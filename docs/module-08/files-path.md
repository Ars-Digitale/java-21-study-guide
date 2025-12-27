# Files and Path in Java I/O – Conceptual Foundations and Critical Details

This section focuses on `Path`, `Files`, and related classes, explaining why they exist, what problems they solve, and how they differ fundamentally 
from legacy java.io APIs, with special attention to filesystem semantics, path resolution, and common misconceptions.

## 1. Why Path and Files Exist (I/O Context)

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

## 2. Path Is a Description, Not a Resource

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

## 3. Absolute vs Relative Paths

Understanding path resolution is essential and frequently tested.

@@H4@@3.1 Absolute Paths@@H4_END@@

An absolute path fully identifies a location from the filesystem root.

- Platform-dependent root
- Independent of JVM working directory


|	Platform	|	Example Absolute Path	|
|---------------|---------------------------|
|	Unix	|	`/home/user/file.txt`	|
|	Windows	|	`C:\Users\User\file.txt`	|
	

### 3.1 Relative Paths

A relative path is resolved against the JVM current working directory.

- Depends on where JVM was launched
- Common source of bugs

> [!NOTE]
>  The working directory is typically available via `System.getProperty("user.dir")`.

## 4. Filesystem Awareness and Separators

NIO introduces filesystem abstraction, which was mostly absent in java.io.

### 4.1 FileSystem

A `FileSystem` represents a concrete filesystem implementation.

- Default filesystem corresponds to OS filesystem
- Other filesystems possible (ZIP, memory, network)

> [!NOTE] 
> Paths are always associated with exactly ONE FileSystem.

### 4.2 Path Separators

Separators differ across platforms, but `Path` abstracts them.



|	Aspect	|	java.io.File	|	java.nio.file.Path	|
|-----------|-------------------|-----------------------|
|	Separator	|	String-based	|	Filesystem-aware	|
|	Portability	|	Manual handling	|	Automatic	|
|	Comparison	|	Error-prone	|	Safer	|
	
> [!NOTE] 
> Hardcoding "/" or "" is discouraged; Path handles this automatically.

### 4.3 Normalization, Resolution, Relativization

These operations manipulate path structure only, not the filesystem.

### 4.4 `normalize()`

Removes redundant name elements like `.` and `..`.

- Purely syntactic
- Does not check if path exists

> [!NOTE]
> normalize() can produce invalid paths if misused.

@@H4@@5.2 resolve()@@H4_END@@

Combines paths in a filesystem-aware way.

- Relative paths are appended
- Absolute argument replaces base path

> **Note:** [!NOTE] If the parameter is absolute, the original path is discarded.

### 4.5 `relativize()`

Computes a relative path between two paths.

- Both paths must be of same type (both absolute or both relative)
- Otherwise throws `IllegalArgumentException` 

> [!NOTE]
> This method does NOT access the filesystem.

## 5. What Files Actually Do (and What They Don’t)

The `Files` class performs real I/O operations.

### 5.1 Files DO

- Open files
- Create and delete filesystem entries
- Throw checked exceptions on failure
- Respect filesystem permissions

### 5.2 Files DO NOT

- Maintain open resources after method returns (except streams)
- Store file contents internally
- Guarantee atomicity unless specified

> [!NOTE]
> Methods returning streams (e.g. `Files.lines()`) DO keep the file open until the stream is closed.

## 6. Error Handling Philosophy: Old vs NIO

A major conceptual difference lies in error reporting.


|	Aspect	|	java.io.File	|	java.nio.file.Files	|
|-----------|-------------------|-----------------------|
|	Error signaling	|	boolean / null	|	IOException	|
|	Diagnostics	|	Poor	|	Rich	|
|	Race awareness	|	Weak	|	Improved	|
|	preference	|	Discouraged	|	Preferred	|
		

## 7. Common Misconceptions

- “Path represents a file” → false
- “normalize checks existence” → false
- “Files.readAllLines streams data” → false
- “Relative paths are portable” → false
- “Creating a Path may fail due to permissions” → false

