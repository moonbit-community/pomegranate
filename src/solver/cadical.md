# CaDiCaL 项目架构与模块优化策略分析（v3.0.0）

本文梳理 CaDiCaL 的基本架构、主要模块及其优化策略，并对每个小节中的优化技术做进一步说明，便于对照源码理解其设计动机与性能权衡。

## 1. 项目与目录结构概览
- **顶层构建与说明**：`configure`、`makefile`/`makefile.in`、`BUILD.md`、`README.md`。
  - 构建脚本提供不同平台/编译选项的切换入口（静态库/命令行程序、可选证明等），与 `src/` 中的条件编译宏对应。
- **核心源码**：`src/`，同时包含库（`libcadical.a`）与命令行求解器实现。
  - `internal.*` 聚合求解核心，其它模块围绕 CDCL、预处理、证明与外部接口扩展。
- **测试**：`test/`（含 API/求解器测试与说明）。
  - 用于接口与回归验证，体现 API 层与内部求解器的可分离性。
- **脚本与工具**：`scripts/`、`contrib/`。
  - 训练/评测/辅助工具集中在这里，服务于调参与回归评测。

## 2. 核心架构（模块分层）
1. **API/前端层**
   - C++ API：`src/cadical.hpp`；C API：`src/ccadical.h`；IPASIR 兼容接口：`src/ipasir.h`。
   - 命令行入口：`src/cadical.cpp`；模型测试器：`src/mobical.cpp`。
   - 解析/格式化：`src/parse.cpp`、`src/format.cpp`、`src/file.cpp`。
   - **优化要点**：接口层尽量薄，主要做参数、格式与 IO 的“胶水”，避免在热路径引入额外开销。
2. **外部接口与扩展**
   - 外部传播器/增量接口：`src/external.hpp`、`src/external.cpp`、`src/external_propagate.cpp`。
   - **优化要点**：外部传播采用“延迟解释（lazy reasons）”，仅在冲突分析或必要时才物化原因子句，降低接口交互成本。
3. **内部求解核心**
   - `Internal` 负责状态、搜索、预处理/内处理（`src/internal.hpp`）。
   - **优化要点**：核心数据结构（watch、occs、arena、stats）集中管理，减少跨模块内存跳转。
4. **证明、检查与监控**
   - DRAT/FRAT/LRAT/IDRUP 等 tracer：`src/*tracer*.cpp`。
   - 检查器：`src/checker.cpp`、`src/lratchecker.cpp`。
   - 日志/统计/资源：`src/logging.cpp`、`src/stats.cpp`、`src/resources.cpp`、`src/profile.cpp`。
   - **优化要点**：追踪/检查可按需启用，避免默认路径额外负担；统计更新经常延迟或批量处理以减少热点开销。

## 3. 关键数据结构与内存/缓存优化
- **Clause（`src/clause.hpp`）**
  - **文字内联存储（flexible array member）**：字面量数组紧贴子句头部存放，避免“子句头部 + 指针 + 额外数组”的二次间接访问；传播热点少一次 cache miss。`Clause::bytes()` 统一做 8 字节对齐，便于连续拷贝与 arena 迁移。
  - **位域状态标记**：`redundant/garbage/reason/...` 等布尔标记使用位域压缩，显著降低单子句元数据体积，提高 watch/occs 扫描时的缓存命中率。
  - **LBD/Glue + 三层策略**：`glue` 代表学习子句的“可传播性”，学习时计算并在后续冲突中更新；使用 tier1/tier2/tier3 阈值（默认 2/6）加上 `used` 计数决定保留/淘汰，低 glue 子句更“粘性”。
- **Arena（`src/arena.hpp`）**
  - **移动式垃圾回收 + 预分配内存**：在 `collect.cpp` 的移动式 GC 中，将幸存子句拷贝到连续 “to 空间”，并可按“被同一文字 watch 的子句相邻”排序以提升传播局部性；通常只增加约 50% 额外内存但显著提升传播吞吐。
  - **可配置分配顺序**：通过 `opts.arenatype` 调整迁移顺序，在局部性与开销之间权衡。
- **Watch 列表（`src/watch.hpp`）**
  - **双 watched literals + blocking literal**：watch 记录“子句指针 + blocking literal + size”，先判 blocking literal 是否满足即可跳过多数子句；size 字段顺带区分二元子句。
  - **二元子句快速识别**：`size==2` 时传播无需解引用子句，仅凭两个文字即可完成传播/冲突检查。
  - **一致性不变式**：实现中尝试维持“被监视文字为假时，blocking literal 为真且层级更低”的不变式，以减少重复扫描。
