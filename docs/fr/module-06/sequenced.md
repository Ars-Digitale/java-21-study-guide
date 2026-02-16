# 29. Collections Séquencées & Map Séquencées

<a id="table-des-matières"></a>
### Table des matières

- [29. Collections Séquencées & Map Séquencées](#29-collections-séquencées--map-séquencées)
  - [29.1 Motivation et Contexte](#291-motivation-et-contexte)
  - [29.2 Interface SequencedCollection](#292-interface-sequencedcollection)
    - [29.2.1 Méthodes Principales de SequencedCollection](#2921-méthodes-principales-de-sequencedcollection)
    - [29.2.2 Implémentations de SequencedCollection](#2922-implémentations-de-sequencedcollection)
    - [29.2.3 Vues Inversées](#2923-vues-inversées)
  - [29.3 Interface SequencedMap](#293-interface-sequencedmap)
    - [29.3.1 Méthodes Principales de SequencedMap](#2931-méthodes-principales-de-sequencedmap)
    - [29.3.2 Implémentations de SequencedMap](#2932-implémentations-de-sequencedmap)
    - [29.3.3 Map Inversées](#2933-map-inversées)
  - [29.4 Relation avec les API Existantes](#294-relation-avec-les-api-existantes)
    - [29.4.1 Quels Types Built-in Sont Séquencés](#2941-quels-types-built-in-sont-séquencés)
  - [29.5 Pièges Courants](#295-pièges-courants)
  - [29.6 Résumé](#296-résumé)

---

Java 21 introduit les `Collections Séquencées` et les `Map Séquencées` afin d’unifier et de formaliser l’accès aux éléments en fonction de leur ordre d’apparition.

Cet ajout résout des incohérences de longue date entre listes, sets, queues, deques et map, en fournissant une API commune pour travailler avec le premier et le dernier élément, ainsi qu’avec des vues inversées.

<a id="291-motivation-et-contexte"></a>
## 29.1 Motivation et Contexte

Avant Java 21, les collections ordonnées (telles que List, LinkedHashSet, Deque ou LinkedHashMap) exposaient les opérations liées à l’ordre via des méthodes différentes ou, dans certains cas, pas du tout.  
Les développeurs devaient s’appuyer sur des API spécifiques à l’implémentation ou sur des contournements indirects.

Les interfaces séquencées introduisent un contrat cohérent pour toutes les collections et map ordonnées, rendant les opérations basées sur l’ordre explicites, sûres et uniformes.

---

<a id="292-interface-sequencedcollection"></a>
## 29.2 Interface SequencedCollection

`SequencedCollection<E>` est une nouvelle interface qui étend `Collection<E>` et représente des collections avec un ordre d’apparition bien défini.

Elle est implémentée par `List`, `Deque` et `LinkedHashSet` (`TreeSet` est ordonné mais n’implémente pas directement SequencedCollection).

<a id="2921-méthodes-principales-de-sequencedcollection"></a>
### 29.2.1 Méthodes Principales de SequencedCollection

L’interface définit des méthodes pour accéder et manipuler les éléments aux deux extrémités de la collection.

| Méthode | Description |
|--------|-------------|
| `E getFirst()` | Retourne le premier élément |
| `E getLast()` | Retourne le dernier élément |
| `void addFirst(E e)` | Insère un élément au début |
| `void addLast(E e)` | Insère un élément à la fin |
| `E removeFirst()` | Supprime et retourne le premier élément |
| `E removeLast()` | Supprime et retourne le dernier élément |
| `SequencedCollection<E> reversed()` | Retourne une vue inversée |

<a id="2922-implémentations-de-sequencedcollection"></a>
### 29.2.2 Implémentations de SequencedCollection

Les types standards suivants implémentent SequencedCollection :

| Type | Notes |
|------|-------|
| **List** | Ordonnée par index |
| **Deque** | File à double extrémité |
| **LinkedHashSet** | Maintient l’ordre d’insertion |

<a id="2923-vues-inversées"></a>
### 29.2.3 Vues Inversées

L’appel à `reversed()` ne crée pas de copie.

Il retourne une vue live de la même collection avec l’ordre inversé.

```java
List<Integer> list = new ArrayList<>(List.of(1, 2, 3));
SequencedCollection<Integer> rev = list.reversed();

rev.removeFirst(); // supprime 3
System.out.println(list); // [1, 2]
```

!!! note
    Les vues inversées partagent la même collection sous-jacente.
    Les modifications structurelles dans l’une ou l’autre vue affectent l’autre :
    modifier soit la collection originale soit la vue inversée a un effet sur les deux.

---

<a id="293-interface-sequencedmap"></a>
## 29.3 Interface SequencedMap

`SequencedMap<K,V>` étend `Map<K,V>` et représente des map avec un ordre d’apparition des entrées bien défini.

Elle standardise des opérations qui n’existaient auparavant que dans des implémentations spécifiques comme `LinkedHashMap`.

<a id="2931-méthodes-principales-de-sequencedmap"></a>
### 29.3.1 Méthodes Principales de SequencedMap

| Méthode | Description |
|--------|-------------|
| `Entry<K,V> firstEntry()` | Première entrée de la map |
| `Entry<K,V> lastEntry()` | Dernière entrée de la map |
| `Entry<K,V> pollFirstEntry()` | Supprime et retourne la première entrée, ou null si vide |
| `Entry<K,V> pollLastEntry()` | Supprime et retourne la dernière entrée, ou null si vide |
| `SequencedMap<K,V> reversed()` | Vue inversée de la map |

<a id="2932-implémentations-de-sequencedmap"></a>
### 29.3.2 Implémentations de SequencedMap

Actuellement, la principale implémentation standard est :

| Type | Ordonnancement |
|------|----------------|
| `LinkedHashMap` | Ordre d’insertion (ou ordre d’accès si configuré) |

!!! note
    LinkedHashMap peut réordonner les entrées lors de la lecture si elle est construite avec `accessOrder=true`.
    
    Dans ce cas, « première » et « dernière » reflètent l’ordre d’accès le plus récent.

<a id="2933-map-inversées"></a>
### 29.3.3 Map Inversées

Comme pour les collections, `reversed()` sur une map séquencée retourne une vue, et non une copie.

```java
SequencedMap<String, Integer> map =
new LinkedHashMap<>(Map.of("A", 1, "B", 2, "C", 3));

SequencedMap<String, Integer> rev = map.reversed();

rev.pollFirstEntry(); // supprime C=3
System.out.println(map); // {A=1, B=2}
```

!!! note
    Comme pour SequencedCollection, `reversed()` retourne une vue live — les mutations s’appliquent aux deux map.

---

<a id="294-relation-avec-les-api-existantes"></a>
## 29.4 Relation avec les API Existantes

Les interfaces séquencées ne remplacent pas les types de collections existants.

Elles se placent au-dessus d’eux dans la hiérarchie et unifient les comportements communs.

Toutes les collections ordonnées existantes bénéficient automatiquement de ces API sans casser la rétrocompatibilité.

<a id="2941-quels-types-built-in-sont-séquencés"></a>
### 29.4.1 Quels Types Built-in Sont Séquencés

Le tableau suivant résume si les types standards de collections sont ordonnés
et s’ils implémentent les nouvelles interfaces Sequenced.

| Type | Ordonné ? | SequencedCollection ? | SequencedMap ? |
|------|-----------|----------------------|----------------|
| `List` | ✔ Oui | ✔ Oui | ✘ Non |
| `Deque` | ✔ Oui | ✔ Oui | ✘ Non |
| `LinkedHashSet` | ✔ Oui | ✔ Oui | ✘ Non |
| `TreeSet` | ✔ Oui (trié) | ✘ Non* | ✘ Non |
| `HashSet` | ✘ Non | ✘ Non | ✘ Non |
| `LinkedHashMap` | ✔ Oui | ✘ Non | ✔ Oui |
| `HashMap` | ✘ Non | ✘ Non | ✘ Non |
| `TreeMap` | ✔ Oui (trié) | ✘ Non | ✘ Non |

!!! note
    `TreeSet` est ordonné, mais implémente `SortedSet`/`NavigableSet`, pas `SequencedCollection`.

---

<a id="295-pièges-courants"></a>
## 29.5 Pièges Courants

- Les interfaces séquencées définissent des vues, pas des copies
- `reversed()` reflète les modifications de manière bidirectionnelle
- Toutes les implémentations de Set ou de Map ne sont pas séquencées
- HashSet et HashMap n’implémentent pas les interfaces séquencées
- L’ordre n’est garanti que lorsqu’il est explicitement défini
- Supprimer des éléments via un iterator sur la vue inversée impacte immédiatement l’ordre original

---

<a id="296-résumé"></a>
## 29.6 Résumé

- Les interfaces séquencées formalisent l’ordre d’apparition
- Elles fournissent un accès first/last et l’inversion
- Elles fonctionnent via des vues live, pas des copies
- Elles unifient les API entre listes, deque, set et map
