# 13. Mise en forme et localisation en Java

## Table des matières

- [13. Mise en forme et localisation en Java](#13-formatting-and-localizing-in-java)
   - [13.1 Mise en forme des chaînes](#131-string-formatting)
     - [13.1.1 String.format et formatted](#1311-stringformat-and-formatted)
       - [13.1.1.1 Indicateurs pour nombres à virgule flottante](#13111-floating-point-flags)
       - [13.1.1.2 Précision n](#13112-precision-n)
       - [13.1.1.3 Largeur m](#13113-width-m)
       - [13.1.1.4 Indicateur de remplissage par zéro 0](#13114-zero-padding-0-flag)
       - [13.1.1.5 Justification à gauche Indicateur -](#13115-left-justification---flag)
       - [13.1.1.6 Signe explicite Indicateur +](#13116-explicit-sign--flag)
       - [13.1.1.7 Parenthèses pour les négatifs Indicateur (](#13117-parentheses-for-negatives--flag)
       - [13.1.1.8 Combinaison des indicateurs](#13118-combining-flags)
       - [13.1.1.9 Effets du Locale](#13119-locale-effects)
       - [13.1.1.10 Erreurs courantes](#131110-common-pitfalls)
     - [13.1.2 Valeurs de texte personnalisées et échappement](#1312-custom-text-values-and-escaping)
   - [13.2 Mise en forme des nombres](#132-number-formatting)
     - [13.2.1 NumberFormat](#1321-numberformat)
     - [13.2.2 Localisation des nombres](#1322-localizing-numbers)
     - [13.2.3 DecimalFormat et NumberFormat](#1323-decimalformat-and-numberformat)
     - [13.2.4 Structure du pattern DecimalFormat](#1324-decimalformat-pattern-structure)
     - [13.2.5 Le symbole 0 (chiffre obligatoire)](#1325-the-0-symbol-mandatory-digit)
     - [13.2.6 Le symbole # (chiffre optionnel)](#1326-the--symbol-optional-digit)
     - [13.2.7 Combiner 0 et #](#1327-combining-0-and-)
     - [13.2.8 Séparateurs décimaux et de groupement](#1328-decimal-and-grouping-separators)
     - [13.2.9 DecimalFormatSymbols : symboles de format spécifiques au Locale](#1329-decimalformatsymbols-locale-specific-formatting-symbols)
     - [13.2.10 Patterns spéciaux de DecimalFormat](#13210-special-decimalformat-patterns)
     - [13.2.11 Règles et erreurs courantes](#13211-common-rules-and-pitfalls)
   - [13.3 Analyse (parsing) des nombres](#133-parsing-numbers)
     - [13.3.1 Parsing avec DecimalFormat](#1331-parsing-with-decimalformat)
     - [13.3.2 CompactNumberFormat](#1332-compactnumberformat)
   - [13.4 Mise en forme des dates et heures](#134-date-and-time-formatting)
     - [13.4.1 DateTimeFormatter](#1341-datetimeformatter)
     - [13.4.2 Symboles standard de date et d’heure](#1342-standard-datetime-symbols)
     - [13.4.3 datetime.format vs formatter.format](#1343-datetimeformat-vs-formatterformat)
     - [13.4.4 Localisation des dates](#1344-localizing-dates)
   - [13.5 Internationalisation (i18n) et localisation (l10n)](#135-internationalization-i18n-and-localization-l10n)
     - [13.5.1 Locales](#1351-locales)
     - [13.5.2 Catégories de Locale](#1352-locale-categories)
     - [13.5.3 Exemple réel](#1353-real-world-example)
   - [13.6 Properties et Resource Bundles](#136-properties-and-resource-bundles)
     - [13.6.1 Règles de résolution des Resource Bundles](#1361-resource-bundle-resolution-rules)
   - [13.7 Règles et erreurs courantes](#137-common-rules-and-pitfalls)

Ce chapitre fournit un traitement approfondi et pratique de la mise en forme en Java 21.

## 13.1 Mise en forme des chaînes

### 13.1.1 String.format et formatted

`String.format()` crée des chaînes formatées en utilisant des substituts de type printf.

Il est sensible au locale et retourne une nouvelle `String` immuable.

```java
String result = String.format("The User: %s | Score: %d", "Bob", 42);
System.out.println(result);

// Or

System.out.println("The User: %s | Score: %d".formatted("Bob", 42));
```

Sortie :

```bash
The User: Bob | Score: 42
```

**Caractéristiques clés :**

- Utilise des spécificateurs de format tels que `%s` (tout type, généralement des chaînes), `%d` (valeurs entières), `%f` (valeurs à virgule flottante).
- Ne modifie pas les chaînes existantes.
- Lance `IllegalFormatException` si les arguments ne correspondent pas au format.
- Est sensible au locale lorsqu’un `Locale` est fourni.

```java
String price = String.format(Locale.GERMANY, "%.2f", 1234.5);
// Sortie (locale allemand) : 1234,50
```

### 13.1.1.1 Indicateurs pour nombres à virgule flottante

`%f` est utilisé pour formater les nombres à virgule flottante (`float`, `double`, `BigDecimal`) en notation décimale.

```java
System.out.printf("%f%n", 12.345);
```

```bash
12.345000
```

- Affiche toujours 6 chiffres après le séparateur décimal par défaut.
- Utilise l’arrondi (et non la troncature).
- Est sensible au locale pour le séparateur décimal.

### 13.1.1.2 Précision (.n)

La précision définit le nombre de chiffres affichés **après** le séparateur décimal.

```java
System.out.printf("%.2f%n", 12.345);
```

```bash
12.35
```

- `%.0f` n’affiche aucun chiffre décimal.
- L’arrondi est appliqué.
- La précision est appliquée avant le remplissage de la largeur.


### 13.1.1.3 Largeur (m)

La largeur définit le nombre total minimal de caractères dans la sortie.

```java
System.out.printf("%8.2f%n", 12.34);
```

```bash
   12.34
```

- Remplit avec des espaces par défaut.
- Si la valeur est plus longue, la largeur est ignorée (elle ne tronque jamais).
- Le remplissage est appliqué à gauche par défaut.

### 13.1.1.4 Indicateur de remplissage par zéro `0`

L’indicateur `0` remplace le remplissage par des espaces par des zéros.

```java
System.out.printf("%08.2f%n", 12.34);
```

```bash
00012.34
```

- Nécessite une largeur.
- Les zéros sont insérés après le signe.
- Ignoré si la justification à gauche est présente (indicateur `-`).

### 13.1.1.5 Justification à gauche Indicateur `-`

L’indicateur `-` aligne la valeur à gauche à l’intérieur de la largeur.

```java
System.out.printf("%-8.2f%n", 12.34);
```

```bash
12.34   
```

- Le remplissage est déplacé vers la droite.
- Écrase le remplissage par zéro.

### 13.1.1.6 Signe explicite Indicateur `+`

L’indicateur `+` force l’affichage du signe pour les nombres positifs.

```java
System.out.printf("%+8.2f%n", 12.34);
```

```bash
   +12.34
```

- Les nombres négatifs affichent déjà `-`.
- Écrase l’indicateur espace (qui affiche un espace en tête pour les valeurs positives).

### 13.1.1.7 Parenthèses pour les négatifs Indicateur `(`

L’indicateur `(` formate les nombres négatifs en utilisant des parenthèses.

```java
System.out.printf("%(8.2f%n", -12.34);
```

```bash
 (12.34)
```

- N’affecte que les valeurs négatives.
- Rarement utilisé en pratique, mais pertinent pour la certification.

### 13.1.1.8 Combinaison des indicateurs

```java
System.out.printf("%+010.2f%n", 12.34);
```

```bash
+000012.34
```

Ordre d’évaluation (simplifié) :

- La précision est appliquée.
- Le signe est traité.
- La largeur est appliquée.
- Le remplissage (espaces ou zéros) est appliqué.

### 13.1.1.9 Effets du Locale

```java
System.out.printf(Locale.FRANCE, "%,.2f%n", 12345.67);
```

```bash
12 345,67
```

Les séparateurs décimaux et de groupement dépendent du `Locale` actif.

### 13.1.1.10 Erreurs courantes

- `%f` utilise 6 décimales par défaut si aucune précision n’est spécifiée.
- La largeur ne tronque jamais la sortie ; elle ne fait qu’ajouter du remplissage si nécessaire.
- L’indicateur `0` est ignoré lorsque `-` est présent.
- `+` écrase l’indicateur espace.
- Le groupement et les séparateurs dépendent du Locale.

### 13.1.2 Valeurs de texte personnalisées et échappement

Certains caractères ont une signification particulière dans les chaînes de format et doivent être échappés.

- `%%` → signe pourcentage littéral.
- `\n`, `\t` → échappements Java standards.

```java
String msg = String.format("Completion: %d%%%nStatus: OK", 100);
System.out.println(msg);
```

Sortie :

```bash
Completion: 100%
Status: OK
```

> [!NOTE]
> Un seul % sans spécificateur valide provoque une IllegalFormatException à l’exécution.

## 13.2 Mise en forme des nombres

### 13.2.1 NumberFormat

`NumberFormat` est une classe abstraite utilisée pour formater et analyser les nombres de manière sensible au locale.

```java
NumberFormat nf = NumberFormat.getInstance(Locale.FRANCE);
System.out.println(nf.format(1234567.89));
```

> [!IMPORTANT]
> - Les méthodes factory déterminent le style de formatage (général, entier, monnaie, pourcentage, compact, ...).
> - Le formatage dépend du `Locale` fourni.
> - `NumberFormat` (et `DecimalFormat`) ne sont pas thread-safe.

### 13.2.2 Localisation des nombres

La localisation des nombres affecte les séparateurs décimaux, les séparateurs de groupement et les symboles monétaires.

```java
NumberFormat nfUS = NumberFormat.getInstance(Locale.US);
NumberFormat nfIT = NumberFormat.getInstance(Locale.ITALY);

System.out.println(nfUS.format(1234.56)); // 1,234.56
System.out.println(nfIT.format(1234.56)); // 1.234,56
```

### 13.2.3 DecimalFormat et NumberFormat

`DecimalFormat` est une sous-classe concrète de `NumberFormat` qui offre un contrôle fin de la mise en forme numérique à l’aide de patterns.

`NumberFormat` définit un formatage sensible au locale via des méthodes factory, tandis que `DecimalFormat` permet un contrôle explicite basé sur des patterns.

```java
NumberFormat nf = NumberFormat.getInstance(Locale.US);
DecimalFormat df = (DecimalFormat) nf;
```

Ou directement :

```java
DecimalFormat df = new DecimalFormat("#,##0.00");
```

> [!NOTE]
> - `DecimalFormat` est mutable (on peut modifier le pattern, les symboles, etc.).
> - `DecimalFormat` n’est pas thread-safe.
> - Le formatage est sensible au locale via `DecimalFormatSymbols`.

### 13.2.4 Structure du pattern DecimalFormat

Un pattern peut contenir une sous-structure positive et une sous-structure négative optionnelle, séparées par `;`.

```text
#,##0.00;(#,##0.00)
```

> [!NOTE]
> - Première partie → nombres positifs.
> - Seconde partie → nombres négatifs.
> - Si la partie négative est omise, les nombres négatifs utilisent automatiquement un `-` en tête.

### 13.2.5 Le symbole `0` (chiffre obligatoire)

Le symbole `0` force l’affichage d’un chiffre, en complétant avec des zéros si nécessaire.

```java
DecimalFormat df = new DecimalFormat("0000.00");
System.out.println(df.format(12.3));
```

```bash
0012.30
```

- Contrôle le nombre minimal de chiffres.
- Complète avec des zéros si le nombre contient moins de chiffres.
- Utile pour des sorties à largeur fixe ou alignées.

### 13.2.6 Le symbole `#` (chiffre optionnel)

Le symbole `#` affiche un chiffre uniquement s’il existe.

```java
DecimalFormat df = new DecimalFormat("####.##");
System.out.println(df.format(12.3));
```

```bash
12.3
```

- Supprime les zéros initiaux.
- Supprime les zéros finaux inutiles.
- Adapté à un formatage « convivial ».

### 13.2.7 Combiner `0` et `#`

Les patterns combinent souvent les deux symboles pour plus de flexibilité.

```java
DecimalFormat df = new DecimalFormat("#,##0.##");
System.out.println(df.format(12));
System.out.println(df.format(12.5));
System.out.println(df.format(12345.678));
```

```bash
12
12.5
12,345.68
```

Explication du pattern :

```text
#,##0 . ##
 ^  ^    ^
 |  |    |
 |  |    └─ chiffres fractionnaires optionnels (#)
 |  └───── chiffre entier obligatoire (0)
 └──────── pattern de groupement (,)
```

- Au moins un chiffre entier est garanti (le `0`).
- Les chiffres sont regroupés par milliers à l’aide du séparateur de groupement.
- Les chiffres fractionnaires sont optionnels (jusqu’à deux).

### 13.2.8 Séparateurs décimaux et de groupement

Dans les patterns :

- `.` → séparateur décimal.
- `,` → séparateur de groupement.

Les symboles effectivement utilisés à l’exécution dépendent du `Locale` (par exemple, virgule vs point).

### 13.2.9 DecimalFormatSymbols : symboles de format spécifiques au Locale

```java
DecimalFormatSymbols symbols =
        DecimalFormatSymbols.getInstance(Locale.FRANCE);

DecimalFormat df =
        new DecimalFormat("#,##0.00", symbols);

System.out.println(df.format(1234.5));
```

```bash
1 234,50
```

- Contrôle les séparateurs décimaux et de groupement.
- Contrôle le signe moins et le symbole monétaire.
- Contrôle les chaînes NaN et Infinity.

### 13.2.10 Patterns spéciaux de DecimalFormat

```text
0.###E0   notation scientifique
###%      pourcentage
¤#,##0.00 monnaie (¤ est le symbole monétaire)
```

### 13.2.11 Règles et erreurs courantes

- `DecimalFormat` est une sous-classe de `NumberFormat`.
- `0` force les chiffres, `#` non.
- Les patterns contrôlent le formatage, pas le mode d’arrondi (utiliser `setRoundingMode()`).
- Le groupement fonctionne uniquement si le séparateur (généralement `,`) est présent dans le pattern.
- Le parsing peut réussir partiellement sans erreur si des caractères finaux suivent un nombre valide.
- `DecimalFormat` est mutable et non thread-safe.

## 13.3 Analyse (parsing) des nombres

L’analyse convertit un texte localisé en valeurs numériques. Par défaut, l’analyse est permissive.

```java
NumberFormat nf = NumberFormat.getInstance(Locale.FRANCE);
Number n = nf.parse("12 345,67abc"); // analyse 12345.67
```

- L’analyse s’arrête au premier caractère invalide.
- Le texte final est ignoré sauf vérification explicite.

### 13.3.1 Parsing avec DecimalFormat

`DecimalFormat` peut également analyser des nombres. L’analyse est permissive par défaut.

```java
DecimalFormat df = new DecimalFormat("#,##0.##");
Number n = df.parse("1,234.56abc");
```

- L’analyse s’arrête au premier caractère invalide.
- Le texte final est ignoré s’il est présent.

Pour imposer une analyse stricte :

```java
df.setParseStrict(true);
```

### 13.3.2 CompactNumberFormat

La mise en forme compacte abrège les grands nombres pour une meilleure lisibilité humaine.

- Prend en charge les styles SHORT et LONG.
- Utilise des abréviations dépendantes du locale (par exemple K, M, « million »).

```java
NumberFormat cnf =
        NumberFormat.getCompactNumberInstance(
                Locale.US, NumberFormat.Style.SHORT);

System.out.println(cnf.format(1_200));        // 1.2K
System.out.println(cnf.format(5_000_000));    // 5M

NumberFormat cnf1 =
        NumberFormat.getCompactNumberInstance(
                Locale.US, NumberFormat.Style.SHORT);

NumberFormat cnf2 =
        NumberFormat.getCompactNumberInstance(
                Locale.US, NumberFormat.Style.LONG);

System.out.println(cnf1.format(315_000_000));   // 315M
System.out.println(cnf2.format(315_000_000));   // 315 million
```

## 13.4 Mise en forme des dates et heures

### 13.4.1 DateTimeFormatter

Java 21 repose sur `java.time` et `DateTimeFormatter` pour la mise en forme moderne des dates et heures.

```java
DateTimeFormatter f =
        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
System.out.println(LocalDateTime.now().format(f));
```

**Propriétés principales :**

- Immuable.
- Thread-safe.
- Sensible au locale.

### 13.4.2 Symboles standard de date et d’heure

```text
y   année
M   numéro du mois (ou nom avec plus de lettres)
d   jour du mois
E   nom du jour
H   heure (0–23)
h   heure (1–12)
m   minute
s   seconde
a   indicateur AM/PM
z   fuseau horaire
```

### 13.4.3 datetime.format vs formatter.format

Les deux méthodes sont fonctionnellement identiques :

```java
date.format(formatter);
formatter.format(date);
```

- `date.format(formatter)` → préféré pour la lisibilité (données d’abord, puis formatage).
- `formatter.format(date)` → parfois pratique dans un code fonctionnel ou avec des formatters réutilisables.

### 13.4.4 Localisation des dates

Les styles localisés adaptent l’affichage des dates aux normes culturelles.

```java
DateTimeFormatter fullIt =
        DateTimeFormatter
                .ofLocalizedDate(FormatStyle.FULL)
                .withLocale(Locale.ITALY);

DateTimeFormatter shortIt =
        DateTimeFormatter
                .ofLocalizedDate(FormatStyle.SHORT)
                .withLocale(Locale.ITALY);

LocalDate today = LocalDate.of(2025, 12, 17);

System.out.println(today.format(fullIt));
System.out.println(today.format(shortIt));
```

Sortie possible :

```bash
mercoledì 17 dicembre 2025
17/12/25
```

## 13.5 Internationalisation (i18n) et localisation (l10n)

### 13.5.1 Locales

Un `Locale` définit la langue, le pays et une variante optionnelle.

```java
Locale l1 = Locale.US;
Locale l2 = Locale.of("fr", "FR");
Locale l3 = new Locale.Builder()
        .setLanguage("en")
        .setRegion("US")
        .build();
```

Formats de Locale :

- `en` (it, fr, etc.) : code langue en minuscules.
- `en_US` (fr_CA, it_IT, etc.) : code langue en minuscules + underscore + code pays en majuscules.

### 13.5.2 Catégories de Locale

Les catégories de Locale séparent la mise en forme de la langue de l’interface utilisateur.

`Locale.Category` permet à Java d’utiliser différents Locale par défaut selon les usages.

Il existe deux catégories :

| Catégorie | Utilisée pour |
| --- | --- |
| FORMAT | Nombres, dates, monnaie, autre formatage |
| DISPLAY | Texte lisible (UI, noms, messages) |

### 13.5.3 Exemple réel

Un utilisateur français vivant en Allemagne peut souhaiter :

- Nombres et dates → format allemand.
- Langue de l’interface → français.

Avant Java 7, cela n’était pas possible.

```java
Locale.setDefault(Locale.Category.FORMAT, Locale.GERMANY);
Locale.setDefault(Locale.Category.DISPLAY, Locale.FRANCE);
```

Exemples d’effets :

| Aspect | Résultat (exemple) |
| --- | --- |
| Nombres | 1.234,56 |
| Dates | 31.12.2025 |
| Monnaie | € |
| Texte UI | Français |
| Noms des mois | décembre |
| Noms des pays | Allemagne |

## 13.6 Properties et Resource Bundles

Les resource bundles externalisent le texte et permettent la localisation sans modifier le code.

```java
ResourceBundle rb =
        ResourceBundle.getBundle("messages", Locale.GERMAN);

String msg = rb.getString("welcome");
```

### 13.6.1 Règles de résolution des Resource Bundles

Java recherche les bundles selon un ordre de repli strict. Par exemple, avec le nom de base `messages` et le locale `de_DE` :

- messages_de_DE.properties
- messages_de.properties
- messages.properties

Si aucun n’est trouvé → `MissingResourceException`.

> [!NOTE]
> Les fichiers `.properties` traditionnels sont spécifiés en ISO-8859-1 ;
> les caractères non ASCII doivent être encodés via des échappements Unicode (par exemple `\u00E9` pour é), sauf si des mécanismes de chargement alternatifs sont utilisés.

## 13.7 Règles et erreurs courantes

- `DateTimeFormatter` est immuable et thread-safe.
- `NumberFormat` / `DecimalFormat` sont mutables et non thread-safe.
- Modifier le `Locale` affecte la manière dont les valeurs sont formatées et analysées, et non les valeurs numériques ou temporelles sous-jacentes.
- L’analyse avec `NumberFormat` ou `DecimalFormat` peut réussir partiellement sans exception si du texte supplémentaire suit un nombre valide.
- `java.time` remplace la plupart des usages des anciennes API `java.util.Date` / `Calendar` dans le code moderne et à l’examen.

