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
> - The if condition must evaluate to a **boolean**; numeric or object expressions are not allowed.
> - Curly braces {} are optional for single statements but recommended to prevent logic errors.
> - The if-else chain is evaluated top to bottom, executing only the first true branch.

---

## 2. The `switch` Statement & Expression 

The **`switch`** construct is a control-flow structure that selects **one branch among multiple alternatives** based on the value of an expression (the **selector**).

Compared to long chains of `if-else-if`, a `switch`:

- Is **easier to read** when testing many discrete values (constants, enums, strings).
- Can be **safer and more concise** when used as a **switch expression**, because:
  - It **produces a value**.
  - The compiler can enforce **exhaustiveness** and **type consistency**.

Java 21 supports:

- The **classic `switch` statement** (control flow only).
- The **`switch` expression** (produces a result).
- **Pattern matching** inside `switch`, including type patterns and guards.


Both forms of `switch` share the same rules concerning the switch `Variable` and acceptable `Case Values`:

### 2.1 The **switch `target variable`** can be:

| Control Variable type     |
|---------------------------|
| `byte`   -  `Byte`        |
| `short`  -  `Short`       |
| `char`   -  `Character`   |
| `int`    -  `Integer`     |
| `String`                  |
| `enum values`             |
| `all obj. types` (with pattern matching) |
| `var` (if resolves to types above)    |

> [!WARNING]
> **Not allowed as selector types**:
> - boolean
> - long
> - float
> - double

### 2.2 Acceptable `Case Values`:

For a non-pattern switch, each case must be a compile-time constant compatible with the selector type:

Allowed as case labels:

- **Literals**: 0, 'A', "ON".
- **enum constants**: You can specify a `value` (Ex: RED) or the `name` with the `value` (Ex: Color.GREEN).
- **final constant `variables`**.

A **final constant `variable`** must be marked of course as **final** and initialized, in the same expression, with a `literal` value.

### 2.3 Type Compatibility Between Selector and Case

The selector type and each case label must be compatible:

- Numeric case constants must be within the range of the selector type.
- For an enum selector, case labels must be constants of that enum.
- For a String selector, case labels must be string constants.

### 2.4 Pattern Matching in Switch

Switch in Java 21 supports pattern matching, including:

- **Type patterns**: case String s
- **Guarded patterns**: case String s when s.length() > 3
- **Null pattern**: case null

Example:

```java
String describe(Object o) {
    return switch (o) {
        case null                -> "null";
        case Integer i           -> "int " + i;
        case String s when s.isEmpty() -> "empty string";
        case String s            -> "string (" + s.length() + ")";
        default                  -> "other";
    };
}
```

**Key points**:

- Each pattern introduces a pattern variable (i, s).
- Pattern variables are in scope only in their arm (or in paths where the pattern is known to match).
- Order matters due to **dominance**: more specific patterns must precede more general ones.

#### 2.4.1 Variable Names and Scope Across Branches

With `Pattern Matching` the pattern matching variable exist only in the scope of the arm for which it has been defined: we can then reuse the same name for different case branches.

Example:

```java
switch (o) {
    case String str           -> System.out.println(str.length());
    case CharSequence str     -> System.out.println(str.charAt(0));
    default                 -> { }
}
```

> [!NOTE]
> Note that this last examples, not returning a value, is in fact a statement switch.

#### 2.4.2 Ordering, Dominance and Exhaustiveness in Pattern Switches

When dealing with `patterns matching` the ordering of branches is always important because of **dominance** and possible **unreachable code**.

A more general pattern must NOT appear before a more specific one, or the specific one becomes unreachable.

Example:

```java
return switch (o) {
    case Object obj      -> "object";
    case String s -> "string"; // ❌ DOES NOT COMPILE -> unreachable: String is already matched by Object
}
```

or

```java
return switch (o) {
    case Integer a      -> "First";
    case Integer a  when  a > 0   -> "Second"; // ❌ DOES NOT COMPILE -> unreachable: Firs will always be selected
	...
}
```

When using `patterns matching`, switches must be **`exhaustive`**; i.e., they must handle all possible selector values:

This can be achieved by:

- Providing a default case in order to address all values that don't match a `case clause`;
- Providing a `last case clause` with a pattern variable type that is the same as the `selector` reference type.

