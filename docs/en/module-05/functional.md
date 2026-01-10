# 20. Functional Programming in Java

### Table of Contents

- [20. Functional Programming in Java](#20-functional-programming-in-java)
  - [20.1 Functional Interfaces](#201-functional-interfaces)
    - [20.1.1 Rules for Functional Interfaces](#2011-rules-for-functional-interfaces)
    - [20.1.2 Common Functional Interfaces javautilfunction](#2012-common-functional-interfaces-javautilfunction)
    - [20.1.3 Convenience Methods on Functional Interfaces](#2013-convenience-methods-on-functional-interfaces)
    - [20.1.4 Primitive Functional Interfaces](#2014-primitive-functional-interfaces)
    - [20.1.5 Summary](#2015-summary)
  - [20.2 Lambda Expressions](#202-lambda-expressions)
    - [20.2.1 Syntax of Lambda Expressions](#2021-syntax-of-lambda-expressions)
    - [20.2.2 Examples of Lambda Syntax](#2022-examples-of-lambda-syntax)
    - [20.2.3 Rules for Lambda Expressions](#2023-rules-for-lambda-expressions)
    - [20.2.4 Type Inference](#2024-type-inference)
    - [20.2.5 Restrictions in Lambda Bodies](#2025-restrictions-in-lambda-bodies)
    - [20.2.6 Return Type Rules](#2026-return-type-rules)
    - [20.2.7 Lambdas vs Anonymous Classes](#2027-lambdas-vs-anonymous-classes)
    - [20.2.8 Common Lambda Errors Certification Traps](#2028-common-lambda-errors-certification-traps)
  - [20.3 Method References](#203-method-references)
    - [20.3.1 Reference to a Static Method](#2031-reference-to-a-static-method)
    - [20.3.2 Reference to an Instance Method of a Particular Object](#2032-reference-to-an-instance-method-of-a-particular-object)
    - [20.3.3 Reference to an Instance Method of an Arbitrary Object of a Given Type](#2033-reference-to-an-instance-method-of-an-arbitrary-object-of-a-given-type)
    - [20.3.4 Reference to a Constructor](#2034-reference-to-a-constructor)
    - [20.3.5 Summary Table of Method Reference Types](#2035-summary-table-of-method-reference-types)
    - [20.3.6 Common Pitfalls](#2036-common-pitfalls)

---

Functional programming is a programming paradigm that focuses on describing what should be done rather than how it should be done.
Starting from Java 8, the language added several features that enable functional-style programming: `lambda expressions`, `functional interfaces`, and `method references`.

These features allow developers to write more expressive, concise, and reusable code, especially when working with collections, concurrency APIs, and event-driven systems.

## 20.1 Functional Interfaces

In Java, a **functional interface** is an interface that contains **exactly one** abstract method.

Functional interfaces enable **Lambda Expressions** and **Method References**, forming the core of Java’s functional programming model.

> **Note:** Java automatically treats any interface with a single abstract method as a functional interface, `@FunctionalInterface` annotation is optional but recommended.

### 20.1.1 Rules for Functional Interfaces

- **Exactly one abstract method** (SAM = Single Abstract Method).
- Interfaces may declare any number of **default**, **static** or **private** methods.
- They may override `Object` methods (`toString()`, `equals(Object)`, `hashCode()`) without affecting SAM count.
- The functional method may come from a **superinterface**.

Example:

```java
@FunctionalInterface
interface Adder {
    int add(int a, int b);   // single abstract method
    static void info() {}
    default void log() {}
}
```

### 20.1.2 Common Functional Interfaces (java.util.function)

Below is a certification-grade summary of the most important functional interfaces.


|Functional Interface | Returns | Method | Parameters |
|---------------------|---------|--------|-------------------- |
|Supplier<T>          | T       | get()         | 0 |
|Consumer<T>          | void    | accept(T)     | 1 |
|BiConsumer<T,U>      | void    | accept(T,U)   | 2 |
|Function<T,R>        | R       | apply(T)      | 1 |
|BiFunction<T,U,R>    | R       | apply(T,U)    | 2 |
|UnaryOperator<T>     | T       | apply(T)      | 1 (same types) |
|BinaryOperator<T>    | T       | apply(T,T)    | 2 (same types) |
|Predicate<T>         | boolean | test(T)       | 1 |
|BiPredicate<T,U>     | boolean | test(T,U)     | 2 |


Examples

```java
Supplier<String> sup = () -> "Hello!";

Consumer<String> printer = s -> System.out.println(s);

Function<String, Integer> length = s -> s.length();

UnaryOperator<Integer> square = x -> x * x;

Predicate<Integer> positive = x -> x > 0;
```

### 20.1.3 Convenience Methods on Functional Interfaces

Many Functional interfaces come with helper methods that allow chaining and composition.


|Interface        | Method         | Description |
|-----------------|----------------|--------------------------- |
|Function         | andThen()      | applies this, then another |
|Function         | compose()      | applies another, then this |
|Function         | identity()     | returns a function x -> x |
|Predicate        | and()          | logical AND |
|Predicate        | or()           | logical OR |
|Predicate        | negate()       | logical NOT |
|Consumer         | andThen()      | chains consumers |
|BinaryOperator   | minBy()        | comparator-based minimum |
|BinaryOperator   | maxBy()        | comparator-based maximum |


Examples

```java
Function<Integer, Integer> times2 = x -> x * 2;
Function<Integer, Integer> plus3  = x -> x + 3;

var result1 = times2.andThen(plus3).apply(5);   // (5*2)+3 = 13
var result2 = times2.compose(plus3).apply(5);   // (5+3)*2 = 16

Predicate<String> longString = s -> s.length() > 5;
Predicate<String> startsWithA = s -> s.startsWith("A");

boolean ok = longString.and(startsWithA).test("Amazing");  // true
```

### 20.1.4 Primitive Functional Interfaces

Java provides specialized versions of functional interfaces for primitives to avoid boxing/unboxing overhead.


| Functional Interface          | Return Type  | Single Abstract Method | # Parameters |
|------------------------------|--------------|-------------------------|--------------|
| IntSupplier                  | int          | getAsInt()              | 0            |
| LongSupplier                 | long         | getAsLong()             | 0            |
| DoubleSupplier               | double       | getAsDouble()           | 0            |
| BooleanSupplier              | boolean      | getAsBoolean()          | 0            |
|                              |              |                         |              |
| IntConsumer                  | void         | accept(int)             | 1 (int)      |
| LongConsumer                 | void         | accept(long)            | 1 (long)     |
| DoubleConsumer               | void         | accept(double)          | 1 (double)   |
|                              |              |                         |              |
| IntPredicate                 | boolean      | test(int)               | 1 (int)      |
| LongPredicate                | boolean      | test(long)              | 1 (long)     |
| DoublePredicate              | boolean      | test(double)            | 1 (double)   |
|                              |              |                         |              |
| IntUnaryOperator             | int          | applyAsInt(int)         | 1 (int)      |
| LongUnaryOperator            | long         | applyAsLong(long)       | 1 (long)     |
| DoubleUnaryOperator          | double       | applyAsDouble(double)   | 1 (double)   |
|                              |              |                         |              |
| IntBinaryOperator            | int          | applyAsInt(int, int)    | 2 (int,int)  |
| LongBinaryOperator           | long         | applyAsLong(long, long) | 2 (long,long)|
| DoubleBinaryOperator         | double       | applyAsDouble(double,double)| 2         |
|                              |              |                         |              |
| IntFunction<R>               | R            | apply(int)              | 1 (int)      |
| LongFunction<R>              | R            | apply(long)             | 1 (long)     |
| DoubleFunction<R>            | R            | apply(double)           | 1 (double)   |
|                              |              |                         |              |
| ToIntFunction<T>             | int          | applyAsInt(T)           | 1 (T)        |
| ToLongFunction<T>            | long         | applyAsLong(T)          | 1 (T)        |
| ToDoubleFunction<T>          | double       | applyAsDouble(T)        | 1 (T)        |
|                              |              |                         |              |
| ToIntBiFunction<T,U>         | int          | applyAsInt(T,U)         | 2 (T,U)      |
| ToLongBiFunction<T,U>        | long         | applyAsLong(T,U)        | 2 (T,U)      |
| ToDoubleBiFunction<T,U>      | double       | applyAsDouble(T,U)      | 2 (T,U)      |
|                              |              |                         |              |
| ObjIntConsumer<T>            | void         | accept(T,int)           | 2 (T,int)    |
| ObjLongConsumer<T>           | void         | accept(T,long)          | 2 (T,long)   |
| ObjDoubleConsumer<T>         | void         | accept(T,double)        | 2 (T,double) |
|                              |              |                         |              |
| DoubleToIntFunction          | int          | applyAsInt(double val.) | 1            |
| DoubleToLongFunction         | long         | applyAsLong(double val.)| 1            |
| IntToDoubleFunction          | double       | applyAsDouble(int val.) | 1            |
| IntToLongFunction            | long         | applyAsLong(int value)  | 1            |
| LongToDoubleFunction         | double       | applyAsDouble(long val.)| 1            |
| LongToIntFunction            | int          | applyAsInt(long value)  | 1            |


Example

```java
IntSupplier dice = () -> (int)(Math.random() * 6) + 1;

IntPredicate even = x -> x % 2 == 0;

IntUnaryOperator doubleIt = x -> x * 2;
```


### 20.1.5 Summary

- Functional Interfaces contain exactly one abstract method (SAM).
- They power Lambdas and Method References.
- Java offers many built-in FIs in java.util.function.
- Primitive variants improve performance by removing boxing.

---

## 20.2 Lambda Expressions

A lambda expression is a compact way of writing a function.
 
Lambda expressions provide a concise way to define implementations of functional interfaces.

A lambda is essentially a short block of code that takes parameters and returns a value, without requiring a full method declaration.

They represent behavior as data and are a key element of Java’s functional programming model.

### 20.2.1 Syntax of Lambda Expressions

The general syntax is:

`(parameters) -> expression`
or
`(parameters) -> { statements }`

### 20.2.2 Examples of Lambda Syntax

**Zero parameters**
```java
Runnable r = () -> System.out.println("Hello");
```

**One parameter (parentheses optional)**
```java
Consumer<String> c = s -> System.out.println(s);
```

**Multiple parameters**
```java
BinaryOperator<Integer> add = (a, b) -> a + b;
```

**With a block body**
```java
Function<Integer, String> f = (x) -> {
    int doubled = x * 2;
    return "Value: " + doubled;
};
```

### 20.2.3 Rules for Lambda Expressions

- Parameter types may be omitted (type inference).
- If a parameter has a type, all parameters must specify the type.
- A single parameter does not require parentheses.
- Multiple parameters require parentheses.
- If the body is a single expression, `return` is not allowed.
- If the body is in `{ }` brackets, `return` must appear if a value is returned.
- Lambda expressions can only be assigned to functional interfaces (SAM types).

### 20.2.4 Type Inference

The compiler infers the lambda's type from the target functional interface context.

```java
Predicate<String> p = s -> s.isEmpty();  // s inferred as String
```

If the compiler cannot infer the type, you must specify it explicitly.

```java
BiFunction<Integer, Integer, Integer> f = (Integer a, Integer b) -> a * b;
```

### 20.2.5 Restrictions in Lambda Bodies

**Lambdas cannot reassign non-final (effectively final) local variables.**

```java
int x = 10;
Runnable r = () -> {
    // x++;   // ❌ compile error — x must be effectively final
    System.out.println(x);
};
```

**They CAN modify object state (only references must be effectively final).**

```java
var list = new ArrayList<>();
Runnable r2 = () -> list.add("OK");  // allowed
```

### 20.2.6 Return Type Rules

If the body is an expression: the expression is the return value.

```java
Function<Integer, Integer> f = x -> x * 2;
```

If the body is a block: you must include `return`.

```java
Function<Integer, Integer> g = x -> {
    return x * 2;
};
```

### 20.2.7 Lambdas vs Anonymous Classes

- Lambdas do NOT create a new scope — they share the enclosing scope.
- `this` inside a lambda refers to the enclosing object, not the lambda.

```java
class Test {
    void run() {
        Runnable r = () -> System.out.println(this.toString());
    }
}
```

In anonymous classes, `this` refers to the anonymous class instance.

### 20.2.8 Common Lambda Errors (Certification Traps)

**Inconsistent return types**
```java
x -> { if (x > 0) return 1; }  // ❌ missing return for negative case
```

**Mixing typed and untyped parameters**
```java
(a, int b) -> a + b   // ❌ illegal
```

**Returning a value from a void-target lambda**
```java
Runnable r = () -> 5;  // ❌ Runnable.run() returns void
```

**Ambiguous overload resolution**

```java
void m(IntFunction<Integer> f) {}
void m(Function<Integer, Integer> f) {}

m(x -> x + 1);  // ❌ ambiguous
```

---

## 20.3 Method References

Method references provide a shorthand syntax for using an existing method as a functional interface implementation.  
They are equivalent to lambda expressions, but more concise, readable, and often preferred when the target method already exists.

There are four categories of method references in Java:

- 1. Reference to a static method (`ClassName::staticMethod`)
- 2. Reference to an instance method of a particular object (`instance::method`)
- 3. Reference to an instance method of an arbitrary object of a given type (`ClassName::instanceMethod`)
- 4. Reference to a constructor (`ClassName::new`)


### 20.3.1 Reference to a Static Method

A static method reference replaces a lambda that calls a static method.

```java
class Utils {
    static int square(int x) { return x * x; }
}

Function<Integer, Integer> f1 = x -> Utils.square(x);
Function<Integer, Integer> f2 = Utils::square;  // method reference
```

Both `f1` and `f2` behave identically.


### 20.3.2 Reference to an Instance Method of a Particular Object

Used when you already have an object instance, and want to refer to one of its methods.

```java
String prefix = "Hello, ";

UnaryOperator<String> op1 = s -> prefix.concat(s);
UnaryOperator<String> op2 = prefix::concat;   // method reference

System.out.println(op2.apply("World"));
```

The reference `prefix::concat` binds `concat` to **that specific object**.


### 20.3.3 Reference to an Instance Method of an Arbitrary Object of a Given Type

This is the trickiest form.  
The functional interface’s first parameter becomes the method’s receiver (`this`).

```java
BiPredicate<String, String> p1 = (s1, s2) -> s1.equals(s2);
BiPredicate<String, String> p2 = String::equals;   // method reference

System.out.println(p2.test("abc", "abc"));  // true
```

> **Note:** This form applies the method to the *first argument* of the lambda.


### 20.3.4 Reference to a Constructor

Constructor references replace lambdas that call `new`.

```java
Supplier<ArrayList<String>> sup1 = () -> new ArrayList<>();
Supplier<ArrayList<String>> sup2 = ArrayList::new; // method reference

Function<Integer, ArrayList<String>> sup3 = ArrayList::new;
// calls the constructor ArrayList(int capacity)
```

### 20.3.5 Summary Table of Method Reference Types

The table below summarizes all method reference categories.


|Type                                | Syntax Example          | Equivalent Lambda |
|----------------------------------- | ------------------------ | ---------------------------------------- |
|Static method                       | Class::staticMethod     | x -> Class.staticMethod(x) |
|Instance method of specific object  | instance::method        | x -> instance.method(x) |
|Instance method of arbitrary object | Class::method           | (obj, x) -> obj.method(x) |
|Constructor                         | Class::new              | () -> new Class() |


### 20.3.6 Common Pitfalls

- A method reference must match *exactly* the functional interface signature.
- Method overloads can make method references ambiguous.
- Instance-method reference (`Class::method`) shifts the receiver to parameter 1.
- Constructor reference fails if there is no matching constructor.

```java
// ❌ Ambiguous: which println()? (println(int), println(String)...)
Consumer<String> c = System.out::println; // OK only because FI parameter is String

// ❌ No matching constructor
Function<String, Integer> f = Integer::new; 
// ERROR: Integer(String) exists, but return type Integer must match
```

When in doubt, rewrite the method reference as a lambda — if the lambda works but the method reference does not, the problem is usually signature matching.
