# Java Concurrency API – High-Level Concurrency in Java 21 (with Examples)

This chapter presents the Java Concurrency API with practical, certification-oriented examples. Each concept is illustrated with minimal but meaningful code to clarify behavior, intent, and correct usage according to Java 21 best practices.

## Goals and Scope of the Concurrency API

The Java Concurrency API addresses limitations of manual thread management by introducing structured abstractions for concurrent execution.

- Task-based programming instead of thread-based programming.
- Centralized thread lifecycle management.
- Safer coordination and cancellation mechanisms.

At its core, the API separates **what** must run from **how** and **where** it runs.

```java
ExecutorService executor = Executors.newSingleThreadExecutor();
executor.execute(() -> System.out.println("Task executed"));
executor.shutdown();
```

## Fundamental Threading Problems

### Race Condition Example

Multiple threads modify shared state without synchronization.

```java
class Counter {
	int count = 0;
	void increment() {
		count++;
	}
}
```

If multiple threads call `increment()` concurrently, results are unpredictable.

### Deadlock Example

Threads wait indefinitely for each other’s locks.

```java
synchronized (lockA) {
	synchronized (lockB) {
	}
}
```

If another thread locks `lockB` first and then waits for `lockA`, both threads are blocked forever.

### Starvation Example

A thread is never scheduled due to unfair resource access.

```java
ReentrantLock lock = new ReentrantLock(false); // unfair lock
```

High-priority threads may repeatedly acquire the lock, starving others.

### Livelock Example

Threads continuously react but never progress.

```java
while (!tryLock()) {
	Thread.sleep(10);
}
```

Both threads repeatedly retry, preventing progress.

## From Threads to Tasks

Tasks represent units of work independent of execution threads.

```java
Runnable task = () -> System.out.println("Runnable task");
Callable<Integer> callable = () -> 42;
```

This abstraction enables reuse, scheduling, and composition.

## Executor Framework

Executors manage thread creation and reuse.

```java
ExecutorService executor = Executors.newFixedThreadPool(2);
executor.execute(() -> System.out.println("Task 1"));
executor.execute(() -> System.out.println("Task 2"));
executor.shutdown();
```

### Submitting Tasks and Futures

```java
Future<Integer> future =
executor.submit(() -> 10 + 20);

Integer result = future.get();
```

The calling thread blocks until the result is available.

### Callable vs Runnable Example

```java
Callable<String> c = () -> "done";
Runnable r = () -> System.out.println("done");
```

Use `Callable` when results or checked exceptions are required.

## Thread Pools and Scheduling

Thread pools control concurrency levels and resource usage.

```java
ExecutorService pool =
Executors.newCachedThreadPool();
```

Cached pools are suitable for short-lived asynchronous tasks.

### Scheduled Execution Example

```java
ScheduledExecutorService scheduler =
Executors.newScheduledThreadPool(1);

scheduler.schedule(
() -> System.out.println("Delayed"),
2, TimeUnit.SECONDS);
```

## Executor Lifecycle and Termination

Executors must be shut down explicitly.

```java
executor.shutdown();
executor.awaitTermination(5, TimeUnit.SECONDS);
```

Failure to do so may prevent JVM termination.

## Thread Safety Strategies

### Synchronized Example

```java
synchronized void increment() {
count++;
}
```

### Atomic Variables Example

```java
AtomicInteger count = new AtomicInteger();
count.incrementAndGet();
```

Atomic classes provide lock-free thread safety.

### Lock Framework Example

```java
ReentrantLock lock = new ReentrantLock();
lock.lock();
try {
} finally {
lock.unlock();
}
```

### Coordination Utilities Example

CyclicBarrier synchronizes multiple threads at a common point.

```java
CyclicBarrier barrier = new CyclicBarrier(3);
barrier.await();
```

## Concurrent Collections

Thread-safe collections optimized for concurrency.

```java
Map<String, Integer> map =
new ConcurrentHashMap<>();
map.put("a", 1);
```

BlockingQueue enables producer-consumer patterns.

```java
BlockingQueue<String> queue =
new LinkedBlockingQueue<>();
queue.put("item");
queue.take();
```

## Parallel Streams

Parallel streams enable declarative data parallelism.

```java
list.parallelStream()
.map(x -> x * x)
.forEach(System.out::println);
```

Parallel streams use the common ForkJoinPool and should be applied carefully.

## Relation to Virtual Threads

Java 21 allows executors to use virtual threads transparently.

```java
ExecutorService executor =
Executors.newVirtualThreadPerTaskExecutor();

executor.submit(() -> blockingIO());
executor.close();
```

Blocking operations scale efficiently with virtual threads.

## Summary

The Java Concurrency API provides structured, safe, and scalable concurrency. By combining executors, synchronization tools, concurrent collections, and parallel streams, Java 21 enables both high-performance and maintainable concurrent applications. These concepts are central to Java certification and modern Java system design.