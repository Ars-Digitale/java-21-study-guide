# Interacting with the User (Standard I/O Streams)

Java programs often need to interact with the user: printing information, reading input, and formatting output.

This interaction is implemented using standard I/O streams, which are normal Java streams connected to the operating system.

This chapter explains how Java interacts with the console and standard input/output,
starting from the most basic concepts and moving to higher-level APIs.

## 1. The Standard I/O Streams

Every Java program starts with three predefined streams provided by the JVM.

They are connected to the process environment (usually a terminal or console).

| Stream | Field | Type | Purpose |
| --- | --- | --- | --- |
| Standard output | `System.out` | PrintStream | Normal output |
| Standard error | `System.err` | PrintStream | Error output |
| Standard input | `System.in` | InputStream | User input |

> [!NOTE]
> These streams are created by the JVM, not by your program.
>
> They exist for the entire lifetime of the process.

## 2. `PrintStream`: What It Is and Why It Exists

`PrintStream` is a byte-oriented output stream designed for human-readable output.

It wraps another OutputStream and adds convenient printing methods.

`System.out` and `System.err` are both instances of `PrintStream`.

### 2.1 Key Characteristics of PrintStream

- Provides `print()` and `println()` methods
- Converts values to text automatically
- Does not throw IOException on write errors
- Optionally supports auto-flushing

> [!NOTE]
> Unlike most streams, PrintStream suppresses IOExceptions.
>
> Errors must be checked using checkError().

### 2.2 Basic Usage of PrintStream

```java
System.out.println("Hello");
System.out.print("Value: ");
System.out.println(42);
```

`println()` appends the platform-specific line separator automatically.

### 2.3 Formatting Output with PrintStream

PrintStream supports formatted output using `printf()` and `format()`,
which are based on the same syntax as String.format().

```java
System.out.printf("Name: %s, Age: %d%n", "Alice", 30);
```

| Specifier | Meaning |
| --- | --- |
| `%s` | String |
| `%d` | Integer |
| `%f` | Floating-point |
| `%n` | Platform-independent newline |

> [!NOTE]
> `printf()` does not automatically add a newline unless you specify `%n`.

## 3. Reading Input as an I/O Stream

Standard input (System.in) is an InputStream connected to user input.

It provides raw bytes and must be adapted for practical use.

### 3.1 Low-Level Reading from System.in

At the lowest level, you can read raw bytes from System.in.

This is rarely convenient for interactive programs.

```java
int b = System.in.read();
```

> [!NOTE]
> `System.in.read()` blocks until input is available.

### 3.2 Using InputStreamReader and BufferedReader

To read text input, `System.in` is typically wrapped into a Reader and buffered.

```java
BufferedReader reader =
new BufferedReader(new InputStreamReader(System.in));

String line = reader.readLine();
```

This converts `bytes → characters and allows line-based input`.

## 4. The Scanner Class (Convenient but Subtle)

`Scanner` is a high-level utility for parsing text input.

It is often used for console interaction, especially in small programs.

```java
Scanner sc = new Scanner(System.in);
int value = sc.nextInt();
String text = sc.nextLine();
```

> [!NOTE]
> Scanner performs tokenization and parsing, not simple reading.
>
> This makes it convenient but slower and sometimes surprising.

### 4.1 Common Scanner Pitfalls

- Mixing `nextInt()` and `nextLine()` can skip input
- Parsing errors throw InputMismatchException
- Scanner is relatively slow for large input

## 5. Closing System Streams

System streams are special and must be handled carefully.

| Stream Close | explicitly? |
| --- | --- |
| System.out | No |
| System.err | No |
| System.in | Usually no |

Closing `System.out` or `System.err` closes the underlying OS stream and affects the entire JVM.

> [!NOTE]
> In almost all applications, you should NOT close System.out or System.err.

## 6. Acquiring Input with `Console`

The `Console` class provides a higher-level, safer way to interact with the user.

It is designed specifically for interactive console programs.

```java
Console console = System.console();
```

> [!NOTE]
> `System.console()` may return null when no console is available
> (e.g. IDEs, redirected input).

### 6.1 Reading Input from Console

```java
String name = console.readLine("Name: ");
```

`readLine()` prints a prompt and reads a full line of input.

### 6.2 Reading Passwords Securely

Console allows reading passwords without echoing characters.

```java
char[] password = console.readPassword("Password: ");
```

> [!NOTE]
> Passwords are returned as `char[]` so they can be cleared from memory.

## 7. Formatting Console Output

Console also supports formatted output, similar to PrintStream.

```java
console.printf("Welcome %s%n", name);
```

This uses the same format specifiers as `printf()`.

## 8. Comparing Console, Scanner, and BufferedReader

| API | Use case | Strengths | Limitations |
| --- | --- | --- | --- |
| BufferedReader | Simple text input | Fast, predictable | Manual parsing |
| Scanner | Token-based input | Convenient, expressive | Slow, subtle behavior |
| Console | Interactive apps | Passwords, formatting | May be unavailable |

## 9. Redirection and Standard Streams

Standard streams can be redirected by the operating system.
Java code does not need to change.

```text
java App < input.txt > output.txt
```

From the program’s perspective, System.in and System.out still behave like normal streams.

## 10. Common Traps and Best Practices

- PrintStream suppresses IOExceptions
- `System.console()` can return null
- Do not close `System.out` or `System.err`
- Scanner mixes parsing and reading
- Console is preferred for passwords

## 11. Final Summary

- `System.out` and `System.err` are PrintStreams for output
- `System.in` is a byte stream that must be adapted for text
- `BufferedReader` and `Scanner` are common input strategies
- `Console` provides safe interactive input and output
- Standard streams integrate naturally with OS redirection
