# 21. Java Optionals and Streams

<a id="table-of-contents"></a>
### Table of Contents

- [21. Java Optionals and Streams](#21-java-optionals-and-streams)
  - [21.1 Optionals Optional OptionalInt OptionalLong OptionalDouble](#211-optionals-optional-optionalint-optionallong-optionaldouble)
    - [21.1.1 Creating Optionals](#2111-creating-optionals)
    - [21.1.2 Reading values safely](#2112-reading-values-safely)
    - [21.1.3 Transforming Optionals](#2113-transforming-optionals)
    - [21.1.4 Optionals and Streams](#2114-optionals-and-streams)
    - [21.1.5 Primitive Optionals](#2115-primitive-optionals)
    - [21.1.6 Common pitfalls](#2116-common-pitfalls)
  - [21.2 What Is a Stream And What It Is Not](#212-what-is-a-stream-and-what-it-is-not)
  - [21.3 Stream Pipeline Architecture](#213-stream-pipeline-architecture)
    - [21.3.1 Stream Sources](#2131-stream-sources)
    - [21.3.2 Intermediate Operations](#2132-intermediate-operations)
      - [21.3.2.1 Table of Common intermediate operations](#21321-table-of-common-intermediate-operations)
    - [21.3.3 Terminal Operations](#2133-terminal-operations)
      - [21.3.3.1 Table of terminal operations](#21331-table-of-terminal-operations)
  - [21.4 Lazy Evaluation and Short-Circuiting](#214-lazy-evaluation-and-short-circuiting)
  - [21.5 Stateless vs Stateful Operations](#215-stateless-vs-stateful-operations)
    - [21.5.1 Stateless Operations](#2151-stateless-operations)
    - [21.5.2 Stateful Operations](#2152-stateful-operations)
  - [21.6 Stream Ordering and Determinism](#216-stream-ordering-and-determinism)
  - [21.7 Parallel Streams](#217-parallel-streams)
  - [21.8 Reduction Operations](#218-reduction-operations)
    - [21.8.1 reduce combining a stream into a single object](#2181-reduce-combining-a-stream-into-a-single-object)
      - [21.8.1.1 Correct mental model](#21811-correct-mental-model)
    - [21.8.2 collect](#2182-collect)
    - [21.8.3 Why collect is different from reduce](#2183-why-collect-is-different-from-reduce)
  - [21.9 Common Streams Pitfalls](#219-common-streams-pitfalls)
  - [21.10 Primitive Streams](#2110-primitive-streams)
    - [21.10.1 Why primitive streams matter](#21101-why-primitive-streams-matter)
    - [21.10.2 Common creation methods](#21102-common-creation-methods)
    - [21.10.3 Primitive-specialized mapping methods](#21103-primitive-specialized-mapping-methods)
    - [21.10.4 Mapping table among StreamT and primitive streams](#21104-mapping-table-among-streamt-and-primitive-streams)
    - [21.10.5 Terminal operations and their result types](#21105-terminal-operations-and-their-result-types)
    - [21.10.6 Common pitfalls and gotchas](#21106-common-pitfalls-and-gotchas)
  - [21.11 Collectors collect Collector and the Collectors Factory Methods](#2111-collectors-collect-collector-and-the-collectors-factory-methods)
    - [21.11.1 collect vs Collector](#21111-collect-vs-collector)
    - [21.11.2 Core collectors quick-reference](#21112-core-collectors-quick-reference)
    - [21.11.3 Grouping collectors](#21113-grouping-collectors)
    - [21.11.4 partitioningBy](#21114-partitioningby)
    - [21.11.5 toMap and merge rules](#21115-tomap-and-merge-rules)
    - [21.11.6 collectingAndThen](#21116-collectingandthen)
    - [21.11.7 How collectors relate to parallel streams](#21117-how-collectors-relate-to-parallel-streams)

---

<a id="211-optionals-optional-optionalint-optionallong-optionaldouble"></a>
## 21.1 Optionals (Optional, OptionalInt, OptionalLong, OptionalDouble)

`Optional<T>` is a container object that may or may not hold a non-null value. 

It is designed to make “absence of a value” explicit and to reduce `NullPointerException` risk by forcing callers to handle the empty case.

!!! note
    - `Optional` is intended primarily for **return types**.
    - It is generally discouraged for fields, method parameters, and serialization boundaries (unless a specific API contract requires it).

<a id="2111-creating-optionals"></a>
### 21.1.1 Creating Optionals

There are three core factory methods. 

- `Optional.of(value)` → value must be non-null; otherwise `NullPointerException` is thrown
- `Optional.ofNullable(value)` → returns empty if value is null
- `Optional.empty()` → an explicitly empty Optional

```java
Optional<String> a = Optional.of("x");
Optional<String> b = Optional.ofNullable(null); // Optional.empty
Optional<String> c = Optional.empty();
```

<a id="2112-reading-values-safely"></a>
### 21.1.2 Reading values safely

Optionals provide multiple ways to access the wrapped value.

- `isPresent()` / `isEmpty()` → test presence
- `get()` → returns the value or throws `NoSuchElementException` if empty (discouraged)
- `orElse(defaultValue)` → returns value or default (default evaluated immediately)
- `orElseGet(supplier)` → returns value or supplier result (supplier evaluated lazily)
- `orElseThrow()` → returns value or throws `NoSuchElementException`
- `orElseThrow(exceptionSupplier)` → returns value or throws custom exception

```java
Optional<String> opt = Optional.of("java");

String v1 = opt.orElse("default");
String v2 = opt.orElseGet(() -> "computed");
String v3 = opt.orElseThrow(); // ok because opt is present
```

!!! note
    - A common trap: `orElse(...)` evaluates its argument even if the Optional is present.
    - Use `orElseGet(...)` when the default is expensive to compute.

<a id="2113-transforming-optionals"></a>
### 21.1.3 Transforming Optionals

Optionals support functional transformations similar to streams, but with “0 or 1 element” semantics.

- `map(fn)` → transforms the value if present
- `flatMap(fn)` → transforms to an Optional without nesting
- `filter(predicate)` → keeps value only if predicate is true

```java
Optional<String> name = Optional.of("Alice");

Optional<Integer> len =
	name.map(String::length); // Optional[5]

Optional<String> filtered =
	name.filter(n -> n.startsWith("A")); // Optional[Alice]
	
System.out.println(len.orElse(0));
System.out.println(filtered.orElseGet(() -> "11"));
```

Output:

```text
5
Alice
```

!!! note
    - `map` wraps the result in an Optional.
    - If your mapping function already returns an Optional, use `flatMap` to avoid `Optional<Optional<T>>` nesting.

<a id="2114-optionals-and-streams"></a>
### 21.1.4 Optionals and Streams

A very common pipeline pattern is to map to an Optional and then remove empties. 

Since Java 9, `Optional` provides `stream()` to convert “present → one element” and “empty → zero elements”.

```java
		Stream<String> words = Stream.of("a", "bb", "ccc");

		words.map(w -> w.length() > 1 ? Optional.of(w.length()) : Optional.<Integer>empty()).flatMap(Optional::stream) // rimuove gli elementi vuoti
				.forEach(System.out::println); 
```

Output:

```text
2
3
```

!!! note
    Before Java 9, this pattern required `filter(Optional::isPresent)` plus `map(Optional::get)`.

<a id="2115-primitive-optionals"></a>
### 21.1.5 Primitive Optionals

Primitive streams use primitive optionals to avoid boxing: `OptionalInt`, `OptionalLong`, `OptionalDouble`. 

They mirror the main Optional API with primitive getters such as `getAsInt()`.

- `OptionalInt.getAsInt()` / `OptionalLong.getAsLong()` / `OptionalDouble.getAsDouble()`
- `orElse(...)` / `orElseGet(...)` / `orElseThrow(...)`

```java
OptionalInt m = IntStream.of(3, 1, 2).min(); // OptionalInt[1]
int value = m.orElse(0); // 1
```

<a id="2116-common-pitfalls"></a>
### 21.1.6 Common pitfalls

- Do not call `get()` without checking presence; prefer `orElseThrow` or transformations
- Avoid returning `null` instead of `Optional.empty()`; an Optional reference itself should not be null
- Remember: `average()` on primitive streams always returns `OptionalDouble` (even for `IntStream` and `LongStream`)
- Use `orElseGet` when computing the default is expensive

---

<a id="212-what-is-a-stream-and-what-it-is-not"></a>
## 21.2 What Is a Stream (And What It Is Not)


A `Java Stream` represents a sequence of elements supporting functional-style operations. 

Streams are designed for data processing, not data storage.

**Key characteristics**:


- A stream does not store data
- A stream is lazy — nothing happens until a terminal operation is invoked
- A stream can be consumed only once
- Streams encourage side-effect-free operations

!!! note
    Streams are conceptually similar to database queries: they describe what to compute, not how to iterate.

---

<a id="213-stream-pipeline-architecture"></a>
## 21.3 Stream Pipeline Architecture

Every stream pipeline consists of three distinct phases:

- 1️⃣  **Source**
- 2️⃣  Zero or more **Intermediate Operations**
- 3️⃣. Exactly one **Terminal Operation**


<a id="2131-stream-sources"></a>
### 21.3.1 Stream Sources


Common stream sources include:

- Collections: `collection.stream()`
- Arrays: `Arrays.stream(array)`
- I/O channels and files
- Infinite streams: `Stream.iterate`, `Stream.generate`


```java
List<String> names = List.of("Ana", "Bob", "Carla");
Stream<String> s = names.stream();  
```

<a id="2132-intermediate-operations"></a>
### 21.3.2 Intermediate Operations


Intermediate operations:


- Return a new stream
- Are lazy
- Do not trigger execution



<a id="21321-table-of-common-intermediate-operations"></a>
#### 21.3.2.1 Table of Common intermediate operations:

| Method | Common input Params | Return value | Desctiption |
|--------|--------------|--------------|--------------|
|`filter` | Predicate | `Stream<T>` | filter the stream according to a predicate match |
| `map` | Function | `Stream<R>` | transform a stream through a one to one mapping input/output |
| `flatMap` | Function | `Stream<R>` | flatten nested streams into a single stream |
| `sorted` | (none) or Comparator | `Stream<T>` | sort by natural order or by the provided Comparator |
| `distinct` | (none) | `Stream<T>` | remove duplicate elements |
| `limit` / `skip` | long | `Stream<T>` | limit size or skip elements |
| `peek` | Consumer | `Stream<T>` | run side-effect action for each element (debugging) |


- Example:

```java
		List<String> names = List.of("Ana", "Bob", "Carla", "Mario");
		
		names.stream().filter(n -> n.length() > 3).map(String::toUpperCase).forEach(System.out::println);
```

Output:

```text
CARLA
MARIO
```

!!! note
    Intermediate operations only describe the computation. No element is processed yet.


<a id="2133-terminal-operations"></a>
### 21.3.3 Terminal Operations

Terminal operations:


- Trigger execution
- Consume the stream
- Produce a result or side effect


<a id="21331-table-of-terminal-operations"></a>
#### 21.3.3.1 Table of terminal operations:


| Method | Return value | behaviour for infinite streams |
|--------|--------------|--------------------------------|
| `forEach` | **void** | does not terminate |
| `collect` | varies | does not terminate |
| `reduce` | varies | does not terminate |
| `findFirst` / `findAny` |  **`Optional<T>`** |  terminates |
| `anyMatch` / `allMatch` / `noneMatch` | **boolean** | may terminate early (short-circuit) |
| `min` / `max` | **`Optional<T>`** | does not terminate |  
|  `count` | **long** | does not terminate |


<a id="214-lazy-evaluation-and-short-circuiting"></a>
## 21.4 Lazy Evaluation and Short-Circuiting

```java
var newNames = new ArrayList<String>();

newNames.add("Bob");
newNames.add("Dan");

// Streams are lazily evaluated: this does not traverse the data yet,
// it only creates a pipeline description bound to the source.
var stream = newNames.stream();

newNames.add("Erin");

// Terminal operation triggers evaluation. The stream sees the updated source,
// so the count includes "Erin".
stream.count(); // 3
```

**Important note :**  
A stream is bound to its *source* (`newNames`), and the pipeline is not executed until a terminal operation is invoked.  
For this reason, if you **modify the collection before the terminal operation**, the terminal operation “sees” the new elements (here, `Erin`).  
In general, however, **modifying the source while a stream pipeline is in use is bad practice** and can lead to non-deterministic behavior (or `ConcurrentModificationException` with some sources/operations). 
The practical rule is: *build the source, then create and execute the stream without mutating it*.



Streams process elements **one at a time**, flowing “vertically” through the pipeline rather than stage-by-stage.

Below we modify the example to use a **short-circuiting** terminal operation: `findFirst()`.

```java
Stream.of("a", "bb", "ccc")
    .filter(s -> {
        System.out.println("filter " + s);
        return s.length() > 1;
    })
    .map(s -> {
        System.out.println("map " + s);
        return s.toUpperCase();
    })
    .findFirst()
    .ifPresent(System.out::println);
```

Execution order:

!!! note
    Only the minimum number of elements required by the terminal operation are processed.

```text
filter a
filter bb
map bb
BB
```

`findFirst()` is satisfied as soon as it finds the **first** element that successfully passes through the pipeline (here `"bb"`), therefore:
- `"ccc"` is never processed (neither `filter` nor `map`);
- lazy evaluation avoids unnecessary work compared to a terminal operation that consumes all elements (such as `forEach` or `count`).


---

<a id="215-stateless-vs-stateful-operations"></a>
## 21.5 Stateless vs Stateful Operations


<a id="2151-stateless-operations"></a>
### 21.5.1 Stateless Operations

Operations like `map` and `filter` process each element independently.


<a id="2152-stateful-operations"></a>
### 21.5.2 Stateful Operations

Operations like `distinct`, `sorted`, and `limit` require maintaining internal state.


!!! note
    Stateful operations can severely impact parallel stream performance.

---

<a id="216-stream-ordering-and-determinism"></a>
## 21.6 Stream Ordering and Determinism


Streams may be:

- Ordered (e.g., `List.stream()`)
- Unordered (e.g., `HashSet.stream()`)


Some operations respect encounter order:

- `forEachOrdered`
- `findFirst`

!!! note
    In parallel streams, `forEach` does not guarantee order.

---

<a id="217-parallel-streams"></a>
## 21.7 Parallel Streams

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

!!! note
    Parallel streams can be slower for small workloads.

---

<a id="218-reduction-operations"></a>
## 21.8 Reduction Operations


<a id="2181-reduce-combining-a-stream-into-a-single-object"></a>
### 21.8.1 `reduce()`: combining a stream into a single object

There are three method signatures for this operation:

- public Optional<T> **reduce**(BinaryOperator<T> accumulator);
- public T **reduce**(T identity, BinaryOperator<T> accumulator);
- public <U> U **reduce**(U identity, BiFunction<U, ? super T, U> accumulator, BinaryOperator<U> combiner)


```java
int sum = Stream.of(1, 2, 3)
	.reduce(0, Integer::sum);
```

Reduction requires:

- **Identity**: Initial value for each partial reduction; must be a neutral element; Example: 0 for sum, 1 for multiplication, empty collection for collecting;
- **Accumulator**: Incorporates one stream element into a partial result;
- (Optional) **Combiner**: Merges two partial results; Used only when the stream is parallel; Ignored for sequential streams

!!! note
    The accumulator must be associative and stateless.

<a id="21811-correct-mental-model"></a>
#### 21.8.1.1 Correct mental model

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

Then the combiner merges the partial results:

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

<ins>Why this is wrong</ins>

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

!!! warning
    ❌ Parallel and sequential results differ → illegal reduction

<a id="2182-collect"></a>
### 21.8.2 `collect()`

`collect` is a mutable reduction optimized for grouping and aggregation. 

It is the Stream API’s standard tool for “mutable reduction”: you accumulate elements into a mutable container (like a List, Set, Map, StringBuilder, custom result object), 
and then optionally merge partial containers when running in parallel.

The general form is:

- public <R> R **collect**(Supplier<R> supplier, BiConsumer<R, ? super T> accumulator, BiConsumer<R, R> combiner);

And a common version used is:

- public <R, A> R **collect**(Collector<? super T, A, R> collector)

where Collectors.* provides prebuilt collectors (grouping, mapping, joining, counting, etc.).

**Meaning**:

- **supplier**: creates a new empty result container (e.g. new ArrayList<>())
- **accumulator**: adds one element into that container (e.g. list::add)
- **combiner**: merges two containers (e.g. list1.addAll(list2))

<a id="2183-why-collect-is-different-from-reduce"></a>
### 21.8.3 Why `collect()` is different from `reduce()`

- **Intent**: mutation vs immutability
	- `reduce()` is designed for immutable-style reduction: combine values into a new value (e.g. sum, min, max).
	- `collect()` is designed for mutable containers: build up a List, Map, StringBuilder, etc.
- **Correctness** in parallel
	- `reduce()` requires the operation to be:
		- associative
		- stateless
		- compatible with identity/combiner rules
	- `collect()` is built to support parallelism safely by:
		- creating one container per thread (supplier)
		- accumulating locally (accumulator)
		- merging at the end (combiner)
- **Performance**
	- `collect()` can be optimized because the stream runtime knows you are building containers:
		- it can avoid unnecessary copying
		- it can pre-size or use specialized implementations (depending on collector)
		- it’s the idiomatic and expected approach
		- using reduce() to build a collection often creates extra objects or forces unsafe mutation.


- Example: “collect into a List” the right way

```java
List<String> longNames =
    names.stream()
         .filter(s -> s.length() > 3)
			.collect(Collectors.toList());
```

- Example: groupingBy with explanation

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

---

<a id="219-common-streams-pitfalls"></a>
## 21.9 Common Streams Pitfalls

- Reusing a consumed stream → `IllegalStateException`
- Modifying external variables inside lambdas
- Assuming execution order in parallel streams
- Using `peek` for logic instead of debugging

---

<a id="2110-primitive-streams"></a>
## 21.10 Primitive Streams

Java provides three specialized stream types to avoid boxing overhead and to enable numeric-focused operations:

- `IntStream` for `int`
- `LongStream` for `long`
- `DoubleStream` for `double`

Primitive streams are still streams (lazy pipelines, intermediate + terminal operations, single-use), but they are **not generic** and they use primitive-specialized functional interfaces (e.g., `IntPredicate`, `LongUnaryOperator`, `DoubleConsumer`).

!!! note
    Use primitive streams when the data is naturally numeric or when performance matters: they avoid boxing/unboxing overhead and provide additional numeric terminal operations.

<a id="21101-why-primitive-streams-matter"></a>
### 21.10.1 Why primitive streams matter

- Performance: avoid allocating wrapper objects and repeated boxing/unboxing in large pipelines
- Convenience: built-in numeric reductions such as `sum()`, `average()`, `summaryStatistics()`
- Common traps: understanding when results are primitives vs `OptionalInt`/`OptionalLong`/`OptionalDouble`

<a id="21102-common-creation-methods"></a>
### 21.10.2 Common creation methods

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

!!! important
    - Only `IntStream` and `LongStream` provide `range()` and `rangeClosed()`.
    - There is no `DoubleStream.range` because counting with doubles has rounding issues.

<a id="21103-primitive-specialized-mapping-methods"></a>
### 21.10.3 Primitive-specialized mapping methods

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


<a id="21104-mapping-table-among-streamt-and-primitive-streams"></a>
### 21.10.4 Mapping table among `Stream<T>` and primitive streams

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
		
!!! important
    - There is no **`unboxed()`** operation.
    - To go from wrappers to primitives you must start from `Stream<T>` and use `mapToInt` / `mapToLong` / `mapToDouble`.

<a id="21105-terminal-operations-and-their-result-types"></a>
### 21.10.5 Terminal operations and their result types

Primitive streams have several terminal operations that are either unique or have primitive-specific return types.


| Terminal operation | IntStream returns | LongStream returns | DoubleStream returns |
|--------------------|-------------------|--------------------|----------------------|
| `count()` | long | long | long |
| `sum()` | int | long | double |
| `min()` / max() | OptionalInt | OptionalLong | OptionalDouble |
| `average()` | OptionalDouble | OptionalDouble | OptionalDouble |
| `findFirst()` / findAny() | OptionalInt | OptionalLong | OptionalDouble |
| `reduce(op)` | OptionalInt | OptionalLong | OptionalDouble |
| `reduce(identity, op)` | int | long | double |
| `summaryStatistics()` | IntSummaryStatistics | LongSummaryStatistics | DoubleSummaryStatistics |
			
!!! warning
    - Even for `IntStream` and `LongStream`, **`average()`** returns `OptionalDouble` (not `OptionalInt` or `OptionalLong`).


- Example 1: `Stream<String>` → `IntStream` → primitive terminal operations.

```java
List<String> words = List.of("a", "bb", "ccc");

int totalLength = words.stream()
	.mapToInt(String::length) // IntStream
		.sum(); // int

// totalLength = 1 + 2 + 3 = 6
```

- Example 2: `IntStream` → boxed `Stream<Integer>` (boxing introduced).

```java
Stream<Integer> boxed = IntStream.rangeClosed(1, 3) // 1,2,3
	.boxed(); // Stream<Integer>
```

- Example 3: primitive stream → object stream via `mapToObj`.

```java
Stream<String> labels = IntStream.range(1, 4) // 1,2,3
	.mapToObj(i -> "N=" + i); // Stream<String>
```

<a id="21106-common-pitfalls-and-gotchas"></a>
### 21.10.6 Common pitfalls and gotchas

- Do not confuse `Stream<Integer>` with `IntStream`: their mapping methods and functional interfaces differ
- `IntStream.sum()` returns `int` but `IntStream.count()` returns `long`
- `average()` always returns `OptionalDouble` for all primitive stream types
- Using `boxed()` reintroduces boxing; only do it if the downstream API requires objects (e.g., collecting to `List<Integer>`)
- Be careful with narrowing conversions: `LongStream.mapToInt` and `DoubleStream.mapToInt` may truncate values

---

<a id="2111-collectors-collect-collector-and-the-collectors-factory-methods"></a>
## 21.11 Collectors (collect(), Collector, and the Collectors Factory Methods)

A `Collector` describes how to accumulate stream elements into a final result. 

The `collect(...)` terminal operation executes this recipe. 

The `Collectors` utility class provides ready-made collectors for common aggregation tasks.


<a id="21111-collect-vs-collector"></a>
### 21.11.1 collect() vs Collector

There are two main ways to collect:

- `collect(Collector)` → the common form using `Collectors.*`
- `collect(supplier, accumulator, combiner)` → explicit mutable reduction (lower-level)

```java
List<String> list =
Stream.of("a", "b")
	.collect(Collectors.toList());

StringBuilder sb =
Stream.of("a", "b")
	.collect(StringBuilder::new, StringBuilder::append, StringBuilder::append);
```

!!! note
    Use `collect(supplier, accumulator, combiner)` when you need a custom mutable container and do not want to implement a full `Collector`.

<a id="21112-core-collectors-quick-reference"></a>
### 21.11.2 Core collectors (quick reference)

These are the most frequently used collectors and the ones most likely to appear in exam questions.

- `toList()` → `List<T>` (no guarantees about mutability/implementation)
- `toSet()` → `Set<T>`
- `toCollection(supplier)` → specific collection type (e.g., `TreeSet`)
- `joining(delim, prefix, suffix)` → `String` from `CharSequence` elements
- `counting()` → `Long` count
- `summingInt` / `summingLong` / `summingDouble` → numeric sums
- `averagingInt` / `averagingLong` / `averagingDouble` → numeric averages
- `minBy(comparator)` / `maxBy(comparator)` → `Optional<T>`
- `mapping(mapper, downstream)` → transform then collect with downstream
- `filtering(predicate, downstream)` → filter inside collector (Java 9+)

<a id="21113-grouping-collectors"></a>
### 21.11.3 Grouping collectors

`groupingBy` classifies elements into buckets keyed by a classifier function. 

It produces a `Map<K, V>` where `V` depends on the downstream collector.

```java
Map<Integer, List<String>> byLen =
Stream.of("a", "bb", "ccc", "dd")
	.collect(Collectors.groupingBy(String::length));
System.out.println("byLen: " + byLen.toString());
```

Output:

```bash
byLen: {1=[a], 2=[bb, dd], 3=[ccc]}
```


With a downstream collector you control what each bucket contains:

```java
Map<Integer, Long> countByLen =
Stream.of("a", "bb", "ccc", "dd")
	.collect(Collectors.groupingBy(String::length, Collectors.counting()));
System.out.println("countByLen: " + countByLen.toString());

Map<Integer, Set<String>> setByLen =
Stream.of("a", "bb", "ccc", "dd")
	.collect(Collectors.groupingBy(String::length, Collectors.toSet()));
System.out.println("setByLen: " + setByLen.toString());
```

Output:

```bash
countByLen: {1=1, 2=2, 3=1}
setByLen: {1=[a], 2=[bb, dd], 3=[ccc]}
```


!!! warning
    Pay attention to the resulting map value type. Example: `groupingBy(..., counting())` yields `Map<K, Long>` (not `int`).

<a id="21114-partitioningby"></a>
### 21.11.4 partitioningBy

`partitioningBy` splits the stream into exactly two groups using a boolean predicate. It always returns a map with keys `true` and `false`.

```java
Map<Boolean, List<String>> parts =
Stream.of("a", "bb", "ccc")
.collect(Collectors.partitioningBy(s -> s.length() > 1));
System.out.println("parts: " + parts.toString());
```

Output:

```bash
parts: {false=[a], true=[bb, ccc]}
```

!!! note
    `partitioningBy` always creates two buckets, while `groupingBy` can create many. Both support downstream collectors.

<a id="21115-tomap-and-merge-rules"></a>
### 21.11.5 toMap and merge rules

`toMap` throws an exception on duplicate keys unless you provide a merge function.

```java
Map<Integer, String> m1 =
Stream.of("aa", "bb")
	.collect(Collectors.toMap(String::length, s -> s)); // ❌ Exception in thread "main" java.lang.IllegalStateException: Duplicate key 2 (attempted merging values aa and bb)

Map<Integer, String> m2 =
Stream.of("aa", "bb", "cc")
	.collect(Collectors.toMap(String::length, s -> s, (oldV, newV) -> oldV + "," + newV)); // key=2 merges values
```

Output:

```bash
m2: {2=aa,bb,cc}
```

<a id="21116-collectingandthen"></a>
### 21.11.6 collectingAndThen

`collectingAndThen(downstream, finisher)` lets you apply a final transformation after collecting (e.g., make the list unmodifiable).

```java
List<String> unmodifiable =
Stream.of("a", "b", "c")
	.collect(Collectors.collectingAndThen(Collectors.toList(), List::copyOf));
```

<a id="21117-how-collectors-relate-to-parallel-streams"></a>
### 21.11.7 How collectors relate to parallel streams

Collectors are designed to work with parallel streams by using supplier/accumulator/combiner internally. In parallel, each worker builds a partial result container and then merges containers.

- The accumulator mutates a per-thread container (no shared mutable state)
- The combiner merges containers (required for parallel execution)
- Some collectors are “concurrent” or have characteristics that affect performance and ordering

!!! note
    prefer `collect(Collectors.toList())` over using `reduce` to build collections. `reduce` is for immutable-style reductions; `collect` is for mutable containers.










