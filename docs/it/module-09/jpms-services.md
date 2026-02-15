# 39. Servizi in JPMS (Il Modello ServiceLoader)

### Indice

- [39 Servizi in JPMS Il Modello ServiceLoader](#39-servizi-in-jpms-il-modello-serviceloader)
  - [39.1 Il Problema che i Servizi Risolvono](#391-il-problema-che-i-servizi-risolvono)
    - [39.1.1 Ruoli nel Modello dei Servizi](#3911-ruoli-nel-modello-dei-servizi)
    - [39.1.2 Modulo Interfaccia del Servizio](#3912-modulo-interfaccia-del-servizio)
    - [39.1.3 Modulo Provider del Servizio](#3913-modulo-provider-del-servizio)
    - [39.1.4 Modulo Consumer del Servizio](#3914-modulo-consumer-del-servizio)
    - [39.1.5 Caricamento dei Servizi a Runtime](#3915-caricamento-dei-servizi-a-runtime)
    - [39.1.6 Regole di Risoluzione dei Servizi](#3916-regole-di-risoluzione-dei-servizi)
    - [39.1.7 Livello Service Locator](#3917-livello-service-locator)
    - [39.1.8 Schema Sequenziale di Invocazione](#3918-schema-sequenziale-di-invocazione)
    - [39.1.9 Tabella Riassuntiva dei Componenti](#3919-tabella-riassuntiva-dei-componenti)


---

`JPMS` include un meccanismo di servizio integrato che permette ai `moduli` di scoprire e utilizzare implementazioni a runtime
senza codificare rigidamente dipendenze tra `provider` e `consumer`.

Questo meccanismo è basato sulla `ServiceLoader API` esistente, ma i moduli lo rendono affidabile, esplicito e sicuro.

## 39.1 Il Problema che i Servizi Risolvono

Talvolta un modulo necessita di utilizzare una capacità, ma non dovrebbe dipendere da una implementazione specifica.

Esempi tipici includono:
- framework di logging
- driver di database
- sistemi plugin
- provider di servizi selezionati a runtime

Senza i servizi, il consumer dovrebbe dipendere direttamente da una implementazione concreta.

Questo crea accoppiamento stretto e riduce la flessibilità.

### 39.1.1 Ruoli nel Modello dei Servizi

Il `modello dei servizi JPMS` coinvolge quattro ruoli distinti.

| Ruolo | Descrizione |
| --- | --- |
| `Interfaccia del servizio` | Definisce il contratto |
| `Provider del servizio` | Implementa il servizio |
| `Consumer del servizio` | Utilizza il servizio |
| `Service loader` | Scopre le implementazioni a runtime |

### 39.1.2 Modulo Interfaccia del Servizio

L’`interfaccia del servizio` definisce l’API da cui i `consumer` dipendono.

Deve essere esportata affinché altri moduli possano vederla.

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
    Il modulo dell’interfaccia del servizio non dovrebbe contenere implementazioni.

### 39.1.3 Modulo Provider del Servizio

Un `modulo provider` implementa l’interfaccia del servizio e dichiara di fornire il servizio.

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

Punti chiave:
- Il `provider` dipende dall’`interfaccia del servizio`
- La classe di implementazione non necessita di essere esportata
- La direttiva `provides with` registra l’implementazione

### 39.1.4 Modulo Consumer del Servizio

Il `modulo consumer` dichiara di utilizzare un servizio, ma non nomina alcuna implementazione.

```java
module com.example.consumer {
	requires com.example.service;
	uses com.example.service.GreetingService;
}
```

!!! note
    `uses` dichiara l’intenzione di scoprire implementazioni a runtime.
    
    Un modulo che dichiara `uses` ma non ha provider corrispondenti nel module path compila normalmente,
    ma `ServiceLoader` restituisce un risultato vuoto a runtime.

### 39.1.5 Caricamento dei Servizi a Runtime

La `ServiceLoader API` esegue la scoperta del servizio.

Trova tutti i provider visibili al grafo dei moduli.

```java
ServiceLoader<GreetingService> loader =
	ServiceLoader.load(GreetingService.class);

for (GreetingService service : loader) {
	System.out.println(service.greet("World"));
}
```

`JPMS` garantisce che solo i provider dichiarati siano scoperti.

La scoperta “accidentale” basata su classpath è prevenuta.

### 39.1.6 Regole di Risoluzione dei Servizi

Affinché un servizio sia individuabile da `ServiceLoader`, devono essere soddisfatte diverse condizioni:

| Regola | Significato |
| ---- | ---- |
| Il modulo provider deve essere leggibile | Risolto dal grafo `requires` |
| L’interfaccia del servizio deve essere esportata | I consumer devono vederla |
| Il consumer (o il Service Locator) deve dichiarare `uses` | Altrimenti ServiceLoader fallisce |
| Il provider deve dichiarare `provides` | La scoperta implicita è vietata |

### 39.1.7 Livello Service Locator

È possibile introdurre un livello aggiuntivo denominato `Service Locator`.

In questa architettura:

- Il `consumer` non utilizza direttamente `ServiceLoader`
- Il `Service Locator` è l’unico componente che dichiara `uses`
- Il `consumer` dipende dal `Service Locator`

Struttura architetturale:

```
Consumer → Service Locator → ServiceLoader → Provider
```

Modulo del Service Locator:

```java
module com.example.locator {
	requires com.example.service;
	uses com.example.service.GreetingService;
}
```

Classe Service Locator:

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

Modulo Consumer:

```java
module com.example.consumer {
	requires com.example.locator;
}
```

Il consumer non dichiara `uses` perché non invoca direttamente `ServiceLoader`.

### 39.1.8 Schema Sequenziale di Invocazione

Sequenza di esecuzione:

1. Il `Consumer` invoca `GreetingLocator.getService()`
2. Il `Service Locator` invoca `ServiceLoader.load(...)`
3. Il `ServiceLoader` consulta il grafo dei moduli
4. Il sistema individua i moduli che dichiarano `provides`
5. Viene istanziata l’implementazione del `Provider`
6. L’istanza viene restituita al `Consumer`

Schema sequenziale:

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
   │ 3. Risoluzione provider
   ▼
Provider Implementation
   │
   │ 4. Istanza restituita
   ▼
Consumer
```

### 39.1.9 Tabella Riassuntiva dei Componenti

| Componente | Ruolo | exports | requires | uses | provides |
|------------|-------|---------|----------|------|----------|
| SPI | Definisce contratto | ✅ | ❌ | ❌ | ❌ |
| Provider | Implementa servizio | ❌ | ✅ | ❌ | ✅ |
| Service Locator | Esegue discovery | (opzionale) | ✅ | ✅ | ❌ |
| Consumer | Usa il servizio | ❌ | ✅ | ❌ | ❌ |

