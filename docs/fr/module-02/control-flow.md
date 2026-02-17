# 7. Flux de contrôle

<a id="table-des-matières"></a>
### Table des matières


- [7.1 L’instruction if](#71-linstruction-if)
- [7.2 L’instruction & l’expression switch](#72-linstruction-switch--lexpression)
	- [7.2.1 La variable cible du switch peut être](#721-la-variable-cible-du-switch-peut-être)
	- [7.2.2 Valeurs case acceptables](#722-valeurs-case-acceptables)
	- [7.2.3 Compatibilité de type entre selector et case](#723-compatibilité-de-type-entre-selector-et-case)
	- [7.2.4 Pattern matching dans switch](#724-pattern-matching-dans-switch)
		- [7.2.4.1 Noms de variables et portée entre les branches](#7241-noms-de-variables-et-portée-entre-les-branches)
		- [7.2.4.2 Ordonnancement, dominance et exhaustivité dans les switch à patterns](#7242-ordonnancement-dominance-et-exhaustivité-dans-les-switch-à-patterns)
- [7.3 Deux formes de switch : switch Statement vs switch Expression](#73-deux-formes-de-switch--switch-statement-vs-switch-expression)
	- [7.3.1 L’instruction switch](#731-linstruction-switch)
		- [7.3.1.1 Comportement de fall-through](#7311-comportement-de-fall-through)
	- [7.3.2 L’expression switch](#732-lexpression-switch)
		- [7.3.2.1 yield dans les blocs d’expression switch](#7321-yield-dans-les-blocs-dexpression-switch)
		- [7.3.2.2 Exhaustivité pour les expressions switch](#7322-exhaustivité-pour-les-expressions-switch)
- [7.4 Gestion de null](#74-gestion-de-null)


---

Le **flux de contrôle** en Java fait référence à l’**ordre dans lequel les instructions individuelles, les commandes ou les appels de méthode sont exécutés** pendant l’exécution du programme.

Par défaut, les instructions s’exécutent séquentiellement de haut en bas, mais les instructions de contrôle du flux permettent au programme de **prendre des décisions**, **répéter des actions** ou **dériver les chemins d’exécution** en fonction de conditions.

Java fournit trois grandes catégories de constructions de contrôle du flux :

- **Instructions décisionnelles** — `if`, `if-else`, `switch`
- **Instructions de boucle** — `for`, `while`, `do-while` et le `for` amélioré
- **Instructions de branchement** — `break`, `continue` et `return`

!!! tip
    Comprendre le flux de contrôle est essentiel pour voir comment les données circulent dans votre programme et comment chaque décision logique est évaluée étape par étape.

<a id="71-linstruction-if"></a>
## 7.1 L’instruction `if`

L’instruction `if` est une structure conditionnelle de contrôle du flux qui exécute un bloc de code uniquement si une expression booléenne spécifiée est évaluée à `true`. Elle permet au programme de prendre des décisions à l’exécution.

**Syntaxe :**

```java
if (condition) {
	// exécuté uniquement lorsque la condition est true
}
```

Une clause `else` optionnelle gère le chemin alternatif :

```java
if (score >= 60) {
	System.out.println("Passed");
} else {
	System.out.println("Failed");
}
```

Plusieurs conditions peuvent être chaînées à l’aide de `else if` :

```java
if (grade >= 90) {
	System.out.println("A");
} else if (grade >= 80) {
	System.out.println("B");
} else if (grade >= 70) {
	System.out.println("C");
} else {
	System.out.println("D or below");
}
```

!!! note
    La condition de `if` doit être évaluée comme un **boolean** ; les types numériques ou les objets ne peuvent pas être utilisés directement comme conditions.
    
    Les accolades `{}` sont facultatives pour une seule instruction mais sont fortement recommandées afin d’éviter des erreurs logiques subtiles.
    
    Une chaîne `if-else` est évaluée de haut en bas, et seul le premier branchement dont la condition est évaluée à `true` est exécuté.

---

<a id="72-linstruction-switch--lexpression"></a>
## 7.2 L’instruction `switch` & l’expression

La construction `switch` est une structure de contrôle du flux qui sélectionne une branche parmi plusieurs alternatives en fonction de la valeur d’une expression (le **selector**).

Comparé aux longues chaînes de `if-else-if`, un `switch` :

- Est souvent **plus facile à lire** lorsqu’on teste de nombreuses valeurs discrètes (constantes, enums, chaînes).
- Peut être **plus sûr et plus concis** lorsqu’il est utilisé comme **expression switch** parce que :

Il produit une valeur.

Le compilateur peut imposer l’**exhaustivité** et la **cohérence de type**.

Java 21 prend en charge :

- Le `switch` classique en tant qu’**instruction** (contrôle du flux uniquement).
- Le `switch` en tant qu’**expression** (produit un résultat).
- **Le pattern matching** dans `switch`, y compris les type patterns et les guards.

Les deux formes de `switch` partagent les mêmes règles concernant le selector (la **variable cible** du switch) et les valeurs case acceptables.

<a id="721-la-variable-cible-du-switch-peut-être"></a>
### 7.2.1 La `variable cible` du switch peut être

| Control Variable type |
| --- |
| `byte` / `Byte` |
| `short` / `Short` |
| `char` / `Character` |
| `int` / `Integer` |
| `String` |
| Enum types (selectors of an `enum`) |
| Any reference type (with pattern matching) |
| `var` (if it resolves to one of the allowed types) |

!!! warning
    **Non autorisé** comme type de selector pour switch :
    
    - `boolean`
    - `long`
    - `float`
    - `double`

<a id="722-valeurs-case-acceptables"></a>
### 7.2.2 Valeurs `case` acceptables

Pour un switch non pattern, chaque étiquette `case` doit être une constante à la compilation compatible avec le type du selector.

Autorisé comme étiquettes case :

- **Littéraux** tels que `0`, `'A'`, `"ON"`.
- **Constantes enum**, par ex. `RED` ou `Color.GREEN`.
- **Variables constantes final** (constantes à la compilation).

Une variable constante à la compilation :

- Doit être déclarée avec `final` et initialisée dans la même instruction.
- Son initialiseur doit lui-même être une expression constante (généralement en utilisant des littéraux et d’autres constantes à la compilation).

<a id="723-compatibilité-de-type-entre-selector-et-case"></a>
### 7.2.3 Compatibilité de type entre selector et case

Le type du selector et chaque étiquette `case` doivent être compatibles :

- Les constantes numériques des case doivent être dans l’intervalle du type du selector.
- Pour un selector `enum`, les étiquettes case doivent être des constantes de cet `enum`.
- Pour un selector `String`, les étiquettes case doivent être des constantes de chaîne.

<a id="724-pattern-matching-dans-switch"></a>
### 7.2.4 Pattern Matching dans Switch

Le switch en Java 21 prend en charge le pattern matching, y compris :

- **Type patterns** : `case String s`
- **Patterns avec garde** : `case String s when s.length() > 3`
- **Pattern null** : `case null`

Exemple :

```java
String describe(Object o) {
	return switch (o) {
		case null -> "null";
		case Integer i -> "int " + i;
		case String s when s.isEmpty() -> "empty string";
		case String s -> "string (" + s.length() + ")";
		default -> "other";
	};
}
```

**Points clés** :

- Chaque pattern introduit une variable de pattern (comme `i` ou `s`).
- Les variables de pattern sont dans la portée uniquement à l’intérieur de leur arm (ou des chemins où le pattern est connu comme correspondant).
- L’ordre est important en raison de la **dominance** : les patterns plus spécifiques doivent précéder les plus généraux.

<a id="7241-noms-de-variables-et-portée-entre-les-branches"></a>
### 7.2.4.1 Noms de variables et portée entre les branches

Avec le pattern matching, la variable de pattern n’existe que dans la portée de l’arm dans lequel elle est définie. Cela signifie que vous pouvez réutiliser le même nom de variable dans différents branches case.

- Exemple :

```java
switch (o) {
	case String str -> System.out.println(str.length());
	case CharSequence str -> System.out.println(str.charAt(0));
	default -> { }
}
```

!!! note
    Ce dernier exemple ne retourne pas de valeur, il s’agit donc d’un **switch instruction** et non d’une expression switch.

<a id="7242-ordonnancement-dominance-et-exhaustivité-dans-les-switch-à-patterns"></a>
### 7.2.4.2 Ordonnancement, dominance et exhaustivité dans les switch à patterns

Lorsqu’on utilise le pattern matching, l’ordre des branches est crucial en raison de la **dominance** et du potentiel **code inatteignable**.

Un pattern plus général ne doit **pas** apparaître avant un pattern plus spécifique, sinon ce dernier devient inatteignable.

- Exemple (branche inatteignable) :

```java
return switch (o) {
	case Object obj -> "object";
	case String s -> "string"; // ❌ DOES NOT COMPILE: unreachable, String is already matched by Object
};
```

- Autre exemple avec une garde :

```java
return switch (o) {
	case Integer a -> "First";
	case Integer a when a > 0 -> "Second"; // ❌ DOES NOT COMPILE: unreachable, the first case matches all Integers
	// ...
};
```

Lorsqu’on utilise le pattern matching, les switch doivent être **exhaustifs** ; c’est-à-dire qu’ils doivent gérer toutes les valeurs possibles du selector.

Cela peut être réalisé en :

- Fournissant un case `default` qui gère toutes les valeurs non correspondantes aux autres cases.
- Fournissant une clause case finale avec un type de pattern qui correspond au type de référence du selector.

- Exemple (non exhaustif) :

```java
Number number = Short.valueOf(10);

switch (number) {
	case Short s -> System.out.println("A"); // ❌ DOES NOT COMPILE: not exhaustive, selector is of type Number
}
```

Pour corriger cela, vous pouvez :

- Changer le type de référence de `number` en `Short` (l’exhaustivité est alors satisfaite par le seul case).
- Ajouter une clause `default` qui couvre toutes les valeurs restantes.
- Ajouter une clause case finale couvrant le type de la variable selector, par exemple :

```java
Number number = Short.valueOf(10);

switch (number) {
	case Short s -> System.out.println("A");
	case Number n -> System.out.println("B");
}
```

!!! warning
    L’exemple suivant, qui utilise à la fois une clause `default` et une clause finale avec le même type que la variable selector, ne **compile pas** : le compilateur considère l’un des deux cases comme dominant toujours l’autre.

```java
Number number = Short.valueOf(10);

switch (number) {
	case Short s -> System.out.println("A");
	case Number n -> System.out.println("B"); // ❌ DOES NOT COMPILE: dominated by either the default or the Number pattern
	default -> System.out.println("C");
}
```

---

<a id="73-deux-formes-de-switch--switch-statement-vs-switch-expression"></a>
## 7.3 Deux formes de `switch` : `switch` Statement vs `switch` Expression

<a id="731-linstruction-switch"></a>
### 7.3.1 L’instruction switch

Une **instruction switch** est utilisée comme construction de contrôle du flux.

Elle ne s’évalue pas, en elle-même, comme une valeur, bien que ses branches puissent contenir des instructions `return` qui retournent depuis la méthode englobante.

```java
switch (mode) { // switch statement
	case "ON":
		start();
		break; // prevents fall-through
	case "OFF":
		stop();
		break;
	default:
		reset();
}
```

**Points clés** :

- Chaque clause `case` inclut une ou plusieurs valeurs correspondantes séparées par des virgules `,`. Un séparateur suit, qui peut être soit deux-points `:` soit, moins couramment pour les instructions, l’opérateur flèche `->`.
Enfin, une expression ou un bloc (entouré de `{}`) définit le code à exécuter lorsqu’une correspondance se produit.
Si vous utilisez l’opérateur flèche pour une clause, vous devez l’utiliser pour toutes les clauses de cette instruction switch.
- Le fall-through est possible pour les case de style deux-points à moins qu’une branche utilise `break`, `return` ou `throw`.
Lorsqu’il est présent, `break` termine le switch après l’exécution de son case ; sans lui, l’exécution continue, dans l’ordre, vers les branches suivantes.
- Une clause `default` est optionnelle et peut apparaître n’importe où dans l’instruction switch. Elle s’exécute s’il n’y a pas de correspondance pour les cases précédents.
- Une instruction switch ne produit pas de valeur comme une expression ; vous ne pouvez pas assigner directement une instruction switch à une variable.

<a id="7311-comportement-de-fall-through"></a>
### 7.3.1.1 Comportement de fall-through

Avec des case de style deux-points, l’exécution saute à l’étiquette case correspondante.

S’il n’y a pas de `break`, elle continue dans le case suivant jusqu’à ce qu’un `break`, `return` ou `throw` soit rencontré.

```java
int n = 2;

switch (n) {
	case 1:
		System.out.println("1");
	case 2:
		System.out.println("2"); // printed
	case 3:
		System.out.println("3"); // printed (fall-through)
		break;
	default:
		System.out.println("message default");
}
```

Sortie :

```bash
2
3
```

!!! note
    Si, dans l’exemple précédent, nous supprimons le `break` sur le `case 3`, le message de la branche `default` sera également affiché.

<a id="732-lexpression-switch"></a>
### 7.3.2 L’expression switch

Une **expression switch** produit toujours une valeur unique comme résultat.

- Exemple :

```java
int len = switch (s) { // switch expression
	case null -> 0;
	case "" -> 0;
	default -> s.length();
};
```

**Points clés** :

- Chaque clause `case` inclut une ou plusieurs valeurs correspondantes séparées par des virgules `,`, suivies de l’opérateur flèche `->`. Puis une expression ou un bloc (entouré de `{}`) définit le résultat pour cet arm.
- Lorsqu’elle est utilisée avec une assignation ou une instruction `return`, une expression switch nécessite un point-virgule de terminaison `;` après l’expression.
- Il n’y a pas de fall-through entre les arms avec flèche. Chaque arm correspondant est exécuté exactement une fois.
- Une expression switch doit être **exhaustive** : toutes les valeurs possibles du selector doivent être couvertes (via des case explicites et/ou `default`).
- Le type du résultat doit être cohérent entre toutes les branches. Par exemple, si un arm produit un `int`, les autres arms doivent produire des valeurs compatibles avec `int`.

<a id="7321-yield-dans-les-blocs-dexpression-switch"></a>
### 7.3.2.1 `yield` dans les blocs d’expression switch

Lorsqu’un arm d’une expression switch utilise un bloc au lieu d’une expression unique, vous devez utiliser `yield` pour fournir le résultat de cet arm.

```java
int len = switch (s) {
	case null -> 0;
	default -> {
		int l = s.trim().length();
		System.out.println("Length: " + l);
		yield l; // result of this arm
	}
};
```

!!! note
    `yield` est utilisé uniquement dans les expressions switch.
    `break value;` n’est pas autorisé comme moyen de retourner une valeur depuis une expression switch.

<a id="7322-exhaustivité-pour-les-expressions-switch"></a>
### 7.3.2.2 Exhaustivité pour les expressions switch

Puisqu’une expression switch doit retourner une valeur, elle doit également être **exhaustive** ; en d’autres termes, elle doit gérer toutes les valeurs possibles du selector.

Vous pouvez garantir cela en :

- Fournissant un case `default`.
- Pour un selector enum : couvrant explicitement toutes les constantes enum.
- Pour des types sealed ou des pattern switch : couvrant tous les sous-types autorisés ou fournissant un `default`.

Exemple, exhaustif via `default` :

```java
int val = switch (s) {
	case "one" -> 1;
	case "two" -> 2;
	default -> 0;
};
```

---

<a id="74-gestion-de-null"></a>
## 7.4 Gestion de null

**Switch classique (sans patterns)**

Si l’expression selector d’un switch classique (sans pattern matching) est évaluée à `null`, une `NullPointerException` est levée à l’exécution.

Pour éviter cela, vérifiez `null` avant d’effectuer le switch :

```java
if (s == null) {
	// handle null
} else {
	switch (s) {
		case "A" -> ...
		default -> ...
	}
}
```

<ins>**Pattern switch (avec `case null`)**</ins>

Avec le pattern matching, vous pouvez gérer `null` directement à l’intérieur du switch :

```java
int len = switch (s) {
	case null -> 0;
	default -> s.length();
};
```

!!! note
    Pour les expressions switch :
    
    Si vous ne gérez pas `null` et que le selector est `null`, une `NullPointerException` est levée.
    
    L’utilisation de `case null` rend le switch explicitement sûr vis-à-vis de null.

!!! warning
    Chaque fois que `case null` est utilisé dans un switch, le switch est traité comme un pattern switch, et toutes les règles applicables aux pattern switch (y compris l’exhaustivité et la dominance) s’appliquent.
