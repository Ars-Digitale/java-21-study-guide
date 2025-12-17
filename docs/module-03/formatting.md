# Formatting in Java

This chapter delivers a **deep and practical** treatment of formatting in Java 21. 

## 1. String Formatting

### 1.1 String.format(), .formatted()

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

#### 1.1.1 Floating-point flags

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

#### 1.1.2 Precision (.n)

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

#### 1.1.3 Width (m)

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

#### 1.1.4 Zero Padding (0 flag)

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

#### 1.1.5 Left Justification (- flag)

The `-` flag left-aligns the value within the width.

```java
System.out.printf("%-8.2f%n", 12.34);
```

```bash
12.34
```

- Padding moves to the right
- Overrides zero padding

#### 1.1.6 Explicit Sign (+ flag)

The `+` flag forces display of the sign for positive numbers.

```java
System.out.printf("%+8.2f%n", 12.34);
```

```bash
+12.34
```

- Negative numbers already show -
- Overrides space flag


#### 1.1.7 Parentheses for Negatives (( flag)

The `(` flag formats negative numbers using parentheses.

```java
System.out.printf("%(8.2f%n", -12.34);
```

```bash
(12.34)
```

- Only affects negative values
- Rare but certification-relevant

#### 1.1.8 Combining Flags

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

#### 1.1.9 Locale Effects

```java
System.out.printf(Locale.FRANCE, "%,.2f%n", 12345.67);
```

```bash
12 345,67
```

Decimal and grouping separators depend on Locale.

#### 1.1.10 Common Pitfalls

- %f defaults to 6 decimal places
- Width never truncates output
- 0 flag ignored when - is present
- + overrides space flag
- Grouping is Locale-dependent


### 1.2 Custom Text Values and Escaping

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


## 2. Number Formatting

### 2.1 NumberFormat

`NumberFormat` is an abstract class used to format and parse numbers in a locale-aware manner.

```java
NumberFormat nf = NumberFormat.getInstance(Locale.FRANCE);
System.out.println(nf.format(1234567.89));
```

Important rules:

- Factory methods determine formatting style
- Formatting depends on Locale
- Not thread-safe

### 2.1 Localizing Numbers

Number localization affects decimal separators, grouping separators, and currency symbols.

```java
NumberFormat nfUS = NumberFormat.getInstance(Locale.US);
NumberFormat nfIT = NumberFormat.getInstance(Locale.ITALY);

System.out.println(nfUS.format(1234.56)); // 1,234.56
System.out.println(nfIT.format(1234.56)); // 1.234,56
```

### 2.2 DecimalFormat and NumberFormat

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

### 2.3 DecimalFormat Pattern Structure

A pattern may contain a positive and an optional negative subpattern, separated by `;`.

```text
#,##0.00;(#,##0.00)
```

- First part → positive numbers
- Second part → negative numbers
- If omitted, negative numbers use '-' automatically

### 2.4 The 0 Symbol (Mandatory Digit)

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

### 2.5 The # Symbol (Optional Digit)

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

### 2.6 Combining `0` and `#`

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

### 2.7 Decimal and Grouping Separators

In patterns:

- . → decimal separator
- , → grouping separator

Actual symbols depend on Locale.

### 2.8 `DecimalFormatSymbols` defines locale-specific formatting symbols.

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


### 2.9 Special DecimalFormat Patterns

```text
0.###E0 scientific notation
###% percent
¤#,##0.00 currency
```

### 2.10 Common Rules and Pitfalls

- DecimalFormat is a NumberFormat subclass
- 0 forces digits, # does not
- Patterns control formatting, not rounding mode
- Grouping only works if ',' is present
- Parsing may succeed partially without error
- DecimalFormat is NOT thread-safe


## 3. Parsing Numbers

Parsing converts localized text into numeric values. Parsing is lenient by default.

```java
NumberFormat nf = NumberFormat.getInstance(Locale.FRANCE);
Number n = nf.parse("12 345,67abc"); // parses 12345.67
```

- Parsing stops at first invalid character
- Trailing text is ignored unless explicitly checked


### 3.1 Parsing with DecimalFormat

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

### 3.2 CompactNumberFormat

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

## 4. Date and Time Formatting

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


## 4. Internationalization (i18n) and Localization (l10n)

### 4.1 Locales

A `Locale` defines language, country, and optional variant.

```java
Locale l1 = Locale.US;
Locale l2 = Locale.of("fr", "FR");
Locale l3 = new Locale.Builder().setLanguage("en").setRegion("US").build();
```

Locale formats:

- **en** (it, fr, etc...): lowercase **language** code;
- **en_US** (fr_CA, it_IT, etc...): lowercase **language** code + underscore + uppercase **country** code.

### 4.2 Locale Categories

Locale categories separate formatting from UI language.

`Locale.Category` lets Java use different default locales for different purposes.

There are two categories only:

- FORMAT	Numbers, dates, currency, formatting
- DISPLAY	Human-readable text (UI, names, messages)

#### 4.2.1 Real-world example

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


## 5. Common Rules and Pitfalls

- DateTimeFormatter is immutable and thread-safe
- NumberFormat is mutable and NOT thread-safe
- Locale changes formatting, not stored values
- Parsing may succeed partially without errors
- java.time replaces Date/Calendar completely

> **Note:** 
In Java certification exams, formatting questions often hide the trap in Locale selection or parsing behavior — always inspect Locale usage first.
