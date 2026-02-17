# 7. Flusso di controllo

<a id="indice"></a>
### Indice


- [7.1 L’istruzione if](#71-listruzione-if)
- [7.2 L’istruzione Switch & la Switch Expression](#72-listruzione-switch--la-switch-expression)
	- [7.2.1 La variabile target dello switch può essere](#721-la-variable-target-dello-switch-può-essere)
	- [7.2.2 Valori case accettabili](#722-valori-case-accettabili)
	- [7.2.3 Compatibilità di tipo tra selector e case](#723-compatibilità-di-tipo-tra-selector-e-case)
	- [7.2.4 Pattern Matching nello Switch](#724-pattern-matching-nello-switch)
		- [7.2.4.1 Nomi delle variabili e scope tra i rami](#7241-nomi-delle-variabili-e-scope-tra-i-rami)
		- [7.2.4.2 Ordinamento, dominanza ed esaustività negli switch con pattern](#7242-ordinamento-dominanza-ed-esaustività-negli-switch-con-pattern)
- [7.3 Due forme di switch: switch Statement vs switch Expression](#73-due-forme-di-switch-switch-statement-vs-switch-expression)
	- [7.3.1 L’istruzione switch](#731-listruzione-switch)
		- [7.3.1.1 Comportamento di fall-through](#7311-comportamento-di-fall-through)
	- [7.3.2 L’espressione switch](#732-lespressione-switch)
		- [7.3.2.1 yield nei blocchi di espressione switch](#7321-yield-nei-blocchi-di-espressione-switch)
		- [7.3.2.2 Esaustività per le espressioni switch](#7322-esaustività-per-le-espressioni-switch)
- [7.4 Gestione di null](#74-gestione-di-null)


---

Il **flusso di controllo** in Java si riferisce all’**ordine in cui le singole istruzioni, i comandi o le chiamate a metodo vengono eseguiti** durante l’esecuzione del programma.

Per impostazione predefinita, le istruzioni vengono eseguite sequenzialmente dall’alto verso il basso, ma le istruzioni di controllo del flusso consentono al programma di **prendere decisioni**, **ripetere azioni** o **diramare i percorsi di esecuzione** in base a condizioni.

Java fornisce tre categorie principali di costrutti di controllo del flusso:

- **Istruzioni decisionali** — `if`, `if-else`, `switch`
- **Istruzioni di iterazione** — `for`, `while`, `do-while` e il **`for`** avanzato
- **Istruzioni di diramazione** — `break`, `continue` e `return`

!!! tip
    Comprendere il flusso di controllo è essenziale per vedere come i dati si muovono all’interno del programma e come ogni decisione logica viene valutata passo dopo passo.

<a id="71-listruzione-if"></a>
## 7.1 L’istruzione `if`

L’istruzione `if` è una struttura condizionale di controllo del flusso che esegue un blocco di codice solo se una specifica espressione booleana viene valutata come `true`. 

L’istruzione consente al programma di prendere decisioni a runtime.

**Sintassi:**

```java
if (condition) {
	// eseguito solo quando la condizione è true
}
```

Una clausola `else` opzionale gestisce il percorso alternativo:

```java
if (score >= 60) {
	System.out.println("Passed");
} else {
	System.out.println("Failed");
}
```

Più condizioni possono essere concatenate usando `else if`:

```java
if (grade >= 90) {
	System.out.println("A");
} else if (grade >= 80) {
	System.out.println("B");
} else if (grade >= 70) {
	System.out.println("C");
} else {
	System.out.println("D or below");
}
```

!!! note
    La condizione di `if` deve essere valutata come **boolean**; i tipi numerici o gli oggetti non possono essere usati direttamente come condizioni.
    
    Le parentesi graffe `{}` sono opzionali per singole istruzioni ma sono fortemente consigliate per prevenire sottili errori di logica.
    
    Una catena `if-else` viene valutata dall’alto verso il basso, e viene eseguito solo il primo ramo con una condizione valutata come `true`.

---

<a id="72-listruzione-switch--la-switch-expression"></a>
## 7.2 L’istruzione `switch` & la `switch Expression`

Il costrutto `switch` è una struttura di controllo del flusso che seleziona un ramo tra più alternative in base al valore di un’espressione (il **selector**).

Rispetto a lunghe catene di `if-else-if`, uno `switch`:

- È spesso **più facile da leggere** quando si testano molti valori discreti (costanti, enum, stringhe).
- Può essere **più sicuro e più conciso** quando usato come **espressione switch** perché:

1) Produce un valore.
2) Il compilatore può imporre **esaustività** e **coerenza di tipo**.

Java 21 supporta:

- La `switch` classica come **istruzione** (solo controllo del flusso).
- La `switch` come **Expression** (produce un risultato).
- **Pattern matching** dentro `switch`, inclusi type pattern e guard.

Entrambe le forme di `switch` condividono le stesse regole riguardanti il selector (la **variabile target** dello switch) e i valori `case` accettabili.

<a id="721-la-variable-target-dello-switch-può-essere"></a>
### 7.2.1 La `variable target` dello switch può essere

| Control Variable type |
| --- |
| `byte` / `Byte` |
| `short` / `Short` |
| `char` / `Character` |
| `int` / `Integer` |
| `String` |
| Enum types (selectors of an `enum`) |
| Any reference type (with pattern matching) |
| `var` (if it resolves to one of the allowed types) |

!!! warning
    **Non consentiti** come type selector per switch:
    
    - `boolean`
    - `long`
    - `float`
    - `double`

<a id="722-valori-case-accettabili"></a>
### 7.2.2 Valori `case` accettabili

Per uno switch `non-pattern`, ogni etichetta `case` deve essere una **costante a compile-time compatibile con il tipo del selector**.

Sono consentite, come etichette `case`:

- **Letterali** come `0`, `'A'`, `"ON"`.
- **Costanti enum**, ad es. `RED` o `Color.GREEN`.
- **Variabili costanti final** (costanti a compile-time).

Una costante a compile-time:

- Deve essere dichiarata con `final` e inizializzata nella stessa istruzione.
- Il suo inizializzatore deve a sua volta essere un’espressione costante (tipicamente usando letterali e altre costanti a compile-time).

<a id="723-compatibilità-di-tipo-tra-selector-e-case"></a>
### 7.2.3 Compatibilità di tipo tra `selector` e `case`

Il tipo del `selector` e ogni etichetta `case` devono essere compatibili:

- Le costanti numeriche dei case devono essere entro l’intervallo del tipo del selector.
- Per un selector `enum`, le etichette `case` devono essere costanti di quell’`enum`.
- Per un selector `String`, le etichette `case` devono essere costanti stringa.

<a id="724-pattern-matching-nello-switch"></a>
### 7.2.4 Pattern Matching nello Switch

Lo switch in Java 21 supporta il `pattern matching`, includendo:

- **Type pattern**: `case String s`
- **Guarded pattern**: `case String s when s.length() > 3`
- **Null pattern**: `case null`

Esempio:

```java
String describe(Object o) {
	return switch (o) {
		case null -> "null";
		case Integer i -> "int " + i;
		case String s when s.isEmpty() -> "empty string";
		case String s -> "string (" + s.length() + ")";
		default -> "other";
	};
}
```

**Punti chiave**:

- Ogni pattern introduce una `pattern variable` (come `i` o `s`).
- Le pattern variable sono in scope solo all’interno del proprio `ramo` (o dei percorsi in cui è noto che il pattern corrisponde).
- L’ordine è importante a causa della **dominanza**: **i pattern più specifici devono precedere quelli più generali**.

<a id="7241-nomi-delle-variabili-e-scope-tra-i-rami"></a>
### 7.2.4.1 Nomi delle variabili e scope tra i rami

Con il `pattern matching`, la variabile di pattern esiste solo nello scope del ramo in cui è definita. 

Questo significa che puoi riutilizzare lo stesso nome di variabile in diversi rami `case` senza che i nomi entrino in conflitto.

- Esempio:

```java
switch (o) {
	case String str -> System.out.println(str.length());
	case CharSequence str -> System.out.println(str.charAt(0));
	default -> { }
}
```

!!! note
    Quest’ultimo esempio non restituisce un valore, quindi è in realtà una **istruzione switch**, non una switch Expression.

<a id="7242-ordinamento-dominanza-ed-esaustività-negli-switch-con-pattern"></a>
### 7.2.4.2 Ordinamento, dominanza ed esaustività negli switch con pattern

Quando si gestisce il pattern matching, l’ordinamento dei rami è cruciale a causa della **dominanza** e del potenziale **codice irraggiungibile**.

Un pattern più generale **non** deve apparire prima di uno più specifico, altrimenti quello specifico diventa irraggiungibile.

- Esempio (ramo irraggiungibile):

```java
return switch (o) {
	case Object obj -> "object";
	case String s -> "string"; // ❌ DOES NOT COMPILE: irraggiungibile, String è già intercettata da Object
};
```

- Un altro esempio con una guard:

```java
return switch (o) {
	case Integer a -> "First";
	case Integer a when a > 0 -> "Second"; // ❌ DOES NOT COMPILE: irraggiungibile, il primo case intercetta tutti gli Integers
	// ...
};
```

Quando si usa il pattern matching, gli switch devono essere **esaustivi**; cioè, devono gestire tutti i possibili valori del selector.

Questo può essere ottenuto tramite:

- Fornire un case `default` che gestisce tutti i valori non corrispondenti a nessun altro case.
- Fornire una clausola `case terminale` con un tipo di pattern che corrisponde al tipo reference del selector.

- Esempio (non esaustivo):

```java
Number number = Short.valueOf(10);

switch (number) {
	case Short s -> System.out.println("A"); // ❌ DOES NOT COMPILE: non esaustivo, il selector è di tipo Number
}
```

Per correggere questo, puoi:

- Cambiare il tipo reference di `number` in `Short` (allora l’esaustività è soddisfatta dal singolo case).
- Aggiungere una clausola `default` che copre tutti i valori rimanenti.
- Aggiungere una clausola `case` finale che copre il tipo della variabile selector, per esempio:

```java
Number number = Short.valueOf(10);

switch (number) {
	case Short s -> System.out.println("A");
	case Number n -> System.out.println("B");
}
```

!!! warning
    Il seguente esempio, che usa sia una clausola `default` sia una clausola finale con lo stesso tipo della variabile selector, **non** compila: il compilatore considera uno dei due case come sempre dominante rispetto all’altro.

```java
Number number = Short.valueOf(10);

switch (number) {
	case Short s -> System.out.println("A");
	case Number n -> System.out.println("B"); // ❌ DOES NOT COMPILE: dominated by either the default or the Number pattern
	default -> System.out.println("C");
}
```

---

<a id="73-due-forme-di-switch-switch-statement-vs-switch-expression"></a>
## 7.3 Due forme di `switch`: `switch` Statement vs `switch` Expression

<a id="731-listruzione-switch"></a>
### 7.3.1 L’istruzione Switch

Una **istruzione switch** è usata come costrutto di controllo del flusso.

Non viene valutata, di per sé, come un valore, anche se i suoi rami possono contenere istruzioni `return` che ritornano dal metodo contenitore.

```java
switch (mode) { // switch statement
	case "ON":
		start();
		break; // prevents fall-through
	case "OFF":
		stop();
		break;
	default:
		reset();
}
```

**Punti chiave**:

- Ogni clausola `case` include uno o più valori corrispondenti separati da virgole `,`. Segue un separatore, che può essere due punti `:` o, meno comunemente per le `istruzioni`, l’operatore freccia `->`.
Infine, un’espressione o un blocco (racchiuso in `{}`) definisce il codice da eseguire quando si verifica una corrispondenza.
**Se si usa l’operatore freccia per una clausola, si deve usare per tutte le clausole in quella istruzione switch**.
- Il fall-through è possibile per i `case` in stile "due punti" a meno che un ramo usi `break`, `return` o `throw`.
Quando presente, `break` termina lo switch dopo l’esecuzione del suo case; senza di esso, l’esecuzione continua, in ordine, nei rami successivi.
- Una clausola `default` è opzionale e può apparire ovunque nell’istruzione switch. Viene eseguita se non c’è corrispondenza per i case precedenti.
- Un’istruzione switch non produce un valore come nell'Expression; non puoi assegnare un’istruzione switch direttamente a una variabile.

<a id="7311-comportamento-di-fall-through"></a>
### 7.3.1.1 Comportamento di Fall-Through

Con i `case` in stile "due punti", l’esecuzione salta all’etichetta `case` corrispondente.

Se non c’è un `break`, continua nel case successivo finché non viene incontrato un `break`, `return` o `throw`.

```java
int n = 2;

switch (n) {
	case 1:
		System.out.println("1");
	case 2:
		System.out.println("2"); // printed
	case 3:
		System.out.println("3"); // printed (fall-through)
		break;
	default:
		System.out.println("message default");
}
```

Output:

```bash
2
3
```

!!! note
    Se nell’esempio precedente rimuoviamo il `break` sul `case 3`, verrà stampato anche il messaggio del ramo `default`.

<a id="732-lespressione-switch"></a>
### 7.3.2 L’espressione Switch

Una **espressione switch** produce sempre un singolo valore come suo risultato.

- Esempio:

```java
int len = switch (s) { // switch expression
	case null -> 0;
	case "" -> 0;
	default -> s.length();
};
```

**Punti chiave**:

- Ogni clausola `case` include uno o più valori corrispondenti separati da virgole `,`, seguiti dall’operatore freccia `->`. Poi un’espressione o un blocco (racchiuso in `{}`) definisce il risultato per quel ramo.
- Quando usata con un’assegnazione o un’istruzione `return`, un’espressione switch richiede un punto e virgola finale `;` dopo l’espressione.
- Non c’è fall-through tra i rami in stile "freccia". Ogni ramo corrispondente viene eseguito esattamente una volta.
- Un’espressione switch deve essere **esaustiva**: tutti i possibili valori del selector devono essere coperti (tramite case espliciti e/o `default`).
- Il tipo del risultato deve essere coerente tra tutti i rami. Per esempio, se un ramo produce un `int`, gli altri rami devono produrre valori compatibili con `int`.

<a id="7321-yield-nei-blocchi-di-espressione-switch"></a>
### 7.3.2.1 `yield` nei blocchi di espressione switch

Quando un ramo di un’espressione switch usa un blocco invece di una singola espressione, devi usare `yield` per fornire il risultato di quel ramo.

```java
int len = switch (s) {
	case null -> 0;
	default -> {
		int l = s.trim().length();
		System.out.println("Length: " + l);
		yield l; // result of this arm
	}
};
```

!!! note
    `yield` è usato solo nelle Expressions switch.
    `break value;` non è consentito come modo per restituire un valore da un’espressione switch.

<a id="7322-esaustività-per-le-espressioni-switch"></a>
### 7.3.2.2 Esaustività per le espressioni switch

Poiché un’espressione switch deve restituire un valore, deve anche essere **esaustiva**; in altre parole, deve gestire tutti i possibili valori del selector.

Puoi assicurare questo tramite:

- Fornire un case `default`.
- Per un selector enum: coprire esplicitamente tutte le costanti enum.
- Per tipi sealed o pattern switch: coprire tutti i sottotipi permessi o fornire un `default`.

Esempio, esaustivo tramite `default`:

```java
int val = switch (s) {
	case "one" -> 1;
	case "two" -> 2;
	default -> 0;
};
```

---

<a id="74-gestione-di-null"></a>
## 7.4 Gestione di null

**Switch classico (senza pattern)**

Se l’espressione selector di uno switch classico (senza pattern matching) viene valutata come `null`, viene lanciata una `NullPointerException` a runtime.

Per evitare questo, controlla `null` prima di fare lo switch:

```java
if (s == null) {
	// handle null
} else {
	switch (s) {
		case "A" -> ...
		default -> ...
	}
}
```

<ins>**Pattern switch (con `case null`)**</ins>

Con il pattern matching, puoi gestire `null` direttamente dentro lo switch:

```java
int len = switch (s) {
	case null -> 0;
	default -> s.length();
};
```

!!! note
    Per le Expressions switch:
    
    Se non gestisci `null` e il selector è `null`, viene lanciata una `NullPointerException`.
    
    Usare `case null` rende lo switch esplicitamente null-safe.

!!! warning
    Ogni volta che `case null` viene usato in uno switch, lo switch viene trattato come un `pattern switch`, e si applicano tutte le regole per i pattern switch (incluse esaustività e dominanza).

