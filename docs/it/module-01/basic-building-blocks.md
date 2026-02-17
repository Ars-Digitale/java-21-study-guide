# 2. Mattoni di base del linguaggio Java

<a id="indice"></a>
### Indice


- [2.1 Definizione di classe](#21-definizione-di-classe)
- [2.2 Commenti](#22-commenti)
- [2.3 Modificatori di accesso](#23-modificatori-di-accesso)
- [2.4 Package](#24-package)
	- [2.4.1 Organizzazione e scopo](#241-organizzazione-e-scopo)
	- [2.4.2 Mappatura con il file system e dichiarazione di un package](#242-mappatura-con-il-file-system-e-dichiarazione-di-un-package)
	- [2.4.3 Appartenere allo stesso package](#243-appartenere-allo-stesso-package)
	- [2.4.4 Importare da un package](#244-importare-da-un-package)
	- [2.4.5 Import statici](#245-import-statici)
		- [2.4.5.1 Regole di precedenza](#2451-regole-di-precedenza)
	- [2.4.6 Package standard vs. package definiti dall’utente](#246-package-standard-vs-package-definiti-dallutente)
- [2.5 Il metodo main](#25-il-metodo-main)
	- [2.5.1 Firma del metodo main](#251-firma-del-metodo-main)
- [2.6 Compilare ed eseguire il codice](#26-compilare-ed-eseguire-il-codice)
	- [2.6.1 Compilare un file, package di default (singola directory)](#261-compilare-un-file-package-di-default-singola-directory)
	- [2.6.2 Più file, package di default (singola directory)](#262-più-file-package-di-default-singola-directory)
	- [2.6.3 Codice dentro package (layout standard src → out)](#263-codice-dentro-package-layout-standard-src--out)
	- [2.6.4 Compilare verso un’altra directory (-d)](#264-compilare-verso-unaltra-directory--d)
	- [2.6.5 Più file su più package (compilare l’intero albero sorgente)](#265-più-file-su-più-package-compilare-lintero-albero-sorgente)
	- [2.6.6 Esecuzione di un singolo sorgente (run veloce senza javac)](#266-esecuzione-di-un-singolo-sorgente-run-veloce-senza-javac)
	- [2.6.7 Passare parametri a un programma Java](#267-passare-parametri-a-un-programma-java)


---

Questo capitolo introduce gli elementi strutturali essenziali di un programma Java:
`class`, `method`, `comment`, `access modifier`, `package`, il metodo `main` e i comandi di base da riga di comando (`javac` e `java`).

Questi sono i concetti minimi necessari per scrivere, compilare, organizzare ed eseguire codice Java nel JDK — senza nessun IDE.

<a id="21-definizione-di-classe"></a>
## 2.1 Definizione di classe

Una `class` Java è il mattone fondamentale di un programma Java. 
 
Una classe rappresenta un **tipo** in Java: definisce un insieme di dati (`fields`) e un comportamento (`methods`).

Una `class` è un **blueprint** (modello), mentre gli `object` sono **istanze concrete** create a runtime sulla base di questo modello.

Una classe Java è composta da due elementi principali, detti **membri** della classe:
- **Field** (o variabili) — rappresentano i dati che definiscono lo stato del nuovo tipo.
- **Method** (o funzioni) — rappresentano le operazioni che possono essere eseguite su questi dati.

Alcuni membri possono essere dichiarati con la keyword **static**.

Un membro static appartiene alla classe stessa, non agli oggetti creati da essa.

Ciò significa che:

- esiste una sola copia condivisa tra tutte le istanze
- può essere utilizzato senza creare un oggetto della classe
- è caricato in memoria quando la classe viene caricata dalla JVM

I membri non statici (detti **di istanza**) appartengono invece ai singoli oggetti e ogni istanza ne possiede la propria copia.

Normalmente, ogni classe è definita nel proprio file "**.java**"; per esempio, una classe chiamata `Person` sarà definita nel corrispondente file `Person.java`.

Qualsiasi classe definita in modo indipendente nel proprio file sorgente è detta **top-level class**.

Una classe di questo tipo può essere dichiarata solo come `public` oppure con il modificatore di accesso di default (`package-private`, cioè senza alcun access modifier esplicito).

Un singolo file, tuttavia, può contenere più di una definizione di classe.  
**In questo caso, solo una classe può essere dichiarata `public`, e il nome del file deve corrispondere a quella classe.**

Le **nested class**, ovvero classi dichiarate all’interno di un’altra classe, possono usare qualunque modificatore di accesso: `public`, `protected`, `private`, `default` (package-private).

- Esempio:

```java
public class Person {

    // This is a comment: explains the code but is ignored by the compiler. See section below.

    // Field → defines data/state
    String personName;

    // Method → defines behavior (this one take a parameter, newName, in input but does not return a value)
    void setPersonName(String newName) {
        personName = newName;
    }

    // Method → defines behavior  (this one does not take parameters in input but does return a String)
    String getPersonName(){
        return personName;
    }
}
```

!!! note
    Nella sua forma più semplice, potremmo teoricamente avere una classe senza metodi e senza field. Sebbene una classe del genere venga compilata, avrebbe ben poco senso pratico.

| Token / Identifier | Category | Meaning | Optional? |
| --- | --- | --- | --- |
| public | Keyword / access modifier | determina quali altre classi possono usare o vedere quell’elemento | Mandatory (quando assente è, per default, package-private) |
| class | Keyword | Dichiara un tipo di classe. | Mandatory |
| Person | Class name (identifier) | Il nome della classe. | Mandatory |
| personName | Field name (identifier) | Memorizza il nome della persona. | Optional |
| String | Type / Keyword | Tipo del field `personName` e del parametro `newName`. | Mandatory |
| setPersonName, getPersonName | Method names (identifier) | denominano un comportamento della classe. | Optional |
| newName | Parameter name (identifier) | input passato al metodo `setPersonName`. | Mandatory (se il metodo richiede un parametro) |
| return | Keyword | Termina un metodo e restituisce un valore. | Mandatory (nei metodi con tipo di ritorno non void) |
| void | Return Type / Keyword | Indica che il metodo non restituisce alcun valore. | Mandatory (se il metodo non restituisce alcun valore) |

!!! note
    Mandatory = richiesto dalla sintassi Java,
    Optional = non richiesto dalla sintassi; dipende dal design.

---

<a id="22-commenti"></a>
## 2.2 Commenti

I commenti non sono codice eseguibile: **spiegano** il codice ma vengono ignorati dal compilatore.

In Java esistono 3 tipi di commenti:
- Single-line (`//`)
- Multi-line (`/* ... */`)
- Javadoc (`/** ... */`)

Un **single-line comment** inizia con 2 slash: tutto il testo che segue sulla stessa riga viene ignorato dal compilatore.

- Esempio:

```java
// This is a single-line comment. It starts with 2 slashes and ends at the end of the line. 
```

Un **multiline comment** include tutto ciò che si trova tra i simboli `/*` e `*/`.

- Esempio:

```java
/* 	
 * This is a multi-line comment.
 * It can span multiple lines.
 * All the text between its opening and closing symbols is ignored by the compiler.
 *
 */
```

Un **Javadoc comment** è simile a un **multiline comment**, tranne per il fatto che inizia con `/**`: tutto il testo compreso tra i simboli di apertura e chiusura viene elaborato dallo strumento Javadoc per generare la documentazione delle API.

```java
/**
 * This is a Javadoc comment
 *
 * This class represents a Person.
 * It stores a name and provides methods
 * to set and retrieve it.
 *
 * <p>Javadoc comments can include HTML tags,
 * and special annotations like @param and @return.</p>
 */
```

!!! warning
    In Java, ogni block comment deve essere chiuso correttamente con `*/`.

- Esempio:

```java
/* valid block comment */
```

va bene, ma

```java
/* */ */
```

produrrà un errore di compilazione perché, mentre i primi due simboli fanno parte del commento, l’ultimo no. Il simbolo extra `*/` non è sintassi valida, quindi il compilatore segnalerà il problema.

---

<a id="23-modificatori-di-accesso"></a>
## 2.3 Modificatori di accesso

In Java, un **access modifier** è una keyword che specifica la visibilità (o accessibilità) di una **class**, **method** o **field**. 
Questo modificatore determina quali altre classi possono usare o vedere quel particolare elemento.

!!! note
    **Tabella dei modificatori di accesso disponibili in Java**

| Token / Identifier | Category | Meaning | Optional? |
| --- | --- | --- | --- |
| public | Keyword / access modifier | Visibile da qualsiasi classe in qualunque package | Sì |
| no modifier (default) | Keyword / access modifier | Visibile solo all’interno dello stesso package | Sì |
| protected | Keyword / access modifier | Visibile nello stesso package e dalle sottoclassi (anche in altri package) | Sì |
| private | Keyword / access modifier | Visibile solo all’interno della stessa classe | Sì |

!!! tip
    **private > default > protected > public**
    La “visibilità si amplia" secondo questo schema.

---

<a id="24-package"></a>
## 2.4 Package

I **package Java** sono raggruppamenti logici di classi, interfacce e sotto-package.  
Aiutano a organizzare codebase grandi, evitare conflitti di nomi e fornire accesso controllato tra parti diverse di un’applicazione.

<a id="241-organizzazione-e-scopo"></a>
### 2.4.1 Organizzazione e scopo

- I nomi dei package seguono le stesse regole dei nomi di variabile. Vedi [Regole di naming Java](naming-rules.md).
- I package sono come **cartelle** per il codice sorgente Java.  
- Permettono di raggruppare classi correlate (ad esempio tutte le utility in `java.util`, tutte le classi di rete in `java.net`).  
- Usando i package puoi evitare **conflitti di nomi**; ad esempio, puoi avere due classi chiamate `Date`, ma una è `java.util.Date` e l’altra è `java.sql.Date`.

<a id="242-mappatura-con-il-file-system-e-dichiarazione-di-un-package"></a>
### 2.4.2 Mappatura con il file system e dichiarazione di un package

- I package corrispondono direttamente alla **gerarchia di directory** sul file system.
- Il package va dichiarato all’inizio del file sorgente (**prima di qualsiasi import**).
- Se non dichiari un package, la classe appartiene al package di default.
  - Questo non è raccomandato nei progetti reali, perché rende più complicate l’organizzazione e gli import.

- Esempio:

```java
package com.example.myapp.utils;

public class MyApp{

}
```

!!! important
    Questa dichiarazione ci dice che la classe appartiene al package `com.example.myapp.utils` e che il suo file deve trovarsi nel path fisico: **com/example/myapp/utils/MyApp.java**

<a id="243-appartenere-allo-stesso-package"></a>
### 2.4.3 Appartenere allo stesso package

Due classi appartengono allo stesso package se e solo se:

- Sono dichiarate con la stessa istruzione `package` all’inizio del rispettivo file sorgente.
- Sono collocate nella stessa directory della gerarchia dei sorgenti.

- Esempio:

Una classe nel package `A.B.C` appartiene solo a `A.B.C`, non a `A.B`.  
Le classi in `A.B` non possono accedere direttamente ai membri **package-private** delle classi in `A.B.C`, perché si tratta di package diversi.

Le classi nello stesso package:

- Possono accedere ai membri `package-private` l’una dell’altra (cioè membri senza modificatore di accesso esplicito).
- Condividono lo stesso namespace, quindi non si ha bisogno di importarle per poterle usare.

Esempio: Due file nello stesso package

```java
// File: src/com/example/tools/Tool.java
package com.example.tools;

public class Tool {
    static void hello() { System.out.println("Hi!"); }
}
```

```java
// File: src/com/example/tools/Runner.java
package com.example.tools;

public class Runner {
    public static void main(String[] args) {
        Tool.hello();    // OK: stesso package, nessun import necessario
    }
}
```

<a id="244-importare-da-un-package"></a>
### 2.4.4 Importare da un package

Per usare classi da un altro package, si deve importarle:

- Esempio:

```java
import java.util.List;       // importa una specifica classe
import java.util.*;          // importa tutte le classi in java.util

import java.nio.file.*.*     // ERROR! solo una wildcard è permessa e deve comparire alla fine!
```

!!! note
    Il carattere wildcard `*` importa tutti i tipi nel package, ma non i sotto-package.

Nel codice comunque, puoi sempre usare il nome completo (fully qualified name) della classe invece di importare tutte le classi del package:

```java
java.util.List myList = new java.util.ArrayList<>();
```

!!! note
    Se importi esplicitamente un nome di classe, questo ha precedenza su qualsiasi import con wildcard;
    
    Se vuoi usare due classi con lo stesso nome (ad esempio `Date` da `java.util` e da `java.sql`), è piu prudente usare una import con nome completamente qualificato.

<a id="245-import-statici"></a>
### 2.4.5 Import statici

Oltre a importare classi da un package, Java permette un altro tipo di import: lo **static import**.
  
Uno *static import* ti consente di importare i **membri statici** di una classe — come `metodi statici` e `variabili statiche` — in modo da poterli usare **senza dover specificare il nome della classe**.

Puoi importare membri statici **specifici** oppure usare una **wildcard** per importare tutti i membri statici di una particolare classe.

Esempio — Static import specifico

```java
import static java.util.Arrays.asList;   // Imports Arrays.asList()

public class Example {

    List<String> arr = asList("first", "second");
    // Puoi invocare asList() direttamente, senza usare Arrays.asList()
}
```

Esempio — Static import di una costante

```java
import static java.lang.Math.PI;
import static java.lang.Math.sqrt;

public class Circle {
    double radius = 3;

    double area = PI * radius * radius;
    double diagonal = sqrt(2); 
}
```

Esempio — Static import con wildcard

```java
import static java.lang.Math.*;

public class Calculator {
    double x = sqrt(49);   // 7.0
    double y = max(10, 20); 
    double z = random();   // invoca Math.random()
}
```

Gli static import con wildcard si comportano esattamente come gli import normali con wildcard:  
portano in scope **tutti i membri statici** della classe.

!!! warning
    Puoi **sempre** chiamare un membro statico usando il nome della classe:
    `Math.sqrt(16)` funziona sempre — anche se è stato importato staticamente.

<a id="2451-regole-di-precedenza"></a>
#### 2.4.5.1 Regole di precedenza

Se la classe corrente dichiara già un metodo o una variabile con lo stesso nome di quella importata staticamente:

- Il **membro locale ha la precedenza**.
- Il membro statico importato viene **oscurato** (shadowing).

Esempio:

```java
import static java.lang.Math.max;

public class Test {

    static int max(int a, int b) {   // versione locale
        return a > b ? a : b;
    }

    void run() {
        System.out.println(max(2, 5));  
        // Chiama il max() LOCALE, non Math.max()
    }
}
```

!!! warning
    Uno static import deve sempre seguire l’esatta sintassi: `import static`.
    
    Il compilatore proibisce di importare **due membri statici con lo stesso simple name** se questo crea ambiguità — anche se provengono da classi o package diversi.

Esempio — **Non consentito**:

```java
import static java.util.Collections.emptyList;

import static java.util.List.of;
import static java.util.Set.of;
// ❌ ERROR: entrambi hanno lo stesso nome di metodo `of()`
```

Il compilatore non sa quale `of()` si intenda usare → errore di compilazione.

!!! tip
    - Se due static import introducono lo stesso nome, **qualsiasi tentativo di usare quel nome provoca un errore di compilazione**.
    - Gli static import **non** importano le classi, solo i membri statici.  
    - Puoi sempre chiamare il membro statico usando il nome della classe, anche se lo hai importato staticamente.

Esempio:

```java
import static java.lang.Math.sqrt;

double a = sqrt(16);        // importato
double b = Math.sqrt(25);   // fully qualified — sempre permesso
```

<a id="246-package-standard-vs-package-definiti-dallutente"></a>
### 2.4.6 Package standard vs package definiti dall’utente

- **Package standard**: forniti con il JDK (ad esempio `java.lang`, `java.util`, `java.io`).
- **Package definiti dall’utente**: creati dagli sviluppatori per organizzare il codice dell’applicazione.

---

<a id="25-il-metodo-main"></a>
## 2.5 Il metodo `main`

In Java, il metodo `main` funge da **punto di ingresso** di un’applicazione standalone. 
 
La sua dichiarazione corretta è fondamentale perché la JVM possa riconoscerlo.

<a id="251-firma-del-metodo-main"></a>
### 2.5.1 Firma del metodo main

Analizziamo la firma del metodo `main` all’interno di due delle classi tra le più semplici possibili:

- Esempio: senza modificatori opzionali

```java
public class MainFirstExample {

    public static void main(String[] args){

        System.out.print("Hello World!!");

    }

}
```

- Esempio: con entrambi i modificatori opzionali `final`

```java
public class MainSecondExample {

    public final static void main(final String options[]){

        System.out.print("Hello World!!");

    }

}
```

!!! note
    **Tabella dei modificatori per il metodo main**

| Token / Identifier | Category | Meaning | Optional? |
| --- | --- | --- | --- |
| `public` | Keyword / Access Modifier | Rende il metodo accessibile da qualunque punto. Necessario perché la JVM possa chiamarlo dall’esterno della classe. | Mandatory |
| `static` | Keyword | Indica che il metodo appartiene alla classe stessa e può essere chiamato senza creare un oggetto. Necessario perché la JVM non ha un’istanza quando avvia il programma. | Mandatory |
| `final` (before return type) | Modifier | Impedisce che il metodo venga sovrascritto (overridden). Può comparire legalmente prima del tipo di ritorno, ma non ha effetti pratici su `main` e non è richiesto. | Optional |
| `main` | Method name (predefined) | Il nome esatto che la JVM cerca come punto di ingresso del programma. Deve essere scritto esattamente `main` (minuscolo). | Mandatory |
| `void` | Return Type / Keyword | Dichiara che il metodo non restituisce alcun valore alla JVM. | Mandatory |
| `String[] args` | Parameter list | Array di `String` che contiene gli argomenti da riga di comando passati al programma. Può essere scritto anche come `String args[]` o `String... args`. Il nome del parametro (`args`) è arbitrario. | Mandatory (il tipo del parametro è richiesto, il nome può variare) |
| `final (in parameter)` | Modifier | Indica che il parametro non può essere riassegnato all’interno del metodo (non puoi riassegnare `args` a un altro array). | Optional |

!!! important
    I modificatori `public`, `static` (obbligatori) e `final` (se presente) possono essere scambiati d’ordine; `public` e `static` **non possono essere omessi**.
    
    Java considera `String[] args` e `String... args` equivalenti.  
    Entrambe le firme compilano e funzionano correttamente come punti di ingresso.

---

<a id="26-compilare-ed-eseguire-il-codice"></a>
## 2.6 Compilare ed eseguire il codice

Questa sezione mostra l'uso dei comandi `javac` e `java` per i casi più comuni in Java 21: file singoli, più file, package, directory di output separate, uso di classpath/module-path.

Segui i layout delle directory esattamente.

> check your tools

```bash
javac -version   # output atteso: javac 21.x
java  -version   # output atteso: java version "21.0.7" ... (l'output potrebbe variare a seconda della jvm in uso)
```

!!! warning
    Quando esegui una classe all’interno di un package, **java richiede il nome completamente qualificato**, MAI il path:
    
    `java com.example.app.Main` ✔  
    `java src/com/example/app/Main` ❌

<a id="261-compilare-un-file-package-di-default-singola-directory"></a>
### 2.6.1 Compilare un file, package di default (singola directory)

**File**
```text
.
└── Hello.java
```

**Hello.java**
```java
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, Java 21!");
    }
}
```

**Compilare (nella stessa directory)**

```bash
javac Hello.java
```

Questo comando creerà, nella stessa directory, un file con lo stesso nome del file ".java" ma con estensione ".class"; questo è il file di bytecode che verrà interpretato ed eseguito dalla JVM.

Una volta che hai il file `.class`, in questo caso `Hello.class`, puoi eseguire il programma con:

**Esecuzione**

```bash
java Hello
```

!!! important
    Non devi specificare l’estensione ".class" quando esegui il programma.

<a id="262-più-file-package-di-default-singola-directory"></a>
### 2.6.2 Più file, package di default (singola directory)

**File**
```text
.
├── A.java
└── B.java
```

**Compilare tutto**
```bash
javac *.java
```

Oppure, se le classi appartengono a uno specifico package:

```bash
javac packagex/*.java
```

Oppure specificando singolarmente:

```bash
javac A.java B.java
```

e

```bash
javac packagex/A.java packagey/B.java
```

**Eseguire il punto di ingresso del programma**: la classe che contiene un metodo `main`

```bash
java A    # se A ha main(...)
# oppure
java B
```

!!! important
    Il path verso le classi è, in Java, il **classpath**. Puoi specificare il **classpath** con una delle seguenti opzioni:
    
    - `-cp <classpath>`  
    - `-classpath <classpath>`  
    - `--class-path <classpath>`

<a id="263-codice-dentro-package-layout-standard-src--out"></a>
### 2.6.3 Codice dentro package (layout standard src → out)

**File**
```text
.
├── src/
│   └── com/
│       └── example/
│           └── app/
│               └── Main.java
└── out/
```

!!! note
    Le cartelle `src` e `out` non fanno parte dei nostri package: sono solo le directory che contengono tutti i file sorgenti e i file `.class` compilati.

**Main.java**

```java
package com.example.app;

public class Main {
    public static void main(String[] args) {
        System.out.println("Packages done right.");
    }
}
```

**Compilare nella stessa directory**

```bash
# Crea il file .class accanto al file sorgente
javac src/com/example/app/Main.java
```

<a id="264-compilare-verso-unaltra-directory--d"></a>
### 2.6.4 Compilare verso un’altra directory (`-d`)

L’opzione `-d out` colloca i file `.class` compilati nella directory `out/`, creando sottocartelle che rispecchiano i nomi dei package:

```bash
javac -d out -sourcepath src src/com/example/app/Main.java
```

**Eseguire (usa il classpath puntando a out/)**

```bash
# Unix/macOS
java -cp out com.example.app.Main

# Windows
java -cp out com.example.app.Main
```

<a id="265-più-file-su-più-package-compilare-lintero-albero-sorgente"></a>
### 2.6.5 Più file su più package (compilare l’intero albero sorgente)

**File**
```text
.
├── src/
│   └── com/
│       └── example/
│           ├── util/
│           │   └── Utils.java
│           └── app/
│               └── Main.java
└── out/
```

**Compilare l’intero albero sorgente in `out/`**

```bash
# Opzione A: indicare a javac i package di livello più alto
javac -d out   src/com/example/util/Utils.java   src/com/example/app/Main.java

# Opzione B: usare -sourcepath per far trovare a javac le dipendenze
javac -d out -sourcepath src   src/com/example/app/Main.java
```

!!! important
    `-sourcepath <sourcepath>` dice a `javac` dove cercare altri file `.java` da cui i sorgenti dipendono.

<a id="266-esecuzione-di-un-singolo-sorgente-run-veloce-senza-javac"></a>
### 2.6.6 Esecuzione di un singolo sorgente (run veloce senza `javac`)

Java 21 (a partire da Java 11) permette di eseguire piccoli programmi direttamente dal sorgente:

```bash
# Solo package di default
java Hello.java
```

Sono consentiti più file sorgente se si trovano nel **package di default** e nella **stessa directory**:

```bash
java Main.java Helper.java
```

> Se usi i **package**, è preferibile compilare in `out/` ed eseguire con `-cp`.

<a id="267-passare-parametri-a-un-programma-java"></a>
### 2.6.7 Passare parametri a un programma Java

Puoi inviare dati al tuo programma Java attraverso i parametri del punto di ingresso `main`.

Come abbiamo visto, il metodo `main` può ricevere un array di stringhe nella forma: **`String[] args`**. Vedi [la sezione sul main](#251-firma-del-metodo-main).

**Main.java che stampa due parametri ricevuti in ingresso dal metodo `main`:**

```java
package com.example.app;

public class Main {
    public static void main(String[] args) {
        System.out.println(args[0]);
        System.out.println(args[1]);
    }
}
```

Per passare i parametri, ti basta scrivere (per esempio):

```bash
java Main.java Hello World  # spaces are used to separate the two arguments
```

Se vuoi passare un argomento contenente spazi, usa le virgolette:

```bash
java Main.java Hello "World Mario" # spaces are used to separate the two arguments
```

> Se dichiari di usare (in questo caso stampare) i primi due elementi dell’array di parametri (come nel nostro esempio), ma in realtà passi meno argomenti, la JVM ti segnalerà il problema con una `java.lang.ArrayIndexOutOfBoundsException`.  

> Se, al contrario, passi più argomenti di quelli che il metodo usa, verranno semplicemente utilizzati (in questo caso) solo i primi due.  

> `args.length` ti dice quanti argomenti sono stati forniti.
