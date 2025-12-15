# Java Streams (Java 21)



This chapter provides an in deep treatment of the Java Streams API as defined in Java 21. 

It focuses on conceptual correctness, execution model, edge cases, performance implications, and common traps.


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

- **Source**
- Zero or more **Intermediate Operations**
- Exactly one **Terminal Operation**


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



#### 2.2.1 Table of Common intermediate operations:

| Method | Common Input Params | Return value | Desctiption |
|--------|--------------|--------------|--------------|
|`filter` | Predicate | `Stream<T>` | filter the stream according to a predicate match |
| `map` | Function | `Stream<T>` | transform a stream through a one to one mapping input/output |
| `flatMap` | Function | `Stream<T>` | flatten all the contained elements to be top level in a sigle stream, removing empty elements |
| `sorted` | void or Comparator | `Stream<T>` | sort according to natural order or provided Comparator |
| `distinct` | void | `Stream<T>` | remove duplicate elements |
| `limit` / `skip` |  long | `Stream<T>` | limit size or skip elements |
| `peek` |  Consumer | `Stream<T>` | perform stream operations without changing the stream (Debug)  |


Example:

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


#### 2.3.1 Table of terminal operations:


| Method | Return value | behaviour for infinite streams |
|--------|--------------|--------------------------------|
| `forEach` | **void** | does not terminate |
| `collect` | varies | does not terminate |
| `reduce` | varies | does not terminate |
| `findFirst` / `findAny` |  **`Optional<T>`** |  terminates |
| `anyMatch` / `allMatch` / `noneMatch` | **boolean** | sometimes terminate |
| `min` / `max` | **`Optional<T>`** | does not terminate |  
|  `count` | **long** | does not terminate |


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


> **Note:** In parallel streams, `forEach` does not guarantee order.


## 6. Parallel Streams

Parallel streams divide work across threads using the ForkJoinPool.commonPool().


```java
int sum =
IntStream.range(1, 1_000_000)
.parallel()
.sum();
```


Rules for safe parallel streams:


- No side effects
- No mutable shared state
- Associative operations only


> **Note:** Parallel streams can be slower for small workloads.

## 7. Reduction Operations


### 7.1 `reduce()`: combining a stream in to a single object

There are three method signatures for this operation:

- public Optional<T> **reduce**(BinaryOperator<T> accumulator);
- public T **reduce**(T identity, BinaryOperator<T> accumulator);
- public <U> U **reduce**(U identity, BiFunction<U, ? super T, U> accumulator, BinaryOperator<U> combiner)


```java
int sum =
Stream.of(1, 2, 3)
.reduce(0, Integer::sum);
```

Reduction requires:

- **Identity**: Initial value for each partial reduction; must be a neutral element; Example: 0 for sum, 1 for multiplication, empty collection for collecting;
- **Accumulator**: Incorporates one stream element into a partial result;
- (Optional) **Combiner**: Merges two partial results; Used only when the stream is parallel; Ignored for sequential streams


> **Note:** 
The accumulator must be associative and stateless.

#### 7.1.1 Correct mental model

- Accumulator: result + element
- Combiner: result + result

**Example 1**: Correct use (sum of lengths)

```java
int totalLength =
    Stream.of("a", "bb", "ccc")
          .parallel()
          .reduce(
              0,                       // identity
              (sum, s) -> sum + s.length(), // accumulator
              (left, right) -> left + right // combiner
          );
```

What happens in parallel

Suppose the stream is split:

- Thread 1: "a", "bb" → 0 + 1 + 2 = 3
- Thread 2: "ccc" → 0 + 3 = 3

Output, Combines merges:

```bash
3 + 3 = 6
```

**Example 2**: Combiner ignored in sequential streams

```java
int result =
    Stream.of("a", "bb", "ccc")
          .reduce(
              0,
              (sum, s) -> sum + s.length(),
              (x, y) -> {
                  throw new RuntimeException("Never called");
              }
          );
```

**Example 3**: Incorrect combiner

```java
int result =
    Stream.of(1, 2, 3, 4)
          .parallel()
          .reduce(
              0,
              (a, b) -> a - b,   // accumulator
              (x, y) -> x - y    // combiner
          );
```

Why this is wrong

**Subtraction is not associative**.

Possible execution:

- Thread 1: 0 - 1 - 2 = -3
- Thread 2: 0 - 3 - 4 = -7

Combiner:

```bash
-3 - (-7) = 4
```

Sequential result would be:

```bash
(((0 - 1) - 2) - 3) - 4 = -10
```

> [!WARNING]
> ❌ Parallel and sequential results differ → illegal reduction

### 7.2 collect()

`collect` is a mutable reduction optimized for grouping and aggregation. 

It is the Stream API’s standard tool for “mutable reduction”: you accumulate elements into a mutable container (like a List, Set, Map, StringBuilder, custom result object), 
and then optionally merge partial containers when running in parallel.

