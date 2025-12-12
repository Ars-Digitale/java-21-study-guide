# Chapter 6 — Map API

The `Map` interface represents a collection of **key–value pairs**, where each key maps to at most one value.
Unlike other collection types, `Map` does **not** extend `Collection` and therefore has its own hierarchy and rules.


## 6.1 Core Map Characteristics

- Each key is unique; duplicate keys overwrite the previous value
- Values may be duplicated
- Maps do not support positional (index-based) access
- Iteration is performed over `keySet()`, `values()`, or `entrySet()`

> **Note:** A `Map` is not a `Collection`, but its views (keySet, values, entrySet) are collections.

## 6.2 Main Map Implementations

| Implementation | Ordering | Null Keys | Null Values | Thread-Safe | Notes |
|----------------|---------|-----------|-------------|-------------|------|
| HashMap | No ordering | 1 | Many | No | Fast, most common |
| LinkedHashMap | Insertion order | 1 | Many | No | Predictable iteration |
| TreeMap | Sorted by key | No | Many | No | Keys must be comparable |
| Hashtable | No ordering | No | No | Yes | Legacy |
| ConcurrentHashMap | No ordering | No | No | Yes | Concurrent-friendly |

> **Note:** TreeMap ordering is determined either by `Comparable` or by a `Comparator` provided at construction.


## 6.3 Creating Maps

Maps can be created using constructors or factory methods.

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

> **Note:** Maps created with `Map.of(...)` and `Map.ofEntries(...)` are **immutable**. Any modification attempt throws `UnsupportedOperationException`.


## 6.4 Basic Map Operations

| Method | Description |
|------|-------------|
| put(k, v) | Adds or replaces a mapping |
| get(k) | Returns value or null |
| remove(k) | Removes mapping |
| containsKey(k) | Checks key presence |
| containsValue(v) | Checks value presence |
| size() | Number of entries |
| isEmpty() | Empty check |
| clear() | Removes all entries |

```java
Map<String, String> map = new HashMap<>();
map.put("A", "Apple");
map.put("B", "Banana");

map.put("A", "Avocado"); // overwrites value

String v = map.get("B"); // Banana
```

## 6.5 Iterating Over a Map

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

> **Note:** Modifying the map while iterating over these views may throw `ConcurrentModificationException` (except for concurrent maps).


## 6.6 Determining Equality in Maps

Map equality is defined as follows:

- Two maps are equal if they contain the same key–value mappings
- Key comparison uses `equals()`
- Value comparison uses `equals()`

```java
Map<String, Integer> m1 = Map.of("A", 1, "B", 2);
Map<String, Integer> m2 = Map.of("B", 2, "A", 1);

System.out.println(m1.equals(m2)); // true
```

> **Note:** Iteration order does not affect map equality.


## 6.7 Special Behavior of TreeMap

TreeMap maintains entries in sorted order based on keys.

```java
Map<Integer, String> tm = new TreeMap<>();
tm.put(3, "C");
tm.put(1, "A");
tm.put(2, "B");

System.out.println(tm); // {1=A, 2=B, 3=C}
```

> [!WARNING]
> All keys in a TreeMap must be mutually comparable. 
> Mixing incompatible types causes `ClassCastException` at runtime.@@WARNING_END@@


## 6.8 Null Handling

| Implementation | Null Key | Null Value |
|----------------|----------|------------|
| HashMap | Yes (1) | Yes |
| LinkedHashMap | Yes (1) | Yes |
| TreeMap | No | Yes |
| Hashtable | No | No |
| ConcurrentHashMap | No | No |



## 6.9 Common  Pitfalls

- Assuming Map is a Collection
- Forgetting that duplicate keys overwrite values
- Using null keys in TreeMap or ConcurrentHashMap
- Confusing iteration order with equality
- Trying to modify immutable maps created via Map.of


## 6.10 Summary

- Maps store unique keys mapped to values
- Ordering depends on implementation
- Equality is based on key–value pairs
- TreeMap requires comparable keys
- Immutable maps throw exceptions on modification
