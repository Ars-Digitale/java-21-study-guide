# 26. Set API

### Table des matières

- [26. Set API ](#26-set-api)
  - [26.1 Hiérarchie des Set Java-Collections-Framework](#261-hiérarchie-des-set-java-collections-framework)
  - [26.2 Caractéristiques de Chaque Implémentation de Set](#262-caractéristiques-de-chaque-implémentation-de-set)
    - [26.2.1 HashSet](#2621-hashset)
    - [26.2.2 LinkedHashSet](#2622-linkedhashset)
    - [26.2.3 TreeSet](#2623-treeset)
  - [26.3 Règles d’Égalité dans les Set](#263-règles-dégalité-dans-les-set)
    - [26.3.1 HashSet--LinkedHashSet](#2631-hashset--linkedhashset)
    - [26.3.2 TreeSet](#2632-treeset)
  - [26.4 Créer des Instances de Set](#264-créer-des-instances-de-set)
    - [26.4.1 En Utilisant les Constructeurs](#2641-en-utilisant-les-constructeurs)
    - [26.4.2 Constructeurs de Copie](#2642-constructeurs-de-copie)
    - [26.4.3 Méthodes Factory](#2643-méthodes-factory)
  - [26.5 Opérations Principales sur les Set](#265-opérations-principales-sur-les-set)
    - [26.5.1 Ajouter des Éléments](#2651-ajouter-des-éléments)
    - [26.5.2 Vérifier l’Appartenance](#2652-vérifier-lappartenance)
    - [26.5.3 Supprimer des Éléments](#2653-supprimer-des-éléments)
    - [26.5.4 Opérations Bulk](#2654-opérations-bulk)
  - [26.6 Pièges Courants](#266-pièges-courants)
  - [26.7 Tableau Récapitulatif](#267-tableau-récapitulatif)

---

Un **Set** en Java représente une collection qui **ne contient pas d’éléments dupliqués**.  

Il modélise le concept mathématique d’`ensemble` : non ordonné (sauf si une implémentation ordonnée est utilisée) et composé de valeurs uniques.

Toutes les implémentations de Set reposent sur des **sémantiques d’égalité** (via `equals()` ou la logique de `Comparator`).

## 26.1 Hiérarchie des Set (Java Collections Framework)

```text
Set<E>
 ├── SequencedSet<E> (Java 21+)
 │    └── LinkedHashSet<E>   (ordonné)
 ├── HashSet<E>              (non ordonné)
 └── SortedSet<E>
      └── NavigableSet<E>
           └── TreeSet<E>    (ordonné)
```

Toutes les implémentations de `Set` requièrent :  
- l’unicité des éléments  
- une égalité et un hashing prévisibles (selon l’implémentation)

> [!NOTE]
> `LinkedHashSet` est désormais formellement un `SequencedSet` depuis Java 21.

---

## 26.2 Caractéristiques de Chaque Implémentation de Set

### 26.2.1 HashSet

- Set généraliste le plus rapide  
- Non ordonné (aucune garantie sur l’ordre d’itération)  
- Utilise `hashCode()` et `equals()`  
- Autorise un seul élément `null`  

```java
Set<String> set = new HashSet<>();
set.add("A");
set.add("B");
set.add("A");   // doublon ignoré
System.out.println(set); // ordre non garanti
```

### 26.2.2 LinkedHashSet

- Maintient l’**ordre d’insertion**  
- Légèrement plus lent que HashSet  
- Utile lorsqu’un ordre d’itération prévisible est requis

```java
Set<String> set = new LinkedHashSet<>();
set.add("A");
set.add("C");
set.add("B");
System.out.println(set);  // [A, C, B]
```

### 26.2.3 TreeSet

Un Set **trié** dont l’ordre est déterminé par :  
1. L’ordre naturel (`Comparable`)  
2. Un `Comparator` fourni  

TreeSet :  
- N’autorise pas d’éléments `null` (NullPointerException à l’exécution)  
- Garantit une itération triée  
- Prend en charge des vues par plage : `headSet()`, `tailSet()`, `subSet()`  

```java
TreeSet<Integer> tree = new TreeSet<>();
tree.add(10);
tree.add(1);
tree.add(5);

System.out.println(tree); // [1, 5, 10]
```

> [!NOTE]
> `TreeSet` exige que tous les éléments soient mutuellement comparables — mélanger des types non comparables produit une `ClassCastException`.
> Les opérations (add, remove, contains) sont en O(log n).

---

## 26.3 Règles d’Égalité dans les Set

Les règles diffèrent selon l’implémentation.

### 26.3.1 HashSet & LinkedHashSet

L’`unicité` est déterminée par deux méthodes :  
- `hashCode()`  
- `equals()`  

Deux objets sont considérés comme le même élément si :

1. Leurs hash codes correspondent  
2. Leur méthode `equals()` retourne `true`  

> [!WARNING]
> Si vous modifiez un objet après l’avoir ajouté à un HashSet ou LinkedHashSet, son hashCode peut changer et le set peut perdre la référence à cet élément.

### 26.3.2 TreeSet

L’unicité est basée sur `compareTo()` ou sur le `Comparator` fourni.  

Si `compare(a, b) == 0`, alors les objets sont considérés comme des doublons, même si `equals()` retourne false.

```java
Comparator<String> comp = (a, b) -> a.length() - b.length();
Set<String> set = new TreeSet<>(comp);

set.add("Hi");
set.add("Yo"); // même longueur → traité comme doublon

System.out.println(set);  // ["Hi"]
```

---

## 26.4 Créer des Instances de Set

### 26.4.1 En Utilisant les Constructeurs

```java
Set<String> s1 = new HashSet<>();
Set<String> s2 = new LinkedHashSet<>();
Set<String> s3 = new TreeSet<>();
```

### 26.4.2 Constructeurs de Copie

```java
List<String> list = List.of("A", "B", "C");

Set<String> copy = new HashSet<>(list); // ordre perdu
System.out.println(copy);

Set<String> ordered = new LinkedHashSet<>(list); // conserve l’ordre de la liste
System.out.println(ordered);
```

### 26.4.3 Méthodes Factory

```java
Set<String> s1 = Set.of("A", "B", "C");   // immuable
Set<String> empty = Set.of();             // set immuable vide
```

> [!NOTE]
> Les set créés via les factory sont **immuables** : ajouter ou supprimer des éléments lève `UnsupportedOperationException`.
> `Set.of(...)` rejette les doublons à la création → IllegalArgumentException et rejette null → NullPointerException

---

## 26.5 Opérations Principales sur les Set

### 26.5.1 Ajouter des Éléments

```java
set.add("A");          // retourne true si ajouté
set.add("A");          // retourne false si doublon
```

### 26.5.2 Vérifier l’Appartenance

```java
set.contains("A");
```

### 26.5.3 Supprimer des Éléments

```java
set.remove("A");
set.clear();
```

### 26.5.4 Opérations Bulk

```java
set.addAll(otherSet);
set.removeAll(otherSet);
set.retainAll(otherSet); // intersection
```

---

## 26.6 Pièges Courants

- Utiliser TreeSet avec des objets non comparables → `ClassCastException`
- TreeSet n’utilise pas `equals()` : seul comparator/compareTo détermine l’unicité
- Utiliser des objets mutables comme clés de Set → casse les règles de hashing
- Les Set créés avec Set.of() sont immuables — la modification échoue
- HashSet ne garantit pas l’ordre d’itération
- TreeSet traite les objets avec compare()==0 comme des doublons même s’ils ne sont pas égaux

---

## 26.7 Tableau Récapitulatif


| Implémentation | Conserve l’Ordre ? | Autorise Null ? | Trié ? | Logique Sous-jacente |
|----------------|--------------------|----------------|--------|----------------------|
| HashSet        | Non                | Oui (1 null)   | Non    | hashCode + equals    |
| LinkedHashSet  | Oui (ordre d’insertion) | Oui (1 null) | Non | table de hachage + liste chaînée |
| TreeSet        | Oui (trié)         | Non            | Oui (naturel/comparator) | compareTo / Comparator |
