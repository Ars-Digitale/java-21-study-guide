# 25. La API List

### Indice

- [25. La API List](#25-la-api-list)
  - [25.1 Caratteristiche delle List](#251-caratteristiche-delle-list)
  - [25.2 Creare List (Costruttori)](#252-creare-list-costruttori)
    - [25.2.1 Costruttori di ArrayList](#2521-costruttori-di-arraylist)
    - [25.2.2 Costruttori di LinkedList](#2522-costruttori-di-linkedlist)
  - [25.3 Metodi Factory](#253-metodi-factory)
    - [25.3.1 List of immutable](#2531-listof-immutabile)
    - [25.3.2 List copyOf immutable-copy](#2532-listcopyof-copia-immutabile)
    - [25.3.3 Arrays asList fixed-size-list](#2533-arraysaslist-lista-a-dimensione-fissa)
  - [25.4 Operazioni Fondamentali di List](#254-operazioni-fondamentali-di-list)
    - [25.4.1 Aggiungere Elementi](#2541-aggiungere-elementi)
    - [25.4.2 Accedere agli Elementi](#2542-accedere-agli-elementi)
    - [25.4.3 Rimuovere Elementi](#2543-rimuovere-elementi)
    - [25.4.4 Comportamenti e Caratteristiche Importanti](#2544-comportamenti-e-caratteristiche-importanti)
  - [25.5 contains, equals e hashCode](#255-contains-equals-e-hashcode)
    - [25.5.1 contains](#2551-contains)
    - [25.5.2 Uguaglianza delle List](#2552-uguaglianza-delle-list)
    - [25.5.3 hashCode](#2553-hashcode)
  - [25.6 Iterare una List](#256-iterare-una-list)
    - [25.6.1 Ciclo For Classico](#2561-ciclo-for-classico)
    - [25.6.2 Ciclo For Migliorato](#2562-ciclo-for-migliorato)
    - [25.6.3 Iterator--ListIterator](#2563-iterator--listiterator)
  - [25.7 Il Metodo subList](#257-il-metodo-sublist)
    - [25.7.1 Sintassi](#2571-sintassi)
    - [25.7.2 Regole](#2572-regole)
    - [25.7.3 Esempi](#2573-esempi)
    - [25.7.4 Modificare la lista padre invalida la vista](#2574-modificare-la-lista-padre-invalida-la-vista)
    - [25.7.5 Modificare la subList modifica il padre](#2575-modificare-la-sublist-modifica-il-padre)
    - [25.7.6 Svuotare la subList svuota parte della lista padre](#2576-svuotare-la-sublist-svuota-parte-della-lista-padre)
    - [25.7.7 Trappole Comuni](#2577-trappole-comuni)
  - [25.8 Tabella Riassuntiva delle Operazioni Importanti](#258-tabella-riassuntiva-delle-operazioni-importanti)

---

Nel `Collections Framework`, una **List** rappresenta una collezione ordinata, basata su indice, che consente duplicati.


L’interfaccia List estende `Collection` ed è implementata da:

```text
List
├── ArrayList (Array ridimensionabile — accesso casuale veloce, inserimenti/rimozioni più lenti nel mezzo)
├── LinkedList (Lista doppiamente collegata — inserimenti/rimozioni veloci, accesso casuale più lento)
└── Vector (Lista sincronizzata legacy — raramente usata oggi)
```

> [!NOTE]
> Vector è legacy e sincronizzato — evitarlo a meno che non sia esplicitamente richiesto.

## 25.1 Caratteristiche delle List

- Ordinate — gli elementi preservano l’ordine di inserimento.
- Indicizzate — accessibili tramite `get(int)` e `set(int,E)`.
- Consentono duplicati — `List` non impone unicità.
- Possono contenere `null` — a meno di usare implementazioni speciali.

---

## 25.2 Creare List (Costruttori)

### 25.2.1 Costruttori di ArrayList

```java
List<String> a1 = new ArrayList<>();
List<String> a2 = new ArrayList<>(50); // capacità iniziale
List<String> a3 = new ArrayList<>(List.of("A", "B"));
```

> [!NOTE]
> La capacità iniziale non è una dimensione. Decide solo quanti elementi l’array interno può contenere prima di ridimensionarsi.

### 25.2.2 Costruttori di LinkedList

```java
List<String> l1 = new LinkedList<>();
List<String> l2 = new LinkedList<>(List.of("A", "B"));
```

> [!NOTE]
> `LinkedList` implementa anche `Deque`.

---

## 25.3 Metodi Factory

### 25.3.1 `List.of()` (immutabile)

```java
List<String> list1 = List.of("A", "B", "C");
list1.add("X"); // ❌ UnsupportedOperationException
list1.set(0, "Z"); // ❌ UnsupportedOperationException
```

> [!NOTE]
> Tutte le liste `List.of()`:
> - non accettano i `null`
> - sono immutabili
> - lanciano `UOE` su modifiche strutturali

### 25.3.2 `List.copyOf()` (copia immutabile)

```java
List<String> src = new ArrayList<>();
src.add("Hello");

List<String> copy = List.copyOf(src); // snapshot immutabile
```

### 25.3.3 Arrays.asList() (lista a dimensione fissa)

```java
String[] arr = {"A", "B"};
List<String> list = Arrays.asList(arr);

list.set(0, "Z"); // OK
list.add("X"); // ❌ UOE — la dimensione è fissa
```

> [!NOTE]
> La lista è supportata dall’array: modificare uno modifica anche l’altro.

---

## 25.4 Operazioni Fondamentali di List

### 25.4.1 Aggiungere Elementi

```java
list.add("A");
list.add(1, "B"); // inserisce all’indice
list.addAll(otherList);
list.addAll(2, otherList);
```

### 25.4.2 Accedere agli Elementi

```java
String x = list.get(0);
list.set(1, "NewValue");
```

> [!NOTE]
> `get()` lancia `IndexOutOfBoundsException` per indici non validi.

Se si tenta di `aggiornare` un elemento in una List vuota, anche all’indice 0, si ottiene una `IndexOutOfBoundsException`

```java
List<Integer> list = new ArrayList<Integer>();
list.add(3);
list.add(5);
System.out.println(list.toString());
list.clear();
list.set(0, 2);
```

Output

```bash
[3, 5]
Exception in thread "main" java.lang.IndexOutOfBoundsException: Index 0 out of bounds for length 0
```

> [!WARNING]
> Chiamare get/set con un indice non valido lancia IndexOutOfBoundsException

### 25.4.3 Rimuovere Elementi

```java
list.remove(0); // remove(int index) — rimuove per indice; remove(Object) — rimuove il primo elemento uguale
list.remove("A"); // rimuove la prima occorrenza
list.removeIf(s -> s.startsWith("X"));
list.clear();
```

### 25.4.4 Comportamenti e Caratteristiche Importanti

|		Operazione		|		Comportamento			|		Eccezione(i)			|
|-----------------------|---------------------------|-------------------------------|
|		`add(E)`			|	aggiunge sempre in coda	|		—						|
|		`add(int,E)`		|	sposta gli elementi a destra	|	IndexOutOfBoundsException	|
|		`get(int)`		|	tempo costante per ArrayList, lineare per LinkedList |	IndexOutOfBoundsException	|
|		`set(int,E)`		|	sostituisce l’elemento	|	IndexOutOfBoundsException	|
|		`remove(int)`		|	sposta gli elementi a sinistra	|	IndexOutOfBoundsException	|
|		`remove(Object)`	|	rimuove il primo elemento uguale	|	—	|

---

## 25.5 `contains()`, `equals()` e `hashCode()`

### 25.5.1 `contains()`

Il metodo `contains()` usa `.equals()` sugli elementi.

### 25.5.2 Uguaglianza delle List

`List.equals()` esegue un confronto elemento per elemento, in ordine.

```java
List<String> a = List.of("A", "B");
List<String> b = List.of("A", "B");

System.out.println(a.equals(b)); // true
```

> [!NOTE]
> - L’ordine conta.
> - Il tipo di lista NON conta.

### 25.5.3 `hashCode()`

Calcolato in base al contenuto.

---

## 25.6 Iterare una List

### 25.6.1 Ciclo For Classico

```java
for (int i = 0; i < list.size(); i++) {
	System.out.println(list.get(i));
}
```

### 25.6.2 Ciclo For Migliorato

```java
for (String s : list) {
	System.out.println(s);
}
```

### 25.6.3 Iterator & ListIterator

```java
Iterator<String> it = list.iterator();
while (it.hasNext()) { System.out.println(it.next()); }

ListIterator<String> lit = list.listIterator();
while (lit.hasNext()) {
	if (lit.next().equals("A")) lit.set("Z");
}
```

> [!WARNING]
> Tutti gli iteratori standard di List sono fail-fast: una modifica strutturale fuori dall’iteratore causa ConcurrentModificationException.

> [!NOTE]
> Solo `ListIterator` supporta l’iterazione bidirezionale e la modifica.

---

## 25.7 Il Metodo `subList()`

`subList()` crea una vista di una porzione della lista, non una copia.
Modificare una delle due può modificare l’altra.

### 25.7.1 Sintassi

```java
List<E> subList(int fromIndex, int toIndex);
```

### 25.7.2 Regole

|			Regola						|				Spiegazione				|
|---------------------------------------|---------------------------------------|
|	fromIndex inclusivo					|	l’elemento a fromIndex è incluso	|
|	toIndex esclusivo					|	l’elemento a toIndex NON è incluso  |
|	La vista è supportata dalla lista originale	|	modificare una modifica l’altra  	|
|	Modifica strutturale del padre invalida la subList	|	→ ConcurrentModificationException	|

### 25.7.3 Esempi

```java
List<String> list = new ArrayList<>(List.of("A", "B", "C", "D"));
List<String> view = list.subList(1, 3);
// view = ["B", "C"]

view.set(0, "X");
// list = ["A", "X", "C", "D"]
// view = ["X", "C"]
```

### 25.7.4 Modificare la lista padre invalida la vista

```java
List<String> list = new ArrayList<>(List.of("A","B","C","D"));
List<String> view = list.subList(1, 3);

list.add("E"); // modifica strutturale della lista padre

view.get(0); // ❌ ConcurrentModificationException
```

### 25.7.5 Modificare la subList modifica il padre

```java
view.remove(1);
// rimuove "C" sia dalla view che dalla lista padre
```

### 25.7.6 Svuotare la subList svuota parte della lista padre

```java
view.clear();
// rimuove gli indici 1 e 2 dalla lista padre
```

### 25.7.7 Trappole Comuni

- Supporre che subList sia indipendente: è una vista, non una copia
- Supporre che subList consenta il ridimensionamento: funziona solo su liste padre modificabili
- Dimenticare che le modifiche al padre invalidano la vista causando ConcurrentModificationException
- Aspettative errate sugli indici: l’indice finale è esclusivo

---

## 25.8 Tabella Riassuntiva delle Operazioni Importanti


| 	Operazione		| 		ArrayList		| 		LinkedList 		| 		List Immutabili 	|
|-------------------|-----------------------|-----------------------|---------------------------|
| `add(E)`			|	veloce				|	veloce				|	❌ non supportato			|
| `add(index,E)`		|	lento (shift)		|	veloce				|	❌						|
| `get(index)`		|	veloce				|	lento				|	veloce					|
| `remove(index)` 	| 	lento 				| lento (a meno che si rimuova primo/ultimo) 		  | ❌ |						
| `remove(Object)`	|	più lento			|	più lento			|	❌						|
| `set(index,E)`		|	veloce				|	lento				|	❌						|
| `iterator()`		|	veloce				|	veloce				|	veloce					|
| `listIterator()`	|	veloce				|	veloce				|	veloce					|
| `contains(Object)`	|	O(n)				|	O(n)				|	O(n)					|
```
