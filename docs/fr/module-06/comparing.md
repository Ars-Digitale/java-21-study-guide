# 24. Comparable, Comparator & Tri en Java

### Table des matières

- [24. Comparable, Comparator & Tri en Java](#24-comparable-comparator--tri-en-java)
  - [24.1 Comparable — Ordre Naturel](#241-comparable--ordre-naturel)
    - [24.1.1 Contrat de la Méthode Comparable](#2411-contrat-de-la-méthode-comparable)
    - [24.1.2 Classe d’Exemple Implémentant Comparable](#2412-classe-dexemple-implémentant-comparable)
    - [24.1.3 Erreurs Courantes de Comparable](#2413-erreurs-courantes-de-comparable)
  - [24.2 Comparator — Ordre Personnalisé](#242-comparator--ordre-personnalisé)
    - [24.2.1 Méthodes Principales de Comparator](#2421-méthodes-principales-de-comparator)
      - [24.2.1.1 Méthodes de Support **Statiques** de Comparator](#24211-méthodes-de-support-statiques-de-comparator)
      - [24.2.1.2 Méthodes d’**Instance** sur Comparator](#24212-méthodes-dinstance-sur-comparator)
    - [24.2.2 Exemple de Comparator](#2422-exemple-de-comparator)
  - [24.3 Comparable vs Comparator](#243-comparable-vs-comparator)
  - [24.4 Tri des Tableaux et des Collections](#244-tri-des-tableaux-et-des-collections)
    - [24.4.1 Arrays sort](#2441-arrays-sort)
    - [24.4.2 Collections sort](#2442-collections-sort)
  - [24.5 Tri Multi-Niveaux thenComparing](#245-tri-multi-niveaux-thencomparing)
  - [24.6 Comparer les Primitifs Efficacement](#246-comparer-les-primitifs-efficacement)
  - [24.7 Pièges Courants](#247-pièges-courants)
  - [24.8 Exemple Complet](#248-exemple-complet)
  - [24.9 Résumé](#249-résumé)

---


Java fournit deux stratégies principales pour le tri et la comparaison : `Comparable` (ordre naturel) et `Comparator` (ordre personnalisé).

Comprendre leurs règles, leurs contraintes et leurs interactions avec les `generics` est essentiel.

- Pour les **types numériques**, le tri suit l’ordre numérique naturel, ce qui signifie que les valeurs plus petites précèdent les valeurs plus grandes.
- Le tri des **chaînes** suit l’ordre lexicographique (`code point` Unicode) : comparaison caractère par caractère ; les chiffres viennent avant les majuscules, les majuscules avant les minuscules.

Cet ordre est basé sur le `code point Unicode` de chaque caractère, et non sur une intuition alphabétique.

Un **Unicode code point** est une valeur numérique unique attribuée aux caractères dans le standard Unicode.

Plus précisément :
un `Unicode code point` est un entier (écrit en hexadécimal sous la forme U+XXXX) qui représente un caractère, un symbole ou un caractère spécial spécifique indépendamment de la police, de la langue ou de la plateforme.

- Exemples :
	- U+0041 → A
	- U+0061 → a
	- U+0030 → 0
	- U+1F600 → 😀

Un code point n’est pas une séquence d’octets ; c’est un nombre abstrait.

La manière dont le code point est ensuite stocké en mémoire physique dépend de l’encodage (UTF-8, UTF-16, UTF-32).

Unicode définit les code points de U+0000 à U+10FFFF.

En bref :
les Unicode code points définissent quel est le caractère ; les encodings définissent comment celui-ci est représenté en octets.

- Exemples d’ordre naturel

```java
List<String> items = List.of("10", "2", "A", "Z", "a", "b");

List<String> sorted = new ArrayList<>(items);
Collections.sort(sorted);

System.out.println(sorted);
```

Sortie :

```bash
[10, 2, A, Z, a, b]
```

> [!NOTE]
> L’ordre naturel est défini uniquement pour les types qui implémentent `Comparable`.

## 24.1 Comparable — Ordre Naturel

L’interface `Comparable<T>` définit l’ordre naturel d’un type.

Une classe l’implémente lorsqu’elle souhaite définir sa règle de tri par défaut.

### 24.1.1 Contrat de la Méthode Comparable

```java
public interface Comparable<T> {
	int compareTo(T other);
}
```

Règles et valeur de retour :

- Retourne **négatif** → `this` < `other`
- Retourne **zéro** → `this` == `other`
- Retourne **positif** → `this` > `other`

> [!IMPORTANT]
> - L’ordre naturel doit être cohérent avec `equals()`, sauf si explicitement documenté autrement :
> - `compareTo()` est cohérent avec `equals()` si, et seulement si, `a.compareTo(b) == 0` et `a.equals(b) est true`.

> [!WARNING]
> compareTo peut lever une ClassCastException s’il reçoit un type non comparable — mais cela se produit généralement uniquement avec des types raw.


### 24.1.2 Exemple : Classe Implémentant Comparable

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

La liste est triée par âge, car il s’agit de l’ordre numérique naturel.

### 24.1.3 Erreurs Courantes de Comparable

- Comparer tous les champs pertinents → résultats incohérents si ce n’est pas le cas
- Violer la transitivité → conduit à un comportement indéfini
- Lever des exceptions dans compareTo() casse le tri
- Ne pas implémenter la même logique que equals() → piège courant

---

## 24.2 Comparator — Ordre Personnalisé

L’interface `Comparator<T>` permet de définir plusieurs stratégies de tri
sans modifier la classe elle-même.

### 24.2.1 Méthodes Principales de Comparator

```java
int compare(T a, T b);
```

Méthodes de support supplémentaires :

#### 24.2.1.1 Méthodes de Support **Statiques** de Comparator

|Méthode	| Statique / Instance | Type de Retour |	Paramètres	| Description |
|--------|---------------------|----------------|-------------|-------------|
|`Comparator.comparing(keyExtractor)`	| statique	|Comparator<T>	| Function<? super T, ? extends U>	| Construit un comparator comparant les clés extraites en utilisant l’ordre naturel. |
|`Comparator.comparing(keyExtractor, keyComparator)`	| statique	| Comparator<T>	| Function<T,U>, Comparator<U>	| Construit un comparator comparant les clés extraites à l’aide d’un comparator personnalisé.|
|`Comparator.comparingInt(keyExtractor)`	| statique	| Comparator<T>	| ToIntFunction<T>	| Comparator optimisé pour les clés int (évite le boxing).|
|`Comparator.comparingLong(keyExtractor)`	| statique	| Comparator<T>	| ToLongFunction<T>	| Comparator optimisé pour les clés long.|
|`Comparator.comparingDouble(keyExtractor)`	| statique	| Comparator<T>	| ToDoubleFunction<T>	| Comparator optimisé pour les clés double.|
|`Comparator.naturalOrder()`	| statique	| Comparator<T>	| none	| Comparator utilisant l’ordre naturel (Comparable).|
|`Comparator.reverseOrder()`	| statique	| Comparator<T>	| none	| Ordre naturel inversé.|
|`Comparator.nullsFirst(comparator)`	| statique	| Comparator<T>	| Comparator<T>	| Enveloppe un comparator afin que les null soient comparés avant les non-null.|
|`Comparator.nullsLast(comparator)`	| statique	| Comparator<T>	| Comparator<T>	| Enveloppe un comparator afin que les null soient comparés après les non-null.|


#### 24.2.1.2 Méthodes d’**Instance** sur Comparator

|Méthode	| Statique / Instance | Type de Retour | Paramètres | Description |
|--------|---------------------|----------------|-------------|-------------|
|`thenComparing(otherComparator)`	| instance	| Comparator<T>	| Comparator<T>	| Ajoute un comparator secondaire lorsque le primaire compare comme égal.|
|`thenComparing(keyExtractor)`	| instance	| Comparator<T>	| Function<T,U>	| Comparaison secondaire utilisant l’ordre naturel de la clé extraite.|
|`thenComparing(keyExtractor, keyComparator)`	| instance	| Comparator<T>	| Function<T,U>, Comparator<U>	| Comparaison secondaire avec un comparator personnalisé.|
|`thenComparingInt(keyExtractor)`	| instance	| Comparator<T>	| ToIntFunction<T>	| Comparaison numérique secondaire (optimisée).|
|`thenComparingLong(keyExtractor)`	| instance	| Comparator<T>	| ToLongFunction<T>	| Comparaison numérique secondaire.|
|`thenComparingDouble(keyExtractor)`	| instance	| Comparator<T>	| ToDoubleFunction<T>	| Comparaison numérique secondaire.|
|`reversed()`	| instance	| Comparator<T>	| none	| Retourne un comparator inversé pour la même logique de comparaison.|

### 24.2.2 Exemple de Comparator

```java
var people = List.of(new Person("Bob",40), new Person("Ann",30));

Comparator<Person> byName = Comparator.comparing(Person::getName);

Comparator<Person> byAgeDesc = Comparator.comparingInt(Person::getAge).reversed();

var sorted = people.stream().sorted(byName.thenComparing(byAgeDesc)).toList();
```

---

## 24.3 Comparable vs Comparator 


|Caractéristique  |	Comparable	| Comparator |
|------------------|-------------|------------|
|Package  |	java.lang	| java.util	|
|Méthode	|	compareTo(T) |	compare(T,T)	|
|Type de Tri |	Naturel (par défaut) |	Personnalisé (stratégies multiples) |
|Modifie la Classe Source	| OUI |	NON |
|Utile Pour	|	Ordre par défaut |	Ordre externe ou alternatif |
|Autorise Plusieurs Ordres	| NON |	OUI |
|Utilisé par Collections.sort	| OUI |	OUI |
|Utilisé par Arrays.sort	| OUI	| OUI |

---	

## 24.4 Tri des Tableaux et des Collections

### 24.4.1 Arrays sort()

```java
int[] nums = {3,1,2};
Arrays.sort(nums); // ordre naturel

Person[] arr = {...};
Arrays.sort(arr); // Person doit implémenter Comparable
Arrays.sort(arr, byName); // en utilisant Comparator
```

### 24.4.2 Collections sort()

```java
Collections.sort(list); // ordre naturel
Collections.sort(list, byName); // comparator
```

> [!NOTE]
> Collections.sort(list) délègue à list.sort(comparator) depuis Java 8.

---

## 24.5 Tri Multi-Niveaux (thenComparing)

```java
var cmp = Comparator
	.comparing(Person::getLastName)
		.thenComparing(Person::getFirstName)
			.thenComparingInt(Person::getAge);
```

---

## 24.6 Comparer les Primitifs Efficacement

```java
Comparator.comparingInt(Person::getAge)
Comparator.comparingLong(...)
Comparator.comparingDouble(...)
```

> [!NOTE]
> Ceux-ci évitent le boxing et sont préférés dans le code sensible aux performances.

---

## 24.7 Pièges Courants

- Trier une liste d’Object sans Comparable → ClassCastException à l’exécution
- compareTo incohérent avec equals → comportement imprévisible
- Comparator qui viole la transitivité → le tri devient indéfini
- Éléments null → sauf si le Comparator les gère, le tri lève une NPE
- Comparator comparant des champs de types mixtes → ClassCastException
- Utiliser la soustraction pour comparer des int peut provoquer un overflow → toujours utiliser `Integer.compare()`
- Trier une liste avec des éléments null et l’ordre naturel → NPE
- compareTo ne doit jamais retourner des valeurs négatives/zéro/positives incohérentes sur les mêmes deux objets (aucune aléatoire)

---

## 24.8 Exemple Complet

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

> [!NOTE]
> `reversed()` s’applique à l’ensemble du comparator composé, et non uniquement à la première clé de comparaison.

---

## 24.9 Résumé

- Utiliser `Comparable` pour l’ordre naturel (1 ordre par défaut).
- Utiliser `Comparator` pour des stratégies de tri flexibles ou multiples.
- Les comparators peuvent être composés (reversed, thenComparing).
- Le tri requiert une logique de comparaison cohérente.
- Arrays.sort et Collections.sort utilisent à la fois Comparable et Comparator. 
