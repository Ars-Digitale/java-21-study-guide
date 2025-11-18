# Looping Constructs in Java 

Java provides several **looping constructs** that allow repeated execution of a block of code as long as a condition holds. 
Loops are essential for iteration, traversal of data structures, repeated computations, and implementing algorithms. 

## 1. The `while` Loop

The `while` loop evaluates its **boolean condition before each iteration**.  
If the condition is `false` from the beginning, the body is **never executed**.

**Syntax**
```java
while (condition) {
    // loop body
}
```

- The **condition** must evaluate to a boolean.
- The loop may execute zero or more times.
- Common pitfalls include forgetting to update the loop variable, causing an infinite loop.

Example:

```java
int i = 0;
while (i < 3) {
    System.out.println(i);
    i++;
}
```

Output:

```bash
0
1
2
```

## 2. The `do-while` Loop

The do-while loop evaluates its condition after executing the body,
ensuring that the loop body runs at least once, even if the condition is false.

**Syntax**
```java
do {
    // loop body
} while (condition);
```
> [!TIP]
> `do-while` requires a semicolon after the closing parenthesis.

Example:

```java
int x = 5;
do {
    System.out.println(x);
    x--;
} while (x > 5); // body runs once even though condition is false
```

Output:

```bash
5
```

## 3. The `for` Loop

The traditional for `loop` is best suited for loops with a counter variable.
It consists of three parts: **initialization**, **condition**, and **update**.

**Syntax**
```java
for (initialization; condition; update) {
    // loop body
}
```
- **Initialization runs once** before the loop starts.
- **Condition** is evaluated before each iteration.
- **Update** runs after each iteration.
- Initialization and Update sections may contain multiple statements separate by commas.
- The variables in the **initialization** block must all be of the same type.
- Any of the three components may be omitted, but the semicolons must remain.

Example:

```java
for (int i = 0; i < 3; i++) {
    System.out.println(i);
}
```

Omitting parts:

```java
int j = 0;
for (; j < 3;) {  // valid
    j++;
}
```

Multiple statements:

```java
int x = 0;
for (long i = 0, c = 3; x < 3 && i < 12; x++, i++) {
    System.out.println(i);
}
```

## 4. The Enhanced `for-each` Loop

The enhanced for loop simplifies iteration over arrays and collections.

**Syntax**
```java
for (ElementType var : arrayOrCollection) {
    // loop body
}
```
- The loop variable is read-only relative to the underlying collection.
- Works with any **Iterable** or array.
- You cannot remove elements from a collection with for-each unless using an iterator.

Example

```java
String[] names = {"A", "B", "C"};
for (String n : names) {
    System.out.println(n);
}
```

Output:

```bash
A
B
C
```

## 6. Nested Loops

Loops may be nested within each other.
Each loop maintains its own variables and conditions.

Example

```java
for (int i = 1; i <= 2; i++) {
    for (int j = 1; j <= 3; j++) {
        System.out.println(i + "," + j);
    }
}
```

Output:

```bash
1,1
1,2
1,3
2,1
2,2
2,3
```

## 7. Infinite Loops

A loop is infinite when its condition always evaluates to true or is omitted.

Examples

```java
while (true) { ... }
```
```java
for (;;) { ... }   // infinite for loop
```
> [!TIP]
> Infinite loops must contain `break`, `return`, or external control to terminate.


## 8. `break` and `continue`



**`break`**

Exits the innermost loop immediately.

```java
for (int i = 0; i < 5; i++) {
    if (i == 2) break;
    System.out.println(i);
}
```

**`continue`**

Skips the rest of the loop body and proceeds with the next iteration.

```java
for (int i = 0; i < 5; i++) {
    if (i % 2 == 0) continue;
    System.out.println(i);   // prints only odd numbers
}
```

`break` and `continue` are applied, without labels, to the nearest inner loop under execution.


## 9. Labeled Loops

A label, which is a single identifier followed by a colon `(:)` may be applied to a loop to allow break or continue to affect outer loops.

**Syntax**
```java
labelName:
for (...) {
    for (...) {
        break labelName;   // jumps out of outer loop
    }
}
```

Example

```java
outer:
for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= 3; j++) {
        if (j == 2) break outer;
        System.out.println(i + "," + j);
    }
}
```

## 10. Loop Variable Scope

- Variables declared inside a loop header (like for (int i = ...)) are scoped to the loop only.
- Variables declared inside the body exist only inside the block.

```java
for (int i = 0; i < 3; i++) {
    int x = i * 2;
}
// i and x are not accessible here
```

## 11. Unreachable code after `break`, `continue`, and `return`

In Java, any statement placed **after** `break`, `continue`, or `return` within the **same block** is considered **unreachable code**, and the compiler will refuse to compile it.  
This is because these keywords **guarantee** that program control leaves the current block immediately, making any following statements impossible to reach during execution.

###  Unreachable Code After `break`
```java
for (int i = 0; i < 3; i++) {
    break;
    System.out.println("Unreachable"); // ❌ Compile-time error
}
```

###  Unreachable Code After continue
```java
for (int i = 0; i < 3; i++) {
    continue;
    System.out.println("Unreachable"); // ❌ Compile-time error
}
```

Explanation:

continue skips to the next iteration.

The statement following it will never run.

###  Unreachable Code After return
```java
int test() {
    return 5;
    System.out.println("Unreachable"); // ❌ Compile-time error
}
```

Explanation:

return exits the method immediately.

No code can appear after it in the same block.


