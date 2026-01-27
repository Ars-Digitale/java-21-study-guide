# 6. Istanziazione dei tipi

### Indice

- [6. Istanziazione dei tipi](#6-istanziazione-dei-tipi)
  - [6.1 Introduzione](#61-introduzione)
    - [6.1.1 Gestione dei tipi primitivi](#611-gestione-dei-tipi-primitivi)
      - [6.1.1.1 Dichiarare un primitivo](#6111-dichiarare-un-primitivo)
      - [6.1.1.2 Assegnare un primitivo](#6112-assegnare-un-primitivo)
    - [6.1.2 Gestione dei tipi reference](#612-gestione-dei-tipi-reference)
      - [6.1.2.1 Creare e assegnare un reference](#6121-creare-e-assegnare-un-reference)
      - [6.1.2.2 Costruttori](#6122-costruttori)
      - [6.1.2.3 Blocchi di inizializzazione-istanza](#6123-blocchi-di-inizializzazione-istanza)
  - [6.2 Inizializzazione predefinita delle variabili](#62-inizializzazione-predefinita-delle-variabili)
    - [6.2.1 Variabili di istanza e di classe](#621-variabili-di-istanza-e-di-classe)
    - [6.2.2 Variabili final di istanza](#622-variabili-final-di-istanza)
    - [6.2.3 Variabili locali](#623-variabili-locali)
      - [6.2.3.1 Inferire i tipi con var](#6231-inferire-i-tipi-con-var)
  - [6.3 Tipi wrapper](#63-tipi-wrapper)
    - [6.3.1 Scopo dei tipi wrapper](#631-scopo-dei-tipi-wrapper)
    - [6.3.2 Autoboxing e unboxing](#632-autoboxing-e-unboxing)
    - [6.3.3 Parsing e conversione](#633-parsing-e-conversione)
    - [6.3.4 Metodi di supporto](#634-metodi-di-supporto)
    - [6.3.5 Valori null](#635-valori-null)
  - [6.4 Uguaglianza in Java](#64-uguaglianza-in-java)
    - [6.4.1 Uguaglianza con i tipi primitivi](#641-uguaglianza-con-i-tipi-primitivi)
      - [6.4.1.1 Punti chiave](#6411-punti-chiave)
    - [6.4.2 Uguaglianza con i tipi reference](#642-uguaglianza-con-i-tipi-reference)
      - [6.4.2.1 Confronto di identità](#6421--confronto-di-identità)
      - [6.4.2.2 equals Confronto logico](#6422-equals-confronto-logico)
      - [6.4.2.3 Punti chiave](#6423-punti-chiave)
  - [6.4.3 String Pool e uguaglianza](#643-string-pool-e-uguaglianza)
      - [6.4.3.1 Il metodo intern](#6431-il-metodo-intern)
    - [6.4.4 Uguaglianza con i tipi wrapper](#644-uguaglianza-con-i-tipi-wrapper)
    - [6.4.5 Uguaglianza e null](#645-uguaglianza-e-null)
    - [6.4.6 Tabella riepilogativa](#646-tabella-riepilogativa)

---


## 6.1 Introduzione
 
In Java, un **tipo** può essere un **tipo primitivo** (come `int`, `double`, `boolean`, ecc.) oppure un **tipo reference** (classi, interfacce, array, enum, record, ecc.). Vedi: [Java Data Types and Casting](data-types.md)

Il modo in cui vengono create le istanze dipende dalla categoria del tipo:

- **Tipi primitivi**  
  Le istanze dei tipi primitivi vengono create semplicemente dichiarando una variabile.  
  La JVM alloca automaticamente la memoria per contenere il valore e non è necessaria alcuna keyword esplicita. 
  
```java
int age = 30;         // crea un int primitivo con valore 30
boolean flag = true;  // crea un boolean primitivo con valore true
double pi = 3.14159;  // crea un double primitivo con valore 3.14159
```
  
- **Tipi reference (oggetti)**  
	Le istanze dei tipi classe vengono create usando la keyword `new` (eccetto alcuni casi speciali come i letterali String, i record con costruttori canonici, o i metodi factory).
	La keyword `new` alloca memoria nell’heap e invoca un costruttore della classe.
  
```java
String name = new String("Alice"); // crea esplicitamente un nuovo oggetto String
Person p = new Person();           // crea un nuovo oggetto Person usando il suo costruttore
```
  
È anche comune affidarsi a letterali o metodi factory per la creazione degli oggetti.
  
```java
String name = new String("Alice"); // crea esplicitamente un nuovo oggetto String
Person p = new Person();           // crea un nuovo oggetto Person usando il suo costruttore
```

> [!IMPORTANT]
> I letterali String **non richiedono `new`** e sono memorizzati nello **String pool**.
> Usare `new String("x")` crea sempre un nuovo oggetto nell’heap.

  
### 6.1.1 Gestione dei tipi primitivi

#### 6.1.1.1 Dichiarare un primitivo

**Dichiarare** un tipo primitivo (come per i tipi reference) significa riservare spazio in memoria per una variabile di un determinato tipo, senza necessariamente assegnarle un valore.  

> [!WARNING]
> A differenza dei primitivi, la cui dimensione dipende dal tipo specifico (es. `int` vs `long`), i tipi reference occupano sempre la stessa dimensione fissa in memoria — ciò che varia è la dimensione dell’oggetto a cui puntano.

- Esempi di sintassi (solo dichiarazione):

```java
int number;

boolean active;

char letter;

int x, y, z;          // Dichiarazioni multiple in un’unica istruzione: Java consente di dichiarare più variabili dello stesso tipo
```


> [!IMPORTANT]
> I modificatori e il tipo dichiarati all’inizio di una dichiarazione di variabili si applicano a tutte le variabili dichiarate in quella stessa istruzione.
>
> **Eccezione**: quando si dichiarano array usando le parentesi quadre dopo il nome della variabile, le parentesi fanno parte del dichiaratore della singola variabile, non del tipo base.


- Esempi

```java
static int a, b, c;

// è equivalente a:

static int a;
static int b;
static int c;


int[] a, b;   // entrambi sono arrays di int
int c[], d;   // solo c è un array, d è un normale int
```

#### 6.1.1.2 Assegnare un primitivo

**Assegnare** un tipo primitivo (come per i tipi reference) significa memorizzare un valore in una variabile dichiarata di quel tipo.
  
Per i primitivi, la variabile contiene il valore stesso; per i tipi reference, la variabile contiene l’indirizzo di memoria (un reference) dell’oggetto puntato.

- Esempi di sintassi:

```java
int number;  					// Dichiarazione di un int: variabile chiamata "number"

number = 10;  					// Assegnazione del valore 10 a questa variabile

char letter = 'A';    			// Dichiarazione e assegnazione in un’unica istruzione: dichiarazione e assegnazione possono essere combinate 

int a1, a2;                      // Dichiarazioni multiple  

int a = 1, b = 2, c = 3;  		// Dichiarazioni multiple e assegnazioni

char b1, b2, b3 = 'C';			// Dichiarazioni miste (2 dichiarazioni + 1 assegnazione)

double d1, double d2;            // ERROR - NOT LEGAL

int v1; v2; 					 // ERROR - NOT LEGAL
```
  
> [!IMPORTANT]
> Quando scrivi un numero direttamente nel codice (un letterale numerico), Java assume per default che sia di tipo **int**.  
> Se il valore non entra in un `int`, il codice non compila a meno che non sia marcato esplicitamente con il suffisso corretto.

- Esempio di sintassi per un letterale numerico:

```java
long exNumLit = 5729685479; // ❌ Does not compile.
						  // Even though the value would fit in a long,
						  // a plain numeric literal is assumed to be an int,
						  // and this number is too large for int.

Changing the declaration adding the correct suffix (L or l) will solve:

long exNumLit = 5729685479L;

or

long exNumLit = 5729685479l;
```
  
**Dichiarare** un tipo `reference` significa riservare spazio in memoria per una variabile che conterrà un reference (puntatore) a un oggetto del tipo specificato.
  
A questo stadio non viene ancora creato alcun oggetto — la variabile ha solo la potenzialità di puntarne uno.

> [!WARNING]
> A differenza dei primitivi, la cui dimensione dipende dal tipo specifico (es. `int` vs `long`), le variabili reference occupano sempre la stessa dimensione fissa in memoria (sufficiente per memorizzare un reference).  
> Ciò che varia è la dimensione dell’oggetto puntato, che viene allocato separatamente nell’heap.

- Esempi di sintassi (solo dichiarazione):

```java
String name;
Person person;
List<Integer> numbers;

Person p1, p2, p3;   // Dichiarazioni multiple in un’unica istruzione

String a = "abc", b = "def", c = "ghi";  	// Dichiarazioni multiple e assegnazioni

String b1, b2, b3 = "abc"					// Dichiarazioni miste (b1, b2) con una assegnazione (b3)

String d1, String d2;         			// ERROR - NOT LEGAL

String v1; v2; 							// ERROR - NOT LEGAL
```


### 6.1.2 Gestione dei tipi reference

#### 6.1.2.1 Creare e assegnare un reference

**Assegnare** un tipo `reference` significa memorizzare nella variabile l’indirizzo di memoria di un oggetto.

Questo si fa normalmente dopo la creazione dell’oggetto con la keyword **new** e un costruttore, oppure usando un letterale o un metodo factory.

Un reference può anche essere assegnato a un altro oggetto dello stesso tipo o di tipo compatibile.

I tipi reference possono anche essere assegnati a **null**, il che significa che non faranno riferimento ad alcun oggetto.

- Esempi di sintassi:

```java
Person person = new Person(); // Esempio con 'new' e un costruttore 'Person()':
							// 'new Person()' crea un nuovo oggetto Person nell’heap
							// e restituisce il suo reference, che viene memorizzato nella variabile 'person'.

String greeting = "Hello";	 // Esempio con letterale (per String).

List<Integer> numbers = List.of(1, 2, 3);   // Esempio con un metodo factory.
```
  
#### 6.1.2.2 Costruttori

Nell’esempio, **`Person()`** è un costruttore — un tipo speciale di metodo usato per inizializzare nuovi oggetti.
  
Ogni volta che chiami `new Person()`, il costruttore viene eseguito e imposta la nuova istanza creata.

**I costruttori hanno tre caratteristiche principali:**

- Il nome del costruttore **deve corrispondere esattamente al nome della classe** (case-sensitive).  
- I costruttori **non dichiarano un tipo di ritorno** (nemmeno `void`).  
- Se non definisci alcun costruttore nella tua classe, il compilatore fornisce automaticamente un **costruttore di default senza argomenti** che non fa nulla.

> [!WARNING]
> Se vedi un metodo che ha lo stesso nome della classe **ma dichiara anche un tipo di ritorno**, **non** è un costruttore.  
> È semplicemente un metodo normale (anche se iniziare i nomi dei metodi con una lettera maiuscola va contro le convenzioni di naming in Java).

Lo **scopo di un costruttore** è inizializzare lo stato di un oggetto appena creato — tipicamente assegnando valori ai suoi campi, con valori di default oppure usando parametri passati al costruttore.

- Esempio 1: Costruttore di default (senza parametri)
							 
```java
public class Person {
    String name;
    int age;

    // Default constructor
    public Person() {
        name = "Unknown";
        age = 0;
    }
}

Person p1 = new Person(); // name = "Unknown", age = 0
```

- Esempio 2: Costruttore con parametri

```java
public class Person {
    String name;
    int age;

    // Constructor with parameters
    public Person(String newName, int newAge) {
        name = newName;
        age = newAge;
    }
}

Person p2 = new Person("Alice", 30); // name = "Alice", age = 30
```

- Esempio 3: Costruttori multipli (overloading dei costruttori)

```java
public class Person {
    String name;
    int age;

    // Default constructor
    public Person() {
        this("Unknown", 0); // calls the other constructor
    }

    // Constructor with parameters
    public Person(String newName, int newAge) {
        name = newName;
        age = newAge;
    }
}

Person p1 = new Person();            // name = "Unknown", age = 0
Person p2 = new Person("Bob", 25);   // name = "Bob", age = 25
```

> [!IMPORTANT]
> - I costruttori non sono ereditati: se una superclasse definisce costruttori, non sono automaticamente disponibili nella sottoclasse — devi dichiararli esplicitamente.
> - Se dichiari un qualsiasi costruttore in una classe, il compilatore non genera il costruttore di default senza argomenti: se ti serve ancora un costruttore senza argomenti, devi dichiararlo manualmente.

#### 6.1.2.3 Blocchi di inizializzazione istanza

Oltre ai costruttori, Java offre un meccanismo chiamato **initializer blocks** per l'inizializzazione degli oggetti.  

Sono blocchi di codice all’interno di una classe, racchiusi tra `{ }`, che vengono eseguiti **ogni volta che viene creata un’istanza**, subito prima dell’esecuzione del corpo del costruttore.

**Caratteristiche**
- Chiamati anche **instance initializer blocks**.  
- Eseguiti, insieme agli initializer dei campi, nell’ordine in cui appaiono nella definizione della classe ma sempre prima dei costruttori.    
- Utili quando più costruttori devono condividere un codice comune di inizializzazione.

Esempio: usare un Instance Initializer Block

```java
public class Person {
    String name;
    int age;

    // Instance initializer block
    {
        System.out.println("Instance initializer block executed");
        age = 18; // default age for every Person
    }

    // Default constructor
    public Person() {
        name = "Unknown";
    }

    // Constructor with parameters
    public Person(String newName) {
        name = newName;
    }
}

Person p1 = new Person();          // prints "Instance initializer block executed"
Person p2 = new Person("Alice");   // prints "Instance initializer block executed"
```

> [!NOTE]
> In questo esempio, il blocco di inizializzazione viene eseguito prima del corpo di entrambi i costruttori.
> Sia p1 che p2 partiranno con age = 18, indipendentemente da quale costruttore viene usato.

**Blocchi di inizializzazione multipli**: se una classe contiene più initializer blocks, essi vengono eseguiti nell’ordine in cui compaiono nel file sorgente:

- Esempio: 

```java
public class Example {
    {
        System.out.println("First block");
    }

    {
        System.out.println("Second block");
    }
}

Example ex = new Example();
// Output:
// First block
// Second block
```

> [!NOTE]
> I blocchi di inizializzazione d’istanza sono meno comuni nella pratica, perché una logica simile può spesso essere messa direttamente nei costruttori.
> È importante sapere che:
> - Vengono sempre eseguiti prima del corpo del costruttore.
> - Sono eseguiti nell’ordine di dichiarazione nella classe.
> - Possono essere combinati con i costruttori per evitare duplicazioni di codice.

> [!WARNING]
> **Ordine di inizializzazione quando si crea un oggetto**
> 1. Campi statici
> 2. Blocchi di inizializzazione statici
> 3. Campi di istanza
> 4. Blocchi di inizializzazione d’istanza
> 5. Corpo del costruttore

---

## 6.2 Inizializzazione predefinita delle variabili

### 6.2.1 Variabili di istanza e di classe

- Una **variabile di istanza (un field)** è un valore definito all’interno di un’istanza di un oggetto;
- Una **variabile di classe** (definita con la keyword **static**) è definita a livello di classe ed è condivisa tra tutti gli oggetti (istanze della classe)

Se non inizializzate, variabili di istanza e di classe ricevono un valore di default dal compilatore.

- Tabella dei valori di default per variabili di istanza e di classe:

| Type | Default Value |
| --- | --- |
| Object | null |
| Numeric | 0 |
| boolean | false |
| char | '\u0000' (NUL) |


### 6.2.2 Variabili final di istanza

A differenza delle normali variabili di istanza e di classe, le variabili **`final` non vengono inizializzate di default dal compilatore**. 
 
Una variabile `final` **deve essere assegnata esplicitamente esattamente una volta**, altrimenti il codice non compila.

Questo vale sia per:
- **variabili final di istanza**
- **variabili di classe static final**

> [!NOTE]
> Possiamo assegnare un valore `null` a una variabile final di istanza o di classe, purché venga impostato esplicitamente.

Java impone questa regola perché una variabile `final` rappresenta un valore che deve essere *noto e fissato* prima dell’uso.


<ins>**`Final Instance Variables`**</ins>

Una **variabile final di istanza** deve essere assegnata **esattamente una volta**, e l’assegnazione deve avvenire in *una* delle seguenti modalità:

1. **Nel punto di dichiarazione**
2. **In un blocco di inizializzazione d’istanza**
3. **All’interno di ogni costruttore**

Se la classe ha *più costruttori*, la variabile deve essere assegnata in **tutti**.

- Esempio:
```java
public class Person {
    final int id;   // deve essere assegnata prima che il costruttore termini
    String name;

    // Costruttore 1
    public Person(int id, String name) {
        this.id = id;        // ok
        this.name = name;
    }

    // Costruttore 2
    public Person() {
        this.id = 0;         // richiesto anche qui
        this.name = "Unknown";
    }
}
```

> [!WARNING]
> Provare a compilare senza assegnare `id` dentro **ogni** costruttore produce un errore a compile-time:
> variable id might not have been initialized

<ins>**Variabili di classe `static final` (Costanti)**</ins>

Una **variabile static final** appartiene alla classe, non a una specifica istanza.  

Deve anch’essa essere assegnata esattamente una volta, ma l’assegnazione può avvenire in uno dei seguenti punti:

1. **Nel punto di dichiarazione**
2. **Dentro un blocco di inizializzazione statico**

- Esempio:
```java
public class AppConfig {

    static final int TIMEOUT = 5000;    // assegnata nella dichiarazione

    static final String VERSION;        // assegnata nel blocco static

    static {
        VERSION = "1.0.0";              // ok
    }
}
```

Tentare di assegnare una `static final` in un costruttore non è consentito.


<ins>**Regole chiave per i campi `final`**</ins>

| Scenario | Allowed? | Notes |
| --- | --- | --- |
| Assign at declaration | ✔ | Most common pattern |
| Assign in constructor | ✔ | All constructors must assign it |
| Assign in instance initializer | ✔ | Before constructor body runs |
| Assign in static initializer (static final only) | ✔ | For class-level constants |
| Assign multiple times | ❌ | Compilation error |
| Default initialization | ❌ | Must be explicitly assigned |

Esempio di situazione **illegale**:
```java
public class Example {
    final int x;        // non inizializzata
}

Example e = new Example(); // ❌ compile-time error
```

<ins>**Perché le variabili `final` non vengono inizializzate di default?**</ins>

Perché:
- Il loro valore deve essere **noto e immutabile**, e
- Java deve garantire che il valore sia impostato **prima dell’uso**,
- L’inizializzazione di default creerebbe una situazione in cui `0`, `null`, o `false` potrebbero diventare involontariamente il valore permanente.

Per questo Java costringe gli sviluppatori a inizializzare esplicitamente i campi `final`.

> [!TIP]
> `final` significa **assegnato una volta**, non **oggetto immutabile**.
>   
> Un reference final può comunque puntare a un oggetto mutabile.

```java
final List<String> list = new ArrayList<>();
list.add("ok");      // consentito
list = new ArrayList<>(); // ❌ non puoi riassegnare il reference
```

### 6.2.3 Variabili locali

Le **variabili locali** sono variabili definite all’interno di un costruttore, di un metodo o di un blocco di inizializzazione;

Le variabili locali non hanno valori di default e devono essere inizializzate prima di poter essere usate. Se provi a usare una variabile locale non inizializzata, il compilatore segnalerà un ERRORE.

- Esempio 

```java
public int localMethod {
   
	int firstVar = 25;
	int secondVar;
	secondVar = 35;
	int firstSum = firstVar + secondVar;    // OK: entrambe le variabili sono inizializzate prima dell’uso
	
	int thirdVar;
	int secondSum = firstSum + thirdVar;    // ERROR: la variabile thirdVar non è stata inizializzata prima dell’uso; se non provi a usare thirdVar il compilatore non segnalerà nulla
}
```

#### 6.2.3.1 Inferire i tipi con var

In certe condizioni puoi usare la keyword **var** al posto del tipo appropriato quando dichiari variabili **locali**;

> [!WARNING]
> - **var** NON è una parola riservata in Java;
> - **var** può essere usata solo per variabili locali: NON può essere usata per **parametri del costruttore**, **variabili di istanza** o **parametri dei metodi**;
> - Il compilatore inferisce il tipo guardando SOLO il codice **sulla riga della dichiarazione**; una volta inferito il tipo, non puoi riassegnare a un altro tipo.

- Esempio

```java
public int localMethod {
   
	var inferredInt = 10; 	// Il compilatore inferisce int dal contesto
	inferredInt = 25; 		// OK
	
	inferredInt = "abcd";   // ERROR: il compilatore ha già inferito il tipo della variabile come int
	
	var notInferred;
	notInferred = 30;		// ERROR: per inferire il tipo, il compilatore guarda SOLO la riga con la dichiarazione
	
	var first, second = 15; // ERROR: var non può essere usata per definire due variabili nella stessa istruzione
	
	var x = null;           // ERROR: var non può essere inizializzata con null ma può essere riassegnata a null purché il tipo sottostante sia un tipo reference.
}
```

> [!WARNING]
> Le variabili locali **non** ricevono mai valori di default.
> Le variabili di istanza e di classe (static) **sì**, sempre.

---

## 6.3 Tipi wrapper

In Java, i **tipi wrapper** sono rappresentazioni a oggetti degli otto tipi primitivi. 
 
Ogni primitivo ha una corrispondente classe wrapper nel package `java.lang`:

| Primitive | Wrapper Class |
| --- | --- |
| `byte` | `Byte` |
| `short` | `Short` |
| `int` | `Integer` |
| `long` | `Long` |
| `float` | `Float` |
| `double` | `Double` |
| `char` | `Character` |
| `boolean` | `Boolean` |

**Gli oggetti wrapper sono immutabili** — una volta creati, il loro valore non può cambiare.

### 6.3.1 Scopo dei tipi wrapper
- Consentono di usare i primitivi in contesti che richiedono oggetti (es. collezioni, generics).  
- Forniscono metodi di utilità per parsing, conversione e manipolazione dei valori.  
- Supportano costanti come `Integer.MAX_VALUE` o `Double.MIN_VALUE`.  

### 6.3.2 Autoboxing e unboxing
Da Java 5, il compilatore converte automaticamente tra primitivi e wrapper:
- **Autoboxing**: primitivo → wrapper  
- **Unboxing**: wrapper → primitivo  

```java
Integer i = 10;       // autoboxing: int → Integer
int n = i;            // unboxing: Integer → int

Integer int1 = Integer.valueOf(11);
long long1 = int1;  // Unboxing --> implicit cast OK

Long long2 = 11;   // ❌ Does not compile. 
                   // 11 is an int literal → requires autoboxing + widening → illegal

Character char1 = null;
char char2 = char1;  // WARNING: NullPointerException

Integer	 arr1 = {11.5, 13.6}  // WARNING: Does not compile!!
Double[] arr2 = {11, 22};     // WARNING: Does not compile!!
```

> [!TIP]
> Java **non** esegue mai `autoboxing + widening/narrowing` in un solo passo.

> [!WARNING]
> - **AUTOBOXING** e **cast implicito** non sono consentiti nella stessa istruzione: non puoi fare entrambe le cose contemporaneamente. (vedi esempio sopra)
> - Questa regola vale anche nelle chiamate ai metodi.

### 6.3.3 Parsing e conversione

I wrapper forniscono metodi statici per convertire stringhe o altri tipi in primitivi:

```java
int x = Integer.parseInt("123");    // returns primitive int
Integer y = Integer.valueOf("456"); // returns Integer object
double d = Double.parseDouble("3.14");

// On the numeric wrapper class valueOf() throws a NumberFormatException on invalid input.
// Example:

Integer w = Integer.valueOf("two"); // NumberFormatException

// On Boolean, the method returns Boolean.TRUE for any value that matches "true" ignoring case, otherwise Boolean.false
// Example:

Boolean.valueOf("true"); 	// true
Boolean.valueOf("TrUe"); 	// true
Boolean.valueOf("TRUE"); 	// true
Boolean.valueOf("false");	// false
Boolean.valueOf("FALSE");	// false
Boolean.valueOf("xyz");		// false
Boolean.valueOf(null);		// false

// The numeric integral classes Byte, Short, Integer and Long include an overloaded **valueOf(String str, int base)** method which takes a base value
// Example with base 16 (hexadecimal) which includes character 0 -> 9 and A -> F (ignore case)

Integer.valueOf("6", 16);	// 6
Integer.valueOf("a", 16);	// 10
Integer.valueOf("A", 16);	// 10
Integer.valueOf("F", 16);	// 15
Integer.valueOf("G", 16);	// NumberFormatException
```

> [!NOTE]
> I metodi **parseXxx()** restituiscono un primitivo mentre **valueOf()** restituisce un oggetto wrapper.

### 6.3.4 Metodi di supporto

Tutte le classi wrapper numeriche estendono la classe `Number` e, per questo, ereditano alcuni metodi di supporto come: `byteValue()`, `shortValue()`, `intValue()`, `longValue()`, `floatValue()`, `doubleValue()`.

Le classi wrapper `Boolean` e `Character` includono: `booleanValue()` e `charValue()`.

- Esempio:

```java

// In trying to convert those helper methods can result in a loss of precision.

Double baseDouble = Double.valueOf("300.56");

Double wrapDouble = baseDouble.doubleValue();
System.out.println("baseDouble.doubleValue(): " + wrapDouble);  // 300.56

Byte wrapByte = baseDouble.byteValue();
System.out.println("baseDouble.byteValue(): " + wrapByte);		// 44  -> There is no 300 in byte

Integer wrapInt = baseDouble.intValue();
System.out.println("baseDouble.intValue(): " + wrapInt);		// 300 -> The value is truncated
```

### 6.3.5 Valori null

A differenza dei primitivi, i tipi wrapper possono contenere **null**.  
Tentare di fare unboxing di null causa una `NullPointerException`:

```java
Integer val = null;
int z = val; // ❌ NullPointerException at runtime
```

---

## 6.4 Uguaglianza in Java

Java fornisce due meccanismi distinti per verificare l’uguaglianza:

- `==` (operatore di uguaglianza)
- `.equals()` (metodo definito in `Object` e ridefinito in molte classi)

Capirne la differenza è essenziale.


### 6.4.1 Uguaglianza con i tipi primitivi

Per i **valori primitivi** (`int`, `double`, `char`, `boolean`, ecc.),  
l’operatore `==` confronta il loro reale **valore numerico o booleano**.

Esempio:
```java
int a = 5;
int b = 5;
System.out.println(a == b);     // true

char c1 = 'A';
char c2 = 65;                   // stesso code point Unicode
System.out.println(c1 == c2);   // true
```

#### 6.4.1.1 Punti chiave
- `==` esegue un **confronto di valori** per i primitivi.
- I tipi primitivi **non** hanno un metodo `.equals()`.
- Tipi primitivi misti seguono le **regole di promozione** numerica  
  (es. `int == long` → `int` promosso a `long`).


### 6.4.2 Uguaglianza con i tipi reference

Con gli oggetti (tipi reference), il significato di `==` cambia.

#### 6.4.2.1 `==` (Confronto di identità)  
`==` verifica se **due riferimenti puntano allo stesso oggetto in memoria**.

```java
String s1 = new String("Hi");
String s2 = new String("Hi");

System.out.println(s1 == s2);      // false → oggetti diversi
```

Anche se i contenuti sono identici, `==` è false a meno che entrambe le variabili non si riferiscano  
**allo stesso identico oggetto**.


#### 6.4.2.2 `.equals()` (Confronto logico)  
Molte classi ridefiniscono `.equals()` per confrontare i **valori**, non gli indirizzi di memoria.

```java
System.out.println(s1.equals(s2)); // true → stesso contenuto
```

#### 6.4.2.3 Punti chiave
- `.equals()` è definito in `Object`.
- Se una classe *non* ridefinisce `.equals()`, si comporta come `==`.
- Classi come `String`, `Integer`, `List`, ecc. ridefiniscono `.equals()`  
  per fornire un confronto di valori significativo.


### 6.4.3 String Pool e uguaglianza

I letterali String sono memorizzati nello **String pool**, quindi letterali identici che
si riferiscono **allo stesso oggetto**.

```java
String a = "Java";
String b = "Java";
System.out.println(a == b);       // true → stesso literal nello pool
```

Ma usare `new` crea un oggetto diverso:

```java
String x = new String("Java");
String y = "Java";

System.out.println(x == y);       // false → x non è nello pool
System.out.println(x.equals(y));  // true
```

Errori comuni

```java
String x = "Java string literal";
String y = " Java string literal".trim();

System.out.println(x == y);       // false → x e y non sono lo stesso a compile-time

String a = "Java string literal";
String b = "Java ";
b += "string literal";

System.out.println(a == b);  // false
```

> [!WARNING]
> Qualsiasi String creata a **runtime** *non* entra nel pool automaticamente.
> Usa `intern()` se si vuole il pooling.

> [!TIP]
> `"Hello" == "Hel" + "lo"` → true (costante a compile-time)
> 
> `"Hello" == getHello()` → false (concatenazione a runtime)

```java
String x = "Hello";
String y = "Hel" + "lo";   // compile-time → stesso literal
String z = "Hel";
z += "lo";                 // runtime → nuova String

System.out.println(x == y); // true
System.out.println(x == z); // false
```

#### 6.4.3.1 Il metodo intern

Puoi anche dire a Java di usare una String dallo String Pool (nel caso esista già) tramite il metodo `intern()`:

```java
String x = "Java";
String y = new String("Java").intern();

System.out.println(x == y);       // true
```

### 6.4.4 Uguaglianza con i tipi wrapper

Le classi wrapper (`Integer`, `Double`, ecc.) si comportano come oggetti:

- `==` → confronta i riferimenti  
- `.equals()` → confronta i valori  

Tuttavia, alcuni wrapper vengono **cache-ati** (Integer da −128 a 127):

```java
Integer a = 100;
Integer b = 100;
System.out.println(a == b);        // true → cached

Integer c = 1000;
Integer d = 1000;
System.out.println(c == d);        // false → non cached

System.out.println(c.equals(d));   // true → stesso valore numerico
```

> [!WARNING]
> Fai molta attenzione alla cache dei wrapper.


### 6.4.5 Uguaglianza e `null`

- `== null` è sempre sicuro.
- Chiamare `.equals()` su un reference `null` genera una `NullPointerException`.

```java
String s = null;
System.out.println(s == null);   // true
// s.equals("Hi");               // ❌ NullPointerException
```

### 6.4.6 Tabella riepilogativa

| Comparison | Primitives | Objects / Wrappers | Strings |
| --- | --- | --- | --- |
| `==` | compares **value** | compares **reference** | identity (affected by String pool) |
| `.equals()` | N/A | compares **content** if overridden | **content** comparison |
