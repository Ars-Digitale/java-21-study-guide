# 35. API di I/O Java (Legacy e NIO)

<a id="indice"></a>
### Indice

- [35. API di I/O Java (Legacy e NIO)](#35-api-di-io-java-legacy-e-nio)
  - [35.1 Legacy java.io — Design, comportamento e sottigliezze](#351-legacy-javaio--design-comportamento-e-sottigliezze)
    - [35.1.1 L’astrazione di stream](#3511-lastrazione-di-stream)
    - [35.1.2 Chaining degli stream e pattern Decorator](#3512-chaining-degli-stream-e-pattern-decorator)
    - [35.1.3 I/O bloccante: cosa significa](#3513-io-bloccante-cosa-significa)
    - [35.1.4 Gestione risorse: close(), flush() e perché esistono](#3514-gestione-risorse-close-flush-e-perché-esistono)
    - [35.1.5 finalize(): perché esiste e perché fallisce](#3515-finalize-perché-esiste-e-perché-fallisce)
    - [35.1.6 available(): scopo e abuso](#3516-available-scopo-e-abuso)
    - [35.1.7 mark() e reset(): backtracking controllato](#3517-mark-e-reset-backtracking-controllato)
    - [35.1.8 Reader, Writer e codifica dei caratteri](#3518-reader-writer-e-codifica-dei-caratteri)
    - [35.1.9 File vs FileDescriptor](#3519-file-vs-filedescriptor)
  - [35.2 java.nio — Buffer, Channel e I/O non bloccante](#352-javanio--buffer-channel-e-io-non-bloccante)
    - [35.2.1 Dagli stream ai buffer: un cambio concettuale](#3521-dagli-stream-ai-buffer-un-cambio-concettuale)
    - [35.2.2 Buffer: scopo e struttura](#3522-buffer-scopo-e-struttura)
    - [35.2.3 Ciclo di vita del buffer: Write → Flip → Read](#3523-ciclo-di-vita-del-buffer-write--flip--read)
    - [35.2.4 clear() vs compact()](#3524-clear-vs-compact)
    - [35.2.5 Heap buffers vs Direct buffers](#3525-heap-buffers-vs-direct-buffers)
    - [35.2.6 Channel: cosa sono](#3526-channel-cosa-sono)
    - [35.2.7 Channel bloccanti vs non bloccanti](#3527-channel-bloccanti-vs-non-bloccanti)
    - [35.2.8 Scatter/Gather I/O](#3528-scattergather-io)
    - [35.2.9 Selector: multiplexing dell’I/O non bloccante](#3529-selector-multiplexing-dellio-non-bloccante)
    - [35.2.10 Quando usare java.nio](#35210-quando-usare-javanio)
  - [35.3 java.nio.file (NIO.2) — Operazioni su file e directory (Legacy vs Modern)](#353-javaniofile-nio2--operazioni-su-file-e-directory-legacy-vs-modern)
    - [35.3.1 Verifiche di esistenza e accessibilità](#3531-verifiche-di-esistenza-e-accessibilità)
    - [35.3.2 Creazione di file e directory](#3532-creazione-di-file-e-directory)
    - [35.3.3 Eliminazione di file e directory](#3533-eliminazione-di-file-e-directory)
    - [35.3.4 Copia di file e directory](#3534-copia-di-file-e-directory)
    - [35.3.5 Spostamento e rinomina](#3535-spostamento-e-rinomina)
    - [35.3.6 Lettura e scrittura di testo e byte (miglioramenti di Files)](#3536-lettura-e-scrittura-di-testo-e-byte-miglioramenti-di-files)
    - [35.3.7 newInputStream/newOutputStream e newBufferedReader/newBufferedWriter](#3537-newinputstreamnewoutputstream-e-newbufferedreadernewbufferedwriter)
    - [35.3.8 Listing directory e attraversamento di alberi](#3538-listing-directory-e-attraversamento-di-alberi)
    - [35.3.9 Ricerca e filtro](#3539-ricerca-e-filtro)
    - [35.3.10 Attributi: lettura, scrittura e view](#35310-attributi-lettura-scrittura-e-view)
    - [35.3.11 Link simbolici e follow dei link](#35311-link-simbolici-e-follow-dei-link)
    - [35.3.12 Sintesi: perché Files è un miglioramento](#35312-sintesi-perché-files-è-un-miglioramento)
  - [35.4 Serializzazione — Object stream, compatibilità e trappole](#354-serializzazione--object-stream-compatibilità-e-trappole)
    - [35.4.1 Cosa fa la serializzazione (e cosa non fa)](#3541-cosa-fa-la-serializzazione-e-cosa-non-fa)
    - [35.4.2 Le due principali marker interface](#3542-le-due-principali-marker-interface)
    - [35.4.3 Esempio base: scrivere e leggere un oggetto](#3543-esempio-base-scrivere-e-leggere-un-oggetto)
    - [35.4.4 Grafi di oggetti, riferimenti e identità](#3544-grafi-di-oggetti-riferimenti-e-identità)
    - [35.4.5 serialVersionUID: la chiave di versioning](#3545-serialversionuid-la-chiave-di-versioning)
    - [35.4.6 Campi transient e static](#3546-campi-transient-e-static)
    - [35.4.7 Campi non serializzabili e NotSerializableException](#3547-campi-non-serializzabili-e-notserializableexception)
    - [35.4.8 Costruttori e serializzazione](#3548-costruttori-e-serializzazione)
    - [35.4.9 Hook di serializzazione custom: writeObject e readObject](#3549-hook-di-serializzazione-custom-writeobject-e-readobject)
    - [35.4.10 Esempio d’uso: ripristinare un campo derivato transient](#35410-esempio-duso-ripristinare-un-campo-derivato-transient)
    - [35.4.11 Externalizable: controllo totale (e responsabilità totale)](#35411-externalizable-controllo-totale-e-responsabilità-totale)
    - [35.4.12 Considerazioni di sicurezza su readObject()](#35412-considerazioni-di-sicurezza-su-readobject)
    - [35.4.13 Trappole comuni e consigli pratici](#35413-trappole-comuni-e-consigli-pratici)
    - [35.4.14 Quando usare (o evitare) la serializzazione Java](#35414-quando-usare-o-evitare-la-serializzazione-java)

---

<a id="351-legacy-javaio-design-comportamento-e-sottigliezze"></a>
## 35.1 Legacy java.io — Design, comportamento e sottigliezze

L’API legacy `java.io` è l’astrazione I/O originale introdotta in Java 1.0.

Essa è orientata agli stream, bloccante, e mappata strettamente sui concetti I/O del sistema operativo.

Anche se esistono API più recenti, `java.io` resta fondamentale: molte API di livello superiore ci si appoggiano, ed è ancora molto usata.

<a id="3511-lastrazione-di-stream"></a>
### 35.1.1 L’astrazione di stream

Uno `stream` rappresenta un flusso continuo di dati tra una sorgente e una destinazione.

In `java.io`, gli stream sono **unidirezionali**: sono o di **input** o di **output**.

| Stream          | Direzione | Unità di dati     | Categoria            |
|----------------|----------|-------------------|----------------------|
| `InputStream`  | Input     | Byte (8-bit)      | Stream di byte       |
| `OutputStream` | Output    | Byte (8-bit)      | Stream di byte       |
| `Reader`       | Input     | Caratteri         | Stream di caratteri  |
| `Writer`       | Output    | Caratteri         | Stream di caratteri  |

Gli `stream` nascondono l’origine concreta dei dati (file, rete, memoria) ed espongono un’interfaccia uniforme di lettura/scrittura.

<a id="3512-chaining-degli-stream-e-pattern-decorator"></a>
### 35.1.2 Chaining degli stream e pattern Decorator

La maggior parte degli stream java.io è progettata per essere combinata.

Ogni wrapper aggiunge comportamento senza cambiare la sorgente dati sottostante.

```java
InputStream in =
	new BufferedInputStream(
		new FileInputStream("data.bin"));
```

In questo esempio:
- `FileInputStream` esegue l’accesso reale al file
- `BufferedInputStream` aggiunge un buffer in memoria

!!! note
    Questo design è noto come **Decorator Pattern**.
    
    Permette di stratificare funzionalità in modo dinamico.

<a id="3513-io-bloccante-cosa-significa"></a>
### 35.1.3 I/O bloccante: cosa significa

Tutti gli stream legacy `java.io` sono **bloccanti**.

Ciò significa che un thread che esegue I/O può essere sospeso dal sistema operativo.

Per esempio, quando chiami `read()`:
- se i dati sono disponibili, vengono restituiti subito
- se non ci sono dati, il thread attende
- se si raggiunge la fine dello stream, viene restituito -1

!!! note
    Il comportamento bloccante semplifica la programmazione, ma limita la scalabilità.

<a id="3514-gestione-risorse-close-flush-e-perché-esistono"></a>
### 35.1.4 Gestione risorse: `close()`, `flush()` e perché esistono

Gli stream spesso incapsulano risorse native del sistema operativo
come `file descriptor` o handle di socket.

Queste risorse sono limitate e devono essere rilasciate esplicitamente.

| Metodo | Scopo |
| --- | --- |
| `flush()` | Scrive i dati bufferizzati verso la destinazione |
| `close()` | Esegue flush e rilascia la risorsa |

```java
try (OutputStream out = new FileOutputStream("file.bin")) {
	out.write(42);
} // close() chiamato automaticamente
```

!!! note
    Non chiudere gli stream può causare perdita di dati o esaurimento delle risorse.

<a id="3515-finalize-perché-esiste-e-perché-fallisce"></a>
### 35.1.5 `finalize()`: perché esiste e perché fallisce

Le prime versioni di Java tentarono di automatizzare il cleanup delle risorse usando la finalizzazione.

Il metodo `finalize()` veniva chiamato dal garbage collector prima di recuperare la memoria.

Tuttavia, i tempi del GC sono imprevedibili.

| Aspetto         | finalize()      |
|----------------|-----------------|
| Tempo di esecuzione | Non specificato |
| Affidabilità    | Bassa           |
| Stato attuale   | Deprecato       |

!!! note
    `finalize()` non va mai usato per pulizia I/O; è deprecato e non sicuro.

<a id="3516-available-scopo-e-abuso"></a>
### 35.1.6 `available()`: scopo e abuso

`available()` stima quanti byte possono essere letti senza bloccare.

Non indica la quantità totale di dati rimanenti.

Casi d’uso tipici:
- evitare blocchi in UI o parsing di protocolli
- dimensionare buffer temporanei

```java
if (in.available() > 0) {
	in.read(buffer);
}
```

!!! note
    `available()` non deve essere usato per rilevare EOF.
    Solo `read()`, che ritorna -1, segnala la fine dello stream.

<a id="3517-mark-e-reset-backtracking-controllato"></a>
### 35.1.7 `mark()` e `reset()`: backtracking controllato

Alcuni input stream consentono di marcare una posizione
e tornarci in seguito.

```java
BufferedInputStream in = new BufferedInputStream(...);
in.mark(1024);
// read ahead
in.reset();
```

| Stream | markSupported() |
| --- | --- |
| `FileInputStream` | No |
| `BufferedInputStream` | Sì |
| `ByteArrayInputStream` | Sì |

<a id="3518-reader-writer-e-codifica-dei-caratteri"></a>
### 35.1.8 Reader, Writer e codifica dei caratteri

`Reader` e `Writer` operano su `caratteri`, non su byte.

Questo richiede una `codifica dei caratteri` (charset).

Se non specifichi un charset, viene usato quello di default della piattaforma.

```java
new FileReader("file.txt"); // encoding di default della piattaforma
```

!!! note
    Affidarsi al charset di default porta a bug di non portabilità.
    
    Specifica sempre un charset esplicitamente.

<a id="3519-file-vs-filedescriptor"></a>
### 35.1.9 File vs FileDescriptor

`File` rappresenta un `percorso` nel filesystem.

Non rappresenta una risorsa aperta.

`FileDescriptor` rappresenta un handle nativo del SO verso un file o stream aperto.

| Classe            | Rappresenta             | Possiede handle OS? |
|------------------|--------------------------|---------------------|
| `File`           | Percorso filesystem       | No                  |
| `FileDescriptor` | Handle file nativo OS     | Sì                  |

!!! note
    Più stream possono condividere lo stesso FileDescriptor.
    
    Chiudendone uno, si chiude la risorsa sottostante per tutti.

---

<a id="352-javanio-buffer-channel-e-io-non-bloccante"></a>
## 35.2 `java.nio` — Buffer, Channel e I/O non bloccante

L’API `java.nio` (New I/O) è stata introdotta per risolvere i limiti di `java.io`.

Offre un modello I/O di più basso livello e più esplicito, che mappa bene sui sistemi operativi moderni.

Alla base, `java.nio` ruota attorno a tre concetti:
- `Buffer` — contenitori di memoria espliciti
- `Channel` — connessioni dati bidirezionali
- `Selector` — multiplexing dell’I/O non bloccante

<a id="3521-dagli-stream-ai-buffer-un-cambio-concettuale"></a>
### 35.2.1 Dagli stream ai buffer: un cambio concettuale

Gli stream legacy nascondono la gestione della memoria al programmatore.

Al contrario, `NIO` rende esplicita la memoria tramite i buffer.

| Aspetto       | java.io                    | java.nio                                  |
|--------------|----------------------------|-------------------------------------------|
| Modello dati | Basato su stream (push)     | Basato su buffer (pull dai buffer)        |
| Memoria      | Nascosta negli stream       | Esplicita via buffer                      |
| Controllo    | Semplice, poco granulare    | Più granulare e configurabile             |

Con NIO, l’applicazione controlla quando i dati vengono letti in memoria e come vengono consumati.

<a id="3522-buffer-scopo-e-struttura"></a>
### 35.2.2 Buffer: scopo e struttura

Un `buffer` è un contenitore tipizzato a dimensione fissa.

Tutte le operazioni I/O NIO leggono da o scrivono su buffer.

Il buffer più comune è `ByteBuffer`.

```java
ByteBuffer buffer = ByteBuffer.allocate(1024);
```

| Proprietà | Significato |
| --- | --- |
| `capacity` | Dimensione totale del buffer |
| `position` | Indice corrente di lettura/scrittura |
| `limit` | Limite dei dati leggibili o scrivibili |

<a id="3523-ciclo-di-vita-del-buffer-write-flip-read"></a>
### 35.2.3 Ciclo di vita del buffer: Write → Flip → Read

I `buffer` hanno un ciclo d’uso rigoroso.

Capirlo male è una fonte comune di bug.

Sequenza tipica:
- scrivi i dati nel buffer
- `flip()` per passare in modalità lettura
- leggi i dati dal buffer
- `clear()` o `compact()` per riutilizzarlo

```java
ByteBuffer buffer = ByteBuffer.allocate(16);

buffer.put((byte) 1);
buffer.put((byte) 2);

buffer.flip(); // passa in modalità lettura

while (buffer.hasRemaining()) {
	byte b = buffer.get();
}

buffer.clear(); // pronto a scrivere di nuovo
```

!!! note
    `flip()` non cancella i dati: regola position e limit.

<a id="3524-clear-vs-compact"></a>
### 35.2.4 `clear()` vs `compact()`

Dopo la lettura, un buffer può essere riutilizzato in due modi.

| Metodo | Comportamento |
| --- | --- |
| `clear()` | Scarta i dati non letti |
| `compact()` | Preserva i dati non letti |

`compact()` è utile nei protocolli streaming dove nel buffer possono restare messaggi parziali.

<a id="3525-heap-buffers-vs-direct-buffers"></a>
### 35.2.5 Heap buffers vs Direct buffers

I buffer possono essere allocati in due regioni di memoria diverse.

```java
ByteBuffer heap = ByteBuffer.allocate(1024);
ByteBuffer direct = ByteBuffer.allocateDirect(1024);
```

| Tipo       | Posizione memoria | Caratteristiche |
|------------|-------------------|-----------------|
| `Heap`     | Heap JVM          | GC, economico da allocare |
| `Direct`   | Memoria nativa    | Miglior throughput I/O, più costoso da allocare |

!!! note
    I direct buffer riducono le copie tra JVM e OS, ma vanno usati con attenzione per evitare pressione di memoria.

<a id="3526-channel-cosa-sono"></a>
### 35.2.6 Channel: cosa sono

Un `channel` rappresenta una connessione verso un’entità I/O
come file, socket o device.

A differenza degli stream, **i channel sono bidirezionali**.

| Channel            | Tipo | Scopo                      |
|-------------------|------|----------------------------|
| `FileChannel`     | File | I/O su file                |
| `SocketChannel`   | TCP  | Networking stream (TCP)    |
| `DatagramChannel` | UDP  | Networking datagram (UDP)  |

```java
try (FileChannel channel =
	FileChannel.open(Path.of("file.txt"))) {

	ByteBuffer buffer = ByteBuffer.allocate(128);
	channel.read(buffer);
}
```

<a id="3527-channel-bloccanti-vs-non-bloccanti"></a>
### 35.2.7 Channel bloccanti vs non bloccanti

I channel possono operare in modalità bloccante o non bloccante.

```java
SocketChannel channel = SocketChannel.open();
channel.configureBlocking(false);
```

In modalità **non bloccante**:
- `read()` può ritornare subito con 0 byte
- `write()` può scrivere solo una parte dei dati

!!! note
    L’I/O non bloccante sposta complessità dal SO all’applicazione.

<a id="3528-scattergather-io"></a>
### 35.2.8 Scatter/Gather I/O

NIO supporta lettura/scrittura da/verso più buffer con una singola operazione.

```java
ByteBuffer header = ByteBuffer.allocate(128);
ByteBuffer body = ByteBuffer.allocate(1024);

ByteBuffer[] buffers = { header, body };
channel.read(buffers);
```

Utile per protocolli strutturati (header + payload).

<a id="3529-selector-multiplexing-dellio-non-bloccante"></a>
### 35.2.9 Selector: multiplexing dell’I/O non bloccante

I `Selector` permettono a un singolo thread di monitorare più channel.

Sono la base dei server scalabili.

| Componente      | Ruolo |
|----------------|------|
| `Selector`      | Monitora più channel |
| `SelectionKey`  | Rappresenta registrazione e stato del channel |
| `Interest set`  | Operazioni osservate (read, write, ecc.) |

<a id="35210-quando-usare-javanio"></a>
### 35.2.10 Quando usare `java.nio`

`NIO` è adatto quando:
- serve alta concorrenza
- ti serve controllo fine sulla memoria
- stai implementando protocolli o server

Per operazioni semplici su file, spesso basta `java.nio.file.Files`.

---

<a id="353-javaniofile-nio2-operazioni-su-file-e-directory-legacy-vs-modern"></a>
## 35.3 `java.nio.file` (NIO.2) — Operazioni su file e directory (Legacy vs Modern)

Questa sezione si concentra sulle operazioni pratiche su file e directory.

Confrontiamo gli approcci legacy (java.io.File + stream java.io) con quelli moderni NIO.2 (Path + Files).

L’obiettivo non è solo conoscere i nomi dei metodi, ma capire:
- cosa fa davvero ogni metodo
- cosa ritorna e come segnala gli errori
- quali trappole esistono (race condition, link, permessi, portabilità)
- quando un metodo di Files è un miglioramento sicuro rispetto al vecchio approccio

<a id="3531-verifiche-di-esistenza-e-accessibilità"></a>
### 35.3.1 Verifiche di esistenza e accessibilità

Un’operazione molto comune è verificare se un file esiste e se è accessibile (lettura, scrittura, esecuzione).

Sia l’API legacy (java.io.File) che NIO.2 (java.nio.file.Files) forniscono metodi per queste verifiche.

È però importante capire che queste verifiche sono volutamente imprecise in entrambe le API.

Sono indizi best-effort, non garanzie affidabili.

<a id="35311-api-legacy-file"></a>
#### 35.3.1.1 API legacy (File)

```java
File f = new File("data.txt");

boolean exists = f.exists();
boolean canRead = f.canRead();
boolean canWrite = f.canWrite();
boolean canExec = f.canExecute();
```

Questi metodi ritornano boolean e non spiegano perché un’operazione è fallita.

Per esempio, exists() può ritornare false quando:
- il file non esiste davvero
- il file esiste ma l’accesso è negato
- un link simbolico è rotto
- si verifica un errore I/O

L’API non consente di distinguere i casi.

<a id="35312-api-moderna-files"></a>
#### 35.3.1.2 API moderna (Files)

```java
Path p = Path.of("data.txt");

boolean exists = Files.exists(p);
boolean readable = Files.isReadable(p);
boolean writable = Files.isWritable(p);
boolean executable = Files.isExecutable(p);
```

Anche questi metodi ritornano boolean e nascondono la ragione dell'eventuale insuccesso.

NIO.2 aggiunge un metodo esplicito per esprimere incertezza:

```java
boolean notExists = Files.notExists(p);
```

!!! note
    `exists()` e `notExists()` possono essere entrambi `false` quando lo stato non è determinabile (per esempio per permessi).

Questo non rende la verifica più accurata: rende solo l’incertezza esplicita.

<a id="353121-consapevolezza-dei-link-simbolici-miglioramento-reale"></a>
##### 35.3.1.2.1 Consapevolezza dei link simbolici (miglioramento reale)

Un vero miglioramento di NIO.2 è il controllo su come gestire i link simbolici:

```java
Files.exists(p, LinkOption.NOFOLLOW_LINKS);
```

La classe File legacy non distingue in modo affidabile:
- file mancante
- link simbolico rotto
- link verso target inaccessibile

NIO.2 permette check link-aware e ispezione esplicita dei link.

<a id="353122-pattern-duso-corretto-critico"></a>
##### 35.3.1.2.2 Pattern d’uso corretto (critico)

Nessuna delle due API dà diagnosi affidabili tramite boolean “di check”.

Il codice NIO.2 corretto non “controlla prima”.

Invece tenta l’operazione e gestisce l’eccezione:

```java
try {
    Files.delete(p);
} catch (NoSuchFileException e) {
    // il file non esiste davvero
} catch (AccessDeniedException e) {
    // problema di permessi
} catch (IOException e) {
    // altro errore I/O
}
```

!!! note
    Il vero vantaggio di NIO.2 è la diagnostica tramite eccezioni durante le azioni, non check di esistenza più “accurati”.

<a id="353123-tabella-riassuntiva"></a>
##### 35.3.1.2.3 Tabella riassuntiva

| Obiettivo            | Legacy (File)                  | Moderno (Files)                        | Dettaglio chiave |
|---------------------|--------------------------------|----------------------------------------|------------------|
| Verificare esistenza | `exists()`                     | `exists() / notExists()`               | notExists() può essere false se lo stato non è determinabile |
| Verificare read/write| `canRead() / canWrite()`       | `isReadable() / isWritable()`          | Files può usare LinkOption.NOFOLLOW_LINKS quando supportato |
| Dettagli errore      | Non disponibili                | Disponibili via eccezioni sulle azioni | I check boolean non spiegano il motivo del fallimento |


<a id="3532-creazione-di-file-e-directory"></a>
### 35.3.2 Creazione di file e directory

La creazione è una grande debolezza del File legacy.

Nel legacy si usano spesso createNewFile() e mkdir/mkdirs(), che ritornano boolean e danno poche info diagnostiche.

<a id="35321-api-legacy-file"></a>
#### 35.3.2.1 API legacy (File)

```java
File f = new File("a.txt");
boolean created = f.createNewFile(); // può lanciare IOException

File dir = new File("dir");
boolean ok1 = dir.mkdir();
boolean ok2 = new File("a/b/c").mkdirs();
```

`mkdir()` crea un solo livello; `mkdirs()` crea anche i parent.

Entrambi ritornano false in caso di fallimento ma senza dire il perché.

<a id="35322-api-moderna-files"></a>
#### 35.3.2.2 API moderna (Files)

```java
Path file = Path.of("a.txt");
Files.createFile(file);

Path dir1 = Path.of("dir");
Files.createDirectory(dir1);

Path dirDeep = Path.of("a/b/c");
Files.createDirectories(dirDeep);
```

!!! note
    `Files.createFile` lancia `FileAlreadyExistsException` se il file esiste.
    
    Spesso è preferibile ai check boolean perché è race-safe.

| Obiettivo         | Legacy (File)         | Moderno (Files)               | Dettaglio chiave |
|------------------|------------------------|-------------------------------|------------------|
| Creare file      | `createNewFile()`      | `createFile()`                | NIO lancia FileAlreadyExistsException se esiste |
| Creare directory | `mkdir()`              | `createDirectory()`           | NIO lancia eccezioni dettagliate |
| Creare parent    | `mkdirs()`             | `createDirectories()`         | Atomicità non garantita per directory profonde |

<a id="3533-eliminazione-di-file-e-directory"></a>
### 35.3.3 Eliminazione di file e directory

La semantica di delete differisce molto tra legacy e NIO.2.

Il legacy `delete()` ritorna boolean; NIO.2 offre metodi che lanciano eccezioni significative.

<a id="35331-api-legacy-file"></a>
#### 35.3.3.1 API legacy (File)

```java
File f = new File("a.txt");
boolean deleted = f.delete();
```

Se fallisce (permessi, file mancante, directory non vuota), `delete()` spesso ritorna false senza dettagli.

<a id="35332-api-moderna-files"></a>
#### 35.3.3.2 API moderna (Files)

```java
Files.delete(Path.of("a.txt"));
```

Per “cancella se presente”, usa `deleteIfExists()`.

```java
Files.deleteIfExists(Path.of("a.txt"));
```

| Obiettivo          | Legacy (File)            | Moderno (Files)         | Dettaglio chiave |
|-------------------|---------------------------|--------------------------|------------------|
| Eliminare          | `delete()`                | `delete()`               | `Files.delete()` lancia eccezione con la causa del fallimento |
| Eliminare se esiste| `exists() + delete()`     | `deleteIfExists()`       | Evita race TOCTOU (check-then-act) |

<a id="3534-copia-di-file-e-directory"></a>
### 35.3.4 Copia di file e directory

Nel legacy, copiare richiede tipicamente lettura/scrittura manuale via stream.

NIO.2 fornisce operazioni di copia di alto livello con opzioni.

<a id="35341-tecnica-legacy-stream-manuali"></a>
#### 35.3.4.1 Tecnica legacy (stream manuali)

```java
try (InputStream in = new FileInputStream("src.bin"); OutputStream out = new FileOutputStream("dst.bin")) {

	byte[] buf = new byte[8192];
	int n;
	while ((n = in.read(buf)) != -1) {
		out.write(buf, 0, n);
	}
}
```

È verboso ed è facile sbagliare (mancanza di buffering, chiusura, ecc.).

<a id="35342-api-moderna-filescopy"></a>
#### 35.3.4.2 API moderna (Files.copy)

```java
Files.copy(Path.of("src.bin"), Path.of("dst.bin"));
```

Il comportamento è controllabile con opzioni.

```java
Files.copy(
	Path.of("src.bin"),
	Path.of("dst.bin"),
	StandardCopyOption.REPLACE_EXISTING,
	StandardCopyOption.COPY_ATTRIBUTES
);
```

!!! note
    `Files.copy` lancia FileAlreadyExistsException per default.
    
    Usa `REPLACE_EXISTING` quando l’overwrite è intenzionale.

| Obiettivo         | Approccio legacy        | Moderno (Files)                          | Dettaglio chiave |
|------------------|--------------------------|------------------------------------------|------------------|
| Copiare file     | Loop stream manuale      | `Files.copy(Path, Path, …)`              | Opzioni: `REPLACE_EXISTING`, `COPY_ATTRIBUTES` |
| Copiare stream   | InputStream/OutputStream | `Files.copy(InputStream, Path, …)`       | Utile per upload/download e piping |
| Copiare directory| Ricorsione manuale       | `walkFileTree + Files.copy`              | Nessun one-liner per copy completa di albero |

<a id="3535-spostamento-e-rinomina"></a>
### 35.3.5 Spostamento e rinomina

La rinomina legacy usa spesso `File.renameTo()`, notoriamente inaffidabile e dipendente dalla piattaforma.

NIO.2 fornisce `Files.move()` con semantica precisa e opzioni.

<a id="35351-api-legacy"></a>
#### 35.3.5.1 API legacy

```java
boolean ok = new File("a.txt").renameTo(new File("b.txt"));
```

`renameTo()` ritorna false senza spiegare, e può fallire tra filesystem.

<a id="35352-api-moderna"></a>
#### 35.3.5.2 API moderna

```java
Files.move(Path.of("a.txt"), Path.of("b.txt"));
```

Le opzioni rendono il comportamento esplicito.

```java
Files.move(
	Path.of("a.txt"),
	Path.of("b.txt"),
	StandardCopyOption.REPLACE_EXISTING,
	StandardCopyOption.ATOMIC_MOVE
);
```

!!! note
    ATOMIC_MOVE è garantito solo se lo spostamento avviene nello stesso filesystem.
    Altrimenti viene lanciata un’eccezione.

| Obiettivo        | Legacy (File)  | Moderno (Files)             | Dettaglio chiave |
|-----------------|-----------------|-----------------------------|------------------|
| Rinomina / move | `renameTo()`    | `move()`                    | Exceptions + opzioni esplicite |
| Move atomico    | Non supportato  | `move(…, ATOMIC_MOVE)`      | Garantito solo stesso filesystem |
| Replace existing| Non esplicito   | `REPLACE_EXISTING`          | Intenzione di overwrite esplicita |

<a id="3536-lettura-e-scrittura-di-testo-e-byte-miglioramenti-di-files"></a>
### 35.3.6 Lettura e scrittura di testo e byte (miglioramenti di Files)

Un grande miglioramento di NIO.2 è la classe utility `Files`, con metodi di alto livello per lettura/scrittura comuni.

Riduce boilerplate e migliora la correttezza.

<a id="35361-letturascrittura-testo-legacy"></a>
#### 35.3.6.1 Lettura/scrittura testo legacy

```java
try (BufferedReader r = new BufferedReader(new FileReader("file.txt"))) {
	String line = r.readLine();
}
```

```java
try (BufferedWriter w = new BufferedWriter(new FileWriter("file.txt"))) {
	w.write("hello");
}
```

Queste classi legacy usano spesso il charset di default se non si utilizza un bridge esplicito.

<a id="35362-letturascrittura-testo-moderna"></a>
#### 35.3.6.2 Lettura/scrittura testo moderna

```java
List<String> lines = Files.readAllLines(Path.of("file.txt"), StandardCharsets.UTF_8);
Files.write(Path.of("file.txt"), lines, StandardCharsets.UTF_8);

Files.lines(Path.of("file.txt")).forEach(System.out::println);

String string = Files.readString(Path.of("file.txt"));
Files.writeString(Path.of("file.txt"), string);
```

<a id="35363-letturascrittura-binaria-moderna"></a>
#### 35.3.6.3 Lettura/scrittura binaria moderna

```java
byte[] data = Files.readAllBytes(Path.of("data.bin"));
Files.write(Path.of("out.bin"), data);
```

!!! important
    `readAllBytes` e `readAllLines` caricano tutto in memoria.
    
    Usa `Files.lines()` (lazy) o, per file grandi, preferisci API streaming come newBufferedReader/newInputStream.

| Task            | Metodo legacy                    | Metodo NIO.2 Files                    | Dettaglio chiave |
|-----------------|----------------------------------|----------------------------------------|------------------|
| Leggere tutti i byte | Loop InputStream manuale     | `readAllBytes()`                       | Carica tutto in memoria |
| Leggere tutte le righe | Loop BufferedReader        | `readAllLines()`                       | Carica tutto in memoria |
| Leggere righe lazy | Loop BufferedReader           | `lines()`                               | Lazy, stream da chiudere |
| Scrivere byte   | OutputStream                      | `write(Path, byte[])`                  | Conciso |
| Scrivere righe  | Loop BufferedWriter               | `write(Path, Iterable, …)`             | Charset specificabile |
| Append testo    | FileWriter(true)                  | `write(…, APPEND)`                     | Opzioni esplicite |

<a id="3537-newinputstreamnewoutputstream-e-newbufferedreadernewbufferedwriter"></a>
### 35.3.7 newInputStream/newOutputStream e newBufferedReader/newBufferedWriter

Queste `factory method` creano stream/reader a partire da un Path.

Sono il bridge consigliato tra streaming classico e gestione Path NIO.2.

```java
try (InputStream in = Files.newInputStream(Path.of("a.bin"))) { }
try (OutputStream out = Files.newOutputStream(Path.of("b.bin"))) { }
```

```java
try (BufferedReader r = Files.newBufferedReader(Path.of("t.txt"), StandardCharsets.UTF_8)) { }
try (BufferedWriter w = Files.newBufferedWriter(Path.of("t.txt"), StandardCharsets.UTF_8)) { }
```

<a id="3538-listing-directory-e-attraversamento-di-alberi"></a>
### 35.3.8 Listing directory e attraversamento di alberi

Nel legacy, il listing directory si basa su `File.list()` e `File.listFiles()`.

Questi metodi ritornano array e offrono poca diagnostica.

<a id="35381-listing-legacy"></a>
#### 35.3.8.1 Listing legacy

```java
File dir = new File(".");
File[] children = dir.listFiles();
```

NIO.2 offre più approcci a seconda del bisogno.

<a id="35382-listing-moderno-directorystream"></a>
#### 35.3.8.2 Listing moderno (DirectoryStream)

```java
try (DirectoryStream<Path> ds = Files.newDirectoryStream(Path.of("."))) {
	for (Path p : ds) {
		System.out.println(p);
	}
}
```

<a id="35383-walking-moderno-fileswalk"></a>
#### 35.3.8.3 Walking moderno (Files.walk)

```java
Files.walk(Path.of("."))
	.filter(Files::isRegularFile)
	.forEach(System.out::println);
```

!!! note
    `Files.walk` restituisce uno Stream che va chiuso.
    Usa `try-with-resources`.

```java
try (Stream<Path> s = Files.walk(Path.of("."))) {
	s.forEach(System.out::println);
}
```

<a id="35384-traversal-con-filevisitor"></a>
#### 35.3.8.4 Traversal con FileVisitor

Per controllo completo (skip subtree, gestione errori, follow link), usa `walkFileTree + FileVisitor`.

```java
Files.walkFileTree(Path.of("."), new SimpleFileVisitor<>() {
	@Override
	public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) {
		System.out.println(file);
		return FileVisitResult.CONTINUE;
	}
});
```

| Obiettivo     | Legacy                 | Moderno                         | Dettaglio chiave |
|--------------|------------------------|----------------------------------|------------------|
| Listing dir  | `list()` / `listFiles()` | `newDirectoryStream()`           | Lazy, va chiuso |
| Walk tree (semplice) | Ricorsione manuale | `walk()` (Stream)                | Stream va chiuso |
| Walk tree (controllo) | Ricorsione manuale | `walkFileTree()`                 | Controllo fine e gestione errori |

<a id="3539-ricerca-e-filtro"></a>
### 35.3.9 Ricerca e filtro

La ricerca è tipicamente `traversal + filtro`.

NIO.2 offre building block: glob pattern, stream, visitor.

```java
try (DirectoryStream<Path> ds =
	Files.newDirectoryStream(Path.of("."), "*.txt")) {
	for (Path p : ds) {
		System.out.println(p);
	}
}
```

```java
try (Stream<Path> s = Files.find(Path.of("."), 10,
	(p, a) -> a.isRegularFile() && p.toString().endsWith(".log"))) {
	s.forEach(System.out::println);
}
```

<a id="35310-attributi-lettura-scrittura-e-view"></a>
### 35.3.10 Attributi: lettura, scrittura e view

Il File legacy espone pochi attributi (size, lastModified).

NIO.2 supporta metadata ricchi tramite attribute view.

<a id="353101-attributi-legacy"></a>
#### 35.3.10.1 Attributi legacy

```java
long size = new File("a.txt").length();
long lm = new File("a.txt").lastModified();
```

<a id="353102-attributi-moderni"></a>
#### 35.3.10.2 Attributi moderni

```java
BasicFileAttributes a =
	Files.readAttributes(Path.of("a.txt"), BasicFileAttributes.class);

long size = a.size();
FileTime modified = a.lastModifiedTime();
```

Accesso tramite nomi string-based:

```java
Object v = Files.getAttribute(Path.of("a.txt"), "basic:size");
Files.setAttribute(Path.of("a.txt"), "basic:lastModifiedTime", FileTime.fromMillis(0));
```

!!! note
    Le attribute view dipendono dal filesystem.
    
    Attributi non supportati generano eccezioni.

<a id="35311-link-simbolici-e-follow-dei-link"></a>
### 35.3.11 Link simbolici e follow dei link

NIO.2 può rilevare e leggere link simbolici in modo esplicito.

```java
Path link = Path.of("mylink");
boolean isLink = Files.isSymbolicLink(link);

if (isLink) {
	Path target = Files.readSymbolicLink(link);
}
```

Molti metodi seguono i link di default.

Per evitarlo, passa `LinkOption.NOFOLLOW_LINKS` quando supportato.

<a id="35312-sintesi-perché-files-è-un-miglioramento"></a>
### 35.3.12 Sintesi: perché Files è un miglioramento

La classe utility `Files` migliora la programmazione filesystem perché:
- riduce boilerplate (copy/move/read/write)
- fornisce opzioni esplicite (overwrite, atomic move, follow links)
- offre metadata più ricchi (attributes/views)
- supporta traversal e ricerca scalabili

Le API legacy restano soprattutto per compatibilità o quando richieste da librerie legacy.

---

<a id="354-serializzazione-object-stream-compatibilità-e-trappole"></a>
## 35.4 Serializzazione — Object stream, compatibilità e trappole

La serializzazione è il processo di convertire un grafo di oggetti in uno stream di byte per memorizzarlo o trasmetterlo, e ricostruirlo successivamente.

In Java, la serializzazione classica è implementata da `java.io.ObjectOutputStream` e `java.io.ObjectInputStream`.

Questo argomento è importante perché combina:
- stream I/O e grafi di oggetti
- versioning e backward compatibility
- considerazioni di sicurezza e pattern d’uso sicuri
- regole del linguaggio (`transient`, static, `serialVersionUID`)

<a id="3541-cosa-fa-la-serializzazione-e-cosa-non-fa"></a>
### 35.4.1 Cosa fa la serializzazione (e cosa non fa)

Quando un oggetto è serializzato, Java scrive informazioni sufficienti a ricostruirlo:
- nome della classe
- serialVersionUID
- valori dei campi di istanza serializzabili
- riferimenti tra oggetti (identità)

La serializzazione non include automaticamente:
- campi static (stato di classe)
- campi transient (esclusi esplicitamente)
- oggetti referenziati non serializzabili (a meno di gestione speciale)

<a id="3542-le-due-principali-marker-interface"></a>
### 35.4.2 Le due principali marker interface

La serializzazione Java è abilitata implementando una di queste interfacce.

| Interfaccia       | Significato                                   | Livello di controllo |
|------------------|-----------------------------------------------|----------------------|
| `Serializable`   | Marker opt-in, meccanismo di default          | Medio (hook possibili) |
| `Externalizable` | Richiede implementazione manuale read/write   | Alto (controllo totale sul formato) |

!!! note
    `Serializable` non ha metodi: è una marker interface.
    
    `Externalizable` estende Serializable e aggiunge readExternal/writeExternal.

<a id="3543-esempio-base-scrivere-e-leggere-un-oggetto"></a>
### 35.4.3 Esempio base: scrivere e leggere un oggetto

Pattern minimo usato in pratica.

```java
import java.io.*;

class Person implements Serializable {

	private String name;
	private int age;

	Person(String name, int age) {
		this.name = name;
		this.age = age;
	}

}

public class Demo {

	public static void main(String[] args) throws Exception {

		Person p = new Person("Alice", 30);

		try (ObjectOutputStream out =
				 new ObjectOutputStream(new FileOutputStream("p.bin"))) {
			out.writeObject(p);
		}

		try (ObjectInputStream in =
				 new ObjectInputStream(new FileInputStream("p.bin"))) {
			Person copy = (Person) in.readObject();
		}
	}

}
```

!!! note
    `readObject()` ritorna Object: serve cast.
    `readObject()` può lanciare ClassNotFoundException.

<a id="3544-grafi-di-oggetti-riferimenti-e-identità"></a>
### 35.4.4 Grafi di oggetti, riferimenti e identità

La serializzazione preserva l’identità degli oggetti all’interno dello stesso stream.

Se lo stesso riferimento compare più volte, Java lo scrive una sola volta e poi scrive back-reference.

```java
Person p = new Person("Bob", 40);
Object[] arr = { p, p }; // stesso riferimento due volte

out.writeObject(arr);
Object[] restored = (Object[]) in.readObject();

// restored[0] e restored[1] puntano allo stesso oggetto
```

!!! note
    Questo previene ricorsione infinita in grafi ciclici.

<a id="3545-serialversionuid-la-chiave-di-versioning"></a>
### 35.4.5 `serialVersionUID`: la chiave di versioning

`serialVersionUID` è un identificatore `long` usato per verificare la compatibilità tra stream serializzato e definizione della classe.

Se l’UID differisce, la deserializzazione tipicamente fallisce con InvalidClassException.

Se non dichiari `serialVersionUID`, la JVM ne calcola uno dalla struttura della classe: piccole modifiche possono comprometterlo.

```java
class Person implements Serializable {

	private static final long serialVersionUID = 1L;

	private String name;
	private int age;
}
```

| Tipo di modifica | Impatto compatibilità (default) |
|---|---|
| Aggiungere un campo | Spesso compatibile (campo nuovo con default) |
| Rimuovere un campo | Spesso compatibile (campo mancante ignorato) |
| Cambiare tipo campo | Spesso incompatibile |
| Cambiare nome/pacchetto | Incompatibile |
| Cambiare serialVersionUID | Incompatibile |

!!! note
    Dichiarare un serialVersionUID stabile è il modo standard per controllare la compatibilità.

<a id="3546-campi-transient-e-static"></a>
### 35.4.6 Campi `transient` e `static`

I campi `transient` sono esclusi dalla serializzazione.

Alla deserializzazione, i campi transient assumono valori di default (0, false, null) salvo ripristino manuale.

I campi `static` appartengono alla classe, non all’istanza, quindi non vengono serializzati.

```java
class Session implements Serializable {

	private static final long serialVersionUID = 1L;

	static int counter = 0;      // non serializzato
	transient String token;      // non serializzato
	String user;                 // serializzato
}
```

!!! note
    Se un transient serve dopo la deserializzazione, va ricalcolato o ripristinato manualmente.

<a id="3547-campi-non-serializzabili-e-notserializableexception"></a>
### 35.4.7 Campi non serializzabili e NotSerializableException

Se un oggetto contiene un campo il cui tipo non è serializzabile, la serializzazione fallisce con NotSerializableException.

```java
class Holder implements Serializable {

	private static final long serialVersionUID = 1L;

	private Thread t; // Thread non è serializzabile
}
```

Soluzioni tipiche:
- marcare il campo transient
- sostituirlo con una rappresentazione serializzabile
- usare hook di serializzazione custom

<a id="3548-costruttori-e-serializzazione"></a>
### 35.4.8 Costruttori e serializzazione

Il comportamento dei costruttori in deserializzazione è fonte frequente di confusione.

Java ripristina lo stato principalmente dal byte stream, non eseguendo i costruttori.

<a id="35481-regola-i-costruttori-delle-classi-serializable-non-vengono-chiamati"></a>
#### 35.4.8.1 Regola: i costruttori delle classi Serializable NON vengono chiamati

Durante la deserializzazione di una classe Serializable, i suoi costruttori NON vengono eseguiti.

L’istanza viene creata senza chiamare quei costruttori e i campi vengono iniettati dallo stream.

!!! note
    Per questo i costruttori delle classi Serializable non devono contenere logica di inizializzazione essenziale: non verrebbe eseguita in deserializzazione.

<a id="35482-regola-di-ereditarietà-viene-chiamata-la-prima-superclass-non-serializable"></a>
#### 35.4.8.2 Regola di ereditarietà: viene chiamata la prima superclass non-Serializable

Se una classe Serializable ha una superclasse non Serializable, la deserializzazione deve inizializzare quella parte.

Quindi Java chiama **il costruttore no-arg della prima superclasse non-Serializable**.

Implicazioni:
- la superclasse non Serializable deve avere un no-arg accessibile
- le sottoclassi Serializable saltano i costruttori, le superclassi non Serializable no

<a id="35483-tabella-quali-costruttori-vengono-eseguiti"></a>
#### 35.4.8.3 Tabella: quali costruttori vengono eseguiti

| Tipo di classe | Costruttore chiamato in deserializzazione |
|---|---|
| Classe Serializable | No |
| Sottoclasse Serializable | No |
| Prima superclasse non Serializable | Sì (no-arg) |
| Classe Externalizable | Sì (richiesto public no-arg) |

<a id="35484-esempio-quali-costruttori-vengono-chiamati"></a>
#### 35.4.8.4 Esempio: quali costruttori vengono chiamati

```java
import java.io.*;

class A {
	A() {
		System.out.println("A constructor");
	}
}

class B extends A implements Serializable {
	private static final long serialVersionUID = 1L;
	B() {
		System.out.println("B constructor");
	}
}

class C extends B {
	private static final long serialVersionUID = 1L;
	C() {
		System.out.println("C constructor");
	}
}

public class Demo {
	public static void main(String[] args) throws Exception {

		C obj = new C();

		try (ObjectOutputStream out =
				 new ObjectOutputStream(new FileOutputStream("c.bin"))) {
			out.writeObject(obj);
		}

		try (ObjectInputStream in =
				 new ObjectInputStream(new FileInputStream("c.bin"))) {
			Object restored = in.readObject();
		}
	}
}
```

Output atteso e spiegazione  
Durante la costruzione normale (new C()):

```text
A constructor
B constructor
C constructor
```

Durante la deserializzazione (readObject):

```text
A constructor
```

Spiegazione:
- C è Serializable → C() non viene chiamato
- B è Serializable → B() non viene chiamato
- A non è Serializable → A() viene chiamato (no-arg)
- I campi di B e C vengono ripristinati dallo stream

!!! note
    Se la prima superclasse non-Serializable non ha un no-arg accessibile, la deserializzazione fallisce.

<a id="3549-hook-di-serializzazione-custom-writeobject-e-readobject"></a>
### 35.4.9 Hook di serializzazione custom: `writeObject` e `readObject`

Gli hook custom servono quando la serializzazione di default non basta (stato transient, campi derivati, cifratura, validazione, compatibilità).

Sono avanzati ma importanti per una deserializzazione corretta.

<a id="35491-perché-esiste-la-serializzazione-custom"></a>
#### 35.4.9.1 Perché esiste la serializzazione custom

Di default, Java serializza automaticamente tutti i campi di istanza non static e non transient.

È comodo, ma non copre esigenze frequenti.

Motivi tipici:
- un campo non va salvato direttamente (dati sensibili)
- un campo è derivato/cache e va ricalcolato
- serve validazione in lettura (rifiutare stato invalido)
- serve logica di backward/forward compatibility
- un oggetto referenziato non è Serializable e va gestito

<a id="35492-cosa-sono-davvero-writeobject-e-readobject"></a>
#### 35.4.9.2 Cosa sono davvero `writeObject` e `readObject`

Per personalizzare serializzazione/deserializzazione, una classe può definire due metodi privati speciali chiamati `writeObject` e `readObject`.

Non sono override di metodi di interfacce o superclassi: non fanno parte del normale flusso del programma.

Non li chiami mai tu.

Il framework di serializzazione (ObjectOutputStream/ObjectInputStream) li individua tramite reflection, **solo** se nome e firma sono esatti, e li invoca automaticamente.

Se non esistono (o la firma è sbagliata), viene usata la serializzazione di default.

!!! note
    Se la firma è errata (visibilità, parametri, return type, eccezioni), il framework non la riconosce e torna silenziosamente al default.

<a id="35493-firme-richieste-esatte"></a>
#### 35.4.9.3 Firme richieste (esatte)

```java
private void writeObject(ObjectOutputStream out) throws IOException

private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException
```

Vincoli:
- devono essere private
- devono ritornare void
- i tipi dei parametri devono combaciare esattamente
- le eccezioni devono essere compatibili

<a id="35494-cosa-succede-in-serializzazione-step-by-step"></a>
#### 35.4.9.4 Cosa succede in serializzazione: step-by-step

Quando serializzi:

```java
out.writeObject(obj);
```

Meccanismo:
- verifica Serializable
- cerca un private writeObject(ObjectOutputStream)
- se assente → default serialization
- se presente → viene chiamato il tuo writeObject

Punto chiave: dentro writeObject, Java non scrive automaticamente i campi “normali” se non lo chiedi. Per questo esiste:

```java
out.defaultWriteObject();
```

`defaultWriteObject()` significa: “serializza i campi serializzabili normali col meccanismo standard”.

Poi puoi scrivere dati extra come vuoi.

<a id="35495-pattern-tipico-e-regola-dellordine-writeread"></a>
#### 35.4.9.5 Pattern tipico e regola dell’ordine write/read

Pattern tipico: usare default e poi estendere.

L’ordine di lettura deve coincidere con l’ordine di scrittura.

```java
private void writeObject(ObjectOutputStream out) throws IOException {
	out.defaultWriteObject(); // scrive i campi normali
	out.writeInt(42);         // scrive dati extra
}

private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException {
	in.defaultReadObject();   // legge i campi normali
	int x = in.readInt();     // legge i dati extra nello stesso ordine
}
```

!!! note
    Se scrivi valori extra (int/string/etc.), devi leggerli nella stessa sequenza, altrimenti la deserializzazione fallisce o corrompe lo stato.

<a id="35410-esempio-duso-ripristinare-un-campo-derivato-transient"></a>
### 35.4.10 Esempio d’uso: ripristinare un campo derivato transient

Caso tipico: ricalcolare un valore cached transient dopo deserializzazione.

```java
class User implements Serializable {

	private static final long serialVersionUID = 1L;

	private String firstName;
	private String lastName;

	private transient String fullName;

	User(String firstName, String lastName) {
		this.firstName = firstName;
		this.lastName = lastName;
		this.fullName = firstName + " " + lastName;
	}

	private void readObject(ObjectInputStream in)
			throws IOException, ClassNotFoundException {

		in.defaultReadObject();              // ripristina firstName e lastName
		fullName = firstName + " " + lastName; // ricalcola il transient
	}
}
```

<a id="35411-externalizable-controllo-totale-e-responsabilità-totale"></a>
### 35.4.11 Externalizable: controllo totale (e responsabilità totale)

Externalizable richiede di definire manualmente come scrivere e leggere l’oggetto.

Richiede anche un costruttore pubblico no-arg, perché la deserializzazione istanzia prima l’oggetto.

```java
import java.io.*;

class Point implements Externalizable {
	int x;
	int y;

	public Point() { } // richiesto

	public Point(int x, int y) { this.x = x; this.y = y; }

	@Override
	public void writeExternal(ObjectOutput out) throws IOException {
		out.writeInt(x);
		out.writeInt(y);
	}

	@Override
	public void readExternal(ObjectInput in) throws IOException {
		x = in.readInt();
		y = in.readInt();
	}
}
```

!!! note
    Con Externalizable controlli il formato.
    Se lo cambi, devi gestire tu la backward compatibility.

<a id="35412-considerazioni-di-sicurezza-su-readobject"></a>
### 35.4.12 Considerazioni di sicurezza su `readObject()`

La deserializzazione di dati non fidati è pericolosa perché può eseguire codice indirettamente tramite:
- hook readObject
- logica di inizializzazione
- gadget chain in librerie

Linee guida:
- non deserializzare mai byte non fidati senza un motivo forte
- preferire formati sicuri (JSON, protobuf) per input esterni
- se obbligato, usare object filter e validazione rigorosa

<a id="35413-trappole-comuni-e-consigli-pratici"></a>
### 35.4.13 Trappole comuni e consigli pratici

- Serializable è solo marker: non richiede metodi
- `readObject` ritorna Object e può lanciare ClassNotFoundException
- i campi `static` non vengono mai serializzati
- i campi `transient` tornano a default salvo ripristino
- senza `serialVersionUID` la compatibilità può rompersi “a sorpresa”
- Externalizable richiede public no-arg constructor
- NotSerializableException quando un campo referenziato non è serializzabile

<a id="35414-quando-usare-o-evitare-la-serializzazione-java"></a>
### 35.4.14 Quando usare (o evitare) la serializzazione Java

Usa la serializzazione classica soprattutto per:
- persistenza locale di breve durata con versioni controllate
- caching in memoria quando entrambe le estremità sono fidate
- sistemi legacy che già la usano

Evitala per:
- protocolli di rete pubblici
- storage a lungo termine con schema evolutivo
- input non fidati
