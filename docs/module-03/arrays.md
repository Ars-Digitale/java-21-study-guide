# Arrays in Java


### Table of Contents

- [Arrays in Java]
	- [2. Arrays in Java](#2-arrays-in-java)
	  - [2.1 Declaring Arrays](#21-declaring-arrays)
	  - [2.2 Creating Arrays (Instantiation)](#22-creating-arrays-instantiation)
		- [2.2.1 Key Rules](#221-key-rules)
		- [2.2.2 Illegal Array Creation Examples](#222-illegal-array-creation-examples)
	  - [2.3 Default Values in Arrays](#23-default-values-in-arrays)
	  - [2.4 Accessing Elements](#24-accessing-elements)
		- [2.4.1 Common Exceptions](#241-common-exceptions)
	  - [2.5 Array Initialization Shorthands](#25-array-initialization-shorthands)
		- [2.5.1 Anonymous Array Creation](#251-anonymous-array-creation)
		- [2.5.2 Short Syntax (Only at Declaration)](#252-short-syntax-only-at-declaration)
	  - [2.6 Multidimensional Arrays (Arrays of Arrays)](#26-multidimensional-arrays-arrays-of-arrays)
		- [2.6.1 Declaration](#261-declaration)
		- [2.6.2 Creating a Rectangular Array](#262-creating-a-rectangular-array)
		- [2.6.3 Creating a Jagged (Irregular) Array](#263-creating-a-jagged-irregular-array)
	  - [2.7 Array Length vs String Length](#27-array-length-vs-string-length)
	  - [2.8 Array Reference Assignments](#28-array-reference-assignments)
		- [2.8.1 Assigning Compatible References](#281-assigning-compatible-references)
		- [2.8.2 Incompatible Assignments (Compile-Time Errors)](#282-incompatible-assignments-compile-time-errors)
		- [2.8.3 Covariance Runtime Danger: ArrayStoreException](#283-covariance-runtime-danger-arraystoreexception)
	  - [2.9 Comparing Arrays](#29-comparing-arrays)
	  - [2.10 Arrays Utility Methods](#210-arrays-utility-methods)
		- [2.10.1 `Arrays.toString()`](#2101-arraystostring)
		- [2.10.2 `Arrays.deepToString()`](#2102-arraysdeeptostring)
		- [2.10.3 `Arrays.sort()`](#2103-arrayssort)
		- [2.10.4 `Arrays.binarySearch()`](#2104-arraysbinarysearch)
	  - [2.11 Enhanced for-loop with Arrays](#211-enhanced-for-loop-with-arrays)
	  - [2.12 Common Pitfalls](#212-common-pitfalls)
		- [2.12.1 Accessing Out of Bounds](#2121-accessing-out-of-bounds)
		- [2.12.2 Using Short Array Initializer Incorrectly](#2122-using-short-array-initializer-incorrectly)
		- [2.12.3 Confusing `.length` and `.length()`](#2123-confusing-length-and-length)
		- [2.12.4 Forgetting Arrays Are Objects](#2124-forgetting-arrays-are-objects)
		- [2.12.5 Mixing Primitive and Wrapper Arrays](#2125-mixing-primitive-and-wrapper-arrays)
		- [2.12.6 Using `binarySearch` on Unsorted Arrays](#2126-using-binarysearch-on-unsorted-arrays)
		- [2.12.7 ArrayStoreException Due to Covariance](#2127-arraystoreexception-due-to-covariance)
	  - [2.13 Summary](#213-summary)
	  
---

## 2. Arrays in Java

Arrays in Java are **fixed-size**, **indexed**, **ordered** collections of elements of the *same* type.  
They are considered **objects**, even when the elements are primitives.  


### 2.1 Declaring Arrays

You can declare an array in two ways:

```java
int[] a;      // preferred modern syntax
int b[];      // legal, older style
String[] names;
Person[] people;

// [] can be before or after the name: all the following declarations are equivalent.

int[] x;
int [] x1;
int []x2;
int x3[];
int x5 [];

// MULTIPLE ARRAYs DECLARATION

int[] arr1, arr2;   // Declares two arrays of int

WARNING!

int arr1[], arr2;   // This time (just moving the brackets) we obtain one variable of type array of int and the second one, arr2, of type int

```

**Declaring does NOT create the array** — it only creates a variable capable of referencing one.


### 2.2 Creating Arrays (Instantiation)

An array is created using `new` followed by the element type and the array length:

```java
int[] numbers = new int[5];
String[] words = new String[3];
```

### Key rules
- The length **must be non-negative** and specified at creation time.
- Length **cannot be changed later**.
- Array length can be any `int` expression:

```java
int size = 4;
double[] values = new double[size];
```

### Illegal array creation examples
```java
// int length = -1;          // Runtime exception: NegativeArraySizeException
// int[] arr = new int[-1]; 

// int[] arr = new int[2.5];  // Compile error: size must be int
```


### 2.3 Default Values in Arrays

Arrays (because they are objects) always receive **default initialization**:

| Element Type | Default Value |
|--------------|----------------|
| Numeric      | 0 |
| boolean      | false |
| char         | '\u0000' |
| Reference types | null |

Example:

```java
int[] nums = new int[3]; 
System.out.println(nums[0]); // 0

String[] s = new String[3];
System.out.println(s[0]);    // null
```


### 2.4 Accessing Elements

Elements are accessed using zero-based indexing:

```java
int[] a = new int[3];
a[0] = 10;
a[1] = 20;
System.out.println(a[1]); // 20
```

### Common Exceptions
- `ArrayIndexOutOfBoundsException` (runtime)

```java
// int[] x = new int[2];
// System.out.println(x[2]); // ❌ index 2 out of bounds
```

### 2.5 Array Initialization Shorthands

#### 2.5.1 Anonymous array creation
```java
int[] a = new int[] {1,2,3};
```

#### 2.5.2 Short syntax (only at declaration!)
```java
int[] b = {1,2,3};
```

> The short syntax *cannot* be used in assignment:

```java
// int[] c;
// c = {1,2,3};  // ❌ does not compile
```

### 2.6 Multidimensional Arrays (Arrays of Arrays)

Java implements multi-dimensional arrays as **arrays of arrays**.

### Declaration
```java
int[][] matrix;
String[][][] cube;
```

### Creating a rectangular array
```java
int[][] rect = new int[3][4]; // 3 rows, 4 columns each
```

### Creating a jagged (irregular) array
You can create rows with different lengths:

```java
int[][] jagged = new int[3][];
jagged[0] = new int[2];
jagged[1] = new int[5];
jagged[2] = new int[1];
```


### 2.7 Array Length vs String Length

- Arrays use **`.length`** (public final field)
- Strings use **`.length()`** (method)

**Common Pitfall**:

```java
// int x = arr.length;   // OK
// int y = s.length;     // ❌ does not compile: missing ()
```


### 2.8 Array Reference Assignments

### Assigning compatible references
```java
int[] a = {1,2,3};
int[] b = a; // both now point to the same array
```

Modifying one affects the other:

```java
b[0] = 99;
System.out.println(a[0]); // 99
```

### Incompatible assignments (compile-time errors)
```java
// int[] x = new int[3];
// long[] y = x;     // ❌ incompatible types
```

But array references follow normal inheritance rules:

```java
String[] s = new String[3];
Object[] o = s;      // OK: arrays are covariant
```

### Covariance runtime danger: ArrayStoreException
```java
Object[] objs = new String[3];
// objs[0] = Integer.valueOf(5); // ❌ ArrayStoreException
```


### 2.9 Comparing Arrays

`==` compares references (identity):  
```java
int[] a = {1,2};
int[] b = {1,2};
System.out.println(a == b); // false
```

`.equals()` in arrays **does not compare contents** (it behaves like `==`):  
```java
System.out.println(a.equals(b)); // false
```

To compare contents, use methods from `java.util.Arrays`:

```java
Arrays.equals(a, b);         // shallow comparison
Arrays.deepEquals(o1, o2);   // deep comparison for nested arrays
```


### 2.10 `Arrays` Utility Methods


### • `Arrays.toString()`
```java
System.out.println(Arrays.toString(new int[]{1,2,3})); // [1, 2, 3]
```

### • `Arrays.deepToString()` (for nested arrays)
```java
System.out.println(Arrays.deepToString(new int[][] {{1,2},{3,4}}));	// [[1, 2], [3, 4]]
```

### • `Arrays.sort()`
```java
int[] a = {4,1,3};
Arrays.sort(a); // [1,3,4]
```

> [!TIP]
> - Strings are sorted in alphabetical order
> - Numbers sort before letters and uppercase letters sort before lowercase letters: (numbers < uppercase < lowercase)
> - `null` is smaller of any other value

```java
String[] arr = {"AB", "ac", "Ba", "bA", "10", "99"};

Arrays.sort(arr);

System.out.println(Arrays.toString(arr));  // [10, 99, AB, Ba, ac, bA]
```

### • `Arrays.binarySearch()`
Requirements: array **must be sorted**, otherwise result is `unpredictable`.

```java
int[] a = {1,3,5,7};
int idx = Arrays.binarySearch(a, 5); // returns 2
```

When value not found → returns **-(insertionPoint) - 1**:

```java
int pos = Arrays.binarySearch(a, 4); // returns -3
```

Explanation: insertion at index 2 → return `-(2) - 1 = -3`.


### • `Arrays.compare()`

While the class `Arrays` contain an overloaded version of the method `equals()` which checks if two arrays contain the same elements (and of course are of the same size)

```java
System.out.println(Arrays.equals(new int[] {200}, new int[] {100}));	// false
System.out.println(Arrays.equals(new int[] {200}, new int[] {200}));	// true
System.out.println(Arrays.equals(new int[] {200}, new int[] {100, 200}));	// false
```

it offers also a `compare()` method with the following utilization rules:

- If the method gives a result `n < 0` --> first array is smaller than the second;
- If the method gives a result `n > 0` --> first array is bigger than the second;
- If the method gives a result `n == 0` --> arrays are equal;

Additional rules in the following example:

```java


int[] arr1 = new int[] {200, 300};
int[] arr2 = new int[] {200, 300, 400};
System.out.println(Arrays.compare(arr1, arr2));  // -1

int[] arr3 = new int[] {200, 300, 400};
int[] arr4 = new int[] {200, 300};
System.out.println(Arrays.compare(arr3, arr4));  // 1

String[] arr5 = new String[] {"200", "300", "aBB"};
String[] arr6 = new String[] {"200", "300", "ABB"};
System.out.println(Arrays.compare(arr5, arr6));     // Positive number: uppercase is smaller than lowercase

String[] arr7 = new String[] {"200", "300", "ABB"};
String[] arr8 = new String[] {"200", "300", "aBB"};
System.out.println(Arrays.compare(arr7, arr8));     // Negative number: uppercase is smaller than lowercase

String[] arr9 = null;
String[] arr10 = new String[] {"200", "300", "ABB"};
System.out.println(Arrays.compare(arr9, arr10));   // -1
```


### 2.11 Enhanced for-loop with Arrays

```java
for (int value : new int[]{1,2,3}) {
    System.out.println(value);
}
```

Rules:
- The right side must be an array or iterable.
- The loop variable must be compatible with element type.

Common error:
```java
// for (long v : new int[]{1,2}) {} // ❌ not allowed: int cannot widen to long in enhanced loop
```


### 2.12 Common Pitfalls

#### 2.12.1 Accessing out of bounds  
Throws `ArrayIndexOutOfBoundsException`.

#### 2.12.2 Using short array initializer incorrectly  
```java
// int[] x;
// x = {1,2}; // ❌ does not compile
```

#### 2.12.3 Confusing `.length` and `.length()`

#### 2.12.4 Forgetting arrays are objects

#### 2.12.5 Mixing primitive arrays and wrapper arrays  
```java
// int[] p = new Integer[3]; // ❌ incompatible
```

#### 2.12.6 Using binarySearch on unsorted arrays → unpredictable results

#### 2.12.7 Covariant array runtime exceptions (ArrayStoreException)

---

#### 2.13 Summary

Arrays in Java are:
- objects (even if holding primitives)
- fixed-size, indexed collections
- always initialized with default values
- type-safe but subject to covariance rules


---