The general form is:

- public <R> R **collect**(Supplier<R> supplier, BiConsumer<R, ? super T> accumulator, BiConsumer<R, R> combiner);

And a common version used is:

- public <R, A> R **collect**(Collector<? super T, A, R> collector)

where Collectors.* provides prebuilt collectors (grouping, mapping, joining, counting, etc.).

Meaning:

- **supplier**: creates a new empty result container (e.g. new ArrayList<>())
- **accumulator**: adds one element into that container (e.g. list::add)
- **combiner**: merges two containers (e.g. list1.addAll(list2))

### 7.3 Why collect() is different from reduce()

- 1. Intent: mutation vs immutability
	- reduce() is designed for immutable-style reduction: combine values into a new value (e.g. sum, min, max).
	- collect() is designed for mutable containers: build up a List, Map, StringBuilder, etc.
- 2. Correctness in parallel
	- reduce() requires the operation to be:
		- associative
		- stateless
		- compatible with identity/combiner rules
	- collect() is built to support parallelism safely by:
		- creating one container per thread (supplier)
		- accumulating locally (accumulator)
		- merging at the end (combiner)
- 3. Performance
	- collect() can be optimized because the stream runtime knows you are building containers:
		- it can avoid unnecessary copying
		- it can pre-size or use specialized implementations (depending on collector)
		- it’s the idiomatic and expected approach
		- Using reduce() to build a collection often creates extra objects or forces unsafe mutation.


Example: “collect into a List” the right way

```java
List<String> longNames =
    names.stream()
         .filter(s -> s.length() > 3)
         .collect(Collectors.toList());
```

Example: groupingBy (your snippet) with explanation

```java
Map<Integer, List<String>> byLength =
    names.stream()
         .collect(Collectors.groupingBy(String::length));
```

What happens conceptually:

- The collector creates an empty Map<Integer, List<String>>
- For each name:
	- compute the key (String::length)
	- put it in the correct bucket list
- In parallel:
	- each thread builds its own partial maps
	- the combiner merges maps by merging lists per key



## 8. Common Streams Pitfall

- Reusing a consumed stream → `IllegalStateException`
- Modifying external variables inside lambdas
- Assuming execution order in parallel streams
- Using `peek` for logic instead of debugging

## 9. Primitive Streams

Java provides three specialized stream types to avoid boxing overhead and to enable numeric-focused operations:

- `IntStream` for `int`
- `LongStream` for `long`
- `DoubleStream` for `double`

Primitive streams are still streams (lazy pipelines, intermediate + terminal operations, single-use), but they are **not generic** and they use primitive-specialized functional interfaces (e.g., `IntPredicate`, `LongUnaryOperator`, `DoubleConsumer`).

> **Note:** Use primitive streams when the data is naturally numeric or when performance matters: they avoid boxing/unboxing overhead and provide additional numeric terminal operations.

### 9.1 Why primitive streams matter

- Performance: avoid allocating wrapper objects and repeated boxing/unboxing in large pipelines
- Convenience: built-in numeric reductions such as `sum()`, `average()`, `summaryStatistics()`
- Common traps: understanding when results are primitives vs `OptionalInt`/`OptionalLong`/`OptionalDouble`

### 9.2 Common creation methods

The following are the most frequently used ways to create primitive streams. Many certification questions start by identifying the stream type created by a factory method.

| Sources |
|---------|
| IntStream.of(int...) |
| IntStream.range(int startInclusive, int endExclusive) |
| IntStream.rangeClosed(int startInclusive, int endInclusive) |
| IntStream.iterate(int seed, IntUnaryOperator f) // infinite unless limited |
| IntStream.iterate(int seed, IntPredicate hasNext, IntUnaryOperator f)  |
| IntStream.generate(IntSupplier s) // infinite unless limited  |
| LongStream.of(long...) |
| LongStream.range(long startInclusive, long endExclusive) |
| LongStream.rangeClosed(long startInclusive, long endInclusive) |
| LongStream.iterate(long seed, LongUnaryOperator f) |
| LongStream.iterate(long seed, LongPredicate hasNext, LongUnaryOperator f) |
| LongStream.generate(LongSupplier s) |
| DoubleStream.of(double...) |
| DoubleStream.iterate(double seed, DoubleUnaryOperator f) |
| DoubleStream.iterate(double seed, DoublePredicate hasNext, DoubleUnaryOperator f) |
| DoubleStream.generate(DoubleSupplier s) |

> [!IMPORTANT]
> - Only `IntStream` and `LongStream` provide `range()` and `rangeClosed()`. 
> - There is no `DoubleStream.range` because counting with doubles has rounding issues.

### 9.3 Primitive-specialized mapping methods (within the same primitive family)

Primitive streams provide **primitive-only** mapping operations that avoid boxing:

