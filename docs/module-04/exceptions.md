# Exceptions and Error Handling

Exceptions are Java’s structured mechanism for handling abnormal conditions at runtime. 

They allow programs to separate normal execution flow from error-handling logic, improving robustness, readability, and correctness. 

## 1. Exception hierarchy and types

All exceptions derive from `Throwable`. 

The hierarchy defines which conditions are recoverable, which must be declared, and which represent fatal system failures.

```text
java.lang.Object
└── java.lang.Throwable
    ├── java.lang.Error
    └── java.lang.Exception
        └── java.lang.RuntimeException
```

### 1.1 Throwable

- Base class for all errors and exceptions
- Supports message, cause, and stack trace
- Only `Throwable` (and subclasses) can be thrown or caught

### 1.2 Error (unchecked)

- Represents serious JVM or system problems
- Not intended to be caught or handled
- Examples: `OutOfMemoryError`, `StackOverflowError`

> [!NOTE]
> Errors indicate conditions from which the application is generally not expected to recover.

### 1.3 Exception

- Represents conditions applications may want to handle
- Divided into **checked** and **unchecked** exceptions

### 1.4 Checked exceptions

- Any `Exception` that is not a `RuntimeException`
- Must be either **caught** or **declared**
- Examples: `IOException`, `SQLException`

### 1.5 Unchecked exceptions

- Subclasses of `RuntimeException`
- Not required to be declared or caught
- Usually represent programming errors
- Examples: `NullPointerException`, `IllegalArgumentException`

## 2. Declaring and throwing exceptions

### 2.1 Declaring exceptions with throws

A method declares checked exceptions using the `throws` clause. This is part of the method’s API contract.

```java
void readFile(Path p) throws IOException {
	Files.readString(p);
}
```
> [!NOTE]
> Only **checked exceptions** must be declared. Unchecked exceptions may be declared but are usually omitted.

### 2.2 Throwing exceptions

Exceptions are created with `new` and thrown explicitly using `throw`.

```java
if (value < 0) {
	throw new IllegalArgumentException("value must be >= 0");
}
```

- `throw` throws exactly one exception instance
- `throws` declares possible exceptions in the method signature

## 3. Overriding methods and exception rules

When overriding a method, exception rules are strictly enforced.

- An overriding method may throw **fewer** or **narrower** checked exceptions
- It may throw any unchecked exceptions
- It may throw **no new or broader** checked exceptions

```java
class Parent {
	void work() throws IOException {}
}

class Child extends Parent {
@Override
void work() throws FileNotFoundException {} // OK (subclass)
}
```

> [!NOTE]
> Changing only the **unchecked** exceptions never breaks the override contract.

## 4. Handling exceptions: try, catch, finally

### 4.1 Basic try-catch syntax

```java
try {
	riskyOperation();
} catch (IOException e) {
	handle(e);
}
```

- A `try` block must be followed by at least one `catch` or a `finally`
- Catches are checked top-down

### 4.2 Multiple catch blocks

Multiple catch blocks allow different handling for different exception types.

```java
try {
	process();
} catch (FileNotFoundException e) {
	recover();
} catch (IOException e) {
	log();
}
```
> [!NOTE]
> More specific exceptions must come before more general ones, otherwise compilation fails.

### 4.3 Multi-catch (Java 7+)

```java
try {
	process();
} catch (IOException | SQLException e) {
	log(e);
}
```

- Exception types must be unrelated (no parent/child)
- The caught variable is implicitly `final`

### 4.4 finally block

The `finally` block executes regardless of whether an exception is thrown, except in extreme JVM termination cases.

```java
try {
	open();
} finally {
	close();
}
```

- Used for cleanup logic
- Executes even if `return` is used in try and/or catch block

> [!NOTE]
> A `finally` block can override a return value or swallow an exception.


## 5. Automatic Resource Management (try-with-resources)

Try-with-resources provides automatic closing of resources that implement `AutoCloseable`. 

It eliminates the need for explicit `finally` cleanup in most cases.

### 5.1 Basic syntax

```java
try (BufferedReader br = Files.newBufferedReader(path)) {
	return br.readLine();
}
```

- Resources are closed automatically
- Closure happens even if an exception is thrown

### 5.2 Declaring multiple resources

```java
try (
InputStream in = Files.newInputStream(p);
OutputStream out = Files.newOutputStream(q)
) {
	in.transferTo(out);
}
```

- Resources are closed in **reverse order** of declaration

### 5.3 Scope of resources

- Resources are in scope only inside the `try` block
- They are implicitly `final`

> [!NOTE]
> Attempting to reassign a resource variable causes a compilation error.

## 6. Effectively final variables

A variable is **effectively final** if it is assigned once and never modified. Java treats it as final even without the `final` keyword.

```java
int x = 10;
try (Scanner sc = new Scanner(System.in)) {
System.out.println(x);
}
```

- Required for variables captured by lambdas
- Required for resources declared outside try-with-resources

## 7. Suppressed exceptions

When both the `try` block and the resource’s `close()` method throw exceptions, Java preserves the primary exception and **suppresses** the others.

```java
try (BadResource r = new BadResource()) {
throw new RuntimeException("main");
}
```

If `close()` also throws an exception, it becomes **suppressed**.

```java
catch (Exception e) {
for (Throwable t : e.getSuppressed()) {
System.out.println(t);
}
}
```

- Primary exception is thrown
- Secondary exceptions are accessible via `getSuppressed()`

> **Note:** Suppressed exceptions are a **very common certification question**, especially combined with try-with-resources.

## 8. Certification summary
- Checked exceptions must be caught or declared
- Override methods may not widen checked exceptions
- Use multi-catch for shared handling logic
- Prefer try-with-resources over finally cleanup
- Resources close in reverse order
- Suppressed exceptions preserve full failure context

> **Note:** Exception mastery is about **control flow and contracts**, not memorizing class names.