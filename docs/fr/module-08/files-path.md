# 32. Fondamentaux des fichiers et des chemins

<a id="table-des-matières"></a>
### Table des matières

- [32. Fondamentaux des fichiers et des chemins](#32-fondamentaux-des-fichiers-et-des-chemins)
  - [32.1 Modèle conceptuel : système de fichiers, fichiers, répertoires, liens et cibles-d’E/S](#321-modèle-conceptuel--système-de-fichiers-fichiers-répertoires-liens-et-cibles-des)
  - [32.2 Système de fichiers – L’abstraction globale](#322-système-de-fichiers--labstraction-globale)
  - [32.3 Chemin – Localiser une entrée dans un système de fichiers](#323-chemin--localiser-une-entrée-dans-un-système-de-fichiers)
  - [32.4 Fichiers – Conteneurs persistants de données](#324-fichiers--conteneurs-persistants-de-données)
  - [32.5 Répertoires – Conteneurs structurels](#325-répertoires--conteneurs-structurels)
  - [32.6 Liens – Mécanismes d’indirection](#326-liens--mécanismes-dindirection)
    - [32.6.1 Liens physiques](#3261-liens-physiques)
    - [32.6.2 Liens symboliques soft](#3262-liens-symboliques-soft)
  - [32.7 Autres types d’entrées du système de fichiers](#327-autres-types-dentrées-du-système-de-fichiers)
  - [32.8 Comment Java IO interagit avec ces concepts](#328-comment-java-io-interagit-avec-ces-concepts)
  - [32.9 Pièges conceptuels fondamentaux](#329-pièges-conceptuels-fondamentaux)
  - [32.10 Pourquoi Path et Files existent (contexte-IO)](#3210-pourquoi-path-et-files-existent-contexte-io)
  - [32.11 File est (API legacy) à la fois un path et une api-d’opérations-sur-fichiers](#3211-file-est-api-legacy-à-la-fois-un-path-et-une-api-dopérations-sur-fichiers)
    - [32.11.1 Ce qu’est vraiment File](#32111-ce-quest-vraiment-file)
    - [32.11.2 Responsabilités de type-Path](#32112-responsabilités-de-type-path)
    - [32.11.3 Responsabilités d’opérations sur le système de fichiers](#32113-responsabilités-dopérations-sur-le-système-de-fichiers)
    - [32.11.4 Ce que File N’EST PAS](#32114-ce-que-file-nest-pas)
    - [32.11.5 L’ancien double rôle](#32115-lancien-double-rôle)
    - [32.11.6 Comment NIO a corrigé cela](#32116-comment-nio-a-corrigé-cela)
    - [32.11.7 Résumé](#32117-résumé)
  - [32.12 Path est une description, pas une ressource](#3212-path-est-une-description-pas-une-ressource)
  - [32.13 Chemins absolus vs relatifs](#3213-chemins-absolus-vs-relatifs)
    - [32.13.1 Chemins absolus](#32131-chemins-absolus)
    - [32.13.2 Chemins relatifs](#32132-chemins-relatifs)
  - [32.14 Connaissance du système de fichiers et séparateurs](#3214-connaissance-du-système-de-fichiers-et-séparateurs)
    - [32.14.1 FileSystem](#32141-filesystem)
    - [32.14.2 Séparateurs de chemin](#32142-séparateurs-de-chemin)
  - [32.15 Ce que Files fait réellement et ce qu’il ne fait pas](#3215-ce-que-files-fait-réellement-et-ce-quil-ne-fait-pas)
    - [32.15.1 Files FAIT](#32151-files-fait)
    - [32.15.2 Files NE FAIT PAS](#32152-files-ne-fait-pas)
  - [32.16 Philosophie de gestion des erreurs : Old-vs-NIO](#3216-philosophie-de-gestion-des-erreurs--old-vs-nio)
  - [32.17 Idées fausses courantes](#3217-idées-fausses-courantes)

---

Cette section se concentre sur `Path`, `File`, `Files` et les classes associées, en expliquant pourquoi elles existent, quels problèmes elles résolvent et quelles sont les différences entre les API legacy `java.io` et `NIO v.2` (nouvelles API d’E/S), avec une attention particulière à la sémantique du système de fichiers, à la résolution des chemins et aux idées fausses courantes.

<a id="321-modèle-conceptuel-système-de-fichiers-fichiers-répertoires-liens-et-cibles-des"></a>
## 32.1 Modèle conceptuel : système de fichiers, fichiers, répertoires, liens et cibles-d’E/S

Avant de comprendre les API d’E/S Java, il est essentiel de comprendre avec quoi elles interagissent.

**Java I/O** n’opère pas dans le vide : il interagit avec des abstractions de système de fichiers fournies par le système d’exploitation.

Cette section définit ces concepts indépendamment de Java, puis explique comment Java I/O les mappe et quels problèmes sont résolus.

---

<a id="322-système-de-fichiers-labstraction-globale"></a>
## 32.2 Système de fichiers – L’abstraction globale

Un `système de fichiers` est un mécanisme structuré fourni par un système d’exploitation pour organiser, stocker, récupérer et gérer des données sur des dispositifs de stockage persistant.

Au niveau conceptuel, un système de fichiers résout plusieurs problèmes fondamentaux :

- Stockage persistant au-delà de l’exécution du programme
- Organisation hiérarchique des données
- Nommer et localiser les données
- Contrôle d’accès et permissions
- Garanties de concurrence et de cohérence

En Java NIO, un système de fichiers est représenté par l’abstraction `FileSystem`, généralement obtenue via `FileSystems.getDefault()` pour le système de fichiers du système d’exploitation.

| Aspect | Signification |
| --- | --- |
| Persistance | Les données survivent à la terminaison de la JVM |
| Portée | Géré par le SE, pas par la JVM |
| Multiplicité | Plusieurs systèmes de fichiers peuvent exister |
| Exemples | Disk FS, ZIP FS, in-memory FS |

!!! note
    Java n’implémente pas de systèmes de fichiers ; il s’adapte aux implémentations fournies par le SE ou par des providers personnalisés.

---

<a id="323-chemin-localiser-une-entrée-dans-un-système-de-fichiers"></a>
## 32.3 Chemin – Localiser une entrée dans un système de fichiers

Un `chemin` est un localisateur logique, pas une ressource.

Il décrit où quelque chose se trouverait dans un système de fichiers, pas ce que c’est ni si cela existe.

Un `chemin` résout le problème de l’`addressing` :

- Identifie un emplacement
- Est interprété dans un système de fichiers spécifique
- Peut ou non correspondre à une entrée existante

| Propriété | Path |
| --- | --- |
| Conscient de l’existence | Non |
| Conscient du type | Non |
| Immuable | Oui |
| Ressource du SE | Non |

!!! note
    En Java, `Path` représente des entrées potentielles du système de fichiers, pas des entrées réelles.

---

<a id="324-fichiers-conteneurs-persistants-de-données"></a>
## 32.4 Fichiers – Conteneurs persistants de données

Un `fichier` est une entrée du système de fichiers dont le rôle principal est de stocker des données.

Le système de fichiers traite les fichiers comme des séquences de bytes opaques.

Problèmes résolus par les fichiers :

- Stockage durable d’informations
- Accès séquentiel et aléatoire aux données
- Partage des données entre processus

Du point de vue du système de fichiers, un fichier a :

- Contenu (bytes)
- Métadonnées (taille, timestamps, permissions)
- Un emplacement (chemin)

| Aspect | Description |
| --- | --- |
| Contenu | Orienté byte |
| Interprétation | Définie par l’application |
| Durée de vie | Indépendante des processus |
| Accès Java | Streams, channels, méthodes de Files |

!!! note
    `Texte` vs `binaire` n’est pas un concept de système de fichiers ; c’est une interprétation au niveau application.

---

<a id="325-répertoires-conteneurs-structurels"></a>
## 32.5 Répertoires – Conteneurs structurels

Un `répertoire (ou dossier)` est une entrée du système de fichiers dont le but est d’organiser d’autres entrées.

Les `répertoires` résolvent le problème de l’évolutivité et de l’organisation :

- Regrouper des entrées liées
- Permettre un nommage hiérarchique
- Supporter une recherche efficace

| Aspect | Répertoire |
| --- | --- |
| Stocke des données | Non (stocke des références) |
| Contient | Fichiers, répertoires, liens |
| Lecture/écriture | Structurelle, pas basée sur le contenu |
| Accès Java | Files.list, Files.walk |

!!! note
    Un répertoire n’est pas un fichier avec du contenu, même si les deux partagent des métadonnées communes.

---

<a id="326-liens-mécanismes-dindirection"></a>
## 32.6 Liens – Mécanismes d’indirection

Un `lien` est une entrée du système de fichiers qui référence une autre entrée.

Les liens résolvent le problème de l’indirection et de la réutilisation.

<a id="3261-liens-physiques"></a>
### 32.6.1 Liens physiques

Un `lien physique` est un nom supplémentaire pour les mêmes données sous-jacentes.

- Plusieurs chemins pointent vers les mêmes données de fichier
- La suppression n’a lieu que lorsque tous les liens sont supprimés

<a id="3262-liens-symboliques-soft"></a>
### 32.6.2 Liens symboliques (Soft)

Un `lien symbolique` est un fichier spécial qui contient un chemin vers une autre entrée :

- Peut pointer vers des cibles inexistantes
- Résolu au moment de l’accès

| Type de lien | Référence | Peut être dangling | Gestion Java |
| --- | --- | --- | --- |
| Physique | Données | Non | Transparent |
| Symbolique | Chemin | Oui | Contrôle explicite |

!!! note
    Java NIO expose le comportement des liens explicitement via `LinkOption`.
    
    Dans de nombreux systèmes de fichiers courants, le code Java ne peut pas créer des liens physiques de manière pleinement portable, tandis que les liens symboliques sont supportés directement via `Files.createSymbolicLink(...)` (là où autorisé par le SE / permissions).

---

<a id="327-autres-types-dentrées-du-système-de-fichiers"></a>
## 32.7 Autres types d’entrées du système de fichiers

Certaines entrées du système de fichiers ne sont pas des conteneurs de données mais des endpoints d’interaction.

| Type | But |
| --- | --- |
| Fichier de périphérique | Interface vers le matériel |
| FIFO / Pipe | Communication inter-processus |
| Fichier socket | Communication réseau |

!!! note
    Java I/O peut interagir avec ces entrées, mais le comportement dépend de la plateforme.

---

<a id="328-comment-java-io-interagit-avec-ces-concepts"></a>
## 32.8 Comment Java IO interagit avec ces concepts

Les API Java I/O opèrent à différents niveaux d’abstraction :

- `Path` / `File` (API legacy) → décrit une entrée du système de fichiers
- `File` (API legacy) / `Files` → interroge ou modifie l’état du système de fichiers
- `Streams` / `Channels` → déplacent des bytes ou des caractères

| API Java | Rôle |
| --- | --- |
| `Path` | Addressing |
| `File` (API legacy) | Addressing / opérations sur le système de fichiers |
| `Files` | Opérations sur le système de fichiers |
| `InputStream` / `Reader` | Lecture de données |
| `OutputStream` / `Writer` | Écriture de données |
| `Channel` / `SeekableByteChannel` | Avancé / accès aléatoire |

!!! note
    Aucune API Java “n’est” un fichier ; les API médiatisent l’accès à des ressources gérées par le système de fichiers.

---

<a id="329-pièges-conceptuels-fondamentaux"></a>
## 32.9 Pièges conceptuels fondamentaux

- Confondre les chemins avec les fichiers
- Supposer que les chemins impliquent l’existence
- Supposer que les répertoires stockent les données des fichiers
- Supposer que les liens sont toujours résolus automatiquement

!!! note
    Séparer toujours emplacement, structure et flux de données lorsqu’on raisonne sur les E/S.

---

<a id="3210-pourquoi-path-et-files-existent-contexte-io"></a>
## 32.10 Pourquoi Path et Files existent (contexte-IO)

Le classique `java.io` mélangeait trois préoccupations différentes dans des API mal séparées :

- Représentation du chemin (où se trouve la ressource ?)
- Interaction avec le système de fichiers (existe-t-elle ? quel type ?)
- Accès aux données (lecture/écriture de bytes ou de caractères)

La conception NIO.2 (Java 7+) sépare délibérément ces préoccupations :

- `Path` → décrit un emplacement
- `Files` → effectue des opérations sur le système de fichiers
- `Streams / Channels` → déplacent des données

!!! note
    Un `Path` n’ouvre jamais un fichier et ne touche jamais le disque à lui seul.

---

<a id="3211-file-est-api-legacy-à-la-fois-un-path-et-une-api-dopérations-sur-fichiers"></a>
## 32.11 File est (API legacy) à la fois un path et une api-d’opérations-sur-fichiers

Oui — dans l’ancienne API d’E/S, `java.io.File` joue de manière confuse deux rôles en même temps, et cette conception est exactement l’une des raisons pour lesquelles `java.nio.file` a été introduit.

**Réponse courte**

- `File` représente un chemin du système de fichiers
- `File` expose aussi des opérations sur le système de fichiers
- Il ne représente **ni** un fichier ouvert, **ni** le contenu du fichier

!!! note
    Ce mélange de responsabilités est considéré comme un défaut de conception rétrospectivement.

<a id="32111-ce-quest-vraiment-file"></a>
### 32.11.1 Ce qu’est vraiment File

Conceptuellement, `File` est plus proche de ce que nous appelons aujourd’hui un `Path`, mais avec des méthodes opérationnelles ajoutées.

| Aspect | java.io.File |
|--------|--------------|
| Représente un emplacement | Oui |
| Ouvre un fichier | Non |
| Lit / écrit des données | Non |
| Interroge le système de fichiers | Oui |
| Modifie le système de fichiers | Oui |
| Contient un handle SE | Non |

!!! note
    Un objet `File` peut exister même si le fichier n’existe pas.

<a id="32112-responsabilités-de-type-path"></a>
### 32.11.2 Responsabilités de type-Path

`File` se comporte comme une abstraction de chemin parce qu’il :

- Encapsule un pathname du système de fichiers (absolu ou relatif)
- Peut être résolu par rapport au répertoire de travail
- Peut être converti en forme absolue ou canonique

Exemples :

```java
File f = new File("data.txt"); // chemin relatif
File abs = f.getAbsoluteFile(); // chemin absolu
File canon = f.getCanonicalFile(); // normalisé + résolu
```

<a id="32113-responsabilités-dopérations-sur-le-système-de-fichiers"></a>
### 32.11.3 Responsabilités d’opérations sur le système de fichiers

En même temps, `File` expose des méthodes qui touchent le système de fichiers :

- exists()
- isFile(), isDirectory()
- length()
- delete()
- mkdir(), mkdirs()
- list(), listFiles()

!!! note
    La plupart de ces méthodes renvoient `boolean` au lieu de lancer `IOException`, ce qui masque les causes des échecs.

<a id="32114-ce-que-file-nest-pas"></a>
### 32.11.4 Ce que File N’EST PAS

- Ce n’est pas un file descriptor ouvert
- Ce n’est pas un stream
- Ce n’est pas un channel
- Ce n’est pas un conteneur de données du fichier

Il faut tout de même utiliser des streams ou des reader/writer pour accéder au contenu.

<a id="32115-lancien-double-rôle"></a>
### 32.11.5 L’ancien double rôle

Le double rôle de `File` a causé plusieurs problèmes :

- Préoccupations mélangées (chemin + opérations)
- Mauvaise gestion des erreurs (boolean au lieu d’exceptions)
- Support faible pour les liens et les systèmes de fichiers multiples
- Comportement dépendant de la plateforme

<a id="32116-comment-nio-a-corrigé-cela"></a>
### 32.11.6 Comment NIO a corrigé cela

NIO.2 sépare explicitement les responsabilités :

| Responsabilité | Ancienne API | API NIO |
|----------------|--------------|---------|
| `Représentation Path` | `File` | `Path` |
| `Opérations sur le système de fichiers` | `File` | `Files` |
| `Accès aux données` | Streams | Streams / Channels |

!!! note
    Cette séparation est l’une des améliorations conceptuelles les plus importantes en Java I/O.

<a id="32117-résumé"></a>
### 32.11.7 Résumé

- `File` représente un chemin ET effectue des opérations sur le système de fichiers
- Il ne lit ni n’écrit jamais le contenu du fichier
- Il n’ouvre jamais un fichier
- `Path` + `Files` est le remplacement moderne

---

<a id="3212-path-est-une-description-pas-une-ressource"></a>
## 32.12 Path est une description, pas une ressource

Un `Path` est une abstraction pure représentant une séquence d’éléments de nom dans un système de fichiers.

- Il n’implique PAS l’existence
- Il n’implique PAS l’accessibilité
- Il ne contient PAS de file descriptor

Ceci est fondamentalement différent des streams ou des channels.

| Concept | Path | Stream / Channel |
|---------|------|------------------|
| `Ouvre ressource` | Non | Oui |
| `Touche disque` | Non | Oui |
| `Contient handle SE` | Non | Oui |
| `Immuable` | Oui | Non |

!!! note
    Créer un Path ne peut pas lancer `IOException` car aucun E/S ne se produit.

---

<a id="3213-chemins-absolus-vs-relatifs"></a>
## 32.13 Chemins absolus vs relatifs

Comprendre la résolution des chemins est essentiel.

<a id="32131-chemins-absolus"></a>
### 32.13.1 Chemins absolus

Un chemin absolu identifie complètement un emplacement depuis la racine du système de fichiers.

- Racine dépendante de la plateforme
- Indépendant du répertoire de travail de la JVM

| Plateforme | Exemple de chemin absolu |
|------------|---------------------------|
| Unix | `/home/user/file.txt` |
| Windows | `C:\Users\User\file.txt` |

!!! important
    - Un chemin commençant par un slash `(/)` (type Unix) ou par une lettre de drive telle que `C:` (Windows) est **typiquement** considéré comme un chemin absolu.
    - Le symbole `.` est une référence au répertoire courant tandis que `..` est une référence à son répertoire parent.
    Sur Windows, un chemin comme `\dir\file.txt` (sans lettre de drive) est *rooted* sur le drive courant, pas pleinement qualifié avec drive + chemin.

Exemple :

```bash
/dirA/dirB/../dirC/./content.txt

is equivalent to:

/dirA/dirC/content.txt

// in this example the symbols were redundant and unnecessary
```

<a id="32132-chemins-relatifs"></a>
### 32.13.2 Chemins relatifs

Un chemin relatif est résolu par rapport au répertoire de travail courant de la JVM.

- Dépend de l’endroit où la JVM a été lancée
- Source courante de bugs

!!! note
    Le répertoire de travail est typiquement disponible via `System.getProperty("user.dir")`.

Exemple :

```bash
dirB/dirC/content.txt
```

---

<a id="3214-connaissance-du-système-de-fichiers-et-séparateurs"></a>
## 32.14 Connaissance du système de fichiers et séparateurs

NIO introduit l’abstraction de système de fichiers, qui était largement absente dans java.io.

<a id="32141-filesystem"></a>
### 32.14.1 FileSystem

Un `FileSystem` représente une implémentation concrète spécifique de système de fichiers.

- Le système de fichiers par défaut correspond au système de fichiers du SE
- D’autres systèmes de fichiers possibles (ZIP, mémoire, réseau)

!!! note
    Les chemins sont toujours associés à exactement UN FileSystem.

<a id="32142-séparateurs-de-chemin"></a>
### 32.14.2 Séparateurs de chemin

Les séparateurs diffèrent selon les plateformes, mais `Path` les abstrait.

| Aspect | java.io.File | java.nio.file.Path |
|--------|--------------|--------------------|
| Séparateur | Basé sur des chaînes | Conscient du système de fichiers |
| Portabilité | Gestion manuelle | Automatique |
| Comparaison | Sujette aux erreurs | Plus sûre |

!!! note
    Hardcoder `"/"` ou `"\\"` est déconseillé ; `Path` le gère automatiquement.

---

<a id="3215-ce-que-files-fait-réellement-et-ce-quil-ne-fait-pas"></a>
## 32.15 Ce que Files fait réellement et ce qu’il ne fait pas

La classe `Files` effectue de vraies opérations d’E/S.

<a id="32151-files-fait"></a>
### 32.15.1 Files FAIT

- Ouvre des fichiers indirectement (via streams / channels renvoyés par ses méthodes)
- Crée et supprime des entrées du système de fichiers
- Lance des exceptions checked en cas d’échec
- Respecte les permissions du système de fichiers

<a id="32152-files-ne-fait-pas"></a>
### 32.15.2 Files NE FAIT PAS

- Maintenir des ressources ouvertes après le retour de la méthode (sauf les streams)
- Stocker le contenu des fichiers en interne
- Garantir l’atomicité sauf si spécifié
- Maintenir un handle persistant vers des fichiers ouverts (les streams/channels possèdent le handle à la place)

!!! note
    Les méthodes qui renvoient des streams (par ex. `Files.lines()`) gardent le fichier ouvert jusqu’à ce que le stream soit fermé.

---

<a id="3216-philosophie-de-gestion-des-erreurs-old-vs-nio"></a>
## 32.16 Philosophie de gestion des erreurs : Old-vs-NIO

Une grande différence conceptuelle réside dans le reporting des erreurs.

| Aspect | `java.io.File` | `java.nio.file.Files` |
|--------|-----------------|------------------------|
| Signalement d’erreur | boolean / `null` | `IOException` |
| Diagnostic | Faible | Riche |
| Conscience des race | Faible | Améliorée |
| Préférence | Déconseillé | Préféré |

---

<a id="3217-idées-fausses-courantes"></a>
## 32.17 Idées fausses courantes

- “Path représente un fichier” → faux
- “normalize vérifie l’existence” → faux
- “Files.readAllLines stream les données” → faux
- “Les chemins relatifs sont portables” → faux
- “Créer un Path peut échouer à cause des permissions” → faux

!!! note
    De nombreuses méthodes NIO qui semblent “sûres” sont purement syntaxiques (comme `normalize` ou `resolve`) : elles ne touchent **pas** le système de fichiers et ne peuvent pas détecter des fichiers manquants.
