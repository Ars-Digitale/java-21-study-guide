# 10. Tableaux en Java

<a id="table-des-matières"></a>
### Table des matières

- [10. Tableaux en Java](#10-tableaux-en-java)
	- [10.1 Ce qu’est un tableau](#101-ce-quest-un-tableau)
		- [10.1.1 Déclarer des tableaux](#1011-déclarer-des-tableaux)
		- [10.1.2 Créer des tableaux (instanciation)](#1012-créer-des-tableaux-instanciation)
		- [10.1.3 Valeurs par défaut dans les tableaux](#1013-valeurs-par-défaut-dans-les-tableaux)
		- [10.1.4 Accéder aux éléments](#1014-accéder-aux-éléments)
		- [10.1.5 Raccourcis d’initialisation de tableaux](#1015-raccourcis-dinitialisation-de-tableaux)
			- [10.1.5.1 Création anonyme de tableau](#10151-création-anonyme-de-tableau)
			- [10.1.5.2 Syntaxe courte (uniquement à la déclaration)](#10152-syntaxe-courte-uniquement-à-la-déclaration)
	- [10.2 Tableaux multidimensionnels (tableaux de tableaux)](#102-tableaux-multidimensionnels-tableaux-de-tableaux)
		- [10.2.1 Créer un tableau rectangulaire](#1021-créer-un-tableau-rectangulaire)
		- [10.2.2 Créer un tableau dentelé (irrégulier)](#1022-créer-un-tableau-dentelé-irrégulier)
	- [10.3 Longueur d’un tableau vs longueur d’une chaîne](#103-longueur-dun-tableau-vs-longueur-dune-chaîne)
	- [10.4 Affectations de références de tableaux](#104-affectations-de-références-de-tableaux)
		- [10.4.1 Affecter des références compatibles](#1041-affecter-des-références-compatibles)
		- [10.4.2 Affectations incompatibles (erreurs à la compilation)](#1042-affectations-incompatibles-erreurs-à-la-compilation)
		- [10.4.3 Danger d’exécution de la covariance : ArrayStoreException](#1043-danger-dexécution-de-la-covariance--arraystoreexception)
	- [10.5 Comparer des tableaux](#105-comparer-des-tableaux)
	- [10.6 Méthodes utilitaires de Arrays](#106-méthodes-utilitaires-de-arrays)
		- [10.6.1 Arrays.toString](#1061-arraystostring)
		- [10.6.2 Arrays.deepToString pour les tableaux imbriqués](#1062-arraysdeeptostring-pour-les-tableaux-imbriqués)
		- [10.6.3 Arrays.sort](#1063-arrayssort)
		- [10.6.4 Arrays.binarySearch](#1064-arraysbinarysearch)
		- [10.6.5 Arrays.compare](#1065-arrayscompare)
	- [10.7 Boucle for améliorée avec les tableaux](#107-boucle-for-améliorée-avec-les-tableaux)
	- [10.8 Pièges courants](#108-pièges-courants)
	- [10.9 Résumé](#109-résumé)


---

<a id="101-ce-quest-un-tableau"></a>
## 10.1 Ce qu’est un tableau

Les tableaux en Java sont des collections **à taille fixe**, **indexées**, **ordonnées** d’éléments du même type.
  
Ce sont des **objets**, même lorsque les éléments sont des primitifs.

<a id="1011-déclarer-des-tableaux"></a>
### 10.1.1 Déclarer des tableaux

Vous pouvez déclarer un tableau de deux façons :

```java
int[] a;      // preferred modern syntax
int b[];      // legal, older style
String[] names;
Person[] people;

// [] can be before or after the name: all the following declarations are equivalent.

int[] x;
int [] x1;
int []x2;
int x3[];
int x5 [];

// MULTIPLE ARRAY DECLARATIONS

int[] arr1, arr2;   // Declares two arrays of int

// WARNING:
// Here arr1 is an int[] and arr2 is just an int (NOT an array!)
int arr1[], arr2;
```

**Déclarer ne crée PAS le tableau** — cela crée seulement une variable capable d’en référencer un.

<a id="1012-créer-des-tableaux-instanciation"></a>
### 10.1.2 Créer des tableaux (instanciation)

Un tableau est créé en utilisant `new` suivi du type des éléments et de la longueur du tableau :

```java
int[] numbers = new int[5];
String[] words = new String[3];
```

**Règles clés**
- La longueur doit être non négative et spécifiée au moment de la création.
- La longueur ne peut pas être modifiée ensuite.
- La longueur du tableau peut être n’importe quelle expression `int`.

```java
int size = 4;
double[] values = new double[size];
```

- Exemples illégaux de création de tableau :

```java
// int length = -1;           
// int[] arr = new int[-1];   // Runtime: NegativeArraySizeException

// int[] arr = new int[2.5];  // Compile error: size must be int
```

<a id="1013-valeurs-par-défaut-dans-les-tableaux"></a>
### 10.1.3 Valeurs par défaut dans les tableaux

Les tableaux (puisque ce sont des objets) reçoivent toujours une **initialisation par défaut** :

| Type d’élément | Valeur par défaut |
| --- | --- |
| Numérique | 0 |
| boolean | false |
| char | '\u0000' |
| Types référence | null |

- Exemple :

```java
int[] nums = new int[3]; 
System.out.println(nums[0]); // 0

String[] s = new String[3];
System.out.println(s[0]);    // null
```

<a id="1014-accéder-aux-éléments"></a>
### 10.1.4 Accéder aux éléments

On accède aux éléments en utilisant une indexation à base zéro :

```java
int[] a = new int[3];
a[0] = 10;
a[1] = 20;
System.out.println(a[1]); // 20
```

**Exception courante**  
- `ArrayIndexOutOfBoundsException` (à l’exécution)

```java
// int[] x = new int[2];
// System.out.println(x[2]); // ❌ index 2 out of bounds
```

<a id="1015-raccourcis-dinitialisation-de-tableaux"></a>
### 10.1.5 Raccourcis d’initialisation de tableaux

<a id="10151-création-anonyme-de-tableau"></a>
### 10.1.5.1 Création anonyme de tableau

```java
int[] a = new int[] {1,2,3};
```

<a id="10152-syntaxe-courte-uniquement-à-la-déclaration"></a>
### 10.1.5.2 Syntaxe courte (uniquement à la déclaration)

```java
int[] b = {1,2,3};
```

> La syntaxe courte `{1,2,3}` ne peut être utilisée qu’au moment de la déclaration.

```java
// int[] c;
// c = {1,2,3};  // ❌ does not compile
```

---

<a id="102-tableaux-multidimensionnels-tableaux-de-tableaux"></a>
## 10.2 Tableaux multidimensionnels (tableaux de tableaux)

Java implémente les tableaux multi-dimensionnels comme des **tableaux de tableaux**.

Déclaration :

```java
int[][] matrix;
String[][][] cube;
```

<a id="1021-créer-un-tableau-rectangulaire"></a>
### 10.2.1 Créer un tableau rectangulaire

```java
int[][] rect = new int[3][4]; // 3 rows, 4 columns each
```

<a id="1022-créer-un-tableau-dentelé-irrégulier"></a>
### 10.2.2 Créer un tableau dentelé (irrégulier)

Vous pouvez créer des lignes de longueurs différentes :

```java
int[][] jagged = new int[3][];
jagged[0] = new int[2];
jagged[1] = new int[5];
jagged[2] = new int[1];
```

---

<a id="103-longueur-dun-tableau-vs-longueur-dune-chaîne"></a>
## 10.3 Longueur d’un tableau vs longueur d’une chaîne

- Les tableaux utilisent `.length` (champ `public final`).
- Les chaînes utilisent `.length()` (méthode).

!!! tip
    C’est un piège classique: champs vs méthodes.

```java
// int x = arr.length;   // OK
// int y = s.length;     // ❌ does not compile: missing ()
int yOk = s.length();
```

---

<a id="104-affectations-de-références-de-tableaux"></a>
## 10.4 Affectations de références de tableaux

<a id="1041-affecter-des-références-compatibles"></a>
### 10.4.1 Affecter des références compatibles

```java
int[] a = {1,2,3};
int[] b = a; // both now point to the same array
```

Modifier une référence affecte l’autre :

```java
b[0] = 99;
System.out.println(a[0]); // 99
```

<a id="1042-affectations-incompatibles-erreurs-à-la-compilation"></a>
### 10.4.2 Affectations incompatibles (erreurs à la compilation)

```java
// int[] x = new int[3];
// long[] y = x;     // ❌ incompatible types
```

Les références de tableaux suivent les règles normales d’héritage :

```java
String[] s = new String[3];
Object[] o = s;      // OK: arrays are covariant
```

<a id="1043-danger-dexécution-de-la-covariance-arraystoreexception"></a>
### 10.4.3 Danger d’exécution de la covariance : `ArrayStoreException`

```java
Object[] objs = new String[3];
// objs[0] = Integer.valueOf(5); // ❌ ArrayStoreException at runtime
```

---

<a id="105-comparer-des-tableaux"></a>
## 10.5 Comparer des tableaux

`==` compare les références (identité) :

```java
int[] a = {1,2};
int[] b = {1,2};
System.out.println(a == b); // false
```

`equals()` sur les tableaux ne compare pas le contenu (il se comporte comme `==`) :

```java
System.out.println(a.equals(b)); // false
```

Pour comparer le contenu, utilisez des méthodes de `java.util.Arrays` :

```java
Arrays.equals(a, b);         // shallow comparison
Arrays.deepEquals(o1, o2);   // deep comparison for nested arrays
```

---

<a id="106-méthodes-utilitaires-de-arrays"></a>
## 10.6 Méthodes utilitaires de `Arrays`

<a id="1061-arraystostring"></a>
### 10.6.1 `Arrays.toString()`

```java
System.out.println(Arrays.toString(new int[]{1,2,3})); // [1, 2, 3]
```

<a id="1062-arraysdeeptostring-pour-les-tableaux-imbriqués"></a>
### 10.6.2 `Arrays.deepToString()` (pour les tableaux imbriqués)

```java
System.out.println(Arrays.deepToString(new int[][] {{1,2},{3,4}}));
// [[1, 2], [3, 4]]
```

<a id="1063-arrayssort"></a>
### 10.6.3 `Arrays.sort()`

```java
int[] a = {4,1,3};
Arrays.sort(a); // [1, 3, 4]
```

!!! tip
    - Les chaînes sont triées selon l’ordre naturel (lexicographique).
    - Les nombres sont triés avant les lettres, et les lettres majuscules sont triées avant les minuscules (nombres < majuscules < minuscules).
    - Pour les types référence, `null` est considéré plus petit que toute valeur non nulle.

```java
String[] arr = {"AB", "ac", "Ba", "bA", "10", "99"};

Arrays.sort(arr);

System.out.println(Arrays.toString(arr));  // [10, 99, AB, Ba, ac, bA]
```

<a id="1064-arraysbinarysearch"></a>
### 10.6.4 `Arrays.binarySearch()`

Exigences : le tableau doit être trié selon le même ordre ; sinon le résultat est imprévisible.

```java
int[] a = {1,3,5,7};
int idx = Arrays.binarySearch(a, 5); // returns 2
```

Quand la valeur n’est pas trouvée, `binarySearch` renvoie `-(insertionPoint) - 1` :

```java
int pos = Arrays.binarySearch(a, 4); // returns -3
// Insertion point is index 2 → -(2) - 1 = -3
```

<a id="1065-arrayscompare"></a>
### 10.6.5 `Arrays.compare()`

La classe `Arrays` propose un `equals()` surchargé qui vérifie si deux tableaux contiennent les mêmes éléments (et ont la même longueur) :

```java
System.out.println(Arrays.equals(new int[] {200}, new int[] {100}));        // false
System.out.println(Arrays.equals(new int[] {200}, new int[] {200}));        // true
System.out.println(Arrays.equals(new int[] {200}, new int[] {100, 200}));   // false
```

Elle fournit aussi une méthode `compare()` avec ces règles :

- Si le résultat `n < 0` → le premier tableau est considéré “plus petit” que le second.
- Si le résultat `n > 0` → le premier tableau est considéré “plus grand” que le second.
- Si le résultat `n == 0` → les tableaux sont égaux.

- Exemples :

```java
int[] arr1 = new int[] {200, 300};
int[] arr2 = new int[] {200, 300, 400};
System.out.println(Arrays.compare(arr1, arr2));  // -1

int[] arr3 = new int[] {200, 300, 400};
int[] arr4 = new int[] {200, 300};
System.out.println(Arrays.compare(arr3, arr4));  // 1

String[] arr5 = new String[] {"200", "300", "aBB"};
String[] arr6 = new String[] {"200", "300", "ABB"};
System.out.println(Arrays.compare(arr5, arr6));     // Positive: "aBB" > "ABB"

String[] arr7 = new String[] {"200", "300", "ABB"};
String[] arr8 = new String[] {"200", "300", "aBB"};
System.out.println(Arrays.compare(arr7, arr8));     // Negative: "ABB" < "aBB"

String[] arr9 = null;
String[] arr10 = new String[] {"200", "300", "ABB"};
System.out.println(Arrays.compare(arr9, arr10));    // -1 (null considered smaller)
```

---

<a id="107-boucle-for-améliorée-avec-les-tableaux"></a>
## 10.7 Boucle for améliorée avec les tableaux

```java
for (int value : new int[]{1,2,3}) {
    System.out.println(value);
}
```

**Règles**
- Le côté droit doit être un tableau ou un `Iterable`.
- Le type de la variable de boucle doit être compatible avec le type d’élément (pas d’élargissement de primitifs ici).

Erreur courante :

```java
// for (long v : new int[]{1,2}) {} // ❌ not allowed: int elements cannot be assigned to long in enhanced for-loop
```

---

<a id="108-pièges-courants"></a>
## 10.8 Pièges courants

- **Accès hors limites** → lance `ArrayIndexOutOfBoundsException`.

- **Mauvaise utilisation de l’initialiseur court**

```java
// int[] x;
// x = {1,2}; // ❌ does not compile
```

- **Confondre `.length` et `.length()`**
- Oublier que les tableaux sont des objets (ils vivent sur le heap et sont référencés).

- **Mélanger des tableaux de primitifs et des tableaux de wrappers**

```java
// int[] p = new Integer[3]; // ❌ incompatible
```

- **Utiliser `binarySearch` sur des tableaux non triés** → résultats imprévisibles.
- **Exceptions d’exécution dues aux tableaux covariants** (`ArrayStoreException`).

---

<a id="109-résumé"></a>
## 10.9 Résumé

Les tableaux en Java sont :

- Des objets (même s’ils contiennent des primitifs).
- Des collections indexées à taille fixe.
- Toujours initialisés avec des valeurs par défaut.
- Type-safe, mais soumis aux règles de covariance (ce qui peut provoquer des exceptions à l’exécution si mal utilisé).
