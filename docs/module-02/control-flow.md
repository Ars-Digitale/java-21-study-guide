# Module 2: Control Flow

**Control flow** in Java refers to the **order in which individual statements, instructions, or function calls are executed** during program runtime.  
By default, statements run **sequentially** from top to bottom, but **control flow statements** allow the program to **make decisions**, **repeat actions**, or **branch execution paths** based on conditions.

Java provides three main categories of control flow constructs:

1. **Decision-making statements** — `if`, `if-else`, `switch`
2. **Looping statements** — `for`, `while`, `do-while`, and enhanced `for`
3. **Branching statements** — `break`, `continue`, and `return`


> [!TIP]
> Understanding control flow is essential for determining how data moves through your program and how logic decisions are executed step by step.


## The `if` Statement

The **`if` statement** is a **conditional control flow structure** that executes a block of code **only if** a specified **boolean expression** evaluates to `true`.  
It allows the program to make **decisions** during runtime.

**Syntax:**
```java
if (condition) {
    // executed only when condition is true
}
```

An optional else clause can handle the alternative path:

```java
if (score >= 60) {
    System.out.println("Passed");
} else {
    System.out.println("Failed");
}
```

Multiple conditions can be chained using else if:

```java
if (grade >= 90) {
    System.out.println("A");
} else if (grade >= 80) {
    System.out.println("B");
} else if (grade >= 70) {
    System.out.println("C");
} else {
    System.out.println("D or below");
}
```

> [!NOTE]
> - The if condition must evaluate to a boolean; numeric or object expressions are not allowed.
> - Curly braces {} are optional for single statements but recommended to prevent logic errors.
> - The if-else chain is evaluated top to bottom, executing only the first true branch.