- **Occurrence 列表（`src/occs.hpp`）**
  - **单 watch 风格连接**：subsume/elim 中只为每个子句连接一个文字，维护成本低；消元阶段主要对不可约子句使用完整 occs。
- **决策队列与评分结构**
  - **VMTF 队列（`src/queue.hpp`）**：双向链表维护决策顺序，变量 bump 时“移到队首”；`queue.unassigned` 记录最后一个未赋值变量，减少寻找下一个决策的扫描成本；`bumped` 时间戳用于重启复用 trail。
  - **EVSIDS 堆（`src/score.cpp` + `src/heap.hpp`）**：堆维护分数，冲突分析 bump 变量并指数衰减；支持 `shuffle`/随机化以打散结构性偏置，提高覆盖度。
- **辅助结构**
  - `radix.hpp`/`range.hpp`/`random.*` 提供轻量排序、区间遍历与可复现随机数，用于多处调度/打散策略，避免热点路径引入复杂 STL 结构。

## 4. CDCL 搜索核心及优化策略
### 4.1 传播与冲突分析
- **传播（`src/propagate.cpp`）**
  - **Lazy 双 watch + blocking literal**：只在必要时移动 watch；多数情况下先检查 blocking literal 是否已满足，从而避免遍历子句文字，显著减少“子句触碰次数”。
  - **二元子句快速路径**：watch 结构记录 `size==2`，传播时只判断另一个文字即可得到传播/冲突，避免解引用子句。
  - **`pos` 位置记忆（Gent’13）**：对子句保存“上次替换 watch 的位置”，下次扫描从该位置起步，降低长子句重复线性扫描的累计二次成本。
  - **预取与延迟统计**：`__builtin_prefetch` 预取 watch；统计在循环结束后统一更新，减少热点循环内的分支与写入。
- **冲突分析（`src/analyze.cpp`）**
  - **First UIP 学习**：沿冲突图回溯到第一个 UIP 生成学习子句，保证非平凡回跳；同时更新子句/变量活动度以匹配近期冲突结构。
  - **EVSIDS 活动度更新**：冲突中出现的变量被 bump，分数随时间指数衰减；与 `scores` 堆耦合，直接影响下一次决策的聚焦程度。
- **子句最小化（`src/minimize.cpp`）**
  - **递归最小化 + poison 标记**：递归尝试移除子句文字，失败路径用 `poison` 标记，避免后续重复尝试；比基于签名的方案更直接。
  - **深度限制与早停**：`opts.minimizedepth` 限制递归深度；结合 Knuth 的“层上只见到一个文字则提前停止”和“最早出现文字过晚”早停策略控制成本。
  - **按 trail 顺序排序**：最小化前根据 trail 位置排序，减少递归深度并提升成功率。

### 4.2 决策与回溯
- **决策（`src/decide.cpp`）**
  - **EVSIDS 与 VMTF 切换**：`use_scores()` 决定使用堆分数或 VMTF 队列；前者聚焦冲突核心，后者提供更稳定的变量顺序。
  - **随机决策序列**：在设定冲突间隔触发 `randec` 序列（长度随次数增长），随机选变量打破结构化陷阱；并限制在浅层决策以避免深层扰动过大。
  - **相位保存与 target/best**：`phases.saved` 记录最近赋值相位；稳定模式下引入 `target/best` 相位（在回溯时更新），帮助保持“有效局部模型”并减少反复翻转。
- **回溯（`src/backtrack.cpp`）**
  - **Chronological backtracking**：允许保留“乱序赋值”的文字（赋值层级低于回溯目标），减少不必要的重新传播；与 `analyze` 中的 chrono 逻辑配合。
  - **更新 target/best**：回溯前调用 `update_target_and_best`，记录最长无冲突 trail 的相位信息，为后续 rephase/决策提供更稳定指引。

### 4.3 重启、缩减与相位重置
- **重启（`src/restart.cpp`）**
  - **Glucose 风格 EMA 触发**：用 fast/slow EMA 跟踪学习子句平均 glue，当 fast 超过 slow×margin 时触发重启；冲突间隔 `opts.restartint` 控制基础频率。
  - **稳定/非稳定模式切换 + reluctant**：`stabilizing()` 通过几何增长阈值在“长稳定期”和“频繁重启期”之间切换；稳定期采用 reluctant doubling 保留少量重启。
  - **Reuse trail**：根据“下一决策变量”的分数/队列位置确定回溯层级，只回溯到“必然会再次决策”的层级，降低重启后的重走成本。
