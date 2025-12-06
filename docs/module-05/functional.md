# Functional Programming in Java

Functional programming is a programming paradigm that focuses on describing what should be done rather than how it should be done.
Starting from Java 8, the language added several features that enable functional-style programming: lambda expressions, functional interfaces, and method references.

These features allow developers to write more expressive, concise, and reusable code, especially when working with collections, concurrency APIs, and event-driven systems.

# 1. Functional Interfaces

A functional interface is an interface that declares exactly one abstract method. This method represents a single behavior and is the target for lambda expressions and method references.

## 1.1 Rules for Functional Interfaces

- A functional interface must have exactly one abstract method.
- It may include default, static, and private methods.
- @FunctionalInterface annotation is optional but recommended.

```java
@FunctionalInterface
interface Printer {
void print(String msg); // Single abstract method
}
```

## 1.2 Common Functional Interfaces (java.util.function)

Below is a table of the most common standard functional interfaces.

```text
Type Parameters → Returns Example use

Supplier<T> () → T get a value
Consumer<T> (T) → void print, log
Function<T,R> (T) → R transform value
Predicate<T> (T) → boolean filtering
BiFunction<A,B,R> (A,B) → R combining inputs
UnaryOperator<T> (T) → T numeric ops
BinaryOperator<T> (T,T) → T reduce/combine
```

## 1.3 Examples for each Functional Interface

```java
Supplier<String> s = () -> "Hello!";
Consumer<String> c = msg -> System.out.println(msg);
Function<String, Integer> f = str -> str.length();
Predicate<Integer> p = n -> n > 10;

System.out.println(s.get());
c.accept("Test");
System.out.println(f.apply("abc"));
System.out.println(p.test(12));
```

## 1.4 Convenience Methods on Functional Interfaces

Many functional interfaces provide helper methods to chain or combine behaviors.

```text
Interface Methods

Function andThen(), compose()
Predicate and(), or(), negate()
Consumer andThen()
BinaryOperator minBy(), maxBy()
```

```java
Predicate<Integer> isEven = x -> x % 2 == 0;
Predicate<Integer> isPositive = x -> x > 0;

Predicate<Integer> evenAndPositive = isEven.and(isPositive);
System.out.println(evenAndPositive.test(4)); // true
```

## 1.5 Primitive Functional Interfaces

```text
IntPredicate, LongPredicate, DoublePredicate
IntFunction<R>, LongFunction<R>, DoubleFunction<R>
IntSupplier, LongSupplier, DoubleSupplier
IntUnaryOperator, IntBinaryOperator, etc.
```

```java
IntPredicate ip = x -> x > 5;
System.out.println(ip.test(7));
```

# 2. Lambda Expressions

A lambda expression is a compact way of writing a function. It represents an implementation of a functional interface.

## 2.1 Syntax

```text
(parameters) -> expression
(parameters) -> { statements }
```

## 2.2 Rules for Lambdas

- Parameter types can be omitted if inference is possible.
- If there is one parameter, parentheses are optional.
- If the body is a single expression, braces and return are omitted.
- Lambdas cannot declare checked exceptions unless allowed by the target functional interface.

```java
// full
Function<String, Integer> f1 = (String s) -> { return s.length(); };

// simplified
Function<String, Integer> f2 = s -> s.length();
```

# 3. Method References

A method reference is a shorthand syntax to reference an existing method instead of writing a lambda.
It is still a functional interface implementation.

## 3.1 Types of Method References

### 3.1.1 Reference to a Static Method

```java
Function<Integer, String> f = String::valueOf;
```

Equivalent lambda:

`x -> String.valueOf(x)`

### 3.1.2 Reference to an Instance Method of a Particular Object

```java
String prefix = "Hello ";
Function<String, String> f = prefix::concat;
```

Equivalent lambda:

`s -> prefix.concat(s)`

### 3.1.3 Reference to an Instance Method of an Arbitrary Object

```java
Function<String, Integer> f = String::length;
```

Equivalent lambda:

`s -> s.length()`

### 3.1.4 Reference to a Constructor

```java
Supplier<ArrayList<String>> s = ArrayList::new;
```

Equivalent lambda:

`() -> new ArrayList<>()`

## 3.2 Summary Table of Method References

```text
Pattern Example Meaning

Class::staticMethod Integer::parseInt calls static method
instance::method obj::toString calls method on given object
Class::instanceMethod String::toLowerCase method of unknown object
Class::new ArrayList::new constructor reference
```

# End of Chapter
