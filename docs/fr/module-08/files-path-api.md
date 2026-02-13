# 33. APIs des fichiers et des chemins

### Table des matières

- [33. APIs des fichiers et des chemins](#33-apis-des-fichiers-et-des-chemins)
  - [33.1 File legacy et Path NIO : création et conversion](#331-file-legacy-et-path-nio--création-et-conversion)
    - [33.1.1 Créer un File legacy](#3311-créer-un-file-legacy)
    - [33.1.2 Créer un Path NIO-v2](#3312-créer-un-path-nio-v2)
    - [33.1.3 Absolu vs relatif : ce que signifie relatif](#3313-absolu-vs-relatif--ce-que-signifie-relatif)
    - [33.1.4 Joindre--Construire-des-Paths](#3314-joindre--construire-des-paths)
      - [33.1.4.1 resolve](#33141-resolve)
      - [33.1.4.2 relativize](#33142-relativize)
    - [33.1.5 Convertir entre File et Path](#3315-convertir-entre-file-et-path)
    - [33.1.6 Conversion URI quand-nécessaire](#3316-conversion-uri-quand-nécessaire)
    - [33.1.7 Canonique vs absolu vs normalisé différences-fondamentales](#3317-canonique-vs-absolu-vs-normalisé-différences-fondamentales)
      - [33.1.7.1 normalize](#33171-normalize)
    - [33.1.8 Tableau de comparaison rapide création--conversion](#3318-tableau-de-comparaison-rapide-création--conversion)
  - [33.2 Gérer les fichiers et répertoires : créer-copier-déplacer-remplacer-comparer-supprimer](#332-gérer-les-fichiers-et-répertoires--créer-copier-déplacer-remplacer-comparer-supprimer-legacy-vs-nio)
    - [33.2.1 Modèle mental Path-Locator-vs-Opérations](#3321-modèle-mental--pathlocator-vs-opérations)
    - [33.2.2 Créer des fichiers et des répertoires](#3322-créer-des-fichiers-et-des-répertoires)
      - [33.2.2.1 Créer un fichier](#33221-créer-un-fichier)
      - [33.2.2.2 Créer des répertoires](#33222-créer-des-répertoires)
    - [33.2.3 Copier des fichiers et des répertoires](#3323-copier-des-fichiers-et-des-répertoires)
      - [33.2.3.1 Copier un fichier NIO](#33231-copier-un-fichier-nio)
      - [33.2.3.2 Copie manuelle legacy basée-sur-stream](#33232-copie-manuelle-legacy-basée-sur-stream)
    - [33.2.4 Déplacer--Renommer-et-Remplacer](#3324-déplacer--renommer-et-remplacer)
      - [33.2.4.1 Renommage legacy piège-commun](#33241-renommage-legacy-piège-commun)
      - [33.2.4.2 NIO Move préféré](#33242-nio-move-préféré)
    - [33.2.5 Comparer des paths et des fichiers](#3325-comparer-des-paths-et-des-fichiers)
      - [33.2.5.1 Égalité-vs-Même-fichier](#33251-égalité-vs-même-fichier)
    - [33.2.6 Supprimer des fichiers et des répertoires](#3326-supprimer-des-fichiers-et-des-répertoires)
      - [33.2.6.1 Delete legacy](#33261-delete-legacy)
      - [33.2.6.2 NIO Delete et Delete-If-Exists](#33262-nio-delete-et-delete-if-exists)
    - [33.2.7 Copier--Supprimer-récursivement-des-arbres-de-répertoires pattern-nio](#3327-copier--supprimer-récursivement-des-arbres-de-répertoires-pattern-nio)
    - [33.2.8 Checklist de résumé](#3328-checklist-de-résumé)

---

Cette section se concentre sur la création de localisateurs de système de fichiers en utilisant l’API legacy `java.io.File` et l’API moderne `java.nio.file.Path` : comment convertir entre eux et comprendre les surcharges, les valeurs par défaut et les pièges courants.

## 33.1 `File` legacy et `Path` NIO : création et conversion

### 33.1.1 Créer un `File` (Legacy)

Une instance `File` représente un pathname du système de fichiers (absolu ou relatif).

En créer une n’accède pas au système de fichiers et ne lance pas `IOException`.

Constructeurs principaux (les plus courants) :

- `new File(String pathname)` 
- `new File(String parent, String child)` 
- `new File(File parent, String child)` 
- `new File(URI uri)` (typiquement `file:...`)

```java
import java.io.File;
import java.net.URI;

File f1 = new File("data.txt"); // relatif
File f2 = new File("/tmp", "data.txt"); // parent + enfant
File f3 = new File(new File("/tmp"), "data.txt");

File f4 = new File(URI.create("file:///tmp/data.txt"));
```

!!! note
    - `new File(...)` n’ouvre jamais le fichier.
    - Existence/permissions sont vérifiées seulement lorsque vous appelez des méthodes comme `exists()`, `length()`, ou lorsque vous ouvrez un stream/channel.

### 33.1.2 Créer un `Path` (NIO v.2)

Un `Path` est aussi juste un locator.

Comme `File`, créer un `Path` n’accède pas au système de fichiers.

Factories principales :

- `Path.of(String first, String... more)` (Java 11+)
- `Paths.get(String first, String... more)` (style plus ancien ; toujours valide)
- `Path.of(URI uri)` (ex. `file:///...`)

```java
import java.net.URI;
import java.nio.file.Path;
import java.nio.file.Paths;

Path p1 = Path.of("data.txt"); // relatif
Path p2 = Path.of("/tmp", "data.txt"); // parent + enfant

Path p3 = Paths.get("data.txt"); // style factory legacy
Path p4 = Path.of(URI.create("file:///tmp/data.txt"));
```

!!! note
    - `Path.of(...)` et `Paths.get(...)` sont équivalents pour le système de fichiers par défaut.
    - Préférez `Path.of` dans le code moderne.

### 33.1.3 Absolu vs relatif : ce que signifie “relatif”

`File` et `Path` peuvent être créés comme chemins relatifs.

Les chemins relatifs sont résolus par rapport au répertoire de travail du processus (typiquement `System.getProperty("user.dir")`).

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

!!! note
    Les chemins relatifs sont une source courante de bugs “works on my machine” parce que `user.dir` dépend de la manière/où la JVM a été lancée.

### 33.1.4 Joindre / construire des paths

- Le `File` legacy utilise des constructeurs (parent + enfant).
- NIO utilise `resolve` et des méthodes associées.

| Tâche | Legacy (File) | NIO (Path) |
|------|---------------|------------|
| Joindre parent + enfant | `new File(parent, child)` | `parent.resolve(child)` |
| Joindre plusieurs segments | Constructeurs répétés | `Path.of(a, b, c)` ou `resolve()` chaîné |

```java
import java.io.File;
import java.nio.file.Path;

File f = new File("/tmp", "a.txt");

Path base = Path.of("/tmp");
Path p = base.resolve("a.txt"); // /tmp/a.txt
Path p2 = base.resolve("dir").resolve("a.txt"); // /tmp/dir/a.txt
```

#### 33.1.4.1 `resolve()`

Combine des paths d’une manière filesystem-aware.

- Les paths relatifs sont ajoutés
- Un argument absolu remplace le path de base

!!! note
    `Path.resolve(...)` a une règle : si l’argument est absolu, il retourne l’argument et ignore la base (vous ne pouvez pas combiner deux paths absolus en utilisant `resolve`).

#### 33.1.4.2 `relativize()`

`Path.relativize` calcule un **path relatif** d’un path à un autre. Le path résultant, lorsqu’il est `resolved` contre le path source, donne le path cible.

Autrement dit :

- Il répond à la question : “Comment aller du path A au path B ?”
- Le résultat est toujours un path **relatif**
- Aucun accès au système de fichiers n’a lieu

**Règles fondamentales**

`relativize` a des préconditions strictes. Les violer lance une exception.

| Règle | Explication |
|------|-------------|
| Les deux paths doivent être absolus | ou tous les deux relatifs |
| Les deux paths doivent appartenir au même système de fichiers | même provider |
| Les composants de root doivent correspondre | même root (sur Windows, même drive) |
| Le résultat n’est jamais absolu | toujours relatif |

!!! note
    Si un path est absolu et l’autre relatif, `IllegalArgumentException` est lancée.

**Exemple relatif simple** :

Les deux paths sont relatifs, donc la relativisation est autorisée.

```java
Path p1 = Path.of("docs/manual");
Path p2 = Path.of("docs/images/logo.png");

Path relative = p1.relativize(p2);
System.out.println(relative);
```

```bash
../images/logo.png
```

Interprétation : depuis `docs/manual`, monter d’un niveau, puis entrer dans `images/logo.png`.

**Exemple de paths absolus** :

Les paths absolus fonctionnent exactement de la même manière.

```java
Path base = Path.of("/home/user/projects");
Path target = Path.of("/home/user/docs/readme.txt");

Path relative = base.relativize(target);
System.out.println(relative);
```

```bash
../docs/readme.txt
```

**Utiliser `resolve` pour vérifier le résultat**

Une propriété clé de `relativize` est cette identité :

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

**Exemple** : mélanger des paths absolus et relatifs (CAS ERREUR)

C’est l’une des erreurs les plus courantes.

```java
Path abs = Path.of("/a/b");
Path rel = Path.of("c/d");

abs.relativize(rel); // lance une exception
```

```bash
Exception in thread "main" java.lang.IllegalArgumentException
```

!!! note
    `relativize` NE tente PAS de convertir automatiquement des paths en absolus.

**Exemple** : roots différentes (piège spécifique Windows)

Sur Windows, des paths avec des lettres de drive différentes ne peuvent pas être relativisés.

```java
Path p1 = Path.of("C:\\data\\a");
Path p2 = Path.of("D:\\data\\b");

p1.relativize(p2); // IllegalArgumentException
```

!!! note
    Sur les systèmes Unix-like, la root est toujours `/`, donc ce problème ne se produit pas.

### 33.1.5 Convertir entre `File` et `Path`

La conversion est directe et sans perte pour les paths normaux du système de fichiers local.

| Conversion | Comment |
|------------|---------|
| File → Path | `file.toPath()` |
| Path → File | `path.toFile()` |

```java
import java.io.File;
import java.nio.file.Path;

File f = new File("data.txt");
Path p = f.toPath();

File back = p.toFile();
```

!!! note
    La conversion ne valide pas l’existence. Elle convertit seulement des représentations.

### 33.1.6 Conversion URI (quand nécessaire)

Les `URI` sont utiles lorsque les paths doivent être représentés dans une forme standard et absolue (par ex. interopérer avec des ressources réseau ou de la configuration).

Les deux APIs supportent la conversion URI.

| Direction | Legacy (File) | NIO (Path) |
|-----------|----------------|------------|
| Depuis URI | `new File(uri)` | `Path.of(uri)` |
| Vers URI | `file.toURI()` | `path.toUri()` |

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

!!! note
    `new File(URI)` requiert un URI `file:` et lance `IllegalArgumentException` si l’URI n’est pas hiérarchique ou n’est pas un file URI.

### 33.1.7 Canonique vs absolu vs normalisé (différences fondamentales)

Ces termes sont souvent mélangés. Ils ne sont pas identiques.

| Concept        | Legacy (File)                          | NIO (Path)        | Touche le système de fichiers |
|----------------|----------------------------------------|-------------------|-------------------------------|
| Absolu         | `getAbsoluteFile()`                    | `toAbsolutePath()`| Non                           |
| Normalisé      | (pas de normalize pur, utiliser canonical)\* | `normalize()` | `normalize()`: Non            |
| Canonique / Réel | `getCanonicalFile()`                 | `toRealPath()`    | Oui                           |

!!! note
    `File.getCanonicalFile()` et `Path.toRealPath()` peuvent résoudre des symlinks et exigent que le path existe, donc ils peuvent lancer `IOException`.
    
    File ne fournit pas de méthode pour une normalisation purement syntaxique : historiquement beaucoup de développeurs utilisaient getCanonicalFile(), mais ceci accède au système de fichiers et peut échouer.

```java
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;

File f = new File("a/../data.txt");
System.out.println(f.getAbsolutePath()); // absolu, peut encore contenir ".."

try {
	System.out.println(f.getCanonicalPath()); // résout "..", peut toucher le système de fichiers
} catch (IOException e) {
	System.out.println("Canonical failed: " + e.getMessage());
}

Path p = Path.of("a/../data.txt");
System.out.println(p.toAbsolutePath()); // absolu, peut encore contenir ".."
System.out.println(p.normalize()); // purement syntaxique

try {
	System.out.println(p.toRealPath()); // résout symlinks, exige l’existence
} catch (IOException e) {
	System.out.println("RealPath failed: " + e.getMessage());
}
```

#### 33.1.7.1 `normalize()`

Supprime des éléments de nom **redondants** comme `.` et `..`.

- Purement syntaxique
- Ne vérifie pas si le path existe

!!! note
    `normalize()` est purement syntaxique, ne vérifie pas l’existence, et peut produire des paths invalides s’il est mal utilisé.

### 33.1.8 Tableau de comparaison rapide (création + conversion)

| Besoin | Legacy (File) | NIO (Path) | Préféré aujourd’hui |
|------|----------------|------------|---------------------|
| Créer depuis string | `new File("x")` | `Path.of("x")` | Path |
| Parent + enfant | `new File(p, c)` | `Path.of(p, c)` ou `resolve()` | Path |
| Convertir entre APIs | `toPath()` | `toFile()` | Path-centric |
| Normaliser | `getCanonicalFile()` (basé filesystem) | `normalize()` (syntactique seulement) | Path |
| Résoudre symlinks | Canonical | `toRealPath()` | Path |

---

## 33.2 Gérer les fichiers et répertoires : créer, copier, déplacer, remplacer, comparer, supprimer (Legacy vs NIO)

Cette section couvre les opérations que vous effectuez sur des entrées du système de fichiers (fichiers/répertoires) : créer, copier, déplacer/renommer, remplacer, comparer et supprimer.

Elle contraste `java.io.File` legacy (et des helpers legacy associés) avec `java.nio.file` moderne (NIO.2).

### 33.2.1 Modèle mental : “Path/Locator” vs “Opérations”

Les deux APIs utilisent des objets qui représentent un path, mais les opérations diffèrent :

- Legacy : `File` est à la fois un wrapper de path et une API d’opérations (responsabilité mélangée)
- NIO : `Path` est le path ; `Files` effectue les opérations (séparation des préoccupations)

| Responsabilité | Legacy | NIO |
|----------------|--------|-----|
| Représentation du path | `File` | `Path` |
| Opérations sur le système de fichiers | `File` | `Files` |
| Reporting riche des erreurs | Faible (booleans) | Fort (exceptions) |

!!! note
    Les méthodes legacy retournent souvent `boolean` (échec silencieux), tandis que NIO lance `IOException` avec cause.

### 33.2.2 Créer des fichiers et des répertoires

La création est là où l’ancienne API est la plus maladroite et l’API NIO la plus expressive.

| Tâche | Approche legacy | Approche NIO | Notes |
|----------------|--------|-----|--------|
| Créer fichier vide | ouvrir+fermer un stream | `Files.createFile` | NIO échoue si existe |
| Créer un répertoire | `mkdir` | `Files.createDirectory` | Le parent doit exister |
| Créer des répertoires récursivement | `mkdirs` | `Files.createDirectories` | Crée les parents |

#### 33.2.2.1 Créer un fichier

Legacy n’a pas de méthode “créer fichier vide”, donc typiquement vous créez un fichier en ouvrant un output stream (side effect).

```java
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

File f = new File("created-legacy.txt");
try (FileOutputStream out = new FileOutputStream(f)) {
	// le fichier est créé (ou tronqué) comme side effect
}
```

NIO fournit une méthode explicite de création.

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;

Path p = Path.of("created-nio.txt");
Files.createFile(p);
```

!!! note
    `Files.createFile` lance `FileAlreadyExistsException` si l’entrée existe.

#### 33.2.2.2 Créer des répertoires

```java
import java.io.File;

File dir1 = new File("a/b");
boolean ok1 = dir1.mkdir(); // échoue si le parent "a" n’existe pas
boolean ok2 = dir1.mkdirs(); // crée les parents
```

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;

Path d = Path.of("a/b");
Files.createDirectory(d); // le parent doit exister
Files.createDirectories(d); // crée les parents, ok si déjà existe
```

!!! note
    Legacy `mkdir()/mkdirs()` retournent `false` en cas d’échec sans dire pourquoi. NIO lance `IOException`.

### 33.2.3 Copier des fichiers et des répertoires

La copie legacy est généralement une copie manuelle par stream (ou des libs externes). NIO a une opération unique et explicite.

| Capacité | Legacy | NIO |
|--------------|--------|-----|
| Copier contenu de fichier | Streams manuels | `Files.copy` |
| Copier dans une cible existante | Manuel | Option `REPLACE_EXISTING` |
| Copier arbre de répertoires | Récursion manuelle | Récursion manuelle (mais meilleurs outils : `Files.walk` + `Files.copy`) |

#### 33.2.3.1 Copier un fichier (NIO)

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.io.IOException;

Path src = Path.of("src.txt");
Path dst = Path.of("dst.txt");

Files.copy(src, dst); // échoue si dst existe
Files.copy(src, dst, StandardCopyOption.REPLACE_EXISTING);
```

!!! note
    `Files.copy` lance `FileAlreadyExistsException` si la cible existe et que vous n’avez pas utilisé `REPLACE_EXISTING`.

#### 33.2.3.2 Copie manuelle (Legacy, basée sur stream)

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

!!! note
    Rappelez-vous `read(byte[])` retourne le nombre de bytes lus ; vous devez écrire seulement ce compte, pas le buffer entier.

### 33.2.4 Déplacer / renommer et remplacer

Dans les deux APIs, rename/move est “au niveau metadata” quand possible, mais peut se comporter comme copy+delete entre systèmes de fichiers. NIO rend cela explicite via des options.

| Opération | Legacy | NIO |
|-----------|--------|-----|
| Renommer/déplacer | `File.renameTo` | `Files.move` |
| Remplacer existant | Peu fiable | `REPLACE_EXISTING` |
| Déplacement atomique | Non supporté | `ATOMIC_MOVE` (si supporté) |

#### 33.2.4.1 Renommage legacy (piège commun)

```java
import java.io.File;

File from = new File("old.txt");
File to = new File("new.txt");

boolean ok = from.renameTo(to); // peut échouer silencieusement
System.out.println(ok);
```

!!! note
    - `renameTo` est notoirement platform-dependent et retourne seulement `boolean`.
    - Il peut échouer parce que la cible existe, le fichier est ouvert, permissions, ou déplacement cross-filesystem.

#### 33.2.4.2 NIO Move (préféré)

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.io.IOException;

Path from = Path.of("old.txt");
Path to = Path.of("new.txt");

Files.move(from, to); // échoue si la cible existe
Files.move(from, to, StandardCopyOption.REPLACE_EXISTING);
```

!!! note
    `Files.move` lance `FileAlreadyExistsException` quand la cible existe et que `REPLACE_EXISTING` n’est pas spécifié.

### 33.2.5 Comparer des paths et des fichiers

Comparer des locators peut signifier : égalité de string/path, égalité normalisée/canonique, ou “même fichier sur disque”.

Les APIs diffèrent significativement ici.

| Objectif de comparaison | Legacy | NIO |
|-------------------------|--------|-----|
| Même texte de path | `File.equals` | `Path.equals` |
| Normaliser le path | `getCanonicalFile` | `normalize` |
| Même fichier/ressource sur disque | faible (heuristique canonique) | `Files.isSameFile` |

#### 33.2.5.1 Égalité vs même fichier

Deux strings de path différentes peuvent référer au même fichier.

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;

Path p1 = Path.of("a/../data.txt");
Path p2 = Path.of("data.txt");

System.out.println(p1.equals(p2)); // false (texte de path différent)
System.out.println(p1.normalize().equals(p2.normalize())); // peut encore être false si relatif

try {
	System.out.println(Files.isSameFile(p1, p2)); // peut être true, peut lancer si non accessible
} catch (IOException e) {
	System.out.println("isSameFile failed: " + e.getMessage());
}
```

!!! note
    `Files.isSameFile` peut accéder au système de fichiers et peut lancer `IOException` (problèmes de permissions, fichiers manquants, etc.).

### 33.2.6 Supprimer des fichiers et des répertoires

La suppression est simple conceptuellement mais a des edge cases importants : répertoires non vides, cibles manquantes, et différences de reporting d’erreurs.

| Tâche | Legacy | NIO | Comportement si manquant |
|------|--------|-----|--------------------------|
| Supprimer fichier/dir | `File.delete` | `Files.delete` | Legacy false, NIO exception |
| Supprimer si existe | Pas direct (check+delete) | `Files.deleteIfExists` | retourne boolean |
| Supprimer dir non vide | Récursion manuelle | Récursion manuelle (walk) | Les deux exigent récursion |

#### 33.2.6.1 Delete legacy

```java
import java.io.File;

File f = new File("x.txt");
boolean ok = f.delete(); // false si non supprimé
System.out.println(ok);
```

!!! note
    Legacy `delete()` échoue (retourne false) pour un répertoire non vide et souvent ne fournit aucune raison.

#### 33.2.6.2 NIO Delete et Delete-If-Exists

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

!!! note
    Certification tip: `Files.delete` lance `NoSuchFileException` si manquant, tandis que `deleteIfExists` retourne `false`.

### 33.2.7 Copier / supprimer récursivement des arbres de répertoires (pattern NIO)

NIO ne fournit pas une seule méthode “copyTree/deleteTree”, mais l’approche standard utilise `Files.walk` ou `Files.walkFileTree`.

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

!!! note
    Supprimer un arbre de répertoires exige de supprimer d’abord les fichiers, puis les répertoires (post-order). C’est une question de raisonnement courante.

### 33.2.8 Checklist de résumé

- Préférer `Files.createFile/createDirectory/createDirectories` aux workarounds legacy
- `File.renameTo` est peu fiable ; préférer `Files.move` avec options
- `Files.copy/move` lancent `FileAlreadyExistsException` à moins que `REPLACE_EXISTING` soit utilisé
- `Files.delete` lance ; `Files.deleteIfExists` retourne boolean
- `Files.isSameFile` peut lancer `IOException` et peut toucher le système de fichiers
- La suppression de répertoires non vides exige une récursion (les deux APIs)