- `IntStream.map(IntUnaryOperator)` → `IntStream`
- `IntStream.mapToLong(IntToLongFunction)` → `LongStream`
- `IntStream.mapToDouble(IntToDoubleFunction)` → `DoubleStream`

- `LongStream.map(LongUnaryOperator)` → `LongStream`
- `LongStream.mapToInt(LongToIntFunction)` → `IntStream`
- `LongStream.mapToDouble(LongToDoubleFunction)` → `DoubleStream`

- `DoubleStream.map(DoubleUnaryOperator)` → `DoubleStream`
- `DoubleStream.mapToInt(DoubleToIntFunction)` → `IntStream`
- `DoubleStream.mapToLong(DoubleToLongFunction)` → `LongStream`


### 9.4 Mapping table among Stream<T> and primitive streams

This table summarizes the main conversions among object streams and primitive streams. 

The “From” column tells you which methods are available and the resulting target stream type.


| From (source)	| To (target) |	Primary method(s) |
|---------------|-------------|-------------------|
| Stream<T> | Stream<R> | map(Function<? super T, ? extends R>) |
| Stream<T> | Stream<R> (flatten) | flatMap(Function<? super T, ? extends Stream<? extends R>>) |
||||
| Stream<T> | IntStream | mapToInt(ToIntFunction<? super T>) |
| Stream<T> | LongStream | mapToLong(ToLongFunction<? super T>) |
| Stream<T> | DoubleStream | mapToDouble(ToDoubleFunction<? super T>) |
| Stream<T> | IntStream (flatten) | flatMapToInt(Function<? super T, ? extends IntStream>) |
| Stream<T> | LongStream (flatten) | flatMapToLong(Function<? super T, ? extends LongStream>) |
| Stream<T> | DoubleStream (flatten) | flatMapToDouble(Function<? super T, ? extends DoubleStream>) |
||||
| IntStream | Stream<Integer> | boxed() |
| LongStream | Stream<Long> | boxed() |
| DoubleStream | Stream<Double> | boxed() |
||||
| IntStream | Stream<U> | mapToObj(IntFunction<? extends U>) |
| LongStream | Stream<U> | mapToObj(LongFunction<? extends U>) |
| DoubleStream | Stream<U> | mapToObj(DoubleFunction<? extends U>) |
||||
| IntStream | LongStream | asLongStream() |
| IntStream | DoubleStream | asDoubleStream() |
| LongStream | DoubleStream | asDoubleStream() |
		
> [!IMPORTANT]
> - There is no **`unboxed()`** operation. 
> - To go from wrappers to primitives you must start from `Stream<T>` and use `mapToInt` / `mapToLong` / `mapToDouble`.

### 9.5 Terminal operations and their result types

Primitive streams have several terminal operations that are either unique or have primitive-specific return types. Many exam questions test the return type precisely.


| Terminal operation | IntStream returns | LongStream returns | DoubleStream returns |
|--------------------|-------------------|--------------------|----------------------|
| count() | long | long | long |
| sum() | int | long | double |
| min() / max() | OptionalInt | OptionalLong | OptionalDouble |
| average() | OptionalDouble | OptionalDouble | OptionalDouble |
| findFirst() / findAny() | OptionalInt | OptionalLong | OptionalDouble |
| reduce(op) | OptionalInt | OptionalLong | OptionalDouble |
| reduce(identity, op) | int | long | double |
| summaryStatistics() | IntSummaryStatistics | LongSummaryStatistics | DoubleSummaryStatistics |
			
> [!WARNING]
> - Even for `IntStream` and `LongStream`, **`average()`** returns `OptionalDouble` (not `OptionalInt` or `OptionalLong`).

Examples (end-to-end conversions)

Example 1: `Stream<String>` → `IntStream` → primitive terminal operations.
```java
List<String> words = List.of("a", "bb", "ccc");

int totalLength =
words.stream()
.mapToInt(String::length) // IntStream
.sum(); // int

// totalLength = 1 + 2 + 3 = 6
```

Example 2: `IntStream` → boxed `Stream<Integer>` (boxing introduced).
```java
Stream<Integer> boxed =
IntStream.rangeClosed(1, 3) // 1,2,3
.boxed(); // Stream<Integer>
```

Example 3: primitive stream → object stream via `mapToObj`.
```java
Stream<String> labels =
IntStream.range(1, 4) // 1,2,3
.mapToObj(i -> "N=" + i); // Stream<String>
```

### 9.6 Common pitfalls and gotchas
- Do not confuse `Stream<Integer>` with `IntStream`: their mapping methods and functional interfaces differ
- `IntStream.sum()` returns `int` but `IntStream.count()` returns `long`
- `average()` always returns `OptionalDouble` for all primitive stream types
- Using `boxed()` reintroduces boxing; only do it if the downstream API requires objects (e.g., collecting to `List<Integer>`)
- Be careful with narrowing conversions: `LongStream.mapToInt` and `DoubleStream.mapToInt` may truncate values








