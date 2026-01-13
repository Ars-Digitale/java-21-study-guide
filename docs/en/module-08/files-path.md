# 32. Files and Paths Fundamentals

### Table of Contents

- [32. Files and Paths Fundamentals](#32-files-and-paths-fundamentals)
  - [32.1 Conceptual Model Filesystem Files Directories Links-and-IO-Targets](#321-conceptual-model-filesystem-files-directories-links-and-io-targets)
  - [32.2 Filesystem – The Global Abstraction](#322-filesystem--the-global-abstraction)
  - [32.3 Path – Locating an Entry in a Filesystem](#323-path--locating-an-entry-in-a-filesystem)
  - [32.4 Files – Persistent Data Containers](#324-files--persistent-data-containers)
  - [32.5 Directories – Structural Containers](#325-directories--structural-containers)
  - [32.6 Links – Indirection Mechanisms](#326-links--indirection-mechanisms)
    - [32.6.1 Hard Links](#3261-hard-links)
    - [32.6.2 Symbolic Soft Links](#3262-symbolic-soft-links)
  - [32.7 Other Filesystem Entry Types](#327-other-filesystem-entry-types)
  - [32.8 How Java IO Interacts with These Concepts](#328-how-java-io-interacts-with-these-concepts)
  - [32.9 Core Conceptual Pitfalls](#329-core-conceptual-pitfalls)
  - [32.10 Why Path and Files Exist IO-Context](#3210-why-path-and-files-exist-io-context)
  - [32.11 Is javaioFile legacy-apis both-a-path-and-a-file-operations-api](#3211-is-javaiofile-legacy-apis-both-a-path-and-a-file-operations-api)
    - [32.11.1 What File Really Is](#32111-what-file-really-is)
    - [32.11.2 Path-like Responsibilities](#32112-path-like-responsibilities)
    - [32.11.3 Filesystem Operation Responsibilities](#32113-filesystem-operation-responsibilities)
    - [32.11.4 What File Is NOT](#32114-what-file-is-not)
    - [32.11.5 Why This Was a Problem](#32115-why-this-was-a-problem)
    - [32.11.6 How NIO Fixed This](#32116-how-nio-fixed-this)
    - [32.11.7 Summary](#32117-summary)
  - [32.12 Path Is a Description Not a Resource](#3212-path-is-a-description-not-a-resource)
  - [32.13 Absolute vs Relative Paths](#3213-absolute-vs-relative-paths)
    - [32.13.1 Absolute Paths](#32131-absolute-paths)
    - [32.13.2 Relative Paths](#32132-relative-paths)
  - [32.14 Filesystem Awareness and Separators](#3214-filesystem-awareness-and-separators)
    - [32.14.1 FileSystem](#32141-filesystem)
    - [32.14.2 Path Separators](#32142-path-separators)
  - [32.15 What Files Actually Do and What They Don’t](#3215-what-files-actually-do-and-what-they-dont)
    - [32.15.1 Files DO](#32151-files-do)
    - [32.15.2 Files DO NOT](#32152-files-do-not)
  - [32.16 Error Handling Philosophy Old-vs-NIO](#3216-error-handling-philosophy-old-vs-nio)
  - [32.17 Common Misconceptions](#3217-common-misconceptions)


---

This section focuses on `Path`, `File`, `Files`, and related classes, explaining why they exist, what problems they solve, and which are the differences between 
legacy java.io APIs and NIO v.2 (new I/O APIs), with special attention to filesystem semantics, path resolution, and common misconceptions.

## 32.1 Conceptual Model: Filesystem, Files, Directories, Links, and I/O Targets

Before understanding Java I/O APIs, it is essential to understand what they interact with. 

**Java I/O** does not operate in a vacuum: it interacts with filesystem abstractions provided by the operating system. 

This section defines those concepts independently of Java, then explains how Java I/O maps onto them and what problems are being solved.

## 32.2 Filesystem – The Global Abstraction

A `filesystem` is a structured mechanism provided by an operating system to organize, store, retrieve, and manage data on persistent storage devices.

At a conceptual level, a filesystem solves several fundamental problems:

- Persistent storage beyond program execution
- Hierarchical organization of data
- Naming and locating data
- Access control and permissions
- Concurrency and consistency guarantees

In Java NIO, a filesystem is represented by the `FileSystem` abstraction, typically obtained via `FileSystems.getDefault()` for the OS filesystem.


| Aspect | Meaning |
| --- | --- |
| Persistence | Data survives JVM termination |
| Scope | OS-managed, not JVM-managed |
| Multiplicity | Multiple filesystems may exist |
| Examples | Disk FS, ZIP FS, in-memory FS |

> [!NOTE]
> Java does not implement filesystems; it adapts to filesystem implementations provided by the OS or custom providers.

## 32.3 Path – Locating an Entry in a Filesystem

A `path` is a logical locator, not a resource. 

It describes where something would be in a filesystem, not what it is or whether it exists.

A `path` solves the problem of `addressing`.

- Identifies a location
- Is interpreted within a specific filesystem
- May or may not correspond to an existing entry

| Property | Path |
| --- | --- |
| Existence-aware | No |
| Type-aware | No |
| Immutable | Yes |
| OS resource | No |

> [!NOTE]
> In Java, `Path` represents potential filesystem entries, not actual ones.

## 32.4 Files – Persistent Data Containers

A `file` is a filesystem entry whose primary role is to store data. 

The filesystem treats files as opaque byte sequences.

Problems solved by files:

- Durable storage of information
- Sequential and random access to data
- Sharing data between processes

From the filesystem perspective, a file has:

- Content (bytes)
- Metadata (size, timestamps, permissions)
- A location (path)

| Aspect | Description |
| --- | --- |
| Content | Byte-oriented |
| Interpretation | Application-defined |
| Lifetime | Independent of processes |
| Java access | Streams, channels, Files methods |

> [!NOTE]
> Text vs binary is not a filesystem concept; it is an application-level interpretation.

## 32.5 Directories – Structural Containers

A `directory (or folder)` is a filesystem entry whose purpose is to organize other entries.

Directories solve the problem of scalability and organization.

- Group related entries
- Enable hierarchical naming
- Support efficient lookup

| Aspect | Directory |
| --- | --- |
| Stores data | No (stores references) |
| Contains | Files, directories, links |
| Read/write | Structural, not content-based |
| Java access | Files.list, Files.walk |

> [!NOTE]
> A directory is not a file with content, even if both share common metadata.

## 32.6 Links – Indirection Mechanisms

A `link` is a filesystem entry that refers to another entry. 

Links solve the problem of indirection and reuse.

### 32.6.1 Hard Links

A `hard link` is an additional name for the same underlying data.

- Multiple paths point to the same file data
- Deletion occurs only when all links are removed

### 32.6.2 Symbolic (Soft) Links

A `symbolic link` is a special file containing a path to another entry.

- May point to non-existing targets
- Resolved at access time

| Link Type | Refers To | Can Dangle | Java Handling |
| --- | --- | --- | --- |
| Hard | Data | No | Transparent |
| Symbolic | Path | Yes | Explicit control |

> [!NOTE]
> Java NIO exposes link behavior explicitly via `LinkOption`.
>
> In many common filesystems, Java code cannot create hard links in a fully portable way, while symbolic links are directly supported via `Files.createSymbolicLink(...)` (where permitted by the OS / permissions).


## 32.7 Other Filesystem Entry Types

Some filesystem entries are not data containers but interaction endpoints.

| Type | Purpose |
| --- | --- |
| Device file | Interface to hardware |
| FIFO / Pipe | Inter-process communication |
| Socket file | Network communication |

> [!NOTE]
> Java I/O may interact with these entries, but behavior is platform-dependent.

## 32.8 How Java I/O Interacts with These Concepts

Java I/O APIs operate at different abstraction layers:

- Path / File (legacy API) → describes a filesystem entry
- File (legacy API) / Files → queries or modifies filesystem state
- Streams / Channels → move bytes or characters


| Java API | Role |
| --- | --- |
| `Path` | Addressing |
| `File` (legacy APIs) | Addressing / filesystem operations |
| `Files` | Filesystem operations |
| `InputStream` / `Reader` | Reading data |
| `OutputStream` / `Writer` | Writing data |
| `Channel` / `SeekableByteChannel` | Advanced / random access |


> [!NOTE]
> No Java API “is” a file; APIs mediate access to filesystem-managed resources.

## 32.9 Core Conceptual Pitfalls

- Confusing paths with files
- Assuming paths imply existence
- Assuming directories store file data
- Assuming links are always resolved automatically

> [!NOTE]
> Always separate location, structure, and data flow when reasoning about I/O.


## 32.10 Why Path and Files Exist (I/O Context)

Classic `java.io` mixed three different concerns into poorly separated APIs:

- Path representation (where is the resource?)
- Filesystem interaction (does it exist? what type?)
- Data access (reading/writing bytes or characters)

The NIO.2 design (Java 7+) deliberately separates these concerns:

- `Path` → describes a location
- `Files` → performs filesystem operations
- `Streams / Channels` → move data

> [!NOTE] 
> A `Path` never opens a file and never touches the disk by itself.

## 32.11 Is `java.io.File` (legacy APIs) both a `path` and a `file-operations` API?

Yes — in the old I/O API, `java.io.File` confusingly plays two roles at the same time, and this design is exactly one of the reasons `java.nio.file` was introduced.

**Short Answer**

- `File` represents a filesystem path
- `File` also exposes filesystem operations
- It does **not** represent an open file, nor file contents

> [!NOTE]
> This mixing of responsibilities is considered a design flaw in hindsight.

### 32.11.1 What `File` Really Is

Conceptually, `File` is closer to what we now call a `Path`, but with added operational methods.

| Aspect | java.io.File |
|-------|---------------|
| Represents a location | Yes |
| Opens a file | No |
| Reads / writes data | No |
| Queries filesystem | Yes |
| Modifies filesystem | Yes |
| Holds OS handle | No |

> [!NOTE]
> A `File` object can exist even if the file does not.

### 32.11.2 Path-like Responsibilities

`File` behaves like a path abstraction because it:

- Encapsulates a filesystem pathname (absolute or relative)
- Can be resolved against the working directory
- Can be converted to absolute or canonical form

Examples:

```java
File f = new File("data.txt"); // relative path
File abs = f.getAbsoluteFile(); // absolute path
File canon = f.getCanonicalFile(); // normalized + resolved
```

### 32.11.3 Filesystem Operation Responsibilities

At the same time, `File` exposes methods that touch the filesystem:

- exists()
- isFile(), isDirectory()
- length()
- delete()
- mkdir(), mkdirs()
- list(), listFiles()

> [!NOTE]
> Most of these methods return `boolean` instead of throwing `IOException`, which hides failure causes.

### 32.11.4 What `File` Is NOT

- Not an open file descriptor
- Not a stream
- Not a channel
- Not a container of file data

You must still use streams or readers/writers to access contents.

### 32.11.5 Why This Was a Problem

The dual role of `File` caused several issues:

- Mixed concerns (path + operations)
- Poor error handling (boolean instead of exceptions)
- Weak support for links and multiple filesystems
- Platform-dependent behavior

### 32.11.6 How NIO Fixed This

NIO.2 explicitly separates responsibilities:

| Responsibility | Old API | NIO API |
|----------------|---------|---------|
| `Path representation` | `File` | `Path` |
| `Filesystem operations` | `File` | `Files` |
| `Data access` | Streams | Streams / Channels |

> [!NOTE]
> This separation is one of the most important conceptual improvements in Java I/O.

### 32.11.7 Summary

- `File` represents a path AND performs filesystem operations
- It never reads or writes file contents
- It never opens a file
- `Path` + `Files` is the modern replacement

## 32.12 Path Is a Description, Not a Resource

A `Path` is a pure abstraction representing a sequence of name elements in a filesystem.

- It does NOT imply existence
- It does NOT imply accessibility
- It does NOT hold a file descriptor

This is fundamentally different from streams or channels.


|	Concept	|	Path	|	Stream / Channel	|
|-----------|-----------|-----------------------|
|	`Opens resource`	|	No	|	Yes	|
|	`Touches disk`	|	No	|	Yes	|
|	`Holds OS handle`	|	No	|	Yes	|
|	`Immutable`	|	Yes	|	No	|
	

> [!NOTE]  
> Creating a Path cannot throw `IOException` because no I/O happens.

## 32.13 Absolute vs Relative Paths

Understanding path resolution is essential.

### 32.13.1 Absolute Paths

An absolute path fully identifies a location from the filesystem root.

- Platform-dependent root
- Independent of JVM working directory


|	Platform	|	Example Absolute Path	|
|---------------|---------------------------|
|	Unix	|	`/home/user/file.txt`	|
|	Windows	|	`C:\Users\User\file.txt`	|


> [!IMPORTANT]  
> - A path starting with a forward slash `(/)` (Unix-like) or with a drive letter such as `C:` (Windows) is **typically** considered an absolute path.  
> - The symbol `.` is a reference to the current directory while `..` is a reference to its parent directory.
> On Windows, a path like `\dir\file.txt` (without drive letter) is *rooted* on the current drive, not fully qualified with drive + path.


Example:

```bash
/dirA/dirB/../dirC/./content.txt

is equivalent to:

/dirA/dirC/content.txt

// in this example the symbols were redundant and unnecessary
```
	
### 32.13.2 Relative Paths

A relative path is resolved against the JVM current working directory.

- Depends on where JVM was launched
- Common source of bugs

> [!NOTE]
>  The working directory is typically available via `System.getProperty("user.dir")`.

Example:

```bash
dirB/dirC/content.txt
```


## 32.14 Filesystem Awareness and Separators

NIO introduces filesystem abstraction, which was mostly absent in java.io.

### 32.14.1 FileSystem

A `FileSystem` represents a concrete filesystem implementation.

- Default filesystem corresponds to OS filesystem
- Other filesystems possible (ZIP, memory, network)

> [!NOTE] 
> Paths are always associated with exactly ONE FileSystem.

### 32.14.2 Path Separators

Separators differ across platforms, but `Path` abstracts them.

|	Aspect	|	java.io.File	|	java.nio.file.Path	|
|-----------|-------------------|-----------------------|
|	Separator	|	String-based	|	Filesystem-aware	|
|	Portability	|	Manual handling	|	Automatic	|
|	Comparison	|	Error-prone	|	Safer	|
	
> [!NOTE] 
> Hardcoding `"/"` or `"\\"` is discouraged; `Path` handles this automatically.


## 32.15 What Files Actually Do (and What They Don’t)

The `Files` class performs real I/O operations.

### 32.15.1 Files DO

- Open files indirectly (via streams / channels returned by its methods)
- Create and delete filesystem entries
- Throw checked exceptions on failure
- Respect filesystem permissions

### 32.15.2 Files DO NOT

- Maintain open resources after method returns (except streams)
- Store file contents internally
- Guarantee atomicity unless specified
- Maintain a persistent handle to open files (streams/channels own the handle instead)


> [!NOTE]
> Methods returning streams (e.g. `Files.lines()`) DO keep the file open until the stream is closed.

## 32.16 Error Handling Philosophy: Old vs NIO

A major conceptual difference lies in error reporting.


| Aspect           | `java.io.File`          | `java.nio.file.Files`     |
|------------------|-------------------------|---------------------------|
| Error signaling  | boolean / `null`        | `IOException`             |
| Diagnostics      | Poor                    | Rich                      |
| Race awareness   | Weak                    | Improved                  |
| Preference       | Discouraged             | Preferred                 |

		

## 32.17 Common Misconceptions

- “Path represents a file” → false
- “normalize checks existence” → false
- “Files.readAllLines streams data” → false
- “Relative paths are portable” → false
- “Creating a Path may fail due to permissions” → false

> [!NOTE]
> Many NIO methods that sound “safe” are purely syntactic (like `normalize` or `resolve`): they do **not** touch the filesystem and cannot detect missing files.


