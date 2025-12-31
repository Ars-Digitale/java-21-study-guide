# Java I/O APIs (Legacy and NIO)

## 1. Legacy java.io — Design, Behavior, and Subtleties

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

### 1.7 mark() and reset(): Controlled Backtracking

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


### 2.10 When to Use java.nio

`NIO` is appropriate when:
- High concurrency is required
- You need fine-grained memory control
- You are implementing protocols or servers

For simple file operations, `java.nio.file.Files` is usually sufficient.