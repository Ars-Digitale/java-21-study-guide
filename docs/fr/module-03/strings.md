# 9. Chaînes de caractères en Java

<a id="table-des-matières"></a>
### Table des matières

- [9. Chaînes de caractères en Java](#9-chaînes-de-caractères-en-java)
	- [9.1 Chaînes & Text Blocks](#91-chaînes--text-blocks)
		- [9.1.1 Chaînes](#911-chaînes)
			- [9.1.1.1 Initialiser des chaînes](#9111-initialiser-des-chaînes)
			- [9.1.1.2 Le String Pool](#9112-le-string-pool)
			- [9.1.1.3 Caractères spéciaux et séquences d’échappement](#9113-caractères-spéciaux-et-séquences-déchappement)
			- [9.1.1.4 Règles de concaténation des chaînes](#9114-règles-de-concaténation-des-chaînes)
			- [9.1.1.5 Règles de concaténation](#9115-règles-de-concaténation)
		- [9.1.2 Text Blocks (depuis Java 15)](#912-text-blocks-depuis-java-15)
			- [9.1.2.1 Mise en forme : espaces essentiels vs incidentels](#9121-mise-en-forme--espaces-essentiels-vs-incidentels)
			- [9.1.2.2 Nombre de lignes, lignes vides et retours à la ligne](#9122-nombre-de-lignes-lignes-vides-et-retours-à-la-ligne)
			- [9.1.2.3 Text Blocks et caractères d’échappement](#9123-text-blocks-et-caractères-déchappement)
			- [9.1.2.4 Erreurs courantes (avec corrections)](#9124-erreurs-courantes-avec-corrections)
	- [9.2 Méthodes principales des chaînes](#92-méthodes-principales-des-chaînes)
		- [9.2.1 Indexation des chaînes](#921-indexation-des-chaînes)
		- [9.2.2 Méthode length](#922-méthode-length)
		- [9.2.3 Règles de bornes : index de début vs index de fin](#923-règles-de-bornes--index-de-début-vs-index-de-fin)
		- [9.2.4 Méthodes utilisant uniquement l’index de début (inclusif)](#924-méthodes-utilisant-uniquement-lindex-de-début-inclusif)
		- [9.2.5 Méthodes avec début inclusif / fin exclusive](#925-méthodes-avec-début-inclusif--fin-exclusive)
		- [9.2.6 Méthodes opérant sur toute la chaîne](#926-méthodes-opérant-sur-toute-la-chaîne)
		- [9.2.7 Accès aux caractères](#927-accès-aux-caractères)
		- [9.2.8 Recherche](#928-recherche)
		- [9.2.9 Méthodes de remplacement](#929-méthodes-de-remplacement)
		- [9.2.10 Découpage et jonction](#9210-découpage-et-jonction)
		- [9.2.11 Méthodes retournant des tableaux](#9211-méthodes-retournant-des-tableaux)
		- [9.2.12 Indentation](#9212-indentation)
		- [9.2.13 Exemples supplémentaires](#9213-exemples-supplémentaires)


---

<a id="91-chaînes-text-blocks"></a>
## 9.1 Chaînes & Text Blocks

<a id="911-chaînes"></a>
### 9.1.1 Chaînes

<a id="9111-initialiser-des-chaînes"></a>
### 9.1.1.1 Initialiser des chaînes

En Java, une **String** est un objet de la classe `java.lang.String`, utilisé pour représenter une séquence de caractères.
  
Les chaînes sont **immutables** : une fois créées, leur contenu ne peut pas être modifié. Toute opération qui semble modifier une chaîne en crée en réalité une nouvelle.

Vous pouvez créer et initialiser des chaînes de plusieurs façons :

```java
String s1 = "Hello";                    // string literal
String s2 = new String("Hello");        // using constructor (not recommended)
String s3 = s1.toUpperCase();           // creates a new String ("HELLO")
```

!!! note
    - Les littéraux de chaîne sont stockés dans le `pool de String`, une zone mémoire spéciale utilisée pour éviter de créer des objets chaîne en double.
    - L’utilisation du mot-clé `new` crée toujours un nouvel objet en dehors du pool.

<a id="9112-le-string-pool"></a>
### 9.1.1.2 Le String Pool

Comme les objets `String` sont immuables et largement utilisés, ils pourraient facilement occuper une grande quantité de mémoire dans un programme Java.
  
Pour réduire la duplication, Java réutilise toutes les chaînes déclarées comme littéraux (voir l’exemple ci-dessus), en les stockant dans une zone dédiée de la JVM appelée **String Pool** ou **Intern Pool**.

Veuillez consulter le paragraphe : **"6.4.3 String Pool and Equality"** dans le chapitre : [Instanciation des types](../module-01/instantiating-types.md) pour une explication et des exemples plus détaillés.

<a id="9113-caractères-spéciaux-et-séquences-déchappement"></a>
### 9.1.1.3 Caractères spéciaux et séquences d’échappement

Les chaînes peuvent contenir des caractères d’échappement, qui permettent d’inclure des symboles spéciaux ou des caractères de contrôle (caractères ayant une signification spéciale en Java).  
Une séquence d’échappement commence par un backslash `\`.

!!! note
    **Table des caractères spéciaux & séquences d’échappement dans les chaînes**

| Escape | Signification | Exemple Java | Résultat |
| --- | --- | --- | --- |
| `\"` | guillemet double | `"She said \"Hi\""` | `She said "Hi"` |
| `\\` | backslash | `"C:\\Users\\Alex"` | `C:\Users\Alex` |
| `\n` | nouvelle ligne (LF) | `"Hello\nWorld"` | `Hello` + line break + `World` |
| `\r` | retour chariot (CR) | `"A\rB"` | `CR before B` |
| `\t` | tabulation | `"Name\tAge"` | `Name    Age` |
| `\'` | guillemet simple | `"It\'s ok"` | `It's ok` |
| `\b` | retour arrière (backspace) | `"AB\bC"` | `AC` (le `B` est supprimé visuellement) |
| `\uXXXX` | unité de code Unicode | `"\u00A9"` | `©` |

<a id="9114-règles-de-concaténation-des-chaînes"></a>
### 9.1.1.4 Règles de concaténation des chaînes

Comme introduit dans le chapitre sur [Opérateurs Java](../module-01/java-operators.md), le symbole `+` représente normalement l’**addition arithmétique** lorsqu’il est utilisé avec des opérandes numériques.

Cependant, lorsqu’il est appliqué aux **String**, le même opérateur effectue la **concaténation de chaînes** — il crée une nouvelle chaîne en joignant les opérandes.

Comme l’opérateur `+` peut apparaître dans des expressions où des nombres et des chaînes sont présents, Java applique un ensemble spécifique de règles pour déterminer si `+` signifie **addition numérique** ou **concaténation de chaînes**.

<a id="9115-règles-de-concaténation"></a>
### 9.1.1.5 Règles de concaténation

- Si les deux opérandes sont numériques, `+` effectue l’**addition numérique**.
- Si au moins un opérande est une `String`, l’opérateur `+` effectue la **concaténation de chaînes**.
- L’évaluation se fait strictement de gauche à droite, car `+` est **associatif à gauche**.  

Cela signifie qu’une fois qu’une `String` apparaît sur le côté gauche de l’expression, toutes les opérations `+` suivantes deviennent des concaténations.

!!! tip
    Comme l’évaluation se fait de gauche à droite, la position du premier opérande `String` détermine comment le reste de l’expression est évalué.

- Exemples

```java
// *** Pure numeric addition

int a = 10 + 20;        // 30
double b = 1.5 + 2.3;   // 3.8



// *** String concatenation when at least one operand is a String

String s = "Hello" + " World";  // "Hello World"
String t = "Value: " + 10;      // "Value: 10"



// *** Left-to-right evaluation affects the result

System.out.println(1 + 2 + " apples"); 
// 3 + " apples"  → "3 apples"

System.out.println("apples: " + 1 + 2); 
// "apples: 1" + 2 → "apples: 12"



// *** Adding parentheses changes the meaning

System.out.println("apples: " + (1 + 2)); 
// parentheses force numeric addition → "apples: 3"



// *** Mixed types with multiple operands

String result = 10 + 20 + "" + 30 + 40;
// (10 + 20) = 30
// 30 + ""  = "30"
// "30" + 30 = "3030"
String out = "3030" + 40; // "303040"

System.out.println(1 + 2 + "3" + 4 + 5);
// Step 1: 1 + 2 = 3
// Step 2: 3 + "3" = "33"
String r = "33" + 4;  // "334"
// Step 4: "334" + 5 = "3345"



// *** null is represented as a string when concatenated

System.out.println("AB" + null);
// ABnull
```

<a id="912-text-blocks-depuis-java-15"></a>
### 9.1.2 Text Blocks (depuis Java 15)

Un text block est un littéral de chaîne multi-ligne introduit pour simplifier l’écriture de grandes chaînes (comme du HTML, du JSON ou du code) sans avoir besoin de nombreuses séquences d’échappement.
  
Un text block commence et se termine par trois guillemets doubles (`"""`).
  
Vous pouvez utiliser les text blocks partout où vous utiliseriez des chaînes.

```java
String html = """
    <html>
        <body>
            <p>Hello, world!</p>
        </body>
    </html>
    """;
```

!!! note
    - Les text blocks incluent automatiquement les retours à la ligne et l’indentation pour la lisibilité. Les newlines sont normalisés en `\n`.
    - Les guillemets doubles à l’intérieur du bloc n’ont généralement pas besoin d’être échappés.
    - Le compilateur interprète le contenu entre les triples guillemets d’ouverture et de fermeture comme la valeur de la chaîne.

<a id="9121-mise-en-forme-espaces-essentiels-vs-incidentels"></a>
### 9.1.2.1 Mise en forme : espaces essentiels vs incidentels

- **Espaces essentiels** : espaces et newlines qui font partie du contenu de chaîne voulu.
- **Espaces incidentels** : indentation dans le code source que vous ne considérez pas conceptuellement comme faisant partie du texte.

```java
String text = """
        Line 1
        Line 2
        Line 3
        """;
```

!!! important
    - **Caractère le plus à gauche (baseline)** : la position du premier caractère non-espace sur l’ensemble des lignes (ou les `"""` de fermeture) définit la baseline d’indentation. Les espaces à gauche de cette baseline sont considérés comme incidentels et sont supprimés.
    - La ligne immédiatement après les `"""` d’ouverture n’est pas incluse dans la sortie si elle est vide (mise en forme typique).
    - Le newline avant les `"""` de fermeture est inclus dans le contenu.  
      Dans l’exemple ci-dessus, la chaîne résultante se termine par un newline après `"Line 3"` : il y a 4 lignes au total.

Sortie avec numéros de ligne (montrant la ligne vide finale) :

```text
1: Line 1
2: Line 2
3: Line 3
4:
```

Pour supprimer le newline final :

- Utilisez un backslash de continuation de ligne à la fin de la dernière ligne de contenu.
- Placez les triples guillemets de fermeture sur la même ligne que le dernier contenu.

```java
String textNoTrail_1 = """
        Line 1
        Line 2
        Line 3\
        """;

// OR

String textNoTrail_2 = """
        Line 1
        Line 2
        Line 3""";
```

<a id="9122-nombre-de-lignes-lignes-vides-et-retours-à-la-ligne"></a>
### 9.1.2.2 Nombre de lignes, lignes vides et retours à la ligne

- Chaque retour à la ligne visible à l’intérieur du bloc devient `\n`.
- Les lignes vides à l’intérieur du bloc sont conservées.

```java
String textNoTrail_0 = """
        Line 1  
        Line 2 \n
        Line 3 
        
        Line 4 
        """;
```

Sortie :

```text
1: Line 1
2: Line 2
3:
4: Line 3
5:
6: Line 4
7:
```

<a id="9123-text-blocks-et-caractères-déchappement"></a>
### 9.1.2.3 Text Blocks et caractères d’échappement

Les séquences d’échappement fonctionnent toujours à l’intérieur des text blocks lorsque nécessaire (par exemple, pour les backslashes ou des caractères de contrôle explicites).

```java
String json = """
    {
      "name": "Alice",
      "path": "C:\\\\Users\\\\Alice"
    }\
    """;
```

Vous pouvez également formater un text block en utilisant des placeholders et `formatted()` :

```java
String card = """
    Name: %s
    Age:  %d
    """.formatted("Alice", 30);
```

<a id="9124-erreurs-courantes-avec-corrections"></a>
### 9.1.2.4 Erreurs courantes (avec corrections)

```java
// ❌ Mismatched delimiters / missing closing triple quote
String bad = """
  Hello
World";      // ERROR — not a closing text block

// ✅ Fix
String ok = """
  Hello
  World
  """;
```

```java
// ❌ Text blocks require a line break after the opening """
String invalid = """Hello""";  // ERROR

// ✅ Fix
String valid = """
    Hello
    """;
```

```java
// ❌ Unescaped trailing backslash at end of a line inside the block
String wrong = """
    C:\Users\Alex\     // ERROR — backslash escapes the newline
    Documents
    """;

// ✅ Fix: escape backslashes, or avoid backslash at end of line
String correct = """
    C:\\Users\\Alex\\
    Documents\
    """;
```

---

<a id="92-méthodes-principales-des-chaînes"></a>
## 9.2 Méthodes principales des chaînes

<a id="921-indexation-des-chaînes"></a>
### 9.2.1 Indexation des chaînes

Les chaînes en Java utilisent une **indexation à base zéro**, ce qui signifie :

- Le premier caractère est à l’index `0`
- Le dernier caractère est à l’index `length() - 1`
- Accéder à un index en dehors de cette plage provoque une `StringIndexOutOfBoundsException`

- Exemple :

```java
String s = "Java";
// Indexes:  0    1    2    3
// Chars:    J    a    v    a

char c = s.charAt(2); // 'v'
```

<a id="922-méthode-length"></a>
### 9.2.2 Méthode `length()`

`length()` renvoie le nombre de caractères dans la chaîne.

```java
String s = "hello";
System.out.println(s.length());  // 5
```

Le dernier index valide est toujours `length() - 1`.

<a id="923-règles-de-bornes-index-de-début-vs-index-de-fin"></a>
### 9.2.3 Règles de bornes : index de début vs index de fin

De nombreuses méthodes de `String` utilisent deux indices :

- **Index de début** — inclusif
- **Index de fin** — exclusif

Autrement dit, `substring(start, end)` inclut les caractères depuis l’index `start` jusqu’à (mais sans inclure) l’index `end`.

- L’index de début doit être `>= 0` et `<= length() - 1`
- L’index de fin peut être égal à `length()` (la “position virtuelle” après le dernier caractère).
- L’index de fin ne doit pas dépasser `length()`.
- L’index de début ne doit jamais être supérieur à l’index de fin.

- Exemple :

```java
String s = "abcdef";
s.substring(1, 4); // "bcd" (indexes 1,2,3)
```

Cette règle s’applique à la plupart des méthodes basées sur substring.

<a id="924-méthodes-utilisant-uniquement-lindex-de-début-inclusif"></a>
### 9.2.4 Méthodes utilisant uniquement l’index de début (inclusif)

| Méthode | Description | Paramètres | Règle d’index | Exemple |
| --- | --- | --- | --- | --- |
| substring(int start) | Renvoie la sous-chaîne de start à la fin | start | start inclusif | "abcdef".substring(2) → "cdef" |
| indexOf(String) | Première occurrence | — | — | "Java".indexOf("a") → 1 |
| indexOf(String, start) | Commence la recherche à l’index | start | start inclusif | "banana".indexOf("a", 2) → 3 |
| lastIndexOf(String) | Dernière occurrence | — | — | "banana".lastIndexOf("a") → 5 |
| lastIndexOf(String, fromIndex) | Recherche à rebours depuis l’index | fromIndex | fromIndex inclusif | "banana".lastIndexOf("a", 3) → 3 |

<a id="925-méthodes-avec-début-inclusif-fin-exclusive"></a>
### 9.2.5 Méthodes avec début inclusif / fin exclusive

Ces méthodes suivent le même comportement de découpage : `start` inclus, `end` exclus.

| Méthode | Description | Signature | Exemple |
| --- | --- | --- | --- |
| substring(start, end) | Extrait une partie de la chaîne | (int start, int end) | "abcdef".substring(1,4) → "bcd" |
| regionMatches | Compare des régions de sous-chaînes | (toffset, other, ooffset, len) | "Hello".regionMatches(1, "ell", 0, 3) → true |
| getBytes(int srcBegin, int srcEnd, byte[] dst, int dstBegin) | Copie des caractères dans un tableau de bytes | début inclusif, fin exclusive | Copie les caractères dans [srcBegin, srcEnd) |
| copyValueOf(char[] data, int offset, int count) | Crée une nouvelle chaîne | offset inclusif ; offset+count exclusif | Même règle que substring |

<a id="926-méthodes-opérant-sur-toute-la-chaîne"></a>
### 9.2.6 Méthodes opérant sur toute la chaîne

| Méthode | Description | Exemple |
| --- | --- | --- |
| toUpperCase() | Version en majuscules | "java".toUpperCase() → "JAVA" |
| toLowerCase() | Version en minuscules | "JAVA".toLowerCase() → "java" |
| trim() | Supprime les espaces en début/fin | "  hi  ".trim() → "hi" |
| strip() | Trim compatible Unicode | "  hi\u2003".strip() → "hi" |
| stripLeading() | Supprime les espaces initiaux | "  hi".stripLeading() → "hi" |
| stripTrailing() | Supprime les espaces finaux | "hi  ".stripTrailing() → "hi" |
| isBlank() | Vrai si vide ou uniquement des espaces | "  ".isBlank() → true |
| isEmpty() | Vrai si length == 0 | "".isEmpty() → true |

<a id="927-accès-aux-caractères"></a>
### 9.2.7 Accès aux caractères

| Méthode | Description | Exemple |
| --- | --- | --- |
| charAt(int index) | Renvoie le caractère à l’index | "Java".charAt(2) → 'v' |
| codePointAt(int index) | Renvoie le point de code Unicode | Utile pour les emojis ou les caractères au-delà du BMP |

<a id="928-recherche"></a>
### 9.2.8 Recherche

| Méthode | Description | Exemple |
| --- | --- | --- |
| contains(CharSequence) | Test de sous-chaîne | "hello".contains("ell") → true |
| startsWith(String) | Préfixe | "abcdef".startsWith("abc") → true |
| startsWith(String, offset) | Préfixe à l’index | "abc".startsWith("b", 1) → true |
| endsWith(String) | Suffixe | "abcdef".endsWith("def") → true |

<a id="929-méthodes-de-remplacement"></a>
### 9.2.9 Méthodes de remplacement

| Méthode | Description | Exemple |
| --- | --- | --- |
| replace(char old, char new) | Remplace des caractères | "banana".replace('a','o') → "bonono" |
| replace(CharSequence old, CharSequence new) | Remplace des sous-chaînes | "ababa".replace("aba","X") → "Xba" |
| replaceAll(String regex, String replacement) | Remplacement regex global | "a1a2".replaceAll("\\d","") → "aa" |
| replaceFirst(String regex, String replacement) | Seulement la première correspondance regex | "a1a2".replaceFirst("\\d","") → "aa2" |

<a id="9210-découpage-et-jonction"></a>
### 9.2.10 Découpage et jonction

| Méthode | Description | Exemple |
| --- | --- | --- |
| split(String regex) | Découpe par regex | "a,b,c".split(",") → ["a","b","c"] |
| split(String regex, int limit) | Découpe avec limite | limit < 0 conserve toutes les chaînes vides finales |

<a id="9211-méthodes-retournant-des-tableaux"></a>
### 9.2.11 Méthodes retournant des tableaux

| Méthode | Description | Exemple |
| --- | --- | --- |
| toCharArray() | Renvoie char[] | "abc".toCharArray() |
| getBytes() | Renvoie byte[] en utilisant l’encodage plateforme/par défaut | "á".getBytes() |

<a id="9212-indentation"></a>
### 9.2.12 Indentation

| Méthode | Description | Exemple |
| --- | --- | --- |
| indent(int numSpaces) | Ajoute (positif) ou supprime (négatif) des espaces au début de chaque ligne ; ajoute aussi un retour à la ligne final s’il n’est pas déjà présent | str.indent(-20) |
| stripIndent() | Supprime tous les espaces initiaux incidentels de chaque ligne ; n’ajoute pas de retour à la ligne final | str.stripIndent() |

- Exemple :

```java
var txtBlock = """
                
                    a
                      b
                     c""";
        
var conc = " a\n" + " b\n" + " c";

System.out.println("length: " + txtBlock.length());
System.out.println(txtBlock);
System.out.println("");
String stripped1 = txtBlock.stripIndent();
System.out.println(stripped1);
System.out.println("length: " + stripped1.length());

System.out.println("*********************");

System.out.println("length: " + conc.length());
System.out.println(conc);
System.out.println("");
String stripped2 = conc.stripIndent();
System.out.println(stripped2);
System.out.println("length: " + stripped2.length());
```

Sortie :

```bash
length: 9

a
  b
 c


a
  b
 c
length: 9
*********************
length: 8
 a
 b
 c

a
b
c
length: 5
```

<a id="9213-exemples-supplémentaires"></a>
### 9.2.13 Exemples supplémentaires

- Exemple 1 — Extraire `[start, end)`

```java
String s = "012345";
System.out.println(s.substring(2, 5));
// includes 2,3,4 → prints "234"
```

- Exemple 2 — Recherche à partir d’un index de début

```java
String s = "hellohello";
int idx = s.indexOf("lo", 5); // search begins at index 5
```

- Exemple 3 — Pièges courants

```java
String s = "abcd";
System.out.println(s.substring(1,1)); // "" empty string
System.out.println(s.substring(3, 2)); // ❌ Exception: start index (3) > end index (2)

System.out.println("abcd".substring(2, 4)); // "cd" — includes indexes 2 and 3; 4 is excluded but legal here

System.out.println("abcd".substring(2, 5)); // ❌ StringIndexOutOfBoundsException (end index 5 is invalid)
```
