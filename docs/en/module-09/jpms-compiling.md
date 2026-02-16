# 38. Compiling, Packaging, and Running Modules

<a id="table-of-contents"></a>
### Table of Contents

- [38. Compiling, Packaging, and Running Modules](#38-compiling-packaging-and-running-modules)
  - [38.1 The Module Path vs the Classpath](#381-the-module-path-vs-the-classpath)
  - [38.2 Module-Related Command-Line Options](#382-module-related-command-line-options)
    - [38.2.1 Options Available in Both java and javac](#3821-options-available-in-both-java-and-javac)
    - [38.2.2 Options Applicable Only to javac](#3822-options-applicable-only-to-javac)
    - [38.2.3 Options Applicable Only to java](#3823--options-applicable-only-to-java)
    - [38.2.4 Important Distinctions](#3824-important-distinctions)
  - [38.3 Compiling a Single Module](#383-compiling-a-single-module)
  - [38.4 Compiling Multiple Interdependent Modules](#384-compiling-multiple-interdependent-modules)
  - [38.5 Packaging a Module into a Modular JAR](#385-packaging-a-module-into-a-modular-jar)
  - [38.6 Running a Modular Application](#386-running-a-modular-application)
  - [38.7 Module Directives Explained](#386-module-directives-explained)
    - [38.7.1 requires](#3871-requires)
    - [38.7.2 requires transitive](#3872-requires-transitive)
    - [38.7.3 exports](#3873-exports)
    - [38.7.4 exports-to-qualified-exports](#3874-exports--to-qualified-exports)
    - [38.7.5 opens](#3875-opens)
    - [38.7.6 opens-to-qualified-opens](#3876-opens--to-qualified-opens)
    - [38.7.7 Table of Core Directives](#3877-table-of-core-directives)
	- [38.7.8 Exports vs Opens — Compile-Time vs Runtime Access](#3878-exports-vs-opens--compile-time-vs-runtime-access)
    - [38.7.8 Exports vs Opens — Accès à la Compilation vs à lExécution](#3878-exports-vs-opens--accès-à-la-compilation-vs-à-lexécution)
  - [38.8 Named, Automatic, and Unnamed Modules](#388-named-automatic-and-unnamed-modules)
    - [38.8.1 Named Modules](#3881-named-modules)
    - [38.8.2 Automatic Modules](#3882-automatic-modules)
    - [38.8.3 Unnamed Module](#3883-unnamed-module)
    - [38.8.4 Comparison Summary](#3884-comparison-summary)
  - [38.9 Inspecting Modules and Dependencies](#389-inspecting-modules-and-dependencies)
    - [38.9.1 Describing Modules with java](#3891-describing-modules-with-java)
    - [38.9.2 Describing Modular JARs](#3892-describing-modular-jars)
    - [38.9.3 Analyzing Dependencies with jdeps](#3893-analyzing-dependencies-with-jdeps)
  - [38.10 Creating Custom Runtime Images with jlink](#3810-creating-custom-runtime-images-with-jlink)
  - [38.11 Creating Self-Contained Applications with jpackage](#3811-creating-self-contained-applications-with-jpackage)
  - [38.12 Final Summary JPMS in Practice](#3812-final-summary-jpms-in-practice)


---

Once a `module` is defined with a `module-info.java` file, it must be compiled, packaged, and executed using module-aware tools.

This section explains how the `Java toolchain` changes when modules are involved.

<a id="381-the-module-path-vs-the-classpath"></a>
## 38.1 The Module Path vs the Classpath

`JPMS` introduces a new concept: the **module path**.

It exists alongside the traditional **classpath**, but the two behave very differently.


| Aspect | Classpath | Module path |
| ---- | ---- | ---- |
| Structure | Flat list of JARs | Modules with identities |
| Encapsulation | None  | Strong |
| Dependency checking | None | Strict |
| Split packages | Allowed | Forbidden (named modules) |
| Resolution order | Order-dependent | Deterministic |

!!! note
    - A JAR placed on the `module path` becomes a `named (or automatic) module`.
    - A JAR placed on the `classpath` is treated as part of the `unnamed module`.
    - Split packages are allowed on the classpath but forbidden for named modules on the module path.

---

<a id="382-module-related-command-line-options"></a>
## 38.2 Module-Related Command-Line Options

When working with the Java Module System, both `java` and `javac` provide specific options for compiling and running modular applications. 

Some options are shared, while others are specific to one tool.


<a id="3821-options-available-in-both-java-and-javac"></a>
### 38.2.1 Options Available in Both `java` and `javac`

These options can be used during compilation as well as execution:

- **`--module`** or **`-m`**  
  Used to compile or run only the specified module.

- **`--module-path`** or **`-p`**  
  Specifies the paths where `java` or `javac` will look for module definitions.


<a id="3822-options-applicable-only-to-javac"></a>
### 38.2.2 Options Applicable Only to `javac`

These options apply only at compile time:

- **`--module-source-path`**  
  (no shortcut)  
  Used by `javac` to locate source module definitions.

- **`-d`**  
  Specifies the output directory where the `.class` files will be generated after compilation.



<a id="3823-options-applicable-only-to-java"></a>
### 38.2.3 Options Applicable Only to `java`

These options apply only at runtime:

- **`--list-modules`**  
  (no shortcut)  
  Lists all observable modules and then exits.

- **`--show-module-resolution`**  
  (no shortcut)  
  Displays module resolution details during application startup.

- **`--describe-module`** or **`-d`**  
  Describes a specified module and then exits.



<a id="3824-important-distinctions"></a>
### 38.2.4 Important Distinctions

The option `-d` has different meanings depending on the tool:

- In **`javac`**, `-d` defines the output directory for compiled class files.
- In **`java`**, `-d` is a shortcut for `--describe-module`.

Additionally, `-d` must not be confused with **`-D`** (uppercase D).

- **`-D`** is used when running a Java program to define system properties as name-value pairs on the command line.

```bash
java -Dconfig.file=app.properties com.example.Main
```

In this example, `-Dconfig.file=app.properties` sets a system property that can be accessed at runtime using `System.getProperty("config.file")`.

---

<a id="383-compiling-a-single-module"></a>
## 38.3 Compiling a Single Module

To compile a module, you must specify the module source path and the destination directory.

```bash
javac -d out \
src/com.example.hello/module-info.java \
src/com.example.hello/com/example/hello/Main.java
```

A more scalable approach uses `--module-source-path`.

```bash
javac --module-source-path src \
      -d out \
      $(find src -name "*.java")
```

!!! note
    `--module-source-path` tells javac where to find multiple modules at once.

---

<a id="384-compiling-multiple-interdependent-modules"></a>
## 38.4 Compiling Multiple Interdependent Modules

When modules depend on each other, their dependencies must be resolvable at compile time.

`--module-path` **mods** (sample dir containing interdependent moules) should contain already-compiled modular JARs or compiled module directories (each with its own module-info.class).


```bash
javac -d out \
--module-source-path src \
--module-path mods \
$(find src -name "*.java")
```

Here:
- `--module-source-path` locates module source trees
- `--module-path` provides already-compiled modules

---

<a id="385-packaging-a-module-into-a-modular-jar"></a>
## 38.5 Packaging a Module into a Modular JAR

After compilation, modules are typically packaged as JAR files.

A modular JAR contains a `module-info.class` at its root.

If `module-info.class` is present, the JAR becomes a `named module` automatically and its `name` is taken from the descriptor (not the filename).


```bash
jar --create \
--file mods/com.example.hello.jar \
--main-class com.example.hello.Main \
-C out/com.example.hello .
```

!!! note
    A JAR with `module-info.class` is a `named module, not an automatic module`.
    When a JAR contains a `module-info.class`, its module name is taken from that file and not inferred from the filename.

---

<a id="386-running-a-modular-application"></a>
## 38.6 Running a Modular Application

To run a modular application, you use the `module path` and specify the `module name`.

```bash
java --module-path mods \
--module com.example.hello/com.example.hello.Main
```

You can shorten this using the `-p` and `-m` options.

```bash
java -p mods -m com.example.hello/com.example.hello.Main
```

!!! note
    When using named modules, the classpath is ignored for resolution of module dependencies.

---

<a id="387-module-directives-explained"></a>
## 38.7 Module Directives Explained

The `module-info.java` file contains directives that describe dependencies, visibility, and services.

Each directive has a precise meaning.

<a id="3871-requires"></a>
### 38.7.1 `requires`

The `requires` directive declares a dependency on another module.

Without it, types from the dependency module cannot be used.

```java
module com.example.app {
	requires com.example.lib;
}
```

Effects of requires:
- Dependency must be present at compile and runtime
- Exported packages of the required module become accessible

<a id="3872-requires-transitive"></a>
### 38.7.2 `requires transitive`

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

!!! note
    This is similar to “public dependencies” in other module systems.
    
    Readable ≠ exported: a transitive requirement does not export your packages automatically.


<a id="3873-exports"></a>
### 38.7.3 `exports`

`exports` makes a package accessible to other modules.

Only exported packages are visible outside the module.

```java
module com.example.lib {
	exports com.example.lib.api;
}
```

Non-exported packages remain strongly encapsulated.

<a id="3874-exports-to-qualified-exports"></a>
### 38.7.4 `exports ... to` (Qualified Exports)

A qualified export restricts access to specific modules.

```java
module com.example.lib {
	exports com.example.internal to com.example.friend;
}
```

Only the listed modules can access the exported package.

<a id="3875-opens"></a>
### 38.7.5 `opens`

`opens` allows deep reflective access to a package.

This is primarily for frameworks using reflection.

```java
module com.example.app {
	opens com.example.app.model;
}
```

!!! note
    opens does NOT make a package accessible at compile time.
    It only affects runtime reflection.

<a id="3876-opens-to-qualified-opens"></a>
### 38.7.6 `opens ... to` (Qualified Opens)

You can restrict reflective access to specific modules.

```java
module com.example.app {
	opens com.example.app.model to com.fasterxml.jackson.databind;
}
```

!!! note
    `opens` affects reflection; `exports` affects compilation and type visibility.


<a id="3877-table-of-core-directives"></a>
### 38.7.7 Table of Core Directives

| Directive | Purpose |
| ---- | ---- |
| `requires` | Declare a dependency |
| `requires transitive` | Propagate dependency |
| `exports` | Expose a package |
| `exports ... to` | Expose to specific modules |
| `opens` | Allow runtime reflection |
| `opens ... to` | Restrict reflective access |


<a id="3878-exports-vs-opens-compile-time-vs-runtime-access"></a>
### 38.7.8 Exports vs Opens — Compile-Time vs Runtime Access

| Visibility | Compile-time? | Runtime reflection? |
| ---- | ---- | ---- |
| `exports` | Yes | No |
| `opens` | No | Yes |
| `exports ... to` | Yes (limited modules) | No |
| `opens ... to` | No | Yes (limited modules) |



!!! important
    `JPMS` adds a `module path`, but the `classpath` still exists. They can coexist, but named modules take precedence.
	
	
---

<a id="388-named-automatic-and-unnamed-modules"></a>
## 38.8 Named, Automatic, and Unnamed Modules

`JPMS` supports different kinds of modules to allow gradual migration from the classpath.

JPMS must interoperate with legacy code.

To support gradual adoption, the JVM recognizes three different module categories.

<a id="3881-named-modules"></a>
### 38.8.1 Named Modules

A `named module` has a `module-info.class` and a stable identity.

- Strong encapsulation
- Explicit dependencies
- Full JPMS support

<a id="3882-automatic-modules"></a>
### 38.8.2 Automatic Modules

A JAR without `module-info` placed on the `module path` becomes an `automatic module`.

Its name is derived from the JAR file name.

- Reads all other modules
- Exports all packages
- No strong encapsulation

!!! note
    Automatic modules exist to ease migration.
    They are not suitable as a long-term design.

<a id="3883-unnamed-module"></a>
### 38.8.3 Unnamed Module

Code on the classpath belongs to the `unnamed module`.

- Reads all named modules
- All packages are open
- Cannot be required by named modules

!!! note
    The `unnamed module` preserves legacy classpath behavior.

<a id="3884-comparison-summary"></a>
### 38.8.4 Comparison Summary

| Module type | module-info present? | Encapsulation | Reads |
| ---- | ---- | ---- | ---- |
| `Named` | Yes | Strong | Declared only |
| `Automatic` | No | Weak | All modules |
| `Unnamed` | No | None | All modules |

---

<a id="389-inspecting-modules-and-dependencies"></a>
## 38.9 Inspecting Modules and Dependencies

<a id="3891-describing-modules-with-java"></a>
### 38.9.1 Describing Modules with java

```bash
java --describe-module java.sql
```

This shows `exports`, `requires`, and `services` of a module.

<a id="3892-describing-modular-jars"></a>
### 38.9.2 Describing Modular JARs

```bash
jar --describe-module --file mylib.jar
```

<a id="3893-analyzing-dependencies-with-jdeps"></a>
### 38.9.3 Analyzing Dependencies with `jdeps`

`jdeps` analyzes class and module dependencies statically.

```bash
jdeps myapp.jar
```

```bash
jdeps --module-path mods --check my.module
```

To detect use of JDK internal APIs:

```bash
jdeps --jdk-internals myapp.jar
```

---

<a id="3810-creating-custom-runtime-images-with-jlink"></a>
## 38.10 Creating Custom Runtime Images with `jlink`

`jlink` builds a minimal Java runtime containing only the modules required by an application.

```bash
jlink
--module-path $JAVA_HOME/jmods:mods
--add-modules com.example.app
--output runtime-image
```

Benefits:
- smaller runtime
- faster startup
- no unused JDK modules

---

<a id="3811-creating-self-contained-applications-with-jpackage"></a>
## 38.11 Creating Self-Contained Applications with `jpackage`

`jpackage` builds platform-specific installers or application images.

```bash
jpackage
--name MyApp
--input mods
--main-module com.example.app/com.example.Main
```

`jpackage` can produce:
- .exe / .msi (Windows)
- .pkg / .dmg (macOS)
- .deb / .rpm (Linux)

---

<a id="3812-final-summary-jpms-in-practice"></a>
## 38.12 Final Summary JPMS in Practice

- `JPMS` introduces `strong encapsulation` and reliable dependencies
- `Modules` replace fragile classpath conventions
- `Services` enable decoupled architectures
- `Automatic` and `unnamed modules` support migration
- `jlink` and `jpackage` enable modern deployment models


