# 33. Files and Paths APIs

<a id="table-of-contents"></a>
### Table of Contents


- [33.1 Legacy File and NIO Path Creation-and-Conversion](#331-legacy-file-and-nio-path-creation-and-conversion)
	- [33.1.1 Creating a File Legacy](#3311-creating-a-file-legacy)
	- [33.1.2 Creating a Path NIO-v2](#3312-creating-a-path-nio-v2)
	- [33.1.3 Absolute vs Relative What Relative Means](#3313-absolute-vs-relative-what-relative-means)
	- [33.1.4 Joining--Building-Paths](#3314-joining--building-paths)
		- [33.1.4.1 resolve](#33141-resolve)
		- [33.1.4.2 relativize](#33142-relativize)
	- [33.1.5 Converting Between File and Path](#3315-converting-between-file-and-path)
	- [33.1.6 URI Conversion When-Needed](#3316-uri-conversion-when-needed)
	- [33.1.7 Canonical vs Absolute vs Normalized Core-Differences](#3317-canonical-vs-absolute-vs-normalized-core-differences)
		- [33.1.7.1 normalize](#33171-normalize)
	- [33.1.8 Quick Comparison Table Creation--Conversion](#3318-quick-comparison-table-creation--conversion)
- [33.2 Managing Files and Directories Create-Copy-Move-Replace-Compare-Delete](#332-managing-files-and-directories-create-copy-move-replace-compare-delete-legacy-vs-nio)
	- [33.2.1 Mental Model Path-Locator-vs-Operations](#3321-mental-model-pathlocator-vs-operations)
	- [33.2.2 Creating Files and Directories](#3322-creating-files-and-directories)
		- [33.2.2.1 Create a File](#33221-create-a-file)
		- [33.2.2.2 Create Directories](#33222-create-directories)
	- [33.2.3 Copying Files and Directories](#3323-copying-files-and-directories)
		- [33.2.3.1 Copy a File NIO](#33231-copy-a-file-nio)
		- [33.2.3.2 Manual Copy Legacy-Stream-Based](#33232-manual-copy-legacy-stream-based)
	- [33.2.4 Moving--Renaming-and-Replacing](#3324-moving--renaming-and-replacing)
		- [33.2.4.1 Legacy Rename Common-Pitfall](#33241-legacy-rename-common-pitfall)
		- [33.2.4.2 NIO Move Preferred](#33242-nio-move-preferred)
	- [33.2.5 Comparing Paths and Files](#3325-comparing-paths-and-files)
		- [33.2.5.1 Equality-vs-Same-File](#33251-equality-vs-same-file)
	- [33.2.6 Deleting Files and Directories](#3326-deleting-files-and-directories)
		- [33.2.6.1 Legacy Delete](#33261-legacy-delete)
		- [33.2.6.2 NIO Delete and Delete-If-Exists](#33262-nio-delete-and-delete-if-exists)
	- [33.2.7 Recursively Copying--Deleting-Directory-Trees NIO-Pattern](#3327-recursively-copying--deleting-directory-trees-nio-pattern)
	- [33.2.8 Summary Checklist](#3328-summary-checklist)


---

This section focuses on how to create filesystem locators using the legacy `java.io.File` API and the modern `java.nio.file.Path` API: how to convert between them and understanding overloads, defaults, and common pitfalls.

<a id="331-legacy-file-and-nio-path-creation-and-conversion"></a>
## 33.1 Legacy `File` and NIO `Path`: Creation and Conversion

<a id="3311-creating-a-file-legacy"></a>
### 33.1.1 Creating a `File` (Legacy)

A `File` instance represents a filesystem pathname (absolute or relative). 

Creating one does **not** access the filesystem and does not throw `IOException`.

Core constructors (most common):

- `new File(String pathname)` 
- `new File(String parent, String child)` 
- `new File(File parent, String child)` 
- `new File(URI uri)` (typically `file:...`)

```java
import java.io.File;
import java.net.URI;

File f1 = new File("data.txt"); // relative
File f2 = new File("/tmp", "data.txt"); // parent + child
File f3 = new File(new File("/tmp"), "data.txt");

File f4 = new File(URI.create("file:///tmp/data.txt"));
```

!!! note
    - `new File(...)` never opens the file.
    - Existence/permissions are checked only when you call methods like `exists()`, `length()`, or when you open a stream/channel.

<a id="3312-creating-a-path-nio-v2"></a>
### 33.1.2 Creating a `Path` (NIO v.2)

A `Path` is also just a locator. 

Like `File`, creating a `Path` does not access the filesystem.

Core factories:

- `Path.of(String first, String... more)` (Java 11+)
- `Paths.get(String first, String... more)` (older style; still valid)
- `Path.of(URI uri)` (e.g., `file:///...`)

```java
import java.net.URI;
import java.nio.file.Path;
import java.nio.file.Paths;

Path p1 = Path.of("data.txt"); // relative
Path p2 = Path.of("/tmp", "data.txt"); // parent + child

Path p3 = Paths.get("data.txt"); // legacy factory style
Path p4 = Path.of(URI.create("file:///tmp/data.txt"));
```

!!! note
    - `Path.of(...)` and `Paths.get(...)` are equivalent for the default filesystem.
    - Prefer `Path.of` in modern code.

<a id="3313-absolute-vs-relative-what-relative-means"></a>
### 33.1.3 Absolute vs Relative: What “Relative” Means

Both `File` and `Path` can be created as relative paths. 

Relative paths are resolved against the process working directory (typically `System.getProperty("user.dir")`).

```java
import java.io.File;
import java.nio.file.Path;

File rf = new File("data.txt");
Path rp = Path.of("data.txt");

System.out.println(rf.isAbsolute()); // false
System.out.println(rp.isAbsolute()); // false

System.out.println(rf.getAbsolutePath());
System.out.println(rp.toAbsolutePath());
```

!!! note
    Relative paths are a common source of “works on my machine” bugs because `user.dir` depends on how/where the JVM was launched.

<a id="3314-joining--building-paths"></a>
### 33.1.4 Joining / Building Paths

- Legacy `File` uses constructors (parent + child). 
- NIO uses `resolve` and related methods.

| Task | Legacy (File) | NIO (Path) |
|------|---------------|------------|
| Join parent + child | `new File(parent, child)` | `parent.resolve(child)` |
| Join many segments | Repeated constructors | `Path.of(a, b, c)` or chained `resolve()` |


```java
import java.io.File;
import java.nio.file.Path;

File f = new File("/tmp", "a.txt");

Path base = Path.of("/tmp");
Path p = base.resolve("a.txt"); // /tmp/a.txt
Path p2 = base.resolve("dir").resolve("a.txt"); // /tmp/dir/a.txt
```

<a id="33141-resolve"></a>
#### 33.1.4.1 `resolve()`

Combines paths in a filesystem-aware way.

- Relative paths are appended
- Absolute argument replaces base path

!!! note
    `Path.resolve(...)` has a rule: if the argument is absolute, it returns the argument and discards the base (you cannot combine two absolute paths using `resolve`).

<a id="33142-relativize"></a>
#### 33.1.4.2 `relativize()`

`Path.relativize` computes a **relative path** from one path to another. The resulting path, when `resolved` against the source path, yields the target path.

In other words:

- It answers the question: “How do I go from path A to path B?”
- The result is always a **relative** path
- No filesystem access occurs

**Fundamental Rules**

`relativize` has strict preconditions. Violating them throws an exception.

| Rule | Explanation |
|------|-------------|
| Both paths must be absolute | or both relative |
| Both paths must belong to the same filesystem | same provider |
| Root components must match | same root (on Windows, same drive) |
| Result is never absolute | always relative |

!!! note
    If one path is absolute and the other relative, `IllegalArgumentException` is thrown.

**Simple Relative Example**:

Both paths are relative, so relativization is allowed.

```java
Path p1 = Path.of("docs/manual");
Path p2 = Path.of("docs/images/logo.png");

Path relative = p1.relativize(p2);
System.out.println(relative);
```

```bash
../images/logo.png
```

Interpretation: from `docs/manual`, go up one level, then into `images/logo.png`.

**Absolute Paths Example**:

Absolute paths work exactly the same way.

```java
Path base = Path.of("/home/user/projects");
Path target = Path.of("/home/user/docs/readme.txt");

Path relative = base.relativize(target);
System.out.println(relative);
```

```bash
../docs/readme.txt
```

**Using `resolve` to Verify the Result**

A key property of `relativize` is this identity:

```text
base.resolve(base.relativize(target)).equals(target)
```

```java
Path base = Path.of("/a/b/c");
Path target = Path.of("/a/d/e");

Path r = base.relativize(target);
System.out.println(r); // ../../d/e
System.out.println(base.resolve(r)); // /a/d/e
```



**Example**: Mixing Absolute and Relative Paths (ERROR CASE)

This is one of the most common mistakes.

```java
Path abs = Path.of("/a/b");
Path rel = Path.of("c/d");

abs.relativize(rel); // throws exception
```

```bash
Exception in thread "main" java.lang.IllegalArgumentException
```

!!! note
    `relativize` does NOT attempt to convert paths to absolute automatically.

**Example**: Different Roots (Windows-Specific Trap)

On Windows, paths with different drive letters cannot be relativized.

```java
Path p1 = Path.of("C:\\data\\a");
Path p2 = Path.of("D:\\data\\b");

p1.relativize(p2); // IllegalArgumentException
```

!!! note
    On Unix-like systems, the root is always `/`, so this issue does not occur.

<a id="3315-converting-between-file-and-path"></a>
### 33.1.5 Converting Between `File` and `Path`

Conversion is straightforward and lossless for normal local filesystem paths.

| Conversion | How |
|------------|-----|
| File → Path | `file.toPath()` |
| Path → File | `path.toFile()` |


```java
import java.io.File;
import java.nio.file.Path;

File f = new File("data.txt");
Path p = f.toPath();

File back = p.toFile();
```

!!! note
    Conversion does not validate existence. It only converts representations.

<a id="3316-uri-conversion-when-needed"></a>
### 33.1.6 URI Conversion (When Needed)

`URIs` are useful when paths must be represented in a standard, absolute form (e.g., interoperating with networked resources or configuration). 

Both APIs support URI conversion.

| Direction | Legacy (File) | NIO (Path) |
|-----------|----------------|------------|
| From URI | `new File(uri)` | `Path.of(uri)` |
| To URI | `file.toURI()` | `path.toUri()` |


```java
import java.io.File;
import java.net.URI;
import java.nio.file.Path;

File f = new File("/tmp/data.txt");
URI u1 = f.toURI();

Path p = Path.of("/tmp/data.txt");
URI u2 = p.toUri();

Path pFromUri = Path.of(u2);
File fFromUri = new File(u1);
```

!!! note
    `new File(URI)` requires a `file:` URI and throws `IllegalArgumentException` if the URI is not hierarchical or not a file URI.

<a id="3317-canonical-vs-absolute-vs-normalized-core-differences"></a>
### 33.1.7 Canonical vs Absolute vs Normalized (Core Differences)

These terms are often mixed up. They are not the same.

| Concept        | Legacy (File)                          | NIO (Path)        | Touches filesystem |
|----------------|----------------------------------------|-------------------|--------------------|
| Absolute       | `getAbsoluteFile()`                    | `toAbsolutePath()`| No                 |
| Normalized     | (no pure normalize, use canonical)\*   | `normalize()`     | `normalize()`: No  |
| Canonical / Real | `getCanonicalFile()`                 | `toRealPath()`    | Yes                |


!!! note
    `File.getCanonicalFile()` and `Path.toRealPath()` may resolve symlinks and require the path to exist, so they can throw `IOException`.
    
    File does not provide a method for purely syntactic normalization: historically many developers used getCanonicalFile(), but this accesses the filesystem and can fail.

```java
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;

File f = new File("a/../data.txt");
System.out.println(f.getAbsolutePath()); // absolute, may still contain ".."

try {
	System.out.println(f.getCanonicalPath()); // resolves "..", may touch filesystem
} catch (IOException e) {
	System.out.println("Canonical failed: " + e.getMessage());
}

Path p = Path.of("a/../data.txt");
System.out.println(p.toAbsolutePath()); // absolute, may still contain ".."
System.out.println(p.normalize()); // purely syntactic

try {
	System.out.println(p.toRealPath()); // resolves symlinks, requires existence
} catch (IOException e) {
	System.out.println("RealPath failed: " + e.getMessage());
}
```

<a id="33171-normalize"></a>
#### 33.1.7.1 `normalize()`

Removes **redundant** name elements like `.` and `..`.

- Purely syntactic
- Does not check if path exists

!!! note
    `normalize()` is purely syntactic, does not check existence, and can produce invalid paths if misused.


<a id="3318-quick-comparison-table-creation--conversion"></a>
### 33.1.8 Quick Comparison Table (Creation + Conversion)

| Need | Legacy (File) | NIO (Path) | Preferred today |
|------|----------------|------------|-----------------|
| Create from string | `new File("x")` | `Path.of("x")` | Path |
| Parent + child | `new File(p, c)` | `Path.of(p, c)` or `resolve()` | Path |
| Convert between APIs | `toPath()` | `toFile()` | Path-centric |
| Normalize | `getCanonicalFile()` (filesystem-based) | `normalize()` (syntactic only) | Path |
| Resolve symlinks | Canonical | `toRealPath()` | Path |

---

<a id="332-managing-files-and-directories-create-copy-move-replace-compare-delete-legacy-vs-nio"></a>
## 33.2 Managing Files and Directories: Create, Copy, Move, Replace, Compare, Delete (Legacy vs NIO)

This section covers the operations you perform on filesystem entries (files/directories): creating, copying, moving/renaming, replacing, comparing, and deleting. 

It contrasts legacy `java.io.File` (and related legacy helpers) with modern `java.nio.file` (NIO.2).

<a id="3321-mental-model-pathlocator-vs-operations"></a>
### 33.2.1 Mental Model: “Path/Locator” vs “Operations”

Both APIs use objects that represent a path, but operations differ:

- Legacy: `File` is both a path wrapper and an operations API (mixed responsibility)
- NIO: `Path` is the path; `Files` performs operations (separation of concerns)

| Responsibility | Legacy | NIO |
|----------------|--------|-----|
| Path representation | `File` | `Path` |
| Filesystem operations | `File` | `Files` |
| Rich error reporting | Weak (booleans) | Strong (exceptions) |

!!! note
    legacy methods often return `boolean` (silent failure), while NIO throws `IOException` with cause.

<a id="3322-creating-files-and-directories"></a>
### 33.2.2 Creating Files and Directories

Creating is where the old API is most awkward and the NIO API is most expressive.

| Task | Legacy approach | NIO approach | Notes |
|----------------|--------|-----|--------|
| Create empty file | open+close stream | `Files.createFile` | NIO fails if exists |
| Create one directory | `mkdir` | `Files.createDirectory` | Parent must exist |
| Create directories recursively | `mkdirs` | `Files.createDirectories` | Creates parents |

<a id="33221-create-a-file"></a>
#### 33.2.2.1 Create a File

Legacy has no “create empty file” method, so you typically create a file by opening an output stream (side effect).

```java
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

File f = new File("created-legacy.txt");
try (FileOutputStream out = new FileOutputStream(f)) {
	// file is created (or truncated) as a side effect
}
```

NIO provides an explicit creation method.

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;

Path p = Path.of("created-nio.txt");
Files.createFile(p);
```

!!! note
    `Files.createFile` throws `FileAlreadyExistsException` if the entry exists.

<a id="33222-create-directories"></a>
#### 33.2.2.2 Create Directories

```java
import java.io.File;

File dir1 = new File("a/b");
boolean ok1 = dir1.mkdir(); // fails if parent "a" does not exist
boolean ok2 = dir1.mkdirs(); // creates parents
```

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;

Path d = Path.of("a/b");
Files.createDirectory(d); // parent must exist
Files.createDirectories(d); // creates parents, ok if already exists
```

!!! note
    Legacy `mkdir()/mkdirs()` return `false` on failure without telling why. NIO throws `IOException`.

<a id="3323-copying-files-and-directories"></a>
### 33.2.3 Copying Files and Directories

Legacy copy is usually manual stream-copy (or external libs). NIO has a single, explicit operation.

|	Capability | Legacy | NIO |
|--------------|--------|-----|
|	Copy file contents | Manual streams | `Files.copy` |
|	Copy into existing target | Manual | `REPLACE_EXISTING` option |
|	Copy directory tree | Manual recursion | Manual recursion (but better tools: `Files.walk` + `Files.copy`) |

<a id="33231-copy-a-file-nio"></a>
#### 33.2.3.1 Copy a File (NIO)

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.io.IOException;

Path src = Path.of("src.txt");
Path dst = Path.of("dst.txt");

Files.copy(src, dst); // fails if dst exists
Files.copy(src, dst, StandardCopyOption.REPLACE_EXISTING);
```

!!! note
    `Files.copy` throws `FileAlreadyExistsException` if the target exists and you did not use `REPLACE_EXISTING`.

<a id="33232-manual-copy-legacy-stream-based"></a>
#### 33.2.3.2 Manual Copy (Legacy, Stream-Based)

```java
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

try (FileInputStream in = new FileInputStream("src.bin");
FileOutputStream out = new FileOutputStream("dst.bin")) {

	byte[] buf = new byte[8192];
	int n;
	while ((n = in.read(buf)) != -1) {
		out.write(buf, 0, n);
	}
}
```

!!! note
    Remember `read(byte[])` returns the number of bytes read; you must write only that count, not the full buffer.


<a id="3324-moving--renaming-and-replacing"></a>
### 33.2.4 Moving / Renaming and Replacing

In both APIs, rename/move is “metadata-level” when possible, but can behave like copy+delete across filesystems. NIO makes this explicit via options.

| Operation | Legacy | NIO |
|-----------|--------|-----|
| Rename/move | `File.renameTo` | `Files.move` |
| Replace existing | Unreliable | `REPLACE_EXISTING` |
| Atomic move | Not supported | `ATOMIC_MOVE` (if supported) |

<a id="33241-legacy-rename-common-pitfall"></a>
#### 33.2.4.1 Legacy Rename (Common Pitfall)

```java
import java.io.File;

File from = new File("old.txt");
File to = new File("new.txt");

boolean ok = from.renameTo(to); // may fail silently
System.out.println(ok);
```

!!! note
    - `renameTo` is notoriously platform-dependent and returns only `boolean`.
    - It may fail because target exists, file is open, permissions, or cross-filesystem move.

<a id="33242-nio-move-preferred"></a>
#### 33.2.4.2 NIO Move (Preferred)

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.io.IOException;

Path from = Path.of("old.txt");
Path to = Path.of("new.txt");

Files.move(from, to); // fails if target exists
Files.move(from, to, StandardCopyOption.REPLACE_EXISTING);
```

!!! note
    `Files.move` throws `FileAlreadyExistsException` when the target exists and `REPLACE_EXISTING` is not specified.

<a id="3325-comparing-paths-and-files"></a>
### 33.2.5 Comparing Paths and Files

Comparing locators can mean: string/path equality, normalized/canonical equality, or “same file on disk”. 

The APIs differ here significantly.

| Comparison goal | Legacy | NIO |
|-----------------|--------|-----|
| Same path text | `File.equals` | `Path.equals` |
| Normalize path | `getCanonicalFile` | `normalize` |
| Same file/resource on disk | weak (canonical heuristic) | `Files.isSameFile` |

<a id="33251-equality-vs-same-file"></a>
#### 33.2.5.1 Equality vs Same File

Two different path strings can refer to the same file.

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;

Path p1 = Path.of("a/../data.txt");
Path p2 = Path.of("data.txt");

System.out.println(p1.equals(p2)); // false (different path text)
System.out.println(p1.normalize().equals(p2.normalize())); // might still be false if relative

try {
	System.out.println(Files.isSameFile(p1, p2)); // may be true, may throw if not accessible
} catch (IOException e) {
	System.out.println("isSameFile failed: " + e.getMessage());
}
```

!!! note
    `Files.isSameFile` may access the filesystem and can throw `IOException` (permission issues, missing files, etc.).

<a id="3326-deleting-files-and-directories"></a>
### 33.2.6 Deleting Files and Directories

Deletion is simple in concept but has important edge cases: non-empty directories, missing targets, and error reporting differences.

| Task | Legacy | NIO | Behavior if missing |
|------|--------|-----|---------------------|
| Delete file/dir | `File.delete` | `Files.delete` | Legacy false, NIO exception |
| Delete if exists | No direct (check+delete) | `Files.deleteIfExists` | returns boolean |
| Delete non-empty dir | Manual recursion | Manual recursion (walk) | Both require recursion |

<a id="33261-legacy-delete"></a>
#### 33.2.6.1 Legacy Delete

```java
import java.io.File;

File f = new File("x.txt");
boolean ok = f.delete(); // false if not deleted
System.out.println(ok);
```

!!! note
    Legacy `delete()` fails (returns false) for a non-empty directory and often provides no reason.

<a id="33262-nio-delete-and-delete-if-exists"></a>
#### 33.2.6.2 NIO Delete and Delete-If-Exists

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.NoSuchFileException;
import java.nio.file.DirectoryNotEmptyException;
import java.io.IOException;

Path p = Path.of("x.txt");

try {
	Files.delete(p);
} catch (NoSuchFileException e) {
	System.out.println("Missing: " + e.getFile());
} catch (DirectoryNotEmptyException e) {
	System.out.println("Directory not empty: " + e.getFile());
} catch (IOException e) {
	System.out.println("Delete failed: " + e.getMessage());
}

boolean deleted = Files.deleteIfExists(p);
System.out.println(deleted);
```

!!! note
    Certification tip: `Files.delete` throws `NoSuchFileException` if missing, while `deleteIfExists` returns `false`.

<a id="3327-recursively-copying--deleting-directory-trees-nio-pattern"></a>
### 33.2.7 Recursively Copying / Deleting Directory Trees (NIO Pattern)

NIO doesn’t provide a single “copyTree/deleteTree” method, but the standard approach uses `Files.walk` or `Files.walkFileTree`. 

```java
import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;

Path root = Path.of("dirToDelete");

Files.walkFileTree(root, new SimpleFileVisitor<Path>() {
    @Override
    public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
        Files.delete(file);
        return FileVisitResult.CONTINUE;
    }

    @Override
    public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {
        if (exc != null) throw exc;
        Files.delete(dir);
        return FileVisitResult.CONTINUE;
    }
});
```

!!! note
    Deleting a directory tree requires deleting files first, then directories (post-order). This is a common reasoning question.

<a id="3328-summary-checklist"></a>
### 33.2.8 Summary Checklist

- Prefer `Files.createFile/createDirectory/createDirectories` over legacy workarounds
- `File.renameTo` is unreliable; prefer `Files.move` with options
- `Files.copy/move` throw `FileAlreadyExistsException` unless `REPLACE_EXISTING` is used
- `Files.delete` throws; `Files.deleteIfExists` returns boolean
- `Files.isSameFile` can throw `IOException` and may touch the filesystem
- Non-empty directory deletion requires recursion (both APIs)

