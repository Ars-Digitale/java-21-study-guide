# 3. Regole di naming Java

### Indice

- [3. Regole di naming Java](#3-regole-di-naming-java)
  - [3.1 Regole per gli identificatori](#31-regole-per-gli-identificatori)
    - [3.1.1 Parole riservate](#311-parole-riservate)
      - [3.1.1.1 Keyword Java riservate](#3111-keyword-java-riservate)
      - [3.1.1.2 Letterali riservati](#3112-letterali-riservati)
    - [3.1.2 Sensibilità alle maiuscole/minuscole](#312-sensibilità-alle-maiuscoleminuscole)
    - [3.1.3 Inizio degli identificatori](#313-inizio-degli-identificatori)
    - [3.1.4 Numeri negli identificatori](#314-numeri-negli-identificatori)
    - [3.1.5 Singolo token _](#315-singolo-token-_)
    - [3.1.6 Letterali numerici e carattere underscore](#316-letterali-numerici-e-carattere-underscore)

---

Java definisce regole precise per gli **identificatori**, ovvero i nomi assegnati a variabili, metodi, classi, interfacce e package.

Finché si rispettano le regole di naming descritte di seguito, si è liberi di scegliere nomi significativi per gli elementi del programma.

## 3.1 Regole per gli identificatori

### 3.1.1 Parole riservate

Gli `identifier` **non possono** coincidere con le **keyword** Java o con i **letterali riservati**.

Le `keyword` sono parole speciali predefinite nel linguaggio Java che non si possono usare come identificatori (vedi tabella qui sotto).

I `literal` come `true`, `false` e `null` sono anch’essi riservati e non possono essere usati come identificatori.

- Esempio:
```java
int class = 5;        // non valido: 'class' è una keyword
boolean true = false; // non valido: 'true' è un literal
int year = 2024;   	  // valido
```

#### 3.1.1.1 Keyword Java riservate

| a -> c | c -> f | f -> n | n -> s | s -> w |
| --- | --- | --- | --- | --- |
| abstract | continue | for | new | switch |
| assert | default | goto* | package | synchronized |
| boolean | do | if | private | this |
| break | double | implements | protected | throw |
| byte | else | import | public | throws |
| case | enum | instanceof | return | transient |
| catch | extends | int | short | try |
| char | final | interface | static | void |
| class | finally | long | strictfp | volatile |
| const* | float | native | super | while |

!!! note
    `goto` e `const` sono riservate ma non utilizzate.

#### 3.1.1.2 Letterali riservati

- `true`  
- `false`  
- `null`  

### 3.1.2 Sensibilità alle maiuscole/minuscole

Gli identificatori in Java sono **case sensitive**.  
Questo significa che `myVar`, `MyVar` e `MYVAR` sono tutti identificatori diversi.

- Esempio:
```java
int myVar = 1;
int MyVar = 2;
int MYVAR = 3;
int CLASS = 6; // legale ma, please, non farlo!!
```

!!! tip
    Java tratta gli identificatori letteralmente: `Count`, `count` e `COUNt` sono entità distinte e possono coesistere.
    
    A causa della sensibilità a maiuscole/minuscole, si potrebbero usare varianti delle keyword che differiscono solo nel case.  
    Anche se è legale, questo stile è fortemente sconsigliato perché riduce la leggibilità ed è considerata una pessima pratica.

### 3.1.3 Inizio degli identificatori

Gli identificatori in Java devono iniziare con una **lettera**, un **simbolo di valuta** (`$`, `€`, `£`, `₹`...) oppure il simbolo **`_`**.

Esempio:
```java
int myVarA;
int $myVarB;
int _myVarC;
String €uro = "currency"; // legale (usato raramente in pratica)
```

!!! note
    I simboli di valuta sono legali ma non raccomandati nel codice reale.

### 3.1.4 Numeri negli identificatori

Gli identificatori in Java possono includere numeri, ma **non possono iniziare** con un numero.

Esempio:
```java
int my33VarA;
int $myVar44;
int 3myVarC; // non valido: identifier non possono iniziare con una cifra
int var2024 = 10; // valido
```

### 3.1.5 Singolo token `_`

- Un singolo underscore (`_`) non è consentito come identificatore.
- A partire da Java 9, `_` è un token riservato per un possibile uso futuro del linguaggio.

- Esempio:
```java
int _;  // invalid since Java 9
```

!!! warning
    `_` è legale all’interno dei letterali numerici (vedi sezione successiva), ma non come identificatore a sé stante.

### 3.1.6 Letterali numerici e carattere underscore

Si possono usare uno o più caratteri `_` (underscore) nei letterali numerici per renderli più facili da leggere.

Puoi inserire underscore quasi ovunque, **tranne** all’inizio, alla fine o immediatamente prima/dopo il punto decimale.

- Esempio:
```java
int firstNum = 1_000_000;
int secondNum = 1 _____________ 2;

double firstDouble = _1000.00   // DOES NOT COMPILE
double secondDouble = 1000_.00  // DOES NOT COMPILE
double thirdDouble = 1000._00   // DOES NOT COMPILE
double fourthDouble = 1000.00_  // DOES NOT COMPILE

double pi = 3.14_159_265; // valid
long mask = 0b1111_0000;  // valid in binary literals
```

!!! tip
    Gli underscore migliorano la leggibilità:
    `1_000_000` è più leggibile di `1000000`.
