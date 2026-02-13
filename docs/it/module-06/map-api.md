# 28. Map API

### Indice

- [28. Map API](#28-map-api)
  - [28.1 Caratteristiche Fondamentali di Map](#281-caratteristiche-fondamentali-di-map)
  - [28.2 Principali Implementazioni di Map](#282-principali-implementazioni-di-map)
  - [28.3 Creare Map](#283-creare-map)
  - [28.4 Operazioni di Base sulle Map](#284-operazioni-di-base-sulle-map)
  - [28.5 Iterare su una Map](#285-iterare-su-una-map)
  - [28.6 Determinare l’Uguaglianza nelle Map](#286-determinare-luguaglianza-nelle-map)
  - [28.7 Comportamento Speciale di TreeMap](#287-comportamento-speciale-di-treemap)
  - [28.8 Gestione dei Null](#288-gestione-dei-null)
  - [28.9 Trappole Comuni](#289-trappole-comuni)
  - [28.10 Riepilogo](#2810-riepilogo)

---

L’interfaccia `Map` rappresenta una collezione di **coppie chiave–valore**, dove ogni chiave è associata ad un unico valore.

A differenza degli altri tipi di collezione, `Map` **non** estende `Collection` e quindi possiede una propria gerarchia e regole specifiche.

## 28.1 Caratteristiche Fondamentali di Map

- Ogni chiave è unica; **chiavi duplicate sovrascrivono il valore precedente**
- I valori possono essere duplicati
- Le Map non supportano accesso posizionale (basato su indice)
- L’iterazione avviene tramite `keySet()`, `values()` o `entrySet()`

!!! note
    Una `Map` non è una `Collection`, ma le sue viste (keySet, values, entrySet) sono collezioni.

---

## 28.2 Principali Implementazioni di Map

| Implementazione | Ordinamento | Chiavi Null | Valori Null | Thread-Safe | Note |
|-----------------|------------|-------------|-------------|-------------|------|
| `HashMap` | Nessun ordine | 1 | Molti | No | Veloce, la più comune |
| `LinkedHashMap` | Ordine di inserimento | 1 | Molti | No | Iterazione prevedibile |
| `TreeMap` | Ordinata per chiave | No | Molti | No | Le chiavi devono essere confrontabili |
| `Hashtable` | Nessun ordine | No | No | Sì | Legacy |
| `ConcurrentHashMap` | Nessun ordine | No | No | Sì | Adatta alla concorrenza |

!!! note
    L’ordinamento di `TreeMap` è determinato da `Comparable` o da un `Comparator` fornito al momento della creazione.

---

## 28.3 Creare Map

Le `Map` possono essere create usando costruttori o metodi factory.

```java
Map<String, Integer> map1 = new HashMap<>();
Map<String, Integer> map2 = new LinkedHashMap<>();
Map<String, Integer> map3 = new TreeMap<>();

Map<String, Integer> map4 = Map.of("A", 1, "B", 2);
Map<String, Integer> map5 = Map.ofEntries(
    Map.entry("X", 10),
    Map.entry("Y", 20)
);
```

!!! note
    Le Map create con `Map.of(...)` e `Map.ofEntries(...)` sono **immutabili**. Qualsiasi tentativo di modifica lancia `UnsupportedOperationException`.

---

## 28.4 Operazioni di Base sulle Map

| Metodo | Descrizione | Valore di Ritorno |
|------|-------------|-------------------|
| `put(k, v)` | Aggiunge o sostituisce una associazione | Valore precedente o null |
| `putIfAbsent(k,v)` | Aggiunge solo se la chiave non è presente | Valore esistente o null |
| `get(k)` | Restituisce il valore o null | Valore specifico o null |
| `getOrDefault(k, default)` | Restituisce valore o default | Valore specifico o default |
| `remove(k)` | Rimuove l’associazione | Valore rimosso o null |
| `containsKey(k)` | Verifica presenza chiave | boolean |
| `containsValue(v)` | Verifica presenza valore | boolean |
| `size()` | Numero di entry | int |
| `isEmpty()` | Verifica se vuota | boolean |
| `clear()` | Rimuove tutte le entry | void |
| `V merge(k, v, BiFunction(V, V, V))` | merge(k, v, remappingFunction) | se la chiave è assente → imposta il valore; se presente → function(oldValue, newValue); se la funzione restituisce null → mapping rimosso |

```java
Map<String, String> map = new HashMap<>();
map.put("A", "Apple");
map.put("B", "Banana");

map.put("A", "Avocado"); // sovrascrive il valore

String v = map.get("B"); // Banana
```

---

## 28.5 Iterare su una Map

Le Map vengono iterate tramite le viste:

- `keySet()` → Set di chiavi
- `values()` → Collection di valori
- `entrySet()` → Set di Map.Entry

```java
for (String key : map.keySet()) {
    System.out.println(key);
}

for (String value : map.values()) {
    System.out.println(value);
}

for (Map.Entry<String, String> e : map.entrySet()) {
    System.out.println(e.getKey() + " = " + e.getValue());
}
```

!!! note
    Modificare la map durante l’iterazione su queste viste può lanciare `ConcurrentModificationException` (eccetto per le map concorrenti).

---

## 28.6 Determinare l’Uguaglianza nelle Map

L’uguaglianza tra map è definita come segue:

- Due map sono uguali se contengono le stesse associazioni chiave–valore
- Il confronto delle chiavi usa `equals()`
- Il confronto dei valori usa `equals()`

```java
Map<String, Integer> m1 = Map.of("A", 1, "B", 2);
Map<String, Integer> m2 = Map.of("B", 2, "A", 1);

System.out.println(m1.equals(m2)); // true
```

!!! note
    L’ordine di iterazione non influisce sull’uguaglianza delle map.

---

## 28.7 Comportamento Speciale di TreeMap

TreeMap mantiene le entry in ordinate in base alle chiavi.

```java
Map<Integer, String> tm = new TreeMap<>();
tm.put(3, "C");
tm.put(1, "A");
tm.put(2, "B");

System.out.println(tm); // {1=A, 2=B, 3=C}
```

!!! warning
    Tutte le chiavi in una `TreeMap` devono essere mutuamente confrontabili.
    Mescolare tipi incompatibili causa `ClassCastException` a runtime.

---

## 28.8 Gestione dei Null

| Implementazione | Chiave Null | Valore Null |
|-----------------|-------------|-------------|
| HashMap | Sì (1) | Sì |
| LinkedHashMap | Sì (1) | Sì |
| TreeMap | No | Sì |
| Hashtable | No | No |
| ConcurrentHashMap | No | No |

!!! note
    `TreeMap` accetta valori `null` solo quando non partecipano al confronto delle chiavi. In pratica questo è raro, perché le chiavi null sono vietate e i comparator possono rifiutare i null.
    
    `HashMap` e `LinkedHashMap` consentono `una sola chiave null` — inserirne un’altra sostituisce quella esistente.

---

## 28.9 Trappole Comuni

- Supporre che Map sia una Collection
- Dimenticare che chiavi duplicate sovrascrivono i valori
- Usare chiavi null in TreeMap o ConcurrentHashMap
- Confondere l’ordine di iterazione con l’uguaglianza
- Tentare di modificare map immutabili create con Map.of

---

## 28.10 Riepilogo

- Le Map memorizzano chiavi uniche associate a valori
- L’ordinamento dipende dall’implementazione
- L’uguaglianza è basata sulle coppie chiave–valore
- TreeMap richiede chiavi confrontabili
- Le map immutabili lanciano eccezioni in caso di modifica
