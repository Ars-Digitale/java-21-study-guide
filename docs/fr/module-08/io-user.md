# 36. Interagir avec l’Utilisateur (Flux E/S Standard)

<a id="table-des-matières"></a>
### Table des matières


- [36.1 Les Flux E/S Standard](#361-les-flux-es-standard)
- [36.2 PrintStream Quest-ce et Pourquoi il Existe](#362-printstream-quest-ce-et-pourquoi-il-existe)
	- [36.2.1 Caractéristiques Clés de PrintStream](#3621-caractéristiques-clés-de-printstream)
	- [36.2.2 Utilisation de Base de PrintStream](#3622-utilisation-de-base-de-printstream)
	- [36.2.3 Formater l'Output avec PrintStream](#3623-formater-loutput-avec-printstream)
- [36.3 Lire l'Input comme Flux E/S](#363-lire-linput-comme-flux-es)
	- [36.3.1 Lecture de Bas Niveau depuis Systemin](#3631-lecture-de-bas-niveau-depuis-systemin)
	- [36.3.2 Utilisation de InputStreamReader et BufferedReader](#3632-utilisation-de-inputstreamreader-et-bufferedreader)
- [36.4 La Classe Scanner Pratique mais Subtile](#364-la-classe-scanner-pratique-mais-subtile)
	- [36.4.1 Problèmes Communs de Scanner](#3641-problèmes-communs-de-scanner)
- [36.5 Fermeture des Flux Système](#365-fermeture-des-flux-système)
- [36.6 Acquérir l'Input avec Console](#366-acquérir-linput-avec-console)
	- [36.6.1 Lire l'Input depuis Console](#3661-lire-linput-depuis-console)
	- [36.6.2 Lire des Mots de Passe de Manière Sécurisée](#3662-lire-des-mots-de-passe-de-manière-sécurisée)
- [36.7 Formater l'Output de la Console](#367-formater-loutput-de-la-console)
- [36.8 Comparaison entre Console Scanner et BufferedReader](#368-comparaison-entre-console-scanner-et-bufferedreader)
- [36.9 Redirection et Flux Standard](#369-redirection-et-flux-standard)
- [36.10 Pièges Communs et Bonnes Pratiques](#3610-pièges-communs-et-bonnes-pratiques)
- [36.11 Synthèse Finale](#3611-synthèse-finale)


---

Les programmes Java doivent souvent interagir avec l’utilisateur: afficher des informations, lire une entrée et formater la sortie.

Cette interaction est implémentée en utilisant les flux E/S standard, qui sont des flux Java normaux connectés au système d’exploitation.

Ce chapitre explique comment Java interagit avec la console et l’entrée/sortie standard,
en partant des concepts les plus basiques et en passant aux API de niveau plus élevé.

<a id="361-les-flux-es-standard"></a>
## 36.1 Les Flux E/S Standard

Chaque programme Java commence avec trois flux prédéfinis fournis par la JVM.

Ils sont connectés à l’environnement du processus (en général un terminal ou une console).

| Flux | Champ | Type | But |
| --- | --- | --- | --- |
| Sortie standard | `System.out` | PrintStream | Sortie normale |
| Erreur standard | `System.err` | PrintStream | Sortie d’erreur |
| Entrée standard | `System.in` | InputStream | Entrée de l’utilisateur |

!!! note
    Ces flux sont créés par la JVM, pas par le programme.
    
    Ils existent pendant toute la durée du processus.

---

<a id="362-printstream-quest-ce-et-pourquoi-il-existe"></a>
## 36.2 `PrintStream`: Qu’est-ce et Pourquoi il Existe

`PrintStream` est un flux de sortie orienté octets conçu pour une sortie lisible par l’utilisateur.

Il enveloppe un autre OutputStream et ajoute des méthodes d’impression pratiques.

`System.out` et `System.err` sont tous deux des instances de `PrintStream`.

<a id="3621-caractéristiques-clés-de-printstream"></a>
### 36.2.1 Caractéristiques Clés de PrintStream

- Flux orienté octets avec des helpers pour l’impression de texte
- Fournit des méthodes `print()` et `println()`
- Convertit automatiquement les valeurs en texte
- Ne lance pas `IOException` sur erreurs d’écriture
- Supporte optionnellement l’auto-flush sur newline / `println()`

!!! note
    Contrairement à la plupart des flux, PrintStream supprime les IOExceptions.
    
    Les erreurs doivent être vérifiées en utilisant checkError().

<a id="3622-utilisation-de-base-de-printstream"></a>
### 36.2.2 Utilisation de Base de PrintStream

```java
System.out.println("Hello");
System.out.print("Value: ");
System.out.println(42);
```

`println()` ajoute automatiquement le séparateur de ligne spécifique à la plateforme.

<a id="3623-formater-loutput-avec-printstream"></a>
### 36.2.3 Formater l’Output avec PrintStream

PrintStream supporte une sortie formatée en utilisant `printf()` et `format()`,
qui sont basés sur la même syntaxe que String.format().

```java
System.out.printf("Name: %s, Age: %d%n", "Alice", 30);
```

| Spécificateur | Signification |
| --- | --- |
| `%s` | Chaîne |
| `%d` | Entier |
| `%f` | Virgule flottante |
| `%n` | Nouvelle ligne indépendante de la plateforme |

!!! note
    `printf()` n’ajoute pas automatiquement une nouvelle ligne à moins qu’on spécifie `%n`.

---

<a id="363-lire-linput-comme-flux-es"></a>
## 36.3 Lire l’Input comme Flux E/S

L’entrée standard (System.in) est un InputStream connecté à l’entrée de l’utilisateur.

Elle fournit des octets bruts et doit être adaptée pour un usage pratique.

<a id="3631-lecture-de-bas-niveau-depuis-systemin"></a>
### 36.3.1 Lecture de Bas Niveau depuis System.in

Au niveau le plus bas, tu peux lire des octets bruts depuis System.in.

Ceci est rarement pratique pour des programmes interactifs.

```java
int b = System.in.read();
```

!!! note
    `System.in.read()` bloque jusqu’à ce que l’entrée soit disponible.

<a id="3632-utilisation-de-inputstreamreader-et-bufferedreader"></a>
### 36.3.2 Utilisation de InputStreamReader et BufferedReader

Pour lire une entrée textuelle, `System.in` est typiquement enveloppé dans un Reader et bufferisé.

```java
BufferedReader reader =
new BufferedReader(new InputStreamReader(System.in));

String line = reader.readLine();
```

Ceci convertit `octets → caractères` et permet une entrée basée sur des lignes.

---

<a id="364-la-classe-scanner-pratique-mais-subtile"></a>
## 36.4 La Classe Scanner (Pratique mais Subtile)

`Scanner` est un utilitaire de haut niveau pour le parsing d’entrée textuelle.

Il est souvent utilisé pour l’interaction avec la console, surtout dans de petits programmes.

```java
Scanner sc = new Scanner(System.in);
int value = sc.nextInt();
String text = sc.nextLine();
```

!!! note
    `Scanner` effectue tokenisation et parsing, pas une simple lecture.
    
    Cela la rend pratique mais plus lente et parfois surprenante.

<a id="3641-problèmes-communs-de-scanner"></a>
### 36.4.1 Problèmes Communs de Scanner

- Mélanger `nextInt()` (et autres `nextXxx()`) avec `nextLine()` peut sembler “sauter” l’entrée car le newline final du token numérique est encore dans le buffer.
- Les erreurs de parsing lancent InputMismatchException
- Scanner est relativement lente pour des entrées de grande taille

---

<a id="365-fermeture-des-flux-système"></a>
## 36.5 Fermeture des Flux Système

Les `flux système` sont spéciaux et doivent être gérés avec attention.

| Flux         | Fermer explicitement? |
|-------------|------------------------|
| `System.out` | Non                   |
| `System.err` | Non                   |
| `System.in`  | En général non        |

Fermer `System.out` ou `System.err` ferme le flux sous-jacent du système d’exploitation et affecte l’ensemble de la JVM: fermer ces flux affecte l’ensemble du processus JVM, pas seulement la classe ou la méthode courante.

!!! note
    Dans presque toutes les applications, tu ne devrais PAS fermer `System.out` ou `System.err`.

---

<a id="366-acquérir-linput-avec-console"></a>
## 36.6 Acquérir l’Input avec `Console`

La classe `Console` fournit une manière de niveau plus élevé et plus sûre d’interagir avec l’utilisateur.

Elle est conçue spécifiquement pour des programmes de console interactifs.

```java
Console console = System.console();
if (console == null) {
    throw new IllegalStateException("No console available");
}
```

!!! note
    `System.console()` peut retourner `null` quand aucune console n’est disponible
    (par ex. IDE, entrée redirigée).
	
	
La présence d’une console dépend de la plateforme sous-jacente et de la manière dont la JVM est lancée.

Si la JVM est démarrée depuis une ligne de commande interactive et que les flux d’entrée/sortie standard ne sont pas redirigés, une console est généralement disponible.  
Dans ce cas, la console est habituellement connectée au clavier et à l’affichage à partir desquels le programme a été lancé.

Si la JVM est démarrée dans un contexte non interactif — par exemple depuis un IDE, un planificateur de tâches en arrière-plan, un gestionnaire de services, ou avec des flux standard redirigés — une console ne sera généralement pas disponible.

Lorsqu’une console existe, elle est représentée par une instance unique de la classe Console, qui peut être obtenue en invoquant la méthode `System.console()`. Si aucun périphérique console n’est disponible, cette méthode retourne `null`.

<a id="3661-lire-linput-depuis-console"></a>
### 36.6.1 Lire l’Input depuis Console

```java
String name = console.readLine("Name: ");
```

`readLine()` affiche un prompt et lit une ligne complète d’entrée.

<a id="3662-lire-des-mots-de-passe-de-manière-sécurisée"></a>
### 36.6.2 Lire des Mots de Passe de Manière Sécurisée

Console permet de lire des mots de passe sans afficher les caractères.

```java
char[] password = console.readPassword("Password: ");
```

!!! note
    Les mots de passe sont retournés en `char[]` afin qu’ils puissent être effacés de la mémoire.

---

<a id="367-formater-loutput-de-la-console"></a>
## 36.7 Formater l’Output de la Console

Console supporte aussi une sortie formatée, similaire à PrintStream.

```java
console.printf("Welcome %s%n", name);
```

Ceci utilise les mêmes spécificateurs de format que `printf()`.

---

<a id="368-comparaison-entre-console-scanner-et-bufferedreader"></a>
## 36.8 Comparaison entre Console, Scanner et BufferedReader

| API | Cas d’usage | Points forts | Limitations |
| --- | --- | --- | --- |
| `BufferedReader` | Entrée textuelle simple | Rapide, prévisible, charset explicite | Parsing manuel |
| `Scanner`        | Entrée basée sur tokens / parsing | Pratique, expressive | Plus lente, comportement des tokens subtil |
| `Console`        | Apps console interactives | Mots de passe, prompts, E/S formatées | Peut ne pas être disponible (`null`) |

---

<a id="369-redirection-et-flux-standard"></a>
## 36.9 Redirection et Flux Standard

Les flux standard peuvent être redirigés par le système d’exploitation.
Le code Java ne doit pas changer.

```bash
java App < input.txt > output.txt
```

Du point de vue du programme, `System.in` et `System.out` se comportent encore comme des flux normaux.

!!! note
    La redirection est gérée par le système d’exploitation ou par le shell. Le code Java ne doit pas changer pour la supporter.

---

<a id="3610-pièges-communs-et-bonnes-pratiques"></a>
## 36.10 Pièges Communs et Bonnes Pratiques

- PrintStream supprime les IOExceptions
- `System.console()` peut retourner null
- Ne pas fermer `System.out` ou `System.err`
- Scanner mélange parsing et lecture
- Console est préférable pour les mots de passe
- Si tu utilises `Scanner` sur `System.in`, ne ferme pas le Scanner si d’autres parties du programme doivent encore lire depuis `System.in` (fermer le Scanner ferme `System.in`).

---

<a id="3611-synthèse-finale"></a>
## 36.11 Synthèse Finale

- `System.out` et `System.err` sont des PrintStream pour la sortie
- `System.in` est un flux d’octets qui doit être adapté pour le texte
- `BufferedReader` et `Scanner` sont des stratégies communes d’entrée
- `Console` fournit une entrée et une sortie interactives sûres
- Les flux standard s’intègrent naturellement avec la redirection du système d’exploitation
