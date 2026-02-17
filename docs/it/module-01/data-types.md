# 4. Tipi di dato Java e casting

<a id="indice"></a>
### Indice

- [4. Tipi di dato Java e casting](#4-tipi-di-dato-java-e-casting)
  - [4.1 Tipi primitivi](#41-tipi-primitivi)
  - [4.2 Tipi reference](#42-tipi-reference)
  - [4.3 Tabella dei tipi primitivi](#43-tabella-dei-tipi-primitivi)
  - [4.4 Note](#44-note)
  - [4.5 Riepilogo](#45-riepilogo)
  - [4.6 Aritmetica e promozione numerica dei primitivi](#46-aritmetica-e-promozione-numerica-dei-primitivi)
    - [4.6.1 Regole di promozione numerica in Java](#461-regole-di-promozione-numerica-in-java)
      - [4.6.1.1 Regola 1 – Tipi misti → il tipo più piccolo viene promosso a quello più grande](#4611-regola-1--tipi-misti--il-tipo-più-piccolo-viene-promosso-a-quello-più-grande)
      - [4.6.1.2 Regola 2 – Integrale + floating-point → l’integrale viene promosso a floating-point](#4612-regola-2--integrale--floating-point--lintegrale-viene-promosso-a-floating-point)
      - [4.6.1.3 Regola 3 – byte, short e char vengono promossi a int durante l’aritmetica](#4613-regola-3--byte-short-e-char-vengono-promossi-a-int-durante-laritmetica)
      - [4.6.1.4 Regola 4 – Il tipo del risultato coincide con il tipo promosso](#4614-regola-4--il-tipo-del-risultato-coincide-con-il-tipo-promosso)
    - [4.6.2 Riepilogo del comportamento di promozione numerica](#462-riepilogo-del-comportamento-di-promozione-numerica)
      - [4.6.2.1 Punti chiave](#4621-punti-chiave)
  - [4.7 Casting in Java](#47-casting-in-java)
    - [4.7.1 Casting dei primitivi](#471-casting-dei-primitivi)
      - [4.7.1.1 Widening implicit casting](#4711-widening-implicit-casting)
      - [4.7.1.2 Narrowing explicit casting](#4712-narrowing-explicit-casting)
      - [4.7.1.3 Narrowing Implicito a Compile-Time](#4713-narrowing-implicito-a-compile-time)
    - [4.7.2 Perdita di dati, overflow e underflow](#472-perdita-di-dati-overflow-e-underflow)
    - [4.7.3 Casting di valori vs. variabili](#473-casting-di-valori-vs-variabili)
    - [4.7.4 Casting di reference (oggetti)](#474-casting-di-reference-oggetti)
      - [4.7.4.1 Upcasting (widening reference cast)](#4741-upcasting-widening-reference-cast)
      - [4.7.4.2 Downcasting (narrowing reference cast)](#4742-downcasting-narrowing-reference-cast)
    - [4.7.5 Riepilogo dei punti chiave](#475-riepilogo-dei-punti-chiave)
    - [4.7.6 Esempi](#476-esempi)
  - [4.8 Sommario](#48-sommario)

---

Come abbiamo visto in [Mattoni Sintattici di Base](syntax-building-blocks.md), Java ha due categorie di tipi di dato:

- **Primitive types**  
- **Reference types**

👉 Per una panoramica completa dei tipi primitivi con dimensioni, range, valori di default ed esempi, vedi la [Tabella dei tipi primitivi](#43-tabella-dei-tipi-primitivi).

<a id="41-tipi-primitivi"></a>
## 4.1 Tipi primitivi

I `primitive` rappresentano **singoli valori grezzi** memorizzati direttamente in memoria.
  
Ogni tipo primitivo ha una dimensione fissa che determina quanti byte occupa.

Concettualmente, un primitivo è semplicemente una **cella di memoria** che contiene un valore:

```text
+-------+
|  42   |   ← value of type short (2 bytes in memory)
+-------+
```

---

<a id="42-tipi-reference"></a>
## 4.2 Tipi reference

Un tipo `reference` contiene l'indirizzo di memoria di un istanza di un tipo complesso; esso non contiene l’`object` stesso, ma un **reference (puntatore)**, appunto, ad esso.
  
Il reference ha dimensione fissa (dipende dalla JVM, spesso 4 o 8 byte) e punta a una locazione di memoria dove è memorizzato l’oggetto reale.

- Esempio: una variabile reference di tipo `String` punta a un oggetto stringa nello heap, che internamente è composto da un array di primitivi `char`.

Diagramma:

```text
Reference (4 or 8 bytes)
+---------+
| address | ───────────────►  Object in Heap
+---------+                  +-------------------+
                             |   "Hello"         |
                             | ['H','e','l','l','o']  ← array of char
                             +-------------------+
```

---

<a id="43-tabella-dei-tipi-primitivi"></a>
## 4.3 Tabella dei tipi primitivi

| Keyword | Type | Size | Min Value | Max Value | Default Value | Example |
| --- | --- | --- | --- | --- | --- | --- |
| `byte` | 8-bit int | 1 byte | –128 | 127 | 0 | `byte b = 100;` |
| `short` | 16-bit int | 2 bytes | –32,768 | 32,767 | 0 | `short s = 2000;` |
| `int` | 32-bit int | 4 bytes | –2,147,483,648 (`–2^31`) | 2,147,483,647 (`2^31–1`) | 0 | `int i = 123456;` |
| `long` | 64-bit int | 8 bytes | –2^63 | 2^63–1 | 0L | `long l = 123456789L;` |
| `float` | 32-bit FP | 4 bytes | see note | see note | 0.0f | `float f = 3.14f;` |
| `double` | 64-bit FP | 8 bytes | see note | see note | 0.0 | `double d = 2.718;` |
| `char` | UTF-16 | 2 bytes | `'\u0000'` (0) | `'\uffff'` (65,535) | `'\u0000'` | `char c = 'A';` |
| `boolean` | true/false | JVM-dep. (often 1 byte) | `false` | `true` | `false` | `boolean b = true;` |

---

<a id="44-note"></a>
## 4.4 Note

`float` e `double` non hanno limiti interi fissi come i tipi interi.  
Invece, seguono lo standard IEEE 754:

- **Più piccoli valori positivi non nulli**:  
  - `Float.MIN_VALUE ≈ 1.4E–45`  
  - `Double.MIN_VALUE ≈ 4.9E–324`  

- **Valori finiti massimi**:  
  - `Float.MAX_VALUE ≈ 3.4028235E+38`  
  - `Double.MAX_VALUE ≈ 1.7976931348623157E+308`  

Supportano anche valori speciali: **`+Infinity`**, **`-Infinity`** e **`NaN`** (Not a Number).

- **FP** = floating point.  
- La dimensione di `boolean` dipende dalla JVM ma il comportamento logico è semplicemente `true`/`false`.  
- I valori di default si applicano ai **field** (variabili di istanza e di classe).  
  Le **variabili locali** devono essere inizializzate esplicitamente prima dell’uso.

---

<a id="45-riepilogo"></a>
## 4.5 Riepilogo

- **Primitive** = valore reale, memorizzato direttamente in memoria.  
- **Reference** = puntatore a un oggetto; l’oggetto stesso può contenere primitivi e altri reference.  
- Per i dettagli sui primitivi, vedi la [Tabella dei tipi primitivi](#43-tabella-dei-tipi-primitivi).

---

<a id="46-aritmetica-e-promozione-numerica-dei-primitivi"></a>
## 4.6 Aritmetica e promozione numerica dei primitivi

Quando si applicano operatori aritmetici o di confronto ai **tipi primitivi**, Java converte automaticamente (o *promuove*) i valori a tipi compatibili secondo regole ben definite di **numeric promotion**.

Queste regole garantiscono calcoli coerenti e riducono il rischio di perdita di dati quando si mescolano tipi numerici differenti.

<a id="461-regole-di-promozione-numerica-in-java"></a>
### 4.6.1 Regole di promozione numerica in Java

<a id="4611-regola-1--tipi-misti--il-tipo-più-piccolo-viene-promosso-a-quello-più-grande"></a>
#### 4.6.1.1 Regola 1 – Tipi misti → il tipo più piccolo viene promosso a quello più grande

Se due operandi appartengono a **tipi numerici diversi**, Java promuove automaticamente il tipo **più piccolo** al tipo **più grande** prima di eseguire l’operazione.

| Example | Explanation |
| --- | --- |
| `int x = 10; double y = 5.5;`<br>`double result = x + y;` | La variabile `x` di tipo `int` viene promossa a `double`, quindi il risultato è un `double` (`15.5`). |

**Ordine di promozione valido (dal più piccolo al più grande):**  
`byte → short → int → long → float → double`

<a id="4612-regola-2--integrale--floating-point--lintegrale-viene-promosso-a-floating-point"></a>
#### 4.6.1.2 Regola 2 – Intero + floating-point → l’intero viene promosso a floating-point

Se un operando è di tipo **intero** (`byte`, `short`, `char`, `int`, `long`) e l’altro è di tipo **floating-point** (`float`, `double`),  
il valore intero viene **promosso** al tipo **floating-point** prima dell’operazione.

| Example | Explanation |
| --- | --- |
| `float f = 2.5F; int n = 3;`<br>`float result = f * n;` | `n` (int) viene promosso a `float`. Il risultato è un `float` (`7.5`). |
| `double d = 10.0; long l = 3;`<br>`double result = d / l;` | `l` (long) è promosso a `double`. Il risultato è un `double` (`3.333...`). |

<a id="4613-regola-3--byte-short-e-char-vengono-promossi-a-int-durante-laritmetica"></a>
#### 4.6.1.3 Regola 3 – `byte`, `short` e `char` vengono promossi a `int` durante l’aritmetica

Quando effettui operazioni aritmetiche **con variabili** (non costanti letterali) di tipo `byte`, `short` o `char`,  
Java le promuove automaticamente a **`int`**, anche se **entrambi gli operandi sono più piccoli di `int`**.

| Example | Explanation |
| --- | --- |
| `byte a = 10, b = 20;`<br>`byte c = a + b;` | ❌ Errore di compilazione: il risultato di `a + b` è di tipo `int`, non `byte`. Serve il cast → `byte c = (byte)(a + b);` |
| `short s1 = 1000, s2 = 2000;`<br>`short sum = (short)(s1 + s2);` | Gli operandi sono promossi a `int`, quindi è richiesto un cast esplicito per assegnare a `short`. |
| `char c1 = 'A', c2 = 2;`<br>`int result = c1 + c2;` | `'A'` (65) e `2` sono promossi a `int`, risultato = `67`. |

!!! note
    Questa regola si applica quando si usano **variabili**.
    
    Quando si usano **letterali costanti**, il compilatore può a volte valutare l’espressione a compile-time e assegnarla in sicurezza.

```java
byte a = 10 + 20;   // ✅ OK: espressione costante che rientra in byte
byte b = 10;
byte c = 20;
byte d = b + c;     // ❌ Errore: b + c è valutato a runtime → int
```

<a id="4614-regola-4--il-tipo-del-risultato-coincide-con-il-tipo-promosso"></a>
#### 4.6.1.4 Regola 4 – Il tipo del risultato coincide con il tipo promosso

Dopo l’applicazione delle promozioni, quando entrambi gli operandi sono dello stesso tipo,  
il **risultato** dell’espressione avrà quel **medesimo tipo promosso**.

| Example | Explanation |
| --- | --- |
| `int i = 5; double d = 6.0;`<br>`var result = i * d;` | `i` viene promosso a `double`, il risultato è `double`. |
| `float f = 3.5F; long l = 4L;`<br>`var result = f + l;` | `l` viene promosso a `float`, il risultato è `float`. |
| `int x = 10, y = 4;`<br>`var div = x / y;` | Entrambi sono `int`, il risultato è `int` (`2`), la parte frazionaria viene troncata. |

!!! warning
    La divisione tra interi produce sempre un **risultato intero**.
    
    Per ottenere un risultato decimale, **almeno un operando deve essere di tipo floating-point**:

```java
double result = 10.0 / 4; // ✅ 2.5
int result = 10 / 4;      // ❌ 2 (la parte frazionaria è scartata)
```

<a id="462-riepilogo-del-comportamento-di-promozione-numerica"></a>
### 4.6.2 Riepilogo del comportamento di promozione numerica

| Situation | Promotion Result | Example |
| --- | --- | --- |
| Mix di tipi numerici piccoli e grandi | Il tipo più piccolo è promosso a quello più grande | `int + double → double` |
| Integrale + floating-point | L’integrale è promosso a floating-point | `long + float → float` |
| Aritmetica con `byte`, `short`, `char` | Promozione a `int` | `byte + byte → int` |
| Risultato dopo la promozione | Il risultato ha il tipo promosso | `float + long → float` |

<a id="4621-punti-chiave"></a>
#### 4.6.2.1 Punti chiave

- Considera sempre la **promozione di tipo** quando misceli tipi diversi in un’espressione aritmetica.  
- Per i tipi piccoli (`byte`, `short`, `char`), la promozione a `int` è automatica quando si usano **variabili** in un’operazione aritmetica.  
- Usa il **casting esplicito** solo quando sei sicuro che il risultato rientri nel tipo di destinazione.  
- Ricorda: la **divisione tra interi tronca**, la **divisione tra floating-point mantiene i decimali**.  
- Comprendere le regole di promozione è cruciale per evitare **perdite di precisione inattese** o **errori di compilazione**.

---

<a id="47-casting-in-java"></a>
## 4.7 Casting in Java

Il `casting` in Java è il processo con cui si converte esplicitamente un valore da un tipo a un altro.  
Si applica sia ai `primitive types` (numeri) sia ai `reference types` (oggetti in una gerarchia di classi).

<a id="471-casting-dei-primitivi"></a>
### 4.7.1 Casting dei primitivi

Il casting dei primitivi cambia il tipo di un valore numerico.

Esistono due categorie di casting:

| Type | Description | Example | Explicit? | Risk |
| --- | --- | --- | --- | --- |
| Widening | tipo più piccolo → tipo più grande | int → double | No | nessuna perdita |
| Narrowing | tipo più grande → tipo più piccolo | double → int | Sì | possible loss |

<a id="4711-widening-implicit-casting"></a>
#### 4.7.1.1 Widening implicit casting

Conversione automatica da un tipo “più piccolo” a un tipo “più grande” compatibile.  
Gestita dal compilatore, **non richiede sintassi esplicita**.

```java
int i = 100;
double d = i;  // implicit cast: int → double
System.out.println(d); // 100.0
```

✅ **Sicuro** – nessun overflow (anche se bisogna comunque essere consapevoli della precisione dei floating-point).

<a id="4712-narrowing-explicit-casting"></a>
### 4.7.1.2 Narrowing Explicit Casting

Conversione manuale da un tipo “più grande” a uno “più piccolo”.  
Richiede una **cast expression** perché può causare perdita di dati.

```java
double d = 9.78;
int i = (int) d;  // explicit cast: double → int
System.out.println(i); // 9 (fraction discarded)
```

!!! warning
    ⚠ Usare solo quando si è sicuri che il valore rientri nel tipo di destinazione.


<a id="4713-narrowing-implicito-a-compile-time"></a>
### 4.7.1.3 Narrowing Implicito a Compile-Time

In alcuni casi specifici, il compilatore permette una conversione di narrowing **senza un cast esplicito**.

Se una variabile è dichiarata `final` ed è inizializzata con una constant expression il cui valore rientra nel tipo di destinazione, il compilatore può eseguire la conversione in modo sicuro a compile time.

```java
final int k = 11;
byte b = k;  // allowed: value 11 fits into byte range

final int x = 200;
byte c = x;  // does NOT compile: 200 is outside byte range
```

Questo funziona perché il compilatore conosce il valore esatto di una variabile `final` e può verificare che sia all'interno dell'intervallo del tipo più piccolo.

Questo tipo di narrowing è consentito tra:
- `byte`
- `short`
- `char`
- `int`

Tuttavia, non si applica a:
- `long`
- `float`
- `double`

Per esempio:

```java
final float f = 10.0f;
int n = f;   // does not compile
```

Anche se il valore sembra compatibile, i tipi floating-point non sono idonei per questa forma di narrowing implicito.


<a id="472-perdita-di-dati-overflow-e-underflow"></a>
### 4.7.2 Perdita di dati, overflow e underflow

Quando un valore eccede la capacità di un tipo, puoi ottenere:

- **Overflow**: il risultato è maggiore del massimo valore rappresentabile
- **Underflow**: il risultato è minore del minimo valore rappresentabile
- **Troncamento**: la parte di dato che non entra viene persa (ad esempio, i decimali)

- Esempio – overflow/underflow con `int`

```java
int max = Integer.MAX_VALUE;
int overflow = max + 1;     // "wrap-around" verso il negativo

int min = Integer.MIN_VALUE;
int underflow = min - 1;    // "wrap-around" verso il positivo
```

- Esempio: troncamento

```java
double d = 9.99;
int i = (int) d; // 9 (fraction discarded)
```

!!! note
    I tipi floating-point (`float`, `double`) **non fanno wrap-around**:
    - overflow → `Infinity` / `-Infinity`  
    - underflow (valori molto piccoli) → 0.0 o valori denormalizzati.

<a id="473-casting-di-valori-vs-variabili"></a>
### 4.7.3 Casting di valori vs. variabili

Java tratta:

- I **letterali interi** come `int` di default
- I **letterali floating-point** come `double` di default

Il compilatore **non richiede cast** quando un letterale rientra nel range del tipo di destinazione:

```java
byte first = 10;        // OK: 10 rientra in byte
short second = 9 * 10;  // OK: espressione costante valutata a compile time
```

Ma:

```java
long a = 5729685479;    // ❌ errore: letterale int fuori range
long b = 5729685479L;   // ✅ letterale long (suffisso L)

float c = 3.14;         // ❌ double → float: richiede F o cast
float d = 3.14F;        // ✅ letterale float

int e = 0x7FFF_FFFF;    // ✅ max int in esadecimale
int f = 0x8000_0000;    // ❌ fuori range int (serve L)
```

Tuttavia, quando si applicano le regole di promozione numerica:

> Con **variabili** di tipo `byte`, `short` e `char` in un’espressione aritmetica, gli operandi vengono promossi a `int` e il risultato è `int`.

```java
byte first = 10;
short second = 9 + first;       // ❌ 9 (int literal) + first (byte → int) = int
// second = (short) (9 + first);  // ✅ cast dell’intera espressione
```

```java
short b = 10;
short a = 5 + b;               // ❌ 5 (int) + b (short → int) = int
short a2 = (short) (5 + b);    // ✅ cast dell’intera espressione
```

!!! warning
    Il cast è un **operatore unario**:
    
    `short a = (short) 5 + b;`  
    Il cast si applica solo a `5` → il risultato dell’espressione resta di tipo `int` → l’assegnazione fallisce comunque.

<a id="474-casting-di-reference-oggetti"></a>
### 4.7.4 Casting di reference (oggetti)

Il casting si applica anche ai **reference a oggetti** in una gerarchia di classi.  
Non modifica l’oggetto in memoria — cambia solo **il tipo di reference** usato per accedervi.

Regole fondamentali:

- Il **tipo reale dell’oggetto** determina quali field/metodi esistono effettivamente.
- Il **tipo del reference** determina cosa puoi accedere in quel punto del codice.

<a id="4741-upcasting-widening-reference-cast"></a>
#### 4.7.4.1 Upcasting (widening reference cast)

Conversione da **sottoclasse** a **superclasse**.

È **implicita** e **sempre sicura**: ogni `Dog` è anche un `Animal`.

```java
class Animal { }
class Dog extends Animal { }

Dog dog = new Dog();
Animal a = dog;    // implicit upcast: Dog → Animal
```

<a id="4742-downcasting-narrowing-reference-cast"></a>
#### 4.7.4.2 Downcasting (narrowing reference cast)

Conversione da **superclasse** a **sottoclasse**.

- È **esplicita**
- Può fallire a runtime con `ClassCastException` se l’oggetto non è realmente di quel tipo

```java
Animal a = new Dog();
Dog d = (Dog) a;   // OK: a punta davvero a un Dog

Animal x = new Animal();
Dog d2 = (Dog) x;  // ⚠ Errore a runtime: ClassCastException
```

Per sicurezza, usa `instanceof`:

```java
if (x instanceof Dog) {
    Dog safeDog = (Dog) x;   // cast sicuro
}
```

<a id="475-riepilogo-dei-punti-chiave"></a>
### 4.7.5 Riepilogo dei punti chiave

| Casting Type | Applies To | Direction | Syntax | Safe? | Performed By |
| --- | --- | --- | --- | --- | --- |
| Widening Primitive | Primitives | small → large | Implicit | Sì | Compiler |
| Narrowing Primitive | Primitives | large → small | Explicit | No | Programmer |
| Upcasting | Objects | subclass → superclass | Implicit | Sì | Compiler |
| Downcasting | Objects | superclass → subclass | Explicit | Runtime check | Programmer |

<a id="476-esempi"></a>
### 4.7.6 Esempi

```java
// Primitive casting
short s = 50;
int i = s;           // widening
byte b = (byte) i;   // narrowing (possible loss)

// Object casting
Object obj = "Hello";
String str = (String) obj; // OK: obj points to a String

Object n = Integer.valueOf(10);
// String fail = (String) n;  // ClassCastException at runtime
```

---

<a id="48-sommario"></a>
## 4.8 Sommario

- Il **casting dei primitivi** cambia il tipo numerico.  
- Il **casting delle reference** cambia la “vista” di un oggetto nella gerarchia.  
- **Upcasting** → sicuro e implicito.  
- **Downcasting** → esplicito, da usare con cautela (spesso dopo `instanceof`).
