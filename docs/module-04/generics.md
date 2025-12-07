# Generics in Java (Certification Grade)

Java Generics provide **compile-time type safety** by allowing `classes`, `interfaces`, and `methods` to work with **types as parameters**.  
They prevent ClassCastException at runtime by moving type checks to compile time, and they increase code reusability by enabling type-agnostic algorithms.  

Generics apply to:  
- Classes
- Interfaces
- Methods (generic methods)
- Constructors  


## 1. Generic Type Basics

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


## 2. Why Generics Exist: Before/After

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


## 3. Generic Methods

A **generic method** introduces its own type parameter(s), independent of the class.

```java
class Util {
    static <T> T pick(T a, T b) { return a; }
}

String s = Util.<String>pick("A", "B"); // explicit
String t = Util.pick("A", "B");         // inference works
```


## 4. Bounds on Type Parameters (extends / super)

### 4.1 Upper Bounds: extends

`<T extends Number>` means **T must be Number or a subclass**.

```java
class Stats<T extends Number> {
    T num;
    Stats(T num) { this.num = num; }
}
```

### 4.2 Multiple Bounds

Syntax: `T extends Class & Interface1 & Interface2 ...`  
The class must come first.

```java
class C<T extends Number & Comparable<T>> { }
```

## 5. Wildcards: `?`, `? extends`, `? super`

### 5.1 Unbounded Wildcard `?`

Use when you want to accept a list of unknown type:

```java
void printAll(List<?> list) { ... }
```

### 5.2 Upper-Bounded Wildcard `? extends`

```java
List<? extends Number> nums = List.of(1,2,3);
Number n = nums.get(0);   // OK
// nums.add(5);           // ❌ cannot add: type safety
```

Rule: **You cannot add elements (except null) to ? extends**  
because you don’t know the exact subtype.

### 5.3 Lower-Bounded Wildcard `? super`

```java
List<? super Integer> list = new ArrayList<Number>();
list.add(10);    // OK
Object o = list.get(0); // returns Object (lowest common supertype)
```

Rule: “Super accepts insertion, extends accepts extraction.”


## 6. Generics and Inheritance

Important rule: **Generics do NOT participate in inheritance**.

```java
List<String> ls = new ArrayList<>();
List<Object> lo = ls;      // ❌ compile error
```

Instead:

```java
List<? extends Object> ok = ls;   // works
```


## 7. Type Inference (Diamond Operator)

```java
Map<String, List<Integer>> map = new HashMap<>();
```

The compiler infers generic arguments from the assignment.


## 8. Raw Types (Legacy Compatibility)

A **raw type** disables generics, re-introducing unsafe behavior.

```java
List raw = new ArrayList();
raw.add("x");
raw.add(10);   // allowed, but unsafe
```

> **Note:** Raw types should be avoided.


## 9. Generic Arrays (Not Allowed)

You cannot create arrays of parameterized types:

```java
List<String>[] arr = new List<String>[10];   // ❌ compile error
```

Because arrays enforce runtime type safety while generics rely on compile time only.


## 10. Type Erasure

Type erasure is the process by which the Java compiler removes all generic type information before generating bytecode. This ensures backward compatibility with pre-Java-5 JVMs.

At compile time, generics are fully checked: type bounds, variance, method overloading with generics, etc. However, at runtime, all generic information disappears.

### 10.1 How Type Erasure Works

- Replace all type variables (like `T`) with their erasure.
- Insert casts where needed.
- Remove all generic type arguments (e.g., `List<String>` → `List`).

### 10.2 Erasure of Unbounded Type Parameters

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

### 10.3 Erasure of Bounded Type Parameters

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

### 10.4 Multiple Bounds: The First Bound Determines Erasure

Java allows multiple bounds:

```java
<T extends Runnable & Serializable & Cloneable>
```

The critical rule:


> **Note:** The erasure of `T` is always the **first bound**, which must be a class or interface.

Because `Runnable` is the first bound, the compiler erases `T` to `Runnable`.

Example with Multiple Bounds (Fully Expanded)

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
public static void runAll(List<Runnable> list) {
    for (Runnable t : list) {
        t.run();
    }
}
```

What happens to the other bounds (Serializable, Cloneable)?

- They are enforced only at compile time.
- They do NOT appear in bytecode.
- No additional interfaces are attached to the erased type.

### 10.5 Why Only the First Bound Becomes the Runtime Type?

Because the JVM must operate using a single, concrete reference type for each variable or parameter.

Runtime bytecode instructions like `invokevirtual` require a single class or interface, not a composite type such as “Runnable & Serializable & Cloneable”.

Thus:

> **Note:** Java selects the **first bound** as the runtime type, and uses the remaining bounds for **compile-time validation only**.

### 10.6 A More Complex Example

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
        // value.b();   // compiler inserts a synthetic bridge or cast
    }
}
```

> **Note:** The compiler inserts additional type checks or bridge methods as needed, but erasure always uses **only the first bound** (A in this case).

### 10.7 Summary of Erasure Rules

- Unbounded T → erased to Object.
- T extends X → erased to X.
- T extends X & Y & Z → erased to X.
- All generic parameters are erased in method signatures.
- Casts are inserted to preserve compile-time typing.
- Bridge methods may be generated to preserve polymorphism.


## 11. Bounded Type Inference

```java
<T extends Number> T identity(T x) { return x; }

int v = identity(10);   // OK
// String s = identity("x"); // ❌ not a Number
```


## 12. Wildcards vs. Type Parameters

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


## 13. PECS Rule (Producer Extends, Consumer Super)

Use **? extends** when the parameter **produces** values.  
Use **? super** when the parameter **consumes** values.

```java
// ? extends → safe read
Number n = listExtends.get(0);

// ? super → safe write
listSuper.add(10);
```


## 14. Common Pitfalls

- Sorting lists with wildcards: List<? extends Number> cannot accept insertions.
- Misunderstanding that List<Object> is NOT a supertype of List<String>.
- Forgetting generic arrays are illegal.
- Thinking generic types are preserved at runtime (they are erased).
- Trying to overload methods using only different type parameters.


## 15. Summary Table of Wildcards

```text
?              → unknown type (read-only except Object methods)
? extends T     → read T safely, cannot add (except null)
? super T       → can add T, retrieving gives Object
```


## 16. Summary Table of Concepts

```text
Generics = compile-time type safety
Bounds = restrict legal types
Wildcards = flexibility in parameters
Type Inference = compiler deduces types
Type Erasure = generics disappear at runtime
Bridge Methods = maintain polymorphism
```


## 17. Complete Example

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
