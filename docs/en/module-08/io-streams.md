# 34. Java I/O Streams

### Table of Contents

- [34. Java I/O Streams](#34-java-io-streams)
  - [34.1 What Is an IO Stream in Java](#341-what-is-an-io-stream-in-java)
  - [34.2 Byte Streams vs Character Streams](#342-byte-streams-vs-character-streams)
    - [34.2.1 Byte Streams](#3421-byte-streams)
    - [34.2.2 Character Streams](#3422-character-streams)
    - [34.2.3 Summary Table](#3423-summary-table)
  - [34.3 Low-Level vs High-Level Streams](#343-low-level-vs-high-level-streams)
    - [34.3.1 Low-Level Streams Node-Streams](#3431-low-level-streams-node-streams)
    - [34.3.2 Common Low-Level Streams](#3432-common-low-level-streams)
    - [34.3.3 High-Level Streams Filter--Processing-Streams](#3433-high-level-streams-filter--processing-streams)
    - [34.3.4 Common High-Level Streams](#3434-common-high-level-streams)
    - [34.3.5 Stream Chaining Rules and Common Errors](#3435-stream-chaining-rules-and-common-errors)
      - [34.3.5.1 Fundamental Chaining Rule](#34351-fundamental-chaining-rule)
      - [34.3.5.2 Byte vs Character Stream Incompatibility](#34352-byte-vs-character-stream-incompatibility)
      - [34.3.5.3 Invalid Chaining Compile-Time-Error](#34353-invalid-chaining-compile-time-error)
      - [34.3.5.4 Bridging Byte Streams to Character Streams](#34354-bridging-byte-streams-to-character-streams)
      - [34.3.5.5 Correct Conversion Pattern](#34355-correct-conversion-pattern)
      - [34.3.5.6 Ordering Rules in Stream Chains](#34356-ordering-rules-in-stream-chains)
      - [34.3.5.7 Correct Logical Order](#34357-correct-logical-order)
      - [34.3.5.8 Resource Management Rule](#34358-resource-management-rule)
      - [34.3.5.9 Common Pitfalls](#34359-common-pitfalls)
  - [34.4 Core javaio Base Classes and Key Methods](#344-core-javaio-base-classes-and-key-methods)
    - [34.4.1 InputStream](#3441-inputstream)
      - [34.4.1.1 Key Methods](#34411-key-methods)
      - [34.4.1.2 Typical Usage Example](#34412-typical-usage-example)
    - [34.4.2 OutputStream](#3442-outputstream)
      - [34.4.2.1 Key Methods](#34421-key-methods)
      - [34.4.2.2 Typical Usage Example](#34422-typical-usage-example)
    - [34.4.3 Reader and Writer](#3443-reader-and-writer)
      - [34.4.3.1 Charset Handling](#34431-charset-handling)
  - [34.5 Buffered Streams and Performance](#345-buffered-streams-and-performance)
    - [34.5.1 Why Buffering Matters](#3451-why-buffering-matters)
    - [34.5.2 How Unbuffered Reading Works](#3452-how-unbuffered-reading-works)
    - [34.5.3 How BufferedInputStream Works](#3453-how-bufferedinputstream-works)
    - [34.5.4 Buffered Output Example](#3454-buffered-output-example)
    - [34.5.5 BufferedReader vs Reader](#3455-bufferedreader-vs-reader)
    - [34.5.6 BufferedWriter Example](#3456-bufferedwriter-example)
  - [34.6 java io vs java nio and java nio file](#346-javaio-vs-javanio-and-javaniofile)
    - [34.6.1 Conceptual Differences](#3461-conceptual-differences)
    - [34.6.2 java-nio Modern-File-IO](#3462-javanio-modern-file-io)
  - [34.7 When to Use Which API](#347-when-to-use-which-api)
  - [34.8 Common Traps and Tips](#348-common-traps-and-tips)


---

This chapter provides a detailed explanation of `Java I/O Streams`. 

It covers classic **java.io** streams, contrasts them with **java.nio / java.nio.file**, and explains design principles, APIs, edge cases, and exam-relevant distinctions.

## 34.1 What Is an I/O Stream in Java?

An `I/O Stream` represents a flow of data between a Java program and an external source or destination. 

The data flows sequentially, like water in a pipe.

- A stream is not a data structure; it does not store data permanently
- Streams are unidirectional (input OR output)
- Streams abstract the underlying source (file, network, memory, device)
- Streams operate in a blocking, synchronous manner (classic I/O)

In Java, streams are organized around two major dimensions:

- `Direction`: Input vs Output
- `Data type`: Byte vs Character

---

## 34.2 Byte Streams vs Character Streams

Java distinguishes streams based on the unit of data they process.

### 34.2.1 Byte Streams

- Work with raw 8-bit bytes
- Used for binary data (images, audio, PDFs, ZIPs)
- Base classes: `InputStream` and `OutputStream` 

### 34.2.2 Character Streams

- Work with 16-bit Unicode characters
- Handle character encoding automatically
- Base classes: `Reader` and `Writer` 

### 34.2.3 Summary Table


|	Aspect	|	Byte Streams	|	Character Streams	|
|-----------|-------------------|-----------------------|
|	`Unit of data`	|	byte (8 bits)	|	char (16 bits)	|
|	`Encoding handling`	|	None	|	Yes (Charset aware)	|
|	`Base classes`	|	InputStream / OutputStream	|	Reader / Writer	|
|	`Typical usage`	|	Binary files	|	Text files	|
| 	`Focus`	|	Low-level I/O	|	Text processing	|

---

## 34.3 Low-Level vs High-Level Streams

Streams in `java.io` follow a decorator pattern. Streams are stacked to add functionality.

### 34.3.1 Low-Level Streams (Node Streams)

Low-level streams connect directly to a data source or sink.

- They know how to read/write bytes or characters
- They do NOT provide buffering, formatting, or object handling

### 34.3.2 Common Low-Level Streams


|	Stream Class	|	Purpose	|
|-------------------|-----------|
|	`FileInputStream`		|	Read bytes from file	|
|	`FileOutputStream`	|	Write bytes to file	|
|	`FileReader`	|	Read characters from file	|
|	`FileWriter`	|	Write characters to file	|


- Example: Low-Level Byte Stream

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

### 34.3.3 High-Level Streams (Filter / Processing Streams)

High-level streams wrap other streams to add functionality.

- Buffering
- Data type conversion
- Object serialization
- Primitive reading/writing

### 34.3.4 Common High-Level Streams


|	Stream Class	|	Adds Functionality	|
|-------------------|-----------------------|
|	`BufferedInputStream`	|	Buffering	|
|	`BufferedReader`	|	Line-based reading	|
|	`DataInputStream`	|	Primitive types	|
|	`ObjectInputStream`	|	Object serialization	|
|	`PrintWriter`	|	Formatted text output	|


- Example: Stream Chaining

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

### 34.3.5 Stream Chaining Rules and Common Errors

The previous example illustrates stream chaining, a core concept in `java.io` based on the decorator pattern. 

Each stream wraps another stream, adding functionality while preserving a strict type hierarchy.

#### 34.3.5.1 Fundamental Chaining Rule

A stream can only wrap another stream of a compatible abstraction level.

- Byte streams can only wrap byte streams
- Character streams can only wrap character streams
- High-level streams require an underlying low-level stream

> [!NOTE]
> You cannot arbitrarily mix `InputStream` with `Reader` or `OutputStream` with `Writer`.

#### 34.3.5.2 Byte vs Character Stream Incompatibility

A very common error is attempting to wrap a byte stream directly with a character-based class (or vice versa).

#### 34.3.5.3 Invalid Chaining (Compile-Time Error)

```java
BufferedReader reader =
	new BufferedReader(new FileInputStream("text.txt"));
```

> [!NOTE]
> This fails because `BufferedReader` expects a `Reader`, not an `InputStream`.

#### 34.3.5.4 Bridging Byte Streams to Character Streams

To convert between byte-based and character-based streams, Java provides bridge classes that perform explicit charset decoding/encoding.

- `InputStreamReader` converts bytes → characters
- `OutputStreamWriter` converts characters → bytes

#### 34.3.5.5 Correct Conversion Pattern

```java
BufferedReader reader =
	new BufferedReader(
		new InputStreamReader(new FileInputStream("text.txt")));
```

> [!NOTE]
> The bridge handles character decoding using a charset (default or explicit).

#### 34.3.5.6 Ordering Rules in Stream Chains

The order of wrapping is not arbitrary and is often tested in certification exams.

- Low-level stream must be innermost
- Bridges (if needed) come next
- Buffered or processing streams come last

#### 34.3.5.7 Correct Logical Order

```text
FileInputStream → InputStreamReader → BufferedReader
```

#### 34.3.5.8 Resource Management Rule

Closing the outermost stream automatically closes all wrapped streams.

> [!NOTE]
> This is why try-with-resources should reference only the highest-level stream.

#### 34.3.5.9 Common Pitfalls

- Trying to buffer a stream of the wrong type
- Forgetting the bridge between byte and char streams
- Assuming `Reader` works with binary data
- Using default charset unintentionally
- Closing inner streams manually (risking double-close): `close()` on the outer wrapper is enough and recommended

---

## 34.4 Core `java.io` Base Classes and Key Methods

The `java.io` package is built around a small set of **abstract base classes**.
Understanding these classes and their contracts is essential, because all concrete I/O classes build on them.

### 34.4.1 InputStream

Abstract base class for byte-oriented input.
All input streams read raw bytes (8-bit values) from a source such as a file, network socket, or memory buffer.

#### 34.4.1.1 Key Methods

| Method | Description |
|--------|-------------|
| int `read()`	|	Reads one byte (0–255); returns -1 at end of stream |
| int `read(byte[])`	|	Reads bytes into buffer; returns number of bytes read or -1 |
| int `read(byte[], int, int)`	|	Reads up to length bytes into a buffer slice |
| int `available()`	|	Bytes readable without blocking (hint, not guarantee) |
| void `close()`	|	Releases the underlying resource |

> [!NOTE]
> The `read()` methods are blocking by default.
>
> They suspend the calling thread until data is available, end-of-stream is reached, or an I/O error occurs.

The `single-byte read()` method is primarily a low-level primitive.

In practice, reading one byte at a time is inefficient and should almost always be avoided in favor of buffered reads.

#### 34.4.1.2 Typical Usage Example

```java
try (InputStream in = new FileInputStream("data.bin")) {
	byte[] buffer = new byte[1024];
	int count;
	while ((count = in.read(buffer)) != -1) {
		// process buffer[0..count-1]
	}
}
```

### 34.4.2 OutputStream

Abstract base class for byte-oriented output.

It represents a destination where raw bytes can be written.

#### 34.4.2.1 Key Methods

| Method | Description |
|--------|-------------|
| void `write(int b)`	|	Writes the low 8 bits of the integer |
| void `write(byte[])`	|	Writes an entire byte array |
| void `write(byte[], int, int)`	|	Writes a slice of a byte array |
| void `flush()`	|	Forces buffered data to be written |
| void `close()`	|	Flushes and releases the resource |

> [!NOTE]
> Calling `close()` implicitly calls `flush()`.
>
> Failing to flush or close an OutputStream may result in data loss.

#### 34.4.2.2 Typical Usage Example

```java
try (OutputStream out = new FileOutputStream("out.bin")) {
	out.write(new byte[] {1, 2, 3, 4});
	out.flush();
}
```

### 34.4.3 Reader and Writer

`Reader` and `Writer` are the `character-oriented` counterparts of InputStream and OutputStream.

They operate on 16-bit Unicode characters instead of raw bytes.

| Class | Direction | Character-based | Encoding aware |
|-------|-----------|-----------------|----------------|
| `Reader` | Input | Yes | Yes |
| `Writer` | Output | Yes | Yes |

Readers and Writers always involve a `charset`, either explicitly or implicitly.

This makes them the correct abstraction for text processing.

#### 34.4.3.1 Charset Handling

```java
Reader reader = new InputStreamReader(
	new FileInputStream("file.txt"),
	StandardCharsets.UTF_8
);
```

> [!NOTE]
> `InputStreamReader` and `OutputStreamWriter` are bridge classes.
> 
> They convert between `byte streams` and `character streams` using a `charset`.

---

## 34.5 Buffered Streams and Performance

`Buffered streams` wrap another stream and add an in-memory buffer.

Instead of interacting with the operating system on every read or write, data is accumulated in memory and transferred in larger chunks.

- `BufferedInputStream` / `BufferedOutputStream` for byte streams
- `BufferedReader` / `BufferedWriter` for character streams

> [!NOTE]
> `Buffered streams` are `decorators`: they do not replace the underlying stream, they enhance it by adding buffering behavior.

### 34.5.1 Why Buffering Matters

| Aspect | Unbuffered | Buffered |
|--------|------------|----------|
| `System calls` | Frequent | Reduced |
| `Performance` | Poor | High |
| `Memory usage` | Minimal | Slightly higher |

System calls are expensive operations.

Buffering minimizes them by grouping multiple logical reads or writes into fewer physical I/O operations.

### 34.5.2 How Unbuffered Reading Works

In an unbuffered stream, each call to read() may result in a native system call.

This is especially inefficient when reading small amounts of data.

```java
try (InputStream in = new FileInputStream("data.bin")) {
	int b;
	while ((b = in.read()) != -1) {
		// each read() may trigger a system call
	}
}
```

> [!NOTE]
> Reading byte-by-byte without buffering is almost always a performance anti-pattern.

### 34.5.3 How BufferedInputStream Works

`BufferedInputStream` internally reads a large block of bytes into a buffer.

Subsequent `read()` calls are served directly from memory until the buffer is empty.

```java
try (InputStream in =
	new BufferedInputStream(new FileInputStream("data.bin"))) {
		int b;
		while ((b = in.read()) != -1) {
			// most reads are served from memory, not the OS
		}
}
```

> [!NOTE]
> The program still calls `read()` repeatedly, but the operating system is accessed only when the internal buffer needs refilling.

### 34.5.4 Buffered Output Example

Buffered output accumulates data in memory and writes it in larger chunks.

The `flush()` operation forces the buffer to be written immediately.

```java
try (OutputStream out =
	new BufferedOutputStream(new FileOutputStream("out.bin"))) {
		for (int i = 0; i < 1_000; i++) {
			out.write(i);
		}
		out.flush(); // forces buffered data to disk
}
```

> [!NOTE]
> `close()` automatically calls flush().
>
> Calling `flush()` explicitly is useful when data must be visible immediately.

### 34.5.5 BufferedReader vs Reader

`BufferedReader` adds efficient `**line-based reading**` on top of a Reader.

Without buffering, each character read may involve a system call.

```java
try (BufferedReader reader =
	new BufferedReader(new FileReader("file.txt"))) {

		String line;
		while ((line = reader.readLine()) != null) {
			System.out.println(line);
		}
}
```

> [!NOTE]
> The `readLine()` method is only available on BufferedReader (not Reader), because it relies on buffering to efficiently detect line boundaries.


### 34.5.6 BufferedWriter Example

```java
try (BufferedWriter writer =
	new BufferedWriter(new FileWriter("file.txt"))) {

		writer.write("Hello");
		writer.newLine();
		writer.write("World");
}
```

`BufferedWriter` minimizes disk access and provides convenience methods such as newLine().

> [!NOTE]
> Always wrap file streams with buffering unless there is a strong reason not to
> 
> Prefer BufferedReader / BufferedWriter for text
> 
> Prefer BufferedInputStream / BufferedOutputStream for binary data

---

## 34.6 java.io vs java.nio (and java.nio.file)

Modern Java applications increasingly favor NIO and NIO.2 APIs, but java.io remains fundamental and widely used.

### 34.6.1 Conceptual Differences

| Aspect | java.io | java.nio / nio.2 |
|--------|---------|------------------|
| `Programming model` | Stream-based | Buffer / Channel-based |
| `Blocking I/O` | blocking by default | Non-blocking capable |
| `File API` | File | Path + Files |
| `Scalability` | Limited | High |
| `Introduced` | Java 1.0 | Java 4 / Java 7 |

> [!NOTE]
> `java.nio` does not replace `java.io`.
>
> Many NIO classes internally rely on streams or coexist with them.

### 34.6.2 java.nio (Modern File I/O)

The java.nio.file package (NIO.2) provides a high-level, expressive, and safer file API.
It is the preferred approach for file operations in Java 11+.

Example: Reading a File (NIO)

```java
Path path = Path.of("file.txt");
List<String> lines = Files.readAllLines(path);
```

Equivalent java.io Code

```java
try (BufferedReader reader = new BufferedReader(new FileReader("file.txt"))) {
	String line;
	while ((line = reader.readLine()) != null) {
		System.out.println(line);
	}
}
```

---

## 34.7 When to Use Which API

| Scenario | Recommended API |
|----------|-----------------|
| `Simple file read/write` | java.nio.file.Files |
| `Binary streaming` | InputStream / OutputStream |
| `Character text processing` | Reader / Writer |
| `High-performance servers` | java.nio.channels |
| `Legacy APIs` | java.io |

---

## 34.8 Common Traps and Tips

- End-of-file is indicated by -1, not by an exception
- Closing a wrapper stream closes the wrapped stream automatically
- `BufferedReader.readLine()` strips line separators
- `InputStreamReader` always involves a charset
- Files utility methods throw checked IOException
- `available()` must not be used to detect EOF

> [!NOTE]
> Most I/O bugs come from incorrect assumptions about blocking, buffering, or character encoding.

