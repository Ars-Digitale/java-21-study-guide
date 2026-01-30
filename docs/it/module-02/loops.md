# 8. Costrutti di iterazione in Java

### Indice

- [8. Costrutti di iterazione in Java](#8-looping-constructs-in-java)
	- [8.1 Il ciclo while](#81-the-while-loop)
	- [8.2 Il ciclo do-while](#82-the-do-while-loop)
	- [8.3 Il ciclo for](#83-the-for-loop)
	- [8.4 Il ciclo for-each avanzato](#84-the-enhanced-for-each-loop)
	- [8.5 Cicli annidati](#85-nested-loops)
	- [8.6 Cicli infiniti](#86-infinite-loops)
	- [8.7 break e continue](#87-break-and-continue)
	- [8.8 Cicli etichettati](#88-labeled-loops)
	- [8.9 Ambito delle variabili di ciclo](#89-loop-variable-scope)
	- [8.10 Codice irraggiungibile dopo break continue e return](#810-unreachable-code-after-break-continue-and-return)
		- [8.10.1 Codice irraggiungibile dopo break](#8101-unreachable-code-after-break)
		- [8.10.2 Codice irraggiungibile dopo continue](#8102-unreachable-code-after-continue)
		- [8.10.3 Codice irraggiungibile dopo return](#8103-unreachable-code-after-return)

---

Java fornisce diversi **costrutti di iterazione** che consentono l’esecuzione ripetuta di un blocco di codice finché una condizione è vera.

I cicli sono essenziali per l’iterazione, l’attraversamento di strutture dati, calcoli ripetuti e l’implementazione di algoritmi.

## 8.1 Il ciclo `while`

Il ciclo `while` valuta la propria **condizione booleana prima di ogni iterazione**.
  
Se la condizione è `false` fin dall’inizio, il corpo non viene mai eseguito.

**Sintassi**
```java
while (condition) {
    // loop body
}
```

- La condizione deve essere valutata come un **booleano**.
- Il ciclo può essere eseguito zero o più volte.
- Tra gli errori comuni c’è il dimenticare di aggiornare la variabile del ciclo, causando un ciclo infinito.

- Esempio:
```java
int i = 0;
while (i < 3) {
    System.out.println(i);
    i++;
}
```

Output:
```bash
0
1
2
```

---

## 8.2 Il ciclo `do-while`

Il ciclo `do-while` valuta la propria condizione **dopo** aver eseguito il corpo, assicurando che **il corpo venga eseguito almeno una volta**.

**Sintassi**
```java
do {
    // loop body
} while (condition);
```

> [!TIP]
> `do-while` richiede un **punto e virgola** dopo la parentesi di chiusura.

- Esempio:
```java
int x = 5;
do {
    System.out.println(x);
    x--;
} while (x > 5); // il body è eseguito almeno una volta anche se la condizione è false
```

Output:
```bash
5
```

---

## 8.3 Il ciclo `for`

Il ciclo `for` tradizionale è più adatto per cicli con una variabile contatore.

È composto da tre parti: `inizializzazione`, `condizione`, `aggiornamento`.

**Sintassi**
```java
for (initialization; condition; update) {
    // loop body
}
```

- L’`inizializzazione` viene **eseguita una volta prima dell’inizio del ciclo**.
- La `condizione` viene **valutata prima di ogni iterazione**.
- L’`aggiornamento` viene **eseguito dopo ogni iterazione**.
- `Inizializzazione` e `aggiornamento` possono contenere più istruzioni separate da virgole.
- Le variabili nell’inizializzazione devono essere **tutte dello stesso tipo**.
- Qualsiasi componente può essere omesso, ma i punti e virgola rimangono.

- Esempio:
```java
for (int i = 0; i < 3; i++) {
    System.out.println(i);
}
```

Omettendo parti:
```java
int j = 0;
for (; j < 3;) {  // valid
    j++;
}
```

Istruzioni multiple:
```java
int x = 0;
for (long i = 0, c = 3; x < 3 && i < 12; x++, i++) {
    System.out.println(i);
}
```

---

## 8.4 Il ciclo `for-each` avanzato

Il `for` avanzato semplifica l’iterazione su `array` e `collezioni`.

**Sintassi**
```java
for (ElementType var : arrayOrCollection) {
    // loop body
}
```

- La variabile di ciclo è di sola lettura rispetto alla collezione sottostante.
- Funziona con qualsiasi `Iterable` o array.
- Non può rimuovere elementi senza un iteratore.

- Esempio:
```java
String[] names = {"A", "B", "C"};
for (String n : names) {
    System.out.println(n);
}
```

Output:
```bash
A
B
C
```

---

## 8.5 Cicli annidati

I cicli possono essere annidati; ciascuno mantiene le proprie variabili e condizioni.

```java
for (int i = 1; i <= 2; i++) {
    for (int j = 1; j <= 3; j++) {
        System.out.println(i + "," + j);
    }
}
```

Output:
```bash
1,1
1,2
1,3
2,1
2,2
2,3
```

---

## 8.6 Cicli infiniti

Un ciclo è infinito quando la sua condizione viene sempre valutata come `true` o è omessa.

```java
while (true) { ... }
```

```java
for (;;) { ... }
```

> [!TIP]
> I cicli infiniti devono contenere `break`, `return` o un controllo esterno.

---

## 8.7 `break` e `continue`

<ins>**break**</ins>
Esce immediatamente dal ciclo più interno.
```java
for (int i = 0; i < 5; i++) {
    if (i == 2) break;
    System.out.println(i);
}
```

<ins>**continue**</ins>
Salta il resto del corpo del ciclo e continua alla successiva iterazione.
```java
for (int i = 0; i < 5; i++) {
    if (i % 2 == 0) continue;
    System.out.println(i);
}
```

> [!NOTE]
> `break` e `continue` si applicano al ciclo più vicino a meno che non vengano usate etichette.

---

## 8.8 Cicli etichettati

Un’`etichetta` (identificatore + due punti) può essere applicata a un ciclo per consentire a break/continue di influire sui cicli esterni.

```java
labelName:
for (...) {
    for (...) {
        break labelName;
    }
}
```

- Esempio:
```java
outer:
for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= 3; j++) {
        if (j == 2) break outer;
        System.out.println(i + "," + j);
    }
}
```

---

## 8.9 Ambito delle variabili di ciclo

- Le variabili dichiarate nell’intestazione del ciclo hanno ambito limitato a quel ciclo.
- Le variabili dichiarate all’interno del corpo esistono solo all’interno di quel blocco.

```java
for (int i = 0; i < 3; i++) {
    int x = i * 2;
}
// i and x are not accessible here
```

---

## 8.10 Codice irraggiungibile dopo `break`, `continue` e `return`

Qualsiasi istruzione posizionata **dopo** `break`, `continue` o `return` nello stesso blocco è considerata irraggiungibile e non compila.

### 8.10.1 Codice irraggiungibile dopo `break`

```java
for (int i = 0; i < 3; i++) {
    break;
    System.out.println("Unreachable"); // ❌ Compile-time error
}
```

### 8.10.2 Codice irraggiungibile dopo `continue`

```java
for (int i = 0; i < 3; i++) {
    continue;
    System.out.println("Unreachable"); // ❌ Compile-time error
}
```

> [!NOTE]
> `continue` salta alla successiva iterazione, quindi il codice successivo non viene mai eseguito.

### 8.10.3 Codice irraggiungibile dopo `return`

```java
int test() {
    return 5;
    System.out.println("Unreachable"); // ❌ Compile-time error
}
```

> [!NOTE]
> `return` esce immediatamente dal metodo; nessuna istruzione può seguirlo.
