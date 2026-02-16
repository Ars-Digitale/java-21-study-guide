# 23. Opérations Partagées des Collections & Égalité

<a id="table-des-matières"></a>
### Table des matières

- [23. Opérations Partagées des Collections & Égalité](#23-opérations-partagées-des-collections--égalité)
  - [23.1 Méthodes Fondamentales des Collections Disponibles pour la Majorité des Collections](#231-méthodes-fondamentales-des-collections-disponibles-pour-la-majorité-des-collections)
    - [23.1.1 Opérations de Mutation](#2311-opérations-de-mutation)
    - [23.1.2 Opérations de Requête](#2312-opérations-de-requête)
  - [23.2 Égalité](#232-égalité)
  - [23.3 Comportement Fail-Fast](#233-comportement-fail-fast)
  - [23.4 Opérations Bulk](#234-opérations-bulk)
  - [23.5 Types de Retour et Exceptions Courantes](#235-types-de-retour-et-exceptions-courantes)
  - [23.6 Tableau de Synthèse — Opérations Partagées](#236-tableau-de-synthèse--opérations-partagées)

---

Ce chapitre couvre les opérations fondamentales partagées dans toute la Java Collections API, y compris la manière dont l’égalité est déterminée à l’intérieur des collections.

Ces concepts s’appliquent à toutes les principales familles de collections basées sur Collection<E> (List, Set, Queue, Deque et leurs variantes Sequenced).

Map partage plusieurs comportements conceptuels (itération, égalité) mais n’hérite pas de Collection.

Maîtriser ces opérations est essentiel, car elles expliquent comment les collections se comportent lors de l’ajout, de la recherche, de la suppression, de la comparaison, de l’itération et du tri des éléments.

<a id="231-méthodes-fondamentales-des-collections-disponibles-pour-la-majorité-des-collections"></a>
## 23.1 Méthodes Fondamentales des Collections (Disponibles pour la Majorité des Collections)

Les méthodes suivantes proviennent de l’interface `Collection<E>` et sont héritées par **toutes** les principales collections à l’exception de `Map` (qui possède sa propre famille d’opérations).

!!! note
    `Map` n’implémente pas `Collection`, mais ses vues `keySet()`, `values()` et `entrySet()` **l’implémentent**, et exposent donc ces opérations partagées.

<a id="2311-opérations-de-mutation"></a>
### 23.1.1 Opérations de Mutation

- `boolean add(E e)` — Ajoute un élément (les listes autorisent les doublons).
- `boolean remove(Object o)` — Supprime le premier élément correspondant.
- `void clear()` — Supprime tous les éléments.
- `boolean addAll(Collection<? extends E> c)` — Insertion bulk.
- `boolean removeAll(Collection<?> c)` — Supprime tous les éléments contenus dans la collection fournie.
- `boolean retainAll(Collection<?> c)` — Conserve uniquement les éléments correspondants.

<a id="2312-opérations-de-requête"></a>
### 23.1.2 Opérations de Requête

- `int size()` — Nombre d’éléments.
- `boolean isEmpty()` — Indique si la collection contient zéro élément.
- `boolean contains(Object o)` — S’appuie sur les règles d’égalité des éléments.
- `Iterator<E> iterator()` — Retourne un itérateur (fail-fast).
- `Object[] toArray()` et `<T> T[] toArray(T[] a)` — Copie dans un tableau.

---

<a id="232-égalité"></a>
## 23.2 Égalité

Une implémentation personnalisée de la méthode `equals()` permet de comparer le type et le contenu de deux collections.

L’implémentation diffère selon que l’on traite des List ou des Set.

- Exemple

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

Sortie

```bash
firstList.equals(secondList): true
secondList.equals(thirdList): false
firstSet.equals(secondSet): true
secondSet.equals(thirdSet): true
```

!!! note
    - Les List comparent la taille, l’ordre et l’égalité des éléments un par un.
    - Les Set comparent uniquement la taille et l’appartenance — l’ordre de parcours est sans importance.
    - Deux sets contenant les mêmes éléments logiques sont égaux même s’ils maintiennent des ordres d’itération internes différents.

---

<a id="233-comportement-fail-fast"></a>
## 23.3 Comportement Fail-Fast

La plupart des itérateurs de collections (à l’exception des collections concurrentes) sont `fail-fast` : modifier structurellement une collection pendant l’itération déclenche une `ConcurrentModificationException`.

```java
List<Integer> list = new ArrayList<>(List.of(1,2,3));
for (Integer i : list) {
	list.add(99); // ❌ ConcurrentModificationException
}
```

!!! note
    Utilisez `Iterator.remove()` lorsque vous devez supprimer des éléments pendant l’itération.
    Le comportement fail-fast **n’est pas garanti** — l’exception est levée selon un principe de best-effort.
    Vous ne devez pas compter sur sa capture pour assurer la correction du programme.

---

<a id="234-opérations-bulk"></a>
## 23.4 Opérations Bulk

- `removeIf(Predicate<? super E> filter)` — Supprime tous les éléments correspondants.
- `replaceAll(UnaryOperator<E> op)` — Remplace chaque élément.
- `forEach(Consumer<? super E> action)` — Applique une action à chaque élément.
- `stream()` — Retourne un stream pour les opérations de pipeline.

---

<a id="235-types-de-retour-et-exceptions-courantes"></a>
## 23.5 Types de Retour et Exceptions Courantes

- `add(E)` retourne **boolean** — toujours `true` pour `ArrayList`, peut être `false` pour les `Set` si aucune modification n’a lieu.
- `remove(Object)` retourne boolean (pas l’élément supprimé).
- `get(int)` lève `IndexOutOfBoundsException`.
- `iterator().remove()` lève `IllegalStateException` s’il est appelé deux fois sans `next()`.
- `toArray()` retourne toujours un `Object[]` — jamais un `T[]`.

---

<a id="236-tableau-de-synthèse-opérations-partagées"></a>
## 23.6 Tableau de Synthèse — Opérations Partagées

| Opération                     | S’applique à                     | Notes                                   |
|-------------------------------|----------------------------------|-----------------------------------------|
| `add(e)`                      | Toutes les collections sauf Map  | Les List autorisent les doublons         |
| `remove(o)`                   | Toutes les collections sauf Map  | Supprime la première occurrence          |
| `contains(o)`                 | Toutes les collections sauf Map  | Utilise equals()                         |
| `size(), isEmpty()`           | Toutes les collections           | Temps constant pour la majorité          |
| `iterator()`                  | Toutes les collections           | Fail-fast                                |
| `clear()`                     | Toutes les collections           | Supprime tous les éléments               |
| `stream()`                    | Toutes les collections           | Retourne un stream séquentiel            |
| `removeIf(), replaceAll()`    | List uniquement (la plupart des Set ne supportent pas replaceAll) | Opérations bulk |
| `toArray()`                   | Toutes les collections           | Retourne Object[]                        |
