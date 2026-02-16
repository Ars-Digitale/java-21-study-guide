# 9. Stringhe in Java

<a id="indice"></a>
### Indice

- [9. Stringhe in Java](#9-stringhe-in-java)
	- [9.1 Stringhe & Text Blocks](#91-stringhe--text-blocks)
		- [9.1.1 Stringhe](#911-stringhe)
			- [9.1.1.1 Inizializzare le stringhe](#9111-inizializzare-le-stringhe)
			- [9.1.1.2 Lo String Pool](#9112-lo-string-pool)
			- [9.1.1.3 Caratteri speciali e sequenze di escape](#9113-caratteri-speciali-e-sequenze-di-escape)
			- [9.1.1.4 Regole per la concatenazione di stringhe](#9114-regole-per-la-concatenazione-di-stringhe)
			- [9.1.1.5 Regole di concatenazione](#9115-regole-di-concatenazione)
		- [9.1.2 Text Blocks (da Java 15)](#912-text-blocks-da-java-15)
			- [9.1.2.1 Formattazione: whitespace essenziale vs incidentale](#9121-formattazione-whitespace-essenziale-vs-incidentale)
			- [9.1.2.2 Conteggio righe, righe vuote e line break](#9122-conteggio-righe-righe-vuote-e-line-break)
			- [9.1.2.3 Text Blocks e caratteri di escape](#9123-text-blocks-e-caratteri-di-escape)
			- [9.1.2.4 Errori comuni con correzioni](#9124-errori-comuni-con-correzioni)
	- [9.2 Metodi principali delle stringhe](#92-metodi-principali-delle-stringhe)
		- [9.2.1 Indicizzazione delle stringhe](#921-indicizzazione-delle-stringhe)
		- [9.2.2 Metodo length](#922-metodo-length)
		- [9.2.3 Regole dei limiti: indice iniziale vs indice finale](#923-regole-dei-limiti-indice-iniziale-vs-indice-finale)
		- [9.2.4 Metodi che usano solo l’indice iniziale (inclusivo)](#924-metodi-che-usano-solo-lindice-iniziale-inclusivo)
		- [9.2.5 Metodi con inizio inclusivo / fine esclusivo](#925-metodi-con-inizio-inclusivo--fine-esclusivo)
		- [9.2.6 Metodi che operano sull’intera stringa](#926-metodi-che-operano-sullintera-stringa)
		- [9.2.7 Accesso ai caratteri](#927-accesso-ai-caratteri)
		- [9.2.8 Ricerca](#928-ricerca)
		- [9.2.9 Metodi di sostituzione](#929-metodi-di-sostituzione)
		- [9.2.10 Suddivisione e unione](#9210-suddivisione-e-unione)
		- [9.2.11 Metodi che restituiscono array](#9211-metodi-che-restituiscono-array)
		- [9.2.12 Indentazione](#9212-indentazione)
		- [9.2.13 Esempi aggiuntivi](#9213-esempi-aggiuntivi)

---

<a id="91-stringhe-text-blocks"></a>
## 9.1 Stringhe & Text Blocks

<a id="911-stringhe"></a>
### 9.1.1 Stringhe

<a id="9111-inizializzare-le-stringhe"></a>
### 9.1.1.1 Inizializzare le stringhe

In Java, una **String** è un oggetto della classe `java.lang.String`, usato per rappresentare una sequenza di caratteri.
  
Le stringhe sono **immutabili**: una volta create, il loro contenuto non può essere cambiato. Qualsiasi operazione che sembra modificare una stringa in realtà ne crea una nuova.

Puoi creare e inizializzare le stringhe in diversi modi:

```java
String s1 = "Hello";                    // string literal
String s2 = new String("Hello");        // using constructor (not recommended)
String s3 = s1.toUpperCase();           // creates a new String ("HELLO")
```

!!! note
    - I letterali stringa sono memorizzati nello `String pool`, un’area speciale di memoria usata per evitare di creare oggetti stringa duplicati.
    - L’uso della keyword `new` crea sempre un nuovo oggetto al di fuori del pool.

<a id="9112-lo-string-pool"></a>
### 9.1.1.2 Lo String Pool

Poiché gli oggetti `String` sono immutabili e ampiamente usati, potrebbero facilmente occupare una grande quantità di memoria in un programma Java.
  
Per ridurre la duplicazione, Java riutilizza tutte le stringhe dichiarate come letterali (vedi l’esempio sopra), memorizzandole in un’area dedicata della JVM nota come **String Pool** o **Intern Pool**.

Per una spiegazione più approfondita e esempi, controlla il paragrafo: **"6.4.3 String Pool and Equality"** nel capitolo: [Istanziazione dei tipi](../module-01/instantiating-types.md).

<a id="9113-caratteri-speciali-e-sequenze-di-escape"></a>
### 9.1.1.3 Caratteri speciali e sequenze di escape

Le stringhe possono contenere caratteri di escape, che permettono di includere simboli speciali o caratteri di controllo (caratteri con un significato speciale in Java).  
Una sequenza di escape inizia con un backslash `\`.

!!! note
    **Tabella dei caratteri speciali & sequenze di escape nelle stringhe**

| Escape | Significato | Esempio Java | Risultato |
| --- | --- | --- | --- |
| `\"` | doppia virgoletta | `"She said \"Hi\""` | `She said "Hi"` |
| `\\` | backslash | `"C:\\Users\\Alex"` | `C:\Users\Alex` |
| `\n` | a capo (LF) | `"Hello\nWorld"` | `Hello` + line break + `World` |
| `\r` | ritorno carrello (CR) | `"A\rB"` | `CR before B` |
| `\t` | tab | `"Name\tAge"` | `Name    Age` |
| `\'` | virgoletta singola | `"It\'s ok"` | `It's ok` |
| `\b` | backspace | `"AB\bC"` | `AC` (il `B` viene rimosso visivamente) |
| `\uXXXX` | unità di codice Unicode | `"\u00A9"` | `©` |

<a id="9114-regole-per-la-concatenazione-di-stringhe"></a>
### 9.1.1.4 Regole per la concatenazione di stringhe

Come introdotto nel capitolo su [Operatori Java](../module-01/java-operators.md), il simbolo `+` normalmente rappresenta l’**addizione aritmetica** quando viene usato con operandi numerici.

Tuttavia, quando applicato alle **String**, lo stesso operatore esegue la **concatenazione di stringhe** — crea una nuova stringa unendo gli operandi tra loro.

Poiché l’operatore `+` può apparire in espressioni in cui sono presenti sia numeri sia stringhe, Java applica un insieme specifico di regole per determinare se `+` significa **addizione numerica** o **concatenazione di stringhe**.

<a id="9115-regole-di-concatenazione"></a>
### 9.1.1.5 Regole di concatenazione

- Se entrambi gli operandi sono numerici, `+` esegue l’**addizione numerica**.
- Se almeno un operando è una `String`, l’operatore `+` esegue la **concatenazione di stringhe**.
- La valutazione è strettamente da sinistra a destra, perché `+` è **associativo a sinistra**.  

Questo significa che, una volta che una `String` appare sul lato sinistro dell’espressione, tutte le successive operazioni `+` diventano concatenazioni.

!!! tip
    Poiché la valutazione è da sinistra a destra, la posizione del primo operando `String` determina come viene valutato il resto dell’espressione.

- Esempi

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

<a id="912-text-blocks-da-java-15"></a>
### 9.1.2 Text Blocks (da Java 15)

Un text block è un letterale stringa multi-linea introdotto per semplificare la scrittura di stringhe grandi (come HTML, JSON o codice) senza la necessità di molte sequenze di escape.
  
Un text block inizia e termina con tre doppi apici (`"""`).
  
Puoi usare i text block ovunque useresti le stringhe.

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
    - I text block includono automaticamente line break e indentazione per la leggibilità. I newline sono normalizzati a `\n`.
    - Le doppie virgolette all’interno del blocco di solito non richiedono escape.
    - Il compilatore interpreta il contenuto tra le triple virgolette di apertura e chiusura come il valore della stringa.

<a id="9121-formattazione-whitespace-essenziale-vs-incidentale"></a>
### 9.1.2.1 Formattazione: whitespace essenziale vs incidentale

- **Whitespace essenziale**: spazi e newline che fanno parte del contenuto della stringa.
- **Whitespace incidentale**: indentazione nel codice sorgente che non consideri concettualmente parte del testo.

```java
String text = """
        Line 1
        Line 2
        Line 3
        """;
```

!!! important
    - **Carattere più a sinistra (baseline)**: la posizione del primo carattere non-spazio su tutte le righe (o la `"""` di chiusura) definisce la baseline di indentazione. Gli spazi a sinistra di questa baseline sono considerati incidentali e vengono rimossi.
    - La riga immediatamente successiva alla `"""` di apertura non è inclusa nell’output se è vuota (formattazione tipica).
    - Il newline prima della `"""` di chiusura è incluso nel contenuto.  
      Nell’esempio sopra, la stringa risultante termina con un newline dopo `"Line 3"`: in totale ci sono 4 righe.

Output con numeri di riga (mostrando la riga vuota finale):

```text
1: Line 1
2: Line 2
3: Line 3
4:
```

Per sopprimere il newline finale:

- Usa un backslash di continuazione riga alla fine dell’ultima riga di contenuto.
- Metti le triple virgolette di chiusura sulla stessa riga dell’ultimo contenuto.

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

<a id="9122-conteggio-righe-righe-vuote-e-line-break"></a>
### 9.1.2.2 Conteggio righe, righe vuote e line break

- Ogni line break visibile dentro il blocco diventa `\n`.
- Le righe vuote dentro il blocco vengono preservate.

```java
String textNoTrail_0 = """
        Line 1  
        Line 2 \n
        Line 3 
        
        Line 4 
        """;
```

Output:

```text
1: Line 1
2: Line 2
3:
4: Line 3
5:
6: Line 4
7:
```

<a id="9123-text-blocks-e-caratteri-di-escape"></a>
### 9.1.2.3 Text Blocks e caratteri di escape

Le sequenze di escape funzionano ancora dentro i text block quando necessario (per esempio, per backslash o caratteri di controllo espliciti).

```java
String json = """
    {
      "name": "Alice",
      "path": "C:\\\\Users\\\\Alice"
    }\
    """;
```

Puoi anche formattare un text block usando placeholder e `formatted()`:

```java
String card = """
    Name: %s
    Age:  %d
    """.formatted("Alice", 30);
```

<a id="9124-errori-comuni-con-correzioni"></a>
### 9.1.2.4 Errori comuni (con correzioni)

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

<a id="92-metodi-principali-delle-stringhe"></a>
## 9.2 Metodi principali delle stringhe

<a id="921-indicizzazione-delle-stringhe"></a>
### 9.2.1 Indicizzazione delle stringhe

Le stringhe in Java usano l’**indicizzazione a base zero**, il che significa:

- Il primo carattere è all’indice `0`
- L’ultimo carattere è all’indice `length() - 1`
- Accedere a qualsiasi indice fuori da questo intervallo causa una `StringIndexOutOfBoundsException`

- Esempio:

```java
String s = "Java";
// Indexes:  0    1    2    3
// Chars:    J    a    v    a

char c = s.charAt(2); // 'v'
```

<a id="922-metodo-length"></a>
### 9.2.2 Metodo `length()`

`length()` restituisce il numero di caratteri nella stringa.

```java
String s = "hello";
System.out.println(s.length());  // 5
```

L’ultimo indice valido è sempre `length() - 1`.

<a id="923-regole-dei-limiti-indice-iniziale-vs-indice-finale"></a>
### 9.2.3 Regole dei limiti: indice iniziale vs indice finale

Molti metodi di `String` usano due indici:

- **Indice iniziale** — inclusivo
- **Indice finale** — esclusivo

In altre parole, `substring(start, end)` include i caratteri dall’indice `start` fino a (ma non includendo) l’indice `end`.

- L’indice iniziale deve essere `>= 0` e `<= length() - 1`
- L’indice finale può essere uguale a `length()` (la “posizione virtuale” dopo l’ultimo carattere).
- L’indice finale non deve superare `length()`.
- L’indice iniziale non deve mai essere maggiore dell’indice finale.

- Esempio:

```java
String s = "abcdef";
s.substring(1, 4); // "bcd" (indexes 1,2,3)
```

Questa regola si applica alla maggior parte dei metodi basati su substring.

<a id="924-metodi-che-usano-solo-lindice-iniziale-inclusivo"></a>
### 9.2.4 Metodi che usano solo l’indice iniziale (inclusivo)

| Metodo | Descrizione | Parametri | Regola indice | Esempio |
| --- | --- | --- | --- | --- |
| substring(int start) | Restituisce la sottostringa da start alla fine | start | start inclusivo | "abcdef".substring(2) → "cdef" |
| indexOf(String) | Prima occorrenza | — | — | "Java".indexOf("a") → 1 |
| indexOf(String, start) | Inizia la ricerca all’indice | start | start inclusivo | "banana".indexOf("a", 2) → 3 |
| lastIndexOf(String) | Ultima occorrenza | — | — | "banana".lastIndexOf("a") → 5 |
| lastIndexOf(String, fromIndex) | Cerca all’indietro dall’indice | fromIndex | fromIndex inclusivo | "banana".lastIndexOf("a", 3) → 3 |

<a id="925-metodi-con-inizio-inclusivo-fine-esclusivo"></a>
### 9.2.5 Metodi con inizio inclusivo / fine esclusivo

Questi metodi seguono lo stesso comportamento di slicing: `start` incluso, `end` escluso.

| Metodo | Descrizione | Firma | Esempio |
| --- | --- | --- | --- |
| substring(start, end) | Estrae una parte della stringa | (int start, int end) | "abcdef".substring(1,4) → "bcd" |
| regionMatches | Confronta regioni di sottostringhe | (toffset, other, ooffset, len) | "Hello".regionMatches(1, "ell", 0, 3) → true |
| getBytes(int srcBegin, int srcEnd, byte[] dst, int dstBegin) | Copia caratteri in un array di byte | start inclusivo, end esclusivo | Copia i caratteri in [srcBegin, srcEnd) |
| copyValueOf(char[] data, int offset, int count) | Crea una nuova stringa | offset inclusivo; offset+count esclusivo | Stessa regola di substring |

<a id="926-metodi-che-operano-sullintera-stringa"></a>
### 9.2.6 Metodi che operano sull’intera stringa

| Metodo | Descrizione | Esempio |
| --- | --- | --- |
| toUpperCase() | Versione maiuscola | "java".toUpperCase() → "JAVA" |
| toLowerCase() | Versione minuscola | "JAVA".toLowerCase() → "java" |
| trim() | Rimuove whitespace iniziale/finale | "  hi  ".trim() → "hi" |
| strip() | Trim Unicode-aware | "  hi\u2003".strip() → "hi" |
| stripLeading() | Rimuove whitespace iniziale | "  hi".stripLeading() → "hi" |
| stripTrailing() | Rimuove whitespace finale | "hi  ".stripTrailing() → "hi" |
| isBlank() | Vero se vuota o solo whitespace | "  ".isBlank() → true |
| isEmpty() | Vero se length == 0 | "".isEmpty() → true |

<a id="927-accesso-ai-caratteri"></a>
### 9.2.7 Accesso ai caratteri

| Metodo | Descrizione | Esempio |
| --- | --- | --- |
| charAt(int index) | Restituisce il carattere all’indice | "Java".charAt(2) → 'v' |
| codePointAt(int index) | Restituisce il code point Unicode | Utile per emoji o caratteri oltre BMP |

<a id="928-ricerca"></a>
### 9.2.8 Ricerca

| Metodo | Descrizione | Esempio |
| --- | --- | --- |
| contains(CharSequence) | Test di sottostringa | "hello".contains("ell") → true |
| startsWith(String) | Prefisso | "abcdef".startsWith("abc") → true |
| startsWith(String, offset) | Prefisso all’indice | "abc".startsWith("b", 1) → true |
| endsWith(String) | Suffisso | "abcdef".endsWith("def") → true |

<a id="929-metodi-di-sostituzione"></a>
### 9.2.9 Metodi di sostituzione

| Metodo | Descrizione | Esempio |
| --- | --- | --- |
| replace(char old, char new) | Sostituisce caratteri | "banana".replace('a','o') → "bonono" |
| replace(CharSequence old, CharSequence new) | Sostituisce sottostringhe | "ababa".replace("aba","X") → "Xba" |
| replaceAll(String regex, String replacement) | Sostituzione regex globale | "a1a2".replaceAll("\\d","") → "aa" |
| replaceFirst(String regex, String replacement) | Solo prima corrispondenza regex | "a1a2".replaceFirst("\\d","") → "aa2" |

<a id="9210-suddivisione-e-unione"></a>
### 9.2.10 Suddivisione e unione

| Metodo | Descrizione | Esempio |
| --- | --- | --- |
| split(String regex) | Suddivide per regex | "a,b,c".split(",") → ["a","b","c"] |
| split(String regex, int limit) | Suddivide con limite | limit < 0 mantiene tutte le stringhe vuote finali |

<a id="9211-metodi-che-restituiscono-array"></a>
### 9.2.11 Metodi che restituiscono array

| Metodo | Descrizione | Esempio |
| --- | --- | --- |
| toCharArray() | Restituisce char[] | "abc".toCharArray() |
| getBytes() | Restituisce byte[] usando encoding di piattaforma/default | "á".getBytes() |

<a id="9212-indentazione"></a>
### 9.2.12 Indentazione

| Metodo | Descrizione | Esempio |
| --- | --- | --- |
| indent(int numSpaces) | Aggiunge (positivo) o rimuove (negativo) spazi dall’inizio di ogni riga; aggiunge anche un line break alla fine se non già presente | str.indent(-20) |
| stripIndent() | Rimuove tutto il whitespace iniziale incidentale da ogni riga; non aggiunge un line break finale | str.stripIndent() |

- Esempio:

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

Output:

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

<a id="9213-esempi-aggiuntivi"></a>
### 9.2.13 Esempi aggiuntivi

- Esempio 1 — Estrarre `[start, end)`

```java
String s = "012345";
System.out.println(s.substring(2, 5));
// includes 2,3,4 → prints "234"
```

- Esempio 2 — Ricerca da un indice iniziale

```java
String s = "hellohello";
int idx = s.indexOf("lo", 5); // search begins at index 5
```

- Esempio 3 — Errori comuni

```java
String s = "abcd";
System.out.println(s.substring(1,1)); // "" empty string
System.out.println(s.substring(3, 2)); // ❌ Exception: start index (3) > end index (2)

System.out.println("abcd".substring(2, 4)); // "cd" — includes indexes 2 and 3; 4 is excluded but legal here

System.out.println("abcd".substring(2, 5)); // ❌ StringIndexOutOfBoundsException (end index 5 is invalid)
```
