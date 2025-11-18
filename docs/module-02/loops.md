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



