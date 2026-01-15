# 37. Java Platform Module System (JPMS)

### Table of Contents

- [37. Java Platform Module System (JPMS)](#37-java-platform-module-system-jpms)
  - [37.1 Why Modules Were Introduced](#371-why-modules-were-introduced)
    - [37.1.1 Problems with the Classpath](#3711-problems-with-the-classpath)
    - [37.1.2 Example of a Classpath Problem](#3712-example-of-a-classpath-problem)
  - [37.2 What Is a Module](#372-what-is-a-module)
    - [37.2.1 Core Properties of Modules](#3721-core-properties-of-modules)
    - [37.2.2 Module vs Package vs JAR](#3722-module-vs-package-vs-jar)
  - [37.3 The module-infojava Descriptor](#373-the-module-infojava-descriptor)
    - [37.3.1 Minimal Module Descriptor](#3731-minimal-module-descriptor)
  - [37.4 Module Directory Structure](#374-module-directory-structure)
  - [37.5 A First Modular Program](#375-a-first-modular-program)
    - [37.5.1 Main Class](#3751-main-class)
    - [37.5.2 Module Descriptor](#3752-module-descriptor)
  - [37.6 Strong Encapsulation Explained](#376-strong-encapsulation-explained)
  - [37.7 Summary of Key Ideas](#377-summary-of-key-ideas)

---

The `Java Platform Module System` (**JPMS**) was introduced in Java 9.

It is a language-level and runtime-level mechanism for structuring Java applications into strongly encapsulated units called modules.

JPMS affects how code is:
- organized
- compiled
- linked
- packaged
- loaded at runtime

Understanding JPMS is essential for modern Java, especially for large applications, libraries, runtime images, and deployment tooling.

## 37.1 Why Modules Were Introduced

Before Java 9, Java applications were built using only:
- `packages`
- `JAR` files
- the `classpath`

This model had serious limitations as applications grew.

### 37.1.1 Problems with the Classpath

The classpath is a flat list of JARs where:
- all public classes are accessible to everyone
- there is no reliable dependency declaration
- conflicting versions are common
- encapsulation is weak or nonexistent
- duplicate classes silently overwrite each other based on classpath order


This led to well-known issues such as:
- “JAR hell”
- classpath ordering bugs
- accidental use of internal APIs
- runtime failures that were not detected at compile time

### 37.1.2 Example of a Classpath Problem

Suppose two libraries depend on different versions of the same third-party JAR.

Only one version can be placed on the classpath.

Which one is chosen depends on classpath order, not correctness.

> [!NOTE]
> This problem cannot be reliably solved with the classpath alone.

---

## 37.2 What Is a Module?

A `module` is a named, self-describing unit of code.

Every named module has a unique name that identifies it to the compiler and module system.


It explicitly declares:
- what it depends on
- what it exposes to other modules
- what it keeps hidden

A module is stronger than a package and more structured than a JAR.

### 37.2.1 Core Properties of Modules

| Property | Description |
| --- | --- |
| Strong encapsulation | Packages are hidden by default |
| Explicit dependencies | Dependencies must be declared |
| Reliable configuration | Missing dependencies cause errors early |
| Named identity | Each module has a unique name |

### 37.2.2 Module vs Package vs JAR

| Concept | Purpose | Encapsulation |
| --- | --- | --- |
| Package | Namespace grouping | Weak (public still visible) |
| JAR     | Packaging / deployment | None (all classes visible when on classpath) |
| Module  | Encapsulation + dependency unit | Strong (unexported packages hidden) |

---

## 37.3 The `module-info.java` Descriptor

Every `named module` is defined by a module descriptor file named:

```text
module-info.java
```

This file describes the module to the compiler and the runtime.

### 37.3.1 Minimal Module Descriptor

A minimal module descriptor declares only the module name. The filename must be exactly `module-info.java`, and it must be located in the root of the module source tree.


```java
module com.example.hello {
}
```

> [!NOTE]
> A module with no directives exports nothing and depends on nothing.

---

## 37.4 Module Directory Structure

A modular project follows a standard directory layout.
The module descriptor sits at the root of the module’s source tree.

```text
src/
└─ com.example.hello/
	├─ module-info.java
	└─ com/
		└─ example/
			└─ hello/
				└─ Main.java
```

Key points:
- The **directory name matches the module name**
- module-info.java is at the top of the module source root
- packages follow standard Java naming rules

> [!NOTE]
> In IDE and build-tool projects, the file structure may differ (e.g. Maven uses `src/main/java`).  
> What always remains true: `module-info.java` sits in the root of the module source tree and package paths follow standard Java naming.

---

## 37.5 A First Modular Program

Let’s create a minimal modular application.

### 37.5.1 Main Class

```java
package com.example.hello;

public class Main {
	public static void main(String[] args) {
		System.out.println("Hello, modular world!");
	}
}
```

### 37.5.2 Module Descriptor

```java
module com.example.hello {
	exports com.example.hello;
}
```

The `exports directive` makes the package accessible to other modules.

Without it, the package is encapsulated and inaccessible.

---

## 37.6 Strong Encapsulation Explained

In `JPMS`, packages are NOT accessible by default.

Even public classes are hidden unless explicitly exported.

In modules, `public` means “public to other modules *only if* the containing package is exported.”


| Situation | Accessible from another module? |
|-----------|---------------------------------|
| Public class in non-exported package  | No |
| Public class in exported package | Yes |
| Protected member in exported package | Yes, but only via subclassing (not general access) |
| Package-private class/member (any package) | No |
| Private member | No |


> [!NOTE]
> This is a fundamental difference from the classpath model.

---

## 37.7 Summary of Key Ideas

- `JPMS` introduces modules as strong units of encapsulation
- Dependencies are explicit and checked
- `module-info.java` is the central descriptor
- Packages are hidden unless exported
- Classpath-based visibility no longer applies in modules
- Public visibility is no longer enough: module exports control accessibility



