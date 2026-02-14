# 37. Java Platform Module System (JPMS)

### Indice

- [37. Java Platform Module System (JPMS)](#37-java-platform-module-system-jpms)
  - [37.1 Perché i moduli sono stati introdotti](#371-perché-i-moduli-sono-stati-introdotti)
    - [37.1.1 Problemi con il classpath](#3711-problemi-con-il-classpath)
    - [37.1.2 Esempio di un problema di classpath](#3712-esempio-di-un-problema-di-classpath)
  - [37.2 Che cos’è un modulo](#372-che-cosè-un-modulo)
    - [37.2.1 Proprietà fondamentali dei moduli](#3721-proprietà-fondamentali-dei-moduli)
    - [37.2.2 Modulo vs package vs JAR](#3722-modulo-vs-package-vs-jar)
  - [37.3 Il descrittore module-infojava](#373-il-descrittore-module-infojava)
    - [37.3.1 Descrittore di modulo minimo](#3731-descrittore-di-modulo-minimo)
  - [37.4 Struttura delle directory di un modulo](#374-struttura-delle-directory-di-un-modulo)
  - [37.5 Un primo programma modulare](#375-un-primo-programma-modulare)
    - [37.5.1 Classe principale](#3751-classe-principale)
    - [37.5.2 Descrittore del modulo](#3752-descrittore-del-modulo)
  - [37.6 Spiegazione dell’incapsulamento forte](#376-spiegazione-dellincapsulamento-forte)
  - [37.7 Sintesi delle idee chiave](#377-sintesi-delle-idee-chiave)

---

Il `Java Platform Module System` (**JPMS**) è stato introdotto in Java 9.

È un meccanismo a livello di linguaggio e a livello di runtime per strutturare le applicazioni Java in unità fortemente incapsulate chiamate `moduli`.

JPMS influenza come il codice viene:
- organizzato
- compilato
- collegato
- impacchettato
- caricato a runtime

Comprendere JPMS è essenziale per il Java moderno, specialmente per grandi applicazioni, librerie, immagini di runtime e strumenti di deployment.

## 37.1 Perché i moduli sono stati introdotti

Prima di Java 9, le applicazioni Java erano costruite usando solo:
- `packages`
- file `JAR`
- il `classpath`

Questo modello aveva limitazioni serie man mano che le applicazioni crescevano.

### 37.1.1 Problemi con il classpath

Il classpath è una lista piatta di JAR in cui:
- tutte le classi pubbliche sono accessibili a tutti
- non esiste una dichiarazione affidabile delle dipendenze
- le versioni in conflitto sono comuni
- l’incapsulamento è debole o inesistente
- classi duplicate si sovrascrivono silenziosamente in base all’ordine del classpath


Questo ha portato a problemi ben noti come:
- “JAR hell”
- bug di ordinamento del classpath
- uso accidentale di API interne
- errori di runtime che non venivano rilevati in fase di compilazione

### 37.1.2 Esempio di un problema di classpath

Supponiamo che due librerie dipendano da versioni diverse dello stesso JAR di terze parti.

Solo una versione può essere messa sul classpath.

Quale viene scelta dipende solamente dall’ordine del classpath, non dalla appropriatezza effettiva.

!!! note
    Questo problema non può essere risolto in modo affidabile con il solo strumento del classpath.

---

## 37.2 Che cos’è un modulo?

Un `modulo` è un’unità di codice nominata e auto-descrittiva.

In sintesi, un modulo è una collezione di uno o più package correlati, insieme a un file descrittore del modulo che ne definisce esplicitamente le sue dipendenze e le funzionalità che rende disponibili.  

Un modulo offre quindi a chi lo utilizza un complesso ben definito e controllato di funzionalità.

Ogni modulo nominato ha un nome unico che lo identifica al compilatore e al sistema dei moduli.


Dichiara esplicitamente:
- da cosa dipende
- cosa espone agli altri moduli
- cosa mantiene nascosto

Un modulo è più forte di un package e più strutturato di un JAR.

### 37.2.1 Proprietà fondamentali dei moduli

| Proprietà | Descrizione |
| --- | --- |
| Incapsulamento forte | I package sono nascosti di default |
| Dipendenze esplicite | Le dipendenze devono essere dichiarate |
| Configurazione affidabile | Dipendenze mancanti causano errori precoci |
| Identità nominata | Ogni modulo ha un nome unico |

### 37.2.2 Modulo vs package vs JAR

| Concetto | Scopo | Incapsulamento |
| --- | --- | --- |
| Package | Raggruppamento di namespace | Debole (public ancora visibile) |
| JAR     | Impacchettamento / deployment | Nessuno (tutte le classi visibili quando sul classpath) |
| Modulo  | Incapsulamento + unità di dipendenza | Forte (package non esportati nascosti) |

---

## 37.3 Il descrittore `module-info.java`

Ogni `modulo nominato` è definito da un file descrittore del modulo chiamato:

```text
module-info.java
```

Questo file descrive il modulo al compilatore e al runtime.

### 37.3.1 Descrittore di modulo minimo

Un descrittore di modulo minimo dichiara solo il nome del modulo. Il nome del file deve essere esattamente `module-info.java`, e deve trovarsi nella root dell’albero dei sorgenti del modulo.


```java
module com.example.hello {
}
```

!!! note
    **Un modulo senza direttive non esporta nulla e non dipende da nulla**.

---

## 37.4 Struttura delle directory di un modulo

Un progetto modulare segue un layout standard di directory.

Il descrittore del modulo si trova alla root dell’albero dei sorgenti del modulo.

```text
src/
└─ com.example.hello/
	├─ module-info.java
	└─ com/
		└─ example/
			└─ hello/
				└─ Main.java
```

Punti chiave:
- Il **nome della directory corrisponde al nome del modulo**
- `module-info.java` è in cima alla root dei sorgenti del modulo
- i package seguono le regole standard di naming Java

!!! note
    Nei progetti IDE e build-tool, la struttura dei file può differire (ad es. Maven usa `src/main/java`).
    Ciò che resta sempre vero: `module-info.java` sta nella root dell’albero dei sorgenti del modulo e i percorsi dei package seguono il naming standard Java.

---

## 37.5 Un primo programma modulare

Creiamo un’applicazione modulare minima.

### 37.5.1 Classe principale

```java
package com.example.hello;

public class Main {
	public static void main(String[] args) {
		System.out.println("Hello, modular world!");
	}
}
```

### 37.5.2 Descrittore del modulo

```java
module com.example.hello {
	exports com.example.hello;
}
```

La `direttiva exports` rende il package accessibile ad altri moduli.

Senza di essa, il package è incapsulato e inaccessibile.

---

## 37.6 Spiegazione dell’incapsulamento forte

In `JPMS`, i package NON sono accessibili di default.

Anche le classi public sono nascoste a meno che non siano esportate esplicitamente.

Nei moduli, `public` significa “public verso altri moduli *solo se* il package contenitore è esportato.”


| Situazione | Accessibile da un altro modulo? |
|-----------|----------------------------------|
| Classe public in package non esportato  | No |
| Classe public in package esportato | Sì |
| Membro protected in package esportato | Sì, ma solo via ereditarietà (non accesso generale) |
| Classe/membro package-private (qualsiasi package) | No |
| Membro private | No |


!!! note
    Questa è una differenza fondamentale rispetto al modello basato sul classpath.

---

## 37.7 Sintesi delle idee chiave

- `JPMS` introduce i moduli come unità forti di incapsulamento
- Le dipendenze sono esplicite e verificate
- `module-info.java` è il descrittore centrale
- I package sono nascosti a meno che non siano esportati
- La visibilità basata su classpath non si applica più nei moduli
- La visibilità public non è più sufficiente: le export del modulo controllano l’accessibilità
