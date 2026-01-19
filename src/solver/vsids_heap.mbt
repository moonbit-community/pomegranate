///|
/// Max-heap keyed by variable activity for VSIDS.
///
/// The heap stores variable ids; `pos` maps var -> heap index (or -1 if absent).
priv struct VsidsHeap {
  heap : Array[Int]
  pos : Array[Int]
  activity : FixedArray[Double]
}

///|
/// Create an empty heap backed by an activity table.
fn VsidsHeap::new(activity : FixedArray[Double]) -> VsidsHeap {
  { heap: [], pos: Array::make(activity.length(), -1), activity }
}

///|
/// Returns true if the heap is empty.
fn VsidsHeap::empty(self : VsidsHeap) -> Bool {
  self.heap.length() == 0
}

///|
/// Returns true if a variable is currently in the heap.
fn VsidsHeap::in_heap(self : VsidsHeap, v : Int) -> Bool {
  v < self.pos.length() && self.pos[v] >= 0
}

///|
/// Grow the `pos` array if needed before inserting a larger variable id.
fn VsidsHeap::ensure_pos(self : VsidsHeap, v : Int) -> Unit {
  if v >= self.pos.length() {
    self.pos.resize(v + 1, -1)
  }
}

///|
/// Compare activities for heap ordering.
fn VsidsHeap::higher(self : VsidsHeap, a : Int, b : Int) -> Bool {
  self.activity[a] > self.activity[b]
}

///|
/// Bubble up an element to restore heap order.
fn VsidsHeap::up(self : VsidsHeap, idx : Int) -> Unit {
  let x = self.heap[idx]
  let mut i = idx
  while i > 0 {
    let p = (i - 1) / 2
    if not(self.higher(x, self.heap[p])) {
      break
    }
    self.heap[i] = self.heap[p]
    self.pos[self.heap[i]] = i
    i = p
  }
  self.heap[i] = x
  self.pos[x] = i
}

///|
/// Bubble down an element to restore heap order.
fn VsidsHeap::down(self : VsidsHeap, idx : Int) -> Unit {
  let x = self.heap[idx]
  let mut i = idx
  let mut left = i * 2 + 1
  while left < self.heap.length() {
    let right = left + 1
    let mut child = left
    if right < self.heap.length() &&
      self.higher(self.heap[right], self.heap[left]) {
      child = right
    }
    if not(self.higher(self.heap[child], x)) {
      break
    }
    self.heap[i] = self.heap[child]
    self.pos[self.heap[i]] = i
    i = child
    left = i * 2 + 1
  }
  self.heap[i] = x
  self.pos[x] = i
}

///|
/// Insert a variable if it is not already in the heap.
fn VsidsHeap::insert(self : VsidsHeap, v : Int) -> Unit {
  self.ensure_pos(v)
  if self.pos[v] >= 0 {
    return
  }
  let idx = self.heap.length()
  self.heap.push(v)
  self.pos[v] = idx
  self.up(idx)
}

///|
/// Update an existing variable's position after its activity increased.
fn VsidsHeap::update(self : VsidsHeap, v : Int) -> Unit {
  if self.pos[v] >= 0 {
    self.up(self.pos[v])
  }
}

///|
/// Pop the highest-activity variable from the heap.
fn VsidsHeap::pop(self : VsidsHeap) -> Int {
  let x = self.heap[0]
  let last = match self.heap.pop() {
    Some(v) => v
    None => panic()
  }
  if self.heap.length() == 0 {
    self.pos[last] = -1
    return last
  }
  self.heap[0] = last
  self.pos[last] = 0
  self.pos[x] = -1
  if self.heap.length() > 1 {
    self.down(0)
  }
  x
}
