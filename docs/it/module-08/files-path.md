# 32. Fondamenti di File e Path

### Indice

- [32. Fondamenti di File e Path](#32-fondamenti-di-file-e-path)
  - [32.1 Modello Concettuale: Filesystem, File, Directory, Link e Target-di-I/O](#321-modello-concettuale-filesystem-file-directory-link-e-target-di-io)
  - [32.2 Filesystem – L’Astrazione Globale](#322-filesystem--lastrazione-globale)
  - [32.3 Path – Localizzare una Entry in un Filesystem](#323-path--localizzare-una-entry-in-un-filesystem)
  - [32.4 File – Contenitori Persistenti di Dati](#324-file--contenitori-persistenti-di-dati)
  - [32.5 Directory – Contenitori Strutturali](#325-directory--contenitori-strutturali)
  - [32.6 Link – Meccanismi di Indirezione](#326-link--meccanismi-di-indirezione)
    - [32.6.1 Hard Link](#3261-hard-link)
    - [32.6.2 Link Simbolici Soft](#3262-link-simbolici-soft)
  - [32.7 Altri Tipi di Entry del Filesystem](#327-altri-tipi-di-entry-del-filesystem)
  - [32.8 Come Java IO Interagisce con Questi Concetti](#328-come-java-io-interagisce-con-questi-concetti)
  - [32.9 Trappole Concettuali Fondamentali](#329-trappole-concettuali-fondamentali)
  - [32.10 Perché Esistono Path e Files (Contesto-IO)](#3210-perché-esistono-path-e-files-contesto-io)
  - [32.11 File È (API legacy) sia un path sia una api-di-operazioni-su-file](#3211-file-è-api-legacy-sia-un-path-sia-una-api-di-operazioni-su-file)
    - [32.11.1 Cosa È Davvero File](#32111-cosa-è-davvero-file)
    - [32.11.2 Responsabilità tipo-Path](#32112-responsabilità-tipo-path)
    - [32.11.3 Responsabilità di Operazioni sul Filesystem](#32113-responsabilità-di-operazioni-sul-filesystem)
    - [32.11.4 Cosa NON È File](#32114-cosa-non-è-file)
    - [32.11.5 Il vecchio doppio ruolo](#32115-il-vecchio-doppio-ruolo)
    - [32.11.6 Come NIO Ha Risolto Questo](#32116-come-nio-ha-risolto-questo)
    - [32.11.7 Riepilogo](#32117-riepilogo)
  - [32.12 Path È una Descrizione, Non una Risorsa](#3212-path-è-una-descrizione-non-una-risorsa)
  - [32.13 Path Assoluti vs Relativi](#3213-path-assoluti-vs-relativi)
    - [32.13.1 Path Assoluti](#32131-path-assoluti)
    - [32.13.2 Path Relativi](#32132-path-relativi)
  - [32.14 Consapevolezza del Filesystem e Separatori](#3214-consapevolezza-del-filesystem-e-separatori)
    - [32.14.1 FileSystem](#32141-filesystem)
    - [32.14.2 Separatori di Path](#32142-separatori-di-path)
  - [32.15 Cosa Fa Davvero Files e Cosa Non Fa](#3215-cosa-fa-davvero-files-e-cosa-non-fa)
    - [32.15.1 Files FA](#32151-files-fa)
    - [32.15.2 Files NON FA](#32152-files-non-fa)
  - [32.16 Filosofia di Gestione degli Errori: Old-vs-NIO](#3216-filosofia-di-gestione-degli-errori-old-vs-nio)
  - [32.17 Falsi Miti Comuni](#3217-falsi-miti-comuni)

---

Questa sezione si concentra su `Path`, `File`, `Files` e classi correlate, spiegando perché esistono, quali problemi risolvono e quali sono le differenze tra le API legacy `java.io` e `NIO v.2` (nuove API di I/O), con particolare attenzione alla semantica del filesystem, alla risoluzione dei path e ai falsi miti comuni.

## 32.1 Modello Concettuale: Filesystem, File, Directory, Link e Target-di-I/O

Prima di comprendere le API di Java I/O, è essenziale capire con cosa esse interagiscono.

**Java I/O** non opera nel vuoto: interagisce con astrazioni di filesystem fornite dal sistema operativo.

Questa sezione definisce questi concetti indipendentemente da Java, poi spiega come Java I/O li mappa e quali problemi vengono risolti.

---

## 32.2 Filesystem – L’Astrazione Globale

Un `filesystem` è un meccanismo strutturato fornito da un sistema operativo per organizzare, memorizzare, recuperare e gestire dati su dispositivi di storage persistente.

A livello concettuale, un filesystem risolve diversi problemi fondamentali:

- Storage persistente oltre l’esecuzione del programma
- Organizzazione gerarchica dei dati
- Nominare e localizzare i dati
- Controllo degli accessi e permessi
- Garanzie di concorrenza e consistenza

In Java NIO, un filesystem è rappresentato dall’astrazione `FileSystem`, tipicamente ottenuta tramite `FileSystems.getDefault()` per il filesystem del sistema operativo.

| Aspetto | Significato |
| --- | --- |
| Persistenza | I dati sopravvivono alla terminazione della JVM |
| Ambito | Gestito dal SO, non gestito dalla JVM |
| Molteplicità | Possono esistere più filesystem |
| Esempi | Disk FS, ZIP FS, in-memory FS |

!!! note
    Java non implementa filesystem; si adatta a implementazioni di filesystem fornite dal SO o da providers custom.

---

## 32.3 Path – Localizzare una Entry in un Filesystem

Un `path` è un localizzatore logico, non una risorsa.

Descrive dove qualcosa sarebbe in un filesystem, non cos’è o se esiste.

Un `path` risolve il problema dell’`addressing`:

- Identifica una posizione
- È interpretato all’interno di un filesystem specifico
- Può o non può corrispondere a una entry esistente

| Proprietà | Path |
| --- | --- |
| Consapevole dell’esistenza | No |
| Consapevole del tipo | No |
| Immutabile | Sì |
| Risorsa del SO | No |

!!! note
    In Java, `Path` rappresenta entry potenziali del filesystem, non entry reali.

---

## 32.4 File – Contenitori Persistenti di Dati

Un `file` è una entry del filesystem il cui ruolo primario è memorizzare dati.

Il filesystem tratta i file come sequenze di byte opache.

Problemi risolti dai file:

- Storage duraturo di informazioni
- Accesso sequenziale e random ai dati
- Condivisione dei dati tra processi

Dal punto di vista del filesystem, un file ha:

- Contenuto (byte)
- Metadati (dimensione, timestamp, permessi)
- Una posizione (path)

| Aspetto | Descrizione |
| --- | --- |
| Contenuto | Orientato ai byte |
| Interpretazione | Definita dall’applicazione |
| Durata | Indipendente dai processi |
| Accesso Java | Stream, channel, metodi di Files |

!!! note
    `Testo` vs `binario` non è un concetto del filesystem; è un’interpretazione a livello applicazione.

---

## 32.5 Directory – Contenitori Strutturali

Una `directory (o folder)` è una entry del filesystem il cui scopo è organizzare altre entry.

Le `directory` risolvono il problema della scalabilità e dell’organizzazione:

- Raggruppare entry correlate
- Abilitare naming gerarchico
- Supportare lookup efficiente

| Aspetto | Directory |
| --- | --- |
| Memorizza dati | No (memorizza riferimenti) |
| Contiene | File, directory, link |
| Lettura/scrittura | Strutturale, non basata sul contenuto |
| Accesso Java | Files.list, Files.walk |

!!! note
    Una directory non è un file con contenuto, anche se entrambi condividono metadati comuni.

---

## 32.6 Link – Meccanismi di Indirezione

Un `link` è una entry del filesystem che riferisce un’altra entry.

I link risolvono il problema dell’indirezione e del riuso.

### 32.6.1 Hard Link

Un `hard link` è un nome aggiuntivo per gli stessi dati sottostanti.

- Più path puntano agli stessi dati del file
- La cancellazione avviene solo quando tutti i link vengono rimossi

### 32.6.2 Link Simbolici (Soft)

Un `link simbolico` è un file speciale che contiene un path verso un’altra entry:

- Può puntare a target non esistenti
- Risolto al momento dell’accesso

| Tipo di Link | Riferisce | Può essere dangling | Gestione Java |
| --- | --- | --- | --- |
| Hard | Dati | No | Trasparente |
| Simbolico | Path | Sì | Controllo esplicito |

!!! note
    Java NIO espone il comportamento dei link in modo esplicito tramite `LinkOption`.
    
    In molti filesystem comuni, il codice Java non può creare hard link in modo pienamente portabile, mentre i link simbolici sono supportati direttamente tramite `Files.createSymbolicLink(...)` (dove permesso dal SO / permessi).

---

## 32.7 Altri Tipi di Entry del Filesystem

Alcune entry del filesystem non sono contenitori di dati ma endpoint di interazione.

| Tipo | Scopo |
| --- | --- |
| Device file | Interfaccia verso hardware |
| FIFO / Pipe | Comunicazione tra processi |
| Socket file | Comunicazione di rete |

!!! note
    Java I/O può interagire con queste entry, ma il comportamento dipende dalla piattaforma.

---

## 32.8 Come Java IO Interagisce con Questi Concetti

Le API Java I/O operano a diversi livelli di astrazione:

- `Path` (NIO) / `File` (API legacy) → descrive una entry del filesystem
- `File` (API legacy) / `Files` → interroga o modifica lo stato del filesystem
- `Streams` / `Channels` → muovono byte o caratteri

| API Java | Ruolo |
| --- | --- |
| `Path` | Addressing |
| `File` (API legacy) | Addressing / operazioni su filesystem |
| `Files` | Operazioni su filesystem |
| `InputStream` / `Reader` | Lettura dati |
| `OutputStream` / `Writer` | Scrittura dati |
| `Channel` / `SeekableByteChannel` | Avanzato / accesso random |

!!! note
    Nessuna API Java “è” un file; le API mediano l’accesso a risorse gestite dal filesystem.

---

## 32.9 Trappole Concettuali Fondamentali

- Confondere i path con i file
- Assumere che i path implichino esistenza
- Assumere che le directory memorizzino i dati dei file
- Assumere che i link siano sempre risolti automaticamente

!!! note
    Separare sempre posizione, struttura e flusso dati quando si ragiona su I/O.

---

## 32.10 Perché Esistono Path e Files (Contesto-IO)

Il classico `java.io` mescolava tre compiti diversi in un API poco specifica:

- Rappresentazione del path (dove si trova la risorsa?)
- Interazione con il filesystem (esiste? che tipo?)
- Accesso ai dati (lettura/scrittura di byte o caratteri)

Il design di NIO.2 (Java 7+) separa deliberatamente queste responsabilità:

- `Path` → descrive una posizione
- `Files` → esegue operazioni sul filesystem
- `Streams / Channels` → spostano dati

!!! note
    Un `Path` non apre mai un file e non tocca mai il disco da solo.

---

## 32.11 File È (API legacy) sia un path sia una api-di-operazioni-su-file?

Sì — nella vecchia API di I/O, `java.io.File` gioca in modo confuso due ruoli allo stesso tempo, e questo design è esattamente una delle ragioni per cui è stato introdotto `java.nio.file`.

**Risposta Breve**

- `File` rappresenta un path del filesystem
- `File` espone anche operazioni sul filesystem
- Non rappresenta **né** un file aperto, **né** i contenuti del file

!!! note
    Questo mix di responsabilità è considerato un difetto di design.

### 32.11.1 Cosa È Davvero File

Concettualmente, `File` è più vicino a ciò che oggi chiamiamo `Path`, ma con metodi operativi aggiunti.

| Aspetto | java.io.File |
|--------|--------------|
| Rappresenta una posizione | Sì |
| Apre un file | No |
| Legge / scrive dati | No |
| Interroga il filesystem | Sì |
| Modifica il filesystem | Sì |
| Contiene handle del SO | No |

!!! note
    Un oggetto `File` può esistere anche se il file non esiste.

### 32.11.2 Responsabilità tipo-Path

`File` si comporta come un’astrazione di path perché:

- Incapsula un pathname del filesystem (assoluto o relativo)
- Può essere risolto rispetto alla working directory
- Può essere convertito in forma assoluta o canonica

Esempi:

```java
File f = new File("data.txt"); // path relativo
File abs = f.getAbsoluteFile(); // path assoluto
File canon = f.getCanonicalFile(); // normalizzato + risolto
```

### 32.11.3 Responsabilità di Operazioni sul Filesystem

Allo stesso tempo, `File` espone metodi che toccano il filesystem:

- exists()
- isFile(), isDirectory()
- length()
- delete()
- mkdir(), mkdirs()
- list(), listFiles()

!!! note
    La maggior parte di questi metodi restituisce `boolean` invece di lanciare `IOException`, il che nasconde le cause degli eventuali problemi.

### 32.11.4 Cosa NON È File

- Non è un file descriptor aperto
- Non è uno stream
- Non è un channel
- Non è un contenitore di dati del file

Si devono comunque usare stream o reader/writer per accedere ai contenuti.

### 32.11.5 Il vecchio doppio ruolo

Il doppio ruolo di `File` ha causato diversi problemi:

- Ruolo misto (path + operazioni)
- Gestione errori insufficiente (boolean invece di eccezioni)
- Supporto debole per link e filesystem multipli
- Comportamento dipendente dalla piattaforma

### 32.11.6 Come NIO ha Risolto Questo

NIO.2 separa esplicitamente le responsabilità:

| Responsabilità | Vecchia API | API NIO |
|----------------|------------|---------|
| `Rappresentazione Path` | `File` | `Path` |
| `Operazioni su filesystem` | `File` | `Files` |
| `Accesso ai dati` | Stream | Stream / Channel |

!!! note
    Questa separazione è uno dei miglioramenti concettuali più importanti in Java I/O.

### 32.11.7 Riepilogo

- `File` rappresenta un path E svolge operazioni sul filesystem
- Non legge né scrive mai i contenuti del file
- Non apre mai un file
- `Path` + `Files` è il sostituto moderno

---

## 32.12 Path È una Descrizione, Non una Risorsa

Un `Path` è un’astrazione pura che rappresenta una sequenza di elementi nominati in un filesystem.

- Non implica esistenza
- Non implica accessibilità
- Non contiene un file descriptor

Questo è fondamentalmente diverso da stream o channel.

| Concetto | Path | Stream / Channel |
|----------|------|------------------|
| `Apre risorsa` | No | Sì |
| `Tocca disco` | No | Sì |
| `Contiene handle SO` | No | Sì |
| `Immutabile` | Sì | No |

!!! note
    Creare un Path non può lanciare `IOException` perché non avviene alcun I/O.

---

## 32.13 Path Assoluti vs Relativi

Comprendere la risoluzione dei path è essenziale.

### 32.13.1 Path Assoluti

Un path assoluto identifica interamente una posizione dalla root del filesystem.

- Root dipendente dalla piattaforma
- Indipendente dalla JVM working directory

| Piattaforma | Esempio di Path Assoluto |
|-------------|---------------------------|
| Unix | `/home/user/file.txt` |
| Windows | `C:\Users\User\file.txt` |

!!! important
    - Un path che inizia con una slash `(/)` (tipo Unix) o con una lettera di drive come `C:` (Windows) è **tipicamente** considerato un path assoluto.
    - Il simbolo `.` è un riferimento alla directory corrente mentre `..` è un riferimento alla directory padre.
    Su Windows, un path come `\dir\file.txt` (senza lettera di drive) è *rooted* sul drive corrente, non pienamente qualificato con drive + path.

Esempio:

```bash
/dirA/dirB/../dirC/./content.txt

is equivalent to:

/dirA/dirC/content.txt

// in this example the symbols were redundant and unnecessary
```

### 32.13.2 Path Relativi

Un path relativo viene risolto rispetto alla directory di lavoro corrente della JVM.

- Dipende da dove è stata avviata la JVM
- Fonte comune di bug

!!! note
    La working directory è tipicamente disponibile tramite `System.getProperty("user.dir")`.

Esempio:

```bash
dirB/dirC/content.txt
```

---

## 32.14 Consapevolezza del Filesystem e Separatori

NIO introduce l’astrazione del filesystem, che era in gran parte assente in java.io.

### 32.14.1 FileSystem

Un `FileSystem` rappresenta una specifica implementazione concreta di filesystem.

- Il filesystem di default corrisponde al filesystem del SO
- Possibili altri filesystem (ZIP, memoria, rete)

!!! note
    I path sono sempre associati a esattamente UN FileSystem.

### 32.14.2 Separatori di Path

I separatori differiscono tra piattaforme, ma `Path` li astrae.

| Aspetto | java.io.File | java.nio.file.Path |
|---------|--------------|--------------------|
| Separatore | Basato su stringhe | Consapevole del filesystem |
| Portabilità | Gestione manuale | Automatica |
| Comparazione | Soggetta a errori | Più sicura |

!!! note
    Hardcodare `"/"` o `"\\"` è sconsigliato; `Path` lo gestisce automaticamente.

---

## 32.15 Cosa Fa Davvero Files e Cosa Non Fa

La classe `Files` esegue vere operazioni di I/O.

### 32.15.1 Files FA

- Apre file indirettamente (tramite stream / channel restituiti dai suoi metodi)
- Crea e cancella entry del filesystem
- Lancia eccezioni checked in caso di fallimento
- Rispetta i permessi del filesystem

### 32.15.2 Files NON FA

- Mantenere risorse aperte dopo il ritorno del metodo (eccetto gli stream)
- Memorizzare contenuti del file internamente
- Garantire atomicità se non specificato
- Mantenere un handle persistente a file aperti (sono stream/channel a possedere l’handle)

!!! note
    I metodi che restituiscono stream (es. `Files.lines()`) tengono il file aperto finché lo stream non viene chiuso.

---

## 32.16 Filosofia di Gestione degli Errori: Old vs NIO

Una grande differenza concettuale risiede nel reporting degli errori.

| Aspetto | `java.io.File` | `java.nio.file.Files` |
|---------|-----------------|------------------------|
| Segnalazione errori | boolean / `null` | `IOException` |
| Diagnostica | Scarsa | Ricca |
| Consapevolezza race | Debole | Migliorata |
| Preferenza | Sconsigliato | Preferito |

---

## 32.17 Falsi Miti Comuni

- “Path rappresenta un file” → falso
- “normalize controlla l’esistenza” → falso
- “Files.readAllLines streamma i dati” → falso
- “I path relativi sono portabili” → falso
- “Creare un Path può fallire per permessi” → falso

!!! note
    Molti metodi NIO che suonano “sicuri” sono puramente sintattici (come `normalize` o `resolve`): non toccano il filesystem e non possono rilevare file mancanti.
