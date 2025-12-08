# Shared Collection Operations & Equality

This chapter covers the fundamental operations shared across the Java Collections API, including how equality is determined inside collections. These concepts apply to all main collection families (`List`, `Set`, `Queue`, `Deque`, `Map` and their Sequenced variants).

Mastering these operations is essential, as they explain how collections behave when adding, searching, removing, comparing, iterating, and sorting elements.

## 2.1 Core Collection Methods (Available to Most Collections)

The following methods come from the `Collection<E>` interface and are inherited by **all** major collections except `Map` (which has its own family of operations).

### 2.1.1 Mutating Operations

- `boolean add(E e)` — Adds an element (allowed to add duplicates in lists).
- `boolean remove(Object o)` — Removes the first matching element.
- `void clear()` — Removes all elements.
- `boolean addAll(Collection<? extends E> c)` — Bulk insertion. 
- `boolean removeAll(Collection<?> c)` — Removes all elements contained in the given collection.
- `boolean retainAll(Collection<?> c)` — Keeps only matching elements.

### 2.1.2 Query Operations

- `int size()` — Number of elements.
- `boolean isEmpty()` — Whether collection contains zero elements.
- `boolean contains(Object o)` — Relies on element equality rules.
- `Iterator<E> iterator()` — Returns an iterator (fail-fast).
- `Object[] toArray()` and `<T> T[] toArray(T[] a)` — Copy into an array.

## 2.2 Equality Rules — How Collections Decide If Two Elements Are “The Same”

It is now **critical** to understand **how Java determines whether an element is considered equal** inside a collection.

### 2.2.1 Equality for Objects

Collections rely on the `equals()` method to determine equality:

```java
String a = "hello";
String b = "hello";

System.out.println(a.equals(b)); // true
System.out.println(a == b); // may be true (string pool), but not guaranteed
```

> **Note:** Collections always use `equals()`, not `==`, except for special cases like `IdentityHashMap`.

### 2.2.2 Equality for Hash-Based Collections

Hash-based structures (HashSet, HashMap, LinkedHashSet, LinkedHashMap) use:

- `hashCode()` to locate a bucket
- `equals()` to compare elements inside the same bucket

Important rule:

> **Note:** When `equals()` is overridden, `hashCode()` must also be overridden so the contract remains valid.

### 2.2.3 Equality and Ordering Collections

Tree-based structures (TreeSet, TreeMap) use ordering, not equality.

- Ordering obtained via `Comparable` (natural order).
- Or via a provided `Comparator`.

> **Note:** In ordered sets and maps, two elements are considered “equal” if their comparison returns `0`.

## 2.3 Fail-Fast Behavior

Most collection iterators (except concurrent collections) are fail-fast: modifying a collection structurally while iterating triggers a `ConcurrentModificationException`.

```java
List<Integer> list = new ArrayList<>(List.of(1,2,3));
for (Integer i : list) {
list.add(99); // ❌ ConcurrentModificationException
}
```

> **Note:** Use `Iterator.remove()` when you must remove elements during iteration.

## 2.4 Bulk Operations (Java 21)

- `removeIf(Predicate<? super E> filter)` — Removes all matching items.
- `replaceAll(UnaryOperator<E> op)` — Replaces every element.
- `forEach(Consumer<? super E> action)` — Applies action to each element.
- `stream()` — Returns a stream for pipeline operations.

## 2.5 Common Return Types and Exceptions (Certification Must-Know)

- `add(E)` returns **boolean** — always `true` for `ArrayList`, may be `false` for `Set` if no change occurs.

- `remove(Object)` returns boolean (not the removed element!).

- `get(int)` throws `IndexOutOfBoundsException.

- `iterator().remove()` throws `IllegalStateException` if called twice without next().

- `toArray()` always returns a `Object[]` — not `T[]`.

## 2.6 Summary Table — Shared Operations

```text
Operation Applies To Notes
add(e) All collections except Map Lists allow duplicates
remove(o) All collections except Map Removes first occurrence
contains(o) All collections except Map Uses equals()
size(), isEmpty() All collections Constant-time for most
iterator() All collections Fail-fast
clear() All collections Removes all elements
stream() All collections Returns sequential stream
removeIf(), replaceAll() Lists, Sets, etc. Bulk operations
toArray() All collections Returns Object[]

```