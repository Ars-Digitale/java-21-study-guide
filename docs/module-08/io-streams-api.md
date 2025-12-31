# Java I/O APIs (Legacy and NIO)

## 1. Legacy `java.io` — Design, Behavior, and Subtleties

The legacy `java.io` API is the original I/O abstraction introduced in Java 1.0.

It is stream-oriented, blocking, and closely mapped to operating system I/O concepts.

Although newer APIs exist, `java.io` remains fundamental: many higher-level APIs build on it, and it is still heavily used.

### 1.1 The Stream Abstraction

A `stream` represents a continuous flow of data between a source and a destination.

In `java.io`, streams are **unidirectional**: they are either **input** or **output**.

| Stream | type | Direction | Data | unit |
| --- | --- | --- | --- | --- |
| `InputStream` | Input | Bytes |
| `OutputStream` | Output | Bytes |
| `Reader` | Input | Characters |
| `Writer` | Output | Characters |

Streams hide the concrete origin of data (file, network, memory) and expose a uniform read/write interface.

### 1.2 Stream Chaining and the Decorator Pattern

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

### 1.3 Blocking I/O: What It Means

All legacy `java.io` streams are **blocking**.

This means a thread performing I/O may be suspended by the operating system.

For example, when calling `read()`:
- If data is available, it is returned immediately
- If no data is available, the thread waits
- If end-of-stream is reached, -1 is returned

> [!NOTE]
> Blocking behavior simplifies programming but limits scalability.

### 1.4 Resource Management: `close()`, `flush()`, and Why They Exist

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

### 1.5 `finalize()`: Why It Exists and Why It Fails

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

### 1.6 `available()`: Purpose and Misuse

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

### 1.7 `mark()` and `reset()`: Controlled Backtracking

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


### 1.8 Readers, Writers, and Character Encoding

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

### 1.9 File vs FileDescriptor

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

## 2. `java.nio` — Buffers, Channels, and Non-Blocking I/O

The `java.nio` API (New I/O) was introduced to address limitations of legacy `java.io`.

It provides a lower-level, more explicit model of I/O that maps closely to modern operating systems.

At its core, `java.nio` is built around three concepts:
- `Buffers` — explicit memory containers
- `Channels` — bidirectional data connections
- `Selectors` — multiplexing non-blocking I/O

### 2.1 From Streams to Buffers: A Conceptual Shift

Legacy streams hide memory management from the programmer.

In contrast, `NIO` makes memory explicit through buffers.

| Aspect | java.io | java.nio |
| --- | --- | --- |
| `Data` | flow | Push-based Pull-based |
| `Memory` | Hidden | Explicit |
| `Control` | Simple | More granular |

With NIO, the application controls when data is read into memory and how it is consumed.

### 2.2 Buffers: Purpose and Structure

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

### 2.3 Buffer Lifecycle: Write → Flip → Read

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

### 2.4 `clear()` vs `compact()`

After reading, a buffer can be reused in two ways.

| Method | Behavior |
| --- | --- |
| `clear()` | Discards unread data |
| `compact()` | Preserves unread data |

`compact()` is useful in streaming protocols where partial messages may remain in the buffer.

### 2.5 Heap Buffers vs Direct Buffers

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

### 2.6 Channels: What They Are

A `channel` represents a connection to an I/O entity
such as a file, socket, or device.

Unlike streams, **channels are bidirectional**.

| Channel | type | Purpose |
| --- | --- | --- |
| `FileChannel` | File | I/O |
| `SocketChannel` | TCP | sockets |
| `DatagramChannel` | UDP |

```java
try (FileChannel channel =
	FileChannel.open(Path.of("file.txt"))) {

		ByteBuffer buffer = ByteBuffer.allocate(128);
		channel.read(buffer);
}
```

### 2.7 Blocking vs Non-Blocking Channels

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

### 2.8 Scatter/Gather I/O

NIO supports reading into or writing from multiple buffers in a single operation.

```java
ByteBuffer header = ByteBuffer.allocate(128);
ByteBuffer body = ByteBuffer.allocate(1024);

ByteBuffer[] buffers = { header, body };
channel.read(buffers);
```

This is useful for structured protocols (headers + payload).

### 2.9 Selectors: Multiplexing Non-Blocking I/O

`Selectors` allow a single thread to monitor multiple channels.

They are the foundation of scalable servers.

| Component | Role |
| --- | --- |
| `Selector` | Monitors channels |
| `SelectionKey` | Represents channel state |
| `Interest` | set Operations of interest |


### 2.10 When to Use `java.nio`

`NIO` is appropriate when:
- High concurrency is required
- You need fine-grained memory control
- You are implementing protocols or servers

For simple file operations, `java.nio.file.Files` is usually sufficient.

---

## 3 `java.nio.file` (NIO.2) — File and Directory Operations (Legacy vs Modern)

