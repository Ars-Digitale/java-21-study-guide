# 27. Queue & Deque API

### Table of Contents

- [27. Queue & Deque API](#27-queue--deque-api)
  - [27.1 Queue — Overview](#271-queue--overview)
    - [27.1.1 Queue Core Methods](#2711-queue-core-methods)
    - [27.1.2 Queue Implementations](#2712-queue-implementations)
  - [27.2 Deque — Overview](#272-deque--overview)
    - [27.2.1 Deque Core Methods](#2721-deque-core-methods)
    - [27.2.2 Deque Implementations](#2722-deque-implementations)
  - [27.3 Using a Queue](#273-using-a-queue)
  - [27.4 Using a Deque as-Queue and as-Stack](#274-using-a-deque-as-queue-and-as-stack)
    - [27.4.1 FIFO Example Queue-Behavior](#2741-fifo-example-queue-behavior)
    - [27.4.2 LIFO Example Stack-Behavior](#2742-lifo-example-stack-behavior)
  - [27.5 PriorityQueue — Special Queue](#275-priorityqueue--special-queue)
  - [27.6 Blocking Queues Basics](#276-blocking-queues-basics)
  - [27.7 Common Pitfalls](#277-common-pitfalls)
  - [27.8 Summary Table](#278-summary-table)

---

Java’s `Queue` and `Deque` interfaces model ordered collections designed for processing elements in a particular sequence.

A **Queue** typically models a **FIFO** (First-In, First-Out) structure.  
A **Deque** (“double-ended queue”) allows insertion and removal from both ends, enabling **FIFO** and **LIFO** behavior in a single API.


## 27.1 Queue — Overview

The `Queue` interface extends `Collection` and is commonly used in asynchronous programming, work distribution, algorithms, and buffering.

Two families of methods exist: ones that **throw exceptions** and ones that **return special values** (usually `null`).

### 27.1.1 Queue Core Methods

| Operation | Throws Exception | Returns Special Value | Description |
|----------|------------------|------------------------|-------------|
| Insert   | add(e)          | offer(e)              | Adds an element; offer preferred for bounded queues |
| Remove   | E remove()        | E poll()                | Removes and returns head. remove() throws NoSuchElementException if queue is empty, poll() returns null |
| Read	   | E element()       | E peek()                | Returns head without removing. element() throws NoSuchElementException if queue is empty, peek() returns null |



### 27.1.2 Queue Implementations

Common classes implementing `Queue`:

- `LinkedList` — unbounded, also implements `Deque` and `List`.
- `ArrayDeque` — fast, resizable array-based queue; cannot store `null`.
- `PriorityQueue` — orders elements by natural order or comparator; not FIFO.
- `ConcurrentLinkedQueue` — thread-safe, lock-free.

> [!NOTE]
> `PriorityQueue` does not guarantee traversal order matching priority sorting.

> [!WARNING]
> Most Queue implementations reject null because null is used as a return value for “empty”.


## 27.2 Deque — Overview

`Deque` (double-ended queue) supports insertion, removal, and inspection from both the head and the tail.

It is more versatile than a Queue:  
- FIFO (queue-like)  
- LIFO (stack-like)  
- Bidirectional algorithms

### 27.2.1 Deque Core Methods


| Operation | Front | End |
|----------|-------|-----|
| Insert   | addFirst(e), offerFirst(e) | addLast(e), offerLast(e) |
| Remove   | removeFirst(), pollFirst() | removeLast(), pollLast() |
| Examine  | getFirst(), peekFirst()    | getLast(), peekLast() |



### 27.2.2 Deque Implementations

- `ArrayDeque` — recommended general-purpose implementation (fast, no capacity limit).
- `LinkedList` — full-featured but slower due to node-based structure.
- `ConcurrentLinkedDeque` — non-blocking concurrent deque.

> [!NOTE]
> `Stack` is legacy; use `Deque` for stack behavior (push/pop).
> ArrayDeque, LinkedList queue ops (add/remove/peek) are O(1) amortized


## 27.3 Using a Queue

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


## 27.4 Using a Deque (as Queue and as Stack)

### 27.4.1 FIFO Example (Queue Behavior)

```java
Deque<String> dq = new ArrayDeque<>();

dq.offerLast("A"); // enqueue
dq.offerLast("B");
dq.offerLast("C");

System.out.println(dq.pollFirst()); // A
System.out.println(dq.pollFirst()); // B
System.out.println(dq.pollFirst()); // C
```


### 27.4.2 LIFO Example (Stack Behavior)

```java
Deque<String> stack = new ArrayDeque<>();

stack.push("A");
stack.push("B");
stack.push("C");

System.out.println(stack.pop()); // C
System.out.println(stack.pop()); // B
System.out.println(stack.pop()); // A
```


## 27.5 PriorityQueue — Special Queue

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


## 27.6 Blocking Queues (Basics)

In concurrent environments, the `java.util.concurrent` package provides blocking queue types.

- `ArrayBlockingQueue` — fixed-size backing array.
- `LinkedBlockingQueue` — optionally bounded.
- `PriorityBlockingQueue` — thread-safe priority queue.
- `DelayQueue` — elements released after delays.

> [!NOTE]
> BlockingQueue never allows `null`.
> put(e) — blocks until space available
> take() — blocks until element available
> BlockingQueue also supports timed operations: offer(e, timeout), poll(timeout)


## 27.7 Common Pitfalls

- `Queue` and `Deque` methods come in “exception” and “special-value” variants — memorize which is which.
- `ArrayDeque` cannot store `null` — `null` is used internally.
- `PriorityQueue` iteration order is NOT sorted.
- Using `Stack` is discouraged; use `Deque` instead.
- Deque enables both FIFO and LIFO and has the **most complete** API.


## 27.8 Summary Table


| Interface | Typical Behavior | Null Allowed? | Common Implementations | Notes |
|-----------|------------------|----------------|-------------------------|-------|
| Queue     | FIFO             | Depends        | LinkedList, ArrayDeque, PriorityQueue | PriorityQueue not FIFO |
| Deque     | FIFO + LIFO      | No (ArrayDeque) | ArrayDeque, LinkedList | Full double-ended operations |
| PriorityQueue | Ordered by priority | No | PriorityQueue | Removes smallest element first |
| BlockingQueue | Thread-safe FIFO | No | ArrayBlockingQueue, LinkedBlockingQueue | add/offer vs put differences |
| ConcurrentLinkedQueue | Lock-free FIFO | No | ConcurrentLinkedQueue | Very fast for multi-threading |


