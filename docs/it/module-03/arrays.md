# 10. Array in Java

### Indice

- [10. Array in Java](#10-array-in-java)
	- [10.1 Che cos’è un array](#101-che-cosè-un-array)
		- [10.1.1 Dichiarare gli array](#1011-dichiarare-gli-array)
		- [10.1.2 Creare array (istanza)](#1012-creare-array-istanza)
		- [10.1.3 Valori predefiniti negli array](#1013-valori-predefiniti-negli-array)
		- [10.1.4 Accedere agli elementi](#1014-accedere-agli-elementi)
		- [10.1.5 Scorciatoie di inizializzazione degli array](#1015-scorciatoie-di-inizializzazione-degli-array)
			- [10.1.5.1 Creazione di array anonimi](#10151-creazione-di-array-anonimi)
			- [10.1.5.2 Sintassi breve (solo in dichiarazione)](#10152-sintassi-breve-solo-in-dichiarazione)
	- [10.2 Array multidimensionali (array di array)](#102-array-multidimensionali-array-di-array)
		- [10.2.1 Creare un array rettangolare](#1021-creare-un-array-rettangolare)
		- [10.2.2 Creare un array frastagliato (irregolare)](#1022-creare-un-array-frastagliato-irregolare)
	- [10.3 Lunghezza degli array vs lunghezza delle stringhe](#103-lunghezza-degli-array-vs-lunghezza-delle-stringhe)
	- [10.4 Assegnazioni di riferimenti a array](#104-assegnazioni-di-riferimenti-a-array)
		- [10.4.1 Assegnare riferimenti compatibili](#1041-assegnare-riferimenti-compatibili)
		- [10.4.2 Assegnazioni incompatibili (errori a compile-time)](#1042-assegnazioni-incompatibili-errori-a-compile-time)
		- [10.4.3 Rischio runtime della covarianza: ArrayStoreException](#1043-rischio-runtime-della-covarianza-arraystoreexception)
	- [10.5 Confrontare gli array](#105-confrontare-gli-array)
	- [10.6 Metodi di utilita di Arrays](#106-metodi-di-utilità-di-arrays)
		- [10.6.1 Arrays.toString](#1061-arraystostring)
		- [10.6.2 Arrays.deepToString per array annidati](#1062-arraysdeeptostring-per-array-annidati)
		- [10.6.3 Arrays.sort](#1063-arrayssort)
		- [10.6.4 Arrays.binarySearch](#1064-arraysbinarysearch)
		- [10.6.5 Arrays.compare](#1065-arrayscompare)
	- [10.7 Enhanced for-loop con array](#107-enhanced-for-loop-con-array)
	- [10.8 Errori comuni](#108-errori-comuni)
	- [10.9 Riepilogo](#109-riepilogo)


---

## 10.1 Che cos’è un array

Gli array in Java sono collezioni **a dimensione fissa**, **indicizzate**, **ordinate** di elementi dello stesso tipo.
  
Sono **oggetti**, anche quando gli elementi contenuti sono primitivi.

### 10.1.1 Dichiarare gli array

Puoi dichiarare un array in due modi:

```java
int[] a;      // sintassi moderna preferita
int b[];      // legale, stile vetusto
String[] names;
Person[] people;

// [] possono trovarsi prima o dopo il nome: tutte le seguenti dichiarazioni sono equivalenti.

int[] x;
int [] x1;
int []x2;
int x3[];
int x5 [];

// MULTIPLE ARRAY DECLARATIONS

int[] arr1, arr2;   // Dichiara due array di interi

// WARNING:
// QUi arr1 è un int[] e arr2 è solo un int (NON un array!)
int arr1[], arr2;
```

**Dichiarare NON crea l’array** — crea solo una variabile in grado di referenziarne uno.

### 10.1.2 Creare array (istanza)

Un array viene creato usando `new` seguito dal tipo dell’elemento e dalla lunghezza dell’array:

```java
int[] numbers = new int[5];
String[] words = new String[3];
```

**Regole chiave**
- La lunghezza deve essere non negativa e specificata al momento della creazione.
- La lunghezza non può essere cambiata in seguito.
- La lunghezza dell’array può essere qualsiasi espressione `int`.

```java
int size = 4;
double[] values = new double[size];
```

- Esempi illegali di creazione di array:

```java
// int length = -1;           
// int[] arr = new int[-1];   // Runtime: NegativeArraySizeException

// int[] arr = new int[2.5];  // Compile error: size must be int
```

### 10.1.3 Valori predefiniti negli array

Gli array (poiché sono oggetti) ricevono sempre una **inizializzazione predefinita**:

| Tipo di elemento | Valore predefinito |
| --- | --- |
| Numerico | 0 |
| boolean | false |
| char | '\u0000' |
| Tipi di riferimento | null |

- Esempio:

```java
int[] nums = new int[3]; 
System.out.println(nums[0]); // 0

String[] s = new String[3];
System.out.println(s[0]);    // null
```

### 10.1.4 Accedere agli elementi

Gli elementi si accedono usando l’indicizzazione a base zero:

```java
int[] a = new int[3];
a[0] = 10;
a[1] = 20;
System.out.println(a[1]); // 20
```

**Eccezione comune**  
- `ArrayIndexOutOfBoundsException` (runtime)

```java
// int[] x = new int[2];
// System.out.println(x[2]); // ❌ indice 2 out of bounds
```

### 10.1.5 Scorciatoie di inizializzazione degli array

### 10.1.5.1 Creazione di array anonimi

```java
int[] a = new int[] {1,2,3};
```

### 10.1.5.2 Sintassi breve (solo in dichiarazione)

```java
int[] b = {1,2,3};
```

> La sintassi breve `{1,2,3}` può essere usata **solo nel punto di dichiarazione**.

```java
// int[] c;
// c = {1,2,3};  // ❌ does not compile
```

---

## 10.2 Array multidimensionali (array di array)

Java implementa gli array multi-dimensionali come **array di array**.

Dichiarazione:

```java
int[][] matrix;
String[][][] cube;
```

### 10.2.1 Creare un array rettangolare

```java
int[][] rect = new int[3][4]; // 3 righe, 4 colonne
```

### 10.2.2 Creare un array frastagliato (irregolare)

Puoi creare righe con lunghezze diverse:

```java
int[][] jagged = new int[3][];
jagged[0] = new int[2];
jagged[1] = new int[5];
jagged[2] = new int[1];
```

---

## 10.3 Lunghezza degli array vs lunghezza delle stringhe

- Gli array usano `.length` (campo `public final`).
- Le stringhe usano `.length()` (metodo).

!!! tip
    Questo è un classico errore: campi vs metodi.

```java
// int x = arr.length;   // OK
// int y = s.length;     // ❌ does not compile: missing ()
int yOk = s.length();
```

---

## 10.4 Assegnazioni di riferimenti a array

### 10.4.1 Assegnare riferimenti compatibili

```java
int[] a = {1,2,3};
int[] b = a; // entrambi puntano ora allo stesso array
```

Modificare un riferimento influisce sull’altro:

```java
b[0] = 99;
System.out.println(a[0]); // 99
```

### 10.4.2 Assegnazioni incompatibili (errori a compile-time)

```java
int[] x = new int[3];
// long[] y = x;     // ❌ tipo incompatibile
```

I riferimenti ad array seguono le normali regole di ereditarietà:

```java
String[] s = new String[3];
Object[] o = s;      // OK: arrays are covariant
```

### 10.4.3 Rischio runtime della covarianza: `ArrayStoreException`

```java
Object[] objs = new String[3];
// objs[0] = Integer.valueOf(5); // ❌ ArrayStoreException a runtime
```

---

## 10.5 Confrontare gli array

`==` confronta i riferimenti (identità):

```java
int[] a = {1,2};
int[] b = {1,2};
System.out.println(a == b); // false
```

`equals()` **sugli array non confronta i contenuti (si comporta come `==`)**:

```java
System.out.println(a.equals(b)); // false
```

Per confrontare i contenuti, usa i metodi di `java.util.Arrays`:

```java
Arrays.equals(a, b);         // shallow comparison
Arrays.deepEquals(o1, o2);   // deep comparison per arrays annidati
```

---

## 10.6 Metodi di utilità di `Arrays`

### 10.6.1 `Arrays.toString()`

```java
System.out.println(Arrays.toString(new int[]{1,2,3})); // [1, 2, 3]
```

### 10.6.2 `Arrays.deepToString()` (per array annidati)

```java
System.out.println(Arrays.deepToString(new int[][] {{1,2},{3,4}}));
// [[1, 2], [3, 4]]
```

### 10.6.3 `Arrays.sort()`

```java
int[] a = {4,1,3};
Arrays.sort(a); // [1, 3, 4]
```

!!! tip
    - Le stringhe sono ordinate in ordine naturale (lessicografico).
    - **I numeri ordinano prima delle lettere, e le lettere maiuscole ordinano prima delle minuscole** (numeri < maiuscole < minuscole).
    - Per i tipi di riferimento, `null` è considerato più piccolo di qualsiasi valore non-null.

```java
String[] arr = {"AB", "ac", "Ba", "bA", "10", "99"};

Arrays.sort(arr);

System.out.println(Arrays.toString(arr));  // [10, 99, AB, Ba, ac, bA]
```

### 10.6.4 `Arrays.binarySearch()`

Requisiti: l’array deve essere ordinato; altrimenti il risultato è imprevedibile.

```java
int[] a = {1,3,5,7};
int idx = Arrays.binarySearch(a, 5); // returns 2
```

Quando il valore non viene trovato, `binarySearch` restituisce `-(insertionPoint) - 1`:

```java
int pos = Arrays.binarySearch(a, 4); // returns -3
// Il punto d'inserimento sarebbe all'indice 2 → -(2) - 1 = -3
```

### 10.6.5 `Arrays.compare()`

La classe `Arrays` offre un `equals()` sovraccarico che verifica se due array contengono gli stessi elementi (e hanno la stessa lunghezza):

```java
System.out.println(Arrays.equals(new int[] {200}, new int[] {100}));        // false
System.out.println(Arrays.equals(new int[] {200}, new int[] {200}));        // true
System.out.println(Arrays.equals(new int[] {200}, new int[] {100, 200}));   // false
```

Fornisce anche un metodo `compare()` con queste regole:

- Se il risultato `n < 0` → il primo array è considerato “più piccolo” del secondo.
- Se il risultato `n > 0` → il primo array è considerato “più grande” del secondo.
- Se il risultato `n == 0` → gli array sono uguali.

- Esempi:

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

## 10.7 Enhanced for-loop con array

```java
for (int value : new int[]{1,2,3}) {
    System.out.println(value);
}
```

**Regole**
- Il lato destro deve essere un array o un `Iterable`.
- Il tipo della variabile di ciclo deve essere compatibile con il tipo degli elementi (**qui non c’è widening di primitivi**).

Errore comune:

```java
// for (long v : new int[]{1,2}) {} // ❌ not allowed: int elements cannot be assigned to long in enhanced for-loop
```

---

## 10.8 Errori comuni

- **Accesso fuori dai limiti** → lancia `ArrayIndexOutOfBoundsException`.

- **Uso errato dell’inizializzatore breve**

```java
// int[] x;
// x = {1,2}; // ❌ does not compile
```

- **Confondere `.length` e `.length()`**
- **Dimenticare che gli array sono oggetti** (vivono nell’heap e sono referenziati).

- **Miscelare array di primitivi e array di wrapper**

```java
// int[] p = new Integer[3]; // ❌ incompatible
```

- **Usare `binarySearch` su array non ordinati** → risultati imprevedibili.
- **Eccezioni runtime dovute a array covarianti** (`ArrayStoreException`).

---

## 10.9 Riepilogo

Gli array in Java sono:

- Oggetti (anche se contengono primitivi).
- Collezioni indicizzate a dimensione fissa.
- Sempre inizializzati con valori predefiniti.
- Type-safe, ma soggetti alle regole di covarianza (che possono causare eccezioni a runtime se usate in modo improprio).
