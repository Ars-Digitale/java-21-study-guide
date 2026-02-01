# 19. Exceptions et Gestion des Erreurs

### Table des matières

- [19. Exceptions et Gestion des Erreurs](#19-exceptions-et-gestion-des-erreurs)
	- [19.1 Hiérarchie et types dexceptions](#191-hiérarchie-et-types-dexceptions)
		- [19.1.1 Throwable](#1911-throwable)
		- [19.1.2 Error (unchecked)](#1912-error-unchecked)
		- [19.1.3 Exceptions Checked (`Exception`)](#1913-exceptions-checked-exception)
		- [19.1.4 Exceptions Unchecked (`RuntimeException`)](#1914-exceptions-unchecked-runtimeexception)
	- [19.2 Déclarer et lancer des exceptions](#192-déclarer-et-lancer-des-exceptions)
		- [19.2.1 Déclarer des exceptions avec throws](#1921-déclarer-des-exceptions-avec-throws)
		- [19.2.2 Lancer des exceptions](#1922-lancer-des-exceptions)
	- [19.3 Redéfinition de méthodes et règles sur les exceptions](#193-redéfinition-de-méthodes-et-règles-sur-les-exceptions)
	- [19.4 Gestion des exceptions: try, catch, finally](#194-gestion-des-exceptions-try-catch-finally)
		- [19.4.1 Syntaxe de base try-catch](#1941-syntaxe-de-base-try-catch)
		- [19.4.2 Plusieurs blocs catch](#1942-plusieurs-blocs-catch)
		- [19.4.3 Multi-catch Java-7](#1943-multi-catch-java-7)
		- [19.4.4 Bloc finally](#1944-bloc-finally)
	- [19.5 Gestion automatique des ressources try-with-resources](#195-gestion-automatique-des-ressources-try-with-resources)
		- [19.5.1 Syntaxe de base](#1951-syntaxe-de-base)
		- [19.5.2 Déclarer plusieurs ressources](#1952-déclarer-plusieurs-ressources)
		- [19.5.3 Portée des ressources](#1953-portée-des-ressources)
	- [19.6 Exceptions supprimées](#196-exceptions-supprimées)
	- [19.7 Résumé des exceptions](#197-résumé-des-exceptions)

Les `Exceptions` constituent le mécanisme structuré de Java pour gérer les conditions anormales à runtime.
Elles permettent de séparer le flux normal dexécution de la logique de gestion des erreurs, améliorant la robustesse, la lisibilité et la correction du programme.

## 19.1 Hiérarchie et types dexceptions

Toutes les exceptions dérivent de `Throwable`.
La hiérarchie définit quelles conditions sont récupérables, lesquelles doivent être déclarées, et lesquelles représentent des défaillances système fatales.

```text
java.lang.Object
└── java.lang.Throwable
    ├── java.lang.Error
    └── java.lang.Exception
        └── java.lang.RuntimeException
```

### 19.1.1 Throwable
- Classe de base pour toutes les erreurs et exceptions
- Fournit message, cause et stack trace
- Seuls `Throwable` et ses sous-classes peuvent être lancés ou capturés

### 19.1.2 Error (unchecked)
- Représente des problèmes graves de la JVM ou du système
- Non destiné à être capturé ou géré
- Exemples: `OutOfMemoryError`, `StackOverflowError`

> [!NOTE]
> Les erreurs indiquent des conditions dont lapplication ne peut généralement pas se remettre.

### 19.1.3 Exceptions Checked (`Exception`)
- Sous-classes de `Exception` **à lexclusion** de `RuntimeException`
- Représentent des conditions que lapplication peut vouloir gérer
- Doivent être soit **capturées** soit **déclarées**
- Exemples: `IOException`, `SQLException`

### 19.1.4 Exceptions Unchecked (`RuntimeException`)
- Sous-classes de `RuntimeException`
- Ne doivent pas obligatoirement être déclarées ou capturées
- Représentent généralement des erreurs de programmation
- Exemples: `NullPointerException`, `IllegalArgumentException`

## 19.2 Déclarer et lancer des exceptions

### 19.2.1 Déclarer des exceptions avec throws
Une méthode déclare les exceptions checked avec la clause `throws`. Cela fait partie du contrat API de la méthode.

```java
void readFile(Path p) throws IOException {
	Files.readString(p);
}
```

> [!NOTE]
> Seules les **exceptions checked** doivent être déclarées. Les exceptions unchecked peuvent lêtre, mais sont généralement omises.

### 19.2.2 Lancer des exceptions
Les exceptions sont créées avec `new` et lancées explicitement avec `throw`.

```java
if (value < 0) {
	throw new IllegalArgumentException("value must be >= 0");
}
```

- `throw` lance exactement une instance dexception
- `throws` déclare les exceptions possibles dans la signature de la méthode

## 19.3 Redéfinition de méthodes et règles sur les exceptions

Lors de la redéfinition dune méthode, les règles sur les exceptions sont strictement appliquées.
- Une méthode redéfinie peut lancer **moins** dexceptions checked ou des exceptions plus **spécifiques**
- Elle peut lancer nimporte quelles exceptions unchecked
- Elle ne peut lancer **aucune nouvelle** exception checked plus large

```java
class Parent {
	void work() throws IOException {}
}

class Child extends Parent {
	@Override
	void work() throws FileNotFoundException {} // OK
}
```

> [!NOTE]
> Modifier uniquement les exceptions unchecked ne viole jamais le contrat de redéfinition.

## 19.4 Gestion des exceptions: try, catch, finally

### 19.4.1 Syntaxe de base try-catch

```java
try {
	riskyOperation();
} catch (IOException e) {
	handle(e);
}
```

- Un bloc `try` doit être suivi dau moins un `catch` ou dun `finally`
- Les `catch` sont évalués de haut en bas

### 19.4.2 Plusieurs blocs catch

```java
try {
	process();
} catch (FileNotFoundException e) {
	recover();
} catch (IOException e) {
	log();
}
```

> [!NOTE]
> Les exceptions plus spécifiques doivent précéder les plus générales, sinon la compilation échoue.
> Si un `catch` pour une superclasse précède celui dune sous-classe, ce dernier devient inatteignable.

### 19.4.3 Multi-catch Java-7

```java
try {
	process();
} catch (IOException | SQLException e) {
	log(e);
}
```

- Les types dexception doivent être non liés (pas parent/enfant)
- La variable capturée est implicitement `final`

### 19.4.4 Bloc finally
Le bloc `finally` sexécute quil y ait exception ou non, sauf en cas darrêt extrême de la JVM.

```java
try {
	open();
} finally {
	close();
}
```

- Utilisé pour la logique de nettoyage
- Sexécute même si `return` est utilisé dans try ou catch

> [!NOTE]
> Un bloc `finally` peut écraser une valeur de retour ou avaler une exception. Cela est déconseillé car cela complique le flux de contrôle.

## 19.5 Gestion automatique des ressources try-with-resources

Le try-with-resources permet la fermeture automatique des ressources implémentant `AutoCloseable`.
Il élimine le besoin dun bloc `finally` explicite dans la plupart des cas.

### 19.5.1 Syntaxe de base

```java
try (BufferedReader br = Files.newBufferedReader(path)) {
	return br.readLine();
}
```

- Les ressources sont fermées automatiquement
- La fermeture a lieu même en cas dexception

### 19.5.2 Déclarer plusieurs ressources

```java
try (InputStream in = Files.newInputStream(p);
		OutputStream out = Files.newOutputStream(q)) {
    in.transferTo(out);
}
```

- Les ressources sont fermées en **ordre inverse** de déclaration

### 19.5.3 Portée des ressources
- Les ressources sont visibles uniquement dans le bloc `try`
- Elles sont implicitement `final`
- Depuis Java 9, on peut déclarer les ressources avant le try-with-resources si elles sont `final` ou effectivement finales

```java
final var firstWriter = Files.newBufferedWriter(filePath);

try (firstWriter; var secondWriter = Files.newBufferedWriter(filePath)) {
	// CODE
}
```

> [!NOTE]
> Tenter de réaffecter une variable ressource provoque une erreur de compilation.

## 19.6 Exceptions supprimées

Lorsque le bloc `try` et la méthode `close()` dune ressource lancent tous deux une exception, Java conserve lexception principale et **supprime** les autres.

```java
try (BadResource r = new BadResource()) {
	throw new RuntimeException("main");
}
```

Si `close()` lance aussi une exception, elle devient **supprimée**.

```java
catch (Exception e) {
	for (Throwable t : e.getSuppressed()) {
		System.out.println(t);
	}
}
```

- L'exeption principale est lancée
- Les exceptions secondaires sont accessibles via `getSuppressed()`

## 19.7 Résumé des exceptions
- Les exceptions checked doivent être capturées ou déclarées
- Les méthodes redéfinies ne peuvent pas élargir les exceptions checked
- Utiliser multi-catch pour une logique de gestion commune
- Préférer try-with-resources au nettoyage via finally
- Les ressources se ferment en ordre inverse
- Les exceptions supprimées préservent le contexte complet de défaillance

