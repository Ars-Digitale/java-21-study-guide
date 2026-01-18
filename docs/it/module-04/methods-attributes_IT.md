# 14. Metodi, Attributi e Variabili

### Indice

- [14. Metodi, Attributi e Variabili](#14-metodi-attributi-e-variabili)
   - [14.1 Metodi](#141-metodi)
     - [14.1.1 Componenti obbligatori di un metodo](#1411-componenti-obbligatori-di-un-metodo)
       - [14.1.1.1 Modificatori di accesso](#14111--modificatori-di-accesso)
       - [14.1.1.2 Tipo di ritorno](#14112-tipo-di-ritorno)
       - [14.1.1.3 Nome del metodo](#14113-nome-del-metodo)
       - [14.1.1.4 Firma del metodo](#14114-firma-del-metodo)
       - [14.1.1.5 Corpo del metodo](#14115-corpo-del-metodo)
     - [14.1.2 Modificatori opzionali](#1412-modificatori-opzionali)
     - [14.1.3 Dichiarare i metodi](#1413-dichiarare-i-metodi)
   - [14.2 Java è un linguaggio Pass-by-Value](#142-java-è-un-linguaggio-pass-by-value)
   - [14.3 Overloading dei metodi](#143-overloading-dei-metodi)
     - [14.3.1 Chiamare metodi overloaded](#1431-chiamare-metodi-overloaded)
       - [14.3.1.1 Vince la corrispondenza esatta](#14311-vince-la-corrispondenza-esatta)
       - [14.3.1.2 Se non esiste una corrispondenza esatta Java sceglie il tipo compatibile più specifico](#14312--se-non-esiste-una-corrispondenza-esatta-java-sceglie-il-tipo-compatibile-più-specifico)
       - [14.3.1.3 L’allargamento dei primitivi batte il boxing](#14313--lallargamento-dei-primitivi-batte-il-boxing)
       - [14.3.1.4 Il boxing batte i varargs](#14314--il-boxing-batte-i-varargs)
       - [14.3.1.5 Per i riferimenti Java sceglie il tipo di riferimento più specifico](#14315--per-i-riferimenti-java-sceglie-il-tipo-di-riferimento-piu-specifico)
       - [14.3.1.6 Quando non esiste un più specifico non ambiguo la chiamata è un errore di compilazione](#14316--quando-non-esiste-un-piu-specifico-non-ambiguo-la-chiamata-e-un-errore-di-compilazione)
       - [14.3.1.7 Overload misti primitivi + wrapper](#14317--overload-misti-primitivi--wrapper)
       - [14.3.1.8 Quando i primitivi si mescolano con i tipi di riferimento](#14318--quando-i-primitivi-si-mescolano-con-i-tipi-di-riferimento)
       - [14.3.1.9 Quando vince Object](#14319--quando-vince-object)
       - [14.3.1.10 Tabella riassuntiva risoluzione overload](#143110-tabella-riassuntiva-risoluzione-overload)
   - [14.4 Variabili locali e di istanza](#144-variabili-locali-e-di-istanza)
     - [14.4.1 Variabili di istanza](#1441-variabili-di-istanza)
     - [14.4.2 Variabili locali](#1442-variabili-locali)
       - [14.4.2.1 Variabili locali effettivamente final](#14421-variabili-locali-effettivamente-final)
       - [14.4.2.2 Parametri come effettivamente final](#14422-parametri-come-effettivamente-final)
   - [14.5 Varargs liste di argomenti a lunghezza variabile](#145-varargs-liste-di-argomenti-a-lunghezza-variabile)
   - [14.6 Metodi statici variabili statiche e inizializzatori statici](#146-metodi-statici-variabili-statiche-e-inizializzatori-statici)
     - [14.6.1 Variabili statiche variabili di classe](#1461-variabili-statiche-variabili-di-classe)
     - [14.6.2 Metodi statici](#1462-metodi-statici)
     - [14.6.3 Blocchi di inizializzazione statica](#1463-blocchi-di-inizializzazione-statica)
     - [14.6.4 Ordine di inizializzazione statico vs istanza](#1464-ordine-di-inizializzazione-statico-vs-istanza)
     - [14.6.5 Accesso ai membri statici](#1465-accesso-ai-membri-statici)
       - [14.6.5.1 Consigliato uso del nome della classe](#14651-consigliato-uso-del-nome-della-classe)
       - [14.6.5.2 Anche legale tramite riferimento di istanza](#14652-anche-legale-tramite-riferimento-di-istanza)
     - [14.6.6 Statico ed ereditarietà](#1466-statico-ed-ereditarieta)
     - [14.6.7 Errori comuni](#1467-errori-comuni)

---

Questo capitolo introduce concetti fondamentali di Programmazione Orientata agli Oggetti (OOP) in Java, iniziando con **metodi**, **passaggio dei parametri**, **overloading**, **variabili locali vs. di istanza** e **varargs**.

## 14.1 Metodi

I `metodi` rappresentano le **operazioni/comportamenti** che possono essere eseguiti da un particolare tipo di dato (una **classe**).
  
Descrivono *cosa può fare l’oggetto* e come interagisce con il suo stato interno e con il mondo esterno.

Una `dichiarazione di metodo` è composta da componenti **obbligatori** e **opzionali**.


### 14.1.1 Componenti obbligatori di un metodo

### 14.1.1.1  Modificatori di accesso

I `Modificatori di accesso` controllano la *visibilità*, non il comportamento.

( Fare riferimento al Paragrafo "**Access Modifiers**" nel Capitolo: [2. Basic Language Java Building Blocks](../module-01/basic-building-blocks.md) )


### 14.1.1.2 Tipo di ritorno

Appare **immediatamente prima** del nome del metodo.

- Se il metodo restituisce un valore → il tipo di ritorno specifica il tipo del valore.
- Se il metodo *non* restituisce un valore → la keyword `void` **deve** essere usata.
- Un metodo con tipo di ritorno non-void **deve** contenere almeno una istruzione `return valore;`.
- Un metodo `void` può:
-   - omettere una istruzione return
-   - includere `return;` (senza **nessun** valore)


### 14.1.1.3 Nome del metodo

Segue le stesse regole degli identificatori ( Fare riferimento al Capitolo: [3. Java Naming Rules](../module-01/naming-rules.md) ).


### 14.1.1.4 Firma del metodo
 
La **firma del metodo** in Java include:

- il *nome del metodo*
- la *lista dei tipi dei parametri* (tipi + ordine)

> [!NOTE]
> I **nomi dei parametri NON fanno parte della firma**, contano solo tipi e ordine.

- Esempio di firme distinte:

```java
void process(int x)
void process(int x, int y)
void process(int x, String y)
```

- Esempio di *stessa* firma (overloading illegale):

```java
// ❌ stessa firma: differiscono solo i nomi dei parametri
void m(int a)
void m(int b)
```


### 14.1.1.5 Corpo del metodo
 
Un blocco `{ }` contenente **zero o più istruzioni**.
  
Se il metodo è `abstract`, il corpo deve essere omesso.


### 14.1.2 Modificatori opzionali

I modificatori opzionali dei metodi includono:

- `static`
- `abstract`
- `final`
- `default` (metodi di interfaccia)
- `synchronized`
- `native`
- `strictfp`

Regole:

- I modificatori opzionali possono apparire in **qualsiasi ordine**.
- Tutti i modificatori devono apparire **prima del tipo di ritorno**.

- Esempio:

```java
public static final int compute() {
    return 10;
}
```


### 14.1.3 Dichiarare i metodi

```java
public final synchronized String formatValue(int x, double y) throws IOException {
    return "Result: " + x + ", " + y;
}
```

Scomposizione:

| Part | Significato |
| --- | --- |
| public | modificatore di accesso |
| final | non può essere sovrascritto |
| synchronized | modificatore di controllo dei thread |
| String | tipo di ritorno |
| formatValue | nome del metodo |
| (int x, double y) | lista dei parametri |
| throws IOException | lista delle eccezioni |
| method body | implementazione |


## 14.2 Java è un linguaggio “Pass-by-Value”

Java usa **solo pass-by-value**, senza eccezioni.

Questo significa:

- Per i **tipi primitivi** → il metodo riceve una *copia del valore*.
- Per i **tipi riferimento** → il metodo riceve una *copia del riferimento*, il che significa:
-   - il riferimento stesso non può essere cambiato dal metodo
-   - l’*oggetto* **può** essere modificato tramite quel riferimento

- Esempio:

```java
void modify(int a, StringBuilder b) {
    a = 50;           // modifica la *copia* → nessun effetto all’esterno
    b.append("!");    // modifica l’*oggetto* → visibile all’esterno
}
```

```java
public static void main(String[] args) {
    
	int num1 = 11;
	methodTryModif(num1);
	System.out.println(num1);
	
}

public static void methodTryModif(int num1){	
	num1 = 10;  // questa nuova assegnazione influisce solo sul parametro del metodo che, accidentalmente, ha lo stesso nome della variabile esterna.
}
```

---

## 14.3 Overloading dei metodi

L’overloading dei metodi significa **stesso nome del metodo**, **firma diversa**.

Due metodi sono considerati overloaded se differiscono per:

- numero di parametri
- tipi dei parametri
- ordine dei parametri

L’overloading **NON dipende da**:

- tipo di ritorno
- modificatore di accesso
- eccezioni

- Esempio:

```java
void print(int x)
void print(double x)
void print(int x, int y)
```

Metodo overloaded illegale:

```java
// ❌ Il tipo di ritorno non conta nell’overloading
int compute(int x)
double compute(int x)
```


### 14.3.1 Chiamare metodi overloaded

Quando sono disponibili più metodi overloaded, Java applica la **risoluzione dell’overload** per decidere quale metodo chiamare.
  
Il compilatore seleziona il metodo i cui tipi di parametro sono i **più specifici** e **compatibili** con gli argomenti forniti.

La risoluzione dell’overload avviene **a compile-time** (a differenza dell’overriding, che è basato sul run-time).

Java segue queste regole:


### 14.3.1.1 Vince la corrispondenza esatta

Se un argomento corrisponde esattamente a un parametro del metodo, quel metodo viene scelto.

```java
void call(int x)    { System.out.println("int"); }
void call(long x)   { System.out.println("long"); }

call(5); // stampa: int (corrispondenza esatta per int)
```


### 14.3.1.2 — Se non esiste una corrispondenza esatta, Java sceglie il tipo compatibile *più specifico*

Java preferisce:

- **widening** rispetto all’autoboxing
- **autoboxing** rispetto ai varargs
- **riferimento più ampio** solo se un tipo più specifico non è disponibile

- Esempio con primitivi numerici:

```java
void test(long x)   { System.out.println("long"); }
void test(float x)  { System.out.println("float"); }

test(5);  // letterale int: può essere allargato a long o float
          // ma long è più specifico di float per i tipi interi
          // Output: long
```


### 14.3.1.3 — L’allargamento dei primitivi batte il boxing

Se un argomento primitivo può essere sia allargato sia autoboxato, Java sceglie l’allargamento.

```java
void m(int x)       { System.out.println("int"); }
void m(Integer x)   { System.out.println("Integer"); }

byte b = 10;
m(b);               // byte → int (widening) vince
                    // Output: int
```


### 14.3.1.4 — Il boxing batte i varargs

```java
void show(Integer x)    { System.out.println("Integer"); }
void show(int... x)     { System.out.println("varargs"); }

show(5);                // int → Integer (boxing) preferito
                        // Output: Integer
```


### 14.3.1.5 — Per i riferimenti, Java sceglie il tipo di riferimento più specifico

```java
void ref(Object o)      { System.out.println("Object"); }
void ref(String s)      { System.out.println("String"); }

ref("abc");             // "abc" è una String → più specifica di Object
                        // Output: String
```

Più specifico significa *più in basso nella gerarchia di ereditarietà*.


### 14.3.1.6 — Quando non esiste un “più specifico” non ambiguo, la chiamata è un errore di compilazione

Esempio con classi sorelle:

```java
void check(Number n)      { System.out.println("Number"); }
void check(String s)      { System.out.println("String"); }

check(null);    // Sia String che Number accettano null
                // String è più specifica perché è una classe concreta
                // Output: String
```

Ma se competono due classi non correlate:

```java
void run(String s)   { }
void run(Integer i)  { }

run(null);  // ❌ Errore a compile-time: chiamata di metodo ambigua
```


### 14.3.1.7 — Overload misti primitivi + wrapper

Java valuta widening, boxing e varargs in questo ordine:

**`widening → boxing → varargs`**

- Esempio:

```java
void mix(long x)        { System.out.println("long"); }
void mix(Integer x)     { System.out.println("Integer"); }
void mix(int... x)      { System.out.println("varargs"); }

short s = 5;
mix(s);   // short → int → long  (widening)
          // boxing e varargs ignorati
          // Output: long
```


### 14.3.1.8 — Quando i primitivi si mescolano con i tipi di riferimento

```java
void fun(Object o)     { System.out.println("Object"); }
void fun(int x)        { System.out.println("int"); }

fun(10);                // vince la corrispondenza primitiva esatta
                        // Output: int

Integer i = 10;
fun(i);                 // riferimento accettato → Object
                        // Output: Object
```


### 14.3.1.9 — Quando vince Object

```java
void fun(List<String> o)    { System.out.println("O"); }
void fun(CharSequence x)    { System.out.println("X"); }
void fun(Object y)        	{ System.out.println("Y"); }

fun(LocalDate.now());       // Output: Y
```


### 14.3.1.10 Tabella riassuntiva (Risoluzione dell’overload)

| Situation | Rule |
| --- | --- |
| Exact match | Sempre scelto |
| Primitive widening vs boxing | Vince il widening |
| Boxing vs varargs | Vince il boxing |
| Most specific reference type | Vince |
| Unrelated reference types | Ambiguo → errore di compilazione |
| Mixed primitive + wrapper | Widening → boxing → varargs |


## 14.4 Variabili locali e di istanza

### 14.4.1 Variabili di istanza

Le variabili di istanza sono:

- dichiarate come membri di una classe
- create quando un oggetto è istanziato
- accessibili da tutti i metodi dell’istanza

Modificatori possibili per le variabili di istanza:

- modificatori di accesso (`public`, `protected`, `private`)
- `final`
- `volatile`
- `transient`

- Esempio:

```java
public class Person {
    private String name;         // variabile di istanza
    protected final int age = 0; // final significa che non può essere riassegnata
}
```


### 14.4.2 Variabili locali

Le variabili locali:

- sono dichiarate *all’interno* di un metodo, costruttore o blocco
- non hanno **valori di default** → devono essere inizializzate esplicitamente prima dell’uso
- unico modificatore consentito: **final**

- Esempio:

```java
void calculate() {
    int x;        // dichiarata
    x = 10;       // deve essere inizializzata prima dell’uso

    final int y = 5;  // legale
}
```

Due casi speciali:


### 14.4.2.1 Variabili locali effettivamente final
 
Una variabile locale è *effettivamente final* se viene **assegnata una sola volta**, anche senza `final`.

Le variabili effettivamente final possono essere usate in:

- espressioni lambda
- classi locali/anonime


### 14.4.2.2 Parametri come effettivamente final

I parametri di metodo si comportano come variabili locali e seguono le stesse regole.


## 14.5 Varargs (Liste di argomenti a lunghezza variabile)

I varargs permettono a un metodo di accettare **zero o più** parametri dello stesso tipo.

Sintassi:

```java
void printNames(String... names)
```

Regole:

- Un metodo può avere **un solo** parametro varargs.
- Deve essere l’**ultimo** parametro nella lista.
- I varargs sono trattati come un **array** all’interno del metodo.

- Esempio:

```java
void show(int x, String... values) {
    System.out.println(values.length);
}

show(10);                     // length = 0
show(10, "A");                // length = 1
show(10, "A", "B", "C");      // length = 3
```

> [!IMPORTANT]
> Varargs e array partecipano all’overloading dei metodi.
> La risoluzione dell’overload può diventare ambigua.


## 14.6 Metodi statici, variabili statiche e inizializzatori statici

In Java, la keyword **`static`** marca elementi che **appartengono alla classe stessa**, non alle singole istanze.
Questo significa:

- Sono **caricati una sola volta** in memoria quando la classe è caricata per la prima volta dalla JVM.
- Sono condivisi tra **tutte le istanze**.
- Possono essere accessi **senza creare un oggetto** della classe.

I membri statici sono memorizzati nella **method area** della JVM (memoria a livello di classe), mentre i membri di istanza vivono nello **heap**.


### 14.6.1 Variabili statiche (Variabili di classe)

Una **variabile statica** è una variabile definita a livello di classe e condivisa da tutte le istanze.

Caratteristiche:

- Create quando la classe è caricata.
- Esistono **anche se nessuna istanza** della classe è creata.
- Tutti gli oggetti vedono lo **stesso valore**.
- Possono essere marcate `final`, `volatile` o `transient`.

- Esempio:

```java
public class Counter {
    static int count = 0;    // condivisa da tutte le istanze
    int id;                  // variabile di istanza

    public Counter() {
        count++;
        id = count;          // ogni istanza ottiene un id unico
    }
}
```


### 14.6.2 Metodi statici

Un **metodo statico** appartiene alla classe, non a una istanza dell’oggetto.

Regole:

- Possono essere chiamati usando il nome della classe: `ClassName.method()`.
- Non possono accedere direttamente a variabili o metodi di istanza, ma solo tramite un’istanza della classe.
- Non possono usare `this` o `super`.
- Sono comunemente usati per:
-   - metodi di utilità (es. `Math.sqrt()`)
-   - factory methods
-   - comportamenti globali che non dipendono dallo stato di istanza

- Esempio:

```java
public class MathUtil {

    static int square(int x) {        // metodo statico
        return x * x;
    }

    void instanceMethod() {
        // System.out.println(count);   // OK: accesso a variabile statica
        // square(5);                   // OK: metodo statico accessibile
    }
}
```

Errori comuni:

```java
// ❌ Errore di compilazione: metodo di istanza non accessibile direttamente in contesto statico
static void go() {
    run();        // run() è un metodo di istanza!
}

void run() { }
```


### 14.6.3 Blocchi di inizializzazione statica

I blocchi di inizializzazione statica permettono di eseguire codice **una sola volta**, quando la classe è caricata.

Sintassi:

```java
static {
    // logica di inizializzazione
}
```

Utilizzo:

- inizializzazione di variabili statiche complesse
- esecuzione di setup a livello di classe
- esecuzione di codice che deve essere eseguito esattamente una volta

- Esempio:

```java
public class Config {

    static final Map<String, String> settings = new HashMap<>();

    static {
        settings.put("mode", "production");
        settings.put("version", "1.0");
        System.out.println("Static initializer executed");
    }
}
```

> [!IMPORTANT]
> I blocchi di inizializzazione statica vengono eseguiti **una sola volta**, nell’ordine in cui appaiono, prima di `main()` e prima che qualsiasi metodo statico sia chiamato.


### 14.6.4 Ordine di inizializzazione (Statico vs. Istanza)

( Fare riferimento al Capitolo: [15. Class Loading, Initialization, and Object Construction](class-loading.md) )


### 14.6.5 Accesso ai membri statici

### 14.6.5.1 Consigliato: usare il nome della classe

```java
Math.sqrt(16);
MyClass.staticMethod();
```


### 14.6.5.2 Anche legale: tramite riferimento di istanza

```java
MyClass obj = new MyClass();
obj.staticMethod();
```


### 14.6.6 Statico ed ereditarietà

I metodi statici:

- possono essere **nascosti**, non sovrascritti
- il binding è a **compile-time**, non a runtime
- sono accessi in base al **tipo del riferimento**, non al tipo dell’oggetto

- Esempio:

```java
class A {
    static void test() { System.out.println("A"); }
}

class B extends A {
    static void test() { System.out.println("B"); }
}

A ref = new B();
ref.test();   // stampa "A" — binding statico!
```

> [!NOTE]
> Regola chiave: i metodi statici usano il **tipo del riferimento**, non il tipo dell’oggetto.


### 14.6.7 Errori comuni

- Tentare di riferirsi a una variabile/metodo di istanza da un contesto statico.
- Supporre che i metodi statici siano sovrascritti → sono **nascosti**.
- Chiamare un metodo statico da un riferimento di istanza (legale ma confondente).
- Confondere l’ordine di inizializzazione degli elementi statici rispetto a quelli di istanza.
- Dimenticare che le variabili statiche sono condivise tra tutti gli oggetti.
- Non sapere che gli inizializzatori statici vengono eseguiti *una sola volta*, in ordine di dichiarazione.

