# Formatting in Java 21 — Comprehensive Certification Chapter

This chapter delivers a **deep, exam-oriented, and practical** treatment of formatting in Java 21. Every topic is expanded with explanations, rules, examples, and certification pitfalls. It is designed both for **Java 21 certification** and for real-world mastery.

## 1. String Formatting

### String.format()

The `String.format()` method creates formatted strings using printf-style placeholders. It is locale-sensitive and returns a new immutable `String`.

```java
String result = String.format("User: %s | Score: %d", "Bob", 42);
System.out.println(result);
```

Key characteristics:

- Uses format specifiers like %s, %d, %f
- Does not modify existing strings
- Throws IllegalFormatException if arguments mismatch
- Locale-sensitive when Locale is provided

```java
String price = String.format(Locale.GERMANY, "%.2f", 1234.5);
// Output: 1234,50
```

> **Note:** 
In certification questions, pay attention to missing arguments or wrong format types — these cause runtime exceptions.


### Custom Text Values and Escaping

Certain characters have special meaning in format strings and must be escaped.

- %% → literal percent sign
- \n, \t → standard Java escapes

```java
String msg = String.format("Completion: %d%%\nStatus: OK", 100);
System.out.println(msg);
```

> **Note:** 
A single % without a valid specifier causes an exception.


## 2. Number Formatting

### NumberFormat

`NumberFormat` is an abstract class used to format and parse numbers in a locale-aware manner.

```java
NumberFormat nf = NumberFormat.getInstance(Locale.FRANCE);
System.out.println(nf.format(1234567.89));
```

Important rules:

- Factory methods determine formatting style
- Formatting depends on Locale
- Not thread-safe

### Localizing Numbers

Number localization affects decimal separators, grouping separators, and currency symbols.

```java
NumberFormat nfUS = NumberFormat.getInstance(Locale.US);
NumberFormat nfIT = NumberFormat.getInstance(Locale.ITALY);

System.out.println(nfUS.format(1234.56)); // 1,234.56
System.out.println(nfIT.format(1234.56)); // 1.234,56
```

### Parsing Numbers

Parsing converts localized text into numeric values. Parsing is lenient by default.

```java
NumberFormat nf = NumberFormat.getInstance(Locale.FRANCE);
Number n = nf.parse("12 345,67abc"); // parses 12345.67
```

- Parsing stops at first invalid character
- Trailing text is ignored unless explicitly checked

> **Note:** 
Certification questions often test silent parsing failures.


### CompactNumberFormat

Compact formatting shortens large numbers for human readability.

```java
NumberFormat cnf =
NumberFormat.getCompactNumberInstance(
Locale.US, NumberFormat.Style.SHORT);

System.out.println(cnf.format(1_200)); // 1.2K
System.out.println(cnf.format(5_000_000)); // 5M
```

- SHORT vs LONG styles
- Locale-dependent abbreviations

## 3. Date and Time Formatting

### DateTimeFormatter

Java 21 relies on `java.time` and `DateTimeFormatter` for modern date/time formatting.

```java
DateTimeFormatter f =
DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
System.out.println(LocalDateTime.now().format(f));
```

Core properties:

- Immutable
- Thread-safe
- Locale-aware

### Standard Date/Time Symbols

```text
y year
M month number
d day of month
E day name
H hour (0–23)
h hour (1–12)
m minute
s second
a AM/PM
z time zone
```

> **Note:** 
Uppercase and lowercase symbols are different and exam-critical.


### datetime.format() vs formatter.format()

Both methods are functionally identical.

```java
date.format(formatter);
formatter.format(date);
```

- datetime.format(formatter) → preferred for clarity
- formatter.format(datetime) → useful in functional code

### Localizing Dates

Localized styles adapt date output to cultural norms.

```java
DateTimeFormatter f =
DateTimeFormatter
.ofLocalizedDate(FormatStyle.FULL)
.withLocale(Locale.ITALY);

System.out.println(LocalDate.now().format(f));
```

## 4. Internationalization (i18n) and Localization (l10n)

### Locales

A `Locale` defines language, country, and optional variant.

```java
Locale l1 = Locale.US;
Locale l2 = Locale.of("fr", "FR");
```

### Locale Categories

Locale categories separate formatting from UI language.

- FORMAT → dates, numbers, currency
- DISPLAY → UI text

```java
Locale.setDefault(Locale.Category.FORMAT, Locale.FRANCE);
```

### Properties and Resource Bundles

Resource bundles externalize text and allow localization without code changes.

```java
ResourceBundle rb =
ResourceBundle.getBundle("messages", Locale.GERMAN);

String msg = rb.getString("welcome");
```

### Resource Bundle Resolution Rules

Java searches bundles in a strict fallback order.

- messages_de_DE.properties
- messages_de.properties
- messages.properties

- If none found → MissingResourceException

> **Note:** 
Properties files must be ISO-8859-1 unless Unicode escapes are used.


## 5. Certification Rules and Common Pitfalls

- DateTimeFormatter is immutable and thread-safe
- NumberFormat is mutable and NOT thread-safe
- Locale changes formatting, not stored values
- Parsing may succeed partially without errors
- java.time replaces Date/Calendar completely

> **Note:** 
In Java certification exams, formatting questions often hide the trap in Locale selection or parsing behavior — always inspect Locale usage first.
