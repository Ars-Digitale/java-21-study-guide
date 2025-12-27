# Java I/O Streams

This chapter provides a detailed explanation of Java I/O Streams. 

It covers classic **java.io** streams, contrasts them with **java.nio / java.nio.file**, and explains design principles, APIs, edge cases, and exam-relevant distinctions.

## 1. What Is an I/O Stream in Java?

An I/O Stream represents a flow of data between a Java program and an external source or destination. 

The data flows sequentially, like water in a pipe.

- A stream is not a data structure; it does not store data permanently
- Streams are unidirectional (input OR output)
- Streams abstract the underlying source (file, network, memory, device)
- Streams operate in a blocking, synchronous manner (classic I/O)

In Java, streams are organized around two major dimensions:

- Direction: Input vs Output
- Data type: Byte vs Character

## 2. Byte Streams vs Character Streams

Java distinguishes streams based on the unit of data they process.

### Byte Streams

- Work with raw 8-bit bytes
- Used for binary data (images, audio, PDFs, ZIPs)
- Base classes: `InputStream` and `OutputStream` 

### Character Streams

- Work with 16-bit Unicode characters
- Handle character encoding automatically
- Base classes: `Reader` and `Writer` 

### Summary Table


|	Aspect	|	Byte Streams	|	Character Streams	|
|-----------|-------------------|-----------------------|
|	`Unit of data`	|	byte (8 bits)	|	char (16 bits)	|
|	`Encoding handling`	|	None	|	Yes (Charset aware)	|
|	`Base classes`	|	InputStream / OutputStream	|	Reader / Writer	|
|	`Typical usage`	|	Binary files	|	Text files	|
| 	`Focus`	|	Low-level I/O	|	Text processing	|
	

## 3. Low-Level vs High-Level Streams

Streams in `java.io` follow a decorator pattern. Streams are stacked to add functionality.

### 3.1 Low-Level Streams (Node Streams)

Low-level streams connect directly to a data source or sink.

- They know how to read/write bytes or characters
- They do NOT provide buffering, formatting, or object handling

### 3.2 Common Low-Level Streams


|	Stream Class	|	Purpose	|
|-------------------|-----------|
|	`FileInputStream`		|	Read bytes from file	|
|	`FileOutputStream`	|	Write bytes to file	|
|	`FileReader`	|	Read characters from file	|
|	`FileWriter`	|	Write characters to file	|


Example: Low-Level Byte Stream

```java
try (InputStream in = new FileInputStream("data.bin")) {
	int b;
	while ((b = in.read()) != -1) {
		System.out.println(b);
	}
}
```

> [!NOTE]
> Low-level streams are rarely used alone in real applications due to poor performance and limited features.

### 3.3 High-Level Streams (Filter / Processing Streams)

High-level streams wrap other streams to add functionality.

- Buffering
- Data type conversion
- Object serialization
- Primitive reading/writing

### 3.4 Common High-Level Streams


|	Stream Class	|	Adds Functionality	|
|-------------------|-----------------------|
|	`BufferedInputStream`	|	Buffering	|
|	`BufferedReader`	|	Line-based reading	|
|	`DataInputStream`	|	Primitive types	|
|	`ObjectInputStream`	|	Object serialization	|
|	`PrintWriter`	|	Formatted text output	|


Example: Stream Chaining

```java
try (BufferedReader reader =
	new BufferedReader(
		new InputStreamReader(
			new FileInputStream("text.txt")))) {

	String line;
	while ((line = reader.readLine()) != null) {
		System.out.println(line);
	}
}
```

### 3.5 Stream Chaining Rules and Common Errors

The previous example illustrates stream chaining, a core concept in `java.io` based on the decorator pattern. 

Each stream wraps another stream, adding functionality while preserving a strict type hierarchy.

#### 3.5.1 Fundamental Chaining Rule

A stream can only wrap another stream of a compatible abstraction level.

- Byte streams can only wrap byte streams
- Character streams can only wrap character streams
- High-level streams require an underlying low-level stream

> [!NOTE]
> You cannot arbitrarily mix `InputStream` with `Reader` or `OutputStream` with `Writer`.

#### 3.5.2 Byte vs Character Stream Incompatibility

A very common error is attempting to wrap a byte stream directly with a character-based class (or vice versa).

#### 3.5.3 Invalid Chaining (Compile-Time Error)

