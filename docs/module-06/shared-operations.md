# 23. Shared Collection Operations & Equality

### Table of Contents

- [23. Shared Collection Operations & Equality](#23-shared-collection-operations--equality)
  - [23.1 Core Collection Methods Available to Most Collections](#231-core-collection-methods-available-to-most-collections)
    - [23.1.1 Mutating Operations](#2311-mutating-operations)
    - [23.1.2 Query Operations](#2312-query-operations)
  - [23.2 Equality](#232-equality)
  - [23.3 Fail-Fast Behavior](#233-fail-fast-behavior)
  - [23.4 Bulk Operations Java-21](#234-bulk-operations-java-21)
  - [23.5 Common Return Types and Exceptions](#235-common-return-types-and-exceptions)
  - [23.6 Summary Table — Shared Operations](#236-summary-table--shared-operations)

---

This chapter covers the fundamental operations shared across the Java Collections API, including how equality is determined inside collections. These concepts apply to all main collection families (`List`, `Set`, `Queue`, `Deque`, `Map` and their Sequenced variants).

Mastering these operations is essential, as they explain how collections behave when adding, searching, removing, comparing, iterating, and sorting elements.

## 23.1 Core Collection Methods (Available to Most Collections)

The following methods come from the `Collection<E>` interface and are inherited by **all** major collections except `Map` (which has its own family of operations).

### 23.1.1 Mutating Operations

- `boolean add(E e)` — Adds an element (allowed to add duplicates in lists).
- `boolean remove(Object o)` — Removes the first matching element.
- `void clear()` — Removes all elements.
- `boolean addAll(Collection<? extends E> c)` — Bulk insertion. 
- `boolean removeAll(Collection<?> c)` — Removes all elements contained in the given collection.
- `boolean retainAll(Collection<?> c)` — Keeps only matching elements.

### 23.1.2 Query Operations

- `int size()` — Number of elements.
- `boolean isEmpty()` — Whether collection contains zero elements.
- `boolean contains(Object o)` — Relies on element equality rules.
- `Iterator<E> iterator()` — Returns an iterator (fail-fast).
- `Object[] toArray()` and `<T> T[] toArray(T[] a)` — Copy into an array.

## 23.2 Equality

A custom implementation of the method `equals()` allows us to compare the type and content of two collections.

The implementation will differ depending if we are dealing with Lists or Sets.

Example

```java
List<Integer> firstList = List.of(10, 11, 22);
List<Integer> secondList = List.of(10, 11, 22);
List<Integer> thirdList = List.of(22, 11, 10);

System.out.println("firstList.equals(secondList): " + firstList.equals(secondList));
System.out.println("secondList.equals(thirdList): " + secondList.equals(thirdList));

Set<Integer> firstSet = Set.of(10, 11, 22);
Set<Integer> secondSet = Set.of(10, 11, 22);
Set<Integer> thirdSet = Set.of(22, 11, 10);

System.out.println("firstSet.equals(secondSet): " + firstSet.equals(secondSet));
System.out.println("secondSet.equals(thirdSet): " + secondSet.equals(thirdSet));
```

Output

```bash
firstList.equals(secondList): true
secondList.equals(thirdList): false
firstSet.equals(secondSet): true
secondSet.equals(thirdSet): true
```

## 23.3 Fail-Fast Behavior

Most collection iterators (except concurrent collections) are fail-fast: modifying a collection structurally while iterating triggers a `ConcurrentModificationException`.

```java
List<Integer> list = new ArrayList<>(List.of(1,2,3));
for (Integer i : list) {
list.add(99); // ❌ ConcurrentModificationException
}
```

> **Note:** Use `Iterator.remove()` when you must remove elements during iteration.

## 23.4 Bulk Operations (Java 21)

- `removeIf(Predicate<? super E> filter)` — Removes all matching items.
- `replaceAll(UnaryOperator<E> op)` — Replaces every element.
- `forEach(Consumer<? super E> action)` — Applies action to each element.
- `stream()` — Returns a stream for pipeline operations.

## 23.5 Common Return Types and Exceptions

- `add(E)` returns **boolean** — always `true` for `ArrayList`, may be `false` for `Set` if no change occurs.

- `remove(Object)` returns boolean (not the removed element!).

- `get(int)` throws `IndexOutOfBoundsException.

- `iterator().remove()` throws `IllegalStateException` if called twice without next().

- `toArray()` always returns a `Object[]` — not `T[]`.

## 23.6 Summary Table — Shared Operations


|	Operation 					|	Applies						|	 To Notes					|
|-------------------------------|-------------------------------|-------------------------------|
|	`add(e)`					|	All collections except Map 	|	Lists allow duplicates		|
|	`remove(o)`					|	All collections except Map 	|	Removes first occurrence	|
|	`contains(o)`				|	All collections except Map 	|	Uses equals()				|
|	`size(), isEmpty()`			|	All collections 			|	Constant-time for most		|
|	`iterator()` 				|	All collections 			|	Fail-fast					|
|	`clear()` 					|	All collections 			|	Removes all elements		|
|	`stream()` 					|	All collections 			|	Returns sequential stream	|
|	`removeIf(), replaceAll()`	| 	Lists, Sets, etc. 			|	Bulk operations				|
|	`toArray()` 				|	All collections 			|	Returns Object[]			|