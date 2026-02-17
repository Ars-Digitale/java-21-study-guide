# 38. Compiler, Empaqueter et Exécuter des Modules

<a id="table-des-matières"></a>
### Table des matières

- [38. Compiler, Empaqueter et Exécuter des Modules](#38-compiler-empaqueter-et-exécuter-des-modules)
  - [38.1 Le Module Path vs le Classpath](#381-le-module-path-vs-le-classpath)
  - [38.2 Options de Ligne de Commande Relatives aux Modules](#382-options-de-ligne-de-commande-relatives-aux-modules)
    - [38.2.1 Options Disponibles dans java et javac](#3821-options-disponibles-dans-java-et-javac)
    - [38.2.2 Options Applicables Uniquement à javac](#3822-options-applicables-uniquement-à-javac)
    - [38.2.3 Options Applicables Uniquement à java](#3823-options-applicables-uniquement-à-java)
    - [38.2.4 Distinctions Importantes](#3824-distinctions-importantes)
  - [38.3 Compiler un Module Unique](#383-compiler-un-module-unique)
  - [38.4 Compiler des Modules Multiples Interdépendants](#384-compiler-des-modules-multiples-interdépendants)
  - [38.5 Empaqueter un Module dans un JAR Modulaire](#385-empaqueter-un-module-dans-un-jar-modulaire)
  - [38.6 Exécuter une Application Modulaire](#386-exécuter-une-application-modulaire)
  - [38.7 Explication des Directives de Module](#387-explication-des-directives-de-module)
    - [38.7.1 requires](#3871-requires)
    - [38.7.2 requires transitive](#3872-requires-transitive)
    - [38.7.3 exports](#3873-exports)
    - [38.7.4 exports-to-qualified-exports](#3874-exports--to-exports-qualifiés)
    - [38.7.5 opens](#3875-opens)
    - [38.7.6 opens-to-qualified-opens](#3876-opens--to-opens-qualifiés)
    - [38.7.7 Table des Directives Principales](#3877-table-des-directives-principales)
    - [38.7.8 Exports vs Opens — Accès à la Compilation vs à lExécution](#3878-exports-vs-opens--accès-à-la-compilation-vs-à-lexécution)
  - [38.8 Modules Nommés, Automatiques et Unnamed](#388-modules-nommés-automatiques-et-unnamed)
    - [38.8.1 Modules Nommés](#3881-modules-nommés)
    - [38.8.2 Modules Automatiques](#3882-modules-automatiques)
    - [38.8.3 Module Unnamed](#3883-module-unnamed)
    - [38.8.4 Résumé Comparatif](#3884-résumé-comparatif)
  - [38.9 Inspection des Modules et des Dépendances](#389-inspection-des-modules-et-des-dépendances)
    - [38.9.1 Décrire les Modules avec java](#3891-décrire-les-modules-avec-java)
    - [38.9.2 Décrire les JAR Modulaires](#3892-décrire-les-jar-modulaires)
    - [38.9.3 Analyser les Dépendances avec jdeps](#3893-analyser-les-dépendances-avec-jdeps)
  - [38.10 Créer des Images Runtime Personnalisées avec jlink](#3810-créer-des-images-runtime-personnalisées-avec-jlink)
  - [38.11 Créer des Applications Autonomes avec jpackage](#3811-créer-des-applications-autonomes-avec-jpackage)
  - [38.12 Résumé Final JPMS en Pratique](#3812-résumé-final-jpms-en-pratique)

---

Une fois qu’un `module` est défini avec un fichier `module-info.java`, il doit être compilé, empaqueté et exécuté à l’aide d’outils conscients des modules.

Cette section explique comment la `toolchain Java` change lorsque des modules sont impliqués.

<a id="381-le-module-path-vs-le-classpath"></a>
## 38.1 Le Module Path vs le Classpath

`JPMS` introduit un nouveau concept : le **module path**.

Il existe aux côtés du **classpath** traditionnel, mais les deux se comportent de manière très différente.

| Aspect | Classpath | Module path |
| ---- | ---- | ---- |
| Structure | Liste plate de JAR | Modules avec identité |
| Encapsulation | Aucune | Forte |
| Vérification des dépendances | Aucune | Stricte |
| Split packages | Autorisés | Interdits (modules nommés) |
| Ordre de résolution | Dépendant de l’ordre | Déterministe |

!!! note
    - Un JAR placé sur le `module path` devient un `module nommé (ou automatique)`.
    - Un JAR placé sur le classpath est traité comme faisant partie du `module non nommé`.
    - Les split packages sont autorisés sur le classpath mais interdits pour les modules nommés sur le module path.

---

<a id="382-options-de-ligne-de-commande-relatives-aux-modules"></a>
## 38.2 Options de Ligne de Commande Relatives aux Modules

Lorsqu’on travaille avec le Java Module System, `java` et `javac` fournissent des options spécifiques pour compiler et exécuter des applications modulaires. 

Certaines options sont communes, tandis que d’autres sont spécifiques à un outil.


<a id="3821-options-disponibles-dans-java-et-javac"></a>
### 38.2.1 Options Disponibles dans `java` et `javac`

Ces options peuvent être utilisées aussi bien lors de la compilation que lors de l’exécution :

- **`--module`** ou **`-m`**  
  Utilisée pour compiler ou exécuter uniquement le module spécifié.

- **`--module-path`** ou **`-p`**  
  Spécifie les chemins dans lesquels `java` ou `javac` rechercheront les définitions de modules.


<a id="3822-options-applicables-uniquement-à-javac"></a>
### 38.2.2 Options Applicables Uniquement à `javac`

Ces options s’appliquent uniquement à la phase de compilation :

- **`--module-source-path`**  
  (aucun raccourci)  
  Utilisée par `javac` pour localiser les définitions des modules source.

- **`-d`**  
  Spécifie le répertoire de sortie dans lequel les fichiers `.class` seront générés après la compilation.



<a id="3823-options-applicables-uniquement-à-java"></a>
### 38.2.3 Options Applicables Uniquement à `java`

Ces options s’appliquent uniquement à la phase d’exécution :

- **`--list-modules`**  
  (aucun raccourci)  
  Liste tous les modules observables puis termine.

- **`--show-module-resolution`**  
  (aucun raccourci)  
  Affiche les détails de la résolution des modules lors du démarrage de l’application.

- **`--describe-module`** ou **`-d`**  
  Décrit un module spécifié puis termine.



<a id="3824-distinctions-importantes"></a>
### 38.2.4 Distinctions Importantes

L’option `-d` a des significations différentes selon l’outil :

- Dans **`javac`**, `-d` définit le répertoire de sortie des fichiers de classes compilés.
- Dans **`java`**, `-d` est un raccourci pour `--describe-module`.

De plus, `-d` ne doit pas être confondue avec **`-D`** (D majuscule).

- **`-D`** est utilisée lors de l’exécution d’un programme Java pour définir des propriétés système sous forme de paires nom-valeur sur la ligne de commande.

```bash
java -Dconfig.file=app.properties com.example.Main
```

Dans cet exemple, `-Dconfig.file=app.properties` définit une propriété système accessible à l’exécution via `System.getProperty("config.file")`.

---

<a id="383-compiler-un-module-unique"></a>
## 38.3 Compiler un Module Unique

Pour compiler un module, vous devez spécifier le chemin des sources du module et le répertoire de destination.

```bash
javac -d out \
src/com.example.hello/module-info.java \
src/com.example.hello/com/example/hello/Main.java
```

Une approche plus évolutive utilise `--module-source-path`.

```bash
javac --module-source-path src \
      -d out \
      $(find src -name "*.java")
```

!!! note
    `--module-source-path` indique à javac où trouver plusieurs modules à la fois.

---

<a id="384-compiler-des-modules-multiples-interdépendants"></a>
## 38.4 Compiler des Modules Multiples Interdépendants

Lorsque des modules dépendent les uns des autres, leurs dépendances doivent être résolubles à la compilation.

`--module-path` **mods** (répertoire d’exemple contenant des modules interdépendants) doit contenir des JAR modulaires déjà compilés ou des répertoires de modules compilés (chacun avec son propre module-info.class).

```bash
javac -d out \
--module-source-path src \
--module-path mods \
$(find src -name "*.java")
```

Ici :
- `--module-source-path` localise les arbres de sources des modules
- `--module-path` fournit des modules déjà compilés

---

<a id="385-empaqueter-un-module-dans-un-jar-modulaire"></a>
## 38.5 Empaqueter un Module dans un JAR Modulaire

Après la compilation, les modules sont généralement empaquetés sous forme de fichiers JAR.

Un JAR modulaire contient un `module-info.class` à sa racine.

Si `module-info.class` est présent, le JAR devient automatiquement un `module nommé` et son `nom` est pris depuis le descripteur (et non depuis le nom du fichier).

```bash
jar --create \
--file mods/com.example.hello.jar \
--main-class com.example.hello.Main \
-C out/com.example.hello .
```

!!! note
    Un JAR avec `module-info.class` est un `module nommé, pas un module automatique`.
    Lorsqu’un JAR contient un `module-info.class`, son nom de module est pris depuis ce fichier et n’est pas déduit du nom du fichier.

---

<a id="386-exécuter-une-application-modulaire"></a>
## 38.6 Exécuter une Application Modulaire

Pour exécuter une application modulaire, vous utilisez le `module path` et spécifiez le `nom du module`.

```bash
java --module-path mods \
--module com.example.hello/com.example.hello.Main
```

Vous pouvez raccourcir cela en utilisant les options `-p` et `-m`.

```bash
java -p mods -m com.example.hello/com.example.hello.Main
```

!!! note
    Lors de l’utilisation de modules nommés, le classpath est ignoré pour la résolution des dépendances entre modules.

---

<a id="387-explication-des-directives-de-module"></a>
## 38.7 Explication des Directives de Module

Le fichier `module-info.java` contient des directives qui décrivent les dépendances, la visibilité et les services.

Chaque directive a une signification précise.

<a id="3871-requires"></a>
### 38.7.1 `requires`

La directive `requires` déclare une dépendance vers un autre module.

Sans elle, les types du module dépendant ne peuvent pas être utilisés.

```java
module com.example.app {
	requires com.example.lib;
}
```

Effets de requires :
- La dépendance doit être présente à la compilation et à l’exécution
- Les packages exportés du module requis deviennent accessibles

<a id="3872-requires-transitive"></a>
### 38.7.2 `requires transitive`

`requires transitive` expose une dépendance aux modules en aval.

Il propage la lisibilité.

```java
module com.example.lib {
	requires transitive com.example.util;
	exports com.example.lib.api;
}
```

Signification :
- **Tout module qui requiert com.example.lib lit automatiquement com.example.util**
- **Les appelants n’ont pas besoin de déclarer requires com.example.util explicitement**

!!! note
    Cela est similaire aux « dépendances publiques » dans d’autres systèmes de modules.
    
    Lisible ≠ exporté : une dépendance transitive n’exporte pas automatiquement vos packages.

<a id="3873-exports"></a>
### 38.7.3 `exports`

`exports` rend un package accessible aux autres modules.

Seuls les packages exportés sont visibles à l’extérieur du module.

```java
module com.example.lib {
	exports com.example.lib.api;
}
```

Les packages non exportés restent fortement encapsulés.

<a id="3874-exports--to-exports-qualifiés"></a>
### 38.7.4 `exports ... to` (Exports Qualifiés)

Un export qualifié restreint l’accès à des modules spécifiques.

```java
module com.example.lib {
	exports com.example.internal to com.example.friend;
}
```

Seuls les modules listés peuvent accéder au package exporté.

<a id="3875-opens"></a>
### 38.7.5 `opens`

`opens` permet un accès réflexif profond à un package.

Il est principalement utilisé par des frameworks utilisant la réflexion.

```java
module com.example.app {
	opens com.example.app.model;
}
```

!!! note
    opens NE rend PAS un package accessible à la compilation.
    Il affecte uniquement la réflexion à l’exécution.

<a id="3876-opens--to-opens-qualifiés"></a>
### 38.7.6 `opens ... to` (Opens Qualifiés)

Vous pouvez restreindre l’accès réflexif à des modules spécifiques.

```java
module com.example.app {
	opens com.example.app.model to com.fasterxml.jackson.databind;
}
```

!!! note
    `opens` affecte la réflexion ; `exports` affecte la compilation et la visibilité des types.

<a id="3877-table-des-directives-principales"></a>
### 38.7.7 Table des Directives Principales

| Directive | But |
| ---- | ---- |
| `requires` | Déclarer une dépendance |
| `requires transitive` | Propager une dépendance |
| `exports` | Exposer un package |
| `exports ... to` | Exposer à des modules spécifiques |
| `opens` | Autoriser la réflexion à l’exécution |
| `opens ... to` | Restreindre l’accès réflexif |

<a id="3878-exports-vs-opens--accès-à-la-compilation-vs-à-lexécution"></a>
### 38.7.8 Exports vs Opens — Accès à la Compilation vs à lExécution

| Visibilité | Compilation ? | Réflexion à l’exécution ? |
| ---- | ---- | ---- |
| `exports` | Oui | Non |
| `opens` | Non | Oui |
| `exports ... to` | Oui (modules limités) | Non |
| `opens ... to` | Non | Oui (modules limités) |

!!! important
    `JPMS` ajoute un `module path`, mais le `classpath` existe toujours. Ils peuvent coexister, mais les modules nommés ont la priorité.
	
---

<a id="388-modules-nommés-automatiques-et-unnamed"></a>
## 38.8 Modules Nommés, Automatiques et Unnamed

`JPMS` supporte différents types de modules afin de permettre une migration progressive depuis le classpath.

JPMS doit interopérer avec du code legacy.

Pour supporter l’adoption progressive, la JVM reconnaît trois catégories différentes de modules.

<a id="3881-modules-nommés"></a>
### 38.8.1 Modules Nommés

Un `module nommé` possède un `module-info.class` et une identité stable.

- Encapsulation forte
- Dépendances explicites
- Support complet JPMS

<a id="3882-modules-automatiques"></a>
### 38.8.2 Modules Automatiques

Un JAR sans `module-info` placé sur le `module path` devient un `module automatique`.

Son nom est dérivé du nom du fichier JAR.

- Lit tous les autres modules
- Exporte tous les packages
- Pas d’encapsulation forte

!!! note
    Les modules automatiques existent pour faciliter la migration.
    Ils ne conviennent pas comme conception à long terme.

<a id="3883-module-unnamed"></a>
### 38.8.3 Module Unnamed

Le code sur le classpath appartient au `module unnamed`.

- Lit tous les modules nommés
- Tous les packages sont ouverts
- Ne peut pas être requis par des modules nommés

!!! note
    Le `module unnamed` préserve le comportement legacy du classpath.

<a id="3884-résumé-comparatif"></a>
### 38.8.4 Résumé Comparatif

| Type de module | module-info présent ? | Encapsulation | Lit |
| ---- | ---- | ---- | ---- |
| `Named` | Oui | Forte | Déclarés seulement |
| `Automatic` | Non | Faible | Tous les modules |
| `Unnamed` | Non | Aucune | Tous les modules |

---

<a id="389-inspection-des-modules-et-des-dépendances"></a>
## 38.9 Inspection des Modules et des Dépendances

<a id="3891-décrire-les-modules-avec-java"></a>
### 38.9.1 Décrire les Modules avec java

```bash
java --describe-module java.sql
```

Cela affiche `exports`, `requires` et `services` d’un module.

<a id="3892-décrire-les-jar-modulaires"></a>
### 38.9.2 Décrire les JAR Modulaires

```bash
jar --describe-module --file mylib.jar
```

<a id="3893-analyser-les-dépendances-avec-jdeps"></a>
### 38.9.3 Analyser les Dépendances avec `jdeps`

`jdeps` analyse statiquement les dépendances de classes et de modules.

```bash
jdeps myapp.jar
```

```bash
jdeps --module-path mods --check my.module
```

Pour détecter l’utilisation d’API internes du JDK :

```bash
jdeps --jdk-internals myapp.jar
```

---

<a id="3810-créer-des-images-runtime-personnalisées-avec-jlink"></a>
## 38.10 Créer des Images Runtime Personnalisées avec `jlink`

`jlink` construit un runtime Java minimal contenant uniquement les modules requis par une application.

```bash
jlink
--module-path $JAVA_HOME/jmods:mods
--add-modules com.example.app
--output runtime-image
```

Avantages :
- runtime plus petit
- démarrage plus rapide
- aucun module JDK inutilisé

---

<a id="3811-créer-des-applications-autonomes-avec-jpackage"></a>
## 38.11 Créer des Applications Autonomes avec `jpackage`

`jpackage` construit des installateurs spécifiques à la plateforme ou des images applicatives.

```bash
jpackage
--name MyApp
--input mods
--main-module com.example.app/com.example.Main
```

`jpackage` peut produire :
- .exe / .msi (Windows)
- .pkg / .dmg (macOS)
- .deb / .rpm (Linux)

---

<a id="3812-résumé-final-jpms-en-pratique"></a>
## 38.12 Résumé Final JPMS en Pratique

- `JPMS` introduit une `encapsulation forte` et des dépendances fiables
- Les `modules` remplacent les conventions fragiles du classpath
- Les `services` permettent des architectures découplées
- Les `modules automatiques` et le `module unnamed` supportent la migration
- `jlink` et `jpackage` permettent des modèles modernes de déploiement

