# 17. Oltre le Classi

### Indice

- [17. Oltre le Classi](#17-oltre-le-classi)
  - [17.1 Interfacce](#171-interfacce)
    - [17.1.1 Cosa Possono Contenere le Interfacce](#1711-cosa-possono-contenere-le-interfacce)
    - [17.1.2 Implementare un’Interfaccia](#1712-implementare-uninterfaccia)
    - [17.1.3 Ereditarietà Multipla](#1713-ereditarietà-multipla)
    - [17.1.4 Ereditarietà delle Interfacce e Conflitti](#1714-ereditarietà-delle-interfacce-e-conflitti)
    - [17.1.5 Metodi default](#1715-metodi-default)
    - [17.1.6 Metodi static](#1716-metodi-static)
    - [17.1.7 Metodi private nelle interfacce](#1717-metodi-private-nelle-interfacce)
  - [17.2 Tipi sealed, non-sealed e final](#172-tipi-sealed-non-sealed-e-final)
    - [17.2.1 Regole](#1721-regole)
  - [17.3 Enum](#173-enum)
    - [17.3.1 Definizione di Enum Semplice](#1731-definizione-di-enum-semplice)
    - [17.3.2 Enum Complesse con Stato e Comportamento](#1732-enum-complesse-con-stato-e-comportamento)
    - [17.3.3 Metodi delle Enum](#1733-metodi-delle-enum)
    - [17.3.4 Regole](#1734-regole)
  - [17.4 Record (Java 16+)](#174-record-java-16)
    - [17.4.1 Costruttore Lungo](#1741-costruttore-lungo)
    - [17.4.2 Costruttore Compatto](#1742-costruttore-compatto)
    - [17.4.3 Pattern Matching per i Record](#1743-pattern-matching-per-i-record)
    - [17.4.4 Nested Record Patterns e Matching dei Record con var e Generics](#1744-nested-record-patterns-e-matching-dei-record-con-var-e-generics)
      - [17.4.4.1 Nested Record Pattern di Base](#17441-nested-record-pattern-di-base)
      - [17.4.4.2 Nested Record Patterns con var](#17442-nested-record-patterns-con-var)
      - [17.4.4.3 Nested Record Patterns e Generics](#17443-nested-record-patterns-e-generics)
      - [17.4.4.4 Errori Comuni con i Nested Record Patterns](#17444-errori-comuni-con-i-nested-record-patterns)
  - [17.5 Classi Annidate in Java](#175-classi-annidate-in-java)
    - [17.5.1 Static Nested Classes](#1751-static-nested-classes)
      - [17.5.1.1 Sintassi e Regole di Accesso](#17511-sintassi-e-regole-di-accesso)
      - [17.5.1.2 Errori Comuni](#17512-errori-comuni)
    - [17.5.2 Inner Classes (Non-Static Nested Classes)](#1752-inner-classes-non-static-nested-classes)
      - [17.5.2.1 Sintassi e Regole di Accesso](#17521-sintassi-e-regole-di-accesso)
      - [17.5.2.2 Errori Comuni](#17522-errori-comuni)
    - [17.5.3 Classi Locali](#1753-classi-locali)
      - [17.5.3.1 Caratteristiche](#17531-caratteristiche)
      - [17.5.3.2 Errori Comuni](#17532-errori-comuni)
    - [17.5.4 Classi Anonime](#1754-classi-anonime)
      - [17.5.4.1 Sintassi e Utilizzo](#17541-sintassi-e-utilizzo)
      - [17.5.4.2 Classe Anonima che Estende una Classe](#17542-classe-anonima-che-estende-una-classe)
    - [17.5.5 Confronto dei Tipi di Classi Annidate](#1755-confronto-dei-tipi-di-classi-annidate)

---

Questo capitolo presenta diversi meccanismi avanzati di tipo (type) oltre il design della Classe in Java: **interfacce**, **enum**, **classi sealed / non-sealed**, **record** e **classi annidate**.

## 17.1 Interfacce

Un’**interfaccia** in Java è un tipo di riferimento che definisce un contratto di metodi che una classe accetta di implementare.

Un `interface` è implicitamente `abstract` e non può essere marcato come `final`: come per le classi top-level, un’interfaccia può dichiarare visibilità come `public` o `default` (package-private).

Una classe Java può implementare un numero qualsiasi di interfacce tramite la keyword `implements`.

Un `interface` può a sua volta estendere più interfacce usando la keyword `extends`.

Le interfacce abilitano astrazione, accoppiamento lasco e ereditarietà multipla di tipo.

### 17.1.1 Cosa Possono Contenere le Interfacce

- **Metodi astratti** (implicitamente `public` e `abstract`)
- **Metodi concreti**
	- **Metodi default** (includono codice e sono implicitamente `public`)
	- **Metodi static** (dichiarati come `static`, includono codice e sono implicitamente `public`)
	- **Metodi private** (Java 9+) per riuso interno
- **Costanti** → implicitamente `public static final` e inizializzate alla dichiarazione

```java
interface Calculator {

    int add(int a, int b);                 // abstract
	
    default int mult(int a, int b) {       // default method
        return a * b;
    }
	
    static double pi() { return 3.14; }    // static method
}
```

> [!WARNING]
> Poiché i metodi astratti delle interfacce sono implicitamente `public`, **non puoi** ridurre il livello di accesso su un metodo di implementazione.

### 17.1.2 Implementare un’Interfaccia

```java
class BasicCalc implements Calculator {
    public int add(int a, int b) { return a + b; }
}
```

> [!NOTE]
> **Ogni** metodo astratto deve essere implementato a meno che la classe non sia astratta essa stessa.

### 17.1.3 Ereditarietà Multipla

Una classe può implementare più interfacce.

```java
interface A { void a(); }
interface B { void b(); }

class C implements A, B {
    public void a() {}
    public void b() {}
}
```

### 17.1.4 Ereditarietà delle Interfacce e Conflitti

Se due interfacce forniscono metodi `default` con la stessa signature, la classe che implementa deve fare override del metodo.

```java
interface X { default void run() { } }
interface Y { default void run() { } }

class Z implements X, Y {
    public void run() { } // mandatory
}
```

Se vuoi comunque accedere a una particolare implementazione del metodo `default` ereditato, puoi usare la seguente sintassi:

```java
interface X { default int run() { return 1; } }
interface Y { default int run() { return 2; } }

class Z implements X, Y {

    public int useARun(){
		return Y.super.run();
	}
	
}
```

### 17.1.5 Metodi `default`

Un metodo `default` (dichiarato con la keyword `default`) è un metodo che definisce un’implementazione e può essere sovrascritto da una classe che implementa l’interfaccia.

- Un metodo default include codice ed è implicitamente `public`;
- Un metodo default non può essere `abstract`, `static` o `final`;
- Come visto appena sopra, se due interfacce forniscono metodi default con la stessa signature, la classe che implementa deve fare override del metodo;
- Una classe che implementa può naturalmente basarsi sull’implementazione fornita del metodo `default` senza sovrascriverlo;
- Il metodo `default` può essere invocato su un’istanza della classe che implementa e NON come metodo `static` dell’interfaccia contenitore;

### 17.1.6 Metodi `static`

- Un’interfaccia può fornire `static methods` (tramite la keyword `static`) che sono implicitamente `public`;
- I metodi static devono includere un corpo del metodo e sono accessibili usando il nome dell’interfaccia;
- I metodi static non possono essere `abstract` o `final`;

### 17.1.7 Metodi `private` nelle interfacce

Tra tutti i metodi concreti che un’interfaccia può implementare, abbiamo anche:

- **Metodi `private`**: visibili solo all’interno dell’interfaccia dichiarante e che possono essere invocati solo da un contesto `non-static` (metodi `default` o altri `non-static private methods`).
- **Metodi `private static`**: visibili solo all’interno dell’interfaccia dichiarante e che possono essere invocati da qualsiasi metodo dell’interfaccia contenitore.

---


## 17.2 Tipi sealed, non-sealed e final

Le classi e le interfacce `sealed` (Java 17+) restringono quali altre classi (o interfacce) possono estenderle o implementarle.

Un `sealed type` è dichiarato mettendo il modificatore `sealed` subito prima della keyword class (o interface), e aggiungendo, dopo il nome del Tipo, la keyword `permits` seguita dalla lista dei tipi che possono estenderlo (o implementarlo).

```java
public sealed class Shape permits Circle, Rectangle { }

final class Circle extends Shape { }

non-sealed class Rectangle extends Shape { }
```

### 17.2.1 Regole

- Un tipo sealed deve dichiarare tutti i sottotipi permessi.
- Un sottotipo permesso deve essere **final**, **sealed** o **non-sealed**; poiché le interfacce non possono essere final, possono essere marcate solo `sealed` o `non-sealed` quando estendono un’interfaccia sealed.
- I tipi sealed devono essere dichiarati nello stesso package (o modulo nominato) dei loro sottotipi diretti.

---


## 17.3 Enum

Le **enum** definiscono un insieme fisso di valori costanti.

Le `enum` possono dichiarare `attributi`, `costruttori` e `metodi` come le classi regolari ma **non possono essere estese**.

La lista dei valori dell’enum deve terminare con un punto e virgola `(;)` nel caso di `Enum Complesse`, ma questo non è obbligatorio per `Enum Semplici`.

### 17.3.1 Definizione di Enum `Semplice`

```java
enum Day { MON, TUE, WED, THU, FRI, SAT, SUN } // punto e virgola omesso
```


### 17.3.2 Enum `Complesse` con Stato e Comportamento

```java
enum Level {
    LOW(1), MEDIUM(5), HIGH(10); // punto e virgola obbligatorio
	
    private int code; 
	
    Level(int code) { this.code = code; }
	
    public int getCode() { return code; }
}

public static void main(String[] args) {
	Level.MEDIUM.getCode();		// invoking a method
}
```

### 17.3.3 Metodi delle Enum

- `values()` – restituisce un array di tutti i valori costanti che possono essere usati, per esempio, in un ciclo `for-each`
- `valueOf(String)` – restituisce la costante per nome
- `ordinal()` – indice (int) della costante

### 17.3.4 Regole

- I costruttori delle enum sono implicitamente `private`;
- Le enum possono contenere metodi `static` e `instance`;
- Le enum possono implementare `interfaces`;

---


## 17.4 Record (Java 16+)

Un **record** è una classe speciale progettata per modellare dati immutabili: sono infatti implicitamente **final**.

Non puoi estendere un record, ma è permesso implementare un’interfaccia regolare o sealed.

Fornisce automaticamente:

- **campi private final** per ogni componente
- **costruttore** con parametri nello stesso ordine della dichiarazione del record;
- **getters** (con nome degli attributi)
- **`equals()`, `hashCode()`, `toString()`**: è inoltre permesso fare override di questi metodi
- I **Record** possono includere `nested classes`, `interfaces`, `records`, `enums` e `annotations`

```java
public record Point(int x, int y) { }

var element = new Point(11, 22);

System.out.println(element.x);
System.out.println(element.y);
```

Se ti serve validazione o trasformazione aggiuntiva dei campi forniti, puoi definire un `costruttore lungo` o un `costruttore compatto`.


### 17.4.1 Costruttore Lungo

```java
public record Person(String name, int age) {

    public Person (String name, int age){
        if (age < 0) throw new IllegalArgumentException();
		this.name = name;
		this.age = age;
    }
}
```

Puoi anche definire costruttori in overload, purché alla fine deleghino a quello canonico usando `this(...)`:

```java
public record Point(int x, int y) {

    // Overloaded constructor (NOT canonical)
    public Point(int value) {
        this(value, value); // deve invocare, come prima istruzione, un altro costruttore overloaded e, in ultima istanza, il costruttore canonico.
    }
}
```

> [!NOTE]
> - Il compilatore non inserirà un costruttore se ne fornisci manualmente uno con la stessa lista di parametri nell’ordine definito;
> - In questo caso, devi impostare esplicitamente ogni campo manualmente;

### 17.4.2 Costruttore Compatto

Puoi definire un `costruttore compatto` che imposta implicitamente tutti i campi, permettendoti di eseguire validazioni e trasformazioni su campi specifici.

Java eseguirà il costruttore completo, impostando tutti i campi, dopo che il costruttore compatto è terminato.

```java
public record Person(String name, int age) {

    public Person {
        if (age < 0) throw new IllegalArgumentException();
		
		name = name.toUpperCase(); // This transformation is still (at this level of initialization) on the input parameter.
		
		// this.name = name; // ❌ Does not compile.
    }	
}
```

> [!WARNING]
> - Se provi a modificare un attributo di Record dentro un Costruttore Compatto, il tuo codice non compilerà

### 17.4.3 Pattern Matching per i Record

Quando usi pattern matching con `instanceof` o con `switch`, un record pattern deve specificare:

- Il tipo del record;
- Un pattern per ogni campo del record (corrispondendo al numero corretto di componenti, e tipi compatibili);

Esempio record:

```java
Object obj = new Point(3, 5);

if (obj instanceof Point(int a, int b)) {
    System.out.println(a + b);   // 8
}
```

### 17.4.4 Nested Record Patterns e Matching dei Record con `var` e Generics

I nested record patterns permettono di destrutturare record che contengono altri record o tipi complessi, estraendo valori ricorsivamente direttamente nel pattern stesso.

Combinano la potenza della destrutturazione dei `record` con il pattern matching, dandoti un modo conciso ed espressivo per navigare strutture dati gerarchiche.

#### 17.4.4.1 Nested Record Pattern di Base

Se un record contiene un altro record, puoi destrutturare entrambi in una volta:

```java
record Address(String city, String country) {}
record Person(String name, Address address) {}

void printInfo(Object obj) {

	switch (obj) {
		case Person(String n, Address(String c, String co)) -> System.out.println(n + " lives in " + c + ", " + co);
		default -> System.out.println("Unknown");
	}
}
```

Nell’esempio sopra, il pattern `Person` include un pattern `Address` annidato.

Entrambi sono matchati strutturalmente.

#### 17.4.4.2 Nested Record Patterns con `var`

Invece di specificare tipi esatti per ogni campo, puoi usare `var` dentro il pattern per lasciare al compilatore l’inferenza del tipo.

```java
	switch (obj) {
		case Person(var name, Address(var city, var country)) -> System.out.println(name + " — " + city + ", " + country);
	}
```

`var` nei pattern funziona come `var` nelle variabili locali: significa "inferisci il tipo".

> [!WARNING]
> - Ti serve ancora il tipo del record contenitore (Person, Address); 
> - solo i tipi dei campi possono essere sostituiti con `var`.

#### 17.4.4.3 Nested Record Patterns e Generics

I record patterns funzionano anche con record generici.

```java
record Box<T>(T value) {}
record Wrapper(Box<String> box) {}

static void test(Object o) {
	switch (o) {
		case Wrapper(Box<String>(var v)) -> System.out.println("Boxed string: " + v);
		default -> System.out.println("Something else");
	}
}
```

In questo esempio:

- Il pattern richiede esattamente `Box<String>`, non `Box<Integer>`.
- Dentro il pattern, `var v` cattura il valore generico unboxed.

#### 17.4.4.4 Errori Comuni con i Nested Record Patterns

Struttura record non corrispondente

```java
// ❌ ERROR: pattern does not match record structure
case Person(var n, var city) -> ...
```

`Person` ha 2 campi, ma uno di questi è un record. Devi destrutturare correttamente.

Numero errato di componenti

```java
// ❌ ERROR: Address has 2 components, not 1
case Person(var n, Address(var onlyCity)) -> ...
```

Mismatch generico

```java
// ❌ ERROR: expecting Box<String> but found Box<Integer>
case Wrapper(Box<Integer>(var v)) -> ...
```

Posizionamento illegale di `var`

```java
// ❌ var cannot replace the record type itself
case var(Person(var n, var a)) -> ...
```

> [!NOTE]
> - `var` non può sostituire l’intero pattern, solo i singoli componenti.

---

## 17.5 Classi Annidate in Java

Java supporta diversi tipi di **classi annidate** — classi dichiarate dentro un’altra classe.
  
Sono uno strumento fondamentale per incapsulamento, organizzazione del codice, pattern di event-handling e rappresentazione di gerarchie logiche.
  
Una classe annidata appartiene sempre a una **classe contenitore** e ha regole speciali di accessibilità e istanziazione a seconda della sua categoria.

Java definisce quattro tipi di classi annidate:

- **Static Nested Classes** – dichiarate con `static` dentro un’altra classe.
- **Inner Classes** (non-static nested classes).
- **Local Classes** – dichiarate dentro un blocco (metodo, costruttore o initializer).
- **Anonymous Classes** – classi senza nome create inline, di solito per fare override di un metodo o implementare un’interfaccia.

### 17.5.1 Static Nested Classes

Una **static nested class** si comporta come una classe top-level con namespace dentro la sua classe contenitore.  
Non **può** accedere ai membri d’istanza della classe esterna ma **può** accedere ai membri statici.  
Non mantiene un riferimento a un’istanza della classe contenitore.

#### 17.5.1.1 Sintassi e Regole di Accesso

- Dichiarata usando `static class` dentro un’altra classe.
- Può accedere solo ai membri **static** della classe esterna.
- Non ha un riferimento implicito all’istanza contenitore.
- Può essere istanziata senza un’istanza esterna.

```java
class Outer {
    static int version = 1;

    static class Nested {
        void print() {
            System.out.println("Version: " + version); // OK: accessing static member
        }
    }
}

class Test {
    public static void main(String[] args) {
        Outer.Nested n = new Outer.Nested(); // No Outer instance required
        n.print();
    }
}
```

#### 17.5.1.2 Errori Comuni

- Le static nested classes **non possono accedere alle variabili d’istanza**:

```java
class Outer {
    int x = 10;
    static class Nested {
        void test() {
            // System.out.println(x); // ❌ Compile error
        }
    }
}
```

### 17.5.2 Inner Classes (Non-Static Nested Classes)

Una **inner class** è associata a un’istanza della classe esterna e può accedere a **tutti i membri** della classe esterna, inclusi quelli **private**.

#### 17.5.2.1 Sintassi e Regole di Accesso

- Dichiarata senza `static`.
- Ha un riferimento implicito all’istanza contenitore.
- Può accedere sia ai membri statici sia ai membri d’istanza della classe esterna.
- Poiché non è statica, deve essere creata tramite un’istanza della classe contenitore.

```java
class Outer {
    private int value = 100;

    class Inner {
        void print() {
            System.out.println("Value = " + value); // OK: accessing private
        }
    }

    void make() {
        Inner i = new Inner(); // OK inside the outer class
        i.print();
    }
}

class Test {
    public static void main(String[] args) {
        Outer o = new Outer();
        Outer.Inner i = o.new Inner(); // MUST be created from an instance
        i.print();
    }
}
```

#### 17.5.2.2 Errori Comuni

- Le inner classes **non possono dichiarare membri statici** eccetto **static final constants**.

```java
class Outer {
    class Inner {
        // static int x = 10;     // ❌ Compile error
        static final int OK = 10; // ✔ Allowed (constant)
    }
}
```

> [!WARNING]
> - Istanziare una inner class SENZA un’istanza esterna è illegale.

### 17.5.3 Classi Locali

Una **classe locale** è una classe annidata definita dentro un blocco — più comunemente un metodo.
  
Non ha modificatori di accesso ed è visibile solo dentro il blocco in cui è dichiarata.

#### 17.5.3.1 Caratteristiche

- Dichiarata dentro un metodo, costruttore o initializer.
- Può accedere ai membri della classe esterna.
- Può accedere a variabili locali se sono **effectively final**.
- Non può dichiarare membri statici (eccetto static final constants).

```java
class Outer {
    void compute() {
        int base = 5; // must be effectively final

        class Local {
            void show() {
                System.out.println(base); // OK
            }
        }

        new Local().show();
    }
}
```

#### 17.5.3.2 Errori Comuni

- `base` deve essere effectively final; cambiarla rompe la compilazione.

```java
void compute() {
    int base = 5;
    base++; // ❌ Now base is NOT effectively final
    class Local {}
}
```

### 17.5.4 Classi Anonime

Una **classe anonima** è una classe one-off creata inline, di solito per implementare un’interfaccia o fare override di un metodo senza nominare una nuova classe.

#### 17.5.4.1 Sintassi e Utilizzo

- Creata usando `new` + tipo + body.
- Non può avere costruttori (nessun nome).
- Spesso usata per event handling, callbacks, comparators.

```java
Runnable r = new Runnable() {
    @Override
    public void run() {
        System.out.println("Anonymous running");
    }
};
```

#### 17.5.4.2 Classe Anonima che Estende una Classe

```java
Button b = new Button("Click");
b.onClick(new ClickHandler() {
    @Override
    public void handle() {
        System.out.println("Handled!");
    }
});
```

### 17.5.5 Confronto dei Tipi di Classi Annidate

Una tabella rapida che riassume tutti i tipi di classi annidate.

| Tipo | Ha un’Istanza Esterna? | Può Accedere ai Membri d’Istanza Esterna? | Può Avere Membri Statici? | Uso Tipico |
|------------------- | ------------------- | ---------------------------------- | ------------------------- | --------------------------- |
| Static Nested | No | No | Sì | Namespacing, helpers |
| Inner Class | Sì | Sì | No (eccetto costanti) | Comportamento legato all’oggetto |
| Local Class | Sì | Sì | No | Classi temporanee con scope |
| Anonymous Class | Sì | Sì | No | Personalizzazione inline |
