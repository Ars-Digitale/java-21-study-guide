# 18. Generics in Java

<a id="indice"></a>
### Indice


- [18.1 Basi dei Tipi Generici](#181-basi-dei-tipi-generici)
- [18.2 Perché Esistono i Generics](#182-perché-esistono-i-generics)
- [18.3 Metodi Generici](#183-metodi-generici)
- [18.4 Type Erasure](#184-type-erasure)
	- [18.4.1 Come Funziona la Type Erasure](#1841-come-funziona-la-type-erasure)
	- [18.4.2 Erasure dei Parametri di Tipo Senza Bound](#1842-erasure-dei-parametri-di-tipo-senza-bound)
	- [18.4.3 Erasure dei Parametri di Tipo con Bound](#1843-erasure-dei-parametri-di-tipo-con-bound)
	- [18.4.4 Bound Multipli: Il Primo Bound Determina l’Erasure](#1844-bound-multipli-il-primo-bound-determina-lerasure)
	- [18.4.5 Perché Solo il Primo Bound Diventa il Tipo a Runtime](#1845-perché-solo-il-primo-bound-diventa-il-tipo-a-runtime)
	- [18.4.6 Un Esempio Più Complesso](#1846-un-esempio-più-complesso)
	- [18.4.7 Overloading di un Metodo Generico — Perché Alcuni Overload Sono Impossibili](#1847-overloading-di-un-metodo-generico--perché-alcuni-overload-sono-impossibili)
	- [18.4.8 Overloading di un Metodo Generico Ereditato da una Classe Parent](#1848-overloading-di-un-metodo-generico-ereditato-da-una-classe-parent)
	- [18.4.9 Restituire Tipi Generici — Regole e Restrizioni](#1849-restituire-tipi-generici--regole-e-restrizioni)
	- [18.4.10 Riepilogo delle Regole di Erasure](#18410-riepilogo-delle-regole-di-erasure)
- [18.5 Bound sui Parametri di Tipo](#185-bound-sui-parametri-di-tipo)
	- [18.5.1 Upper Bounds: extends](#1851-upper-bounds-extends)
	- [18.5.2 Bound Multipli](#1852-bound-multipli)
	- [18.5.3 Wildcard: ?, ? extends, ? super](#1853-wildcard---extends--super)
		- [18.5.3.1 Wildcard Non Limitata](#18531-wildcard-non-limitata-)
		- [18.5.3.2 Wildcard con Upper Bound extends](#18532-wildcard-con-upper-bound--extends)
		- [18.5.3.3 Wildcard con Lower Bound super](#18533-wildcard-con-lower-bound--super)
- [18.6 Generics ed Ereditarietà](#186-generics-ed-ereditarietà)
- [18.7 Type Inference (Operatore Diamond)](#187-type-inference-operatore-diamond)
- [18.8 Raw Types (Compatibilità Legacy)](#188-raw-types-compatibilità-legacy)
- [18.9 Array Generici (Non Permessi)](#189-array-generici-non-permessi)
- [18.10 Bounded Type Inference](#1810-bounded-type-inference)
- [18.11 Wildcard vs Parametri di Tipo](#1811-wildcard-vs-parametri-di-tipo)
- [18.12 Regola PECS (Producer Extends, Consumer Super)](#1812-regola-pecs-producer-extends-consumer-super)
- [18.13 Errori Comuni](#1813-errori-comuni)
- [18.14 Tabella Riassuntiva delle Wildcard](#1814-tabella-riassuntiva-delle-wildcard)
- [18.15 Riepilogo dei Concetti](#1815-riepilogo-dei-concetti)
- [18.16 Esempio Completo](#1816-esempio-completo)


---

Java `Generics` permettono di creare classi, interfacce e metodi che lavorano con tipi specificati dall’utente, garantendo che vengano usati solo oggetti del tipo corretto.

Tutti i controlli di tipo vengono eseguiti dal compilatore a compile-time. 

Durante la compilazione, il compilatore verifica i tipi e poi rimuove le informazioni generiche (processo identificato come **type erasure**), sostituendole con i tipi reali o con Object quando necessario.

Il bytecode risultante non contiene generics: contiene solo i tipi concreti e, se serve, cast inseriti automaticamente dal compilatore.

In questo modo, gli errori di tipo vengono intercettati prima dell’esecuzione, rendendo il codice più sicuro, leggibile e riutilizzabile.

I Generics si applicano a:
- `Classi`
- `Interfacce`
- `Metodi` (metodi generici)
- `Costruttori`

<a id="181-basi-dei-tipi-generici"></a>
## 18.1 Basi dei Tipi Generici

Una classe o interfaccia generica introduce uno o più **parametri di tipo**, racchiusi tra parentesi angolari.

```java
class Box<T> {
    private T value;
    void set(T v) { value = v; }
    T get()       { return value; }
}

Box<String> b = new Box<>();

b.set("hello");

String x = b.get(); // nessun cast necessario
```

Sono permessi più parametri di tipo:

```java
class Pair<K, V> {
    K key;
    V value;
}
```

---

<a id="182-perché-esistono-i-generics"></a>
## 18.2 Perché Esistono i Generics

```java
List list = new ArrayList();          // pre-generics
list.add("hi");

Integer x = (Integer) list.get(0);    // ClassCastException a runtime
```

Con i generics:

```java
List<String> list = new ArrayList<>();
list.add("hi");

String x = list.get(0);               // type-safe, nessun cast
```

---

<a id="183-metodi-generici"></a>
## 18.3 Metodi Generici

Un **metodo generico** introduce i propri parametri di tipo, indipendenti dalla classe.

```java
class Util {

    static <T> T pick(T a, T b) { return a; }
	
}

String s = Util.<String>pick("A", "B"); // esplicito
String t = Util.pick("A", "B");         // l’inferenza funziona
```

---

<a id="184-type-erasure"></a>
## 18.4 Type Erasure

La `Type erasure` è il processo attraverso cui il compilatore Java rimuove tutte le informazioni sui tipi generici prima di generare il bytecode.

Questo garantisce compatibilità con le JVM precedenti a Java 5.

A `compile time`, i generics sono completamente controllati: bound sui tipi, varianza, overloading di metodi generici, ecc. 

Tuttavia, a runtime, tutte le informazioni generiche scompaiono.

<a id="1841-come-funziona-la-type-erasure"></a>
### 18.4.1 Come Funziona la Type Erasure

- Sostituire tutte le variabili di tipo (come `T`) con il loro tipo erasure.
- Inserire cast dove necessario.
- Rimuovere tutti gli argomenti di tipo generico (es. `List<String>` → `List`).

<a id="1842-erasure-dei-parametri-di-tipo-senza-bound"></a>
### 18.4.2 Erasure dei Parametri di Tipo Senza Bound

Se una variabile di tipo non ha bound:

```java
class Box<T> {
    T value;
    T get() { return value; }
}
```

L’erasure di `T` è `Object`.

```java
class Box {
    Object value;
    Object get() { return value; }
}
```

<a id="1843-erasure-dei-parametri-di-tipo-con-bound"></a>
### 18.4.3 Erasure dei Parametri di Tipo con Bound

Se il parametro di tipo ha bound:

```java
class TaskRunner<T extends Runnable> {

    void run(T task) { task.run(); }
	
}
```

Allora l’erasure di `T` è il primo bound trovato dal compilatore: in questo specifico caso `Runnable`.

```java
class TaskRunner {
    void run(Runnable task) { task.run(); }
}
```

<a id="1844-bound-multipli-il-primo-bound-determina-lerasure"></a>
### 18.4.4 Bound Multipli: Il Primo Bound Determina l’Erasure

Java permette bound multipli:

```java
<T extends Runnable & Serializable & Cloneable>
```

!!! important
    L’erasure di `T` è sempre il **primo bound**, che deve essere una classe o interfaccia.

Poiché `Runnable` è il primo bound, il compilatore effettua l’erasure di `T` a `Runnable`.

- Esempio con Bound Multipli (Completamente Espanso)

```java
public static <T extends Runnable & Serializable & Cloneable>
void runAll(List<T> list) {
    for (T t : list) {
        t.run();
    }
}
```

Versione con Erasure

```java
public static void runAll(List list) {
    for (Object obj : list) {
        Runnable t = (Runnable) obj;   // cast inserito dal compilatore
        t.run();
    }
}
```

Cosa succede agli altri bound (Serializable, Cloneable)?

- Sono applicati solo a compile time.
- NON compaiono nel bytecode.
- Nessuna interfaccia aggiuntiva viene associata al tipo con erasure.

<a id="1845-perché-solo-il-primo-bound-diventa-il-tipo-a-runtime"></a>
### 18.4.5 Perché Solo il Primo Bound Diventa il Tipo a Runtime?

Perché la JVM deve operare usando un singolo tipo di riferimento concreto per ogni variabile o parametro.

Le istruzioni bytecode a runtime come `invokevirtual` richiedono una singola classe o interfaccia, non un tipo composto come “Runnable & Serializable & Cloneable”.

!!! note
    Java seleziona il **primo bound** come tipo a runtime, e usa i bound restanti solo per la **validazione a compile-time**.

<a id="1846-un-esempio-più-complesso"></a>
### 18.4.6 Un Esempio Più Complesso

```java
interface A { void a(); }
interface B { void b(); }

class C implements A, B {
    public void a() {}
    public void b() {}
}

class Demo<T extends A & B> {
    void test(T value) {
        value.a();
        value.b();
    }
}
```

Versione con Erasure

```java
class Demo {
    void test(A value) {
        value.a();
        // value.b();   // ❌ non disponibile dopo l’erasure: il tipo è A, non B
    }
}
```

!!! note
    Il compilatore può inserire cast aggiuntivi o metodi bridge in scenari di ereditarietà più complessi, ma l’erasure usa sempre solo il primo bound (A in questo caso).

<a id="1847-overloading-di-un-metodo-generico--perché-alcuni-overload-sono-impossibili"></a>
### 18.4.7 Overloading di un Metodo Generico — Perché Alcuni Overload Sono Impossibili

Quando Java compila codice generico, applica la type erasure:
i parametri di tipo come T vengono rimossi, e il compilatore li sostituisce con il loro tipo erasure (di solito Object o il primo bound).

Per questo motivo, due metodi che sembrano diversi a livello di sorgente possono diventare identici dopo l’erasure.

Se le `signature` con erasure sono uguali, Java non può distinguerli, quindi il codice non compila.

- Esempio: Due Metodi che Collassano sulla Stessa `Signature`

```java
public class Demo {
    public void testInput(List<Object> inputParam) {}

    // public void testInput(List<String> inputParam) {}   // ❌ Errore di compilazione: dopo l’erasure, entrambi diventano testInput(List)
}
```

Spiegazione

```bash
List<Object> e List<String> vengono entrambi cancellati a List.
```

A runtime entrambi i metodi apparirebbero come:

```java
void testInput(List inputParam)
```

Java non permette due metodi con signature identiche nella stessa classe, quindi l’overload viene rifiutato a compile time.

<a id="1848-overloading-di-un-metodo-generico-ereditato-da-una-classe-parent"></a>
### 18.4.8 Overloading di un Metodo Generico Ereditato da una Classe Parent

La stessa regola si applica quando una subclass tenta di introdurre un metodo che, dopo erasure, ha la stessa signature di uno nella superclass.

```java
public class SubDemo extends Demo {
    public void testInput(List<Integer> inputParam) {} 
    // ❌ Errore di compilazione: erasure → testInput(List), uguale al parent
}
```

Ancora una volta, il compilatore rifiuta l’overload perché le signature con erasure collidono.

**Quando l’Overloading Funziona**

L’erasure rimuove solo i parametri generici, non la classe reale usata come parametro del metodo.

Quindi, se due parametri differiscono nel tipo raw (non generico), l’overload è legale.

```java
public class Demo {
    public void testInput(List<Object> inputParam) {}
    public void testInput(ArrayList<String> inputParam) {}  // ✔ Compila
}
```

**Perché funziona**

Anche se ArrayList<String> diventa ArrayList, e List<Object> diventa List, queste sono classi diverse (ArrayList vs List), quindi le signature restano distinte:

```java
void testInput(List inputParam)
void testInput(ArrayList inputParam)
```

Nessuna collisione → overloading legale.

<a id="1849-restituire-tipi-generici--regole-e-restrizioni"></a>
### 18.4.9 Restituire Tipi Generici — Regole e Restrizioni

Quando si restituisce un valore da un metodo, Java segue una regola rigida:

Il tipo di ritorno di un metodo in overriding deve essere un sottotipo del tipo di ritorno del parent, e qualsiasi argomento generico deve rimanere type-compatible (anche se viene cancellato a runtime).

Questo spesso confonde i programmatori, perché i generics nei tipi di ritorno causano conflitti simili a quelli dei parametri.

Punti Chiave:
- La **covarianza del tipo di ritorno si applica solo al tipo raw**, non agli argomenti generici.
- Gli argomenti generici devono restare compatibili dopo l’erasure (devono coincidere).
- **Due metodi non possono differire solo per il parametro generico nel tipo di ritorno**.

Esempio: sostituzione Illegale del Tipo di Ritorno a Causa di Incompatibilità Generica

```java
class A {
    List<String> getData() { return null; }
}

class B extends A {
    // List<Integer> non è un tipo di ritorno covariante di List<String>
    // ❌ Errore di compilazione
    List<Integer> getData() { return null; }
}
```

Spiegazione:

Anche se i generics vengono cancellati, Java impone comunque type safety a livello di sorgente:

```java
List<Integer> non è un sottotipo di List<String>.
```

Entrambi diventano List, ma Java rifiuta l’override che rompe la compatibilità di tipo.

- Esempio: Tipo di Ritorno Covariante Legale

```java
class A {
    Collection<String> getData() { return null; }
}

class B extends A {
    List<String> getData() { return null; }  // ✔ List è sottotipo di Collection
}
```

Questo è permesso perché:
- I tipi raw sono covarianti (List estende Collection).
- Gli argomenti generici coincidono (String vs String).

- 
- Esempio: Overload Illegale Basato Solo sul Tipo di Ritorno

```java
class Demo {
    List<String> getList() { return null; }

    // List<Integer> getList() { return null; }  
    // ❌ Errore di compilazione: il tipo di ritorno da solo non distingue i metodi
}
```

**Java non usa il tipo di ritorno per distinguere metodi in overload**.

<a id="18410-riepilogo-delle-regole-di-erasure"></a>
### 18.4.10 Riepilogo delle Regole di Erasure

- `T senza bound` → erasure a Object.
- `T extends X` → erasure a X.
- `T extends X & Y & Z` → erasure a X.
- Tutti i parametri generici vengono cancellati nelle signature dei metodi.
- Vengono inseriti cast per preservare la tipizzazione a compile-time.
- Possono essere generati metodi bridge per preservare il polimorfismo.

---

<a id="185-bound-sui-parametri-di-tipo"></a>
## 18.5 Bound sui Parametri di Tipo

<a id="1851-upper-bounds-extends"></a>
### 18.5.1 Upper Bounds: extends

`<T extends Number>` significa **T deve essere Number o una sottoclasse**.

```java
class Stats<T extends Number> {
    T num;
    Stats(T num) { this.num = num; }
}
```

<a id="1852-bound-multipli"></a>
### 18.5.2 Bound Multipli

Sintassi: `T extends Class & Interface1 & Interface2 ...`
La classe deve comparire per prima.

```java
class C<T extends Number & Comparable<T>> { }
```

<a id="1853-wildcard---extends--super"></a>
### 18.5.3 Wildcard: `?`, `? extends`, `? super`

<a id="18531-wildcard-non-limitata-"></a>
#### 18.5.3.1 Wildcard Non Limitata `?`

Da utilizzare quando si vuole accettare una lista di tipo sconosciuto:

```java
void printAll(List<?> list) { ... }
```

<a id="18532-wildcard-con-upper-bound--extends"></a>
#### 18.5.3.2 Wildcard con Upper Bound `? extends`

```java
List<? extends Number> nums = List.of(1, 2, 3);

Number n = nums.get(0);   // OK
// nums.add(5);           // ❌ non si può aggiungere: type safety
```

> Non puoi aggiungere elementi (eccetto null) a `? extends` perché non conosci il sottotipo esatto.

<a id="18533-wildcard-con-lower-bound--super"></a>
#### 18.5.3.3 Wildcard con Lower Bound `? super`

`<? super Integer>` significa **il tipo deve essere Integer o una superclasse di Integer**.

```java
List<? super Integer> list = new ArrayList<Number>();
list.add(10);    // OK

Object o = list.get(0); // restituisce Object (supertype comune minimo)
```

> **IMPORTANT**
>
> `super` accetta **inserimento**
>
> `extends` accetta **estrazione**.

---

<a id="186-generics-ed-ereditarietà"></a>
## 18.6 Generics ed Ereditarietà

> I generics NON partecipano all’ereditarietà.  
> Un `List<String>` non è sottotipo di `List<Object>`; i tipi parametrizzati sono invarianti.

```java
List<String> ls = new ArrayList<>();
List<Object> lo = ls;      // ❌ errore di compilazione
```

Invece:

```java
List<? extends Object> ok = ls;   // funziona
```

---

<a id="187-type-inference-operatore-diamond"></a>
## 18.7 Type Inference (Operatore Diamond)

```java
Map<String, List<Integer>> map = new HashMap<>();
```

Il compilatore deduce gli argomenti generici dall’assegnazione.

---

<a id="188-raw-types-compatibilità-legacy"></a>
## 18.8 Raw Types (Compatibilità Legacy)

Un **raw type** disabilita i generics, reintroducendo comportamenti non sicuri.

```java
List raw = new ArrayList();
raw.add("x");
raw.add(10);   // permesso, ma non sicuro
```

> I raw types dovrebbero essere evitati.

---

<a id="189-array-generici-non-permessi"></a>
## 18.9 Array Generici (Non Permessi)

Non puoi creare array di tipi parametrizzati:

```java
List<String>[] arr = new List<String>[10];   // ❌ errore di compilazione
```

Perché gli array applicano type safety a runtime mentre i generics si basano solo su controlli a compile-time.

---

<a id="1810-bounded-type-inference"></a>
## 18.10 Bounded Type Inference

```java
static <T extends Number> T identity(T x) { return x; }

int v = identity(10);   // OK
// String s = identity("x"); // ❌ non è un Number
```

---

<a id="1811-wildcard-vs-parametri-di-tipo"></a>
## 18.11 Wildcard vs Parametri di Tipo

Usa le **wildcard** quando ti serve flessibilità nei parametri.
Usa i **parametri di tipo** quando il metodo deve restituire o mantenere informazioni di tipo.

- Esempio — wildcard troppo debole:

```java
List<?> copy(List<?> list) {
   return list;  // perde informazioni di tipo
}
```

Meglio:

```java
<T> List<T> copy(List<T> list) {
    return list;
}
```

---

<a id="1812-regola-pecs-producer-extends-consumer-super"></a>
## 18.12 Regola PECS (Producer Extends, Consumer Super)

Usa **? extends** quando il parametro **produce** valori.
Usa **? super** quando il parametro **consuma** valori.

```java
List<? extends Number> listExtends = List.of(1, 2, 3);
List<? super Integer> listSuper = new ArrayList<Number>();

// ? extends → lettura sicura
Number n = listExtends.get(0);

// ? super → scrittura sicura
listSuper.add(10);
```

---

<a id="1813-errori-comuni"></a>
## 18.13 Errori Comuni

- Ordinare liste con wildcard: List<? extends Number> non può accettare inserimenti.
- Fraintendere che List<Object> NON è un supertype di List<String>.
- Dimenticare che gli array generici sono illegali.
- Pensare che i tipi generici siano preservati a runtime (vengono cancellati).
- Provare a fare overload di metodi usando solo parametri di tipo diversi.

---

<a id="1814-tabella-riassuntiva-delle-wildcard"></a>
## 18.14 Tabella Riassuntiva delle Wildcard

| Sintassi | Significato |
| --- | --- |
| `?` | tipo sconosciuto (sola lettura eccetto metodi Object) |
| `? extends T` | leggere T in sicurezza, non si può aggiungere (eccetto null) |
| `? super T` | si può aggiungere T, la lettura restituisce Object |

---

<a id="1815-riepilogo-dei-concetti"></a>
## 18.15 Riepilogo dei Concetti

```text
Generics = type safety a compile-time
Bound = limitano i tipi legali
Wildcard = flessibilità nei parametri
Type Inference = il compilatore deduce i tipi
Type Erasure = i generics scompaiono a runtime
Bridge Methods = mantengono il polimorfismo
```

---

<a id="1816-esempio-completo"></a>
## 18.16 Esempio Completo

```java
class Repository<T extends Number> {
    private final List<T> store = new ArrayList<>();

    void add(T value) { store.add(value); }

    T first() { return store.isEmpty() ? null : store.get(0); }

    // metodo generico con wildcard
    static double sum(List<? extends Number> list) {
        double total = 0;
        for (Number n : list) total += n.doubleValue();
        return total;
    }
}
```

