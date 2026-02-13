# 22. Introduzione al Framework delle Collezioni

### Indice

- [22. Introduzione al Framework delle Collezioni](#22-introduzione-al-framework-delle-collezioni)
  - [22.1 Che cos’è il Framework delle Collezioni](#221-che-cosè-il-framework-delle-collezioni)
  - [22.2 Le Interfacce Principali](#222-le-interfacce-principali)
    - [22.2.1 Principali interfacce di Collection](#2221-principali-interfacce-di-collection)
    - [22.2.2 Gerarchia di Map](#2222-gerarchia-di-map)
  - [22.3 Collezioni Sequenced Java-21](#223-collezioni-sequenced-java-21)
  - [22.4 Perché esiste il Framework delle Collezioni](#224-perché-esiste-il-framework-delle-collezioni)
  - [22.5 I due lati del Framework Collections-vs-Maps](#225-i-due-lati-del-framework-collections-vs-maps)
  - [22.6 Tipi generici nel Framework delle Collezioni](#226-tipi-generici-nel-framework-delle-collezioni)
  - [22.7 Mutabilità vs Immutabilità](#227-mutabilità-vs-immutabilità)
  - [22.8 Aspettative di Prestazioni Big-O](#228-aspettative-di-prestazioni-big-o)
  - [22.9 Riepilogo](#229-riepilogo)

---

Il `Java Collections Framework (JCF)` è un insieme di **interfacce, classi e algoritmi** progettato per memorizzare, manipolare ed elaborare gruppi di dati in modo efficiente.

Fornisce un’architettura unificata per gestire collezioni, consentendo agli sviluppatori di scrivere codice riutilizzabile e interoperabile con comportamenti prevedibili e caratteristiche di prestazioni.

Questo capitolo introduce i concetti fondamentali necessari prima di studiare List, Set, Queue, Map e Sequenced Collections, esplorati in dettaglio nei capitoli successivi.

## 22.1 Che cos’è il Framework delle Collezioni?

Il Framework delle Collezioni fornisce:

- Un **insieme di interfacce** (Collection, List, Set, Queue, Deque, Map…)
- Un **insieme di implementazioni** (ArrayList, HashSet, TreeSet, LinkedList…)
- Un **insieme di algoritmi di utilità** (ordinamento, ricerca, copia, inversione…) in java.util.Collections e java.util.Arrays.
- Un linguaggio comune per le aspettative di prestazioni (complessità Big-O).

Tutte le principali strutture di collezione condividono un design coerente così che il codice che funziona con un’implementazione può spesso essere riutilizzato con un’altra.

---

## 22.2 Le Interfacce Principali

Al cuore del Java Collections Framework c’è un piccolo insieme di **interfacce radice** che definiscono comportamenti generici di gestione dei dati.

- **List**: una collezione `ordinata` di elementi che consente `duplicati`;
- **Set**: una collezione che non consente `duplicati`;
- **Queue**: una collezione progettata per contenere elementi in corso di elaborazione, tipicamente FIFO (first-in-first-out), con varianti come priority queue e deque.
- **Map**: una struttura che mappa chiavi a valori, dove non sono consentite chiavi duplicate; ogni chiave può mappare al massimo un valore.


### 22.2.1 Principali interfacce di Collection

Sotto è riportata la gerarchia concettuale.

```text
java.util
├─ Collection<E>
│ ├─ SequencedCollection<E> (Java 21+)
│ │ ├─ List<E>
│ │ │ 	├─ ArrayList<E>
│ │ │ 	└─ LinkedList<E> (also implements Deque<E>)
│ │ └─ Deque<E> (also extends Queue<E>)
│ │ 	├─ ArrayDeque<E>
│ │ 	└─ LinkedList<E>
│ ├─ Set<E>
│ │ 	├─ SequencedSet<E> (Java 21+)
│ │ 	│ 		└─ LinkedHashSet<E>
│ │ 	├─ SortedSet<E>
│ │ 	│ 		└─ NavigableSet<E>
│ │ 	│ 			└─ TreeSet<E>
│ │ 	├─ HashSet<E>
│ │ 	└─ (other Set implementations)
│ ├─ Queue<E>
│ │ 	├─ Deque<E> (already under SequencedCollection<E>)
│ │ 	├─ PriorityQueue<E>
│ │ 	└─ (other Queue implementations)
│ └─ (other Collection implementations)
│
└─ Map<K,V> (not a Collection)
	├─ SequencedMap<K,V> (Java 21+)
	│ 	└─ LinkedHashMap<K,V>
	├─ SortedMap<K,V>
	│ 	└─ NavigableMap<K,V>
	│ 	└─ TreeMap<K,V>
	├─ HashMap<K,V>
	├─ Hashtable<K,V>
	└─ (other Map/ConcurrentMap implementations)
```

L’interfaccia **Map** non estende Collection perché una map memorizza coppie chiave/valore piuttosto che singoli valori.

### 22.2.2 Gerarchia di Map

```text
java.util
└─ Map<K,V>
	├─ SequencedMap<K,V> (Java 21+)
	│ 	└─ LinkedHashMap<K,V>
	├─ SortedMap<K,V>
	│ 	└─ NavigableMap<K,V>
	│ 		└─ TreeMap<K,V>
	├─ HashMap<K,V>
	├─ Hashtable<K,V>
	└─ ConcurrentMap<K,V> (java.util.concurrent)
		└─ ConcurrentHashMap<K,V>
```

---

## 22.3 Collezioni Sequenced (Java 21+)

Java 21 introduce la nuova interfaccia `SequencedCollection`, che formalizza l’idea che una collezione mantenga un **ordine di encounter definito**.
Questo era già vero per List, LinkedHashSet, LinkedHashMap, Deque, ecc., ma ora il comportamento è standardizzato.

- `SequencedCollection` definisce metodi come `getFirst()`, `getLast()`, `addFirst()`, `addLast()`, `removeFirst()`, `removeLast()`, e `reversed()`.
- SequencedSet, SequencedMap estendono l’idea per set e map.

Questo semplifica drasticamente la specifica dei comportamenti di ordinamento e sarà usato in tutti i capitoli seguenti.

---

## 22.4 Perché esiste il Framework delle Collezioni

- Evitare di reinventare le strutture dati
- Fornire algoritmi ben testati e ad alte prestazioni
- Migliorare l’interoperabilità tramite interfacce condivise
- Supportare tipi generici per collezioni type-safe

Prima di Java 1.2, le strutture dati erano ad-hoc, incoerenti e non tipizzate.

Il Collections Framework ha unificato tutto questo in una API coerente.

---

## 22.5 I due lati del Framework: Collections vs. Maps

“Map estende Collection?”
**No.**
Una Map memorizza **coppie**, mentre una Collection memorizza **singoli elementi**.

- Collection = List, Set, Queue, Deque, SequencedCollection
- Map = archivio chiave/valore in stile dizionario

---

## 22.6 Tipi generici nel Framework delle Collezioni

Le collezioni sono quasi sempre usate con i generics. L’uso di raw types è sconsigliato.

```java
List<String> names = new ArrayList<>();
Map<Integer, String> map = new HashMap<>();
```

!!! note
    I generics nelle collezioni funzionano tramite `type erasure`: fai riferimento al Paragrafo "**18.4 Type Erasure**" nel Capitolo: [Generics in Java](../module-04/generics.md).

## 22.7 Mutabilità vs. Immutabilità

Molti metodi nella Collections API restituiscono collezioni **unmodifiable**:

```java
List<String> immutable = List.of("a", "b");
immutable.add("c"); // ❌ UnsupportedOperationException
```

Java fornisce diversi modi per creare collezioni immutabili:

- `List.of()`, `Set.of()`, `Map.of()`
- `List.copyOf(collection)`
- wrapper `Collections.unmodifiableList(...)`
- `Records` usati come contenitori di valori immutabili

!!! note
    Il metodo `Arrays.asList(varargs)`, che è costruito su un array, si comporta diversamente: vedi esempi sotto.

```java

String[] vargs = new String[] {"u", "v", "z"};
List<String> fromAsList = Arrays.asList(vargs);

List<String> immutable1 = List.of(vargs);
immutable1.add("c"); // ❌ UnsupportedOperationException

List<String> immutable2 = List.copyOf(fromAsList);
immutable2.set(0, "k"); // ❌ UnsupportedOperationException


// Non possiamo fare  ADD o REMOVE di elementi da "fromAsList" ma possiamo sostituirli;
// o modificando l’array sottostante "vargs" o mutando la lista stessa:


fromAsList.set(0, "k");  // l’aggiornamento sarà riflesso anche sull’array sottostante.
```

!!! note
    `Arrays.asList(...)` restituisce una vista List a dimensione fissa, ma **mutabile**, supportata dall’array originale.
    Non puoi aggiungere/rimuovere elementi, ma puoi sostituire quelli esistenti.


## 22.8 Aspettative di Prestazioni Big-O

Capire la complessità dei tipi "Collectio" è essenziale. Ecco alcuni esempi comuni:

| Type | Methods | Complexity |
| ---- | ---- | ---- |
| ArrayList | `get()`, `add()`, `remove()` | **`O(1)`**, **`O(1) ammortizzato`**, **`O(n)`**  |
| LinkedList | `get()`, `add/remove first/last` | **`O(n)`**,  **`O(1)`** |
| HashSet | `add()`, `contains()`, `remove()` |   ~ **`O(1)`** |
| TreeSet | `add()`, `contains()`, `remove()`  | **`O(log n)`**  |
| HashMap | `get()/put()`  | ~ **`O(1) in media`**  |
| TreeMap | `get()/put()`  |  **`O(log n)`** |
| Deque | `add/remove first/last`  | **`O(1)`**  |


!!! note
    Questi valori sono medie; il caso peggiore può essere diverso (specialmente per strutture basate su hash).


## 22.9 Riepilogo

- Il Collection Framework è costruito su un piccolo insieme di interfacce principali.
- Java 21 aggiunge Sequenced Collections per unificare il comportamento di ordinamento.
- Le Map non sono Collection — formano una gerarchia parallela.
- Le collezioni fanno massiccio uso dei generics.
- La mutabilità conta — i metodi factory spesso restituiscono collezioni immutabili.
- Le caratteristiche prestazionali sono prevedibili.
