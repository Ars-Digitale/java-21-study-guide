# 39. Services in JPMS (The ServiceLoader Model)

<a id="table-of-contents"></a>
### Table of Contents

- [39 Services in JPMS The ServiceLoader Model](#39-services-in-jpms-the-serviceloader-model)
  - [39.1 The Problem Services Solve](#391-the-problem-services-solve)
    - [39.1.1 Roles in the Service Model](#3911-roles-in-the-service-model)
    - [39.1.2 Service Interface Module](#3912-service-interface-module)
    - [39.1.3 Service Provider Module](#3913-service-provider-module)
    - [39.1.4 Service Consumer Module](#3914-service-consumer-module)
    - [39.1.5 Loading Services at Runtime](#3915-loading-services-at-runtime)
    - [39.1.6 Service Resolution Rules](#3916-service-resolution-rules)
    - [39.1.7 Service Locator Layer](#3917-service-locator-layer)
    - [39.1.8 Sequential Invocation Diagram](#3918-sequential-invocation-diagram)
    - [39.1.9 Component Summary Table](#3919-component-summary-table)


---

`JPMS` includes a built-in service mechanism that allows `modules` to discover and use implementations at runtime
without hardcoding dependencies between `providers` and `consumers`.

This mechanism is based on the existing `ServiceLoader API`, but modules make it reliable, explicit, and safe.

<a id="391-the-problem-services-solve"></a>
## 39.1 The Problem Services Solve

Sometimes a module needs to use a capability, but should not depend on a specific implementation.

Typical examples include:
- logging frameworks
- database drivers
- plugin systems
- service providers selected at runtime

Without services, the consumer would need to depend directly on a concrete implementation.

This creates tight coupling and reduces flexibility.

<a id="3911-roles-in-the-service-model"></a>
### 39.1.1 Roles in the Service Model

The `JPMS service model` involves four distinct roles.

| Role | Description |
| --- | --- |
| `Service interface` | Defines the contract |
| `Service provider` | Implements the service |
| `Service consumer` | Uses the service |
| `Service loader` | Discovers implementations at runtime |

<a id="3912-service-interface-module"></a>
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

!!! note
    The service interface module should contain no implementations.

<a id="3913-service-provider-module"></a>
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
- The `provides` directive registers the implementation

<a id="3914-service-consumer-module"></a>
### 39.1.4 Service Consumer Module

The `consumer module` declares that it uses a service, but does not name any implementation.

```java
module com.example.consumer {
	requires com.example.service;
	uses com.example.service.GreetingService;
}
```

!!! note
    `uses` declares intent to discover implementations at runtime.
    
    A module that declares `uses` but has no matching provider on the module path compiles normally,
    but `ServiceLoader` returns an empty result at runtime.

<a id="3915-loading-services-at-runtime"></a>
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

<a id="3916-service-resolution-rules"></a>
### 39.1.6 Service Resolution Rules

For a service to be discoverable by `ServiceLoader`, several conditions must be satisfied:

| Rule | Meaning |
| ---- | ---- |
| Provider module must be readable | Resolved by `requires` graph |
| Service interface must be exported | Consumers must see it |
| Consumer must declare `uses` | Otherwise ServiceLoader fails |
| Provider must declare `provides` | Implicit discovery is forbidden |

<a id="3917-service-locator-layer"></a>
### 39.1.7 Service Locator Layer

It is possible to introduce an additional layer called `Service Locator`.

In this architecture:

- The `consumer` does not directly use `ServiceLoader`
- The `Service Locator` is the only component that declares `uses`
- The `consumer` depends on the `Service Locator`

Architectural structure:

```
Consumer → Service Locator → ServiceLoader → Provider
```

Service Locator module:

```java
module com.example.locator {
	requires com.example.service;
	uses com.example.service.GreetingService;
}
```

Service Locator class:

```java
package com.example.locator;

import java.util.ServiceLoader;
import com.example.service.GreetingService;

public class GreetingLocator {

	public static GreetingService getService() {
		return ServiceLoader
				.load(GreetingService.class)
				.findFirst()
				.orElseThrow();
	}
}
```

Consumer module:

```java
module com.example.consumer {
	requires com.example.locator;
}
```

The consumer does not declare `uses` because it does not directly invoke `ServiceLoader`.

<a id="3918-sequential-invocation-diagram"></a>
### 39.1.8 Sequential Invocation Diagram

Execution sequence:

1. The `Consumer` invokes `GreetingLocator.getService()`
2. The `Service Locator` invokes `ServiceLoader.load(...)`
3. The `ServiceLoader` consults the module graph
4. The system identifies modules that declare `provides`
5. The `Provider` implementation is instantiated
6. The instance is returned to the `Consumer`

Sequential diagram:

```
Consumer
   │
   │ 1. getService()
   ▼
Service Locator
   │
   │ 2. ServiceLoader.load()
   ▼
ServiceLoader
   │
   │ 3. Provider resolution
   ▼
Provider Implementation
   │
   │ 4. Instance returned
   ▼
Consumer
```

<a id="3919-component-summary-table"></a>
### 39.1.9 Component Summary Table

| Component | Role | exports | requires | uses | provides |
|------------|-------|---------|----------|------|----------|
| SPI | Defines contract | ✅ | ❌ | ❌ | ❌ |
| Provider | Implements service | ❌ | ✅ | ❌ | ✅ |
| Service Locator | Performs discovery | (optional) | ✅ | ✅ | ❌ |
| Consumer | Uses the service | ❌ | ✅ | ❌ | ❌ |

