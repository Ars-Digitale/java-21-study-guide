# 2. Blocs de base du langage Java

<a id="table-des-matières"></a>
### Table des matières


- [2.1 Définition de classe](#21-définition-de-classe)
- [2.2 Commentaires](#22-commentaires)
- [2.3 Modificateurs d’accès](#23-modificateurs-daccès)
- [2.4 Packages](#24-packages)
	- [2.4.1 Organisation et objectif](#241-organisation-et-objectif)
	- [2.4.2 Correspondance avec le système de fichiers et déclaration d’un package](#242-correspondance-avec-le-système-de-fichiers-et-déclaration-dun-package)
	- [2.4.3 Appartenir au même package](#243-appartenir-au-même-package)
	- [2.4.4 Importer depuis un package](#244-importer-depuis-un-package)
	- [2.4.5 Imports statiques](#245-imports-statiques)
		- [2.4.5.1 Règles de précédence](#2451-règles-de-précédence)
	- [2.4.6 Packages standard vs. packages définis par l’utilisateur](#246-packages-standard-vs-packages-définis-par-lutilisateur)
- [2.5 La méthode main](#25-la-méthode-main)
	- [2.5.1 Signature de la méthode main](#251-signature-de-la-méthode-main)
- [2.6 Compiler et exécuter le code](#26-compiler-et-exécuter-le-code)
	- [2.6.1 Compiler un fichier, package par défaut (répertoire unique)](#261-compiler-un-fichier-package-par-défaut-répertoire-unique)
	- [2.6.2 Plusieurs fichiers, package par défaut (répertoire unique)](#262-plusieurs-fichiers-package-par-défaut-répertoire-unique)
	- [2.6.3 Code dans des packages (organisation standard src → out)](#263-code-dans-des-packages-organisation-standard-src--out)
	- [2.6.4 Compiler vers un autre répertoire (-d)](#264-compiler-vers-un-autre-répertoire--d)
	- [2.6.5 Plusieurs fichiers sur plusieurs packages (compiler tout l’arbre des sources)](#265-plusieurs-fichiers-sur-plusieurs-packages-compiler-tout-larbre-des-sources)
	- [2.6.6 Exécution d’un fichier source unique (lancement rapide sans javac)](#266-exécution-dun-fichier-source-unique-lancement-rapide-sans-javac)
	- [2.6.7 Passer des paramètres à un programme Java](#267-passer-des-paramètres-à-un-programme-java)


---

Ce chapitre présente les éléments structurels essentiels d’un programme Java :  
`classes`, `méthodes`, `commentaires`, `modificateurs d’accès`, `packages`, la méthode `main` et les outils de base en ligne de commande (`javac` et `java`).

Ce sont les éléments minimaux nécessaires pour écrire, compiler, organiser et exécuter du code Java à l’aide du JDK (Java Development Kit) — sans utiliser aucun IDE (Integrated Development Environment).

<a id="21-définition-de-classe"></a>
## 2.1 Définition de classe

Une `class` Java est le bloc fondamental d’un programme Java.
  
Une `classe` représente un **type de donnée défini par l’utilisateur**, constitué d’un ensemble de données internes (`fields`) et des opérations pouvant agir sur celles-ci (`methods`).

Une `class` est un **plan** (blueprint), tandis que les `objects` sont des **instances concrètes** créées à l’exécution.

Une classe Java est composée de deux éléments principaux, appelés ses **membres**:

- **Fields** (ou variables): représentent les données qui définissent l’état de ce nouveau type.
- **Methods** (ou fonctions): représentent les opérations qui peuvent être effectuées sur ces données.

Certains membres peuvent être déclarés avec le mot-clé **static**.

Un membre static appartient à la classe elle-même, et non aux objets créés à partir d’elle.

Cela signifie que :

- il existe une seule copie partagée entre toutes les instances
- il peut être utilisé sans créer un objet de la classe
- il est chargé en mémoire lorsque la classe est chargée par la JVM

Les membres non static (appelés **d’instance**) appartiennent en revanche aux objets individuels et chaque instance possède sa propre copie.

Normalement, chaque classe est définie dans son propre fichier "**.java**" ; par exemple, une classe nommée `Person` sera définie dans le fichier correspondant `Person.java`.

Toute classe définie indépendamment dans son propre fichier source est appelée **top-level class**.

Une telle classe ne peut être déclarée que `public` ou avec le modificateur d’accès par défaut (`package-private`, c’est-à-dire sans modificateur explicite).

Un seul fichier peut cependant contenir plusieurs définitions de classe.  
**Dans ce cas, une seule classe peut être déclarée `public`, et le nom du fichier doit correspondre à cette classe.**

Les **nested classes**, c’est-à-dire les classes déclarées à l’intérieur d’une autre classe, peuvent utiliser n’importe quel modificateur d’accès : `public`, `protected`, `private`, `default` (package-private).

- Exemple :

```java
public class Person {

    // This is a comment: explains the code but is ignored by the compiler. See section below.

    // Field → defines data/state
    String personName;

    // Method → defines behavior (this one take a parameter, newName, in input but does not return a value)
    void setPersonName(String newName) {
        personName = newName;
    }

    // Method → defines behavior  (this one does not take parameters in input but does return a String)
    String getPersonName(){
        return personName;
    }
}
```

!!! note
    Dans sa forme la plus simple, on pourrait théoriquement avoir une classe sans méthode et sans field. Une telle classe se compilerait, mais aurait très peu de sens pratique.

| Token / Identifier | Category | Meaning | Optional? |
| --- | --- | --- | --- |
| public | Keyword / access modifier | détermine quelles autres classes peuvent utiliser ou voir cet élément | Mandatory (lorsqu’il est absent, l’accès est par défaut package-private) |
| class | Keyword | Déclare un type de classe. | Mandatory |
| Person | Class name (identifier) | Le nom de la classe. | Mandatory |
| personName | Field name (identifier) | Stocke le nom de la personne. | Optional |
| String | Type / Keyword | Type du field `personName` et du paramètre `newName`. | Mandatory |
| setPersonName, getPersonName | Method names (identifier) | nomment un comportement de la classe. | Optional |
| newName | Parameter name (identifier) | paramètre passé à la méthode `setPersonName`. | Mandatory (si la méthode a besoin d’un paramètre) |
| return | Keyword | Quitte une méthode et renvoie une valeur. | Mandatory (dans les méthodes avec type de retour non void) |
| void | Return Type / Keyword | Indique que la méthode ne renvoie aucune valeur. | Mandatory (si la méthode ne renvoie pas de valeur) |

!!! note
    Mandatory = requis par la syntaxe Java,
    Optional = non requis par la syntaxe ; dépend du design.

---

<a id="22-commentaires"></a>
## 2.2 Commentaires

Les commentaires ne sont pas du code exécutable : ils **expliquent** le code mais sont ignorés par le compilateur.

En Java, il existe 3 types de commentaires :
- Single-line (`//`)
- Multi-line (`/* ... */`)
- Javadoc (`/** ... */`)

Un **single-line comment** commence par 2 barres obliques : tout le texte qui suit sur la même ligne est ignoré par le compilateur.

- Exemple :

```java
// This is a single-line comment. It starts with 2 slashes and ends at the end of the line. 
```

Un **multiline comment** inclut tout ce qui se trouve entre les symboles `/*` et `*/`.

- Exemple :

```java
/* 	
 * This is a multi-line comment.
 * It can span multiple lines.
 * All the text between its opening and closing symbols is ignored by the compiler.
 *
 */
```

Un **commentaire Javadoc** est similaire à un **multiline comment**, sauf qu’il commence par `/**` : tout le texte entre les symboles d’ouverture et de fermeture est traité par l’outil Javadoc pour générer la documentation d’API.

```java
/**
 * This is a Javadoc comment
 *
 * This class represents a Person.
 * It stores a name and provides methods
 * to set and retrieve it.
 *
 * <p>Javadoc comments can include HTML tags,
 * and special annotations like @param and @return.</p>
 */
```

!!! warning
    En Java, chaque block comment doit être correctement fermé avec `*/`.

- Exemple :

```java
/* valid block comment */
```

est correct, mais

```java
/* */ */
```

provoquera une erreur de compilation, car les deux premiers symboles font partie du commentaire, mais le dernier non. Le symbole supplémentaire `*/` n’est pas une syntaxe valide et le compilateur se plaindra.

---

<a id="23-modificateurs-daccès"></a>
## 2.3 Modificateurs d’accès

En Java, un **modificateur d’accès** (access modifier) est un mot-clé qui spécifie la visibilité (ou accessibilité) d’une **classe**, d’une **méthode** ou d’un **champ**. Il détermine quelles autres classes peuvent utiliser ou voir cet élément.

!!! note
    **Table des modificateurs d’accès disponibles en Java**

| Token / Identifier | Category | Meaning | Optional? |
| --- | --- | --- | --- |
| public | Keyword / access modifier | Visible depuis n’importe quelle classe, dans n’importe quel package | Oui |
| no modifier (default) | Keyword / access modifier | Visible uniquement à l’intérieur du même package | Oui |
| protected | Keyword / access modifier | Visible dans le même package et par les sous-classes (même dans d’autres packages) | Oui |
| private | Keyword / access modifier | Visible uniquement à l’intérieur de la même classe | Oui |

!!! tip
    **private > default > protected > public**
    Pense que la “visibilité s’étend vers l’extérieur”.

---

<a id="24-packages"></a>
## 2.4 Packages

Les **packages Java** sont des regroupements logiques de classes, d’interfaces et de sous-packages.  
Ils aident à organiser de grands codebases, à éviter les conflits de noms et à contrôler l’accès entre différentes parties d’une application.

<a id="241-organisation-et-objectif"></a>
### 2.4.1 Organisation et objectif

- La dénomination des packages suit les mêmes règles que les noms de variables. Voir : *Java Naming Rules*.  
- Les packages sont comme des **dossiers** pour votre code source Java.  
- Ils permettent de regrouper des classes liées entre elles (par exemple toutes les utilitaires dans `java.util`, toutes les classes réseau dans `java.net`).  
- En utilisant les packages, vous pouvez éviter les **conflits de noms** : par exemple, vous pouvez avoir deux classes nommées `Date`, l’une `java.util.Date` et l’autre `java.sql.Date`.

<a id="242-correspondance-avec-le-système-de-fichiers-et-déclaration-dun-package"></a>
### 2.4.2 Correspondance avec le système de fichiers et déclaration d’un package

- Les packages correspondent directement à la **hiérarchie de répertoires** sur le système de fichiers.
- Vous déclarez le package en haut du fichier source (**avant tout import**).
- Si vous ne déclarez pas de package, la classe appartient au package par défaut.
  - Ceci n’est pas recommandé pour des projets réels, car cela complique l’organisation et les imports.

- Exemple :

```java
package com.example.myapp.utils;

public class MyApp{

}
```

!!! important
    Cette déclaration signifie que la classe doit être située dans le répertoire : **com/example/myapp/utils/MyApp.java**

<a id="243-appartenir-au-même-package"></a>
### 2.4.3 Appartenir au même package

Deux classes appartiennent au même package si et seulement si :

- Elles sont déclarées avec la même instruction `package` en haut de leur fichier source.
- Elles se trouvent dans le même répertoire de la hiérarchie des sources.

- Exemple :

Une classe dans le package `A.B.C` appartient uniquement à `A.B.C`, pas à `A.B`.  
Les classes dans `A.B` ne peuvent pas accéder directement aux membres **package-private** des classes de `A.B.C`, car il s’agit de packages différents.

Les classes dans le même package :

- Peuvent accéder aux membres package-private les unes des autres (c’est-à-dire les membres sans modificateur d’accès explicite).
- Partagent le même espace de noms, donc il n’est pas nécessaire de les importer pour les utiliser.

Exemple : deux fichiers dans le même package

```java
// File: src/com/example/tools/Tool.java
package com.example.tools;

public class Tool {
    static void hello() { System.out.println("Hi!"); }
}
```

```java
// File: src/com/example/tools/Runner.java
package com.example.tools;

public class Runner {
    public static void main(String[] args) {
        Tool.hello();    // OK : même package, aucun import nécessaire
    }
}
```

<a id="244-importer-depuis-un-package"></a>
### 2.4.4 Importer depuis un package

Pour utiliser des classes provenant d’un autre package, vous devez les importer :

- Exemple :

```java
import java.util.List;       // importe une classe spécifique
import java.util.*;          // importe toutes les classes dans java.util

import java.nio.file.*.*     // ERROR! only one wildcard is allowed and it must be at the end!
```

!!! note
    Le caractère wildcard `*` importe tous les types du package, mais pas ses sous-packages.

Vous pouvez toujours utiliser le nom complètement qualifié (fully qualified name) au lieu d’importer toutes les classes du package :

```java
java.util.List myList = new java.util.ArrayList<>();
```

!!! note
    Si vous importez explicitement un nom de classe, il est prioritaire sur tout import avec wildcard ;
    si vous voulez utiliser deux classes ayant le même nom (par exemple `Date` de `java.util` et de `java.sql`), il est préférable d’utiliser un import avec nom entièrement qualifié.

<a id="245-imports-statiques"></a>
### 2.4.5 Imports statiques

En plus d’importer des classes depuis un package, Java permet un autre type d’import : l’**import statique**.  
Un *static import* permet d’importer les **membres statiques** d’une classe — tels que des méthodes statiques et des variables statiques — afin de les utiliser **sans faire référence au nom de la classe**.

Vous pouvez importer des membres statiques **spécifiques** ou utiliser un **wildcard** pour importer tous les membres statiques d’une classe.

Exemple — import statique spécifique

```java
import static java.util.Arrays.asList;   // Imports Arrays.asList()

public class Example {

    List<String> arr = asList("first", "second");
    // We can call asList() directly, without using Arrays.asList()
}
```

Exemple — import statique d’une constante

```java
import static java.lang.Math.PI;
import static java.lang.Math.sqrt;

public class Circle {
    double radius = 3;

    double area = PI * radius * radius;
    double diagonal = sqrt(2); 
}
```

Exemple — import statique avec wildcard

```java
import static java.lang.Math.*;

public class Calculator {
    double x = sqrt(49);   // 7.0
    double y = max(10, 20); 
    double z = random();   // calls Math.random()
}
```

Les imports statiques avec wildcard se comportent exactement comme les imports normaux avec wildcard :  
ils mettent **tous les membres statiques** de la classe dans la portée courante.

!!! warning
    Vous pouvez **toujours** appeler un membre statique avec le nom de la classe :
    `Math.sqrt(16)` fonctionne toujours — même si le membre a été importé statiquement.

<a id="2451-règles-de-précédence"></a>
#### 2.4.5.1 Règles de précédence

Si la classe courante déclare déjà une méthode ou une variable portant le même nom qu’un membre importé statiquement :

- Le **membre local est prioritaire**.
- Le membre statique importé est **masqué** (shadowing).

Exemple :

```java
import static java.lang.Math.max;

public class Test {

    static int max(int a, int b) {   // version locale
        return a > b ? a : b;
    }

    void run() {
        System.out.println(max(2, 5));  
        // Appelle la version LOCALE de max(), pas Math.max()
    }
}
```

!!! warning
    - Un import statique doit toujours respecter exactement la syntaxe : `import static`.
    - Le compilateur interdit d’importer **deux membres statiques portant le même simple name** si cela crée une ambiguïté — même s’ils proviennent de classes ou de packages différents.

Exemple — **Non autorisé** :

```java
import static java.util.Collections.emptyList;
import static java.util.List.of;

// ❌ ERROR: both methods have the same name `of()`
import static java.util.Set.of;
```

Le compilateur ne sait pas quel `of()` vous souhaitez appeler → échec de compilation.

!!! tip
    - Si deux imports statiques introduisent le même nom, **toute tentative d’utiliser ce nom provoque une erreur de compilation**.
    - Les imports statiques **n’importent pas les classes**, seulement les membres statiques.  
    - Vous pouvez toujours appeler le membre statique avec le nom de la classe, même s’il est importé statiquement.

Exemple :

```java
import static java.lang.Math.sqrt;

double a = sqrt(16);        // import statique
double b = Math.sqrt(25);   // fully qualified — toujours autorisé
```

<a id="246-packages-standard-vs-packages-définis-par-lutilisateur"></a>
### 2.4.6 Packages standard vs packages définis par l’utilisateur

- **Packages standard** : fournis avec le JDK (par ex. `java.lang`, `java.util`, `java.io`).  
- **Packages définis par l’utilisateur** : créés par les développeurs pour organiser le code de l’application.

---

<a id="25-la-méthode-main"></a>
## 2.5 La méthode `main`

En Java, la méthode `main` sert de **point d’entrée** à une application autonome.  
Sa déclaration correcte est cruciale pour que la JVM puisse la reconnaître.

<a id="251-signature-de-la-méthode-main"></a>
### 2.5.1 Signature de la méthode main

Observons la signature de la méthode `main` dans deux des classes les plus simples possibles :

- Exemple : sans modificateurs optionnels

```java
public class MainFirstExample {

    public static void main(String[] args){

        System.out.print("Hello World!!");

    }

}
```

- Exemple : avec les deux modificateurs optionnels `final`

```java
public class MainSecondExample {

    public final static void main(final String options[]){

        System.out.print("Hello World!!");

    }

}
```

!!! note
    **Table des modificateurs pour la méthode main**

| Token / Identifier | Category | Meaning | Optional? |
| --- | --- | --- | --- |
| public | Keyword / Access Modifier | Rend la méthode accessible depuis n’importe où. Nécessaire pour que la JVM puisse l’appeler depuis l’extérieur de la classe. | Mandatory |
| static | Keyword | Signifie que la méthode appartient à la classe elle-même et peut être appelée sans créer d’objet. Nécessaire car la JVM n’a aucune instance au démarrage du programme. | Mandatory |
| final (before return type) | Modifier | Empêche la méthode d’être redéfinie (overridden). Peut apparaître légalement avant le type de retour, mais n’a aucun effet particulier sur `main` et n’est pas requis. | Optional |
| main | Method name (predefined) | Nom exact que la JVM recherche comme point d’entrée du programme. Doit être écrit exactement `main` (en minuscules). | Mandatory |
| void | Return Type / Keyword | Déclare que la méthode ne renvoie aucune valeur à la JVM. | Mandatory |
| String[] args | Parameter list | Tableau de `String` qui contient les arguments de ligne de commande passés au programme. Peut aussi s’écrire `String args[]` ou `String... args`. Le nom du paramètre (`args`) est arbitraire. | Mandatory (le type du paramètre est requis, le nom peut varier) |
| final (in parameter) | Modifier | Marque le paramètre comme non réaffectable à l’intérieur du corps de la méthode (vous ne pouvez pas réassigner `args` vers un autre tableau). | Optional |

!!! important
    Les modificateurs `public`, `static` (obligatoires) et `final` (s’il est présent) peuvent être permutés ; `public` et `static` ne peuvent pas être omis.
    
    Java considère `String[] args` et `String... args` comme équivalents.  
    Les deux variantes compilent et fonctionnent correctement comme points d’entrée.

---

<a id="26-compiler-et-exécuter-le-code"></a>
## 2.6 Compiler et exécuter le code

Cette section présente des commandes `javac` et `java` **correctes et fonctionnelles** pour des situations courantes en Java 21 : fichiers uniques, plusieurs fichiers, packages, répertoires de sortie séparés, utilisation du classpath/module-path.

Suivez exactement l’organisation des répertoires.

> check your tools

```bash
javac -version   # should print: javac 21.x
java  -version   # should print: java version "21.0.7" ... (the output could be different depending on the implementation of the jvm you installed)
```

!!! warning
    Lors de l’exécution d’une classe à l’intérieur d’un package, **java exige le nom complètement qualifié**, JAMAIS le chemin :
    
    `java com.example.app.Main` ✔  
    `java src/com/example/app/Main` ❌

<a id="261-compiler-un-fichier-package-par-défaut-répertoire-unique"></a>
### 2.6.1 Compiler un fichier, package par défaut (répertoire unique)

**Fichiers**
```text
.
└── Hello.java
```

**Hello.java**
```java
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, Java 21!");
    }
}
```

**Compiler (dans le même répertoire)**

```bash
javac Hello.java
```

Cette commande va créer, dans le même répertoire, un fichier portant le même nom que le fichier ".java" mais avec l’extension ".class" ; c’est le fichier de bytecode qui sera interprété et exécuté par la JVM.

Une fois que vous avez le fichier `.class`, dans ce cas `Hello.class`, vous pouvez lancer le programme avec :

**Exécution**

```bash
java Hello
```

!!! important
    Vous n’avez pas à préciser l’extension ".class" lors de l’exécution du programme.

<a id="262-plusieurs-fichiers-package-par-défaut-répertoire-unique"></a>
### 2.6.2 Plusieurs fichiers, package par défaut (répertoire unique)

**Fichiers**
```text
.
├── A.java
└── B.java
```

**Tout compiler**
```bash
javac *.java
```

Ou, si les classes appartiennent à un package spécifique :

```bash
javac packagex/*.java
```

Ou en les spécifiant explicitement :

```bash
javac A.java B.java
```

et

```bash
javac packagex/A.java packagey/B.java
```

**Exécuter le point d’entrée** : la classe qui possède une méthode `main`

```bash
java A    # si A possède main(...)
# ou
java B
```

!!! important
    Le chemin vers vos classes correspond, en Java, au **classpath**. Vous pouvez spécifier le **classpath** avec l’une des options suivantes :
    
    - `-cp <classpath>`  
    - `-classpath <classpath>`  
    - `--class-path <classpath>`

<a id="263-code-dans-des-packages-organisation-standard-src--out"></a>
### 2.6.3 Code dans des packages (organisation standard src → out)

**Fichiers**
```text
.
├── src/
│   └── com/
│       └── example/
│           └── app/
│               └── Main.java
└── out/
```

!!! note
    Les dossiers `src` et `out` ne font pas partie de nos packages : ce sont simplement les répertoires qui contiennent tous les fichiers source et les fichiers `.class` compilés.

**Main.java**

```java
package com.example.app;

public class Main {
    public static void main(String[] args) {
        System.out.println("Packages done right.");
    }
}
```

**Compiler dans le même répertoire**

```bash
# Crée le fichier .class juste à côté du fichier source
javac src/com/example/app/Main.java
```

<a id="264-compiler-vers-un-autre-répertoire--d"></a>
### 2.6.4 Compiler vers un autre répertoire (`-d`)

L’option `-d out` place les fichiers `.class` compilés dans le répertoire `out/`, en créant des sous-dossiers qui reflètent les noms de packages :

```bash
javac -d out -sourcepath src src/com/example/app/Main.java
```

**Exécution (utiliser le classpath pointant sur out/)**

```bash
# Unix/macOS
java -cp out com.example.app.Main

# Windows
java -cp out com.example.app.Main
```

<a id="265-plusieurs-fichiers-sur-plusieurs-packages-compiler-tout-larbre-des-sources"></a>
### 2.6.5 Plusieurs fichiers sur plusieurs packages (compiler tout l’arbre des sources)

**Fichiers**
```text
.
├── src/
│   └── com/
│       └── example/
│           ├── util/
│           │   └── Utils.java
│           └── app/
│               └── Main.java
└── out/
```

**Compiler tout l’arbre des sources dans `out/`**

```bash
# Option A : indiquer à javac les packages de plus haut niveau
javac -d out   src/com/example/util/Utils.java   src/com/example/app/Main.java

# Option B : utiliser -sourcepath pour laisser javac trouver les dépendances
javac -d out -sourcepath src   src/com/example/app/Main.java
```

!!! important
    `-sourcepath <sourcepath>` indique à `javac` où chercher d’autres fichiers `.java` dont dépendent les sources.

<a id="266-exécution-dun-fichier-source-unique-lancement-rapide-sans-javac"></a>
### 2.6.6 Exécution d’un fichier source unique (lancement rapide sans `javac`)

Java 21 (depuis Java 11) permet d’exécuter de petits programmes directement à partir du code source :

```bash
# Uniquement package par défaut
java Hello.java
```

Plusieurs fichiers source sont autorisés s’ils se trouvent dans le **package par défaut** et dans le **même répertoire** :

```bash
java Main.java Helper.java
```

> Si vous utilisez des **packages**, il est préférable de compiler dans `out/` et d’exécuter avec `-cp`.

<a id="267-passer-des-paramètres-à-un-programme-java"></a>
### 2.6.7 Passer des paramètres à un programme Java

Vous pouvez transmettre des données à votre programme Java via les paramètres du point d’entrée `main`.

Comme nous l’avons vu, la méthode `main` peut recevoir un tableau de chaînes sous la forme : **`String[] args`**. Voir [la section sur main](#251-signature-de-la-méthode-main).

**Main.java qui affiche deux paramètres reçus en entrée par la méthode `main` :**

```java
package com.example.app;

public class Main {
    public static void main(String[] args) {
        System.out.println(args[0]);
        System.out.println(args[1]);
    }
}
```

Pour passer des paramètres, il suffit de taper (par exemple) :

```bash
java Main.java Hello World  # spaces are used to separate the two arguments
```

Si vous voulez passer un argument contenant des espaces, utilisez des guillemets :

```bash
java Main.java Hello "World Mario" # spaces are used to separate the two arguments
```

> Si vous déclarez utiliser (ici, afficher) les deux premiers éléments du tableau de paramètres, mais que vous passez en réalité moins d’arguments, la JVM vous signalera un problème via une `java.lang.ArrayIndexOutOfBoundsException`.  

> Si, au contraire, vous passez plus d’arguments que ce que la méthode utilise, elle n’affichera que les deux premiers (dans ce cas).  

> `args.length` vous indique combien d’arguments ont été fournis.
