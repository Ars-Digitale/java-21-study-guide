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

