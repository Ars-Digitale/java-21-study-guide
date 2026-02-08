# 21. Java Optional e Streams

### Indice

- [21. Java Optional e Streams](#21-java-optional-e-streams)
  - [21.1 Optional (Optional OptionalInt OptionalLong OptionalDouble)](#211-optional-optional-optionalint-optionallong-optionaldouble)
    - [21.1.1 Creare Optional](#2111-creare-optional)
    - [21.1.2 Leggere valori in sicurezza](#2112-leggere-valori-in-sicurezza)
    - [21.1.3 Trasformare Optional](#2113-trasformare-optional)
    - [21.1.4 Optional e Stream](#2114-optional-e-stream)
    - [21.1.5 Optional per tipi primitivi](#2115-optional-per-tipi-primitivi)
    - [21.1.6 Trappole comuni](#2116-trappole-comuni)
  - [21.2 Che Cos’è uno Stream (E cosa Non è)](#212-che-cosè-uno-stream-e-cosa-non-è)
  - [21.3 Architettura della Pipeline Stream](#213-architettura-della-pipeline-stream)
    - [21.3.1 Sorgenti di Stream](#2131-sorgenti-di-stream)
    - [21.3.2 Operazioni Intermedie](#2132-operazioni-intermedie)
      - [21.3.2.1 Tabella delle operazioni intermedie comuni](#21321-tabella-delle-operazioni-intermedie-comuni)
    - [21.3.3 Operazioni Terminali](#2133-operazioni-terminali)
      - [21.3.3.1 Tabella delle operazioni terminali](#21331-tabella-delle-operazioni-terminali)
  - [21.4 Valutazione Pigra e Short-Circuiting](#214-valutazione-pigra-e-short-circuiting)
  - [21.5 Operazioni Stateless vs Stateful](#215-operazioni-stateless-vs-stateful)
    - [21.5.1 Operazioni Stateless](#2151-operazioni-stateless)
    - [21.5.2 Operazioni Stateful](#2152-operazioni-stateful)
  - [21.6 Ordinamento degli Stream e Determinismo](#216-ordinamento-degli-stream-e-determinismo)
  - [21.7 Stream Paralleli](#217-stream-paralleli)
  - [21.8 Operazioni di Riduzione](#218-operazioni-di-riduzione)
    - [21.8.1 `reduce()`: combinare uno stream in un singolo oggetto](#2181-reduce-combinare-uno-stream-in-un-singolo-oggetto)
      - [21.8.1.1 Modello mentale corretto](#21811-modello-mentale-corretto)
    - [21.8.2 `collect()`](#2182-collect)
    - [21.8.3 Perché `collect()` è diverso da `reduce()`](#2183-perché-collect-è-diverso-da-reduce)
  - [21.9 Trappole Comuni degli Stream](#219-trappole-comuni-degli-stream)
  - [21.10 Stream Primitivi](#2110-stream-primitivi)
    - [21.10.1 Perché gli stream primitivi contano](#21101-perche-gli-stream-primitivi-contano)
    - [21.10.2 Metodi comuni di creazione](#21102-metodi-comuni-di-creazione)
    - [21.10.3 Metodi di mapping specializzati per primitivi](#21103-metodi-di-mapping-specializzati-per-primitivi)
    - [21.10.4 Tabella di mapping tra `Stream<T>` e stream primitivi](#21104-tabella-di-mapping-tra-streamt-e-stream-primitivi)
    - [21.10.5 Operazioni terminali e i loro tipi di risultato](#21105-operazioni-terminali-e-i-loro-tipi-di-risultato)
    - [21.10.6 Trappole e gotcha comuni](#21106-trappole-e-gotcha-comuni)
  - [21.11 Collector (collect(), Collector e i Metodi Factory di Collectors)](#2111-collector-collect-collector-e-i-metodi-factory-di-collectors)
    - [21.11.1 collect() vs Collector](#21111-collect-vs-collector)
    - [21.11.2 Collector core (riferimento rapido)](#21112-collector-core-riferimento-rapido)
    - [21.11.3 Collector di raggruppamento](#21113-collector-di-raggruppamento)
    - [21.11.4 partitioningBy](#21114-partitioningby)
    - [21.11.5 toMap e regole di merge](#21115-tomap-e-regole-di-merge)
    - [21.11.6 collectingAndThen](#21116-collectingandthen)
    - [21.11.7 Come i collector si relazionano agli stream paralleli](#21117-come-i-collector-si-relazionano-agli-stream-paralleli)

---

## 21.1 Optional (Optional, OptionalInt, OptionalLong, OptionalDouble)

`Optional<T>` è un oggetto contenitore che può contenere, o meno, un valore non-null. 

È stato pensato per rendere esplicita l’“assenza di un valore” e per ridurre il rischio di `NullPointerException` forzando i chiamanti a gestire il caso di "assenza".

> [!NOTE]
> - `Optional` è inteso principalmente per **tipi di ritorno**. 
> - È generalmente sconsigliato per attributi, parametri di metodo e contesti di serializzazione (a meno che un contratto API specifico lo richieda).

### 21.1.1 Creare Optional

Ci sono tre metodi factory principali per creare Optional. 

- `Optional.of(value)` → value deve essere non-null; altrimenti viene lanciata `NullPointerException`
- `Optional.ofNullable(value)` → restituisce empty se value è null
- `Optional.empty()` → un Optional esplicitamente vuoto

```java
Optional<String> a = Optional.of("x");
Optional<String> b = Optional.ofNullable(null); // Optional.empty
Optional<String> c = Optional.empty();
```

### 21.1.2 Leggere valori in sicurezza

Gli Optional forniscono molteplici modi per accedere al valore incapsulato.

- `isPresent()` / `isEmpty()` → test di presenza
- `get()` → restituisce il valore o lancia `NoSuchElementException` se non presente (sconsigliato)
- `orElse(defaultValue)` → restituisce valore o default (default valutato immediatamente)
- `orElseGet(supplier)` → restituisce valore o risultato del supplier (supplier valutato lazily)
- `orElseThrow()` → restituisce valore o lancia `NoSuchElementException`
- `orElseThrow(exceptionSupplier)` → restituisce valore o lancia eccezione personalizzata

```java
Optional<String> opt = Optional.of("java");

String v1 = opt.orElse("default");
String v2 = opt.orElseGet(() -> "computed");
String v3 = opt.orElseThrow(); // ok perché opt è presente
```

> [!NOTE]
> - Una trappola comune: `orElse(...)` valuta il suo argomento anche se l’Optional è presente. 
> - Usa `orElseGet(...)` quando il default è laborioso da calcolare.

### 21.1.3 Trasformare Optional

Gli Optional supportano trasformazioni funzionali simili agli stream, ma con semantica “0 o 1 elemento”.

- `map(fn)` → trasforma il valore se presente
- `flatMap(fn)` → trasforma in un Optional "flattened", senza annidamento
- `filter(predicate)` → mantiene il valore solo se il predicate è true

```java
Optional<String> name = Optional.of("Alice");

Optional<Integer> len =
	name.map(String::length); // Optional[5]

Optional<String> filtered =
	name.filter(n -> n.startsWith("A")); // Optional[Alice]
	
System.out.println(len.orElse(0));
System.out.println(filtered.orElseGet(() -> "11"));
```

Output:

```text
5
Alice
```

> [!NOTE]
> - `map` incapsula il risultato in un Optional. 
> - Se la tua funzione di mapping restituisce già un Optional, usa `flatMap` per evitare l’annidamento `Optional<Optional<T>>`.

### 21.1.4 Optional e Stream

Un pattern di pipeline molto comune è fare `map` verso un Optional e poi rimuovere gli "assenti". 

Da Java 9, `Optional` fornisce `stream()` per convertire “presente → un elemento” e “vuoto → zero elementi”.

```java
		Stream<String> words = Stream.of("a", "bb", "ccc");

		words.map(w -> w.length() > 1 ? Optional.of(w.length()) : Optional.<Integer>empty()).flatMap(Optional::stream) // rimuove gli elementi vuoti
				.forEach(System.out::println); 
```

Output:

```text
2
3
```


> [!NOTE]
> Prima di Java 9, questo pattern richiedeva `filter(Optional::isPresent)` più `map(Optional::get)`. 

### 21.1.5 Optional per tipi primitivi

Gli stream primitivi usano optional primitivi per evitare boxing: `OptionalInt`, `OptionalLong`, `OptionalDouble`. 

Essi rispecchiano la API principale di Optional con `getter` primitivi come `getAsInt()`.

- `OptionalInt.getAsInt()` / `OptionalLong.getAsLong()` / `OptionalDouble.getAsDouble()`
- `orElse(...)` / `orElseGet(...)` / `orElseThrow(...)`

```java
OptionalInt m = IntStream.of(3, 1, 2).min(); // OptionalInt[1]
int value = m.orElse(0); // 1
```

### 21.1.6 Trappole comuni

- Non usare `get()` senza controllare la presenza; si preferisca `orElseThrow` o trasformazioni
- Evita di restituire `null` invece di `Optional.empty()`; un riferimento Optional in sé non dovrebbe essere null
- Ricorda: `average()` sugli stream primitivi restituisce sempre `OptionalDouble` (anche per `IntStream` e `LongStream`)
- Usa `orElseGet` quando calcolare il default è costoso in termini di calcolo (Performances)

---

## 21.2 Che Cos’è uno Stream (E cosa non è)


Uno `Stream Java` rappresenta una sequenza di elementi (una pipeline) che supporta operazioni in stile funzionale. 

Gli stream sono progettati per l’elaborazione dei dati, non per l’archiviazione degli stessi.

**Caratteristiche chiave**:


- Uno stream non memorizza dati
- Uno stream è Lazy — non succede nulla su di esso, finché non viene invocata un’operazione terminale
- Uno stream può essere consumato soltanto una volta
- Gli stream incoraggiano operazioni senza effetti collaterali

> [!NOTE]
> Gli stream sono concettualmente simili a query di database: descrivono cosa calcolare, non come iterare.

---

## 21.3 Architettura della Pipeline Stream

Ogni pipeline di stream consiste di tre fasi distinte:

- 1️⃣  **Sorgente**
- 2️⃣  Zero o più **Operazioni Intermedie**
- 3️⃣. Esattamente una **Operazione Terminale**


### 21.3.1 Sorgenti di Stream


Sorgenti comuni di stream includono:

- Collezioni: `collection.stream()`
- Array: `Arrays.stream(array)`
- Canali I/O e file
- Stream infiniti: `Stream.iterate`, `Stream.generate`


```java
List<String> names = List.of("Ana", "Bob", "Carla");

Stream<String> s = names.stream();  
```

### 21.3.2 Operazioni Intermedie


Operazioni intermedie:


- Restituiscono un nuovo stream
- Sono evalualte "Lazily"
- Non innescano l’esecuzione



#### 21.3.2.1 Tabella delle operazioni intermedie comuni:

| Method | Common input Params | Return value | Desctiption |
|--------|--------------|--------------|--------------|
|`filter` | Predicate | `Stream<T>` | filtra lo stream secondo una corrispondenza del predicate |
| `map` | Function | `Stream<R>` | trasforma uno stream attraverso un mapping uno a uno input/output |
| `flatMap` | Function | `Stream<R>` | appiattisce stream annidati in un singolo stream |
| `sorted` | (none) or Comparator | `Stream<T>` | ordina per ordine naturale o per il Comparator fornito |
| `distinct` | (none) | `Stream<T>` | rimuove elementi duplicati |
| `limit` / `skip` | long | `Stream<T>` | limita la dimensione o salta elementi |
| `peek` | Consumer | `Stream<T>` | esegue un’azione con side-effect per ogni elemento (debugging) |


- Esempio:

```java
		List<String> names = List.of("Ana", "Bob", "Carla", "Mario");
		
		names.stream().filter(n -> n.length() > 3).map(String::toUpperCase).forEach(System.out::println);
```

Output:

```text
CARLA
MARIO
```

> [!NOTE]
> Le operazioni intermedie descrivono solo il calcolo. Nessun elemento è ancora elaborato.


### 21.3.3 Operazioni Terminali

Operazioni terminali:


- Innescano l’esecuzione
- Consumano lo stream
- Producono un risultato o un effetto collaterale


#### 21.3.3.1 Tabella delle operazioni terminali:


| Method | Return value | behaviour for infinite streams |
|--------|--------------|--------------------------------|
| `forEach` | **void** | non termina |
| `collect` | varia | non termina |
| `reduce` | varia | non termina |
| `findFirst` / `findAny` |  **`Optional<T>`** |  termina |
| `anyMatch` / `allMatch` / `noneMatch` | **boolean** | può terminare presto (short-circuit) |
| `min` / `max` | **`Optional<T>`** | non termina |  
|  `count` | **long** | non termina |


## 21.4 Valutazione Pigra e Short-Circuiting

```java
var newNames = new ArrayList<String>();

newNames.add("Bob");
newNames.add("Dan");

// Gli stream sono valutati pigramente: questo non attraversa ancora i dati,
// crea solo una descrizione della pipeline legata alla sorgente.
var stream = newNames.stream();

newNames.add("Erin");

// L’operazione terminale innesca la valutazione. Lo stream vede la sorgente aggiornata,
// quindi il count include "Erin".
stream.count(); // 3
```

**Nota importante :**  
Uno stream è legato alla sua *sorgente* (`newNames`), e la pipeline non viene eseguita finché non viene invocata un’operazione terminale.  
Per questa ragione, se **modifichi la collezione prima dell’operazione terminale**, l’operazione terminale “vede” i nuovi elementi (qui, `Erin`).  
In generale, tuttavia, **modificare la sorgente mentre una pipeline stream è in uso è una cattiva pratica** e può portare a comportamento non deterministico (o `ConcurrentModificationException` con alcune sorgenti/operazioni). 
La regola pratica è: *costruisci la sorgente, poi crea ed esegui lo stream senza mutarla*.



Gli stream processano elementi **uno alla volta**, scorrendo “verticalmente” attraverso la pipeline piuttosto che stadio-per-stadio.

Sotto modifichiamo l’esempio per usare un’operazione terminale **short-circuiting**: `findFirst()`.

```java
Stream.of("a", "bb", "ccc")
    .filter(s -> {
        System.out.println("filter " + s);
        return s.length() > 1;
    })
    .map(s -> {
        System.out.println("map " + s);
        return s.toUpperCase();
    })
    .findFirst()
    .ifPresent(System.out::println);
```

Ordine di esecuzione:

> [!NOTE]
> Viene processato solo il numero minimo di elementi richiesti dall’operazione terminale.

```text
filter a
filter bb
map bb
BB
```

`findFirst()` è soddisfatto non appena trova il **primo** elemento che passa con successo attraverso la pipeline (qui `"bb"`), quindi:
- `"ccc"` non viene mai processato (né `filter` né `map`);
- la valutazione pigra evita lavoro non necessario rispetto a un’operazione terminale che consuma tutti gli elementi (come `forEach` o `count`).


---

## 21.5 Operazioni Stateless vs Stateful


### 21.5.1 Operazioni Stateless

Operazioni come `map` e `filter` processano ogni elemento indipendentemente.


### 21.5.2 Operazioni Stateful

Operazioni come `distinct`, `sorted` e `limit` richiedono il mantenimento di stato interno.


> [!NOTE]
> Le operazioni stateful possono impattare severamente le prestazioni degli stream paralleli.

---

## 21.6 Ordinamento degli Stream e Determinismo


Gli stream possono essere:

- Ordinati (es. `List.stream()`)
- Non ordinati (es. `HashSet.stream()`)


Alcune operazioni rispettano l’ordine di encounter:

- `forEachOrdered`
- `findFirst`

> [!NOTE]
> Negli stream paralleli, `forEach` non garantisce ordine.

---

## 21.7 Stream Paralleli

Gli stream paralleli dividono il lavoro tra thread usando il ForkJoinPool.commonPool().


```java
int sum =
IntStream.range(1, 1_000_000)
	.parallel()
		.sum();
```


Regole per stream paralleli sicuri:


- Nessun effetto collaterale
- Nessuno stato condiviso mutabile
- Solo operazioni associative

> [!NOTE]
> Gli stream paralleli possono essere più lenti per carichi di lavoro leggeri.

---

## 21.8 Operazioni di Riduzione


### 21.8.1 `reduce()`: combinare uno stream in un singolo oggetto

Ci sono tre firme di metodo per questa operazione:

- public Optional<T> **reduce**(BinaryOperator<T> accumulator);
- public T **reduce**(T identity, BinaryOperator<T> accumulator);
- public <U> U **reduce**(U identity, BiFunction<U, ? super T, U> accumulator, BinaryOperator<U> combiner)


```java
int sum = Stream.of(1, 2, 3)
	.reduce(0, Integer::sum);
```

La riduzione richiede:

- **Identity**: valore iniziale per ogni riduzione parziale; deve essere un elemento neutro; Esempio: 0 per la somma, 1 per la moltiplicazione, collezione vuota per la raccolta;
- **Accumulator**: incorpora un elemento dello stream in un risultato parziale;
- (Opzionale) **Combiner**: unisce due risultati parziali; Usato solo quando lo stream è parallelo; Ignorato per stream sequenziali

> [!NOTE]
> L’accumulator deve essere associativo e stateless.

#### 21.8.1.1 Modello mentale corretto

- Accumulator: risultato + elemento
- Combiner: risultato + risultato

**Esempio 1**: Uso corretto (somma delle lunghezze)

```java
int totalLength =
    Stream.of("a", "bb", "ccc")
          .parallel()
          .reduce(
              0,                       // identity
              (sum, s) -> sum + s.length(), // accumulator
              (left, right) -> left + right // combiner
          );
```

Cosa succede in parallelo

Supponi che lo stream sia diviso:

- Thread 1: "a", "bb" → 0 + 1 + 2 = 3
- Thread 2: "ccc" → 0 + 3 = 3

in seguito il combiner unisce i risultati parziali:

```bash
3 + 3 = 6
```

**Esempio 2**: Combiner ignorato negli stream sequenziali

```java
int result =
    Stream.of("a", "bb", "ccc")
          .reduce(
              0,
              (sum, s) -> sum + s.length(),
              (x, y) -> {
                  throw new RuntimeException("Never called");
              }
          );
```

**Esempio 3**: Combiner scorretto

```java
int result =
    Stream.of(1, 2, 3, 4)
          .parallel()
          .reduce(
              0,
              (a, b) -> a - b,   // accumulator
              (x, y) -> x - y    // combiner
          );
```

<ins>Perché questo è sbagliato</ins>

**La sottrazione non è associativa**.

Possibile esecuzione:

- Thread 1: 0 - 1 - 2 = -3
- Thread 2: 0 - 3 - 4 = -7

Combiner:

```bash
-3 - (-7) = 4
```

Il risultato sequenziale sarebbe:

```bash
(((0 - 1) - 2) - 3) - 4 = -10
```

> [!WARNING]
> ❌ I risultati paralleli e sequenziali differiscono → riduzione illegale

### 21.8.2 `collect()`

`collect` è una riduzione mutabile ottimizzata per raggruppamento e aggregazione. 

È lo strumento standard della Stream API per la “riduzione mutabile”: accumuli elementi in un contenitore mutabile (come una List, Set, Map, StringBuilder, oggetto risultato custom), 
e poi, opzionalmente, si uniscono i contenitori parziali quando si esegue in parallelo.

La forma generale è:

- public <R> R **collect**(Supplier<R> supplier, BiConsumer<R, ? super T> accumulator, BiConsumer<R, R> combiner);

E una versione comune usata è:

- public <R, A> R **collect**(Collector<? super T, A, R> collector)

dove Collectors.* fornisce collector pre-costruiti (grouping, mapping, joining, counting, ecc.).

**Significato**:

- **supplier**: crea un nuovo contenitore risultato vuoto (es. new ArrayList<>())
- **accumulator**: aggiunge un elemento in quel contenitore (es. list::add)
- **combiner**: unisce due contenitori (es. list1.addAll(list2))

### 21.8.3 Perché `collect()` è diverso da `reduce()`

- **Intento**: mutazione vs immutabilità
	- `reduce()` è progettato per riduzione in stile immutabile: combinare valori in un nuovo valore (es. somma, min, max).
	- `collect()` è progettato per contenitori mutabili: costruire una List, Map, StringBuilder, ecc.
- **Correttezza** in parallelo
	- `reduce()` richiede che l’operazione sia:
		- associativa
		- stateless
		- compatibile con regole di identity/combiner
	- `collect()` è costruito per supportare il parallelismo in sicurezza mediante:
		- creazione di un contenitore per thread (supplier)
		- accumulo locale (accumulator)
		- merge alla fine (combiner)
- **Prestazioni**
	- `collect()` può essere ottimizzato perché il runtime dello stream sa che stai costruendo contenitori:
		- può evitare copie non necessarie
		- può pre-dimensionare o usare implementazioni specializzate (a seconda del collector)
		- è l’approccio idiomatico e atteso
		- usare reduce() per costruire una collezione spesso crea oggetti extra o forza mutazione non sicura.


- Esempio: “collect in una List” nel modo corretto

```java
List<String> longNames =
    names.stream()
         .filter(s -> s.length() > 3)
			.collect(Collectors.toList());
```

- Esempio: groupingBy con spiegazione

```java
Map<Integer, List<String>> byLength =
    names.stream()
         .collect(Collectors.groupingBy(String::length));
```

Cosa succede concettualmente:

- Il collector crea una Map<Integer, List<String>> vuota
- Per ogni name:
	- calcola la chiave (String::length)
	- lo mette nella lista bucket corretta
- In parallelo:
	- ogni thread costruisce le proprie mappe parziali
	- il combiner unisce le mappe unendo le liste per chiave

---

## 21.9 Trappole comuni degli Stream

- Riutilizzare uno stream consumato → `IllegalStateException`
- Modificare variabili esterne dentro le lambda
- Assumere ordine di esecuzione negli stream paralleli
- Usare `peek` per logica invece che per debugging

---

## 21.10 Stream Primitivi

Java fornisce tre tipi di stream specializzati per evitare overhead di boxing e per abilitare operazioni focalizzate sui numeri:

- `IntStream` per `int`
- `LongStream` per `long`
- `DoubleStream` per `double`

Gli stream primitivi sono comunque stream (pipeline lazy, operazioni intermedie + terminali, single-use), ma non sono **generici** e usano interfacce funzionali specializzate per primitivi (es. `IntPredicate`, `LongUnaryOperator`, `DoubleConsumer`).

> [!NOTE]
> Usa stream primitivi quando i dati sono naturalmente numerici o quando le prestazioni contano: evitano overhead di boxing/unboxing e forniscono operazioni terminali numeriche aggiuntive.

### 21.10.1 Perché gli stream primitivi sono importanti

- Prestazioni: evitare l’allocazione di oggetti wrapper e boxing/unboxing ripetuti in pipeline grandi
- Convenienza: riduzioni numeriche integrate come `sum()`, `average()`, `summaryStatistics()`
- Trappole comuni: capire quando i risultati sono primitivi vs `OptionalInt`/`OptionalLong`/`OptionalDouble`

### 21.10.2 Metodi comuni di creazione

I seguenti sono i modi usati più frequentemente per creare stream primitivi. Molte domande di certificazione iniziano identificando il tipo di stream creato da un metodo factory.

| Sources |
|---------|
| IntStream.of(int...) |
| IntStream.range(int startInclusive, int endExclusive) |
| IntStream.rangeClosed(int startInclusive, int endInclusive) |
| IntStream.iterate(int seed, IntUnaryOperator f) // infinito a meno che limitato |
| IntStream.iterate(int seed, IntPredicate hasNext, IntUnaryOperator f)  |
| IntStream.generate(IntSupplier s) // infinito a meno che limitato  |
| LongStream.of(long...) |
| LongStream.range(long startInclusive, long endExclusive) |
| LongStream.rangeClosed(long startInclusive, long endInclusive) |
| LongStream.iterate(long seed, LongUnaryOperator f) |
| LongStream.iterate(long seed, LongPredicate hasNext, LongUnaryOperator f) |
| LongStream.generate(LongSupplier s) |
| DoubleStream.of(double...) |
| DoubleStream.iterate(double seed, DoubleUnaryOperator f) |
| DoubleStream.iterate(double seed, DoublePredicate hasNext, DoubleUnaryOperator f) |
| DoubleStream.generate(DoubleSupplier s) |

> [!IMPORTANT]
> - Solo `IntStream` e `LongStream` forniscono `range()` e `rangeClosed()`. 
> - Non esiste `DoubleStream.range` perché contare con double ha problemi di arrotondamento.

### 21.10.3 Metodi di mapping specializzati per primitivi

Gli stream primitivi forniscono operazioni di mapping **solo per primitivi** che evitano boxing:

- `IntStream.map(IntUnaryOperator)` → `IntStream`
- `IntStream.mapToLong(IntToLongFunction)` → `LongStream`
- `IntStream.mapToDouble(IntToDoubleFunction)` → `DoubleStream`

- `LongStream.map(LongUnaryOperator)` → `LongStream`
- `LongStream.mapToInt(LongToIntFunction)` → `IntStream`
- `LongStream.mapToDouble(LongToDoubleFunction)` → `DoubleStream`

- `DoubleStream.map(DoubleUnaryOperator)` → `DoubleStream`
- `DoubleStream.mapToInt(DoubleToIntFunction)` → `IntStream`
- `DoubleStream.mapToLong(DoubleToLongFunction)` → `LongStream`


### 21.10.4 Tabella di mapping tra `Stream<T>` e stream primitivi

Questa tabella riassume le principali conversioni tra stream di oggetti e stream primitivi. 

La colonna “From” ti dice quali metodi sono disponibili e il tipo di stream target risultante.


| From (source)	| To (target) |	Primary method(s) |
|---------------|-------------|-------------------|
| Stream<T> | Stream<R> | map(Function<? super T, ? extends R>) |
| Stream<T> | Stream<R> (flatten) | flatMap(Function<? super T, ? extends Stream<? extends R>>) |
||||
| Stream<T> | IntStream | mapToInt(ToIntFunction<? super T>) |
| Stream<T> | LongStream | mapToLong(ToLongFunction<? super T>) |
| Stream<T> | DoubleStream | mapToDouble(ToDoubleFunction<? super T>) |
| Stream<T> | IntStream (flatten) | flatMapToInt(Function<? super T, ? extends IntStream>) |
| Stream<T> | LongStream (flatten) | flatMapToLong(Function<? super T, ? extends LongStream>) |
| Stream<T> | DoubleStream (flatten) | flatMapToDouble(Function<? super T, ? extends DoubleStream>) |
||||
| IntStream | Stream<Integer> | boxed() |
| LongStream | Stream<Long> | boxed() |
| DoubleStream | Stream<Double> | boxed() |
||||
| IntStream | Stream<U> | mapToObj(IntFunction<? extends U>) |
| LongStream | Stream<U> | mapToObj(LongFunction<? extends U>) |
| DoubleStream | Stream<U> | mapToObj(DoubleFunction<? extends U>) |
||||
| IntStream | LongStream | asLongStream() |
| IntStream | DoubleStream | asDoubleStream() |
| LongStream | DoubleStream | asDoubleStream() |
		
> [!IMPORTANT]
> - Non esiste un’operazione **`unboxed()`**. 
> - Per passare da wrapper a primitivi devi partire da `Stream<T>` e usare `mapToInt` / `mapToLong` / `mapToDouble`.

### 21.10.5 Operazioni terminali e i loro tipi di risultato

Gli stream primitivi hanno diverse operazioni terminali che sono uniche o hanno tipi di ritorno specifici per primitivi.


| Terminal operation | IntStream returns | LongStream returns | DoubleStream returns |
|--------------------|-------------------|--------------------|----------------------|
| `count()` | long | long | long |
| `sum()` | int | long | double |
| `min()` / max() | OptionalInt | OptionalLong | OptionalDouble |
| `average()` | OptionalDouble | OptionalDouble | OptionalDouble |
| `findFirst()` / findAny() | OptionalInt | OptionalLong | OptionalDouble |
| `reduce(op)` | OptionalInt | OptionalLong | OptionalDouble |
| `reduce(identity, op)` | int | long | double |
| `summaryStatistics()` | IntSummaryStatistics | LongSummaryStatistics | DoubleSummaryStatistics |
			
> [!WARNING]
> - Anche per `IntStream` e `LongStream`, **`average()`** restituisce `OptionalDouble` (non `OptionalInt` o `OptionalLong`).


- Esempio 1: `Stream<String>` → `IntStream` → operazioni terminali primitive.

```java
List<String> words = List.of("a", "bb", "ccc");

int totalLength = words.stream()
	.mapToInt(String::length) // IntStream
		.sum(); // int

// totalLength = 1 + 2 + 3 = 6
```

- Esempio 2: `IntStream` → boxed `Stream<Integer>` (boxing introdotto).

```java
Stream<Integer> boxed = IntStream.rangeClosed(1, 3) // 1,2,3
	.boxed(); // Stream<Integer>
```

- Esempio 3: stream primitivo → stream di oggetti via `mapToObj`.

```java
Stream<String> labels = IntStream.range(1, 4) // 1,2,3
	.mapToObj(i -> "N=" + i); // Stream<String>
```

### 21.10.6 Trappole e gotcha comuni

- Non confondere `Stream<Integer>` con `IntStream`: i loro metodi di mapping e interfacce funzionali differiscono
- `IntStream.sum()` restituisce `int` ma `IntStream.count()` restituisce `long`
- `average()` restituisce sempre `OptionalDouble` per tutti i tipi di stream primitivi
- Usare `boxed()` reintroduce boxing; fallo solo se l’API downstream richiede oggetti (es. raccogliere in `List<Integer>`)
- Fai attenzione alle conversioni di narrowing: `LongStream.mapToInt` e `DoubleStream.mapToInt` possono troncare i valori

---

## 21.11 Collector (collect(), Collector e i Metodi Factory di Collectors)

Un `Collector` descrive come accumulare elementi di stream in un risultato finale. 

L’operazione terminale `collect(...)` esegue questa ricetta. 

La classe utility `Collectors` fornisce collector pronti per compiti comuni di aggregazione.


### 21.11.1 collect() vs Collector

Ci sono due modi principali per raccogliere:

- `collect(Collector)` → la forma comune usando `Collectors.*`
- `collect(supplier, accumulator, combiner)` → riduzione mutabile esplicita (più low-level)

```java
List<String> list =
Stream.of("a", "b")
	.collect(Collectors.toList());

StringBuilder sb =
Stream.of("a", "b")
	.collect(StringBuilder::new, StringBuilder::append, StringBuilder::append);
```

> [!NOTE]
> Usa `collect(supplier, accumulator, combiner)` quando ti serve un contenitore mutabile custom e non vuoi implementare un `Collector` completo.

### 21.11.2 Collector core

Questi sono i collector usati più frequentemente e quelli più probabilmente presenti in domande d’esame.

- `toList()` → `List<T>` (nessuna garanzia su mutabilità/implementazione)
- `toSet()` → `Set<T>`
- `toCollection(supplier)` → tipo di collezione specifico (es. `TreeSet`)
- `joining(delim, prefix, suffix)` → `String` da elementi `CharSequence`
- `counting()` → conteggio `Long`
- `summingInt` / `summingLong` / `summingDouble` → somme numeriche
- `averagingInt` / `averagingLong` / `averagingDouble` → medie numeriche
- `minBy(comparator)` / `maxBy(comparator)` → `Optional<T>`
- `mapping(mapper, downstream)` → trasforma poi raccoglie con downstream
- `filtering(predicate, downstream)` → filtra dentro il collector (Java 9+)

### 21.11.3 Collector di raggruppamento

`groupingBy` classifica elementi in bucket con chiave data da una funzione classifier. 

Produce una `Map<K, V>` dove `V` dipende dal collector downstream.

```java
Map<Integer, List<String>> byLen =
Stream.of("a", "bb", "ccc", "dd")
	.collect(Collectors.groupingBy(String::length));
System.out.println("byLen: " + byLen.toString());
```

Output:

```bash
byLen: {1=[a], 2=[bb, dd], 3=[ccc]}
```


Con un collector downstream controlli cosa contiene ogni bucket:

```java
Map<Integer, Long> countByLen =
Stream.of("a", "bb", "ccc", "dd")
	.collect(Collectors.groupingBy(String::length, Collectors.counting()));
System.out.println("countByLen: " + countByLen.toString());

Map<Integer, Set<String>> setByLen =
Stream.of("a", "bb", "ccc", "dd")
	.collect(Collectors.groupingBy(String::length, Collectors.toSet()));
System.out.println("setByLen: " + setByLen.toString());
```

Output:

```bash
countByLen: {1=1, 2=2, 3=1}
setByLen: {1=[a], 2=[bb, dd], 3=[ccc]}
```


> [!WARNING]
> Fai attenzione al tipo del valore della mappa risultante. Esempio: `groupingBy(..., counting())` produce `Map<K, Long>` (non `int`).

### 21.11.4 partitioningBy

`partitioningBy` divide lo stream in esattamente due gruppi usando un `Predicate` booleano. Restituisce sempre una mappa con chiavi `true` e `false`.

```java
Map<Boolean, List<String>> parts =
Stream.of("a", "bb", "ccc")
	.collect(Collectors.partitioningBy(s -> s.length() > 1));
System.out.println("parts: " + parts.toString());
```

Output:

```bash
parts: {false=[a], true=[bb, ccc]}
```

> [!NOTE]
> `partitioningBy` crea sempre due bucket, mentre `groupingBy` può crearne molti. Entrambi supportano collector downstream.

### 21.11.5 toMap e regole di merge

`toMap` lancia un’eccezione su chiavi duplicate a meno che tu non fornisca una funzione di merge.

```java
Map<Integer, String> m1 =
Stream.of("aa", "bb")
	.collect(Collectors.toMap(String::length, s -> s)); // ❌ Exception in thread "main" java.lang.IllegalStateException: Duplicate key 2 (attempted merging values aa and bb)

Map<Integer, String> m2 =
Stream.of("aa", "bb", "cc")
	.collect(Collectors.toMap(String::length, s -> s, (oldV, newV) -> oldV + "," + newV)); // key=2 merges values
```

Output:

```bash
m2: {2=aa,bb,cc}
```

### 21.11.6 collectingAndThen

`collectingAndThen(downstream, finisher)` ti permette di applicare una trasformazione finale dopo la raccolta (es. rendere la lista non modificabile).

```java
List<String> unmodifiable =
Stream.of("a", "b", "c")
	.collect(Collectors.collectingAndThen(Collectors.toList(), List::copyOf));
```

### 21.11.7 Come i collector si relazionano agli stream paralleli

I collector sono progettati per funzionare con stream paralleli usando supplier/accumulator/combiner internamente. In parallelo, ogni worker costruisce un contenitore di risultato parziale e poi unisce i contenitori.

- L’accumulator muta un contenitore per-thread (nessuno stato condiviso mutabile)
- Il combiner unisce i contenitori (richiesto per esecuzione parallela)
- Alcuni collector sono “concurrent” o hanno caratteristiche che influenzano prestazioni e ordinamento

> [!NOTE]
> preferisci `collect(Collectors.toList())` rispetto a usare `reduce` per costruire collezioni. `reduce` è per riduzioni in stile immutabile; `collect` è per contenitori mutabili.










