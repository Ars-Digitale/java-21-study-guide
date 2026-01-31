# 16. Ereditarietà in Java

### Indice

- [16. Ereditarietà in Java](#16-ereditarietà-in-java)
	- [16.1 Definizione Generale di Ereditarietà](#161-definizione-generale-di-ereditarietà)
	- [16.2 Ereditarietà Singola e java.lang.Object](#162-ereditarietà-singola-e-javalangobject)
	- [16.3 Ereditarietà Transitiva](#163-ereditarietà-transitiva)
	- [16.4 Cosa Viene Ereditato, Breve Promemoria](#164-cosa-viene-ereditato-breve-promemoria)
	- [16.5 Modificatori di Classe che Influenzano l’Ereditarietà](#165-modificatori-di-classe-che-influenzano-lereditarietà)
	- [16.6 Riferimenti this e super](#166-riferimenti-this-e-super)
		- [16.6.1 Il Riferimento this](#1661-il-riferimento-this)
		- [16.6.2 Il Riferimento super](#1662-il-riferimento-super)
	- [16.7 Dichiarare Costruttori in una catena ereditaria](#167-dichiarare-costruttori-in-una-catena-ereditaria)
	- [16.8 Costruttore no-arg di Default](#168-costruttore-no-arg-di-default)
	- [16.9 Usare this e Constructor Overloading](#169-usare-this-e-constructor-overloading)
	- [16.10 Chiamare il Costruttore del Parent usando super](#1610-chiamare-il-costruttore-del-parent-usando-super)
	- [16.11 Suggerimenti e Trappole sul Costruttore di Default](#1611-suggerimenti-e-trappole-sul-costruttore-di-default)
	- [16.12 super si Riferisce Sempre al Parent più diretto](#1612-super-si-riferisce-sempre-al-parent-più-diretto)
	- [16.13 Ereditare Membri](#1613-ereditare-membri)
		- [16.13.1 Method Overriding](#16131-method-overriding)
			- [16.13.1.1 Definizione e Ruolo nell’Ereditarietà](#161311-definizione-e-ruolo-nellereditarietà)
			- [16.13.1.2 Usare super per chiamare l’Implementazione del Parent](#161312-usare-super-per-chiamare-limplementazione-del-parent)
			- [16.13.1.3 Regole di Overriding Instance Methods](#161313-regole-di-overriding-instance-methods)
			- [16.13.1.4 Nascondere Static Methods Method Hiding](#161314-nascondere-static-methods-method-hiding)
		- [16.13.2 Abstract Classes](#16132-abstract-classes)
			- [16.13.2.1 Definizione e Scopo](#161321-definizione-e-scopo)
			- [16.13.2.2 Regole per le Abstract Classes](#161322-regole-per-le-abstract-classes)
		- [16.13.3 Creare Oggetti Immutabili](#16133-creare-oggetti-immutabili)
			- [16.13.3.1 Cos’è un Oggetto Immutable](#161331-cosè-un-oggetto-immutable)
			- [16.13.3.2 Linee Guida per Progettare Classi Immutable](#161332-linee-guida-per-progettare-classi-immutable)
			
---

L'`Inheritance` (Ereditarietà) è uno dei pilastri fondamentali dell'Object-Oriented Programming.

Essa permette a una classe `figlia` ( child ), la **subclass**, di acquisire lo stato e il comportamento di un’altra classe `genitrice` ( parent ), la **superclass**, creando relazioni gerarchiche che promuovono riuso del codice, specializzazione e polimorfismo.

## 16.1 Definizione Generale di Ereditarietà

L’ereditarietà consente a una classe di estenderne un’altra, ottenendone automaticamente i suoi `attributi` e i suoi `metodi` accessibili.

La classe che estende può aggiungere nuove funzionalità o ridefinire (fare `override`) i comportamenti esistenti, creando versioni più specializzate della propria classe parent.

> [!NOTE]
> L’Ereditarietà esprime una relazione *“is-a”* (è-un): un Cane **is a** (è-un) Animale.

---

## 16.2 Ereditarietà Singola e java.lang.Object

Java supporta la **single inheritance**, il che significa che ogni classe può estendere **una sola** superclasse diretta.

Tutte le classi ereditano in ultima analisi da `java.lang.Object`, che si trova al vertice della gerarchia.

Questo garantisce che tutti gli oggetti Java condividano un comportamento minimo comune (ad esempio i metodi `toString()`, `equals()`, `hashCode()`).

```java
class Animal { }
class Dog extends Animal { }

// All classes implicitly extend Object
System.out.println(new Dog() instanceof Object); // true
```

---

## 16.3 Ereditarietà Transitiva

L’`Inheritance` è **transitiva**.

Se la classe `C` estende `B` e `B` estende `A`, allora `C` eredita effettivamente i membri accessibili sia da `B` *sia* da `A`.

```java
class A { }
class B extends A { }
class C extends B { } // C inherits from both A and B
```

---

## 16.4 Cosa Viene Ereditato, Breve Promemoria

Una subclass eredita tutti i membri **accessibili** della classe genitrice.

Tuttavia, nello specifico, questo dipende dagli `access modifiers`.

- **public** → sempre ereditato
- **protected** → ereditato se accessibile tramite regole di package o subclass
- **default (package-private)** → ereditato solo nello stesso package
- **private** → **NON** ereditato

> [!NOTE]
> ( Fare riferimento al Paragrafo "**Access Modifiers**" nel Capitolo: [Mattoni di base del linguaggio Java](../module-01/basic-building-blocks.md) )

---

## 16.5 Modificatori di Classe che influenzano l’Ereditarietà

Alcuni modificatori a livello di classe determinano se una classe possa essere estesa.

| Modifier | Meaning | Effect on Inheritance |
| --- | --- | --- |
| `final` | La classe non può essere estesa | Inheritance STOP |
| `abstract` | La classe non può essere istanziata | Deve essere estesa |
| `sealed` | Permette solo un elenco fisso di subclass | Restringe l’inheritance |
| `non-sealed` | Subclass di una sealed class che riapre l’inheritance | Inheritance permesso |
| `static` | Si applica solo alle nested classes | Si comporta come una top-level class all’interno della sua classe contenitore |

> [!NOTE]
> Una classe `static` in Java può esistere solo come **static nested class**.

---

## 16.6 Riferimenti `this` e `super`

### 16.6.1 Il Riferimento `this`

Il riferimento `this` si riferisce all’istanza corrente dell’oggetto e permette di disambiguare l’accesso ai membri correnti ed ereditati.

Java utilizza una regola di **granular scope**:
- Se una variabile di metodo/locale ha lo stesso nome di un `instance field`, quella locale “oscura” l'attributo di istanza.
- È necessario usare `this.fieldName` per accedere quindi all’attributo di istanza.

```java
public class Person {
    String name;

    public Person(String name) {
        this.name = name;
    }
}
```

Se i nomi differiscono, `this` è opzionale.

```java
public class Person {
    String name;

	public Person(String n) {
		name = n;
	}
}
```


> [!WARNING]
> `this` NON può essere usato all’interno di metodi statici perché, in quel contesto, non esiste alcuna istanza.


### 16.6.2 Il Riferimento `super`

Il riferimento `super` dà accesso ai membri della classe genitrice (parent) diretta.

Utile quando:
- Il parent (genitore) e il child (figlio) definiscono un attributo/metodo con lo stesso nome; vedi sezione: [Ereditare Membri](#1613-ereditare-membri)
- Parent e child definiscono un attributo con lo stesso nome → `variable hiding` (due copie)
- Parent e child definiscono un metodo con la stessa signature → `method overriding`
- Si vuole chiamare esplicitamente l’implementazione ereditata

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
> `super` NON può essere usato dentro contesti static.

---

## 16.7 Dichiarare Costruttori in una catena ereditaria

Un `costruttore` inizializza un oggetto appena creato.

I costruttori non vengono **mai ereditati**, ma ogni costruttore di subclass deve assicurare che la classe parent sia inizializzata.

I `costruttori` sono metodi speciali con un nome che corrisponde al nome della classe e che non dichiarano alcun return type.

Una classe può definire più costruttori (constructor overloading), ciascuno con una `signature` unica.

Si può dichiarare esplicitamente un `no-arg constructor` o un qualsiasi costruttore specifico oppure, se non lo si fa, Java creerà implicitamente un `default no-arg constructor`.

Se si dichiara esplicitamente un costruttore, il compilatore Java non includerà alcun `default no-arg constructor`: questa regola si applica indipendentemente a ogni classe nella gerarchia.

Una classe parent continua ad avere il proprio costruttore di default a meno che non ne definisca anch’essa uno.

---

## 16.8 Costruttore `no-arg` di Default

Se una classe non dichiara alcun costruttore, Java inserisce automaticamente un **default no-argument constructor**.

Questo costruttore invocherà il costruttore `super()` del genitore diretto, implicitamente: il compilatore Java inserisce implicitamente una chiamata al no-arg constructor `super()`.

```java
class Parent { }

class Child extends Parent {
    // Compiler inserts:
    // Child() { super(); }
}
```

---

## 16.9 Usare `this()` e Constructor Overloading

**this()** invoca un altro costruttore nella stessa classe.

Regole:
- Deve essere la **prima** istruzione nel costruttore
- Non può essere combinato con `super()`
- È consentita una sola chiamata a `this()` in un costruttore
- Usato per centralizzare l’inizializzazione

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

## 16.10 Chiamare il Costruttore del Parent usando `super()`

Ogni costruttore deve chiamare un costruttore della superclasse, esplicitamente o implicitamente.

La chiamata a `super()` deve apparire come **prima** istruzione nel costruttore (a meno che non sia sostituito da `this()`).

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

## 16.11 Suggerimenti e Trappole sul Costruttore di Default

- **Se la classe genitore non ha un no-arg constructor, la classe figlia DEVE invocare lo specifico `super(args)` esplicitamente.**
- Se la classe figlia non definisce alcun costruttore, Java non crea automaticamente un costruttore di default per questa.
- Se ci si dimentica di chiamare esplicitamente un `parent constructor` esistente, il compilatore inserisce `super()` — il quale potrebbe non esistere.

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

## 16.12 `super()` si Riferisce Sempre al Parent più diretto

Anche in lunghe catene ereditarie, `super()` invoca sempre (e soltanto) il costruttore della classe genitrice **immediata**.

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

## 16.13 Ereditare Membri

### 16.13.1 Method Overriding

Il `method overriding` è un concetto fondamentale dell'ereditarietà: permette a una classe figlia di fornire una **nuova implementazione** per un metodo già definito in una sua classe parent.

A runtime, la versione del metodo eseguita dipende dal **tipo reale dell’oggetto**, non dal particolare `reference type`.

Questo comportamento è chiamato **dynamic dispatch** ed è ciò che rende possibile il polimorfismo in Java.

#### 16.13.1.1 Definizione e Ruolo nell’Ereditarietà

Un metodo in una subclass fa **override** di un metodo di una sua superclass se:
- il metodo della superclass è `metodo d'istanza` (non statico);
- il metodo della subclass ha lo **stesso nome**, la **stessa lista di parametri** e un **return type che è dello stesso tipo** o di un **sottotipo** del return type nel metodo ereditato;
- entrambi i metodi sono accessibili (non privati) e il metodo della subclass non è meno visibile di quello della superclass.
- Il metodo in overriding **non può dichiarare nuove o più ampie checked exceptions**.

L’Overriding è usato per specializzare il comportamento: una subclass può adattare o rifinire il comportamento della classe parent, pur potendo essere usata tramite un reference del tipo genitore.

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

#### 16.13.1.2 Usare super per chiamare l’Implementazione del Parent

Quando una subclass fa override di un metodo, può comunque accedere all’implementazione "originaria" della superclass, tramite il riferimento `super`.

Questo è utile se si vuole riusare o estendere il comportamento definito nella classe parent.

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

Se sia la classe parent sia la classe child dichiarano un membro (attributo o metodo) con lo stesso nome, il child può accedere a entrambi:
- la versione in overriding (default)
- la versione del parent tramite `super`

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

#### 16.13.1.3 Regole di Overriding (Instance Methods)

- **Stessa firma (signature)**: stesso nome di metodo, stessi tipi e ordine dei parametri.
- **return type coovariante**: il metodo in overriding può restituire (ritornare) lo stesso tipo del parent, o un **subtype** del return type del parent.
- **Accessibilità**: il metodo in overriding non può essere meno accessibile del metodo originario (ad esempio, non si può passare da `public` a `protected` o `private`). Può soltanto mantenere la stessa visibilità o aumentarla.
- **Checked exceptions**: il metodo in overriding non può dichiarare nuove o più ampie `checked exceptions` rispetto al `parent method`; può dichiararne meno, dichiarare checked exceptions più specifiche o, eventualmente, rimuoverle completamente.
- **Unchecked exceptions**: possono essere aggiunte o rimosse senza restrizioni.
- **final methods**: non possono essere partecipare all'`override`.

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

#### 16.13.1.4 Nascondere Static Methods (Method Hiding)

I metodi statici non partecipano all'`overriding`; risultano invece, eventualmente, nascosti (**hidden**).

Se una subclass definisce uno static method con la stessa firma di uno static method della classe parent, il metodo statico della subclass **nasconde** quello della classe genitrice.

Se uno dei metodi invece è marcato come `static` e l’altro no, il codice non compilerà.

La selezione del metodo per i metodi statici avviene a **compile time** ed è basata sul `reference type`: non sull’`object type`.

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
> - metodi statici **final** non possono essere `hidden` (nascosti); metodi d'istanza dichiarati **final** non possono essere `overriden`.
> - Se si prova a ridefinirli in una subclass, il codice non compilerà.

### 16.13.2 Abstract Classes

#### 16.13.2.1 Definizione e Scopo

Una **abstract class** è una classe che non può essere istanziata direttamente ed è destinata a essere estesa.

Può contenere:
- metodi abstract (dichiarati senza body);
- metodi concreti (con implementazione);
- attributi, costruttori, membri statici, e anche static initializers.

Le abstract classes sono usate quando si vuole definire un comportamento comune (e un contratto) di **base**, ma lasciare alcuni dettagli da implementare alle subclasses concrete.

#### 16.13.2.2 Regole per le Abstract Classes

- Una classe con almeno un metodo astratto **deve** essere dichiarata `abstract`.
- Una `abstract class` **non può** essere istanziata direttamente.
- I metodi astratti non hanno body e terminano con un punto e virgola.
- Gli **abstract methods non possono essere `final`, `static` o `private`**, perché devono essere ridefinibili `overridable`.
- La prima subclass concreta (non-abstract) nella gerarchia, deve implementare tutti gli `abstract methods` ereditati, altrimenti deve essere dichiarata anch'essa `abstract`.

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
> - Sebbene una `abstract class` non possa essere istanziata, i suoi costruttori vengono comunque chiamati quando si creano istanze di classi figlie concrete.
> - Il flusso delle istanziazioni, nella `catena ereditaria`, parte sempre dal top della gerarchia e si muove verso il basso.

### 16.13.3 Creare Oggetti Immutabili

#### 16.13.3.1 Cos’è un Oggetto `Immutable`

Un oggetto è **immutable** se, dopo che è stato creato, il suo stato **non può cambiare**.

Tutti gli attributi che ne rappresentano lo stato, rimangono costanti per l'intero ciclo di vita di quell’oggetto.

Gli `immutable objects` sono più semplici da comprendere, intrinsecamente `thread safe` (se progettati correttamente), e ampiamente usati nella Java Standard Library (ad esempio `String`, wrapper classes come `Integer`, e molte classi in `java.time`).

#### 16.13.3.2 Linee Guida per Progettare Classi Immutable

- Dichiarare una classe **final** cosicché non possa essere estesa (oppure rendere tutti i costruttori privati e fornire factory methods protetti).
- Rendere tutti gli attributi che ne rappresentano lo stato **private** e **final**.
- Non fornire alcun `mutator` (setter) methods.
- Inizializzare tutti gli attributi nei costruttori (o nei factory methods) e non esporli mai in modo `mutabile`.
- Se un attributo si riferisce ad un oggetto mutabile, fare **defensive copies** (copie difensive) in fase di costruzione e quando lo si restituisce tramite `getters`.

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

In questo esempio:
- `Person` è **final**: non può essere estesa e il suo comportamento non può essere alterato tramite `inheritance`.
- Tutti gli attributi sono `private` e `final`, definiti una sola volta nel costruttore.
- La lista degli `hobbies` viene copiata difensivamente nella fase di costruzione e wrappata come `unmodifiable` (non modificabile) nel `metodo getter`, cosicché alcun codice esterno ne possa modificare lo stato interno.

Progettare `immutable objects` è particolarmente importante in contesti multithread e quando si passano oggetti attraverso i diversi layers di una applicazione.
