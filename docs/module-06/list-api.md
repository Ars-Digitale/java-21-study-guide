# The List API

In the Collections Framework, a **List** represents an ordered, index-based, duplicate-allowing collection.


The List interface extends `Collection` and is implemented by:

- `ArrayList` — resizable array, fast random access, not thread-safe.
- `LinkedList` — doubly-linked list, fast insertions/removals, slower random access.
- `CopyOnWriteArrayList` — thread-safe, designed for heavy reads and rare writes.

## 3.1 Characteristics of Lists

- Ordered — elements preserve insertion order.
- Indexed — accessible via `get(int)` and `set(int,E)`.
- Allow duplicates — `List` does not enforce uniqueness.
- Can contain null — unless using special implementations.

## 3.2 Creating Lists (Constructors)

### 3.2.1 ArrayList Constructors

```java
List<String> a1 = new ArrayList<>();
List<String> a2 = new ArrayList<>(50); // initial capacity
List<String> a3 = new ArrayList<>(List.of("A", "B"));
```

> **Note:** Initial capacity is not a size. It just decides how many elements the internal array can hold before resizing.

### 3.2.2 LinkedList Constructors

```java
List<String> l1 = new LinkedList<>();
List<String> l2 = new LinkedList<>(List.of("A", "B"));
```

> **Note:** LinkedList also implements `Deque`.

## 3.3 Factory Methods

### 3.3.1 `List.of()` (immutable)

```java
List<String> list1 = List.of("A", "B", "C");
list1.add("X"); // ❌ UnsupportedOperationException
list1.set(0, "Z"); // ❌ UnsupportedOperationException
```

> **Note:** All `List.of()` lists:

- reject nulls
- are immutable
- throw `UOE` on structural modification

### 3.3.2 `List.copyOf()` (immutable copy)

```java
List<String> src = new ArrayList<>();
src.add("Hello");

List<String> copy = List.copyOf(src); // immutable snapshot
```

### 3.3.3 Arrays.asList() (fixed-size list)

```java
String[] arr = {"A", "B"};
List<String> list = Arrays.asList(arr);

list.set(0, "Z"); // OK
list.add("X"); // ❌ UOE — size is fixed
```

> **Note:** The list is backed by the array: modifying one affects the other.

## 3.4 Core List Operations

### 3.4.1 Adding Elements

```java
list.add("A");
list.add(1, "B"); // insert at index
list.addAll(otherList);
list.addAll(2, otherList);
```

### 3.4.2 Accessing Elements

```java
String x = list.get(0);
list.set(1, "NewValue");
```

> **Note:** `get()` throws `IndexOutOfBoundsException` for invalid indices.

### 3.4.3 Removing Elements

```java
list.remove(0); // removes by index
list.remove("A"); // removes first occurrence
list.removeIf(s -> s.startsWith("X"));
list.clear();
```

## 3.5 Iterating Through a List

### 3.5.1 Classic For Loop

```java
for (int i = 0; i < list.size(); i++) {
	System.out.println(list.get(i));
}
```

### 3.5.2 Enhanced For Loop

```java
for (String s : list) {
	System.out.println(s);
}
```

### 3.5.3 Iterator & ListIterator

```java
Iterator<String> it = list.iterator();
while (it.hasNext()) { System.out.println(it.next()); }

ListIterator<String> lit = list.listIterator();
while (lit.hasNext()) {
	if (lit.next().equals("A")) lit.set("Z");
}
```

> **Note:** Only `ListIterator` supports bidirectional traversal and modification.

## 3.6 Equality of Lists

`List.equals()` performs element-wise comparison in order.

```java
List<String> a = List.of("A", "B");
List<String> b = List.of("A", "B");

System.out.println(a.equals(b)); // true
```

> **Note:** Order matters. Duplicates matter. Type of list does NOT matter.

## 3.7 Common Certification Pitfalls

- `List.of()` rejects nulls.
- Arrays.asList() creates a fixed-size list.
- Removing by index vs. object: `remove(1)` vs `remove(Integer.valueOf(1))`.
- LinkedList random access is slow (O(n)).
- SubList is a view — modifying it affects the parent.

## 3.8 Summary Table of Important Operations

```text

| 	Operation		| 		ArrayList		| 		LinkedList 		| 		Immutable Lists 	|
|-------------------|-----------------------|-----------------------|---------------------------|
| add(E)			|	fast				|	fast				|	❌ unsupported			|
| add(index,E)		|	slow (shift)		|	fast				|	❌						|
| get(index)		|	fast				|	slow				|	fast					|
| remove(index)		|	slow (shift)		|	fast				|	❌						|
| remove(Object)	|	slower				|	slower				|	❌						|
| set(index,E)		|	fast				|	slow				|	❌						|
| iterator()		|	fast				|	fast				|	fast					|
| listIterator()	|	fast				|	fast				|	fast					|
| contains(Object)	|	O(n)				|	O(n)				|	O(n)					|
```		