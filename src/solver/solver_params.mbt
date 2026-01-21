///|
/// Heuristic parameters for the CDCL solver.

///|
/// Size of the rolling LBD window used to warm up EMA statistics.
const LBD_QUEUE_LEN : Int = 50

///|
/// Cap applied to LBD values when updating the slow average.
const LBD_CAP : Int = 50

///|
/// Minimum LBD sample count before LBD-based restart checks run.
const LBD_READY_MIN_QUEUE : Int = 30

///|
/// Minimum conflict count before LBD-based restart checks run.
const LBD_READY_MIN_CONFLICTS : Int = 30

///|
/// EMA smoothing factor for the fast LBD signal.
const LBD_FAST_EMA_ALPHA : Double = 0.10

///|
/// EMA smoothing factor for the slow LBD signal.
const LBD_SLOW_EMA_ALPHA : Double = 0.01

///|
/// Margin above the slow EMA that triggers a restart.
const LBD_EMA_MARGIN : Double = 0.08

///|
/// Variable-count divisor used in the base restart budget.
const RESTART_BASE_VAR_DIV : Int = 1500

///|
/// Minimum base restart budget from variable count.
const RESTART_BASE_VAR_MIN : Int = 12

///|
/// Maximum base restart budget from variable count.
const RESTART_BASE_VAR_MAX : Int = 48

///|
/// Clause-count divisor used in the base restart budget.
const RESTART_BASE_CLAUSE_DIV : Int = 7000

///|
/// Minimum base restart budget from clause count.
const RESTART_BASE_CLAUSE_MIN : Int = 12

///|
/// Maximum base restart budget from clause count.
const RESTART_BASE_CLAUSE_MAX : Int = 48

///|
/// Variable-count divisor used in the base rephase budget.
const REPHASE_BASE_VAR_DIV : Int = 1500

///|
/// Minimum base rephase budget from variable count.
const REPHASE_BASE_VAR_MIN : Int = 24

///|
/// Maximum base rephase budget from variable count.
const REPHASE_BASE_VAR_MAX : Int = 100

///|
/// Clause-count divisor used in the base rephase budget.
const REPHASE_BASE_CLAUSE_DIV : Int = 8000

///|
/// Minimum base rephase budget from clause count.
const REPHASE_BASE_CLAUSE_MIN : Int = 24

///|
/// Maximum base rephase budget from clause count.
const REPHASE_BASE_CLAUSE_MAX : Int = 100

///|
/// Increment applied to the rephase limit after each rephase.
const REPHASE_LIMIT_STEP : Int = 80

///|
/// Increment applied to the reduction limit after each reduction.
const REDUCE_LIMIT_STEP : Int = 200

///|
/// Minimum learned clause count required before reducing the database.
const REDUCE_LIMIT_MIN : Int = 150

///|
/// Maximum learned clause count required before reducing the database.
const REDUCE_LIMIT_MAX : Int = 500

///|
/// Clause-count divisor used to set the initial reduction limit.
const REDUCE_LIMIT_DIV : Int = 1200

///|
/// Depth threshold to enable shallow random decisions.
const DECIDE_SHALLOW_RANDOM_DEPTH : Int = 12

///|
/// Percent chance of random decision at shallow depth.
const DECIDE_SHALLOW_RANDOM_PCT : Int = 5

///|
/// Number of VSIDS heap samples when making a noisy random decision.
const DECIDE_RANDOM_SAMPLE_COUNT : Int = 10

///|
/// Depth threshold to enable mid-depth random decisions.
const DECIDE_MID_RANDOM_DEPTH : Int = 25

///|
/// Percent chance of random decision at mid depth.
const DECIDE_MID_RANDOM_PCT : Int = 4

///|
/// Depth threshold to enable deep random decisions.
const DECIDE_DEEP_RANDOM_DEPTH : Int = 50

///|
/// Percent chance of random decision at deep depth.
const DECIDE_DEEP_RANDOM_PCT : Int = 8

///|
/// Deepest depth threshold for overriding saved phases.
const PHASE_OVERRIDE_DEPTH_1 : Int = 70

///|
/// Override percent at the deepest depth threshold.
const PHASE_OVERRIDE_PCT_1 : Int = 65

///|
/// Middle depth threshold for overriding saved phases.
const PHASE_OVERRIDE_DEPTH_2 : Int = 35

///|
/// Override percent at the middle depth threshold.
const PHASE_OVERRIDE_PCT_2 : Int = 45

///|
/// Shallow depth threshold for overriding saved phases.
const PHASE_OVERRIDE_DEPTH_3 : Int = 15

///|
/// Override percent at the shallow depth threshold.
const PHASE_OVERRIDE_PCT_3 : Int = 30

