# Java Concurrency API

This chapter introduces the **Java Concurrency API**, which provides high-level abstractions for managing concurrent execution safely, efficiently, and scalably. 

Unlike low-level thread manipulation, the Concurrency API focuses on **tasks**, **executors**, and **coordination mechanisms**, allowing developers to reason about what should be done rather than how threads are scheduled.

## Goals and Scope of the Concurrency API

The Java Concurrency API, primarily located in the `java.util.concurrent` package, was introduced to address fundamental problems inherent in manual thread management.

- Decouple task submission from thread management.
- Reduce error-prone low-level synchronization.
- Improve scalability and performance on multi-core systems.
- Provide structured mechanisms for coordination, cancellation, and shutdown.

The API does not eliminate concurrency problems but provides disciplined tools to manage them safely and predictably. Instead of explicitly creating and controlling threads, developers submit tasks and let the framework manage execution details.

```java
ExecutorService executor = Executors.newSingleThreadExecutor();
executor.execute(() -> System.out.println("Task executed"));
executor.shutdown();
```

## Fundamental Threading Problems

Before understanding the Concurrency API, it is essential to understand the concurrency problems it is designed to mitigate. These problems arise from shared mutable state, scheduling unpredictability, and improper coordination.

### Race Conditions

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

### Deadlock

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

### Starvation

**Starvation** happens when a thread is indefinitely denied access to resources, even though those resources are available.

- Often caused by unfair locking or scheduling policies.
- Thread remains runnable but never executes.

```java
ReentrantLock lock = new ReentrantLock(false); // unfair lock
```

Threads may repeatedly acquire the lock while others wait indefinitely.

### Livelock

In a **livelock**, threads are not blocked but continuously react to each other in a way that prevents progress.

- Threads remain active but ineffective.
- Often caused by aggressive retry or avoidance logic.

```java
while (!tryLock()) {
    Thread.sleep(10);
}
```

Both threads may repeatedly retry, preventing forward progress.

## From Threads to Tasks

The Concurrency API shifts the programming model from managing **threads** directly to submitting **tasks**. A task represents a logical unit of work independent of the thread that executes it.

- Runnable: Represents a task that does not return a result.
- Callable: Represents a task that returns a result and may throw checked exceptions.

```java
Runnable task = () -> System.out.println("Runnable task");
Callable<Integer> callable = () -> 42;
```

This abstraction allows tasks to be reused, scheduled flexibly, and executed by different execution strategies.

## Executor Framework

The **Executor Framework** is the core of the Concurrency API. It manages thread creation, reuse, and task execution behind a simple interface.

- Executor: Basic interface for executing tasks.
- ExecutorService: Extends Executor with lifecycle control and result handling.
- ScheduledExecutorService: Supports delayed and periodic task execution.

```java
ExecutorService executor = Executors.newFixedThreadPool(2);
executor.execute(() -> System.out.println("Task 1"));
executor.execute(() -> System.out.println("Task 2"));
executor.shutdown();
```

### Submitting Tasks and Futures

Tasks submitted using `submit()` return a **Future**, which represents the result of an asynchronous computation.

```java
Future<Integer> future = executor.submit(() -> 10 + 20);
Integer result = future.get();
```

- get(): Blocks until completion.
- cancel(): Attempts to cancel execution.
- isDone(): Checks completion status.

### Callable vs Runnable

Both interfaces represent tasks, but with different capabilities.

- Runnable: No return value, cannot throw checked exceptions.
- Callable: Returns a value and supports checked exceptions.

```java
Callable<String> c = () -> "done";
Runnable r = () -> System.out.println("done");
```

For result-oriented asynchronous computation, `Callable` is generally preferred.

## Thread Pools and Scheduling

Executors manage **thread pools**, which reuse a fixed or dynamic number of threads to execute tasks efficiently.

- Fixed thread pool: Limits concurrency to a fixed number of threads.
- Cached thread pool: Dynamically grows and shrinks based on demand.
- Single-thread executor: Ensures sequential task execution.
- Scheduled executor: Supports delayed and periodic tasks.

```java
ScheduledExecutorService scheduler =
    Executors.newScheduledThreadPool(1);

scheduler.schedule(
    () -> System.out.println("Delayed"),
    2, TimeUnit.SECONDS);
```

## Executor Lifecycle and Termination

Executors must be shut down explicitly to release resources and allow JVM termination.

- shutdown(): Initiates orderly shutdown.
- shutdownNow(): Attempts immediate shutdown and interrupts running tasks.
- awaitTermination(): Waits for completion or timeout.

```java
executor.shutdown();
executor.awaitTermination(5, TimeUnit.SECONDS);
```

## Thread Safety Strategies

The Concurrency API provides multiple complementary strategies for achieving thread safety.

### Synchronization

Synchronization enforces mutual exclusion and memory visibility using intrinsic locks.

```java
synchronized void increment() {
    count++;
}
```

### Atomic Variables

Atomic classes provide lock-free, thread-safe operations using low-level CPU primitives.

```java
AtomicInteger count = new AtomicInteger();
count.incrementAndGet();
```

### Lock Framework

The `java.util.concurrent.locks` package provides advanced locking constructs with greater flexibility.

```java
ReentrantLock lock = new ReentrantLock();
lock.lock();
try {

} finally {
   lock.unlock();
}
```

### Coordination Utilities

Coordination utilities allow threads to synchronize execution without direct locking.

```java
CyclicBarrier barrier = new CyclicBarrier(3);
barrier.await();
```

## Concurrent Collections

Concurrent collections are thread-safe data structures designed for high concurrency and scalability.

- ConcurrentHashMap: High-performance concurrent map.
- CopyOnWriteArrayList: Optimized for frequent reads.
- BlockingQueue: Supports producer-consumer patterns.

```java
BlockingQueue<String> queue =
new LinkedBlockingQueue<>();
queue.put("item");
queue.take();
```

## Parallel Streams

Parallel streams provide declarative data parallelism by splitting stream operations across multiple threads.

- Activated via `parallelStream()` or `stream().parallel()`.
- Executed using the common `ForkJoinPool`.
- Best suited for CPU-bound, stateless operations.

```java
list.parallelStream()
    .map(x -> x * x)
    .forEach(System.out::println);
```

## Relation to Virtual Threads

In Java 21, the Executor framework integrates seamlessly with **virtual threads**, enabling massive concurrency with minimal resource usage.

```java
ExecutorService executor =
Executors.newVirtualThreadPerTaskExecutor();

executor.submit(() -> blockingIO());
executor.close();
```

This allows blocking code to scale efficiently without redesigning APIs.

## Summary

The Java Concurrency API provides a robust, scalable, and safer alternative to manual thread management. By abstracting execution, coordinating tasks, and offering thread-safe utilities, it enables developers to build concurrent systems that are both performant and maintainable. Mastery of these concepts is essential for Java 21 certification and modern Java development.
