# Module 1: Instantiating types

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
  
It is also common to rely on literals or factory methods for object creation:
  
	```java
	String name = new String("Alice"); // creates a new String object explicitly
	Person p = new Person();           // creates a new Person object using its constructor
	``` 
  
## Handling a Primitive Type

### 1. Declaring a Primitive

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
### 2. Assigning a Primitive

**Assigning** a primitive type (as with reference types) means storing a value into a declared variable of that given type.  
For primitives, the variable holds the value itself, while for reference types the variable holds the memory address (a reference) of the object being pointed to.

- Syntax examples:

  ```java
  int number;  					// Declaring an int type: a variable called "number"
  
  number = 10;  				// Assigning the value 10 to this variable
  
  char letter = 'A';    		// Declaring and Assigning in a single statement: declaration and assignment can be combined  
  
  int a = 1, b = 2, c = 3;  	// Multiple declarations & assignements
  
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
  ```

## Handling a Reference Type

### 1. Creating and Assigning a Reference

**Assigning** a reference type means storing into the variable the memory address of an object.
This is normally done after the creation of the object with the **new** keyword and a Constructor, or by using a literal or a factory method.
A reference can also be assigned to another object of the same or compatible type.
Reference types can also be assigned **null**, which means that they do not refer to an object.

- Syntax examples:

  ```java
  Person person = new Person(); // Example with 'new' and a constructor:
                                // 'new Person()' creates a new Person object on the heap
                                // and returns its reference, which is stored in the variable 'person'.
  
  String greeting = "Hello";	 // Example with literal (for String).
  
  List<Integer> numbers = List.of(1, 2, 3);   // Example with a factory method.
  
  ```
  
### 2. Constructors

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

### 3. Instance Initializer Blocks

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
> However, for the certification exam it is important to know that:
> - They always run before the constructor body.
> - They are executed in the order of declaration in the class.
> - They can be combined with constructors to avoid code duplication.

## Wrapper Types

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

### 1. Purpose of Wrapper Types
- Allow primitives to be used in contexts that require objects (e.g., collections, generics).  
- Provide utility methods for parsing, converting, and working with values.  
- Support constants such as `Integer.MAX_VALUE` or `Double.MIN_VALUE`.  

### 2. Autoboxing and Unboxing
Since Java 5, the compiler automatically converts between primitives and their wrappers:
- **Autoboxing**: primitive → wrapper  
- **Unboxing**: wrapper → primitive  

```java
Integer i = 10;       // autoboxing: int → Integer
int n = i;            // unboxing: Integer → int
```

### 3. Parsing and Conversion

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

### 4. Helper methods

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

### 5. Null Values

Unlike primitives, wrapper types can hold **null**. 
Attempting to unbox null causes a NullPointerException:

```java
Integer val = null;
int z = val; // ❌ NullPointerException at runtime
```

### 6. Equality

Comparing wrappers with == checks for reference equality, not value equality. 
Use .equals() for value comparison.

```java
Integer a = 1000;
Integer b = 1000;
System.out.println(a == b);        // false, different objects
System.out.println(a.equals(b));   // true, same value
```

