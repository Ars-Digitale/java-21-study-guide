# 8. Constructions de boucle en Java

### Table des matières

- [8. Constructions de boucle en Java](#8-looping-constructs-in-java)
	- [8.1 La boucle while](#81-the-while-loop)
	- [8.2 La boucle do-while](#82-the-do-while-loop)
	- [8.3 La boucle for](#83-the-for-loop)
	- [8.4 La boucle for-each améliorée](#84-the-enhanced-for-each-loop)
	- [8.5 Boucles imbriquées](#85-nested-loops)
	- [8.6 Boucles infinies](#86-infinite-loops)
	- [8.7 break et continue](#87-break-and-continue)
	- [8.8 Boucles étiquetées](#88-labeled-loops)
	- [8.9 Portée des variables de boucle](#89-loop-variable-scope)
	- [8.10 Code inatteignable après break continue et return](#810-unreachable-code-after-break-continue-and-return)
		- [8.10.1 Code inatteignable après break](#8101-unreachable-code-after-break)
		- [8.10.2 Code inatteignable après continue](#8102-unreachable-code-after-continue)
		- [8.10.3 Code inatteignable après return](#8103-unreachable-code-after-return)

---

Java fournit plusieurs **constructions de boucle** qui permettent l’exécution répétée d’un bloc de code tant qu’une condition est vérifiée.

Les boucles sont essentielles pour l’itération, le parcours de structures de données, les calculs répétitifs et l’implémentation d’algorithmes.

## 8.1 La boucle `while`

La boucle `while` évalue sa **condition booléenne avant chaque itération**.  
Si la condition est `false` dès le début, le corps n’est jamais exécuté.

**Syntaxe**
```java
while (condition) {
    // loop body
}
```

- La condition doit être évaluée comme un booléen.
- La boucle peut s’exécuter zéro ou plusieurs fois.
- Les erreurs courantes incluent l’oubli de mettre à jour la variable de boucle, provoquant une boucle infinie.

- Exemple :
```java
int i = 0;
while (i < 3) {
    System.out.println(i);
    i++;
}
```

Sortie :
```bash
0
1
2
```

---

## 8.2 La boucle `do-while`

La boucle `do-while` évalue sa condition **après** l’exécution du corps, garantissant que le corps s’exécute au moins une fois.

**Syntaxe**
```java
do {
    // loop body
} while (condition);
```

> [!TIP]
> `do-while` nécessite un point-virgule après la parenthèse fermante.

- Exemple :
```java
int x = 5;
do {
    System.out.println(x);
    x--;
} while (x > 5); // body runs once even though condition is false
```

Sortie :
```bash
5
```

---

## 8.3 La boucle `for`

La boucle `for` traditionnelle convient le mieux aux boucles avec une variable compteur.
Elle se compose de trois parties : initialisation, condition, mise à jour.

**Syntaxe**
```java
for (initialization; condition; update) {
    // loop body
}
```

- L’initialisation s’exécute une fois avant le début de la boucle.
- La condition est évaluée avant chaque itération.
- La mise à jour s’exécute après chaque itération.
- L’initialisation et la mise à jour peuvent contenir plusieurs instructions séparées par des virgules.
- Les variables dans l’initialisation doivent toutes être du même type.
- Tout composant peut être omis, mais les points-virgules restent.

- Exemple :
```java
for (int i = 0; i < 3; i++) {
    System.out.println(i);
}
```

Omission de parties :
```java
int j = 0;
for (; j < 3;) {  // valid
    j++;
}
```

Instructions multiples :
```java
int x = 0;
for (long i = 0, c = 3; x < 3 && i < 12; x++, i++) {
    System.out.println(i);
}
```

---

## 8.4 La boucle `for-each` améliorée

Le `for` amélioré simplifie l’itération sur les tableaux et les collections.

**Syntaxe**
```java
for (ElementType var : arrayOrCollection) {
    // loop body
}
```

- La variable de boucle est en lecture seule par rapport à la collection sous-jacente.
- Fonctionne avec n’importe quel `Iterable` ou tableau.
- Ne peut pas supprimer des éléments sans itérateur.

- Exemple :
```java
String[] names = {"A", "B", "C"};
for (String n : names) {
    System.out.println(n);
}
```

Sortie :
```bash
A
B
C
```

---

## 8.5 Boucles imbriquées

Les boucles peuvent être imbriquées ; chacune conserve ses propres variables et conditions.

```java
for (int i = 1; i <= 2; i++) {
    for (int j = 1; j <= 3; j++) {
        System.out.println(i + "," + j);
    }
}
```

Sortie :
```bash
1,1
1,2
1,3
2,1
2,2
2,3
```

---

## 8.6 Boucles infinies

Une boucle est infinie lorsque sa condition est toujours évaluée à `true` ou est omise.

```java
while (true) { ... }
```

```java
for (;;) { ... }
```

> [!TIP]
> Les boucles infinies doivent contenir `break`, `return` ou un contrôle externe.

---

## 8.7 `break` et `continue`

<ins>**break**</ins>
Quitte immédiatement la boucle la plus interne.
```java
for (int i = 0; i < 5; i++) {
    if (i == 2) break;
    System.out.println(i);
}
```

<ins>**continue**</ins>
Saute le reste du corps de la boucle et passe à l’itération suivante.
```java
for (int i = 0; i < 5; i++) {
    if (i % 2 == 0) continue;
    System.out.println(i);
}
```

> [!NOTE]
> `break` et `continue` s’appliquent à la boucle la plus proche à moins que des étiquettes ne soient utilisées.

---

## 8.8 Boucles étiquetées

Une étiquette (identifiant + deux-points) peut être appliquée à une boucle pour permettre à break/continue d’affecter les boucles externes.

```java
labelName:
for (...) {
    for (...) {
        break labelName;
    }
}
```

- Exemple :
```java
outer:
for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= 3; j++) {
        if (j == 2) break outer;
        System.out.println(i + "," + j);
    }
}
```

---

## 8.9 Portée des variables de boucle

- Les variables déclarées dans l’en-tête de la boucle sont limitées à la portée de cette boucle.
- Les variables déclarées à l’intérieur du corps existent uniquement à l’intérieur de ce bloc.

```java
for (int i = 0; i < 3; i++) {
    int x = i * 2;
}
// i and x are not accessible here
```

---

## 8.10 Code inatteignable après `break`, `continue` et `return`

Toute instruction placée **après** `break`, `continue` ou `return` dans le même bloc est considérée comme inatteignable et ne compile pas.

### 8.10.1 Code inatteignable après `break`

```java
for (int i = 0; i < 3; i++) {
    break;
    System.out.println("Unreachable"); // ❌ Compile-time error
}
```

### 8.10.2 Code inatteignable après `continue`

```java
for (int i = 0; i < 3; i++) {
    continue;
    System.out.println("Unreachable"); // ❌ Compile-time error
}
```

> [!NOTE]
> `continue` saute à l’itération suivante, donc le code qui suit n’est jamais exécuté.

### 8.10.3 Code inatteignable après `return`

```java
int test() {
    return 5;
    System.out.println("Unreachable"); // ❌ Compile-time error
}
```

> [!NOTE]
> `return` quitte la méthode immédiatement ; aucune instruction ne peut le suivre.
