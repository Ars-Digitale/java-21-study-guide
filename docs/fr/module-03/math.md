# 11. Mathématiques en Java

### Table des matières

- [11. Mathématiques en Java](#11-mathématiques-en-java)
	- [11.1 API Math](#111-api-math)
		- [11.1.1 Maximum et minimum entre deux valeurs](#1111-maximum-et-minimum-entre-deux-valeurs)
		- [11.1.2 Math.round](#1112-mathround)
		- [11.1.3 Math.ceil (Ceiling)](#1113-mathceil-ceiling)
		- [11.1.4 Math.floor (Floor)](#1114-mathfloor-floor)
		- [11.1.5 Math.pow](#1115-mathpow)
		- [11.1.6 Math.random](#1116-mathrandom)
		- [11.1.7 Math.abs](#1117-mathabs)
		- [11.1.8 Math.sqrt](#1118-mathsqrt)
		- [11.1.9 Tableau récapitulatif](#1119-tableau-récapitulatif)
	- [11.2 BigInteger et BigDecimal](#112-biginteger-et-bigdecimal)
		- [11.2.1 Pourquoi double et float ne suffisent pas](#1121-pourquoi-double-et-float-ne-suffisent-pas)
		- [11.2.2 BigInteger — Entiers à précision arbitraire](#1122-biginteger--entiers-à-précision-arbitraire)
		- [11.2.3 Créer BigInteger](#1123-créer-biginteger)
		- [11.2.4 Opérations (pas d’opérateurs)](#1124-opérations-pas-dopérateurs-)


---

## 11.1 API Math

La classe `java.lang.Math` fournit un ensemble de méthodes statiques utiles pour les opérations numériques.
  
Ces méthodes fonctionnent avec les types numériques primitifs.
  
Ci-dessous se trouve un résumé des plus fréquemment utilisées, ainsi que leurs formes surchargées.

### 11.1.1 Maximum et minimum entre deux valeurs

`Math.max()` et `Math.min()` comparent les deux valeurs fournies et renvoient le maximum ou le minimum entre elles.
  
Il existe quatre versions surchargées pour chaque méthode :

```java
public static int min(int x, int y);
public static float min(float x, float y);
public static long min(long x, long y);
public static double min(double x, double y);

public static int max(int x, int y);
public static float max(float x, float y);
public static long max(long x, long y);
public static double max(double x, double y);
```

- Exemple :

```java
System.out.println(Math.max(10.50, 7.5));   // 10.5
System.out.println(Math.min(10, -20));      // -20
```

### 11.1.2 `Math.round()`

`round()` renvoie l’entier le plus proche de son argument, en suivant les règles d’arrondi standard :  
les valeurs dont la partie fractionnaire est 0.5 et au-dessus sont arrondies vers le haut ; en dessous de 0.5 elles sont arrondies vers le bas (vers l’entier le plus proche).

**Surcharges**
- `long round(double value)`
- `int round(float value)`

- Exemples :

```java
Math.round(3.2);    // 3   (returns long)
Math.round(3.6);    // 4
Math.round(-3.5f);  // -3  (float version returns int)
```

!!! note
    - La version `float` renvoie un `int`.
    - La version `double` renvoie un `long`.

### 11.1.3 `Math.ceil()` (Ceiling)

`ceil()` renvoie la plus petite valeur `double` qui est supérieure ou égale à l’argument.

**Surcharge**
- `double ceil(double value)`

- Exemples :

```java
Math.ceil(3.1);   // 4.0
Math.ceil(-3.1);  // -3.0
```

### 11.1.4 `Math.floor()` (Floor)

`floor()` renvoie la plus grande valeur `double` qui est inférieure ou égale à l’argument.

**Surcharge**
- `double floor(double value)`

- Exemples :

```java
Math.floor(3.9);   // 3.0
Math.floor(-3.1);  // -4.0
```

### 11.1.5 `Math.pow()`

`pow()` élève une valeur à une puissance.

**Surcharge**
- `double pow(double base, double exponent)`

- Exemples :

```java
Math.pow(2, 3);      // 8.0
Math.pow(9, 0.5);    // 3.0  (square root)
Math.pow(10, -1);    // 0.1
```

### 11.1.6 `Math.random()`

`random()` renvoie un `double` dans l’intervalle `[0.0, 1.0)` (0.0 inclus, 1.0 exclus).

**Surcharge**
- `double random()`

- Exemples :

```java
double r = Math.random();   // 0.0 <= r < 1.0

// Example: random int 0–9
int x = (int)(Math.random() * 10);
```

### 11.1.7 `Math.abs()`

`abs()` renvoie la valeur absolue (distance à zéro).

**Surcharges**
- `int abs(int value)`
- `long abs(long value)`
- `float abs(float value)`
- `double abs(double value)`

### 11.1.8 `Math.sqrt()`

`sqrt()` calcule la racine carrée et renvoie un `double`.

```java
Math.sqrt(9);    // 3.0
Math.sqrt(-1);   // NaN (not a number)
```

### 11.1.9 Tableau récapitulatif

| Méthode | Renvoie | Surcharges | Notes |
| --- | --- | --- | --- |
| `round()` | int ou long | float, double | Entier le plus proche |
| `ceil()` | double | double | Plus petite valeur >= argument |
| `floor()` | double | double | Plus grande valeur <= argument |
| `pow()` | double | double, double | Exponentiation |
| `random()` | double | none | 0.0 <= r < 1.0 |
| `min()/max()` | même type | int, long, float, double | Compare deux valeurs |
| `abs()` | même type | int, long, float, double | Valeur absolue |
| `sqrt()` | double | double | Racine carrée |

---

## 11.2 BigInteger et BigDecimal

Les classes `BigInteger` et `BigDecimal` (dans `java.math`) fournissent des types numériques à précision arbitraire.
  
Elles sont utilisées lorsque :

- Les types primitifs (`int`, `long`, `double`, etc.) n’ont pas une plage suffisante.
- Les erreurs d’arrondi en virgule flottante de `float`/`double` ne sont pas acceptables (par exemple, dans les calculs financiers).

Les deux sont **immutables** : chaque opération renvoie une nouvelle instance.

### 11.2.1 Pourquoi `double` et `float` ne suffisent pas

Les types en virgule flottante (`float`, `double`) utilisent une représentation binaire. Beaucoup de fractions décimales ne peuvent pas être représentées exactement (comme 0.1 ou 0.2), ce qui produit des erreurs d’arrondi :

```java
System.out.println(0.1 + 0.2); // 0.30000000000000004 
```

Pour des tâches comme les calculs financiers, cela est inacceptable.
  
`BigDecimal` résout ce problème en représentant les nombres à l’aide d’un modèle décimal avec une échelle configurable (nombre de chiffres après la virgule).

### 11.2.2 BigInteger — Entiers à précision arbitraire

`BigInteger` représente des valeurs entières de taille pratiquement quelconque, limitée uniquement par la mémoire disponible.

### 11.2.3 Créer BigInteger

Méthodes courantes :

**À partir d’un long**

```java
static BigInteger valueOf(long val);
```

**À partir d’une String**

```java
BigInteger(String val);        // decimal by default
BigInteger(String val, int radix);
```

**Valeur aléatoire**

```java
BigInteger(int numBits, Random rnd);
```

- Exemples :

```java
import java.math.BigInteger;
import java.math.BigDecimal;
import java.util.Random;

BigInteger a = BigInteger.valueOf(10L);

// You can pass a long to both types, but a double only to BigDecimal

BigInteger g = BigInteger.valueOf(3000L);
BigDecimal p = BigDecimal.valueOf(3000L);
BigDecimal q = BigDecimal.valueOf(3000.00);

BigInteger b = new BigInteger("12345678901234567890"); // decimal string
BigInteger c = new BigInteger("FF", 16);               // 255 in base 16
BigInteger r = new BigInteger(128, new Random());      // random 128-bit number
```

### 11.2.4 Opérations (pas d’opérateurs !)

Vous ne pouvez pas utiliser les opérateurs arithmétiques standards (`+`, `-`, `*`, `/`, `%`) avec `BigInteger` ou `BigDecimal`.
  
À la place, vous devez appeler des méthodes (qui renvoient toutes de nouvelles instances). En voici quelques-unes courantes pour `BigInteger` :

- `add(BigInteger val)`
- `subtract(BigInteger val)`
- `multiply(BigInteger val)`
- `divide(BigInteger val)` – division entière
- `remainder(BigInteger val)`
- `pow(int exponent)`
- `negate()`
- `abs()`
- `gcd(BigInteger val)`
- `compareTo(BigInteger val)` – ordre

- Exemple :

```java
BigInteger x = new BigInteger("100000000000000000000");
BigInteger y = new BigInteger("3");

BigInteger sum = x.add(y);        // x + y
BigInteger prod = x.multiply(y);  // x * y
BigInteger div = x.divide(y);     // integer division
BigInteger rem = x.remainder(y);  // modulus

if (x.compareTo(y) > 0) {
    System.out.println("x is larger");
}
```
