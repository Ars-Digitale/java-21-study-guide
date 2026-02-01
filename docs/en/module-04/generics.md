# 18. Generics in Java

### Table of Contents

- [18. Generics in Java](#18-generics-in-java)
  - [18.1 Generic Type Basics](#181-generic-type-basics)
  - [18.2 Why Generics Exist](#182-why-generics-exist)
  - [18.3 Generic Methods](#183-generic-methods)
  - [18.4 Type Erasure](#184-type-erasure)
    - [18.4.1 How Type Erasure Works](#1841-how-type-erasure-works)
    - [18.4.2 Erasure of Unbounded Type Parameters](#1842-erasure-of-unbounded-type-parameters)
    - [18.4.3 Erasure of Bounded Type Parameters](#1843-erasure-of-bounded-type-parameters)
    - [18.4.4 Multiple Bounds The First Bound Determines Erasure](#1844-multiple-bounds-the-first-bound-determines-erasure)
    - [18.4.5 Why Only the First Bound Becomes the Runtime Type](#1845-why-only-the-first-bound-becomes-the-runtime-type)
    - [18.4.6 A More Complex Example](#1846-a-more-complex-example)
    - [18.4.7 Overloading a Generic Method Why Some Overloads Are Impossible](#1847-overloading-a-generic-method--why-some-overloads-are-impossible)
    - [18.4.8 Overloading a Generic Method Inherited from a Parent Class](#1848-overloading-a-generic-method-inherited-from-a-parent-class)
    - [18.4.9 Returning Generic Types Rules and Restrictions](#1849-returning-generic-types--rules-and-restrictions)
    - [18.4.10 Summary of Erasure Rules](#18410-summary-of-erasure-rules)
  - [18.5 Bounds on Type Parameters](#185-bounds-on-type-parameters)
    - [18.5.1 Upper Bounds extends](#1851-upper-bounds-extends)
    - [18.5.2 Multiple Bounds](#1852-multiple-bounds)
    - [18.5.3 Wildcards: ?, ? extends, ? super](#1853-wildcards---extends--super)
      - [18.5.3.1 Unbounded Wildcard](#18531-unbounded-wildcard-)
      - [18.5.3.2 Upper-Bounded Wildcard extends](#18532-upper-bounded-wildcard--extends)
      - [18.5.3.3 Lower-Bounded Wildcard super](#18533-lower-bounded-wildcard--super)
  - [18.6 Generics and Inheritance](#186-generics-and-inheritance)
  - [18.7 Type Inference Diamond Operator](#187-type-inference-diamond-operator)
  - [18.8 Raw Types Legacy Compatibility](#188-raw-types-legacy-compatibility)
  - [18.9 Generic Arrays Not Allowed](#189-generic-arrays-not-allowed)
  - [18.10 Bounded Type Inference](#1810-bounded-type-inference)
  - [18.11 Wildcards vs Type Parameters](#1811-wildcards-vs-type-parameters)
  - [18.12 PECS Rule Producer Extends Consumer Super](#1812-pecs-rule-producer-extends-consumer-super)
  - [18.13 Common Pitfalls](#1813-common-pitfalls)
  - [18.14 Summary Table of Wildcards](#1814-summary-table-of-wildcards)
  - [18.15 Summary of Concepts](#1815-summary-of-concepts)
  - [18.16 Complete Example](#1816-complete-example)

---

Java `Generics` allow you to create classes, interfaces, and methods that work with user-specified types, ensuring that only objects of the correct type are used.

All type checks are performed by the compiler at compile time.

During compilation, the compiler verifies type correctness and then removes the generic type information, replacing it with concrete types (a process known as **type erasure**) or with Object when necessary.

The resulting bytecode does not contain generics: it only contains concrete types and, when needed, casts automatically inserted by the compiler.

In this way, type errors are caught before execution, making the code safer, more readable, and more reusable.

Generics apply to:  
- `Classes`
- `Interfaces`
- `Methods` (generic methods)
- `Constructors`  


## 18.1 Generic Type Basics

A generic class or interface introduces one or more **type parameters**, enclosed in angle brackets.

```java
class Box<T> {
    private T value;
    void set(T v) { value = v; }
    T get()       { return value; }
}

Box<String> b = new Box<>();
b.set("hello");
String x = b.get(); // no cast needed
```

Multiple type parameters are allowed:

```java
class Pair<K, V> {
    K key;
    V value;
}
```

---

## 18.2 Why Generics Exist

```java
List list = new ArrayList();          // pre-generics
list.add("hi");
Integer x = (Integer) list.get(0);    // ClassCastException at runtime
```

With generics:

```java
List<String> list = new ArrayList<>();
list.add("hi");
String x = list.get(0);               // type-safe, no cast
```

---

## 18.3 Generic Methods

A **generic method** introduces its own type parameter(s), independent of the class.

```java
class Util {
    static <T> T pick(T a, T b) { return a; }
}

String s = Util.<String>pick("A", "B"); // explicit
String t = Util.pick("A", "B");         // inference works
```

---

## 18.4 Type Erasure

`Type erasure` is the process by which the Java compiler removes all generic type information before generating bytecode. 

This ensures backward compatibility with pre-Java-5 JVMs.

At compile time, generics are fully checked: type bounds, variance, method overloading with generics, etc. However, at runtime, all generic information disappears.

### 18.4.1 How Type Erasure Works

- Replace all type variables (like `T`) with their erasure.
- Insert casts where needed.
- Remove all generic type arguments (e.g., `List<String>` → `List`).

### 18.4.2 Erasure of Unbounded Type Parameters

If a type variable has no bound:

```java
class Box<T> {
    T value;
    T get() { return value; }
}
```

The erasure of `T` is `Object`.

```java
class Box {
    Object value;
    Object get() { return value; }
}
```

### 18.4.3 Erasure of Bounded Type Parameters

If the type parameter has bounds:

```java
class TaskRunner<T extends Runnable> {
    void run(T task) { task.run(); }
}
```

Then the erasure of `T` is the first bound: `Runnable`.

```java
class TaskRunner {
    void run(Runnable task) { task.run(); }
}
```

### 18.4.4 Multiple Bounds: The First Bound Determines Erasure

Java allows multiple bounds:

```java
<T extends Runnable & Serializable & Cloneable>
```

The critical rule:

> [!IMPORTANT]
> The erasure of `T` is always the **first bound**, which must be a class or interface.

Because `Runnable` is the first bound, the compiler erases `T` to `Runnable`.

-Example with Multiple Bounds (Fully Expanded)

```java
public static <T extends Runnable & Serializable & Cloneable>
void runAll(List<T> list) {
    for (T t : list) {
        t.run();
    }
}
```

Erased Version

```java
public static void runAll(List list) {
    for (Object obj : list) {
        Runnable t = (Runnable) obj;   // cast set by the compiler
        t.run();
    }
}

```

What happens to the other bounds (Serializable, Cloneable)?

- They are enforced only at compile time.
- They do NOT appear in bytecode.
- No additional interfaces are attached to the erased type.

### 18.4.5 Why Only the First Bound Becomes the Runtime Type?

Because the JVM must operate using a single, concrete reference type for each variable or parameter.

Runtime bytecode instructions like `invokevirtual` require a single class or interface, not a composite type such as “Runnable & Serializable & Cloneable”.

Thus:

> [!NOTE]
> Java selects the **first bound** as the runtime type, and uses the remaining bounds for **compile-time validation only**.

### 18.4.6 A More Complex Example

```java
interface A { void a(); }
interface B { void b(); }

class C implements A, B {
    public void a() {}
    public void b() {}
}

class Demo<T extends A & B> {
    void test(T value) {
        value.a();
        value.b();
    }
}
```

Erased Version

```java
class Demo {
    void test(A value) {
        value.a();
        // value.b();   // ❌ not available after erasure: type is A, not B
    }
}
```

> [!NOTE]
> The compiler may insert additional casts or bridge methods in more complex inheritance scenarios, but erasure always uses only the first bound (A in this case).


### 18.4.7 Overloading a Generic Method — Why Some Overloads Are Impossible

When Java compiles generic code, it applies type erasure:
type parameters such as T are removed, and the compiler substitutes them with their erased type (usually Object or the first bound).

Because of this, two methods that look different at the source level may become identical after erasure.

If the erased signatures are the same, Java cannot distinguish between them, therefore the code does not compile.

- Example: Two Methods That Collapse to the Same Signature

```java
public class Demo {
    public void testInput(List<Object> inputParam) {}

    // public void testInput(List<String> inputParam) {}   // ❌ Compile error: after erasure, both become testInput(List)
}
```

Explanation

```bash
List<Object> and List<String> are both erased to List.
```

At runtime both methods would appear as:

```java
void testInput(List inputParam)
```

Java does not allow two methods with identical signatures in the same class, so the overload is rejected at compile time.

### 18.4.8 Overloading a Generic Method Inherited from a Parent Class

The same rule applies when a subclass tries to introduce a method that erases to the same signature as one in its superclass.

```java
public class SubDemo extends Demo {
    public void testInput(List<Integer> inputParam) {} 
    // ❌ Compile error: erases to testInput(List), same as parent
}
```

Again, the compiler rejects the overload because the erased signatures collide.

<ins>**When Overloading Does Work**</ins>

**Erasure only removes type parameters, not the actual class used in the method parameter**.

Therefore, if two method parameters differ in their raw (non-generic) type, the overload is legal, even if one is a generic parameterized type.

```java
public class Demo {
    public void testInput(List<Object> inputParam) {}
    public void testInput(ArrayList<String> inputParam) {}  // ✔ Compiles
}
```

<ins>**Why this works**</ins>

Even though ArrayList<String> erases to ArrayList, and List<Object> erases to List, these are different classes (ArrayList vs. List), so the signatures remain distinct:

```java
void testInput(List inputParam)
void testInput(ArrayList inputParam)
```

No collision → legal overloading.

### 18.4.9 Returning Generic Types — Rules and Restrictions

When returning a value from a method, Java follows a strict rule:

The return type of an overriding method must be a subtype of the parent's return type, and any generic arguments must remain type-compatible (even though they are erased at runtime).

This often confuses developers, because generics on return types cause similar erasure-based conflicts as parameter types.

Key Points:
- Return type covariance applies only to the raw type, not the generic arguments.
- Generic arguments must remain compatible after erasure (they must match).
- Two methods cannot differ only by generic parameter on the return type.

- Example: Illegal Return Type Change Due to Generic Mismatch

```java
class A {
    List<String> getData() { return null; }
}

class B extends A {
    // List<Integer> is not a covariant return type of List<String>
    // ❌ Compile error
    List<Integer> getData() { return null; }
}
```

Explanation:

Even though generics are erased, Java still enforces source-level type safety:

`List<Integer>` is not a subtype of `List<String>`.

Both erase to `List`, but Java rejects overriding that breaks type compatibility.

- Example: Legal Covariant Return Type

```java
class A {
    Collection<String> getData() { return null; }
}

class B extends A {
    List<String> getData() { return null; }  // ✔ List is a subtype of Collection
}
```

This is allowed because:
- The raw types are covariant (List extends Collection).
- The generic arguments match (String vs. String).

- Example: Illegal Overload on Return Type Alone

Two methods differing only by the generic argument in the return type cannot coexist:

```java
class Demo {
    List<String> getList() { return null; }

    // List<Integer> getList() { return null; }  
    // ❌ Compile error: return type alone does not distinguish methods
}
```

**Java does not use the return type when distinguishing overloaded methods**.

### 18.4.10 Summary of Erasure Rules

- `Unbounded T` → erased to Object.
- `T extends X` → erased to X.
- `T extends X & Y & Z` → erased to X.
- All generic parameters are erased in method signatures.
- Casts are inserted to preserve compile-time typing.
- Bridge methods may be generated to preserve polymorphism.

---

## 18.5 Bounds on Type Parameters

### 18.5.1 Upper Bounds: extends

`<T extends Number>` means **T must be Number or a subclass**.

```java
class Stats<T extends Number> {
    T num;
    Stats(T num) { this.num = num; }
}
```

### 18.5.2 Multiple Bounds

Syntax: `T extends Class & Interface1 & Interface2 ...`  

The class must come first.

```java
class C<T extends Number & Comparable<T>> { }
```

### 18.5.3 Wildcards: `?`, `? extends`, `? super`

#### 18.5.3.1 Unbounded Wildcard `?`

Use when you want to accept a list of unknown type:

```java
void printAll(List<?> list) { ... }
```

#### 18.5.3.2 Upper-Bounded Wildcard `? extends`

```java
List<? extends Number> nums = List.of(1, 2, 3);
Number n = nums.get(0);   // OK
// nums.add(5);           // ❌ cannot add: type safety
```

> **You cannot add elements (except null) to ? extends** because you don’t know the exact subtype.

#### 18.5.3.3 Lower-Bounded Wildcard `? super`

`<? super Integer>` means **the type must be Integer or a superclass of Integer**.

```java
List<? super Integer> list = new ArrayList<Number>();
list.add(10);    // OK
Object o = list.get(0); // returns Object (lowest common supertype)
```


> **IMPORTANT**
>
> - `Super` accepts **insertion**
> - `extends` accepts **extraction**.

---

## 18.6 Generics and Inheritance


> **Generics do NOT participate in inheritance**. 
> 
> A `List<String>` is not a subtype of `List<Object>`; parameterized types are invariant.


```java
List<String> ls = new ArrayList<>();
List<Object> lo = ls;      // ❌ compile error
```

Instead:

```java
List<? extends Object> ok = ls;   // works
```

---

## 18.7 Type Inference (Diamond Operator)

```java
Map<String, List<Integer>> map = new HashMap<>();
```

The compiler infers generic arguments from the assignment.

---

## 18.8 Raw Types (Legacy Compatibility)

A **raw type** disables generics, re-introducing unsafe behavior.

```java
List raw = new ArrayList();
raw.add("x");
raw.add(10);   // allowed, but unsafe
```

> Raw types should be avoided.

---

## 18.9 Generic Arrays (Not Allowed)

You cannot create arrays of parameterized types:

```java
List<String>[] arr = new List<String>[10];   // ❌ compile error
```

Because arrays enforce runtime type safety while generics rely on compile-time checks only.

---

## 18.10 Bounded Type Inference

```java
static <T extends Number> T identity(T x) { return x; }

int v = identity(10);   // OK
// String s = identity("x"); // ❌ not a Number
```

---

## 18.11 Wildcards vs. Type Parameters

Use **wildcards** when you need flexibility in parameters.  
Use **type parameters** when the method must return or maintain type information.

Example — wildcard too weak:

```java
List<?> copy(List<?> list) {
   return list;  // loses type information
}
```

Better:

```java
<T> List<T> copy(List<T> list) {
    return list;
}
```

---

## 18.12 PECS Rule (Producer Extends, Consumer Super)

Use **? extends** when the parameter **produces** values.  
Use **? super** when the parameter **consumes** values.

```java
List<? extends Number> listExtends = List.of(1, 2, 3);
List<? super Integer> listSuper = new ArrayList<Number>();

// ? extends → safe read
Number n = listExtends.get(0);

// ? super → safe write
listSuper.add(10);
```

---

## 18.13 Common Pitfalls

- Sorting lists with wildcards: List<? extends Number> cannot accept insertions.
- Misunderstanding that List<Object> is NOT a supertype of List<String>.
- Forgetting generic arrays are illegal.
- Thinking generic types are preserved at runtime (they are erased).
- Trying to overload methods using only different type parameters.

---

## 18.14 Summary Table of Wildcards

| Syntax       | Meaning                                         |
|-------------|-------------------------------------------------|
|`?`               | unknown type (read-only except Object methods) |
|`? extends T`     | read T safely, cannot add (except null) |
|`? super T`       | can add T, retrieving gives Object |


---

## 18.15 Summary of Concepts

```text
Generics = compile-time type safety
Bounds = restrict legal types
Wildcards = flexibility in parameters
Type Inference = compiler deduces types
Type Erasure = generics disappear at runtime
Bridge Methods = maintain polymorphism
```

---

## 18.16 Complete Example

```java
class Repository<T extends Number> {
    private final List<T> store = new ArrayList<>();

    void add(T value) { store.add(value); }

    T first() { return store.isEmpty() ? null : store.get(0); }

    // generic method with wildcard
    static double sum(List<? extends Number> list) {
        double total = 0;
        for (Number n : list) total += n.doubleValue();
        return total;
    }
}

```
