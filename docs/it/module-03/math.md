# 11. Matematica in Java

### Indice

- [11. Matematica in Java](#11-matematica-in-java)
	- [11.1 API Math](#111-api-math)
		- [11.1.1 Massimo e minimo tra due valori](#1111-massimo-e-minimo-tra-due-valori)
		- [11.1.2 Math.round](#1112-mathround)
		- [11.1.3 Math.ceil (Ceiling)](#1113-mathceil-ceiling)
		- [11.1.4 Math.floor (Floor)](#1114-mathfloor-floor)
		- [11.1.5 Math.pow](#1115-mathpow)
		- [11.1.6 Math.random](#1116-mathrandom)
		- [11.1.7 Math.abs](#1117-mathabs)
		- [11.1.8 Math.sqrt](#1118-mathsqrt)
		- [11.1.9 Tabella riassuntiva](#1119-tabella-riassuntiva)
	- [11.2 BigInteger e BigDecimal](#112-biginteger-e-bigdecimal)
		- [11.2.1 Perché double e float non sono sufficienti](#1121-perché-double-e-float-non-sono-sufficienti)
		- [11.2.2 BigInteger — Interi a precisione arbitraria](#1122-biginteger--interi-a-precisione-arbitraria)
		- [11.2.3 Creare BigInteger](#1123-creare-biginteger)
		- [11.2.4 Operazioni (niente operatori)](#1124-operazioni-niente-operatori)


---

## 11.1 API Math

La classe `java.lang.Math` fornisce un insieme di metodi statici utili per operazioni numeriche.
  
Questi metodi funzionano con i tipi numerici primitivi.
  
Di seguito una sintesi di quelli usati più frequentemente, insieme alle loro forme sovraccaricate.

### 11.1.1 Massimo e minimo tra due valori

`Math.max()` e `Math.min()` confrontano i due valori forniti e restituiscono il massimo o il minimo tra di essi.
  
Esistono quattro versioni sovraccaricate per ciascun metodo:

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

- Esempio:

```java
System.out.println(Math.max(10.50, 7.5));   // 10.5
System.out.println(Math.min(10, -20));      // -20
```

### 11.1.2 `Math.round()`

`round()` restituisce l’intero più vicino al suo argomento, seguendo le regole standard di arrotondamento:  
i valori con parte frazionaria 0.5 e superiore vengono arrotondati verso l’alto; sotto 0.5 vengono arrotondati verso il basso (verso l’intero più vicino).

**Overload**
- `long round(double value)`
- `int round(float value)`

- Esempi:

```java
Math.round(3.2);    // 3   (returns long)
Math.round(3.6);    // 4
Math.round(-3.5f);  // -3  (float version returns int)
```

> [!NOTE]
> - La versione `float` restituisce un `int`.  
> - La versione `double` restituisce un `long`.

### 11.1.3 `Math.ceil()` (Ceiling)

`ceil()` restituisce il più piccolo valore `double` che è maggiore o uguale all’argomento.

**Overload**
- `double ceil(double value)`

- Esempi:

```java
Math.ceil(3.1);   // 4.0
Math.ceil(-3.1);  // -3.0
```

### 11.1.4 `Math.floor()` (Floor)

`floor()` restituisce il più grande valore `double` che è minore o uguale all’argomento.

**Overload**
- `double floor(double value)`

- Esempi:

```java
Math.floor(3.9);   // 3.0
Math.floor(-3.1);  // -4.0
```

### 11.1.5 `Math.pow()`

`pow()` eleva un valore a una potenza.

**Overload**
- `double pow(double base, double exponent)`

- Esempi:

```java
Math.pow(2, 3);      // 8.0
Math.pow(9, 0.5);    // 3.0  (square root)
Math.pow(10, -1);    // 0.1
```

### 11.1.6 `Math.random()`

`random()` restituisce un `double` nell’intervallo `[0.0, 1.0)` (0.0 incluso, 1.0 escluso).

**Overload**
- `double random()`

- Esempi:

```java
double r = Math.random();   // 0.0 <= r < 1.0

// Example: random int 0–9
int x = (int)(Math.random() * 10);
```

### 11.1.7 `Math.abs()`

`abs()` restituisce il valore assoluto (distanza da zero).

**Overload**
- `int abs(int value)`
- `long abs(long value)`
- `float abs(float value)`
- `double abs(double value)`

### 11.1.8 `Math.sqrt()`

`sqrt()` calcola la radice quadrata e restituisce un `double`.

```java
Math.sqrt(9);    // 3.0
Math.sqrt(-1);   // NaN (not a number)
```

### 11.1.9 Tabella riassuntiva

| Metodo | Restituisce | Overload | Note |
| --- | --- | --- | --- |
| round() | int o long | float, double | Intero più vicino |
| ceil() | double | double | Valore più piccolo >= argomento |
| floor() | double | double | Valore più grande <= argomento |
| pow() | double | double, double | Esponenziazione |
| random() | double | none | 0.0 <= r < 1.0 |
| min()/max() | stesso tipo | int, long, float, double | Confronta due valori |
| abs() | stesso tipo | int, long, float, double | Valore assoluto |
| sqrt() | double | double | Radice quadrata |

---

## 11.2 BigInteger e BigDecimal

Le classi `BigInteger` e `BigDecimal` (in `java.math`) forniscono tipi numerici a precisione arbitraria.
  
Si usano quando:

- I tipi primitivi (`int`, `long`, `double`, ecc.) non hanno abbastanza range.
- Gli errori di arrotondamento in virgola mobile di `float`/`double` non sono accettabili (ad esempio, nei calcoli finanziari).

Entrambi sono **immutabili**: ogni operazione restituisce una nuova istanza.

### 11.2.1 Perché `double` e `float` non sono sufficienti

I tipi in virgola mobile (`float`, `double`) usano una rappresentazione binaria. Molte frazioni decimali non possono essere rappresentate esattamente (come 0.1 o 0.2), quindi si ottengono errori di arrotondamento:

```java
System.out.println(0.1 + 0.2); // 0.30000000000000004 
```

Per attività come i calcoli finanziari, questo è inaccettabile.
  
`BigDecimal` risolve il problema rappresentando i numeri usando un modello decimale con una scala configurabile (numero di cifre dopo il separatore decimale).

### 11.2.2 BigInteger — Interi a precisione arbitraria

`BigInteger` rappresenta valori interi di dimensione praticamente qualsiasi, limitata solo dalla memoria disponibile.

### 11.2.3 Creare BigInteger

Modi comuni:

**Da un long**

```java
static BigInteger valueOf(long val);
```

**Da una String**

```java
BigInteger(String val);        // decimal by default
BigInteger(String val, int radix);
```

**Valore randomico**

```java
BigInteger(int numBits, Random rnd);
```

- Esempi:

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

### 11.2.4 Operazioni (niente operatori!)

Non puoi usare gli operatori aritmetici standard (`+`, `-`, `*`, `/`, `%`) con `BigInteger` o `BigDecimal`.
  
Devi invece chiamare metodi (tutti i quali restituiscono nuove istanze). Ecco alcuni di quelli comuni per `BigInteger`:

- `add(BigInteger val)`
- `subtract(BigInteger val)`
- `multiply(BigInteger val)`
- `divide(BigInteger val)` – divisione intera
- `remainder(BigInteger val)`
- `pow(int exponent)`
- `negate()`
- `abs()`
- `gcd(BigInteger val)`
- `compareTo(BigInteger val)` – ordinamento

- Esempio:

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
