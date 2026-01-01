# Java Platform Module System (JPMS)

The `Java Platform Module System` (**JPMS**) was introduced in Java 9.

It is a language-level and runtime-level mechanism for structuring Java applications into strongly encapsulated units called modules.

JPMS affects how code is:
- organized
- compiled
- linked
- packaged
- loaded at runtime

Understanding JPMS is essential for modern Java, especially for large applications, libraries, runtime images, and deployment tooling.

## 1. Why Modules Were Introduced

Before Java 9, Java applications were built using only:
- packages
- JAR files
- the classpath

This model had serious limitations as applications grew.

### 1.1 Problems with the Classpath

The classpath is a flat list of JARs where:
- all public classes are accessible to everyone
- there is no reliable dependency declaration
- conflicting versions are common
- encapsulation is weak or nonexistent

This led to well-known issues such as:
- “JAR hell”
- classpath ordering bugs
- accidental use of internal APIs
- runtime failures that were not detected at compile time

### 1.2 Example of a Classpath Problem

Suppose two libraries depend on different versions of the same third-party JAR.

Only one version can be placed on the classpath.

Which one is chosen depends on classpath order, not correctness.

> [!NOTE]
> This problem cannot be reliably solved with the classpath alone.

## 2. What Is a Module?

A module is a named, self-describing unit of code.

It explicitly declares:
- what it depends on
- what it exposes to other modules
- what it keeps hidden

A module is stronger than a package and more structured than a JAR.

### 2.1 Core Properties of Modules

| Property | Description |
| --- | --- |
| Strong encapsulation | Packages are hidden by default |
| Explicit dependencies | Dependencies must be declared |
| Reliable configuration | Missing dependencies cause errors early |
| Named identity | Each module has a unique name |

### 2.2 Module vs Package vs JAR

| Concept | Purpose | Encapsulation |
| --- | --- | --- |
| Package | Namespace | only Weak |
| JAR | Deployment unit | None |
| Module | Strong abstraction unit | Strong |

## 3. The module-info.java Descriptor

Every named module is defined by a module descriptor file named:

```text
module-info.java
```

This file describes the module to the compiler and the runtime.

### 3.1 Minimal Module Descriptor

A minimal module descriptor declares only the module name.

```java
module com.example.hello {
}
```

> [!NOTE]
> A module with no directives exports nothing and depends on nothing.

## 4. Module Directory Structure

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

## 5. A First Modular Program

Let’s create a minimal modular application.

### 5.1 Main Class

```java
package com.example.hello;

public class Main {
	public static void main(String[] args) {
		System.out.println("Hello, modular world!");
	}
}
```

### 5.2 Module Descriptor

```java
module com.example.hello {
	exports com.example.hello;
}
```

The `exports directive` makes the package accessible to other modules.

Without it, the package is encapsulated and inaccessible.

## 6. Strong Encapsulation Explained

In `JPMS`, packages are NOT accessible by default.

Even public classes are hidden unless explicitly exported.

| Situation | Accessible? |
| --- | --- |
| Public class in non-exported package | No |
| Public class in exported package | Yes |
| Non-public class | Never |

> [!NOTE]
> This is a fundamental difference from the classpath model.

## 7. Summary of Key Ideas

- `JPMS` introduces modules as strong units of encapsulation
- Dependencies are explicit and checked
- `module-info.java` is the central descriptor
- Packages are hidden unless exported
- Classpath-based visibility no longer applies in modules