- **子句库缩减（`src/reduce.cpp`）**
  - **按 glue/size 排序 + 分层保留**：候选子句按 glue（优先）与 size 排序，tier1/tier2 用 `used` 计数保护；低 glue 子句更“粘性”，并更新 `lim.keptsize/keptglue` 供 subsume 使用。
  - **“flush” 全量清理**：较少触发但更激进，直接淘汰冗余子句；hyper 产生的小子句通常仅保留一轮。
- **相位重置（`src/rephase.cpp`）**
  - **轮转策略**：按固定顺序在 original / inverted / flipping / random / best / walk 之间切换，避免长期停留在错误相位。
  - **与本地搜索联动**：启用 `walk` 时在 rephase 中触发局部搜索，以寻找更优相位，并写回 `phases.saved`。

### 4.4 其他搜索增强
- **幸运相位（`src/lucky.cpp`）**
  - **快速 SAT 机会探测**：尝试“全正/全负赋值 + 传播”，或按固定顺序赋值并传播；若所有子句都含相应极性文字则可快速判 SAT，否则快速回滚。
- **移动平均（`src/ema.hpp`, `src/averages.hpp`）**
  - **多信号平滑**：对 glue、冲突等统计维护 EMA，减少短期噪声；`swap_averages()` 在稳定/非稳定模式切换时保留不同历史，使重启与调度更平滑。

## 5. 预处理/内处理（Simplification & Inprocessing）

### 5.1 变量消元与等价替换
- **有界变量消元（`src/elim.cpp`）**
  - **SATeLite 风格 BVE**：仅当 resolvent 大小不超过阈值时消元，控制子句爆炸；消元轮次与 subsume/block/cover 交错运行。
  - **增量调度**：只关注“最近因删减而受影响”的变量，occurrence 计数与打分函数驱动优先级，避免全局重扫。
- **门结构识别（`src/gates.cpp`）**
  - **限制解析对**：识别门结构后，只在“门子句 + 非门子句”之间解析；门-门解析通常为重言式或冗余，从源头减少 resolvent 数量。
- **SCC 等价替换（`src/decompose.hpp/.cpp`）**
  - **二元蕴含图 Tarjan 分解**：在 2-SAT 蕴含图上找强连通分量，得到等价文字并替换为代表元；可能进一步导出单位子句。
  - **证明链构建**：替换时为 LRAT/DRAT 构建链，确保可验证。
- **Congruence（`src/congruence.hpp/.cpp`）**
  - **SAT’24 流程**：先处理二元子句，再检测并合并 gates，再按等价链逐步替换，最后做前向 subsume。
  - **lazy/eager 双并查集**：lazy 结构保存全部等价，eager 结构按已传播链逐步合并，既便于证明生成也避免一次性重写成本。

### 5.2 子句级简化
- **前向 subsumption（`src/subsume.cpp`）**
  - **单 watch 连接**：每个候选子句只连接一个出现频次较小的文字，维护成本低；查询时遍历该文字的 occs 列表即可获得潜在 subsuming 子句。
  - **“sticky”子句参与**：除原始子句外，部分高价值学习子句也参与（由 `lim.keptglue/keptsize` 决定），提升删减效果。
- **后向 subsumption（`src/backward.cpp`）**
  - **消元队列内反向检查**：新子句加入时，用其最小 occs 文字反向检查是否可 subsume/strengthen 旧子句，消元阶段效果尤为明显。
- **Vivification（`src/vivify.cpp`）**
  - **ATE/ALE + 传播增强**：将子句文字逐个置为假并传播，若可推出冲突或削弱则删除/缩短子句；比常规 subsume 更强但更昂贵。
  - **排序与“伪 Trie”复用**：按文字出现频次排序子句与文字，复用前一次 vivify 的传播路径，模拟 distillation 效果而无需真实 Trie。
- **Blocked clause elimination（`src/block.cpp`）**
  - **Move-to-front 优化**：对 occs 列表和子句内部文字做 move-to-front，加速找到使 resolvent 为重言式的文字，降低阻塞检测成本。
  - **受控触发**：仅在满足大小阈值、并且对应文字近期发生变化时尝试，避免频繁且昂贵的全局检查。
