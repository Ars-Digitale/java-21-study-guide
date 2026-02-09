# 23. Operazioni Condivise delle Collezioni & Uguaglianza

### Indice

- [23. Operazioni Condivise delle Collezioni & Uguaglianza](#23-operazioni-condivise-delle-collezioni--uguaglianza)
  - [23.1 Metodi Fondamentali delle Collezioni Disponibili per la Maggior Parte delle Collezioni](#231-metodi-fondamentali-delle-collezioni-disponibili-per-la-maggior-parte-delle-collezioni)
    - [23.1.1 Operazioni di Mutazione](#2311-operazioni-di-mutazione)
    - [23.1.2 Operazioni di Query](#2312-operazioni-di-query)
  - [23.2 Uguaglianza](#232-uguaglianza)
  - [23.3 Comportamento Fail-Fast](#233-comportamento-fail-fast)
  - [23.4 Operazioni Bulk](#234-operazioni-bulk)
  - [23.5 Tipi di Ritorno ed Eccezioni Comuni](#235-tipi-di-ritorno-ed-eccezioni-comuni)
  - [23.6 Tabella di Riepilogo — Operazioni Condivise](#236-tabella-di-riepilogo--operazioni-condivise)

---

Questo capitolo copre le operazioni fondamentali condivise in tutta la Java Collections API, incluso il modo in cui viene determinata l’uguaglianza all’interno delle collezioni stesse.

Questi concetti si applicano a tutte le principali famiglie di collezioni basate su Collection<E> (List, Set, Queue, Deque e le loro varianti Sequenced).

Map condivide diversi comportamenti concettuali (iterazione, uguaglianza) ma non eredita da Collection.

Padroneggiare queste operazioni è essenziale, poiché spiegano come le collezioni si comportano quando si aggiungono, cercano, rimuovono, confrontano, iterano e ordinano elementi.

## 23.1 Metodi Fondamentali delle Collezioni (Disponibili per la Maggior Parte delle Collezioni)

I seguenti metodi provengono dall’interfaccia `Collection<E>` e sono ereditati da **tutte** le principali collezioni eccetto `Map` (che ha una propria famiglia di operazioni).

> [!NOTE]
> `Map` non implementa `Collection`, ma le sue viste `keySet()`, `values()` ed `entrySet()` **sì**, e quindi espongono queste operazioni condivise.

### 23.1.1 Operazioni di Mutazione

- `boolean add(E e)` — Aggiunge un elemento (le liste consentono duplicati).
- `boolean remove(Object o)` — Rimuove il primo elemento corrispondente.
- `void clear()` — Rimuove tutti gli elementi.
- `boolean addAll(Collection<? extends E> c)` — Inserimento bulk.
- `boolean removeAll(Collection<?> c)` — Rimuove tutti gli elementi contenuti nella collezione fornita.
- `boolean retainAll(Collection<?> c)` — Mantiene solo gli elementi corrispondenti.

### 23.1.2 Operazioni di Query

- `int size()` — Numero di elementi.
- `boolean isEmpty()` — Indica se la collezione contiene zero elementi.
- `boolean contains(Object o)` — Si basa sulle regole di uguaglianza degli elementi.
- `Iterator<E> iterator()` — Restituisce un iteratore (fail-fast).
- `Object[] toArray()` e `<T> T[] toArray(T[] a)` — Copia in un array.

---

## 23.2 Uguaglianza

Un’implementazione personalizzata del metodo `equals()` consente di confrontare il tipo e il contenuto di due collezioni.

L’implementazione differirà a seconda che si tratti di `List` o di `Set`.

- Esempio

```java
List<Integer> firstList = List.of(10, 11, 22);
List<Integer> secondList = List.of(10, 11, 22);
List<Integer> thirdList = List.of(22, 11, 10);

System.out.println("firstList.equals(secondList): " + firstList.equals(secondList));
System.out.println("secondList.equals(thirdList): " + secondList.equals(thirdList));

Set<Integer> firstSet = Set.of(10, 11, 22);
Set<Integer> secondSet = Set.of(10, 11, 22);
Set<Integer> thirdSet = Set.of(22, 11, 10);

System.out.println("firstSet.equals(secondSet): " + firstSet.equals(secondSet));
System.out.println("secondSet.equals(thirdSet): " + secondSet.equals(thirdSet));
```

Output

```bash
firstList.equals(secondList): true
secondList.equals(thirdList): false
firstSet.equals(secondSet): true
secondSet.equals(thirdSet): true
```

> [!NOTE]
> - Le List confrontano dimensione, ordine ed uguaglianza degli elementi uno per uno.
> - I Set confrontano solo dimensione e appartenenza — l’ordine di encounter è irrilevante.
> - Due set con gli stessi elementi logici sono uguali anche se mantengono internamente ordini di iterazione diversi.

---

## 23.3 Comportamento Fail-Fast

La maggior parte degli iteratori delle collezioni (eccetto le collezioni concorrenti) sono `fail-fast`: modificare strutturalmente una collezione durante l’iterazione provoca una `ConcurrentModificationException`.

```java
List<Integer> list = new ArrayList<>(List.of(1,2,3));
for (Integer i : list) {
	list.add(99); // ❌ ConcurrentModificationException
}
```

> [!NOTE]
> Usa `Iterator.remove()` quando devi rimuovere elementi durante l’iterazione.
> Il comportamento fail-fast **non è garantito** — l’eccezione viene lanciata secondo il principio del best-effort.
> Non devi fare affidamento sulla sua intercettazione per la correttezza del programma.

---

## 23.4 Operazioni Bulk

- `removeIf(Predicate<? super E> filter)` — Rimuove tutti gli elementi corrispondenti.
- `replaceAll(UnaryOperator<E> op)` — Sostituisce ogni elemento.
- `forEach(Consumer<? super E> action)` — Applica un’azione a ciascun elemento.
- `stream()` — Restituisce uno stream per operazioni di pipeline.

---

## 23.5 Tipi di Ritorno ed Eccezioni Comuni

- `add(E)` restituisce **boolean** — sempre `true` per `ArrayList`, può essere `false` per i `Set` se non avviene alcuna modifica.
- `remove(Object)` restituisce boolean (non l’elemento rimosso).
- `get(int)` lancia `IndexOutOfBoundsException`.
- `iterator().remove()` lancia `IllegalStateException` se chiamato due volte senza `next()`.
- `toArray()` restituisce sempre un `Object[]` — non un `T[]`.

---

## 23.6 Tabella di Riepilogo — Operazioni Condivise

| Operazione                    | Si applica a                | Note                          |
|------------------------------|-----------------------------|-------------------------------|
| `add(e)`                     | Tutte le collezioni eccetto Map | Le List consentono duplicati |
| `remove(o)`                  | Tutte le collezioni eccetto Map | Rimuove la prima occorrenza  |
| `contains(o)`                | Tutte le collezioni eccetto Map | Usa equals()                |
| `size(), isEmpty()`          | Tutte le collezioni         | Tempo costante per la maggior parte |
| `iterator()`                 | Tutte le collezioni         | Fail-fast                     |
| `clear()`                    | Tutte le collezioni         | Rimuove tutti gli elementi    |
| `stream()`                   | Tutte le collezioni         | Restituisce stream sequenziale |
| `removeIf(), replaceAll()`   | Solo List (la maggior parte dei Set non supporta replaceAll) | Operazioni bulk |
| `toArray()`                  | Tutte le collezioni         | Restituisce Object[]          |
