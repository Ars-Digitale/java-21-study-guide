# 26. Set API

<a id="indice"></a>
### Indice

- [26. Set API ](#26-set-api)
  - [26.1 Gerarchia dei Set Java-Collections-Framework](#261-gerarchia-dei-set-java-collections-framework)
  - [26.2 Caratteristiche di Ogni Implementazione di Set](#262-caratteristiche-di-ogni-implementazione-di-set)
    - [26.2.1 HashSet](#2621-hashset)
    - [26.2.2 LinkedHashSet](#2622-linkedhashset)
    - [26.2.3 TreeSet](#2623-treeset)
  - [26.3 Regole di Uguaglianza nei Set](#263-regole-di-uguaglianza-nei-set)
    - [26.3.1 HashSet--LinkedHashSet](#2631-hashset--linkedhashset)
    - [26.3.2 TreeSet](#2632-treeset)
  - [26.4 Creare Istanze di Set](#264-creare-istanze-di-set)
    - [26.4.1 Usando i Costruttori](#2641-usando-i-costruttori)
    - [26.4.2 Costruttori di Copia](#2642-costruttori-di-copia)
    - [26.4.3 Metodi Factory](#2643-metodi-factory)
  - [26.5 Operazioni Principali sui Set](#265-operazioni-principali-sui-set)
    - [26.5.1 Aggiungere Elementi](#2651-aggiungere-elementi)
    - [26.5.2 Verificare l’Appartenenza](#2652-verificare-lappartenenza)
    - [26.5.3 Rimuovere Elementi](#2653-rimuovere-elementi)
    - [26.5.4 Operazioni Bulk](#2654-operazioni-bulk)
  - [26.6 Trappole Comuni](#266-trappole-comuni)
  - [26.7 Tabella Riassuntiva](#267-tabella-riassuntiva)

---

Un **Set** in Java rappresenta una collezione che **non contiene elementi duplicati**.  

Modella il concetto matematico di `insieme`: non ordinato (a meno di usare un’implementazione ordinata) e composto da valori unici.

Tutte le implementazioni di Set si basano su **semantiche di uguaglianza** (tramite `equals()` oppure logica di `Comparator`).

<a id="261-gerarchia-dei-set-java-collections-framework"></a>
## 26.1 Gerarchia dei Set (Java Collections Framework)

```text
Set<E>
 ├── SequencedSet<E> (Java 21+)
 │    └── LinkedHashSet<E>   (ordinato)
 ├── HashSet<E>              (non ordinato)
 └── SortedSet<E>
      └── NavigableSet<E>
           └── TreeSet<E>    (ordinato)
```

Tutte le implementazioni di `Set` richiedono:  
- unicità degli elementi  
- uguaglianza e hashing prevedibili (a seconda dell’implementazione)

!!! note
    `LinkedHashSet` è ora formalmente un `SequencedSet` a partire da Java 21.

---

<a id="262-caratteristiche-di-ogni-implementazione-di-set"></a>
## 26.2 Caratteristiche di Ogni Implementazione di Set

<a id="2621-hashset"></a>
### 26.2.1 HashSet

- Set generico più veloce  
- Non ordinato (nessuna garanzia sull’ordine di iterazione)  
- Usa `hashCode()` ed `equals()`  
- Consente un solo elemento `null`  

```java
Set<String> set = new HashSet<>();
set.add("A");
set.add("B");
set.add("A");   // duplicato ignorato
System.out.println(set); // ordine non garantito
```

<a id="2622-linkedhashset"></a>
### 26.2.2 LinkedHashSet

- Mantiene l’**ordine di inserimento**  
- Leggermente più lento di HashSet  
- Utile quando è richiesto un ordine di iterazione prevedibile

```java
Set<String> set = new LinkedHashSet<>();
set.add("A");
set.add("C");
set.add("B");
System.out.println(set);  // [A, C, B]
```

<a id="2623-treeset"></a>
### 26.2.3 TreeSet

Un Set **ordinato** il cui ordine è determinato da:  
1. Ordinamento naturale (`Comparable`)  
2. Un `Comparator` fornito  

TreeSet:  
- Non consente elementi `null` (NullPointerException a runtime)  
- Garantisce iterazione ordinata  
- Supporta viste di intervallo: `headSet()`, `tailSet()`, `subSet()`  

```java
TreeSet<Integer> tree = new TreeSet<>();
tree.add(10);
tree.add(1);
tree.add(5);

System.out.println(tree); // [1, 5, 10]
```

!!! note
    `TreeSet` richiede che tutti gli elementi siano mutuamente confrontabili — mescolare tipi non confrontabili produce `ClassCastException`.
    Le operazioni (add, remove, contains) sono O(log n).

---

<a id="263-regole-di-uguaglianza-nei-set"></a>
## 26.3 Regole di Uguaglianza nei Set

Le regole differiscono in base all’implementazione.

<a id="2631-hashset--linkedhashset"></a>
### 26.3.1 HashSet & LinkedHashSet

L’`unicità` è determinata da due metodi:  
- `hashCode()`  
- `equals()`  

Due oggetti sono considerati lo stesso elemento se:
  
1. I loro hash code coincidono  
2. Il loro metodo `equals()` restituisce `true`  

!!! warning
    Se si muta un oggetto dopo averlo aggiunto a un HashSet o LinkedHashSet, il suo hashCode può cambiare e il set può perdere il riferimento a quell’elemento.

<a id="2632-treeset"></a>
### 26.3.2 TreeSet

L’unicità è basata su `compareTo()` o sul `Comparator` fornito.  

Se `compare(a, b) == 0` allora gli oggetti sono considerati duplicati, anche se `equals()` restituisce false.

```java
Comparator<String> comp = (a, b) -> a.length() - b.length();
Set<String> set = new TreeSet<>(comp);

set.add("Hi");
set.add("Yo"); // stessa lunghezza → trattato come duplicato

System.out.println(set);  // ["Hi"]
```

---

<a id="264-creare-istanze-di-set"></a>
## 26.4 Creare Istanze di Set

<a id="2641-usando-i-costruttori"></a>
### 26.4.1 Usando i Costruttori

```java
Set<String> s1 = new HashSet<>();
Set<String> s2 = new LinkedHashSet<>();
Set<String> s3 = new TreeSet<>();
```

<a id="2642-costruttori-di-copia"></a>
### 26.4.2 Costruttori di Copia

```java
List<String> list = List.of("A", "B", "C");

Set<String> copy = new HashSet<>(list); // ordine perso
System.out.println(copy);

Set<String> ordered = new LinkedHashSet<>(list); // mantiene l’ordine della lista
System.out.println(ordered);
```

<a id="2643-metodi-factory"></a>
### 26.4.3 Metodi Factory

```java
Set<String> s1 = Set.of("A", "B", "C");   // immutabile
Set<String> empty = Set.of();             // set immutabile vuoto
```

!!! note
    I set creati tramite factory sono **immutabili**: aggiungere o rimuovere elementi lancia `UnsupportedOperationException`.
    `Set.of(...)` rifiuta duplicati in fase di creazione → IllegalArgumentException e rifiuta null → NullPointerException

---

<a id="265-operazioni-principali-sui-set"></a>
## 26.5 Operazioni Principali sui Set

<a id="2651-aggiungere-elementi"></a>
### 26.5.1 Aggiungere Elementi

```java
set.add("A");          // restituisce true se aggiunto
set.add("A");          // restituisce false se duplicato
```

<a id="2652-verificare-lappartenenza"></a>
### 26.5.2 Verificare l’Appartenenza

```java
set.contains("A");
```

<a id="2653-rimuovere-elementi"></a>
### 26.5.3 Rimuovere Elementi

```java
set.remove("A");
set.clear();
```

<a id="2654-operazioni-bulk"></a>
### 26.5.4 Operazioni Bulk

```java
set.addAll(otherSet);
set.removeAll(otherSet);
set.retainAll(otherSet); // intersezione
```

---

<a id="266-trappole-comuni"></a>
## 26.6 Trappole Comuni

- Usare TreeSet con oggetti non confrontabili → `ClassCastException`
- TreeSet non usa affatto `equals()`: solo comparator/compareTo determina l’unicità
- Usare oggetti mutabili come chiavi di Set → rompe le regole di hashing
- I Set creati con Set.of() sono immutabili — la modifica fallisce
- HashSet non garantisce l’ordine di iterazione
- TreeSet tratta oggetti con compare()==0 come duplicati anche se non uguali

---

<a id="267-tabella-riassuntiva"></a>
## 26.7 Tabella Riassuntiva


| Implementazione | Mantiene l’Ordine? | Consente Null? | Ordinato? | Logica Sottostante |
|-----------------|--------------------|---------------|-----------|--------------------|
| HashSet         | No                 | Sì (1 null)   | No        | hashCode + equals  |
| LinkedHashSet   | Sì (ordine di inserimento) | Sì (1 null) | No | tabella hash + lista collegata |
| TreeSet         | Sì (ordinato)      | No            | Sì (naturale/comparator) | compareTo / Comparator |
