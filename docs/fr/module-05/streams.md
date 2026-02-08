# 21. Java Optional et Streams

### Table des matières

- [21. Java Optional et Streams](#21-java-optional-et-streams)
  - [21.1 Optional (Optional OptionalInt OptionalLong OptionalDouble)](#211-optional-optional-optionalint-optionallong-optionaldouble)
    - [21.1.1 Créer des Optional](#2111-créer-des-optional)
    - [21.1.2 Lire des valeurs en toute sécurité](#2112-lire-des-valeurs-en-toute-sécurité)
    - [21.1.3 Transformer des Optional](#2113-transformer-des-optional)
    - [21.1.4 Optional et Streams](#2114-optional-et-streams)
    - [21.1.5 Optional pour les types primitifs](#2115-optional-pour-les-types-primitifs)
    - [21.1.6 Pièges courants](#2116-pièges-courants)
  - [21.2 Qu’est-ce qu’un Stream (et ce que ce n’est pas)](#212-quest-ce-quun-stream-et-ce-que-ce-nest-pas)
  - [21.3 Architecture du pipeline Stream](#213-architecture-du-pipeline-stream)
    - [21.3.1 Sources de Stream](#2131-sources-de-stream)
    - [21.3.2 Opérations intermédiaires](#2132-opérations-intermédiaires)
      - [21.3.2.1 Tableau des opérations intermédiaires courantes](#21321-tableau-des-opérations-intermédiaires-courantes)
    - [21.3.3 Opérations terminales](#2133-opérations-terminales)
      - [21.3.3.1 Tableau des opérations terminales](#21331-tableau-des-opérations-terminales)
  - [21.4 Évaluation paresseuse et court-circuitage](#214-evaluation-paresseuse-et-court-circuitage)
  - [21.5 Opérations stateless vs stateful](#215-opérations-stateless-vs-stateful)
    - [21.5.1 Opérations stateless](#2151-opérations-stateless)
    - [21.5.2 Opérations stateful](#2152-opérations-stateful)
  - [21.6 Ordonnancement des Streams et déterminisme](#216-ordonnancement-des-streams-et-déterminisme)
  - [21.7 Streams parallèles](#217-streams-parallèles)
  - [21.8 Opérations de réduction](#218-opérations-de-réduction)
    - [21.8.1 `reduce()` : combiner un stream en un seul objet](#2181-reduce-combiner-un-stream-en-un-seul-objet)
      - [21.8.1.1 Modèle mental correct](#21811-modèle-mental-correct)
    - [21.8.2 `collect()`](#2182-collect)
    - [21.8.3 Pourquoi `collect()` est différent de `reduce()`](#2183-pourquoi-collect-est-différent-de-reduce)
  - [21.9 Pièges courants des Streams](#219-pièges-courants-des-streams)
  - [21.10 Streams primitifs](#2110-streams-primitifs)
    - [21.10.1 Pourquoi les streams primitifs sont importants](#21101-pourquoi-les-streams-primitifs-sont-importants)
    - [21.10.2 Méthodes courantes de création](#21102-méthodes-courantes-de-création)
    - [21.10.3 Méthodes de mapping spécialisées pour les primitifs](#21103-méthodes-de-mapping-spécialisées-pour-les-primitifs)
    - [21.10.4 Tableau de mapping entre `Stream<T>` et les streams primitifs](#21104-tableau-de-mapping-entre-streamt-et-les-streams-primitifs)
    - [21.10.5 Opérations terminales et leurs types de résultat](#21105-opérations-terminales-et-leurs-types-de-résultat)
    - [21.10.6 Pièges et gotchas courants](#21106-pièges-et-gotchas-courants)
  - [21.11 Collectors (collect(), Collector et les méthodes factory de Collectors)](#2111-collectors-collect-collector-et-les-méthodes-factory-de-collectors)
    - [21.11.1 collect() vs Collector](#21111-collect-vs-collector)
    - [21.11.2 Collectors principaux](#21112-collectors-principaux)
    - [21.11.3 Collectors de regroupement](#21113-collectors-de-regroupement)
    - [21.11.4 partitioningBy](#21114-partitioningby)
    - [21.11.5 toMap et règles de fusion](#21115-tomap-et-règles-de-fusion)
    - [21.11.6 collectingAndThen](#21116-collectingandthen)
    - [21.11.7 Comment les collectors se rapportent aux streams parallèles](#21117-comment-les-collectors-se-rapportent-aux-streams-parallèles)

---

## 21.1 Optional (Optional, OptionalInt, OptionalLong, OptionalDouble)

`Optional<T>` est un objet conteneur qui peut contenir, ou non, une valeur non nulle.

Il a été conçu pour rendre explicite « l’absence d’une valeur » et pour réduire le risque de `NullPointerException` en forçant les appelants à gérer le cas d’absence.

> [!NOTE]
> - `Optional` est principalement destiné aux **types de retour**.
> - Il est généralement déconseillé pour les attributs, les paramètres de méthode et les contextes de sérialisation (sauf si un contrat API spécifique l’exige).

### 21.1.1 Créer des Optional

Il existe trois méthodes factory principales pour créer des Optional.

- `Optional.of(value)` → value doit être non nulle ; sinon une `NullPointerException` est levée
- `Optional.ofNullable(value)` → retourne empty si value est null
- `Optional.empty()` → un Optional explicitement vide

```java
Optional<String> a = Optional.of("x");
Optional<String> b = Optional.ofNullable(null); // Optional.empty
Optional<String> c = Optional.empty();
```

### 21.1.2 Lire des valeurs en toute sécurité

Les Optional fournissent plusieurs moyens d’accéder à la valeur encapsulée.

- `isPresent()` / `isEmpty()` → test de présence
- `get()` → retourne la valeur ou lève `NoSuchElementException` si absente (déconseillé)
- `orElse(defaultValue)` → retourne la valeur ou la valeur par défaut (évaluée immédiatement)
- `orElseGet(supplier)` → retourne la valeur ou le résultat du supplier (supplier évalué de manière lazy)
- `orElseThrow()` → retourne la valeur ou lève `NoSuchElementException`
- `orElseThrow(exceptionSupplier)` → retourne la valeur ou lève une exception personnalisée

```java
Optional<String> opt = Optional.of("java");

String v1 = opt.orElse("default");
String v2 = opt.orElseGet(() -> "computed");
String v3 = opt.orElseThrow(); // ok car opt est présent
```

> [!NOTE]
> - Un piège courant : `orElse(...)` évalue son argument même si l’Optional est présent.
> - Utilisez `orElseGet(...)` lorsque la valeur par défaut est coûteuse à calculer.

### 21.1.3 Transformer des Optional

Les Optional prennent en charge des transformations fonctionnelles similaires aux streams, mais avec une sémantique « 0 ou 1 élément ».

- `map(fn)` → transforme la valeur si elle est présente
- `flatMap(fn)` → transforme en un Optional aplati, sans imbrication
- `filter(predicate)` → conserve la valeur uniquement si le predicate est true

```java
Optional<String> name = Optional.of("Alice");

Optional<Integer> len =
	name.map(String::length); // Optional[5]

Optional<String> filtered =
	name.filter(n -> n.startsWith("A")); // Optional[Alice]

System.out.println(len.orElse(0));
System.out.println(filtered.orElseGet(() -> "11"));
```

Sortie :

```text
5
Alice
```

> [!NOTE]
> - `map` encapsule le résultat dans un Optional.
> - Si votre fonction de mapping retourne déjà un Optional, utilisez `flatMap` pour éviter l’imbrication `Optional<Optional<T>>`.

### 21.1.4 Optional et Streams

Un pattern de pipeline très courant consiste à effectuer un `map` vers un Optional puis à supprimer les éléments absents.

Depuis Java 9, `Optional` fournit `stream()` pour convertir « présent → un élément » et « vide → zéro élément ».

```java
		Stream<String> words = Stream.of("a", "bb", "ccc");

		words.map(w -> w.length() > 1 ? Optional.of(w.length()) : Optional.<Integer>empty())
		     .flatMap(Optional::stream) // supprime les éléments vides
		     .forEach(System.out::println);
```

Sortie :

```text
2
3
```

> [!NOTE]
> Avant Java 9, ce pattern nécessitait `filter(Optional::isPresent)` plus `map(Optional::get)`.

### 21.1.5 Optional pour les types primitifs

Les streams primitifs utilisent des optional primitifs pour éviter le boxing : `OptionalInt`, `OptionalLong`, `OptionalDouble`.

Ils reflètent l’API principale de Optional avec des getters primitifs comme `getAsInt()`.

- `OptionalInt.getAsInt()` / `OptionalLong.getAsLong()` / `OptionalDouble.getAsDouble()`
- `orElse(...)` / `orElseGet(...)` / `orElseThrow(...)`

```java
OptionalInt m = IntStream.of(3, 1, 2).min(); // OptionalInt[1]
int value = m.orElse(0); // 1
```

### 21.1.6 Pièges courants

- Ne pas utiliser `get()` sans vérifier la présence ; préférer `orElseThrow` ou les transformations
- Éviter de retourner `null` au lieu de `Optional.empty()` ; une référence Optional elle-même ne devrait pas être null
- Se souvenir que `average()` sur les streams primitifs retourne toujours `OptionalDouble` (même pour `IntStream` et `LongStream`)
- Utiliser `orElseGet` lorsque le calcul de la valeur par défaut est coûteux en termes de performances

---

## 21.2 Qu’est-ce qu’un Stream (et ce que ce n’est pas)

Un `Stream Java` représente une séquence d’éléments (un pipeline) prenant en charge des opérations de style fonctionnel.

Les streams sont conçus pour le traitement des données, et non pour leur stockage.

**Caractéristiques clés** :

- Un stream ne stocke pas de données
- Un stream est lazy — rien ne se produit tant qu’une opération terminale n’est pas invoquée
- Un stream ne peut être consommé qu’une seule fois
- Les streams encouragent des opérations sans effets de bord

> [!NOTE]
> Les streams sont conceptuellement similaires aux requêtes de bases de données : ils décrivent ce qu’il faut calculer, et non comment itérer.

---

## 21.3 Architecture du pipeline Stream

Chaque pipeline de stream se compose de trois phases distinctes :

- 1️⃣ **Source**
- 2️⃣ Zéro ou plusieurs **Opérations intermédiaires**
- 3️⃣ Exactement une **Opération terminale**

### 21.3.1 Sources de Stream

Les sources courantes de stream incluent :

- Collections : `collection.stream()`
- Tableaux : `Arrays.stream(array)`
- Canaux I/O et fichiers
- Streams infinis : `Stream.iterate`, `Stream.generate`

```java
List<String> names = List.of("Ana", "Bob", "Carla");

Stream<String> s = names.stream();
```

### 21.3.2 Opérations intermédiaires

Opérations intermédiaires :

- Retournent un nouveau stream
- Sont évaluées de manière lazy
- Ne déclenchent pas l’exécution

#### 21.3.2.1 Tableau des opérations intermédiaires courantes

| Method | Common input Params | Return value | Desctiption |
|--------|--------------------|--------------|-------------|
| `filter` | Predicate | `Stream<T>` | filtre le stream selon une correspondance du predicate |
| `map` | Function | `Stream<R>` | transforme un stream par un mapping un-à-un entrée/sortie |
| `flatMap` | Function | `Stream<R>` | aplatit des streams imbriqués en un seul stream |
| `sorted` | (none) or Comparator | `Stream<T>` | trie par ordre naturel ou selon le Comparator fourni |
| `distinct` | (none) | `Stream<T>` | supprime les éléments dupliqués |
| `limit` / `skip` | long | `Stream<T>` | limite la taille ou saute des éléments |
| `peek` | Consumer | `Stream<T>` | exécute une action avec effet de bord pour chaque élément (debugging) |

- Exemple :

```java
		List<String> names = List.of("Ana", "Bob", "Carla", "Mario");

		names.stream()
		     .filter(n -> n.length() > 3)
		     .map(String::toUpperCase)
		     .forEach(System.out::println);
```

Sortie :

```text
CARLA
MARIO
```

> [!NOTE]
> Les opérations intermédiaires décrivent uniquement le calcul. Aucun élément n’est encore traité.

### 21.3.3 Opérations terminales

Opérations terminales :

- Déclenchent l’exécution
- Consomment le stream
- Produisent un résultat ou un effet de bord

#### 21.3.3.1 Tableau des opérations terminales

| Method | Return value | behaviour for infinite streams |
|--------|--------------|--------------------------------|
| `forEach` | **void** | ne termine pas |
| `collect` | varie | ne termine pas |
| `reduce` | varie | ne termine pas |
| `findFirst` / `findAny` | **`Optional<T>`** | termine |
| `anyMatch` / `allMatch` / `noneMatch` | **boolean** | peut terminer tôt (court-circuit) |
| `min` / `max` | **`Optional<T>`** | ne termine pas |
| `count` | **long** | ne termine pas |

---

## 21.4 Évaluation paresseuse et court-circuitage

```java
var newNames = new ArrayList<String>();

newNames.add("Bob");
newNames.add("Dan");

// Les streams sont évalués de manière paresseuse : ceci ne parcourt pas encore les données,
// cela crée uniquement une description du pipeline liée à la source.
var stream = newNames.stream();

newNames.add("Erin");

// L’opération terminale déclenche l’évaluation. Le stream voit la source mise à jour,
// donc le count inclut "Erin".
stream.count(); // 3
```

**Note importante :**  
Un stream est lié à sa *source* (`newNames`), et le pipeline n’est pas exécuté tant qu’une opération terminale n’est pas invoquée.  
Pour cette raison, si vous **modifiez la collection avant l’opération terminale**, l’opération terminale « voit » les nouveaux éléments (ici, `Erin`).  
En général, toutefois, **modifier la source pendant qu’un pipeline de stream est en cours d’utilisation est une mauvaise pratique** et peut conduire à un comportement non déterministe (ou à une `ConcurrentModificationException` avec certaines sources/opérations).  
La règle pratique est : *construire la source, puis créer et exécuter le stream sans la modifier*.

Les streams traitent les éléments **un par un**, en circulant « verticalement » à travers le pipeline plutôt que étape par étape.

Ci-dessous, nous modifions l’exemple pour utiliser une opération terminale **à court-circuit** : `findFirst()`.

```java
Stream.of("a", "bb", "ccc")
    .filter(s -> {
        System.out.println("filter " + s);
        return s.length() > 1;
    })
    .map(s -> {
        System.out.println("map " + s);
        return s.toUpperCase();
    })
    .findFirst()
    .ifPresent(System.out::println);
```

Ordre d’exécution :

> [!NOTE]
> Seul le nombre minimal d’éléments requis par l’opération terminale est traité.

```text
filter a
filter bb
map bb
BB
```

`findFirst()` est satisfait dès qu’il trouve le **premier** élément qui traverse avec succès le pipeline (ici `"bb"`), donc :
- `"ccc"` n’est jamais traité (ni `filter` ni `map`) ;
- l’évaluation paresseuse évite un travail inutile par rapport à une opération terminale qui consomme tous les éléments (comme `forEach` ou `count`).

---

## 21.5 Opérations stateless vs stateful

### 21.5.1 Opérations stateless

Des opérations comme `map` et `filter` traitent chaque élément indépendamment.

### 21.5.2 Opérations stateful

Des opérations comme `distinct`, `sorted` et `limit` nécessitent le maintien d’un état interne.

> [!NOTE]
> Les opérations stateful peuvent avoir un impact sévère sur les performances des streams parallèles.

---

## 21.6 Ordonnancement des Streams et déterminisme

Les streams peuvent être :

- Ordonnés (ex. `List.stream()`)
- Non ordonnés (ex. `HashSet.stream()`)

Certaines opérations respectent l’ordre de parcours :

- `forEachOrdered`
- `findFirst`

> [!NOTE]
> Dans les streams parallèles, `forEach` ne garantit pas l’ordre.

---

## 21.7 Streams parallèles

Les streams parallèles divisent le travail entre threads en utilisant `ForkJoinPool.commonPool()`.

```java
int sum =
IntStream.range(1, 1_000_000)
	.parallel()
	.sum();
```

Règles pour des streams parallèles sûrs :

- Aucun effet de bord
- Aucun état partagé mutable
- Uniquement des opérations associatives

> [!NOTE]
> Les streams parallèles peuvent être plus lents pour des charges de travail légères.

---

## 21.8 Opérations de réduction

### 21.8.1 `reduce()` : combiner un stream en un seul objet

Il existe trois signatures de méthode pour cette opération :

- public Optional<T> **reduce**(BinaryOperator<T> accumulator);
- public T **reduce**(T identity, BinaryOperator<T> accumulator);
- public <U> U **reduce**(U identity, BiFunction<U, ? super T, U> accumulator, BinaryOperator<U> combiner);

```java
int sum = Stream.of(1, 2, 3)
	.reduce(0, Integer::sum);
```

La réduction requiert :

- **Identity** : valeur initiale pour chaque réduction partielle ; doit être un élément neutre ; exemple : 0 pour la somme, 1 pour la multiplication, collection vide pour la collecte ;
- **Accumulator** : incorpore un élément du stream dans un résultat partiel ;
- (Optionnel) **Combiner** : fusionne deux résultats partiels ; utilisé uniquement lorsque le stream est parallèle ; ignoré pour les streams séquentiels

> [!NOTE]
> L’accumulator doit être associatif et stateless.

#### 21.8.1.1 Modèle mental correct

- Accumulator : résultat + élément
- Combiner : résultat + résultat

**Exemple 1** : Utilisation correcte (somme des longueurs)

```java
int totalLength =
    Stream.of("a", "bb", "ccc")
          .parallel()
          .reduce(
              0,                            // identity
              (sum, s) -> sum + s.length(), // accumulator
              (left, right) -> left + right // combiner
          );
```

Ce qui se passe en parallèle

Supposons que le stream soit divisé :

- Thread 1 : "a", "bb" → 0 + 1 + 2 = 3
- Thread 2 : "ccc" → 0 + 3 = 3

Ensuite, le combiner fusionne les résultats partiels :

```bash
3 + 3 = 6
```

**Exemple 2** : Combiner ignoré dans les streams séquentiels

```java
int result =
    Stream.of("a", "bb", "ccc")
          .reduce(
              0,
              (sum, s) -> sum + s.length(),
              (x, y) -> {
                  throw new RuntimeException("Never called");
              }
          );
```

**Exemple 3** : Combiner incorrect

```java
int result =
    Stream.of(1, 2, 3, 4)
          .parallel()
          .reduce(
              0,
              (a, b) -> a - b,   // accumulator
              (x, y) -> x - y    // combiner
          );
```

<ins>Pourquoi ceci est incorrect</ins>

**La soustraction n’est pas associative**.

Exécution possible :

- Thread 1 : 0 - 1 - 2 = -3
- Thread 2 : 0 - 3 - 4 = -7

Combiner :

```bash
-3 - (-7) = 4
```

Le résultat séquentiel serait :

```bash
(((0 - 1) - 2) - 3) - 4 = -10
```

> [!WARNING]
> ❌ Les résultats parallèles et séquentiels diffèrent → réduction illégale

### 21.8.2 `collect()`

`collect` est une réduction mutable optimisée pour le regroupement et l’agrégation.

C’est l’outil standard de l’API Stream pour la « réduction mutable » : vous accumulez des éléments dans un conteneur mutable (comme une List, Set, Map, StringBuilder, objet résultat personnalisé), puis, éventuellement, vous fusionnez les conteneurs partiels lors de l’exécution en parallèle.

La forme générale est :

- public <R> R **collect**(Supplier<R> supplier, BiConsumer<R, ? super T> accumulator, BiConsumer<R, R> combiner);

Une version couramment utilisée est :

- public <R, A> R **collect**(Collector<? super T, A, R> collector);

où `Collectors.*` fournit des collectors préconstruits (grouping, mapping, joining, counting, etc.).

**Signification** :

- **supplier** : crée un nouveau conteneur de résultat vide (ex. `new ArrayList<>()`)
- **accumulator** : ajoute un élément dans ce conteneur (ex. `list::add`)
- **combiner** : fusionne deux conteneurs (ex. `list1.addAll(list2)`)

### 21.8.3 Pourquoi `collect()` est différent de `reduce()`

- **Intention** : mutation vs immutabilité
	- `reduce()` est conçu pour une réduction de style immuable : combiner des valeurs en une nouvelle valeur (ex. somme, min, max).
	- `collect()` est conçu pour des conteneurs mutables : construire une List, Map, StringBuilder, etc.
- **Correction** en parallèle
	- `reduce()` exige que l’opération soit :
		- associative
		- stateless
		- compatible avec les règles d’identity/combiner
	- `collect()` est conçu pour supporter le parallélisme en toute sécurité grâce à :
		- la création d’un conteneur par thread (supplier)
		- l’accumulation locale (accumulator)
		- la fusion finale (combiner)
- **Performance**
	- `collect()` peut être optimisé car le runtime du stream sait que vous construisez des conteneurs :
		- il peut éviter des copies inutiles
		- il peut pré-dimensionner ou utiliser des implémentations spécialisées (selon le collector)
		- c’est l’approche idiomatique et attendue
		- utiliser `reduce()` pour construire une collection crée souvent des objets supplémentaires ou force une mutation non sûre.

- Exemple : « collecter dans une List » de la bonne manière

```java
List<String> longNames =
    names.stream()
         .filter(s -> s.length() > 3)
         .collect(Collectors.toList());
```

- Exemple : groupingBy avec explication

```java
Map<Integer, List<String>> byLength =
    names.stream()
         .collect(Collectors.groupingBy(String::length));
```

Ce qui se passe conceptuellement :

- Le collector crée une `Map<Integer, List<String>>` vide
- Pour chaque nom :
	- calcule la clé (`String::length`)
	- l’ajoute dans la liste du bucket approprié
- En parallèle :
	- chaque thread construit ses propres maps partielles
	- le combiner fusionne les maps en fusionnant les listes par clé

---

## 21.9 Pièges courants des Streams

- Réutiliser un stream déjà consommé → `IllegalStateException`
- Modifier des variables externes à l’intérieur des lambda
- Supposer l’ordre d’exécution dans les streams parallèles
- Utiliser `peek` pour la logique au lieu du debugging

---

## 21.10 Streams primitifs

Java fournit trois types de streams spécialisés pour éviter le surcoût du boxing et pour permettre des opérations centrées sur les nombres :

- `IntStream` pour `int`
- `LongStream` pour `long`
- `DoubleStream` pour `double`

Les streams primitifs restent des streams (pipelines lazy, opérations intermédiaires + terminales, usage unique), mais ils ne sont pas **génériques** et utilisent des interfaces fonctionnelles spécialisées pour les primitifs (ex. `IntPredicate`, `LongUnaryOperator`, `DoubleConsumer`).

> [!NOTE]
> Utilisez les streams primitifs lorsque les données sont naturellement numériques ou lorsque la performance compte : ils évitent le surcoût de boxing/unboxing et fournissent des opérations terminales numériques supplémentaires.

### 21.10.1 Pourquoi les streams primitifs sont importants

- Performance : éviter l’allocation d’objets wrapper et le boxing/unboxing répété dans de grands pipelines
- Commodité : réductions numériques intégrées comme `sum()`, `average()`, `summaryStatistics()`
- Pièges courants : comprendre quand les résultats sont primitifs vs `OptionalInt`/`OptionalLong`/`OptionalDouble`

### 21.10.2 Méthodes courantes de création

Les méthodes suivantes sont les plus fréquemment utilisées pour créer des streams primitifs. De nombreuses questions de certification commencent par identifier le type de stream créé par une méthode factory.

| Sources |
|---------|
| IntStream.of(int...) |
| IntStream.range(int startInclusive, int endExclusive) |
| IntStream.rangeClosed(int startInclusive, int endInclusive) |
| IntStream.iterate(int seed, IntUnaryOperator f) // infini sauf limitation |
| IntStream.iterate(int seed, IntPredicate hasNext, IntUnaryOperator f) |
| IntStream.generate(IntSupplier s) // infini sauf limitation |
| LongStream.of(long...) |
| LongStream.range(long startInclusive, long endExclusive) |
| LongStream.rangeClosed(long startInclusive, long endInclusive) |
| LongStream.iterate(long seed, LongUnaryOperator f) |
| LongStream.iterate(long seed, LongPredicate hasNext, LongUnaryOperator f) |
| LongStream.generate(LongSupplier s) |
| DoubleStream.of(double...) |
| DoubleStream.iterate(double seed, DoubleUnaryOperator f) |
| DoubleStream.iterate(double seed, DoublePredicate hasNext, DoubleUnaryOperator f) |
| DoubleStream.generate(DoubleSupplier s) |

> [!IMPORTANT]
> - Seuls `IntStream` et `LongStream` fournissent `range()` et `rangeClosed()`.
> - Il n’existe pas de `DoubleStream.range` car le comptage avec des doubles pose des problèmes d’arrondi.

### 21.10.3 Méthodes de mapping spécialisées pour les primitifs

Les streams primitifs fournissent des opérations de mapping **uniquement pour primitifs** afin d’éviter le boxing :

- `IntStream.map(IntUnaryOperator)` → `IntStream`
- `IntStream.mapToLong(IntToLongFunction)` → `LongStream`
- `IntStream.mapToDouble(IntToDoubleFunction)` → `DoubleStream`

- `LongStream.map(LongUnaryOperator)` → `LongStream`
- `LongStream.mapToInt(LongToIntFunction)` → `IntStream`
- `LongStream.mapToDouble(LongToDoubleFunction)` → `DoubleStream`

- `DoubleStream.map(DoubleUnaryOperator)` → `DoubleStream`
- `DoubleStream.mapToInt(DoubleToIntFunction)` → `IntStream`
- `DoubleStream.mapToLong(DoubleToLongFunction)` → `LongStream`

### 21.10.4 Tableau de mapping entre `Stream<T>` et les streams primitifs

Ce tableau résume les principales conversions entre streams d’objets et streams primitifs.

La colonne « From » indique quelles méthodes sont disponibles et le type de stream cible résultant.

| From (source) | To (target) | Primary method(s) |
|---------------|-------------|-------------------|
| Stream<T> | Stream<R> | map(Function<? super T, ? extends R>) |
| Stream<T> | Stream<R> (flatten) | flatMap(Function<? super T, ? extends Stream<? extends R>>) |
||||
| Stream<T> | IntStream | mapToInt(ToIntFunction<? super T>) |
| Stream<T> | LongStream | mapToLong(ToLongFunction<? super T>) |
| Stream<T> | DoubleStream | mapToDouble(ToDoubleFunction<? super T>) |
| Stream<T> | IntStream (flatten) | flatMapToInt(Function<? super T, ? extends IntStream>) |
| Stream<T> | LongStream (flatten) | flatMapToLong(Function<? super T, ? extends LongStream>) |
| Stream<T> | DoubleStream (flatten) | flatMapToDouble(Function<? super T, ? extends DoubleStream>) |
||||
| IntStream | Stream<Integer> | boxed() |
| LongStream | Stream<Long> | boxed() |
| DoubleStream | Stream<Double> | boxed() |
||||
| IntStream | Stream<U> | mapToObj(IntFunction<? extends U>) |
| LongStream | Stream<U> | mapToObj(LongFunction<? extends U>) |
| DoubleStream | Stream<U> | mapToObj(DoubleFunction<? extends U>) |
||||
| IntStream | LongStream | asLongStream() |
| IntStream | DoubleStream | asDoubleStream() |
| LongStream | DoubleStream | asDoubleStream() |

> [!IMPORTANT]
> - Il n’existe pas d’opération **`unboxed()`**.
> - Pour passer des wrappers aux primitifs, vous devez partir de `Stream<T>` et utiliser `mapToInt` / `mapToLong` / `mapToDouble`.

### 21.10.5 Opérations terminales et leurs types de résultat

Les streams primitifs disposent de plusieurs opérations terminales qui sont uniques ou qui ont des types de retour spécifiques aux primitifs.

| Terminal operation | IntStream returns | LongStream returns | DoubleStream returns |
|--------------------|-------------------|--------------------|----------------------|
| `count()` | long | long | long |
| `sum()` | int | long | double |
| `min()` / max() | OptionalInt | OptionalLong | OptionalDouble |
| `average()` | OptionalDouble | OptionalDouble | OptionalDouble |
| `findFirst()` / findAny() | OptionalInt | OptionalLong | OptionalDouble |
| `reduce(op)` | OptionalInt | OptionalLong | OptionalDouble |
| `reduce(identity, op)` | int | long | double |
| `summaryStatistics()` | IntSummaryStatistics | LongSummaryStatistics | DoubleSummaryStatistics |

> [!WARNING]
> - Même pour `IntStream` et `LongStream`, **`average()`** retourne `OptionalDouble` (et non `OptionalInt` ou `OptionalLong`).

- Exemple 1 : `Stream<String>` → `IntStream` → opérations terminales primitives

```java
List<String> words = List.of("a", "bb", "ccc");

int totalLength = words.stream()
	.mapToInt(String::length) // IntStream
	.sum(); // int

// totalLength = 1 + 2 + 3 = 6
```

- Exemple 2 : `IntStream` → `Stream<Integer>` boxé (boxing introduit)

```java
Stream<Integer> boxed = IntStream.rangeClosed(1, 3) // 1,2,3
	.boxed(); // Stream<Integer>
```

- Exemple 3 : stream primitif → stream d’objets via `mapToObj`

```java
Stream<String> labels = IntStream.range(1, 4) // 1,2,3
	.mapToObj(i -> "N=" + i); // Stream<String>
```

### 21.10.6 Pièges et gotchas courants

- Ne pas confondre `Stream<Integer>` avec `IntStream` : leurs méthodes de mapping et interfaces fonctionnelles diffèrent
- `IntStream.sum()` retourne `int` mais `IntStream.count()` retourne `long`
- `average()` retourne toujours `OptionalDouble` pour tous les types de streams primitifs
- Utiliser `boxed()` réintroduit le boxing ; ne le faire que si l’API en aval requiert des objets (ex. collecte dans `List<Integer>`)
- Attention aux conversions de narrowing : `LongStream.mapToInt` et `DoubleStream.mapToInt` peuvent tronquer les valeurs

---

## 21.11 Collectors (collect(), Collector et les méthodes factory de Collectors)

Un `Collector` décrit comment accumuler des éléments de stream dans un résultat final.

L’opération terminale `collect(...)` exécute cette recette.

La classe utilitaire `Collectors` fournit des collectors prêts à l’emploi pour des tâches courantes d’agrégation.

### 21.11.1 collect() vs Collector

Il existe deux manières principales de collecter :

- `collect(Collector)` → la forme courante utilisant `Collectors.*`
- `collect(supplier, accumulator, combiner)` → réduction mutable explicite (plus bas niveau)

```java
List<String> list =
Stream.of("a", "b")
	.collect(Collectors.toList());

StringBuilder sb =
Stream.of("a", "b")
	.collect(StringBuilder::new, StringBuilder::append, StringBuilder::append);
```

> [!NOTE]
> Utilisez `collect(supplier, accumulator, combiner)` lorsque vous avez besoin d’un conteneur mutable personnalisé et que vous ne souhaitez pas implémenter un `Collector` complet.

### 21.11.2 Collectors principaux

Voici les collectors les plus fréquemment utilisés et les plus susceptibles d’apparaître dans les questions d’examen.

- `toList()` → `List<T>` (aucune garantie sur la mutabilité ou l’implémentation)
- `toSet()` → `Set<T>`
- `toCollection(supplier)` → type de collection spécifique (ex. `TreeSet`)
- `joining(delim, prefix, suffix)` → `String` à partir d’éléments `CharSequence`
- `counting()` → comptage `Long`
- `summingInt` / `summingLong` / `summingDouble` → sommes numériques
- `averagingInt` / `averagingLong` / `averagingDouble` → moyennes numériques
- `minBy(comparator)` / `maxBy(comparator)` → `Optional<T>`
- `mapping(mapper, downstream)` → transforme puis collecte avec un downstream
- `filtering(predicate, downstream)` → filtre à l’intérieur du collector (Java 9+)

### 21.11.3 Collectors de regroupement

`groupingBy` classe les éléments dans des buckets à l’aide d’une fonction classifier.

Il produit une `Map<K, V>` où `V` dépend du collector downstream.

```java
Map<Integer, List<String>> byLen =
Stream.of("a", "bb", "ccc", "dd")
	.collect(Collectors.groupingBy(String::length));
System.out.println("byLen: " + byLen.toString());
```

Sortie :

```bash
byLen: {1=[a], 2=[bb, dd], 3=[ccc]}
```

Avec un collector downstream, vous contrôlez ce que contient chaque bucket :

```java
Map<Integer, Long> countByLen =
Stream.of("a", "bb", "ccc", "dd")
	.collect(Collectors.groupingBy(String::length, Collectors.counting()));
System.out.println("countByLen: " + countByLen.toString());

Map<Integer, Set<String>> setByLen =
Stream.of("a", "bb", "ccc", "dd")
	.collect(Collectors.groupingBy(String::length, Collectors.toSet()));
System.out.println("setByLen: " + setByLen.toString());
```

Sortie :

```bash
countByLen: {1=1, 2=2, 3=1}
setByLen: {1=[a], 2=[bb, dd], 3=[ccc]}
```

> [!WARNING]
> Faites attention au type de la valeur de la map résultante. Exemple : `groupingBy(..., counting())` produit `Map<K, Long>` (et non `int`).

### 21.11.4 partitioningBy

`partitioningBy` divise le stream en exactement deux groupes à l’aide d’un `Predicate` booléen. Il retourne toujours une map avec les clés `true` et `false`.

```java
Map<Boolean, List<String>> parts =
Stream.of("a", "bb", "ccc")
	.collect(Collectors.partitioningBy(s -> s.length() > 1));
System.out.println("parts: " + parts.toString());
```

Sortie :

```bash
parts: {false=[a], true=[bb, ccc]}
```

> [!NOTE]
> `partitioningBy` crée toujours deux buckets, tandis que `groupingBy` peut en créer plusieurs. Les deux prennent en charge des collectors downstream.

### 21.11.5 toMap et règles de fusion

`toMap` lève une exception en cas de clés dupliquées sauf si vous fournissez une fonction de fusion.

```java
Map<Integer, String> m1 =
Stream.of("aa", "bb")
	.collect(Collectors.toMap(String::length, s -> s)); // ❌ Exception in thread "main" java.lang.IllegalStateException: Duplicate key 2 (attempted merging values aa and bb)

Map<Integer, String> m2 =
Stream.of("aa", "bb", "cc")
	.collect(Collectors.toMap(String::length, s -> s, (oldV, newV) -> oldV + "," + newV)); // key=2 merges values
```

Sortie :

```bash
m2: {2=aa,bb,cc}
```

### 21.11.6 collectingAndThen

`collectingAndThen(downstream, finisher)` permet d’appliquer une transformation finale après la collecte (ex. rendre la liste non modifiable).

```java
List<String> unmodifiable =
Stream.of("a", "b", "c")
	.collect(Collectors.collectingAndThen(Collectors.toList(), List::copyOf));
```

### 21.11.7 Comment les collectors se rapportent aux streams parallèles

Les collectors sont conçus pour fonctionner avec des streams parallèles en utilisant supplier/accumulator/combiner en interne. En parallèle, chaque worker construit un conteneur de résultat partiel puis fusionne les conteneurs.

- L’accumulator modifie un conteneur par thread (aucun état partagé mutable)
- Le combiner fusionne les conteneurs (requis pour l’exécution parallèle)
- Certains collectors sont « concurrent » ou possèdent des caractéristiques influençant les performances et l’ordonnancement

> [!NOTE]
> Préférez `collect(Collectors.toList())` à l’utilisation de `reduce` pour construire des collections. `reduce` est destiné aux réductions de style immuable ; `collect` est destiné aux conteneurs mutables.
