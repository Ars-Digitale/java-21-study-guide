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
Unlike primitives, whose size depends on their specific type (e.g., `int` vs `long`), reference types always occupy the same fixed size in memory — what varies is the size of the object they point to.

- Syntax examples for declaration only:

  ```java
  int number;
  
  boolean active;
  
  char letter;
  
  int x, y, z;          // Multiple declarations in one statement: Java allows declaring multiple variables of the same type
  ```
### 2. Assigning a Primitive

**Assigning** a primitive type (as with reference types) means storing a value into a declared variable of that given type.

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