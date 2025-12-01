# Module 1: Instantiating types

### Table of Contents

- [1. Instantiating Types](#1-instantiating-types)
  - [1.1 Handling Primitive Types](#11-handling-primitive-types)
    - [1.1.1 Declaring a Primitive](#111-declaring-a-primitive)
    - [1.1.2 Assigning a Primitive](#112-assigning-a-primitive)
  - [1.2 Handling Reference Types](#12-handling-reference-types)
    - [1.2.1 Creating and Assigning a Reference](#121-creating-and-assigning-a-reference)
    - [1.2.2 Constructors](#122-constructors)
    - [1.2.3 Instance Initializer Blocks](#123-instance-initializer-blocks)
  - [1.3 Default Variable Initialization](#13-default-variable-initialization)
    - [1.3.1 Instance and Class Variables](#131-instance-and-class-variables)
    - [1.3.2 Local Variables](#132-local-variables)
    - [1.3.3 Inferring Types with `var`](#133-inferring-types-with-var)
  - [1.4 Wrapper Types](#14-wrapper-types)
    - [1.4.1 Purpose of Wrapper Types](#141-purpose-of-wrapper-types)
    - [1.4.2 Autoboxing and Unboxing](#142-autoboxing-and-unboxing)
    - [1.4.3 Parsing and Conversion](#143-parsing-and-conversion)
    - [1.4.4 Helper Methods](#144-helper-methods)
    - [1.4.5 Null Values](#145-null-values)
  - [1.5 Equality in Java](#15-equality-in-java)
    - [1.5.1 Equality with Primitives](#151-equality-with-primitive-types)
    - [1.5.2 Equality with Reference Types](#152-equality-with-reference-types)
      - [1.5.2.1 `==` (Identity Comparison)](#1521-identity-comparison)
      - [1.5.2.2 `.equals()` (Logical Comparison)](#1522-equals-logical-comparison)
    - [1.5.3 String Pool and Equality](#153-string-pool-and-equality)
      - [1.5.3.1 The intern method](#1531-the-intern-method)
    - [1.5.4 Equality with Wrapper Types](#154-equality-with-wrapper-types)
    - [1.5.5 Equality and `null`](#155-equality-and-null)
    - [1.5.6 Summary Table](#156-summary-table)

	
---

## 1. Instantiating Types
 
In Java, a **type** can be either a **primitive type** (such as `int`, `double`, `boolean`, etc.) or a **reference type** (classes, interfaces, arrays, enums, records, etc.). See: [Module 1: Java Data Types](data-types.md)

The way instances are created depends on the category of the type:

- **Primitive types**  
  Instances of primitive types are created simply by declaring a variable.  
  The JVM automatically allocates memory to hold the value, and no explicit keyword is needed. 
  
```java
  int age = 30;         // creates a primitive int with value 30
  boolean flag = true;  // creates a primitive boolean with value true
  double pi = 3.14159;  // creates a primitive double with value 3.14159
```
  
 - **Reference types (objects)**  
	Instances of class types are created using the new keyword (except for a few special cases such as string literals, records with canonical constructors, or factory methods).
	The new keyword allocates memory on the heap and invokes a constructor of the class.
  
```java
	String name = new String("Alice"); // creates a new String object explicitly
	Person p = new Person();           // creates a new Person object using its constructor
```
  
It is also common to rely on literals or factory methods for object creation.
  
```java
	String name = new String("Alice"); // creates a new String object explicitly
	Person p = new Person();           // creates a new Person object using its constructor
``` 
  
### 1.1 Handling Primitive Types

#### 1.1.1 Declaring a Primitive

**Declaring** a primitive type (as with reference types) means reserving space in memory for a variable of a given type, without necessarily giving it a value.  

> [!WARNING]
> Unlike primitives, whose size depends on their specific type (e.g., `int` vs `long`), reference types always occupy the same fixed size in memory — what varies is the size of the object they point to.

- Syntax examples for declaration only:

  ```java
  int number;
  
  boolean active;
  
  char letter;
  
  int x, y, z;          // Multiple declarations in one statement: Java allows declaring multiple variables of the same type
  ```
#### 1.1.2 Assigning a Primitive

**Assigning** a primitive type (as with reference types) means storing a value into a declared variable of that given type.  
For primitives, the variable holds the value itself, while for reference types the variable holds the memory address (a reference) of the object being pointed to.

- Syntax examples:

```java
  int number;  					// Declaring an int type: a variable called "number"
  
  number = 10;  				// Assigning the value 10 to this variable
  
  char letter = 'A';    		// Declaring and Assigning in a single statement: declaration and assignment can be combined 

  int a1, a2;                   // Multiple declarations  
  
  int a = 1, b = 2, c = 3;  	// Multiple declarations & assignements
  
  char b1, b2, b3 = 'C'			// Mixed declarations (2) with one assignement
  
  double d1, double d2;         // ERROR - NOT LEGAL
  
  int v1; v2; 					// ERROR - NOT LEGAL
```
  
> [!IMPORTANT]
> When you write a number directly in the code (a numeric literal), Java assumes by default that it is of type **int**.  
> If the value does not fit into an `int`, the code will not compile unless you explicitly mark it with the correct suffix.

- Syntax example for a numeric literal:

```java
  long exNumLit = 5729685479; // ❌ Does not compile.
                              // Even though the value would fit in a long,
                              // a plain numeric literal is assumed to be an int,
                              // and this number is too large for int.
  
  Changing the declaration adding the correct suffix (L or l) will solve:
  
  long exNumLit = 5729685479L;
  
  or
  
  long exNumLit = 5729685479l;
							 
```
  
**Declaring** a reference type means reserving space in memory for a variable that will contain a reference (pointer) to an object of the specified type.  
At this stage, no object is created yet — the variable only has the potential to point to one.

> [!WARNING]  
> Unlike primitives, whose size depends on their specific type (e.g., `int` vs `long`), reference variables always occupy the same fixed size in memory (enough to store a reference).  
> What varies is the size of the object they point to, which is allocated separately on the heap.

- Syntax examples for declaration only:

```java
  String name;
  Person person;
  List<Integer> numbers;
  
  Person p1, p2, p3;   // Multiple declarations in one statement
   
  String a = "abc", b = "def", c = "ghi";  	// Multiple declarations & assignements
  
  String b1, b2, b3 = "abc"					// Mixed declarations (b1, b2) with one assignement (b3)
  
  String d1, String d2;         			// ERROR - NOT LEGAL
  
  String v1; v2; 							// ERROR - NOT LEGAL
```

---

### 1.2 Handling Reference Types

#### 1.2.1 Creating and Assigning a Reference

**Assigning** a reference type means storing into the variable the memory address of an object.
This is normally done after the creation of the object with the **new** keyword and a Constructor, or by using a literal or a factory method.
A reference can also be assigned to another object of the same or compatible type.
Reference types can also be assigned **null**, which means that they do not refer to an object.

- Syntax examples:

```java
  Person person = new Person(); // Example with 'new' and a constructor 'Person()':
                                // 'new Person()' creates a new Person object on the heap
                                // and returns its reference, which is stored in the variable 'person'.
  
  String greeting = "Hello";	 // Example with literal (for String).
  
  List<Integer> numbers = List.of(1, 2, 3);   // Example with a factory method.
  
```
  
#### 1.2.2 Constructors

In the example, **`Person()`** is a constructor — a special kind of method used to initialize new objects.  
Whenever you call `new Person()`, the constructor runs and sets up the newly created instance.

**Constructors have three main characteristics:**

- The constructor name **must match the class name** exactly (case-sensitive).  
- Constructors **do not declare a return type** (not even `void`).  
- If you do not define any constructor in your class, the compiler will automatically provide a **default no-argument constructor** that does nothing.

> [!WARNING]  
> If you see a method that has the same name as the class **but also declares a return type**, it is **not** a constructor.  
> It is simply a regular method (though starting method names with a capital letter is against Java naming conventions).

The **purpose of a constructor** is to initialize the state of a newly created object — typically by assigning values to its fields, either with default values or using parameters passed to the constructor.

- Example 1: Default constructor (no parameters)
							 
```java
public class Person {
    String name;
    int age;

    // Default constructor
    public Person() {
        name = "Unknown";
        age = 0;
    }
}

Person p1 = new Person(); // name = "Unknown", age = 0
```

- Example 2: Constructor with parameters

```java
public class Person {
    String name;
    int age;

    // Constructor with parameters
    public Person(String newName, int newAge) {
        name = newName;
        age = newAge;
    }
}

Person p2 = new Person("Alice", 30); // name = "Alice", age = 30
```

- Example 3: Multiple constructors (constructor overloading)

```java
public class Person {
    String name;
    int age;

    // Default constructor
    public Person() {
        this("Unknown", 0); // calls the other constructor
    }

    // Constructor with parameters
    public Person(String newName, int newAge) {
        name = newName;
        age = newAge;
    }
}

Person p1 = new Person();            // name = "Unknown", age = 0
Person p2 = new Person("Bob", 25);   // name = "Bob", age = 25
```

> [!IMPORTANT]
> - Constructors are not inherited: if a superclass defines constructors, they are not automatically available in the subclass — you must declare them explicitly.
> - If you declare any constructor in a class, the compiler does not generate the default no-argument constructor: if you still need a no-argument constructor, you must declare it manually.

#### 1.2.3 Instance Initializer Blocks

In addition to constructors, Java provides a mechanism called **initializer blocks** to help initialize objects.  
These are blocks of code inside a class, enclosed in `{ }`, that run **every time an instance is created**, just before the constructor body is executed.

#### Characteristics
- Also called **instance initializer blocks**.  
- Executed, along with fields initializers, in the order in which they appear in the class definition but always before Constructors.    
- Useful when multiple constructors need to share common initialization code.

Example: Using an Instance Initializer Block

```java
public class Person {
    String name;
    int age;

    // Instance initializer block
    {
        System.out.println("Instance initializer block executed");
        age = 18; // default age for every Person
    }

    // Default constructor
    public Person() {
        name = "Unknown";
    }

    // Constructor with parameters
    public Person(String newName) {
        name = newName;
    }
}

Person p1 = new Person();          // prints "Instance initializer block executed"
Person p2 = new Person("Alice");   // prints "Instance initializer block executed"
```
> [!NOTE]
> In this example, the initializer block runs before either constructor body.
> Both p1 and p2 will start with age = 18, regardless of which constructor is used.

**Multiple Initializer Blocks**: if a class contains multiple initializer blocks, they are executed in the order they appear in the source file:

- Example: 

```java
public class Example {
    {
        System.out.println("First block");
    }

    {
        System.out.println("Second block");
    }
}

Example ex = new Example();
// Output:
// First block
// Second block
```

> [!NOTE]
> Instance initializer blocks are less common in practice, because similar logic can often be placed directly in constructors.
> It is important to know that:
> - They always run before the constructor body.
> - They are executed in the order of declaration in the class.
> - They can be combined with constructors to avoid code duplication.


### 1.3 Default Variable Initialization

#### 1.3.1 Instance and Class variables

- An **instance variable (a field)** is a value defined within an instance of an object;
- A **class variable** (defined with the keyword **static**) is defined at class level and it is shared among all the objects (instances of the class)

Instance and class variables are given a default value, by the compiler, if not initialized.

- Table of default values for instance & class variables;

| Type | Default Value |
|----|----|
| Object | null |
| Numeric | 0 |
| boolean | false |
| char | '\u0000' (NUL) |

#### 1.3.2 Local variables

**Local variables** are variables defined within a constructor, method or inizializer block;

Local variables do not have default values and they must be initialized before they can be used. If you try to use a not initialized local variable the compiler will report an ERROR.

- Example 

```java
public int localMethod {
   
	int firstVar = 25;
	int secondVar;
	secondVar = 35;
	int firstSum = firstVar + secondVar;    // OK variables are both initialized before use
	
	int thirdVar;
	int secondSum = firstSum + thirdVar;    // ERROR: variable thirdVar has not been initialized before use; if you do not try to use thirdVar the compiler will not complain
}
```

#### 1.3.3 Inferring Types with var

Under certain conditions you can use the keyword **var** in place of the appropriate type when declaring **local** variables;

> [!WARNING]
> - **var** IS NOT a reserved word in java;
> - **var** can be used only for local variables: it CAN'T be used for **constructor parameters**, **instance variables** or **method parameters**;
> - The compiler infere the type by looking ONLY at the code **on the line of the declaration**; once the right type has been inferred you can't reassign to another type.

- example

```java
public int localMethod {
   
	var inferredInt = 10; 	// The compiler infer int by the context;
	inferredInt = 25; 		// OK
	
	inferredInt = "abcd";   // ERROR: the compiler has already inferred the type of the variable as int
	
	var notInferred;
	notInferred = 30;		// ERROR: in order to infer the type, the compiler looks ONLY at the line with declaration
	
	var first, second = 15; // ERROR: var cannot be used to define two variables on the same statement;
	
	var x = null;           // ERROR: var cannot be initialized with null but it can be reassigned to null provided that the underlying type is a reference type.
}
```

### 1.4 Wrapper Types

In Java, **wrapper types** are object representations of the eight primitive types.  
Each primitive has a corresponding wrapper class in the `java.lang` package:

| Primitive | Wrapper Class |
|-----------|---------------|
| `byte`    | `Byte`        |
| `short`   | `Short`       |
| `int`     | `Integer`     |
| `long`    | `Long`        |
| `float`   | `Float`       |
| `double`  | `Double`      |
| `char`    | `Character`   |
| `boolean` | `Boolean`     |

Wrapper objects are immutable — once created, their value cannot change.

#### 1.4.1 Purpose of Wrapper Types
- Allow primitives to be used in contexts that require objects (e.g., collections, generics).  
- Provide utility methods for parsing, converting, and working with values.  
- Support constants such as `Integer.MAX_VALUE` or `Double.MIN_VALUE`.  

#### 1.4.2 Autoboxing and Unboxing
Since Java 5, the compiler automatically converts between primitives and their wrappers:
- **Autoboxing**: primitive → wrapper  
- **Unboxing**: wrapper → primitive  

```java
Integer i = 10;       // autoboxing: int → Integer
int n = i;            // unboxing: Integer → int
```

#### 1.4.3 Parsing and Conversion

Wrappers provide static methods to convert strings or other types into primitives:

```java
int x = Integer.parseInt("123");    // returns primitive int
Integer y = Integer.valueOf("456"); // returns Integer object
double d = Double.parseDouble("3.14");

// On the numeric wrapper class valueOf() throws a NumberFormatException on invalid input.
// Example:

Integer w = Integer.valueOf("two"); // NumberFormatException

// On Boolean, the method returns Boolean.TRUE for any value that matches "true" ignoring case, otherwise Boolean.false
// Example:

Boolean.valueOf("true"); 	// true
Boolean.valueOf("TrUe"); 	// true
Boolean.valueOf("TRUE"); 	// true
Boolean.valueOf("false");	// false
Boolean.valueOf("FALSE");	// false
Boolean.valueOf("xyz");		// false
Boolean.valueOf(null);		// false

// The numeric integral classes Byte, Short, Integer and Long include an overloaded **valueOf(String str, int base)** method which takes a base value
// Example with base 16 (hexadecimal) which includes character 0 -> 9 and A -> F (ignore case)

Integer.valueOf("6", 16);	// 6
Integer.valueOf("a", 16);	// 10
Integer.valueOf("A", 16);	// 10
Integer.valueOf("F", 16);	// 15
Integer.valueOf("G", 16);	// NumberFormatException
```

> [!NOTE]
> methods **parseXxx()** return a primitive while **valueOf()** returns a wrapper object.

#### 1.4.4 Helper methods

All the numeric wrapper classes extend the Number class and, for that, they inherit some helper methods such as: byteValue(), shortValue(), intValue(), longValue(), floatValue(), DoubleValue().
The Boolean and Character wrapper classes include: booleanValue() and charValue().

- Example:

```java

		// In trying to convert those helper methods can result in a loss of precision.

		Double baseDouble = Double.valueOf("300.56");

		Double wrapDouble = baseDouble.doubleValue();
		System.out.println("baseDouble.doubleValue(): " + wrapDouble);  // 300.56
		
		Byte wrapByte = baseDouble.byteValue();
		System.out.println("baseDouble.byteValue(): " + wrapByte);		// 44  -> There is no 300 in byte
		
		Integer wrapInt = baseDouble.intValue();
		System.out.println("baseDouble.intValue(): " + wrapInt);		// 300 -> The value is truncated
```

#### 1.4.5 Null Values

Unlike primitives, wrapper types can hold **null**. 
Attempting to unbox null causes a NullPointerException:

```java
Integer val = null;
int z = val; // ❌ NullPointerException at runtime
```

### 1.5 Equality in Java

Java provides two different mechanisms for checking equality:

- `==` (equality operator)
- `.equals()` (method defined in `Object` and overridden in many classes)

Understanding the difference is essential.


#### 1.5.1 Equality with Primitive Types

For **primitive values** (`int`, `double`, `char`, `boolean`, etc.),  
the operator `==` compares their actual **numeric or boolean value**.

Example:
```java
int a = 5;
int b = 5;
System.out.println(a == b);     // true

char c1 = 'A';
char c2 = 65;                   // same Unicode code point
System.out.println(c1 == c2);   // true
```

### ✔️ Key points
- `==` performs **value comparison** for primitives.
- Primitive types have **no `.equals()`** method.
- Mixed primitive types follow numeric **promotion rules**  
  (e.g., `int == long` → `int` promoted to `long`).


#### 1.5.2 Equality with Reference Types

With objects (reference types), the meaning of `==` changes.

##### 1.5.2.1 `==`(Identity Comparison)  
`==` checks whether **two references point to the same object in memory**.

```java
String s1 = new String("Hi");
String s2 = new String("Hi");

System.out.println(s1 == s2);      // false → different objects
```

Even if contents are identical, `==` is false unless both variables refer to  
**the exact same object**.


##### 1.5.2.2 `.equals()` (Logical Comparison)  
Many classes override `.equals()` to compare **values**, not memory addresses.

```java
System.out.println(s1.equals(s2)); // true → same content
```

### ✔️ Key points
- `.equals()` is defined in `Object`.
- If a class does *not* override `.equals()`, it behaves like `==`.
- Classes like `String`, `Integer`, `List`, etc. override `.equals()`  
  to provide meaningful value comparison.


#### 1.5.3 String Pool and Equality

String literals are stored in the **String pool**, so identical literals  
refer to the **same object**.

```java
String a = "Java";
String b = "Java";
System.out.println(a == b);       // true → same pooled literal
```

But using `new` creates a different object:

```java
String x = new String("Java");
String y = "Java";

System.out.println(x == y);       // false → x is not pooled
System.out.println(x.equals(y));  // true
```

Common Pitfalls

```java
String x = "Java string literal";
String y = " Java string literal".trim();

System.out.println(x == y);       // false → x and y are not the same at compile time

String a = "Java string literal";
String b = "Java ";
b += "string literal";

System.out.println(a == b);  // false
```

##### 1.5.3.1 The intern method

You can also tell Java to use a String from the String Pool (in case it already exist) through the `intern()` method:

```java
String x = "Java";
String y = new String("Java").intern();


System.out.println(x == y);       // true
```

#### 1.5.4 Equality with Wrapper Types

Wrapper classes (`Integer`, `Double`, etc.) behave like objects:

- `==` → compares references  
- `.equals()` → compares values  

However, some wrappers are **cached** (Integer from −128 to 127):

```java
Integer a = 100;
Integer b = 100;
System.out.println(a == b);        // true → cached

Integer c = 1000;
Integer d = 1000;
System.out.println(c == d);        // false → not cached

System.out.println(c.equals(d));   // true → same numeric value
```

Be very careful with wrapper caching — heavily tested on exams.


#### 1.5.5 Equality and `null`

- `== null` is always safe.
- Calling `.equals()` on a `null` reference throws a **NullPointerException**.

```java
String s = null;
System.out.println(s == null);   // true
// s.equals("Hi");               // ❌ NullPointerException
```

---

#### 1.5.6 Summary Table

| Comparison | Primitives | Objects / Wrappers | Strings |
|-----------|------------|--------------------|---------|
| `==`      | compares **value** | compares **reference** | identity (affected by String pool) |
| `.equals()` | N/A | compares **content** if overridden | **content** comparison |





