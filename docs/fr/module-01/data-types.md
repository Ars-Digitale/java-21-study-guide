# 4. Types de données Java et cast

<a id="table-des-matières"></a>
### Table des matières

- [4. Types de données Java et cast](#4-types-de-données-java-et-cast)
  - [4.1 Types primitifs](#41-types-primitifs)
  - [4.2 Types référence](#42-types-référence)
  - [4.3 Tableau des types primitifs](#43-tableau-des-types-primitifs)
  - [4.4 Notes](#44-notes)
  - [4.5 Récapitulatif](#45-récapitulatif)
  - [4.6 Arithmétique et promotion numérique primitive](#46-arithmétique-et-promotion-numérique-primitive)
    - [4.6.1 Règles de promotion numérique en Java](#461--règles-de-promotion-numérique-en-java)
      - [4.6.1.1 Règle 1 – Types numériques mixtes → le plus petit type est promu vers le plus grand](#4611-règle-1--types-numériques-mixtes--le-plus-petit-type-est-promu-vers-le-plus-grand)
      - [4.6.1.2 Règle 2 – Entier + flottant → l’entier est promu vers le flottant](#4612-règle-2--entier--flottant--lentier-est-promu-vers-le-flottant)
      - [4.6.1.3 Règle 3 – byte, short et char sont promus en int lors des opérations arithmétiques](#4613-règle-3--byte-short-et-char-sont-promus-en-int-lors-des-opérations-arithmétiques)
      - [4.6.1.4 Règle 4 – Le type du résultat correspond au type promu des opérandes](#4614-règle-4--le-type-du-résultat-correspond-au-type-promu-des-opérandes)
    - [4.6.2 Récapitulatif du comportement de promotion numérique](#462--récapitulatif-du-comportement-de-promotion-numérique)
      - [4.6.2.1 Points clés](#4621--points-clés)
  - [4.7 Cast en Java](#47-cast-en-java)
    - [4.7.1 Cast primitif](#471-cast-primitif)
      - [4.7.1.1 Cast large implicite](#4711-cast-large-implicite)
      - [4.7.1.2 Cast étroit explicite](#4712-cast-étroit-explicite)
      - [4.7.1.3 Cast étroit Implicite à la Compilation](#4713-cast-étroit-implicite-à-la-compilation)
    - [4.7.2 Perte de données, dépassement et sous-dépassement](#472-perte-de-données-dépassement-et-sous-dépassement)
    - [4.7.3 Cast de valeurs versus variables](#473-cast-de-valeurs-versus-variables)
    - [4.7.4 Cast de référence d’objets](#474-cast-de-référence-dobjets)
      - [4.7.4.1 Upcasting (cast large de référence)](#4741-upcasting-cast-large-de-référence)
      - [4.7.4.2 Downcasting (cast étroit de référence)](#4742-downcasting-cast-étroit-de-référence)
    - [4.7.5 Résumé des points clés](#475-résumé-des-points-clés)
    - [4.7.6 Exemples](#476-exemples)
  - [4.8 Résumé](#48-résumé)

---

Comme nous l’avons vu dans les [Blocs Syntaxiques](syntax-building-blocks.md), Java propose deux catégories de types de données :

- **Types primitifs**  
- **Types référence**

👉 Pour une vue complète des types primitifs avec leur taille, plage de valeurs, valeurs par défaut et exemples, voir le [Tableau des types primitifs](#43-tableau-des-types-primitifs).

<a id="41-types-primitifs"></a>
## 4.1 Types primitifs

Les `primitives` représentent des **valeurs brutes uniques** stockées directement en mémoire.  
Chaque type primitif possède une taille fixe qui détermine le nombre d’octets qu’il occupe.

Conceptuellement, un primitif est simplement une **cellule mémoire** contenant une valeur :

```text
+-------+
|  42   |   ← valeur de type short (2 octets en mémoire)
+-------+
```

---

<a id="42-types-référence"></a>
## 4.2 Types référence

Un type `référence` ne contient pas l’`objet` lui-même, mais une **référence (pointeur)** vers celui-ci.  
La référence a une taille fixe (dépendante de la JVM, souvent 4 ou 8 octets) qui pointe vers un emplacement mémoire où l’objet réel est stocké.

- Exemple : une variable de type `String` pointe vers un objet chaîne dans le tas (heap), qui est lui-même composé en interne d’un tableau de primitives `char`.

Diagramme :

```text
Référence (4 ou 8 octets)
+---------+
| address | ───────────────►  Objet dans le tas (Heap)
+---------+                  +-------------------+
                             |   "Hello"         |
                             | ['H','e','l','l','o']  ← tableau de char
                             +-------------------+
```

---

<a id="43-tableau-des-types-primitifs"></a>
## 4.3 Tableau des types primitifs

| Mot-clé | Type | Taille | Valeur min | Valeur max | Valeur par défaut | Exemple |
| --- | --- | --- | --- | --- | --- | --- |
| `byte` | int 8 bits | 1 octet | –128 | 127 | 0 | `byte b = 100;` |
| `short` | int 16 bits | 2 octets | –32 768 | 32 767 | 0 | `short s = 2000;` |
| `int` | int 32 bits | 4 octets | –2 147 483 648 (–2^31) | 2 147 483 647 (2^31–1) | 0 | `int i = 123456;` |
| `long` | int 64 bits | 8 octets | –2^63 | 2^63–1 | 0L | `long l = 123456789L;` |
| `float` | flottant 32 bits | 4 octets | voir note | voir note | 0.0f | `float f = 3.14f;` |
| `double` | flottant 64 bits | 8 octets | voir note | voir note | 0.0 | `double d = 2.718;` |
| `char` | UTF-16 | 2 octets | `'\u0000'` (0) | `'\uffff'` (65 535) | `'\u0000'` | `char c = 'A';` |
| `boolean` | true/false | dépend de la JVM (souvent 1 octet) | false | true | false | `boolean b = true;` |

---

<a id="44-notes"></a>
## 4.4 Notes

`float` et `double` n’ont pas de bornes entières fixes comme les types entiers.  
Ils suivent la norme IEEE 754 :

- **Plus petites valeurs positives non nulles** :  
  - `Float.MIN_VALUE ≈ 1.4E–45`  
  - `Double.MIN_VALUE ≈ 4.9E–324`  

- **Plus grandes valeurs finies** :  
  - `Float.MAX_VALUE ≈ 3.4028235E+38`  
  - `Double.MAX_VALUE ≈ 1.7976931348623157E+308`  

Ils supportent également des valeurs spéciales : **`+Infinity`**, **`-Infinity`**, et **`NaN`** (Not a Number).

- **FP** = floating point (virgule flottante).  
- La taille de `boolean` dépend de la JVM mais le type se comporte logiquement comme `true`/`false`.  
- Les valeurs par défaut s’appliquent aux **champs** (variables de classe).  
  Les **variables locales** doivent être explicitement initialisées avant utilisation.

---

<a id="45-récapitulatif"></a>
## 4.5 Récapitulatif

- **Primitif** = valeur réelle, stockée directement en mémoire.  
- **Référence** = pointeur vers un objet ; l’objet lui-même peut contenir des primitives et d’autres références.  
- Pour les détails des primitives, voir le [Tableau des types primitifs](#43-tableau-des-types-primitifs).

---

<a id="46-arithmétique-et-promotion-numérique-primitive"></a>
## 4.6 Arithmétique et promotion numérique primitive

Lorsqu’on applique des opérateurs arithmétiques ou de comparaison à des **types primitifs**, Java convertit (ou *promeut*) automatiquement les valeurs vers des types compatibles selon des **règles de promotion numérique** bien définies.

Ces règles garantissent des calculs cohérents et évitent la perte de données lors du mélange de types numériques différents.

<a id="461--règles-de-promotion-numérique-en-java"></a>
### 4.6.1 🔹 Règles de promotion numérique en Java

<a id="4611-règle-1--types-numériques-mixtes--le-plus-petit-type-est-promu-vers-le-plus-grand"></a>
#### 4.6.1.1 Règle 1 – Types numériques mixtes → le plus petit type est promu vers le plus grand

Si deux opérandes appartiennent à des **types numériques différents**, Java promeut automatiquement le type le **plus petit** vers le type le **plus grand** avant d’effectuer l’opération.

| Exemple | Explication |
| --- | --- |
| `int x = 10; double y = 5.5; double result = x + y;` | La valeur `int x` est promue en `double`, donc le résultat est un `double` (`15.5`). |

**Ordre de promotion valide (du plus petit au plus grand)** :  
`byte → short → int → long → float → double`

<a id="4612-règle-2--entier--flottant--lentier-est-promu-vers-le-flottant"></a>
#### 4.6.1.2 Règle 2 – Entier + flottant → l’entier est promu vers le flottant

Si un opérande est de type **entier** (`byte`, `short`, `char`, `int`, `long`) et l’autre de type **flottant** (`float`, `double`),  
la **valeur entière est promue** vers le type flottant avant l’opération.

| Exemple | Explication |
| --- | --- |
| `float f = 2.5F; int n = 3; float result = f * n;` | `n` (int) est promu en `float`. Le résultat est un `float` (`7.5`). |
| `double d = 10.0; long l = 3; double result = d / l;` | `l` (long) est promu en `double`. Le résultat est un `double` (`3.333...`). |

<a id="4613-règle-3--byte-short-et-char-sont-promus-en-int-lors-des-opérations-arithmétiques"></a>
#### 4.6.1.3 Règle 3 – `byte`, `short` et `char` sont promus en `int` lors des opérations arithmétiques

Lorsqu’on effectue une opération arithmétique sur des **variables** (et non des constantes littérales) de type `byte`, `short` ou `char`,  
Java les promeut automatiquement en **`int`**, même si **les deux opérandes sont plus petits que `int`**.

| Exemple | Explication |
| --- | --- |
| `byte a = 10, b = 20; byte c = a + b;` | ❌ Erreur de compilation : le résultat de `a + b` est un `int`, pas un `byte`. Il faut caster → `byte c = (byte)(a + b);` |
| `short s1 = 1000, s2 = 2000; short sum = (short)(s1 + s2);` | Les opérandes sont promus en `int`, un cast explicite est nécessaire pour affecter à `short`. |
| `char c1 = 'A', c2 = 2; int result = c1 + c2;` | `'A'` (65) et `2` sont promus en `int`, résultat = `67`. |

!!! note
    Cette règle s’applique uniquement lorsqu’on utilise des **variables**.
    Lorsque l’on utilise des **littéraux constants**, le compilateur peut parfois évaluer l’expression à la compilation et l’affecter sans problème.

```java
byte a = 10 + 20;   // ✅ OK : expression constante qui tient dans un byte
byte b = 10;
byte c = 20;
byte d = b + c;     // ❌ Erreur : b + c est évalué à l’exécution → int
```

<a id="4614-règle-4--le-type-du-résultat-correspond-au-type-promu-des-opérandes"></a>
#### 4.6.1.4 Règle 4 – Le type du résultat correspond au type promu des opérandes

Une fois les promotions appliquées, et lorsque les deux opérandes sont du même type,  
le **résultat** de l’expression a ce **même type promu**.

| Exemple | Explication |
| --- | --- |
| `int i = 5; double d = 6.0; var result = i * d;` | `i` est promu en `double`, le résultat est un `double`. |
| `float f = 3.5F; long l = 4L; var result = f + l;` | `l` est promu en `float`, le résultat est un `float`. |
| `int x = 10, y = 4; var div = x / y;` | Les deux sont `int`, le résultat est un `int` (`2`), la partie fractionnaire est tronquée. |

!!! warning
    La division entière produit toujours un **résultat entier**.
    Pour obtenir un résultat décimal, **au moins un opérande doit être flottant** :

```java
double result = 10.0 / 4; // ✅ 2.5
int result2 = 10 / 4;     // ❌ 2 (fraction ignorée)
```

---

<a id="462--récapitulatif-du-comportement-de-promotion-numérique"></a>
### 4.6.2 ✅ Récapitulatif du comportement de promotion numérique

| Situation | Résultat de promotion | Exemple |
| --- | --- | --- |
| Mélange de petits et grands types numériques | Le plus petit est promu vers le plus grand | int + double → double |
| Entier + flottant | L’entier est promu vers le flottant | long + float → float |
| Arithmétique sur byte, short, char | Promu en int | byte + byte → int |
| Résultat après promotion | Le type du résultat correspond au type promu | float + long → float |

<a id="4621--points-clés"></a>
#### 4.6.2.1 🧠 Points clés

- Toujours tenir compte de la **promotion de type** lorsqu’on mélange des types dans une expression arithmétique.  
- Pour les petits types (`byte`, `short`, `char`), la promotion en `int` est automatique dès qu’il y a une opération avec des **variables**.  
- Utilisez le **cast explicite** seulement lorsque vous êtes sûr que le résultat tient dans le type cible.  
- Rappelez-vous : **la division entière tronque**, la **division en flottant conserve les décimales**.  
- Comprendre ces règles est essentiel pour éviter les **pertes de précision inattendues** ou les **erreurs de compilation** à l’examen de certification Java.

---

<a id="47-cast-en-java"></a>
## 4.7 Cast en Java

En Java, le `cast` est le processus par lequel on convertit explicitement une valeur d’un type vers un autre.  
Cela s’applique à la fois aux `types primitifs` (nombres) et aux `types référence` (objets dans une hiérarchie de classes).

<a id="471-cast-primitif"></a>
### 4.7.1 Cast primitif

Le cast primitif modifie le type d’une valeur numérique.

Il existe deux catégories de cast :

| Type | Description | Exemple | Explicite ? | Risque |
| --- | --- | --- | --- | --- |
| Widening | plus petit type → plus grand type | int → double | Non | Aucune perte |
| Narrowing | plus grand type → plus petit type | double → int | Oui | Perte possible |

<a id="4711-cast-large-implicite"></a>
#### 4.7.1.1 Cast large implicite

Conversion automatique d’un type “plus petit” vers un type compatible “plus grand”.  
Gérée par le compilateur, **ne nécessite pas de syntaxe explicite**.

```java
int i = 100;
double d = i;  // cast implicite : int → double
System.out.println(d); // 100.0
```

✅ **Sûr** – pas de dépassement (même s’il faut garder en tête la précision des flottants).


<a id="4712-cast-étroit-explicite"></a>
### 4.7.1.2 Cast étroit explicite

Conversion manuelle d’un type « plus grand » vers un type « plus petit ».  
Nécessite une **cast expression** car cela peut provoquer une perte de données.

```java
double d = 9.78;
int i = (int) d;  // explicit cast: double → int
System.out.println(i); // 9 (fraction discarded)
```

!!! warning
    ⚠ Utiliser uniquement lorsque vous êtes certain que la valeur tient dans le type cible.


<a id="4713-cast-étroit-implicite-à-la-compilation"></a>
### 4.7.1.3 Cast étroit Implicite à la Compilation

Dans certains cas spécifiques, le compilateur autorise une conversion de narrowing **sans cast explicite**.

Si une variable est déclarée `final` et initialisée avec une constant expression dont la valeur tient dans le type cible, le compilateur peut effectuer la conversion en toute sécurité au moment de la compilation.

```java
final int k = 10;
byte b = k;  // allowed: value 10 fits into byte range

final int x = 200;
byte c = x;  // does NOT compile: 200 is outside byte range
```

Cela fonctionne parce que le compilateur connaît la valeur exacte d’une variable `final` et peut vérifier qu’elle se situe dans l’intervalle du type plus petit.

Ce type de narrowing est autorisé entre :
- `byte`
- `short`
- `char`
- `int`

Cependant, cela ne s’applique pas à :
- `long`
- `float`
- `double`

Par exemple :

```java
final float f = 10.0f;
int n = f;   // does not compile
```

Même si la valeur semble compatible, les types à virgule flottante ne sont pas éligibles pour cette forme de narrowing implicite.


<a id="472-perte-de-données-dépassement-et-sous-dépassement"></a>
### 4.7.2 Perte de données, dépassement et sous-dépassement

Lorsqu’une valeur dépasse la capacité d’un type, on peut obtenir :

- **Dépassement (overflow)** : résultat supérieur à la valeur maximale représentable
- **Sous-dépassement (underflow)** : résultat inférieur à la valeur minimale représentable
- **Troncature** : les données qui ne tiennent pas sont perdues (par exemple, les décimales)

- Exemple – overflow/underflow avec int

```java
int max = Integer.MAX_VALUE;
int overflow = max + 1;     // retour (“wrap-around”) vers une valeur négative

int min = Integer.MIN_VALUE;
int underflow = min - 1;    // retour (“wrap-around”) vers une valeur positive
```

- Exemple – troncature

```java
double d = 9.99;
int i = (int) d; // 9 (fraction supprimée)
```

!!! note
    Les types flottants (`float`, `double`) **ne font pas de wrap-around** :
    - overflow → `Infinity` / `-Infinity`  
    - underflow (valeurs très petites) → 0.0 ou valeurs dénormalisées.

---

<a id="473-cast-de-valeurs-versus-variables"></a>
### 4.7.3 Cast de valeurs versus variables

Java traite :

- Les **littéraux entiers** comme des `int` par défaut
- Les **littéraux flottants** comme des `double` par défaut

Le compilateur **n’exige pas de cast** lorsqu’un littéral tient dans la plage du type cible :

```java
byte first = 10;        // OK : 10 tient dans un byte
short second = 9 * 10;  // OK : expression constante évaluée à la compilation
```

Mais :

```java
long a = 5729685479;    // ❌ erreur : littéral int hors plage
long b = 5729685479L;   // ✅ littéral long (suffixe L)

float c = 3.14;         // ❌ double → float : nécessite F ou cast
float d = 3.14F;        // ✅ littéral float

int e = 0x7FFF_FFFF;    // ✅ max int en hexadécimal
int f = 0x8000_0000;    // ❌ hors plage int (nécessite L)
```

Cependant, lorsque les règles de promotion numérique s’appliquent :

> Avec des variables de type `byte`, `short` et `char` dans une expression arithmétique, les opérandes sont promus en `int` et le résultat est un `int`.

```java
byte first = 10;
short second = 9 + first;       // ❌ 9 (littéral int) + first (byte → int) = int
// second = (short) (9 + first);  // ✅ cast de l’expression entière
```

```java
short b = 10;
short a = 5 + b;               // ❌ 5 (int) + b (short → int) = int
short a2 = (short) (5 + b);    // ✅ cast de l’expression entière
```

!!! warning
    Le cast est un **opérateur unaire** :
    
    `short a = (short) 5 + b;`  
    Le cast s’applique uniquement à `5` → le résultat de l’expression reste un int → l’affectation échoue toujours.

---

<a id="474-cast-de-référence-dobjets"></a>
### 4.7.4 Cast de référence d’objets

Le cast s’applique aussi aux **références d’objets** dans une hiérarchie de classes.  
Il ne change pas l’objet en mémoire — seulement le **type de référence** utilisé pour y accéder.

Règles importantes :

- Le **type réel de l’objet** détermine quels champs/méthodes existent réellement.
- Le **type de la référence** détermine ce que vous pouvez appeler/accéder à cet endroit du code.

<a id="4741-upcasting-cast-large-de-référence"></a>
#### 4.7.4.1 Upcasting (cast large de référence)

Conversion d’une **sous-classe** vers une **super-classe**.

**Implicite** et **toujours sûre** : chaque `Dog` est aussi un `Animal`.

```java
class Animal { }
class Dog extends Animal { }

Dog dog = new Dog();
Animal a = dog;    // upcast implicite : Dog → Animal
```

<a id="4742-downcasting-cast-étroit-de-référence"></a>
#### 4.7.4.2 Downcasting (cast étroit de référence)

Conversion d’une **super-classe** vers une **sous-classe**.

- **Explicite**
- Peut échouer à l’exécution avec `ClassCastException` si l’objet n’est pas réellement de ce type

```java
Animal a = new Dog();
Dog d = (Dog) a;   // OK : a référence réellement un Dog

Animal x = new Animal();
Dog d2 = (Dog) x;  // ⚠ Erreur à l’exécution : ClassCastException
```

Pour plus de sécurité, utilisez `instanceof` :

```java
if (x instanceof Dog) {
    Dog safeDog = (Dog) x;   // cast sûr
}
```

---

<a id="475-résumé-des-points-clés"></a>
### 4.7.5 Résumé des points clés

| Type de cast | S’applique à | Direction | Syntaxe | Sûr ? | Effettué par |
| --- | --- | --- | --- | --- | --- |
| Widening Primitive | Primitifs | petit → grand | Implice | Oui | Compilateur |
| Narrowing Primitive | Primitifs | grand → petit | Explicite | Non | Programmeur |
| Upcasting | Objets | sous-classe → super-classe | Implice | Oui | Compilateur |
| Downcasting | Objets | super-classe → sous-classe | Explicite | Vérification à l’exécution | Programmeur |

---

<a id="476-exemples"></a>
### 4.7.6 Exemples

```java
// Cast primitif
short s = 50;
int i = s;           // widening
byte b = (byte) i;   // narrowing (perte possible)

// Cast d’objet
Object obj = "Hello";
String str = (String) obj; // OK : obj référence une String

Object n = Integer.valueOf(10);
// String fail = (String) n;  // ClassCastException à l’exécution
```

---

<a id="48-résumé"></a>
## 4.8 Résumé

- Le **cast primitif** change le type numérique.  
- Le **cast de référence** change la “vue” d’un objet dans la hiérarchie.  
- **Upcasting** → sûr et implicite.  
- **Downcasting** → explicite, à utiliser avec prudence (souvent après `instanceof`).
