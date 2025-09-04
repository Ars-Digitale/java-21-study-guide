# Syntax Building Blocks

Every software system or computer program is composed of a set of data and a set of operations that are applied to this data in order to produce a result.

More formally:

A computer program consists of a collection of data structures that represent the state of the system, together with algorithms that specify the operations to be performed on this state in order to produce outputs.

This document describes a **hierarchy of abstractions**: the *elementary building blocks* which, combined into increasingly complex structures, form software.  
The sequence is presented in **increasing order of complexity**, with general definitions (computer science) and Java references.

---

## 1. **Value**
- **Definition:** An abstract entity representing information (number, character, boolean, string, etc.).  
- **Theory:** A value belongs to a mathematical domain (set), such as ℕ for natural numbers or Σ* for strings.  
- **Example (abstract):** the number forty-two, the truth value *true*, the character "a".

---

## 2. **Literal**
- **Definition:** A **literal** is the concrete notation in source code that directly denotes a fixed value.  
- **In Java:** `42`, `'a'`, `true`, `"Hello"`.  
- **Theory:** A literal is syntax, while a value is its semantics.  
- **Note:** Literals are the most common way to introduce values into programs.

---

## 3. **Identifier**
- **Definition:** A symbolic name that associates a value (or a structure) with a readable label.  
- **In Java:** `int x = 42;` → `x` is an identifier.  
- **Theory:** Binding function: connects a name to a value or resource.

---

## 4. **Variable**
- **Definition:** A “memory cell” labeled by an identifier, which can hold and change value.  
- **In Java:** `int counter = 0; counter = counter + 1;`.  
- **Theory:** A mutable state that can vary over time during execution.

---

## 5. **Type**
- **Definition:** A classification of values and variables, defining what is valid and which operations are allowed.  
- **In Java:**  
  - **Primitive (simple) types:** directly represent basic values.  
    Examples: `int`, `double`, `boolean`, `char`, `byte`, `short`, `long`, `float`.  
  - **Reference (complex) types:** represent references (pointers) to objects in memory.  
    Examples: `String`, arrays (e.g., `int[]`), classes, interfaces, and user-defined types.  
- **Theory:** A type system = rules that associate sets of values and admissible operations.

---

## 6. **Expression**
- **Definition:** A combination of values, literals, variables, operators, and functions that produces a new value.  
- **In Java:** `x + 3`, `Math.sqrt(25)`, `"Hello" + " world"`.  
- **Theory:** A syntax tree that evaluates to a result.

---

## 7. **Statement**
- **Definition:** A unit of execution that modifies state or controls flow.  
- **In Java:** `x = x + 1;`, `if (x > 0) { ... }`.  
- **Theory:** A sequence of actions that does not return a value, but changes the configuration of the abstract machine.

---

## 8. **Code Block**
- **Definition:** A set of statements enclosed between delimiters forming an executable unit.  
- **In Java:** `{ int y = 5; x = x + y; }`.  
- **Theory:** A sequential composition of statements, with rules of *scope* (visibility).

---

## 9. **Function / Method**
- **Definition:** A sequence of encapsulated statements, identified by a name, which can receive inputs (parameters) and return an output (value).  
- **In Java:**
  ~~~java
  int square(int n) { return n * n; }
  ~~~
- **Theory:** A mapping between input and output domains, with an operational body.

---

## 10. **Class / Object**
- **Definition:**  
  - **Class:** abstract description of a set of objects (state + behavior).  
  - **Object:** a concrete instance of the class.  
- **In Java:**
  ~~~java
  class Point { int x, y; void move(int dx, int dy) { x += dx; y += dy; } }
  Point p = new Point();
  ~~~
- **Theory:** Abstraction of an *ADT* (Abstract Data Type).

---

## 11. **Module / Package**
- **Definition:** Logical grouping of classes, functions, and resources with a common purpose.  
- **In Java:** `package java.util;` → collects utilities.  
- **Theory:** Mechanism of organization and reuse, reducing complexity.

---

## 12. **Program**
- **Definition:** A coherent set of modules, classes, and functions that, when executed on a machine, realizes a global behavior.  
- **In Java:** The `main` and everything it invokes.  
- **Theory:** A specification of transformations from input to output on an abstract machine.

---

## 13. **System**
- **Definition:** A set of cooperating programs that interact with external resources (user, network, devices).  
- **Example:** An enterprise Java platform with database, REST services, UI.  
- **Theory:** Complex architecture of software and hardware components.

---

## 📌 Summary as a Growing Scale

`Value → Literal → Identifier → Variable → Type → Expression → Statement → Code Block → Function/Method → Class/Object → Module/Package → Program → System`

---

## 📊 Hierarchy Diagram (ASCII)

**Description:** This ASCII diagram shows the hierarchical relation between building blocks, from the most complex (System) down to the simplest (Value and its concrete form, the Literal).

~~~text
System
└── Program
    └── Module / Package
        └── Class / Object
            └── Function / Method
                └── Code Block
                    └── Statement
                        └── Expression
                            └── Type
                                └── Variable
                                    └── Identifier
                                        └── Literal
                                            └── Value
~~~

---

## 📊 Hierarchy Diagram (Mermaid)

**Description:** The Mermaid diagram renders the same hierarchy in a top-down tree. It highlights that a Literal is the syntactic form of a Value.

~~~mermaid
graph TD
    A[System]
    A --> B[Program]
    B --> C[Module / Package]
    C --> D[Class / Object]
    D --> E[Function / Method]
    E --> F[Code Block]
    F --> G[Statement]
    G --> H[Expression]
    H --> I[Type]
    I --> J[Variable]
    J --> K[Identifier]
    K --> L[Literal]
    L --> M[Value]
~~~