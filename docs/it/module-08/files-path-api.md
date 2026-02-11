# 33. API di Files e Path

### Indice

- [33. API di Files e Path](#33-api-di-files-e-path)
  - [33.1 Creazione-e-Conversione di File legacy e Path NIO](#331-creazione-e-conversione-di-file-legacy-e-path-nio)
    - [33.1.1 Creare un File Legacy](#3311-creare-un-file-legacy)
    - [33.1.2 Creare un Path NIO-v2](#3312-creare-un-path-nio-v2)
    - [33.1.3 Assoluto vs Relativo Cosa Significa Relativo](#3313-assoluto-vs-relativo-cosa-significa-relativo)
    - [33.1.4 Unire--Costruire-Path](#3314-unire--costruire-path)
      - [33.1.4.1 resolve](#33141-resolve)
      - [33.1.4.2 relativize](#33142-relativize)
    - [33.1.5 Convertire tra File e Path](#3315-convertire-tra-file-e-path)
    - [33.1.6 Conversione URI Quando-Serve](#3316-conversione-uri-quando-serve)
    - [33.1.7 Canonico vs Assoluto vs Normalizzato Differenze-Fondamentali](#3317-canonico-vs-assoluto-vs-normalizzato-differenze-fondamentali)
      - [33.1.7.1 normalize](#33171-normalize)
    - [33.1.8 Tabella di Confronto Rapida Creazione--Conversione](#3318-tabella-di-confronto-rapida-creazione--conversione)
  - [33.2 Gestire File e Directory: Creare-Copiare-Spostare-Sostituire-Confrontare-Cancellare](#332-gestire-file-e-directory-creare-copiare-spostare-sostituire-confrontare-cancellare-legacy-vs-nio)
    - [33.2.1 Modello Mentale Path-Locator-vs-Operazioni](#3321-modello-mentale-pathlocator-vs-operazioni)
    - [33.2.2 Creare File e Directory](#3322-creare-file-e-directory)
      - [33.2.2.1 Creare un File](#33221-creare-un-file)
      - [33.2.2.2 Creare Directory](#33222-creare-directory)
    - [33.2.3 Copiare File e Directory](#3323-copiare-file-e-directory)
      - [33.2.3.1 Copiare un File NIO](#33231-copiare-un-file-nio)
      - [33.2.3.2 Copia Manuale Legacy-Basata-su-Stream](#33232-copia-manuale-legacy-basata-su-stream)
    - [33.2.4 Spostare--Rinominare-e-Sostituire](#3324-spostare--rinominare-e-sostituire)
      - [33.2.4.1 Rinomina Legacy Trappola-Comune](#33241-rinomina-legacy-trappola-comune)
      - [33.2.4.2 NIO Move Preferito](#33242-nio-move-preferito)
    - [33.2.5 Confrontare Path e File](#3325-confrontare-path-e-file)
      - [33.2.5.1 Uguaglianza-vs-Stesso-File](#33251-uguaglianza-vs-stesso-file)
    - [33.2.6 Cancellare File e Directory](#3326-cancellare-file-e-directory)
      - [33.2.6.1 Delete Legacy](#33261-delete-legacy)
      - [33.2.6.2 NIO Delete e Delete-If-Exists](#33262-nio-delete-e-delete-if-exists)
    - [33.2.7 Copiare--Cancellare-Ricorsivamente-Alberi-di-Directory Pattern-NIO](#3327-copiare--cancellare-ricorsivamente-alberi-di-directory-pattern-nio)
    - [33.2.8 Checklist di Riepilogo](#3328-checklist-di-riepilogo)

---

Questa sezione si concentra su come creare localizzatori su filesystem usando la API legacy `java.io.File` e la moderna API `java.nio.file.Path`: come convertire tra di loro e comprendere overload, default e trappole comuni.

## 33.1 `File` legacy e `Path` NIO: Creazione e Conversione

### 33.1.1 Creare un `File` (Legacy)

Una istanza `File` rappresenta un pathname del filesystem (assoluto o relativo).

Crearne una non accede al filesystem e non lancia `IOException`.

Costruttori core (più comuni):

- `new File(String pathname)` 
- `new File(String parent, String child)` 
- `new File(File parent, String child)` 
- `new File(URI uri)` (tipicamente `file:...`)

```java
import java.io.File;
import java.net.URI;

File f1 = new File("data.txt"); // relativo
File f2 = new File("/tmp", "data.txt"); // parent + child
File f3 = new File(new File("/tmp"), "data.txt");

File f4 = new File(URI.create("file:///tmp/data.txt"));
```

> [!NOTE]
> - `new File(...)` non apre mai il file.
> - Esistenza/permessi vengono controllati solo quando invocati metodi come `exists()`, `length()`, o quando si apre uno stream/channel.

### 33.1.2 Creare un `Path` (NIO v.2)

Un `Path` è solo un locator.

Come `File`, creare un `Path` non accede al filesystem.

Factory core:

- `Path.of(String first, String... more)` (Java 11+)
- `Paths.get(String first, String... more)` (stile più vecchio; ancora valido)
- `Path.of(URI uri)` (es. `file:///...`)

```java
import java.net.URI;
import java.nio.file.Path;
import java.nio.file.Paths;

Path p1 = Path.of("data.txt"); // relativo
Path p2 = Path.of("/tmp", "data.txt"); // parent + child

Path p3 = Paths.get("data.txt"); // stile factory legacy
Path p4 = Path.of(URI.create("file:///tmp/data.txt"));
```

> [!NOTE]
> - `Path.of(...)` e `Paths.get(...)` sono equivalenti per il filesystem di default.
> - Preferisci `Path.of` nel codice moderno.

### 33.1.3 Assoluto vs Relativo: Cosa Significa “Relativo”

Sia `File` sia `Path` possono essere creati come path relativi.

I path relativi vengono risolti rispetto alla working directory del processo (tipicamente `System.getProperty("user.dir")`).

```java
import java.io.File;
import java.nio.file.Path;

File rf = new File("data.txt");
Path rp = Path.of("data.txt");

System.out.println(rf.isAbsolute()); // false
System.out.println(rp.isAbsolute()); // false

System.out.println(rf.getAbsolutePath());
System.out.println(rp.toAbsolutePath());
```

> [!NOTE]
> I path relativi sono una fonte comune di bug “funziona sulla mia macchina” perché `user.dir` dipende da come/dove la JVM è stata lanciata.

### 33.1.4 Unire / Costruire Path

- Il `File` legacy usa i costruttori (parent + child).
- NIO usa `resolve` e metodi correlati.

| Task | Legacy (File) | NIO (Path) |
|------|---------------|------------|
| Unire parent + child | `new File(parent, child)` | `parent.resolve(child)` |
| Unire molti segmenti | Costruttori ripetuti | `Path.of(a, b, c)` o `resolve()` concatenati |

```java
import java.io.File;
import java.nio.file.Path;

File f = new File("/tmp", "a.txt");

Path base = Path.of("/tmp");
Path p = base.resolve("a.txt"); // /tmp/a.txt
Path p2 = base.resolve("dir").resolve("a.txt"); // /tmp/dir/a.txt
```

#### 33.1.4.1 `resolve()`

Combina path in modo filesystem-aware.

- I path relativi vengono appesi
- Un argomento assoluto sostituisce il base path

> [!NOTE]
> `Path.resolve(...)` ha una regola: se l’argomento è assoluto, restituisce l’argomento e scarta la base (non puoi combinare due path assoluti usando `resolve`).

#### 33.1.4.2 `relativize()`

`Path.relativize` calcola un **path relativo** da un path a un altro. Il path risultante, quando `resolved` rispetto al path sorgente, produce il path target.

In altre parole:

- Risponde alla domanda: “Come vado dal path A al path B?”
- Il risultato è sempre un path **relativo**
- Non avviene alcun accesso al filesystem

**Regole Fondamentali**

`relativize` ha precondizioni strette. Violandole si lancia una eccezione.

| Regola | Spiegazione |
|------|-------------|
| Entrambi i path devono essere assoluti | o entrambi relativi |
| Entrambi i path devono appartenere allo stesso filesystem | stesso provider |
| I componenti di root devono combaciare | stessa root (su Windows, stesso drive) |
| Il risultato non è mai assoluto | sempre relativo |

> [!NOTE]
> Se un path è assoluto e l’altro relativo, viene lanciata `IllegalArgumentException`.

**Esempio Relativo Semplice**:

Entrambi i path sono relativi, quindi la relativizzazione è consentita.

```java
Path p1 = Path.of("docs/manual");
Path p2 = Path.of("docs/images/logo.png");

Path relative = p1.relativize(p2);
System.out.println(relative);
```

```bash
../images/logo.png
```

Interpretazione: da `docs/manual`, sali di un livello, poi entra in `images/logo.png`.

**Esempio di Path Assoluti**:

I path assoluti funzionano esattamente allo stesso modo.

```java
Path base = Path.of("/home/user/projects");
Path target = Path.of("/home/user/docs/readme.txt");

Path relative = base.relativize(target);
System.out.println(relative);
```

```bash
../docs/readme.txt
```

**Usare `resolve` per Verificare il Risultato**

Una proprietà chiave di `relativize` è questa identità:

```text
base.resolve(base.relativize(target)).equals(target)
```

```java
Path base = Path.of("/a/b/c");
Path target = Path.of("/a/d/e");

Path r = base.relativize(target);
System.out.println(r); // ../../d/e
System.out.println(base.resolve(r)); // /a/d/e
```

**Esempio**: Mescolare Path Assoluti e Relativi (CASO ERRORE)

Questo è uno degli errori più comuni.

```java
Path abs = Path.of("/a/b");
Path rel = Path.of("c/d");

abs.relativize(rel); // lancia eccezione
```

```bash
Exception in thread "main" java.lang.IllegalArgumentException
```

> [!NOTE]
> `relativize` NON tenta di convertire automaticamente i path in assoluti.

**Esempio**: Root Diverse (Trappola Specifica Windows)

Su Windows, path con lettere di drive diverse non possono essere relativizzati.

```java
Path p1 = Path.of("C:\\data\\a");
Path p2 = Path.of("D:\\data\\b");

p1.relativize(p2); // IllegalArgumentException
```

> [!NOTE]
> Su sistemi Unix-like, la root è sempre `/`, quindi questo problema non si verifica.

### 33.1.5 Convertire tra `File` e `Path`

La conversione è diretta e lossless per normali path del filesystem locale.

| Conversione | Come |
|------------|-----|
| File → Path | `file.toPath()` |
| Path → File | `path.toFile()` |

```java
import java.io.File;
import java.nio.file.Path;

File f = new File("data.txt");
Path p = f.toPath();

File back = p.toFile();
```

> [!NOTE]
> La conversione non valida l’esistenza. Converte solo rappresentazioni.

### 33.1.6 Conversione URI (Quando Serve)

Gli `URI` sono utili quando i path devono essere rappresentati in forma standard e assoluta (es. interoperare con risorse in rete o configurazione).

Entrambe le API supportano la conversione URI.

| Direzione | Legacy (File) | NIO (Path) |
|-----------|----------------|------------|
| Da URI | `new File(uri)` | `Path.of(uri)` |
| A URI | `file.toURI()` | `path.toUri()` |

```java
import java.io.File;
import java.net.URI;
import java.nio.file.Path;

File f = new File("/tmp/data.txt");
URI u1 = f.toURI();

Path p = Path.of("/tmp/data.txt");
URI u2 = p.toUri();

Path pFromUri = Path.of(u2);
File fFromUri = new File(u1);
```

> [!NOTE]
> `new File(URI)` richiede un URI `file:` e lancia `IllegalArgumentException` se l’URI non è gerarchico o non è un file URI.

### 33.1.7 Canonico vs Assoluto vs Normalizzato (Differenze Fondamentali)

Questi termini vengono spesso confusi. Non sono la stessa cosa.

| Concetto        | Legacy (File)                          | NIO (Path)        | Tocca filesystem |
|----------------|----------------------------------------|-------------------|------------------|
| Assoluto       | `getAbsoluteFile()`                    | `toAbsolutePath()`| No               |
| Normalizzato   | (nessun normalize puro, usa canonical)\* | `normalize()`   | `normalize()`: No |
| Canonico / Reale | `getCanonicalFile()`                 | `toRealPath()`    | Sì               |

> [!NOTE]
> `File.getCanonicalFile()` e `Path.toRealPath()` possono risolvere symlink e richiedere che il path esista, quindi possono lanciare `IOException`.
>
> File non fornisce un metodo per una normalizzazione puramente sintattica: storicamente molti sviluppatori usavano getCanonicalFile(), ma questo accede al filesystem e può fallire.

```java
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;

File f = new File("a/../data.txt");
System.out.println(f.getAbsolutePath()); // assoluto, può ancora contenere ".."

try {
	System.out.println(f.getCanonicalPath()); // risolve "..", può toccare filesystem
} catch (IOException e) {
	System.out.println("Canonical failed: " + e.getMessage());
}

Path p = Path.of("a/../data.txt");
System.out.println(p.toAbsolutePath()); // assoluto, può ancora contenere ".."
System.out.println(p.normalize()); // puramente sintattico

try {
	System.out.println(p.toRealPath()); // risolve symlink, richiede esistenza
} catch (IOException e) {
	System.out.println("RealPath failed: " + e.getMessage());
}
```

#### 33.1.7.1 `normalize()`

Rimuove elementi di nome **ridondanti** come `.` e `..`.

- Puramente sintattico
- Non controlla se il path esiste

> [!NOTE]
> `normalize()` è puramente sintattico, non controlla l’esistenza, e può produrre path invalidi se usato male.

### 33.1.8 Tabella di Confronto Rapida (Creazione + Conversione)

| Esigenza | Legacy (File) | NIO (Path) | Preferito oggi |
|------|----------------|------------|-----------------|
| Creare da stringa | `new File("x")` | `Path.of("x")` | Path |
| Parent + child | `new File(p, c)` | `Path.of(p, c)` o `resolve()` | Path |
| Convertire tra API | `toPath()` | `toFile()` | Path-centric |
| Normalizzare | `getCanonicalFile()` (basato su filesystem) | `normalize()` (solo sintattico) | Path |
| Risolvere symlink | Canonical | `toRealPath()` | Path |

---

## 33.2 Gestire File e Directory: Creare, Copiare, Spostare, Sostituire, Confrontare, Cancellare (Legacy vs NIO)

Questa sezione copre le operazioni che esegui sulle entry del filesystem (file/directory): creazione, copia, spostamento/rinominazione, sostituzione, confronto e cancellazione.

Confronta il legacy `java.io.File` (e helper legacy correlati) con il moderno `java.nio.file` (NIO.2).

### 33.2.1 Modello Mentale: “Path/Locator” vs “Operazioni”

Entrambe le API usano oggetti che rappresentano un path, ma le operazioni differiscono:

- Legacy: `File` è sia un wrapper di path sia una API di operazioni (responsabilità mescolata)
- NIO: `Path` è il path; `Files` esegue le operazioni (separazione delle responsabilità)

| Responsabilità | Legacy | NIO |
|----------------|--------|-----|
| Rappresentazione Path | `File` | `Path` |
| Operazioni su filesystem | `File` | `Files` |
| Reporting degli errori | Debole (boolean) | Forte (eccezioni) |

> [!NOTE]
> I metodi legacy spesso restituiscono `boolean` (fallimento silenzioso), mentre NIO lancia `IOException` con causa.

### 33.2.2 Creare File e Directory

La creazione è dove la vecchia API è più scomoda e la API NIO è più espressiva.

| Task | Approccio legacy | Approccio NIO | Note |
|----------------|--------|-----|--------|
| Creare file vuoto | apri+chiudi stream | `Files.createFile` | NIO fallisce se esiste |
| Creare una directory | `mkdir` | `Files.createDirectory` | Il parent deve esistere |
| Creare directory ricorsivamente | `mkdirs` | `Files.createDirectories` | Crea i parent |

#### 33.2.2.1 Creare un File

Il legacy non ha un metodo “crea file vuoto”, quindi tipicamente crei un file aprendo uno stream di output (side effect).

```java
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

File f = new File("created-legacy.txt");
try (FileOutputStream out = new FileOutputStream(f)) {
	// il file è creato (o troncato) come side effect
}
```

NIO fornisce un metodo esplicito di creazione.

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;

Path p = Path.of("created-nio.txt");
Files.createFile(p);
```

> [!NOTE]
> `Files.createFile` lancia `FileAlreadyExistsException` se la entry esiste.

#### 33.2.2.2 Creare Directory

```java
import java.io.File;

File dir1 = new File("a/b");
boolean ok1 = dir1.mkdir(); // fallisce se il parent "a" non esiste
boolean ok2 = dir1.mkdirs(); // crea i parent
```

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;

Path d = Path.of("a/b");
Files.createDirectory(d); // il parent deve esistere
Files.createDirectories(d); // crea i parent, ok se già esiste
```

> [!NOTE]
> I legacy `mkdir()/mkdirs()` restituiscono `false` in caso di fallimento senza dire perché. NIO lancia `IOException`.

### 33.2.3 Copiare File e Directory

La copia legacy è di solito una copia manuale via stream (o librerie esterne). NIO ha una singola operazione esplicita.

| Capacità | Legacy | NIO |
|--------------|--------|-----|
| Copiare contenuti file | Stream manuali | `Files.copy` |
| Copiare in target esistente | Manuale | Opzione `REPLACE_EXISTING` |
| Copiare albero directory | Ricorsione manuale | Ricorsione manuale (ma strumenti migliori: `Files.walk` + `Files.copy`) |

#### 33.2.3.1 Copiare un File (NIO)

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.io.IOException;

Path src = Path.of("src.txt");
Path dst = Path.of("dst.txt");

Files.copy(src, dst); // fallisce se dst esiste
Files.copy(src, dst, StandardCopyOption.REPLACE_EXISTING);
```

> [!NOTE]
> `Files.copy` lancia `FileAlreadyExistsException` se il target esiste e non hai usato `REPLACE_EXISTING`.

#### 33.2.3.2 Copia Manuale (Legacy, Basata su Stream)

```java
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

try (FileInputStream in = new FileInputStream("src.bin");
FileOutputStream out = new FileOutputStream("dst.bin")) {

	byte[] buf = new byte[8192];
	int n;
	while ((n = in.read(buf)) != -1) {
		out.write(buf, 0, n);
	}
}
```

> [!NOTE]
> Ricorda `read(byte[])` restituisce il numero di byte letti; devi scrivere solo quel conteggio, non l’intero buffer.

### 33.2.4 Spostare / Rinominare e Sostituire

In entrambe le API, rinomina/sposta è “a livello metadata” quando possibile, ma può comportarsi come copy+delete tra filesystem. NIO lo rende esplicito tramite opzioni.

| Operazione | Legacy | NIO |
|-----------|--------|-----|
| Rinominare/spostare | `File.renameTo` | `Files.move` |
| Sostituire esistente | Inaffidabile | `REPLACE_EXISTING` |
| Spostamento atomico | Non supportato | `ATOMIC_MOVE` (se supportato) |

#### 33.2.4.1 Rinomina Legacy (Trappola Comune)

```java
import java.io.File;

File from = new File("old.txt");
File to = new File("new.txt");

boolean ok = from.renameTo(to); // può fallire silenziosamente
System.out.println(ok);
```

> [!NOTE]
> - `renameTo` è notoriamente platform-dependent e restituisce solo `boolean`.
> - Può fallire perché il target esiste, il file è aperto, permessi, o spostamento cross-filesystem.

#### 33.2.4.2 NIO Move (Preferito)

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.io.IOException;

Path from = Path.of("old.txt");
Path to = Path.of("new.txt");

Files.move(from, to); // fallisce se il target esiste
Files.move(from, to, StandardCopyOption.REPLACE_EXISTING);
```

> [!NOTE]
> `Files.move` lancia `FileAlreadyExistsException` quando il target esiste e `REPLACE_EXISTING` non è specificato.

### 33.2.5 Confrontare Path e File

Confrontare locator può significare: uguaglianza string/path, uguaglianza normalizzata/canonica, o “stesso file su disco”.

Le API differiscono significativamente qui.

| Obiettivo confronto | Legacy | NIO |
|-----------------|--------|-----|
| Stesso testo di path | `File.equals` | `Path.equals` |
| Normalizzare path | `getCanonicalFile` | `normalize` |
| Stesso file/risorsa su disco | debole (euristica canonica) | `Files.isSameFile` |

#### 33.2.5.1 Uguaglianza vs Stesso File

Due stringhe di path diverse possono riferirsi allo stesso file.

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;

Path p1 = Path.of("a/../data.txt");
Path p2 = Path.of("data.txt");

System.out.println(p1.equals(p2)); // false (testo path diverso)
System.out.println(p1.normalize().equals(p2.normalize())); // può ancora essere false se relativo

try {
	System.out.println(Files.isSameFile(p1, p2)); // può essere true, può lanciare se non accessibile
} catch (IOException e) {
	System.out.println("isSameFile failed: " + e.getMessage());
}
```

> [!NOTE]
> `Files.isSameFile` può accedere al filesystem e può lanciare `IOException` (problemi di permessi, file mancanti, ecc.).

### 33.2.6 Cancellare File e Directory

La cancellazione è semplice in concetto ma ha casi limite importanti: directory non vuote, target mancanti e differenze nel reporting degli errori.

| Task | Legacy | NIO | Comportamento se mancante |
|------|--------|-----|---------------------------|
| Cancellare file/dir | `File.delete` | `Files.delete` | Legacy false, NIO eccezione |
| Cancellare se esiste | Nessun diretto (check+delete) | `Files.deleteIfExists` | restituisce boolean |
| Cancellare dir non vuota | Ricorsione manuale | Ricorsione manuale (walk) | Entrambe richiedono ricorsione |

#### 33.2.6.1 Delete Legacy

```java
import java.io.File;

File f = new File("x.txt");
boolean ok = f.delete(); // false se non cancellato
System.out.println(ok);
```

> [!NOTE]
> Legacy `delete()` fallisce (restituisce false) per una directory non vuota e spesso non fornisce motivo.

#### 33.2.6.2 NIO Delete e Delete-If-Exists

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.NoSuchFileException;
import java.nio.file.DirectoryNotEmptyException;
import java.io.IOException;

Path p = Path.of("x.txt");

try {
	Files.delete(p);
} catch (NoSuchFileException e) {
	System.out.println("Missing: " + e.getFile());
} catch (DirectoryNotEmptyException e) {
	System.out.println("Directory not empty: " + e.getFile());
} catch (IOException e) {
	System.out.println("Delete failed: " + e.getMessage());
}

boolean deleted = Files.deleteIfExists(p);
System.out.println(deleted);
```

> [!NOTE]
> Certification tip: `Files.delete` lancia `NoSuchFileException` se mancante, mentre `deleteIfExists` restituisce `false`.

### 33.2.7 Copiare / Cancellare Ricorsivamente Alberi di Directory (Pattern NIO)

NIO non fornisce un singolo metodo “copyTree/deleteTree”, ma l’approccio standard usa `Files.walk` o `Files.walkFileTree`.

```java
import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;

Path root = Path.of("dirToDelete");

Files.walkFileTree(root, new SimpleFileVisitor<Path>() {
    @Override
    public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
        Files.delete(file);
        return FileVisitResult.CONTINUE;
    }

    @Override
    public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {
        if (exc != null) throw exc;
        Files.delete(dir);
        return FileVisitResult.CONTINUE;
    }
});
```

> [!NOTE]
> Cancellare un albero di directory richiede cancellare prima i file, poi le directory (post-order). Questa è una domanda di ragionamento comune.

### 33.2.8 Checklist di Riepilogo

- Preferisci `Files.createFile/createDirectory/createDirectories` rispetto a workaround legacy
- `File.renameTo` è inaffidabile; preferisci `Files.move` con opzioni
- `Files.copy/move` lanciano `FileAlreadyExistsException` a meno che non venga usato `REPLACE_EXISTING`
- `Files.delete` lancia; `Files.deleteIfExists` restituisce boolean
- `Files.isSameFile` può lanciare `IOException` e può toccare il filesystem
- La cancellazione di directory non vuote richiede ricorsione (entrambe le API)
