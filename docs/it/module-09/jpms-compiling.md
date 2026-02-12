# 38. Compilare, Impacchettare ed Eseguire Moduli

### Indice

- [38. Compilare, Impacchettare ed Eseguire Moduli](#38-compilare-impacchettare-ed-eseguire-moduli)
  - [38.1 Il Module Path vs il Classpath](#381-il-module-path-vs-il-classpath)
  - [38.2 Compilare un Singolo Modulo](#382-compilare-un-singolo-modulo)
  - [38.3 Compilare Moduli Multipli Interdipendenti](#383-compilare-moduli-multipli-interdipendenti)
  - [38.4 Impacchettare un Modulo in un JAR Modulare](#384-impacchettare-un-modulo-in-un-jar-modulare)
  - [38.5 Eseguire un’Applicazione Modulare](#385-eseguire-unapplicazione-modulare)
  - [38.6 Spiegazione delle Direttive del Modulo](#386-spiegazione-delle-direttive-del-modulo)
    - [38.6.1 requires](#3861-requires)
    - [38.6.2 requires transitive](#3862-requires-transitive)
    - [38.6.3 exports](#3863-exports)
    - [38.6.4 exports-to-qualified-exports](#3864-exports--to-qualified-exports)
    - [38.6.5 opens](#3865-opens)
    - [38.6.6 opens-to-qualified-opens](#3866-opens--to-qualified-opens)
    - [38.6.7 Tabella delle Direttive Principali](#3867-tabella-delle-direttive-principali)
    - [38.6.8 Exports vs Opens — Accesso a Compile-Time vs Runtime](#3868-exports-vs-opens--accesso-a-compile-time-vs-runtime)

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

> [!NOTE]
> - Un JAR posizionato sul `module path` diventa un `modulo nominato (o automatico)`.
> - Un JAR posizionato sul classpath è trattato come parte del `modulo non nominato`.
> - Gli split package sono consentiti sul classpath ma vietati per i moduli nominati sul module path.

---

## 38.2 Compilare un Singolo Modulo

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

> [!NOTE]
> `--module-source-path` indica a javac dove trovare più moduli contemporaneamente.

---

## 38.3 Compilare Moduli Multipli Interdipendenti

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

## 38.4 Impacchettare un Modulo in un JAR Modulare

Dopo la compilazione, i moduli sono tipicamente impacchettati come file JAR.

Un JAR modulare contiene un `module-info.class` alla sua root.

Se `module-info.class` è presente, il JAR diventa automaticamente un `modulo nominato` e il suo `nome` è preso dal descrittore (non dal nome del file).

```bash
jar --create \
--file mods/com.example.hello.jar \
--main-class com.example.hello.Main \
-C out/com.example.hello .
```

> [!NOTE]
> Un JAR con `module-info.class` è un `modulo nominato, non un modulo automatico`.
> Quando un JAR contiene un `module-info.class`, il suo nome di modulo è preso da quel file e non è dedotto dal nome del file.

---

## 38.5 Eseguire un’Applicazione Modulare

Per eseguire un’applicazione modulare, si utilizza il `module path` e si specifica il `nome del modulo`.

```bash
java --module-path mods \
--module com.example.hello/com.example.hello.Main
```

Puoi abbreviare usando le opzioni `-p` e `-m`.

```bash
java -p mods -m com.example.hello/com.example.hello.Main
```

> [!NOTE]
> Quando si usano moduli nominati, il classpath è ignorato per la risoluzione delle dipendenze tra moduli.

---

## 38.6 Spiegazione delle Direttive del Modulo

Il file `module-info.java` contiene direttive che descrivono dipendenze, visibilità e servizi.

Ogni direttiva ha un significato preciso.

### 38.6.1 `requires`

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

### 38.6.2 `requires transitive`

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

> [!NOTE]
> Questo è simile alle “dipendenze pubbliche” in altri sistemi di moduli.
>
> Leggibile ≠ esportato: un requisito transitivo non esporta automaticamente i tuoi package.

### 38.6.3 `exports`

`exports` rende un package accessibile ad altri moduli.

Solo i package esportati sono visibili all’esterno del modulo.

```java
module com.example.lib {
	exports com.example.lib.api;
}
```

I package non esportati rimangono fortemente incapsulati.

### 38.6.4 `exports ... to` (Export Qualificati)

Un export qualificato limita l’accesso a moduli specifici.

```java
module com.example.lib {
	exports com.example.internal to com.example.friend;
}
```

Solo i moduli elencati possono accedere al package esportato.

### 38.6.5 `opens`

`opens` consente un accesso riflessivo profondo a un package.

È usato principalmente da framework che utilizzano reflection.

```java
module com.example.app {
	opens com.example.app.model;
}
```

> [!NOTE]
> opens NON rende un package accessibile a compile-time.
> Influenza solo la reflection a runtime.

### 38.6.6 `opens ... to` (Opens Qualificati)

Puoi limitare l’accesso riflessivo a moduli specifici.

```java
module com.example.app {
	opens com.example.app.model to com.fasterxml.jackson.databind;
}
```

> [!NOTE]
> `opens` influenza la reflection; `exports` influenza la compilazione e la visibilità dei tipi.

### 38.6.7 Tabella delle Direttive Principali

| Direttiva | Scopo |
| ---- | ---- |
| `requires` | Dichiarare una dipendenza |
| `requires transitive` | Propagare una dipendenza |
| `exports` | Esporre un package |
| `exports ... to` | Esporre a moduli specifici |
| `opens` | Consentire reflection a runtime |
| `opens ... to` | Limitare l’accesso riflessivo |

### 38.6.8 Exports vs Opens — Accesso a Compile-Time vs Runtime

| Visibilità | Compile-time? | Reflection a runtime? |
| ---- | ---- | ---- |
| `exports` | Sì | No |
| `opens` | No | Sì |
| `exports ... to` | Sì (moduli limitati) | No |
| `opens ... to` | No | Sì (moduli limitati) |

> [!IMPORTANT]
> `JPMS` aggiunge un `module path`, ma il `classpath` esiste ancora. Possono coesistere, ma i moduli nominati hanno la precedenza.
