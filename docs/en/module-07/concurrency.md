# 31. Java Concurrency APIs

### Table of Contents

- [31. Java Concurrency APIs](#31-java-concurrency-apis)
  - [31.1 Goals and Scope of the Concurrency API](#311-goals-and-scope-of-the-concurrency-api)
  - [31.2 Fundamental Threading Problems](#312-fundamental-threading-problems)
    - [31.2.1 Race Conditions](#3121-race-conditions)
    - [31.2.2 Deadlock](#3122-deadlock)
    - [31.2.3 Starvation](#3123-starvation)
    - [31.2.4 Livelock](#3124-livelock)
  - [31.3 From Threads to Tasks](#313-from-threads-to-tasks)
  - [31.4 Executor Framework](#314-executor-framework)
    - [31.4.1 Submitting Tasks and Futures](#3141-submitting-tasks-and-futures)
    - [31.4.2 Callable vs Runnable](#3142-callable-vs-runnable)
  - [31.5 Thread Pools and Scheduling](#315-thread-pools-and-scheduling)
  - [31.6 Executor Lifecycle and Termination](#316-executor-lifecycle-and-termination)
  - [31.7 Thread Safety Strategies](#317-thread-safety-strategies)
    - [31.7.1 Synchronization](#3171-synchronization)
    - [31.7.2 Atomic Variables](#3172-atomic-variables)
      - [31.7.2.1 Atomic classes](#31721-atomic-classes)
      - [31.7.2.2 Atomic methods](#31722-atomic-methods)
    - [31.7.3 Lock Framework](#3173-lock-framework)
      - [31.7.3.1 Lock implementations](#31731-lock-implementations)
      - [31.7.3.2 Common Lock methods](#31732-common-lock-methods)
    - [31.7.4 Coordination Utilities](#3174-coordination-utilities)
  - [31.8 Concurrent Collections](#318-concurrent-collections)
  - [31.9 Parallel Streams](#319-parallel-streams)
  - [31.10 Relation to Virtual Threads](#3110-relation-to-virtual-threads)
  - [31.11 Summary](#3111-summary)

---

This chapter introduces the **Java Concurrency API**, which provides high-level abstractions for managing concurrent execution safely, efficiently, and scalably.<br>
Unlike low-level thread manipulation, the Concurrency API focuses on **tasks**, **executors**, and **coordination mechanisms**, allowing developers to reason about what should be done rather than how threads are scheduled.

## 31.1 Goals and Scope of the Concurrency API

The `Java Concurrency API`, primarily located in the `java.util.concurrent` package, was introduced to address fundamental problems inherent in manual thread management.

- Decouple task submission from thread management.
- Reduce error-prone low-level synchronization.
- Improve scalability and performance on multi-core systems.
- Provide structured mechanisms for coordination, cancellation, and shutdown.

The API does not eliminate concurrency problems but provides disciplined tools to manage them safely and predictably. 

Instead of explicitly creating and controlling threads, developers submit tasks and let the framework manage **thread allocation, reuse, and synchronization**.


```java
ExecutorService executor = Executors.newSingleThreadExecutor();
executor.execute(() -> System.out.println("Task executed"));
executor.shutdown();
```

## 31.2 Fundamental Threading Problems

Before understanding the Concurrency API, it is essential to understand the concurrency problems it is designed to mitigate. 

These problems arise from shared mutable state, scheduling unpredictability, and improper coordination.

### 31.2.1 Race Conditions

A **race condition** occurs when multiple threads access shared mutable state and the program’s correctness depends on the timing or interleaving of their execution.

- Caused by unsynchronized access to shared data.
- Leads to inconsistent or incorrect program state.

```java
class Counter {
    int count = 0;
    void increment() {
	   count++;
    }
}
```

If multiple threads invoke `increment()` concurrently, increments may be lost because the operation is not atomic.

### 31.2.2 Deadlock

A **deadlock** occurs when two or more threads are permanently blocked, each waiting for a resource held by another thread.

- Typically caused by circular lock dependencies.
- No thread involved can make progress.

```java
synchronized (lockA) {
    synchronized (lockB) {
    }
}
```

If another thread acquires `lockB` first and then waits for `lockA`, a deadlock may occur.

> [!NOTE]
> Real-world deadlocks typically involve multiple locks and order inversion.


### 31.2.3 Starvation

**Starvation** happens when a thread is indefinitely denied access to resources, even though those resources are available.

- Often caused by unfair locking or scheduling policies.
- Thread remains runnable but never executes.

```java
ReentrantLock lock = new ReentrantLock(false); // unfair lock
```

Threads may repeatedly acquire the lock while others wait indefinitely.

### 31.2.4 Livelock

In a **livelock**, threads are not blocked but continuously react to each other in a way that prevents progress.

- Threads remain active but ineffective.
- Often caused by aggressive retry or avoidance logic.

```java
while (!tryLock()) {
    Thread.sleep(10);
}
```

Both threads may repeatedly retry, preventing forward progress.

## 31.3 From Threads to Tasks

The Concurrency API shifts the programming model from managing **threads** directly to submitting **tasks**. 

A **task** represents a logical unit of work independent of the thread that executes it.

- **Runnable**: Represents a task that does not return a result.
- **Callable**: Represents a task that returns a result and may throw checked exceptions.

```java
Runnable task = () -> System.out.println("Runnable task");
Callable<Integer> callable = () -> 42;
```

This abstraction allows tasks to be reused, scheduled flexibly, and executed by different execution strategies.

## 31.4 Executor Framework

The **Executor Framework** is the core of the Concurrency API. 

It manages thread creation, reuse, and task execution behind a simple interface.

- **Executor**: Basic interface for executing tasks.
- **ExecutorService**: Extends Executor with lifecycle control and result handling.
- **ScheduledExecutorService**: Supports delayed and periodic task execution.

```java
ExecutorService executor = Executors.newFixedThreadPool(2);
executor.execute(() -> System.out.println("Task 1"));
executor.execute(() -> System.out.println("Task 2"));
executor.shutdown();
```

### 31.4.1 Submitting Tasks and Futures

Tasks submitted using `execute()` return `void: it is a "fire-and-forget" method which does not give back any information about the result of the task.

Tasks submitted using `submit()` return a **Future**, which represents the result of an asynchronous computation.

Both methods are used to submit work for asynchronous execution.

```java
Future<Integer> future = executor.submit(() -> 10 + 20);
Integer result = future.get();
```

| Method                                      | Description |
|---------------------------------------------|-------------|
| void **execute(Runnable task)**                  | Executes a task asynchronously with no return value and no `Future`. |
| Future<?> **submit(Runnable task)**              | Executes a task asynchronously; no result is produced (`Future.get()` returns `null`). |
| <T> Future<T> **submit(Callable<T> task)**       | Executes a task asynchronously and returns a result of type `T`. |
| <T> List<Future<T>> **invokeAll(Collection<? extends Callable<T>> tasks)** | Executes all tasks and returns a `Future` for each, after all complete. |
| <T> T **invokeAny(Collection<? extends Callable<T>> tasks)** | Executes tasks and returns the result of one that completes successfully; others are cancelled. |



| Method                                   | Description |
|------------------------------------------|-------------|
| boolean **isDone()**                          | Returns `true` if the task has completed (normally, exceptionally, or via cancellation). |
| boolean **isCancelled()**                    | Returns `true` if the task was cancelled before normal completion. |
| boolean **cancel(boolean mayInterruptIfRunning)** | Attempts to cancel execution. If `true`, interrupts the running thread if possible. |
| T **get()**                                  | Blocks until completion and returns the result, or throws an exception if failed or cancelled. |
| T **get(long timeout, TimeUnit unit)**        | Blocks up to the given timeout and returns the result, or throws `TimeoutException` if not completed. |


> [!WARNING]
> `execute()` will drop exceptions silently unless handled inside the task.


### 31.4.2 Callable vs Runnable

Both interfaces represent tasks, but with different capabilities.

- Runnable: No return value, cannot throw checked exceptions.
- Callable: Returns a value and supports checked exceptions.

```java
Callable<String> c = () -> "done";
Runnable r = () -> System.out.println("done");
```

For result-oriented asynchronous computation, `Callable` is generally preferred.

## 31.5 Thread Pools and Scheduling

Executors manage **thread pools**, which reuse a fixed or dynamic number of threads to execute tasks efficiently.

- **Fixed thread pool**: Limits concurrency to a fixed number of threads.
- **Cached thread pool**: Dynamically grows and shrinks based on demand: creates new threads as needed but reuses available threads.
- **Single-thread executor**: Ensures sequential task execution.
- **Scheduled executor**: Supports delayed and periodic tasks.

```java
ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

scheduler.schedule(
	() -> System.out.println("Delayed"),
	2, TimeUnit.SECONDS);
```

> [!IMPORTANT]
> Never create threads manually in a loop:
> use pools or virtual threads instead.


## 31.6 Executor Lifecycle and Termination

Executors must be shut down explicitly to release resources and allow JVM termination.

- **shutdown()**: Initiates orderly shutdown: completes waiting tasks but doesn't accept additionals ones.
- **close()**: (Java 19+) calls shutdown() and waits for tasks to finish, behaving like try-with-resources support for ExecutorService.
- **shutdownNow()**: Attempts immediate shutdown and interrupts running tasks.
- **awaitTermination()**: Waits for completion or timeout.

```java
executor.shutdown();
executor.awaitTermination(5, TimeUnit.SECONDS);
```

## 31.7 Thread Safety Strategies

The Concurrency API provides multiple complementary strategies for achieving thread safety.

### 31.7.1 Synchronization

Synchronization enforces mutual exclusion and memory visibility by using an intrinsic lock (monitor) associated with an object or a class.

```java
synchronized void increment() {
    count++;
}
```

When a thread enters a synchronized method:

- It **acquires the intrinsic lock** of the target object (`this` for instance methods).
- Only one thread at a time can hold the same lock, preventing concurrent execution.
- When the method exits, the lock is released automatically.

Synchronization establishes a **happens-before relationship** in the Java Memory Model:

- All writes made inside the synchronized region are flushed to main memory when the lock is released.
- A thread acquiring the same lock later is guaranteed to see those updates.

The synchronized keyword can be applied to:

- **Instance methods** (lock on `this`)
- **Static methods** (lock on the `Class` object)
- **Blocks** (lock on a specific object, allowing finer-grained control)


> [!IMPORTANT]
> Synchronization is simple but may hurt scalability under contention.


### 31.7.2 Atomic Variables

Atomic classes provide lock-free, thread-safe operations implemented using low-level CPU primitives such as Compare-And-Swap (CAS).

```java
AtomicInteger count = new AtomicInteger();
count.incrementAndGet();
```

#### 31.7.2.1 Atomic classes

| Atomic Class            | Description |
|-------------------------|-------------|
| **AtomicBoolean**           | Atomically updates and reads a `boolean` value. |
| **AtomicInteger**           | Atomically updates and reads an `int` value. |
| **AtomicLong**              | Atomically updates and reads a `long` value. |
| **AtomicReference<T>**      | Atomically updates and reads an object reference. |
| **AtomicIntegerArray**      | Provides atomic operations on elements of an `int` array. |
| **AtomicLongArray**         | Provides atomic operations on elements of a `long` array. |
| **AtomicReferenceArray<T>** | Provides atomic operations on elements of a reference array. |
| **AtomicStampedReference<T>** | Atomically updates a reference with an integer stamp to avoid ABA problems. |
| **AtomicMarkableReference<T>** | Atomically updates a reference with a boolean mark. |

#### 31.7.2.2 Atomic methods

| Method | Description |
|--------|-------------|
| **get()** | Returns the current value with volatile-read semantics. |
| **set(value)** | Sets the value with volatile-write semantics. |
| **lazySet(value)** | Eventually sets the value with weaker ordering guarantees. |
| **compareAndSet(expect, update)** | Atomically sets the value if the current value equals the expected value. |
| **getAndSet(value)** | Atomically sets the value and returns the previous value. |
| **incrementAndGet()** | Atomically increments the value and returns the updated result. |
| **getAndIncrement()** | Atomically increments the value and returns the previous result. |
| **decrementAndGet()** | Atomically decrements the value and returns the updated result. |
| **getAndDecrement()** | Atomically decrements the value and returns the previous result. |
| **addAndGet(delta)** | Atomically adds the given delta and returns the updated result. |
| **getAndAdd(delta)** | Atomically adds the given delta and returns the previous result. |


Atomic variables:

- Perform single operations **atomically**
- Provide **memory visibility guarantees** similar to `volatile`
- Avoid thread blocking, making them highly scalable under contention

However, atomic variables only guarantee atomicity for **individual operations**.
Composing multiple operations still requires external synchronization.

Atomic variables are typically used for:

- Counters and sequence generators
- Flags and state indicators
- High-throughput, low-latency updates

### 31.7.3 Lock Framework

The java.util.concurrent.locks package provides explicit locking mechanisms that offer greater flexibility and control than synchronized.

```java
ReentrantLock lock = new ReentrantLock();
lock.lock();
try {
    // critical section
} finally {
    lock.unlock();
}
```

Key characteristics of the Lock framework:

- Locks must be explicitly acquired and released
- Lock acquisition can be interruptible or time-bounded
- Locks may be configured with fairness policies (parameter) when ordering is required (when you need to control the order in which threads run)
- Multiple Condition objects can be associated with a single lock

#### 31.7.3.1 Lock implementations

| Lock Implementation | Description |
|---------------------|-------------|
| **Lock**                | Core interface defining explicit lock operations. |
| **ReentrantLock**       | Reentrant mutual exclusion lock with optional fairness policy. |
| **ReadWriteLock**       | Interface defining separate read and write locks. |
| **ReentrantReadWriteLock** | Provides separate reentrant read and write locks to improve read scalability. |
| **StampedLock**         | Lock supporting optimistic, read, and write locking modes (non-reentrant). |

> [!WARNING]
> Unlike other locks, StampedLock is **not reentrant** — 
> re-acquiring it from the same thread causes deadlock.


#### 31.7.3.2 Common Lock methods

| Method | Description |
|--------|-------------|
| **lock()** | Acquires the lock, blocking indefinitely until available. |
| **unlock()** | Releases the lock; must be called by the owning thread. |
| **tryLock()** | Attempts to acquire the lock immediately without blocking: returns boolean indicating if lock has been succesfully acquired |
| **tryLock(long, TimeUnit)** | Attempts to acquire the lock within the given timeout. |
| **lockInterruptibly()** | Acquires the lock unless the thread is interrupted. |
| **newCondition()** | Creates a `Condition` instance for fine-grained thread coordination. |


Unlike synchronized, locks do not release automatically, making proper try/finally usage essential to avoid deadlocks.

### 31.7.4 Coordination Utilities

Coordination utilities allow threads to coordinate execution phases without protecting shared data via mutual exclusion.

Other coordination primitives include:
- CountDownLatch
- Semaphore
- Phaser


```java
import java.util.concurrent.CyclicBarrier;

public class BarrierExample {

    private static final int THREAD_COUNT = 3;

    public static void main(String[] args) {

        CyclicBarrier barrier = new CyclicBarrier(
            THREAD_COUNT,
            () -> System.out.println("All threads reached the barrier. Proceeding...")
        );

        Runnable task = () -> {
            String name = Thread.currentThread().getName();
            try {
                System.out.println(name + " performing initial work");
                Thread.sleep((long) (Math.random() * 2000));

                // Wait for other threads
                System.out.println(name + " waiting at barrier");
                barrier.await();

                // Executed only after all threads reach the barrier
                System.out.println(name + " performing next phase");

            } catch (Exception e) {
                e.printStackTrace();
            }
        };

        for (int i = 1; i <= THREAD_COUNT; i++) {
            new Thread(task, "Worker-" + i).start();
        }
    }
}
```

Sample Output:

```bash
Worker-1 performing initial work
Worker-2 performing initial work
Worker-3 performing initial work
Worker-3 waiting at barrier
Worker-1 waiting at barrier
Worker-2 waiting at barrier
All threads reached the barrier. Proceeding...
Worker-3 performing next phase
Worker-1 performing next phase
Worker-2 performing next phase
```

A CyclicBarrier:

- Blocks threads until a predefined number of threads reach the barrier
- Releases all waiting threads simultaneously once the barrier is tripped
- Can be reused for multiple coordination cycles

These utilities focus on execution ordering and synchronization, not data protection.


## 31.8 Concurrent Collections

Concurrent collections are **thread-safe data structures** designed to support **high levels of concurrency** without requiring external synchronization.

Unlike synchronized wrappers (e.g. `Collections.synchronizedMap`), concurrent collections:
- Use **fine-grained locking** or **lock-free techniques**
- Allow multiple threads to access and modify the collection simultaneously
- Scale better under contention

Common examples include:

- **ConcurrentHashMap**  
  A high-performance concurrent map that allows concurrent reads and updates by partitioning internal state and minimizing lock contention.

- **CopyOnWriteArrayList**  
  A thread-safe list optimized for scenarios with **many reads and few writes**. Write operations create a new internal array, allowing reads to proceed without locking.

- **BlockingQueue**  
  A queue designed for **producer-consumer patterns**, where threads can block while waiting for elements or available capacity.

```java
BlockingQueue<String> queue = new LinkedBlockingQueue<>();
queue.put("item");   // blocks if the queue is full
queue.take();        // blocks if the queue is empty
```

Blocking queues handle synchronization internally, simplifying coordination between producer and consumer threads.

> [!CAUTION]
> CopyOnWrite collections are memory-expensive; avoid in write-heavy workloads.



## 31.9 Parallel Streams

Parallel streams provide **declarative data parallelism**, allowing stream operations to be executed concurrently across multiple threads with minimal code changes.

Key characteristics:
- Activated via `parallelStream()` or `stream().parallel()`
- Internally executed using the **common ForkJoinPool**
- Automatically splits data into chunks processed in parallel

Parallel streams work best when:
- Operations are **CPU-bound**
- Functions are **stateless and non-blocking**
- The data source is large enough to amortize parallelization overhead

```java
list.parallelStream()
    .map(x -> x * x)
    .forEach(System.out::println);
```

Because execution order is not guaranteed, parallel streams should avoid:
- Shared mutable state
- Blocking I/O
- Order-dependent side effects

> [!NOTE]
> Use `forEachOrdered()` if deterministic output is required.


## 31.10 Relation to Virtual Threads

In Java 21, the Executor framework integrates seamlessly with **virtual threads**, enabling massive concurrency with minimal resource usage.

```java
ExecutorService executor =
Executors.newVirtualThreadPerTaskExecutor();

executor.submit(() -> blockingIO());
executor.close();
```

This allows blocking code to scale efficiently without redesigning APIs.

## 31.11 Summary

- The `Java Concurrency API` provides a robust, scalable, and safer alternative to manual thread management. 
- By abstracting execution, coordinating tasks, and offering thread-safe utilities, it enables developers to build concurrent systems that are both performant and maintainable.
- Choose the right tool: synchronized → locks → atomics → executors → virtual threads.