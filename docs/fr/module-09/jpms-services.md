# 39. Services en JPMS (Le Modèle ServiceLoader)

### Table des matières

- [39 Services en JPMS Le Modèle ServiceLoader](#39-services-en-jpms-le-modèle-serviceloader)
  - [39.1 Le Problème que les Services Résolvent](#391-le-problème-que-les-services-résolvent)
    - [39.1.1 Rôles dans le Modèle des Services](#3911-rôles-dans-le-modèle-des-services)
    - [39.1.2 Module de l’Interface de Service](#3912-module-de-linterface-de-service)
    - [39.1.3 Module Fournisseur du Service](#3913-module-fournisseur-du-service)
    - [39.1.4 Module Consommateur du Service](#3914-module-consommateur-du-service)
    - [39.1.5 Chargement des Services à l’Exécution](#3915-chargement-des-services-à-lexécution)
    - [39.1.6 Règles de Résolution des Services](#3916-règles-de-résolution-des-services)
  - [39.2 Modules Named, Automatic et Unnamed](#392-modules-named-automatic-et-unnamed)
    - [39.2.1 Modules Named](#3921-modules-named)
    - [39.2.2 Modules Automatic](#3922-modules-automatic)
    - [39.2.3 Module Unnamed](#3923-module-unnamed)
    - [39.2.4 Synthèse Comparative](#3924-synthèse-comparative)
  - [39.3 Inspection des Modules et des Dépendances](#393-inspection-des-modules-et-des-dépendances)
    - [39.3.1 Décrire des Modules avec java](#3931-décrire-des-modules-avec-java)
    - [39.3.2 Décrire des JAR Modulaires](#3932-décrire-des-jar-modulaires)
    - [39.3.3 Analyser les Dépendances avec jdeps](#3933-analyser-les-dépendances-avec-jdeps)
  - [39.4 Créer des Images Runtime Personnalisées avec jlink](#394-créer-des-images-runtime-personnalisées-avec-jlink)
  - [39.5 Créer des Applications Autonomes avec jpackage](#395-créer-des-applications-autonomes-avec-jpackage)
  - [39.6 Synthèse Finale JPMS en Pratique](#396-synthèse-finale--jpms-en-pratique)

---

`JPMS` inclut un mécanisme de service intégré qui permet aux `modules` de découvrir et d’utiliser des implémentations à l’exécution
sans coder en dur les dépendances entre `fournisseurs` et `consommateurs`.

Ce mécanisme est basé sur l’API `ServiceLoader` existante, mais les modules le rendent fiable, explicite et sûr.

## 39.1 Le Problème que les Services Résolvent

Parfois, un module doit utiliser une capacité, mais ne devrait pas dépendre d’une implémentation spécifique.

Exemples typiques :
- frameworks de logging
- drivers de bases de données
- systèmes de plugins
- fournisseurs de services sélectionnés à l’exécution

Sans les services, le consommateur devrait dépendre directement d’une implémentation concrète.

Cela crée un couplage fort et réduit la flexibilité.

### 39.1.1 Rôles dans le Modèle des Services

Le `modèle de services JPMS` implique quatre rôles distincts.

| Rôle | Description |
| --- | --- |
| `Service interface` | Définit le contrat |
| `Service provider` | Implémente le service |
| `Service consumer` | Utilise le service |
| `Service loader` | Découvre les implémentations à l’exécution |

### 39.1.2 Module de l’Interface de Service

L’`interface de service` définit l’API dont dépendent les `consommateurs`.

Elle doit être exportée afin que les autres modules puissent la voir.

```java
package com.example.service;

public interface GreetingService {
	String greet(String name);
}
```

```java
module com.example.service {
	exports com.example.service;
}
```

!!! note
    Le module de l’interface de service ne devrait contenir aucune implémentation.

### 39.1.3 Module Fournisseur du Service

Un `module fournisseur` implémente l’interface de service et déclare qu’il fournit le service.

```java
package com.example.service.impl;

import com.example.service.GreetingService;

public class EnglishGreeting implements GreetingService {
	public String greet(String name) {
		return "Hello " + name;
	}
}
```

```java
module com.example.provider.english {
	requires com.example.service;
	provides com.example.service.GreetingService with com.example.service.impl.EnglishGreeting;
}
```

Points clés :
- Le `fournisseur` dépend de l’`interface de service`
- La classe d’implémentation n’a pas besoin d’être exportée
- La directive provides enregistre l’implémentation

### 39.1.4 Module Consommateur du Service

Le `module consommateur` déclare qu’il utilise un service, mais ne nomme aucune implémentation.

```java
module com.example.consumer {
	requires com.example.service;
	uses com.example.service.GreetingService;
}
```

!!! note
    `uses` déclare l’intention de découvrir des implémentations à l’exécution.
    
    Un module qui déclare `uses` mais n’a aucun fournisseur correspondant sur le module path compile normalement,
    mais `ServiceLoader` retourne un résultat vide à l’exécution.

### 39.1.5 Chargement des Services à l’Exécution

L’API `ServiceLoader` effectue la découverte des services.

Elle trouve tous les fournisseurs visibles dans le graphe de modules.

```java
ServiceLoader<GreetingService> loader =
	ServiceLoader.load(GreetingService.class);

for (GreetingService service : loader) {
	System.out.println(service.greet("World"));
}
```

`JPMS` garantit que seuls les fournisseurs déclarés sont découverts.

La découverte « accidentelle » basée sur le classpath est empêchée.

### 39.1.6 Règles de Résolution des Services

Pour qu’un service soit découvrable par ServiceLoader, plusieurs conditions doivent être satisfaites :

| Règle | Signification |
| ---- | ---- |
| Le module fournisseur doit être lisible | Résolu via le graphe requires |
| L’interface de service doit être exportée | Les consommateurs doivent pouvoir la voir |
| Le consommateur doit déclarer `uses` | Sinon ServiceLoader échoue |
| Le fournisseur doit déclarer `provides` | La découverte implicite est interdite |

---

## 39.2 Modules Named, Automatic et Unnamed

`JPMS` supporte différents types de modules afin de permettre une migration progressive depuis le classpath.

JPMS doit interopérer avec le code legacy.

Pour supporter une adoption graduelle, la JVM reconnaît trois catégories distinctes de modules.

### 39.2.1 Modules Named

Un `module named` possède un `module-info.class` et une identité stable.

- Encapsulation forte
- Dépendances explicites
- Support complet de JPMS

### 39.2.2 Modules Automatic

Un JAR sans module-info `placé sur le module path` devient un `module automatic`.

Son nom est dérivé du nom du fichier JAR.

- Lit tous les autres modules
- Exporte tous les packages
- Aucun encapsulamento fort

!!! note
    Les modules automatic existent pour faciliter la migration.
    Ils ne sont pas adaptés comme conception à long terme.

### 39.2.3 Module Unnamed

Le code sur le classpath appartient au `module unnamed`.

- Lit tous les modules named
- Tous les packages sont ouverts
- Ne peut pas être requis par des modules named

!!! note
    Le `module unnamed` préserve le comportement legacy du classpath.

### 39.2.4 Synthèse Comparative

| Type de module | module-info présent ? | Encapsulation | Lit |
| ---- | ---- | ---- | ---- |
| `Named` | Oui | Forte | Uniquement déclarés |
| `Automatic` | Non | Faible | Tous les modules |
| `Unnamed` | Non | Aucune | Tous les modules |

---

## 39.3 Inspection des Modules et des Dépendances

### 39.3.1 Décrire des Modules avec java

```bash
java --describe-module java.sql
```

Cela affiche les exports, les requires et les services d’un module.

### 39.3.2 Décrire des JAR Modulaires

```bash
jar --describe-module --file mylib.jar
```

### 39.3.3 Analyser les Dépendances avec `jdeps`

`jdeps` analyse statiquement les dépendances entre classes et modules.

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

## 39.4 Créer des Images Runtime Personnalisées avec `jlink`

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

## 39.5 Créer des Applications Autonomes avec `jpackage`

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

## 39.6 Synthèse Finale : JPMS en Pratique

- `JPMS` introduit une `encapsulation forte` et des dépendances fiables
- Les `modules` remplacent les conventions fragiles basées sur le classpath
- Les `services` permettent des architectures découplées
- Les modules `automatic` et `unnamed` supportent la migration
- `jlink` et `jpackage` permettent des modèles de déploiement modernes
