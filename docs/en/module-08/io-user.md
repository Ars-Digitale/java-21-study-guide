# 36. Interacting with the User (Standard I/O Streams)

### Table of Contents

- [36. Interacting with the User Standard I/O Streams](#36-interacting-with-the-user-standard-io-streams)
  - [36.1 The Standard I/O Streams](#361-the-standard-io-streams)
  - [36.2 PrintStream What It Is and Why It Exists](#362-printstream-what-it-is-and-why-it-exists)
    - [36.2.1 Key Characteristics of PrintStream](#3621-key-characteristics-of-printstream)
    - [36.2.2 Basic Usage of PrintStream](#3622-basic-usage-of-printstream)
    - [36.2.3 Formatting Output with PrintStream](#3623-formatting-output-with-printstream)
  - [36.3 Reading Input as an IO Stream](#363-reading-input-as-an-io-stream)
    - [36.3.1 Low-Level Reading from Systemin](#3631-low-level-reading-from-systemin)
    - [36.3.2 Using InputStreamReader and BufferedReader](#3632-using-inputstreamreader-and-bufferedreader)
  - [36.4 The Scanner Class Convenient but Subtle](#364-the-scanner-class-convenient-but-subtle)
    - [36.4.1 Common Scanner Pitfalls](#3641-common-scanner-pitfalls)
  - [36.5 Closing System Streams](#365-closing-system-streams)
  - [36.6 Acquiring Input with Console](#366-acquiring-input-with-console)
    - [36.6.1 Reading Input from Console](#3661-reading-input-from-console)
    - [36.6.2 Reading Passwords Securely](#3662-reading-passwords-securely)
  - [36.7 Formatting Console Output](#367-formatting-console-output)
  - [36.8 Comparing Console Scanner and BufferedReader](#368-comparing-console-scanner-and-bufferedreader)
  - [36.9 Redirection and Standard Streams](#369-redirection-and-standard-streams)
  - [36.10 Common Traps and Best Practices](#3610-common-traps-and-best-practices)
  - [36.11 Final Summary](#3611-final-summary)

---

Java programs often need to interact with the user: printing information, reading input, and formatting output.

This interaction is implemented using standard I/O streams, which are normal Java streams connected to the operating system.

This chapter explains how Java interacts with the console and standard input/output,
starting from the most basic concepts and moving to higher-level APIs.

## 36.1 The Standard I/O Streams

Every Java program starts with three predefined streams provided by the JVM.

They are connected to the process environment (usually a terminal or console).

| Stream | Field | Type | Purpose |
| --- | --- | --- | --- |
| Standard output | `System.out` | PrintStream | Normal output |
| Standard error | `System.err` | PrintStream | Error output |
| Standard input | `System.in` | InputStream | User input |

!!! note
    These streams are created by the JVM, not by your program.
    
    They exist for the entire lifetime of the process.

---

## 36.2 `PrintStream`: What It Is and Why It Exists

`PrintStream` is a byte-oriented output stream designed for human-readable output.

It wraps another OutputStream and adds convenient printing methods.

`System.out` and `System.err` are both instances of `PrintStream`.

### 36.2.1 Key Characteristics of PrintStream

- Byte-oriented stream with text-printing helpers
- Provides `print()` and `println()` methods
- Converts values to text automatically
- Does not throw `IOException` on write errors
- Optionally supports auto-flushing on newline / `println()`

!!! note
    Unlike most streams, PrintStream suppresses IOExceptions.
    
    Errors must be checked using checkError().

### 36.2.2 Basic Usage of PrintStream

```java
System.out.println("Hello");
System.out.print("Value: ");
System.out.println(42);
```

`println()` appends the platform-specific line separator automatically.

### 36.2.3 Formatting Output with PrintStream

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

!!! note
    `printf()` does not automatically add a newline unless you specify `%n`.

---

## 36.3 Reading Input as an I/O Stream

Standard input (System.in) is an InputStream connected to user input.

It provides raw bytes and must be adapted for practical use.

### 36.3.1 Low-Level Reading from System.in

At the lowest level, you can read raw bytes from System.in.

This is rarely convenient for interactive programs.

```java
int b = System.in.read();
```

!!! note
    `System.in.read()` blocks until input is available.

### 36.3.2 Using InputStreamReader and BufferedReader

To read text input, `System.in` is typically wrapped into a Reader and buffered.

```java
BufferedReader reader =
new BufferedReader(new InputStreamReader(System.in));

String line = reader.readLine();
```

This converts `bytes → characters` and allows line-based input.

---

## 36.4 The Scanner Class (Convenient but Subtle)

`Scanner` is a high-level utility for parsing text input.

It is often used for console interaction, especially in small programs.

```java
Scanner sc = new Scanner(System.in);
int value = sc.nextInt();
String text = sc.nextLine();
```

!!! note
    `Scanner` performs tokenization and parsing, not simple reading.
    
    This makes it convenient but slower and sometimes surprising.

### 36.4.1 Common Scanner Pitfalls

- Mixing `nextInt()` (and other `nextXxx()`) with `nextLine()` can appear to "skip" input because the trailing newline from the numeric token is still in the buffer.
- Parsing errors throw InputMismatchException
- Scanner is relatively slow for large input

---

## 36.5 Closing System Streams

`System streams` are special and must be handled carefully.

| Stream     | Close explicitly? |
|------------|-------------------|
| `System.out` | No                |
| `System.err` | No                |
| `System.in`  | Usually no        |


Closing `System.out` or `System.err` closes the underlying OS stream and affects the entire JVM: closing these streams affects the entire JVM process, not just the current class or method.


!!! note
    In almost all applications, you should NOT close `System.out` or `System.err`.

---

## 36.6 Acquiring Input with `Console`

The `Console` class provides a higher-level, safer way to interact with the user.

It is designed specifically for interactive console programs.

```java
Console console = System.console();
if (console == null) {
    throw new IllegalStateException("No console available");
}
```

!!! note
    `System.console()` may return null when no console is available
    (e.g. IDEs, redirected input).
	

The presence of a console depends on the underlying platform and on how the JVM is launched.

If the JVM is started from an interactive command line and the standard input/output streams are not redirected, a console is typically available.  
In this case, the console is usually connected to the keyboard and display from which the program was launched.

If the JVM is started in a non-interactive context — for example by an IDE, a background scheduler, a service manager, or with redirected standard streams — a console will usually not be available.

When a console exists, it is represented by a single unique instance of the Console class, which can be obtained by invoking the `System.console()` method. 
If no console device is available, this method will return `null`.

### 36.6.1 Reading Input from Console

```java
String name = console.readLine("Name: ");
```

`readLine()` prints a prompt and reads a full line of input.

### 36.6.2 Reading Passwords Securely

Console allows reading passwords without echoing characters.

```java
char[] password = console.readPassword("Password: ");
```

!!! note
    Passwords are returned as `char[]` so they can be cleared from memory.

---

## 36.7 Formatting Console Output

Console also supports formatted output, similar to PrintStream.

```java
console.printf("Welcome %s%n", name);
```

This uses the same format specifiers as `printf()`.

---

## 36.8 Comparing Console, Scanner, and BufferedReader

| API | Use case | Strengths | Limitations |
| --- | --- | --- | --- |
| `BufferedReader` | Simple text input           | Fast, predictable, charset explicit | Manual parsing |
| `Scanner`        | Token-based / parsed input  | Convenient, expressive              | Slower, subtle token behavior |
| `Console`        | Interactive console apps    | Passwords, prompts, formatted I/O   | May be unavailable (`null`)    |

---

## 36.9 Redirection and Standard Streams

Standard streams can be redirected by the operating system.
Java code does not need to change.

```text
java App < input.txt > output.txt
```

From the program’s perspective, System.in and System.out still behave like normal streams.

!!! note
    Redirection is handled by the operating system or shell. The Java code does not need to change to support it.

---

## 36.10 Common Traps and Best Practices

- PrintStream suppresses IOExceptions
- `System.console()` can return null
- Do not close `System.out` or `System.err`
- Scanner mixes parsing and reading
- Console is preferred for passwords
- If you use `Scanner` on `System.in`, do not close the Scanner if other parts of the program still need to read from `System.in` (closing the Scanner closes `System.in`).

---

## 36.11 Final Summary

- `System.out` and `System.err` are PrintStreams for output
- `System.in` is a byte stream that must be adapted for text
- `BufferedReader` and `Scanner` are common input strategies
- `Console` provides safe interactive input and output
- Standard streams integrate naturally with OS redirection
