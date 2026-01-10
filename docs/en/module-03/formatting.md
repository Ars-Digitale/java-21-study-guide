# 13. Formatting and Localizing in Java

### Table of Contents

- [13. Formatting and Localizing in Java](#13-formatting-and-localizing-in-java)
  - [13.1 String Formatting](#131-string-formatting)
    - [13.1.1 String.format and formatted](#1311-stringformat-and-formatted)
      - [13.1.1.1 Floating-point Flags](#13111-floating-point-flags)
      - [13.1.1.2 Precision n](#13112-precision-n)
      - [13.1.1.3 Width m](#13113-width-m)
      - [13.1.1.4 Zero Padding 0 Flag](#13114-zero-padding-0-flag)
      - [13.1.1.5 Left Justification--flag](#13115-left-justification-flag)
      - [13.1.1.6 Explicit Sign--flag](#13116-explicit-sign-flag)
      - [13.1.1.7 Parentheses for Negatives--flag](#13117-parentheses-for-negatives-flag)
      - [13.1.1.8 Combining Flags](#13118-combining-flags)
      - [13.1.1.9 Locale Effects](#13119-locale-effects)
      - [13.1.1.10 Common Pitfalls](#131110-common-pitfalls)
    - [13.1.2 Custom Text Values and Escaping](#1312-custom-text-values-and-escaping)
  - [13.2 Number Formatting](#132-number-formatting)
    - [13.2.1 NumberFormat](#1321-numberformat)
    - [13.2.2 Localizing Numbers](#1322-localizing-numbers)
    - [13.2.3 DecimalFormat and NumberFormat](#1323-decimalformat-and-numberformat)
    - [13.2.4 DecimalFormat Pattern Structure](#1324-decimalformat-pattern-structure)
    - [13.2.5 The 0 Symbol Mandatory Digit](#1325-the-0-symbol-mandatory-digit)
    - [13.2.6 The Number Symbol Optional Digit](#1326-the-number-symbol-optional-digit)
    - [13.2.7 Combining 0 and Number](#1327-combining-0-and-number)
    - [13.2.8 Decimal and Grouping Separators](#1328-decimal-and-grouping-separators)
    - [13.2.9 DecimalFormatSymbols Locale-Specific Formatting Symbols](#1329-decimalformatsymbols-locale-specific-formatting-symbols)
    - [13.2.10 Special DecimalFormat Patterns](#13210-special-decimalformat-patterns)
    - [13.2.11 Common Rules and Pitfalls](#13211-common-rules-and-pitfalls)
  - [13.3 Parsing Numbers](#133-parsing-numbers)
    - [13.3.1 Parsing with DecimalFormat](#1331-parsing-with-decimalformat)
    - [13.3.2 CompactNumberFormat](#1332-compactnumberformat)
  - [13.4 Date and Time Formatting](#134-date-and-time-formatting)
    - [13.4.1 DateTimeFormatter](#1341-datetimeformatter)
    - [13.4.2 Standard Date Time Symbols](#1342-standard-date-time-symbols)
    - [13.4.3 datetimeformat-vs-formatterformat](#1343-datetimeformat-vs-formatterformat)
    - [13.4.4 Localizing Dates](#1344-localizing-dates)
  - [13.5 Internationalization i18n and Localization l10n](#135-internationalization-i18n-and-localization-l10n)
    - [13.5.1 Locales](#1351-locales)
    - [13.5.2 Locale Categories](#1352-locale-categories)
      - [13.5.3 Real-world Example](#1353-real-world-example)
  - [13.6 Properties and Resource Bundles](#136-properties-and-resource-bundles)
    - [13.6.1 Resource Bundle Resolution Rules](#1361-resource-bundle-resolution-rules)
  - [13.7 Common Rules and Pitfalls](#137-common-rules-and-pitfalls)

---

This chapter delivers a **deep and practical** treatment of formatting in Java 21. 

## 13.1 String Formatting

### 13.1.1 String.format and formatted

The `String.format()` method creates formatted strings using printf-style placeholders. 

It is locale-sensitive and returns a new immutable `String`.

```java
String result = String.format("The User: %s | Score: %d", "Bob", 42);
System.out.println(result);

// Or

System.out.println("The User: %s | Score: %d".formatted("Bob", 42));
```

Output:

```bash
The User: Bob | Score: 42
```

Key characteristics:

- Uses format specifiers like **%s** (applies to any type, commonly String values), **%d** (integral values), **%f** (floating-point values)
- Does not modify existing strings
- Throws IllegalFormatException if arguments mismatch
- Locale-sensitive when Locale is provided with the static implementation String.format()

```java
String price = String.format(Locale.GERMANY, "%.2f", 1234.5);
// Output: 1234,50
```

#### 13.1.1.1 Floating-point flags

The `%f` conversion is used to format floating-point numbers (`float`, `double`, `BigDecimal`) using **decimal notation**. It is commonly used with `String.format()` and `printf`.

```java
System.out.printf("%f%n", 12.345);
```

```bash
12.345000
```

- Always prints 6 digits after the decimal point
- Uses rounding (not truncation)
- Locale-sensitive for decimal separator

#### 13.1.1.2 Precision (.n)

Precision defines the number of digits printed **after the decimal point**.

```java
System.out.printf("%.2f", 12.345);
```

```bash
12.35
```

- .0f prints no decimal digits
- Rounding is applied
- Precision is applied before width padding

#### 13.1.1.3 Width (m)

Width defines the **minimum total number of characters** in the output.

```java
System.out.printf("%8.2f", 12.34);
```

```bash
   12,34  
```

- Pads with spaces by default
- If the number is longer, width is ignored
- Padding is applied on the left by default

#### 13.1.1.4 Zero Padding 0 Flag

The `0` flag replaces space padding with zeros.

```java
System.out.printf("%08.2f", 12.34);
```

```bash
00012.34
```

- Requires a width
- Zeros are inserted after the sign
- Ignored if left-justified (- flag)

#### 13.1.1.5 Left Justification - Flag

The `-` flag left-aligns the value within the width.

```java
System.out.printf("%-8.2f%n", 12.34);
```

```bash
12.34
```

- Padding moves to the right
- Overrides zero padding

#### 13.1.1.6 Explicit Sign + Flag

The `+` flag forces display of the sign for positive numbers.

```java
System.out.printf("%+8.2f%n", 12.34);
```

```bash
+12.34
```

- Negative numbers already show -
- Overrides space flag


#### 13.1.1.7 Parentheses for Negatives ( Flag

The `(` flag formats negative numbers using parentheses.

```java
System.out.printf("%(8.2f%n", -12.34);
```

```bash
(12.34)
```

- Only affects negative values
- Rare but certification-relevant

#### 13.1.1.8 Combining Flags

```java
System.out.printf("%+010.2f%n", 12.34);
```

```bash
+000012.34
```

Evaluation order:

- Precision applied
- Sign handled
- Width enforced
- Padding applied

#### 13.1.1.9 Locale Effects

```java
System.out.printf(Locale.FRANCE, "%,.2f%n", 12345.67);
```

```bash
12 345,67
```

Decimal and grouping separators depend on Locale.

#### 13.1.1.10 Common Pitfalls

- %f defaults to 6 decimal places
- Width never truncates output
- 0 flag ignored when - is present
- + overrides space flag
- Grouping is Locale-dependent


### 13.1.2 Custom Text Values and Escaping

Certain characters have special meaning in format strings and must be escaped.

- %% → literal percent sign
- \n, \t → standard Java escapes

```java
String msg = String.format("Completion: %d%%\nStatus: OK", 100);
System.out.println(msg);
```

Output:

```bash
Completion: 100%
Status: OK
```

> [!NOTE] 
> A single % without a valid specifier causes an exception.

---

## 13.2 Number Formatting

### 13.2.1 NumberFormat

`NumberFormat` is an abstract class used to format and parse numbers in a locale-aware manner.

```java
NumberFormat nf = NumberFormat.getInstance(Locale.FRANCE);
System.out.println(nf.format(1234567.89));
```

Important rules:

- Factory methods determine formatting style
- Formatting depends on Locale
- Not thread-safe

### 13.2.2 Localizing Numbers

Number localization affects decimal separators, grouping separators, and currency symbols.

```java
NumberFormat nfUS = NumberFormat.getInstance(Locale.US);
NumberFormat nfIT = NumberFormat.getInstance(Locale.ITALY);

System.out.println(nfUS.format(1234.56)); // 1,234.56
System.out.println(nfIT.format(1234.56)); // 1.234,56
```

### 13.2.3 DecimalFormat and NumberFormat

`DecimalFormat` is a concrete subclass of `NumberFormat` that provides fine-grained control over numeric formatting using patterns. 

`NumberFormat` defines locale-aware formatting via factory methods, while `DecimalFormat` allows explicit pattern-based control.

```java
NumberFormat nf = NumberFormat.getInstance(Locale.US);
DecimalFormat df = (DecimalFormat) nf;
```

Or directly:

```java
DecimalFormat df = new DecimalFormat("#,##0.00");
```

- DecimalFormat is mutable
- DecimalFormat is NOT thread-safe
- Formatting is locale-sensitive via DecimalFormatSymbols

### 13.2.4 DecimalFormat Pattern Structure

A pattern may contain a positive and an optional negative subpattern, separated by `;`.

```text
#,##0.00;(#,##0.00)
```

- First part → positive numbers
- Second part → negative numbers
- If omitted, negative numbers use '-' automatically

### 13.2.5 The 0 Symbol (Mandatory Digit)

The `0` symbol forces a digit to appear, padding with zeros if necessary.

```java
DecimalFormat df = new DecimalFormat("0000.00");
System.out.println(df.format(12.3));
```

```bash
0012.30
```

- Controls minimum number of digits
- Pads with zeros
- Used for fixed-width or aligned output

### 13.2.6 The Number Symbol Optional Digit

The `#` symbol displays a digit only if it exists.

```java
DecimalFormat df = new DecimalFormat("####.##");
System.out.println(df.format(12.3));
```

```bash
12.3
```

- Suppresses leading zeros
- Suppresses trailing zeros
- Used for human-readable formatting

### 13.2.7 Combining 0 and Number

Patterns often combine both symbols for flexibility.

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

Pattern explanation: 

```bash
#,##0 . ##
 ^  ^    ^
 |  |    |
 |  |    └─ optional fractional digits
 |  └───── mandatory integer digit
 └──────── grouping pattern
```

- At least one integer digit is guaranteed
- Group digits in thousands (,)
- But always show at least one digit, even if the number is less than 1

### 13.2.8 Decimal and Grouping Separators

In patterns:

- . → decimal separator
- , → grouping separator

Actual symbols depend on Locale.

### 13.2.9 DecimalFormatSymbols Locale-Specific Formatting Symbols

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

- Controls decimal and grouping separators
- Controls minus sign and currency symbol
- Controls NaN and Infinity strings


### 13.2.10 Special DecimalFormat Patterns

```text
0.###E0 scientific notation
###% percent
¤#,##0.00 currency
```

### 13.2.11 Common Rules and Pitfalls

- DecimalFormat is a NumberFormat subclass
- 0 forces digits, # does not
- Patterns control formatting, not rounding mode
- Grouping only works if ',' is present
- Parsing may succeed partially without error
- DecimalFormat is NOT thread-safe

---

## 13.3 Parsing Numbers

Parsing converts localized text into numeric values. Parsing is lenient by default.

```java
NumberFormat nf = NumberFormat.getInstance(Locale.FRANCE);
Number n = nf.parse("12 345,67abc"); // parses 12345.67
```

- Parsing stops at first invalid character
- Trailing text is ignored unless explicitly checked


### 13.3.1 Parsing with DecimalFormat

`DecimalFormat` can also parse numbers. Parsing is lenient by default.

```java
DecimalFormat df = new DecimalFormat("#,##0.##");
Number n = df.parse("1,234.56abc");
```

- Parsing stops at first invalid character
- Trailing text is ignored

To enforce strict parsing:

```java
df.setParseStrict(true);
```

### 13.3.2 CompactNumberFormat

Compact formatting shortens large numbers for human readability.

- SHORT vs LONG styles
- Locale-dependent abbreviations

```java
NumberFormat cnf =
NumberFormat.getCompactNumberInstance(
Locale.US, NumberFormat.Style.SHORT);

System.out.println(cnf.format(1_200)); // 1.2K
System.out.println(cnf.format(5_000_000)); // 5M

NumberFormat cnf1 =
		NumberFormat.getCompactNumberInstance(
		Locale.US, NumberFormat.Style.SHORT);

NumberFormat cnf2 =
		NumberFormat.getCompactNumberInstance(
		Locale.US, NumberFormat.Style.LONG);

System.out.println(cnf1.format(315_000_000));  	// 315M
System.out.println(cnf2.format(315_000_000));	// 315 million

```

---

## 13.4 Date and Time Formatting

### 13.4.1 DateTimeFormatter

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

### 13.4.2 Standard Date/Time Symbols

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


### 13.4.3 datetime.format vs formatter.format

Both methods are functionally identical.

```java
date.format(formatter);
formatter.format(date);
```

- datetime.format(formatter) → preferred for clarity
- formatter.format(datetime) → useful in functional code

### 13.4.4 Localizing Dates

Localized styles adapt date output to cultural norms.

```java
DateTimeFormatter f =
	DateTimeFormatter
		.ofLocalizedDate(FormatStyle.FULL)
		.withLocale(Locale.ITALY);

DateTimeFormatter f1 =
	DateTimeFormatter
		.ofLocalizedDate(FormatStyle.FULL)
		.withLocale(Locale.ITALY);

System.out.println(LocalDate.now().format(f));
System.out.println(LocalDate.now().format(f1));
```

Output:

```bash
mercoledì 17 dicembre 2025
17 dic 2025
```

---

## 13.5 Internationalization (i18n) and Localization (l10n)

### 13.5.1 Locales

A `Locale` defines language, country, and optional variant.

```java
Locale l1 = Locale.US;
Locale l2 = Locale.of("fr", "FR");
Locale l3 = new Locale.Builder().setLanguage("en").setRegion("US").build();
```

Locale formats:

- **en** (it, fr, etc...): lowercase **language** code;
- **en_US** (fr_CA, it_IT, etc...): lowercase **language** code + underscore + uppercase **country** code.

### 13.5.2 Locale Categories

Locale categories separate formatting from UI language.

`Locale.Category` lets Java use different default locales for different purposes.

There are two categories only:

- FORMAT	Numbers, dates, currency, formatting
- DISPLAY	Human-readable text (UI, names, messages)

#### 13.5.3 Real-world Example

A French user living in Germany might want:

- Numbers and dates → German format
- UI language → French

Before Java 7, this was impossible.


```java
Locale.setDefault(Locale.Category.FORMAT, Locale.GERMANY);
Locale.setDefault(Locale.Category.DISPLAY, Locale.FRANCE);
```

Sample Output:

| Aspect        | Result       |
| ------------- | ------------ |
| Numbers       | `1.234,56`   |
| Dates         | `31.12.2025` |
| Currency      | `€`          |
| UI text       | French       |
| Month names   | `décembre`   |
| Country names | `Allemagne`  |

---

## 13.6 Properties and Resource Bundles

Resource bundles externalize text and allow localization without code changes.

```java
ResourceBundle rb =
ResourceBundle.getBundle("messages", Locale.GERMAN);

String msg = rb.getString("welcome");
```

### 13.6.1 Resource Bundle Resolution Rules

Java searches bundles in a strict fallback order.

- messages_de_DE.properties
- messages_de.properties
- messages.properties

- If none found → MissingResourceException

> **Note:** 
Properties files must be ISO-8859-1 unless Unicode escapes are used.


## 13.7 Common Rules and Pitfalls

- DateTimeFormatter is immutable and thread-safe
- NumberFormat is mutable and NOT thread-safe
- Locale changes formatting, not stored values
- Parsing may succeed partially without errors
- java.time replaces Date/Calendar completely


