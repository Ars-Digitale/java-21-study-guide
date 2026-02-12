# 39. Servizi in JPMS (Il Modello ServiceLoader)

### Indice

- [39 Servizi in JPMS Il Modello ServiceLoader](#39-servizi-in-jpms-il-modello-serviceloader)
  - [39.1 Il Problema che i Servizi Risolvono](#391-il-problema-che-i-servizi-risolvono)
    - [39.1.1 Ruoli nel Modello dei Servizi](#3911-ruoli-nel-modello-dei-servizi)
    - [39.1.2 Modulo dell’Interfaccia di Servizio](#3912-modulo-dellinterfaccia-di-servizio)
    - [39.1.3 Modulo Provider del Servizio](#3913-modulo-provider-del-servizio)
    - [39.1.4 Modulo Consumer del Servizio](#3914-modulo-consumer-del-servizio)
    - [39.1.5 Caricamento dei Servizi a Runtime](#3915-caricamento-dei-servizi-a-runtime)
    - [39.1.6 Regole di Risoluzione dei Servizi](#3916-regole-di-risoluzione-dei-servizi)
  - [39.2 Moduli Named, Automatic e Unnamed](#392-moduli-named-automatic-e-unnamed)
    - [39.2.1 Moduli Named](#3921-moduli-named)
    - [39.2.2 Moduli Automatic](#3922-moduli-automatic)
    - [39.2.3 Modulo Unnamed](#3923-modulo-unnamed)
    - [39.2.4 Sintesi Comparativa](#3924-sintesi-comparativa)
  - [39.3 Ispezionare Moduli e Dipendenze](#393-ispezionare-moduli-e-dipendenze)
    - [39.3.1 Descrivere Moduli con java](#3931-descrivere-moduli-con-java)
    - [39.3.2 Descrivere JAR Modulari](#3932-descrivere-jar-modulari)
    - [39.3.3 Analizzare le Dipendenze con jdeps](#3933-analizzare-le-dipendenze-con-jdeps)
  - [39.4 Creare Immagini Runtime Personalizzate con jlink](#394-creare-immagini-runtime-personalizzate-con-jlink)
  - [39.5 Creare Applicazioni Self-Contained con jpackage](#395-creare-applicazioni-self-contained-con-jpackage)
  - [39.6 Sintesi Finale JPMS nella Pratica](#396-sintesi-finale-jpms-nella-pratica)

---

`JPMS` include un meccanismo di servizio integrato che permette ai `moduli` di scoprire e utilizzare implementazioni a runtime
senza codificare rigidamente le dipendenze tra `provider` e `consumer`.

Questo meccanismo è basato sulla `ServiceLoader API` esistente, ma i moduli lo rendono affidabile, esplicito e sicuro.

## 39.1 Il Problema che i Servizi Risolvono

Talvolta un modulo deve utilizzare una funzionalità, ma non dovrebbe dipendere da un’implementazione specifica.

Esempi tipici includono:
- framework di logging
- driver di database
- sistemi di plugin
- service provider selezionati a runtime

Senza i servizi, il consumer dovrebbe dipendere direttamente da un’implementazione concreta.

Questo crea accoppiamento stretto e riduce la flessibilità.

### 39.1.1 Ruoli nel Modello dei Servizi

Il `modello di servizio JPMS` coinvolge quattro ruoli distinti.

| Ruolo | Descrizione |
| --- | --- |
| `Service interface` | Definisce il contratto |
| `Service provider` | Implementa il servizio |
| `Service consumer` | Usa il servizio |
| `Service loader` | Scopre le implementazioni a runtime |

### 39.1.2 Modulo dell’Interfaccia di Servizio

La `service interface` definisce l’API da cui i `consumer` dipendono.

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

> [!NOTE]
> Il modulo dell’interfaccia di servizio non dovrebbe contenere implementazioni.

### 39.1.3 Modulo Provider del Servizio

Un `modulo provider` implementa l’interfaccia di servizio e dichiara che fornisce il servizio.

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
- Il `provider` dipende dalla `service interface`
- La classe di implementazione non deve essere esportata
- La direttiva provides registra l’implementazione

### 39.1.4 Modulo Consumer del Servizio

Il `modulo consumer` dichiara che utilizza un servizio, ma non nomina alcuna implementazione.

```java
module com.example.consumer {
	requires com.example.service;
	uses com.example.service.GreetingService;
}
```

> [!NOTE]
> `uses` dichiara l’intenzione di scoprire implementazioni a runtime.
>
> Un modulo che dichiara `uses` ma non ha alcun provider corrispondente sul module path compila normalmente,
> ma `ServiceLoader` restituisce un risultato vuoto a runtime.

### 39.1.5 Caricamento dei Servizi a Runtime

La `ServiceLoader API` esegue la discovery dei servizi.

Trova tutti i provider visibili al grafo dei moduli.

```java
ServiceLoader<GreetingService> loader =
	ServiceLoader.load(GreetingService.class);

for (GreetingService service : loader) {
	System.out.println(service.greet("World"));
}
```

`JPMS` garantisce che solo i provider dichiarati siano scoperti.

La discovery “accidentale” basata su classpath è prevenuta.

### 39.1.6 Regole di Risoluzione dei Servizi

Affinché un servizio sia individuabile da ServiceLoader, devono essere soddisfatte diverse condizioni:

| Regola | Significato |
| ---- | ---- |
| Il modulo provider deve essere leggibile | Risolto tramite il grafo requires |
| L’interfaccia di servizio deve essere esportata | I consumer devono poterla vedere |
| Il consumer deve dichiarare `uses` | Altrimenti ServiceLoader fallisce |
| Il provider deve dichiarare `provides` | La discovery implicita è vietata |

---

## 39.2 Moduli Named, Automatic e Unnamed

`JPMS` supporta diversi tipi di moduli per permettere una migrazione graduale dal classpath.

JPMS deve interoperare con codice legacy.

Per supportare un’adozione graduale, la JVM riconosce tre diverse categorie di moduli.

### 39.2.1 Moduli Named

Un `modulo named` ha un `module-info.class` e un’identità stabile.

- Incapsulamento forte
- Dipendenze esplicite
- Supporto completo JPMS

### 39.2.2 Moduli Automatic

Un JAR senza module-info `posizionato sul module path` diventa un `modulo automatic`.

Il suo nome è derivato dal nome del file JAR.

- Legge tutti gli altri moduli
- Esporta tutti i package
- Nessun incapsulamento forte

> [!NOTE]
> I moduli automatic esistono per facilitare la migrazione.
> Non sono adatti come soluzione di lungo termine.

### 39.2.3 Modulo Unnamed

Il codice sul classpath appartiene al `modulo unnamed`.

- Legge tutti i moduli named
- Tutti i package sono aperti
- Non può essere richiesto da moduli named

> [!NOTE]
> Il `modulo unnamed` preserva il comportamento legacy del classpath.

### 39.2.4 Sintesi Comparativa

| Tipo di modulo | module-info presente? | Incapsulamento | Legge |
| ---- | ---- | ---- | ---- |
| `Named` | Sì | Forte | Solo dichiarati |
| `Automatic` | No | Debole | Tutti i moduli |
| `Unnamed` | No | Nessuno | Tutti i moduli |

---

## 39.3 Ispezionare Moduli e Dipendenze

### 39.3.1 Descrivere Moduli con java

```bash
java --describe-module java.sql
```

Questo mostra exports, requires e servizi di un modulo.

### 39.3.2 Descrivere JAR Modulari

```bash
jar --describe-module --file mylib.jar
```

### 39.3.3 Analizzare le Dipendenze con `jdeps`

`jdeps` analizza staticamente le dipendenze tra classi e moduli.

```bash
jdeps myapp.jar
```

```bash
jdeps --module-path mods --check my.module
```

Per rilevare l’uso di API interne del JDK:

```bash
jdeps --jdk-internals myapp.jar
```

---

## 39.4 Creare Immagini Runtime Personalizzate con `jlink`

`jlink` costruisce un runtime Java minimale contenente solo i moduli richiesti da un’applicazione.

```bash
jlink
--module-path $JAVA_HOME/jmods:mods
--add-modules com.example.app
--output runtime-image
```

Vantaggi:
- runtime più piccolo
- avvio più rapido
- nessun modulo JDK inutilizzato

---

## 39.5 Creare Applicazioni Self-Contained con `jpackage`

`jpackage` costruisce installer specifici per piattaforma o immagini applicative.

```bash
jpackage
--name MyApp
--input mods
--main-module com.example.app/com.example.Main
```

`jpackage` può produrre:
- .exe / .msi (Windows)
- .pkg / .dmg (macOS)
- .deb / .rpm (Linux)

---

## 39.6 Sintesi Finale: JPMS nella Pratica

- `JPMS` introduce `incapsulamento forte` e dipendenze affidabili
- I `moduli` sostituiscono convenzioni fragili basate sul classpath
- I `servizi` permettono architetture disaccoppiate
- I moduli `automatic` e `unnamed` supportano la migrazione
- `jlink` e `jpackage` abilitano modelli di deployment moderni
