# 35. API Java d’E/S (Legacy et NIO)

### Table des matières

- [35. API Java dE/S (Legacy et NIO)](#35-api-java-des-legacy-et-nio)
  - [35.1 Legacy java.io — Conception, comportement et subtilités](#351-legacy-javaio--conception-comportement-et-subtilités)
    - [35.1.1 L’abstraction de flux](#3511-labstraction-de-flux)
    - [35.1.2 Chaînage des flux et pattern Décorateur](#3512-chaînage-des-flux-et-pattern-décorateur)
    - [35.1.3 E/S bloquantes: ce que cela signifie](#3513-es-bloquantes-ce-que-cela-signifie)
    - [35.1.4 Gestion des ressources: close(), flush() et pourquoi ils existent](#3514-gestion-des-ressources-close-flush-et-pourquoi-ils-existent)
    - [35.1.5 finalize(): pourquoi il existe et pourquoi il échoue](#3515-finalize-pourquoi-il-existe-et-pourquoi-il-échoue)
    - [35.1.6 available(): objectif et abus](#3516-available-objectif-et-abus)
    - [35.1.7 mark() et reset(): backtracking contrôlé](#3517-mark-et-reset-backtracking-contrôlé)
    - [35.1.8 Reader, Writer et encodage des caractères](#3518-reader-writer-et-encodage-des-caractères)
    - [35.1.9 File vs FileDescriptor](#3519-file-vs-filedescriptor)
  - [35.2 java.nio — Buffer, Channel et E/S non bloquantes](#352-javanio--buffer-channel-et-es-non-bloquantes)
    - [35.2.1 Des flux aux buffers: un changement conceptuel](#3521-des-flux-aux-buffers-un-changement-conceptuel)
    - [35.2.2 Buffer: objectif et structure](#3522-buffer-objectif-et-structure)
    - [35.2.3 Cycle de vie du buffer: Write → Flip → Read](#3523-cycle-de-vie-du-buffer-write--flip--read)
    - [35.2.4 clear() vs compact()](#3524-clear-vs-compact)
    - [35.2.5 Heap buffers vs Direct buffers](#3525-heap-buffers-vs-direct-buffers)
    - [35.2.6 Channel: ce que c’est](#3526-channel-ce-que-cest)
    - [35.2.7 Channel bloquants vs non bloquants](#3527-channel-bloquants-vs-non-bloquants)
    - [35.2.8 Scatter/Gather E/S](#3528-scattergather-es)
    - [35.2.9 Selector: multiplexage de lE/S non bloquante](#3529-selector-multiplexage-de-les-non-bloquante)
    - [35.2.10 Quand utiliser java.nio](#35210-quand-utiliser-javanio)
  - [35.3 java.nio.file (NIO.2) — Opérations sur fichiers et répertoires (Legacy vs Moderne)](#353-javaniofile-nio2--opérations-sur-fichiers-et-répertoires-legacy-vs-moderne)
    - [35.3.1 Vérifications d’existence et d’accessibilité](#3531-vérifications-dexistence-et-daccessibilité)
    - [35.3.2 Création de fichiers et de répertoires](#3532-création-de-fichiers-et-de-répertoires)
    - [35.3.3 Suppression de fichiers et de répertoires](#3533-suppression-de-fichiers-et-de-répertoires)
    - [35.3.4 Copie de fichiers et de répertoires](#3534-copie-de-fichiers-et-de-répertoires)
    - [35.3.5 Déplacement et renommage](#3535-déplacement-et-renommage)
    - [35.3.6 Lecture et écriture de texte et d’octets (améliorations de Files)](#3536-lecture-et-écriture-de-texte-et-doctets-améliorations-de-files)
    - [35.3.7 newInputStream/newOutputStream et newBufferedReader/newBufferedWriter](#3537-newinputstreamnewoutputstream-et-newbufferedreadernewbufferedwriter)
    - [35.3.8 Listing de répertoires et traversée d’arbres](#3538-listing-de-répertoires-et-traversée-darbres)
    - [35.3.9 Recherche et filtre](#3539-recherche-et-filtre)
    - [35.3.10 Attributs: lecture, écriture et view](#35310-attributs-lecture-écriture-et-view)
    - [35.3.11 Liens symboliques et follow des liens](#35311-liens-symboliques-et-follow-des-liens)
    - [35.3.12 Synthèse: pourquoi Files est une amélioration](#35312-synthèse-pourquoi-files-est-une-amélioration)
  - [35.4 Sérialisation — Object stream, compatibilité et pièges](#354-sérialisation--object-stream-compatibilité-et-pièges)
    - [35.4.1 Ce que fait la sérialisation (et ce qu’elle ne fait pas)](#3541-ce-que-fait-la-sérialisation-et-ce-quelle-ne-fait-pas)
    - [35.4.2 Les deux principales marker interface](#3542-les-deux-principales-marker-interface)
    - [35.4.3 Exemple de base: écrire et lire un objet](#3543-exemple-de-base-écrire-et-lire-un-objet)
    - [35.4.4 Graphes d’objets, références et identité](#3544-graphes-dobjets-références-et-identité)
    - [35.4.5 serialVersionUID: la clé de versioning](#3545-serialversionuid-la-clé-de-versioning)
    - [35.4.6 Champs transient et static](#3546-champs-transient-et-static)
    - [35.4.7 Champs non sérialisables et NotSerializableException](#3547-champs-non-sérialisables-et-notserializableexception)
    - [35.4.8 Constructeurs et sérialisation](#3548-constructeurs-et-sérialisation)
    - [35.4.9 Hook de sérialisation custom: writeObject et readObject](#3549-hook-de-sérialisation-custom-writeobject-et-readobject)
    - [35.4.10 Exemple d’usage: restaurer un champ dérivé transient](#35410-exemple-dusage-restaurer-un-champ-dérivé-transient)
    - [35.4.11 Externalizable: contrôle total (et responsabilité totale)](#35411-externalizable-contrôle-total-et-responsabilité-totale)
    - [35.4.12 Considérations de sécurité sur readObject()](#35412-considérations-de-sécurité-sur-readobject)
    - [35.4.13 Pièges communs et conseils pratiques](#35413-pièges-communs-et-conseils-pratiques)
    - [35.4.14 Quand utiliser (ou éviter) la sérialisation Java](#35414-quand-utiliser-ou-éviter-la-sérialisation-java)

---

## 35.1 Legacy java.io — Conception, comportement et subtilités

L’API legacy `java.io` est l’abstraction E/S originale introduite dans Java 1.0.

Elle est orientée flux, bloquante, et mappée étroitement sur les concepts E/S du système d’exploitation.

Même si des API plus récentes existent, `java.io` reste fondamentale: beaucoup d’API de niveau supérieur s’appuient dessus, et elle est encore très utilisée.

### 35.1.1 L’abstraction de flux

Un `stream` représente un flux continu de données entre une source et une destination.

Dans `java.io`, les flux sont **unidirectionnels**: ils sont soit **d’entrée** soit **de sortie**.

| Flux            | Direction | Unité de données   | Catégorie             |
|----------------|----------|--------------------|-----------------------|
| `InputStream`  | Entrée    | Octets (8-bit)     | Flux d’octets         |
| `OutputStream` | Sortie    | Octets (8-bit)     | Flux d’octets         |
| `Reader`       | Entrée    | Caractères         | Flux de caractères    |
| `Writer`       | Sortie    | Caractères         | Flux de caractères    |

Les `stream` masquent l’origine concrète des données (fichier, réseau, mémoire) et exposent une interface uniforme de lecture/écriture.

### 35.1.2 Chaînage des flux et pattern Décorateur

La plupart des flux java.io sont conçus pour être combinés.

Chaque wrapper ajoute un comportement sans changer la source de données sous-jacente.

```java
InputStream in =
	new BufferedInputStream(
		new FileInputStream("data.bin"));
```

Dans cet exemple:
- `FileInputStream` effectue l’accès réel au fichier
- `BufferedInputStream` ajoute un buffer en mémoire

!!! note
    Cette conception est connue comme **Decorator Pattern**.
    
    Elle permet de stratifier des fonctionnalités de manière dynamique.

### 35.1.3 E/S bloquantes: ce que cela signifie

Tous les flux legacy `java.io` sont **bloquants**.

Cela signifie qu’un thread qui effectue des E/S peut être suspendu par le système d’exploitation.

Par exemple, quand tu appelles `read()`:
- si des données sont disponibles, elles sont retournées tout de suite
- s’il n’y a pas de données, le thread attend
- si on atteint la fin du flux, -1 est retourné

!!! note
    Le comportement bloquant simplifie la programmation, mais limite la scalabilité.

### 35.1.4 Gestion des ressources: `close()`, `flush()` et pourquoi ils existent

Les flux encapsulent souvent des ressources natives du système d’exploitation
comme `file descriptor` ou des handles de socket.

Ces ressources sont limitées et doivent être libérées explicitement.

| Méthode | Objectif |
| --- | --- |
| `flush()` | Écrit les données bufferisées vers la destination |
| `close()` | Effectue flush et libère la ressource |

```java
try (OutputStream out = new FileOutputStream("file.bin")) {
	out.write(42);
} // close() appelé automatiquement
```

!!! note
    Ne pas fermer les flux peut causer une perte de données ou un épuisement des ressources.

### 35.1.5 `finalize()`: pourquoi il existe et pourquoi il échoue

Les premières versions de Java ont tenté d’automatiser le nettoyage des ressources en utilisant la finalisation.

La méthode `finalize()` était appelée par le garbage collector avant de récupérer la mémoire.

Cependant, les temps du GC sont imprévisibles.

| Aspect           | finalize()        |
|-----------------|-------------------|
| Temps d’exécution | Non spécifié     |
| Fiabilité        | Faible            |
| État actuel       | Déprécié          |

!!! note
    `finalize()` ne doit jamais être utilisé pour le nettoyage E/S; il est déprécié et non sûr.

### 35.1.6 `available()`: objectif et abus

`available()` estime combien d’octets peuvent être lus sans bloquer.

Il n’indique pas la quantité totale de données restantes.

Cas d’usage typiques:
- éviter des blocages en UI ou parsing de protocoles
- dimensionner des buffers temporaires

```java
if (in.available() > 0) {
	in.read(buffer);
}
```

!!! note
    `available()` ne doit pas être utilisé pour détecter EOF.
    Seul `read()`, qui retourne -1, signale la fin du flux.

### 35.1.7 `mark()` et `reset()`: backtracking contrôlé

Certains flux d’entrée permettent de marquer une position
et d’y revenir ensuite.

```java
BufferedInputStream in = new BufferedInputStream(...);
in.mark(1024);
// read ahead
in.reset();
```

| Flux | markSupported() |
| --- | --- |
| `FileInputStream` | Non |
| `BufferedInputStream` | Oui |
| `ByteArrayInputStream` | Oui |

### 35.1.8 Reader, Writer et encodage des caractères

`Reader` et `Writer` opèrent sur des `caractères`, pas sur des octets.

Cela requiert un `encodage des caractères` (charset).

Si tu ne spécifies pas un charset, celui par défaut de la plateforme est utilisé.

```java
new FileReader("file.txt"); // encodage par défaut de la plateforme
```

!!! note
    S’appuyer sur le charset par défaut mène à des bugs de non-portabilité.
    
    Spécifie toujours un charset explicitement.

### 35.1.9 File vs FileDescriptor

`File` représente un `chemin` dans le filesystem.

Il ne représente pas une ressource ouverte.

`FileDescriptor` représente un handle natif du SE vers un fichier ou un flux ouvert.

| Classe            | Représente              | Possède handle OS? |
|------------------|--------------------------|--------------------|
| `File`           | Chemin filesystem        | Non                |
| `FileDescriptor` | Handle fichier natif OS  | Oui                |

!!! note
    Plusieurs flux peuvent partager le même FileDescriptor.
    
    En en fermant un, on ferme la ressource sous-jacente pour tous.

---

## 35.2 `java.nio` — Buffer, Channel et E/S non bloquantes

L’API `java.nio` (New I/O) a été introduite pour résoudre les limites de `java.io`.

Elle offre un modèle E/S de plus bas niveau et plus explicite, qui mappe bien sur les systèmes d’exploitation modernes.

À la base, `java.nio` tourne autour de trois concepts:
- `Buffer` — conteneurs de mémoire explicites
- `Channel` — connexions de données bidirectionnelles
- `Selector` — multiplexage de lE/S non bloquante

### 35.2.1 Des flux aux buffers: un changement conceptuel

Les flux legacy masquent la gestion de la mémoire au programmeur.

Au contraire, `NIO` rend la mémoire explicite via les buffers.

| Aspect        | java.io                      | java.nio                                   |
|--------------|------------------------------|--------------------------------------------|
| Modèle de données | Basé sur flux (push)     | Basé sur buffer (pull depuis les buffers)  |
| Mémoire       | Cachée dans les flux         | Explicite via buffer                        |
| Contrôle      | Simple, peu granulaire       | Plus granulaire et configurable             |

Avec NIO, l’application contrôle quand les données sont lues en mémoire et comment elles sont consommées.

### 35.2.2 Buffer: objectif et structure

Un `buffer` est un conteneur typé de taille fixe.

Toutes les opérations E/S NIO lisent depuis ou écrivent sur des buffers.

Le buffer le plus commun est `ByteBuffer`.

```java
ByteBuffer buffer = ByteBuffer.allocate(1024);
```

| Propriété | Signification |
| --- | --- |
| `capacity` | Taille totale du buffer |
| `position` | Index courant de lecture/écriture |
| `limit` | Limite des données lisibles ou inscriptibles |

### 35.2.3 Cycle de vie du buffer: Write → Flip → Read

Les `buffer` ont un cycle d’usage rigoureux.

Le comprendre mal est une source commune de bugs.

Séquence typique:
- écris les données dans le buffer
- `flip()` pour passer en mode lecture
- lis les données du buffer
- `clear()` ou `compact()` pour le réutiliser

```java
ByteBuffer buffer = ByteBuffer.allocate(16);

buffer.put((byte) 1);
buffer.put((byte) 2);

buffer.flip(); // passe en mode lecture

while (buffer.hasRemaining()) {
	byte b = buffer.get();
}

buffer.clear(); // prêt à écrire de nouveau
```

!!! note
    `flip()` n’efface pas les données: il règle position et limit.

### 35.2.4 `clear()` vs `compact()`

Après la lecture, un buffer peut être réutilisé de deux manières.

| Méthode | Comportement |
| --- | --- |
| `clear()` | Jette les données non lues |
| `compact()` | Préserve les données non lues |

`compact()` est utile dans les protocoles streaming où dans le buffer peuvent rester des messages partiels.

### 35.2.5 Heap buffers vs Direct buffers

Les buffers peuvent être alloués dans deux régions de mémoire différentes.

```java
ByteBuffer heap = ByteBuffer.allocate(1024);
ByteBuffer direct = ByteBuffer.allocateDirect(1024);
```

| Type      | Position mémoire | Caractéristiques |
|-----------|-------------------|------------------|
| `Heap`    | Heap JVM          | GC, économique à allouer |
| `Direct`  | Mémoire native    | Meilleur throughput E/S, plus coûteux à allouer |

!!! note
    Les direct buffer réduisent les copies entre JVM et OS, mais doivent être utilisés avec attention pour éviter une pression mémoire.

### 35.2.6 Channel: ce que c’est

Un `channel` représente une connexion vers une entité E/S
comme fichier, socket ou device.

À la différence des flux, **les channel sont bidirectionnels**.

| Channel             | Type | Objectif                     |
|--------------------|------|------------------------------|
| `FileChannel`      | Fichier | E/S sur fichiers         |
| `SocketChannel`    | TCP  | Networking stream (TCP)      |
| `DatagramChannel`  | UDP  | Networking datagram (UDP)    |

```java
try (FileChannel channel =
	FileChannel.open(Path.of("file.txt"))) {

	ByteBuffer buffer = ByteBuffer.allocate(128);
	channel.read(buffer);
}
```

### 35.2.7 Channel bloquants vs non bloquants

Les channel peuvent opérer en mode bloquant ou non bloquant.

```java
SocketChannel channel = SocketChannel.open();
channel.configureBlocking(false);
```

En mode **non bloquant**:
- `read()` peut retourner tout de suite avec 0 octets
- `write()` peut écrire seulement une partie des données

!!! note
    L’E/S non bloquante déplace la complexité du SE vers l’application.

### 35.2.8 Scatter/Gather E/S

NIO supporte lecture/écriture depuis/vers plusieurs buffers avec une seule opération.

```java
ByteBuffer header = ByteBuffer.allocate(128);
ByteBuffer body = ByteBuffer.allocate(1024);

ByteBuffer[] buffers = { header, body };
channel.read(buffers);
```

Utile pour des protocoles structurés (header + payload).

### 35.2.9 Selector: multiplexage de lE/S non bloquante

Les `Selector` permettent à un seul thread de monitorer plusieurs channel.

Ils sont la base des serveurs scalables.

| Composant        | Rôle |
|-----------------|------|
| `Selector`       | Monitore plusieurs channel |
| `SelectionKey`   | Représente enregistrement et état du channel |
| `Interest set`   | Opérations observées (read, write, etc.) |

### 35.2.10 Quand utiliser `java.nio`

`NIO` est adapté quand:
- il faut une haute concurrence
- il te faut un contrôle fin sur la mémoire
- tu implémentes des protocoles ou des serveurs

Pour des opérations simples sur fichiers, souvent `java.nio.file.Files` suffit.

---

## 35.3 `java.nio.file` (NIO.2) — Opérations sur fichiers et répertoires (Legacy vs Moderne)

Cette section se concentre sur les opérations pratiques sur fichiers et répertoires.

Nous comparons les approches legacy (java.io.File + flux java.io) avec celles modernes NIO.2 (Path + Files).

L’objectif n’est pas seulement de connaître les noms des méthodes, mais de comprendre:
- ce que fait vraiment chaque méthode
- ce qu’elle retourne et comment elle signale les erreurs
- quels pièges existent (race condition, liens, permissions, portabilité)
- quand une méthode de Files est une amélioration sûre par rapport à l’ancienne approche

### 35.3.1 Vérifications d’existence et d’accessibilité

Une opération très commune est de vérifier si un fichier existe et s’il est accessible (lecture, écriture, exécution).

À la fois l’API legacy (java.io.File) et NIO.2 (java.nio.file.Files) fournissent des méthodes pour ces vérifications.

Il est toutefois important de comprendre que ces vérifications sont volontairement imprécises dans les deux API.

Ce sont des indices best-effort, pas des garanties fiables.

#### 35.3.1.1 API legacy (File)

```java
File f = new File("data.txt");

boolean exists = f.exists();
boolean canRead = f.canRead();
boolean canWrite = f.canWrite();
boolean canExec = f.canExecute();
```

Ces méthodes retournent boolean et n’expliquent pas pourquoi une opération a échoué.

Par exemple, exists() peut retourner false quand:
- le fichier n’existe vraiment pas
- le fichier existe mais l’accès est refusé
- un lien symbolique est cassé
- une erreur E/S se produit

L’API ne permet pas de distinguer les cas.

#### 35.3.1.2 API moderne (Files)

```java
Path p = Path.of("data.txt");

boolean exists = Files.exists(p);
boolean readable = Files.isReadable(p);
boolean writable = Files.isWritable(p);
boolean executable = Files.isExecutable(p);
```

Ces méthodes aussi retournent boolean et masquent la raison de l’éventuel insuccès.

NIO.2 ajoute une méthode explicite pour exprimer l’incertitude:

```java
boolean notExists = Files.notExists(p);
```

!!! note
    `exists()` et `notExists()` peuvent être tous deux `false` quand l’état n’est pas déterminable (par exemple à cause de permissions).

Cela ne rend pas la vérification plus précise: cela rend seulement l’incertitude explicite.

##### 35.3.1.2.1 Conscience des liens symboliques (amélioration réelle)

Une vraie amélioration de NIO.2 est le contrôle sur comment gérer les liens symboliques:

```java
Files.exists(p, LinkOption.NOFOLLOW_LINKS);
```

La classe File legacy ne distingue pas de manière fiable:
- fichier manquant
- lien symbolique cassé
- lien vers target inaccessible

NIO.2 permet des check link-aware et une inspection explicite des liens.

##### 35.3.1.2.2 Pattern d’usage correct (critique)

Aucune des deux API ne donne de diagnostics fiables via boolean “de check”.

Le code NIO.2 correct ne “contrôle pas avant”.

À la place il tente l’opération et gère l’exception:

```java
try {
    Files.delete(p);
} catch (NoSuchFileException e) {
    // le fichier n’existe vraiment pas
} catch (AccessDeniedException e) {
    // problème de permissions
} catch (IOException e) {
    // autre erreur E/S
}
```

!!! note
    Le vrai avantage de NIO.2 est le diagnostic via exceptions pendant les actions, pas des check d’existence plus “précis”.

##### 35.3.1.2.3 Tableau récapitulatif

| Objectif             | Legacy (File)                   | Moderne (Files)                         | Détail clé |
|---------------------|----------------------------------|------------------------------------------|------------|
| Vérifier existence  | `exists()`                       | `exists() / notExists()`                 | notExists() peut être false si l’état n’est pas déterminable |
| Vérifier read/write | `canRead() / canWrite()`         | `isReadable() / isWritable()`            | Files peut utiliser LinkOption.NOFOLLOW_LINKS quand supporté |
| Détails erreur      | Non disponibles                  | Disponibles via exceptions sur les actions | Les check boolean n’expliquent pas le motif de l’échec |


### 35.3.2 Création de fichiers et de répertoires

La création est une grande faiblesse du File legacy.

Dans le legacy on utilise souvent createNewFile() et mkdir/mkdirs(), qui retournent boolean et donnent peu d’infos diagnostiques.

#### 35.3.2.1 API legacy (File)

```java
File f = new File("a.txt");
boolean created = f.createNewFile(); // peut lancer IOException

File dir = new File("dir");
boolean ok1 = dir.mkdir();
boolean ok2 = new File("a/b/c").mkdirs();
```

`mkdir()` crée un seul niveau; `mkdirs()` crée aussi les parents.

Les deux retournent false en cas d’échec mais sans dire pourquoi.

#### 35.3.2.2 API moderne (Files)

```java
Path file = Path.of("a.txt");
Files.createFile(file);

Path dir1 = Path.of("dir");
Files.createDirectory(dir1);

Path dirDeep = Path.of("a/b/c");
Files.createDirectories(dirDeep);
```

!!! note
    `Files.createFile` lance `FileAlreadyExistsException` si le fichier existe.
    
    Souvent il est préférable aux check boolean parce qu’il est race-safe.

| Objectif          | Legacy (File)          | Moderne (Files)               | Détail clé |
|------------------|-------------------------|-------------------------------|------------|
| Créer fichier    | `createNewFile()`       | `createFile()`                | NIO lance FileAlreadyExistsException s’il existe |
| Créer répertoire | `mkdir()`               | `createDirectory()`           | NIO lance des exceptions détaillées |
| Créer parents    | `mkdirs()`              | `createDirectories()`         | Atomicité non garantie pour répertoires profonds |

### 35.3.3 Suppression de fichiers et de répertoires

La sémantique de delete diffère beaucoup entre legacy et NIO.2.

Le legacy `delete()` retourne boolean; NIO.2 offre des méthodes qui lancent des exceptions significatives.

#### 35.3.3.1 API legacy (File)

```java
File f = new File("a.txt");
boolean deleted = f.delete();
```

S’il échoue (permissions, fichier manquant, répertoire non vide), `delete()` retourne souvent false sans détails.

#### 35.3.3.2 API moderne (Files)

```java
Files.delete(Path.of("a.txt"));
```

Pour “supprime si présent”, utilise `deleteIfExists()`.

```java
Files.deleteIfExists(Path.of("a.txt"));
```

| Objectif            | Legacy (File)             | Moderne (Files)           | Détail clé |
|--------------------|----------------------------|----------------------------|------------|
| Supprimer          | `delete()`                 | `delete()`                 | `Files.delete()` lance exception avec la cause de l’échec |
| Supprimer si existe| `exists() + delete()`      | `deleteIfExists()`         | Évite race TOCTOU (check-then-act) |

### 35.3.4 Copie de fichiers et de répertoires

Dans le legacy, copier requiert typiquement lecture/écriture manuelle via flux.

NIO.2 fournit des opérations de copie de haut niveau avec options.

#### 35.3.4.1 Technique legacy (flux manuels)

```java
try (InputStream in = new FileInputStream("src.bin"); OutputStream out = new FileOutputStream("dst.bin")) {

	byte[] buf = new byte[8192];
	int n;
	while ((n = in.read(buf)) != -1) {
		out.write(buf, 0, n);
	}
}
```

C’est verbeux et c’est facile de se tromper (absence de buffering, fermeture, etc.).

#### 35.3.4.2 API moderne (Files.copy)

```java
Files.copy(Path.of("src.bin"), Path.of("dst.bin"));
```

Le comportement est contrôlable avec options.

```java
Files.copy(
	Path.of("src.bin"),
	Path.of("dst.bin"),
	StandardCopyOption.REPLACE_EXISTING,
	StandardCopyOption.COPY_ATTRIBUTES
);
```

!!! note
    `Files.copy` lance FileAlreadyExistsException par défaut.
    
    Utilise `REPLACE_EXISTING` quand l’overwrite est intentionnel.

| Objectif          | Approche legacy            | Moderne (Files)                           | Détail clé |
|------------------|-----------------------------|-------------------------------------------|------------|
| Copier fichier    | Boucle flux manuelle        | `Files.copy(Path, Path, …)`               | Options: `REPLACE_EXISTING`, `COPY_ATTRIBUTES` |
| Copier flux       | InputStream/OutputStream    | `Files.copy(InputStream, Path, …)`        | Utile pour upload/download et piping |
| Copier répertoire | Récursion manuelle          | `walkFileTree + Files.copy`               | Aucun one-liner pour copy complète d’arbre |

### 35.3.5 Déplacement et renommage

Le renommage legacy utilise souvent `File.renameTo()`, notoirement peu fiable et dépendant de la plateforme.

NIO.2 fournit `Files.move()` avec sémantique précise et options.

#### 35.3.5.1 API legacy

```java
boolean ok = new File("a.txt").renameTo(new File("b.txt"));
```

`renameTo()` retourne false sans explication, et peut échouer entre filesystem.

#### 35.3.5.2 API moderne

```java
Files.move(Path.of("a.txt"), Path.of("b.txt"));
```

Les options rendent le comportement explicite.

```java
Files.move(
	Path.of("a.txt"),
	Path.of("b.txt"),
	StandardCopyOption.REPLACE_EXISTING,
	StandardCopyOption.ATOMIC_MOVE
);
```

!!! note
    ATOMIC_MOVE est garanti seulement si le déplacement arrive dans le même filesystem.
    Sinon une exception est lancée.

| Objectif         | Legacy (File)   | Moderne (Files)              | Détail clé |
|-----------------|------------------|------------------------------|------------|
| Renommage / move | `renameTo()`     | `move()`                     | Exceptions + options explicites |
| Move atomique    | Non supporté     | `move(…, ATOMIC_MOVE)`       | Garanti seulement même filesystem |
| Replace existing | Non explicite    | `REPLACE_EXISTING`           | Intention d’overwrite explicite |

### 35.3.6 Lecture et écriture de texte et d’octets (améliorations de Files)

Une grande amélioration de NIO.2 est la classe utilitaire `Files`, avec des méthodes de haut niveau pour lecture/écriture communes.

Elle réduit le boilerplate et améliore la justesse.

#### 35.3.6.1 Lecture/écriture texte legacy

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

Ces classes legacy utilisent souvent le charset par défaut si on n’utilise pas un bridge explicite.

#### 35.3.6.2 Lecture/écriture texte moderne

```java
List<String> lines = Files.readAllLines(Path.of("file.txt"), StandardCharsets.UTF_8);
Files.write(Path.of("file.txt"), lines, StandardCharsets.UTF_8);

Files.lines(Path.of("file.txt")).forEach(System.out::println);

String string = Files.readString(Path.of("file.txt"));
Files.writeString(Path.of("file.txt"), string);
```

#### 35.3.6.3 Lecture/écriture binaire moderne

```java
byte[] data = Files.readAllBytes(Path.of("data.bin"));
Files.write(Path.of("out.bin"), data);
```

!!! important
    `readAllBytes` et `readAllLines` chargent tout en mémoire.
    
    Utilise `Files.lines()` (lazy) ou, pour de gros fichiers, préfère des API streaming comme newBufferedReader/newInputStream.

| Tâche              | Méthode legacy                     | Méthode NIO.2 Files                      | Détail clé |
|-------------------|------------------------------------|------------------------------------------|------------|
| Lire tous les octets | Boucle InputStream manuelle      | `readAllBytes()`                         | Charge tout en mémoire |
| Lire toutes les lignes | Boucle BufferedReader          | `readAllLines()`                         | Charge tout en mémoire |
| Lire lignes lazy  | Boucle BufferedReader              | `lines()`                                | Lazy, stream à fermer |
| Écrire octets     | OutputStream                        | `write(Path, byte[])`                    | Concis |
| Écrire lignes     | Boucle BufferedWriter               | `write(Path, Iterable, …)`               | Charset spécifiable |
| Append texte      | FileWriter(true)                    | `write(…, APPEND)`                       | Options explicites |

### 35.3.7 newInputStream/newOutputStream et newBufferedReader/newBufferedWriter

Ces `factory method` créent des flux/reader à partir d’un Path.

Ils sont le bridge recommandé entre streaming classique et gestion Path NIO.2.

```java
try (InputStream in = Files.newInputStream(Path.of("a.bin"))) { }
try (OutputStream out = Files.newOutputStream(Path.of("b.bin"))) { }
```

```java
try (BufferedReader r = Files.newBufferedReader(Path.of("t.txt"), StandardCharsets.UTF_8)) { }
try (BufferedWriter w = Files.newBufferedWriter(Path.of("t.txt"), StandardCharsets.UTF_8)) { }
```

### 35.3.8 Listing de répertoires et traversée d’arbres

Dans le legacy, le listing de répertoires se base sur `File.list()` et `File.listFiles()`.

Ces méthodes retournent des array et offrent peu de diagnostics.

#### 35.3.8.1 Listing legacy

```java
File dir = new File(".");
File[] children = dir.listFiles();
```

NIO.2 offre plus d’approches selon le besoin.

#### 35.3.8.2 Listing moderne (DirectoryStream)

```java
try (DirectoryStream<Path> ds = Files.newDirectoryStream(Path.of("."))) {
	for (Path p : ds) {
		System.out.println(p);
	}
}
```

#### 35.3.8.3 Walking moderne (Files.walk)

```java
Files.walk(Path.of("."))
	.filter(Files::isRegularFile)
	.forEach(System.out::println);
```

!!! note
    `Files.walk` retourne un Stream qui doit être fermé.
    Utilise `try-with-resources`.

```java
try (Stream<Path> s = Files.walk(Path.of("."))) {
	s.forEach(System.out::println);
}
```

#### 35.3.8.4 Traversal avec FileVisitor

Pour un contrôle complet (skip subtree, gestion erreurs, follow link), utilise `walkFileTree + FileVisitor`.

```java
Files.walkFileTree(Path.of("."), new SimpleFileVisitor<>() {
	@Override
	public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) {
		System.out.println(file);
		return FileVisitResult.CONTINUE;
	}
});
```

| Objectif      | Legacy                   | Moderne                          | Détail clé |
|--------------|--------------------------|----------------------------------|------------|
| Listing dir  | `list()` / `listFiles()` | `newDirectoryStream()`           | Lazy, doit être fermé |
| Walk tree (simple) | Récursion manuelle  | `walk()` (Stream)                | Stream doit être fermé |
| Walk tree (contrôle) | Récursion manuelle| `walkFileTree()`                 | Contrôle fin et gestion erreurs |

### 35.3.9 Recherche et filtre

La recherche est typiquement `traversal + filtre`.

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

### 35.3.10 Attributs: lecture, écriture et view

Le File legacy expose peu d’attributs (size, lastModified).

NIO.2 supporte des metadata riches via attribute view.

#### 35.3.10.1 Attributs legacy

```java
long size = new File("a.txt").length();
long lm = new File("a.txt").lastModified();
```

#### 35.3.10.2 Attributs modernes

```java
BasicFileAttributes a =
	Files.readAttributes(Path.of("a.txt"), BasicFileAttributes.class);

long size = a.size();
FileTime modified = a.lastModifiedTime();
```

Accès via noms string-based:

```java
Object v = Files.getAttribute(Path.of("a.txt"), "basic:size");
Files.setAttribute(Path.of("a.txt"), "basic:lastModifiedTime", FileTime.fromMillis(0));
```

!!! note
    Les attribute view dépendent du filesystem.
    
    Les attributs non supportés génèrent des exceptions.

### 35.3.11 Liens symboliques et follow des liens

NIO.2 peut détecter et lire des liens symboliques de manière explicite.

```java
Path link = Path.of("mylink");
boolean isLink = Files.isSymbolicLink(link);

if (isLink) {
	Path target = Files.readSymbolicLink(link);
}
```

Beaucoup de méthodes suivent les liens par défaut.

Pour l’éviter, passe `LinkOption.NOFOLLOW_LINKS` quand supporté.

### 35.3.12 Synthèse: pourquoi Files est une amélioration

La classe utilitaire `Files` améliore la programmation filesystem parce que:
- réduit le boilerplate (copy/move/read/write)
- fournit des options explicites (overwrite, atomic move, follow links)
- offre des metadata plus riches (attributes/views)
- supporte traversal et recherche scalables

Les API legacy restent surtout pour compatibilité ou quand requises par des librairies legacy.

---

## 35.4 Sérialisation — Object stream, compatibilité et pièges

La sérialisation est le processus de convertir un graphe d’objets en un flux d’octets pour le mémoriser ou le transmettre, et le reconstruire ensuite.

En Java, la sérialisation classique est implémentée par `java.io.ObjectOutputStream` et `java.io.ObjectInputStream`.

Ce sujet est important parce qu’il combine:
- flux E/S et graphes d’objets
- versioning et backward compatibility
- considérations de sécurité et pattern d’usage sûrs
- règles du langage (`transient`, static, `serialVersionUID`)

### 35.4.1 Ce que fait la sérialisation (et ce qu’elle ne fait pas)

Quand un objet est sérialisé, Java écrit des informations suffisantes pour le reconstruire:
- nom de la classe
- serialVersionUID
- valeurs des champs d’instance sérialisables
- références entre objets (identité)

La sérialisation n’inclut pas automatiquement:
- champs static (état de classe)
- champs transient (exclus explicitement)
- objets référencés non sérialisables (à moins de gestion spéciale)

### 35.4.2 Les deux principales marker interface

La sérialisation Java est activée en implémentant une de ces interfaces.

| Interface         | Signification                                   | Niveau de contrôle |
|------------------|--------------------------------------------------|--------------------|
| `Serializable`   | Marker opt-in, mécanisme par défaut              | Moyen (hook possibles) |
| `Externalizable` | Requiert implémentation manuelle read/write      | Haut (contrôle total sur le format) |

!!! note
    `Serializable` n’a pas de méthodes: c’est une marker interface.
    
    `Externalizable` étend Serializable et ajoute readExternal/writeExternal.

### 35.4.3 Exemple de base: écrire et lire un objet

Pattern minimal utilisé en pratique.

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
    `readObject()` retourne Object: un cast est nécessaire.
    `readObject()` peut lancer ClassNotFoundException.

### 35.4.4 Graphes d’objets, références et identité

La sérialisation préserve l’identité des objets à l’intérieur du même flux.

Si la même référence apparaît plusieurs fois, Java l’écrit une seule fois puis écrit une back-reference.

```java
Person p = new Person("Bob", 40);
Object[] arr = { p, p }; // même référence deux fois

out.writeObject(arr);
Object[] restored = (Object[]) in.readObject();

// restored[0] et restored[1] pointent vers le même objet
```

!!! note
    Cela prévient la récursion infinie dans des graphes cycliques.

### 35.4.5 `serialVersionUID`: la clé de versioning

`serialVersionUID` est un identifiant `long` utilisé pour vérifier la compatibilité entre flux sérialisé et définition de la classe.

Si l’UID diffère, la désérialisation échoue typiquement avec InvalidClassException.

Si tu ne déclares pas `serialVersionUID`, la JVM en calcule un depuis la structure de la classe: de petites modifications peuvent le compromettre.

```java
class Person implements Serializable {

	private static final long serialVersionUID = 1L;

	private String name;
	private int age;
}
```

| Type de modification | Impact compatibilité (par défaut) |
|---|---|
| Ajouter un champ | Souvent compatible (champ nouveau avec défaut) |
| Supprimer un champ | Souvent compatible (champ manquant ignoré) |
| Changer type de champ | Souvent incompatible |
| Changer nom/paquet | Incompatible |
| Changer serialVersionUID | Incompatible |

!!! note
    Déclarer un serialVersionUID stable est la manière standard de contrôler la compatibilité.

### 35.4.6 Champs `transient` et `static`

Les champs `transient` sont exclus de la sérialisation.

À la désérialisation, les champs transient prennent des valeurs par défaut (0, false, null) sauf restauration manuelle.

Les champs `static` appartiennent à la classe, pas à l’instance, donc ils ne sont pas sérialisés.

```java
class Session implements Serializable {

	private static final long serialVersionUID = 1L;

	static int counter = 0;      // non sérialisé
	transient String token;      // non sérialisé
	String user;                 // sérialisé
}
```

!!! note
    Si un transient est nécessaire après la désérialisation, il doit être recalculé ou restauré manuellement.

### 35.4.7 Champs non sérialisables et NotSerializableException

Si un objet contient un champ dont le type n’est pas sérialisable, la sérialisation échoue avec NotSerializableException.

```java
class Holder implements Serializable {

	private static final long serialVersionUID = 1L;

	private Thread t; // Thread n’est pas sérialisable
}
```

Solutions typiques:
- marquer le champ transient
- le remplacer par une représentation sérialisable
- utiliser des hook de sérialisation custom

### 35.4.8 Constructeurs et sérialisation

Le comportement des constructeurs en désérialisation est une source fréquente de confusion.

Java restaure l’état principalement depuis le flux d’octets, sans exécuter les constructeurs.

#### 35.4.8.1 Règle: les constructeurs des classes Serializable NE sont pas appelés

Pendant la désérialisation d’une classe Serializable, ses constructeurs NE sont pas exécutés.

L’instance est créée sans appeler ces constructeurs et les champs sont injectés depuis le flux.

!!! note
    Pour cela les constructeurs des classes Serializable ne doivent pas contenir une logique d’initialisation essentielle: elle ne serait pas exécutée en désérialisation.

#### 35.4.8.2 Règle d’héritage: la première superclass non-Serializable est appelée

Si une classe Serializable a une superclasse non Serializable, la désérialisation doit initialiser cette partie.

Donc Java appelle **le constructeur no-arg de la première superclasse non-Serializable**.

Implications:
- la superclasse non Serializable doit avoir un no-arg accessible
- les sous-classes Serializable sautent les constructeurs, les superclasses non Serializable non

#### 35.4.8.3 Tableau: quels constructeurs sont exécutés

| Type de classe | Constructeur appelé en désérialisation |
|---|---|
| Classe Serializable | Non |
| Sous-classe Serializable | Non |
| Première superclasse non Serializable | Oui (no-arg) |
| Classe Externalizable | Oui (public no-arg requis) |

#### 35.4.8.4 Exemple: quels constructeurs sont appelés

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

Output attendu et explication  
Pendant la construction normale (new C()):

```text
A constructor
B constructor
C constructor
```

Pendant la désérialisation (readObject):

```text
A constructor
```

Explication:
- C est Serializable → C() n’est pas appelé
- B est Serializable → B() n’est pas appelé
- A n’est pas Serializable → A() est appelé (no-arg)
- Les champs de B et C sont restaurés depuis le flux

!!! note
    Si la première superclasse non-Serializable n’a pas un no-arg accessible, la désérialisation échoue.

### 35.4.9 Hook de sérialisation custom: `writeObject` et `readObject`

Les hook custom servent quand la sérialisation par défaut ne suffit pas (état transient, champs dérivés, chiffrement, validation, compatibilité).

Ils sont avancés mais importants pour une désérialisation correcte.

#### 35.4.9.1 Pourquoi la sérialisation custom existe

Par défaut, Java sérialise automatiquement tous les champs d’instance non static et non transient.

C’est commode, mais cela ne couvre pas des besoins fréquents.

Motifs typiques:
- un champ ne doit pas être sauvegardé directement (données sensibles)
- un champ est dérivé/cache et doit être recalculé
- validation en lecture est nécessaire (refuser un état invalide)
- logique de backward/forward compatibility est nécessaire
- un objet référencé n’est pas Serializable et doit être géré

#### 35.4.9.2 Ce que sont vraiment `writeObject` et `readObject`

Pour personnaliser sérialisation/désérialisation, une classe peut définir deux méthodes privées spéciales appelées `writeObject` et `readObject`.

Ce ne sont pas des override de méthodes d’interfaces ou de superclass: elles ne font pas partie du flux normal du programme.

Tu ne les appelles jamais toi.

Le framework de sérialisation (ObjectOutputStream/ObjectInputStream) les identifie via reflection, **seulement** si nom et signature sont exacts, et les invoque automatiquement.

S’ils n’existent pas (ou la signature est mauvaise), la sérialisation par défaut est utilisée.

!!! note
    Si la signature est erronée (visibilité, paramètres, return type, exceptions), le framework ne la reconnaît pas et revient silencieusement au défaut.

#### 35.4.9.3 Signatures requises (exactes)

```java
private void writeObject(ObjectOutputStream out) throws IOException

private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException
```

Contraintes:
- elles doivent être private
- elles doivent retourner void
- les types des paramètres doivent correspondre exactement
- les exceptions doivent être compatibles

#### 35.4.9.4 Ce qui se passe en sérialisation: step-by-step

Quand tu sérialises:

```java
out.writeObject(obj);
```

Mécanisme:
- vérifie Serializable
- cherche un private writeObject(ObjectOutputStream)
- si absent → sérialisation par défaut
- si présent → ton writeObject est appelé

Point clé: à l’intérieur de writeObject, Java n’écrit pas automatiquement les champs “normaux” si tu ne le demandes pas. Pour cela existe:

```java
out.defaultWriteObject();
```

`defaultWriteObject()` signifie: “sérialise les champs sérialisables normaux avec le mécanisme standard”.

Ensuite tu peux écrire des données extra comme tu veux.

#### 35.4.9.5 Pattern typique et règle de l’ordre write/read

Pattern typique: utiliser default puis étendre.

L’ordre de lecture doit coïncider avec l’ordre d’écriture.

```java
private void writeObject(ObjectOutputStream out) throws IOException {
	out.defaultWriteObject(); // écrit les champs normaux
	out.writeInt(42);         // écrit des données extra
}

private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException {
	in.defaultReadObject();   // lit les champs normaux
	int x = in.readInt();     // lit les données extra dans le même ordre
}
```

!!! note
    Si tu écris des valeurs extra (int/string/etc.), tu dois les lire dans la même séquence, sinon la désérialisation échoue ou corrompt l’état.

### 35.4.10 Exemple d’usage: restaurer un champ dérivé transient

Cas typique: recalculer une valeur cached transient après désérialisation.

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

		in.defaultReadObject();                 // restaure firstName et lastName
		fullName = firstName + " " + lastName; // recalcule le transient
	}
}
```

### 35.4.11 Externalizable: contrôle total (et responsabilité totale)

Externalizable requiert de définir manuellement comment écrire et lire l’objet.

Il requiert aussi un constructeur public no-arg, parce que la désérialisation instancie d’abord l’objet.

```java
import java.io.*;

class Point implements Externalizable {
	int x;
	int y;

	public Point() { } // requis

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
    Avec Externalizable tu contrôles le format.
    Si tu le changes, tu dois gérer toi la backward compatibility.

### 35.4.12 Considérations de sécurité sur `readObject()`

La désérialisation de données non fiables est dangereuse parce qu’elle peut exécuter du code indirectement via:
- hook readObject
- logique d’initialisation
- gadget chain dans des librairies

Lignes directrices:
- ne désérialise jamais des octets non fiables sans un motif fort
- préférer des formats sûrs (JSON, protobuf) pour des inputs externes
- si obligé, utiliser object filter et validation rigoureuse

### 35.4.13 Pièges communs et conseils pratiques

- Serializable est seulement marker: il ne requiert pas de méthodes
- `readObject` retourne Object et peut lancer ClassNotFoundException
- les champs `static` ne sont jamais sérialisés
- les champs `transient` reviennent à défaut sauf restauration
- sans `serialVersionUID` la compatibilité peut se casser “par surprise”
- Externalizable requiert public no-arg constructor
- NotSerializableException quand un champ référencé n’est pas sérialisable

### 35.4.14 Quand utiliser (ou éviter) la sérialisation Java

Utilise la sérialisation classique surtout pour:
- persistance locale de courte durée avec versions contrôlées
- caching en mémoire quand les deux extrémités sont fiables
- systèmes legacy qui l’utilisent déjà

Évite-la pour:
- protocoles de réseau publics
- stockage à long terme avec schéma évolutif
- inputs non fiables
