# 10. Arrays in Java

<a id="table-of-contents"></a>
### Table of Contents


- [10.1 What an Array Is](#101-what-an-array-is)
	- [10.1.1 Declaring Arrays](#1011-declaring-arrays)
	- [10.1.2 Creating Arrays Instantiation](#1012-creating-arrays-instantiation)
	- [10.1.3 Default Values in Arrays](#1013-default-values-in-arrays)
	- [10.1.4 Accessing Elements](#1014-accessing-elements)
	- [10.1.5 Array Initialization Shorthands](#1015-array-initialization-shorthands)
		- [10.1.5.1 Anonymous Array Creation](#10151-anonymous-array-creation)
		- [10.1.5.2 Short Syntax Only at Declaration](#10152-short-syntax-only-at-declaration)
- [10.2 Multidimensional Arrays Arrays of Arrays](#102-multidimensional-arrays-arrays-of-arrays)
	- [10.2.1 Creating a Rectangular Array](#1021-creating-a-rectangular-array)
	- [10.2.2 Creating a Jagged Irregular Array](#1022-creating-a-jagged-irregular-array)
- [10.3 Array Length vs String Length](#103-array-length-vs-string-length)
- [10.4 Array Reference Assignments](#104-array-reference-assignments)
	- [10.4.1 Assigning Compatible References](#1041-assigning-compatible-references)
	- [10.4.2 Incompatible Assignments Compile-Time Errors](#1042-incompatible-assignments-compile-time-errors)
	- [10.4.3 Covariance Runtime Danger ArrayStoreException](#1043-covariance-runtime-danger-arraystoreexception)
- [10.5 Comparing Arrays](#105-comparing-arrays)
- [10.6 Arrays Utility Methods](#106-arrays-utility-methods)
	- [10.6.1 Arrays.toString](#1061-arraystostring)
	- [10.6.2 Arrays.deepToString for Nested Arrays](#1062-arraysdeeptostring-for-nested-arrays)
	- [10.6.3 Arrays.sort](#1063-arrayssort)
	- [10.6.4 Arrays.binarySearch](#1064-arraysbinarysearch)
	- [10.6.5 Arrays.compare](#1065-arrayscompare)
- [10.7 Enhanced for-loop with Arrays](#107-enhanced-for-loop-with-arrays)
- [10.8 Common Pitfalls](#108-common-pitfalls)
- [10.9 Summary](#109-summary)

---

<a id="101-what-an-array-is"></a>
## 10.1 What an Array Is

Arrays in Java are **fixed-size**, **indexed**, **ordered** collections of elements of the same type.
  
They are **objects**, even when the elements are primitives.

<a id="1011-declaring-arrays"></a>
### 10.1.1 Declaring Arrays

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

// MULTIPLE ARRAY DECLARATIONS

int[] arr1, arr2;   // Declares two arrays of int

// WARNING:
// Here arr1 is an int[] and arr2 is just an int (NOT an array!)
int arr1[], arr2;
```

**Declaring does NOT create the array** — it only creates a variable capable of referencing one.

<a id="1012-creating-arrays-instantiation"></a>
### 10.1.2 Creating Arrays (Instantiation)

An array is created using `new` followed by the element type and the array length:

```java
int[] numbers = new int[5];
String[] words = new String[3];
```

**Key rules**
- The length must be non-negative and specified at creation time.
- The length cannot be changed later.
- The array length can be any `int` expression.

```java
int size = 4;
double[] values = new double[size];
```

- Illegal array creation examples:

```java
// int length = -1;           
// int[] arr = new int[-1];   // Runtime: NegativeArraySizeException

// int[] arr = new int[2.5];  // Compile error: size must be int
```

<a id="1013-default-values-in-arrays"></a>
### 10.1.3 Default Values in Arrays

Arrays (because they are objects) always receive **default initialization**:

| Element Type    | Default Value |
|-----------------|---------------|
| Numeric         | 0             |
| boolean         | false         |
| char            | '\u0000'      |
| Reference types | null          |

- Example:

```java
int[] nums = new int[3]; 
System.out.println(nums[0]); // 0

String[] s = new String[3];
System.out.println(s[0]);    // null
```

<a id="1014-accessing-elements"></a>
### 10.1.4 Accessing Elements

Elements are accessed using zero-based indexing:

```java
int[] a = new int[3];
a[0] = 10;
a[1] = 20;
System.out.println(a[1]); // 20
```

**Common exception**  
- `ArrayIndexOutOfBoundsException` (runtime)

```java
// int[] x = new int[2];
// System.out.println(x[2]); // ❌ index 2 out of bounds
```

<a id="1015-array-initialization-shorthands"></a>
### 10.1.5 Array Initialization Shorthands

<a id="10151-anonymous-array-creation"></a>
#### 10.1.5.1 Anonymous Array Creation

```java
int[] a = new int[] {1,2,3};
```

<a id="10152-short-syntax-only-at-declaration"></a>
#### 10.1.5.2 Short Syntax (Only at Declaration)

```java
int[] b = {1,2,3};
```

> The short syntax `{1,2,3}` can only be used at the point of declaration.

```java
// int[] c;
// c = {1,2,3};  // ❌ does not compile
```

---

<a id="102-multidimensional-arrays-arrays-of-arrays"></a>
## 10.2 Multidimensional Arrays (Arrays of Arrays)

Java implements multi-dimensional arrays as **arrays of arrays**.

Declaration:

```java
int[][] matrix;
String[][][] cube;
```

<a id="1021-creating-a-rectangular-array"></a>
### 10.2.1 Creating a Rectangular Array

```java
int[][] rect = new int[3][4]; // 3 rows, 4 columns each
```

<a id="1022-creating-a-jagged-irregular-array"></a>
### 10.2.2 Creating a Jagged (Irregular) Array

You can create rows with different lengths:

```java
int[][] jagged = new int[3][];
jagged[0] = new int[2];
jagged[1] = new int[5];
jagged[2] = new int[1];
```

---

<a id="103-array-length-vs-string-length"></a>
## 10.3 Array Length vs String Length

- Arrays use `.length` (public final field).
- Strings use `.length()` (method).

!!! tip
    This is a classic trap: fields vs methods.

```java
// int x = arr.length;   // OK
// int y = s.length;     // ❌ does not compile: missing ()
int yOk = s.length();
```

---

<a id="104-array-reference-assignments"></a>
## 10.4 Array Reference Assignments

<a id="1041-assigning-compatible-references"></a>
### 10.4.1 Assigning Compatible References

```java
int[] a = {1,2,3};
int[] b = a; // both now point to the same array
```

Modifying one reference affects the other:

```java
b[0] = 99;
System.out.println(a[0]); // 99
```

<a id="1042-incompatible-assignments-compile-time-errors"></a>
### 10.4.2 Incompatible Assignments (Compile-Time Errors)

```java
// int[] x = new int[3];
// long[] y = x;     // ❌ incompatible types
```

Array references follow normal inheritance rules:

```java
String[] s = new String[3];
Object[] o = s;      // OK: arrays are covariant
```

<a id="1043-covariance-runtime-danger-arraystoreexception"></a>
### 10.4.3 Covariance Runtime Danger: ArrayStoreException

```java
Object[] objs = new String[3];
// objs[0] = Integer.valueOf(5); // ❌ ArrayStoreException at runtime
```

---

<a id="105-comparing-arrays"></a>
## 10.5 Comparing Arrays

`==` compares references (identity):

```java
int[] a = {1,2};
int[] b = {1,2};
System.out.println(a == b); // false
```

`equals()` on arrays does not compare contents (it behaves like `==`):

```java
System.out.println(a.equals(b)); // false
```

To compare contents, use methods from `java.util.Arrays`:

```java
Arrays.equals(a, b);         // shallow comparison
Arrays.deepEquals(o1, o2);   // deep comparison for nested arrays
```

---

<a id="106-arrays-utility-methods"></a>
## 10.6 `Arrays` Utility Methods

<a id="1061-arraystostring"></a>
### 10.6.1 `Arrays.toString()`

```java
System.out.println(Arrays.toString(new int[]{1,2,3})); // [1, 2, 3]
```

<a id="1062-arraysdeeptostring-for-nested-arrays"></a>
### 10.6.2 `Arrays.deepToString()` (for nested arrays)

```java
System.out.println(Arrays.deepToString(new int[][] {{1,2},{3,4}}));
// [[1, 2], [3, 4]]
```

<a id="1063-arrayssort"></a>
### 10.6.3 `Arrays.sort()`

```java
int[] a = {4,1,3};
Arrays.sort(a); // [1, 3, 4]
```

!!! tip
    - Strings are sorted in natural (lexicographic) order.
    - Numbers sort before letters, and uppercase letters sort before lowercase letters (numbers < uppercase < lowercase).
    - For reference types, `null` is considered smaller than any non-null value.

```java
String[] arr = {"AB", "ac", "Ba", "bA", "10", "99"};

Arrays.sort(arr);

System.out.println(Arrays.toString(arr));  // [10, 99, AB, Ba, ac, bA]
```

<a id="1064-arraysbinarysearch"></a>
### 10.6.4 `Arrays.binarySearch()`

Requirements: the array must be sorted using the same ordering; otherwise the result is unpredictable.

```java
int[] a = {1,3,5,7};
int idx = Arrays.binarySearch(a, 5); // returns 2
```

When the value is not found, `binarySearch` returns `-(insertionPoint) - 1`:

```java
int pos = Arrays.binarySearch(a, 4); // returns -3
// Insertion point is index 2 → -(2) - 1 = -3
```

<a id="1065-arrayscompare"></a>
### 10.6.5 `Arrays.compare()`

The class `Arrays` offers an overloaded `equals()` that checks if two arrays contain the same elements (and have the same length):

```java
System.out.println(Arrays.equals(new int[] {200}, new int[] {100}));        // false
System.out.println(Arrays.equals(new int[] {200}, new int[] {200}));        // true
System.out.println(Arrays.equals(new int[] {200}, new int[] {100, 200}));   // false
```

It also provides a `compare()` method with these rules:

- If the result `n < 0` → the first array is considered “smaller” than the second.
- If the result `n > 0` → the first array is considered “greater” than the second.
- If the result `n == 0` → the arrays are equal.

- Examples:

```java
int[] arr1 = new int[] {200, 300};
int[] arr2 = new int[] {200, 300, 400};
System.out.println(Arrays.compare(arr1, arr2));  // -1

int[] arr3 = new int[] {200, 300, 400};
int[] arr4 = new int[] {200, 300};
System.out.println(Arrays.compare(arr3, arr4));  // 1

String[] arr5 = new String[] {"200", "300", "aBB"};
String[] arr6 = new String[] {"200", "300", "ABB"};
System.out.println(Arrays.compare(arr5, arr6));     // Positive: "aBB" > "ABB"

String[] arr7 = new String[] {"200", "300", "ABB"};
String[] arr8 = new String[] {"200", "300", "aBB"};
System.out.println(Arrays.compare(arr7, arr8));     // Negative: "ABB" < "aBB"

String[] arr9 = null;
String[] arr10 = new String[] {"200", "300", "ABB"};
System.out.println(Arrays.compare(arr9, arr10));    // -1 (null considered smaller)
```

---

<a id="107-enhanced-for-loop-with-arrays"></a>
## 10.7 Enhanced for-loop with Arrays

```java
for (int value : new int[]{1,2,3}) {
    System.out.println(value);
}
```

**Rules**
- The right side must be an array or an `Iterable`.
- The loop variable type must be compatible with the element type (no primitive widening here).

Common error:

```java
// for (long v : new int[]{1,2}) {} // ❌ not allowed: int elements cannot be assigned to long in enhanced for-loop
```

---

<a id="108-common-pitfalls"></a>
## 10.8 Common Pitfalls

- **Accessing out of bounds** → throws `ArrayIndexOutOfBoundsException`.

- **Using short array initializer incorrectly**

```java
// int[] x;
// x = {1,2}; // ❌ does not compile
```

- **Confusing `.length` and `.length()`**
- **Forgetting that arrays are objects** (they live on the heap and are referenced).

- **Mixing primitive arrays and wrapper arrays**

```java
// int[] p = new Integer[3]; // ❌ incompatible
```

- **Using `binarySearch` on unsorted arrays** → unpredictable results.
- **Covariant array runtime exceptions** (`ArrayStoreException`).

---

<a id="109-summary"></a>
## 10.9 Summary

Arrays in Java are:

- Objects (even if they hold primitives).
- Fixed-size, indexed collections.
- Always initialized with default values.
- Type-safe, but subject to covariance rules (which can cause runtime exceptions if misused).
