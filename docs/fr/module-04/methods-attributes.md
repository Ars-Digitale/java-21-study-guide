# 14. Méthodes, Attributs et Variables

### Table des matières

- [14. Méthodes, Attributs et Variables](#14-méthodes-attributs-et-variables)
   - [14.1 Méthodes](#141-méthodes)
     - [14.1.1 Composants obligatoires d’une méthode](#1411-composants-obligatoires-dune-méthode)
       - [14.1.1.1 Modificateurs d’accès](#14111-modificateurs-daccès)
       - [14.1.1.2 Type de retour](#14112-type-de-retour)
       - [14.1.1.3 Nom de la méthode](#14113-nom-de-la-méthode)
       - [14.1.1.4 Signature de la méthode](#14114-signature-de-la-méthode)
       - [14.1.1.5 Corps de la méthode](#14115-corps-de-la-méthode)
     - [14.1.2 Modificateurs optionnels](#1412-modificateurs-optionnels)
     - [14.1.3 Déclarer des méthodes](#1413-déclarer-des-méthodes)
   - [14.2 Java est un langage Pass-by-Value](#142-java-est-un-langage--pass-by-value-)
   - [14.3 Surcharge des méthodes](#143-surcharge-des-méthodes)
     - [14.3.1 Appeler des méthodes surchargées](#1431-appeler-des-méthodes-surchargées)
       - [14.3.1.1 La correspondance exacte l’emporte](#14311-la-correspondance-exacte-lemporte)
       - [14.3.1.2 S’il n’existe pas de correspondance exacte Java choisit le type compatible le plus spécifique](#14312--sil-nexiste-pas-de-correspondance-exacte-java-choisit-le-type-compatible-le-plus-spécifique)
       - [14.3.1.3 L’élargissement des primitifs bat le boxing](#14313--lélargissement-des-primitifs-bat-le-boxing)
       - [14.3.1.4 Le boxing bat les varargs](#14314--le-boxing-bat-les-varargs)
       - [14.3.1.5 Pour les références Java choisit le type de référence le plus spécifique](#14315--pour-les-références-java-choisit-le-type-de-référence-le-plus-spécifique)
       - [14.3.1.6 Lorsqu’il n’y a pas de plus spécifique non ambigu l’appel est une erreur de compilation](#14316--lorsquil-ny-a-pas-de--plus-spécifique--non-ambigu-lappel-est-une-erreur-de-compilation)
       - [14.3.1.7 Surcharges mixtes primitifs + wrappers](#14317--surcharges-mixtes-primitifs--wrappers)
       - [14.3.1.8 Quand les primitifs se mélangent avec les types de référence](#14318--quand-les-primitifs-se-mélangent-avec-les-types-de-référence)
       - [14.3.1.9 Quand Object gagne](#14319--quand-object-gagne)
       - [14.3.1.10 Tableau récapitulatif de la résolution de surcharge](#143110-tableau-récapitulatif-résolution-de-la-surcharge)
   - [14.4 Variables locales et d’instance](#144-variables-locales-et-dinstance)
     - [14.4.1 Variables d’instance](#1441-variables-dinstance)
     - [14.4.2 Variables locales](#1442-variables-locales)
       - [14.4.2.1 Variables locales effectivement final](#14421-variables-locales-effectivement-final)
       - [14.4.2.2 Paramètres comme effectivement final](#14422-paramètres-comme-effectivement-final)
   - [14.5 Varargs listes d’arguments à longueur variable](#145-varargs-listes-darguments-à-longueur-variable)
   - [14.6 Méthodes statiques, variables statiques et initialiseurs statiques](#146-méthodes-statiques-variables-statiques-et-initialiseurs-statiques)
     - [14.6.1 Variables statiques (variables de classe)](#1461-variables-statiques-variables-de-classe)
     - [14.6.2 Méthodes statiques](#1462-méthodes-statiques)
     - [14.6.3 Blocs d’initialisation statique](#1463-blocs-dinitialisation-statique)
     - [14.6.4 Ordre d’initialisation statique vs instance](#1464-ordre-dinitialisation-statique-vs-instance)
     - [14.6.5 Accès aux membres statiques](#1465-accès-aux-membres-statiques)
       - [14.6.5.1 Utiliser le nom de la classe](#14651-utiliser-le-nom-de-la-classe)
       - [14.6.5.2 Via une référence d’instance](#14652-via-une-référence-dinstance)
     - [14.6.6 Statique et héritage](#1466-statique-et-héritage)
     - [14.6.7 Pièges courants](#1467-pièges-courants)

---

Ce chapitre introduit des concepts fondamentaux de la Programmation Orientée Objet (OOP) en Java, en commençant par les **méthodes**, le **passage des paramètres**, la **surcharge**, les **variables locales vs. d’instance** et les **varargs**.

## 14.1 Méthodes

Les `méthodes` représentent les **opérations/comportements** qui peuvent être effectués par un type de données particulier (une **classe**).

Elles décrivent *ce que l’objet peut faire* et comment il interagit avec son état interne et le monde extérieur.

Une `déclaration de méthode` est composée de composants **obligatoires** et **optionnels**.

### 14.1.1 Composants obligatoires d’une méthode

### 14.1.1.1 Modificateurs d’accès

Les `modificateurs d’accès` contrôlent la *visibilité*, pas le comportement.
( Se référer au paragraphe "**Access Modifiers**" dans le chapitre : [2. Basic Language Java Building Blocks](../module-01/basic-building-blocks.md) )

### 14.1.1.2 Type de retour

Apparaît **immédiatement avant** le nom de la méthode.

- Si la méthode retourne une valeur → le type de retour spécifie le type de la valeur.
- Si la méthode ne retourne *pas* de valeur → le mot-clé `void` **doit** être utilisé.
- Une méthode avec un type de retour non void **doit** contenir au moins une instruction `return valeur;`.
- Une méthode `void` peut :
-   - omettre une instruction return
-   - inclure `return;` (sans **aucune** valeur)

### 14.1.1.3 Nom de la méthode

Suit les mêmes règles que les identificateurs ( Se référer au chapitre : [3. Java Naming Rules](../module-01/naming-rules.md) ).

### 14.1.1.4 Signature de la méthode

La **signature de la méthode** en Java inclut :

- le *nom de la méthode*
- la *liste des types de paramètres* (types + ordre)

!!! note
    Les **noms des paramètres NE font PAS partie de la signature**, seuls les types et l’ordre comptent.

- Exemple de signatures distinctes :

```java
void process(int x)
void process(int x, int y)
void process(int x, String y)
```

- Exemple de *même* signature (surcharge illégale) :

```java
// ❌ même signature : seuls les noms des paramètres diffèrent
void m(int a)
void m(int b)
```

### 14.1.1.5 Corps de la méthode

Un bloc `{ }` contenant **zéro ou plusieurs instructions**.
Si la méthode est `abstract`, le corps doit être omis.


### 14.1.2 Modificateurs optionnels

Les modificateurs optionnels de méthode incluent :

- `static`
- `abstract`
- `final`
- `default` (méthodes d’interface)
- `synchronized`
- `native`
- `strictfp`

Règles :

- Les modificateurs optionnels peuvent apparaître dans **n’importe quel ordre**.
- Tous les modificateurs doivent apparaître **avant le type de retour**.

- Exemple :

```java
public static final int compute() {
    return 10;
}
```


### 14.1.3 Déclarer des méthodes

```java
public final synchronized String formatValue(int x, double y) throws IOException {
    return "Result: " + x + ", " + y;
}
```

Décomposition :

| Partie | Signification |
| --- | --- |
| public | modificateur d’accès |
| final | ne peut pas être redéfinie |
| synchronized | modificateur de contrôle des threads |
| String | type de retour |
| formatValue | nom de la méthode |
| (int x, double y) | liste des paramètres |
| throws IOException | liste des exceptions |
| method body | implémentation |

---

## 14.2 Java est un langage « Pass-by-Value »

Java utilise **uniquement le pass-by-value**, sans exception.

Cela signifie :

- Pour les **types primitifs** → la méthode reçoit une *copie de la valeur*.
- Pour les **types référence** → la méthode reçoit une *copie de la référence*, ce qui signifie :
-   - la référence elle-même ne peut pas être modifiée par la méthode
-   - l’*objet* **peut** être modifié via cette référence

- Exemple :

```java
void modify(int a, StringBuilder b) {
    a = 50;           // modification de la *copie* → aucun effet à l’extérieur
    b.append("!");    // modification de l’*objet* → visible à l’extérieur
}
```

```java
public static void main(String[] args) {
    
	int num1 = 11;
	methodTryModif(num1);
	System.out.println(num1);
	
}

public static void methodTryModif(int num1){	
	num1 = 10;  // cette nouvelle affectation concerne uniquement le paramètre du méthode qui, accidentellement, porte le même nom que la variable externe.
}
```

---

## 14.3 Surcharge des méthodes

La surcharge des méthodes signifie **même nom de méthode**, **signature différente**.

Deux méthodes sont considérées comme surchargées si elles diffèrent par :

- le nombre de paramètres
- les types des paramètres
- l’ordre des paramètres

La surcharge **NE dépend PAS de** :

- le type de retour
- le modificateur d’accès
- les exceptions

- Exemple :

```java
void print(int x)
void print(double x)
void print(int x, int y)
```

Méthode surchargée illégale :

```java
// ❌ Le type de retour ne compte pas dans la surcharge
int compute(int x)
double compute(int x)
```

### 14.3.1 Appeler des méthodes surchargées

Lorsque plusieurs méthodes surchargées sont disponibles, Java applique la **résolution de surcharge** pour décider quelle méthode appeler.
  
Le compilateur sélectionne la méthode dont les types de paramètres sont les **plus spécifiques** et **compatibles** avec les arguments fournis.

La résolution de surcharge a lieu **au moment de la compilation** (contrairement à l’overriding, qui est basé sur l’exécution).

Java suit ces règles :


### 14.3.1.1 La correspondance exacte l’emporte

Si un argument correspond exactement à un paramètre de méthode, cette méthode est choisie.

```java
void call(int x)    { System.out.println("int"); }
void call(long x)   { System.out.println("long"); }

call(5); // affiche : int (correspondance exacte pour int)
```


### 14.3.1.2 — S’il n’existe pas de correspondance exacte, Java choisit le type compatible *le plus spécifique*

Java préfère :

- **l’élargissement** plutôt que l’autoboxing
- **l’autoboxing** plutôt que les varargs
- **le type de référence plus large** uniquement si un type plus spécifique n’est pas disponible

- Exemple avec des primitifs numériques :

```java
void test(long x)   { System.out.println("long"); }
void test(float x)  { System.out.println("float"); }

test(5);  // littéral int : peut être élargi en long ou float
          // mais long est plus spécifique que float pour les types entiers
          // Output : long
```


### 14.3.1.3 — L’élargissement des primitifs bat le boxing

Si un argument primitif peut être soit élargi soit autoboxé, Java choisit l’élargissement.

```java
void m(int x)       { System.out.println("int"); }
void m(Integer x)   { System.out.println("Integer"); }

byte b = 10;
m(b);               // byte → int (élargissement) l’emporte
                    // Output : int
```


### 14.3.1.4 — Le boxing bat les varargs

```java
void show(Integer x)    { System.out.println("Integer"); }
void show(int... x)     { System.out.println("varargs"); }

show(5);                // int → Integer (boxing) préféré
                        // Output : Integer
```


### 14.3.1.5 — Pour les références, Java choisit le type de référence le plus spécifique

```java
void ref(Object o)      { System.out.println("Object"); }
void ref(String s)      { System.out.println("String"); }

ref("abc");             // "abc" est une String → plus spécifique que Object
                        // Output : String
```

Plus spécifique signifie *plus bas dans la hiérarchie d’héritage*.


### 14.3.1.6 — Lorsqu’il n’y a pas de « plus spécifique » non ambigu, l’appel est une erreur de compilation

Exemple avec des classes sœurs :

```java
void check(Number n)      { System.out.println("Number"); }
void check(String s)      { System.out.println("String"); }

check(null);    // String et Number acceptent null
                // String est plus spécifique car c’est une classe concrète
                // Output : String
```

Mais si deux classes non liées entrent en concurrence :

```java
void run(String s)   { }
void run(Integer i)  { }

run(null);  // ❌ Erreur à la compilation : appel de méthode ambigu
```


### 14.3.1.7 — Surcharges mixtes primitifs + wrappers

Java évalue l’élargissement, le boxing et les varargs dans cet ordre :

**`élargissement → boxing → varargs`**

- Exemple :

```java
void mix(long x)        { System.out.println("long"); }
void mix(Integer x)     { System.out.println("Integer"); }
void mix(int... x)      { System.out.println("varargs"); }

short s = 5;
mix(s);   // short → int → long  (élargissement)
          // boxing et varargs ignorés
          // Output : long
```


### 14.3.1.8 — Quand les primitifs se mélangent avec les types de référence

```java
void fun(Object o)     { System.out.println("Object"); }
void fun(int x)        { System.out.println("int"); }

fun(10);                // la correspondance primitive exacte l’emporte
                        // Output : int

Integer i = 10;
fun(i);                 // référence acceptée → Object
                        // Output : Object
```


### 14.3.1.9 — Quand Object gagne

```java
void fun(List<String> o)    { System.out.println("O"); }
void fun(CharSequence x)    { System.out.println("X"); }
void fun(Object y)        	{ System.out.println("Y"); }

fun(LocalDate.now());       // Output : Y
```


### 14.3.1.10 Tableau récapitulatif (Résolution de la surcharge)

| Situation | Règle |
| --- | --- |
| Correspondance exacte | Toujours choisie |
| Élargissement primitif vs boxing | L’élargissement l’emporte |
| Boxing vs varargs | Le boxing l’emporte |
| Type de référence le plus spécifique | L’emporte |
| Types de référence non liés | Ambigu → erreur de compilation |
| Primitif + wrapper mélangés | Élargissement → boxing → varargs |

---

## 14.4 Variables locales et d’instance

### 14.4.1 Variables d’instance

Les variables d’instance sont :

- déclarées comme membres d’une classe
- créées lorsqu’un objet est instancié
- accessibles par toutes les méthodes de l’instance

Modificateurs possibles pour les variables d’instance :

- modificateurs d’accès (`public`, `protected`, `private`)
- `final`
- `volatile`
- `transient`

- Exemple :

```java
public class Person {
    private String name;         // variable d’instance
    protected final int age = 0; // final signifie ne peut pas être réaffectée
}
```


### 14.4.2 Variables locales

Les variables locales :

- sont déclarées *à l’intérieur* d’une méthode, d’un constructeur ou d’un bloc
- n’ont **aucune valeur par défaut** → doivent être explicitement initialisées avant utilisation
- seul modificateur autorisé : **final**

- Exemple :

```java
void calculate() {
    int x;        // déclarée
    x = 10;       // doit être initialisée avant utilisation

    final int y = 5;  // légal
}
```

Deux cas particuliers :


### 14.4.2.1 Variables locales effectivement final
 
Une variable locale est *effectivement final* si elle est **assignée une seule fois**, même sans `final`.

Les variables effectivement final peuvent être utilisées dans :

- expressions lambda
- classes locales/anonimes


### 14.4.2.2 Paramètres comme effectivement final

Les paramètres de méthode se comportent comme des variables locales et suivent les mêmes règles.

---

## 14.5 Varargs (Listes d’arguments à longueur variable)

Les varargs permettent à une méthode d’accepter **zéro ou plusieurs** paramètres du même type.

Syntaxe :

```java
void printNames(String... names)
```

Règles :

- Une méthode peut avoir **un seul** paramètre varargs.
- Il doit être le **dernier** paramètre dans la liste.
- Les varargs sont traités comme un **tableau** à l’intérieur de la méthode.

- Exemple :

```java
void show(int x, String... values) {
    System.out.println(values.length);
}

show(10);                     // length = 0
show(10, "A");                // length = 1
show(10, "A", "B", "C");      // length = 3
```

!!! important
    Les varargs et les tableaux participent à la surcharge des méthodes.
    La résolution de la surcharge peut devenir ambiguë.

---

## 14.6 Méthodes statiques, variables statiques et initialiseurs statiques

En Java, le mot-clé **`static`** marque des éléments qui **appartiennent à la classe elle-même**, et non aux instances individuelles.
Cela signifie :

- Ils sont **chargés une seule fois** en mémoire lorsque la classe est chargée pour la première fois par la JVM.
- Ils sont partagés entre **toutes les instances**.
- Ils peuvent être accessibles **sans créer d’objet** de la classe.

Les membres statiques sont stockés dans la **method area** de la JVM (mémoire au niveau de la classe), tandis que les membres d’instance vivent dans le **heap**.


### 14.6.1 Variables statiques (Variables de classe)

Une **variable statique** est une variable définie au niveau de la classe et partagée par toutes les instances.

Caractéristiques :

- Créées lorsque la classe est chargée.
- Existent **même si aucune instance** de la classe n’est créée.
- Tous les objets voient la **même valeur**.
- Peuvent être marquées `final`, `volatile` ou `transient`.

- Exemple :

```java
public class Counter {
    static int count = 0;    // partagée par toutes les instances
    int id;                  // variable d’instance

    public Counter() {
        count++;
        id = count;          // chaque instance obtient un id unique
    }
}
```


### 14.6.2 Méthodes statiques

Une **méthode statique** appartient à la classe, et non à une instance d’objet.

Règles :

- Elles peuvent être appelées en utilisant le nom de la classe : `ClassName.method()`.
- Elles **ne peuvent pas** accéder directement aux variables ou méthodes d’instance, mais uniquement via une instance de la classe.
- Elles **ne peuvent pas** utiliser `this` ou `super`.
- Elles sont couramment utilisées pour :
-   - des méthodes utilitaires (ex. `Math.sqrt()`)
-   - des méthodes de fabrique
-   - des comportements globaux qui ne dépendent pas de l’état d’instance

- Exemple :

```java
public class MathUtil {

    static int square(int x) {        // méthode statique
        return x * x;
    }

    void instanceMethod() {
        // System.out.println(count);   // OK : accès à une variable statique
        // square(5);                   // OK : méthode statique accessible
    }
}
```

Erreurs courantes :

```java
// ❌ Erreur de compilation : une méthode d’instance ne peut pas être appelée directement dans un contexte statique
static void go() {
    run();        // run() est une méthode d’instance !
}

void run() { }
```


### 14.6.3 Blocs d’initialisation statique

Les blocs d’initialisation statique permettent d’exécuter du code **une seule fois**, lorsque la classe est chargée.

Syntaxe :

```java
static {
    // logique d’initialisation
}
```

Utilisation :

- initialisation de variables statiques complexes
- exécution d’un setup au niveau de la classe
- exécution de code qui doit être exécuté exactement une fois

- Exemple :

```java
public class Config {

    static final Map<String, String> settings = new HashMap<>();

    static {
        settings.put("mode", "production");
        settings.put("version", "1.0");
        System.out.println("Static initializer executed");
    }
}
```

!!! important
    Les blocs d’initialisation statique s’exécutent **une seule fois**, dans l’ordre où ils apparaissent, avant `main()` et avant qu’une méthode statique ne soit appelée.


### 14.6.4 Ordre d’initialisation (Statique vs. Instance)

( Se référer au chapitre : [15. Class Loading, Initialization, and Object Construction](class-loading.md) )


### 14.6.5 Accès aux membres statiques

### 14.6.5.1 Utiliser le nom de la classe

```java
Math.sqrt(16);
MyClass.staticMethod();
```


### 14.6.5.2 Via une référence d’instance

```java
MyClass obj = new MyClass();
obj.staticMethod();
```


### 14.6.6 Statique et héritage

Les méthodes statiques :

- peuvent être **masquées**, pas redéfinies
- le binding est **à la compilation**, pas à l’exécution
- sont accessibles selon le **type de la référence**, et non le type de l’objet

- Exemple :

```java
class A {
    static void test() { System.out.println("A"); }
}

class B extends A {
    static void test() { System.out.println("B"); }
}

A ref = new B();
ref.test();   // affiche "A" — binding statique !
```

!!! note
    Règle clé : les méthodes statiques utilisent le **type de la référence**, et non le type de l’objet.


### 14.6.7 Pièges courants

- Tenter de référencer une variable ou une méthode d’instance depuis un contexte statique.
- Supposer que les méthodes statiques sont redéfinies → elles sont **masquées**.
- Appeler une méthode statique via une référence d’instance (légal mais déroutant).
- Confondre l’ordre d’initialisation des éléments statiques et des éléments d’instance.
- Oublier que les variables statiques sont partagées entre tous les objets.
- Ignorer que les initialiseurs statiques s’exécutent *une seule fois*, dans l’ordre de déclaration.

