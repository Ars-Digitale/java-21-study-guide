# 6. Instanciation des types

### Table des matières

- [6. Instanciation des types](#6-instanciation-des-types)
  - [6.1 Introduction](#61-introduction)
    - [6.1.1 Gestion des types primitifs](#611-gestion-des-types-primitifs)
      - [6.1.1.1 Déclarer un primitif](#6111-déclarer-un-primitif)
      - [6.1.1.2 Affecter un primitif](#6112-affecter-un-primitif)
    - [6.1.2 Gestion des types référence](#612-gestion-des-types-référence)
      - [6.1.2.1 Créer et affecter une référence](#6121-créer-et-affecter-une-référence)
      - [6.1.2.2 Constructeurs](#6122-constructeurs)
      - [6.1.2.3 Blocs-dinitialisation-dinstance](#6123-blocs-dinitialisation-dinstance)
  - [6.2 Initialisation par défaut des variables](#62-initialisation-par-défaut-des-variables)
    - [6.2.1 Variables d’instance et de classe](#621-variables-dinstance-et-de-classe)
    - [6.2.2 Variables d’instance final](#622-variables-dinstance-final)
    - [6.2.3 Variables locales](#623-variables-locales)
      - [6.2.3.1 Inférer les types avec var](#6231-inférer-les-types-avec-var)
  - [6.3 Types wrapper](#63-types-wrapper)
    - [6.3.1 Objectif des types wrapper](#631-objectif-des-types-wrapper)
    - [6.3.2 Autoboxing et unboxing](#632-autoboxing-et-unboxing)
    - [6.3.3 Parsing et conversion](#633-parsing-et-conversion)
    - [6.3.4 Méthodes utilitaires](#634-méthodes-utilitaires)
    - [6.3.5 Valeurs null](#635-valeurs-null)
  - [6.4 Égalité en Java](#64-égalité-en-java)
    - [6.4.1 Égalité avec les types primitifs](#641-égalité-avec-les-types-primitifs)
      - [6.4.1.1 Points clés](#6411-points-clés))
    - [6.4.2 Égalité avec les types référence](#642-égalité-avec-les-types-référence)
      - [6.4.2.1 Comparaison d’identité](#6421-comparaison-didentité)
      - [6.4.2.2 equals Comparaison logique](#6422-equals-comparaison-logique)
      - [6.4.2.3 Points clés](#6423-points-clés)
  - [6.4.3 String Pool et égalité](#643-string-pool-et-égalité)
      - [6.4.3.1 La méthode intern](#6431-la-méthode-intern)
    - [6.4.4 Égalité avec les types wrapper](#644-égalité-avec-les-types-wrapper)
    - [6.4.5 Égalité et null](#645-égalité-et-null)
    - [6.4.6 Tableau récapitulatif](#646-tableau-récapitulatif)


---


## 6.1 Introduction
 
En Java, un **type** peut être soit un **type primitif** (comme `int`, `double`, `boolean`, etc.), soit un **type référence** (classes, interfaces, tableaux, enums, records, etc.). Voir : [Java Data Types and Casting](data-types.md)

La façon dont les instances sont créées dépend de la catégorie du type :

- **Types primitifs**  
  Les instances des types primitifs sont créées simplement en déclarant une variable.  
  La JVM alloue automatiquement la mémoire nécessaire pour contenir la valeur, et aucun mot-clé explicite n’est requis. 
  
```java
int age = 30;         // crée un int primitif avec la valeur 30
boolean flag = true;  // crée un boolean primitif avec la valeur true
double pi = 3.14159;  // crée un double primitif avec la valeur 3.14159
```
  
- **Types référence (objets)**  
	Les instances des types classe sont créées à l’aide du mot-clé `new` (sauf quelques cas particuliers comme les littéraux String, les records avec constructeur canonique, ou les méthodes factory).
	Le mot-clé `new` alloue de la mémoire sur le tas (heap) et invoque un constructeur de la classe.
  
```java
String name = new String("Alice"); // crée explicitement un nouvel objet String
Person p = new Person();           // crée un nouvel objet Person via son constructeur
```
  
Il est aussi courant de s’appuyer sur des littéraux ou des méthodes factory pour créer des objets.
  
```java
String name = new String("Alice"); // crée explicitement un nouvel objet String
Person p = new Person();           // crée un nouvel objet Person via son constructeur
```

> [!IMPORTANT]
> Les littéraux String **ne nécessitent pas `new`** et sont stockés dans le **String pool**.
> Utiliser `new String("x")` crée toujours un nouvel objet sur le heap.

  
### 6.1.1 Gestion des types primitifs

#### 6.1.1.1 Déclarer un primitif

**Déclarer** un type primitif (comme pour les types référence) signifie réserver un espace mémoire pour une variable d’un type donné, sans nécessairement lui attribuer une valeur.  

> [!WARNING]
> Contrairement aux primitifs, dont la taille dépend du type spécifique (par ex. `int` vs `long`), les variables référence occupent toujours la même taille fixe en mémoire — ce qui varie, c’est la taille de l’objet qu’elles pointent.

- Exemples de syntaxe (déclaration uniquement) :

```java
int number;

boolean active;

char letter;

int x, y, z;          // Déclarations multiples dans une seule instruction : Java autorise la déclaration de plusieurs variables du même type
```


> [!IMPORTANT]
> Les `modificateurs` et le `type` déclarés au début d’une déclaration de variables s’appliquent à toutes les variables déclarées dans la même instruction.
>
> **Exception** : lors de la déclaration de tableaux en utilisant les crochets après le nom de la variable, les crochets font partie du déclarateur de la variable individuelle, et non du type de base.

- Examples

```java
static int a, b, c;

// est équivalent à :

static int a;
static int b;
static int c;


int[] a, b;   // les deux sont des tableaux de int
int c[], d;   // seul c est un tableau, d est un int normal
```

#### 6.1.1.2 Affecter un primitif

**Affecter** un type primitif (comme pour les types référence) signifie stocker une valeur dans une variable déclarée de ce type.  
Pour les primitifs, la variable contient la valeur elle-même, tandis que pour les types référence elle contient l’adresse mémoire (une référence) de l’objet pointé.

- Exemples de syntaxe :

```java
int number;  					// Déclaration d’un int : une variable appelée "number"

number = 10;  					// Affectation de la valeur 10 à cette variable

char letter = 'A';    			// Déclaration et affectation en une seule instruction : déclaration et affectation peuvent être combinées 

int a1, a2;                      // Déclarations multiples  

int a = 1, b = 2, c = 3;  		// Déclarations multiples & affectations

char b1, b2, b3 = 'C';			// Déclarations mixtes (2 déclarations + 1 affectation)

double d1, double d2;            // ERROR - NOT LEGAL

int v1; v2; 					 // ERROR - NOT LEGAL
```
  
> [!IMPORTANT]
> Quand tu écris un nombre directement dans le code (un littéral numérique), Java suppose par défaut qu’il est de type **int**.  
> Si la valeur ne tient pas dans un `int`, le code ne compile pas, à moins de le marquer explicitement avec le suffixe approprié.

- Exemple de syntaxe pour un littéral numérique :

```java
long exNumLit = 5729685479; // ❌ Does not compile.
						  // Even though the value would fit in a long,
						  // a plain numeric literal is assumed to be an int,
						  // and this number is too large for int.

Changing the declaration adding the correct suffix (L or l) will solve:

long exNumLit = 5729685479L;

or

long exNumLit = 5729685479l;
```
  
**Déclarer** un type `reference` signifie réserver de l’espace mémoire pour une variable qui contiendra une référence (pointeur) vers un objet du type spécifié.
  
À ce stade, aucun objet n’est encore créé — la variable a seulement la capacité d’en référencer un.

> [!WARNING]
> Contrairement aux primitifs, dont la taille dépend du type spécifique (par ex. `int` vs `long`), les variables référence occupent toujours la même taille fixe en mémoire (suffisante pour stocker une référence).  
> Ce qui varie, c’est la taille de l’objet pointé, qui est alloué séparément sur le heap.

- Exemples de syntaxe (déclaration uniquement) :

```java
String name;
Person person;
List<Integer> numbers;

Person p1, p2, p3;   // Déclarations multiples dans une seule instruction

String a = "abc", b = "def", c = "ghi";  	// Déclarations multiples & affectations

String b1, b2, b3 = "abc"					// Déclarations mixtes (b1, b2) avec une affectation (b3)

String d1, String d2;         			// ERROR - NOT LEGAL

String v1; v2; 							// ERROR - NOT LEGAL
```


### 6.1.2 Gestion des types référence

#### 6.1.2.1 Créer et affecter une référence

**Affecter** un type `reference` signifie stocker dans la variable l’adresse mémoire d’un objet.

On le fait normalement après la création de l’objet avec le mot-clé **new** et un constructeur, ou en utilisant un littéral ou une méthode factory.

Une référence peut aussi être affectée à un autre objet du même type ou d’un type compatible.

Les types référence peuvent également recevoir **null**, ce qui signifie qu’ils ne référencent aucun objet.

- Exemples de syntaxe :

```java
Person person = new Person(); // Exemple avec 'new' et un constructeur 'Person()' :
							// 'new Person()' crée un nouvel objet Person sur le heap
							// et renvoie sa référence, stockée dans la variable 'person'.

String greeting = "Hello";	 // Exemple avec un littéral (pour String).

List<Integer> numbers = List.of(1, 2, 3);   // Exemple avec une méthode factory.
```
  
#### 6.1.2.2 Constructeurs

Dans l’exemple, **`Person()`** est un constructeur — un type spécial de méthode utilisée pour initialiser de nouveaux objets.
  
Chaque fois que tu appelles `new Person()`, le constructeur s’exécute et configure l’instance nouvellement créée.

**Les constructeurs ont trois caractéristiques principales :**

- Le nom du constructeur **doit correspondre exactement au nom de la classe** (sensible à la casse).  
- Les constructeurs **ne déclarent pas de type de retour** (pas même `void`).  
- Si tu ne définis aucun constructeur dans ta classe, le compilateur fournit automatiquement un **constructeur par défaut sans argument** qui ne fait rien.

> [!WARNING]
> Si tu vois une méthode qui a le même nom que la classe **mais qui déclare un type de retour**, ce n’est **pas** un constructeur.  
> C’est simplement une méthode ordinaire (même si commencer les noms de méthodes par une majuscule va à l’encontre des conventions de nommage Java).

Le **but d’un constructeur** est d’initialiser l’état d’un objet nouvellement créé — généralement en affectant des valeurs à ses champs, soit avec des valeurs par défaut, soit à partir de paramètres passés au constructeur.

- Exemple 1 : Constructeur par défaut (sans paramètres)
							 
```java
public class Person {
    String name;
    int age;

    // Default constructor
    public Person() {
        name = "Unknown";
        age = 0;
    }
}

Person p1 = new Person(); // name = "Unknown", age = 0
```

- Exemple 2 : Constructeur avec paramètres

```java
public class Person {
    String name;
    int age;

    // Constructor with parameters
    public Person(String newName, int newAge) {
        name = newName;
        age = newAge;
    }
}

Person p2 = new Person("Alice", 30); // name = "Alice", age = 30
```

- Exemple 3 : Plusieurs constructeurs (surcharge de constructeurs)

```java
public class Person {
    String name;
    int age;

    // Default constructor
    public Person() {
        this("Unknown", 0); // calls the other constructor
    }

    // Constructor with parameters
    public Person(String newName, int newAge) {
        name = newName;
        age = newAge;
    }
}

Person p1 = new Person();            // name = "Unknown", age = 0
Person p2 = new Person("Bob", 25);   // name = "Bob", age = 25
```

> [!IMPORTANT]
> - Les constructeurs ne sont pas hérités : si une superclasse définit des constructeurs, ils ne sont pas automatiquement disponibles dans la sous-classe — tu dois les déclarer explicitement.
> - Si tu déclares un constructeur quelconque dans une classe, le compilateur ne génère pas le constructeur par défaut sans argument : si tu as encore besoin d’un constructeur sans argument, tu dois le déclarer manuellement.

#### 6.1.2.3 Blocs d’initialisation d’instance

En plus des constructeurs, Java fournit un mécanisme appelé **initializer blocks** pour aider à initialiser les objets.  
Ce sont des blocs de code à l’intérieur d’une classe, entourés par `{ }`, qui s’exécutent **à chaque création d’instance**, juste avant l’exécution du corps du constructeur.

**Caractéristiques**
- Aussi appelés **instance initializer blocks**.  
- Exécutés, avec les initialisations de champs, dans l’ordre où ils apparaissent dans la définition de la classe, mais toujours avant les constructeurs.    
- Utiles lorsque plusieurs constructeurs doivent partager un code d’initialisation commun.

Exemple : utilisation d’un Instance Initializer Block

```java
public class Person {
    String name;
    int age;

    // Instance initializer block
    {
        System.out.println("Instance initializer block executed");
        age = 18; // default age for every Person
    }

    // Default constructor
    public Person() {
        name = "Unknown";
    }

    // Constructor with parameters
    public Person(String newName) {
        name = newName;
    }
}

Person p1 = new Person();          // prints "Instance initializer block executed"
Person p2 = new Person("Alice");   // prints "Instance initializer block executed"
```

> [!NOTE]
> Dans cet exemple, le bloc d’initialisation s’exécute avant le corps de chacun des constructeurs.
> p1 et p2 commenceront tous les deux avec age = 18, quel que soit le constructeur utilisé.

**Plusieurs blocs d’initialisation** : si une classe contient plusieurs blocs d’initialisation, ils s’exécutent dans l’ordre où ils apparaissent dans le fichier source :

- Exemple : 

```java
public class Example {
    {
        System.out.println("First block");
    }

    {
        System.out.println("Second block");
    }
}

Example ex = new Example();
// Output:
// First block
// Second block
```

> [!NOTE]
> Les blocs d’initialisation d’instance sont moins courants en pratique, car une logique similaire peut souvent être placée directement dans les constructeurs.
> Il est important de savoir que :
> - Ils s’exécutent toujours avant le corps du constructeur.
> - Ils sont exécutés dans l’ordre de déclaration dans la classe.
> - Ils peuvent être combinés avec les constructeurs pour éviter la duplication de code.

> [!WARNING]
> **Ordre d’initialisation lors de la création d’un objet**
> 1. Champs statiques
> 2. Blocs d’initialisation statiques
> 3. Champs d’instance
> 4. Blocs d’initialisation d’instance
> 5. Corps du constructeur

---

## 6.2 Initialisation par défaut des variables

### 6.2.1 Variables d’instance et de classe

- Une **variable d’instance (un champ/field)** est une valeur définie dans une instance d’un objet ;
- Une **variable de classe** (définie avec le mot-clé **static**) est définie au niveau de la classe et est partagée entre tous les objets (instances de la classe)

Les variables d’instance et de classe reçoivent une valeur par défaut, par le compilateur, si elles ne sont pas initialisées.

- Tableau des valeurs par défaut pour les variables d’instance et de classe :

| Type | Default Value |
| --- | --- |
| Object | null |
| Numeric | 0 |
| boolean | false |
| char | '\u0000' (NUL) |


### 6.2.2 Variables d’instance final

Contrairement aux variables d’instance et de classe ordinaires, les variables **`final` ne sont pas initialisées par défaut par le compilateur**.  
Une variable `final` **doit être affectée explicitement exactement une fois**, sinon le code ne compile pas.

Cela s’applique aux :
- **variables final d’instance**
- **variables de classe static final**

> [!NOTE]
> On peut affecter une valeur `null` à une variable final d’instance ou de classe tant que cela est fait explicitement.

Java impose cette règle car une variable `final` représente une valeur qui doit être *connue et fixée* avant usage.


<ins>**`Final Instance Variables`**</ins>

Une **variable final d’instance** doit être affectée **exactement une fois**, et l’affectation doit se produire dans *un* des endroits suivants :

1. **Au point de déclaration**
2. **Dans un bloc d’initialisation d’instance**
3. **À l’intérieur de chaque constructeur**

Si la classe a *plusieurs constructeurs*, la variable doit être affectée dans **tous**.

- Exemple :
```java
public class Person {
    final int id;   // doit être affectée avant la fin du constructeur
    String name;

    // Constructeur 1
    public Person(int id, String name) {
        this.id = id;        // ok
        this.name = name;
    }

    // Constructeur 2
    public Person() {
        this.id = 0;         // requis aussi ici
        this.name = "Unknown";
    }
}
```

> [!WARNING]
> Compiler sans affecter `id` dans **chaque** constructeur produit une erreur de compilation :
> variable id might not have been initialized

<ins>**Variables de classe `static final` (constantes)**</ins>

Une **variable static final** appartient à la classe plutôt qu’à une instance.  
Elle doit aussi être affectée exactement une fois, mais l’affectation peut se faire à l’un des endroits suivants :

1. **Au point de déclaration**
2. **Dans un bloc d’initialisation statique**

- Exemple :
```java
public class AppConfig {

    static final int TIMEOUT = 5000;    // affectée à la déclaration

    static final String VERSION;        // affectée dans le bloc static

    static {
        VERSION = "1.0.0";              // ok
    }
}
```

Tenter d’affecter une `static final` dans un constructeur est illégal.


<ins>**Règles clés pour les champs `final`**</ins>

| Scenario | Allowed? | Notes |
| --- | --- | --- |
| Assign at declaration | ✔ | Most common pattern |
| Assign in constructor | ✔ | All constructors must assign it |
| Assign in instance initializer | ✔ | Before constructor body runs |
| Assign in static initializer (static final only) | ✔ | For class-level constants |
| Assign multiple times | ❌ | Compilation error |
| Default initialization | ❌ | Must be explicitly assigned |

Exemple d’une situation **illégale** :
```java
public class Example {
    final int x;        // not initialized
}

Example e = new Example(); // ❌ compile-time error
```

<ins>**Pourquoi les variables `final` ne sont-elles pas initialisées par défaut ?**</ins>

Parce que :
- Leur valeur doit être **connue et immuable**, et
- Java doit garantir que la valeur est définie **avant utilisation**,
- Une initialisation par défaut créerait une situation où `0`, `null` ou `false` pourraient devenir involontairement la valeur permanente.

Ainsi, Java oblige les développeurs à initialiser explicitement les champs `final`.

> [!TIP]
> `final` signifie **affecté une seule fois**, pas **objet immuable**.
>   
> Une référence final peut toujours pointer vers un objet mutable.

```java
final List<String> list = new ArrayList<>();
list.add("ok");      // autorisé
list = new ArrayList<>(); // ❌ impossible de réaffecter la référence
```

### 6.2.3 Variables locales

Les **variables locales** sont des variables définies dans un constructeur, une méthode ou un bloc d’initialisation ;

Les variables locales n’ont pas de valeurs par défaut et doivent être initialisées avant d’être utilisées. Si tu essaies d’utiliser une variable locale non initialisée, le compilateur signalera une ERREUR.

- Exemple 

```java
public int localMethod {
   
	int firstVar = 25;
	int secondVar;
	secondVar = 35;
	int firstSum = firstVar + secondVar;    // OK variables are both initialized before use
	
	int thirdVar;
	int secondSum = firstSum + thirdVar;    // ERROR: variable thirdVar has not been initialized before use; if you do not try to use thirdVar the compiler will not complain
}
```

#### 6.2.3.1 Inférer les types avec var

Dans certaines conditions, tu peux utiliser le mot-clé **var** à la place du type approprié lors de la déclaration de variables **locales** ;

> [!WARNING]
> - **var** N’EST PAS un mot réservé en Java ;
> - **var** ne peut être utilisé que pour les variables locales : il NE PEUT PAS être utilisé pour les **paramètres de constructeur**, les **variables d’instance** ou les **paramètres de méthode** ;
> - Le compilateur infère le type en regardant UNIQUEMENT le code **sur la ligne de déclaration** ; une fois le bon type inféré, tu ne peux pas réaffecter avec un autre type.

- Exemple

```java
public int localMethod {
   
	var inferredInt = 10; 	// The compiler infer int by the context;
	inferredInt = 25; 		// OK
	
	inferredInt = "abcd";   // ERROR: the compiler has already inferred the type of the variable as int
	
	var notInferred;
	notInferred = 30;		// ERROR: in order to infer the type, the compiler looks ONLY at the line with declaration
	
	var first, second = 15; // ERROR: var cannot be used to define two variables on the same statement;
	
	var x = null;           // ERROR: var cannot be initialized with null but it can be reassigned to null provided that the underlying type is a reference type.
}
```

> [!WARNING]
> Les variables locales **n’obtiennent jamais** de valeurs par défaut.
> Les champs d’instance et statiques **en obtiennent toujours**.

---

## 6.3 Types wrapper

En Java, les **types wrapper** sont des représentations objet des huit types primitifs.  
Chaque primitif a une classe wrapper correspondante dans le package `java.lang` :

| Primitive | Wrapper Class |
| --- | --- |
| `byte` | `Byte` |
| `short` | `Short` |
| `int` | `Integer` |
| `long` | `Long` |
| `float` | `Float` |
| `double` | `Double` |
| `char` | `Character` |
| `boolean` | `Boolean` |

Les objets wrapper sont immuables — une fois créés, leur valeur ne peut pas changer.

### 6.3.1 Objectif des types wrapper
- Permettre d’utiliser des primitifs dans des contextes qui exigent des objets (par ex. collections, generics).  
- Fournir des méthodes utilitaires pour parser, convertir et manipuler des valeurs.  
- Supporter des constantes comme `Integer.MAX_VALUE` ou `Double.MIN_VALUE`.  

### 6.3.2 Autoboxing et unboxing
Depuis Java 5, le compilateur convertit automatiquement entre primitifs et wrappers :
- **Autoboxing** : primitif → wrapper  
- **Unboxing** : wrapper → primitif  

```java
Integer i = 10;       // autoboxing: int → Integer
int n = i;            // unboxing: Integer → int

Integer int1 = Integer.valueOf(11);
long long1 = int1;  // Unboxing --> implicit cast OK

Long long2 = 11;   // ❌ Does not compile. 
                   // 11 is an int literal → requires autoboxing + widening → illegal

Character char1 = null;
char char2 = char1;  // WARNING: NullPointerException

Integer	 arr1 = {11.5, 13.6}  // WARNING: Does not compile!!
Double[] arr2 = {11, 22};     // WARNING: Does not compile!!
```

> [!TIP]
> Java **ne réalise jamais** autoboxing + widening/narrowing en une seule étape.

> [!WARNING]
> - **AUTOBOXING** et **cast implicite** ne sont pas autorisés dans la même instruction : tu ne peux pas faire les deux en même temps. (voir l’exemple ci-dessus)
> - Cette règle s’applique aussi aux appels de méthode.

### 6.3.3 Parsing et conversion

Les wrappers fournissent des méthodes statiques pour convertir des chaînes ou d’autres types en primitifs :

```java
int x = Integer.parseInt("123");    // returns primitive int
Integer y = Integer.valueOf("456"); // returns Integer object
double d = Double.parseDouble("3.14");

// On the numeric wrapper class valueOf() throws a NumberFormatException on invalid input.
// Example:

Integer w = Integer.valueOf("two"); // NumberFormatException

// On Boolean, the method returns Boolean.TRUE for any value that matches "true" ignoring case, otherwise Boolean.false
// Example:

Boolean.valueOf("true"); 	// true
Boolean.valueOf("TrUe"); 	// true
Boolean.valueOf("TRUE"); 	// true
Boolean.valueOf("false");	// false
Boolean.valueOf("FALSE");	// false
Boolean.valueOf("xyz");		// false
Boolean.valueOf(null);		// false

// The numeric integral classes Byte, Short, Integer and Long include an overloaded **valueOf(String str, int base)** method which takes a base value
// Example with base 16 (hexadecimal) which includes character 0 -> 9 and A -> F (ignore case)

Integer.valueOf("6", 16);	// 6
Integer.valueOf("a", 16);	// 10
Integer.valueOf("A", 16);	// 10
Integer.valueOf("F", 16);	// 15
Integer.valueOf("G", 16);	// NumberFormatException
```

> [!NOTE]
> Les méthodes **parseXxx()** renvoient un primitif tandis que **valueOf()** renvoie un objet wrapper.

### 6.3.4 Méthodes utilitaires

Toutes les classes wrapper numériques étendent la classe `Number` et héritent donc de méthodes utilitaires telles que : `byteValue()`, `shortValue()`, `intValue()`, `longValue()`, `floatValue()`, `doubleValue()`.

Les classes wrapper `Boolean` et `Character` incluent : `booleanValue()` et `charValue()`.

- Exemple :

```java

// In trying to convert those helper methods can result in a loss of precision.

Double baseDouble = Double.valueOf("300.56");

Double wrapDouble = baseDouble.doubleValue();
System.out.println("baseDouble.doubleValue(): " + wrapDouble);  // 300.56

Byte wrapByte = baseDouble.byteValue();
System.out.println("baseDouble.byteValue(): " + wrapByte);		// 44  -> There is no 300 in byte

Integer wrapInt = baseDouble.intValue();
System.out.println("baseDouble.intValue(): " + wrapInt);		// 300 -> The value is truncated
```

### 6.3.5 Valeurs null

Contrairement aux primitifs, les wrappers peuvent contenir **null**.  
Tenter d’unboxer `null` provoque une NullPointerException :

```java
Integer val = null;
int z = val; // ❌ NullPointerException at runtime
```

---

## 6.4 Égalité en Java

Java fournit deux mécanismes différents pour vérifier l’égalité :

- `==` (opérateur d’égalité)
- `.equals()` (méthode définie dans `Object` et redéfinie dans de nombreuses classes)

Comprendre la différence est essentiel.


### 6.4.1 Égalité avec les types primitifs

Pour les **valeurs primitives** (`int`, `double`, `char`, `boolean`, etc.),  
l’opérateur `==` compare leur **valeur numérique ou booléenne** réelle.

Exemple :
```java
int a = 5;
int b = 5;
System.out.println(a == b);     // true

char c1 = 'A';
char c2 = 65;                   // same Unicode code point
System.out.println(c1 == c2);   // true
```

#### 6.4.1.1 Points clés
- `==` effectue une **comparaison de valeur** pour les primitifs.
- Les types primitifs n’ont **pas** de méthode `.equals()`.
- Les types primitifs mixtes suivent les **règles de promotion** numérique  
  (par ex. `int == long` → `int` promu en `long`).


### 6.4.2 Égalité avec les types référence

Avec les objets (types référence), la signification de `==` change.

#### 6.4.2.1 `==` (Comparaison d’identité)  
`==` vérifie si **deux références pointent vers le même objet en mémoire**.

```java
String s1 = new String("Hi");
String s2 = new String("Hi");

System.out.println(s1 == s2);      // false → objets différents
```

Même si les contenus sont identiques, `==` est false sauf si les deux variables référencent  
**le même objet exact**.


#### 6.4.2.2 `.equals()` (Comparaison logique)  
De nombreuses classes redéfinissent `.equals()` pour comparer les **valeurs**, pas les adresses mémoire.

```java
System.out.println(s1.equals(s2)); // true → même contenu
```

#### 6.4.2.3 Points clés
- `.equals()` est définie dans `Object`.
- Si une classe ne redéfinit *pas* `.equals()`, elle se comporte comme `==`.
- Des classes comme `String`, `Integer`, `List`, etc. redéfinissent `.equals()`  
  pour fournir une comparaison de valeur pertinente.


### 6.4.3 String Pool et égalité

Les littéraux String sont stockés dans le **String pool**, donc des littéraux identiques  
référencent **le même objet**.

```java
String a = "Java";
String b = "Java";
System.out.println(a == b);       // true → même littéral dans le pool
```

Mais l’utilisation de `new` crée un objet différent :

```java
String x = new String("Java");
String y = "Java";

System.out.println(x == y);       // false → x n’est pas dans le pool
System.out.println(x.equals(y));  // true
```

Pièges courants

```java
String x = "Java string literal";
String y = " Java string literal".trim();

System.out.println(x == y);       // false → x et y ne sont pas identiques à la compilation

String a = "Java string literal";
String b = "Java ";
b += "string literal";

System.out.println(a == b);  // false
```

> [!WARNING]
> Toute String créée à **l’exécution** n’entre *pas* automatiquement dans le pool.
> Utilise `intern()` si tu veux le pooling.

> [!TIP]
> `"Hello" == "Hel" + "lo"` → true (constante à la compilation)
> 
> `"Hello" == getHello()` → false (concaténation à l’exécution)

```java
String x = "Hello";
String y = "Hel" + "lo";   // compile-time → même littéral
String z = "Hel";
z += "lo";                 // runtime → nouvelle String

System.out.println(x == y); // true
System.out.println(x == z); // false
```

#### 6.4.3.1 La méthode intern

Tu peux aussi demander à Java d’utiliser une String du String Pool (si elle existe déjà) via la méthode `intern()` :

```java
String x = "Java";
String y = new String("Java").intern();

System.out.println(x == y);       // true
```

### 6.4.4 Égalité avec les types wrapper

Les classes wrapper (`Integer`, `Double`, etc.) se comportent comme des objets :

- `==` → compare les références  
- `.equals()` → compare les valeurs  

Cependant, certains wrappers sont **mis en cache** (Integer de −128 à 127) :

```java
Integer a = 100;
Integer b = 100;
System.out.println(a == b);        // true → cached

Integer c = 1000;
Integer d = 1000;
System.out.println(c == d);        // false → not cached

System.out.println(c.equals(d));   // true → même valeur numérique
```

> [!WARNING]
> Fais très attention au caching des wrappers.


### 6.4.5 Égalité et `null`

- `== null` est toujours sûr.
- Appeler `.equals()` sur une référence `null` déclenche une `NullPointerException`.

```java
String s = null;
System.out.println(s == null);   // true
// s.equals("Hi");               // ❌ NullPointerException
```

### 6.4.6 Tableau récapitulatif

| Comparison | Primitives | Objects / Wrappers | Strings |
| --- | --- | --- | --- |
| `==` | compares **value** | compares **reference** | identity (affected by String pool) |
| `.equals()` | N/A | compares **content** if overridden | **content** comparison |