This section focuses on practical operations on files and directories.

We compare the legacy approaches (java.io.File + java.io streams) with modern NIO.2 approaches (Path + Files).

The goal is not only to know the method names, but to understand:
- what each method really does
- what it returns and how it reports errors
- what pitfalls exist (race conditions, links, permissions, portability)
- when a Files method is a safe enhancement over the old approach

### 3.1 Existence and Accessibility Checks

A very common operation is to check whether a file exists and whether it can be accessed (read, written, executed).

Both the legacy API (java.io.File) and the modern NIO.2 API (java.nio.file.Files) provide methods for these checks.

However, it is important to understand that these checks are intentionally imprecise in both APIs.

They are best-effort hints, not reliable guarantees.

#### 3.1.1 Legacy API (File)

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

#### 3.1.2 Modern API (Files)

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

**Symbolic Link Awareness** (Real Improvement)

One genuine enhancement of NIO.2 is control over symbolic link handling:

```java
Files.exists(p, LinkOption.NOFOLLOW_LINKS);
```

Legacy File cannot reliably distinguish:

- a missing file
- a broken symbolic link
- a link pointing to an inaccessible target

NIO.2 allows link-aware checks and explicit link inspection.

**Correct Usage Pattern** (Critical)

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

Summary Table:

| Goal | Legacy | (File) | Modern | (Files) | Key | detail |
| --- | --- | --- | --- | --- | --- | --- |
| Check | existence | exists() | exists() | / | notExists() | notExists may be false when unknown |
| Check | read/write | canRead/canWrite | isReadable/isWritable | Files | can | specify NOFOLLOW_LINKS |
| Error | details | Not | available | Exceptions | available | in other ops Checks still return boolean |

### 3.2 Creating Files and Directories

Creation is a major weakness of legacy File.
Legacy often uses createNewFile() and mkdir/mkdirs(), which return boolean and provide little diagnostic information.

### Legacy API (File)

```java
File f = new File("a.txt");
boolean created = f.createNewFile(); // may throw IOException

File dir = new File("dir");
boolean ok1 = dir.mkdir();
boolean ok2 = new File("a/b/c").mkdirs();
```

mkdir() creates only one directory level, mkdirs() creates parents too.
Both return false on failure but do not tell you why.

### Modern API (Files)

```java
Path file = Path.of("a.txt");
Files.createFile(file);

Path dir1 = Path.of("dir");
Files.createDirectory(dir1);

Path dirDeep = Path.of("a/b/c");
Files.createDirectories(dirDeep);
```

> [!NOTE]
> Files.createFile throws FileAlreadyExistsException if the file exists.
> This is often preferred over boolean checks because it is race-safe.

| Goal | Legacy | (File) | Modern | (Files) | Key | detail |
| --- | --- | --- | --- | --- | --- | --- |
| Create | file | createNewFile() | createFile() | NIO | throws | FileAlreadyExistsException |
| Create | directory | mkdir() | createDirectory() | NIO | throws | detailed exceptions |
| Create | parents | mkdirs() | createDirectories() | Atomicity | is | not guaranteed for deep creation |

### 9.3.3 Deleting Files and Directories

Deletion semantics differ strongly between legacy and NIO.2.
Legacy delete() returns boolean; NIO.2 offers methods that throw meaningful exceptions.

### Legacy API (File)

```java
File f = new File("a.txt");
boolean deleted = f.delete();
```

If deletion fails (permission denied, file does not exist, directory not empty), delete() usually returns false without explanation.

### Modern API (Files)

```java
Files.delete(Path.of("a.txt"));
```

If you want "delete if present" semantics, use deleteIfExists().

```java
Files.deleteIfExists(Path.of("a.txt"));
```

| Goal | Legacy | (File) | Modern | (Files) | Key | detail |
| --- | --- | --- | --- | --- | --- | --- |
| Delete | delete() | delete() | Files | throws | exception | with reason |
| Delete | if | present | Manual | exists() | check | deleteIfExists() Avoids TOCTOU check-then-act pattern |

### 9.3.4 Copying Files and Directories

Legacy copying typically requires manually reading and writing bytes via streams.
NIO.2 provides high-level copy operations with options.

### Legacy technique (manual streams)

```java
try (InputStream in = new FileInputStream("src.bin");
OutputStream out = new FileOutputStream("dst.bin")) {

byte[] buf = new byte[8192];
int n;
while ((n = in.read(buf)) != -1) {
    out.write(buf, 0, n);
}


}
```

This is verbose and easy to get wrong (missing buffering, missing close, etc.).

### Modern API (Files.copy)

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
> Files.copy throws FileAlreadyExistsException by default.
> Use REPLACE_EXISTING when overwriting is intended.

