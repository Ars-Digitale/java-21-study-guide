# 38. Compilare, Impacchettare ed Eseguire Moduli

### Indice

- [38. Compilare, Impacchettare ed Eseguire Moduli](#38-compilare-impacchettare-ed-eseguire-moduli)
  - [38.1 Il Module Path vs il Classpath](#381-il-module-path-vs-il-classpath)
  - [38.2 Opzioni della Riga di Comando Relative ai Moduli](#382-opzioni-della-riga-di-comando-relative-ai-moduli)
    - [38.2.1 Opzioni Disponibili sia in java che in javac](#3821-opzioni-disponibili-sia-in-java-che-in-javac)
    - [38.2.2 Opzioni Applicabili Solo a javac](#3822-opzioni-applicabili-solo-a-javac)
    - [38.2.3 Opzioni Applicabili Solo a java](#3823-opzioni-applicabili-solo-a-java)
    - [38.2.4 Distinzioni Importanti](#3824-distinzioni-importanti)
  - [38.3 Compilare un Singolo Modulo](#383-compilare-un-singolo-modulo)
  - [38.4 Compilare Moduli Multipli Interdipendenti](#384-compilare-moduli-multipli-interdipendenti)
  - [38.5 Impacchettare un Modulo in un JAR Modulare](#385-impacchettare-un-modulo-in-un-jar-modulare)
  - [38.6 Eseguire un’Applicazione Modulare](#386-eseguire-unapplicazione-modulare)
  - [38.7 Spiegazione delle Direttive del Modulo](#387-spiegazione-delle-direttive-del-modulo)
    - [38.7.1 requires](#3871-requires)
    - [38.7.2 requires transitive](#3872-requires-transitive)
    - [38.7.3 exports](#3873-exports)
    - [38.7.4 exports-to-qualified-exports](#3874-exports--to-export-qualificati)
    - [38.7.5 opens](#3875-opens)
    - [38.7.6 opens-to-qualified-opens](#3876-opens--to-opens-qualificati)
    - [38.7.7 Tabella delle Direttive Principali](#3877-tabella-delle-direttive-principali)
    - [38.7.8 Exports vs Opens — Accesso a Compile-Time vs Runtime](#3878-exports-vs-opens--accesso-a-compile-time-vs-runtime)

---

Una volta che un `modulo` è definito con un file `module-info.java`, deve essere compilato, impacchettato ed eseguito utilizzando strumenti consapevoli dei moduli.

Questa sezione spiega come cambia la `toolchain Java` quando sono coinvolti i moduli.

## 38.1 Il Module Path vs il Classpath

`JPMS` introduce un nuovo concetto: il **module path**.

Esiste accanto al tradizionale **classpath**, ma i due si comportano in modo molto diverso.

| Aspetto | Classpath | Module path |
| ---- | ---- | ---- |
| Struttura | Lista piatta di JAR | Moduli con identità |
| Incapsulamento | Nessuno | Forte |
| Verifica delle dipendenze | Nessuna | Rigorosa |
| Split packages | Consentiti | Vietati (moduli nominati) |
| Ordine di risoluzione | Dipendente dall’ordine | Deterministico |

!!! note
    - Un JAR posizionato sul `module path` diventa un `modulo nominato (o automatico)`.
    - Un JAR posizionato sul classpath è trattato come parte del `modulo non nominato`.
    - Gli split package sono consentiti sul classpath ma vietati per i moduli nominati sul module path.

---

## 38.2 Opzioni della Riga di Comando Relative ai Moduli

Quando si lavora con il Java Module System, sia `java` che `javac` forniscono opzioni specifiche per compilare ed eseguire applicazioni modulari. 

Alcune opzioni sono condivise, mentre altre sono specifiche di uno strumento.


### 38.2.1 Opzioni Disponibili sia in `java` che in `javac`

Queste opzioni possono essere utilizzate sia durante la compilazione sia durante l’esecuzione:

- **`--module`** o **`-m`**  
  Utilizzata per compilare o eseguire solo il modulo specificato.

- **`--module-path`** o **`-p`**  
  Specifica i percorsi nei quali `java` o `javac` cercheranno le definizioni dei moduli.


### 38.2.2 Opzioni Applicabili Solo a `javac`

Queste opzioni si applicano solo in fase di compilazione:

- **`--module-source-path`**  
  (nessuna forma abbreviata)  
  Utilizzata da `javac` per individuare le definizioni dei moduli sorgente.

- **`-d`**  
  Specifica la directory di destinazione nella quale verranno generati i file `.class` dopo la compilazione.



### 38.2.3 Opzioni Applicabili Solo a `java`

Queste opzioni si applicano solo in fase di esecuzione:

- **`--list-modules`**  
  (nessuna forma abbreviata)  
  Elenca tutti i moduli osservabili e quindi termina.

- **`--show-module-resolution`**  
  (nessuna forma abbreviata)  
  Mostra i dettagli della risoluzione dei moduli durante l’avvio dell’applicazione.

- **`--describe-module`** o **`-d`**  
  Descrive un modulo specificato e quindi termina.



### 38.2.4 Distinzioni Importanti

L’opzione `-d` ha significati diversi a seconda dello strumento:

- In **`javac`**, `-d` definisce la directory di destinazione per i file di classe compilati.
- In **`java`**, `-d` è una forma abbreviata di `--describe-module`.

Inoltre, `-d` non deve essere confusa con **`-D`** (D maiuscola).

- **`-D`** viene utilizzata durante l’esecuzione di un programma Java per definire proprietà di sistema come coppie nome-valore nella riga di comando.

```bash
java -Dconfig.file=app.properties com.example.Main
```

In questo esempio, `-Dconfig.file=app.properties` imposta una proprietà di sistema che può essere letta a runtime tramite `System.getProperty("config.file")`.

---

## 38.3 Compilare un Singolo Modulo

Per compilare un modulo, devi specificare il percorso dei sorgenti del modulo e la directory di destinazione.

```bash
javac -d out \
src/com.example.hello/module-info.java \
src/com.example.hello/com/example/hello/Main.java
```

Un approccio più scalabile utilizza `--module-source-path`.

```bash
javac --module-source-path src \
      -d out \
      $(find src -name "*.java")
```

!!! note
    `--module-source-path` indica a javac dove trovare più moduli contemporaneamente.

---

## 38.4 Compilare Moduli Multipli Interdipendenti

Quando i moduli dipendono l’uno dall’altro, le loro dipendenze devono essere risolvibili in fase di compilazione.

`--module-path` **mods** (directory di esempio contenente moduli interdipendenti) dovrebbe contenere JAR modulari già compilati o directory di moduli compilati (ognuna con il proprio module-info.class).

```bash
javac -d out \
--module-source-path src \
--module-path mods \
$(find src -name "*.java")
```

Qui:
- `--module-source-path` individua gli alberi dei sorgenti dei moduli
- `--module-path` fornisce moduli già compilati

---

## 38.5 Impacchettare un Modulo in un JAR Modulare

Dopo la compilazione, i moduli sono tipicamente impacchettati come file JAR.

Un JAR modulare contiene un `module-info.class` alla sua root.

Se `module-info.class` è presente, il JAR diventa automaticamente un `modulo nominato` e il suo `nome` è preso dal descrittore (non dal nome del file).

```bash
jar --create \
--file mods/com.example.hello.jar \
--main-class com.example.hello.Main \
-C out/com.example.hello .
```

!!! note
    Un JAR con `module-info.class` è un `modulo nominato, non un modulo automatico`.
    Quando un JAR contiene un `module-info.class`, il suo nome di modulo è preso da quel file e non è dedotto dal nome del file.

---

## 38.6 Eseguire un’Applicazione Modulare

Per eseguire un’applicazione modulare, si utilizza il `module path` e si specifica il `nome del modulo`.

```bash
java --module-path mods \
--module com.example.hello/com.example.hello.Main
```

Puoi abbreviare usando le opzioni `-p` e `-m`.

```bash
java -p mods -m com.example.hello/com.example.hello.Main
```

!!! note
    Quando si usano moduli nominati, il classpath è ignorato per la risoluzione delle dipendenze tra moduli.

---

## 38.7 Spiegazione delle Direttive del Modulo

Il file `module-info.java` contiene direttive che descrivono dipendenze, visibilità e servizi.

Ogni direttiva ha un significato preciso.

### 38.7.1 `requires`

La direttiva `requires` dichiara una dipendenza da un altro modulo.

Senza di essa, i tipi del modulo dipendente non possono essere utilizzati.

```java
module com.example.app {
	requires com.example.lib;
}
```

Effetti di requires:
- La dipendenza deve essere presente a compile-time e a runtime
- I package esportati del modulo richiesto diventano accessibili

### 38.7.2 `requires transitive`

`requires transitive` espone una dipendenza ai moduli a valle.

Propaga la leggibilità.

```java
module com.example.lib {
	requires transitive com.example.util;
	exports com.example.lib.api;
}
```

Significato:
- **Qualsiasi modulo che richiede com.example.lib legge automaticamente com.example.util**
- **I chiamanti non devono dichiarare requires com.example.util esplicitamente**

!!! note
    Questo è simile alle “dipendenze pubbliche” in altri sistemi di moduli.
    
    Leggibile ≠ esportato: un requisito transitivo non esporta automaticamente i tuoi package.

### 38.7.3 `exports`

`exports` rende un package accessibile ad altri moduli.

Solo i package esportati sono visibili all’esterno del modulo.

```java
module com.example.lib {
	exports com.example.lib.api;
}
```

I package non esportati rimangono fortemente incapsulati.

### 38.7.4 `exports ... to` (Export Qualificati)

Un export qualificato limita l’accesso a moduli specifici.

```java
module com.example.lib {
	exports com.example.internal to com.example.friend;
}
```

Solo i moduli elencati possono accedere al package esportato.

### 38.7.5 `opens`

`opens` consente un accesso riflessivo profondo a un package.

È usato principalmente da framework che utilizzano reflection.

```java
module com.example.app {
	opens com.example.app.model;
}
```

!!! note
    opens NON rende un package accessibile a compile-time.
    Influenza solo la reflection a runtime.

### 38.7.6 `opens ... to` (Opens Qualificati)

Puoi limitare l’accesso riflessivo a moduli specifici.

```java
module com.example.app {
	opens com.example.app.model to com.fasterxml.jackson.databind;
}
```

!!! note
    `opens` influenza la reflection; `exports` influenza la compilazione e la visibilità dei tipi.

### 38.7.7 Tabella delle Direttive Principali

| Direttiva | Scopo |
| ---- | ---- |
| `requires` | Dichiarare una dipendenza |
| `requires transitive` | Propagare una dipendenza |
| `exports` | Esporre un package |
| `exports ... to` | Esporre a moduli specifici |
| `opens` | Consentire reflection a runtime |
| `opens ... to` | Limitare l’accesso riflessivo |

### 38.7.8 Exports vs Opens — Accesso a Compile-Time vs Runtime

| Visibilità | Compile-time? | Reflection a runtime? |
| ---- | ---- | ---- |
| `exports` | Sì | No |
| `opens` | No | Sì |
| `exports ... to` | Sì (moduli limitati) | No |
| `opens ... to` | No | Sì (moduli limitati) |

!!! important
    `JPMS` aggiunge un `module path`, ma il `classpath` esiste ancora. Possono coesistere, ma i moduli nominati hanno la precedenza.
