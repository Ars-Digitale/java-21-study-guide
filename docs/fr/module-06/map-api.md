# 28. Map API

### Table des matières

- [28. Map API](#28-map-api)
  - [28.1 Caractéristiques Fondamentales de Map](#281-caractéristiques-fondamentales-de-map)
  - [28.2 Principales Implémentations de Map](#282-principales-implémentations-de-map)
  - [28.3 Créer des Map](#283-créer-des-map)
  - [28.4 Opérations de Base sur les Map](#284-opérations-de-base-sur-les-map)
  - [28.5 Itérer sur une Map](#285-itérer-sur-une-map)
  - [28.6 Déterminer l’Égalité dans les Map](#286-déterminer-légalité-dans-les-map)
  - [28.7 Comportement Spécial de TreeMap](#287-comportement-spécial-de-treemap)
  - [28.8 Gestion des Null](#288-gestion-des-null)
  - [28.9 Pièges Courants](#289-pièges-courants)
  - [28.10 Résumé](#2810-résumé)

---

L’interface `Map` représente une collection de **paires clé–valeur**, où chaque clé est associée à au plus une valeur.

Contrairement aux autres types de collections, `Map` **n’étend pas** `Collection` et possède donc sa propre hiérarchie et ses propres règles.

## 28.1 Caractéristiques Fondamentales de Map

- Chaque clé est unique ; **les clés dupliquées écrasent la valeur précédente**
- Les valeurs peuvent être dupliquées
- Les Map ne prennent pas en charge l’accès positionnel (basé sur des indices)
- L’itération s’effectue via `keySet()`, `values()` ou `entrySet()`

> [!NOTE]
> Une `Map` n’est pas une `Collection`, mais ses vues (keySet, values, entrySet) sont des collections.

---

## 28.2 Principales Implémentations de Map

| Implémentation | Ordonnancement | Clés Null | Valeurs Null | Thread-Safe | Notes |
|----------------|----------------|-----------|--------------|-------------|-------|
| `HashMap` | Aucun ordre | 1 | Plusieurs | Non | Rapide, la plus courante |
| `LinkedHashMap` | Ordre d’insertion | 1 | Plusieurs | Non | Itération prévisible |
| `TreeMap` | Triée par clé | Non | Plusieurs | Non | Les clés doivent être comparables |
| `Hashtable` | Aucun ordre | Non | Non | Oui | Legacy |
| `ConcurrentHashMap` | Aucun ordre | Non | Non | Oui | Adaptée à la concurrence |

> [!NOTE]
> L’ordre de `TreeMap` est déterminé soit par `Comparable`, soit par un `Comparator` fourni lors de la construction.

---

## 28.3 Créer des Map

Les `Map` peuvent être créées à l’aide de constructeurs ou de méthodes factory.

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

> [!NOTE]
> Les Map créées avec `Map.of(...)` et `Map.ofEntries(...)` sont **immuables**. Toute tentative de modification lève `UnsupportedOperationException`.

---

## 28.4 Opérations de Base sur les Map

| Méthode | Description | Valeur de Retour |
|--------|-------------|------------------|
| `put(k, v)` | Ajoute ou remplace une association | Valeur précédente ou null |
| `putIfAbsent(k,v)` | Ajoute seulement si la clé est absente | Valeur existante ou null |
| `get(k)` | Retourne la valeur ou null | Valeur spécifique ou null |
| `getOrDefault(k, default)` | Retourne la valeur ou la valeur par défaut | Valeur spécifique ou défaut |
| `remove(k)` | Supprime l’association | Valeur supprimée ou null |
| `containsKey(k)` | Vérifie la présence de la clé | boolean |
| `containsValue(v)` | Vérifie la présence de la valeur | boolean |
| `size()` | Nombre d’entrées | int |
| `isEmpty()` | Test de vacuité | boolean |
| `clear()` | Supprime toutes les entrées | void |
| `V merge(k, v, BiFunction(V, V, V))` | merge(k, v, remappingFunction) | si clé absente → définit la valeur ; si clé présente → function(oldValue, newValue) ; si la fonction retourne null → association supprimée |

```java
Map<String, String> map = new HashMap<>();
map.put("A", "Apple");
map.put("B", "Banana");

map.put("A", "Avocado"); // écrase la valeur

String v = map.get("B"); // Banana
```

---

## 28.5 Itérer sur une Map

Les Map sont parcourues via des vues :

- `keySet()` → Set de clés
- `values()` → Collection de valeurs
- `entrySet()` → Set de Map.Entry

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

> [!NOTE]
> Modifier la map pendant l’itération sur ces vues peut lever `ConcurrentModificationException` (sauf pour les map concurrentes).

---

## 28.6 Déterminer l’Égalité dans les Map

L’égalité des map est définie comme suit :

- Deux map sont égales si elles contiennent les mêmes associations clé–valeur
- La comparaison des clés utilise `equals()`
- La comparaison des valeurs utilise `equals()`

```java
Map<String, Integer> m1 = Map.of("A", 1, "B", 2);
Map<String, Integer> m2 = Map.of("B", 2, "A", 1);

System.out.println(m1.equals(m2)); // true
```

> [!NOTE]
> L’ordre d’itération n’affecte pas l’égalité des map.

---

## 28.7 Comportement Spécial de TreeMap

TreeMap maintient les entrées triées selon les clés.

```java
Map<Integer, String> tm = new TreeMap<>();
tm.put(3, "C");
tm.put(1, "A");
tm.put(2, "B");

System.out.println(tm); // {1=A, 2=B, 3=C}
```

> [!WARNING]
> Toutes les clés d’une `TreeMap` doivent être mutuellement comparables.
> Mélanger des types incompatibles provoque une `ClassCastException` à l’exécution.

---

## 28.8 Gestion des Null

| Implémentation | Clé Null | Valeur Null |
|----------------|----------|-------------|
| HashMap | Oui (1) | Oui |
| LinkedHashMap | Oui (1) | Oui |
| TreeMap | Non | Oui |
| Hashtable | Non | Non |
| ConcurrentHashMap | Non | Non |

> [!NOTE]
> `TreeMap` accepte les valeurs `null` uniquement lorsqu’elles ne participent pas à la comparaison des clés. En pratique, cela est rare, car les clés null sont interdites et les comparators peuvent rejeter les null.
>
> `HashMap` et `LinkedHashMap` autorisent une seule clé null — en insérer une autre remplace l’existante.

---

## 28.9 Pièges Courants

- Supposer que Map est une Collection
- Oublier que les clés dupliquées écrasent les valeurs
- Utiliser des clés null dans TreeMap ou ConcurrentHashMap
- Confondre l’ordre d’itération avec l’égalité
- Tenter de modifier des map immuables créées via Map.of

---

## 28.10 Résumé

- Les Map stockent des clés uniques associées à des valeurs
- L’ordonnancement dépend de l’implémentation
- L’égalité est basée sur les paires clé–valeur
- TreeMap exige des clés comparables
- Les map immuables lèvent des exceptions en cas de modification
