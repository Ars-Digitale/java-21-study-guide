# 34. Stream I/O in Java

<a id="indice"></a>
### Indice

- [34. Stream I/O in Java](#34-stream-io-in-java)
  - [34.1 Che cos’è uno Stream I/O in Java](#341-che-cosè-uno-stream-io-in-java)
  - [34.2 Stream di Byte vs Stream di Caratteri](#342-stream-di-byte-vs-stream-di-caratteri)
    - [34.2.1 Stream di Byte](#3421-stream-di-byte)
    - [34.2.2 Stream di Caratteri](#3422-stream-di-caratteri)
    - [34.2.3 Tabella di riepilogo](#3423-tabella-di-riepilogo)
  - [34.3 Stream di Basso Livello vs Stream di Alto Livello](#343-stream-di-basso-livello-vs-stream-di-alto-livello)
    - [34.3.1 Stream di Basso Livello Node-Streams](#3431-stream-di-basso-livello-node-streams)
    - [34.3.2 Stream comuni di Basso Livello](#3432-stream-comuni-di-basso-livello)
    - [34.3.3 Stream di Alto Livello Filter--Processing-Streams](#3433-stream-di-alto-livello-filter--processing-streams)
    - [34.3.4 Stream comuni di Alto Livello](#3434-stream-comuni-di-alto-livello)
    - [34.3.5 Regole di chaining degli stream e errori comuni](#3435-regole-di-chaining-degli-stream-e-errori-comuni)
      - [34.3.5.1 Regola fondamentale di chaining](#34351-regola-fondamentale-di-chaining)
      - [34.3.5.2 Incompatibilità tra stream di byte e stream di caratteri](#34352-incompatibilità-tra-stream-di-byte-e-stream-di-caratteri)
      - [34.3.5.3 Chaining non valido errore-di-compilazione](#34353-chaining-non-valido-errore-di-compilazione)
      - [34.3.5.4 Bridging da stream di byte a stream di caratteri](#34354-bridging-da-stream-di-byte-a-stream-di-caratteri)
      - [34.3.5.5 Pattern corretto di conversione](#34355-pattern-corretto-di-conversione)
      - [34.3.5.6 Regole di ordinamento nelle catene di stream](#34356-regole-di-ordinamento-nelle-catene-di-stream)
      - [34.3.5.7 Ordine logico corretto](#34357-ordine-logico-corretto)
      - [34.3.5.8 Regola di gestione delle risorse](#34358-regola-di-gestione-delle-risorse)
      - [34.3.5.9 Trappole comuni](#34359-trappole-comuni)
  - [34.4 Classi base principali di javaio e metodi chiave](#344-classi-base-principali-di-javaio-e-metodi-chiave)
    - [34.4.1 InputStream](#3441-inputstream)
      - [34.4.1.1 Metodi chiave](#34411-metodi-chiave)
      - [34.4.1.2 Esempio tipico di utilizzo](#34412-esempio-tipico-di-utilizzo)
    - [34.4.2 OutputStream](#3442-outputstream)
      - [34.4.2.1 Metodi chiave](#34421-metodi-chiave)
      - [34.4.2.2 Esempio tipico di utilizzo](#34422-esempio-tipico-di-utilizzo)
    - [34.4.3 Reader e Writer](#3443-reader-e-writer)
      - [34.4.3.1 Gestione del charset](#34431-gestione-del-charset)
  - [34.5 Stream bufferizzati e prestazioni](#345-stream-bufferizzati-e-prestazioni)
    - [34.5.1 Perché il buffering conta](#3451-perché-il-buffering-conta)
    - [34.5.2 Come funziona la lettura non bufferizzata](#3452-come-funziona-la-lettura-non-bufferizzata)
    - [34.5.3 Come funziona BufferedInputStream](#3453-come-funziona-bufferedinputstream)
    - [34.5.4 Esempio di output bufferizzato](#3454-esempio-di-output-bufferizzato)
    - [34.5.5 BufferedReader vs Reader](#3455-bufferedreader-vs-reader)
    - [34.5.6 Esempio di BufferedWriter](#3456-esempio-di-bufferedwriter)
  - [34.6 java io vs java nio e java nio file](#346-javaio-vs-javanio-e-javaniofile)
    - [34.6.1 Differenze concettuali](#3461-differenze-concettuali)
    - [34.6.2 java-nio I/O file moderno](#3462-javanio-io-file-moderno)
  - [34.7 Quando usare quale API](#347-quando-usare-quale-api)
  - [34.8 Trappole comuni e suggerimenti](#348-trappole-comuni-e-suggerimenti)

---

Questo capitolo fornisce una spiegazione dettagliata degli `stream I/O in Java`.

Copre gli stream classici **java.io**, li mette a confronto con **java.nio / java.nio.file**, e spiega principi di progettazione, API, casi limite e distinzioni rilevanti.

<a id="341-che-cosè-uno-stream-io-in-java"></a>
## 34.1 Che cos’è uno Stream I/O in Java?

Uno `stream I/O` rappresenta un flusso di dati tra un programma Java e una sorgente o destinazione esterna.

I dati scorrono in modo sequenziale, come acqua in un tubo.

- Uno stream non è una struttura dati; non memorizza dati in modo permanente
- Gli stream sono unidirezionali (input O output)
- Gli stream astraggono la sorgente sottostante (file, rete, memoria, dispositivo)
- Gli stream operano in modo bloccante, sincrono (I/O classico)

In Java, gli stream sono organizzati attorno a due dimensioni principali:

- `Direzione`: Input vs Output
- `Tipo di dato`: Byte vs Carattere

---

<a id="342-stream-di-byte-vs-stream-di-caratteri"></a>
## 34.2 Stream di Byte vs Stream di Caratteri

Java distingue gli stream in base all’unità di dato che elaborano.

<a id="3421-stream-di-byte"></a>
### 34.2.1 Stream di Byte

- Lavorano con byte grezzi a 8 bit
- Usati per dati binari (immagini, audio, PDF, ZIP)
- Classi base: `InputStream` e `OutputStream`

<a id="3422-stream-di-caratteri"></a>
### 34.2.2 Stream di Caratteri

- Lavorano con caratteri Unicode a 16 bit
- Gestiscono automaticamente l’encoding dei caratteri
- Classi base: `Reader` e `Writer`

<a id="3423-tabella-di-riepilogo"></a>
### 34.2.3 Tabella di riepilogo

|	Aspetto	|	Stream di Byte	|	Stream di Caratteri	|
|-----------|-------------------|-----------------------|
|	`Unità di dato`	|	byte (8 bit)	|	char (16 bit)	|
|	`Gestione encoding`	|	Nessuna	|	Sì (consapevole del charset)	|
|	`Classi base`	|	InputStream / OutputStream	|	Reader / Writer	|
|	`Uso tipico`	|	File binari	|	File di testo	|
| 	`Focus`	|	I/O a basso livello	|	Elaborazione testo	|

---

<a id="343-stream-di-basso-livello-vs-stream-di-alto-livello"></a>
## 34.3 Stream di Basso Livello vs Stream di Alto Livello

Gli stream in `java.io` seguono un pattern decorator. Gli stream vengono impilati per aggiungere funzionalità.

<a id="3431-stream-di-basso-livello-node-streams"></a>
### 34.3.1 Stream di Basso Livello (Node Streams)

Gli stream di basso livello si collegano direttamente a una sorgente o a una destinazione di dati.

- Sanno come leggere/scrivere byte o caratteri
- NON forniscono buffering, formattazione o gestione di oggetti

<a id="3432-stream-comuni-di-basso-livello"></a>
### 34.3.2 Stream comuni di Basso Livello

|	Classe Stream	|	Scopo	|
|-------------------|-----------|
|	`FileInputStream`		|	Legge byte da file	|
|	`FileOutputStream`	|	Scrive byte su file	|
|	`FileReader`	|	Legge caratteri da file	|
|	`FileWriter`	|	Scrive caratteri su file	|

- Esempio: stream di byte a basso livello

```java
try (InputStream in = new FileInputStream("data.bin")) {
	int b;
	while ((b = in.read()) != -1) {
		System.out.println(b);
	}
}
```

!!! note
    Gli stream di basso livello sono raramente usati da soli nelle applicazioni reali a causa di prestazioni scarse e funzionalità limitate.

<a id="3433-stream-di-alto-livello-filter-processing-streams"></a>
### 34.3.3 Stream di Alto Livello (Filter / Processing Streams)

Gli stream di alto livello avvolgono altri stream per aggiungere funzionalità.

- Buffering
- Conversione del tipo di dato
- Serializzazione di oggetti
- Lettura/scrittura di primitivi

<a id="3434-stream-comuni-di-alto-livello"></a>
### 34.3.4 Stream comuni di Alto Livello

|	Classe Stream	|	Aggiunge funzionalità	|
|-------------------|-----------------------|
|	`BufferedInputStream`	|	Buffering	|
|	`BufferedReader`	|	Lettura basata su linee	|
|	`DataInputStream`	|	Tipi primitivi	|
|	`ObjectInputStream`	|	Serializzazione oggetti	|
|	`PrintWriter`	|	Output testo formattato	|

- Esempio: chaining degli stream

```java
try (BufferedReader reader =
	new BufferedReader(
		new InputStreamReader(
			new FileInputStream("text.txt")))) {

	String line;
	while ((line = reader.readLine()) != null) {
		System.out.println(line);
	}
}
```

<a id="3435-regole-di-chaining-degli-stream-e-errori-comuni"></a>
### 34.3.5 Regole di chaining degli stream e errori comuni

L’esempio precedente illustra lo stream chaining, un concetto centrale in `java.io` basato sul pattern decorator.

Ogni stream avvolge un altro stream, aggiungendo funzionalità preservando una gerarchia di tipi rigorosa.

<a id="34351-regola-fondamentale-di-chaining"></a>
#### 34.3.5.1 Regola fondamentale di chaining

Uno stream può avvolgere solo un altro stream di un livello di astrazione compatibile.

- Gli stream di byte possono avvolgere solo stream di byte
- Gli stream di caratteri possono avvolgere solo stream di caratteri
- Gli stream di alto livello richiedono uno stream di basso livello sottostante

!!! note
    Non puoi mescolare arbitrariamente `InputStream` con `Reader` o `OutputStream` con `Writer`.

<a id="34352-incompatibilità-tra-stream-di-byte-e-stream-di-caratteri"></a>
#### 34.3.5.2 Incompatibilità tra stream di byte e stream di caratteri

Un errore molto comune è tentare di avvolgere uno stream di byte direttamente con una classe basata su caratteri (o viceversa).

<a id="34353-chaining-non-valido-errore-di-compilazione"></a>
#### 34.3.5.3 Chaining non valido (errore di compilazione)

```java
BufferedReader reader =
	new BufferedReader(new FileInputStream("text.txt"));
```

!!! note
    Questo fallisce perché `BufferedReader` si aspetta un `Reader`, non un `InputStream`.

<a id="34354-bridging-da-stream-di-byte-a-stream-di-caratteri"></a>
#### 34.3.5.4 Bridging da stream di byte a stream di caratteri

Per convertire tra stream basati su byte e stream basati su caratteri, Java fornisce classi ponte che eseguono decodifica/codifica esplicita del charset.

- `InputStreamReader` converte byte → caratteri
- `OutputStreamWriter` converte caratteri → byte

<a id="34355-pattern-corretto-di-conversione"></a>
#### 34.3.5.5 Pattern corretto di conversione

```java
BufferedReader reader =
	new BufferedReader(
		new InputStreamReader(new FileInputStream("text.txt")));
```

!!! note
    Il ponte gestisce la decodifica dei caratteri usando un charset (predefinito o esplicito).

<a id="34356-regole-di-ordinamento-nelle-catene-di-stream"></a>
#### 34.3.5.6 Regole di ordinamento nelle catene di stream

L’ordine di wrapping non è arbitrario.

- Lo stream di basso livello deve essere il più interno
- I bridge (se necessari) vengono dopo
- Gli stream bufferizzati o di elaborazione vengono per ultimi

<a id="34357-ordine-logico-corretto"></a>
#### 34.3.5.7 Ordine logico corretto

```text
FileInputStream → InputStreamReader → BufferedReader
```

<a id="34358-regola-di-gestione-delle-risorse"></a>
#### 34.3.5.8 Regola di gestione delle risorse

Chiudere lo stream più esterno chiude automaticamente tutti gli stream avvolti.

!!! note
    Per questo try-with-resources dovrebbe riferirsi solo allo stream di livello più alto.

<a id="34359-trappole-comuni"></a>
#### 34.3.5.9 Trappole comuni

- Tentare di bufferizzare uno stream del tipo sbagliato
- Dimenticare il bridge tra stream di byte e stream di char
- Assumere che `Reader` funzioni con dati binari
- Usare il charset predefinito involontariamente
- Chiudere manualmente gli stream interni (rischiando double-close): `close()` sul wrapper esterno è sufficiente ed è raccomandato

---

<a id="344-classi-base-principali-di-javaio-e-metodi-chiave"></a>
## 34.4 Classi base principali di `java.io` e metodi chiave

Il package `java.io` è costruito attorno a un piccolo insieme di **classi base astratte**.
Comprendere queste classi e i loro contratti è essenziale, perché tutte le classi I/O concrete si basano su di esse.

<a id="3441-inputstream"></a>
### 34.4.1 InputStream

Classe base astratta per input orientato ai byte.
Tutti gli input stream leggono byte grezzi (valori a 8 bit) da una sorgente come un file, un socket di rete o un buffer di memoria.

<a id="34411-metodi-chiave"></a>
#### 34.4.1.1 Metodi chiave

| Metodo | Descrizione |
|--------|-------------|
| int `read()`	|	Legge un byte (0–255); ritorna -1 a fine stream |
| int `read(byte[])`	|	Legge byte in un buffer; ritorna numero di byte letti o -1 |
| int `read(byte[], int, int)`	|	Legge fino a length byte in una slice del buffer |
| int `available()`	|	Byte leggibili senza bloccare (hint, non garanzia) |
| void `close()`	|	Rilascia la risorsa sottostante |

!!! note
    I metodi `read()` sono bloccanti per default.
    
    Sospendono il thread chiamante finché i dati non sono disponibili, finché non si raggiunge end-of-stream, o finché non si verifica un errore I/O.

Il metodo `read()` a singolo byte è principalmente un primitivo di basso livello.

In pratica, leggere un byte alla volta è inefficiente e dovrebbe quasi sempre essere evitato a favore di letture bufferizzate.

<a id="34412-esempio-tipico-di-utilizzo"></a>
#### 34.4.1.2 Esempio tipico di utilizzo

```java
try (InputStream in = new FileInputStream("data.bin")) {
	byte[] buffer = new byte[1024];
	int count;
	while ((count = in.read(buffer)) != -1) {
		// process buffer[0..count-1]
	}
}
```

<a id="3442-outputstream"></a>
### 34.4.2 OutputStream

Classe base astratta per output orientato ai byte.

Rappresenta una destinazione dove possono essere scritti byte grezzi.

<a id="34421-metodi-chiave"></a>
#### 34.4.2.1 Metodi chiave

| Metodo | Descrizione |
|--------|-------------|
| void `write(int b)`	|	Scrive gli 8 bit meno significativi dell’intero |
| void `write(byte[])`	|	Scrive un intero array di byte |
| void `write(byte[], int, int)`	|	Scrive una slice di un array di byte |
| void `flush()`	|	Forza la scrittura dei dati bufferizzati |
| void `close()`	|	Esegue flush e rilascia la risorsa |

!!! note
    Chiamare `close()` richiama implicitamente `flush()`.
    
    Non eseguire flush o close su un OutputStream può causare perdita di dati.

<a id="34422-esempio-tipico-di-utilizzo"></a>
#### 34.4.2.2 Esempio tipico di utilizzo

```java
try (OutputStream out = new FileOutputStream("out.bin")) {
	out.write(new byte[] {1, 2, 3, 4});
	out.flush();
}
```

<a id="3443-reader-e-writer"></a>
### 34.4.3 Reader e Writer

`Reader` e `Writer` sono le controparti `orientate ai caratteri` di InputStream e OutputStream.

Operano su caratteri Unicode a 16 bit invece di byte grezzi.

| Classe | Direzione | Basata su caratteri | Consapevole dell’encoding |
|-------|-----------|---------------------|----------------------------|
| `Reader` | Input | Sì | Sì |
| `Writer` | Output | Sì | Sì |

Reader e Writer implicano sempre un `charset`, esplicitamente o implicitamente.

Questo li rende l’astrazione corretta per l’elaborazione di testo.

<a id="34431-gestione-del-charset"></a>
#### 34.4.3.1 Gestione del charset

```java
Reader reader = new InputStreamReader(
	new FileInputStream("file.txt"),
	StandardCharsets.UTF_8
);
```

!!! note
    `InputStreamReader` e `OutputStreamWriter` sono classi ponte.
    
    Convertono tra `stream di byte` e `stream di caratteri` usando un `charset`.

---

<a id="345-stream-bufferizzati-e-prestazioni"></a>
## 34.5 Stream bufferizzati e prestazioni

Gli `stream bufferizzati` avvolgono un altro stream e aggiungono un buffer in memoria.

Invece di interagire con il sistema operativo a ogni read o write, i dati vengono accumulati in memoria e trasferiti in blocchi più grandi.

- `BufferedInputStream` / `BufferedOutputStream` per stream di byte
- `BufferedReader` / `BufferedWriter` per stream di caratteri

!!! note
    Gli `stream bufferizzati` sono `decorator`: non sostituiscono lo stream sottostante, lo migliorano aggiungendo comportamento di buffering.

<a id="3451-perché-il-buffering-conta"></a>
### 34.5.1 Perché il buffering conta

| Aspetto | Non bufferizzato | Bufferizzato |
|--------|------------|----------|
| `System calls` | Frequenti | Ridotte |
| `Prestazioni` | Scarse | Alte |
| `Uso memoria` | Minimo | Leggermente più alto |

Le system call sono operazioni costose.

Il buffering le minimizza raggruppando più letture o scritture logiche in meno operazioni I/O fisiche.

<a id="3452-come-funziona-la-lettura-non-bufferizzata"></a>
### 34.5.2 Come funziona la lettura non bufferizzata

In uno stream non bufferizzato, ogni chiamata a read() può risultare in una system call nativa.

Questo è particolarmente inefficiente quando si leggono grandi quantità di dati.

```java
try (InputStream in = new FileInputStream("data.bin")) {
	int b;
	while ((b = in.read()) != -1) {
		// ogni read() può innescare una system call
	}
}
```

!!! note
    Leggere byte-per-byte senza buffering è quasi sempre un anti-pattern di prestazioni.

<a id="3453-come-funziona-bufferedinputstream"></a>
### 34.5.3 Come funziona BufferedInputStream

`BufferedInputStream` internamente legge un grande blocco di byte in un buffer.

Le successive chiamate `read()` sono servite direttamente dalla memoria finché il buffer non è vuoto.

```java
try (InputStream in =
	new BufferedInputStream(new FileInputStream("data.bin"))) {
		int b;
		while ((b = in.read()) != -1) {
			// la maggior parte delle letture è servita dalla memoria, non dall’OS
		}
}
```

!!! note
    Il programma chiama ancora `read()` ripetutamente, ma il sistema operativo viene invocato solo quando il buffer interno deve essere riempito di nuovo.

<a id="3454-esempio-di-output-bufferizzato"></a>
### 34.5.4 Esempio di output bufferizzato

L’output bufferizzato accumula dati in memoria e li scrive in blocchi più grandi.

L’operazione `flush()` forza la scrittura immediata del buffer.

```java
try (OutputStream out =
	new BufferedOutputStream(new FileOutputStream("out.bin"))) {
		for (int i = 0; i < 1_000; i++) {
			out.write(i);
		}
		out.flush(); // forza i dati bufferizzati su disco
}
```

!!! note
    `close()` chiama automaticamente flush().
    
    Chiamare `flush()` esplicitamente è utile quando i dati devono essere visibili immediatamente.

<a id="3455-bufferedreader-vs-reader"></a>
### 34.5.5 BufferedReader vs Reader

`BufferedReader` aggiunge una `**lettura basata su linee**` efficiente sopra un Reader.

Senza buffering, ogni carattere letto può coinvolgere una system call.

```java
try (BufferedReader reader =
	new BufferedReader(new FileReader("file.txt"))) {

		String line;
		while ((line = reader.readLine()) != null) {
			System.out.println(line);
		}
}
```

!!! note
    Il metodo `readLine()` è disponibile solo su `BufferedReader` (non su `Reader`), perché si basa sul buffering per rilevare efficientemente i confini di riga.

<a id="3456-esempio-di-bufferedwriter"></a>
### 34.5.6 Esempio di BufferedWriter

```java
try (BufferedWriter writer =
	new BufferedWriter(new FileWriter("file.txt"))) {

		writer.write("Hello");
		writer.newLine();
		writer.write("World");
}
```

`BufferedWriter` minimizza l’accesso al disco e fornisce metodi di convenienza come `newLine()`.

!!! note
    Avvolgi sempre gli stream di file con buffering a meno che non ci sia una forte ragione per non farlo
    
    Preferisci BufferedReader / BufferedWriter per testo
    
    Preferisci BufferedInputStream / BufferedOutputStream per dati binari

---

<a id="346-javaio-vs-javanio-e-javaniofile"></a>
## 34.6 java.io vs java.nio (e java.nio.file)

Le applicazioni Java moderne favoriscono sempre più le API NIO e NIO.2, ma java.io rimane fondamentale e ampiamente usato.

<a id="3461-differenze-concettuali"></a>
### 34.6.1 Differenze concettuali

| Aspetto | java.io | java.nio / nio.2 |
|--------|---------|------------------|
| `Modello di programmazione` | Basato su stream | Basato su buffer / channel |
| `I/O bloccante` | Bloccante per default | Capace di non-bloccante |
| `File API` | File | Path + Files |
| `Scalabilità` | Limitata | Alta |
| `Introdotto` | Java 1.0 | Java 4 / Java 7 |

!!! note
    `java.nio` non sostituisce `java.io`.
    
    Molte classi NIO internamente si basano su stream o coesistono con essi.

<a id="3462-javanio-io-file-moderno"></a>
### 34.6.2 java.nio (I/O file moderno)

Il package `java.nio.file` (NIO.2) fornisce una file API di alto livello, espressiva e più sicura.
È l’approccio preferito per operazioni su file in Java 11+.

Esempio: leggere un file (NIO)

```java
Path path = Path.of("file.txt");
List<String> lines = Files.readAllLines(path);
```

Codice java.io equivalente

```java
try (BufferedReader reader = new BufferedReader(new FileReader("file.txt"))) {
	String line;
	while ((line = reader.readLine()) != null) {
		System.out.println(line);
	}
}
```

---

<a id="347-quando-usare-quale-api"></a>
## 34.7 Quando usare quale API

| Scenario | API raccomandata |
|----------|------------------|
| `Lettura/scrittura file semplice` | java.nio.file.Files |
| `Streaming binario` | InputStream / OutputStream |
| `Elaborazione testo a caratteri` | Reader / Writer |
| `Server ad alte prestazioni` | java.nio.channels |
| `API legacy` | java.io |

---

<a id="348-trappole-comuni-e-suggerimenti"></a>
## 34.8 Trappole comuni e suggerimenti

- End-of-file è indicato da -1, non da un’eccezione
- Chiudere uno stream wrapper chiude automaticamente lo stream avvolto
- `BufferedReader.readLine()` rimuove i separatori di linea
- `InputStreamReader` coinvolge sempre un charset
- I metodi utility Files lanciano IOException checked
- `available()` non deve essere usato per rilevare EOF

!!! note
    La maggior parte dei bug I/O deriva da assunzioni errate su blocking, buffering o character encoding.
