# Files and Paths APIs

This first section focuses on how to create filesystem locators using the legacy `java.io.File` API and the modern `java.nio.file.Path` API: how to convert between them and understanding overloads, defaults, and common pitfalls.

## Legacy `File` and NIO `Path`: Creation and Conversion

### 1. Creating a `File` (Legacy)

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

> [!NOTE]
> - `new File(...)` never opens the file. 
> - Existence/permissions are checked only when you call methods like `exists()`, `length()`, or when you open a stream/channel.

### 2. Creating a `Path` (NIO v.2)

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

> [!NOTE]
> - `Path.of(...)` and `Paths.get(...)` are equivalent for the default filesystem. 
> - Prefer `Path.of` in modern code.

### 3. Absolute vs Relative: What “Relative” Means

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

> [!NOTE]
> Relative paths are a common source of “works on my machine” bugs because `user.dir` depends on how/where the JVM was launched.

### 4. Joining / Building Paths

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

#### 4.1 `resolve()`

Combines paths in a filesystem-aware way.

- Relative paths are appended
- Absolute argument replaces base path

> [!NOTE]
> `Path.resolve(...)` has a rule: if the argument is absolute, it returns the argument and discards the base (you cannot combine two absolute path using `resolve`)

#### 4.2 `relativize()`

`Path.relativize` computes a **relative path** from one path to another. The resulting path, when `resolve`d against the source path, yields the target path.

In other words:

- It answers the question: “How do I go from path A to path B?”
- The result is always a **relative** path
- No filesystem access occurs

Fundamental Rules (EXAM-CRITICAL)

`relativize` has strict preconditions. Violating them throws an exception.

| Rule | Explanation |
|------|-------------|
| Both paths must be absolute | or both relative |
| Both paths must belong to the same filesystem | same provider |
| Root components must match | same root (on Windows, same drive) |
| Result is never absolute | always relative |

> [!NOTE]
> If one path is absolute and the other relative, `IllegalArgumentException` is thrown.

Simple Relative Example:

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

Absolute Paths Example:

Absolute paths work exactly the same way.

```java
Path base = Path.of("/home/user/projects");
Path target = Path.of("/home/user/docs/readme.txt");

Path relative = base.relativize(target);
System.out.println(relative);
```

```bash
../../docs/readme.txt
```

> [!NOTE]
> The common prefix (here `/home/user`) is removed before computing the `..` segments.

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

> [!NOTE]
> This identity is frequently tested in certification questions.

Example: Mixing Absolute and Relative Paths (ERROR CASE)

This is one of the most common mistakes.

```java
Path abs = Path.of("/a/b");
Path rel = Path.of("c/d");

abs.relativize(rel); // throws exception
```

```bash
Exception in thread "main" java.lang.IllegalArgumentException
```

> [!NOTE]
> `relativize` does NOT attempt to convert paths to absolute automatically.

Example: Different Roots (Windows-Specific Trap)

On Windows, paths with different drive letters cannot be relativized.

```java
Path p1 = Path.of("C:\data\a");
Path p2 = Path.of("D:\data\b");

p1.relativize(p2); // IllegalArgumentException
```

> [!NOTE]
> On Unix-like systems, the root is always `/`, so this issue does not occur.

### 5. Converting Between `File` and `Path`

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

> [!NOTE]
> Conversion does not validate existence. It only converts representations.

### 6. URI Conversion (When Needed)

URIs are useful when paths must be represented in a standard, absolute form (e.g., interoperating with networked resources or configuration). Both APIs support URI conversion.

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

> [!NOTE]
> `new File(URI)` requires a `file:` URI and throws `IllegalArgumentException` if the URI is not hierarchical or not a file URI.

### 7. Canonical vs Absolute vs Normalized (Core Differences)

These terms are often mixed up in exams. They are not the same.

| Concept | Legacy (File) | NIO (Path) | Touches filesystem |
|--------|----------------|------------|--------------------|
| Absolute | `getAbsoluteFile()` | `toAbsolutePath()` | No |
| Normalized | Canonical effect | `normalize()` | No |
| Canonical / Real | `getCanonicalFile()` | `toRealPath()` | Yes |


> [!NOTE]
> `File.getCanonicalFile()` and `Path.toRealPath()` may resolve symlinks and require the path to exist, so they can throw `IOException`.

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

#### 7.1 `normalize()`

Removes **redundant** name elements like `.` and `..`.

- Purely syntactic
- Does not check if path exists

> [!NOTE]
> normalize() can produce invalid paths if misused.


### 8. Quick Comparison Table (Creation + Conversion)

| Need | Legacy (File) | NIO (Path) | Preferred today |
|------|----------------|------------|-----------------|
| Create from string | `new File("x")` | `Path.of("x")` | Path |
| Parent + child | `new File(p, c)` | `Path.of(p, c)` or `resolve()` | Path |
| Convert between APIs | `toPath()` | `toFile()` | Path-centric |
| Normalize | Canonical | `normalize()` | Path |
| Resolve symlinks | Canonical | `toRealPath()` | Path |

