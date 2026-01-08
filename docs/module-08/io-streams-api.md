# 35. Java I/O APIs (Legacy and NIO)

### Table of Contents

- [35. Java I/O APIs (Legacy and NIO)](#35-java-io-apis-legacy-and-nio)
  - [35.1 Legacy java.io — Design, Behavior, and Subtleties](#351-legacy-javaio--design-behavior-and-subtleties)
    - [35.1.1 The Stream Abstraction](#3511-the-stream-abstraction)
    - [35.1.2 Stream Chaining and the Decorator Pattern](#3512-stream-chaining-and-the-decorator-pattern)
    - [35.1.3 Blocking I/O: What It Means](#3513-blocking-io-what-it-means)
    - [35.1.4 Resource Management: close(), flush(), and Why They Exist](#3514-resource-management-close-flush-and-why-they-exist)
    - [35.1.5 finalize(): Why It Exists and Why It Fails](#3515-finalize-why-it-exists-and-why-it-fails)
    - [35.1.6 available(): Purpose and Misuse](#3516-available-purpose-and-misuse)
    - [35.1.7 mark() and reset(): Controlled Backtracking](#3517-mark-and-reset-controlled-backtracking)
    - [35.1.8 Readers, Writers, and Character Encoding](#3518-readers-writers-and-character-encoding)
    - [35.1.9 File vs FileDescriptor](#3519-file-vs-filedescriptor)
  - [35.2 java.nio — Buffers, Channels, and Non-Blocking I/O](352-javanio--buffers-channels-and-non-blocking-io)
    - [35.2.1 From Streams to Buffers: A Conceptual Shift](#3521-from-streams-to-buffers-a-conceptual-shift)
    - [35.2.2 Buffers: Purpose and Structure](#3522-buffers-purpose-and-structure)
    - [35.2.3 Buffer Lifecycle: Write → Flip → Read](#3523-buffer-lifecycle-write-flip-read)
    - [35.2.4 clear() vs compact()](#3524-clear-vs-compact)
    - [35.2.5 Heap Buffers vs Direct Buffers](#3525-heap-buffers-vs-direct-buffers)
    - [35.2.6 Channels: What They Are](#3526-channels-what-they-are)
    - [35.2.7 Blocking vs Non-Blocking Channels](#3527-blocking-vs-non-blocking-channels)
    - [35.2.8 Scatter/Gather I/O](#3528-scattergather-io)
    - [35.2.9 Selectors: Multiplexing Non-Blocking I/O](#3529-selectors-multiplexing-non-blocking-io)
    - [35.2.10 When to Use java.nio](#35210-when-to-use-javanio)
  - [35.3 java.nio.file (NIO.2) — File and Directory Operations (Legacy vs Modern)](#353-javaniofile-nio2-file-and-directory-operations-legacy-vs-modern)
    - [35.3.1 Existence and Accessibility Checks](#3531-existence-and-accessibility-checks)
    - [35.3.2 Creating Files and Directories](#3532-creating-files-and-directories)
    - [35.3.3 Deleting Files and Directories](#3533-deleting-files-and-directories)
    - [35.3.4 Copying Files and Directories](#3534-copying-files-and-directories)
    - [35.3.5 Moving and Renaming](#3535-moving-and-renaming)
    - [35.3.6 Reading and Writing Text and Bytes (Files Enhancements)](#3536-reading-and-writing-text-and-bytes-files-enhancements)
    - [35.3.7 newInputStream/newOutputStream and newBufferedReader/newBufferedWriter](#3537-newinputstreamnewoutputstream-and-newbufferedreadernewbufferedwriter)
    - [35.3.8 Listing Directories and Traversing Trees](#3538-listing-directories-and-traversing-trees)
    - [35.3.9 Searching and Filtering](#3539-searching-and-filtering)
    - [35.3.10 Attributes: Reading, Writing, and Views](#35310-attributes-reading-writing-and-views)
    - [35.3.11 Symbolic Links and Link Following](#35311-symbolic-links-and-link-following)
    - [35.3.12 Summary: Why Files Is an Enhancement](#35312-summary-why-files-is-an-enhancement)
  - [35.4 Serialization — Object Streams, Compatibility, and Traps](#354-serialization-object-streams-compatibility-and-traps)
    - [35.4.1 What Serialization Does (and What It Does Not)](#3541-what-serialization-does-and-what-it-does-not)
    - [35.4.2 The Two Main Marker Interfaces](#3542-the-two-main-marker-interfaces)
    - [35.4.3 Basic Example: Writing and Reading an Object](#3543-basic-example-writing-and-reading-an-object)
    - [35.4.4 Object Graphs, References, and Identity](#3544-object-graphs-references-and-identity)
    - [35.4.5 serialVersionUID: The Versioning Key](#3545-serialversionuid-the-versioning-key)
    - [35.4.6 transient and static Fields](#3546-transient-and-static-fields)
    - [35.4.7 Non-Serializable Fields and NotSerializableException](#3547-non-serializable-fields-and-notserializableexception)
    - [35.4.8 Constructors and Serialization](#3548-constructors-and-serialization)
    - [35.4.9 Custom Serialization Hooks: writeObject and readObject](#3549-custom-serialization-hooks-writeobject-and-readobject)
    - [35.4.10 Example Use Case: Restoring a transient Derived Field](#35410-example-use-case-restoring-a-transient-derived-field)
    - [35.4.11 Externalizable: Full Control (and Full Responsibility)](#35411-externalizable-full-control-and-full-responsibility)
    - [35.4.12 readObject() Security Considerations](#35412-readobject-security-considerations)
    - [35.4.13 Common Traps and Practical Tips](#35413-common-traps-and-practical-tips)
    - [35.4.14 When to Use (or Avoid) Java Serialization](#35414-when-to-use-or-avoid-java-serialization)

---


## 35.1 Legacy java.io — Design, Behavior, and Subtleties

The legacy `java.io` API is the original I/O abstraction introduced in Java 1.0.

It is stream-oriented, blocking, and closely mapped to operating system I/O concepts.

Although newer APIs exist, `java.io` remains fundamental: many higher-level APIs build on it, and it is still heavily used.

### 35.1.1 The Stream Abstraction

A `stream` represents a continuous flow of data between a source and a destination.

In `java.io`, streams are **unidirectional**: they are either **input** or **output**.

| Stream | type | Direction | Data | unit |
| --- | --- | --- | --- | --- |
| `InputStream` | Input | Bytes |
| `OutputStream` | Output | Bytes |
| `Reader` | Input | Characters |
| `Writer` | Output | Characters |

Streams hide the concrete origin of data (file, network, memory) and expose a uniform read/write interface.

### 35.1.2 Stream Chaining and the Decorator Pattern

Most java.io streams are designed to be combined.
Each wrapper adds behavior without changing the underlying data source.

```java
InputStream in =
	new BufferedInputStream(
		new FileInputStream("data.bin"));
```

In this example:
- `FileInputStream` performs the actual file access
- `BufferedInputStream` adds an in-memory buffer

> [!NOTE]
> This design is known as the Decorator Pattern.
>
> It allows features to be layered dynamically.

### 35.1.3 Blocking I/O: What It Means

All legacy `java.io` streams are **blocking**.

This means a thread performing I/O may be suspended by the operating system.

For example, when calling `read()`:
- If data is available, it is returned immediately
- If no data is available, the thread waits
- If end-of-stream is reached, -1 is returned

> [!NOTE]
> Blocking behavior simplifies programming but limits scalability.

### 35.1.4 Resource Management: `close()`, `flush()`, and Why They Exist

Streams often encapsulate native operating system resources
such as `file descriptors` or `socket handles`.

These resources are limited and must be released explicitly.

| Method | Purpose |
| --- | --- |
| `flush()` | Writes buffered data to the destination |
| `close()` | Flushes and releases the resource |

```java
try (OutputStream out = new FileOutputStream("file.bin")) {
	out.write(42);
} // close() called automatically
```

> [!NOTE]
> Failing to close streams may cause data loss or resource exhaustion.

### 35.1.5 `finalize()`: Why It Exists and Why It Fails

Early Java attempted to automate resource cleanup using finalization.

The `finalize()` method was called by the garbage collector before reclaiming memory.

However, garbage collection timing is unpredictable.

| Aspect | finalize() |
| --- | --- |
| `Execution` | time Unspecified |
| `Reliability` | Low |
| `Current` | status Deprecated |

> [!NOTE]
> `finalize()` must never be used for I/O cleanup; it is deprecated and unsafe.

### 35.1.6 `available()`: Purpose and Misuse

The `available()` method estimates how many bytes can be read without blocking.

It does not report total remaining data.

Typical use cases include:
- Avoiding blocking in UI or protocol parsing
- Sizing temporary buffers

```java
if (in.available() > 0) {
	in.read(buffer);
}
```

> [!NOTE]
> `available()` must not be used to detect end-of-file.
> Only `read()` returning -1 signals EOF.

### 35.1.7 `mark()` and `reset()`: Controlled Backtracking

Some input streams allow marking a position
and returning to it later.

```java
BufferedInputStream in = new BufferedInputStream(...);
in.mark(1024);
// read ahead
in.reset();
```

| Stream | markSupported() |
| --- | --- |
| `FileInputStream` | No |
| `BufferedInputStream` | Yes |
| `ByteArrayInputStream` | Yes |


### 35.1.8 Readers, Writers, and Character Encoding

`Reader` and `Writer` operate on `characters`, not bytes.

This requires a `character encoding`.

If no charset is specified, the platform default is used.

```java
new FileReader("file.txt"); // platform default encoding
```

> [!NOTE]
> Relying on the platform default charset leads to non-portable bugs.
>
> Always specify a charset explicitly.

### 35.1.9 File vs FileDescriptor

`File` represents a `path` in the filesystem.

It does not represent an open resource.

FileDescriptor represents a native OS handle to an open file or stream.

| Class | Represents | Resource | ownership |
| --- | --- | --- | --- |
| `File` | Path | only | No |
| `FileDescriptor` | Native | handle | Yes |

> [!NOTE]
> Multiple streams may share the same FileDescriptor.
>
> Closing one closes the underlying resource for all.

---

## 35.2 `java.nio` — Buffers, Channels, and Non-Blocking I/O

The `java.nio` API (New I/O) was introduced to address limitations of legacy `java.io`.

It provides a lower-level, more explicit model of I/O that maps closely to modern operating systems.

At its core, `java.nio` is built around three concepts:
- `Buffers` — explicit memory containers
- `Channels` — bidirectional data connections
- `Selectors` — multiplexing non-blocking I/O

### 35.2.1 From Streams to Buffers: A Conceptual Shift

Legacy streams hide memory management from the programmer.

In contrast, `NIO` makes memory explicit through buffers.

| Aspect | java.io | java.nio |
| --- | --- | --- |
| `Data` | flow | Push-based Pull-based |
| `Memory` | Hidden | Explicit |
| `Control` | Simple | More granular |

With NIO, the application controls when data is read into memory and how it is consumed.

### 35.2.2 Buffers: Purpose and Structure

A `buffer` is a fixed-size, typed container for data.

All NIO I/O operations read from or write to buffers.

The most common buffer is ByteBuffer.

```java
ByteBuffer buffer = ByteBuffer.allocate(1024);
```

| Property | Meaning |
| --- | --- |
| `capacity` | Total size of the buffer |
| `position` | Current read/write index |
| `limit` | Boundary of readable or writable data |

### 35.2.3 Buffer Lifecycle: Write → Flip → Read

`Buffers` have a strict `usage lifecycle`.

Misunderstanding it is a common source of bugs.

Typical sequence:
- Write data into the buffer
- `flip()` to switch to read mode
- Read data from the buffer
- `clear()` or `compact()` to reuse

```java
ByteBuffer buffer = ByteBuffer.allocate(16);

buffer.put((byte) 1);
buffer.put((byte) 2);

buffer.flip(); // switch to read mode

while (buffer.hasRemaining()) {
	byte b = buffer.get();
}

buffer.clear(); // ready for writing again
```

> [!NOTE]
> `flip()` does not erase data: it adjusts position and limit.

### 35.2.4 `clear()` vs `compact()`

After reading, a buffer can be reused in two ways.

| Method | Behavior |
| --- | --- |
| `clear()` | Discards unread data |
| `compact()` | Preserves unread data |

`compact()` is useful in streaming protocols where partial messages may remain in the buffer.

### 35.2.5 Heap Buffers vs Direct Buffers

Buffers can be allocated in two different memory regions.

```java
ByteBuffer heap = ByteBuffer.allocate(1024);
ByteBuffer direct = ByteBuffer.allocateDirect(1024);
```

| Type | Memory | location | Characteristics |
| --- | --- | --- | --- |
| `Heap` | buffer | JVM | heap Garbage collected |
| `Direct` | buffer | Native | memory Faster I/O, costly allocation |

> [!NOTE]
> Direct buffers reduce copying between JVM and OS but must be used carefully to avoid memory pressure.

### 35.2.6 Channels: What They Are

A `channel` represents a connection to an I/O entity
such as a file, socket, or device.

Unlike streams, **channels are bidirectional**.

| Channel | type | Purpose |
| --- | --- | --- |
| `FileChannel` | File | I/O |
| `SocketChannel` | TCP | sockets |
| `DatagramChannel` | UDP | |

```java
try (FileChannel channel =
	FileChannel.open(Path.of("file.txt"))) {

		ByteBuffer buffer = ByteBuffer.allocate(128);
		channel.read(buffer);
}
```

### 35.2.7 Blocking vs Non-Blocking Channels

Channels can operate in blocking or non-blocking mode.

```java
SocketChannel channel = SocketChannel.open();
channel.configureBlocking(false);
```

In `**non-blocking mode**`:
- `read()` may return immediately with 0 bytes
- `write()` may write only part of the data

> [!NOTE]
> Non-blocking I/O shifts complexity from the OS to the application.

### 35.2.8 Scatter/Gather I/O

NIO supports reading into or writing from multiple buffers in a single operation.

```java
ByteBuffer header = ByteBuffer.allocate(128);
ByteBuffer body = ByteBuffer.allocate(1024);

ByteBuffer[] buffers = { header, body };
channel.read(buffers);
```

This is useful for structured protocols (headers + payload).

### 35.2.9 Selectors: Multiplexing Non-Blocking I/O

`Selectors` allow a single thread to monitor multiple channels.

They are the foundation of scalable servers.

| Component | Role |
| --- | --- |
| `Selector` | Monitors channels |
| `SelectionKey` | Represents channel state |
| `Interest` | set Operations of interest |


### 35.2.10 When to Use `java.nio`

`NIO` is appropriate when:
- High concurrency is required
- You need fine-grained memory control
- You are implementing protocols or servers

For simple file operations, `java.nio.file.Files` is usually sufficient.

---

## 35.3 `java.nio.file` (NIO.2) — File and Directory Operations (Legacy vs Modern)

This section focuses on practical operations on files and directories.

We compare the legacy approaches (java.io.File + java.io streams) with modern NIO.2 approaches (Path + Files).

The goal is not only to know the method names, but to understand:
- what each method really does
- what it returns and how it reports errors
- what pitfalls exist (race conditions, links, permissions, portability)
- when a Files method is a safe enhancement over the old approach

### 35.3.1 Existence and Accessibility Checks

A very common operation is to check whether a file exists and whether it can be accessed (read, written, executed).

Both the legacy API (java.io.File) and the modern NIO.2 API (java.nio.file.Files) provide methods for these checks.

However, it is important to understand that these checks are intentionally imprecise in both APIs.

They are best-effort hints, not reliable guarantees.

#### 35.3.1.1 Legacy API (File)

```java
File f = new File("data.txt");

boolean exists = f.exists();
boolean canRead = f.canRead();
boolean canWrite = f.canWrite();
boolean canExec = f.canExecute();
```

These methods return a boolean and do not explain why an operation failed.

For example, exists() may return false when:

- the file truly does not exist
- the file exists but access is denied
- a symbolic link is broken
- an I/O error occurs

The API provides no way to distinguish between these cases.

#### 35.3.1.2 Modern API (Files)

```java
Path p = Path.of("data.txt");

boolean exists = Files.exists(p);
boolean readable = Files.isReadable(p);
boolean writable = Files.isWritable(p);
boolean executable = Files.isExecutable(p);
```

Despite being newer, these methods also return booleans and also hide the reason for failure.

NIO.2 adds an explicit method to express uncertainty:

```java
boolean notExists = Files.notExists(p);
```

> [!NOTE]
> `exists()` and `notExists()` can both be false if the status cannot be determined (for example due to permissions).
>
> This means: “the file status cannot be determined” (for example, due to permissions).

This does not make the check more accurate — it merely makes the uncertainty explicit.

##### 35.3.1.2.1 Symbolic Link Awareness (Real Improvement)

One genuine enhancement of NIO.2 is control over symbolic link handling:

```java
Files.exists(p, LinkOption.NOFOLLOW_LINKS);
```

Legacy File cannot reliably distinguish:

- a missing file
- a broken symbolic link
- a link pointing to an inaccessible target

NIO.2 allows link-aware checks and explicit link inspection.

##### 35.3.1.2.2 Correct Usage Pattern (Critical)

Neither API provides reliable diagnostics through boolean checks alone.

Correct NIO.2 code does not “check first”.
Instead, it attempts the operation and handles the exception:

```java
try {
    Files.delete(p);
} catch (NoSuchFileException e) {
    // file truly does not exist
} catch (AccessDeniedException e) {
    // permission problem
} catch (IOException e) {
    // other I/O error
}
```

> [!NOTE]
> NIO.2’s real advantage is exception-based diagnostics during operations, not more accurate existence or accessibility checks.

##### 35.3.1.2.3 Summary Table

| Goal               | Legacy (File)              | Modern (Files)                     | Key detail                                                                 |
|--------------------|----------------------------|------------------------------------|----------------------------------------------------------------------------|
| Check existence    | `exists()`                   | `exists() / notExists()`             | notExists() may be false when the status cannot be determined               |
| Check read/write   | `canRead() / canWrite()`     | `isReadable() / isWritable()`        | Files methods can use LinkOption.NOFOLLOW_LINKS where supported             |
| Error details      | Not available              | Available via exceptions on actions| Boolean checks themselves still do not explain the reason for failure       |


### 35.3.2 Creating Files and Directories

Creation is a major weakness of legacy File.

Legacy often uses createNewFile() and mkdir/mkdirs(), which return boolean and provide little diagnostic information.

#### 35.3.2.1 Legacy API (File)

```java
File f = new File("a.txt");
boolean created = f.createNewFile(); // may throw IOException

File dir = new File("dir");
boolean ok1 = dir.mkdir();
boolean ok2 = new File("a/b/c").mkdirs();
```

`mkdir()` creates only one directory level, `mkdirs()` creates parents too.

Both return false on failure but do not tell you why.

#### 35.3.2.2 Modern API (Files)

```java
Path file = Path.of("a.txt");
Files.createFile(file);

Path dir1 = Path.of("dir");
Files.createDirectory(dir1);

Path dirDeep = Path.of("a/b/c");
Files.createDirectories(dirDeep);
```

> [!NOTE]
> `Files.createFile` throws `FileAlreadyExistsException` if the file exists.
>
> This is often preferred over boolean checks because it is race-safe.

| Goal              | Legacy (File)        | Modern (Files)           | Key detail                                                     |
|-------------------|----------------------|--------------------------|----------------------------------------------------------------|
| Create file       | `createNewFile()`      | `createFile()`             | NIO throws FileAlreadyExistsException if the file exists        |
| Create directory  | `mkdir()`              | `createDirectory()`        | NIO throws detailed exceptions on failure                       |
| Create parents    | `mkdirs()`             | `createDirectories()`      | Atomicity is not guaranteed for deep directory creation         |


### 35.3.3 Deleting Files and Directories

Deletion semantics differ strongly between legacy and NIO.2.

Legacy `delete()` returns boolean; NIO.2 offers methods that throw meaningful exceptions.

#### 35.3.3.1 Legacy API (File)

```java
File f = new File("a.txt");
boolean deleted = f.delete();
```

If deletion fails (permission denied, file does not exist, directory not empty), `delete()` usually returns false without explanation.

#### 35.3.3.2 Modern API (Files)

```java
Files.delete(Path.of("a.txt"));
```

If you want "delete if present" semantics, use deleteIfExists().

```java
Files.deleteIfExists(Path.of("a.txt"));
```

| Goal               | Legacy (File)            | Modern (Files)           | Key detail                                                         |
|--------------------|--------------------------|--------------------------|--------------------------------------------------------------------|
| Delete              | `delete()`                 | `delete()`                 | `Files.delete()` throws an exception with the failure reason          |
| Delete if present   | `exists() + delete()`      | `deleteIfExists()`         | Avoids TOCTOU (check-then-act) race conditions                      |


### 35.3.4 Copying Files and Directories

Legacy copying typically requires manually reading and writing bytes via streams.

NIO.2 provides high-level copy operations with options.

#### 35.3.4.1 Legacy technique (manual streams)

```java
try (InputStream in = new FileInputStream("src.bin"); OutputStream out = new FileOutputStream("dst.bin")) {

	byte[] buf = new byte[8192];
	int n;
	while ((n = in.read(buf)) != -1) {
		out.write(buf, 0, n);
	}
}
```

This is verbose and easy to get wrong (missing buffering, missing close, etc.).

#### 35.3.4.2 Modern API (Files.copy)

```java
Files.copy(Path.of("src.bin"), Path.of("dst.bin"));
```

Copy behavior can be controlled with options.

```java
Files.copy(
	Path.of("src.bin"),
	Path.of("dst.bin"),
	StandardCopyOption.REPLACE_EXISTING,
	StandardCopyOption.COPY_ATTRIBUTES
);
```

> [!NOTE]
> `Files.copy` throws FileAlreadyExistsException by default.
>
> Use `REPLACE_EXISTING` when overwriting is intended.

| Goal            | Legacy approach        | Modern (Files)                         | Key detail                                                             |
|-----------------|------------------------|----------------------------------------|------------------------------------------------------------------------|
| Copy file       | Manual stream loop     | `Files.copy(Path, Path, …)`              | Options include REPLACE_EXISTING and COPY_ATTRIBUTES                   |
| Copy stream     | InputStream/OutputStream | `Files.copy(InputStream, Path, …)`       | Useful for uploads, downloads, and piping data                         |
| Copy directory  | Manual recursion       | `walkFileTree + Files.copy`              | No single one-liner for full directory tree copy                        |


### 35.3.5 Moving and Renaming

Renaming in legacy code typically uses `File.renameTo()`, which is notoriously unreliable and platform-dependent.

NIO.2 provides Files.move() with explicit semantics and options.

#### 35.3.5.1 Legacy API

```java
boolean ok = new File("a.txt").renameTo(new File("b.txt"));
```

`renameTo()` returns false on failure and does not explain why.

It may also fail unexpectedly across filesystems.

#### 35.3.5.2 Modern API

```java
Files.move(Path.of("a.txt"), Path.of("b.txt"));
```

Move options provide precise behavior.

```java
Files.move(
	Path.of("a.txt"),
	Path.of("b.txt"),
	StandardCopyOption.REPLACE_EXISTING,
	StandardCopyOption.ATOMIC_MOVE
);
```

> [!NOTE]
> ATOMIC_MOVE is only guaranteed when the move occurs within the same filesystem.
> Otherwise an exception is thrown.

| Goal            | Legacy (File)      | Modern (Files)                 | Key detail                                                       |
|-----------------|--------------------|--------------------------------|------------------------------------------------------------------|
| Rename / move   | `renameTo()`         | `move()`                         | Files.move() provides exceptions and explicit options            |
| Atomic move     | Not supported      | `move(…, ATOMIC_MOVE)`           | Guaranteed only within the same filesystem                       |
| Replace existing| Not explicit       | `REPLACE_EXISTING`               | Makes overwrite intent explicit                                  |


### 35.3.6 Reading and Writing Text and Bytes (Files Enhancements)

A major enhancement of NIO.2 is the `Files` utility class, which provides high-level methods for common reading and writing tasks.

These methods reduce boilerplate and improve correctness.

#### 35.3.6.1 Legacy text reading/writing

```java
try (BufferedReader r = new BufferedReader(new FileReader("file.txt"))) {
	String line = r.readLine();
}
```

```java
try (BufferedWriter w = new BufferedWriter(new FileWriter("file.txt"))) {
	w.write("hello");
}
```

These legacy classes typically use the platform default charset unless you explicitly bridge with InputStreamReader/OutputStreamWriter.

#### 35.3.6.2 Modern text reading/writing

```java
List<String> lines = Files.readAllLines(Path.of("file.txt"), StandardCharsets.UTF_8);
Files.write(Path.of("file.txt"), lines, StandardCharsets.UTF_8);

Files.lines(Path.of("file.txt")).forEach(System.out::println);

String string = Files.readString(Path.of("file.txt"));
Files.writeString(Path.of("file.txt"), string);
```

#### 35.3.6.3 Modern binary reading/writing

```java
byte[] data = Files.readAllBytes(Path.of("data.bin"));
Files.write(Path.of("out.bin"), data);
```

> [!IMPORTANT]
> `readAllBytes` and `readAllLines` load the entire file into memory.
>
> Use `Files.lines()` instead which lazily process each line or, for large files, prefer streaming APIs such as newBufferedReader or newInputStream.

| Task          | Legacy method                     | NIO.2 Files method                 | Key detail                                                     |
|---------------|-----------------------------------|------------------------------------|----------------------------------------------------------------|
| Read all bytes| Manual InputStream loop           | `readAllBytes()`                     | Loads the entire file into memory                              |
| Read all lines| BufferedReader loop               | `readAllLines()`                     | Loads the entire file into memory                              |
| Read lines lazily| BufferedReader loop               | `lines()`                     | Lazily process each line                              |
| Write bytes   | OutputStream                      | `write(Path, byte[])`                | Simple and concise                                              |
| Write lines   | BufferedWriter loop               | `write(Path, Iterable, …)`           | Charset can be specified                                       |
| Append text   | FileWriter(true)                  | `write(…, APPEND)`                   | Options make intent explicit                                   |


### 35.3.7 newInputStream/newOutputStream and newBufferedReader/newBufferedWriter

These factory methods create stream/reader instances from a Path.

They are the recommended bridge between classic streaming and NIO.2 path handling.

```java
try (InputStream in = Files.newInputStream(Path.of("a.bin"))) { }
try (OutputStream out = Files.newOutputStream(Path.of("b.bin"))) { }
```

```java
try (BufferedReader r = Files.newBufferedReader(Path.of("t.txt"), StandardCharsets.UTF_8)) { }
try (BufferedWriter w = Files.newBufferedWriter(Path.of("t.txt"), StandardCharsets.UTF_8)) { }
```

### 35.3.8 Listing Directories and Traversing Trees

Legacy directory listing is based on `File.list()` and `File.listFiles()`.

These methods return arrays and provide limited error reporting.

#### 35.3.8.1 Legacy listing

```java
File dir = new File(".");
File[] children = dir.listFiles();
```

NIO.2 provides multiple approaches depending on needs.

#### 35.3.8.2 Modern listing (DirectoryStream)

```java
try (DirectoryStream<Path> ds = Files.newDirectoryStream(Path.of("."))) {
	for (Path p : ds) {
		System.out.println(p);
	}
}
```

#### 35.3.8.3 Modern walking (Files.walk)

```java
Files.walk(Path.of("."))
	.filter(Files::isRegularFile)
		.forEach(System.out::println);
```

> [!NOTE]
> `Files.walk` returns a Stream that must be closed.
> Prefer try-with-resources when using it.

```java
try (Stream<Path> s = Files.walk(Path.of("."))) {
	s.forEach(System.out::println);
}
```

#### 35.3.8.4 Modern traversal with FileVisitor

For full control (skip subtrees, handle errors, follow links), use `walkFileTree + FileVisitor`.

```java
Files.walkFileTree(Path.of("."), new SimpleFileVisitor<>() {
	@Override
	public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) {
		System.out.println(file);
		return FileVisitResult.CONTINUE;
	}
});
```

| Goal | Legacy | Modern | Key | detail |
| --- | --- | --- | --- | --- |
| List | directory | list/listFiles | `newDirectoryStream` | Lazy, must be closed |
| Walk | tree | (simple) | Manual | recursion `walk()` Stream must be closed |
| Walk | tree | (control) | Manual | recursion `walkFileTree()` Error handling + pruning |

### 35.3.9 Searching and Filtering

Searching is typically implemented by traversing and filtering.

NIO.2 provides convenient building blocks: glob patterns, streams, and visitors.

```java
try (DirectoryStream<Path> ds =
	Files.newDirectoryStream(Path.of("."), "*.txt")) {
		for (Path p : ds) {
			System.out.println(p);
		}
}
```

```java
try (Stream<Path> s = Files.find(Path.of("."), 10,
	(p, a) -> a.isRegularFile() && p.toString().endsWith(".log"))) {
		s.forEach(System.out::println);
}
```

### 35.3.10 Attributes: Reading, Writing, and Views

Legacy File exposes only a few attributes (size, lastModified).

NIO.2 supports rich metadata via attribute views.

#### 35.3.10.1 Legacy attributes

```java
long size = new File("a.txt").length();
long lm = new File("a.txt").lastModified();
```

#### 35.3.10.2 Modern attributes

```java
BasicFileAttributes a =
	Files.readAttributes(Path.of("a.txt"), BasicFileAttributes.class);

long size = a.size();
FileTime modified = a.lastModifiedTime();
```

You can also access attributes using string-based names.

```java
Object v = Files.getAttribute(Path.of("a.txt"), "basic:size");
Files.setAttribute(Path.of("a.txt"), "basic:lastModifiedTime", FileTime.fromMillis(0));
```

> [!NOTE]
> Attribute views are filesystem-dependent.
>
> Unsupported attributes cause exceptions.

### 35.3.11 Symbolic Links and Link Following

NIO.2 can explicitly detect and read symbolic links.

This is critical for correct filesystem traversal and security.

```java
Path link = Path.of("mylink");
boolean isLink = Files.isSymbolicLink(link);

if (isLink) {
	Path target = Files.readSymbolicLink(link);
}
```

Many methods follow links by default.
To prevent this, pass `LinkOption.NOFOLLOW_LINKS` when supported.

### 35.3.12 Summary: Why Files Is an Enhancement

The Files utility class improves filesystem programming by:
- reducing boilerplate (copy/move/read/write)
- providing explicit options (overwrite, atomic move, follow links)
- offering richer metadata (attributes/views)
- supporting scalable traversal and searching

Legacy APIs remain mostly for backward compatibility or when required by old libraries.

---

## 35.4 Serialization — Object Streams, Compatibility, and Traps

Serialization is the process of converting an object graph into a byte stream so it can be stored or transmitted, then reconstructed later.

In Java, classic serialization is implemented by `java.io.ObjectOutputStream` and `java.io.ObjectInputStream`.

This topic is critical because it combines:
- I/O streams and object graphs
- versioning and backward compatibility
- security concerns and safe usage patterns
- special language rules (`transient`, static, `serialVersionUID`)

### 35.4.1 What Serialization Does (and What It Does Not)

When an object is serialized, Java writes enough information to reconstruct it later:
- the class name
- the serialVersionUID
- the values of serializable instance fields
- references between objects (object identity)

Serialization does not automatically include:
- static fields (class-level state)
- transient fields (explicitly excluded)
- non-serializable referenced objects (unless handled specially)

### 35.4.2 The Two Main Marker Interfaces

Java serialization is enabled by implementing one of these interfaces.

| Interface Meaning Control level |
| --- |
| Serializable Opt-in marker, default mechanism Medium (custom hooks possible) |
| Externalizable Requires manual read/write implementation High (full control) |

> [!NOTE]
> `Serializable` has no methods. It is a marker interface.
>
> `Externalizable` extends Serializable and adds readExternal/writeExternal.

### 35.4.3 Basic Example: Writing and Reading an Object

This is the minimal pattern used in practice.

```java
import java.io.*;

class Person implements Serializable {

	private String name;
	private int age;

	Person(String name, int age) {
		this.name = name;
		this.age = age;
	}

}

public class Demo {

	public static void main(String[] args) throws Exception {

		Person p = new Person("Alice", 30);

		try (ObjectOutputStream out =
				 new ObjectOutputStream(new FileOutputStream("p.bin"))) {
			out.writeObject(p);
		}

		try (ObjectInputStream in =
				 new ObjectInputStream(new FileInputStream("p.bin"))) {
			Person copy = (Person) in.readObject();
		}
	}

}
```

> [!NOTE]
> `readObject()` returns Object. A cast is required.
> `readObject()` can throw ClassNotFoundException.

### 35.4.4 Object Graphs, References, and Identity

Serialization preserves object identity within the same stream.

If the same object reference appears multiple times in the graph, Java writes it once and later writes back-references.

```java
Person p = new Person("Bob", 40);
Object[] arr = { p, p }; // same reference twice

out.writeObject(arr);
Object[] restored = (Object[]) in.readObject();

// restored[0] and restored[1] refer to the same object instance
```

> [!NOTE]
> This behavior prevents infinite recursion on cyclic graphs.

### 35.4.5 `serialVersionUID`: The Versioning Key

`serialVersionUID` is a long identifier used to verify compatibility between a serialized stream and a class definition.

If the UID differs, deserialization typically fails with InvalidClassException.

If you do not declare `serialVersionUID`, the JVM computes one from class details.

Small changes may change the computed UID, breaking compatibility.

```java
class Person implements Serializable {

	private static final long serialVersionUID = 1L;

	private String name;
	private int age;
}
```

| Change type Compatibility impact (default) |
| --- |
| Add a field Often compatible (new field gets default) |
| Remove a field Often compatible (missing field ignored) |
| Change field type Often incompatible |
| Change class name/package Incompatible |
| Change serialVersionUID Incompatible |

> [!NOTE]
> Declaring a stable serialVersionUID is the standard way to control serialization compatibility.

### 35.4.6 `transient` and `static` Fields

`transient` fields are excluded from serialization.

On deserialization, transient fields are assigned default values (0, false, null) unless explicitly restored.

`static` fields belong to the class, not to instances, so they are not serialized.

```java
class Session implements Serializable {

private static final long serialVersionUID = 1L;

static int counter = 0;      // not serialized
transient String token;      // not serialized
String user;                 // serialized


}
```

> [!NOTE]
> If a transient field is required after deserialization, you must recompute it or restore it manually.

### 35.4.7 Non-Serializable Fields and NotSerializableException

If an object references a field whose type is not serializable, serialization fails with NotSerializableException.

```java
class Holder implements Serializable {

	private static final long serialVersionUID = 1L;

	private Thread t; // Thread is not serializable


}
```

Typical solutions:
- mark the field transient
- replace it with a serializable representation
- use custom serialization hooks

### 35.4.8 Constructors and Serialization

Constructor behavior during serialization and deserialization is a frequent source of confusion.

Java serialization restores object state primarily from the byte stream, not by running constructors.

#### 35.4.8.1 Rule: Constructors of Serializable Classes Are Not Called

During deserialization of a Serializable class, the constructors of that class are NOT executed.

The instance is created without calling those constructors, and field values are injected from the stream.

> [!NOTE]
> This is why constructors of Serializable classes must not contain essential initialization logic.
>
> That initialization would not run during deserialization.

#### 35.4.8.2 Inheritance Rule: The First Non-Serializable Superclass Constructor Is Called

When a Serializable class has a non-Serializable superclass, deserialization must still initialize that superclass part.

Therefore, Java calls **the no-argument constructor of the first non-Serializable superclass**.

Important implications:

- the non-Serializable superclass must have an accessible no-arg constructor
- serializable subclasses skip constructors, but non-serializable superclasses do not

#### 35.4.8.3 Summary Table: Which Constructors Run

| Class type Constructor called during deserialization |
| --- |
| Serializable class No |
| Serializable subclass No |
| First non-Serializable superclass Yes (no-arg constructor) |
| Externalizable class Yes (public no-arg constructor required) |

#### 35.4.8.4 Worked Example: Which Constructors Are Called

This example prints which constructors run during normal construction and during deserialization.

```java
import java.io.*;

class A {

	A() {
		System.out.println("A constructor");
	}
}

class B extends A implements Serializable {

	private static final long serialVersionUID = 1L;

	B() {
		System.out.println("B constructor");
	}
}

class C extends B { // Extending B, C is Serializable

	private static final long serialVersionUID = 1L;

	C() {
		System.out.println("C constructor");
	}
}

public class Demo {

	public static void main(String[] args) throws Exception {

		C obj = new C();

		try (ObjectOutputStream out =
				 new ObjectOutputStream(new FileOutputStream("c.bin"))) {
			out.writeObject(obj);
		}

		try (ObjectInputStream in =
				 new ObjectInputStream(new FileInputStream("c.bin"))) {
			Object restored = in.readObject();
		}
	}
}
```

Expected Output and Explanation
During normal construction (new C()):
```text
A constructor
B constructor
C constructor
```

During deserialization (readObject):
```text
A constructor
```

Explanation:
- C is Serializable, so C() is not called during deserialization
- B is Serializable, so B() is not called during deserialization
- A is not Serializable, so A() is called (no-arg constructor)
- Fields of B and C are restored from the stream instead of constructors running

> [!NOTE]
> If the first non-Serializable superclass has no accessible no-arg constructor, deserialization fails.


### 35.4.9 Custom Serialization Hooks: `writeObject` and `readObject`

Custom serialization hooks exist to handle cases where default Java serialization is not enough (transient state, derived fields, encryption, validation, compatibility).

They are advanced but extremely important for correct deserialization behavior.

#### 35.4.9.1 Why Custom Serialization Exists

By default, Java serialization automatically writes and reads all non-static, non-transient instance fields of a Serializable object.

This is convenient, but it cannot express certain common needs.

Typical reasons to customize serialization:
- A field should not be stored directly (sensitive data)
- A field is derived/cached and should be recomputed after restore
- You need validation when reading (reject invalid state)
- You need backward/forward compatibility logic (support older streams)
- A referenced object is not Serializable and must be handled specially

#### 35.4.9.2 What `writeObject` and `readObject` Really Are

To customize serialization and deserialization, a class may define two special private methods named `writeObject` and `readObject`.

These methods are not overrides of methods from any interface or superclass.

They do not belong to Serializable, and they are not part of the normal method call flow of your program.

You never call writeObject or readObject yourself.

Instead, the serialization framework (ObjectOutputStream and ObjectInputStream) checks, using reflection, whether the class defines methods with these exact names and signatures.

If such methods are found, the serialization framework calls them automatically during serialization or deserialization.

If they are not found, the framework performs default serialization instead.

[!NOTE]
> If the method signature is incorrect (wrong visibility, parameter type, return type, or declared exceptions), the serialization framework does not recognize the method and silently falls back to default serialization.
>
> This behavior often makes errors hard to diagnose.

#### 35.4.9.3 Exact Required Signatures

```java
private void writeObject(ObjectOutputStream out) throws IOException

private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException
```

Key constraints:
- must be private
- must return void
- parameter types must match exactly
- exceptions must be compatible with the required throws list

#### 35.4.9.4 What Happens During Serialization: Step by Step

When you serialize an object, you typically call:

```java
out.writeObject(obj);
```

Then the serialization mechanism does roughly this:
- Checks if the object’s class implements Serializable
- Checks whether the class declares a private writeObject(ObjectOutputStream)
- If not present: default serialization runs automatically
- If present: your writeObject is called instead

A crucial point: inside writeObject, Java does not automatically write the normal fields unless you ask for it.

This is why this call exists:
```java
out.defaultWriteObject();
```

`defaultWriteObject()` means: “serialize the object’s normal serializable fields using the default mechanism.”

After that, you may write extra data in any format you want.

#### 35.4.9.5 Typical Pattern and the Write/Read Order Rule

The typical pattern is to keep default serialization and then extend it.

The order of reads MUST match the order of writes.

```java
private void writeObject(ObjectOutputStream out) throws IOException {
	out.defaultWriteObject(); // writes normal fields
	out.writeInt(42); // writes extra custom data
}

private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException {

	in.defaultReadObject();         // reads normal fields
	int x = in.readInt();           // reads extra custom data in same order

}
```

> [!NOTE]
> If you write extra values (ints/strings/etc.), you must read them back in the same sequence.
> Otherwise deserialization will fail or restore corrupted state.

### 35.4.10 Example Use Case: Restoring a transient Derived Field

A classic use case is recomputing a transient cached value after deserialization.

```java
class User implements Serializable {

	private static final long serialVersionUID = 1L;

	private String firstName;
	private String lastName;

	private transient String fullName;

	User(String firstName, String lastName) {
		this.firstName = firstName;
		this.lastName = lastName;
		this.fullName = firstName + " " + lastName;
	}

	private void readObject(ObjectInputStream in)
			throws IOException, ClassNotFoundException {

		in.defaultReadObject(); // restore firstName and lastName
		fullName = firstName + " " + lastName; // recompute transient field
	}
}
```

### 35.4.11 Externalizable: Full Control (and Full Responsibility)

Externalizable requires you to define how to write and read the object manually.

It also requires a public no-argument constructor because deserialization instantiates the object first.

```java
import java.io.*;

class Point implements Externalizable {
int x;
int y;

public Point() { } // required

public Point(int x, int y) { this.x = x; this.y = y; }

@Override
public void writeExternal(ObjectOutput out) throws IOException {
    out.writeInt(x);
    out.writeInt(y);
}

@Override
public void readExternal(ObjectInput in) throws IOException {
    x = in.readInt();
    y = in.readInt();
}


}
```

> [!NOTE]
> With Externalizable, you control the format.
> If you change the format later, you must handle backward compatibility yourself.

### 35.4.12 `readObject()` Security Considerations

Deserialization of untrusted data is dangerous because it can execute code indirectly via:
- constructors and initialization logic
- readObject hooks
- gadget chains in libraries

Safe practice guidelines:
- Never deserialize untrusted bytes unless you have a strong reason
- Prefer safe data formats (JSON, protobuf) for external inputs
- If forced, apply object filters and strict validation


### 35.4.13 Common Traps and Practical Tips

- Serializable is marker-only; no method must be implemented
- `readObject` returns Object and may throw ClassNotFoundException
- `static fields` are never serialized
- `transient fields` reset to default values unless restored
- Missing `serialVersionUID` may break compatibility unexpectedly
- Externalizable requires public no-arg constructor
- NotSerializableException occurs when a referenced field type is not serializable

### 35.4.14 When to Use (or Avoid) Java Serialization

Use classic Java serialization mainly for:
- short-lived local persistence under controlled versions
- in-memory caching where both ends are trusted
- legacy systems that already depend on it

Avoid it for:
- public network protocols
- long-term storage with evolving schemas
- untrusted inputs


