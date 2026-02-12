# 39. Services in JPMS (The ServiceLoader Model)

### Table of Contents

- [39 Services in JPMS The ServiceLoader Model](#39-services-in-jpms-the-serviceloader-model)
  - [39.1 The Problem Services Solve](#391-the-problem-services-solve)
    - [39.1.1 Roles in the Service Model](#3911-roles-in-the-service-model)
    - [39.1.2 Service Interface Module](#3912-service-interface-module)
    - [39.1.3 Service Provider Module](#3913-service-provider-module)
    - [39.1.4 Service Consumer Module](#3914-service-consumer-module)
    - [39.1.5 Loading Services at Runtime](#3915-loading-services-at-runtime)
    - [39.1.6 Service Resolution Rules](#3916-service-resolution-rules)
  - [39.2 Named Automatic and Unnamed Modules](#392-named-automatic-and-unnamed-modules)
    - [39.2.1 Named Modules](#3921-named-modules)
    - [39.2.2 Automatic Modules](#3922-automatic-modules)
    - [39.2.3 Unnamed Module](#3923-unnamed-module)
    - [39.2.4 Comparison Summary](#3924-comparison-summary)
  - [39.3 Inspecting Modules and Dependencies](#393-inspecting-modules-and-dependencies)
    - [39.3.1 Describing Modules with java](#3931-describing-modules-with-java)
    - [39.3.2 Describing Modular JARs](#3932-describing-modular-jars)
    - [39.3.3 Analyzing Dependencies with jdeps](#3933-analyzing-dependencies-with-jdeps)
  - [39.4 Creating Custom Runtime Images with jlink](#394-creating-custom-runtime-images-with-jlink)
  - [39.5 Creating Self-Contained Applications with jpackage](#395-creating-self-contained-applications-with-jpackage)
  - [39.6 Final Summary JPMS in Practice](#396-final-summary-jpms-in-practice)

---

`JPMS` includes a built-in service mechanism that allows `modules` to discover and use implementations at runtime
without hardcoding dependencies between `providers` and `consumers`.

This mechanism is based on the existing `ServiceLoader API`, but modules make it reliable, explicit, and safe.

## 39.1 The Problem Services Solve

Sometimes a module needs to use a capability, but should not depend on a specific implementation.

Typical examples include:
- logging frameworks
- database drivers
- plugin systems
- service providers selected at runtime

Without services, the consumer would need to depend directly on a concrete implementation.

This creates tight coupling and reduces flexibility.

### 39.1.1 Roles in the Service Model

The `JPMS service model` involves four distinct roles.

| Role | Description |
| --- | --- |
| `Service interface` | Defines the contract |
| `Service provider` | Implements the service |
| `Service consumer` | Uses the service |
| `Service loader` | Discovers implementations at runtime |

### 39.1.2 Service Interface Module

The `service interface` defines the API that `consumers` depend on.

It must be exported so other modules can see it.

```java
package com.example.service;

public interface GreetingService {
	String greet(String name);
}
```

```java
module com.example.service {
	exports com.example.service;
}
```

> [!NOTE]
> The service interface module should contain no implementations.

### 39.1.3 Service Provider Module

A `provider module` implements the service interface and declares that it provides the service.

```java
package com.example.service.impl;

import com.example.service.GreetingService;

public class EnglishGreeting implements GreetingService {
	public String greet(String name) {
		return "Hello " + name;
	}
}
```

```java
module com.example.provider.english {
	requires com.example.service;
	provides com.example.service.GreetingService with com.example.service.impl.EnglishGreeting;
}
```

Key points:
- The `provider` depends on the `service interface`
- The implementation class does not need to be exported
- The provides directive registers the implementation

### 39.1.4 Service Consumer Module

The `consumer module` declares that it uses a service, but does not name any implementation.

```java
module com.example.consumer {
	requires com.example.service;
	uses com.example.service.GreetingService;
}
```

> [!NOTE]
> `uses` declares intent to discover implementations at runtime.
>
> A module that declares `uses` but has no matching provider on the module path compiles normally,
> but `ServiceLoader` returns an empty result at runtime.


### 39.1.5 Loading Services at Runtime

The `ServiceLoader API` performs service discovery.

It finds all providers visible to the module graph.

```java
ServiceLoader<GreetingService> loader =
	ServiceLoader.load(GreetingService.class);

for (GreetingService service : loader) {
	System.out.println(service.greet("World"));
}
```

`JPMS` guarantees that only declared providers are discovered.

Classpath-based “accidental” discovery is prevented.

### 39.1.6 Service Resolution Rules

For a service to be discoverable by ServiceLoader, several conditions must be satisfied:


| Rule | Meaning |
| ---- | ---- |
| Provider module must be readable | Resolved by requires graph |
| Service interface must be exported | Consumers must see it |
| Consumer must declare `uses` | Otherwise ServiceLoader fails |
| Provider must declare `provides` | Implicit discovery is forbidden |

---

## 39.2 Named, Automatic, and Unnamed Modules

`JPMS` supports different kinds of modules to allow gradual migration from the classpath.

JPMS must interoperate with legacy code.

To support gradual adoption, the JVM recognizes three different module categories.


### 39.2.1 Named Modules

A `named module` has a `module-info.class` and a stable identity.

- Strong encapsulation
- Explicit dependencies
- Full JPMS support

### 39.2.2 Automatic Modules

A JAR without module-info `placed on the module path` becomes an `automatic module`.

Its name is derived from the JAR file name.

- Reads all other modules
- Exports all packages
- No strong encapsulation

> [!NOTE]
> Automatic modules exist to ease migration.
> They are not suitable as a long-term design.

### 39.2.3 Unnamed Module

Code on the classpath belongs to the `unnamed module`.

- Reads all named modules
- All packages are open
- Cannot be required by named modules

> [!NOTE]
> The `unnamed module` preserves legacy classpath behavior.

### 39.2.4 Comparison Summary

| Module type | module-info present? | Encapsulation | Reads |
| ---- | ---- | ---- | ---- |
| `Named` | Yes | Strong | Declared only |
| `Automatic` | No | Weak | All modules |
| `Unnamed` | No | None | All modules |

---

## 39.3 Inspecting Modules and Dependencies

### 39.3.1 Describing Modules with java

```bash
java --describe-module java.sql
```

This shows exports, requires, and services of a module.

### 39.3.2 Describing Modular JARs

```bash
jar --describe-module --file mylib.jar
```

### 39.3.3 Analyzing Dependencies with `jdeps`

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

## 39.4 Creating Custom Runtime Images with `jlink`

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

## 39.5 Creating Self-Contained Applications with `jpackage`

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

## 39.6 Final Summary: JPMS in Practice

- `JPMS` introduces `strong encapsulation` and reliable dependencies
- `Modules` replace fragile classpath conventions
- `Services` enable decoupled architectures
- `Automatic` and `unnamed modules` support migration
- `jlink` and `jpackage` enable modern deployment models