```java
BufferedReader reader =
	new BufferedReader(new FileInputStream("text.txt"));
```

> [!NOTE]
> This fails because `BufferedReader` expects a `Reader`, not an `InputStream`.

#### 3.5.4 Bridging Byte Streams to Character Streams

To convert between byte-based and character-based streams, Java provides bridge classes.

- `InputStreamReader` converts bytes → characters
- `OutputStreamWriter` converts characters → bytes

#### 3.5.5 Correct Conversion Pattern

```java
BufferedReader reader =
	new BufferedReader(
		new InputStreamReader(new FileInputStream("text.txt")));
```

> [!NOTE]
> The bridge handles character decoding using a charset (default or explicit).

#### 3.5.6 Ordering Rules in Stream Chains

The order of wrapping is not arbitrary and is often tested in certification exams.

- Low-level stream must be innermost
- Bridges (if needed) come next
- Buffered or processing streams come last

#### 3.5.7 Correct Logical Order

```text
FileInputStream → InputStreamReader → BufferedReader
```

#### 3.5.8 Resource Management Rule

Closing the outermost stream automatically closes all wrapped streams.

> [!NOTE]
> This is why try-with-resources should reference only the highest-level stream.

#### 3.5.9 Common Pitfalls

- Trying to buffer a stream of the wrong type
- Forgetting the bridge between byte and char streams
- Assuming `Reader` works with binary data
- Using default charset unintentionally


## 4. Core java.io Base Classes and Key Methods

Understanding method behavior and return values is critical for exams.

### 4.1 InputStream

Abstract base class for byte input.

### Key Methods

```text

Method	Description
int read()	Reads one byte, returns -1 at EOF
int read(byte[])	Reads into buffer, returns count or -1
int available()	Bytes readable without blocking
void close()	Releases resource
```	

> [!NOTE]
> The `read()` method blocks until data is available or EOF.

### 4.2 OutputStream

Abstract base class for byte output.

```text

Method	Description
void write(int b)	Writes one byte
void write(byte[])	Writes entire buffer
void flush()	Forces buffered data to output
void close()	Flushes and closes
```	

### 4.3 Reader and Writer

Character-based equivalents of InputStream and OutputStream.

```text

Class	Character Focus	Encoding Aware
Reader	Input	Yes
Writer	Output	Yes
```		

### Charset Handling

```java
Reader reader = new InputStreamReader(
new FileInputStream("file.txt"),
StandardCharsets.UTF_8);
```

## 5. Buffered Streams and Performance

Buffered streams reduce system calls, significantly improving performance.

- Read/write larger chunks internally
- Essential for file and network I/O

### Buffered vs Unbuffered

```text

Aspect	Unbuffered	Buffered
System calls	Frequent	Reduced
Performance	Poor	High
Exam usage	Rare	Recommended
```		

## 6. java.io vs java.nio (and java.nio.file)

This distinction is very important for Java 11+ certifications.

### 6.1 Conceptual Differences

```text

Aspect	java.io	java.nio / nio.2
Programming model	Stream-based	Buffer / Channel-based
Blocking	Blocking	Non-blocking capable
File API	File	Path + Files
Scalability	Limited	High
Introduced	Java 1.0	Java 4 / Java 7 (nio.2)
```		

### 6.2 java.nio.file (Modern File I/O)

Java 21 strongly favors `java.nio.file` for file operations.

### Example: Reading a File (NIO)

```java
Path path = Path.of("file.txt");
List<String> lines = Files.readAllLines(path);
```

### Equivalent java.io Code

```java
try (BufferedReader reader = new BufferedReader(new FileReader("file.txt"))) {
String line;
while ((line = reader.readLine()) != null) {
System.out.println(line);
}
}
```

## 7. When to Use Which API (Exam Perspective)

```text

Scenario	Recommended API
Simple file read/write	java.nio.file.Files
Binary streaming	InputStream / OutputStream
Character text processing	Reader / Writer
High-performance servers	java.nio.channels
Legacy APIs	java.io
```	

## 8. Certification Traps and Exam Tips

- EOF is indicated by -1, not an exception
- Closing a high-level stream closes the wrapped stream
- BufferedReader.readLine() removes line separators
- InputStreamReader bridges byte → char with charset
- Files methods throw IOException (checked)

> [!NOTE]
> Expect questions mixing java.io and java.nio to test conceptual understanding, not syntax memorization.