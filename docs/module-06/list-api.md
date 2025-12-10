# The List API

In the Collections Framework, a **List** represents an ordered, index-based, duplicate-allowing collection.


The List interface extends `Collection` and is implemented by:

```text
List
├── ArrayList (Resizable array — fast random access, slower inserts/removals in the middle)
├── LinkedList (Doubly-linked list — fast inserts/removals, slower random access)
└── Vector (Legacy synchronized list — rarely used today)
```


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

If you try to `update` an element in an empty List, event at index 0, you get an `IndexOutOfBoundsException`

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

> **Note:** `get()` throws `IndexOutOfBoundsException` for invalid indices.

### 3.4.3 Removing Elements

```java
list.remove(0); // removes by a "primitive" index. Overloaded version over the one implemented in Collection which removes an object match.
list.remove("A"); // removes first occurrence
list.removeIf(s -> s.startsWith("X"));
list.clear();
```

### 3.5 Important Behaviors and Characteristics

|		Operation		|		Behavior			|		Exception(s)			|
|-----------------------|---------------------------|-------------------------------|
|		add(E)			|	always appends			|		—						|
|		add(int,E)		|	shifts elements right	|	IndexOutOfBoundsException	|
|		get(int)		|	constant-time for ArrayList, linear for LinkedList |	IndexOutOfBoundsException	|
|		set(int,E)		|	replaces element		|	IndexOutOfBoundsException	|
|		remove(int)		|	shifts elements left	|	IndexOutOfBoundsException	|
|		remove(Object)	|	removes first equal element	|	—	|

## 3.6 contains(), equals(), and hashCode()

### 3.6.1 contains()

Uses .equals() on elements.

### 3.6.2 Equality of Lists

`List.equals()` performs element-wise comparison in order.

```java
List<String> a = List.of("A", "B");
List<String> b = List.of("A", "B");

System.out.println(a.equals(b)); // true
```

> **Note:** Order matters. Type of list does NOT matter.

### 3.6.3 hashCode()

Computed based on the contents.

## 3.7 Iterating Through a List

### 3.7.1 Classic For Loop

```java
for (int i = 0; i < list.size(); i++) {
	System.out.println(list.get(i));
}
```

### 3.7.2 Enhanced For Loop

```java
for (String s : list) {
	System.out.println(s);
}
```

### 3.7.3 Iterator & ListIterator

```java
Iterator<String> it = list.iterator();
while (it.hasNext()) { System.out.println(it.next()); }

ListIterator<String> lit = list.listIterator();
while (lit.hasNext()) {
	if (lit.next().equals("A")) lit.set("Z");
}
```

> **Note:** Only `ListIterator` supports bidirectional traversal and modification.

## 3.8 The subList() Method

`subList()` creates a view of a portion of the list, not a copy.
Modifying either list can modify the other.

### 3.8.1 Syntax

```java
List<E> subList(int fromIndex, int toIndex);
```

### 3.8.2 Rules

|			Rule						|				Explanation				|
|---------------------------------------|---------------------------------------|
|	fromIndex inclusive					|	element at fromIndex is included	|
|	toIndex exclusive					|	element at toIndex is NOT included  |
|	The view is backed by original list	|	modifying one modifies the other  	|
|	Structural modification of parent invalidates the subList	|	→ ConcurrentModificationException	|

### 3.8.3 Examples

```java
List<String> list = new ArrayList<>(List.of("A", "B", "C", "D"));
List<String> view = list.subList(1, 3);
// view = ["B", "C"]

view.set(0, "X");
// list = ["A", "X", "C", "D"]
// view = ["X", "C"]
```

### 3.8.4 Modifying the parent list invalidates the view

```java
List<String> list = new ArrayList<>(List.of("A","B","C","D"));
List<String> view = list.subList(1, 3);

list.add("E"); // structural change to parent list

view.get(0); // ❌ ConcurrentModificationException
```

### 3.8.5 Modifying the subList modifies the parent

```java
view.remove(1);
// removes "C" from both view and parent list
```

### 3.8.6 Clearing the subList clears part of the parent list

```java
view.clear();
// removes indices 1 and 2 from the parent
```

### 3.8.7 Common Pitfalls

- Assuming subList is independent	It is a view, not a copy
- Assuming subList allows resizing	It allows add/remove only inside the subrange
- Forgetting that parent modifications invalidate	Results in ConcurrentModificationException
- Incorrect index expectations	End index is exclusive

## 3.9 Summary Table of Important Operations


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
		