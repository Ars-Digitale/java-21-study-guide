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

### 2. Creating and Assigning a Reference

**Assigning** a reference type means storing into the variable the memory address of an object.
This is normally done after the creation of the object with the new keyword and a Constructor, or by using a literal or a factory method.

- Syntax examples:

  ```java
  Person person = new Person(); // Example with 'new' and a constructor:
                                // 'new Person()' creates a new Person object on the heap
                                // and returns its reference, which is stored in the variable 'person'.
  
  String greeting = "Hello";	 // Example with literal (for String).
  
  List<Integer> numbers = List.of(1, 2, 3);   // Example with a factory method.
  
  ```
  
### 3. Constructors

In the example, **`Person()`** is a constructor — a special kind of method used to initialize new objects.  
Whenever you call `new Person()`, the constructor runs and sets up the newly created instance.

**Constructors have three main characteristics:**

- The constructor name **must match the class name** exactly (case-sensitive).  
- Constructors **do not declare a return type** (not even `void`).  
- If you do not define any constructor in your class, the compiler will automatically provide a **default no-argument constructor** that does nothing.

> [!WARNING]  
> If you see a method that has the same name as the class **but also declares a return type**, it is **not** a constructor.  
> It is simply a regular method (though starting method names with a capital letter is against Java naming conventions).

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