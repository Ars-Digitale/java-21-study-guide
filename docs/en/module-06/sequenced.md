# 29. Sequenced Collections & Sequenced Maps

### Table of Contents

- [29. Sequenced Collections & Sequenced Maps](#29-sequenced-collections--sequenced-maps)
  - [29.1 Motivation and Background](#291-motivation-and-background)
  - [29.2 SequencedCollection Interface](#292-sequencedcollection-interface)
    - [29.2.1 Core Methods of SequencedCollection](#2921-core-methods-of-sequencedcollection)
    - [29.2.2 Implementations of SequencedCollection](#2922-implementations-of-sequencedcollection)
    - [29.2.3 Reversed Views](#2923-reversed-views)
  - [29.3 SequencedMap Interface](#293-sequencedmap-interface)
    - [29.3.1 Core Methods of SequencedMap](#2931-core-methods-of-sequencedmap)
    - [29.3.2 Implementations of SequencedMap](#2932-implementations-of-sequencedmap)
    - [29.3.3 Reversed Maps](#2933-reversed-maps)
  - [29.4 Relationship with Existing APIs](#294-relationship-with-existing-apis)
    - [29.4.1 Which Built-in Types Are Sequenced](#2941-which-built-in-types-are-sequenced)
  - [29.5 Common Pitfalls](#295-common-pitfalls)
  - [29.6 Summary](#296-summary)

---

Java 21 introduces `Sequenced Collections` and `Sequenced Maps` to unify and formalize access to elements based on their encounter order.
This addition solves long-standing inconsistencies between lists, sets, queues, deques, and maps, providing a common API to work with the first and last elements, as well as reversed views.

## 29.1 Motivation and Background

Before Java 21, ordered collections (such as List, LinkedHashSet, Deque, or LinkedHashMap) exposed ordering operations through different methods or not at all.
Developers had to rely on implementation-specific APIs or indirect workarounds.

Sequenced interfaces introduce a consistent contract for all ordered collections and maps, making order-based operations explicit, safe, and uniform.

## 29.2 SequencedCollection Interface

SequencedCollection<E> is a new interface that extends Collection<E> and represents collections with a well-defined encounter order.

Implemented by List, Deque, and LinkedHashSet (TreeSet is ordered but does not implement SequencedCollection directly).


### 29.2.1 Core Methods of SequencedCollection

The interface defines methods to access and manipulate elements at both ends of the collection.

|	Method	|	Description		|
|-----------|-------------------|
|	E getFirst()	|	Returns the first element |
|	E getLast()	|	Returns the last element |
|	void addFirst(E e)	|	Inserts element at the beginning |
|	void addLast(E e)	|	Inserts element at the end |
|	E removeFirst()	|	Removes and returns the first element |
|	E removeLast()	|	Removes and returns the last element |
|	SequencedCollection<E> reversed()	|	Returns a reversed view |

### 29.2.2 Implementations of SequencedCollection

The following standard types implement SequencedCollection:

|	Type	|	Notes  |
|-----------|----------|
List	|	Ordered by index |
Deque	|	Double-ended queue |
LinkedHashSet	|	Maintains insertion order |

### 29.2.3 Reversed Views

Calling reversed() does not create a copy.
It returns a live view of the same collection with inverted order.

```java
List<Integer> list = new ArrayList<>(List.of(1, 2, 3));
SequencedCollection<Integer> rev = list.reversed();

rev.removeFirst(); // removes 3
System.out.println(list); // [1, 2]
```

> [!NOTE]
> Reversed views share the same backing collection. Structural changes in either view affect the other:
> modifying either the original collection or the reversed view affects the other.

## 29.3 SequencedMap Interface

SequencedMap<K,V> extends Map<K,V> and represents maps with a defined encounter order of entries.

It standardizes operations that previously existed only in specific implementations such as LinkedHashMap.

### 29.3.1 Core Methods of SequencedMap

| Method | Description |
|--------|-------------|
|Entry<K,V> firstEntry() | First map entry |
|Entry<K,V> lastEntry() | Last map entry |
|Entry<K,V> pollFirstEntry() | Removes and returns the first entry, or null if empty |
|Entry<K,V> pollLastEntry() | Removes and returns last entry, or null if empty  |
|SequencedMap<K,V> reversed() | Reversed view of the map |

### 29.3.2 Implementations of SequencedMap

Currently, the primary standard implementation is:

|	Type  |	Ordering	|
|---------|-------------|
|	LinkedHashMap  |	Insertion order (or access order if configured) |

> [!NOTE]
> LinkedHashMap can reorder entries on read if constructed with accessOrder=true.
> In that case, “first” and “last” reflect most-recent-access order.

### 29.3.3 Reversed Maps

As with collections, reversed() on a sequenced map returns a view, not a copy.

```java
SequencedMap<String, Integer> map =
new LinkedHashMap<>(Map.of("A", 1, "B", 2, "C", 3));

SequencedMap<String, Integer> rev = map.reversed();

rev.pollFirstEntry(); // removes C=3
System.out.println(map); // {A=1, B=2}
```

> [!NOTE]
> Like SequencedCollection, reversed() returns a live view — mutations apply to both maps.


## 29.4 Relationship with Existing APIs

Sequenced interfaces do not replace existing collection types.
They sit above them in the hierarchy and unify common behaviors.

All existing ordered collections automatically benefit from these APIs without breaking backward compatibility.

### 29.4.1 Which Built-in Types Are Sequenced?

The following table summarizes whether standard collection types are ordered,
and whether they implement the new Sequenced interfaces.

| Type               | Ordered? | SequencedCollection? | SequencedMap? |
|-------------------|----------|----------------------|----------------|
| List              | ✔ Yes    | ✔ Yes                | ✘ No           |
| Deque             | ✔ Yes    | ✔ Yes                | ✘ No           |
| LinkedHashSet     | ✔ Yes    | ✔ Yes                | ✘ No           |
| TreeSet           | ✔ Yes (sorted) | ✘ No*        | ✘ No           |
| HashSet           | ✘ No     | ✘ No                 | ✘ No           |
| LinkedHashMap     | ✔ Yes    | ✘ No                 | ✔ Yes          |
| HashMap           | ✘ No     | ✘ No                 | ✘ No           |
| TreeMap           | ✔ Yes (sorted) | ✘ No        | ✘ No           |

> [!NOTE]
> TreeSet is ordered, but implements `SortedSet`/`NavigableSet`, not `SequencedCollection`.

## 29.5 Common Pitfalls

- Sequenced interfaces define views, not copies
- reversed() reflects changes bidirectionally
- Not all Set or Map implementations are sequenced
- HashSet and HashMap do not implement sequenced interfaces
- Order is guaranteed only when explicitly defined
- Removing elements via iterator on reversed view impacts original order immediately.


## 29.6 Summary

- Sequenced interfaces formalize encounter order
- They provide first/last access and reversal
- They work via live views, not copies
- They unify APIs across lists, deques, sets, and maps
- They are a key Java 21 certification topic