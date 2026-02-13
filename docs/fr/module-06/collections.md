# 22. Introduction au Framework des Collections

### Table des matières

- [22. Introduction au Framework des Collections](#22-introduction-au-framework-des-collections)
  - [22.1 Qu’est-ce que le Framework des Collections](#221-quest-ce-que-le-framework-des-collections-)
  - [22.2 Les Interfaces Principales](#222-les-interfaces-principales)
    - [22.2.1 Principales interfaces de Collection](#2221-principales-interfaces-de-collection)
    - [22.2.2 Hiérarchie de Map](#2222-hiérarchie-de-map)
  - [22.3 Collections Sequenced Java-21](#223-collections-sequenced-java-21)
  - [22.4 Pourquoi le Framework des Collections existe](#224-pourquoi-le-framework-des-collections-existe)
  - [22.5 Les deux côtés du Framework Collections-vs-Maps](#225-les-deux-côtés-du-framework--collections-vs-maps)
  - [22.6 Types génériques dans le Framework des Collections](#226-types-génériques-dans-le-framework-des-collections)
  - [22.7 Mutabilité vs Immutabilité](#227-mutabilité-vs-immutabilité)
  - [22.8 Attentes de Performance Big-O](#228-attentes-de-performance-big-o)
  - [22.9 Résumé](#229-résumé)

---

Le `Java Collections Framework (JCF)` est un ensemble **d’interfaces, de classes et d’algorithmes** conçu pour stocker, manipuler et traiter des groupes de données de manière efficace.

Il fournit une architecture unifiée pour gérer les collections, permettant aux développeurs d’écrire du code réutilisable et interopérable avec des comportements prévisibles et des caractéristiques de performance.

Ce chapitre introduit les concepts fondamentaux nécessaires avant d’étudier List, Set, Queue, Map et les Sequenced Collections, explorés en détail dans les chapitres suivants.

## 22.1 Qu’est-ce que le Framework des Collections ?

Le Framework des Collections fournit :

- Un **ensemble d’interfaces** (Collection, List, Set, Queue, Deque, Map…)
- Un **ensemble d’implémentations** (ArrayList, HashSet, TreeSet, LinkedList…)
- Un **ensemble d’algorithmes utilitaires** (tri, recherche, copie, inversion…) dans java.util.Collections et java.util.Arrays.
- Un langage commun pour les attentes de performance (complexité Big-O).

Toutes les principales structures de collection partagent une conception cohérente, de sorte que le code fonctionnant avec une implémentation peut souvent être réutilisé avec une autre.

---

## 22.2 Les Interfaces Principales

Au cœur du Java Collections Framework se trouve un petit ensemble **d’interfaces racines** qui définissent des comportements génériques de gestion des données.

- **List** : une collection `ordonnée` d’éléments qui autorise les `doublons` ;
- **Set** : une collection qui n’autorise pas les `doublons` ;
- **Queue** : une collection conçue pour contenir des éléments en cours de traitement, typiquement FIFO (first-in-first-out), avec des variantes comme les priority queues et les deques.
- **Map** : une structure qui associe des clés à des valeurs, où les clés dupliquées ne sont pas autorisées ; chaque clé peut être associée à au plus une valeur.


### 22.2.1 Principales interfaces de Collection

Ci-dessous se trouve la hiérarchie conceptuelle.

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

L’interface **Map** n’étend pas Collection, car une map stocke des paires clé/valeur plutôt que des valeurs uniques.

### 22.2.2 Hiérarchie de Map

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

## 22.3 Collections Sequenced (Java 21+)

Java 21 introduit la nouvelle interface `SequencedCollection`, qui formalise l’idée qu’une collection maintient un **ordre de parcours défini**.
Cela était déjà vrai pour List, LinkedHashSet, LinkedHashMap, Deque, etc., mais ce comportement est désormais standardisé.

- `SequencedCollection` définit des méthodes telles que `getFirst()`, `getLast()`, `addFirst()`, `addLast()`, `removeFirst()`, `removeLast()` et `reversed()`.
- SequencedSet et SequencedMap étendent ce concept aux sets et aux maps.

Cela simplifie considérablement la spécification des comportements d’ordonnancement et sera utilisé dans tous les chapitres suivants.

---

## 22.4 Pourquoi le Framework des Collections existe

- Éviter de réinventer les structures de données
- Fournir des algorithmes bien testés et hautement performants
- Améliorer l’interopérabilité grâce à des interfaces partagées
- Prendre en charge les types génériques pour des collections sûres du point de vue du type

Avant Java 1.2, les structures de données étaient ad hoc, incohérentes et non typées.

Le Collections Framework a unifié tout cela dans une API cohérente.

---

## 22.5 Les deux côtés du Framework : Collections vs Maps

« Map étend-elle Collection ? »
**Non.**
Une Map stocke des **paires**, tandis qu’une Collection stocke des **éléments uniques**.

- Collection = List, Set, Queue, Deque, SequencedCollection
- Map = stockage clé/valeur de type dictionnaire

---

## 22.6 Types génériques dans le Framework des Collections

Les collections sont presque toujours utilisées avec des generics. L’utilisation de raw types est déconseillée.

```java
List<String> names = new ArrayList<>();
Map<Integer, String> map = new HashMap<>();
```

!!! note
    Les generics dans les collections fonctionnent via le `type erasure` : se référer au paragraphe "**18.4 Type Erasure**" dans le chapitre : [Generics in Java](../module-04/generics.md).

## 22.7 Mutabilité vs Immutabilité

De nombreuses méthodes de la Collections API renvoient des collections **unmodifiable** :

```java
List<String> immutable = List.of("a", "b");
immutable.add("c"); // ❌ UnsupportedOperationException
```

Java fournit plusieurs moyens de créer des collections immuables :

- `List.of()`, `Set.of()`, `Map.of()`
- `List.copyOf(collection)`
- wrappers `Collections.unmodifiableList(...)`
- `Records` utilisés comme conteneurs de valeurs immuables

!!! note
    La méthode `Arrays.asList(varargs)`, qui est construite sur un tableau, se comporte différemment : voir les exemples ci-dessous.

```java

String[] vargs = new String[] {"u", "v", "z"};
List<String> fromAsList = Arrays.asList(vargs);

List<String> immutable1 = List.of(vargs);
immutable1.add("c"); // ❌ UnsupportedOperationException

List<String> immutable2 = List.copyOf(fromAsList);
immutable2.set(0, "k"); // ❌ UnsupportedOperationException


// Nous ne pouvons pas ADD ou REMOVE des éléments de "fromAsList" mais nous pouvons les remplacer ;
// soit en modifiant le tableau sous-jacent "vargs", soit en mutant la liste elle-même :


fromAsList.set(0, "k");  // la mise à jour sera également reflétée dans le tableau sous-jacent.
```

!!! note
    `Arrays.asList(...)` renvoie une vue List de taille fixe, mais **mutable**, supportée par le tableau d’origine.
    Vous ne pouvez pas ajouter/supprimer des éléments, mais vous pouvez remplacer ceux existants.


## 22.8 Attentes de Performance Big-O

Comprendre la complexité des types de collection est essentiel. Voici quelques exemples courants :

| Type | Methods | Complexity |
| ---- | ---- | ---- |
| ArrayList | `get()`, `add()`, `remove()` | **`O(1)`**, **`O(1) amorti`**, **`O(n)`**  |
| LinkedList | `get()`, `add/remove first/last` | **`O(n)`**,  **`O(1)`** |
| HashSet | `add()`, `contains()`, `remove()` |   ~ **`O(1)`** |
| TreeSet | `add()`, `contains()`, `remove()`  | **`O(log n)`**  |
| HashMap | `get()/put()`  | ~ **`O(1) en moyenne`**  |
| TreeMap | `get()/put()`  |  **`O(log n)`** |
| Deque | `add/remove first/last`  | **`O(1)`**  |


!!! note
    Ces valeurs sont des moyennes ; le pire cas peut être différent (en particulier pour les structures basées sur le hachage).


## 22.9 Résumé

- Le Collection Framework est construit sur un petit ensemble d’interfaces principales.
- Java 21 ajoute les Sequenced Collections pour unifier le comportement d’ordonnancement.
- Les Map ne sont pas des Collection — elles forment une hiérarchie parallèle.
- Les collections font un usage intensif des generics.
- La mutabilité est importante — les méthodes factory renvoient souvent des collections immuables.
- Les caractéristiques de performance sont prévisibles.
