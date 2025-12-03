# Class Loading, Initialization, and Object Construction

In Java, understanding **how classes are loaded**, **how static and instance members are initialized**, and **how constructors run — especially with inheritance** — is essential for mastering the language.

This chapter provides a unified, clear explanation of:

- How a class is loaded into memory
- How static variables and static initializers are executed
- How objects are created step-by-step
- How constructors run in an inheritance chain
- How different memory areas (Heap, Stack, Method Area) participate

## 1. Memory Areas Relevant to Class and Object Initialization

Before understanding initialization order, it is useful to recall the three main memory areas involved:

- **Method Area (a.k.a. Class Area)** — stores class metadata, static variables, and static initializer blocks.
- **Heap** — stores all objects and instance fields.
- **Stack** — stores method calls, local variables, and references.

> **Note:** Static members belong to the **class** and are created **once** in the Method Area.  
Instance members belong to **each object** and live in the **Heap**.

## 2. Class Loading (with Inheritance)

When a Java program starts, the JVM loads classes *on demand*.  
When a class is referenced for the first time (e.g., by calling `new` or accessing a static member), **its entire inheritance chain must be loaded first**.

### 2.1 Class Loading Order

Given a class hierarchy:

```java
class A { ... }
class B extends A { ... }
class C extends B { ... }
```

If the code executes:

```java
public static void main(String[] args) {
    new C();
}
```

Then class loading proceeds in this strict order:

- Load class A
- Initialize A’s static variables (default → explicit)
- Run A’s static initializer blocks (top → bottom)
- Load class B and repeat the same logic
- Load class C and repeat the same logic

### 2.2 What Happens During Class Loading

- **Step 1: Static variables are allocated** (default values first).
- **Step 2: Explicit static initializations run**.
- **Step 3: Static initializer blocks** run in source order.

> **Note:** After these steps, the class is fully prepared and may now be used (instantiated or referenced).

## 3. Object Creation (with Inheritance)

When the `new` keyword is used, **instance creation follows a strict and predictable sequence** involving all parent classes.

### 3.1 Full Instance Creation Order

- **1. Memory is allocated on the Heap for the new object** (fields get default values).
- **2. Parent constructors must run first** — top of hierarchy → subclass.
- **3. Instance variables receive explicit initializations**.
- **4. Instance initializer blocks execute**.
- **5. The constructor body runs**.

## 4. A Complete Example: Static + Instance Initialization Across Inheritance

Consider the following three-level hierarchy:

```java
class A {
    static int sa = init("A static var");

    static {
        System.out.println("A static block");
    }

    int ia = init("A instance var");

    {
        System.out.println("A instance block");
    }

    A() {
        System.out.println("A constructor");
    }

    static int init(String msg) {
        System.out.println(msg);
        return 0;
    }
}

class B extends A {
    static int sb = init("B static var");

    static {
        System.out.println("B static block");
    }

    int ib = init("B instance var");

    {
        System.out.println("B instance block");
    }

    B() {
        System.out.println("B constructor");
    }
}

class C extends B {
    static int sc = init("C static var");

    static {
        System.out.println("C static block");
    }

    int ic = init("C instance var");

    {
        System.out.println("C instance block");
    }

    C() {
        System.out.println("C constructor");
    }
}

public class Test {
    public static void main(String[] args) {
        new C();
    }
}
```

Output

```bash
A static var
A static block
B static var
B static block
C static var
C static block
A instance var
A instance block
A constructor
B instance var
B instance block
B constructor
C instance var
C instance block
C constructor
```

## 5. Visualization Diagram (Safe ASCII)

```text
            CLASS LOADING (top to bottom)

                A  --->  B  --->  C
                |         |         |
      static vars + static blocks executed in order

-------------------------------------------------------

            OBJECT CREATION (bottom to top)

 new C() 
    |
    +--> allocate memory for C (default values)
    +--> call B() constructor
            |
            +--> call A() constructor
                    |
                    +--> init A instance vars
                    +--> run A instance blocks
                    +--> run A constructor
            +--> init B instance vars
            +--> run B instance blocks
            +--> run B constructor
    +--> init C instance vars
    +--> run C instance blocks
    +--> run C constructor
```

## 6. Key Rules to Remember

- Static initialization happens **once** per class.
- Static initializers run in parent → child order.
- Instance initializers run **every time** an object is created.
- Instance initialization runs in child → parent order for constructors,  
but field initialization always runs **parent first**, then child.
- Constructors always call the parent constructor (explicitly or implicitly).

## 7. Summary Table

```text
STATIC (Class Level)                   | INSTANCE (Object Level)
--------------------------------------+-------------------------------------
One-time-only                         | Happens at every 'new'
Executed parent → child               | Initialization parent → child
static vars (default → explicit)      | instance vars (default → explicit)
static blocks                         | instance blocks
                                      | constructor
```
