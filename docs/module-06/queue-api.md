# Queue & Deque API

Java’s `Queue` and `Deque` interfaces model ordered collections designed for processing elements in a particular sequence.

A **Queue** typically models a **FIFO** (First-In, First-Out) structure.  
A **Deque** (“double-ended queue”) allows insertion and removal from both ends, enabling **FIFO** and **LIFO** behavior in a single API.


## 5.1 Queue — Overview

The `Queue` interface extends `Collection` and is commonly used in asynchronous programming, work distribution, algorithms, and buffering.

Two families of methods exist: ones that **throw exceptions** and ones that **return special values** (usually `null`).

### 5.1.1 Queue Core Methods

| Operation | Throws Exception | Returns Special Value | Description |
|----------|------------------|------------------------|-------------|
| Insert   | add(e)          | offer(e)              | Adds an element; offer preferred for bounded queues |
| Remove   | remove()        | poll()                | Removes and returns head |
| Examine  | element()       | peek()                | Returns head without removing |



### 5.1.2 Queue Implementations

Common classes implementing `Queue`:

- `LinkedList` — unbounded, also implements `Deque` and `List`.
- `ArrayDeque` — fast, resizable array-based queue; cannot store `null`.
- `PriorityQueue` — orders elements by natural order or comparator; not FIFO.
- `ConcurrentLinkedQueue` — thread-safe, lock-free.

> **Note:** For certification, remember: `PriorityQueue` does not guarantee traversal order matching priority sorting.


## 5.2 Deque — Overview

`Deque` (double-ended queue) supports insertion, removal, and inspection from both the head and the tail.

It is more versatile than a Queue:  
- FIFO (queue-like)  
- LIFO (stack-like)  
- Bidirectional algorithms

### 5.2.1 Deque Core Methods


| Operation | Front | End |
|----------|-------|-----|
| Insert   | addFirst(e), offerFirst(e) | addLast(e), offerLast(e) |
| Remove   | removeFirst(), pollFirst() | removeLast(), pollLast() |
| Examine  | getFirst(), peekFirst()    | getLast(), peekLast() |



### 5.2.2 Deque Implementations

- `ArrayDeque` — recommended general-purpose implementation (fast, no capacity limit).
- `LinkedList` — full-featured but slower due to node-based structure.
- `ConcurrentLinkedDeque` — non-blocking concurrent deque.

> **Note:** `Stack` is legacy; use `Deque` for stack behavior (push/pop).


## 5.3 Using a Queue

```java
Queue<String> q = new LinkedList<>();

q.offer("A");
q.offer("B");
q.offer("C");

System.out.println(q.peek());   // A
System.out.println(q.poll());   // A
System.out.println(q.poll());   // B
System.out.println(q.poll());   // C
System.out.println(q.poll());   // null (empty queue)
```


## 5.4 Using a Deque (as Queue and as Stack)

### 5.4.1 FIFO Example (Queue Behavior)

```java
Deque<String> dq = new ArrayDeque<>();

dq.offerLast("A"); // enqueue
dq.offerLast("B");
dq.offerLast("C");

System.out.println(dq.pollFirst()); // A
System.out.println(dq.pollFirst()); // B
System.out.println(dq.pollFirst()); // C
```


### 5.4.2 LIFO Example (Stack Behavior)

```java
Deque<String> stack = new ArrayDeque<>();

stack.push("A");
stack.push("B");
stack.push("C");

System.out.println(stack.pop()); // C
System.out.println(stack.pop()); // B
System.out.println(stack.pop()); // A
```


## 5.5 PriorityQueue — Special Queue

`PriorityQueue` orders elements by **natural order** or by a provided `Comparator`.

Important characteristics:

- Not FIFO — head is the “smallest” element.
- Order is only guaranteed during removal, not iteration.
- Null elements not permitted.

```java
PriorityQueue<Integer> pq = new PriorityQueue<>();

pq.offer(50);
pq.offer(10);
pq.offer(30);

System.out.println(pq.poll()); // 10
System.out.println(pq.poll()); // 30
System.out.println(pq.poll()); // 50
```


## 5.6 Blocking Queues (Certification Basics)

In concurrent environments, the `java.util.concurrent` package provides blocking queue types.

- `ArrayBlockingQueue` — fixed-size backing array.
- `LinkedBlockingQueue` — optionally bounded.
- `PriorityBlockingQueue` — thread-safe priority queue.
- `DelayQueue` — elements released after delays.

> **Note:** BlockingQueue never allows `null`.


## 5.7 Certification Pitfalls

- `Queue` and `Deque` methods come in “exception” and “special-value” variants — memorize which is which.
- `ArrayDeque` cannot store `null` — `null` is used internally.
- `PriorityQueue` iteration order is NOT sorted.
- Using `Stack` is discouraged; use `Deque` instead.
- Deque enables both FIFO and LIFO and has the **most complete** API.


## 5.8 Summary Table


| Interface | Typical Behavior | Null Allowed? | Common Implementations | Notes |
|-----------|------------------|----------------|-------------------------|-------|
| Queue     | FIFO             | Depends        | LinkedList, ArrayDeque, PriorityQueue | PriorityQueue not FIFO |
| Deque     | FIFO + LIFO      | No (ArrayDeque) | ArrayDeque, LinkedList | Full double-ended operations |
| PriorityQueue | Ordered by priority | No | PriorityQueue | Removes smallest element first |
| BlockingQueue | Thread-safe FIFO | No | ArrayBlockingQueue, LinkedBlockingQueue | add/offer vs put differences |
| ConcurrentLinkedQueue | Lock-free FIFO | No | ConcurrentLinkedQueue | Very fast for multi-threading |


