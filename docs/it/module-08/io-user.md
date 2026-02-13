# 36. Interagire con l’Utente (Stream I/O Standard)

### Indice

- [36. Interagire con l'Utente Stream I/O Standard](#36-interagire-con-lutente-stream-io-standard)
  - [36.1 Gli Stream I/O Standard](#361-gli-stream-io-standard)
  - [36.2 PrintStream Cosè e Perché Esiste](#362-printstream-cosè-e-perché-esiste)
    - [36.2.1 Caratteristiche Chiave di PrintStream](#3621-caratteristiche-chiave-di-printstream)
    - [36.2.2 Uso Base di PrintStream](#3622-uso-base-di-printstream)
    - [36.2.3 Formattare l'Output con PrintStream](#3623-formattare-loutput-con-printstream)
  - [36.3 Leggere Input come Stream I/O](#363-leggere-input-come-stream-io)
    - [36.3.1 Lettura a Basso Livello da Systemin](#3631-lettura-a-basso-livello-da-systemin)
    - [36.3.2 Uso di InputStreamReader e BufferedReader](#3632-uso-di-inputstreamreader-e-bufferedreader)
  - [36.4 La Classe Scanner Comoda ma Sottile](#364-la-classe-scanner-comoda-ma-sottile)
    - [36.4.1 Problemi Comuni di Scanner](#3641-problemi-comuni-di-scanner)
  - [36.5 Chiusura degli Stream di Sistema](#365-chiusura-degli-stream-di-sistema)
  - [36.6 Acquisire Input con Console](#366-acquisire-input-con-console)
    - [36.6.1 Leggere Input da Console](#3661-leggere-input-da-console)
    - [36.6.2 Leggere Password in Modo Sicuro](#3662-leggere-password-in-modo-sicuro)
  - [36.7 Formattare l'Output della Console](#367-formattare-loutput-della-console)
  - [36.8 Confronto tra Console Scanner e BufferedReader](#368-confronto-tra-console-scanner-e-bufferedreader)
  - [36.9 Redirezione e Stream Standard](#369-redirezione-e-stream-standard)
  - [36.10 Trappole Comuni e Best Practice](#3610-trappole-comuni-e-best-practice)
  - [36.11 Sintesi Finale](#3611-sintesi-finale)

---

I programmi Java spesso devono interagire con l’utente: stampare informazioni, leggere input e formattare l’output.

Questa interazione è implementata usando gli stream I/O standard, che sono normali stream Java connessi al sistema operativo.

Questo capitolo spiega come Java interagisce con la console e l’input/output standard,
partendo dai concetti più basilari e passando alle API di livello più alto.

## 36.1 Gli Stream I/O Standard

Ogni programma Java inizia con tre stream predefiniti forniti dalla JVM.

Sono connessi all’ambiente del processo (di solito un terminale o una console).

| Stream | Campo | Tipo | Scopo |
| --- | --- | --- | --- |
| Output standard | `System.out` | PrintStream | Output normale |
| Errore standard | `System.err` | PrintStream | Output di errore |
| Input standard | `System.in` | InputStream | Input dell’utente |

!!! note
    Questi stream sono creati dalla JVM, non dal programma.
    
    Essi esistono per l’intera durata del processo.

---

## 36.2 `PrintStream`: Cos’è e Perché Esiste

`PrintStream` è uno stream di output orientato ai byte progettato per output leggibile dall’utente.

Avvolge un altro OutputStream e aggiunge metodi di stampa convenienti.

`System.out` e `System.err` sono entrambi istanze di `PrintStream`.

### 36.2.1 Caratteristiche Chiave di PrintStream

- Stream orientato ai byte con helper per la stampa di testo
- Fornisce metodi `print()` e `println()`
- Converte automaticamente i valori in testo
- Non lancia `IOException` su errori di scrittura
- Supporta opzionalmente l’auto-flush su newline / `println()`

!!! note
    A differenza della maggior parte degli stream, PrintStream sopprime le IOExceptions.
    
    Gli errori devono essere verificati usando checkError().

### 36.2.2 Uso Base di PrintStream

```java
System.out.println("Hello");
System.out.print("Value: ");
System.out.println(42);
```

`println()` aggiunge automaticamente il separatore di linea specifico della piattaforma.

### 36.2.3 Formattare l’Output con PrintStream

PrintStream supporta output formattato usando `printf()` e `format()`,
che sono basati sulla stessa sintassi di String.format().

```java
System.out.printf("Name: %s, Age: %d%n", "Alice", 30);
```

| Specificatore | Significato |
| --- | --- |
| `%s` | Stringa |
| `%d` | Intero |
| `%f` | Virgola mobile |
| `%n` | Nuova linea indipendente dalla piattaforma |

!!! note
    `printf()` non aggiunge automaticamente una nuova linea a meno che non si specifichi `%n`.

---

## 36.3 Leggere Input come Stream I/O

L’input standard (System.in) è un InputStream connesso all’input dell’utente.

Fornisce byte grezzi e deve essere adattato per un uso pratico.

### 36.3.1 Lettura a Basso Livello da System.in

Al livello più basso, puoi leggere byte grezzi da System.in.

Questo è raramente conveniente per programmi interattivi.

```java
int b = System.in.read();
```

!!! note
    `System.in.read()` si blocca finché l’input non è disponibile.

### 36.3.2 Uso di InputStreamReader e BufferedReader

Per leggere input testuale, `System.in` è tipicamente avvolto in un Reader e bufferizzato.

```java
BufferedReader reader =
new BufferedReader(new InputStreamReader(System.in));

String line = reader.readLine();
```

Questo converte `byte → caratteri` e permette input basato su linee.

---

## 36.4 La Classe Scanner (Comoda ma Sottile)

`Scanner` è un’utilità di alto livello per il parsing di input testuale.

È spesso usata per l’interazione con la console, specialmente in piccoli programmi.

```java
Scanner sc = new Scanner(System.in);
int value = sc.nextInt();
String text = sc.nextLine();
```

!!! note
    `Scanner` esegue tokenizzazione e parsing, non semplice lettura.
    
    Questo la rende comoda ma più lenta e talvolta sorprendente.

### 36.4.1 Problemi Comuni di Scanner

- Mischiare `nextInt()` (e altri `nextXxx()`) con `nextLine()` può sembrare “saltare” input perché il newline finale del token numerico è ancora nel buffer.
- Gli errori di parsing lanciano InputMismatchException
- Scanner è relativamente lenta per input di grandi dimensioni

---

## 36.5 Chiusura degli Stream di Sistema

Gli `stream di sistema` sono speciali e devono essere gestiti con attenzione.

| Stream        | Chiudere esplicitamente? |
|--------------|---------------------------|
| `System.out` | No                        |
| `System.err` | No                        |
| `System.in`  | Di solito no              |

Chiudere `System.out` o `System.err` chiude lo stream sottostante del sistema operativo e influisce sull’intera JVM: chiudere questi stream influisce sull’intero processo JVM, non solo sulla classe o metodo corrente.

!!! note
    In quasi tutte le applicazioni, NON dovresti chiudere `System.out` o `System.err`.

---

## 36.6 Acquisire Input con `Console`

La classe `Console` fornisce un modo di livello più alto e più sicuro per interagire con l’utente.

È progettata specificamente per programmi di console interattivi.

```java
Console console = System.console();
if (console == null) {
    throw new IllegalStateException("No console available");
}
```

!!! note
    `System.console()` può restituire `null` quando nessuna console è disponibile
    (ad es. IDE, input rediretto).

### 36.6.1 Leggere Input da Console

```java
String name = console.readLine("Name: ");
```

`readLine()` stampa un prompt e legge una linea completa di input.

### 36.6.2 Leggere Password in Modo Sicuro

Console permette di leggere password senza mostrare i caratteri.

```java
char[] password = console.readPassword("Password: ");
```

!!! note
    Le password sono restituite come `char[]` così possono essere cancellate dalla memoria.

---

## 36.7 Formattare l’Output della Console

Console supporta anche output formattato, simile a PrintStream.

```java
console.printf("Welcome %s%n", name);
```

Questo usa gli stessi specificatori di formato di `printf()`.

---

## 36.8 Confronto tra Console, Scanner e BufferedReader

| API | Caso d’uso | Punti di forza | Limitazioni |
| --- | --- | --- | --- |
| `BufferedReader` | Input testuale semplice | Veloce, prevedibile, charset esplicito | Parsing manuale |
| `Scanner`        | Input basato su token / parsing | Comoda, espressiva | Più lenta, comportamento dei token sottile |
| `Console`        | App console interattive | Password, prompt, I/O formattato | Può non essere disponibile (`null`) |

---

## 36.9 Redirezione e Stream Standard

Gli stream standard possono essere rediretti dal sistema operativo.
Il codice Java non deve cambiare.

```bash
java App < input.txt > output.txt
```

Dal punto di vista del programma, `System.in` e `System.out` si comportano ancora come normali stream.

!!! note
    La redirezione è gestita dal sistema operativo o dalla shell. Il codice Java non deve cambiare per supportarla.

---

## 36.10 Trappole Comuni e Best Practice

- PrintStream sopprime le IOExceptions
- `System.console()` può restituire null
- Non chiudere `System.out` o `System.err`
- Scanner mescola parsing e lettura
- Console è preferibile per le password
- Se usi `Scanner` su `System.in`, non chiudere lo Scanner se altre parti del programma devono ancora leggere da `System.in` (chiudere lo Scanner chiude `System.in`).

---

## 36.11 Sintesi Finale

- `System.out` e `System.err` sono PrintStream per l’output
- `System.in` è uno stream di byte che deve essere adattato per il testo
- `BufferedReader` e `Scanner` sono strategie comuni di input
- `Console` fornisce input e output interattivo sicuro
- Gli stream standard si integrano naturalmente con la redirezione del sistema operativo
