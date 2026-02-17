# 24. Comparable, Comparator & Ordinamento in Java

<a id="indice"></a>
### Indice


- [24.1 Comparable — Ordinamento Naturale](#241-comparable--ordinamento-naturale)
	- [24.1.1 Contratto del Metodo di Comparable](#2411-contratto-del-metodo-di-comparable)
	- [24.1.2 Classe di Esempio che Implementa Comparable](#2412-esempio-classe-che-implementa-comparable)
	- [24.1.3 Errori Comuni di Comparable](#2413-errori-comuni-di-comparable)
- [24.2 Comparator — Ordinamento Personalizzato](#242-comparator--ordinamento-personalizzato)
	- [24.2.1 Metodi Principali di Comparator](#2421-metodi-principali-di-comparator)
		- [24.2.1.1 Metodi di Supporto **Statici** di Comparator](#24211-metodi-di-supporto-statici-di-comparator)
		- [24.2.1.2 Metodi di **Istanza** su Comparator](#24212-metodi-di-istanza-su-comparator)
	- [24.2.2 Esempio di Comparator](#2422-esempio-di-comparator)
- [24.3 Comparable vs Comparator](#243-comparable-vs-comparator)
- [24.4 Ordinamento di Array e Collezioni](#244-ordinamento-di-array-e-collezioni)
	- [24.4.1 Arrays sort](#2441-arrays-sort)
	- [24.4.2 Collections sort](#2442-collections-sort)
- [24.5 Ordinamento Multi-Livello thenComparing](#245-ordinamento-multi-livello-thencomparing)
- [24.6 Confrontare Primitivi in Modo Efficiente](#246-confrontare-primitivi-in-modo-efficiente)
- [24.7 Trappole Comuni](#247-trappole-comuni)
- [24.8 Esempio Completo](#248-esempio-completo)
- [24.9 Riepilogo](#249-riepilogo)


---


Java fornisce due strategie principali per l’ordinamento e il confronto: `Comparable` (ordinamento naturale) e `Comparator` (ordinamento personalizzato).

Comprendere le loro regole, i vincoli e le interazioni con i `generics` è essenziale.

- Per i **tipi numerici**, l’ordinamento segue l’ordine numerico naturale, il che significa che i valori più piccoli vengono prima di quelli più grandi.
- L’ordinamento delle **stringhe** segue l’ordine lessicografico (`code point` Unicode): confronto carattere per carattere; le cifre vengono prima delle maiuscole, le maiuscole prima delle minuscole.

Questo ordinamento si basa sul `code point Unicode` di ogni carattere, non sull’intuizione alfabetica.

Un **Unicode code point** è un valore numerico unico assegnato ai caratteri nell'Unicode standard.

Più precisamente:
un `Unicode code point` è un integer (scritto in esadecimale come U+XXXX) che rappresenta uno specifico carattere, simbolo, o  carattere speciale indipendentemente da font, lingua, o piattaforma.

- Esempi:
	- U+0041 → A
	- U+0061 → a
	- U+0030 → 0
	- U+1F600 → 😀

Un code point non è una sequenza di byte; è un numero astratto.

Come il code point sia poi stoccato nella memoria fisica dipende dall'encoding (UTF-8, UTF-16, UTF-32).

Unicode definisce code point da U+0000 a U+10FFFF.

In breve:
Unicode code points definisce quale sia il carattere; l'encodings definisce come questo sia rappresentato in bytes.

- Esempi di natural ordering

```java
List<String> items = List.of("10", "2", "A", "Z", "a", "b");

List<String> sorted = new ArrayList<>(items);
Collections.sort(sorted);

System.out.println(sorted);
```

Output:

```bash
[10, 2, A, Z, a, b]
```

!!! note
    L’ordinamento naturale è definito solo per i tipi che implementano `Comparable`.

<a id="241-comparable--ordinamento-naturale"></a>
## 24.1 Comparable — Ordinamento Naturale

L’interfaccia `Comparable<T>` definisce l’ordine naturale di un tipo.

Una classe la implementa quando vuole definire la propria regola di ordinamento predefinita.

<a id="2411-contratto-del-metodo-di-comparable"></a>
### 24.1.1 Contratto del Metodo di Comparable

```java
public interface Comparable<T> {
	int compareTo(T other);
}
```

Regole e restituzione:

- Restituisce **negativo** → `this` < `other`
- Restituisce **zero** → `this` == `other`
- Restituisce **positivo** → `this` > `other`

!!! important
    - L’ordinamento naturale deve essere consistente con `equals()`, a meno che non sia esplicitamente documentato diversamente:
    - `compareTo()` è consistente con `equals()` se, e solo se, `a.compareTo(b) == 0` e `a.equals(b) è true`.

!!! warning
    compareTo può lanciare ClassCastException se riceve un tipo non confrontabile — ma questo di solito succede solo con tipi raw.


<a id="2412-esempio-classe-che-implementa-comparable"></a>
### 24.1.2 Esempio: Classe che Implementa Comparable

```java
public class Person implements Comparable<Person> {

	private String name;
	private int age;

	public Person(String n, int a) {
		this.name = n;
		this.age = a;
	}

	@Override
	public int compareTo(Person other) {
		return Integer.compare(this.age, other.age);
	}


}

var list = List.of(new Person("Bob", 40), new Person("Alice", 30));

list.stream().sorted().forEach(p -> System.out.println(p.getAge()));
```

La lista viene ordinata per età, perché quello è l’ordine numerico naturale.

<a id="2413-errori-comuni-di-comparable"></a>
### 24.1.3 Errori Comuni di Comparable

- Confrontare tutti i campi rilevanti → risultati inconsistenti se non lo si fa
- Violare la transitività → porta a comportamento indefinito
- Lanciare eccezioni dentro compareTo() rompe l’ordinamento
- Non implementare la stessa logica di equals() → trappola comune

---

<a id="242-comparator--ordinamento-personalizzato"></a>
## 24.2 Comparator — Ordinamento Personalizzato

L’interfaccia `Comparator<T>` consente di definire più strategie di ordinamento
senza modificare la classe stessa.

<a id="2421-metodi-principali-di-comparator"></a>
### 24.2.1 Metodi Principali di Comparator

```java
int compare(T a, T b);
```

Metodi di supporto aggiuntivi:

<a id="24211-metodi-di-supporto-statici-di-comparator"></a>
#### 24.2.1.1 Metodi di Supporto **Statici** di Comparator

|Metodo	| Statico / Istanza | Tipo di Ritorno |	Parametri	| Descrizione |
|-------|-------------------|---------------|------------|-------------|
|`Comparator.comparing(keyExtractor)`	| statico	|Comparator<T>	| Function<? super T, ? extends U>	| Costruisce un comparator che confronta le chiavi estratte usando l’ordinamento naturale. |
|`Comparator.comparing(keyExtractor, keyComparator)`	| statico	| Comparator<T>	| Function<T,U>, Comparator<U>	| Costruisce un comparator che confronta le chiavi estratte usando un comparator personalizzato.|
|`Comparator.comparingInt(keyExtractor)`	| statico	| Comparator<T>		| ToIntFunction<T>	| Comparator ottimizzato per chiavi int (evita il boxing).|
|`Comparator.comparingLong(keyExtractor)`	| statico	| Comparator<T>		| ToLongFunction<T>	| Comparator ottimizzato per chiavi long.|
|`Comparator.comparingDouble(keyExtractor)`	| statico	| Comparator<T>		| ToDoubleFunction<T>	| Comparator ottimizzato per chiavi double.|
|`Comparator.naturalOrder()`	| statico	| Comparator<T>	| none	| Comparator che usa l’ordinamento naturale (Comparable).|
|`Comparator.reverseOrder()`	| statico	| Comparator<T>	| none	| Ordinamento naturale inverso.|
|`Comparator.nullsFirst(comparator)`	| statico	| Comparator<T>	| Comparator<T>	| Incapsula un comparator in modo che i null vengano confrontati prima dei non-null.|
|`Comparator.nullsLast(comparator)`	| statico	| Comparator<T>	| Comparator<T>	| Incapsula un comparator in modo che i null vengano confrontati dopo i non-null.|


<a id="24212-metodi-di-istanza-su-comparator"></a>
#### 24.2.1.2 Metodi di **Istanza** su Comparator

|Metodo	| Statico / Istanza |	Tipo di Ritorno	| Parametri | Descrizione |
|-------|-------------------|---------------|------------|-------------|
|`thenComparing(otherComparator)`	| istanza	| Comparator<T>	| Comparator<T>	| Aggiunge un comparator secondario quando il primario confronta come uguali.|
|`thenComparing(keyExtractor)`	| istanza	| Comparator<T>	| Function<T,U>	| Confronto secondario usando l’ordinamento naturale della chiave estratta.|
|`thenComparing(keyExtractor, keyComparator)`	| istanza	| Comparator<T>	| Function<T,U>, Comparator<U>	| Confronto secondario con comparator personalizzato.|
|`thenComparingInt(keyExtractor)`	| istanza	| Comparator<T>	| ToIntFunction<T>	| Confronto numerico secondario (ottimizzato).|
|`thenComparingLong(keyExtractor)`	| istanza	| Comparator<T>	| ToLongFunction<T>	| Confronto numerico secondario.|
|`thenComparingDouble(keyExtractor)`	| istanza	| Comparator<T>	| ToDoubleFunction<T>	| Confronto numerico secondario.|
|`reversed()`	| istanza	| Comparator<T>	| none	| Restituisce un comparator invertito per la stessa logica di confronto.|

<a id="2422-esempio-di-comparator"></a>
### 24.2.2 Esempio di Comparator

```java
var people = List.of(new Person("Bob",40), new Person("Ann",30));

Comparator<Person> byName = Comparator.comparing(Person::getName);

Comparator<Person> byAgeDesc = Comparator.comparingInt(Person::getAge).reversed();

var sorted = people.stream().sorted(byName.thenComparing(byAgeDesc)).toList();
```

---

<a id="243-comparable-vs-comparator"></a>
## 24.3 Comparable vs Comparator 


|Caratteristica  |	Comparable	| Comparator |
|----------------|-------------|------------|
|Package  |	java.lang	| java.util	|
|Metodo	|	compareTo(T) |	compare(T,T)	|
|Tipo di Ordinamento |	Naturale (predefinito) |	Personalizzato (strategie multiple) |
|Modifica la Classe Sorgente	| SI |	NO |
|Utile Per	|	Ordinamento predefinito |	Ordinamento esterno o alternativo |
|Consente Ordini Multipli	| NO |	SI |
|Usato da Collections.sort	| SI |	SI |
|Usato da Arrays.sort	| SI	| SI |

---	

<a id="244-ordinamento-di-array-e-collezioni"></a>
## 24.4 Ordinamento di Array e Collezioni

<a id="2441-arrays-sort"></a>
### 24.4.1 Arrays sort()

```java
int[] nums = {3,1,2};
Arrays.sort(nums); // ordine naturale

Person[] arr = {...};
Arrays.sort(arr); // Person deve implementare Comparable
Arrays.sort(arr, byName); // usando Comparator
```

<a id="2442-collections-sort"></a>
### 24.4.2 Collections sort()

```java
Collections.sort(list); // ordine naturale
Collections.sort(list, byName); // comparator
```

!!! note
    Collections.sort(list) delega a list.sort(comparator) da Java 8.

---

<a id="245-ordinamento-multi-livello-thencomparing"></a>
## 24.5 Ordinamento Multi-Livello (thenComparing)

```java
var cmp = Comparator
	.comparing(Person::getLastName)
		.thenComparing(Person::getFirstName)
			.thenComparingInt(Person::getAge);
```

---

<a id="246-confrontare-primitivi-in-modo-efficiente"></a>
## 24.6 Confrontare Primitivi in Modo Efficiente

```java
Comparator.comparingInt(Person::getAge)
Comparator.comparingLong(...)
Comparator.comparingDouble(...)
```

!!! note
    Questi evitano il boxing e sono preferiti nel codice sensibile alle prestazioni.

---

<a id="247-trappole-comuni"></a>
## 24.7 Trappole Comuni

- Ordinare una lista di Object senza Comparable → ClassCastException a runtime
- compareTo inconsistente con equals → comportamento imprevedibile
- Comparator che rompe la transitività → l’ordinamento diventa indefinito
- Elementi null → a meno che il Comparator li gestisca, l’ordinamento lancia NPE
- Comparator che confronta campi di tipi misti → ClassCastException
- Usare la sottrazione per confrontare int può causare overflow → usare sempre `Integer.compare()`
- Ordinare una lista con elementi null e ordine naturale → NPE
- compareTo non deve mai restituire negativo/zero/positivo inconsistenti sugli stessi due oggetti (niente casualità)

---

<a id="248-esempio-completo"></a>
## 24.8 Esempio Completo

```java
record Book(String title, double price, int year) {}

var books = List.of(
new Book("Java 17", 40.0, 2021),
new Book("Algorithms", 55.0, 2019),
new Book("Java 21", 42.0, 2023)
);

Comparator<Book> cmp =
Comparator
	.comparingDouble(Book::price)
		.thenComparing(Book::year)
			.reversed();

books.stream().sorted(cmp)
	.forEach(System.out::println);

```

!!! note
    `reversed()` si applica all’intero comparator composto, non solo alla prima chiave di confronto.

---

<a id="249-riepilogo"></a>
## 24.9 Riepilogo

- Usare `Comparable` per l’ordinamento naturale (1 ordine predefinito).
- Usare `Comparator` per strategie di ordinamento flessibili o multiple.
- I comparator possono essere composti (reversed, thenComparing).
- L’ordinamento richiede una logica di confronto consistente.
- Arrays.sort e Collections.sort usano sia Comparable che Comparator. 
