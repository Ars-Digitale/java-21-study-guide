# 30. Java Threads – Fundamentals and Execution Model

### Table of Contents

- [30. Java Threads – Fundamentals and Execution Model](#30-java-threads--fundamentals-and-execution-model)
  - [30.1 Threads Processes and the Operating System](#301-threads-processes-and-the-operating-system)
  - [30.2 Memory Model Stack and Heap](#302-memory-model-stack-and-heap)
  - [30.3 Context and Context Switching](#303-context-and-context-switching)
  - [30.4 Concurrency vs Parallelism](#304-concurrency-vs-parallelism)
  - [30.5 Threads in Java Conceptual Model](#305-threads-in-java-conceptual-model)
  - [30.6 Thread Categories in Java 21](#306-thread-categories-in-java-21)
  - [30.7 Creating Threads in Java](#307-creating-threads-in-java)
  - [30.8 Thread Lifecycle and Execution](#308-thread-lifecycle-and-execution)
  - [30.9 Starting vs Running a Thread Synchronous-or-Asynchronous](#309-starting-vs-running-a-thread-synchronous-or-asynchronous)
  - [30.10 Thread Priority and Scheduling](#3010-thread-priority-and-scheduling)
  - [30.11 Thread Deferring and Yielding](#3011-thread-deferring-and-yielding)
  - [30.12 Thread Interruption and Cooperative Cancellation](#3012-thread-interruption-and-cooperative-cancellation)
    - [30.12.1 What Interrupting a Thread Means](#30121-what-interrupting-a-thread-means)
    - [30.12.2 Interrupting Blocking Operations](#30122-interrupting-blocking-operations)
    - [30.12.3 Checking the Interruption Status](#30123-checking-the-interruption-status)
    - [30.12.4 Example Interrupting-a-Sleeping-Thread](#30124-example-interrupting-a-sleeping-thread)
    - [30.12.5 Key Observations](#30125-key-observations)
  - [30.13 Threads and the Main Thread](#3013-threads-and-the-main-thread)
  - [30.14 Thread Concurrency and Shared State](#3014-thread-concurrency-and-shared-state)
  - [30.15 Summary](#3015-summary)

---

This chapter introduces **threads** from first principles and explains how they are modeled and used in Java 21. 

It builds the conceptual foundation required for understanding concurrency, synchronization, and the Java Concurrency API covered in the next chapter.

## 30.1 Threads, Processes, and the Operating System

To understand threads, we must start from the operating system execution model. Modern operating systems execute programs using **processes** and **threads**.

- **Process**: An executing program instance managed by the operating system. A process owns its own virtual memory space, system resources (files, sockets), and at least one thread.
- **Thread**: A lightweight execution unit within a process. Threads share the process memory and resources but execute independently.
- **Task**: A logical unit of work to be executed. A task may be executed by a thread but is not itself a thread.
- **CPU Core**: A physical or logical execution unit capable of running one thread at a time. Multiple cores allow true parallel execution.

A single process can contain many threads, all operating within the same shared environment. This shared environment is both the source of concurrency power and concurrency risk.

## 30.2 Memory Model: Stack and Heap

Threads interact with memory in two fundamentally different ways.

- **Thread Stack**: Private memory area for each thread. It stores method call frames, local variables, and execution state. Each thread has exactly one stack.
- **Heap**: Shared memory area used for objects and class instances. All threads within the same process can access the heap.

Because stacks are isolated and the heap is shared, concurrency problems arise when multiple threads access the same heap objects without proper coordination.

## 30.3 Context and Context Switching

The operating system schedules threads onto CPU cores. Since the number of runnable threads often exceeds the number of available cores, the OS performs **context switching**.

- **Context**: The complete execution state of a thread, including registers, program counter, and stack pointer.
- **Context Switch**: The act of suspending one thread and resuming another by saving and restoring their contexts.

Context switching enables concurrency but has a cost: CPU cycles are consumed without executing application logic. Java developers must design systems that balance concurrency and efficiency.

## 30.4 Concurrency vs Parallelism

These two terms are often confused but describe different concepts.

- **Concurrency**: Multiple threads are in progress during the same time interval, possibly interleaved on a single CPU core.
- **Parallelism**: Multiple threads execute simultaneously on different CPU cores.

Java supports concurrency independently of hardware parallelism. Even on a single-core system, Java threads can be concurrent through time slicing.

## 30.5 Threads in Java: Conceptual Model

In Java, a **thread** represents an independent path of execution within a single JVM process. All Java threads run within the same heap and class loader context unless explicitly isolated by advanced mechanisms.

- **Java Thread**: An object of type `java.lang.Thread` that maps to an underlying execution unit.
- **Runnable**: A functional interface representing a task whose `run()` method contains executable logic.

A thread executes code by invoking its `run()` method, either directly or indirectly through the JVM thread scheduler: please check [Starting vs Running a Thread: Synchronous or Asynchronous](#9-starting-vs-running-a-thread-synchronous-or-asynchronous)

## 30.6 Thread Categories in Java 21

Java 21 defines multiple kinds of threads, differing in lifecycle, scheduling, and intended use.

- **Platform Thread**: A traditional Java thread mapped one-to-one to an operating system thread.
- **Virtual Thread**: A lightweight thread managed by the JVM and scheduled onto carrier threads. Introduced to enable massive concurrency with minimal overhead.
- **Carrier Thread**: A platform thread used internally by the JVM to execute virtual threads.
- **Daemon Thread**: A background thread that does not prevent JVM termination. When only daemon threads remain, the JVM exits.
- **User Thread**: Any non-daemon thread. The JVM waits for all user threads to complete before exiting.
- **System Thread**: Threads created internally by the JVM for garbage collection, JIT compilation, and other runtime services.


## 30.7 Creating Threads in Java

Threads can be created in multiple ways, all conceptually centered around providing executable logic.

- Extending `Thread` and overriding `run()`.
- Passing a `Runnable` to a `Thread` constructor.
- Using thread factories and executors (covered in the Concurrency API section).

```java
Runnable runnable = ...

  // Create a platform thread through constructor
  Thread thread = new Thread(runnable);
  thread.start();

  // Start a daemon thread to run a task
  Thread thread = Thread.ofPlatform().daemon().start(runnable);

  // Create an unstarted thread with name "duke", its start() method
  // must be invoked to schedule it to execute.
  Thread thread = Thread.ofPlatform().name("duke").unstarted(runnable);

  // A ThreadFactory that creates daemon threads named "worker-0", "worker-1", ...
  ThreadFactory factory = Thread.ofPlatform().daemon().name("worker-", 0).factory();

  // Start a virtual thread to run a task
  Thread thread = Thread.ofVirtual().start(runnable);

  // A ThreadFactory that creates virtual threads
  ThreadFactory factory = Thread.ofVirtual().factory();
```

Thread creation alone does not start execution. Execution begins only when the JVM scheduler is engaged.

## 30.8 Thread Lifecycle and Execution

A Java thread progresses through well-defined states during its lifetime.

- **New**: Thread object created but not yet started.
- **Runnable**: Eligible for execution by the scheduler.
- **Running**: Actively executing on a CPU core.
- **Blocked / Waiting**: Temporarily unable to proceed due to synchronization or coordination.
- **Terminated**: Execution completed or aborted.

The JVM and operating system cooperate to move threads between these states.

Threads in `BLOCKED`, `WAITING` or `TIMED_WAITING` state are **not using any CPU resources**

## 30.9 Starting vs Running a Thread: Synchronous or Asynchronous

A critical conceptual distinction exists between invoking `run()` and invoking `start()`.

- Calling `run()` directly executes the method synchronously in the current thread, like a normal method call.
- Calling `start()` requests the JVM to create a new call stack and execute `run()` asynchronously in a separate thread.

Therefore, code such as `new Thread(r).run();` does NOT create concurrency. The execution remains synchronous and blocks the calling thread until completion.

Asynchronous execution means the caller continues immediately while the new thread progresses independently, subject to scheduling. Synchronous execution means the caller waits for the operation to complete.

## 30.10 Thread Priority and Scheduling

Java threads have an associated priority hint that influences scheduling.

- Thread Priority: An integer value indicating relative importance, ranging from minimum to maximum.
- Scheduling: The JVM delegates scheduling decisions to the operating system, which may or may not honor priorities strictly.

Thread priority affects scheduling probability but never guarantees execution order. Portable Java code must never rely on priorities for correctness.

You can set **priority** on `platform threads`; for `virtual threads` the **priority** is always set to **5** (Thread.NORM_PRIORITY) and trying to change it has no effect.

## 30.11 Thread Deferring and Yielding

Threads can voluntarily influence scheduling behavior.

- Yielding: A thread hints that it is willing to pause execution to allow other runnable threads to proceed.
- Sleeping: A thread suspends execution for a fixed duration, entering a timed waiting state.

These mechanisms do not guarantee immediate execution of other threads; they merely provide scheduling hints.

## 30.12 Thread Interruption and Cooperative Cancellation

Java threads cannot be stopped forcibly from the outside. Instead, Java provides a cooperative mechanism called **thread interruption**, which allows one thread to request that another thread stop what it is doing. 

The target thread decides how and when to respond.

### 30.12.1 What Interrupting a Thread Means

Interrupting a thread does **not** terminate it. Calling `interrupt()` sets an internal **interruption flag** on the target thread. It is the responsibility of the running thread to observe this flag and react appropriately.

- Interrupt Request: A signal sent to a thread indicating that it should stop or change its current activity.
- Interruption Flag: A boolean status associated with each thread, set when `interrupt()` is invoked.
- Cooperative Cancellation: A design pattern where threads periodically check for interruption and terminate themselves cleanly.

### 30.12.2 Interrupting Blocking Operations

Some blocking methods in Java respond immediately to interruption by throwing `InterruptedException` and clearing the interruption flag. These methods include `sleep()`, `wait()`, and `join()`.

When a thread is blocked in one of these methods and another thread interrupts it, the blocked thread is awakened and an exception is thrown. This provides a safe escape point from blocking operations.

### 30.12.3 Checking the Interruption Status

Threads that are not blocked must explicitly check whether they have been interrupted. Java provides two ways to do this.

- `Thread.currentThread().isInterrupted()`: Returns the interruption status without clearing it.
- `Thread.interrupted()`: Returns the interruption status and clears it.

Failing to check the interruption status may cause threads to ignore cancellation requests and run indefinitely.

### 30.12.4 Example: Interrupting a Sleeping Thread

The following example demonstrates cooperative cancellation using interruption. A worker thread repeatedly sleeps while performing work. The main thread interrupts it, causing a clean shutdown.

```java
class Main {

	static class Task implements Runnable {
		public void run() {
			try {
				while (true) {
					System.out.println("Working...");
					Thread.sleep(1000);
				}
			} catch (InterruptedException e) {
				System.out.println("Task interrupted, shutting down");
			}
		}
	}

	public static void main(String[] args) throws InterruptedException {
		Thread worker = new Thread(new Task());
		worker.start();
		System.out.println("main before sleep...");
		Thread.sleep(3000);
		System.out.println("main after sleep...");
		worker.interrupt();
		System.out.println("main reached END");
	}
}
```

Output:

```bash
main before sleep...
Working...
Working...
Working...
main after sleep...
main reached END
Task interrupted, shutting down
```

### 30.12.5 Key Observations

- Calling `interrupt()` does not stop the thread directly.
- The interruption is detected because `sleep()` throws `InterruptedException`.
- The worker thread terminates itself in a controlled manner.
- Proper interruption handling allows threads to release resources and maintain program correctness.

> **Note:** 
Swallowing `InterruptedException` without terminating or restoring the interruption status is considered bad practice and may lead to unresponsive threads.


## 30.13 Threads and the Main Thread

Every Java application starts with a **main thread**. This thread executes the `main(String[])` method.

- The main thread is a user thread.
- The JVM remains alive as long as at least one user thread is running.
- If the main thread terminates but other user threads exist, the JVM continues execution waiting for the user threads to be done.

Understanding the role of the main thread is essential for reasoning about program termination and background processing.

## 30.14 Thread Concurrency and Shared State

Concurrency arises when multiple threads access shared mutable state.

- Shared State: Any heap-based data accessible by more than one thread.
- Race Condition: A correctness error caused by unsynchronized access to shared state.
- Visibility Problem: A thread observes stale data due to lack of proper memory synchronization.

Java provides synchronization, volatile variables, and higher-level concurrency utilities to address these problems, which will be studied in subsequent sections.

## 30.15 Summary

Threads are the fundamental building block of concurrent execution in Java. They exist within processes, share memory, and are scheduled by the JVM in cooperation with the operating system.
