# 29. Collezioni Sequenziate & Map Sequenziate

### Indice

- [29. Collezioni Sequenziate & Map Sequenziate](#29-collezioni-sequenziate--map-sequenziate)
  - [29.1 Motivazione e Contesto](#291-motivazione-e-contesto)
  - [29.2 Interfaccia SequencedCollection](#292-interfaccia-sequencedcollection)
    - [29.2.1 Metodi Principali di SequencedCollection](#2921-metodi-principali-di-sequencedcollection)
    - [29.2.2 Implementazioni di SequencedCollection](#2922-implementazioni-di-sequencedcollection)
    - [29.2.3 Viste Invertite](#2923-viste-invertite)
  - [29.3 Interfaccia SequencedMap](#293-interfaccia-sequencedmap)
    - [29.3.1 Metodi Principali di SequencedMap](#2931-metodi-principali-di-sequencedmap)
    - [29.3.2 Implementazioni di SequencedMap](#2932-implementazioni-di-sequencedmap)
    - [29.3.3 Map Invertite](#2933-map-invertite)
  - [29.4 Relazione con le API Esistenti](#294-relazione-con-le-api-esistenti)
    - [29.4.1 Quali Tipi Built-in Sono Sequenziati](#2941-quali-tipi-built-in-sono-sequenziati)
  - [29.5 Trappole Comuni](#295-trappole-comuni)
  - [29.6 Riepilogo](#296-riepilogo)

---

Java 21 introduce le `Collezioni Sequenziate` e le `Map Sequenziate` per unificare e formalizzare l’accesso agli elementi in base al loro ordine di incontro.

Questa aggiunta risolve incoerenze di lunga data tra liste, set, queue, deque e map, fornendo un’API comune per lavorare con il primo e l’ultimo elemento, oltre che con viste invertite.

## 29.1 Motivazione e Contesto

Prima di Java 21, le collezioni ordinate (come List, LinkedHashSet, Deque o LinkedHashMap) esponevano operazioni basate sull’ordine tramite metodi diversi o, in alcuni casi, non le esponevano affatto.
  
Gli sviluppatori dovevano fare affidamento su API specifiche dell’implementazione o su soluzioni indirette.

Le interfacce sequenziate introducono un contratto coerente per tutte le collezioni e map ordinate, rendendo le operazioni basate sull’ordine esplicite, sicure e uniformi.

---

## 29.2 Interfaccia SequencedCollection

`SequencedCollection<E>` è una nuova interfaccia che estende `Collection<E>` e rappresenta collezioni con un ordine di incontro ben definito.

È implementata da `List`, `Deque` e `LinkedHashSet` (`TreeSet` è ordinato ma non implementa direttamente SequencedCollection).

### 29.2.1 Metodi Principali di SequencedCollection

L’interfaccia definisce metodi per accedere e manipolare gli elementi a entrambe le estremità della collezione.

| Metodo | Descrizione |
|-------|-------------|
| `E getFirst()` | Restituisce il primo elemento |
| `E getLast()` | Restituisce l’ultimo elemento |
| `void addFirst(E e)` | Inserisce un elemento all’inizio |
| `void addLast(E e)` | Inserisce un elemento alla fine |
| `E removeFirst()` | Rimuove e restituisce il primo elemento |
| `E removeLast()` | Rimuove e restituisce l’ultimo elemento |
| `SequencedCollection<E> reversed()` | Restituisce una vista invertita |

### 29.2.2 Implementazioni di SequencedCollection

I seguenti tipi standard implementano SequencedCollection:

| Tipo | Note |
|------|------|
| **List** | Ordinata per indice |
| **Deque** | Coda a doppia estremità |
| **LinkedHashSet** | Mantiene l’ordine di inserimento |

### 29.2.3 Viste Invertite

La chiamata a `reversed()` non crea una copia.

Restituisce una vista live della stessa collezione con ordine invertito.

```java
List<Integer> list = new ArrayList<>(List.of(1, 2, 3));
SequencedCollection<Integer> rev = list.reversed();

rev.removeFirst(); // rimuove 3
System.out.println(list); // [1, 2]
```

!!! note
    Le viste invertite condividono la stessa collezione sottostante.
    Le modifiche strutturali in una delle due viste influenzano anche l’altra:
    modificare sia la collezione originale sia la vista invertita ha effetto su entrambe.

---

## 29.3 Interfaccia SequencedMap

`SequencedMap<K,V>` estende `Map<K,V>` e rappresenta map con un ordine di incontro delle entry ben definito.

Standardizza operazioni che in precedenza esistevano solo in implementazioni specifiche come `LinkedHashMap`.

### 29.3.1 Metodi Principali di SequencedMap

| Metodo | Descrizione |
|--------|-------------|
| `Entry<K,V> firstEntry()` | Prima entry della map |
| `Entry<K,V> lastEntry()` | Ultima entry della map |
| `Entry<K,V> pollFirstEntry()` | Rimuove e restituisce la prima entry, oppure null se vuota |
| `Entry<K,V> pollLastEntry()` | Rimuove e restituisce l’ultima entry, oppure null se vuota |
| `SequencedMap<K,V> reversed()` | Vista invertita della map |

### 29.3.2 Implementazioni di SequencedMap

Attualmente, la principale implementazione standard è:

| Tipo | Ordinamento |
|------|-------------|
| `LinkedHashMap` | Ordine di inserimento (o ordine di accesso se configurato) |

!!! note
    LinkedHashMap può riordinare le entry in lettura se costruita con `accessOrder=true`.
    
    In tal caso, “prima” e “ultima” riflettono l’ordine di accesso più recente.

### 29.3.3 Map Invertite

Come per le collezioni, `reversed()` su una map sequenziata restituisce una vista, non una copia.

```java
SequencedMap<String, Integer> map =
new LinkedHashMap<>(Map.of("A", 1, "B", 2, "C", 3));

SequencedMap<String, Integer> rev = map.reversed();

rev.pollFirstEntry(); // rimuove C=3
System.out.println(map); // {A=1, B=2}
```

!!! note
    Come per SequencedCollection, `reversed()` restituisce una vista live — le mutazioni si applicano a entrambe le map.

---

## 29.4 Relazione con le API Esistenti

Le interfacce sequenziate non sostituiscono i tipi di collezione esistenti.

Si collocano sopra di essi nella gerarchia e unificano i comportamenti comuni.

Tutte le collezioni ordinate esistenti beneficiano automaticamente di queste API senza rompere la retrocompatibilità.

### 29.4.1 Quali Tipi Built-in Sono Sequenziati?

La tabella seguente riassume se i tipi standard di collezione sono ordinati
e se implementano le nuove interfacce Sequenced.

| Tipo | Ordinato? | SequencedCollection? | SequencedMap? |
|------|-----------|----------------------|----------------|
| `List` | ✔ Sì | ✔ Sì | ✘ No |
| `Deque` | ✔ Sì | ✔ Sì | ✘ No |
| `LinkedHashSet` | ✔ Sì | ✔ Sì | ✘ No |
| `TreeSet` | ✔ Sì (ordinato) | ✘ No* | ✘ No |
| `HashSet` | ✘ No | ✘ No | ✘ No |
| `LinkedHashMap` | ✔ Sì | ✘ No | ✔ Sì |
| `HashMap` | ✘ No | ✘ No | ✘ No |
| `TreeMap` | ✔ Sì (ordinato) | ✘ No | ✘ No |

!!! note
    `TreeSet` è ordinato, ma implementa `SortedSet`/`NavigableSet`, non `SequencedCollection`.

---

## 29.5 Trappole Comuni

- Le interfacce sequenziate definiscono viste, non copie
- `reversed()` riflette le modifiche in modo bidirezionale
- Non tutte le implementazioni di Set o Map sono sequenziate
- HashSet e HashMap non implementano interfacce sequenziate
- L’ordine è garantito solo quando esplicitamente definito
- La rimozione di elementi tramite iterator sulla vista invertita impatta immediatamente l’ordine originale

---

## 29.6 Riepilogo

- Le interfacce sequenziate formalizzano l’ordine di incontro
- Forniscono accesso first/last e inversione
- Funzionano tramite viste live, non copie
- Unificano le API tra liste, deque, set e map