///|
/// Base override percent at very shallow depth.
const PHASE_OVERRIDE_PCT_BASE : Int = 15

///|
/// Percent chance to use local-best phase even when a saved phase exists.
const PHASE_BEST_PCT : Int = 10

///|
/// Percent chance to flip a non-saved phase decision.
const PHASE_FLIP_PCT : Int = 10

///|
/// Only flip phase when the variable has low activity (relative to var_inc).
const PHASE_FLIP_ACTIVITY_MULT : Double = 2.0

///|
/// Percent chance a restart is a full restart (no kept levels).
const RESTART_FULL_PCT : Int = 40

///|
/// Number of decision levels to keep on partial restarts.
const RESTART_KEEP_WINDOW : Int = 4

///|
/// Percent chance to copy local-best phases on restart.
const RESTART_PHASE_LOCAL_BEST_PCT : Int = 50

///|
/// Percent chance to invert local-best phases on restart.
const RESTART_PHASE_INVERT_BEST_PCT : Int = 10

///|
/// Percent chance to randomize phases on restart.
const RESTART_PHASE_RANDOM_PCT : Int = 25

///|
/// Numerator for local-best threshold decay.
const LOCAL_BEST_THRESHOLD_NUM : Int = 8

///|
/// Denominator for local-best threshold decay.
const LOCAL_BEST_THRESHOLD_DEN : Int = 10

///|
/// VSIDS activity decay factor applied on restart.
const ACTIVITY_DECAY_RESTART : Double = 0.75

///|
/// VSIDS activity decay factor applied on rephase.
const ACTIVITY_DECAY_REPHASE : Double = 0.4

///|
/// Skip decay when the factor is at or above this value.
const ACTIVITY_DECAY_SKIP : Double = 0.999

///|
/// Factor used to increase VSIDS increment (var_inc /= VAR_INC_DECAY).
const VAR_INC_DECAY : Double = 0.98

///|
/// Activity value threshold that triggers a rescale.
const VSIDS_RESCALE_LIMIT : Double = 1.0e100

///|
/// Activity rescale multiplier for VSIDS values and var_inc.
const VSIDS_RESCALE_FACTOR : Double = 1.0e-100

///|
/// VSIDS bump multiplier for literals seen during resolution.
const VSIDS_BUMP_RESOLVE_MULT : Double = 0.5

///|
/// VSIDS bump multiplier for low-LBD learned clauses.
const VSIDS_BUMP_LBD_MULT : Double = 0.4

///|
/// VSIDS bump multiplier for variables near the backtrack level.
const VSIDS_BUMP_BACKTRACK_MULT : Double = 1.0

///|
/// Decision level threshold used to detect deep-stuck searches.
const DEEP_STUCK_LEVEL : Int = 70

///|
/// Divisor applied to restart_limit to detect deep-stuck conflicts.
const DEEP_STUCK_CONFLICTS_DIV : Int = 3

///|
/// Divisor applied to rephase_limit when restart is ready.
const REPHASE_SOON_DIV : Int = 2

///|
/// LBD threshold for the extra low-LBD VSIDS bump.
const LEARNED_STRONG_LBD_MAX : Int = 3

///|
/// Window below the backtrack level that gets a strong VSIDS bump.
const BACKTRACK_BUMP_WINDOW : Int = 2

///|
/// Max learned clause length kept unconditionally during reduction.
const LEARNED_KEEP_LEN_MAX : Int = 3

///|
/// Max LBD kept unconditionally during reduction (core clauses).
const LEARNED_KEEP_LBD_CORE_MAX : Int = 2

///|
/// Max LBD kept with light usage filtering (tier-2 clauses).
const LEARNED_KEEP_LBD_TIER_MAX : Int = 6

///|
/// Minimum usage count kept unconditionally during reduction.
const LEARNED_KEEP_USED_MIN : Int = 3

///|
/// Fraction of removable learned clauses to drop during reduction.
const LEARNED_DROP_RATIO_NUM : Int = 3

///|
/// Fraction of removable learned clauses to drop during reduction.
const LEARNED_DROP_RATIO_DEN : Int = 4

///|
/// Minimum learned clause length to trigger a second minimization pass.
const LEARNED_MINIMIZE_SECOND_PASS_MIN_LEN : Int = 6

///|
/// Minimum LBD to consider dynamic LBD tightening on use.
const LEARNED_LBD_UPDATE_MIN : Int = 3

///|
/// Max learned clause length to consider for dynamic LBD tightening.
const LEARNED_LBD_UPDATE_MAX_LEN : Int = 64

///|
/// Divisor used to decay learned-clause usage counters.
const LEARNED_USED_DECAY_DIV : Int = 2
