# Sequenced Collections & Sequenced Maps (Java 21)

Java 21 introduces Sequenced Collections and Sequenced Maps to unify and formalize access to elements based on their encounter order.
This addition solves long-standing inconsistencies between lists, sets, queues, deques, and maps, providing a common API to work with the first and last elements, as well as reversed views.

## 1. Motivation and Background

Before Java 21, ordered collections (such as List, LinkedHashSet, Deque, or LinkedHashMap) exposed ordering operations through different methods or not at all.
Developers had to rely on implementation-specific APIs or indirect workarounds.

Sequenced interfaces introduce a consistent contract for all ordered collections and maps, making order-based operations explicit, safe, and uniform.

## 2. SequencedCollection Interface

SequencedCollection<E> is a new interface that extends Collection<E> and represents collections with a well-defined encounter order.

It is implemented by all ordered collections such as List, Deque, and ordered Set implementations.

### 2.1 Core Methods of SequencedCollection

The interface defines methods to access and manipulate elements at both ends of the collection.

|	Method	|	Description		|
|-----------|-------------------|
|	E getFirst()	|	Returns the first element |
|	E getLast()	|	Returns the last element |
|	void addFirst(E e)	|	Inserts element at the beginning |
|	void addLast(E e)	|	Inserts element at the end |
|	E removeFirst()	|	Removes and returns the first element |
|	E removeLast(	|	Removes and returns the last element |
|	SequencedCollection<E> reversed()	|	Returns a reversed view |

### 2.2 Implementations of SequencedCollection

The following standard types implement SequencedCollection:

|	Type	|	Notes  |
|-----------|----------|
List	|	Ordered by index |
Deque	|	Double-ended queue |
LinkedHashSet	|	Maintains insertion order |

### 2.3 Reversed Views

Calling reversed() does not create a copy.
It returns a live view of the same collection with inverted order.

```java
List<Integer> list = new ArrayList<>(List.of(1, 2, 3));
SequencedCollection<Integer> rev = list.reversed();

rev.removeFirst(); // removes 3
System.out.println(list); // [1, 2]
```

> **Note:** Modifying either the original collection or the reversed view affects the other.

## 3. SequencedMap Interface

SequencedMap<K,V> extends Map<K,V> and represents maps with a defined encounter order of entries.

It standardizes operations that previously existed only in specific implementations such as LinkedHashMap.

### 3.1 Core Methods of SequencedMap

Method	Description
Entry<K,V> firstEntry()	First map entry
Entry<K,V> lastEntry()	Last map entry
Entry<K,V> pollFirstEntry()	Removes and returns first entry
Entry<K,V> pollLastEntry()	Removes and returns last entry
SequencedMap<K,V> reversed()	Reversed view of the map

### 3.2 Implementations of SequencedMap

Currently, the primary standard implementation is:

|	Type  |	Ordering	|
|---------|-------------|
|	LinkedHashMap  |	Insertion order (or access order if configured) |

### 3.3 Reversed Maps

As with collections, reversed() on a sequenced map returns a view, not a copy.

```java
SequencedMap<String, Integer> map =
new LinkedHashMap<>(Map.of("A", 1, "B", 2, "C", 3));

SequencedMap<String, Integer> rev = map.reversed();

rev.pollFirstEntry(); // removes C=3
System.out.println(map); // {A=1, B=2}
```

## 4. Relationship with Existing APIs

Sequenced interfaces do not replace existing collection types.
They sit above them in the hierarchy and unify common behaviors.

All existing ordered collections automatically benefit from these APIs without breaking backward compatibility.

## 5. Common Pitfalls

Sequenced interfaces define views, not copies

reversed() reflects changes bidirectionally

Not all Set or Map implementations are sequenced

HashSet and HashMap do not implement sequenced interfaces

Order is guaranteed only when explicitly defined

## 6. Summary

- Sequenced interfaces formalize encounter order
- They provide first/last access and reversal
- They work via live views, not copies
- They unify APIs across lists, deques, sets, and maps
- They are a key Java 21 certification topic