Example:

```java
Number number = Short.valueOf(10);
switch (number) {
    case Short short      -> System.out.println("A"); // ❌ DOES NOT COMPILE -> Not exhaustive: selector reference variable of type Number
}
```

In order to solve you can:

- 1) Change the reference type of `number` to be `Short` (Exhaustiveness achieved);
- 2) Add a `default` clause that covers everything;
- 3) Add a case clause, at the end, covering the type of the selector variable (see example below);

```java
Number number = Short.valueOf(10);
switch (number) {
    case Short short      -> System.out.println("A");
	case Number b         -> System.out.println("B");
}
``` 

> [!WARNING]
> The following example, applying both a `default` clause and a `last` clause of the same type of the `selector` variable DOES NOT COMPILE:
> the compiler consider one of the two cases always dominating the other.

```java
Number number = Short.valueOf(10);
switch (number) {
    case Short short      -> System.out.println("A");
	case Number b         -> System.out.println("B"); // ❌ DOES NOT COMPILE -> the compiler consider one of the two cases always dominating the other
	default -> System.out.println("C");
}
``` 



## 3. Two Forms of switch: `switch` Statement vs `switch` Expression

### 3.1 The Switch Statement

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

- Each `case` clause includes one or a set of matching values split by commas `(,)`. <br>After that, a `separator` follows which can be both a **colon** `(:)` or, less usual for `statement`, the **arrow operator** `(->)`.
<br>Finally, an expression follows (or a code block with braces `({})`), for the code to execute when a match occurs; <br>(Note that if you use the arrow operator for one clause, you must use it for all clauses)
- Fall-through is possible unless a branch uses `break`, `return`, or `throw`.<br>While `break` are optional, when present they terminate the switch after the execution of the matching clause they belong to: without the `break` 
statement, the code continues to execute, `IN ORDER`, the following branches;
- A `default` clause is optional and it can appear anywhere within the switch statement: a `default` statement runs if there is no match; 
- There is no value that the switch as a `statement` yields. You cannot assign the statement itself to a variable.

#### 3.1.1 Fall-Through Behavior

- Execution jumps to the matching case.
- If there is no break, it continues into the next case until a break, return or throw are met.

```java
int n = 2;
switch (n) {
    case 1:
        System.out.println("1");
    case 2:
        System.out.println("2");    // printed
    case 3:
        System.out.println("3");    // printed (fall-through)
        break;
    default:
        System.out.println("message default");
}
```

Output:

```bash
2
3
```

> [!NOTE]
> If in the previous example we remove the `break` on `case 3`, also the `message default` will be printed;


### 3.2 The Switch Expression

A switch expression always produces a single value as its result.

Example:

```java
int len = switch (s) {              // switch expression
    case null      -> 0;
    case ""        -> 0;
    default        -> s.length();
};
```

**Key points**:

- Each `case` clause includes one or a set of matching values split by commas `(,)`. <br>After that, the  **arrow operator** `(->) `separator` follows.
<br>Finally, an expression follows (or a code block with braces `({})`), for the code to execute when a match occurs; 
- No fall-through between arrow arms.
- Must be **exhaustive**: all possible selector values must be covered (via cases and/or default).
- The result type must be consistent across all branches. (Ex: if a `switch expression` returns an int, the other branches can't return an unrelated type)

#### 3.2.1 `yield` in Switch Expression Blocks

When an arm of a switch expression uses a block instead of a single expression, you must use yield to provide the result:

```java
int len = switch (s) {
    case null -> 0;
    default -> {
        int l = s.trim().length();
        System.out.println("Length: " + l);
        yield l;    // result of this arm
    }
};
```

> [!NOTE]
> `yield` is only for switch expressions.
> break value; is not allowed as a way to return a value from a switch expression.

#### 3.2.2 Exhaustiveness for Switch Expressions

Because a `switch expression` must return a value, it must be also **`exhaustive`**; i.e., it must handle all possible selector values:

You can ensure this by:

- Providing a default case, or
- For enum selector: covering all enum constants, or
- For sealed types/pattern switches: covering all permitted subtypes or providing default.

Example, exhaustive through default:

```java
int val = switch (s) {
    case "one" -> 1;
    case "two" -> 2;
    default    -> 0;
};
```