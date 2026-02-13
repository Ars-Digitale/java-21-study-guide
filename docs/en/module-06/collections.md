# 22. Introduction to the Collections Framework

### Table of Contents

- [22. Introduction to the Collections Framework](#22-introduction-to-the-collections-framework)
  - [22.1 What Is the Collections Framework](#221-what-is-the-collections-framework)
  - [22.2 The Core Interfaces](#222-the-core-interfaces)
    - [22.2.1 Main Collection Interfaces](#2221-main-collection-interfaces)
    - [22.2.2 Map Hierarchy](#2222-map-hierarchy)
  - [22.3 Sequenced Collections Java-21](#223-sequenced-collections-java-21)
  - [22.4 Why the Collections Framework Exists](#224-why-the-collections-framework-exists)
  - [22.5 The Two Sides of the Framework Collections-vs-Maps](#225-the-two-sides-of-the-framework-collections-vs-maps)
  - [22.6 Generic Types in the Collections Framework](#226-generic-types-in-the-collections-framework)
  - [22.7 Mutability vs Immutability](#227-mutability-vs-immutability)
  - [22.8 Big-O Performance Expectations](#228-big-o-performance-expectations)
  - [22.9 Summary](#229-summary)

---

The `Java Collections Framework (JCF)` is a set of **interfaces, classes, and algorithms** designed to store, manipulate, and process groups of data efficiently.

It provides a unified architecture for handling collections, allowing developers to write reusable, interoperable code with predictable behaviors and performance characteristics.

This chapter introduces the foundational concepts needed before studying Lists, Sets, Queues, Maps, and Sequenced Collections, explored in detail in subsequent chapters.

## 22.1 What Is the Collections Framework?

The Collections Framework provides:

- A **set of interfaces** (Collection, List, Set, Queue, Deque, Map…)
- A **set of implementations** (ArrayList, HashSet, TreeSet, LinkedList…)
- A **set of utility algorithms** (sorting, searching, copying, reversing…) in java.util.Collections and java.util.Arrays.
- A common language for performance expectations (Big-O complexity).

All major collection structures share a consistent design so that code working with one implementation can often be reused with another.

---

## 22.2 The Core Interfaces

At the heart of the Java Collections Framework is a small set of **root interfaces** that define generic data-handling behaviors.

- **List**: an `ordered` collection of elements that allows `duplicates`;
- **Set**: a collection that does not allow `duplicates`;
- **Queue**: a collection designed for holding elements prior to processing, typically FIFO (first-in-first-out), with variants like priority queues and deques.
- **Map**: a structure that maps keys to values, where duplicate keys are not allowed; each key can map to at most one value.


### 22.2.1 Main Collection Interfaces

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
│ │ 	│ 			└─ TreeSet<E>
│ │ 	├─ HashSet<E>
│ │ 	└─ (other Set implementations)
│ ├─ Queue<E>
│ │ 	├─ Deque<E> (already under SequencedCollection<E>)
│ │ 	├─ PriorityQueue<E>
│ │ 	└─ (other Queue implementations)
│ └─ (other Collection implementations)
│
└─ Map<K,V> (not a Collection)
	├─ SequencedMap<K,V> (Java 21+)
	│ 	└─ LinkedHashMap<K,V>
	├─ SortedMap<K,V>
	│ 	└─ NavigableMap<K,V>
	│ 	└─ TreeMap<K,V>
	├─ HashMap<K,V>
	├─ Hashtable<K,V>
	└─ (other Map/ConcurrentMap implementations)
```

The **Map** interface does not extend Collection because a map stores key/value pairs rather than single values.

### 22.2.2 Map Hierarchy

```text
java.util
└─ Map<K,V>
	├─ SequencedMap<K,V> (Java 21+)
	│ 	└─ LinkedHashMap<K,V>
	├─ SortedMap<K,V>
	│ 	└─ NavigableMap<K,V>
	│ 		└─ TreeMap<K,V>
	├─ HashMap<K,V>
	├─ Hashtable<K,V>
	└─ ConcurrentMap<K,V> (java.util.concurrent)
		└─ ConcurrentHashMap<K,V>
```

---

## 22.3 Sequenced Collections (Java 21+)

Java 21 introduces the new interface `SequencedCollection`, which formalizes the idea that a collection maintains a **defined encounter order**.
This was already true for List, LinkedHashSet, LinkedHashMap, Deque, etc., but now the behavior is standardized.

- `SequencedCollection` defines methods like `getFirst()`, `getLast()`, `addFirst()`, `addLast()`, `removeFirst()`, `removeLast()`, and `reversed()`.
- SequencedSet, SequencedMap extend the idea for sets and maps.

This drastically simplifies the specification of ordering behaviors and will be used throughout the following chapters.

---

## 22.4 Why the Collections Framework Exists

- Avoid reinventing data structures
- Provide well-tested, high-performance algorithms
- Improve interoperability through shared interfaces
- Support generic types for type-safe collections

Before Java 1.2, data structures were ad-hoc, inconsistent, and untyped. 

The Collections Framework unified all of this into a consistent API.

---

## 22.5 The Two Sides of the Framework: Collections vs. Maps

“Does Map extend Collection?”
**No.**
A Map stores **pairs**, while a Collection stores **single elements**.

- Collection = List, Set, Queue, Deque, SequencedCollection
- Map = Dictionary-like key/value store

---

## 22.6 Generic Types in the Collections Framework

Collections are almost always used with generics. Using raw types is discouraged.

```java
List<String> names = new ArrayList<>();
Map<Integer, String> map = new HashMap<>();
```

!!! note
    Generics in collections work through `type erasure`: Please check the Paragraph "**18.4 Type Erasure**" in Chapter: [18. Generics in Java](../module-04/generics.md).

## 22.7 Mutability vs. Immutability

Many methods in the Collections API return **unmodifiable** collections:

```java
List<String> immutable = List.of("a", "b");
immutable.add("c"); // ❌ UnsupportedOperationException
```

Java provides several ways to create immutable collections:

- `List.of()`, `Set.of()`, `Map.of()`
- `List.copyOf(collection)`
- `Collections.unmodifiableList(...)` wrappers
- `Records` used as immutable value containers

!!! note
    The method `Arrays.asList(varargs)`, which is backed by an array, behaves differently: see examples below.

```java

String[] vargs = new String[] {"u", "v", "z"};
List<String> fromAsList = Arrays.asList(vargs);

List<String> immutable1 = List.of(vargs);
immutable1.add("c"); // ❌ UnsupportedOperationException

List<String> immutable2 = List.copyOf(fromAsList);
immutable2.set(0, "k"); // ❌ UnsupportedOperationException


// We can't ADD or REMOVE elements from "fromAsList" but we can replace them,
// either by modifying the underlying array "vargs" or by mutating the list itself:


fromAsList.set(0, "k");  // the update will be reflected on the backing array as well.
```

!!! note
    `Arrays.asList(...)` returns a fixed-size, but **mutable**, List view backed by the original array.
    You cannot add/remove elements, but you can replace existing ones.


## 22.8 Big-O Performance Expectations

Understanding complexity is essential. Here are common examples:

| Type | Methods | Complexity |
| ---- | ---- | ---- |
| ArrayList | `get()`, `add()`, `remove()` | **`O(1)`**, **`amortized O(1)`**, **`O(n)`**  |
| LinkedList | `get()`, `add/remove first/last` | **`O(n)`**,  **`O(1)`** |
| HashSet | `add()`, `contains()`, `remove()` |   ~ **`O(1)`** |
| TreeSet | `add()`, `contains()`, `remove()`  | **`O(log n)`**  |
| HashMap | `get()/put()`  | ~ **`O(1) on average`**  |
| TreeMap | `get()/put()`  |  **`O(log n)`** |
| Deque | `add/remove first/last`  | **`O(1)`**  |


!!! note
    These values are averages; worst-case may be different (especially for hash-based structures).


## 22.9 Summary

- The Collection Framework is built on a small set of core interfaces.
- Java 21 adds Sequenced Collections to unify ordering behavior.
- Maps are not Collections — they form a parallel hierarchy.
- Collections rely heavily on generics.
- Mutability matters — factory methods often return immutable collections.
- Performance characteristics are predictable.
