# 37. Java Platform Module System (JPMS)

### Table des matières

- [37. Java Platform Module System (JPMS)](#37-java-platform-module-system-jpms)
  - [37.1 Pourquoi les modules ont été introduits](#371-pourquoi-les-modules-ont-été-introduits)
    - [37.1.1 Problèmes avec le classpath](#3711-problèmes-avec-le-classpath)
    - [37.1.2 Exemple d’un problème de classpath](#3712-exemple-dun-problème-de-classpath)
  - [37.2 Qu’est-ce qu’un module](#372-quest-ce-quun-module)
    - [37.2.1 Propriétés fondamentales des modules](#3721-propriétés-fondamentales-des-modules)
    - [37.2.2 Module vs package vs JAR](#3722-module-vs-package-vs-jar)
  - [37.3 Le descripteur module-infojava](#373-le-descripteur-module-infojava)
    - [37.3.1 Descripteur de module minimal](#3731-descripteur-de-module-minimal)
  - [37.4 Structure des répertoires d’un module](#374-structure-des-répertoires-dun-module)
  - [37.5 Un premier programme modulaire](#375-un-premier-programme-modulaire)
    - [37.5.1 Classe principale](#3751-classe-principale)
    - [37.5.2 Descripteur du module](#3752-descripteur-du-module)
  - [37.6 Explication de l’encapsulation forte](#376-explication-de-lencapsulation-forte)
  - [37.7 Synthèse des idées clés](#377-synthèse-des-idées-clés)

---

Le `Java Platform Module System` (**JPMS**) a été introduit en Java 9.

C’est un mécanisme au niveau du langage et au niveau du runtime pour structurer les applications Java en unités fortement encapsulées appelées `modules`.

JPMS influence la manière dont le code est :
- organisé
- compilé
- lié
- empaqueté
- chargé au runtime

Comprendre JPMS est essentiel pour le Java moderne, en particulier pour les grandes applications, les bibliothèques, les images de runtime et les outils de déploiement.

## 37.1 Pourquoi les modules ont été introduits

Avant Java 9, les applications Java étaient construites en utilisant uniquement :
- des `packages`
- des fichiers `JAR`
- le `classpath`

Ce modèle présentait des limitations sérieuses à mesure que les applications grandissaient.

### 37.1.1 Problèmes avec le classpath

Le classpath est une liste plate de JAR dans laquelle :
- toutes les classes publiques sont accessibles à tous
- il n’existe pas de déclaration fiable des dépendances
- les versions en conflit sont courantes
- l’encapsulation est faible ou inexistante
- des classes dupliquées s’écrasent silencieusement en fonction de l’ordre du classpath


Cela a conduit à des problèmes bien connus tels que :
- “JAR hell”
- des bugs liés à l’ordre du classpath
- l’utilisation accidentelle d’API internes
- des erreurs d’exécution qui n’étaient pas détectées à la compilation

### 37.1.2 Exemple d’un problème de classpath

Supposons que deux bibliothèques dépendent de versions différentes du même JAR tiers.

Une seule version peut être placée sur le classpath.

La version choisie dépend uniquement de l’ordre du classpath, et non de l’appropriation réelle.

> [!NOTE]
> Ce problème ne peut pas être résolu de manière fiable avec le seul outil du classpath.

---

## 37.2 Qu’est-ce qu’un module ?

Un `module` est une unité de code nommée et auto-descriptive.

Chaque module nommé possède un nom unique qui l’identifie auprès du compilateur et du système de modules.


Il déclare explicitement :
- de quoi il dépend
- ce qu’il expose aux autres modules
- ce qu’il garde caché

Un module est plus fort qu’un package et plus structuré qu’un JAR.

### 37.2.1 Propriétés fondamentales des modules

| Propriété | Description |
| --- | --- |
| Encapsulation forte | Les packages sont cachés par défaut |
| Dépendances explicites | Les dépendances doivent être déclarées |
| Configuration fiable | Les dépendances manquantes provoquent des erreurs précoces |
| Identité nommée | Chaque module possède un nom unique |

### 37.2.2 Module vs package vs JAR

| Concept | But | Encapsulation |
| --- | --- | --- |
| Package | Regroupement d’espace de noms | Faible (public reste visible) |
| JAR     | Empaquetage / déploiement | Aucune (toutes les classes visibles lorsqu’elles sont sur le classpath) |
| Module  | Encapsulation + unité de dépendance | Forte (packages non exportés cachés) |

---

## 37.3 Le descripteur `module-info.java`

Chaque `module nommé` est défini par un fichier descripteur de module appelé :

```text
module-info.java
```

Ce fichier décrit le module au compilateur et au runtime.

### 37.3.1 Descripteur de module minimal

Un descripteur de module minimal déclare uniquement le nom du module. Le nom du fichier doit être exactement `module-info.java`, et il doit se trouver à la racine de l’arbre des sources du module.


```java
module com.example.hello {
}
```

> [!NOTE]
> **Un module sans directives n’exporte rien et ne dépend de rien**.

---

## 37.4 Structure des répertoires d’un module

Un projet modulaire suit une structure standard de répertoires.

Le descripteur du module se trouve à la racine de l’arbre des sources du module.

```text
src/
└─ com.example.hello/
	├─ module-info.java
	└─ com/
		└─ example/
			└─ hello/
				└─ Main.java
```

Points clés :
- Le **nom du répertoire correspond au nom du module**
- `module-info.java` se trouve en haut de la racine des sources du module
- les packages suivent les règles standard de nommage Java

> [!NOTE]
> Dans les projets IDE et build-tool, la structure des fichiers peut différer (par ex. Maven utilise `src/main/java`).  
> Ce qui reste toujours vrai : `module-info.java` se trouve à la racine de l’arbre des sources du module et les chemins des packages suivent le nommage standard Java.

---

## 37.5 Un premier programme modulaire

Créons une application modulaire minimale.

### 37.5.1 Classe principale

```java
package com.example.hello;

public class Main {
	public static void main(String[] args) {
		System.out.println("Hello, modular world!");
	}
}
```

### 37.5.2 Descripteur du module

```java
module com.example.hello {
	exports com.example.hello;
}
```

La `directive exports` rend le package accessible aux autres modules.

Sans elle, le package est encapsulé et inaccessible.

---

## 37.6 Explication de l’encapsulation forte

Dans `JPMS`, les packages NE sont PAS accessibles par défaut.

Même les classes public sont cachées à moins d’être exportées explicitement.

Dans les modules, `public` signifie “public vers les autres modules *seulement si* le package conteneur est exporté.”


| Situation | Accessible depuis un autre module ? |
|-----------|--------------------------------------|
| Classe public dans un package non exporté  | Non |
| Classe public dans un package exporté | Oui |
| Membre protected dans un package exporté | Oui, mais seulement via héritage (pas accès général) |
| Classe/membre package-private (n’importe quel package) | Non |
| Membre private | Non |


> [!NOTE]
> C’est une différence fondamentale par rapport au modèle basé sur le classpath.

---

## 37.7 Synthèse des idées clés

- `JPMS` introduit les modules comme unités fortes d’encapsulation
- Les dépendances sont explicites et vérifiées
- `module-info.java` est le descripteur central
- Les packages sont cachés sauf s’ils sont exportés
- La visibilité basée sur le classpath ne s’applique plus dans les modules
- La visibilité public n’est plus suffisante : les exports du module contrôlent l’accessibilité
