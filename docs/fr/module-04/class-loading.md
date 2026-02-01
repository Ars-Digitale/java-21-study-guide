# 15. Chargement des Classes, Initialisation et Construction des Objets

### Table des matières

- [15. Chargement des Classes, Initialisation et Construction des Objets](#15-chargement-des-classes-initialisation-et-construction-des-objets)
  - [15.1 Zones Mémoire Java Pertinentes pour l’Initialisation des Classes et des Objets](#151-zones-mémoire-java-pertinentes-pour-linitialisation-des-classes-et-des-objets)
  - [15.2 Chargement des Classes avec Héritage](#152-chargement-des-classes-avec-héritage)
    - [15.2.1 Ordre de Chargement des Classes](#1521-ordre-de-chargement-des-classes)
    - [15.2.2 Que se Passe-t-il Pendant le Chargement d’une Classe](#1522-que-se-passe-t-il-pendant-le-chargement-dune-classe)
  - [15.3 Création d’Objets avec Héritage](#153-création-dobjets-avec-héritage)
    - [15.3.1 Ordre Complet de Création des Instances](#1531-ordre-complet-de-création-des-instances)
  - [15.4 Exemple Complet : Initialisation Statique + d’Instance à Travers l’Héritage](#154-exemple-complet--initialisation-statique--dinstance-à-travers-lhéritage)
  - [15.5 Diagramme de Visualisation](#155-diagramme-de-visualisation)
  - [15.6 Règles Clés](#156-règles-clés)
  - [15.7 Tableau Récapitulatif](#157-tableau-récapitulatif)

---

En Java, comprendre **comment les classes sont chargées**, **comment les membres statiques et d’instance sont initialisés**, et **comment les constructeurs s’exécutent — en particulier avec l’héritage** — est essentiel pour maîtriser le langage.

Ce chapitre fournit une explication unifiée et claire de :

- Comment une classe est chargée en mémoire  
- Comment les variables statiques et les blocs statiques sont exécutés  
- Comment les objets sont créés étape par étape  
- Comment les constructeurs s’exécutent dans une chaîne d’héritage  
- Comment différentes zones mémoire (Heap, Stack, Method Area) participent  

## 15.1 Zones Mémoire Java Pertinentes pour l’Initialisation des Classes et des Objets

Avant de comprendre l’ordre d’initialisation, il est utile de rappeler les trois principales zones mémoire impliquées :

- **Method Area (aussi appelée Class Area)** — stocke les métadonnées des classes, les variables statiques et les blocs d’initialisation statique.  
- **Heap** — stocke tous les objets et les champs d’instance.  
- **Stack** — stocke les appels de méthodes, les variables locales et les références.  

> [!NOTE]  
> Les membres statiques appartiennent à la **classe** et sont créés **une seule fois** dans la Method Area. Les membres d’instance appartiennent à **chaque objet** et vivent dans le **Heap**.

---

## 15.2 Chargement des Classes (avec Héritage)

Quand un programme Java démarre, la JVM charge les classes *à la demande*.

Quand une classe est référencée pour la première fois (par exemple via `new` ou en accédant à un membre statique), **toute sa chaîne d’héritage doit d’abord être chargée**.

### 15.2.1 Ordre de Chargement des Classes

Étant donnée une hiérarchie de classes :

```java
class A { ... }
class B extends A { ... }
class C extends B { ... }
```

Si le code exécute :

```java
public static void main(String[] args) {
    new C();
}
```

Alors le chargement des classes se déroule dans cet ordre strict :

- Charger la classe A  
- Initialiser les variables statiques de A (valeurs par défaut → explicites)  
- Exécuter les blocs d’initialisation statique de A (du haut vers le bas)  
- Charger la classe B et répéter la même logique  
- Charger la classe C et répéter la même logique  

### 15.2.2 Que se Passe-t-il Pendant le Chargement d’une Classe

- **Étape 1 : Les variables statiques sont allouées** (d’abord avec les valeurs par défaut).  
- **Étape 2 : Les initialisations statiques explicites s’exécutent**.  
- **Étape 3 : Les blocs d’initialisation statique** s’exécutent dans l’ordre du code source.  

> [!NOTE]  
> Après ces étapes, la classe est complètement prête et peut maintenant être utilisée (instanciée ou référencée).

---

## 15.3 Création d’Objets (avec Héritage)

Quand le mot-clé `new` est utilisé, **la création d’instance suit une séquence stricte et prévisible** impliquant toutes les classes parentes.

### 15.3.1 Ordre Complet de Création des Instances

- **1. La mémoire est allouée dans le Heap pour le nouvel objet** (les champs reçoivent des valeurs par défaut).  
- **2. La chaîne des constructeurs s’exécute du parent vers l’enfant** — le sommet de la hiérarchie s’exécute en premier, puis chaque sous-classe.  
- **3. Les variables d’instance reçoivent leurs initialisations explicites**.  
- **4. Les blocs d’initialisation d’instance s’exécutent**.  
- **5. Le corps du constructeur s’exécute** : pour chaque classe dans la chaîne d’héritage, les étapes 3–5 (initialisation des champs, blocs d’instance, corps du constructeur) s’appliquent du parent vers l’enfant.  

---

## 15.4 Exemple Complet : Initialisation Statique + d’Instance à Travers l’Héritage

Considérons la hiérarchie suivante à trois niveaux :

```java
class A {
    static int sa = init("A static var");

    static {
        System.out.println("A static block");
    }

    int ia = init("A instance var");

    {
        System.out.println("A instance block");
    }

    A() {
        System.out.println("A constructor");
    }

    static int init(String msg) {
        System.out.println(msg);
        return 0;
    }
}

class B extends A {
    static int sb = init("B static var");

    static {
        System.out.println("B static block");
    }

    int ib = init("B instance var");

    {
        System.out.println("B instance block");
    }

    B() {
        System.out.println("B constructor");
    }
}

class C extends B {
    static int sc = init("C static var");

    static {
        System.out.println("C static block");
    }

    int ic = init("C instance var");

    {
        System.out.println("C instance block");
    }

    C() {
        System.out.println("C constructor");
    }
}

public class Test {
    public static void main(String[] args) {
        new C();
    }
}
```

Sortie

```bash
A static var
A static block
B static var
B static block
C static var
C static block
A instance var
A instance block
A constructor
B instance var
B instance block
B constructor
C instance var
C instance block
C constructor
```

---

## 15.5 Diagramme de Visualisation

```text
            CHARGEMENT DES CLASSES (du haut vers le bas)

                A  --->  B  --->  C
                |         |         |
      variables statiques + blocs statiques exécutés dans l’ordre

-------------------------------------------------------

            CRÉATION DE L’OBJET (du parent vers l’enfant)

 new C() 
    |
    +--> allocation mémoire pour C (valeurs par défaut)
    +--> appel du constructeur B()
            |
            +--> appel du constructeur A()
                    |
                    +--> initialise les variables d’instance de A
                    +--> exécute les blocs d’instance de A
                    +--> exécute le constructeur A
            +--> initialise les variables d’instance de B
            +--> exécute les blocs d’instance de B
            +--> exécute le constructeur B
    +--> initialise les variables d’instance de C
    +--> exécute les blocs d’instance de C
    +--> exécute le constructeur C
```

---

## 15.6 Règles Clés

- L’initialisation statique se produit **une seule fois** par classe.  
- Les initialisateurs statiques s’exécutent dans l’ordre parent → enfant.  
- L’initialisation d’instance se produit chaque fois qu’un objet est créé.  
- Pour chaque classe dans la chaîne d’héritage, les champs d’instance et les blocs d’instance s’exécutent avant le corps du constructeur de cette classe.  
- Globalement, l’initialisation des champs/blocs d’instance et les constructeurs s’exécutent du parent vers l’enfant.  
- Les constructeurs appellent toujours le constructeur du parent (explicitement ou implicitement).  

---

## 15.7 Tableau Récapitulatif

| STATIQUE (Niveau Classe) | INSTANCE (Niveau Objet) |
|---------------------------|--------------------------|
| Une seule fois | Se produit à chaque `new` |
| Exécuté parent → enfant | Initialisation d’instance et constructeurs parent → enfant |
| variables statiques (défaut → explicites) | variables d’instance (défaut → explicites) |
| blocs statiques | blocs d’instance + constructeur |
