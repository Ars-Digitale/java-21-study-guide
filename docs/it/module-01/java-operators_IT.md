# 5. Operatori Java

### Indice

- [5. Operatori Java](#5-operatori-java)
  - [5.1 Definizione](#51-definizione)
  - [5.2 Tipi di operatori](#52-tipi-di-operatori)
  - [5.3 Categorie di operatori](#53-categorie-di-operatori)
  - [5.4 Precedenza degli operatori e ordine di valutazione](#54-precedenza-degli-operatori-e-ordine-di-valutazione)
  - [5.5 Tabella riassuntiva degli operatori Java](#55-tabella-riassuntiva-degli-operatori-java)
    - [5.5.1 Note aggiuntive](#551-note-aggiuntive)
  - [5.6 Operatori unari](#56-operatori-unari)
    - [5.6.1 Categorie di operatori unari](#561-categorie-di-operatori-unari)
    - [5.6.2 Esempi](#562-esempi)
  - [5.7 Operatori binari](#57-operatori-binari)
    - [5.7.1 Categorie di operatori binari](#571-categorie-di-operatori-binari)
    - [5.7.2 Operatori di divisione e resto (modulus)](#572-operatori-di-divisione-e-resto-modulus)
    - [5.7.3 Il valore di ritorno dell’operatore di assegnazione](#573-il-valore-di-ritorno-delloperatore-di-assegnazione)
    - [5.7.4 Operatori di assegnazione composta](#574-operatori-di-assegnazione-composta)
    - [5.7.5 Operatori di uguaglianza == e !=](#575-operatori-di-uguaglianza--e-)
      - [5.7.5.1 Uguaglianza con tipi primitivi](#5751-uguaglianza-con-tipi-primitivi)
      - [5.7.5.2 Uguaglianza con tipi reference (oggetti)](#5752-uguaglianza-con-tipi-reference-oggetti)
    - [5.7.6 L’operatore instanceof](#576-loperatore-instanceof)
      - [5.7.6.1 Controllo in fase di compilazione vs fase di esecuzione](#5761-controllo-in-fase-di-compilazione-vs-fase-di-esecuzione)
      - [5.7.6.2 Pattern matching per instanceof](#5762-pattern-matching-per-instanceof)
      - [5.7.6.3 Flow scoping e logica short-circuit](#5763-flow-scoping-e-logica-short-circuit)
      - [5.7.6.4 Array e tipi reificabili](#5764-array-e-tipi-reificabili)
  - [5.8 Operatore ternario](#58-operatore-ternario)
    - [5.8.1 Sintassi](#581-sintassi)
    - [5.8.2 Esempio](#582-esempio)
    - [5.8.3 Esempio di ternario annidato](#583-esempio-di-ternario-annidato)
    - [5.8.4 Note](#584-note)


---

## 5.1 Definizione

In Java, gli **operatori** sono simboli speciali che eseguono operazioni su variabili e valori.  
Sono i mattoni fondamentali delle espressioni e permettono agli sviluppatori di manipolare i dati, confrontare valori, eseguire operazioni aritmetiche e controllare il flusso logico.

Un’**espressione** è una combinazione di operatori e operandi che produce un risultato.

Per esempio:
```java
int result = (a + b) * c;
```

Qui, `+` e `*` sono operatori, e `a`, `b` e `c` sono operandi.

---

## 5.2 Tipi di operatori

Java definisce tre tipi di operatori, raggruppati in base al numero di operandi che utilizzano:

| Type | Descrizione | Esempi |
| --- | --- | --- |
| Unary | Opera su un singolo operando | `+x`, `-x`, `++x`, `--x`, `!flag`, `~num` |
| Binary | Opera su due operandi | `a + b`, `a - b`, `x * y`, `x / y`, `x % y` |
| Ternary | Opera su tre operandi (ce n’è uno solo in Java) | `condition ? valueIfTrue : valueIfFalse` |

---

## 5.3 Categorie di operatori

Gli operatori possono anche essere raggruppati, in base al loro scopo, in categorie:

| Categoria | Descrizione | Esempi |
| --- | --- | --- |
| Assignment | Assegna valori alle variabili | `=`, `+=`, `-=`, `*=`, `/=`, `%=` |
| Relational | Confronta valori | `==`, `!=`, `<`, `>`, `<=`, `>=` |
| Logical | Combina o inverte espressioni booleane | <code>&#124;</code>, <code>&amp;</code>, <code>^</code> |
| Conditional | Combina o inverte espressioni booleane | <code>&#124;&#124;</code>, <code>&amp;&amp;</code> |
| Bitwise | Manipola i bit | <code>&amp;</code>, <code>&#124;</code>, `^`, `~`, `<<`, `>>`, `>>>` |
| Instanceof | Verifica il tipo di un oggetto | `obj instanceof ClassName` |
| Lambda | Usato nelle espressioni lambda | `(x, y) -> x + y` |

---

## 5.4 Precedenza degli operatori e ordine di valutazione

La **precedenza degli operatori** determina come gli operatori sono raggruppati in un’espressione — cioè, quali operazioni vengono eseguite per prime.
  
L’**associatività** (o **ordine di valutazione**) determina se l’espressione viene valutata da **sinistra a destra** o da **destra a sinistra** quando gli operatori hanno la stessa precedenza.

Esempio:

```java
int result = 10 + 5 * 2;  // La moltiplicazione avviene prima dell’addizione → result = 20
```

Le parentesi tonde `()` possono essere usate per **forzare la precedenza**:

```java
int result = (10 + 5) * 2;  // Le parentesi vengono valutate per prime → result = 30
```

> [!NOTE]
> - La **precedenza** degli operatori riguarda il *raggruppamento*, non l’ordine effettivo di valutazione nel bytecode.
> - Usa sempre le parentesi per rendere esplicita la precedenza e migliorare la leggibilità nelle espressioni complesse.

---

## 5.5 Tabella riassuntiva degli operatori Java

| Precedenza (Alta → Bassa) | Tipo | Operatori | Esempio | Ordine di valutazione | Applicabile a |
| --- | --- | --- | --- | --- | --- |
| 1 | Postfix Unary | `expr++`, `expr--` | `x++` | Sinistra → Destra | Tipi numerici |
| 2 | Prefix Unary | `++expr`, `--expr` | `--x` | Sinistra → Destra | Numerici |
| 3 | Other Unary | `(type)`, `+`, `-`, `~`, `!` | `-x`, `!flag` | Destra → Sinistra | Numerici, boolean |
| 4 | Cast Unary | `(Type) reference` | `(short) 22` | Destra → Sinistra | reference, primitivi |
| 5 | Multiplication/division/modulus | `*`, `/`, `%` | `a * b` | Sinistra → Destra | Tipi numerici |
| 6 | Additive | `+`, `-` | `a + b` | Sinistra → Destra | Numerici, String (concatenazione) |
| 7 | Shift | `<<`, `>>`, `>>>` | `a << 2` | Sinistra → Destra | Tipi interi |
| 8 | Relational | `<`, `>`, `<=`, `>=`, `instanceof` | `a < b`, `obj instanceof Person` | Sinistra → Destra | Numerici, reference |
| 9 | Equality | `==`, `!=` | `a == b` | Sinistra → Destra | Tutti i tipi (eccetto boolean per `<`, `>`) |
| 10 | Logical AND | <code>&amp;</code> | `a & b` | Sinistra → Destra | boolean |
| 11 | Logical exclusive OR | `^` | `a ^ b` | Sinistra → Destra | boolean |
| 12 | Logical inclusive OR | <code>&#124;</code> | `a `<code>&#124;</code>` b` | Sinistra → Destra | boolean |
| 13 | Conditional AND | <code>&amp;&amp;</code> | `a`<code>&amp;&amp;</code>`b` | Sinistra → Destra | boolean |
| 14 | Conditional OR | <code>&#124;&#124;</code> | `a`<code>&#124;&#124;</code>`b` | Sinistra → Destra | boolean |
| 15 | Ternary (Conditional) | `? :` | `a > b ? x : y` | Destra → Sinistra | Tutti i tipi |
| 16 | Assignment | `=`, `+=`, `-=`, `*=`, `/=`, `%=` | `x += 5` | Destra → Sinistra | Tutti i tipi assegnabili |
| 17 | Arrow operator | `->` | `(x, y) -> x + y` | Destra → Sinistra | Espressioni lambda, switch rules |

### 5.5.1 Note aggiuntive

- La **concatenazione di stringhe (`+`)** ha una precedenza più bassa rispetto all’`+` aritmetico sui numeri.
- Usa le parentesi `()` per la precedenza e la leggibilità — non cambiano la semantica ma rendono l’intento più chiaro.

---

## 5.6 Operatori unari

Gli operatori unari operano su **un solo operando** per produrre un nuovo valore.  
Sono usati per operazioni come incremento/decremento, negazione di un valore, inversione di un booleano o complemento bit a bit.

### 5.6.1 Categorie di operatori unari

| Operatore | Nome | Descrizione | Esempio | Risultato |
| --- | --- | --- | --- | --- |
| `+` | Unary plus | Indica un valore positivo (di solito ridondante). | `+x` | Uguale a `x` |
| `-` | Unary minus | Indica che un numero letterale è negativo o nega un’espressione. | `-5` | `-5` |
| `++` | Increment | Incrementa una variabile di 1. Può essere prefisso o postfisso. | `++x`, `x++` | `x+1` |
| `--` | Decrement | Decrementa una variabile di 1. Può essere prefisso o postfisso. | `--x`, `x--` | `x-1` |
| `!` | Logical complement | Inverte un valore booleano. | `!true` | `false` |
| `~` | Bitwise complement | Inverte ogni bit di un intero. | `~5` | `-6` |
| `(type)` | Cast | Converte il valore in un altro tipo. | `(int) 3.9` | `3` |

### 5.6.2 Esempi

```java
int x = 5;
System.out.println(++x);  // 6  (prefisso: incrementa x a 6, poi restituisce 6)
System.out.println(x++);  // 6  (postfisso: restituisce 6, poi incrementa x a 7)
System.out.println(x);    // 7

boolean flag = false;
System.out.println(!flag);  // true

int a = 5;                  // binario: 0000 0101
System.out.println(~a);     // -6 → binario: 1111 1010 (complemento a due)
```

> [!NOTE]
> - Prefisso (`++x` / `--x`): aggiorna prima il valore, poi restituisce il nuovo valore.
> - Postfisso (`x++` / `x--`): restituisce prima il valore corrente, poi lo aggiorna.
> - L’operatore `!` si applica a valori boolean; `~` si applica a tipi numerici interi.

---

## 5.7 Operatori binari

Gli operatori binari richiedono **due operandi**.  
Eseguono operazioni aritmetiche, relazionali, logiche, bit a bit e di assegnazione.

### 5.7.1 Categorie di operatori binari

| Categoria | Operatori | Esempio | Descrizione |
| --- | --- | --- | --- |
| Arithmetic | `+`, `-`, `*`, `/`, `%` | `a + b` | Operazioni matematiche di base. |
| Relational | `<`, `>`, `<=`, `>=`, `==`, `!=` | `a < b` | Confrontano valori. |
| Logical (boolean) | <code>&amp;</code>, <code>&#124;</code>, `^` | `a `<code>&amp;</code>` b` | Vedi nota sotto. |
| Conditional | <code>&amp;&amp;</code>, <code>&#124;&#124;</code> | `a `<code>&amp;&amp;</code>` b` | Vedi nota sotto. |
| Bitwise (integral) | <code>&amp;</code>, <code>&#124;</code>, `^`, `<<`, `>>`, `>>>` | `a << 2` | Operano sui bit. |
| Assignment | `=`, `+=`, `-=`, `*=`, `/=`, `%=` | `x += 3` | Modificano e assegnano. |
| String Concatenation | `+` | `"Hello " + name` | Uniscono stringhe. |

> [!IMPORTANT]
> - Gli operatori **logici** (`&`, `|`, `^`) *valutano sempre entrambi i lati*.
> - Gli operatori **condizionali** (`&&`, `||`) sono **short-circuit**:
>   - `a && b` → `b` è valutato solo se `a` è true
>   - `a || b` → `b` è valutato solo se `a` è false

Esempi:

**Esempio aritmetico:**
```java
int a = 10, b = 4;
System.out.println(a + b);  // 14
System.out.println(a - b);  // 6
System.out.println(a * b);  // 40
System.out.println(a / b);  // 2
System.out.println(a % b);  // 2
```

**Esempio relazionale:**
```java
int a = 5, b = 8;
System.out.println(a < b);   // true
System.out.println(a >= b);  // false
System.out.println(a == b);  // false
System.out.println(a != b);  // true
```

**Esempio logico:**
```java
boolean x = true, y = false;
System.out.println(x && y);  // false
System.out.println(x || y);  // true
System.out.println(!x);      // false
```

**Esempio bit a bit:**
```java
int a = 5;   // 0101
int b = 3;   // 0011
System.out.println(a & b);  // 1  (0001)
System.out.println(a | b);  // 7  (0111)
System.out.println(a ^ b);  // 6  (0110)
System.out.println(a << 1); // 10 (1010)
System.out.println(a >> 1); // 2  (0010)
```

### 5.7.2 Operatori di divisione e resto (modulus)

L’operatore di resto (*modulus*) restituisce il resto della divisione tra due numeri.  
Se due numeri si dividono esattamente, il resto è 0: per esempio **10 % 5** è 0.  
Al contrario, **13 % 4** restituisce il resto 1.

Possiamo usare il resto anche con numeri negativi secondo le regole seguenti:

- se il **divisore** è negativo (es.: 7 % -5), il segno viene ignorato e il risultato è **2**;
- se il **dividendo** è negativo (es.: -7 % 5), il segno viene preservato e il risultato è **-2**;

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

### 5.7.3 Il valore di ritorno dell’operatore di assegnazione

In Java, l’**operatore di assegnazione (`=`)** non si limita a memorizzare un valore in una variabile —  
restituisce anche **il valore assegnato** come risultato dell’intera espressione.

Questo significa che l’operazione di assegnazione può essere **usata come parte di un’altra espressione**,  
ad esempio all’interno di un’istruzione `if`, nella condizione di un ciclo o perfino in un’altra assegnazione.

```java
int x;
int y = (x = 10);   // l’assegnazione (x = 10) restituisce 10
System.out.println(y);  // 10

// x = 10 assegna 10 a x.
// L’espressione (x = 10) viene valutata a 10.
// Questo valore viene poi assegnato a y.
// Quindi sia x che y finiscono con lo stesso valore (10).
```

Poiché l’assegnazione restituisce un valore, può comparire anche all’interno di un’istruzione **if**.  
Tuttavia, ciò porta spesso a errori logici se usata involontariamente.

```java
boolean flag = false;

if (flag = true) {
    System.out.println("This will always execute!");
}

// Qui la condizione (flag = true) assegna true a flag, poi viene valutata a true,
// quindi il blocco if viene sempre eseguito.

// Uso corretto (confronto invece di assegnazione):

if (flag == true) {
    System.out.println("Condition checked, not assigned");
}
```

> [!WARNING]
> Se vedi `if (x = qualcosa)`, fermati: è una **assegnazione**, non un confronto.

### 5.7.4 Operatori di assegnazione composta

Gli **operatori di assegnazione composta** in Java combinano un’operazione aritmetica o bit a bit con l’assegnazione in un unico passaggio.  
Invece di scrivere `x = x + 5`, puoi usare la forma abbreviata `x += 5`.  
Essi eseguono automaticamente un **cast di tipo** verso il tipo della variabile a sinistra quando necessario.

Gli operatori composti più comuni includono:  
`+=`, `-=`, `*=`, `/=`, `%=`, `&=`, `|=`, `^=`, `<<=`, `>>=`, e `>>>=`.

```java
int x = 10;

// Assegnazioni composte aritmetiche
x += 5;   // equivale a x = x + 5 → x = 15
x -= 3;   // equivale a x = x - 3 → x = 12
x *= 2;   // equivale a x = x * 2 → x = 24
x /= 4;   // equivale a x = x / 4 → x = 6
x %= 5;   // equivale a x = x % 5 → x = 1

// Assegnazioni composte bit a bit
int y = 6;   // 0110 (binario)
y &= 3;      // y = y & 3 → 0110 & 0011 = 0010 → y = 2
y |= 4;      // y = y | 4 → 0010 | 0100 = 0110 → y = 6
y ^= 5;      // y = y ^ 5 → 0110 ^ 0101 = 0011 → y = 3

// Assegnazioni composte con shift
int z = 8;   // 0000 1000
z <<= 2;     // z = z << 2 → 0010 0000 → z = 32
z >>= 1;     // z = z >> 1 → 0001 0000 → z = 16
z >>>= 2;    // z = z >>> 2 → 0000 0100 → z = 4

// Esempio di cast di tipo
byte b = 10;
// b = b + 1;   // ❌ errore di compilazione: il risultato int non può essere assegnato a byte
b += 1;         // ✅ funziona: cast implicito di nuovo verso byte
```

> [!NOTE]
> Gli operatori di assegnazione composta **eseguono un cast implicito** verso il tipo della variabile a sinistra.  
> Per questo motivo `b += 1` compila anche se `b = b + 1` non compila.

### 5.7.5 Operatori di uguaglianza (`==` e `!=`)

Gli **operatori di uguaglianza** in Java `==` (uguale a) e `!=` (diverso da) vengono usati per confrontare due operandi.  
Tuttavia, il loro comportamento differisce **a seconda che siano applicati a tipi primitivi o a tipi reference (oggetti)**.

> [!NOTE]
> - `==` confronta i **valori** per i tipi primitivi  
> - `==` confronta i **riferimenti** per gli oggetti  
> - `.equals()` confronta il **contenuto dell’oggetto** (se implementato)

#### 5.7.5.1 Uguaglianza con tipi primitivi

Quando si confrontano **valori primitivi**, `==` e `!=` confrontano i **valori effettivamente memorizzati**.

```java
int a = 5, b = 5;
System.out.println(a == b);  // true  → hanno lo stesso valore
System.out.println(a != b);  // false → i valori sono uguali
```

> [!IMPORTANT]
> - Se gli operandi sono di tipi numerici diversi, Java li promuove automaticamente a un tipo comune prima del confronto.
> - Tuttavia, confrontare float e double può produrre risultati inattesi a causa di errori di precisione (vedi esempio sotto).

```java
int x = 10;
double y = 10.0;
System.out.println(x == y);  // true → x è promosso a double (10.0)

double d = 0.1 + 0.2;
System.out.println(d == 0.3); // false → problema di arrotondamento dei floating point
```

#### 5.7.5.2 Uguaglianza con tipi reference (oggetti)

Per gli oggetti, `==` e `!=` confrontano i riferimenti, non il contenuto dell’oggetto.  
Restituiscono true solo se entrambi i riferimenti puntano **allo stesso oggetto** in memoria.

```java
String s1 = new String("Java");
String s2 = new String("Java");
System.out.println(s1 == s2);      // false → oggetti diversi in memoria
System.out.println(s1 != s2);      // true  → non lo stesso riferimento
```

Anche se due oggetti hanno contenuto identico, `==` confronta i loro **indirizzi**, non i valori.  
Per confrontare il **contenuto** degli oggetti, usa il metodo **`.equals()`**.

```java
System.out.println(s1.equals(s2)); // true → stesso contenuto della stringa
```

**Caso speciale: null e letterali String**

- Qualsiasi reference può essere confrontato con `null` usando `==` o `!=`.

```java
String text = null;
System.out.println(text == null);  // true
```

- I letterali String sono *internati* dalla Java Virtual Machine (JVM):  
ciò significa che letterali identici possono puntare allo stesso riferimento in memoria:

```java
String a = "Java";
String b = "Java";
System.out.println(a == b);       // true → stesso letterale internato
```

- Uguaglianza con tipi misti:  
quando si usa `==` tra operandi di categorie diverse (es. primitivo vs oggetto),  
il compilatore prova a eseguire l’unboxing se uno dei due è una **wrapper class**.

```java
Integer i = 100;
int j = 100;
System.out.println(i == j);   // true → unboxing prima del confronto
```

### 5.7.6 L’operatore `instanceof`

`instanceof` è un **operatore relazionale** che verifica se un valore reference è un’**istanza di** un certo **tipo reference** a runtime.  
Restituisce un `boolean`.

```java
Object o = "Java";
boolean b1 = (o instanceof String);   // true
boolean b2 = (o instanceof Number);   // false
```

Comportamento con **null**:  
se l’espressione è null, **expr instanceof Type** è sempre **false**.

```java
Object n = null;
System.out.println(n instanceof Object);  // false
```

> [!WARNING]
> `instanceof` restituisce sempre `false` quando l’operando a sinistra è `null`.

#### 5.7.6.1 Controllo in fase di compilazione vs fase di esecuzione

- In fase di compilazione, il compilatore rifiuta tipi *inconvertibili* (che non possono essere in relazione a runtime).
- A runtime, se il controllo in compilazione è passato, la JVM valuta il tipo reale dell’oggetto.

```java
// ❌ Errore di compilazione: tipi inconvertibili (String non è correlato a Integer)
boolean bad = ("abc" instanceof Integer);

// ✅ Compila, ma il risultato a runtime dipende dall’oggetto reale:

Number num = Integer.valueOf(10);
System.out.println(num instanceof Integer); // true a runtime
System.out.println(num instanceof Double);  // false a runtime
```

#### 5.7.6.2 Pattern matching per instanceof

Java supporta i *type pattern* con `instanceof`, che eseguono sia il test sia il binding della variabile quando il test ha successo.  
Aggiungere una variabile dopo il tipo indica al compilatore di trattare il costrutto come *Pattern Matching*.

Sintassi (forma *pattern*):

```java
Object obj = "Hello";

if (obj instanceof String str) {
    // Aggiungere la variabile str dopo il tipo istruisce il compilatore a usare il Pattern Matching
    
    System.out.println(str.toUpperCase()); // l’identificatore è in scope qui, di tipo String (sicuro).
}
```

Proprietà fondamentali:

- Se il test ha successo, la variabile di pattern (es. `str`) è sicuramente assegnata ed è in scope nel ramo `true`.
- Le variabili di pattern sono implicitamente `final` (non possono essere riassegnate).
- Il nome non deve entrare in conflitto con una variabile esistente nello stesso scope.

#### 5.7.6.3 Flow scoping e logica short-circuit

Le variabili di pattern diventano disponibili in base all’analisi di flusso:

```java
Object obj = "data";

// Test negato, variabile disponibile nel ramo else
if (!(obj instanceof String s)) {
    // s non è in scope qui
} else {
    System.out.println(s.length()); // s è in scope qui
}

// Con &&, la variabile di pattern può essere usata a destra se a sinistra è stata stabilita
if (obj instanceof String s && s.length() > 3) {
    System.out.println(s.substring(0, 3)); // s in scope
}

// Con ||, la variabile di pattern NON è sicura a destra (lo short-circuit può impedire che venga stabilita)
if (obj instanceof String s || s.length() > 3) {  // ❌ s non è in scope qui
    // ...
}

// Le parentesi possono aiutare a raggruppare la logica
if ((obj instanceof String s) && s.contains("a")) { // ✅ s in scope dopo il test raggruppato
    System.out.println(s);
}
```

Il pattern matching con `null` viene valutato, come sempre per `instanceof`, a `false`:

```java
String str = null;

// instanceof normale
if (str instanceof String) {  
	System.out.print("NOT EXECUTED"); // instanceof è false
}

// Pattern matching
if (str instanceof String s) {  
	System.out.print("NOT EXECUTED"); // instanceof è comunque false
}
```

**Tipi supportati:**

Il tipo della variabile di pattern deve essere un sottotipo, un supertipo o lo stesso tipo della variabile reference.

```java
Number num = Short.valueOf(10);

if (num instanceof String s) {}  // ❌ Errore di compilazione
if (num instanceof Short s) {}   // ✅ Ok
if (num instanceof Object s) {}  // ✅ Ok
if (num instanceof Number s) {}  // ✅ Ok
```

#### 5.7.6.4 Array e tipi reificabili

`instanceof` funziona con gli array (che sono reificabili) e con forme generiche *erased* o con wildcard.  
I **tipi reificabili** sono quelli la cui rappresentazione a runtime preserva completamente il tipo (per esempio: raw types, array, classi non generiche, wildcard `?`).  
A causa del *type erasure*, `List<String>` non può essere testata direttamente a runtime.

```java
Object arr = new int[]{1,2,3};
System.out.println(arr instanceof int[]); // true

Object list = java.util.List.of(1,2,3);
// System.out.println(list instanceof List<Integer>); // ❌ Errore di compilazione: tipo parametrizzato non reificabile
System.out.println(list instanceof java.util.List<?>); // ✅ true
```

---

## 5.8 Operatore ternario

L’**operatore ternario** (`? :`) è l’unico operatore in Java che prende **tre operandi**.  
Funziona come una forma compatta di un’istruzione `if-else`.

> [!TIP]
> L’operatore ternario **deve** produrre un valore di un tipo *compatibile*.  
> Se i due rami producono tipi non correlati, la compilazione fallisce.
> 
> ```java
> String s = true ? "ok" : 5; // ❌ errore di compilazione: tipi incompatibili
> ```

### 5.8.1 Sintassi

```java
condition ? expressionIfTrue : expressionIfFalse;
```

### 5.8.2 Esempio

```java
int age = 20;
String access = (age >= 18) ? "Allowed" : "Denied";
System.out.println(access); // "Allowed"
```

### 5.8.3 Esempio di ternario annidato

```java
int score = 85;
String grade = (score >= 90) ? "A" :
(score >= 75) ? "B" :
(score >= 60) ? "C" : "F";
System.out.println(grade); // "B"
```

### 5.8.4 Note

> [!WARNING]
> 
> - Espressioni ternarie annidate possono ridurre la leggibilità. Usa le parentesi per maggiore chiarezza.
> - L’operatore ternario restituisce un valore, a differenza di if-else, che è un’istruzione.
