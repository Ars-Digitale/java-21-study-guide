# 18. Generics en Java

<a id="table-des-matières"></a>
### Table des matières


- [18.1 Bases des Types Génériques](#181-bases-des-types-génériques)
- [18.2 Pourquoi les Generics Existent](#182-pourquoi-les-generics-existent)
- [18.3 Méthodes Génériques](#183-méthodes-génériques)
- [18.4 Type Erasure](#184-type-erasure)
	- [18.4.1 Comment Fonctionne la Type Erasure](#1841-comment-fonctionne-la-type-erasure)
	- [18.4.2 Erasure des Paramètres de Type Sans Bound](#1842-erasure-des-paramètres-de-type-sans-bound)
	- [18.4.3 Erasure des Paramètres de Type Avec Bound](#1843-erasure-des-paramètres-de-type-avec-bound)
	- [18.4.4 Bounds Multiples: Le Premier Bound Détermine l’Erasure](#1844-bounds-multiples-le-premier-bound-détermine-lerasure)
	- [18.4.5 Pourquoi Seulement le Premier Bound Devient le Type à Runtime](#1845-pourquoi-seulement-le-premier-bound-devient-le-type-à-runtime)
	- [18.4.6 Un Exemple Plus Complexe](#1846-un-exemple-plus-complexe)
	- [18.4.7 Redéfinition (Overriding) et Génériques](#1847-redéfinition-et-génériques)
		- [18.4.7.1 Comment le compilateur valide une redéfinition](#18471-comment-le-compilateur-valide-une-redéfinition)
		- [18.4.7.2 Paramètres génériques et redéfinition](#18472-paramètres-génériques-et-redéfinition)
		- [18.4.7.3 Redéfinition valide — Suppression de la spécificité générique](#18473-redéfinition-valide-suppression-de-spécificité-générique)
		- [18.4.7.4 Redéfinition invalide — Ajout de spécificité générique](#18474-redéfinition-invalide-ajout-de-spécificité-générique)
		- [18.4.7.5 Redéfinition valide — Paramétrage identique](#18475-redéfinition-valide-paramétrage-identique)
		- [18.4.7.6 Redéfinition invalide — Changement d’argument générique](#18476-redéfinition-invalide-changement-dargument-générique)
		- [18.4.7.7 Pourquoi cette règle existe](#18477-pourquoi-cette-règle-existe)
		- [18.4.7.8 Modèle mental](#18478-modèle-mental)
		- [18.4.7.9 Règles récapitulatives](#18479-règles-résumé)
	- [18.4.8 Surcharge d’une Méthode Générique — Pourquoi Certaines Surcharges Sont Impossibles](#1848-surcharge-dune-méthode-générique--pourquoi-certaines-surcharges-sont-impossibles)
	- [18.4.9 Surcharge d’une Méthode Générique Héritée d’une Classe Parent](#1849-surcharge-dune-méthode-générique-héritée-dune-classe-parent)
	- [18.4.10 Retourner des Types Génériques — Règles et Restrictions](#18410-retourner-des-types-génériques--règles-et-restrictions)
	- [18.4.11 Récapitulatif des Règles d’Erasure](#18411-récapitulatif-des-règles-derasure)
- [18.5 Bounds sur les Paramètres de Type](#185-bounds-sur-les-paramètres-de-type)
	- [18.5.1 Upper Bounds: extends](#1851-upper-bounds-extends)
	- [18.5.2 Bounds Multiples](#1852-bounds-multiples)
	- [18.5.3 Wildcard: ?, ? extends, ? super](#1853-wildcard---extends--super)
		- [18.5.3.1 Wildcard Non Limitée](#18531-wildcard-non-limitée-)
		- [18.5.3.2 Wildcard avec Upper Bound extends](#18532-wildcard-avec-upper-bound--extends)
		- [18.5.3.3 Wildcard avec Lower Bound super](#18533-wildcard-avec-lower-bound--super)
- [18.6 Generics et Héritage](#186-generics-et-héritage)
- [18.7 Type Inference (Opérateur Diamond)](#187-type-inference-opérateur-diamond)
- [18.8 Raw Types (Compatibilité Legacy)](#188-raw-types-compatibilité-legacy)
- [18.9 Tableaux Génériques (Non Autorisés)](#189-tableaux-génériques-non-autorisés)
- [18.10 Bounded Type Inference](#1810-bounded-type-inference)
- [18.11 Wildcard vs Paramètres de Type](#1811-wildcard-vs-paramètres-de-type)
- [18.12 Règle PECS (Producer Extends, Consumer Super)](#1812-règle-pecs-producer-extends-consumer-super)
- [18.13 Pièges Communs](#1813-pièges-communs)
- [18.14 Tableau Récapitulatif des Wildcards](#1814-tableau-récapitulatif-des-wildcards)
- [18.15 Récapitulatif des Concepts](#1815-récapitulatif-des-concepts)
- [18.16 Exemple Complet](#1816-exemple-complet)


---

Java `Generics` permettent de créer des classes, des interfaces et des méthodes qui travaillent avec des types spécifiés par l’utilisateur, en garantissant que seuls des objets du type correct sont utilisés.

Tous les contrôles de type sont effectués par le compilateur à compile-time.

Pendant la compilation, le compilateur vérifie les types puis supprime les informations génériques (processus identifié comme **type erasure**), en les remplaçant par les types réels ou par Object lorsque nécessaire.

Le bytecode résultant ne contient pas de generics: il contient seulement les types concrets et, si nécessaire, des casts insérés automatiquement par le compilateur.

De cette manière, les erreurs de type sont interceptées avant l’exécution, rendant le code plus sûr, lisible et réutilisable.

Les Generics s’appliquent à:
- `Classes`
- `Interfaces`
- `Méthodes` (méthodes génériques)
- `Constructeurs`

<a id="181-bases-des-types-génériques"></a>
## 18.1 Bases des Types Génériques

Une classe ou interface générique introduit un ou plusieurs **paramètres de type**, encadrés par des chevrons.

```java
class Box<T> {
    private T value;
    void set(T v) { value = v; }
    T get()       { return value; }
}

Box<String> b = new Box<>();

b.set("hello");

String x = b.get(); // aucun cast nécessaire
```

Plusieurs paramètres de type sont permis:

```java
class Pair<K, V> {
    K key;
    V value;
}
```

---

<a id="182-pourquoi-les-generics-existent"></a>
## 18.2 Pourquoi les Generics Existent

```java
List list = new ArrayList();          // pre-generics
list.add("hi");

Integer x = (Integer) list.get(0);    // ClassCastException à runtime
```

Avec les generics:

```java
List<String> list = new ArrayList<>();
list.add("hi");

String x = list.get(0);               // type-safe, aucun cast
```

---

<a id="183-méthodes-génériques"></a>
## 18.3 Méthodes Génériques

Une **méthode générique** introduit ses propres paramètres de type, indépendants de la classe.

```java
class Util {

    static <T> T pick(T a, T b) { return a; }
	
}

String s = Util.<String>pick("A", "B"); // explicite
String t = Util.pick("A", "B");         // l’inférence fonctionne
```

---

<a id="184-type-erasure"></a>
## 18.4 Type Erasure

La `Type erasure` est le processus par lequel le compilateur Java supprime toutes les informations sur les types génériques avant de générer le bytecode.

Cela garantit la compatibilité avec les JVM précédentes à Java 5.

À `compile time`, les generics sont complètement contrôlés: bounds sur les types, variance, surcharge de méthodes génériques, etc.

Cependant, à runtime, toutes les informations génériques disparaissent.

<a id="1841-comment-fonctionne-la-type-erasure"></a>
### 18.4.1 Comment Fonctionne la Type Erasure

- Remplacer toutes les variables de type (comme `T`) par leur type erasure.
- Insérer des casts lorsque nécessaire.
- Supprimer tous les arguments de type générique (ex. `List<String>` → `List`).

<a id="1842-erasure-des-paramètres-de-type-sans-bound"></a>
### 18.4.2 Erasure des Paramètres de Type Sans Bound

Si une variable de type n’a pas de bound:

```java
class Box<T> {
    T value;
    T get() { return value; }
}
```

L’erasure de `T` est `Object`.

```java
class Box {
    Object value;
    Object get() { return value; }
}
```

<a id="1843-erasure-des-paramètres-de-type-avec-bound"></a>
### 18.4.3 Erasure des Paramètres de Type Avec Bound

Si le paramètre de type a un bound:

```java
class TaskRunner<T extends Runnable> {

    void run(T task) { task.run(); }
	
}
```

Alors l’erasure de `T` est le premier bound trouvé par le compilateur: dans ce cas spécifique `Runnable`.

```java
class TaskRunner {
    void run(Runnable task) { task.run(); }
}
```

<a id="1844-bounds-multiples-le-premier-bound-détermine-lerasure"></a>
### 18.4.4 Bounds Multiples: Le Premier Bound Détermine l’Erasure

Java permet des bounds multiples:

```java
<T extends Runnable & Serializable & Cloneable>
```

!!! important
    L’erasure de `T` est toujours le **premier bound**, qui doit être une classe ou une interface.

Puisque `Runnable` est le premier bound, le compilateur effectue l’erasure de `T` à `Runnable`.

- Exemple avec Bounds Multiples (Entièrement Développé)

```java
public static <T extends Runnable & Serializable & Cloneable>
void runAll(List<T> list) {
    for (T t : list) {
        t.run();
    }
}
```

Version avec Erasure

```java
public static void runAll(List list) {
    for (Object obj : list) {
        Runnable t = (Runnable) obj;   // cast inséré par le compilateur
        t.run();
    }
}
```

Que se passe-t-il avec les autres bounds (Serializable, Cloneable)?

- Ils sont appliqués seulement à compile time.
- Ils n’apparaissent PAS dans le bytecode.
- Aucune interface supplémentaire n’est associée au type avec erasure.

<a id="1845-pourquoi-seulement-le-premier-bound-devient-le-type-à-runtime"></a>
### 18.4.5 Pourquoi Seulement le Premier Bound Devient le Type à Runtime?

Parce que la JVM doit opérer en utilisant un seul type de référence concret pour chaque variable ou paramètre.

Les instructions bytecode à runtime comme `invokevirtual` exigent une seule classe ou interface, pas un type composé comme “Runnable & Serializable & Cloneable”.

!!! note
    Java sélectionne le **premier bound** comme type à runtime, et utilise les bounds restants seulement pour la **validation à compile-time**.

<a id="1846-un-exemple-plus-complexe"></a>
### 18.4.6 Un Exemple Plus Complexe

```java
interface A { void a(); }
interface B { void b(); }

class C implements A, B {
    public void a() {}
    public void b() {}
}

class Demo<T extends A & B> {
    void test(T value) {
        value.a();
        value.b();
    }
}
```

Version avec Erasure

```java
class Demo {
    void test(A value) {
        value.a();
        // value.b();   // ❌ non disponible après l’erasure: le type est A, pas B
    }
}
```

!!! note
    Le compilateur peut insérer des casts supplémentaires ou des méthodes bridge dans des scénarios d’héritage plus complexes, mais l’erasure utilise toujours seulement le premier bound (A dans ce cas).


<a id="1847-redéfinition-et-génériques"></a>
### 18.4.7 Redéfinition (Overriding) et Génériques

Lorsque les génériques interagissent avec l’héritage, deux règles fondamentales doivent être clairement comprises :

!!! important
    **La redéfinition est vérifiée après l’effacement des types (type erasure).**  
    **La compatibilité des types est vérifiée avant l’effacement.**

Ces deux étapes expliquent pourquoi certaines méthodes redéfinissent correctement, tandis que d’autres provoquent des erreurs de compilation.


<a id="18471-comment-le-compilateur-valide-une-redéfinition"></a>
#### 18.4.7.1 Comment le compilateur valide une redéfinition

Lorsqu’une sous-classe déclare une méthode qui *pourrait* redéfinir une méthode de la superclasse, le compilateur effectue deux vérifications :

1. **Avant l’effacement**  
   La méthode doit être compatible avec celle de la classe parente :
   - Même nom
   - Même types de paramètres (y compris les arguments génériques)
   - Type de retour compatible (covariance autorisée)

2. **Après l’effacement**  
   Les signatures effacées doivent correspondre exactement.

Les deux conditions doivent être satisfaites.


<a id="18472-paramètres-génériques-et-redéfinition"></a>
#### 18.4.7.2 Paramètres génériques et redéfinition

Les arguments de type générique font partie de la signature de la méthode **à la compilation**, mais disparaissent après l’effacement.

Par conséquent :

- Il est permis **d’effacer l’information générique dans la méthode redéfinie**
- Il est interdit **d’ajouter une nouvelle spécificité générique**
- Si les deux méthodes utilisent des types paramétrés, ils doivent correspondre exactement


<a id="18473-redéfinition-valide-suppression-de-spécificité-générique"></a>
#### 18.4.7.3 Redéfinition valide — Suppression de la spécificité générique

```java
class Parent {
    void process(Set<Integer> data) {}
}

class Child extends Parent {
    @Override
    void process(Set data) {}   // ✔ autorisé (type brut)
}
```

Explication :

- Avant l’effacement : `Set` est compatible par affectation avec `Set<Integer>`
- Après l’effacement : les deux deviennent `Set`

✔ Redéfinition valide.


<a id="18474-redéfinition-invalide-ajout-de-spécificité-générique"></a>
#### 18.4.7.4 Redéfinition invalide — Ajout de spécificité générique

```java
class Parent {
    void process(Set data) {}
}

class Child extends Parent {
    void process(Set<Integer> data) {}   // ❌ erreur de compilation
}
```

Explication :

- Avant l’effacement : `Set<Integer>` n’est PAS compatible par affectation avec `Set`
- Le compilateur rejette la méthode avant même d’appliquer l’effacement



<a id="18475-redéfinition-valide-paramétrage-identique"></a>
#### 18.4.7.5 Redéfinition valide — Paramétrage identique

```java
class Parent {
    void process(Set<Integer> data) {}
}

class Child extends Parent {
    @Override
    void process(Set<Integer> data) {}   // ✔ correspondance exacte
}
```

Les deux vérifications réussissent :
- Compatible avant l’effacement
- Identique après l’effacement



<a id="18476-redéfinition-invalide-changement-dargument-générique"></a>
#### 18.4.7.6 Redéfinition invalide — Changement d’argument générique

```java
class Parent {
    void process(Set<Integer> data) {}
}

class Child extends Parent {
    void process(Set<String> data) {}   // ❌ erreur de compilation
}
```

Explication :

- Avant l’effacement : `Set<String>` n’est pas compatible avec `Set<Integer>`
- Après l’effacement : les deux deviennent `Set`
- Collision + incompatibilité → erreur de compilation


<a id="18477-pourquoi-cette-règle-existe"></a>
#### 18.4.7.7 Pourquoi cette règle existe

Java doit garantir :

- **La sûreté des types à la compilation**
- **Le polymorphisme à l’exécution après effacement**

Comme les génériques disparaissent à l’exécution, la JVM ne voit que les signatures effacées.  
Le compilateur doit donc assurer la compatibilité avant l’effacement et la cohérence après l’effacement.



<a id="18478-modèle-mental"></a>
#### 18.4.7.8 Modèle mental

Considérez la redéfinition avec génériques comme une vérification en deux phases :

```text
Phase 1 → Les types au niveau source sont-ils compatibles ?
Phase 2 → Les signatures effacées correspondent-elles ?
```

Si l’une des phases échoue → erreur de compilation.



<a id="18479-règles-résumé"></a>
#### 18.4.7.9 Règles récapitulatives

- La redéfinition est validée **après l’effacement**
- La compatibilité est validée **avant l’effacement**
- Il est possible d’effacer l’information générique dans la sous-classe
- Il est interdit d’introduire une nouvelle spécificité générique
- Si les deux méthodes sont paramétrées, les arguments doivent correspondre exactement
- Après l’effacement, les signatures doivent être identiques

Cela explique pourquoi certaines méthodes qui *semblent* être des surcharges sont rejetées :  
après l’effacement, elles entrent en collision, et si elles ne constituent pas une redéfinition valide, le compilateur les bloque.



<a id="1848-surcharge-dune-méthode-générique--pourquoi-certaines-surcharges-sont-impossibles"></a>
### 18.4.8 Surcharge d’une Méthode Générique — Pourquoi Certaines Surcharges Sont Impossibles

Quand Java compile du code générique, il applique la type erasure:
les paramètres de type comme T sont supprimés, et le compilateur les remplace par leur type erasure (habituellement Object ou le premier bound).

Pour cette raison, deux méthodes qui semblent différentes au niveau source peuvent devenir identiques après l’erasure.

Si les `signature` avec erasure sont les mêmes, Java ne peut pas les distinguer, donc le code ne compile pas.

- Exemple: Deux Méthodes qui S’effondrent sur la Même `Signature`

```java
public class Demo {
    public void testInput(List<Object> inputParam) {}

    // public void testInput(List<String> inputParam) {}   // ❌ Erreur de compilation: après l’erasure, les deux deviennent testInput(List)
}
```

Explication

```bash
List<Object> et List<String> sont tous deux effacés en List.
```

À runtime les deux méthodes apparaîtraient comme:

```java
void testInput(List inputParam)
```

Java ne permet pas deux méthodes avec des signatures identiques dans la même classe, donc la surcharge est rejetée à compile time.

<a id="1849-surcharge-dune-méthode-générique-héritée-dune-classe-parent"></a>
### 18.4.9 Surcharge d’une Méthode Générique Héritée d’une Classe Parent

La même règle s’applique quand une subclass tente d’introduire une méthode qui, après erasure, a la même signature qu’une dans la superclass.

```java
public class SubDemo extends Demo {
    public void testInput(List<Integer> inputParam) {} 
    // ❌ Erreur de compilation: erasure → testInput(List), identique au parent
}
```

Encore une fois, le compilateur rejette la surcharge parce que les signatures avec erasure entrent en collision.

**Quand la Surcharge Fonctionne**

L’erasure supprime seulement les paramètres génériques, pas la classe réelle utilisée comme paramètre de méthode.

Donc, si deux paramètres diffèrent dans le type raw (non générique), la surcharge est légale.

```java
public class Demo {
    public void testInput(List<Object> inputParam) {}
    public void testInput(ArrayList<String> inputParam) {}  // ✔ Compile
}
```

**Pourquoi ça fonctionne**

Même si ArrayList<String> devient ArrayList, et List<Object> devient List, ce sont des classes différentes (ArrayList vs List), donc les signatures restent distinctes:

```java
void testInput(List inputParam)
void testInput(ArrayList inputParam)
```

Aucune collision → surcharge légale.

<a id="18410-retourner-des-types-génériques--règles-et-restrictions"></a>
### 18.4.10 Retourner des Types Génériques — Règles et Restrictions

Quand on retourne une valeur depuis une méthode, Java suit une règle rigide:

Le type de retour d’une méthode en overriding doit être un sous-type du type de retour du parent, et tout argument générique doit rester type-compatible (même s’il est effacé à runtime).

Cela confond souvent les programmeurs, parce que les generics sur les types de retour causent des conflits similaires à ceux des paramètres.

Points Clés:
- La **covariance du type de retour s’applique seulement au type raw**, pas aux arguments génériques.
- Les arguments génériques doivent rester compatibles après l’erasure (ils doivent coïncider).
- **Deux méthodes ne peuvent pas différer seulement par le paramètre générique dans le type de retour**.

Exemple: substitution Illégale du Type de Retour à Cause d’Incompatibilité Générique

```java
class A {
    List<String> getData() { return null; }
}

class B extends A {
    // List<Integer> n’est pas un type de retour covariant de List<String>
    // ❌ Erreur de compilation
    List<Integer> getData() { return null; }
}
```

Explication:

Même si les generics sont effacés, Java impose quand même la type safety au niveau source:

```java
List<Integer> n’est pas un sous-type de List<String>.
```

Les deux deviennent List, mais Java rejette l’override qui casse la compatibilité de type.

- Exemple: Type de Retour Covariant Légal

```java
class A {
    Collection<String> getData() { return null; }
}

class B extends A {
    List<String> getData() { return null; }  // ✔ List est un sous-type de Collection
}
```

Ceci est permis parce que:
- Les types raw sont covariants (List étend Collection).
- Les arguments génériques coïncident (String vs String).

-
- Exemple: Surcharge Illégale Basée Seulement sur le Type de Retour

```java
class Demo {
    List<String> getList() { return null; }

    // List<Integer> getList() { return null; }  
    // ❌ Erreur de compilation: le type de retour seul ne distingue pas les méthodes
}
```

**Java n’utilise pas le type de retour pour distinguer les méthodes en surcharge**.

<a id="18411-récapitulatif-des-règles-derasure"></a>
### 18.4.11 Récapitulatif des Règles d’Erasure

- `T sans bound` → erasure à Object.
- `T extends X` → erasure à X.
- `T extends X & Y & Z` → erasure à X.
- Tous les paramètres génériques sont effacés dans les signatures des méthodes.
- Des casts sont insérés pour préserver la typisation à compile-time.
- Des méthodes bridge peuvent être générées pour préserver le polymorphisme.

---

<a id="185-bounds-sur-les-paramètres-de-type"></a>
## 18.5 Bounds sur les Paramètres de Type

<a id="1851-upper-bounds-extends"></a>
### 18.5.1 Upper Bounds: extends

`<T extends Number>` signifie **T doit être Number ou une sous-classe**.

```java
class Stats<T extends Number> {
    T num;
    Stats(T num) { this.num = num; }
}
```

<a id="1852-bounds-multiples"></a>
### 18.5.2 Bounds Multiples

Syntaxe: `T extends Class & Interface1 & Interface2 ...`
La classe doit apparaître en premier.

```java
class C<T extends Number & Comparable<T>> { }
```

<a id="1853-wildcard---extends--super"></a>
### 18.5.3 Wildcard: `?`, `? extends`, `? super`

<a id="18531-wildcard-non-limitée-"></a>
#### 18.5.3.1 Wildcard Non Limitée `?`

À utiliser quand on veut accepter une liste de type inconnu:

```java
void printAll(List<?> list) { ... }
```

<a id="18532-wildcard-avec-upper-bound--extends"></a>
#### 18.5.3.2 Wildcard avec Upper Bound `? extends`

```java
List<? extends Number> nums = List.of(1, 2, 3);

Number n = nums.get(0);   // OK
// nums.add(5);           // ❌ on ne peut pas ajouter: type safety
```

> Tu ne peux pas ajouter des éléments (sauf null) à `? extends` parce que tu ne connais pas le sous-type exact.

<a id="18533-wildcard-avec-lower-bound--super"></a>
#### 18.5.3.3 Wildcard avec Lower Bound `? super`

`<? super Integer>` signifie **le type doit être Integer ou une superclasse de Integer**.

```java
List<? super Integer> list = new ArrayList<Number>();
list.add(10);    // OK

Object o = list.get(0); // retourne Object (supertype commun minimal)
```

> **IMPORTANT**
>
> `super` accepte **l’insertion**
>
> `extends` accepte **l’extraction**.

---

<a id="186-generics-et-héritage"></a>
## 18.6 Generics et Héritage

> I generics ne participent PAS à l’héritage.  
> Un `List<String>` n’est pas un sous-type de `List<Object>`; les types paramétrés sont invariants.

```java
List<String> ls = new ArrayList<>();
List<Object> lo = ls;      // ❌ erreur de compilation
```

Au contraire:

```java
List<? extends Object> ok = ls;   // fonctionne
```

---

<a id="187-type-inference-opérateur-diamond"></a>
## 18.7 Type Inference (Opérateur Diamond)

```java
Map<String, List<Integer>> map = new HashMap<>();
```

Le compilateur déduit les arguments génériques à partir de l’affectation.

---

<a id="188-raw-types-compatibilité-legacy"></a>
## 18.8 Raw Types (Compatibilité Legacy)

Un **raw type** désactive les generics, réintroduisant des comportements non sûrs.

```java
List raw = new ArrayList();
raw.add("x");
raw.add(10);   // permis, mais non sûr
```

> Les raw types devraient être évités.

---

<a id="189-tableaux-génériques-non-autorisés"></a>
## 18.9 Tableaux Génériques (Non Autorisés)

Tu ne peux pas créer des tableaux de types paramétrés:

```java
List<String>[] arr = new List<String>[10];   // ❌ erreur de compilation
```

Parce que les tableaux appliquent la type safety à runtime tandis que les generics se basent seulement sur des contrôles à compile-time.

---

<a id="1810-bounded-type-inference"></a>
## 18.10 Bounded Type Inference

```java
static <T extends Number> T identity(T x) { return x; }

int v = identity(10);   // OK
// String s = identity("x"); // ❌ n’est pas un Number
```

---

<a id="1811-wildcard-vs-paramètres-de-type"></a>
## 18.11 Wildcard vs Paramètres de Type

Utilise les **wildcards** quand tu as besoin de flexibilité dans les paramètres.
Utilise les **paramètres de type** quand la méthode doit retourner ou maintenir des informations de type.

- Exemple — wildcard trop faible:

```java
List<?> copy(List<?> list) {
   return list;  // perd des informations de type
}
```

Mieux:

```java
<T> List<T> copy(List<T> list) {
    return list;
}
```

---

<a id="1812-règle-pecs-producer-extends-consumer-super"></a>
## 18.12 Règle PECS (Producer Extends, Consumer Super)

Utilise **? extends** quand le paramètre **produit** des valeurs.
Utilise **? super** quand le paramètre **consomme** des valeurs.

```java
List<? extends Number> listExtends = List.of(1, 2, 3);
List<? super Integer> listSuper = new ArrayList<Number>();

// ? extends → lecture sûre
Number n = listExtends.get(0);

// ? super → écriture sûre
listSuper.add(10);
```

---

<a id="1813-pièges-communs"></a>
## 18.13 Pièges Communs

- Trier des listes avec wildcard: List<? extends Number> ne peut pas accepter d’insertions.
- Mal comprendre que List<Object> N’EST PAS un supertype de List<String>.
- Oublier que les tableaux génériques sont illégaux.
- Penser que les types génériques sont préservés à runtime (ils sont effacés).
- Essayer de surcharger des méthodes en utilisant seulement des paramètres de type différents.

---

<a id="1814-tableau-récapitulatif-des-wildcards"></a>
## 18.14 Tableau Récapitulatif des Wildcards

| Syntaxe | Signification |
| --- | --- |
| `?` | type inconnu (lecture seule sauf méthodes Object) |
| `? extends T` | lire T en sécurité, on ne peut pas ajouter (sauf null) |
| `? super T` | on peut ajouter T, la lecture retourne Object |

---

<a id="1815-récapitulatif-des-concepts"></a>
## 18.15 Récapitulatif des Concepts

```text
Generics = type safety à compile-time
Bounds = limitent les types légaux
Wildcard = flexibilité dans les paramètres
Type Inference = le compilateur déduit les types
Type Erasure = les generics disparaissent à runtime
Bridge Methods = maintiennent le polymorphisme
```

---

<a id="1816-exemple-complet"></a>
## 18.16 Exemple Complet

```java
class Repository<T extends Number> {
    private final List<T> store = new ArrayList<>();

    void add(T value) { store.add(value); }

    T first() { return store.isEmpty() ? null : store.get(0); }

    // méthode générique avec wildcard
    static double sum(List<? extends Number> list) {
        double total = 0;
        for (Number n : list) total += n.doubleValue();
        return total;
    }
}
```
