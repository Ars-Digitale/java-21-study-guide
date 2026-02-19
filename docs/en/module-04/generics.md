# 18. Generics in Java

<a id="table-of-contents"></a>
### Table of Contents


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
	- [18.4.7 Overriding and Generics](#1847-overriding-and-generics)
		- [18.4.7.1 How the Compiler Validates an Override](#18471-how-the-compiler-validates-an-override)
		- [18.4.7.2 Generic Parameters and Overriding](#18472-generic-parameters-and-overriding)
		- [18.4.7.3 Valid Override - Erasing Generic Specificity](#18473-valid-override-erasing-generic-specificity)
		- [18.4.7.4 Invalid Override - Adding Generic Specificity](#18474-invalid-override-adding-generic-specificity)
		- [18.4.7.5 Valid Override - Matching Parameterization](#18475-valid-override-matching-parameterization)
		- [18.4.7.6 Invalid Override - Changing Generic Argument](#18476-invalid-override-changing-generic-argument)
		- [18.4.7.7 Why This Rule Exists](#18477-why-this-rule-exists)
		- [18.4.7.8 Mental Model](#18478-mental-model)
		- [18.4.7.9 Summary Rules](#18479-summary-rules)
	- [18.4.8 Overloading a Generic Method Why Some Overloads Are Impossible](#1848-overloading-a-generic-method--why-some-overloads-are-impossible)
	- [18.4.9 Overloading a Generic Method Inherited from a Parent Class](#1849-overloading-a-generic-method-inherited-from-a-parent-class)
	- [18.4.10 Returning Generic Types Rules and Restrictions](#18410-returning-generic-types--rules-and-restrictions)
	- [18.4.11 Summary of Erasure Rules](#18411-summary-of-erasure-rules)
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


<a id="181-generic-type-basics"></a>
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

<a id="182-why-generics-exist"></a>
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

<a id="183-generic-methods"></a>
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

<a id="184-type-erasure"></a>
## 18.4 Type Erasure

`Type erasure` is the process by which the Java compiler removes all generic type information before generating bytecode. 

This ensures backward compatibility with pre-Java-5 JVMs.

At compile time, generics are fully checked: type bounds, variance, method overloading with generics, etc. However, at runtime, all generic information disappears.

<a id="1841-how-type-erasure-works"></a>
### 18.4.1 How Type Erasure Works

- Replace all type variables (like `T`) with their erasure.
- Insert casts where needed.
- Remove all generic type arguments (e.g., `List<String>` → `List`).

<a id="1842-erasure-of-unbounded-type-parameters"></a>
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

<a id="1843-erasure-of-bounded-type-parameters"></a>
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

<a id="1844-multiple-bounds-the-first-bound-determines-erasure"></a>
### 18.4.4 Multiple Bounds: The First Bound Determines Erasure

Java allows multiple bounds:

```java
<T extends Runnable & Serializable & Cloneable>
```

The critical rule:

!!! important
    The erasure of `T` is always the **first bound**, which must be a class or interface.

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

<a id="1845-why-only-the-first-bound-becomes-the-runtime-type"></a>
### 18.4.5 Why Only the First Bound Becomes the Runtime Type?

Because the JVM must operate using a single, concrete reference type for each variable or parameter.

Runtime bytecode instructions like `invokevirtual` require a single class or interface, not a composite type such as “Runnable & Serializable & Cloneable”.

Thus:

!!! note
    Java selects the **first bound** as the runtime type, and uses the remaining bounds for **compile-time validation only**.

<a id="1846-a-more-complex-example"></a>
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

!!! note
    The compiler may insert additional casts or bridge methods in more complex inheritance scenarios, but erasure always uses only the first bound (A in this case).


<a id="1847-overriding-and-generics"></a>
### 18.4.7 Overriding and Generics

When generics interact with inheritance, two fundamental rules must be clearly understood:

!!! important
    **Override is checked after type erasure.**  
    **Type compatibility is checked before type erasure.**

These two steps explain why some methods override correctly while others produce compile-time errors.

<a id="18471-how-the-compiler-validates-an-override"></a>
#### 18.4.7.1 How the Compiler Validates an Override

When a subclass declares a method that *might* override a superclass method, the compiler performs two checks:

1. **Before erasure**  
   The method must be type-compatible with the parent method.
   - Same method name
   - Same parameter types (including generic arguments)
   - Compatible return type (covariant allowed)

2. **After erasure**  
   The erased signatures must match exactly.

Both conditions must be satisfied.

<a id="18472-generic-parameters-and-overriding"></a>
#### 18.4.7.2 Generic Parameters and Overriding

Generic type arguments are part of the method signature *at compile time*, but disappear after erasure.

Because of this:

- You are allowed to **erase generic information in the overriding method**
- You are NOT allowed to **introduce new generic specificity**
- If both methods declare parameterized types, they must match exactly


<a id="18473-valid-override-erasing-generic-specificity"></a>
#### 18.4.7.3 Valid Override - Erasing Generic Specificity

```java
class Parent {
    void process(Set<Integer> data) {}
}

class Child extends Parent {
    @Override
    void process(Set data) {}   // ✔ allowed (raw type)
}
```

Explanation:

- Before erasure: `Set` is assignment-compatible with `Set<Integer>`
- After erasure: both become `Set`

✔ Valid override.


<a id="18474-invalid-override-adding-generic-specificity"></a>
#### 18.4.7.4 Invalid Override - Adding Generic Specificity

```java
class Parent {
    void process(Set data) {}
}

class Child extends Parent {
    void process(Set<Integer> data) {}   // ❌ compile error
}
```

Explanation:

- Before erasure: `Set<Integer>` is NOT assignment-compatible with `Set`
- The compiler rejects it before even considering erasure


<a id="18475-valid-override-matching-parameterization"></a>
#### 18.4.7.5 Valid Override - Matching Parameterization

```java
class Parent {
    void process(Set<Integer> data) {}
}

class Child extends Parent {
    @Override
    void process(Set<Integer> data) {}   // ✔ exact match
}
```

Both checks pass:
- Compatible before erasure
- Identical after erasure


<a id="18476-invalid-override-changing-generic-argument"></a>
#### 18.4.7.6 Invalid Override - Changing Generic Argument

```java
class Parent {
    void process(Set<Integer> data) {}
}

class Child extends Parent {
    void process(Set<String> data) {}   // ❌ compile error
}
```

Explanation:

- Before erasure: `Set<String>` is not compatible with `Set<Integer>`
- After erasure: both would become `Set`
- Collision + incompatibility → compile error


<a id="18477-why-this-rule-exists"></a>
#### 18.4.7.7 Why This Rule Exists

Java must guarantee:

- **Compile-time type safety**
- **Runtime polymorphism after erasure**

Since generics disappear at runtime, the JVM sees only erased signatures.
The compiler must therefore ensure compatibility before erasure, and consistency after erasure.


<a id="18478-mental-model"></a>
#### 18.4.7.8 Mental Model

Think of overriding with generics as a two-phase check:

```text
Phase 1 → Are the source-level types compatible?
Phase 2 → Do the erased signatures match?
```

If either phase fails → compilation error.


<a id="18479-summary-rules"></a>
#### 18.4.7.9 Summary Rules

- Override is validated **after erasure**
- Compatibility is validated **before erasure**
- You may erase generic information in the subclass
- You may NOT introduce new generic specificity
- If both methods are parameterized, arguments must match exactly
- After erasure, signatures must be identical



This explains why some methods that *look* like overloads are rejected:
after erasure they collide, and if they are not valid overrides, the compiler blocks them.



<a id="1848-overloading-a-generic-method--why-some-overloads-are-impossible"></a>
### 18.4.8 Overloading a Generic Method — Why Some Overloads Are Impossible

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

<a id="1849-overloading-a-generic-method-inherited-from-a-parent-class"></a>
### 18.4.9 Overloading a Generic Method Inherited from a Parent Class

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

<a id="18410-returning-generic-types--rules-and-restrictions"></a>
### 18.4.10 Returning Generic Types — Rules and Restrictions

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

<a id="18411-summary-of-erasure-rules"></a>
### 18.4.11 Summary of Erasure Rules

- `Unbounded T` → erased to Object.
- `T extends X` → erased to X.
- `T extends X & Y & Z` → erased to X.
- All generic parameters are erased in method signatures.
- Casts are inserted to preserve compile-time typing.
- Bridge methods may be generated to preserve polymorphism.

---

<a id="185-bounds-on-type-parameters"></a>
## 18.5 Bounds on Type Parameters

<a id="1851-upper-bounds-extends"></a>
### 18.5.1 Upper Bounds: extends

`<T extends Number>` means **T must be Number or a subclass**.

```java
class Stats<T extends Number> {
    T num;
    Stats(T num) { this.num = num; }
}
```

<a id="1852-multiple-bounds"></a>
### 18.5.2 Multiple Bounds

Syntax: `T extends Class & Interface1 & Interface2 ...`  

The class must come first.

```java
class C<T extends Number & Comparable<T>> { }
```

<a id="1853-wildcards---extends--super"></a>
### 18.5.3 Wildcards: `?`, `? extends`, `? super`

<a id="18531-unbounded-wildcard-"></a>
#### 18.5.3.1 Unbounded Wildcard `?`

Use when you want to accept a list of unknown type:

```java
void printAll(List<?> list) { ... }
```

<a id="18532-upper-bounded-wildcard--extends"></a>
#### 18.5.3.2 Upper-Bounded Wildcard `? extends`

```java
List<? extends Number> nums = List.of(1, 2, 3);
Number n = nums.get(0);   // OK
// nums.add(5);           // ❌ cannot add: type safety
```

> **You cannot add elements (except null) to ? extends** because you don’t know the exact subtype.

<a id="18533-lower-bounded-wildcard--super"></a>
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
>
> - `extends` accepts **extraction**.

---

<a id="186-generics-and-inheritance"></a>
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

<a id="187-type-inference-diamond-operator"></a>
## 18.7 Type Inference (Diamond Operator)

```java
Map<String, List<Integer>> map = new HashMap<>();
```

The compiler infers generic arguments from the assignment.

---

<a id="188-raw-types-legacy-compatibility"></a>
## 18.8 Raw Types (Legacy Compatibility)

A **raw type** disables generics, re-introducing unsafe behavior.

```java
List raw = new ArrayList();
raw.add("x");
raw.add(10);   // allowed, but unsafe
```

> Raw types should be avoided.

---

<a id="189-generic-arrays-not-allowed"></a>
## 18.9 Generic Arrays (Not Allowed)

You cannot create arrays of parameterized types:

```java
List<String>[] arr = new List<String>[10];   // ❌ compile error
```

Because arrays enforce runtime type safety while generics rely on compile-time checks only.

---

<a id="1810-bounded-type-inference"></a>
## 18.10 Bounded Type Inference

```java
static <T extends Number> T identity(T x) { return x; }

int v = identity(10);   // OK
// String s = identity("x"); // ❌ not a Number
```

---

<a id="1811-wildcards-vs-type-parameters"></a>
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

<a id="1812-pecs-rule-producer-extends-consumer-super"></a>
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

<a id="1813-common-pitfalls"></a>
## 18.13 Common Pitfalls

- Sorting lists with wildcards: List<? extends Number> cannot accept insertions.
- Misunderstanding that List<Object> is NOT a supertype of List<String>.
- Forgetting generic arrays are illegal.
- Thinking generic types are preserved at runtime (they are erased).
- Trying to overload methods using only different type parameters.

---

<a id="1814-summary-table-of-wildcards"></a>
## 18.14 Summary Table of Wildcards

| Syntax       | Meaning                                         |
|-------------|-------------------------------------------------|
|`?`               | unknown type (read-only except Object methods) |
|`? extends T`     | read T safely, cannot add (except null) |
|`? super T`       | can add T, retrieving gives Object |


---

<a id="1815-summary-of-concepts"></a>
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

<a id="1816-complete-example"></a>
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
