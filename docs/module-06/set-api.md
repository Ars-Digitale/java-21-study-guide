# Chapter 4 — Set API

A **Set** in Java represents a collection that **contains no duplicate elements**.  
It models the mathematical concept of a set: unordered (unless using an ordered implementation) and composed of unique values.

All Set implementations rely on **equality semantics** (either `equals()` or comparator logic).

## 4.1 Set Hierarchy (Java Collections Framework)

```text
Set<E>
 ├── HashSet<E>           (unordered, fastest, uses hashing)
 ├── LinkedHashSet<E>     (maintains insertion order)
 └── SortedSet<E>         (interface)
       └── TreeSet<E>     (sorted ascending by natural order or Comparator)
```

All `Set` implementations require:  
- uniqueness of elements  
- predictable equality and hashing (depending on implementation)

## 4.2 Characteristics of Each Set Implementation

### 4.2.1 HashSet
- Fastest general-purpose Set  
- Unordered (no iteration order guarantee)  
- Uses `hashCode()` and `equals()`  
- Allows one `null` element  


```java
Set<String> set = new HashSet<>();
set.add("A");
set.add("B");
set.add("A");   // duplicate ignored
System.out.println(set); // order not guaranteed
```

### 4.2.2 LinkedHashSet
- Maintains **insertion order**  
- Slightly slower than HashSet  
- Useful when predictable iteration order is required

```java
Set<String> set = new LinkedHashSet<>();
set.add("A");
set.add("C");
set.add("B");
System.out.println(set);  // [A, C, B]
```

### 4.2.3 TreeSet

A **sorted** Set whose order is determined by:  
1. Natural ordering (`Comparable`)  
2. A provided `Comparator`  

TreeSet:  
- No `null` elements allowed (NullPointerException at runtime)  
- Guarantees sorted iteration  
- Supports range views: `headSet()`, `tailSet()`, `subSet()`  


```java
TreeSet<Integer> tree = new TreeSet<>();
tree.add(10);
tree.add(1);
tree.add(5);

System.out.println(tree); // [1, 5, 10]
```

> **Note:** TreeSet requires all elements to be mutually comparable —  
mixing non-comparable types produces `ClassCastException`.


## 4.3 Equality Rules in Sets

The rules differ depending on implementation.

### 4.3.1 HashSet & LinkedHashSet

Uniqueness is determined by two methods:  
- `hashCode()`  
- `equals()`  

Two objects are considered the same element if:  
1. Their hash codes match  
2. Their `equals()` method returns `true`  


### 4.3.2 TreeSet

Uniqueness is based on `compareTo()` or the provided `Comparator`.  

If `compare(a, b) == 0` then the objects are considered duplicates, even if `equals()` is false.

```java
Comparator<String> comp = (a, b) -> a.length() - b.length();
Set<String> set = new TreeSet<>(comp);

set.add("Hi");
set.add("Yo"); // same length → treated as duplicate

System.out.println(set);  // ["Hi"]
```

## 4.4 Creating Set Instances

### 4.4.1 Using Constructors

```java
Set<String> s1 = new HashSet<>();
Set<String> s2 = new LinkedHashSet<>();
Set<String> s3 = new TreeSet<>();
```

### 4.4.2 Copy Constructors

```java
List<String> list = List.of("A", "B", "C");

Set<String> copy = new HashSet<>(list); // order lost
System.out.println(copy);

Set<String> ordered = new LinkedHashSet<>(list); // maintains the order from the list
System.out.println(ordered);
```

### 4.4.3 Factory Methods

```java
Set<String> s1 = Set.of("A", "B", "C");   // immutable
Set<String> empty = Set.of();             // empty immutable set
```

> **Note:** Factory-created sets are **immutable** —  
adding or removing elements throws `UnsupportedOperationException`.


## 4.5 Main Operations on Sets

### 4.5.1 Adding Elements

```java
set.add("A");          // returns true if added
set.add("A");          // returns false if duplicate
```

### 4.5.2 Checking Membership

```java
set.contains("A");
```

### 4.5.3 Removing Elements

```java
set.remove("A");
set.clear();
```

### 4.5.4 Bulk Operations

```java
set.addAll(otherSet);
set.removeAll(otherSet);
set.retainAll(otherSet); // intersection
```


## 4.6 Common Pitfalls

- Using TreeSet with non-comparable objects → `ClassCastException`
- Using mutable objects as Set keys → breaks hashing rules
- Factory Set.of() is immutable — modification fails
- HashSet does not guarantee iteration order
- TreeSet treats objects with compare()==0 as duplicates even if not equal


## 4.7 Summary Table


| Implementation   | Keeps Order?          | Allows Null? | Sorted?        | Underlying Logic        |
|------------------|-----------------------|--------------|----------------|--------------------------|
| HashSet          | No                    | Yes (1 null) | No             | hashCode + equals        |
| LinkedHashSet    | Yes (insertion order) | Yes (1 null) | No             | hash table + linked list |
| TreeSet          | Yes (sorted)          | No           | Yes (natural/comparator) | compareTo / Comparator |


