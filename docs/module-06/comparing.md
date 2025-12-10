# Comparable, Comparator & Sorting in Java

Java provides two main strategies for sorting and comparing: `Comparable` (natural ordering) and `Comparator` (custom ordering).
Understanding their rules, constraints, and interactions with generics is essential.

- For **numeric types**, sorting follows natural numerical order, meaning smaller values come before larger ones.
- For **strings**, sorting follows Unicode (lexicographical) order: `digits` come first, then `uppercase letters`, and finally `lowercase letters`.

This ordering is based on each character’s Unicode code point, not alphabetical intuition.

```java
List<String> items = List.of("10", "2", "A", "Z", "a", "b");

List<String> sorted = new ArrayList<>(items);
Collections.sort(sorted);

System.out.println(sorted);
```

Output:

```bash
[10, 2, A, Z, a, b]
```


## 1. Comparable — Natural Ordering

The interface `Comparable<T>` defines the natural order of a type.
A class implements it when it wants to define its default sorting rule.

### 1.1 Comparable Method Contract

```java
public interface Comparable<T> {
	int compareTo(T other);
}
```

Rules and expectations:

- Return negative → `this` < `other`
- Return zero → `this` == `other`
- Return positive → `this` > `other`

> [!IMPORTANT]
> - Natural ordering must be consistent with equals(), unless explicitly documented otherwise:
> - `compareTo()` is consistent with `equals()` if, and only if, `a.compareTo(b) == 0` and `a.equals(b) is true`.

### 1.2 Example: Class Implementing Comparable

```java
public class Person implements Comparable<Person> {

private String name;
private int age;

public Person(String n, int a) {
    this.name = n;
    this.age = a;
}

@Override
public int compareTo(Person other) {
    return Integer.compare(this.age, other.age);
}


}

var list = List.of(new Person("Bob", 40), new Person("Alice", 30));

list.stream().sorted().forEach(p -> System.out.println(p.age));
```

The list sorts by age, because that is the natural numbering order.

### 1.3 Common Comparable Pitfalls

- Compare all relevant fields → inconsistent results if not
- Violating transitivity → leads to undefined behavior
- Throwing exceptions inside compareTo() breaks sorting
- Failing to implement the same logic as equals() → common trap

## 2. Comparator — Custom Ordering

The interface `Comparator<T>` allows defining multiple sorting strategies
without modifying the class itself.

### 2.1 Comparator Core Methods

```java
int compare(T a, T b);
```

Additional helper methods:

- `reversed()`
- `thenComparing(...)` for multi-level comparison
- Static factory methods: `Comparator.comparing(...)`

### 2.2 Comparator Example

```java
Comparator<Person> byName = Comparator.comparing(Person::getName);

Comparator<Person> byAgeDesc = Comparator.comparingInt(Person::getAge).reversed();

var sorted = people.stream().sorted(byName.thenComparing(byAgeDesc)).toList();
```

## 3. Comparable vs Comparator 


|Feature  |	Comparable	| Comparator |
|---------|-------------|------------|
|Package  |	java.lang	| java.util	|
|Method	|	compareTo(T) |	compare(T,T)	|
|Sorting Type |	Natural (default) |	Custom (multiple strategies) |
|Modifies Source Class	| YES |	NO |
|Useful For	|	Default ordering |	External or alternate ordering |
|Allows Multiple Orders	| NO |	YES |
|Used By Collections.sort	| YES |	YES |
|Used By Arrays.sort	| YES	| YES |
	

## 4. Sorting Arrays and Collections

### 4.1 Arrays.sort()

```java
int[] nums = {3,1,2};
Arrays.sort(nums); // natural order

Person[] arr = {...};
Arrays.sort(arr); // Person must implement Comparable
Arrays.sort(arr, byName); // using Comparator
```

### 4.2 Collections.sort()

```java
Collections.sort(list); // natural order
Collections.sort(list, byName); // comparator
```

## 5. Multi-Level Sorting (thenComparing)

```java
var cmp = Comparator
.comparing(Person::getLastName)
.thenComparing(Person::getFirstName)
.thenComparingInt(Person::getAge);
```

## 6. Comparing Primitives Efficiently

```java
Comparator.comparingInt(Person::getAge)
Comparator.comparingLong(...)
Comparator.comparingDouble(...)
```

> **Note:** These avoid boxing and are preferred in performance-sensitive code.

## 7. Common Traps

- Sorting a list of Objects without Comparable → runtime ClassCastException
- compareTo inconsistent with equals → unpredictable behavior
- Comparator that breaks transitivity → sorting becomes undefined
- Null elements → unless Comparator handles them, sorting throws NPE
- Comparator comparing fields of mixed types → ClassCastException
- Using subtraction to compare ints can overflow → always use `Integer.compare()`

## 8. Full Example

```java
record Book(String title, double price, int year) {}

var books = List.of(
new Book("Java 17", 40.0, 2021),
new Book("Algorithms", 55.0, 2019),
new Book("Java 21", 42.0, 2023)
);

Comparator<Book> cmp =
Comparator
.comparingDouble(Book::price)
.thenComparing(Book::year)
.reversed();

books.stream().sorted(cmp)
.forEach(System.out::println);
```

# Summary

- Use `Comparable` for natural ordering (1 default order).
- Use `Comparator` for flexible or multiple sorting strategies.
- Comparators can compose (reversed, thenComparing).
- Sorting requires consistent comparison logic.
- Arrays.sort and Collections.sort use both Comparable and Comparator.