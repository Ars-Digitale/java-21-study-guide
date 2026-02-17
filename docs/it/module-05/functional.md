# 20. Programmazione Funzionale in Java

<a id="indice"></a>
### Indice


- [20.1 Interfacce Funzionali](#201-interfacce-funzionali)
	- [20.1.1 Regole per le Interfacce Funzionali](#2011-regole-per-le-interfacce-funzionali)
	- [20.1.2 Interfacce Funzionali Comuni (java.util.function)](#2012-interfacce-funzionali-comuni-javautilfunction)
	- [20.1.3 Metodi di Comodità nelle Interfacce Funzionali](#2013-metodi-di-comodità-nelle-interfacce-funzionali)
	- [20.1.4 Interfacce Funzionali Primitive](#2014-interfacce-funzionali-primitive)
	- [20.1.5 Riepilogo](#2015-riepilogo)
- [20.2 Espressioni Lambda](#202-espressioni-lambda)
	- [20.2.1 Sintassi delle Espressioni Lambda](#2021-sintassi-delle-espressioni-lambda)
	- [20.2.2 Esempi di Sintassi Lambda](#2022-esempi-di-sintassi-lambda)
	- [20.2.3 Regole per le Espressioni Lambda](#2023-regole-per-le-espressioni-lambda)
	- [20.2.4 Inferenza di Tipo](#2024-inferenza-di-tipo)
	- [20.2.5 Restrizioni nei Corpi delle Lambda](#2025-restrizioni-nei-corpi-delle-lambda)
	- [20.2.6 Regole sul Tipo di Ritorno](#2026-regole-sul-tipo-di-ritorno)
	- [20.2.7 Lambda vs Classi Anonime](#2027-lambda-vs-classi-anonime)
	- [20.2.8 Errori Comuni nelle Lambda Trappole da Certificazione](#2028-errori-comuni-nelle-lambda-trappole-da-certificazione)
- [20.3 Riferimenti a Metodi](#203-riferimenti-a-metodi)
	- [20.3.1 Riferimento a un Metodo Statico](#2031-riferimento-a-un-metodo-statico)
	- [20.3.2 Riferimento a un Metodo d’Istanza di un Oggetto Specifico](#2032-riferimento-a-un-metodo-distanza-di-un-oggetto-specifico)
	- [20.3.3 Riferimento a un Metodo d’Istanza di un Oggetto Arbitrario di un Dato Tipo](#2033-riferimento-a-un-metodo-distanza-di-un-oggetto-arbitrario-di-un-dato-tipo)
	- [20.3.4 Riferimento a un Costruttore](#2034-riferimento-a-un-costruttore)
	- [20.3.5 Tabella Riassuntiva dei Tipi di Method Reference](#2035-tabella-riassuntiva-dei-tipi-di-method-reference)
	- [20.3.6 Errori Comuni](#2036-errori-comuni)


---

La `programmazione funzionale` è un paradigma di programmazione che si concentra sul descrivere **cosa** deve essere fatto, piuttosto che **come** deve essere fatto.

A partire da Java 8, il linguaggio ha aggiunto diverse funzionalità che abilitano uno stile di programmazione “funzionale”: `lambda expressions`, `functional interfaces` e `method references`.

Queste funzionalità permettono agli sviluppatori di scrivere codice più espressivo, conciso e riutilizzabile, soprattutto quando si lavora con collezioni, API di concorrenza e sistemi event-driven.

<a id="201-interfacce-funzionali"></a>
## 20.1 Interfacce Funzionali

In Java, un’**interfaccia funzionale** è un’interfaccia che contiene **esattamente un solo** metodo astratto.

Le interfacce funzionali abilitano **Lambda Expressions** e **Method References**, formando il nucleo del modello di programmazione funzionale di Java.

!!! note
    Java tratta automaticamente come interfaccia funzionale qualsiasi interfaccia con un solo metodo astratto. L’annotazione `@FunctionalInterface` è opzionale ma consigliata.

<a id="2011-regole-per-le-interfacce-funzionali"></a>
### 20.1.1 Regole per le Interfacce Funzionali

- **Esattamente un metodo astratto** (SAM = Single Abstract Method).
- Le interfacce possono dichiarare un numero qualsiasi di metodi **default**, **static** o **private**.
- Possono fare override dei metodi di `Object` (`toString()`, `equals(Object)`, `hashCode()`) senza influenzare il conteggio SAM.
- Il metodo funzionale può provenire da una **superinterfaccia**.

Esempio:

```java
@FunctionalInterface
interface Adder {
    int add(int a, int b);   // single abstract method
    static void info() {}
    default void log() {}
}
```

<a id="2012-interfacce-funzionali-comuni-javautilfunction"></a>
### 20.1.2 Interfacce Funzionali Comuni (java.util.function)

Di seguito un riepilogo delle interfacce funzionali più importanti.

| Functional Interface | Returns | Method | Parameters |
|---------------------|---------|--------|------------|
| `Supplier<T>`       | T       | get()  | 0          |
| `Consumer<T>`       | void    | accept(T) | 1       |
| `BiConsumer<T,U>`   | void    | accept(T,U) | 2     |
| `Function<T,R>`     | R       | apply(T) | 1        |
| `BiFunction<T,U,R>` | R       | apply(T,U) | 2      |
| `UnaryOperator<T>`  | T       | apply(T) | 1 (stessi tipi) |
| `BinaryOperator<T>` | T       | apply(T,T) | 2 (stessi tipi) |
| `Predicate<T>`      | boolean | test(T) | 1        |
| `BiPredicate<T,U>`  | boolean | test(T,U) | 2      |

- Esempi

```java
Supplier<String> sup = () -> "Hello!";

Consumer<String> printer = s -> System.out.println(s);

Function<String, Integer> length = s -> s.length();

UnaryOperator<Integer> square = x -> x * x;

Predicate<Integer> positive = x -> x > 0;
```

<a id="2013-metodi-di-comodità-nelle-interfacce-funzionali"></a>
### 20.1.3 Metodi di Comodità nelle Interfacce Funzionali

Molte interfacce funzionali includono metodi di supporto che consentono chaining e composizione.

| Interface      | Method    | Description |
|---------------|-----------|-------------|
| Function      | andThen() | applica questa funzione, poi un’altra |
| Function      | compose() | applica un’altra funzione, poi questa |
| Function      | identity() | restituisce una funzione x -> x |
| Predicate     | and()     | AND logico |
| Predicate     | or()      | OR logico |
| Predicate     | negate()  | NOT logico |
| Consumer      | andThen() | concatena consumer |
| BinaryOperator| minBy()   | minimo basato su comparator |
| BinaryOperator| maxBy()   | massimo basato su comparator |

- Esempi

```java
Function<Integer, Integer> times2 = x -> x * 2;
Function<Integer, Integer> plus3  = x -> x + 3;

var result1 = times2.andThen(plus3).apply(5);   // (5*2)+3 = 13
var result2 = times2.compose(plus3).apply(5);   // (5+3)*2 = 16

Predicate<String> longString = s -> s.length() > 5;
Predicate<String> startsWithA = s -> s.startsWith("A");

boolean ok = longString.and(startsWithA).test("Amazing");  // true
```

<a id="2014-interfacce-funzionali-primitive"></a>
### 20.1.4 Interfacce Funzionali Primitive

Java fornisce versioni specializzate delle interfacce funzionali per i tipi primitivi, per evitare overhead di boxing/unboxing.

| Functional Interface              | Return Type | Single Abstract Method | # Parameters |
|----------------------------------|-------------|-------------------------|--------------|
| IntSupplier                       | int         | getAsInt()              | 0            |
| LongSupplier                      | long        | getAsLong()             | 0            |
| DoubleSupplier                    | double      | getAsDouble()           | 0            |
| BooleanSupplier                   | boolean     | getAsBoolean()          | 0            |
|                                  |             |                         |              |
| IntConsumer                       | void        | accept(int)             | 1 (int)      |
| LongConsumer                      | void        | accept(long)            | 1 (long)     |
| DoubleConsumer                    | void        | accept(double)          | 1 (double)   |
|                                  |             |                         |              |
| IntPredicate                      | boolean     | test(int)               | 1 (int)      |
| LongPredicate                     | boolean     | test(long)              | 1 (long)     |
| DoublePredicate                   | boolean     | test(double)            | 1 (double)   |
|                                  |             |                         |              |
| IntUnaryOperator                  | int         | applyAsInt(int)         | 1 (int)      |
| LongUnaryOperator                 | long        | applyAsLong(long)       | 1 (long)     |
| DoubleUnaryOperator               | double      | applyAsDouble(double)   | 1 (double)   |
|                                  |             |                         |              |
| IntBinaryOperator                 | int         | applyAsInt(int, int)    | 2 (int,int)  |
| LongBinaryOperator                | long        | applyAsLong(long, long) | 2 (long,long)|
| DoubleBinaryOperator              | double      | applyAsDouble(double,double) | 2       |
|                                  |             |                         |              |
| IntFunction<R>                    | R           | apply(int)              | 1 (int)      |
| LongFunction<R>                   | R           | apply(long)             | 1 (long)     |
| DoubleFunction<R>                 | R           | apply(double)           | 1 (double)   |
|                                  |             |                         |              |
| ToIntFunction<T>                  | int         | applyAsInt(T)           | 1 (T)        |
| ToLongFunction<T>                 | long        | applyAsLong(T)          | 1 (T)        |
| ToDoubleFunction<T>               | double      | applyAsDouble(T)        | 1 (T)        |
|                                  |             |                         |              |
| ToIntBiFunction<T,U>              | int         | applyAsInt(T,U)         | 2 (T,U)      |
| ToLongBiFunction<T,U>             | long        | applyAsLong(T,U)        | 2 (T,U)      |
| ToDoubleBiFunction<T,U>           | double      | applyAsDouble(T,U)      | 2 (T,U)      |
|                                  |             |                         |              |
| ObjIntConsumer<T>                 | void        | accept(T,int)           | 2 (T,int)    |
| ObjLongConsumer<T>                | void        | accept(T,long)          | 2 (T,long)   |
| ObjDoubleConsumer<T>              | void        | accept(T,double)        | 2 (T,double) |
|                                  |             |                         |              |
| DoubleToIntFunction               | int         | applyAsInt(double)      | 1            |
| DoubleToLongFunction              | long        | applyAsLong(double)     | 1            |
| IntToDoubleFunction               | double      | applyAsDouble(int)      | 1            |
| IntToLongFunction                 | long        | applyAsLong(int)        | 1            |
| LongToDoubleFunction              | double      | applyAsDouble(long)     | 1            |
| LongToIntFunction                 | int         | applyAsInt(long)        | 1            |

- Esempio

```java
IntSupplier dice = () -> (int)(Math.random() * 6) + 1;

IntPredicate even = x -> x % 2 == 0;

IntUnaryOperator doubleIt = x -> x * 2;
```

<a id="2015-riepilogo"></a>
### 20.1.5 Riepilogo

- Le interfacce funzionali contengono esattamente un metodo astratto (SAM).
- Sono alla base di Lambda e Method References.
- Java offre molte FI built-in in `java.util.function`.
- Le varianti primitive migliorano le performance rimuovendo il boxing.

---

<a id="202-espressioni-lambda"></a>
## 20.2 Espressioni Lambda

Una lambda expression è un modo compatto di scrivere una funzione.

Le lambda expressions offrono un modo conciso per definire implementazioni di interfacce funzionali.

Una lambda è essenzialmente un piccolo blocco di codice che accetta parametri e restituisce un valore, senza richiedere una dichiarazione completa di metodo.

Rappresentano il comportamento come dato e sono un elemento chiave del modello di programmazione funzionale in Java.

<a id="2021-sintassi-delle-espressioni-lambda"></a>
### 20.2.1 Sintassi delle Espressioni Lambda

La sintassi generale è:

`(parameters) -> expression`  
oppure  
`(parameters) -> { statements }`

<a id="2022-esempi-di-sintassi-lambda"></a>
### 20.2.2 Esempi di Sintassi Lambda

**Zero parametri**
```java
Runnable r = () -> System.out.println("Hello");
```

**Un parametro (parentesi opzionali)**
```java
Consumer<String> c = s -> System.out.println(s);
```

**Più parametri**
```java
BinaryOperator<Integer> add = (a, b) -> a + b;
```

**Con block body**
```java
Function<Integer, String> f = (x) -> {
    int doubled = x * 2;
    return "Value: " + doubled;
};
```

<a id="2023-regole-per-le-espressioni-lambda"></a>
### 20.2.3 Regole per le Espressioni Lambda

- I tipi dei parametri possono essere omessi (type inference).
- Se un parametro ha un tipo, allora **tutti** i parametri devono specificare il tipo.
- Un singolo parametro non richiede parentesi.
- Più parametri richiedono le parentesi.
- Se il corpo è una singola espressione (senza `{ }`), `return` non è consentito; l’espressione stessa è il valore di ritorno.
- Se il corpo usa `{ }` (un blocco), `return` deve comparire se viene restituito un valore.
- Le lambda possono essere assegnate solo a interfacce funzionali (tipi SAM).

<a id="2024-inferenza-di-tipo"></a>
### 20.2.4 Inferenza di Tipo

Il compilatore deduce il tipo della lambda dal contesto dell’interfaccia funzionale target.

```java
Predicate<String> p = s -> s.isEmpty();  // s inferito come String
```

Se il compilatore non riesce a inferire il tipo, devi specificarlo esplicitamente.

```java
BiFunction<Integer, Integer, Integer> f = (Integer a, Integer b) -> a * b;
```

<a id="2025-restrizioni-nei-corpi-delle-lambda"></a>
### 20.2.5 Restrizioni nei Corpi delle Lambda

**Le lambda possono catturare solo variabili locali che sono final o effectively final (non riassegnate).**

```java
int x = 10;
Runnable r = () -> {
    // x++;   // ❌ errore di compilazione — x deve essere effectively final
    System.out.println(x);
};
```

**Possono invece modificare lo stato di un oggetto (solo i riferimenti devono essere effectively final).**

```java
var list = new ArrayList<>();
Runnable r2 = () -> list.add("OK");  // consentito
```

<a id="2026-regole-sul-tipo-di-ritorno"></a>
### 20.2.6 Regole sul Tipo di Ritorno

Se il corpo è un’espressione: l’espressione è il valore di ritorno.

```java
Function<Integer, Integer> f = x -> x * 2;
```

Se il corpo è un blocco: devi includere `return`.

```java
Function<Integer, Integer> g = x -> {
    return x * 2;
};
```

<a id="2027-lambda-vs-classi-anonime"></a>
### 20.2.7 Lambda vs Classi Anonime

- Le lambda NON creano un nuovo scope: condividono lo scope contenitore.
- `this` dentro una lambda si riferisce all’oggetto contenitore, non alla lambda.

```java
class Test {
    void run() {
        Runnable r = () -> System.out.println(this.toString());
    }
}
```

Nelle classi anonime, `this` si riferisce all’istanza della classe anonima.

<a id="2028-errori-comuni-nelle-lambda-trappole-da-certificazione"></a>
### 20.2.8 Errori Comuni nelle Lambda (Trappole da Certificazione)

**Tipi di ritorno incoerenti**
```java
x -> { if (x > 0) return 1; }  // ❌ manca return per il caso negativo
```

**Mescolare parametri tipizzati e non tipizzati**
```java
(a, int b) -> a + b   // ❌ illegale
```

**Restituire un valore da una lambda con target void**
```java
Runnable r = () -> 5;  // ❌ Runnable.run() restituisce void
```

**Risoluzione di overload ambigua**

```java
void m(IntFunction<Integer> f) {}
void m(Function<Integer, Integer> f) {}

m(x -> x + 1);  // ❌ ambiguo
```

---

<a id="203-riferimenti-a-metodi"></a>
## 20.3 Riferimenti a Metodi

I riferimenti a metodi (method references) forniscono una sintassi abbreviata per usare un metodo esistente come implementazione di un’interfaccia funzionale.

Sono equivalenti alle lambda expressions, ma più concisi, leggibili e spesso preferibili quando il metodo target esiste già.

Esistono quattro categorie di method references in Java:

- 1. Riferimento a un metodo statico (`ClassName::staticMethod`)
- 2. Riferimento a un metodo d’istanza di un oggetto specifico (`instance::method`)
- 3. Riferimento a un metodo d’istanza di un oggetto arbitrario di un dato tipo (`ClassName::instanceMethod`)
- 4. Riferimento a un costruttore (`ClassName::new`)

<a id="2031-riferimento-a-un-metodo-statico"></a>
### 20.3.1 Riferimento a un Metodo Statico

Un method reference statico sostituisce una lambda che invoca un metodo statico.

```java
class Utils {
    static int square(int x) { return x * x; }
}

Function<Integer, Integer> f1 = x -> Utils.square(x);
Function<Integer, Integer> f2 = Utils::square;  // method reference
```

Sia `f1` che `f2` si comportano in modo identico.

<a id="2032-riferimento-a-un-metodo-distanza-di-un-oggetto-specifico"></a>
### 20.3.2 Riferimento a un Metodo d’Istanza di un Oggetto Specifico

Usato quando hai già un’istanza di un oggetto e vuoi riferirti a uno dei suoi metodi.

```java
String prefix = "Hello, ";

UnaryOperator<String> op1 = s -> prefix.concat(s);
UnaryOperator<String> op2 = prefix::concat;   // method reference

System.out.println(op2.apply("World"));
```

Il riferimento `prefix::concat` lega `concat` a **quell’oggetto specifico**.

<a id="2033-riferimento-a-un-metodo-distanza-di-un-oggetto-arbitrario-di-un-dato-tipo"></a>
### 20.3.3 Riferimento a un Metodo d’Istanza di un Oggetto Arbitrario di un Dato Tipo

Questa è la forma più “insidiosa”.

Il primo parametro dell’interfaccia funzionale diventa il receiver del metodo (`this`).

```java
BiPredicate<String, String> p1 = (s1, s2) -> s1.equals(s2);
BiPredicate<String, String> p2 = String::equals;   // method reference

System.out.println(p2.test("abc", "abc"));  // true
```

!!! note
    Questa forma applica il metodo al *primo argomento* della lambda.

<a id="2034-riferimento-a-un-costruttore"></a>
### 20.3.4 Riferimento a un Costruttore

I constructor references sostituiscono lambda che invocano `new`.

```java
Supplier<ArrayList<String>> sup1 = () -> new ArrayList<>();
Supplier<ArrayList<String>> sup2 = ArrayList::new; // method reference

Function<Integer, ArrayList<String>> sup3 = ArrayList::new;
// invoca il costruttore ArrayList(int capacity)
```

<a id="2035-tabella-riassuntiva-dei-tipi-di-method-reference"></a>
### 20.3.5 Tabella Riassuntiva dei Tipi di Method Reference

La tabella seguente riassume tutte le categorie di method reference.

| Type                               | Syntax Example          | Equivalent Lambda |
|-----------------------------------|-------------------------|-------------------|
| Static method                       | Class::staticMethod     | x -> Class.staticMethod(x) |
| Instance method of specific object  | instance::method        | x -> instance.method(x) |
| Instance method of arbitrary object | Class::method           | (obj, x) -> obj.method(x) |
| Constructor                         | Class::new              | () -> new Class() |

<a id="2036-errori-comuni"></a>
### 20.3.6 Errori Comuni

- Un method reference deve combaciare *esattamente* con la signature dell’interfaccia funzionale.
- Gli overload possono rendere i method references ambigui.
- Il riferimento a metodo d’istanza (`Class::method`) sposta il receiver al parametro 1.
- Un constructor reference fallisce se non esiste un costruttore compatibile.

```java
// ❌ Ambiguo: quale println()? (println(int), println(String)...)
Consumer<String> c = System.out::println; // OK solo perché il parametro FI è String

// ❌ Costruttore non compatibile: interfaccia funzionale errata
Supplier<Integer> s = Integer::new;          // ✔ OK: invoca Integer()
Function<String, Long> f = Integer::new;     // ❌ ERRORE: il costruttore restituisce Integer, non Long
```

In caso di dubbio, riscrivi il method reference come una lambda: se la lambda funziona ma il method reference no, il problema è quasi sempre il matching della signature.