| Goal | Legacy | approach | Modern | (Files) | Key | detail |
| --- | --- | --- | --- | --- | --- | --- |
| Copy | file | Manual | streams | Files.copy | Options: | REPLACE_EXISTING, COPY_ATTRIBUTES |
| Copy | stream | Streams | Files.copy(InputStream, | Path, | ...) | Useful for uploads/downloads |
| Copy | directory | Manual | recursion | Walk | tree | + copy No single one-liner for full tree copy |

### 9.3.5 Moving and Renaming

Renaming in legacy code typically uses File.renameTo(), which is notoriously unreliable and platform-dependent.
NIO.2 provides Files.move() with explicit semantics and options.

### Legacy API

```java
boolean ok = new File("a.txt").renameTo(new File("b.txt"));
```

renameTo() returns false on failure and does not explain why.
It may also fail unexpectedly across filesystems.

### Modern API

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

| Goal | Legacy | (File) | Modern | (Files) | Key | detail |
| --- | --- | --- | --- | --- | --- | --- |
| Rename/move | renameTo() | move() | Files | gives | exceptions | + options |
| Atomic | move | No | move(..., | ATOMIC_MOVE) | Only | within same filesystem |
| Replace | existing | Not | explicit | REPLACE_EXISTING | Makes | intent explicit |

### 9.3.6 Reading and Writing Text and Bytes (Files Enhancements)

A major enhancement of NIO.2 is the Files utility class, which provides high-level methods for common reading and writing tasks.
These methods reduce boilerplate and improve correctness.

### Legacy text reading/writing

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

### Modern text reading/writing

```java
List<String> lines = Files.readAllLines(Path.of("file.txt"), StandardCharsets.UTF_8);
Files.write(Path.of("file.txt"), lines, StandardCharsets.UTF_8);
```

### Modern binary reading/writing

```java
byte[] data = Files.readAllBytes(Path.of("data.bin"));
Files.write(Path.of("out.bin"), data);
```

> [!NOTE]
> readAllBytes and readAllLines load the entire file into memory.
> For large files, prefer streaming APIs such as newBufferedReader or newInputStream.

| Task | Legacy | method | NIO.2 | Files | method | Key | detail |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Read | all | bytes | Manual | stream | loop | readAllBytes() | Loads whole file into memory |
| Read | all | lines | BufferedReader | loop | readAllLines() | Loads | whole file into memory |
| Write | bytes | OutputStream | write(Path, | byte[]) | Simple | and | concise |
| Write | lines | BufferedWriter | loop | write(Path, | Iterable, | ...) | Charset can be specified |
| Append | text | FileWriter(true) | write(..., | APPEND) | Options | make | intent explicit |

### 9.3.7 newInputStream/newOutputStream and newBufferedReader/newBufferedWriter

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

### 9.3.8 Listing Directories and Traversing Trees

Legacy directory listing is based on File.list() and File.listFiles().
These methods return arrays and provide limited error reporting.

### Legacy listing

```java
File dir = new File(".");
File[] children = dir.listFiles();
```

NIO.2 provides multiple approaches depending on needs.

### Modern listing (DirectoryStream)

```java
try (DirectoryStream<Path> ds = Files.newDirectoryStream(Path.of("."))) {
for (Path p : ds) {
System.out.println(p);
}
}
```

### Modern walking (Files.walk)

```java
Files.walk(Path.of("."))
.filter(Files::isRegularFile)
.forEach(System.out::println);
```

> [!NOTE]
> Files.walk returns a Stream that must be closed.
> Prefer try-with-resources when using it.

```java
try (Stream<Path> s = Files.walk(Path.of("."))) {
s.forEach(System.out::println);
}
```

### Modern traversal with FileVisitor

For full control (skip subtrees, handle errors, follow links), use walkFileTree + FileVisitor.

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
| List | directory | list/listFiles | newDirectoryStream | Lazy, must be closed |
| Walk | tree | (simple) | Manual | recursion walk() Stream must be closed |
| Walk | tree | (control) | Manual | recursion walkFileTree() Error handling + pruning |

### 9.3.9 Searching and Filtering

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

### 9.3.10 Attributes: Reading, Writing, and Views

Legacy File exposes only a few attributes (size, lastModified).
NIO.2 supports rich metadata via attribute views.

### Legacy attributes

```java
long size = new File("a.txt").length();
long lm = new File("a.txt").lastModified();
```

### Modern attributes

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
> Unsupported attributes cause exceptions.

### 9.3.11 Symbolic Links and Link Following

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
To prevent this, pass LinkOption.NOFOLLOW_LINKS when supported.

### 9.3.12 Summary: Why Files Is an Enhancement

The Files utility class improves filesystem programming by:
- reducing boilerplate (copy/move/read/write)
- providing explicit options (overwrite, atomic move, follow links)
- offering richer metadata (attributes/views)
- supporting scalable traversal and searching

Legacy APIs remain mostly for backward compatibility or when required by old libraries.