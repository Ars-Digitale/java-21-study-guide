# 28. Map API

### Table of Contents

- [28. Map API](#28-map-api)
  - [28.1 Core Map Characteristics](#281-core-map-characteristics)
  - [28.2 Main Map Implementations](#282-main-map-implementations)
  - [28.3 Creating Maps](#283-creating-maps)
  - [28.4 Basic Map Operations](#284-basic-map-operations)
  - [28.5 Iterating Over a Map](#285-iterating-over-a-map)
  - [28.6 Determining Equality in Maps](#286-determining-equality-in-maps)
  - [28.7 Special Behavior of TreeMap](#287-special-behavior-of-treemap)
  - [28.8 Null Handling](#288-null-handling)
  - [28.9 Common Pitfalls](#289-common-pitfalls)
  - [28.10 Summary](#2810-summary)

---

The `Map` interface represents a collection of **key–value pairs**, where each key maps to at most one value.

Unlike other collection types, `Map` does **not** extend `Collection` and therefore has its own hierarchy and rules.


## 28.1 Core Map Characteristics

- Each key is unique; **duplicate keys overwrite the previous value**
- Values may be duplicated
- Maps do not support positional (index-based) access
- Iteration is performed over `keySet()`, `values()`, or `entrySet()`

!!! note
    A `Map` is not a `Collection`, but its views (keySet, values, entrySet) are collections.

---

## 28.2 Main Map Implementations

| Implementation | Ordering | Null Keys | Null Values | Thread-Safe | Notes |
|----------------|---------|-----------|-------------|-------------|------|
| `HashMap` | No ordering | 1 | Many | No | Fast, most common |
| `LinkedHashMap` | Insertion order | 1 | Many | No | Predictable iteration |
| `TreeMap` | Sorted by key | No | Many | No | Keys must be comparable |
| `Hashtable` | No ordering | No | No | Yes | Legacy |
| `ConcurrentHashMap` | No ordering | No | No | Yes | Concurrent-friendly |

!!! note
    `TreeMap` ordering is determined either by `Comparable` or by a `Comparator` provided at construction.

---

## 28.3 Creating Maps

`Maps` can be created using constructors or factory methods.

```java
Map<String, Integer> map1 = new HashMap<>();
Map<String, Integer> map2 = new LinkedHashMap<>();
Map<String, Integer> map3 = new TreeMap<>();

Map<String, Integer> map4 = Map.of("A", 1, "B", 2);
Map<String, Integer> map5 = Map.ofEntries(
    Map.entry("X", 10),
    Map.entry("Y", 20)
);
```

!!! note
    Maps created with `Map.of(...)` and `Map.ofEntries(...)` are **immutable**. Any modification attempt throws `UnsupportedOperationException`.

---

## 28.4 Basic Map Operations

| Method | Description | Return
|------|-------------|---------------|
| `put(k, v)` | Adds or replaces a mapping | Return prev. value or null |
| `putIfAbsent(k,v)` | Adds only if key not present | Returns existing or null |
| `get(k)` | Returns value or null | Return specific value or null |
| `getOrDefault(k, default)` | Returns value or default | Return specific value or default |
| `remove(k)` | Removes mapping | Remove and return specific value or null |
| `containsKey(k)` | Checks key presence | boolean |
| `containsValue(v)` | Checks value presence | boolean |
| `size()` | Number of entries | int |
| `isEmpty()` | Empty check | boolean |
| `clear()` | Removes all entries | void |
| `V merge(k, v, BiFunction(V, V, V))` | merge(k, v, remappingFunction) | if key absent → sets value; if key present → function(oldValue, newValue); if function returns null → mapping removed |

```java
Map<String, String> map = new HashMap<>();
map.put("A", "Apple");
map.put("B", "Banana");

map.put("A", "Avocado"); // overwrites value

String v = map.get("B"); // Banana
```

---

## 28.5 Iterating Over a Map

Maps are iterated via views:

- `keySet()` → Set of keys
- `values()` → Collection of values
- `entrySet()` → Set of Map.Entry

```java
for (String key : map.keySet()) {
    System.out.println(key);
}

for (String value : map.values()) {
    System.out.println(value);
}

for (Map.Entry<String, String> e : map.entrySet()) {
    System.out.println(e.getKey() + " = " + e.getValue());
}
```

!!! note
    Modifying the map while iterating over these views may throw `ConcurrentModificationException` (except for concurrent maps).

---

## 28.6 Determining Equality in Maps

Map equality is defined as follows:

- Two maps are equal if they contain the same key–value mappings
- Key comparison uses `equals()`
- Value comparison uses `equals()`

```java
Map<String, Integer> m1 = Map.of("A", 1, "B", 2);
Map<String, Integer> m2 = Map.of("B", 2, "A", 1);

System.out.println(m1.equals(m2)); // true
```

!!! note
    Iteration order does not affect map equality.

---

## 28.7 Special Behavior of TreeMap

TreeMap maintains entries in sorted order based on keys.

```java
Map<Integer, String> tm = new TreeMap<>();
tm.put(3, "C");
tm.put(1, "A");
tm.put(2, "B");

System.out.println(tm); // {1=A, 2=B, 3=C}
```

!!! warning
    All keys in a `TreeMap` must be mutually comparable.
    Mixing incompatible types causes `ClassCastException` at runtime.

---

## 28.8 Null Handling

| Implementation | Null Key | Null Value |
|----------------|----------|------------|
| HashMap | Yes (1) | Yes |
| LinkedHashMap | Yes (1) | Yes |
| TreeMap | No | Yes |
| Hashtable | No | No |
| ConcurrentHashMap | No | No |

!!! note
    TreeMap accepts null values only when they do not participate in key comparison. In practice this is rare, because null keys are banned and comparators may reject nulls.
    
    HashMap/LinkedHashMap allow only ONE null key — inserting another replaces the existing one.

---

## 28.9 Common Pitfalls

- Assuming Map is a Collection
- Forgetting that duplicate keys overwrite values
- Using null keys in TreeMap or ConcurrentHashMap
- Confusing iteration order with equality
- Trying to modify immutable maps created via Map.of

---

## 28.10 Summary

- Maps store unique keys mapped to values
- Ordering depends on implementation
- Equality is based on key–value pairs
- TreeMap requires comparable keys
- Immutable maps throw exceptions on modification
