# 34. Streams I/O Java

<a id="table-des-matières"></a>
### Table des matières

- [34. Streams I/O Java](#34-streams-io-java)
  - [34.1 Qu’est-ce qu’un flux I/O en Java](#341-quest-ce-quun-flux-io-en-java-)
  - [34.2 Flux d’octets vs flux de caractères](#342-flux-doctets-vs-flux-de-caractères)
    - [34.2.1 Flux d’octets](#3421-flux-doctets)
    - [34.2.2 Flux de caractères](#3422-flux-de-caractères)
    - [34.2.3 Tableau récapitulatif](#3423-tableau-récapitulatif)
  - [34.3 Flux de bas niveau vs flux de haut niveau](#343-flux-de-bas-niveau-vs-flux-de-haut-niveau)
    - [34.3.1 Flux de bas niveau Node-Streams](#3431-flux-de-bas-niveau-node-streams)
    - [34.3.2 Flux de bas niveau courants](#3432-flux-de-bas-niveau-courants)
    - [34.3.3 Flux de haut niveau Filter--Processing-Streams](#3433-flux-de-haut-niveau-filter--processing-streams)
    - [34.3.4 Flux de haut niveau courants](#3434-flux-de-haut-niveau-courants)
    - [34.3.5 Règles de chaînage des flux et erreurs courantes](#3435-règles-de-chaînage-des-flux-et-erreurs-courantes)
      - [34.3.5.1 Règle fondamentale de chaînage](#34351-règle-fondamentale-de-chaînage)
      - [34.3.5.2 Incompatibilité flux d’octets vs flux de caractères](#34352-incompatibilité-flux-doctets-vs-flux-de-caractères)
      - [34.3.5.3 Chaînage invalide erreur-de-compilation](#34353-chaînage-invalide-erreur-de-compilation)
      - [34.3.5.4 Pont entre flux d’octets et flux de caractères](#34354-pont-entre-flux-doctets-et-flux-de-caractères)
      - [34.3.5.5 Patron correct de conversion](#34355-patron-correct-de-conversion)
      - [34.3.5.6 Règles d’ordre dans les chaînes de flux](#34356-règles-dordre-dans-les-chaînes-de-flux)
      - [34.3.5.7 Ordre logique correct](#34357-ordre-logique-correct)
      - [34.3.5.8 Règle de gestion des ressources](#34358-règle-de-gestion-des-ressources)
      - [34.3.5.9 Pièges courants](#34359-pièges-courants)
  - [34.4 Classes de base principales de javaio et méthodes clés](#344-classes-de-base-principales-de-javaio-et-méthodes-clés)
    - [34.4.1 InputStream](#3441-inputstream)
      - [34.4.1.1 Méthodes clés](#34411-méthodes-clés)
      - [34.4.1.2 Exemple d’utilisation typique](#34412-exemple-dutilisation-typique)
    - [34.4.2 OutputStream](#3442-outputstream)
      - [34.4.2.1 Méthodes clés](#34421-méthodes-clés)
      - [34.4.2.2 Exemple d’utilisation typique](#34422-exemple-dutilisation-typique)
    - [34.4.3 Reader et Writer](#3443-reader-et-writer)
      - [34.4.3.1 Gestion du charset](#34431-gestion-du-charset)
  - [34.5 Flux tamponnés et performance](#345-flux-tamponnés-et-performance)
    - [34.5.1 Pourquoi la mise en tampon compte](#3451-pourquoi-la-mise-en-tampon-compte)
    - [34.5.2 Comment fonctionne la lecture non tamponnée](#3452-comment-fonctionne-la-lecture-non-tamponnée)
    - [34.5.3 Comment fonctionne BufferedInputStream](#3453-comment-fonctionne-bufferedinputstream)
    - [34.5.4 Exemple de sortie tamponnée](#3454-exemple-de-sortie-tamponnée)
    - [34.5.5 BufferedReader vs Reader](#3455-bufferedreader-vs-reader)
    - [34.5.6 Exemple de BufferedWriter](#3456-exemple-de-bufferedwriter)
  - [34.6 java io vs java nio et java nio file](#346-javaio-vs-javanio-et-javaniofile)
    - [34.6.1 Différences conceptuelles](#3461-différences-conceptuelles)
    - [34.6.2 java-nio I/O de fichier moderne](#3462-javanio-io-de-fichier-moderne)
  - [34.7 Quand utiliser quelle API](#347-quand-utiliser-quelle-api)
  - [34.8 Pièges courants et conseils](#348-pièges-courants-et-conseils)

---

Ce chapitre fournit une explication détaillée des `flux I/O Java`.

Il couvre les flux classiques **java.io**, les compare à **java.nio / java.nio.file**, et explique les principes de conception, les API, les cas limites et les distinctions pertinentes.

<a id="341-quest-ce-quun-flux-io-en-java-"></a>
## 34.1 Qu’est-ce qu’un flux I/O en Java ?

Un `flux I/O` représente un flux de données entre un programme Java et une source ou une destination externe.

Les données circulent de manière séquentielle, comme de l’eau dans un tuyau.

- Un flux n’est pas une structure de données ; il ne stocke pas les données de manière permanente
- Les flux sont unidirectionnels (entrée OU sortie)
- Les flux abstraient la source sous-jacente (fichier, réseau, mémoire, périphérique)
- Les flux fonctionnent de manière bloquante, synchrone (I/O classique)

En Java, les flux sont organisés autour de deux dimensions majeures :

- `Direction` : Entrée vs Sortie
- `Type de données` : Octets vs Caractères

---

<a id="342-flux-doctets-vs-flux-de-caractères"></a>
## 34.2 Flux d’octets vs flux de caractères

Java distingue les flux selon l’unité de données qu’ils traitent.

<a id="3421-flux-doctets"></a>
### 34.2.1 Flux d’octets

- Fonctionnent avec des octets bruts 8 bits
- Utilisés pour les données binaires (images, audio, PDF, ZIP)
- Classes de base : `InputStream` et `OutputStream`

<a id="3422-flux-de-caractères"></a>
### 34.2.2 Flux de caractères

- Fonctionnent avec des caractères Unicode 16 bits
- Gèrent automatiquement l’encodage des caractères
- Classes de base : `Reader` et `Writer`

<a id="3423-tableau-récapitulatif"></a>
### 34.2.3 Tableau récapitulatif

|	Aspect	|	Flux d’octets	|	Flux de caractères	|
|-----------|-------------------|-----------------------|
|	`Unité de données`	|	byte (8 bits)	|	char (16 bits)	|
|	`Gestion de l’encodage`	|	Aucune	|	Oui (conscient du charset)	|
|	`Classes de base`	|	InputStream / OutputStream	|	Reader / Writer	|
|	`Usage typique`	|	Fichiers binaires	|	Fichiers texte	|
| 	`Focus`	|	I/O bas niveau	|	Traitement de texte	|

---

<a id="343-flux-de-bas-niveau-vs-flux-de-haut-niveau"></a>
## 34.3 Flux de bas niveau vs flux de haut niveau

Les flux dans `java.io` suivent un pattern decorator. Les flux sont empilés pour ajouter des fonctionnalités.

<a id="3431-flux-de-bas-niveau-node-streams"></a>
### 34.3.1 Flux de bas niveau (Node Streams)

Les flux de bas niveau se connectent directement à une source ou un puits de données.

- Ils savent lire/écrire des octets ou des caractères
- Ils ne fournissent PAS de mise en tampon, de formatage ou de gestion d’objets

<a id="3432-flux-de-bas-niveau-courants"></a>
### 34.3.2 Flux de bas niveau courants

|	Classe de flux	|	Objectif	|
|-------------------|-----------|
|	`FileInputStream`		|	Lire des octets depuis un fichier	|
|	`FileOutputStream`	|	Écrire des octets dans un fichier	|
|	`FileReader`	|	Lire des caractères depuis un fichier	|
|	`FileWriter`	|	Écrire des caractères dans un fichier	|

- Exemple : flux d’octets de bas niveau

```java
try (InputStream in = new FileInputStream("data.bin")) {
	int b;
	while ((b = in.read()) != -1) {
		System.out.println(b);
	}
}
```

!!! note
    Les flux de bas niveau sont rarement utilisés seuls dans des applications réelles en raison de performances médiocres et de fonctionnalités limitées.

<a id="3433-flux-de-haut-niveau-filter--processing-streams"></a>
### 34.3.3 Flux de haut niveau (Filter / Processing Streams)

Les flux de haut niveau enveloppent d’autres flux pour ajouter des fonctionnalités.

- Mise en tampon
- Conversion de type de données
- Sérialisation d’objets
- Lecture/écriture de primitifs

<a id="3434-flux-de-haut-niveau-courants"></a>
### 34.3.4 Flux de haut niveau courants

|	Classe de flux	|	Ajoute des fonctionnalités	|
|-------------------|-----------------------|
|	`BufferedInputStream`	|	Mise en tampon	|
|	`BufferedReader`	|	Lecture par lignes	|
|	`DataInputStream`	|	Types primitifs	|
|	`ObjectInputStream`	|	Sérialisation d’objets	|
|	`PrintWriter`	|	Sortie texte formatée	|

- Exemple : chaînage de flux

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

<a id="3435-règles-de-chaînage-des-flux-et-erreurs-courantes"></a>
### 34.3.5 Règles de chaînage des flux et erreurs courantes

L’exemple précédent illustre le chaînage des flux, un concept central de `java.io` basé sur le pattern decorator.

Chaque flux enveloppe un autre flux, ajoutant des fonctionnalités tout en préservant une hiérarchie de types stricte.

<a id="34351-règle-fondamentale-de-chaînage"></a>
#### 34.3.5.1 Règle fondamentale de chaînage

Un flux ne peut envelopper qu’un autre flux d’un niveau d’abstraction compatible.

- Les flux d’octets ne peuvent envelopper que des flux d’octets
- Les flux de caractères ne peuvent envelopper que des flux de caractères
- Les flux de haut niveau nécessitent un flux de bas niveau sous-jacent

!!! note
    Vous ne pouvez pas mélanger arbitrairement `InputStream` avec `Reader` ou `OutputStream` avec `Writer`.

<a id="34352-incompatibilité-flux-doctets-vs-flux-de-caractères"></a>
#### 34.3.5.2 Incompatibilité flux d’octets vs flux de caractères

Une erreur très courante consiste à tenter d’envelopper un flux d’octets directement avec une classe basée sur les caractères (ou inversement).

<a id="34353-chaînage-invalide-erreur-de-compilation"></a>
#### 34.3.5.3 Chaînage invalide (erreur de compilation)

```java
BufferedReader reader =
	new BufferedReader(new FileInputStream("text.txt"));
```

!!! note
    Cela échoue parce que `BufferedReader` attend un `Reader`, pas un `InputStream`.

<a id="34354-pont-entre-flux-doctets-et-flux-de-caractères"></a>
#### 34.3.5.4 Pont entre flux d’octets et flux de caractères

Pour convertir entre les flux basés sur les octets et ceux basés sur les caractères, Java fournit des classes passerelles qui effectuent un décodage/encodage explicite du charset.

- `InputStreamReader` convertit octets → caractères
- `OutputStreamWriter` convertit caractères → octets

<a id="34355-patron-correct-de-conversion"></a>
#### 34.3.5.5 Patron correct de conversion

```java
BufferedReader reader =
	new BufferedReader(
		new InputStreamReader(new FileInputStream("text.txt")));
```

!!! note
    La passerelle gère le décodage des caractères en utilisant un charset (par défaut ou explicite).

<a id="34356-règles-dordre-dans-les-chaînes-de-flux"></a>
#### 34.3.5.6 Règles d’ordre dans les chaînes de flux

L’ordre d’enveloppement n’est pas arbitraire.

- Le flux de bas niveau doit être le plus interne
- Les passerelles (si nécessaires) viennent ensuite
- Les flux tamponnés ou de traitement viennent en dernier

<a id="34357-ordre-logique-correct"></a>
#### 34.3.5.7 Ordre logique correct

```text
FileInputStream → InputStreamReader → BufferedReader
```

<a id="34358-règle-de-gestion-des-ressources"></a>
#### 34.3.5.8 Règle de gestion des ressources

Fermer le flux le plus externe ferme automatiquement tous les flux enveloppés.

!!! note
    C’est pourquoi try-with-resources devrait référencer uniquement le flux de plus haut niveau.

<a id="34359-pièges-courants"></a>
#### 34.3.5.9 Pièges courants

- Essayer de tamponner un flux du mauvais type
- Oublier la passerelle entre flux d’octets et flux de caractères
- Supposer que `Reader` fonctionne avec des données binaires
- Utiliser le charset par défaut involontairement
- Fermer manuellement les flux internes (risque de double-close) : `close()` sur l’enveloppe externe suffit et est recommandé

---

<a id="344-classes-de-base-principales-de-javaio-et-méthodes-clés"></a>
## 34.4 Classes de base principales de `java.io` et méthodes clés

Le package `java.io` est construit autour d’un petit ensemble de **classes de base abstraites**.
Comprendre ces classes et leurs contrats est essentiel, car toutes les classes I/O concrètes s’appuient sur elles.

<a id="3441-inputstream"></a>
### 34.4.1 InputStream

Classe de base abstraite pour l’entrée orientée octets.
Tous les flux d’entrée lisent des octets bruts (valeurs 8 bits) depuis une source telle qu’un fichier, un socket réseau, ou un buffer mémoire.

<a id="34411-méthodes-clés"></a>
#### 34.4.1.1 Méthodes clés

| Méthode | Description |
|--------|-------------|
| int `read()`	|	Lit un octet (0–255) ; retourne -1 à la fin du flux |
| int `read(byte[])`	|	Lit des octets dans un buffer ; retourne le nombre d’octets lus ou -1 |
| int `read(byte[], int, int)`	|	Lit jusqu’à length octets dans une tranche de buffer |
| int `available()`	|	Octets lisibles sans bloquer (indice, pas garantie) |
| void `close()`	|	Libère la ressource sous-jacente |

!!! note
    Les méthodes `read()` sont bloquantes par défaut.
    
    Elles suspendent le thread appelant jusqu’à ce que des données soient disponibles, que la fin de flux soit atteinte, ou qu’une erreur I/O se produise.

La méthode `read()` à octet unique est principalement un primitif de bas niveau.

En pratique, lire un octet à la fois est inefficace et devrait presque toujours être évité au profit de lectures tamponnées.

<a id="34412-exemple-dutilisation-typique"></a>
#### 34.4.1.2 Exemple d’utilisation typique

```java
try (InputStream in = new FileInputStream("data.bin")) {
	byte[] buffer = new byte[1024];
	int count;
	while ((count = in.read(buffer)) != -1) {
		// traiter buffer[0..count-1]
	}
}
```

<a id="3442-outputstream"></a>
### 34.4.2 OutputStream

Classe de base abstraite pour la sortie orientée octets.

Elle représente une destination où des octets bruts peuvent être écrits.

<a id="34421-méthodes-clés"></a>
#### 34.4.2.1 Méthodes clés

| Méthode | Description |
|--------|-------------|
| void `write(int b)`	|	Écrit les 8 bits de poids faible de l’entier |
| void `write(byte[])`	|	Écrit un tableau d’octets entier |
| void `write(byte[], int, int)`	|	Écrit une tranche d’un tableau d’octets |
| void `flush()`	|	Force l’écriture des données tamponnées |
| void `close()`	|	Effectue flush et libère la ressource |

!!! note
    Appeler `close()` appelle implicitement `flush()`.
    
    Ne pas faire flush ou close sur un OutputStream peut entraîner une perte de données.

<a id="34422-exemple-dutilisation-typique"></a>
#### 34.4.2.2 Exemple d’utilisation typique

```java
try (OutputStream out = new FileOutputStream("out.bin")) {
	out.write(new byte[] {1, 2, 3, 4});
	out.flush();
}
```

<a id="3443-reader-et-writer"></a>
### 34.4.3 Reader et Writer

`Reader` et `Writer` sont les équivalents `orientés caractères` de InputStream et OutputStream.

Ils fonctionnent sur des caractères Unicode 16 bits au lieu d’octets bruts.

| Classe | Direction | Basée sur caractères | Consciente de l’encodage |
|-------|-----------|----------------------|--------------------------|
| `Reader` | Entrée | Oui | Oui |
| `Writer` | Sortie | Oui | Oui |

Readers et Writers impliquent toujours un `charset`, explicitement ou implicitement.

Cela en fait l’abstraction correcte pour le traitement de texte.

<a id="34431-gestion-du-charset"></a>
#### 34.4.3.1 Gestion du charset

```java
Reader reader = new InputStreamReader(
	new FileInputStream("file.txt"),
	StandardCharsets.UTF_8
);
```

!!! note
    `InputStreamReader` et `OutputStreamWriter` sont des classes passerelles.
    
    Ils convertissent entre `flux d’octets` et `flux de caractères` en utilisant un `charset`.

---

<a id="345-flux-tamponnés-et-performance"></a>
## 34.5 Flux tamponnés et performance

Les `flux tamponnés` enveloppent un autre flux et ajoutent un buffer en mémoire.

Au lieu d’interagir avec le système d’exploitation à chaque read ou write, les données sont accumulées en mémoire et transférées en plus gros blocs.

- `BufferedInputStream` / `BufferedOutputStream` pour les flux d’octets
- `BufferedReader` / `BufferedWriter` pour les flux de caractères

!!! note
    Les `flux tamponnés` sont des `decorators` : ils ne remplacent pas le flux sous-jacent, ils l’améliorent en ajoutant un comportement de mise en tampon.

<a id="3451-pourquoi-la-mise-en-tampon-compte"></a>
### 34.5.1 Pourquoi la mise en tampon compte

| Aspect | Non tamponné | Tamponné |
|--------|------------|----------|
| `Appels système` | Fréquents | Réduits |
| `Performance` | Médiocre | Élevée |
| `Utilisation mémoire` | Minimale | Légèrement plus élevée |

Les appels système sont des opérations coûteuses.

La mise en tampon les minimise en regroupant plusieurs lectures ou écritures logiques en moins d’opérations I/O physiques.

<a id="3452-comment-fonctionne-la-lecture-non-tamponnée"></a>
### 34.5.2 Comment fonctionne la lecture non tamponnée

Dans un flux non tamponné, chaque appel à read() peut entraîner un appel système natif.

C’est particulièrement inefficace lorsqu’on lit de grandes quantités de données.

```java
try (InputStream in = new FileInputStream("data.bin")) {
	int b;
	while ((b = in.read()) != -1) {
		// chaque read() peut déclencher un appel système
	}
}
```

!!! note
    Lire octet par octet sans mise en tampon est presque toujours un anti-pattern de performance.

<a id="3453-comment-fonctionne-bufferedinputstream"></a>
### 34.5.3 Comment fonctionne BufferedInputStream

`BufferedInputStream` lit en interne un grand bloc d’octets dans un buffer.

Les appels `read()` suivants sont servis directement depuis la mémoire jusqu’à ce que le buffer soit vide.

```java
try (InputStream in =
	new BufferedInputStream(new FileInputStream("data.bin"))) {
		int b;
		while ((b = in.read()) != -1) {
			// la plupart des lectures sont servies depuis la mémoire, pas depuis l’OS
		}
}
```

!!! note
    Le programme appelle toujours `read()` de manière répétée, mais le système d’exploitation n’est accédé que lorsque le buffer interne doit être rempli à nouveau.

<a id="3454-exemple-de-sortie-tamponnée"></a>
### 34.5.4 Exemple de sortie tamponnée

La sortie tamponnée accumule les données en mémoire et les écrit en plus gros blocs.

L’opération `flush()` force l’écriture immédiate du buffer.

```java
try (OutputStream out =
	new BufferedOutputStream(new FileOutputStream("out.bin"))) {
		for (int i = 0; i < 1_000; i++) {
			out.write(i);
		}
		out.flush(); // force les données tamponnées sur disque
}
```

!!! note
    `close()` appelle automatiquement flush().
    
    Appeler `flush()` explicitement est utile lorsque les données doivent être visibles immédiatement.

<a id="3455-bufferedreader-vs-reader"></a>
### 34.5.5 BufferedReader vs Reader

`BufferedReader` ajoute une `**lecture par lignes**` efficace au-dessus d’un Reader.

Sans mise en tampon, chaque caractère lu peut impliquer un appel système.

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
    La méthode `readLine()` n’est disponible que sur `BufferedReader` (pas sur `Reader`), car elle s’appuie sur la mise en tampon pour détecter efficacement les limites de ligne.

<a id="3456-exemple-de-bufferedwriter"></a>
### 34.5.6 Exemple de BufferedWriter

```java
try (BufferedWriter writer =
	new BufferedWriter(new FileWriter("file.txt"))) {

		writer.write("Hello");
		writer.newLine();
		writer.write("World");
}
```

`BufferedWriter` minimise l’accès disque et fournit des méthodes pratiques telles que newLine().

!!! note
    Enveloppez toujours les flux de fichiers avec une mise en tampon sauf s’il y a une forte raison de ne pas le faire
    
    Préférez BufferedReader / BufferedWriter pour le texte
    
    Préférez BufferedInputStream / BufferedOutputStream pour les données binaires

---

<a id="346-javaio-vs-javanio-et-javaniofile"></a>
## 34.6 java.io vs java.nio (et java.nio.file)

Les applications Java modernes favorisent de plus en plus les API NIO et NIO.2, mais java.io reste fondamental et largement utilisé.

<a id="3461-différences-conceptuelles"></a>
### 34.6.1 Différences conceptuelles

| Aspect | java.io | java.nio / nio.2 |
|--------|---------|------------------|
| `Modèle de programmation` | Basé sur les flux | Basé sur buffers / channels |
| `I/O bloquantes` | bloquantes par défaut | Capable de non-bloquant |
| `API fichiers` | File | Path + Files |
| `Scalabilité` | Limitée | Élevée |
| `Introduit` | Java 1.0 | Java 4 / Java 7 |

!!! note
    `java.nio` ne remplace pas `java.io`.
    
    De nombreuses classes NIO s’appuient en interne sur des flux ou coexistent avec eux.

<a id="3462-javanio-io-de-fichier-moderne"></a>
### 34.6.2 java.nio (I/O de fichier moderne)

Le package `java.nio.file` (NIO.2) fournit une API fichiers de haut niveau, expressive et plus sûre.
C’est l’approche préférée pour les opérations sur fichiers en Java 11+.

Exemple : lire un fichier (NIO)

```java
Path path = Path.of("file.txt");
List<String> lines = Files.readAllLines(path);
```

Code java.io équivalent

```java
try (BufferedReader reader = new BufferedReader(new FileReader("file.txt"))) {
	String line;
	while ((line = reader.readLine()) != null) {
		System.out.println(line);
	}
}
```

---

<a id="347-quand-utiliser-quelle-api"></a>
## 34.7 Quand utiliser quelle API

| Scénario | API recommandée |
|----------|-----------------|
| `Lecture/écriture simple de fichier` | java.nio.file.Files |
| `Streaming binaire` | InputStream / OutputStream |
| `Traitement de texte en caractères` | Reader / Writer |
| `Serveurs haute performance` | java.nio.channels |
| `API legacy` | java.io |

---

<a id="348-pièges-courants-et-conseils"></a>
## 34.8 Pièges courants et conseils

- La fin de fichier est indiquée par -1, pas par une exception
- Fermer un flux wrapper ferme automatiquement le flux enveloppé
- `BufferedReader.readLine()` supprime les séparateurs de ligne
- `InputStreamReader` implique toujours un charset
- Les méthodes utilitaires Files lancent des IOException checked
- `available()` ne doit pas être utilisé pour détecter EOF

!!! note
    La plupart des bugs I/O proviennent d’hypothèses incorrectes sur le blocking, la mise en tampon ou l’encodage des caractères.
