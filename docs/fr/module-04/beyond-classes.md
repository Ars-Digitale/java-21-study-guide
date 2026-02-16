# 17. Au-delà des Classes

### Table des matières

- [17. Au-delà des Classes](#17-au-delà-des-classes)
  - [17.1 Interfaces](#171-interfaces)
    - [17.1.1 Ce que les Interfaces Peuvent Contenir](#1711-ce-que-les-interfaces-peuvent-contenir)
    - [17.1.2 Implémenter une Interface](#1712-implémenter-une-interface)
    - [17.1.3 Héritage Multiple](#1713-héritage-multiple)
    - [17.1.4 Héritage des Interfaces et Conflits](#1714-héritage-des-interfaces-et-conflits)
    - [17.1.5 Méthodes default](#1715-méthodes-default)
    - [17.1.6 Méthodes static](#1716-méthodes-static)
    - [17.1.7 Méthodes private dans les interfaces](#1717-méthodes-private-dans-les-interfaces)
  - [17.2 Types sealed, non-sealed et final](#172-types-sealed-non-sealed-et-final)
    - [17.2.1 Règles](#1721-règles)
  - [17.3 Enum](#173-enum)
    - [17.3.1 Définition d’une Enum Simple](#1731-définition-dune-enum-simple)
    - [17.3.2 Enum Complexes avec État et Comportement](#1732-enum-complexes-avec-état-et-comportement)
    - [17.3.3 Méthodes des Enum](#1733-méthodes-des-enum)
    - [17.3.4 Règles](#1734-règles)
  - [17.4 Records (Java 16+)](#174-records-java-16)
    - [17.4.1 Résumé des Règles de Base pour les Records](#1741-résumé-des-règles-de-base-pour-les-records)
    - [17.4.2 Constructeur Long](#1742-constructeur-long)
    - [17.4.3 Constructeur Compact](#1743-constructeur-compact)
    - [17.4.4 Pattern Matching pour les Records](#1744-pattern-matching-pour-les-records)
    - [17.4.5 Nested Record Patterns et Matching des Records avec var et Generics](#1745-nested-record-patterns-et-matching-des-records-avec-var-et-generics)
      - [17.4.5.1 Nested Record Pattern de Base](#17451-nested-record-pattern-de-base)
      - [17.4.5.2 Nested Record Patterns avec var](#17452-nested-record-patterns-avec-var)
      - [17.4.5.3 Nested Record Patterns et Generics](#17453-nested-record-patterns-et-generics)
      - [17.4.5.4 Erreurs Courantes avec les Nested Record Patterns](#17454-erreurs-courantes-avec-les-nested-record-patterns)
  - [17.5 Classes Imbriquées en Java](#175-classes-imbriquées-en-java)
    - [17.5.1 Static Nested Classes](#1751-static-nested-classes)
      - [17.5.1.1 Syntaxe et Règles d’Accès](#17511-syntaxe-et-règles-daccès)
      - [17.5.1.2 Erreurs Courantes](#17512-erreurs-courantes)
    - [17.5.2 Inner Classes (Non-Static Nested Classes)](#1752-inner-classes-non-static-nested-classes)
      - [17.5.2.1 Syntaxe et Règles d’Accès](#17521-syntaxe-et-règles-daccès)
      - [17.5.2.2 Erreurs Courantes](#17522-erreurs-courantes)
    - [17.5.3 Classes Locales](#1753-classes-locales)
      - [17.5.3.1 Caractéristiques](#17531-caractéristiques)
      - [17.5.3.2 Erreurs Courantes](#17532-erreurs-courantes)
    - [17.5.4 Classes Anonymes](#1754-classes-anonymes)
      - [17.5.4.1 Syntaxe et Utilisation](#17541-syntaxe-et-utilisation)
      - [17.5.4.2 Classe Anonyme qui Étend une Classe](#17542-classe-anonyme-qui-étend-une-classe)
    - [17.5.5 Comparaison des Types de Classes Imbriquées](#1755-comparaison-des-types-de-classes-imbriquées)
  - [17.6 Imbrication des Interfaces en Java](#176-imbrication-des-interfaces-en-java)
    - [17.6.1 Où une Interface peut être Déclarée](#1761-où-une-interface-peut-être-déclarée)
    - [17.6.2 Interfaces Imbriquées](#1762-interfaces-imbriquées)
      - [17.6.2.1 Interface Imbriquée dans une Classe](#17621-interface-imbriquée-dans-une-classe)
      - [17.6.2.2 Interface Imbriquée dans une autre Interface](#17622-interface-imbriquée-dans-une-autre-interface)
    - [17.6.3 Règles d'Accès](#1763-règles-daccès)
    - [17.6.4 Types Imbriqués dans les Interfaces](#1764-types-imbriqués-dans-les-interfaces)
    - [17.6.5 Résumé Essentiel](#1765-résumé-essentiel)

---

Ce chapitre présente plusieurs mécanismes avancés de type (*type*) au-delà du design de la Classe en Java : **interfaces**, **enum**, **classes sealed / non-sealed**, **records** et **classes imbriquées**.

## 17.1 Interfaces

Une **interface** en Java est un type de référence qui définit un contrat de méthodes qu’une classe accepte d’implémenter.

Une `interface` est implicitement `abstract` et ne peut pas être marquée `final` : comme pour les classes top-level, une interface peut déclarer une visibilité `public` ou `default` (package-private).

Une classe Java peut implémenter un nombre quelconque d’interfaces via le mot-clé `implements`.

Une `interface` peut à son tour étendre plusieurs interfaces en utilisant le mot-clé `extends`.

Les interfaces permettent l’abstraction, un couplage faible et l’héritage multiple de type.

### 17.1.1 Ce que les Interfaces Peuvent Contenir

- **Méthodes abstraites** (implicitement `public` et `abstract`)
- **Méthodes concrètes**
	- **Méthodes default** (contiennent du code et sont implicitement `public`)
	- **Méthodes static** (déclarées `static`, contiennent du code et sont implicitement `public`)
	- **Méthodes private** (Java 9+) pour la réutilisation interne
- **Constantes** → implicitement `public static final` et initialisées à la déclaration

```java
interface Calculator {

    int add(int a, int b);                 // abstract
	
    default int mult(int a, int b) {       // default method
        return a * b;
    }
	
    static double pi() { return 3.14; }    // static method
}
```

!!! warning
    Puisque les méthodes abstraites des interfaces sont implicitement `public`, **vous ne pouvez pas** réduire le niveau d’accès sur une méthode d’implémentation.

### 17.1.2 Implémenter une Interface

```java
class BasicCalc implements Calculator {
    public int add(int a, int b) { return a + b; }
}
```

!!! note
    **Chaque** méthode abstraite doit être implémentée, sauf si la classe est elle-même abstraite.

### 17.1.3 Héritage Multiple

Une classe peut implémenter plusieurs interfaces.

```java
interface A { void a(); }
interface B { void b(); }

class C implements A, B {
    public void a() {}
    public void b() {}
}
```

### 17.1.4 Héritage des Interfaces et Conflits

Si deux interfaces fournissent des méthodes `default` avec la même signature, la classe qui implémente doit redéfinir (override) la méthode.

```java
interface X { default void run() { } }
interface Y { default void run() { } }

class Z implements X, Y {
    public void run() { } // mandatory
}
```

Si vous voulez tout de même accéder à une implémentation particulière de la méthode `default` héritée, vous pouvez utiliser la syntaxe suivante :

```java
interface X { default int run() { return 1; } }
interface Y { default int run() { return 2; } }

class Z implements X, Y {

    public int useARun(){
		return Y.super.run();
	}
	
}
```

### 17.1.5 Méthodes `default`

Une méthode `default` (déclarée avec le mot-clé `default`) est une méthode qui définit une implémentation et peut être redéfinie par une classe qui implémente l’interface.

- Une méthode default contient du code et est implicitement `public` ;
- Une méthode default ne peut pas être `abstract`, `static` ou `final` ;
- Comme vu juste au-dessus, si deux interfaces fournissent des méthodes default avec la même signature, la classe qui implémente doit redéfinir la méthode ;
- Une classe qui implémente peut naturellement s’appuyer sur l’implémentation fournie de la méthode `default` sans la redéfinir ;
- La méthode `default` peut être invoquée sur une instance de la classe qui implémente et NON comme méthode `static` de l’interface contenante ;

### 17.1.6 Méthodes `static`

- Une interface peut fournir des `static methods` (via le mot-clé `static`) qui sont implicitement `public` ;
- Les méthodes static doivent inclure un corps de méthode et sont accessibles via le nom de l’interface ;
- Les méthodes static ne peuvent pas être `abstract` ou `final` ;

### 17.1.7 Méthodes `private` dans les interfaces

Parmi toutes les méthodes concrètes qu’une interface peut implémenter, nous avons aussi :

- **Méthodes `private`** : visibles uniquement à l’intérieur de l’interface déclarante et qui ne peuvent être invoquées que depuis un contexte `non-static` (méthodes `default` ou autres `non-static private methods`).
- **Méthodes `private static`** : visibles uniquement à l’intérieur de l’interface déclarante et qui peuvent être invoquées par n’importe quelle méthode de l’interface englobante.

---

## 17.2 Types sealed, non-sealed et final

Les classes et interfaces `sealed` (Java 17+) restreignent quelles autres classes (ou interfaces) peuvent les étendre ou les implémenter.

Un `sealed type` est déclaré en plaçant le modificateur `sealed` juste avant le mot-clé class (ou interface), et en ajoutant, après le nom du Type, le mot-clé `permits` suivi de la liste des types qui peuvent l’étendre (ou l’implémenter).

```java
public sealed class Shape permits Circle, Rectangle { }

final class Circle extends Shape { }

non-sealed class Rectangle extends Shape { }
```

### 17.2.1 Règles

- Un type sealed doit déclarer tous les sous-types autorisés.
- Un sous-type autorisé doit être **final**, **sealed** ou **non-sealed** ; puisque les interfaces ne peuvent pas être final, elles ne peuvent être marquées que `sealed` ou `non-sealed` lorsqu’elles étendent une interface sealed.
- Les types sealed doivent être déclarés dans le même package (ou module nommé) que leurs sous-types directs.

---

## 17.3 Enum

Les **enum** définissent un ensemble fixe de valeurs constantes.

Les `enum` peuvent déclarer des `attributs`, des `constructeurs` et des `méthodes` comme des classes ordinaires mais **ne peuvent pas être étendues**.

La liste des valeurs de l’enum doit se terminer par un point-virgule `(;)` dans le cas des `Enum Complexes`, mais ce n’est pas obligatoire pour les `Enum Simples`.

### 17.3.1 Définition d’une Enum `Simple`

```java
enum Day { MON, TUE, WED, THU, FRI, SAT, SUN } // point-virgule omis
```

### 17.3.2 Enum `Complexes` avec État et Comportement

```java
enum Level {
    LOW(1), MEDIUM(5), HIGH(10); // point-virgule obligatoire
	
    private int code; 
	
    Level(int code) { this.code = code; }
	
    public int getCode() { return code; }
}

public static void main(String[] args) {
	Level.MEDIUM.getCode();		// invoking a method
}
```

### 17.3.3 Méthodes des Enum

- `values()` – renvoie un tableau de toutes les valeurs constantes utilisables, par exemple, dans une boucle `for-each`
- `valueOf(String)` – renvoie la constante par son nom
- `ordinal()` – index (int) de la constante

### 17.3.4 Règles

- Les constructeurs d’enum sont implicitement `private` ;
- Les enum peuvent contenir des méthodes `static` et `instance` ;
- Les enum peuvent implémenter des `interfaces` ;

---

## 17.4 Records (Java 16+)

Un **record** est une classe spéciale conçue pour modéliser des données immuables : ils sont en effet implicitement **final**.

Vous ne pouvez pas étendre un record, mais il est permis d’implémenter une interface normale ou sealed.

Il fournit automatiquement :

- **champs private final** pour chaque composant
- **constructeur** avec des paramètres dans le même ordre que la déclaration du record ;
- **getters** (portant le nom des attributs)
- **`equals()`, `hashCode()`, `toString()`** : il est également permis de redéfinir (override) ces méthodes
- Les **Records** peuvent inclure `nested classes`, `interfaces`, `records`, `enums` et `annotations`

```java
public record Point(int x, int y) { }

var element = new Point(11, 22);

System.out.println(element.x);
System.out.println(element.y);
```

Si vous avez besoin de validation ou de transformation supplémentaire des champs fournis, vous pouvez définir un `constructeur long` ou un `constructeur compact`.


### 17.4.1 Résumé des Règles de Base pour les Records

Un record peut être déclaré à trois emplacements :

- Comme **record top-level** (directement dans un package)
- Comme **record member** (à l’intérieur d’une classe ou d’une interface)
- Comme **record local** (à l’intérieur d’une méthode)

Toutes les classes record `member` et `local` sont implicitement `static`.

- Un record member peut déclarer `static` de manière redondante.
- Un record local ne doit pas déclarer `static` explicitement.

Chaque classe record est implicitement `final`.

- Déclarer `final` explicitement est autorisé mais redondant.
- Un record ne peut pas être déclaré `abstract`, `sealed` ou `non-sealed`.

La superclasse directe de chaque record est `java.lang.Record`.

- Un record ne peut pas déclarer de clause `extends`.
- Un record ne peut étendre aucune autre classe.

La sérialisation des records diffère de celle des classes sérialisables ordinaires.

- Lors de la désérialisation, le constructeur canonique est invoqué.

Le corps d’un record peut contenir :

- Des constructeurs
- Des méthodes
- Des champs statiques
- Des blocs d’initialisation statiques

Le corps d’un record NE doit PAS contenir :

- Des déclarations de champs d’instance
- Des blocs d’initialisation d’instance
- Des méthodes `abstract`
- Des méthodes `native`


### 17.4.2 Constructeur Long

```java
public record Person(String name, int age) {

    public Person (String name, int age){
        if (age < 0) throw new IllegalArgumentException();
		this.name = name;
		this.age = age;
    }
}
```

Vous pouvez aussi définir des constructeurs en surcharge (overload), à condition qu’ils délèguent finalement au constructeur canonique via `this(...)` :

```java
public record Point(int x, int y) {

    // Overloaded constructor (NOT canonical)
    public Point(int value) {
        this(value, value); // doit invoquer, comme première instruction, un autre constructeur surchargé et, en dernière instance, le constructeur canonique.
    }
}
```

!!! note
    - Le compilateur n’insérera pas de constructeur si vous en fournissez manuellement un avec la même liste de paramètres dans l’ordre défini ;
    - Dans ce cas, vous devez définir explicitement chaque champ manuellement ;

### 17.4.3 Constructeur Compact

Vous pouvez définir un `constructeur compact` qui initialise implicitement tous les champs, tout en vous permettant d’effectuer des validations et des transformations sur des champs spécifiques.

Java exécutera le constructeur complet, initialisant tous les champs, après que le constructeur compact a terminé.

```java
public record Person(String name, int age) {

    public Person {
        if (age < 0) throw new IllegalArgumentException();
		
		name = name.toUpperCase(); // This transformation is still (at this level of initialization) on the input parameter.
		
		// this.name = name; // ❌ Does not compile.
    }	
}
```

!!! warning
    - Si vous essayez de modifier un attribut de Record dans un Constructeur Compact, votre code ne compilera pas

### 17.4.4 Pattern Matching pour les Records

Quand vous utilisez le pattern matching avec `instanceof` ou avec `switch`, un record pattern doit spécifier :

- Le type du record ;
- Un pattern pour chaque champ du record (correspondant au bon nombre de composants, et avec des types compatibles) ;

Exemple record :

```java
Object obj = new Point(3, 5);

if (obj instanceof Point(int a, int b)) {
    System.out.println(a + b);   // 8
}
```

### 17.4.5 Nested Record Patterns et Matching des Records avec `var` et Generics

Les nested record patterns permettent de déstructurer des records qui contiennent d’autres records ou des types complexes, en extrayant récursivement des valeurs directement dans le pattern.

Ils combinent la puissance de la déconstruction des `record` avec le pattern matching, vous donnant une manière concise et expressive de naviguer dans des structures de données hiérarchiques.

#### 17.4.5.1 Nested Record Pattern de Base

Si un record contient un autre record, vous pouvez déstructurer les deux en une seule fois :

```java
record Address(String city, String country) {}
record Person(String name, Address address) {}

void printInfo(Object obj) {

	switch (obj) {
		case Person(String n, Address(String c, String co)) -> System.out.println(n + " lives in " + c + ", " + co);
		default -> System.out.println("Unknown");
	}
}
```

Dans l’exemple ci-dessus, le pattern `Person` inclut un pattern `Address` imbriqué.

Les deux sont appariés structurellement.

#### 17.4.5.2 Nested Record Patterns avec `var`

Au lieu de spécifier des types exacts pour chaque champ, vous pouvez utiliser `var` dans le pattern pour laisser le compilateur inférer le type.

```java
	switch (obj) {
		case Person(var name, Address(var city, var country)) -> System.out.println(name + " — " + city + ", " + country);
	}
```

`var` dans les patterns fonctionne comme `var` dans les variables locales : cela signifie "inférer le type".

!!! warning
    - Vous avez toujours besoin du type du record englobant (Person, Address) ;
    - seuls les types des champs peuvent être remplacés par `var`.

#### 17.4.5.3 Nested Record Patterns et Generics

Les record patterns fonctionnent aussi avec des records génériques.

```java
record Box<T>(T value) {}
record Wrapper(Box<String> box) {}

static void test(Object o) {
	switch (o) {
		case Wrapper(Box<String>(var v)) -> System.out.println("Boxed string: " + v);
		default -> System.out.println("Something else");
	}
}
```

Dans cet exemple :

- Le pattern exige exactement `Box<String>`, pas `Box<Integer>`.
- Dans le pattern, `var v` capture la valeur générique unboxed.

#### 17.4.5.4 Erreurs Courantes avec les Nested Record Patterns

Structure de record non correspondante

```java
// ❌ ERROR: pattern does not match record structure
case Person(var n, var city) -> ...
```

`Person` a 2 champs, mais l’un d’eux est un record. Vous devez déstructurer correctement.

Nombre incorrect de composants

```java
// ❌ ERROR: Address has 2 components, not 1
case Person(var n, Address(var onlyCity)) -> ...
```

Incompatibilité générique

```java
// ❌ ERROR: expecting Box<String> but found Box<Integer>
case Wrapper(Box<Integer>(var v)) -> ...
```

Placement illégal de `var`

```java
// ❌ var cannot replace the record type itself
case var(Person(var n, var a)) -> ...
```

!!! note
    - `var` ne peut pas remplacer l’ensemble du pattern, seulement les composants individuels.

---

## 17.5 Classes Imbriquées en Java

Java supporte plusieurs types de **classes imbriquées** — des classes déclarées à l’intérieur d’une autre classe.

Ce sont des outils fondamentaux pour l’encapsulation, l’organisation du code, les patterns d’event-handling et la représentation de hiérarchies logiques.

Une classe imbriquée appartient toujours à une **classe englobante** et a des règles particulières d’accessibilité et d’instanciation selon sa catégorie.

Java définit quatre types de classes imbriquées :

- **Static Nested Classes** – déclarées avec `static` à l’intérieur d’une autre classe.
- **Inner Classes** (non-static **nested** classes).
- **Local Classes** – déclarées dans un bloc (méthode, constructeur ou initializer).
- **Anonymous Classes** – classes sans nom créées inline, généralement pour redéfinir une méthode ou implémenter une interface.


!!! warning
	- `static` s’applique uniquement aux classes **membres imbriquées**
	- Les classes `Top-level` → ne peuvent pas être static
	- Les classes `Local` (déclarées dans les méthodes) → ne peuvent pas être static
	- Les classes `Anonymous` → ne peuvent pas être static
	- Une classe `static nested` ne peut pas accéder aux membres d’instance sans une référence explicite à un objet externe.
	

### 17.5.1 Static Nested Classes

Une **static nested class** se comporte comme une classe top-level dont le namespace est à l’intérieur de sa classe englobante.  
Elle ne **peut pas** accéder aux membres d’instance de la classe externe mais **peut** accéder aux membres statiques.  
Elle ne conserve pas de référence vers une instance de la classe englobante.
Une classe imbriquée `static` peut contenir des variables membres non statiques.

#### 17.5.1.1 Syntaxe et Règles d’Accès

- Déclarée via `static class` à l’intérieur d’une autre classe.
- Peut accéder uniquement aux membres **static** de la classe externe.
- N’a pas de référence implicite vers l’instance englobante.
- Peut être instanciée sans instance externe.

```java
class Outer {
    static int version = 1;

    static class Nested {
        void print() {
            System.out.println("Version: " + version); // OK: accessing static member
        }
    }
}

class Test {
    public static void main(String[] args) {
        Outer.Nested n = new Outer.Nested(); // No Outer instance required
        n.print();
    }
}
```

#### 17.5.1.2 Erreurs Courantes

- Les static nested classes **ne peuvent pas accéder aux variables d’instance** :

```java
class Outer {
    int x = 10;
    static class Nested {
        void test() {
            // System.out.println(x); // ❌ Compile error
        }
    }
}
```

### 17.5.2 Inner Classes (Non-Static Nested Classes)

Une **inner class** est associée à une instance de la classe externe et peut accéder à **tous les membres** de la classe externe, y compris ceux **private**.

#### 17.5.2.1 Syntaxe et Règles d’Accès

- Déclarée sans `static`.
- Possède une référence implicite vers l’instance englobante.
- Peut accéder aux membres statiques et aux membres d’instance de la classe externe.
- Comme elle n’est pas statique, elle doit être créée via une instance de la classe englobante.

```java
class Outer {
    private int value = 100;

    class Inner {
        void print() {
            System.out.println("Value = " + value); // OK: accessing private
        }
    }

    void make() {
        Inner i = new Inner(); // OK inside the outer class
        i.print();
    }
}

class Test {
    public static void main(String[] args) {
        Outer o = new Outer();
        Outer.Inner i = o.new Inner(); // MUST be created from an instance
        i.print();
    }
}
```

#### 17.5.2.2 Erreurs Courantes

- Les inner classes **ne peuvent pas déclarer de membres statiques** sauf les **static final constants**.

```java
class Outer {
    class Inner {
        // static int x = 10;     // ❌ Compile error
        static final int OK = 10; // ✔ Allowed (constant)
    }
}
```

!!! warning
    - Instancier une inner class SANS instance externe est illégal.

### 17.5.3 Classes Locales

Une **classe locale** est une classe imbriquée définie à l’intérieur d’un bloc — le plus souvent une méthode.

Elle n’a pas de modificateur d’accès et n’est visible qu’à l’intérieur du bloc où elle est déclarée.

#### 17.5.3.1 Caractéristiques

- Déclarée à l’intérieur d’une méthode, d’un constructeur ou d’un initializer.
- Peut accéder aux membres de la classe externe.
- Peut accéder aux variables locales si elles sont **effectively final**.
- Ne peut pas déclarer de membres statiques (sauf static final constants).

```java
class Outer {
    void compute() {
        int base = 5; // must be effectively final

        class Local {
            void show() {
                System.out.println(base); // OK
            }
        }

        new Local().show();
    }
}
```

#### 17.5.3.2 Erreurs Courantes

- `base` doit être effectively final ; le modifier casse la compilation.

```java
void compute() {
    int base = 5;
    base++; // ❌ Now base is NOT effectively final
    class Local {}
}
```

### 17.5.4 Classes Anonymes

Une **classe anonyme** est une classe one-off créée inline, généralement pour implémenter une interface ou redéfinir une méthode sans nommer une nouvelle classe.

#### 17.5.4.1 Syntaxe et Utilisation

- Créée via `new` + type + body.
- Ne peut pas avoir de constructeurs (pas de nom).
- Souvent utilisée pour event handling, callbacks, comparators.

```java
Runnable r = new Runnable() {
    @Override
    public void run() {
        System.out.println("Anonymous running");
    }
};
```

#### 17.5.4.2 Classe Anonyme qui Étend une Classe

```java
Button b = new Button("Click");
b.onClick(new ClickHandler() {
    @Override
    public void handle() {
        System.out.println("Handled!");
    }
});
```

### 17.5.5 Comparaison des Types de Classes Imbriquées

Un tableau rapide qui résume tous les types de classes imbriquées.

| Type | A une Instance Externe ? | Peut Accéder aux Membres d’Instance Externe ? | Peut Avoir des Membres Statiques ? | Usage Typique |
|------------------- | ------------------- | ---------------------------------- | ------------------------- | --------------------------- |
| Static Nested | Non | Non | Oui | Namespacing, helpers |
| Inner Class | Oui | Oui | Non (sauf constantes) | Comportement lié à l’objet |
| Local Class | Oui | Oui | Non | Classes temporaires avec scope |
| Anonymous Class | Oui | Oui | Non | Personnalisation inline |


---

## 17.6 Imbrication des Interfaces en Java

En Java, une interface peut être déclarée à différents emplacements et suit des règles spécifiques concernant l’imbrication et les membres autorisés.

### 17.6.1 Où une Interface peut être Déclarée

Une interface peut être :

- **Top-level** (directement dans un package)
- **Interface membre imbriquée** (déclarée à l’intérieur d’une classe ou d’une autre interface)
- **Interface locale** ❌ (non autorisée)
- **Interface anonyme** ❌ (n’existe pas comme déclaration, seulement des implémentations anonymes)

En Java, il n’est **pas permis de déclarer une interface locale** (c’est-à-dire à l’intérieur d’une méthode ou d’un bloc).  
Les interfaces peuvent être uniquement `top-level` ou `member`.


### 17.6.2 Interfaces Imbriquées

Une interface imbriquée peut être déclarée dans :

#### 17.6.2.1 Interface Imbriquée dans une Classe

- Elle est implicitement `static`
- Elle ne peut pas être déclarée `non-static`
- Elle peut être déclarée `public`, `protected`, `private` ou `package-private`

- Exemple :

```java
class Outer {
    interface InnerInterface {
        void test();
    }
}
```

Le mot-clé `static` est implicite :

```java
class Outer {
    static interface InnerInterface {   // autorisé mais redondant
        void test();
    }
}
```

#### 17.6.2.2 Interface Imbriquée dans une autre Interface

- Elle est implicitement `public` et `static`
- Elle ne peut pas être `private` ou `protected`

```java
interface A {
    interface B {
        void test();
    }
}
```


### 17.6.3 Règles dAccès

Une `interface imbriquée` :

- N’a pas de référence implicite à une instance de la classe englobante
- Ne peut pas accéder directement aux membres d’instance de la classe englobante
- **Peut accéder uniquement aux membres `static` de la classe englobante**


### 17.6.4 Types Imbriqués dans les Interfaces

Une interface peut contenir :

- Des classes imbriquées (implicitement `public static`)
- Des records imbriqués (implicitement `public static`)
- Des enums imbriqués (implicitement `public static`)
- D’autres interfaces imbriquées (implicitement `public static`)


### 17.6.5 Résumé Essentiel

- Les interfaces imbriquées sont toujours `static`
- Les interfaces locales n’existent pas
- Les champs sont toujours `public static final`
- Les méthodes sont implicitement `public abstract` (sauf default/static/private)
- Elles peuvent contenir d’autres types imbriqués