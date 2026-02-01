# 20. Programmation Fonctionnelle en Java

### Table des matières

- [20. Programmation Fonctionnelle en Java](#20-programmation-fonctionnelle-en-java)
  - [20.1 Interfaces Fonctionnelles](#201-interfaces-fonctionnelles)
    - [20.1.1 Règles pour les Interfaces Fonctionnelles](#2011-règles-pour-les-interfaces-fonctionnelles)
    - [20.1.2 Interfaces Fonctionnelles Courantes (java.util.function)](#2012-interfaces-fonctionnelles-courantes-javautilfunction)
    - [20.1.3 Méthodes de Commodité sur les Interfaces Fonctionnelles](#2013-méthodes-de-commodité-sur-les-interfaces-fonctionnelles)
    - [20.1.4 Interfaces Fonctionnelles Primitives](#2014-interfaces-fonctionnelles-primitives)
    - [20.1.5 Résumé](#2015-résumé)
  - [20.2 Expressions Lambda](#202-expressions-lambda)
    - [20.2.1 Syntaxe des Expressions Lambda](#2021-syntaxe-des-expressions-lambda)
    - [20.2.2 Exemples de Syntaxe Lambda](#2022-exemples-de-syntaxe-lambda)
    - [20.2.3 Règles pour les Expressions Lambda](#2023-règles-pour-les-expressions-lambda)
    - [20.2.4 Inférence de Type](#2024-inférence-de-type)
    - [20.2.5 Restrictions dans les Corps des Lambda](#2025-restrictions-dans-les-corps-des-lambda)
    - [20.2.6 Règles de Type de Retour](#2026-règles-de-type-de-retour)
    - [20.2.7 Lambdas vs Classes Anonymes](#2027-lambdas-vs-classes-anonymes)
    - [20.2.8 Erreurs Courantes (Pièges de Certification)](#2028-erreurs-courantes-pièges-de-certification)
  - [20.3 Références de Méthodes](#203-références-de-méthodes)
    - [20.3.1 Référence à une Méthode Statique](#2031-référence-à-une-méthode-statique)
    - [20.3.2 Référence à une Méthode d’Instance d’un Objet Particulier](#2032-référence-à-une-méthode-dinstance-dun-objet-particulier)
    - [20.3.3 Référence à une Méthode d’Instance d’un Objet Arbitraire d’un Type Donné](#2033-référence-à-une-méthode-dinstance-dun-objet-arbitraire-dun-type-donné)
    - [20.3.4 Référence à un Constructeur](#2034-référence-à-un-constructeur)
    - [20.3.5 Tableau Récapitulatif des Types de Method Reference](#2035-tableau-récapitulatif-des-types-de-method-reference)
    - [20.3.6 Pièges Fréquents](#2036-pièges-fréquents)

---

La `programmation fonctionnelle` est un paradigme qui se concentre sur ce qui doit être fait plutôt que sur la manière de le faire.

À partir de Java 8, le langage a ajouté plusieurs fonctionnalités qui permettent un style “fonctionnel” : `lambda expressions`, `functional interfaces` et `method references`.

Ces fonctionnalités permettent d’écrire du code plus expressif, concis et réutilisable, en particulier lorsqu’on travaille avec des collections, des API de concurrence et des systèmes event-driven.

## 20.1 Interfaces Fonctionnelles

En Java, une **interface fonctionnelle** est une interface qui contient **exactement une** méthode abstraite.

Les interfaces fonctionnelles permettent les **Lambda Expressions** et les **Method References**, et constituent le cœur du modèle de programmation fonctionnelle de Java.

> [!NOTE]
> Java considère automatiquement comme interface fonctionnelle toute interface ayant une seule méthode abstraite. L’annotation `@FunctionalInterface` est optionnelle mais recommandée.

### 20.1.1 Règles pour les Interfaces Fonctionnelles

- **Exactement une méthode abstraite** (SAM = Single Abstract Method).
- Une interface peut déclarer un nombre quelconque de méthodes **default**, **static** ou **private**.
- Elle peut redéfinir des méthodes de `Object` (`toString()`, `equals(Object)`, `hashCode()`) sans affecter le décompte SAM.
- La méthode fonctionnelle peut provenir d’une **super-interface**.

Exemple :

```java
@FunctionalInterface
interface Adder {
    int add(int a, int b);   // single abstract method
    static void info() {}
    default void log() {}
}
```

### 20.1.2 Interfaces Fonctionnelles Courantes (java.util.function)

Ci-dessous, un résumé des interfaces fonctionnelles les plus importantes.

| Functional Interface | Returns | Method | Parameters |
|---------------------|---------|--------|------------|
| `Supplier<T>`       | T       | get()  | 0          |
| `Consumer<T>`       | void    | accept(T) | 1       |
| `BiConsumer<T,U>`   | void    | accept(T,U) | 2     |
| `Function<T,R>`     | R       | apply(T) | 1        |
| `BiFunction<T,U,R>` | R       | apply(T,U) | 2      |
| `UnaryOperator<T>`  | T       | apply(T) | 1 (mêmes types) |
| `BinaryOperator<T>` | T       | apply(T,T) | 2 (mêmes types) |
| `Predicate<T>`      | boolean | test(T) | 1        |
| `BiPredicate<T,U>`  | boolean | test(T,U) | 2      |

- Exemples

```java
Supplier<String> sup = () -> "Hello!";

Consumer<String> printer = s -> System.out.println(s);

Function<String, Integer> length = s -> s.length();

UnaryOperator<Integer> square = x -> x * x;

Predicate<Integer> positive = x -> x > 0;
```

### 20.1.3 Méthodes de Commodité sur les Interfaces Fonctionnelles

De nombreuses interfaces fonctionnelles proposent des méthodes utilitaires permettant l’enchaînement et la composition.

| Interface      | Method     | Description |
|---------------|------------|-------------|
| Function      | andThen()  | applique celle-ci, puis une autre |
| Function      | compose()  | applique une autre, puis celle-ci |
| Function      | identity() | renvoie une fonction x -> x |
| Predicate     | and()      | ET logique |
| Predicate     | or()       | OU logique |
| Predicate     | negate()   | NON logique |
| Consumer      | andThen()  | chaîne des consumers |
| BinaryOperator| minBy()    | minimum basé sur un comparator |
| BinaryOperator| maxBy()    | maximum basé sur un comparator |

- Exemples

```java
Function<Integer, Integer> times2 = x -> x * 2;
Function<Integer, Integer> plus3  = x -> x + 3;

var result1 = times2.andThen(plus3).apply(5);   // (5*2)+3 = 13
var result2 = times2.compose(plus3).apply(5);   // (5+3)*2 = 16

Predicate<String> longString = s -> s.length() > 5;
Predicate<String> startsWithA = s -> s.startsWith("A");

boolean ok = longString.and(startsWithA).test("Amazing");  // true
```

### 20.1.4 Interfaces Fonctionnelles Primitives

Java fournit des versions spécialisées des interfaces fonctionnelles pour les types primitifs afin d’éviter le coût du boxing/unboxing.

| Functional Interface              | Return Type | Single Abstract Method | # Parameters |
|----------------------------------|-------------|-------------------------|--------------|
| IntSupplier                       | int         | getAsInt()              | 0            |
| LongSupplier                      | long        | getAsLong()             | 0            |
| DoubleSupplier                    | double      | getAsDouble()           | 0            |
| BooleanSupplier                   | boolean     | getAsBoolean()          | 0            |
|                                  |             |                         |              |
| IntConsumer                       | void        | accept(int)             | 1 (int)      |
| LongConsumer                      | void        | accept(long)            | 1 (long)     |
| DoubleConsumer                    | void        | accept(double)          | 1 (double)   |
|                                  |             |                         |              |
| IntPredicate                      | boolean     | test(int)               | 1 (int)      |
| LongPredicate                     | boolean     | test(long)              | 1 (long)     |
| DoublePredicate                   | boolean     | test(double)            | 1 (double)   |
|                                  |             |                         |              |
| IntUnaryOperator                  | int         | applyAsInt(int)         | 1 (int)      |
| LongUnaryOperator                 | long        | applyAsLong(long)       | 1 (long)     |
| DoubleUnaryOperator               | double      | applyAsDouble(double)   | 1 (double)   |
|                                  |             |                         |              |
| IntBinaryOperator                 | int         | applyAsInt(int, int)    | 2 (int,int)  |
| LongBinaryOperator                | long        | applyAsLong(long, long) | 2 (long,long)|
| DoubleBinaryOperator              | double      | applyAsDouble(double,double) | 2       |
|                                  |             |                         |              |
| IntFunction<R>                    | R           | apply(int)              | 1 (int)      |
| LongFunction<R>                   | R           | apply(long)             | 1 (long)     |
| DoubleFunction<R>                 | R           | apply(double)           | 1 (double)   |
|                                  |             |                         |              |
| ToIntFunction<T>                  | int         | applyAsInt(T)           | 1 (T)        |
| ToLongFunction<T>                 | long        | applyAsLong(T)          | 1 (T)        |
| ToDoubleFunction<T>               | double      | applyAsDouble(T)        | 1 (T)        |
|                                  |             |                         |              |
| ToIntBiFunction<T,U>              | int         | applyAsInt(T,U)         | 2 (T,U)      |
| ToLongBiFunction<T,U>             | long        | applyAsLong(T,U)        | 2 (T,U)      |
| ToDoubleBiFunction<T,U>           | double      | applyAsDouble(T,U)      | 2 (T,U)      |
|                                  |             |                         |              |
| ObjIntConsumer<T>                 | void        | accept(T,int)           | 2 (T,int)    |
| ObjLongConsumer<T>                | void        | accept(T,long)          | 2 (T,long)   |
| ObjDoubleConsumer<T>              | void        | accept(T,double)        | 2 (T,double) |
|                                  |             |                         |              |
| DoubleToIntFunction               | int         | applyAsInt(double)      | 1            |
| DoubleToLongFunction              | long        | applyAsLong(double)     | 1            |
| IntToDoubleFunction               | double      | applyAsDouble(int)      | 1            |
| IntToLongFunction                 | long        | applyAsLong(int)        | 1            |
| LongToDoubleFunction              | double      | applyAsDouble(long)     | 1            |
| LongToIntFunction                 | int         | applyAsInt(long)        | 1            |

- Exemple

```java
IntSupplier dice = () -> (int)(Math.random() * 6) + 1;

IntPredicate even = x -> x % 2 == 0;

IntUnaryOperator doubleIt = x -> x * 2;
```

### 20.1.5 Résumé

- Les interfaces fonctionnelles contiennent exactement une méthode abstraite (SAM).
- Elles sont le support des Lambdas et des Method References.
- Java propose de nombreuses FI intégrées dans `java.util.function`.
- Les variantes primitives améliorent les performances en supprimant le boxing.

---

## 20.2 Expressions Lambda

Une expression lambda est une manière compacte d’écrire une fonction.

Les expressions lambda offrent une façon concise de définir des implémentations d’interfaces fonctionnelles.

Une lambda est essentiellement un petit bloc de code qui prend des paramètres et renvoie une valeur, sans nécessiter une déclaration complète de méthode.

Elles représentent le comportement comme une donnée et constituent un élément clé du modèle de programmation fonctionnelle en Java.

### 20.2.1 Syntaxe des Expressions Lambda

La syntaxe générale est :

`(parameters) -> expression`  
ou  
`(parameters) -> { statements }`

### 20.2.2 Exemples de Syntaxe Lambda

**Zéro paramètre**
```java
Runnable r = () -> System.out.println("Hello");
```

**Un paramètre (parenthèses optionnelles)**
```java
Consumer<String> c = s -> System.out.println(s);
```

**Plusieurs paramètres**
```java
BinaryOperator<Integer> add = (a, b) -> a + b;
```

**Avec un corps en bloc**
```java
Function<Integer, String> f = (x) -> {
    int doubled = x * 2;
    return "Value: " + doubled;
};
```

### 20.2.3 Règles pour les Expressions Lambda

- Les types des paramètres peuvent être omis (inférence de type).
- Si un paramètre a un type, alors **tous** les paramètres doivent spécifier un type.
- Un seul paramètre ne nécessite pas de parenthèses.
- Plusieurs paramètres nécessitent des parenthèses.
- Si le corps est une seule expression (sans `{ }`), `return` est interdit ; l’expression elle-même est la valeur de retour.
- Si le corps utilise `{ }` (un bloc), `return` doit apparaître si une valeur est renvoyée.
- Les expressions lambda ne peuvent être assignées qu’à des interfaces fonctionnelles (types SAM).

### 20.2.4 Inférence de Type

Le compilateur déduit le type de la lambda à partir du contexte de l’interface fonctionnelle cible.

```java
Predicate<String> p = s -> s.isEmpty();  // s déduit comme String
```

Si le compilateur ne peut pas déduire le type, il faut le préciser explicitement.

```java
BiFunction<Integer, Integer, Integer> f = (Integer a, Integer b) -> a * b;
```

### 20.2.5 Restrictions dans les Corps des Lambda

**Les lambdas ne peuvent capturer que des variables locales `final` ou effectively final (non réassignées).**

```java
int x = 10;
Runnable r = () -> {
    // x++;   // ❌ erreur de compilation — x doit être effectively final
    System.out.println(x);
};
```

**Elles peuvent en revanche modifier l’état d’un objet (seules les références doivent être effectively final).**

```java
var list = new ArrayList<>();
Runnable r2 = () -> list.add("OK");  // autorisé
```

### 20.2.6 Règles de Type de Retour

Si le corps est une expression : l’expression est la valeur de retour.

```java
Function<Integer, Integer> f = x -> x * 2;
```

Si le corps est un bloc : il faut inclure `return`.

```java
Function<Integer, Integer> g = x -> {
    return x * 2;
};
```

### 20.2.7 Lambdas vs Classes Anonymes

- Les lambdas ne créent PAS une nouvelle portée : elles partagent la portée englobante.
- `this` dans une lambda fait référence à l’objet englobant, pas à la lambda.

```java
class Test {
    void run() {
        Runnable r = () -> System.out.println(this.toString());
    }
}
```

Dans une classe anonyme, `this` fait référence à l’instance de la classe anonyme.

### 20.2.8 Erreurs Courantes (Pièges de Certification)

**Types de retour incohérents**
```java
x -> { if (x > 0) return 1; }  // ❌ manque un return pour le cas négatif
```

**Mélanger paramètres typés et non typés**
```java
(a, int b) -> a + b   // ❌ illégal
```

**Renvoyer une valeur pour une lambda ciblant void**
```java
Runnable r = () -> 5;  // ❌ Runnable.run() retourne void
```

**Résolution d’overload ambiguë**

```java
void m(IntFunction<Integer> f) {}
void m(Function<Integer, Integer> f) {}

m(x -> x + 1);  // ❌ ambigu
```

---

## 20.3 Références de Méthodes

Les références de méthodes (method references) fournissent une syntaxe abrégée pour utiliser une méthode existante comme implémentation d’une interface fonctionnelle.

Elles sont équivalentes aux expressions lambda, mais plus concises, plus lisibles, et souvent préférées lorsque la méthode cible existe déjà.

Il existe quatre catégories de références de méthodes en Java :

- 1. Référence à une méthode statique (`ClassName::staticMethod`)
- 2. Référence à une méthode d’instance d’un objet particulier (`instance::method`)
- 3. Référence à une méthode d’instance d’un objet arbitraire d’un type donné (`ClassName::instanceMethod`)
- 4. Référence à un constructeur (`ClassName::new`)

### 20.3.1 Référence à une Méthode Statique

Une référence à méthode statique remplace une lambda qui appelle une méthode statique.

```java
class Utils {
    static int square(int x) { return x * x; }
}

Function<Integer, Integer> f1 = x -> Utils.square(x);
Function<Integer, Integer> f2 = Utils::square;  // method reference
```

`f1` et `f2` se comportent de manière identique.

### 20.3.2 Référence à une Méthode d’Instance d’un Objet Particulier

Utilisée lorsque vous avez déjà une instance d’objet et que vous voulez référencer l’une de ses méthodes.

```java
String prefix = "Hello, ";

UnaryOperator<String> op1 = s -> prefix.concat(s);
UnaryOperator<String> op2 = prefix::concat;   // method reference

System.out.println(op2.apply("World"));
```

La référence `prefix::concat` lie `concat` à **cet objet spécifique**.

### 20.3.3 Référence à une Méthode d’Instance d’un Objet Arbitraire d’un Type Donné

C’est la forme la plus “piégeuse”.

Le premier paramètre de l’interface fonctionnelle devient le receiver de la méthode (`this`).

```java
BiPredicate<String, String> p1 = (s1, s2) -> s1.equals(s2);
BiPredicate<String, String> p2 = String::equals;   // method reference

System.out.println(p2.test("abc", "abc"));  // true
```

> [!NOTE]
> Cette forme applique la méthode au *premier argument* de la lambda.

### 20.3.4 Référence à un Constructeur

Les références de constructeurs remplacent des lambdas qui appellent `new`.

```java
Supplier<ArrayList<String>> sup1 = () -> new ArrayList<>();
Supplier<ArrayList<String>> sup2 = ArrayList::new; // method reference

Function<Integer, ArrayList<String>> sup3 = ArrayList::new;
// appelle le constructeur ArrayList(int capacity)
```

### 20.3.5 Tableau Récapitulatif des Types de Method Reference

Le tableau ci-dessous résume toutes les catégories de références de méthodes.

| Type                                | Syntax Example          | Equivalent Lambda |
|------------------------------------|-------------------------|-------------------|
| Static method                       | Class::staticMethod     | x -> Class.staticMethod(x) |
| Instance method of specific object  | instance::method        | x -> instance.method(x) |
| Instance method of arbitrary object | Class::method           | (obj, x) -> obj.method(x) |
| Constructor                         | Class::new              | () -> new Class() |

### 20.3.6 Pièges Fréquents

- Une référence de méthode doit correspondre *exactement* à la signature de l’interface fonctionnelle.
- Les overloads peuvent rendre une référence de méthode ambiguë.
- La référence à méthode d’instance (`Class::method`) décale le receiver sur le paramètre 1.
- Une référence de constructeur échoue s’il n’existe pas de constructeur compatible.

```java
// ❌ Ambigu : quel println()? (println(int), println(String)...)
Consumer<String> c = System.out::println; // OK uniquement parce que le paramètre FI est String

// ❌ Constructeur non compatible : mauvaise interface fonctionnelle
Supplier<Integer> s = Integer::new;          // ✔ OK : appelle Integer()
Function<String, Long> f = Integer::new;     // ❌ ERREUR : le constructeur retourne Integer, pas Long
```

En cas de doute, réécrivez la method reference en lambda : si la lambda fonctionne mais pas la method reference, le problème est généralement un mismatch de signature.
