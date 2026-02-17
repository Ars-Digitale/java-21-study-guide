# 25. L’API List

<a id="table-des-matières"></a>
### Table des matières


- [25.1 Caractéristiques des List](#251-caractéristiques-des-list)
- [25.2 Créer des List (Constructeurs)](#252-créer-des-list-constructeurs)
	- [25.2.1 Constructeurs de ArrayList](#2521-constructeurs-de-arraylist)
	- [25.2.2 Constructeurs de LinkedList](#2522-constructeurs-de-linkedlist)
- [25.3 Méthodes Factory](#253-méthodes-factory)
	- [25.3.1 List of immutable](#2531-listof-immuable)
	- [25.3.2 List copyOf immutable-copy](#2532-listcopyof-copie-immuable)
	- [25.3.3 Arrays asList fixed-size-list](#2533-arraysaslist-liste-à-taille-fixe)
- [25.4 Opérations Principales de List](#254-opérations-principales-de-list)
	- [25.4.1 Ajouter des Éléments](#2541-ajouter-des-éléments)
	- [25.4.2 Accéder aux Éléments](#2542-accéder-aux-éléments)
	- [25.4.3 Supprimer des Éléments](#2543-supprimer-des-éléments)
	- [25.4.4 Comportements et Caractéristiques Importants](#2544-comportements-et-caractéristiques-importants)
- [25.5 contains, equals et hashCode](#255-contains-equals-et-hashcode)
	- [25.5.1 contains](#2551-contains)
	- [25.5.2 Égalité des List](#2552-égalité-des-list)
	- [25.5.3 hashCode](#2553-hashcode)
- [25.6 Itérer à Travers une List](#256-itérer-à-travers-une-list)
	- [25.6.1 Boucle For Classique](#2561-boucle-for-classique)
	- [25.6.2 Boucle For Améliorée](#2562-boucle-for-améliorée)
	- [25.6.3 Iterator--ListIterator](#2563-iterator--listiterator)
- [25.7 La Méthode subList](#257-la-méthode-sublist)
	- [25.7.1 Syntaxe](#2571-syntaxe)
	- [25.7.2 Règles](#2572-règles)
	- [25.7.3 Exemples](#2573-exemples)
	- [25.7.4 Modifier la liste parent invalide la vue](#2574-modifier-la-liste-parent-invalide-la-vue)
	- [25.7.5 Modifier la subList modifie le parent](#2575-modifier-la-sublist-modifie-le-parent)
	- [25.7.6 Vider la subList vide une partie de la liste parent](#2576-vider-la-sublist-vide-une-partie-de-la-liste-parent)
	- [25.7.7 Pièges Courants](#2577-pièges-courants)
- [25.8 Tableau Résumé des Opérations Importantes](#258-tableau-résumé-des-opérations-importantes)


---

Dans le `Collections Framework`, une **List** représente une collection ordonnée, basée sur des indices, autorisant les doublons.


L’interface List étend `Collection` et est implémentée par :

```text
List
├── ArrayList (Tableau redimensionnable — accès aléatoire rapide, insertions/suppressions plus lentes au milieu)
├── LinkedList (Liste doublement chaînée — insertions/suppressions rapides, accès aléatoire plus lent)
└── Vector (Liste synchronisée legacy — rarement utilisée aujourd’hui)
```

!!! note
    Vector est legacy et synchronisé — à éviter sauf si explicitement requis.

<a id="251-caractéristiques-des-list"></a>
## 25.1 Caractéristiques des List

- Ordonnées — les éléments préservent l’ordre d’insertion.
- Indexées — accessibles via `get(int)` et `set(int,E)`.
- Autorisent les doublons — `List` n’impose pas l’unicité.
- Peuvent contenir `null` — sauf si l’on utilise des implémentations spéciales.

---

<a id="252-créer-des-list-constructeurs"></a>
## 25.2 Créer des List (Constructeurs)

<a id="2521-constructeurs-de-arraylist"></a>
### 25.2.1 Constructeurs de ArrayList

```java
List<String> a1 = new ArrayList<>();
List<String> a2 = new ArrayList<>(50); // capacité initiale
List<String> a3 = new ArrayList<>(List.of("A", "B"));
```

!!! note
    La capacité initiale n’est pas une taille. Elle décide seulement combien d’éléments le tableau interne peut contenir avant redimensionnement.

<a id="2522-constructeurs-de-linkedlist"></a>
### 25.2.2 Constructeurs de LinkedList

```java
List<String> l1 = new LinkedList<>();
List<String> l2 = new LinkedList<>(List.of("A", "B"));
```

!!! note
    `LinkedList` implémente aussi `Deque`.

---

<a id="253-méthodes-factory"></a>
## 25.3 Méthodes Factory

<a id="2531-listof-immuable"></a>
### 25.3.1 `List.of()` (immuable)

```java
List<String> list1 = List.of("A", "B", "C");
list1.add("X"); // ❌ UnsupportedOperationException
list1.set(0, "Z"); // ❌ UnsupportedOperationException
```

!!! note
    Toutes les listes `List.of()` :
    - rejettent les `null`
    - sont immuables
    - lèvent `UOE` lors d’une modification structurelle

<a id="2532-listcopyof-copie-immuable"></a>
### 25.3.2 `List.copyOf()` (copie immuable)

```java
List<String> src = new ArrayList<>();
src.add("Hello");

List<String> copy = List.copyOf(src); // instantané immuable
```

<a id="2533-arraysaslist-liste-à-taille-fixe"></a>
### 25.3.3 Arrays.asList() (liste à taille fixe)

```java
String[] arr = {"A", "B"};
List<String> list = Arrays.asList(arr);

list.set(0, "Z"); // OK
list.add("X"); // ❌ UOE — la taille est fixe
```

!!! note
    La liste est adossée au tableau : modifier l’un affecte l’autre.

---

<a id="254-opérations-principales-de-list"></a>
## 25.4 Opérations Principales de List

<a id="2541-ajouter-des-éléments"></a>
### 25.4.1 Ajouter des Éléments

```java
list.add("A");
list.add(1, "B"); // insère à l’index
list.addAll(otherList);
list.addAll(2, otherList);
```

<a id="2542-accéder-aux-éléments"></a>
### 25.4.2 Accéder aux Éléments

```java
String x = list.get(0);
list.set(1, "NewValue");
```

!!! note
    `get()` lève `IndexOutOfBoundsException` pour des index invalides.

Si vous essayez de `mettre à jour` un élément dans une List vide, même à l’index 0, vous obtenez une `IndexOutOfBoundsException`

```java
List<Integer> list = new ArrayList<Integer>();
list.add(3);
list.add(5);
System.out.println(list.toString());
list.clear();
list.set(0, 2);
```

Sortie

```bash
[3, 5]
Exception in thread "main" java.lang.IndexOutOfBoundsException: Index 0 out of bounds for length 0
```

!!! warning
    Appeler get/set avec un index invalide lève IndexOutOfBoundsException

<a id="2543-supprimer-des-éléments"></a>
### 25.4.3 Supprimer des Éléments

```java
list.remove(0); // remove(int index) — supprime par index ; remove(Object) — supprime le premier élément égal
list.remove("A"); // supprime la première occurrence
list.removeIf(s -> s.startsWith("X"));
list.clear();
```

<a id="2544-comportements-et-caractéristiques-importants"></a>
### 25.4.4 Comportements et Caractéristiques Importants

|		Opération		|		Comportement			|		Exception(s)			|
|-----------------------|---------------------------|-------------------------------|
|		`add(E)`			|	ajoute toujours à la fin	|		—						|
|		`add(int,E)`		|	décale les éléments vers la droite	|	IndexOutOfBoundsException	|
|		`get(int)`		|	temps constant pour ArrayList, linéaire pour LinkedList |	IndexOutOfBoundsException	|
|		`set(int,E)`		|	remplace l’élément	|	IndexOutOfBoundsException	|
|		`remove(int)`		|	décale les éléments vers la gauche	|	IndexOutOfBoundsException	|
|		`remove(Object)`	|	supprime le premier élément égal	|	—	|

---

<a id="255-contains-equals-et-hashcode"></a>
## 25.5 `contains()`, `equals()` et `hashCode()`

<a id="2551-contains"></a>
### 25.5.1 `contains()`

La Méthode `contains()` utilise `.equals()` sur les éléments.

<a id="2552-égalité-des-list"></a>
### 25.5.2 Égalité des List

`List.equals()` effectue une comparaison élément par élément dans l’ordre.

```java
List<String> a = List.of("A", "B");
List<String> b = List.of("A", "B");

System.out.println(a.equals(b)); // true
```

!!! note
    - L’ordre compte.
    - Le type de liste ne compte PAS.

<a id="2553-hashcode"></a>
### 25.5.3 `hashCode()`

Calculé sur la base du contenu.

---

<a id="256-itérer-à-travers-une-list"></a>
## 25.6 Itérer à Travers une List

<a id="2561-boucle-for-classique"></a>
### 25.6.1 Boucle For Classique

```java
for (int i = 0; i < list.size(); i++) {
	System.out.println(list.get(i));
}
```

<a id="2562-boucle-for-améliorée"></a>
### 25.6.2 Boucle For Améliorée

```java
for (String s : list) {
	System.out.println(s);
}
```

<a id="2563-iterator--listiterator"></a>
### 25.6.3 Iterator & ListIterator

```java
Iterator<String> it = list.iterator();
while (it.hasNext()) { System.out.println(it.next()); }

ListIterator<String> lit = list.listIterator();
while (lit.hasNext()) {
	if (lit.next().equals("A")) lit.set("Z");
}
```

!!! warning
    Tous les itérateurs standard de List sont fail-fast : une modification structurelle en dehors de l’itérateur cause ConcurrentModificationException.

!!! note
    Seul `ListIterator` supporte la traversée bidirectionnelle et la modification.

---

<a id="257-la-méthode-sublist"></a>
## 25.7 La Méthode `subList()`

`subList()` crée une vue d’une portion de la liste, pas une copie.
Modifier l’une des deux peut modifier l’autre.

<a id="2571-syntaxe"></a>
### 25.7.1 Syntaxe

```java
List<E> subList(int fromIndex, int toIndex);
```

<a id="2572-règles"></a>
### 25.7.2 Règles

|			Règle						|				Explication				|
|---------------------------------------|---------------------------------------|
|	fromIndex inclusif					|	l’élément à fromIndex est inclus	|
|	toIndex exclusif					|	l’élément à toIndex n’est PAS inclus  |
|	La vue est adossée à la liste originale	|	modifier l’une modifie l’autre  	|
|	Modification structurelle du parent invalide la subList	|	→ ConcurrentModificationException	|

<a id="2573-exemples"></a>
### 25.7.3 Exemples

```java
List<String> list = new ArrayList<>(List.of("A", "B", "C", "D"));
List<String> view = list.subList(1, 3);
// view = ["B", "C"]

view.set(0, "X");
// list = ["A", "X", "C", "D"]
// view = ["X", "C"]
```

<a id="2574-modifier-la-liste-parent-invalide-la-vue"></a>
### 25.7.4 Modifier la liste parent invalide la vue

```java
List<String> list = new ArrayList<>(List.of("A","B","C","D"));
List<String> view = list.subList(1, 3);

list.add("E"); // modification structurelle de la liste parent

view.get(0); // ❌ ConcurrentModificationException
```

<a id="2575-modifier-la-sublist-modifie-le-parent"></a>
### 25.7.5 Modifier la subList modifie le parent

```java
view.remove(1);
// supprime "C" à la fois de la view et de la liste parent
```

<a id="2576-vider-la-sublist-vide-une-partie-de-la-liste-parent"></a>
### 25.7.6 Vider la subList vide une partie de la liste parent

```java
view.clear();
// supprime les index 1 et 2 du parent
```

<a id="2577-pièges-courants"></a>
### 25.7.7 Pièges Courants

- Supposer que subList est indépendante : c’est une vue, pas une copie
- Supposer que subList permet le redimensionnement : fonctionne uniquement sur des listes parent modifiables
- Oublier que les modifications du parent invalident la vue entraînant ConcurrentModificationException
- Attentes d’index incorrectes : l’index de fin est exclusif

---

<a id="258-tableau-résumé-des-opérations-importantes"></a>
## 25.8 Tableau Résumé des Opérations Importantes


| 	Opération		| 		ArrayList		| 		LinkedList 		| 		List Immuables 	|
|-------------------|-----------------------|-----------------------|---------------------------|
| `add(E)`			|	rapide				|	rapide				|	❌ non supporté			|
| `add(index,E)`		|	lent (shift)		|	rapide				|	❌						|
| `get(index)`		|	rapide				|	lent				|	rapide					|
| `remove(index)` 	| 	lent 				| lent (sauf si suppression du premier/dernier) 		  | ❌ |						
| `remove(Object)`	|	plus lent			|	plus lent			|	❌						|
| `set(index,E)`		|	rapide				|	lent				|	❌						|
| `iterator()`		|	rapide				|	rapide				|	rapide					|
| `listIterator()`	|	rapide				|	rapide				|	rapide					|
| `contains(Object)`	|	O(n)				|	O(n)				|	O(n)					|
