# 24. Comparable, Comparator & Sorting in Java

### Table of Contents

- [24. Comparable, Comparator & Sorting in Java](#24-comparable-comparator--sorting-in-java)
  - [24.1 Comparable — Natural Ordering](#241-comparable--natural-ordering)
    - [24.1.1 Comparable Method Contract](#2411-comparable-method-contract)
    - [24.1.2 Example Class Implementing Comparable](#2412-example-class-implementing-comparable)
    - [24.1.3 Common Comparable Pitfalls](#2413-common-comparable-pitfalls)
  - [24.2 Comparator — Custom Ordering](#242-comparator--custom-ordering)
    - [24.2.1 Comparator Core Methods](#2421-comparator-core-methods)
      - [24.2.1.1 Comparator Helper Static Methods](#24211-comparator-helper-static-methods)
      - [24.2.1.2 Instance Methods on Comparator](#24212-instance-methods-on-comparator)
    - [24.2.2 Comparator Example](#2422-comparator-example)
  - [24.3 Comparable vs Comparator](#243-comparable-vs-comparator)
  - [24.4 Sorting Arrays and Collections](#244-sorting-arrays-and-collections)
    - [24.4.1 Arrayssort](#2441-arrayssort)
    - [24.4.2 Collectionssort](#2442-collectionssort)
  - [24.5 Multi-Level Sorting thenComparing](#245-multi-level-sorting-thencomparing)
  - [24.6 Comparing Primitives Efficiently](#246-comparing-primitives-efficiently)
  - [24.7 Common Traps](#247-common-traps)
  - [24.8 Full Example](#248-full-example)
  - [24.9 Summary](#249-summary)

---


Java provides two main strategies for sorting and comparing: `Comparable` (natural ordering) and `Comparator` (custom ordering).
Understanding their rules, constraints, and interactions with generics is essential.

- For **numeric types**, sorting follows natural numerical order, meaning smaller values come before larger ones.
- Sorting **strings** follows lexicographical (Unicode code point) order: character-by-character comparison; digits come before uppercase, uppercase before lowercase.

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

> [!NOTE]
> Natural ordering is only defined for types that implement Comparable.

## 24.1 Comparable — Natural Ordering

The interface `Comparable<T>` defines the natural order of a type.
A class implements it when it wants to define its default sorting rule.

### 24.1.1 Comparable Method Contract

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

> [!WARNING]
> compareTo may throw ClassCastException if given a non-comparable type — but this usually appears only with raw types.


### 24.1.2 Example: Class Implementing Comparable

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

list.stream().sorted().forEach(p -> System.out.println(p.getAge()));
```

The list sorts by age, because that is the natural numbering order.

### 24.1.3 Common Comparable Pitfalls

- Compare all relevant fields → inconsistent results if not
- Violating transitivity → leads to undefined behavior
- Throwing exceptions inside compareTo() breaks sorting
- Failing to implement the same logic as equals() → common trap

## 24.2 Comparator — Custom Ordering

The interface `Comparator<T>` allows defining multiple sorting strategies
without modifying the class itself.

### 24.2.1 Comparator Core Methods

```java
int compare(T a, T b);
```

Additional helper methods:

#### 24.2.1.1 Comparator Helper **Static** Methods

|Method	| Static / Instance | Return Type |	Parameters	| Description |
|-------|-------------------|---------------|------------|-------------|
|Comparator.comparing(keyExtractor)	| static	|Comparator<T>	| Function<? super T, ? extends U>	| Builds a comparator comparing extracted keys using natural ordering. |
|Comparator.comparing(keyExtractor, keyComparator)	| static	| Comparator<T>	| Function<T,U>, Comparator<U>	| Builds comparator comparing extracted keys using a custom comparator.|
|Comparator.comparingInt(keyExtractor)	| static	| Comparator<T>		| ToIntFunction<T>	| Optimized comparator for int keys (avoids boxing).|
|Comparator.comparingLong(keyExtractor)	| static	| Comparator<T>		| ToLongFunction<T>	| Optimized comparator for long keys.|
|Comparator.comparingDouble(keyExtractor)	| static	| Comparator<T>		| ToDoubleFunction<T>	| Optimized comparator for double keys.|
|Comparator.naturalOrder()	| static	| Comparator<T>	| none	| Comparator using natural ordering (Comparable).|
|Comparator.reverseOrder()	| static	| Comparator<T>	| none	| Reverse natural ordering.|
|Comparator.nullsFirst(comparator)	| static	| Comparator<T>	| Comparator<T>	| Wraps comparator so nulls compare before non-nulls.|
|Comparator.nullsLast(comparator)	| static	| Comparator<T>	| Comparator<T>	| Wraps comparator so nulls compare after non-nulls.|


#### 24.2.1.2 **Instance** Methods on Comparator

|Method	| Static / Instance |	Return Type	| Parameters | Description |
|-------|-------------------|---------------|------------|-------------|
|thenComparing(otherComparator)	| instance	| Comparator<T>	| Comparator<T>	| Adds a secondary comparator when the primary compares equal.|
|thenComparing(keyExtractor)	| instance	| Comparator<T>	| Function<T,U>	| Secondary comparison using natural ordering of extracted key.|
|thenComparing(keyExtractor, keyComparator)	| instance	| Comparator<T>	| Function<T,U>, Comparator<U>	| Secondary comparison with custom comparator.|
|thenComparingInt(keyExtractor)	| instance	| Comparator<T>	| ToIntFunction<T>	| Secondary numeric comparison (optimized).|
|thenComparingLong(keyExtractor)	| instance	| Comparator<T>	| ToLongFunction<T>	| Secondary numeric comparison.|
|thenComparingDouble(keyExtractor)	| instance	| Comparator<T>	| ToDoubleFunction<T>	| Secondary numeric comparison.|
|reversed()	| instance	| Comparator<T>	| none	| Returns a reversed comparator for the same comparison logic.|

### 24.2.2 Comparator Example

```java
var people = List.of(new Person("Bob",40), new Person("Ann",30));

Comparator<Person> byName = Comparator.comparing(Person::getName);

Comparator<Person> byAgeDesc = Comparator.comparingInt(Person::getAge).reversed();

var sorted = people.stream().sorted(byName.thenComparing(byAgeDesc)).toList();
```

## 24.3 Comparable vs Comparator 


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
	

## 24.4 Sorting Arrays and Collections

### 24.4.1 Arrays.sort()

```java
int[] nums = {3,1,2};
Arrays.sort(nums); // natural order

Person[] arr = {...};
Arrays.sort(arr); // Person must implement Comparable
Arrays.sort(arr, byName); // using Comparator
```

### 24.4.2 Collections.sort()

```java
Collections.sort(list); // natural order
Collections.sort(list, byName); // comparator
```

> [!NOTE]
> Collections.sort(list) delegates to list.sort(comparator) since Java 8.


## 24.5 Multi-Level Sorting (thenComparing)

```java
var cmp = Comparator
	.comparing(Person::getLastName)
		.thenComparing(Person::getFirstName)
			.thenComparingInt(Person::getAge);
```

## 24.6 Comparing Primitives Efficiently

```java
Comparator.comparingInt(Person::getAge)
Comparator.comparingLong(...)
Comparator.comparingDouble(...)
```

> [!NOTE]
> These avoid boxing and are preferred in performance-sensitive code.

## 24.7 Common Traps

- Sorting a list of Objects without Comparable → runtime ClassCastException
- compareTo inconsistent with equals → unpredictable behavior
- Comparator that breaks transitivity → sorting becomes undefined
- Null elements → unless Comparator handles them, sorting throws NPE
- Comparator comparing fields of mixed types → ClassCastException
- Using subtraction to compare ints can overflow → always use `Integer.compare()`
- Sorting a list with null elements and natural order → NPE
- compareTo must never return inconsistent negative/zero/positive on same two objects (no randomness)

## 24.8 Full Example

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

> [!NOTE]
> reversed() applies to the entire composed comparator, not just the first comparison key.


## 24.9 Summary

- Use `Comparable` for natural ordering (1 default order).
- Use `Comparator` for flexible or multiple sorting strategies.
- Comparators can compose (reversed, thenComparing).
- Sorting requires consistent comparison logic.
- Arrays.sort and Collections.sort use both Comparable and Comparator.