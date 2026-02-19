# 19. Eccezioni e Gestione degli Errori

<a id="indice"></a>
### Indice


 - [19.1 Gerarchia e tipi di eccezioni](#191-gerarchia-e-tipi-di-eccezioni)
	- [19.1.1 Throwable](#1911-throwable)
	- [19.1.2 Error (unchecked)](#1912-error-unchecked)
	- [19.1.3 Eccezioni Checked (`Exception`)](#1913-eccezioni-checked-exception)
	- [19.1.4 Eccezioni Unchecked (`RuntimeException`)](#1914-eccezioni-unchecked-runtimeexception)
 - [19.2 Dichiarare e lanciare eccezioni](#192-dichiarare-e-lanciare-eccezioni)
	- [19.2.1 Dichiarare eccezioni con throws](#1921-dichiarare-eccezioni-con-throws)
	- [19.2.2 Lanciare eccezioni](#1922-lanciare-eccezioni)
- [19.3 Override dei metodi e regole sulle eccezioni](#193-override-dei-metodi-e-regole-sulle-eccezioni)
- [19.4 Gestione delle eccezioni: try, catch, finally](#194-gestione-delle-eccezioni-try-catch-finally)
	- [19.4.1 Sintassi base try-catch](#1941-sintassi-base-try-catch)
	- [19.4.2 Blocchi catch multipli](#1942-blocchi-catch-multipli)
	- [19.4.3 Multi-catch Java 7](#1943-multi-catch-java-7)
	- [19.4.4 Blocco finally](#1944-blocco-finally)
- [19.5 Gestione automatica delle risorse try-with-resources](#195-gestione-automatica-delle-risorse-try-with-resources)
	- [19.5.1 Sintassi base](#1951-sintassi-base)
	- [19.5.2 Dichiarare risorse multiple](#1952-dichiarare-risorse-multiple)
	- [19.5.3 Scope delle risorse](#1953-scope-delle-risorse)
- [19.6 Eccezioni soppresse](#196-eccezioni-soppresse)
- [19.7 Riepilogo sulle eccezioni](#197-riepilogo-sulle-eccezioni)


---

Le `Exceptions` sono il meccanismo strutturato di Java per gestire condizioni anomale a runtime. 

Permettono ai programmi di separare il flusso di esecuzione normale dalla logica di gestione degli errori, migliorando robustezza, leggibilità e correttezza.

<a id="191-gerarchia-e-tipi-di-eccezioni"></a>
## 19.1 Gerarchia e tipi di eccezioni

Tutte le eccezioni derivano da `Throwable`.

La gerarchia definisce quali condizioni sono recuperabili, quali devono essere dichiarate e quali rappresentano errori fatali del sistema.

```text
java.lang.Object
└── java.lang.Throwable
    ├── java.lang.Error
    └── java.lang.Exception
        └── java.lang.RuntimeException
```

<a id="1911-throwable"></a>
### 19.1.1 Throwable

- Classe base per tutti gli errori e le eccezioni  
- Supporta messaggio, causa e stack trace  
- Solo `Throwable` (e le sue sottoclassi) può essere lanciato o catturato  

<a id="1912-error-unchecked"></a>
### 19.1.2 Error (unchecked)

- Rappresenta gravi problemi della JVM o del sistema  
- Non è pensato per essere catturato o gestito  
- Esempi: `OutOfMemoryError`, `StackOverflowError`  

> **NOTA**  
> Gli Error indicano condizioni dalle quali l’applicazione generalmente non è attesa a riprendersi.

<a id="1913-eccezioni-checked-exception"></a>
### 19.1.3 Eccezioni Checked (`Exception`)

- Sottoclassi di `Exception` **escludendo** `RuntimeException`  
- Rappresentano condizioni che le applicazioni potrebbero voler gestire  
- Devono essere **catturate** oppure **dichiarate**  
- Esempi: `IOException`, `SQLException`  

<a id="1914-eccezioni-unchecked-runtimeexception"></a>
### 19.1.4 Eccezioni Unchecked (`RuntimeException`)

- Sottoclassi di `RuntimeException`  
- Non è richiesto dichiararle o catturarle  
- Solitamente rappresentano errori di programmazione  
- Esempi: `NullPointerException`, `IllegalArgumentException`  

---

<a id="192-dichiarare-e-lanciare-eccezioni"></a>
## 19.2 Dichiarare e lanciare eccezioni

<a id="1921-dichiarare-eccezioni-con-throws"></a>
### 19.2.1 Dichiarare eccezioni con throws

Un metodo dichiara eccezioni **checked** usando la clausola `throws`. Questa fa parte del contratto API del metodo.

```java
void readFile(Path p) throws IOException {
	Files.readString(p);
}
```

> **NOTA**  
> Solo le **eccezioni checked** devono essere dichiarate. Le eccezioni unchecked possono essere dichiarate, ma di solito vengono omesse.

<a id="1922-lanciare-eccezioni"></a>
### 19.2.2 Lanciare eccezioni

Le eccezioni vengono create con `new` e lanciate esplicitamente usando `throw`.

```java
if (value < 0) {
	throw new IllegalArgumentException("value must be >= 0");
}
```

- `throw` lancia esattamente un’istanza di eccezione  
- `throws` dichiara le possibili eccezioni nella firma del metodo  

---

<a id="193-override-dei-metodi-e-regole-sulle-eccezioni"></a>
## 19.3 Override dei metodi e regole sulle eccezioni

Quando si fa override di un metodo, le regole sulle eccezioni sono applicate in modo rigoroso.

- Un metodo in override può lanciare **meno** o **più specifiche** eccezioni checked  
- Può lanciare qualsiasi eccezione unchecked  
- Non può lanciare **nuove o più generiche** eccezioni checked  

```java
class Parent {
	void work() throws IOException {}
}

class Child extends Parent {
	@Override
	void work() throws FileNotFoundException {} // OK (sottoclasse)
}
```

> **NOTA**  
> Cambiare solo le eccezioni **unchecked** non rompe mai il contratto di override.

---

<a id="194-gestione-delle-eccezioni-try-catch-finally"></a>
## 19.4 Gestione delle eccezioni: try, catch, finally

<a id="1941-sintassi-base-try-catch"></a>
### 19.4.1 Sintassi base try-catch

```java
try {
	riskyOperation();
} catch (IOException e) {
	handle(e);
}
```

- Un blocco `try` deve essere seguito da almeno un `catch` oppure da un `finally`  
- I catch vengono controllati dall’alto verso il basso  

<a id="1942-blocchi-catch-multipli"></a>
### 19.4.2 Blocchi catch multipli

Blocchi catch multipli permettono gestioni diverse per tipi di eccezione differenti.

```java
try {
	process();
} catch (FileNotFoundException e) {
	recover();
} catch (IOException e) {
	log();
}
```

> **NOTA**  
> Le eccezioni più specifiche devono venire prima di quelle più generali, altrimenti la compilazione fallisce.  
> Se si mette un catch per una superclasse (es. `IOException`) prima di uno per una sottoclasse (es. `FileNotFoundException`), il catch della sottoclasse diventa irraggiungibile.

<a id="1943-multi-catch-java-7"></a>
### 19.4.3 Multi-catch (Java 7+)

```java
try {
	process();
} catch (IOException | SQLException e) {
	log(e);
}
```

- I tipi di eccezione devono essere non correlati (nessuna relazione parent/child)  
- La variabile catturata è implicitamente `final`  

<a id="1944-blocco-finally"></a>
### 19.4.4 Blocco finally

Il blocco `finally` viene eseguito indipendentemente dal fatto che venga lanciata un’eccezione, tranne in casi estremi di terminazione della JVM.

```java
try {
	open();
} finally {
	close();
}
```

- Usato per logica di cleanup  
- Viene eseguito anche se si usa `return` nel blocco try e/o catch  

> **NOTA**  
> Un blocco `finally` può sovrascrivere un valore di ritorno o “inghiottire” un’eccezione. Questo è generalmente sconsigliato perché rende il flusso di controllo più difficile da comprendere.

---

<a id="195-gestione-automatica-delle-risorse-try-with-resources"></a>
## 19.5 Gestione automatica delle risorse (try-with-resources)

Il `try-with-resources` fornisce la chiusura automatica delle risorse che implementano `AutoCloseable`.

Elimina la necessità di cleanup esplicito con `finally` nella maggior parte dei casi.

<a id="1951-sintassi-base"></a>
### 19.5.1 Sintassi base

```java
try (BufferedReader br = Files.newBufferedReader(path)) {
	return br.readLine();
}
```

- Le risorse vengono chiuse automaticamente  
- La chiusura avviene anche se viene lanciata un’eccezione
- Le risorse vengono chiuse prima dell'esecuzione dei blocchi `catch` o del `finally`

```java
try (Resource a = new Resource()) {
    a.read();
} finally {
    a.close();  // ❌ Compile-time error: a è out of scope qui
}
```   

<a id="1952-dichiarare-risorse-multiple"></a>
### 19.5.2 Dichiarare risorse multiple

```java
try (InputStream in = Files.newInputStream(p);
		OutputStream out = Files.newOutputStream(q)) {
    in.transferTo(out);
}
```

- Le risorse vengono chiuse in **ordine inverso** rispetto alla dichiarazione  

<a id="1953-scope-delle-risorse"></a>
### 19.5.3 Scope delle risorse

- Le risorse sono visibili solo all’interno del blocco `try`  
- Sono implicitamente `final`  
- Da Java 9, si possono dichiarare risorse in anticipo, fuori dal try-with-resources, purché siano dichiarate `final` o siano effettivamente final.

```java
final var firstWriter = Files.newBufferedWriter(filePath);

try (firstWriter; var secondWriter = Files.newBufferedWriter(filePath)) {
	// CODE
}
```

> **NOTA**  
> Tentare di riassegnare una variabile risorsa causa un errore di compilazione.

```java
Resource a = new Resource();
try(a){ // since Java 9
  ...
}finally{
   a.close(); // questo codice compila ma la risorsa puntata dal reference 'a', è stata chiusa.
}
```

---

<a id="196-eccezioni-soppresse"></a>
## 19.6 Eccezioni soppresse

Quando sia il blocco `try` sia il metodo `close()` della risorsa lanciano eccezioni, Java conserva l’eccezione principale e **sopprime** le altre.

```java
try (BadResource r = new BadResource()) {
	throw new RuntimeException("main");
}
```

Se anche `close()` lancia un’eccezione, questa diventa **soppressa**.

```java
catch (Exception e) {
	for (Throwable t : e.getSuppressed()) {
		System.out.println(t);
	}
}
```

- L’eccezione principale viene lanciata  
- Le eccezioni secondarie sono accessibili tramite `getSuppressed()`  

---

<a id="197-riepilogo-sulle-eccezioni"></a>
## 19.7 Riepilogo sulle eccezioni

- Le eccezioni checked devono essere catturate o dichiarate  
- I metodi in override non possono ampliare le eccezioni checked  
- Usa il multi-catch per logica di gestione condivisa  
- Preferisci try-with-resources al cleanup con finally  
- Le risorse si chiudono in ordine inverso  
- Le eccezioni soppresse preservano il contesto completo del fallimento
