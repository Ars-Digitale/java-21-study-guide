# 38. Compiler, Empaqueter et Exécuter des Modules

### Table des matières

- [38. Compiler, Empaqueter et Exécuter des Modules](#38-compiler-empaqueter-et-exécuter-des-modules)
  - [38.1 Le Module Path vs le Classpath](#381-le-module-path-vs-le-classpath)
  - [38.2 Compiler un Module Unique](#382-compiler-un-module-unique)
  - [38.3 Compiler des Modules Multiples Interdépendants](#383-compiler-des-modules-multiples-interdépendants)
  - [38.4 Empaqueter un Module dans un JAR Modulaire](#384-empaqueter-un-module-dans-un-jar-modulaire)
  - [38.5 Exécuter une Application Modulaire](#385-exécuter-une-application-modulaire)
  - [38.6 Explication des Directives de Module](#386-explication-des-directives-de-module)
    - [38.6.1 requires](#3861-requires)
    - [38.6.2 requires transitive](#3862-requires-transitive)
    - [38.6.3 exports](#3863-exports)
    - [38.6.4 exports-to-qualified-exports](#3864-exports--to-exports-qualifiés)
    - [38.6.5 opens](#3865-opens)
    - [38.6.6 opens-to-qualified-opens](#3866-opens--to-opens-qualifiés)
    - [38.6.7 Table des Directives Principales](#3867-table-des-directives-principales)
    - [38.6.8 Exports vs Opens — Accès à la Compilation vs à lExécution](#3868-exports-vs-opens--accès-à-la-compilation-vs-à-lexécution)

---

Une fois qu’un `module` est défini avec un fichier `module-info.java`, il doit être compilé, empaqueté et exécuté à l’aide d’outils conscients des modules.

Cette section explique comment la `toolchain Java` change lorsque des modules sont impliqués.

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

## 38.2 Compiler un Module Unique

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

## 38.3 Compiler des Modules Multiples Interdépendants

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

## 38.4 Empaqueter un Module dans un JAR Modulaire

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

## 38.5 Exécuter une Application Modulaire

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

## 38.6 Explication des Directives de Module

Le fichier `module-info.java` contient des directives qui décrivent les dépendances, la visibilité et les services.

Chaque directive a une signification précise.

### 38.6.1 `requires`

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

### 38.6.2 `requires transitive`

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

### 38.6.3 `exports`

`exports` rend un package accessible aux autres modules.

Seuls les packages exportés sont visibles à l’extérieur du module.

```java
module com.example.lib {
	exports com.example.lib.api;
}
```

Les packages non exportés restent fortement encapsulés.

### 38.6.4 `exports ... to` (Exports Qualifiés)

Un export qualifié restreint l’accès à des modules spécifiques.

```java
module com.example.lib {
	exports com.example.internal to com.example.friend;
}
```

Seuls les modules listés peuvent accéder au package exporté.

### 38.6.5 `opens`

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

### 38.6.6 `opens ... to` (Opens Qualifiés)

Vous pouvez restreindre l’accès réflexif à des modules spécifiques.

```java
module com.example.app {
	opens com.example.app.model to com.fasterxml.jackson.databind;
}
```

!!! note
    `opens` affecte la réflexion ; `exports` affecte la compilation et la visibilité des types.

### 38.6.7 Table des Directives Principales

| Directive | But |
| ---- | ---- |
| `requires` | Déclarer une dépendance |
| `requires transitive` | Propager une dépendance |
| `exports` | Exposer un package |
| `exports ... to` | Exposer à des modules spécifiques |
| `opens` | Autoriser la réflexion à l’exécution |
| `opens ... to` | Restreindre l’accès réflexif |

### 38.6.8 Exports vs Opens — Accès à la Compilation vs à lExécution

| Visibilité | Compilation ? | Réflexion à l’exécution ? |
| ---- | ---- | ---- |
| `exports` | Oui | Non |
| `opens` | Non | Oui |
| `exports ... to` | Oui (modules limités) | Non |
| `opens ... to` | Non | Oui (modules limités) |

!!! important
    `JPMS` ajoute un `module path`, mais le `classpath` existe toujours. Ils peuvent coexister, mais les modules nommés ont la priorité.