- **Covered clause elimination（`src/cover.cpp`）**
  - **ALA + CLA 组合**：ALA 步骤用 watch 传播快速扩展，CLA 步骤用 occs 枚举解析候选；若扩展后变为 blocked 或产生冲突则可删子句。
  - **证据构造**：维护 `added/covered/extend` 栈生成 witness，便于证明追踪。
- **二元子句去重（`src/deduplicate.cpp`）**
  - **Watch 扫描去重**：扫描 watch 列表发现完全重复的二元子句并标记为垃圾，避免二元子句“偷偷膨胀”。
  - **Hyper unary resolution**：当发现 `(x ∨ y)` 与 `(x ∨ ¬y)` 时直接推出单位子句 `x`，相当于快速局部推理。

### 5.3 图结构与探测类优化
- **Failed literal probing（`src/probe.cpp`）**
  - **专用传播 + 根节点探测**：仅在二元蕴含图根节点上探测；探测期间可即时生成 hyper binary resolvent。
  - **预算控制**：以 propagation limit 约束成本，未完成的探测根保留到下轮继续。
- **Transitive reduction（`src/transred.cpp`）**
  - **删冗余边**：在二元蕴含图上寻找替代路径以删除冗余二元子句，避免 hyper binary 产生过多衍生子句。
  - **同样受限于预算**：以传播次数上限控制开销，并跳过 hyper 产生的二元子句以防过度重写。
- **Hyper ternary resolution（`src/ternary.cpp`）**
  - **仅由三元产生**：只用三元子句解析生成三元（或二元）子句，避免高阶 resolvent 膨胀。
  - **去重/存在性检查**：通过 occs 检查是否已有同型子句或被二元子句包含，避免重复添加。

### 5.4 Sweeping 与内置子求解器
- **Sweeping（`src/sweep.cpp` + `src/kitten.*`）**
  - **内置轻量 SAT（kitten）**：在 dense 模式下构建完整 occs 结构，调用 `kitten` 做局部求解/翻转/implicant 提取。
  - **Tick limit 控制开销**：通过 ticks 上限限制每轮成本，适合在内处理阶段做“有限但有收益”的结构清理。

### 5.5 本地搜索与 Lookahead
- **Walk（`src/walk.cpp`）**
  - **ProbSAT 风格随机游走**：基于 break value 的概率选择翻转变量，使用 CB 参数表控制偏好；维护“坏子句集合”与局部最优模型。
  - **轻量记忆最佳解**：只记录翻转序列而非全模型，减少内存拷贝成本。
- **Lookahead（`src/lookahead.cpp`）**
  - **基于出现频次挑选候选文字**：预先统计文字出现次数（locc），优先选择出现多且更可能触发冲突的文字。
  - **探测根节点 + probe 列表**：在二元蕴含图根节点上做探测，探测列表可刷新/保留，用于逐步发现强制赋值或冲突。

## 6. 证明、检查与可观测性
- **Proof Tracing**：`src/drattracer.cpp`、`src/frattracer.cpp`、`src/lrattracer.cpp` 等。
  - 将学习/删除子句写入 DRAT/FRAT/LRAT 轨迹，保证 UNSAT 结果可验证；删除通常延迟到“真正释放”时以避免证明不一致。
- **Checker**：`src/checker.cpp`、`src/lratchecker.cpp`。
  - 独立验证证明轨迹，便于调试与评测。
- **日志与统计**：`src/logging.cpp`、`src/stats.cpp`、`src/profile.cpp`。
  - 通过 `LOG/PHASE` 等宏记录关键阶段与耗时，`stats` 维护传播/冲突/重启等指标；`resources` 负责时间/内存限制与资源监控。

## 7. 小结
CaDiCaL 采用分层架构：API/前端 → 内部求解核心 → 证明/检查与监控，并在各层使用针对性的优化：
- **内存与缓存优化**（Clause 内联、Arena 重排、watch/occs 专用结构）；
- **搜索策略优化**（EVSIDS + VMTF、EMA 重启、相位重置、随机化与 trail 复用）；
- **简化与内处理**（有界消元、subsume/vivify、图结构约简、sweep/kitten）；
- **本地搜索与启发式探索**（walk/lookahead/lucky phases）。

这些优化与严格的证明/检查机制共同支撑了 CaDiCaL 作为高性能 CDCL SAT 求解器的稳定性与竞争力。
