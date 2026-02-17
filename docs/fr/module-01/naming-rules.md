# 3. Règles de nommage Java

<a id="table-des-matières"></a>
### Table des matières


- [3.1 Règles pour les identifiants](#31-règles-pour-les-identifiants)
	- [3.1.1 Mots réservés](#311-mots-réservés)
		- [3.1.1.1 Mots-clés Java réservés](#3111-mots-clés-java-réservés)
		- [3.1.1.2 Littéraux réservés](#3112-littéraux-réservés)
	- [3.1.2 Sensibilité à la casse](#312-sensibilité-à-la-casse)
	- [3.1.3 Début des identifiants](#313-début-des-identifiants)
	- [3.1.4 Chiffres dans les identifiants](#314-chiffres-dans-les-identifiants)
	- [3.1.5 Jeton `_` seul](#315-jeton-_-seul)
	- [3.1.6 Littéraux numériques et caractère underscore](#316-littéraux-numériques-et-caractère-underscore)


---

Java définit des règles précises pour les **identifiants**, c’est-à-dire les noms donnés aux variables, méthodes, classes, interfaces et packages.

Tant que vous respectez les règles de nommage décrites ci-dessous, vous êtes libre de choisir des noms significatifs pour les éléments de votre programme.

<a id="31-règles-pour-les-identifiants"></a>
## 3.1 Règles pour les identifiants

<a id="311-mots-réservés"></a>
### 3.1.1 Mots réservés

Les `identifiers` **ne peuvent pas** être identiques aux **mots-clés** Java ni aux **littéraux réservés**.

Les `keywords` sont des mots spéciaux prédéfinis dans le langage Java que vous n’êtes pas autorisé à utiliser comme identifiants (voir tableau ci-dessous).

Les `literals` comme `true`, `false` et `null` sont également réservés et ne peuvent pas être utilisés comme identifiants.

- Exemple :
```java
int class = 5;        // invalid: 'class' is a keyword
boolean true = false; // invalid: 'true' is a literal
int year = 2024;   	  // valid
```

<a id="3111-mots-clés-java-réservés"></a>
#### 3.1.1.1 Mots-clés Java réservés

| a -> c | c -> f | f -> n | n -> s | s -> w |
| --- | --- | --- | --- | --- |
| abstract | continue | for | new | switch |
| assert | default | goto* | package | synchronized |
| boolean | do | if | private | this |
| break | double | implements | protected | throw |
| byte | else | import | public | throws |
| case | enum | instanceof | return | transient |
| catch | extends | int | short | try |
| char | final | interface | static | void |
| class | finally | long | strictfp | volatile |
| const* | float | native | super | while |

!!! note
    `goto` et `const` sont réservés mais non utilisés.

<a id="3112-littéraux-réservés"></a>
#### 3.1.1.2 Littéraux réservés

- `true`  
- `false`  
- `null`  

<a id="312-sensibilité-à-la-casse"></a>
### 3.1.2 Sensibilité à la casse

Les identifiants en Java sont **sensibles à la casse** (case sensitive).  
Cela signifie que `myVar`, `MyVar` et `MYVAR` sont trois identifiants différents.

- Exemple :
```java
int myVar = 1;
int MyVar = 2;
int MYVAR = 3;
int CLASS = 6; // legal but, please, don't do it!!
```

!!! tip
    Java traite les identifiants littéralement : `Count`, `count` et `COUNt` sont indépendants et peuvent coexister.
    
    À cause de la sensibilité à la casse, il est possible d’utiliser des variantes de mots-clés qui diffèrent uniquement par la casse.  
    Même si c’est légal, ce type de nommage est fortement déconseillé, car il nuit à la lisibilité et est considéré comme une très mauvaise pratique.

<a id="313-début-des-identifiants"></a>
### 3.1.3 Début des identifiants

Les identifiants en Java doivent commencer par une lettre, un symbole monétaire (`$`, `€`, `£`, `₹`...) ou le symbole `_`.

Exemple :
```java
int myVarA;
int $myVarB;
int _myVarC;
String €uro = "currency"; // legal (rarely seen in practice)
```

!!! note
    Les symboles de devise sont autorisés, mais ils ne sont pas recommandés dans du code réel.

<a id="314-chiffres-dans-les-identifiants"></a>
### 3.1.4 Chiffres dans les identifiants

Les identifiants Java peuvent contenir des chiffres, mais **ne peuvent pas commencer** par un chiffre.

Exemple :
```java
int my33VarA;
int $myVar44;
int 3myVarC; // invalid: identifier cannot start with a digit
int var2024 = 10; // valid
```

<a id="315-jeton-seul"></a>
### 3.1.5 Jeton `_` seul

- Un underscore (`_`) seul n’est pas autorisé comme identifiant.
- Depuis Java 9, `_` est un jeton réservé pour un usage futur du langage.

- Exemple :
```java
int _;  // invalid since Java 9
```

!!! warning
    `_` est autorisé à l’intérieur des littéraux numériques (voir section suivante), mais pas comme identifiant isolé.

<a id="316-littéraux-numériques-et-caractère-underscore"></a>
### 3.1.6 Littéraux numériques et caractère underscore

Vous pouvez utiliser un ou plusieurs caractères `_` (underscore) dans les littéraux numériques afin de les rendre plus lisibles.

Vous pouvez placer des underscores presque partout, **sauf** au début, à la fin ou juste autour du point décimal (immédiatement avant ou après).

- Exemple :
```java
int firstNum = 1_000_000;
int secondNum = 1 _____________ 2;

double firstDouble = _1000.00   // DOES NOT COMPILE
double secondDouble = 1000_.00  // DOES NOT COMPILE
double thirdDouble = 1000._00   // DOES NOT COMPILE
double fourthDouble = 1000.00_  // DOES NOT COMPILE

double pi = 3.14_159_265; // valid
long mask = 0b1111_0000;  // valid in binary literals
```

!!! tip
    Les underscores améliorent la lisibilité :
    `1_000_000` est plus facile à lire que `1000000`.
