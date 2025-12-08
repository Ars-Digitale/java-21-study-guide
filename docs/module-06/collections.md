# Introduction to the Collections Framework

The Java Collections Framework (JCF) is a set of **interfaces, classes, and algorithms** designed to store, manipulate, and process groups of data efficiently.

It provides a unified architecture for handling collections, allowing developers to write reusable, interoperable code with predictable behaviors and performance characteristics.

This chapter introduces the foundational concepts needed before studying Lists, Sets, Queues, Maps, and Sequenced Collections, explored in detail in subsequent chapters.

## 1. What Is the Collections Framework?

The Collections Framework provides:

- A **set of interfaces** (Collection, List, Set, Queue, Deque, Map…)
- A **set of implementations** (ArrayList, HashSet, TreeSet, LinkedList…)
- A **set of utility algorithms** (sorting, searching, copying, reversing…) in java.util.Collections and java.util.Arrays.
- A common language for performance expectations (Big-O complexity).

All major collection structures share a consistent design so that code working with one implementation can often be reused with another.

## 2. The Core Interfaces (Hierarchy Overview)

At the heart of the Java Collections Framework is a small set of **root interfaces** that define generic data-handling behaviors.

### 2.1 Main Collection Interfaces

Below is the conceptual hierarchy.

```text
java.util
├─ Collection<E>
│ ├─ SequencedCollection<E> (Java 21+)
│ │ ├─ List<E>
│ │ │ 	├─ ArrayList<E>
│ │ │ 	└─ LinkedList<E> (also implements Deque<E>)
│ │ └─ Deque<E> (also extends Queue<E>)
│ │ 	├─ ArrayDeque<E>
│ │ 	└─ LinkedList<E>
│ ├─ Set<E>
│ │ 	├─ SequencedSet<E> (Java 21+)
│ │ 	│ 		└─ LinkedHashSet<E>
│ │ 	├─ SortedSet<E>
│ │ 	│ 		└─ NavigableSet<E>
│ │ 	│ 		└─ TreeSet<E>
│ │ 	├─ HashSet<E>
│ │ 	└─ (other Set implementations)
│ ├─ Queue<E>
│ │ 	├─ Deque<E> (already under SequencedCollection<E>)
│ │ 	├─ PriorityQueue<E>
│ │ 	└─ (other Queue implementations)
│ └─ (other Collection implementations)
└─ Map<K,V> (not a Collection)
	├─ SequencedMap<K,V> (Java 21+)
	│ └─ LinkedHashMap<K,V>
	├─ SortedMap<K,V>
	│ └─ NavigableMap<K,V>
	│ └─ TreeMap<K,V>
	├─ HashMap<K,V>
	├─ Hashtable<K,V>
	└─ (other Map/ConcurrentMap implementations)
```

The **Map** interface does not extend Collection because a map stores key/value pairs rather than single values.

### 2.2 Map Hierarchy

```text
java.util
└─ Map<K,V>
	├─ SequencedMap<K,V> (Java 21+)
	│ 	└─ LinkedHashMap<K,V>
	├─ SortedMap<K,V>
	│ 	└─ NavigableMap<K,V>
	│ 	└─ TreeMap<K,V>
	├─ HashMap<K,V>
	├─ Hashtable<K,V>
		└─ ConcurrentMap<K,V> (java.util.concurrent)
		└─ ConcurrentHashMap<K,V>
```

## 3. Sequenced Collections (Java 21+)

Java 21 introduces the new interface `SequencedCollection`, which formalizes the idea that a collection maintains a **defined encounter order**.
This was already true for List, LinkedHashSet, LinkedHashMap, Deque, etc., but now the behavior is standardized.

- SequencedCollection: defines `getFirst()`, `getLast()`, `addFirst()`, `addLast()`.
- SequencedSet, SequencedMap extend the idea for sets and maps.

This drastically simplifies the specification of ordering behaviors and will be used throughout the following chapters.

## 4. Why the Collections Framework Exists

- Avoid reinventing data structures
- Provide well-tested, high-performance algorithms
- Improve interoperability through shared interfaces
- Support generic types for type-safe collections

Before Java 1.2, data structures were ad-hoc, inconsistent, and untyped. The Collections Framework unified all of this into a consistent API.

## 5. The Two Sides of the Framework: Collections vs. Maps

A common certification question: “Does Map extend Collection?”
**No.**
A Map stores **pairs**, while a Collection stores **single elements**.

- Collection = List, Set, Queue, Deque, SequencedCollection
- Map = Dictionary-like key/value store

## 6. Generic Types in the Collections Framework

Collections are almost always used with generics. Using raw types is discouraged and often tested on the exam.

```java
List<String> names = new ArrayList<>();
Map<Integer, String> map = new HashMap<>();
```

> **Note:** Generics in collections work through type erasure — explained deeply in the Generics chapter.

## 7. Mutability vs. Immutability

Many methods in the Collections API return **unmodifiable** collections:

```java
List<String> immutable = List.of("a", "b");
immutable.add("c"); // ❌ UnsupportedOperationException
```

Java provides several ways to create immutable collections:

- List.of(), Set.of(), Map.of()
- Collections.unmodifiableList(...) wrappers
- Records used as immutable value containers

## 8. Big-O Performance Expectations

Understanding complexity is essential for the exam. Here are common examples:

```text
ArrayList: get() O(1), add() amortized O(1), remove() O(n)
LinkedList: get() O(n), add/remove first/last O(1)
HashSet: add(), contains(), remove() ~ O(1)
TreeSet: add(), contains(), remove() O(log n)
HashMap: get()/put() ~ O(1)
TreeMap: get()/put() O(log n)
Deque: add/remove first/last O(1)
```

> **Note:** These values are averages; worst-case may be different (especially for hash-based structures).

## 9. Common Exceptions in Collection Operations

- UnsupportedOperationException — modifying an unmodifiable collection
- ClassCastException — incompatible element or key types
- NullPointerException — certain implementations forbid null (e.g., TreeMap keys)
- ConcurrentModificationException — structural modification during iteration

## 10. Summary of Chapter 1

- The Collection Framework is built on a small set of core interfaces.
- Java 21 adds Sequenced Collections to unify ordering behavior.
- Maps are not Collections — they form a parallel hierarchy.
- Collections rely heavily on generics.
- Mutability matters — factory methods often return immutable collections.
- Performance characteristics are predictable and must be known for the exam.
