# 16. Héritage en Java

### Indice

- [16. Héritage en Java](#16-héritage-en-java)
	- [16.1 Définition Générale de l’Héritage](#161-définition-générale-de-lhéritage)
	- [16.2 Héritage Simple et java.lang.Object](#162-héritage-simple-et-javalangobject)
	- [16.3 Héritage Transitif](#163-héritage-transitif)
	- [16.4 Ce Qui Est Hérité, Bref Rappel](#164-ce-qui-est-hérité-bref-promemoria)
	- [16.5 Modificateurs de Classe qui Influencent l’Héritage](#165-modificateurs-de-classe-qui-influencent-lhéritage)
	- [16.6 Références this et super](#166-références-this-et-super)
		- [16.6.1 La Référence this](#1661-la-référence-this)
		- [16.6.2 La Référence super](#1662-la-référence-super)
	- [16.7 Déclarer des Constructeurs dans une chaîne héréditaire](#167-déclarer-des-constructeurs-dans-une-chaîne-héréditaire)
	- [16.8 Constructeur no-arg par Défaut](#168-constructeur-no-arg-par-défaut)
	- [16.9 Utiliser this et Constructor Overloading](#169-utiliser-this-et-constructor-overloading)
	- [16.10 Appeler le Constructeur du Parent en utilisant super](#1610-appeler-le-constructeur-du-parent-en-utilisant-super)
	- [16.11 Conseils et Pièges sur le Constructeur par Défaut](#1611-conseils-et-pièges-sur-le-constructeur-par-défaut)
	- [16.12 super se Réfère Toujours au Parent le plus direct](#1612-super-se-réfère-toujours-au-parent-le-plus-direct)
	- [16.13 Hériter des Membres](#1613-hériter-des-membres)
		- [16.13.1 Method Overriding](#16131-method-overriding)
			- [16.13.1.1 Définition et Rôle dans l’Héritage](#161311-définition-et-rôle-dans-lhéritage)
			- [16.13.1.2 Utiliser super pour appeler l’Implémentation du Parent](#161312-utiliser-super-pour-appeler-limplémentation-du-parent)
			- [16.13.1.3 Règles de Overriding Instance Methods](#161313-règles-de-overriding-instance-methods)
			- [16.13.1.4 Masquer Static Methods Method Hiding](#161314-masquer-static-methods-method-hiding)
		- [16.13.2 Abstract Classes](#16132-abstract-classes)
			- [16.13.2.1 Définition et But](#161321-définition-et-but)
			- [16.13.2.2 Règles pour les Abstract Classes](#161322-règles-pour-les-abstract-classes)
		- [16.13.3 Créer des Objets Immutables](#16133-créer-des-objets-immutables)
			- [16.13.3.1 Qu’est-ce qu’un Objet Immutable](#161331-quest-ce-quun-objet-immutable)
			- [16.13.3.2 Lignes Directrices pour Concevoir des Classes Immutable](#161332-lignes-directrices-pour-concevoir-des-classes-immutable)
			
---

L'`Inheritance` (Héritage) est l’un des piliers fondamentaux de l'Object-Oriented Programming.

Elle permet à une classe `fille` ( child ), la **subclass**, d’acquérir l’état et le comportement d’une autre classe `génitrice` ( parent ), la **superclass**, en créant des relations hiérarchiques qui promeuvent la réutilisation du code, la spécialisation et le polymorphisme.

## 16.1 Définition Générale de l’Héritage

L’héritage permet à une classe d’en étendre une autre, en obtenant automatiquement ses `attributs` et ses `méthodes` accessibles.

La classe qui étend peut ajouter de nouvelles fonctionnalités ou redéfinir (faire `override`) les comportements existants, en créant des versions plus spécialisées de sa propre classe parent.

> [!NOTE]
> L’Héritage exprime une relation *“is-a”* (est-un) : un Chien **is a** (est-un) Animal.

---

## 16.2 Héritage Simple et java.lang.Object

Java supporte la **single inheritance**, ce qui signifie que chaque classe peut étendre **une seule** superclasse directe.

Toutes les classes héritent en dernière analyse de `java.lang.Object`, qui se trouve au sommet de la hiérarchie.

Cela garantit que tous les objets Java partagent un comportement minimal commun (par exemple les méthodes `toString()`, `equals()`, `hashCode()`).

```java
class Animal { }
class Dog extends Animal { }

// All classes implicitly extend Object
System.out.println(new Dog() instanceof Object); // true
```

---

## 16.3 Héritage Transitif

L’`Inheritance` est **transitif**.

Si la classe `C` étend `B` et `B` étend `A`, alors `C` hérite effectivement des membres accessibles à la fois de `B` *et* de `A`.

```java
class A { }
class B extends A { }
class C extends B { } // C inherits from both A and B
```

---

## 16.4 Ce Qui Est Hérité, Bref Promemoria

Une subclass hérite de tous les membres **accessibles** de la classe génitrice.

Cependant, spécifiquement, cela dépend des `access modifiers`.

- **public** → toujours hérité
- **protected** → hérité si accessible via règles de package ou subclass
- **default (package-private)** → hérité seulement dans le même package
- **private** → **NON** hérité

> [!NOTE]
> ( Faire référence au Paragraphe "**Access Modifiers**" dans le Chapitre: [Briques de base du langage Java](../module-01/basic-building-blocks.md) )

---

## 16.5 Modificateurs de Classe qui influencent l’Héritage

Certains modificateurs au niveau de la classe déterminent si une classe peut être étendue.

| Modifier | Signification | Effet sur l’Héritage |
| --- | --- | --- |
| `final` | La classe ne peut pas être étendue | Inheritance STOP |
| `abstract` | La classe ne peut pas être instanciée | Doit être étendue |
| `sealed` | Permet seulement une liste fixe de subclass | Restreint l’inheritance |
| `non-sealed` | Subclass d’une sealed class qui rouvre l’inheritance | Inheritance permis |
| `static` | S’applique seulement aux nested classes | Se comporte comme une top-level class à l’intérieur de sa classe conteneur |

> [!NOTE]
> Une classe `static` en Java peut exister seulement comme **static nested class**.

---

## 16.6 Références `this` et `super`

### 16.6.1 La Référence `this`

La référence `this` se réfère à l’instance courante de l’objet et permet de lever l’ambiguïté d’accès aux membres courants et hérités.

Java utilise une règle de **granular scope**:
- Si une variable de méthode/locale a le même nom qu’un `instance field`, celle locale “masque” l'attribut d’instance.
- Il est nécessaire d’utiliser `this.fieldName` pour accéder donc à l’attribut d’instance.

```java
public class Person {
    String name;

    public Person(String name) {
        this.name = name;
    }
}
```

Si les noms diffèrent, `this` est optionnel.

```java
public class Person {
    String name;

	public Person(String n) {
		name = n;
	}
}
```

> [!WARNING]
> `this` NE peut PAS être utilisé à l’intérieur de méthodes statiques parce que, dans ce contexte, aucune instance n’existe.

### 16.6.2 La Référence `super`

La référence `super` donne accès aux membres de la classe génitrice (parent) directe.

Utile quand:
- Le parent (genitore) et le child (figlio) définissent un attribut/méthode avec le même nom; voir section: [Hériter des Membres](#1613-hériter-des-membres)
- Parent et child définissent un attribut avec le même nom → `variable hiding` (deux copies)
- Parent et child définissent une méthode avec la même signature → `method overriding`
- On veut appeler explicitement l’implémentation héritée

```java
class Parent { int value = 10; }

class Child extends Parent {
    int value = 20;

    void printBoth() {
        System.out.println(value);      // child value
        System.out.println(super.value); // parent value
    }
}
```

> [!NOTE]
> `super` NE peut PAS être utilisé dans des contextes statiques.

---

## 16.7 Déclarer des Constructeurs dans une chaîne héréditaire

Un `constructeur` initialise un objet nouvellement créé.

Les constructeurs ne sont **jamais hérités**, mais chaque constructeur de subclass doit s’assurer que la classe parent soit initialisée.

Les `constructeurs` sont des méthodes spéciales avec un nom qui correspond au nom de la classe et qui ne déclarent aucun return type.

Une classe peut définir plusieurs constructeurs (constructor overloading), chacun avec une `signature` unique.

On peut déclarer explicitement un `no-arg constructor` ou n’importe quel constructeur spécifique ou, si on ne le fait pas, Java créera implicitement un `default no-arg constructor`.

Si on déclare explicitement un constructeur, le compilateur Java n’inclura aucun `default no-arg constructor`: cette règle s’applique indépendamment à chaque classe dans la hiérarchie.

Une classe parent continue d’avoir son propre constructeur par défaut à moins qu’elle n’en définisse aussi un.

---

## 16.8 Constructeur `no-arg` par Défaut

Si une classe ne déclare aucun constructeur, Java insère automatiquement un **default no-argument constructor**.

Ce constructeur invoquera le constructeur `super()` du parent direct, implicitement: le compilateur Java insère implicitement un appel au no-arg constructor `super()`.

```java
class Parent { }

class Child extends Parent {
    // Compiler inserts:
    // Child() { super(); }
}
```

---

## 16.9 Utiliser `this()` et Constructor Overloading

**this()** invoque un autre constructeur dans la même classe.

Règles:
- Doit être la **première** instruction dans le constructeur
- Ne peut pas être combiné avec `super()`
- Une seule invocation à `this()` est autorisée dans un constructeur
- Utilisé pour centraliser l’initialisation

```java
class Car {
    int year;
    String model;

    Car() {
        this(2020, "Unknown");
    }

    Car(int year, String model) {
        this.year = year;
        this.model = model;
    }
}
```

---

## 16.10 Appeler le Constructeur du Parent en utilisant `super()`

Chaque constructeur doit appeler un constructeur de la superclasse, explicitement ou implicitement.

L’appel à `super()` doit apparaître comme **première** instruction dans le constructeur (à moins qu’il ne soit remplacé par `this()`).

```java
class Parent {
    Parent() { System.out.println("Parent constructor"); }
}

class Child extends Parent {
    Child() {
        super(); // optional, compiler would insert it
        System.out.println("Child constructor");
    }
}
```

---

## 16.11 Conseils et Pièges sur le Constructeur par Défaut

- **Si la classe parent n’a pas de no-arg constructor, la classe fille DOIT invoquer le spécifique `super(args)` explicitement.**
- Si la classe fille ne définit aucun constructeur, Java ne crée pas automatiquement un constructeur par défaut pour celle-ci.
- Si on oublie d’appeler explicitement un `parent constructor` existant, le compilateur insère `super()` — lequel pourrait ne pas exister.

```java
class Parent {
    Parent(int x) { }
}

class Child extends Parent {
    // ERROR → compiler inserts super(), but Parent() does not exist
    Child() { }
}
```

---

## 16.12 `super()` se Réfère Toujours au Parent le plus direct

Même dans de longues chaînes héréditaires, `super()` invoque toujours (et seulement) le constructeur de la classe génitrice **immédiate**.

```java
class A { 
	A() { System.out.println("A"); } 
}
class B extends A { 
	B() { System.out.println("B"); } 
}
class C extends B {
    C() {
        super(); // Calls B(), not A()
        System.out.println("C");
    }
}
```

Output:

```bash
A
B
C
```

---

## 16.13 Hériter des Membres

### 16.13.1 Method Overriding

Le `method overriding` est un concept fondamental de l’héritage: il permet à une classe fille de fournir une **nouvelle implémentation** pour une méthode déjà définie dans une de ses classes parent.

À runtime, la version de la méthode exécutée dépend du **type réel de l’objet**, pas du particulier `reference type`.

Ce comportement est appelé **dynamic dispatch** et c’est ce qui rend possible le polymorphisme en Java.

#### 16.13.1.1 Définition et Rôle dans l’Héritage

Une méthode dans une subclass fait **override** d’une méthode d’une de ses superclass si:
- la méthode de la superclass est `méthode d’instance` (non statique);
- la méthode de la subclass a le **même nom**, la **même liste de paramètres** et un **return type qui est du même type** ou d’un **sous-type** du return type dans la méthode héritée;
- les deux méthodes sont accessibles (non privées) et la méthode de la subclass n’est pas moins visible que celle de la superclass.
- La méthode en overriding **ne peut pas déclarer de nouvelles ou plus larges checked exceptions**.

L’Overriding est utilisé pour spécialiser le comportement: une subclass peut adapter ou affiner le comportement de la classe parent, tout en pouvant être utilisée via une référence du type parent.

```java
class Animal {
	void speak() {
		System.out.println("Some generic animal sound");
	}
}

class Dog extends Animal {

	@Override
	void speak() {
		System.out.println("Woof!");
	}
}

public class TestOverride {
	public static void main(String[] args) {
		Animal a = new Dog(); // reference type = Animal, object type = Dog
		a.speak(); // prints "Woof!" (Dog implementation)
	}
}
```

#### 16.13.1.2 Utiliser super pour appeler l’Implémentation du Parent

Quand une subclass fait override d’une méthode, elle peut quand même accéder à l’implémentation "originelle" de la superclass, via la référence `super`.

Cela est utile si on veut réutiliser ou étendre le comportement défini dans la classe parent.

```java
class Person {
	void introduce() {
		System.out.println("I am a person.");
	}
}

class Student extends Person {
	@Override
	void introduce() {
		super.introduce(); // calls Person.introduce()
		System.out.println("I am also a student.");
	}
}
```

Si la classe parent et la classe child déclarent toutes deux un membre (attribut ou méthode) avec le même nom, le child peut accéder aux deux:
- la version en overriding (default)
- la version du parent via `super`

```java
class Base {
	int value = 10;

	void show() {
		System.out.println("Base value = " + value);
	}
}

class Derived extends Base {
	int value = 20; // hides Base.value

	@Override
	void show() {
		System.out.println("Derived value = " + value);          // 20
		System.out.println("Base value via super = " + super.value); // 10
	}
}
```

#### 16.13.1.3 Règles de Overriding (Instance Methods)

- **Même signature (signature)**: même nom de méthode, mêmes types et ordre des paramètres.
- **return type covariant**: la méthode en overriding peut restituer (retourner) le même type du parent, ou un **subtype** du return type du parent.
- **Accessibilité**: la méthode en overriding ne peut pas être moins accessible que la méthode originelle (par exemple, on ne peut pas passer de `public` à `protected` ou `private`). Elle peut seulement maintenir la même visibilité ou l’augmenter.
- **Checked exceptions**: la méthode en overriding ne peut pas déclarer de nouvelles ou plus larges `checked exceptions` par rapport au `parent method`; elle peut en déclarer moins, déclarer des checked exceptions plus spécifiques ou, éventuellement, les enlever complètement.
- **Unchecked exceptions**: elles peuvent être ajoutées ou enlevées sans restrictions.
- **final methods**: elles ne peuvent pas participer à l'`override`.

```java
class Parent {
	Number getValue() throws Exception {
		return 42;
	}
}

class Child extends Parent {
@Override
	// Covariant return type: Integer is a subclass of Number
	Integer getValue() throws RuntimeException {
		return 100;
	}
}
```

#### 16.13.1.4 Masquer Static Methods (Method Hiding)

Les méthodes statiques ne participent pas à l'`overriding`; elles sont au contraire, éventuellement, masquées (**hidden**).

Si une subclass définit un static method avec la même signature d’un static method de la classe parent, la méthode statique de la subclass **masque** celle de la classe génitrice.

Si l’une des méthodes est marquée comme `static` et l’autre non, le code ne compilera pas.

La sélection de la méthode pour les méthodes statiques arrive à **compile time** et est basée sur le `reference type`: pas sur l’`object type`.

```java
class A {
	static void show() {
		System.out.println("A.show()");
	}
}

class B extends A {
	static void show() {
		System.out.println("B.show()");
	}
}

public class TestStatic {
	public static void main(String[] args) {
		A a = new B();
		B b = new B();

		a.show(); // A.show()  (reference type A)
		b.show(); // B.show()  (reference type B)
	}
}
```

> [!IMPORTANT]
> - méthodes statiques **final** ne peuvent pas être `hidden` (masquées); méthodes d’instance déclarées **final** ne peuvent pas être `overriden`.
> - Si on essaye de les redéfinir dans une subclass, le code ne compilera pas.

### 16.13.2 Abstract Classes

#### 16.13.2.1 Définition et But

Une **abstract class** est une classe qui ne peut pas être instanciée directement et est destinée à être étendue.

Elle peut contenir:
- méthodes abstract (déclarées sans body);
- méthodes concrètes (avec implémentation);
- attributs, constructeurs, membres statiques, et aussi static initializers.

Les abstract classes sont utilisées quand on veut définir un comportement commun (et un contrat) de **base**, mais laisser certains détails à implémenter aux subclasses concrètes.

#### 16.13.2.2 Règles pour les Abstract Classes

- Une classe avec au moins une méthode abstraite **doit** être déclarée `abstract`.
- Une `abstract class` **ne peut pas** être instanciée directement.
- Les méthodes abstraites n’ont pas de body et terminent avec un point-virgule.
- Les **abstract methods ne peuvent pas être `final`, `static` ou `private`**, parce qu’elles doivent être redéfinissables `overridable`.
- La première subclass concrète (non-abstract) dans la hiérarchie, doit implémenter tous les `abstract methods` hérités, sinon elle doit être déclarée elle aussi `abstract`.

```java
abstract class Shape {

	abstract double area(); // must be implemented by concrete subclasses

	void describe() {
		System.out.println("I am a shape.");
	}

	Shape() {
		System.out.println("Shape constructor");
	}
}

class Circle extends Shape {
	private final double radius;

	Circle(double radius) {
		this.radius = radius;
	}

	@Override
	double area() {
		return Math.PI * radius * radius;
	}
}
```

> [!NOTE]
> - Bien qu’une `abstract class` ne puisse pas être instanciée, ses constructeurs sont quand même appelés quand on crée des instances de classes filles concrètes.
> - Le flux des instanciations, dans la `chaîne héréditaire`, part toujours du sommet de la hiérarchie et se déplace vers le bas.

### 16.13.3 Créer des Objets Immutables

#### 16.13.3.1 Qu’est-ce qu’un Objet `Immutable`

Un objet est **immutable** si, après qu’il a été créé, son état **ne peut pas changer**.

Tous les attributs qui représentent son état, restent constants pour l'ensemble du cycle de vie de cet objet.

Les `immutable objects` sont simples à comprendre, intrinsèquement `thread safe` (si conçus correctement), et largement utilisés dans la Java Standard Library (par exemple `String`, wrapper classes comme `Integer`, et beaucoup de classes dans `java.time`).

#### 16.13.3.2 Lignes Directrices pour Concevoir des Classes Immutable

- Déclarer une classe **final** afin qu’elle ne puisse pas être étendue (ou bien rendre tous les constructeurs privés et fournir des factory methods protégés).
- Rendre tous les attributs qui représentent son état **private** et **final**.
- Ne fournir aucune méthode `mutator` (setter).
- Initialiser tous les attributs dans les constructeurs (ou dans les factory methods) et ne jamais les exposer de façon `mutable`.
- Si un attribut se réfère à un objet mutable, faire des **defensive copies** (copies défensives) en phase de construction et quand on le restitue via des `getters`.

```java
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class Person {
	private final String name; // String is immutable
	private final int age;
	private final List<String> hobbies; // List is mutable, we must protect it

	public Person(String name, int age, List<String> hobbies) {
		this.name = name;
		this.age = age;
		// Defensive copy on input
		this.hobbies = new ArrayList<>(hobbies);
	}

	public String getName() {
		return name; // safe (String is immutable)
	}

	public int getAge() {
		return age;
	}

	public List<String> getHobbies() {
		// Defensive copy or unmodifiable view on output
		return Collections.unmodifiableList(hobbies);
	}
}
```

Dans cet exemple:
- `Person` est **final**: elle ne peut pas être étendue et son comportement ne peut pas être altéré via `inheritance`.
- Tous les attributs sont `private` et `final`, définis une seule fois dans le constructeur.
- La liste des `hobbies` est copiée défensivement dans la phase de construction et wrappée comme `unmodifiable` (non modifiable) dans la `méthode getter`, afin qu’aucun code externe ne puisse modifier l’état interne.

Concevoir des `immutable objects` est particulièrement important dans des contextes multithread et quand on passe des objets à travers les différents layers d’une application.

