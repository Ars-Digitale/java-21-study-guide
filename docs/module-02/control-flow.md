# Module 2: Control Flow

**Control flow** in Java refers to the **order in which individual statements, instructions, or function calls are executed** during program runtime.  
By default, statements run **sequentially** from top to bottom, but **control flow statements** allow the program to **make decisions**, **repeat actions**, or **branch execution paths** based on conditions.

Java provides three main categories of control flow constructs:

1. **Decision-making statements** — `if`, `if-else`, `switch`
2. **Looping statements** — `for`, `while`, `do-while`, and enhanced `for`
3. **Branching statements** — `break`, `continue`, and `return`


> [!TIP]
> Understanding control flow is essential for determining how data moves through your program and how logic decisions are executed step by step.


## 1. The `if` Statement

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

---

## 2. The `switch` Statement & Expression 

The **`switch`** construct is a control-flow structure that selects **one branch among multiple alternatives** based on the value of an expression (the *selector*).

Compared to long chains of `if-else-if`, a `switch`:

- Is **easier to read** when testing many discrete values (constants, enums, strings).
- Can be **safer and more concise** when used as a **switch expression**, because:
  - It **produces a value**.
  - The compiler can enforce **exhaustiveness** and **type consistency**.

Java 21 supports:

- The **classic `switch` statement** (control flow only).
- The **`switch` expression** (produces a result).
- **Pattern matching** inside `switch`, including type patterns and guards.


## 3. Two Forms of switch: `switch` Statement vs `switch` Expression

### 3.1 Switch Statement

A **switch statement** is used as a control-flow construct.
It **does not itself evaluate to a value**, but its branches may contain `return` statements that return from the **enclosing method**.

```java
switch (mode) {                     // switch statement
    case "ON":
        start();
        break;                      // prevents fall-through
    case "OFF":
        stop();
        break;
    default:
        reset();
}
```

**Key points**:

- Each `case` clause includes one or a set of matching values split by commas `(,)`; after that a separator follows which can be both a colon `(:)` or, less usual for `statement`, the **arrow operator** `(->)`.
Finally, an expression or a code block with braces `({})`, for the code to execute, when a match occurs; (Note that if you use the arrow operator for one clause, you must use it for all clauses)
- Fall-through is possible unless a branch uses break, return, or throw: while `break` are optional, when present they terminate the switch after the execution of the matching clause they belong to; without the `break` 
statement, the code continues to execute, `in order`, the following branches;
- A `default` clause is optional and it can appear anywhere within the switch statement: a `default` statement runs if there is no match; 
- There is no value that the switch as a `statement` yields. You cannot assign the statement itself to a variable.