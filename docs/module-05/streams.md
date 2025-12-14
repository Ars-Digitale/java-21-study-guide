# Java Streams — Certification-Grade Deep Dive (Java 21)



This chapter provides an in deep treatment of the Java Streams API as defined in Java 21. 
It focuses on conceptual correctness, execution model, edge cases, performance implications, and common traps frequently tested in professional Java certifications.


##  1. What Is a Stream (And What It Is Not)


A Java Stream represents a sequence of elements supporting functional-style operations. 

Streams are designed for data processing, not data storage.



**Key characteristics**:


- A stream does not store data
- A stream is lazy — nothing happens until a terminal operation is invoked
- A stream can be consumed only once
- Streams encourage side-effect-free operations


> **Note:** 
Streams are conceptually similar to database queries: they describe what to compute, not how to iterate.


## 2. Stream Pipeline Architecture

Every stream pipeline consists of three distinct phases:

- Source
- Zero or more intermediate operations
- Exactly one terminal operation


### 2.1 Stream Sources


Common stream sources include:

- Collections: `collection.stream()`
- Arrays: `Arrays.stream(array)`
- I/O channels and files
- Infinite streams: `Stream.iterate`, `Stream.generate`


```java
List<String> names = List.of("Ana", "Bob", "Carla");
Stream<String> s = names.stream();
```

### 2.2 Intermediate Operations


Intermediate operations:


- Return a new stream
- Are lazy
- Do not trigger execution



Common intermediate operations include:

- `filter`
- `map`
- `flatMap`
- `sorted`
- `distinct`


```java
Stream<String> s2 = names.stream().filter(n -> n.length() > 3).map(String::toUpperCase);
```

> **Note:** 
Intermediate operations only describe the computation. No element is processed yet.


### 2.3 Terminal Operations

Terminal operations:


- Trigger execution
- Consume the stream
- Produce a result or side effect


### 2.4 Table of terminal operations:


| Method | Return value | behaviour for infinite streams |
|--------|--------------|--------------------------------|
| `forEach` | void | does not terminate |
| `collect` | varies | does not terminate |
| `reduce` | varies | does not terminate |
| `findFirst` / `findAny` |  Optional<T> |  terminates |
| `anyMatch` / `allMatch` / `noneMatch` | boolean | sometimes terminate |
| `min` / `max` | Optional<T> | does not terminate |  
|  `count` | long | does not terminate |


## 3. Lazy Evaluation and Short-Circuiting


Streams process elements one at a time, flowing through the pipeline vertically, not stage-by-stage.


```java
Stream.of("a", "bb", "ccc").filter(s -> {
	System.out.println("filter " + s);
	return s.length() > 1;
}).map(s -> {
	System.out.println("map " + s);
	return s.toUpperCase();
}).findFirst();
```


Execution order:

> **Note:** 
Only the minimum number of elements required by the terminal operation are processed.

```text
--> filter a
--> filter bb
----> map bb
```

## 4. Stateless vs Stateful Operations


### 4.1 Stateless Operations

Operations like `map` and `filter` process each element independently.


### 4.2 Stateful Operations

Operations like `distinct`, `sorted`, and `limit` require maintaining internal state.


> **Note:** 
Stateful operations can severely impact parallel stream performance.


## 5. Stream Ordering and Determinism



Streams may be:

- Ordered (e.g., `List.stream()`)
- Unordered (e.g., `HashSet.stream()`)


Some operations respect encounter order:

- `forEachOrdered`
- `findFirst`


> **Note:** 
In parallel streams, `forEach` does not guarantee order.


## 6. Reduction Operations


### 6.1 reduce()


```java
int sum =
Stream.of(1, 2, 3)
.reduce(0, Integer::sum);
```


Reduction requires:


- 
Identity

- 
Accumulator

- 
(Optional) Combiner


> **Note:** 
The accumulator must be associative and stateless.


### 
6.2 collect()



`collect` is a mutable reduction optimized for grouping and aggregation.


```java
Map<Integer, List<String>> byLength =
names.stream()
.collect(Collectors.groupingBy(String::length));
```

## 
7. Parallel Streams



Parallel streams divide work across threads using the ForkJoinPool.commonPool().


```java
int sum =
IntStream.range(1, 1_000_000)
.parallel()
.sum();
```


Rules for safe parallel streams:


- 
No side effects

- 
No mutable shared state

- 
Associative operations only


> **Note:** 
Parallel streams can be slower for small workloads.


## 
8. Common Certification Pitfalls


- 
Reusing a consumed stream → `IllegalStateException`

- 
Modifying external variables inside lambdas

- 
Assuming execution order in parallel streams

- 
Using `peek` for logic instead of debugging


## 
9. Certification Exercises


### 
Exercise 1 — Lazy Evaluation



How many times is `filter` executed?


```java
Stream.of("x", "yy", "zzz")
.filter(s -> s.length() > 1)
.findFirst();
```

### 
Exercise 2 — Stream Reuse



What happens at runtime?


```java
Stream<Integer> s = Stream.of(1, 2, 3);
s.count();
s.forEach(System.out::println);
```

### 
Exercise 3 — Parallel Semantics



Is the output deterministic?


```java
IntStream.range(1, 10)
.parallel()
.forEach(System.out::print);
```

### 
Exercise 4 — Reduction Correctness



Why is this reduction incorrect for parallel streams?


```java
int result =
IntStream.range(1, 100)
.parallel()
.reduce(0, (a, b) -> a - b);
```

## 
10. Exam Summary


- 
Streams are lazy and single-use

- 
Intermediate ≠ execution

- 
Terminal triggers processing

- 
Parallel streams require mathematical discipline

- 
Most exam traps involve ordering, laziness, and side effects


> **Note:** 
Mastery of streams means understanding how execution flows, not memorizing methods.
