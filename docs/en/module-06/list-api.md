# 25. The List API

### Table of Contents

- [25. The List API](#25-the-list-api)
  - [25.1 Characteristics of Lists](#251-characteristics-of-lists)
  - [25.2 Creating Lists Constructors](#252-creating-lists-constructors)
    - [25.2.1 ArrayList Constructors](#2521-arraylist-constructors)
    - [25.2.2 LinkedList Constructors](#2522-linkedlist-constructors)
  - [25.3 Factory Methods](#253-factory-methods)
    - [25.3.1 List of immutable](#2531-listof-immutable)
    - [25.3.2 List copyOf immutable-copy](#2532-listcopyof-immutable-copy)
    - [25.3.3 Arrays asList fixed-size-list](#2533-arraysaslist-fixed-size-list)
  - [25.4 Core List Operations](#254-core-list-operations)
    - [25.4.1 Adding Elements](#2541-adding-elements)
    - [25.4.2 Accessing Elements](#2542-accessing-elements)
    - [25.4.3 Removing Elements](#2543-removing-elements)
    - [25.4.4 Important Behaviors and Characteristics](#2544-important-behaviors-and-characteristics)
  - [25.5 contains, equals and hashCode](#255-contains-equals-and-hashcode)
    - [25.5.1 contains](#2551-contains)
    - [25.5.2 Equality of Lists](#2552-equality-of-lists)
    - [25.5.3 hashCode](#2553-hashcode)
  - [25.6 Iterating Through a List](#256-iterating-through-a-list)
    - [25.6.1 Classic For Loop](#2561-classic-for-loop)
    - [25.6.2 Enhanced For Loop](#2562-enhanced-for-loop)
    - [25.6.3 Iterator--ListIterator](#2563-iterator--listiterator)
  - [25.7 The subList Method](#257-the-sublist-method)
    - [25.7.1 Syntax](#2571-syntax)
    - [25.7.2 Rules](#2572-rules)
    - [25.7.3 Examples](#2573-examples)
    - [25.7.4 Modifying the parent list invalidates the view](#2574-modifying-the-parent-list-invalidates-the-view)
    - [25.7.5 Modifying the subList modifies the parent](#2575-modifying-the-sublist-modifies-the-parent)
    - [25.7.6 Clearing the subList clears part of the parent list](#2576-clearing-the-sublist-clears-part-of-the-parent-list)
    - [25.7.7 Common Pitfalls](#2577-common-pitfalls)
  - [25.8 Summary Table of Important Operations](#258-summary-table-of-important-operations)

---

In the `Collections Framework`, a **List** represents an ordered, index-based, duplicate-allowing collection.


The List interface extends `Collection` and is implemented by:

```text
List
├── ArrayList (Resizable array — fast random access, slower inserts/removals in the middle)
├── LinkedList (Doubly-linked list — fast inserts/removals, slower random access)
└── Vector (Legacy synchronized list — rarely used today)
```

> [!NOTE]
> Vector is legacy and synchronized — avoid unless explicitly required.

## 25.1 Characteristics of Lists

- Ordered — elements preserve insertion order.
- Indexed — accessible via `get(int)` and `set(int,E)`.
- Allow duplicates — `List` does not enforce uniqueness.
- Can contain `null` — unless using special implementations.

---

## 25.2 Creating Lists (Constructors)

### 25.2.1 ArrayList Constructors

```java
List<String> a1 = new ArrayList<>();
List<String> a2 = new ArrayList<>(50); // initial capacity
List<String> a3 = new ArrayList<>(List.of("A", "B"));
```

> [!NOTE]
> Initial capacity is not a size. It just decides how many elements the internal array can hold before resizing.

### 25.2.2 LinkedList Constructors

```java
List<String> l1 = new LinkedList<>();
List<String> l2 = new LinkedList<>(List.of("A", "B"));
```

> [!NOTE]
> `LinkedList` also implements `Deque`.

---

## 25.3 Factory Methods

### 25.3.1 `List.of()` (immutable)

```java
List<String> list1 = List.of("A", "B", "C");
list1.add("X"); // ❌ UnsupportedOperationException
list1.set(0, "Z"); // ❌ UnsupportedOperationException
```

> [!NOTE]
> All `List.of()` lists:
> - reject `nulls`
> - are immutable
> - throw `UOE` on structural modification

### 25.3.2 `List.copyOf()` (immutable copy)

```java
List<String> src = new ArrayList<>();
src.add("Hello");

List<String> copy = List.copyOf(src); // immutable snapshot
```

### 25.3.3 Arrays.asList() (fixed-size list)

```java
String[] arr = {"A", "B"};
List<String> list = Arrays.asList(arr);

list.set(0, "Z"); // OK
list.add("X"); // ❌ UOE — size is fixed
```

> [!NOTE]
> The list is backed by the array: modifying one affects the other.

---

## 25.4 Core List Operations

### 25.4.1 Adding Elements

```java
list.add("A");
list.add(1, "B"); // insert at index
list.addAll(otherList);
list.addAll(2, otherList);
```

### 25.4.2 Accessing Elements

```java
String x = list.get(0);
list.set(1, "NewValue");
```

> [!NOTE]
> `get()` throws `IndexOutOfBoundsException` for invalid indices.

If you try to `update` an element in an empty List, even at index 0, you get an `IndexOutOfBoundsException`

```java
List<Integer> list = new ArrayList<Integer>();
list.add(3);
list.add(5);
System.out.println(list.toString());
list.clear();
list.set(0, 2);
```

Output

```bash
[3, 5]
Exception in thread "main" java.lang.IndexOutOfBoundsException: Index 0 out of bounds for length 0
```

> [!WARNING]
> Calling get/set with an invalid index throws IndexOutOfBoundsException

### 25.4.3 Removing Elements

```java
list.remove(0); // remove(int index) — removes by index;  remove(Object) — removes first equal element
list.remove("A"); // removes first occurrence
list.removeIf(s -> s.startsWith("X"));
list.clear();
```

### 25.4.4 Important Behaviors and Characteristics

|		Operation		|		Behavior			|		Exception(s)			|
|-----------------------|---------------------------|-------------------------------|
|		`add(E)`			|	always appends			|		—						|
|		`add(int,E)`		|	shifts elements right	|	IndexOutOfBoundsException	|
|		`get(int)`		|	constant-time for ArrayList, linear for LinkedList |	IndexOutOfBoundsException	|
|		`set(int,E)`		|	replaces element		|	IndexOutOfBoundsException	|
|		`remove(int)`		|	shifts elements left	|	IndexOutOfBoundsException	|
|		`remove(Object)`	|	removes first equal element	|	—	|

---

## 25.5 `contains()`, `equals()`, and `hashCode()`

### 25.5.1 `contains()`

Method `contains()` uses `.equals()` on elements.

### 25.5.2 Equality of Lists

`List.equals()` performs element-wise comparison in order.

```java
List<String> a = List.of("A", "B");
List<String> b = List.of("A", "B");

System.out.println(a.equals(b)); // true
```

> [!NOTE]
> - Order matters. 
> - Type of list does NOT matter.

### 25.5.3 `hashCode()`

Computed based on the contents.

---

## 25.6 Iterating Through a List

### 25.6.1 Classic For Loop

```java
for (int i = 0; i < list.size(); i++) {
	System.out.println(list.get(i));
}
```

### 25.6.2 Enhanced For Loop

```java
for (String s : list) {
	System.out.println(s);
}
```

### 25.6.3 Iterator & ListIterator

```java
Iterator<String> it = list.iterator();
while (it.hasNext()) { System.out.println(it.next()); }

ListIterator<String> lit = list.listIterator();
while (lit.hasNext()) {
	if (lit.next().equals("A")) lit.set("Z");
}
```

> [!WARNING]
> All standard List iterators are fail-fast: structural modification outside iterator causes ConcurrentModificationException.

> [!NOTE]
> Only `ListIterator` supports bidirectional traversal and modification.

---

## 25.7 The `subList()` Method

`subList()` creates a view of a portion of the list, not a copy.
Modifying either list can modify the other.

### 25.7.1 Syntax

```java
List<E> subList(int fromIndex, int toIndex);
```

### 25.7.2 Rules

|			Rule						|				Explanation				|
|---------------------------------------|---------------------------------------|
|	fromIndex inclusive					|	element at fromIndex is included	|
|	toIndex exclusive					|	element at toIndex is NOT included  |
|	The view is backed by original list	|	modifying one modifies the other  	|
|	Structural modification of parent invalidates the subList	|	→ ConcurrentModificationException	|

### 25.7.3 Examples

```java
List<String> list = new ArrayList<>(List.of("A", "B", "C", "D"));
List<String> view = list.subList(1, 3);
// view = ["B", "C"]

view.set(0, "X");
// list = ["A", "X", "C", "D"]
// view = ["X", "C"]
```

### 25.7.4 Modifying the parent list invalidates the view

```java
List<String> list = new ArrayList<>(List.of("A","B","C","D"));
List<String> view = list.subList(1, 3);

list.add("E"); // structural change to parent list

view.get(0); // ❌ ConcurrentModificationException
```

### 25.7.5 Modifying the subList modifies the parent

```java
view.remove(1);
// removes "C" from both view and parent list
```

### 25.7.6 Clearing the subList clears part of the parent list

```java
view.clear();
// removes indices 1 and 2 from the parent
```

### 25.7.7 Common Pitfalls

- Assuming subList is independent:	it is a view, not a copy
- Assuming subList allows resizing:	works only on modifiable parent lists.
- Forgetting that parent modifications invalidate results in ConcurrentModificationException
- Incorrect index expectations:	End index is exclusive

---

## 25.8 Summary Table of Important Operations


| 	Operation		| 		ArrayList		| 		LinkedList 		| 		Immutable Lists 	|
|-------------------|-----------------------|-----------------------|---------------------------|
| `add(E)`			|	fast				|	fast				|	❌ unsupported			|
| `add(index,E)`		|	slow (shift)		|	fast				|	❌						|
| `get(index)`		|	fast				|	slow				|	fast					|
| `remove(index)` 	| 	slow 				| slow (unless removing first/last) 		  | ❌ |						
| `remove(Object)`	|	slower				|	slower				|	❌						|
| `set(index,E)`		|	fast				|	slow				|	❌						|
| `iterator()`		|	fast				|	fast				|	fast					|
| `listIterator()`	|	fast				|	fast				|	fast					|
| `contains(Object)`	|	O(n)				|	O(n)				|	O(n)					|
		