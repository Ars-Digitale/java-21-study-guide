# 26. Set API

<a id="table-of-contents"></a>
### Table of Contents

- [26. Set API](#26-set-api)
  - [26.1 Set Hierarchy Java-Collections-Framework](#261-set-hierarchy-java-collections-framework)
  - [26.2 Characteristics of Each Set Implementation](#262-characteristics-of-each-set-implementation)
    - [26.2.1 HashSet](#2621-hashset)
    - [26.2.2 LinkedHashSet](#2622-linkedhashset)
    - [26.2.3 TreeSet](#2623-treeset)
  - [26.3 Equality Rules in Sets](#263-equality-rules-in-sets)
    - [26.3.1 HashSet--LinkedHashSet](#2631-hashset--linkedhashset)
    - [26.3.2 TreeSet](#2632-treeset)
  - [26.4 Creating Set Instances](#264-creating-set-instances)
    - [26.4.1 Using Constructors](#2641-using-constructors)
    - [26.4.2 Copy Constructors](#2642-copy-constructors)
    - [26.4.3 Factory Methods](#2643-factory-methods)
  - [26.5 Main Operations on Sets](#265-main-operations-on-sets)
    - [26.5.1 Adding Elements](#2651-adding-elements)
    - [26.5.2 Checking Membership](#2652-checking-membership)
    - [26.5.3 Removing Elements](#2653-removing-elements)
    - [26.5.4 Bulk Operations](#2654-bulk-operations)
  - [26.6 Common Pitfalls](#266-common-pitfalls)
  - [26.7 Summary Table](#267-summary-table)

---

A **Set** in Java represents a collection that **contains no duplicate elements**.  

It models the mathematical concept of a `set`: unordered (unless using an ordered implementation) and composed of unique values.

All Set implementations rely on **equality semantics** (either `equals()` or `comparator` logic.

<a id="261-set-hierarchy-java-collections-framework"></a>
## 26.1 Set Hierarchy (Java Collections Framework)

```text
Set<E>
 ├── SequencedSet<E> (Java 21+)
 │    └── LinkedHashSet<E>   (ordered)
 ├── HashSet<E>              (unordered)
 └── SortedSet<E>
      └── NavigableSet<E>
           └── TreeSet<E>    (sorted)
```

All `Set` implementations require:  
- uniqueness of elements  
- predictable equality and hashing (depending on implementation)

!!! note
    `LinkedHashSet` is now formally a `SequencedSet` since Java 21.

---

<a id="262-characteristics-of-each-set-implementation"></a>
## 26.2 Characteristics of Each Set Implementation

<a id="2621-hashset"></a>
### 26.2.1 HashSet

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

<a id="2622-linkedhashset"></a>
### 26.2.2 LinkedHashSet

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

<a id="2623-treeset"></a>
### 26.2.3 TreeSet

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

!!! note
    `TreeSet` requires all elements to be mutually comparable — mixing non-comparable types produces `ClassCastException`.
    Operations (add, remove, contains) are O(log n).

---

<a id="263-equality-rules-in-sets"></a>
## 26.3 Equality Rules in Sets

The rules differ depending on implementation.

<a id="2631-hashset--linkedhashset"></a>
### 26.3.1 HashSet & LinkedHashSet

`Uniqueness` is determined by two methods:  
- `hashCode()`  
- `equals()`  

Two objects are considered the same element if:
  
1. Their hash codes match  
2. Their `equals()` method returns `true`  

!!! warning
    If you mutate an object after adding it to a HashSet or LinkedHashSet, its hashCode may change and the set may lose track of it.

<a id="2632-treeset"></a>
### 26.3.2 TreeSet

Uniqueness is based on `compareTo()` or the provided `Comparator`.  

If `compare(a, b) == 0` then the objects are considered duplicates, even if `equals()` is false.

```java
Comparator<String> comp = (a, b) -> a.length() - b.length();
Set<String> set = new TreeSet<>(comp);

set.add("Hi");
set.add("Yo"); // same length → treated as duplicate

System.out.println(set);  // ["Hi"]
```

---

<a id="264-creating-set-instances"></a>
## 26.4 Creating Set Instances

<a id="2641-using-constructors"></a>
### 26.4.1 Using Constructors

```java
Set<String> s1 = new HashSet<>();
Set<String> s2 = new LinkedHashSet<>();
Set<String> s3 = new TreeSet<>();
```

<a id="2642-copy-constructors"></a>
### 26.4.2 Copy Constructors

```java
List<String> list = List.of("A", "B", "C");

Set<String> copy = new HashSet<>(list); // order lost
System.out.println(copy);

Set<String> ordered = new LinkedHashSet<>(list); // maintains the order from the list
System.out.println(ordered);
```

<a id="2643-factory-methods"></a>
### 26.4.3 Factory Methods

```java
Set<String> s1 = Set.of("A", "B", "C");   // immutable
Set<String> empty = Set.of();             // empty immutable set
```

!!! note
    Factory-created sets are **immutable**: adding or removing elements throws `UnsupportedOperationException`.
    `Set.of(...)` rejects duplicates at creation time → IllegalArgumentException and rejects null → NullPointerException


---

<a id="265-main-operations-on-sets"></a>
## 26.5 Main Operations on Sets

<a id="2651-adding-elements"></a>
### 26.5.1 Adding Elements

```java
set.add("A");          // returns true if added
set.add("A");          // returns false if duplicate
```

<a id="2652-checking-membership"></a>
### 26.5.2 Checking Membership

```java
set.contains("A");
```

<a id="2653-removing-elements"></a>
### 26.5.3 Removing Elements

```java
set.remove("A");
set.clear();
```

<a id="2654-bulk-operations"></a>
### 26.5.4 Bulk Operations

```java
set.addAll(otherSet);
set.removeAll(otherSet);
set.retainAll(otherSet); // intersection
```

---

<a id="266-common-pitfalls"></a>
## 26.6 Common Pitfalls

- Using TreeSet with non-comparable objects → `ClassCastException`
- TreeSet does not use `equals()` at all: only comparator/compareTo decides uniqueness.
- Using mutable objects as Set keys → breaks hashing rules
- Factory Set.of() is immutable — modification fails
- HashSet does not guarantee iteration order
- TreeSet treats objects with compare()==0 as duplicates even if not equal

---

<a id="267-summary-table"></a>
## 26.7 Summary Table


| Implementation   | Keeps Order?          | Allows Null? | Sorted?        | Underlying Logic        |
|------------------|-----------------------|--------------|----------------|--------------------------|
| HashSet          | No                    | Yes (1 null) | No             | hashCode + equals        |
| LinkedHashSet    | Yes (insertion order) | Yes (1 null) | No             | hash table + linked list |
| TreeSet          | Yes (sorted)          | No           | Yes (natural/comparator) | compareTo / Comparator |


