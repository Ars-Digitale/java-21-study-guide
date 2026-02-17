# 7. Control Flow

<a id="table-of-contents"></a>
### Table of Contents


- [7.1 The if Statement](#71-the-if-statement)
- [7.2 The switch Statement & Expression](#72-the-switch-statement--expression)
	- [7.2.1 The switch target variable can be](#721-the-switch-target-variable-can-be)
	- [7.2.2 Acceptable Case Values](#722-acceptable-case-values)
	- [7.2.3 Type Compatibility Between Selector and Case](#723-type-compatibility-between-selector-and-case)
	- [7.2.4 Pattern Matching in Switch](#724-pattern-matching-in-switch)
		- [7.2.4.1 Variable Names and Scope Across Branches](#7241-variable-names-and-scope-across-branches)
		- [7.2.4.2 Ordering Dominance and Exhaustiveness in Pattern Switches](#7242-ordering-dominance-and-exhaustiveness-in-pattern-switches)
- [7.3 Two Forms of switch Statement vs switch Expression](#73-two-forms-of-switch-switch-statement-vs-switch-expression)
	- [7.3.1 The Switch Statement](#731-the-switch-statement)
		- [7.3.1.1 Fall-Through Behavior](#7311-fall-through-behavior)
	- [7.3.2 The Switch Expression](#732-the-switch-expression)
		- [7.3.2.1 yield in Switch Expression Blocks](#7321-yield-in-switch-expression-blocks)
		- [7.3.2.2 Exhaustiveness for Switch Expressions](#7322-exhaustiveness-for-switch-expressions)
- [7.4 Null Handling](#74-null-handling)


---


**Control flow** in Java refers to the **order in which individual statements, instructions, or method calls are executed** during program runtime. 

By default, statements run sequentially from top to bottom, but control flow statements allow the program to **make decisions**, **repeat actions**, or **branch execution paths** based on conditions.

Java provides three main categories of control flow constructs:

- **Decision-making statements** — `if`, `if-else`, `switch`
- **Looping statements** — `for`, `while`, `do-while`, and the enhanced `for`
- **Branching statements** — `break`, `continue`, and `return`

!!! tip
    Understanding control flow is essential to seeing how data moves through your program and how each logic decision is evaluated step by step.

<a id="71-the-if-statement"></a>
## 7.1 The `if` Statement

The `if` statement is a conditional control-flow structure that executes a block of code only if a specified boolean expression evaluates to `true`. It allows the program to make decisions at runtime.

**Syntax:**

```java
if (condition) {
	// executed only when condition is true
}
```

An optional `else` clause handles the alternative path:

```java
if (score >= 60) {
	System.out.println("Passed");
} else {
	System.out.println("Failed");
}
```

Multiple conditions can be chained using `else if`:

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

!!! note
    The `if` condition must evaluate to a **boolean**; numeric or object types cannot be used directly as conditions.
    
    Curly braces `{}` are optional for single statements but strongly recommended to prevent subtle logic errors.
    
    An `if-else` chain is evaluated from top to bottom, and only the first branch with a condition evaluating to `true` is executed.

---

<a id="72-the-switch-statement--expression"></a>
## 7.2 The `switch` Statement & Expression

The `switch` construct is a control-flow structure that selects one branch among multiple alternatives based on the value of an expression (the **selector**).

Compared to long chains of `if-else-if`, a `switch`:

- Is often **easier to read** when testing many discrete values (constants, enums, strings).
- Can be **safer and more concise** when used as a **switch expression** because:

It **produces a value**.

The compiler can enforce **exhaustiveness** and **type consistency**.


Java 21 supports:

- The classic `switch` **statement** (control flow only).
- The `switch` **expression** (produces a result).
- **Pattern matching** inside `switch`, including type patterns and guards.

Both forms of `switch` share the same rules concerning the selector (switch **target variable**) and acceptable case values.

<a id="721-the-switch-target-variable-can-be"></a>
### 7.2.1 The switch `target variable` can be

| Control Variable type |
| --- |
| `byte` / `Byte` |
| `short` / `Short` |
| `char` / `Character` |
| `int` / `Integer` |
| `String` |
| Enum types (selectors of an `enum`) |
| Any reference type (with pattern matching) |
| `var` (if it resolves to one of the allowed types) |

!!! warning
    **Not allowed** as selector types for switch:
    
    - `boolean`
    - `long`
    - `float`
    - `double`

<a id="722-acceptable-case-values"></a>
### 7.2.2 Acceptable `case` Values

For a non-pattern switch, each `case` label must be a compile-time constant compatible with the selector type.

Allowed as case labels:

- **Literals** such as `0`, `'A'`, `"ON"`.
- **Enum constants**, e.g., `RED` or `Color.GREEN`.
- **Final constant variables** (compile-time constants).

A compile-time constant variable:

- Must be declared with `final` and initialized in the same statement.
- Its initializer must itself be a constant expression (typically using literals and other compile-time constants).

<a id="723-type-compatibility-between-selector-and-case"></a>
### 7.2.3 Type Compatibility Between Selector and Case

The selector type and each `case` label must be compatible:

- Numeric case constants must be within the range of the selector type.
- For an `enum` selector, case labels must be constants of that `enum`.
- For a `String` selector, case labels must be string constants.

<a id="724-pattern-matching-in-switch"></a>
### 7.2.4 Pattern Matching in Switch

Switch in Java 21 supports pattern matching, including:

- **Type patterns**: `case String s`
- **Guarded patterns**: `case String s when s.length() > 3`
- **Null pattern**: `case null`

Example:

```java
String describe(Object o) {
	return switch (o) {
		case null -> "null";
		case Integer i -> "int " + i;
		case String s when s.isEmpty() -> "empty string";
		case String s -> "string (" + s.length() + ")";
		default -> "other";
	};
}
```

**Key points**:

- Each pattern introduces a pattern variable (such as `i` or `s`).
- Pattern variables are in scope only within their own arm (or paths where the pattern is known to match).
- Order matters because of **dominance**: more specific patterns must precede more general ones.

<a id="7241-variable-names-and-scope-across-branches"></a>
#### 7.2.4.1 Variable Names and Scope Across Branches

With pattern matching, the pattern variable exists only in the scope of the arm in which it is defined. This means you can reuse the same variable name in different case branches.

- Example:

```java
switch (o) {
	case String str -> System.out.println(str.length());
	case CharSequence str -> System.out.println(str.charAt(0));
	default -> { }
}
```

!!! note
    This last example does not return a value, so it is a **statement switch**, not a switch expression.

<a id="7242-ordering-dominance-and-exhaustiveness-in-pattern-switches"></a>
#### 7.2.4.2 Ordering, Dominance and Exhaustiveness in Pattern Switches

When dealing with pattern matching, the ordering of branches is crucial because of **dominance** and potential **unreachable code**.

A more general pattern must **not** appear before a more specific one, or the specific one becomes unreachable.

- Example (unreachable branch):

```java
return switch (o) {
	case Object obj -> "object";
	case String s -> "string"; // ❌ DOES NOT COMPILE: unreachable, String is already matched by Object
};
```

- Another example with a guard:

```java
return switch (o) {
	case Integer a -> "First";
	case Integer a when a > 0 -> "Second"; // ❌ DOES NOT COMPILE: unreachable, the first case matches all Integers
	// ...
};
```

When using pattern matching, switches must be **exhaustive**; that is, they must handle all possible selector values.

This can be achieved by:

- Providing a `default` case that handles all values not matched by any other case.
- Providing a final case clause with a pattern type that matches the selector reference type.

- Example (not exhaustive):

```java
Number number = Short.valueOf(10);

switch (number) {
	case Short s -> System.out.println("A"); // ❌ DOES NOT COMPILE: not exhaustive, selector is of type Number
}
```

To fix this, you can:

- Change the reference type of `number` to `Short` (then exhaustiveness is satisfied by the single case).
- Add a `default` clause that covers all remaining values.
- Add a final case clause covering the type of the selector variable, for example:

```java
Number number = Short.valueOf(10);

switch (number) {
	case Short s -> System.out.println("A");
	case Number n -> System.out.println("B");
}
```

!!! warning
    The following example, which uses both a `default` clause and a final clause with the same type as the selector variable, does **not** compile: the compiler considers one of the two cases as always dominating the other.

```java
Number number = Short.valueOf(10);

switch (number) {
	case Short s -> System.out.println("A");
	case Number n -> System.out.println("B"); // ❌ DOES NOT COMPILE: dominated by either the default or the Number pattern
	default -> System.out.println("C");
}
```

---

<a id="73-two-forms-of-switch-switch-statement-vs-switch-expression"></a>
## 7.3 Two Forms of `switch`: `switch` Statement vs `switch` Expression

<a id="731-the-switch-statement"></a>
### 7.3.1 The Switch Statement

A **switch statement** is used as a control-flow construct. 

It does not, by itself, evaluate to a value, although its branches may contain `return` statements that return from the enclosing method.

```java
switch (mode) { // switch statement
	case "ON":
		start();
		break; // prevents fall-through
	case "OFF":
		stop();
		break;
	default:
		reset();
}
```

**Key points**:

- Each `case` clause includes one or more matching values separated by commas `,`. A separator follows, which can be either a colon `:` or, less commonly for statements, the arrow operator `->`.
Finally, an expression or a block (enclosed in `{}`) defines the code to execute when a match occurs.
If you use the arrow operator for one clause, you must use it for all clauses in that switch statement.
- Fall-through is possible for colon-style cases unless a branch uses `break`, `return`, or `throw`.
When present, `break` terminates the switch after executing its case; without it, execution continues, in order, into the following branches.
- A `default` clause is optional and can appear anywhere in the switch statement. It runs if there is no match for previous cases.
- A switch statement does not yield a value as an expression; you cannot assign a switch statement directly to a variable.

<a id="7311-fall-through-behavior"></a>
#### 7.3.1.1 Fall-Through Behavior

With colon-style cases, execution jumps to the matching case label. 

If there is no `break`, it continues into the next case until a `break`, `return`, or `throw` is encountered.

```java
int n = 2;

switch (n) {
	case 1:
		System.out.println("1");
	case 2:
		System.out.println("2"); // printed
	case 3:
		System.out.println("3"); // printed (fall-through)
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

!!! note
    If in the previous example we remove the `break` on `case 3`, the message from the `default` branch will also be printed.

<a id="732-the-switch-expression"></a>
### 7.3.2 The Switch Expression

A **switch expression** always produces a single value as its result.

- Example:

```java
int len = switch (s) { // switch expression
	case null -> 0;
	case "" -> 0;
	default -> s.length();
};
```

**Key points**:

- Each `case` clause includes one or more matching values separated by commas `,`, followed by the arrow operator `->`. Then an expression or a block (enclosed in `{}`) defines the result for that arm.
- When used with an assignment or a `return` statement, a switch expression requires a terminating semicolon `;` after the expression.
- There is no fall-through between arrow arms. Each matching arm executes exactly once.
- A switch expression must be **exhaustive**: all possible selector values must be covered (via explicit cases and/or `default`).
- The result type must be consistent across all branches. For example, if one arm yields an `int`, the other arms must yield values compatible with `int`.

<a id="7321-yield-in-switch-expression-blocks"></a>
#### 7.3.2.1 `yield` in Switch Expression Blocks

When an arm of a switch expression uses a block instead of a single expression, you must use `yield` to provide the result of that arm.

```java
int len = switch (s) {
	case null -> 0;
	default -> {
		int l = s.trim().length();
		System.out.println("Length: " + l);
		yield l; // result of this arm
	}
};
```

!!! note
    `yield` is used only in switch expressions.
    `break value;` is not allowed as a way to return a value from a switch expression.

<a id="7322-exhaustiveness-for-switch-expressions"></a>
#### 7.3.2.2 Exhaustiveness for Switch Expressions

Because a switch expression must return a value, it must also be **exhaustive**; in other words, it must handle all possible selector values.

You can ensure this by:

- Providing a `default` case.
- For an enum selector: covering all enum constants explicitly.
- For sealed types or pattern switches: covering all permitted subtypes or providing a `default`.

Example, exhaustive via `default`:

```java
int val = switch (s) {
	case "one" -> 1;
	case "two" -> 2;
	default -> 0;
};
```

---

<a id="74-null-handling"></a>
## 7.4 Null Handling

**Classic switch (without patterns)**

If the selector expression of a classic switch (without pattern matching) evaluates to `null`, a `NullPointerException` is thrown at runtime.

To avoid this, check for `null` before switching:

```java
if (s == null) {
	// handle null
} else {
	switch (s) {
		case "A" -> ...
		default -> ...
	}
}
```

<ins>**Pattern switch (with `case null`)**</ins>

With pattern matching, you can handle `null` directly inside the switch:

```java
int len = switch (s) {
	case null -> 0;
	default -> s.length();
};
```

!!! note
    For switch expressions:
    
    If you do not handle `null` and the selector is `null`, a `NullPointerException` is thrown.
    
    Using `case null` makes the switch explicitly null-safe.

!!! warning
    Any time `case null` is used in a switch, the switch is treated as a pattern switch, and all the rules for pattern switches (including exhaustiveness and dominance) apply.
