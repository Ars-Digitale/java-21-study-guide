# 38. Compiling, Packaging, and Running Modules

### Table of Contents

- [38 Compiling Packaging and Running Modules](#38-compiling-packaging-and-running-modules)
  - [38.1 The Module Path vs the Classpath](#381-the-module-path-vs-the-classpath)
  - [38.2 Compiling a Single Module](#382-compiling-a-single-module)
  - [38.3 Compiling Multiple Interdependent Modules](#383-compiling-multiple-interdependent-modules)
  - [38.4 Packaging a Module into a Modular JAR](#384-packaging-a-module-into-a-modular-jar)
  - [38.5 Running a Modular Application](#385-running-a-modular-application)
  - [38.6 Module Directives Explained](#386-module-directives-explained)
    - [38.6.1 requires](#3861-requires)
    - [38.6.2 requires transitive](#3862-requires-transitive)
    - [38.6.3 exports](#3863-exports)
    - [38.6.4 exports-to-qualified-exports](#3864-exports-to-qualified-exports)
    - [38.6.5 opens](#3865-opens)
    - [38.6.6 opens-to-qualified-opens](#3866-opens-to-qualified-opens)
    - [38.6.7 Summary of Core Directives](#3867-summary-of-core-directives)

---

Once a module is defined with a `module-info.java` file, it must be compiled, packaged, and executed using module-aware tools.

This section explains how the Java toolchain changes when modules are involved.

## 38.1 The Module Path vs the Classpath

`JPMS` introduces a new concept: the module path.
It exists alongside the traditional classpath, but the two behave very differently.

| Aspect | Classpath | Module path |
| --- | --- | --- |
| Structure | Flat list of JARs | Modules with identities |
| Encapsulation | None  | Strong |
| Dependency checking | None | Strict |
| Split packages | Allowed | Forbidden (named modules) |
| Resolution order | Order-dependent | Deterministic |

> [!NOTE]
> A JAR placed on the classpath is treated as part of the `unnamed module`.
> A JAR placed on the module path becomes a `named (or automatic) module`.

## 38.2 Compiling a Single Module

To compile a module, you must specify the module source path and the destination directory.

```bash
javac -d out
src/com.example.hello/module-info.java
src/com.example.hello/com/example/hello/Main.java
```

A more scalable approach uses --module-source-path.

```bash
javac -d out
--module-source-path src
$(find src -name "*.java")
```

> [!NOTE]
> `--module-source-path` tells javac where to find multiple modules at once.

## 38.3 Compiling Multiple Interdependent Modules

When modules depend on each other, their dependencies must be resolvable at compile time.

```bash
javac -d out
--module-source-path src
--module-path mods
$(find src -name "*.java")
```

Here:
- `--module-source-path` locates module source trees
- `--module-path` provides already-compiled modules

## 38.4 Packaging a Module into a Modular JAR

After compilation, modules are typically packaged as JAR files.

A modular JAR contains a `module-info.class` at its root.

```bash
jar --create
--file mods/com.example.hello.jar
--main-class com.example.hello.Main
-C out/com.example.hello .
```

> [!NOTE]
> A JAR with `module-info.class` is a `named module, not an automatic module`.

## 38.5 Running a Modular Application

To run a modular application, you use the `module path` and specify the `module name`.

```bash
java --module-path mods
--module com.example.hello/com.example.hello.Main
```

You can shorten this using the `-m` option.

```bash
java -p mods -m com.example.hello/com.example.hello.Main
```

## 38.6 Module Directives Explained

The module-info.java file contains directives that describe dependencies, visibility, and services.

Each directive has a precise meaning.

### 38.6.1 `requires`

The requires directive declares a dependency on another module.

Without it, types from the dependency module cannot be used.

```java
module com.example.app {
	requires com.example.lib;
}
```

Effects of requires:
- Dependency must be present at compile and runtime
- Exported packages of the required module become accessible

### 38.6.2 `requires transitive`

`requires transitive` exposes a dependency to downstream modules.

It propagates readability.

```java
module com.example.lib {
	requires transitive com.example.util;
	exports com.example.lib.api;
}
```

Meaning:
- **Any module requiring com.example.lib automatically reads com.example.util**
- **Callers do not need to declare requires com.example.util explicitly**

> [!NOTE]
> This is similar to “public dependencies” in other module systems.

### 38.6.3 `exports`

`exports` makes a package accessible to other modules.

Only exported packages are visible outside the module.

```java
module com.example.lib {
	exports com.example.lib.api;
}
```

Non-exported packages remain strongly encapsulated.

### 38.6.4 `exports ... to` (Qualified Exports)

A qualified export restricts access to specific modules.

```java
module com.example.lib {
	exports com.example.internal to com.example.friend;
}
```

Only the listed modules can access the exported package.

### 38.6.5 `opens`

`opens` allows deep reflective access to a package.

This is primarily for frameworks using reflection.

```java
module com.example.app {
	opens com.example.app.model;
}
```

> [!NOTE]
> opens does NOT make a package accessible at compile time.
> It only affects runtime reflection.

### 38.6.6 `opens ... to` (Qualified Opens)

You can restrict reflective access to specific modules.

```java
module com.example.app {
	opens com.example.app.model to com.fasterxml.jackson.databind;
}
```

### 38.6.7 Summary of Core Directives

| Directive | Purpose |
| --- | --- |
| `requires` | Declare a dependency |
| `requires transitive` | Propagate dependency |
| `exports` | Expose a package |
| `exports ... to` | Expose to specific modules |
| `opens` | Allow runtime reflection |
| `opens ... to` | Restrict reflective access |
