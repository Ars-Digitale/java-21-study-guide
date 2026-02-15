# 39. Services dans JPMS (Le Modèle ServiceLoader)

### Table des matières

- [39 Services dans JPMS Le Modèle ServiceLoader](#39-services-dans-jpms-le-modèle-serviceloader)
  - [39.1 Le Problème que les Services Résolvent](#391-le-problème-que-les-services-résolvent)
    - [39.1.1 Rôles dans le Modèle de Service](#3911-rôles-dans-le-modèle-de-service)
    - [39.1.2 Module Interface de Service](#3912-module-interface-de-service)
    - [39.1.3 Module Fournisseur de Service](#3913-module-fournisseur-de-service)
    - [39.1.4 Module Consommateur de Service](#3914-module-consommateur-de-service)
    - [39.1.5 Chargement des Services à lExécution](#3915-chargement-des-services-a-lxécution)
    - [39.1.6 Règles de Résolution des Services](#3916-règles-de-résolution-des-services)
    - [39.1.7 Couche Service Locator](#3917-couche-service-locator)
    - [39.1.8 Schéma Séquentiel dInvocation](#3918-schéma-séquentiel-dinvocation)
    - [39.1.9 Tableau Récapitulatif des Composants](#3919-tableau-récapitulatif-des-composants)


---

`JPMS` inclut un mécanisme de service intégré qui permet aux `modules` de découvrir et dutiliser des implémentations à l’exécution
sans coder en dur des dépendances entre `fournisseurs` et `consommateurs`.

Ce mécanisme est basé sur l’`API ServiceLoader` existante, mais les modules le rendent fiable, explicite et sûr.

## 39.1 Le Problème que les Services Résolvent

Parfois un module doit utiliser une capacité, mais ne devrait pas dépendre dune implémentation spécifique.

Des exemples typiques incluent :
- frameworks de journalisation
- pilotes de base de données
- systèmes de plugins
- fournisseurs de service sélectionnés à l’exécution

Sans services, le consommateur devrait dépendre directement dune implémentation concrète.

Cela crée un couplage fort et réduit la flexibilité.

### 39.1.1 Rôles dans le Modèle de Service

Le `modèle de service JPMS` implique quatre rôles distincts.

| Rôle | Description |
| --- | --- |
| `Interface de service` | Définit le contrat |
| `Fournisseur de service` | Implémente le service |
| `Consommateur de service` | Utilise le service |
| `Service loader` | Découvre les implémentations à l’exécution |

### 39.1.2 Module Interface de Service

L’`interface de service` définit l’API dont les `consommateurs` dépendent.

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
    Le module d’interface de service ne devrait contenir aucune implémentation.

### 39.1.3 Module Fournisseur de Service

Un `module fournisseur` implémente l’interface de service et déclare quil fournit le service.

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
- La directive `provides` enregistre l’implémentation

### 39.1.4 Module Consommateur de Service

Le `module consommateur` déclare quil utilise un service, mais ne nomme aucune implémentation.

```java
module com.example.consumer {
	requires com.example.service;
	uses com.example.service.GreetingService;
}
```

!!! note
    `uses` déclare l’intention de découvrir des implémentations à l’exécution.
    
    Un module qui déclare `uses` mais ne possède aucun fournisseur correspondant sur le module path compile normalement,
    mais `ServiceLoader` retourne un résultat vide à l’exécution.

### 39.1.5 Chargement des Services à lExécution

L’`API ServiceLoader` effectue la découverte de service.

Elle trouve tous les fournisseurs visibles pour le graphe des modules.

```java
ServiceLoader<GreetingService> loader =
	ServiceLoader.load(GreetingService.class);

for (GreetingService service : loader) {
	System.out.println(service.greet("World"));
}
```

`JPMS` garantit que seuls les fournisseurs déclarés sont découverts.

La découverte “accidentelle” basée sur le classpath est empêchée.

### 39.1.6 Règles de Résolution des Services

Pour qu’un service soit découvrable par `ServiceLoader`, plusieurs conditions doivent être satisfaites :

| Règle | Signification |
| ---- | ---- |
| Le module fournisseur doit être lisible | Résolu par le graphe `requires` |
| L’interface de service doit être exportée | Les consommateurs doivent la voir |
| Le consommateur doit déclarer `uses` | Sinon ServiceLoader échoue |
| Le fournisseur doit déclarer `provides` | La découverte implicite est interdite |

### 39.1.7 Couche Service Locator

Il est possible dintroduire une couche supplémentaire appelée `Service Locator`.

Dans cette architecture :

- Le `consommateur` n’utilise pas directement `ServiceLoader`
- Le `Service Locator` est le seul composant qui déclare `uses`
- Le `consommateur` dépend du `Service Locator`

Structure architecturale :

```
Consommateur → Service Locator → ServiceLoader → Fournisseur
```

Module du Service Locator :

```java
module com.example.locator {
	requires com.example.service;
	uses com.example.service.GreetingService;
}
```

Classe Service Locator :

```java
package com.example.locator;

import java.util.ServiceLoader;
import com.example.service.GreetingService;

public class GreetingLocator {

	public static GreetingService getService() {
		return ServiceLoader
				.load(GreetingService.class)
				.findFirst()
				.orElseThrow();
	}
}
```

Module Consommateur :

```java
module com.example.consumer {
	requires com.example.locator;
}
```

Le consommateur ne déclare pas `uses` parce quil ninvoque pas directement `ServiceLoader`.

### 39.1.8 Schéma Séquentiel dInvocation

Séquence dexécution :

1. Le `Consommateur` invoque `GreetingLocator.getService()`
2. Le `Service Locator` invoque `ServiceLoader.load(...)`
3. Le `ServiceLoader` consulte le graphe des modules
4. Le système identifie les modules qui déclarent `provides`
5. L’implémentation du `Fournisseur` est instanciée
6. L’instance est retournée au `Consommateur`

Schéma séquentiel :

```
Consommateur
   │
   │ 1. getService()
   ▼
Service Locator
   │
   │ 2. ServiceLoader.load()
   ▼
ServiceLoader
   │
   │ 3. Résolution du fournisseur
   ▼
Implémentation Fournisseur
   │
   │ 4. Instance retournée
   ▼
Consommateur
```

### 39.1.9 Tableau Récapitulatif des Composants

| Composant | Rôle | exports | requires | uses | provides |
|------------|-------|---------|----------|------|----------|
| SPI | Définit le contrat | ✅ | ❌ | ❌ | ❌ |
| Fournisseur | Implémente le service | ❌ | ✅ | ❌ | ✅ |
| Service Locator | Effectue la découverte | (optionnel) | ✅ | ✅ | ❌ |
| Consommateur | Utilise le service | ❌ | ✅ | ❌ | ❌ |

