# Standard APIs

### 1. Strings

### 1.1 Rules for String Concatenation

As introduced in the chapter on  
[Java Operators](../module-01/java-operators.md), the symbol `+` normally represents **arithmetic addition** when used with numeric operands.  

However, when applied to **Strings**, the same operator performs **string concatenation** — that is, it creates a new string by joining operands together.

Since the operator `+` may appear in expressions where both **numbers** and **strings** are present, Java applies a specific set of rules to determine whether `+` means *numeric addition* or *string concatenation*.

### **Concatenation Rules**

1. **If both operands are numeric**, `+` performs **numeric addition**.

2. **If at least one operand is a `String`**, the `+` operator performs **string concatenation**.

3. **Evaluation is strictly left-to-right**, because `+` is **left-associative**.  
   This means that once a `String` appears on the left side of the expression, all subsequent `+` operations become concatenations.

> [!TIPS]
> Because evaluation is left-to-right, the position of the first String operand determines the rest of the expression.

Examples

```java

// *** Pure numeric addition

int a = 10 + 20;        // 30
double b = 1.5 + 2.3;   // 3.8



// *** String concatenation when at least one operand is a String

String s = "Hello" + " World";  // "Hello World"
String t = "Value: " + 10;      // "Value: 10"



// *** Left-to-right evaluation affects the result

System.out.println(1 + 2 + " apples"); 
// 3 + " apples"  → "3 apples"

System.out.println("apples: " + 1 + 2); 
// "apples: 1" + 2 → "apples: 12"



// *** Adding parentheses changes the meaning

System.out.println("apples: " + (1 + 2)); 
// parentheses force numeric addition → "apples: 3"



// *** Mixed types with multiple operands

String result = 10 + 20 + "" + 30 + 40;
// (10 + 20) = 30
// 30 + ""  = "30"
// "30" + 30 = "3030"
// "3030" + 40 = "303040"

System.out.println(1 + 2 + "3" + 4 + 5);
// Step 1: 1 + 2 = 3
// Step 2: 3 + "3" = "33"
// Step 3: "33" + 4 = "334"
// Step 4: "334" + 5 = "3345"
```

