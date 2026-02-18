# 5. Opérateurs Java

<a id="table-des-matières"></a>
### Table des matières


- [5.1 Définition](#51-définition)
- [5.2 Types d’opérateurs](#52-types-dopérateurs)
- [5.3 Catégories d’opérateurs](#53-catégories-dopérateurs)
- [5.4 Priorité des opérateurs et ordre d’évaluation](#54-priorité-des-opérateurs-et-ordre-dévaluation)
- [5.5 Tableau récapitulatif des opérateurs Java](#55-tableau-récapitulatif-des-opérateurs-java)
	- [5.5.1 Notes complémentaires](#551-notes-complémentaires)
- [5.6 Opérateurs unaires](#56-opérateurs-unaires)
	- [5.6.1 Catégories d’opérateurs unaires](#561-catégories-dopérateurs-unaires)
	- [5.6.2 Exemples](#562-exemples)
- [5.7 Opérateurs binaires](#57-opérateurs-binaires)
	- [5.7.1 Catégories d’opérateurs binaires](#571-catégories-dopérateurs-binaires)
	- [5.7.2 Opérateurs de division et de modulo (reste)](#572-opérateurs-de-division-et-de-modulo-reste)
	- [5.7.3 La valeur de retour de l’opérateur d’affectation](#573-la-valeur-de-retour-de-lopérateur-daffectation)
	- [5.7.4 Opérateurs d’affectation composée](#574-opérateurs-daffectation-composée)
	- [5.7.5 Opérateurs d’égalité == et !=](#575-opérateurs-dégalité--et-)
		- [5.7.5.1 Égalité avec les types primitifs](#5751-égalité-avec-les-types-primitifs)
		- [5.7.5.2 Égalité avec les types référence (objets)](#5752-égalité-avec-les-types-référence-objets)
	- [5.7.6 L’opérateur instanceof](#576-lopérateur-instanceof)
		- [5.7.6.1 Vérification à la compilation vs à l’exécution](#5761-vérification-à-la-compilation-vs-à-lexécution)
		- [5.7.6.2 Pattern matching pour instanceof](#5762-pattern-matching-pour-instanceof)
		- [5.7.6.3 Flow scoping & logique short-circuit](#5763-flow-scoping--logique-short-circuit)
		- [5.7.6.4 Tableaux et types réifiables](#5764-tableaux-et-types-réifiables)
- [5.8 Opérateur Ternaire](#58-opérateur-ternaire)
	- [5.8.1 Règles de Typage de l’Opérateur Ternaire](#581-regles-de-typage-de-loperateur-ternaire)
		- [5.8.1.1 Opérandes Numériques](#5811-operandes-numeriques)
		- [5.8.1.2 Types de Référence](#5812-types-de-reference)
	- [5.8.2 Syntaxe](#582-syntaxe)
	- [5.8.3 Exemple](#583-exemple)
	- [5.8.4 Exemple de Ternaire Imbriqué](#584-exemple-de-ternaire-imbriqué)
	- [5.8.5 Remarques](#585-remarques)

---

<a id="51-définition"></a>
## 5.1 Définition

En Java, les **opérateurs** sont des symboles spéciaux qui effectuent des opérations sur des variables et des valeurs.  
Ce sont les briques de base des expressions et ils permettent aux développeurs de manipuler des données, de comparer des valeurs, d’effectuer des opérations arithmétiques et de contrôler le flux logique.

Une **expression** est une combinaison d’opérateurs et d’opérandes qui produit un résultat.

Par exemple :
```java
int result = (a + b) * c;
```

Ici, `+` et `*` sont des opérateurs, et `a`, `b` et `c` sont des opérandes.

---

<a id="52-types-dopérateurs"></a>
## 5.2 Types d’opérateurs

Java définit trois types d’opérateurs, regroupés selon le nombre d’opérandes qu’ils utilisent :

| Type | Description | Exemples |
| --- | --- | --- |
| Unary | Opère sur un seul opérande | `+x`, `-x`, `++x`, `--x`, `!flag`, `~num` |
| Binary | Opère sur deux opérandes | `a + b`, `a - b`, `x * y`, `x / y`, `x % y` |
| Ternary | Opère sur trois opérandes (un seul en Java) | `condition ? valueIfTrue : valueIfFalse` |

---

<a id="53-catégories-dopérateurs"></a>
## 5.3 Catégories d’opérateurs

Les opérateurs peuvent également être regroupés, selon leur objectif, en catégories :

| Catégorie | Description | Exemples |
| --- | --- | --- |
| Assignment | Assigne des valeurs aux variables | `=`, `+=`, `-=`, `*=`, `/=`, `%=` |
| Relational | Compare des valeurs | `==`, `!=`, `<`, `>`, `<=`, `>=` |
| Logical | Combine ou inverse des expressions booléennes | <code>&#124;</code>, <code>&amp;</code>, <code>^</code> |
| Conditional | Combine ou inverse des expressions booléennes | <code>&#124;&#124;</code>, <code>&amp;&amp;</code> |
| Bitwise | Manipule des bits | <code>&amp;</code>, <code>&#124;</code>, `^`, `~`, `<<`, `>>`, `>>>` |
| Instanceof | Teste le type d’un objet | `obj instanceof ClassName` |
| Lambda | Utilisé dans les expressions lambda | `(x, y) -> x + y` |

---

<a id="54-priorité-des-opérateurs-et-ordre-dévaluation"></a>
## 5.4 Priorité des opérateurs et ordre d’évaluation

La **priorité des opérateurs** détermine comment les opérateurs sont regroupés dans une expression — c’est-à-dire quelles opérations sont effectuées en premier.  
L’**associativité** (ou **ordre d’évaluation**) détermine si l’expression est évaluée de **gauche à droite** ou de **droite à gauche** lorsque des opérateurs ont la même priorité.

Exemple :

```java
int result = 10 + 5 * 2;  // La multiplication est effectuée avant l’addition → result = 20
```

Les parenthèses `()` peuvent être utilisées pour **surclasser la priorité** :

```java
int result = (10 + 5) * 2;  // Les parenthèses sont évaluées en premier → result = 30
```

!!! note
    - La **priorité** des opérateurs concerne le *regroupement*, pas l’ordre concret d’évaluation.
    - Utilise les parenthèses pour la priorité et la clarté dans les expressions complexes.

---

<a id="55-tableau-récapitulatif-des-opérateurs-java"></a>
## 5.5 Tableau récapitulatif des opérateurs Java

| Priorité (Haute → Basse) | Type | Opérateurs | Exemple | Ordre d’évaluation | Applicable à |
| --- | --- | --- | --- | --- | --- |
| 1 | Postfix Unary | `expr++`, `expr--` | `x++` | Gauche → Droite | Types numériques |
| 2 | Prefix Unary | `++expr`, `--expr` | `--x` | Gauche → Droite | Numériques |
| 3 | Other Unary | `(type)`, `+`, `-`, `~`, `!` | `-x`, `!flag` | Droite → Gauche | Numériques, boolean |
| 4 | Cast Unary | `(Type) reference` | `(short) 22` | Droite → Gauche | reference, primitifs |
| 5 | Multiplication/division/modulus | `*`, `/`, `%` | `a * b` | Gauche → Droite | Types numériques |
| 6 | Additive | `+`, `-` | `a + b` | Gauche → Droite | Numériques, String (concaténation) |
| 7 | Shift | `<<`, `>>`, `>>>` | `a << 2` | Gauche → Droite | Types intégraux |
| 8 | Relational | `<`, `>`, `<=`, `>=`, `instanceof` | `a < b`, `obj instanceof Person` | Gauche → Droite | Numériques, reference |
| 9 | Equality | `==`, `!=` | `a == b` | Gauche → Droite | Tous les types (sauf boolean pour `<`, `>`) |
| 10 | Logical AND | <code>&amp;</code> | `a & b` | Gauche → Droite | boolean |
| 11 | Logical exclusive OR | `^` | `a ^ b` | Gauche → Droite | boolean |
| 12 | Logical inclusive OR | <code>&#124;</code> | `a `<code>&#124;</code>` b` | Gauche → Droite | boolean |
| 13 | Conditional AND | <code>&amp;&amp;</code> | `a`<code>&amp;&amp;</code>`b` | Gauche → Droite | boolean |
| 14 | Conditional OR | <code>&#124;&#124;</code> | `a`<code>&#124;&#124;</code>`b` | Gauche → Droite | boolean |
| 15 | Ternary (Conditional) | `? :` | `a > b ? x : y` | Droite → Gauche | Tous les types |
| 16 | Assignment | `=`, `+=`, `-=`, `*=`, `/=`, `%=` | `x += 5` | Droite → Gauche | Tous les types assignables |
| 17 | Arrow operator | `->` | `(x, y) -> x + y` | Droite → Gauche | Expressions lambda, switch rules |

<a id="551-notes-complémentaires"></a>
### 5.5.1 Notes complémentaires

- La **concaténation de chaînes (`+`)** a une priorité plus faible que le `+` arithmétique sur les nombres.
- Utilise les parenthèses `()` pour la priorité et la lisibilité — elles ne changent pas la sémantique mais rendent l’intention explicite.

---

<a id="56-opérateurs-unaires"></a>
## 5.6 Opérateurs unaires

Les opérateurs unaires opèrent sur **un seul opérande** pour produire une nouvelle valeur.  
Ils sont utilisés pour des opérations comme l’incrémentation/décrémentation, la négation d’une valeur, l’inversion d’un booléen ou le complément bit à bit.

<a id="561-catégories-dopérateurs-unaires"></a>
### 5.6.1 Catégories d’opérateurs unaires

| Opérateur | Nom | Description | Exemple | Résultat |
| --- | --- | --- | --- | --- |
| `+` | Unary plus | Indique une valeur positive (souvent redondant). | `+x` | Identique à `x` |
| `-` | Unary minus | Indique qu’un nombre littéral est négatif ou nie une expression. | `-5` | `-5` |
| `++` | Increment | Augmente une variable de 1. Peut être préfixe ou postfixe. | `++x`, `x++` | `x+1` |
| `--` | Decrement | Diminue une variable de 1. Peut être préfixe ou postfixe. | `--x`, `x--` | `x-1` |
| `!` | Logical complement | Inverse une valeur booléenne. | `!true` | `false` |
| `~` | Bitwise complement | Inverse chaque bit d’un entier. | `~5` | `-6` |
| `(type)` | Cast | Convertit la valeur vers un autre type. | `(int) 3.9` | `3` |

<a id="562-exemples"></a>
### 5.6.2 Exemples

```java
int x = 5;
System.out.println(++x);  // 6  (préfixe : incrémente x à 6, puis renvoie 6)
System.out.println(x++);  // 6  (postfixe : renvoie 6, puis incrémente x à 7)
System.out.println(x);    // 7

boolean flag = false;
System.out.println(!flag);  // true

int a = 5;                  // binaire : 0000 0101
System.out.println(~a);     // -6 → binaire : 1111 1010 (complément à deux)
```

!!! note
    - Préfixe (`++x` / `--x`) : met à jour la valeur d’abord, puis renvoie la nouvelle valeur.
    - Postfixe (`x++` / `x--`) : renvoie d’abord la valeur courante, puis la met à jour.
    - L’opérateur `!` s’applique aux valeurs boolean ; `~` s’applique aux types numériques intégraux.

---

<a id="57-opérateurs-binaires"></a>
## 5.7 Opérateurs binaires

Les opérateurs binaires nécessitent **deux opérandes**.  
Ils effectuent des opérations arithmétiques, relationnelles, logiques, bit à bit et d’affectation.

<a id="571-catégories-dopérateurs-binaires"></a>
### 5.7.1 Catégories d’opérateurs binaires

| Catégorie | Opérateurs | Exemple | Description |
| --- | --- | --- | --- |
| Arithmetic | `+`, `-`, `*`, `/`, `%` | `a + b` | Opérations mathématiques de base. |
| Relational | `<`, `>`, `<=`, `>=`, `==`, `!=` | `a < b` | Compare des valeurs. |
| Logical (boolean) | <code>&amp;</code>, <code>&#124;</code>, `^` | `a `<code>&amp;</code>` b` | Voir note ci-dessous. |
| Conditional | <code>&amp;&amp;</code>, <code>&#124;&#124;</code> | `a `<code>&amp;&amp;</code>` b` | Voir note ci-dessous. |
| Bitwise (integral) | <code>&amp;</code>, <code>&#124;</code>, `^`, `<<`, `>>`, `>>>` | `a << 2` | Opère sur les bits. |
| Assignment | `=`, `+=`, `-=`, `*=`, `/=`, `%=` | `x += 3` | Modifie puis affecte. |
| String Concatenation | `+` | `"Hello " + name` | Concatène des chaînes. |

!!! important
    - Les opérateurs **logiques** (`&`, `|`, `^`) *évaluent toujours les deux côtés*.
    - Les opérateurs **conditionnels** (`&&`, `||`) sont **short-circuit** :
      - `a && b` → `b` est évalué uniquement si `a` est true
      - `a || b` → `b` est évalué uniquement si `a` est false

Exemples :

**Exemple arithmétique :**
```java
int a = 10, b = 4;
System.out.println(a + b);  // 14
System.out.println(a - b);  // 6
System.out.println(a * b);  // 40
System.out.println(a / b);  // 2
System.out.println(a % b);  // 2
```

**Exemple relationnel :**
```java
int a = 5, b = 8;
System.out.println(a < b);   // true
System.out.println(a >= b);  // false
System.out.println(a == b);  // false
System.out.println(a != b);  // true
```

**Exemple logique :**
```java
boolean x = true, y = false;
System.out.println(x && y);  // false
System.out.println(x || y);  // true
System.out.println(!x);      // false
```

**Exemple bit à bit :**
```java
int a = 5;   // 0101
int b = 3;   // 0011
System.out.println(a & b);  // 1  (0001)
System.out.println(a | b);  // 7  (0111)
System.out.println(a ^ b);  // 6  (0110)
System.out.println(a << 1); // 10 (1010)
System.out.println(a >> 1); // 2  (0010)
```

<a id="572-opérateurs-de-division-et-de-modulo-reste"></a>
### 5.7.2 Opérateurs de division et de modulo (reste)

L’opérateur modulo donne le reste lorsque deux nombres sont divisés.  
Si deux nombres se divisent exactement, le reste est 0 : par exemple **10 % 5** vaut 0.  
En revanche, **13 % 4** donne un reste de 1.

On peut utiliser le modulo avec des nombres négatifs selon les règles suivantes :

- si le **diviseur** est négatif (ex. : 7 % -5), le signe est ignoré et le résultat est **2** ;
- si le **dividende** est négatif (ex. : -7 % 5), le signe est conservé et le résultat est **-2** ;

```java
System.out.println(8 % 5);      // GIVES 3
System.out.println(10 % 5); 	// GIVES 0
System.out.println(10 % 3); 	// GIVES 1    
System.out.println(-10 % 3); 	// GIVES -1    
System.out.println(10 % -3); 	// GIVES 1   
System.out.println(-10 % -3); 	// GIVES -1 

System.out.println(8 % 9);      // GIVES 8
System.out.println(3 % 4);      // GIVES 3    
System.out.println(2 % 4);      // GIVES 2
System.out.println(-8 % 9);     // GIVES -8
```

<a id="573-la-valeur-de-retour-de-lopérateur-daffectation"></a>
### 5.7.3 La valeur de retour de l’opérateur d’affectation

En Java, l’**opérateur d’affectation (`=`)** ne fait pas que stocker une valeur dans une variable —  
il **renvoie aussi la valeur affectée** comme résultat de l’expression entière.

Cela signifie que l’affectation peut être **utilisée comme partie d’une autre expression**,  
par exemple dans une condition `if`, dans la condition d’une boucle, ou même dans une autre affectation.

```java
int x;
int y = (x = 10);   // l’affectation (x = 10) renvoie 10
System.out.println(y);  // 10

// x = 10 affecte 10 à x.
// L’expression (x = 10) s’évalue à 10.
// Cette valeur est ensuite affectée à y.
// Donc x et y finissent avec la même valeur (10).
```

Comme l’affectation renvoie une valeur, elle peut aussi apparaître dans un **if**.  
Cependant, cela conduit souvent à des erreurs logiques si c’est fait involontairement.

```java
boolean flag = false;

if (flag = true) {
    System.out.println("This will always execute!");
}

// Ici la condition (flag = true) affecte true à flag, puis s’évalue à true,
// donc le bloc if s’exécute toujours.

// Usage correct (comparaison au lieu d’affectation) :

if (flag == true) {
    System.out.println("Condition checked, not assigned");
}
```

!!! warning
    Si tu vois `if (x = quelque chose)`, stop : c’est une **affectation**, pas une comparaison.

<a id="574-opérateurs-daffectation-composée"></a>
### 5.7.4 Opérateurs d’affectation composée

Les **opérateurs d’affectation composée** en Java combinent une opération arithmétique ou bit à bit avec une affectation en une seule étape.  
Au lieu d’écrire `x = x + 5`, tu peux utiliser la forme abrégée `x += 5`.  
Ils effectuent automatiquement un **cast implicite** vers le type de la variable à gauche lorsque c’est nécessaire.

Les opérateurs composés courants incluent :  
`+=`, `-=`, `*=`, `/=`, `%=`, `&=`, `|=`, `^=`, `<<=`, `>>=`, et `>>>=`.

```java
int x = 10;

// Affectations composées arithmétiques
x += 5;   // équivalent à x = x + 5 → x = 15
x -= 3;   // équivalent à x = x - 3 → x = 12
x *= 2;   // équivalent à x = x * 2 → x = 24
x /= 4;   // équivalent à x = x / 4 → x = 6
x %= 5;   // équivalent à x = x % 5 → x = 1

// Affectations composées bit à bit
int y = 6;   // 0110 (binaire)
y &= 3;      // y = y & 3 → 0110 & 0011 = 0010 → y = 2
y |= 4;      // y = y | 4 → 0010 | 0100 = 0110 → y = 6
y ^= 5;      // y = y ^ 5 → 0110 ^ 0101 = 0011 → y = 3

// Affectations composées avec décalage
int z = 8;   // 0000 1000
z <<= 2;     // z = z << 2 → 0010 0000 → z = 32
z >>= 1;     // z = z >> 1 → 0001 0000 → z = 16
z >>>= 2;    // z = z >>> 2 → 0000 0100 → z = 4

// Exemple de cast de type
byte b = 10;
// b = b + 1;   // ❌ erreur de compilation : le résultat int ne peut pas être affecté à byte
b += 1;         // ✅ fonctionne : cast implicite vers byte
```

!!! note
    Les affectations composées effectuent un **cast implicite** vers le type de la variable à gauche.
    C’est pourquoi `b += 1` compile alors que `b = b + 1` ne compile pas.

<a id="575-opérateurs-dégalité--et-"></a>
### 5.7.5 Opérateurs d’égalité (`==` et `!=`)

Les **opérateurs d’égalité** en Java `==` (égal à) et `!=` (différent de) servent à comparer deux opérandes.  
Cependant, leur comportement diffère **selon qu’ils s’appliquent à des types primitifs ou à des types référence (objets)**.

!!! note
    - `==` compare les **valeurs** pour les primitifs
    - `==` compare les **références** pour les objets  
    - `.equals()` compare le **contenu** d’un objet (si implémenté)

<a id="5751-égalité-avec-les-types-primitifs"></a>
#### 5.7.5.1 Égalité avec les types primitifs

Lorsqu’on compare des **valeurs primitives**, `==` et `!=` comparent les **valeurs stockées**.

```java
int a = 5, b = 5;
System.out.println(a == b);  // true  → mêmes valeurs
System.out.println(a != b);  // false → valeurs égales
```

!!! important
    - Si les opérandes sont de types numériques différents, Java les promeut automatiquement vers un type commun avant la comparaison.
    - Cependant, comparer float et double peut produire des résultats inattendus à cause des erreurs de précision (voir ci-dessous).

```java
int x = 10;
double y = 10.0;
System.out.println(x == y);  // true → x promu en double (10.0)

double d = 0.1 + 0.2;
System.out.println(d == 0.3); // false → problème d’arrondi floating-point
```

<a id="5752-égalité-avec-les-types-référence-objets"></a>
#### 5.7.5.2 Égalité avec les types référence (objets)

Pour les objets, `==` et `!=` comparent les références, pas le contenu.  
Ils renvoient true uniquement si les deux références pointent vers **le même objet** en mémoire.

```java
String s1 = new String("Java");
String s2 = new String("Java");
System.out.println(s1 == s2);      // false → objets différents en mémoire
System.out.println(s1 != s2);      // true  → pas la même référence
```

Même si deux objets ont un contenu identique, `==` compare leurs **adresses**, pas leurs valeurs.  
Pour comparer le **contenu** des objets, utilise **`.equals()`**.

```java
System.out.println(s1.equals(s2)); // true → même contenu de chaîne
```

**Cas particulier : null et littéraux String**

- Toute référence peut être comparée à `null` avec `==` ou `!=`.

```java
String text = null;
System.out.println(text == null);  // true
```

- Les littéraux String sont *internés* par la JVM :  
des littéraux identiques peuvent donc pointer vers la même référence en mémoire :

```java
String a = "Java";
String b = "Java";
System.out.println(a == b);       // true → même littéral interné
```

- Égalité avec types mixtes :  
avec `==` entre catégories différentes (ex. primitif vs objet),  
le compilateur tente l’unboxing si l’un des deux est une **classe wrapper**.

```java
Integer i = 100;
int j = 100;
System.out.println(i == j);   // true → unboxing avant comparaison
```

<a id="576-lopérateur-instanceof"></a>
### 5.7.6 L’opérateur `instanceof`

`instanceof` est un **opérateur relationnel** qui teste si une référence est une **instance** d’un certain **type référence** à l’exécution.  
Il renvoie un `boolean`.

```java
Object o = "Java";
boolean b1 = (o instanceof String);   // true
boolean b2 = (o instanceof Number);   // false
```

Comportement avec **null** :  
si l’expression est null, **expr instanceof Type** est toujours **false**.

```java
Object n = null;
System.out.println(n instanceof Object);  // false
```

!!! warning
    `instanceof` renvoie toujours `false` lorsque l’opérande gauche est `null`.

<a id="5761-vérification-à-la-compilation-vs-à-lexécution"></a>
#### 5.7.6.1 Vérification à la compilation vs à l’exécution

- À la compilation, le compilateur rejette les types inconvertibles (qui ne peuvent pas être liés à l’exécution).
- À l’exécution, si la vérification compile-time a passé, la JVM évalue le type réel de l’objet.

```java
// ❌ Erreur de compilation : types inconvertibles (String est sans rapport avec Integer)
boolean bad = ("abc" instanceof Integer);

// ✅ Compile, mais le résultat à l’exécution dépend de l’objet réel :

Number num = Integer.valueOf(10);
System.out.println(num instanceof Integer); // true à l’exécution
System.out.println(num instanceof Double);  // false à l’exécution
```

<a id="5762-pattern-matching-pour-instanceof"></a>
#### 5.7.6.2 Pattern matching pour instanceof

Java supporte les *type patterns* avec `instanceof`, qui testent et lient une variable si le test réussit.  
Ajouter une variable après le type indique au compilateur d’interpréter cela comme du *Pattern Matching*.

Syntaxe (forme pattern) :

```java
Object obj = "Hello";

if (obj instanceof String str) {
	// Ajouter la variable str après le type indique au compilateur de faire du Pattern Matching
	
    System.out.println(str.toUpperCase()); // l’identifiant est en scope ici, de type String (sûr).
}
```

Propriétés clés :

- Si le test réussit, la variable de pattern (ex. `str`) est définitivement assignée et visible dans la branche true.
- Les variables de pattern sont implicitement final (ne peuvent pas être réassignées).
- Le nom ne doit pas entrer en conflit avec une variable existante dans le même scope.

<a id="5763-flow-scoping--logique-short-circuit"></a>
#### 5.7.6.3 Flow scoping & logique short-circuit

Les variables de pattern deviennent disponibles selon l’analyse de flux :

```java
Object obj = "data";

// Test négatif, variable disponible dans la branche else
if (!(obj instanceof String s)) {
    // s n’est pas en scope ici
} else {
    System.out.println(s.length()); // s est en scope ici
}

// Avec &&, la variable de pattern peut être utilisée à droite si la gauche l’a établie
if (obj instanceof String s && s.length() > 3) {
    System.out.println(s.substring(0, 3)); // s en scope
}

// Avec ||, la variable de pattern n’est PAS sûre à droite (le short-circuit peut empêcher de l’établir)
if (obj instanceof String s || s.length() > 3) {  // ❌ s n’est pas en scope ici
    // ...
}

// Les parenthèses peuvent aider à regrouper la logique
if ((obj instanceof String s) && s.contains("a")) { // ✅ s en scope après le test groupé
    System.out.println(s);
}
```

Le pattern matching avec `null` s’évalue, comme toujours pour `instanceof`, à `false` :

```java
String str = null;

// instanceof classique
if (str instanceof String) {  
	System.out.print("NOT EXECUTED"); // instanceof vaut false
}

// Pattern matching
if (str instanceof String s) {  
	System.out.print("NOT EXECUTED"); // instanceof vaut toujours false
}
```

**Types supportés :**

Le type de la variable de pattern doit être un sous-type, un super-type, ou le même type que la variable référence.

```java
Number num = Short.valueOf(10);

if (num instanceof String s) {}  // ❌ Erreur de compilation
if (num instanceof Short s) {}   // ✅ Ok
if (num instanceof Object s) {}  // ✅ Ok
if (num instanceof Number s) {}  // ✅ Ok
```

<a id="5764-tableaux-et-types-réifiables"></a>
#### 5.7.6.4 Tableaux et types réifiables

`instanceof` fonctionne avec les tableaux (réifiables) et avec des formes génériques effacées ou avec wildcard.  
Les **types réifiables** sont ceux dont la représentation à l’exécution conserve pleinement leur type (par exemple : raw types, tableaux, classes non génériques, wildcard `?`).  
À cause de l’effacement de type (*type erasure*), `List<String>` ne peut pas être testée directement à l’exécution.

```java
Object arr = new int[]{1,2,3};
System.out.println(arr instanceof int[]); // true

Object list = java.util.List.of(1,2,3);
// System.out.println(list instanceof List<Integer>); // ❌ Erreur de compilation : type paramétré non réifiable
System.out.println(list instanceof java.util.List<?>); // ✅ true
```

---

<a id="58-opérateur-ternaire"></a>
## 5.8 Opérateur ternaire

L’**opérateur ternaire** (`? :`) est le seul opérateur en Java qui prend **trois opérandes**.  
Il constitue une forme concise de l’instruction `if-else`.


<a id="581-regles-de-typage-de-loperateur-ternaire"></a>
### 5.8.1 Règles de Typage de l’Opérateur Ternaire

Le type d’une expression conditionnelle (ternaire) est déterminé par les types du deuxième et du troisième opérande.


<a id="5811-operandes-numeriques"></a>
#### 5.8.1.1 Opérandes Numériques

- Si un opérande est de type `byte` et l’autre de type `short`, le type résultant est `short`.
- Si un opérande est de type `T` (`byte`, `short` ou `char`) et l’autre est une expression constante de type `int` dont la valeur est représentable dans `T`, alors le type résultant est `T`.
- Dans tous les autres cas numériques, la **binary numeric promotion** est appliquée aux deux opérandes.  
  Le type de l’expression conditionnelle devient le type promu.

> La binary numeric promotion inclut la **conversion d’unboxing** et la **value set conversion**.



<a id="5812-types-de-reference"></a>
#### 5.8.1.2 Types de Référence

- Si un opérande est `null` et l’autre est un type de référence, le type résultant est ce type de référence.
- Si les deux opérandes sont de types de référence différents, l’un doit être assignable à l’autre (compatibilité d’assignation).  
  Le type résultant est le type le plus général, c’est-à-dire celui auquel l’autre peut être assigné.
- Si aucun des deux types n’est compatible par assignation avec l’autre, une **erreur à la compilation** se produit.



En résumé, l’opérateur ternaire détermine son type en appliquant :

- Des règles spécifiques de narrowing pour les petits types entiers  
- La binary numeric promotion pour les valeurs numériques  
- Les règles de compatibilité d’assignation pour les types de référence  



!!! tip
    L’opérateur ternaire **doit** produire une valeur d’un type compatible.
    Si les deux branches retournent des types non liés, la compilation échoue.
    
    ```java
    String s = true ? "ok" : 5; // ❌ erreur de compilation : types incompatibles
    ```



<a id="582-syntaxe"></a>
### 5.8.2 Syntaxe

```java
condition ? expressionIfTrue : expressionIfFalse;
```



<a id="583-exemple"></a>
### 5.8.3 Exemple

```java
int age = 20;
String access = (age >= 18) ? "Autorisé" : "Refusé";
System.out.println(access);  // "Autorisé"
```



<a id="584-exemple-de-ternaire-imbriqué"></a>
### 5.8.4 Exemple de Ternaire Imbriqué

```java
int score = 85;
String grade = (score >= 90) ? "A" :
               (score >= 75) ? "B" :
               (score >= 60) ? "C" : "F";
System.out.println(grade);  // "B"
```


<a id="585-remarques"></a>
### 5.8.5 Remarques

!!! warning
    - Les expressions ternaires imbriquées peuvent réduire la lisibilité. Utilisez des parenthèses pour plus de clarté.
    - L’opérateur ternaire retourne une **valeur**, contrairement à `if-else`, qui est une instruction.