
# 13. Formattazione e Localizzazione in Java

## Indice

- [13. Formattazione e Localizzazione in Java](#13-formattazione-e-localizzazione-in-java)
   - [13.1 Formattazione delle Stringhe](#131-formattazione-delle-stringhe)
     - [13.1.1 String.format e formatted](#1311-stringformat-e-formatted)
       - [13.1.1.1 Flag per numeri in virgola mobile](#13111-flag-per-numeri-in-virgola-mobile)
       - [13.1.1.2 Precisione n](#13112-precisione-n)
       - [13.1.1.3 Larghezza m](#13113-larghezza-m)
       - [13.1.1.4 Flag di riempimento con zero 0](#13114-flag-di-riempimento-con-zero-0)
       - [13.1.1.5 Giustificazione a sinistra Flag -](#13115-giustificazione-a-sinistra-flag--)
       - [13.1.1.6 Segno esplicito Flag +](#13116-segno-esplicito-flag-)
       - [13.1.1.7 Parentesi per i negativi Flag (](#13117-parentesi-per-i-negativi-flag-)
       - [13.1.1.8 Combinazione dei flag](#13118-combinazione-dei-flag)
       - [13.1.1.9 Effetti del Locale](#13119-effetti-del-locale)
       - [13.1.1.10 Errori comuni](#131110-errori-comuni)
     - [13.1.2 Valori di testo personalizzati ed escaping](#1312-valori-di-testo-personalizzati-ed-escaping)
   - [13.2 Formattazione dei Numeri](#132-formattazione-dei-numeri)
     - [13.2.1 NumberFormat](#1321-numberformat)
     - [13.2.2 Localizzazione dei numeri](#1322-localizzazione-dei-numeri)
     - [13.2.3 DecimalFormat e NumberFormat](#1323-decimalformat-e-numberformat)
     - [13.2.4 Struttura del pattern DecimalFormat](#1324-struttura-del-pattern-decimalformat)
     - [13.2.5 Il simbolo 0 (cifra obbligatoria)](#1325-il-simbolo-0-cifra-obbligatoria)
     - [13.2.6 Il simbolo # (cifra opzionale)](#1326-il-simbolo--cifra-opzionale)
     - [13.2.7 Combinare 0 e #](#1327-combinare-0-e-)
     - [13.2.8 Separatori decimali e di raggruppamento](#1328-separatori-decimali-e-di-raggruppamento)
     - [13.2.9 DecimalFormatSymbols: simboli di formattazione specifici del Locale](#1329-decimalformatsymbols-simboli-di-formattazione-specifici-del-locale)
     - [13.2.10 Pattern speciali di DecimalFormat](#13210-pattern-speciali-di-decimalformat)
     - [13.2.11 Regole ed errori comuni](#13211-regole-ed-errori-comuni)
   - [13.3 Parsing dei Numeri](#133-parsing-dei-numeri)
     - [13.3.1 Parsing con DecimalFormat](#1331-parsing-con-decimalformat)
     - [13.3.2 CompactNumberFormat](#1332-compactnumberformat)
   - [13.4 Formattazione di Data e Ora](#134-formattazione-di-data-e-ora)
     - [13.4.1 DateTimeFormatter](#1341-datetimeformatter)
     - [13.4.2 Simboli standard di data e ora](#1342-simboli-standard-di-data-e-ora)
     - [13.4.3 datetime.format vs formatter.format](#1343-datetimeformat-vs-formatterformat)
     - [13.4.4 Localizzazione delle date](#1344-localizzazione-delle-date)
   - [13.5 Internazionalizzazione (i18n) e Localizzazione (l10n)](#135-internazionalizzazione-i18n-e-localizzazione-l10n)
     - [13.5.1 Locales](#1351-locales)
     - [13.5.2 Categorie di Locale](#1352-categorie-di-locale)
     - [13.5.3 Esempio reale](#1353-esempio-reale)
   - [13.6 Properties e Resource Bundles](#136-properties-e-resource-bundles)
     - [13.6.1 Regole di risoluzione dei Resource Bundle](#1361-regole-di-risoluzione-dei-resource-bundle)
   - [13.7 Regole ed errori comuni](#137-regole-ed-errori-comuni)

---

Questo capitolo fornisce un trattamento approfondito e pratico della formattazione in Java 21.

## 13.1 Formattazione delle Stringhe

### 13.1.1 String.format e formatted

`String.format()` crea stringhe formattate utilizzando segnaposto in stile printf.

È sensibile al locale e restituisce una nuova `String` immutabile.

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

**Caratteristiche chiave:**

- Utilizza specificatori di formato come `%s` (qualsiasi tipo, comunemente valori String), `%d` (valori interi), `%f` (valori in virgola mobile).
- Non modifica le stringhe esistenti.
- Lancia `IllegalFormatException` se gli argomenti non corrispondono al formato.
- È sensibile al locale quando viene fornito un `Locale`.

```java
String price = String.format(Locale.GERMANY, "%.2f", 1234.5);
// Output (locale tedesco): 1234,50
```

### 13.1.1.1 Flag per numeri in virgola mobile

`%f` è usato per formattare numeri in virgola mobile (`float`, `double`, `BigDecimal`) usando la notazione decimale.

```java
System.out.printf("%f", 12.345);
```

```bash
12.345000
```

- **Stampa sempre 6 cifre dopo il punto decimale** per impostazione predefinita.
- Utilizza l’arrotondamento (non il troncamento).
- È sensibile al locale per il separatore decimale.

### 13.1.1.2 Precisione (.n)

La precisione definisce il numero di cifre stampate **dopo** il punto decimale.

```java
System.out.printf("%.2f", 12.345);
```

```bash
12.35
```

- `%.0f` non stampa cifre decimali.
- Viene applicato l’arrotondamento.
- La precisione è applicata prima del riempimento della larghezza.

### 13.1.1.3 Larghezza (m)

La larghezza definisce il numero minimo totale di caratteri nell’output.

```java
System.out.printf("%8.2f", 12.34);
```

```bash
   12.34
```

- Per impostazione predefinita **riempie con spazi**.
- Se il valore è più lungo, la larghezza viene ignorata (non viene mai troncato).
- Il riempimento è applicato a sinistra per impostazione predefinita.

### 13.1.1.4 Flag di riempimento con zero `0`

Il flag `0` sostituisce il riempimento con spazi con zeri.

```java
System.out.printf("%08.2f", 12.34);
```

```bash
00012.34
```

- Richiede una larghezza.
- Gli zeri sono inseriti dopo il segno.
- Ignorato se è presente la giustificazione a sinistra (flag `-`).

### 13.1.1.5 Giustificazione a sinistra Flag `-`

Il flag `-` allinea il valore a sinistra all’interno della larghezza.

```java
System.out.printf("%-8.2f", 12.34);
```

```bash
12.34   
```

- Il riempimento viene spostato a destra.
- Sovrascrive il riempimento con zero.

### 13.1.1.6 Segno esplicito Flag `+`

Il flag `+` forza la visualizzazione del segno per i numeri positivi.

```java
System.out.printf("%+8.2f", 12.34);
```

```bash
   +12.34
```

- I numeri negativi mostrano già `-`.
- Sovrascrive il flag spazio (che stampa uno spazio iniziale per i valori positivi).

### 13.1.1.7 Parentesi per i negativi Flag `(`

Il flag `(` formatta i numeri negativi usando le parentesi.

```java
System.out.printf("%(8.2f", -12.34);
```

```bash
 (12.34)
```

- Influenza solo i valori negativi.
- Raramente usato nella pratica.

### 13.1.1.8 Combinazione dei flag

```java
System.out.printf("%+010.2f", 12.34);
```

```bash
+000012.34
```

Ordine di valutazione (semplificato):

- Viene applicata la precisione.
- Viene gestito il segno.
- Viene applicata la larghezza.
- Viene applicato il riempimento (spazi o zeri).

### 13.1.1.9 Effetti del Locale

```java
System.out.printf(Locale.FRANCE, "%,.2f", 12345.67);
```

```bash
12 345,67
```

I separatori decimali e di raggruppamento dipendono dal `Locale` attivo.

### 13.1.1.10 Errori comuni

- `%f` usa 6 cifre decimali per impostazione predefinita se non viene specificata la precisione.
- La larghezza non tronca mai l’output, ma aggiunge solo riempimento se necessario.
- Il flag `0` è ignorato quando è presente `-`.
- `+` sovrascrive il flag spazio.
- Raggruppamento e separatori dipendono dal Locale.

### 13.1.2 Valori di testo personalizzati ed escaping

Alcuni caratteri hanno un significato speciale nelle stringhe di formato e devono essere sottoposti a escaping.

- `%%` → segno percentuale letterale.
- `\n`, `\t` → escape standard Java.

```java
String msg = String.format("Completion: %d%%%nStatus: OK", 100);
System.out.println(msg);
```

Output:

```bash
Completion: 100%
Status: OK
```

> [!NOTE]
> Un singolo % senza uno specificatore valido causa una IllegalFormatException a runtime.

## 13.2 Formattazione dei Numeri

### 13.2.1 NumberFormat

`NumberFormat` è una classe astratta utilizzata per formattare e fare il parsing dei numeri in modo sensibile al locale.

```java
NumberFormat nf = NumberFormat.getInstance(Locale.FRANCE);
System.out.println(nf.format(1234567.89));
```

> [!IMPORTANT]
> - I metodi factory determinano lo stile di formattazione (generale, intero, valuta, percentuale, compatto, ...).
> - La formattazione dipende dal `Locale` fornito.
> - `NumberFormat` (e `DecimalFormat`) non sono thread-safe.

### 13.2.2 Localizzazione dei numeri

La localizzazione dei numeri influisce sui separatori decimali, sui separatori di raggruppamento e sui simboli di valuta.

```java
NumberFormat nfUS = NumberFormat.getInstance(Locale.US);
NumberFormat nfIT = NumberFormat.getInstance(Locale.ITALY);

System.out.println(nfUS.format(1234.56)); // 1,234.56
System.out.println(nfIT.format(1234.56)); // 1.234,56
```

### 13.2.3 DecimalFormat e NumberFormat

`DecimalFormat` è una sottoclasse concreta di `NumberFormat` che fornisce un controllo fine sulla formattazione numerica tramite pattern.

`NumberFormat` definisce una formattazione sensibile al locale tramite metodi factory, mentre `DecimalFormat` consente un controllo esplicito basato su pattern.

```java
NumberFormat nf = NumberFormat.getInstance(Locale.US);
DecimalFormat df = (DecimalFormat) nf;
```

Oppure direttamente:

```java
DecimalFormat df = new DecimalFormat("#,##0.00");
```

> [!NOTE]
> - `DecimalFormat` è mutabile (è possibile cambiare pattern, simboli, ecc.).
> - `DecimalFormat` non è thread-safe.
> - La formattazione è sensibile al locale tramite `DecimalFormatSymbols`.


### 13.2.4 Struttura del pattern DecimalFormat

Un pattern può contenere una sottostruttura positiva e una negativa opzionale, separate da `;`.

```text
#,##0.00;(#,##0.00)
```

> [!NOTE]
> - La prima parte → numeri positivi.
> - La seconda parte → numeri negativi.
> - Se la parte negativa è omessa, i numeri negativi usano automaticamente un `-` iniziale.

### 13.2.5 Il simbolo `0` (cifra obbligatoria)

Il simbolo `0` forza la visualizzazione di una cifra, riempiendo con zeri se necessario.

```java
DecimalFormat df = new DecimalFormat("0000.00");
System.out.println(df.format(12.3));
```

```bash
0012.30
```

- Controlla il numero minimo di cifre.
- Riempie con zeri se il numero ha meno cifre.
- Utile per output a larghezza fissa o allineato.

### 13.2.6 Il simbolo `#` (cifra opzionale)

Il simbolo `#` visualizza una cifra solo se esiste.

```java
DecimalFormat df = new DecimalFormat("####.##");
System.out.println(df.format(12.3));
```

```bash
12.3
```

- Sopprime gli zeri iniziali.
- Sopprime gli zeri finali non necessari.
- Adatto a una formattazione “user-friendly”.

### 13.2.7 Combinare `0` e `#`

I pattern combinano spesso entrambi i simboli per maggiore flessibilità.

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

Spiegazione del pattern:

```text
#,##0 . ##
 ^  ^    ^
 |  |    |
 |  |    └─ cifre frazionarie opzionali (#)
 |  └───── cifra intera obbligatoria (0)
 └──────── pattern di raggruppamento (,)
```

- È garantita almeno una cifra intera (lo `0`).
- Le cifre sono raggruppate per migliaia usando il separatore di raggruppamento.
- Le cifre frazionarie sono opzionali (fino a due).

### 13.2.8 Separatori decimali e di raggruppamento

Nei pattern:

- `.` → separatore decimale.
- `,` → separatore di raggruppamento.

I simboli effettivamente utilizzati a runtime dipendono dal `Locale` (ad esempio, virgola vs punto).

### 13.2.9 DecimalFormatSymbols: simboli di formattazione specifici del Locale

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

- Controlla i separatori decimali e di raggruppamento.
- Controlla il segno meno e il simbolo di valuta.
- Controlla le stringhe NaN e Infinity.

### 13.2.10 Pattern speciali di DecimalFormat

```text
0.###E0   notazione scientifica
###%      percentuale
¤#,##0.00 valuta (¤ è il simbolo di valuta)
```

### 13.2.11 Regole ed errori comuni

- `DecimalFormat` è una sottoclasse di `NumberFormat`.
- `0` forza le cifre, `#` no.
- I pattern controllano la formattazione, non la modalità di arrotondamento (usare `setRoundingMode()`).
- Il raggruppamento funziona solo se il separatore (di solito `,`) è presente nel pattern.
- Il parsing può riuscire parzialmente senza errore se sono presenti caratteri finali dopo un numero valido.
- `DecimalFormat` è mutabile e non thread-safe.

## 13.3 Parsing dei Numeri

Il parsing converte testo localizzato in valori numerici. Per impostazione predefinita, il parsing è permissivo.

```java
NumberFormat nf = NumberFormat.getInstance(Locale.FRANCE);
Number n = nf.parse("12 345,67abc"); // estrae 12345.67
```

- Il parsing si ferma al primo carattere non valido.
- Il testo finale viene ignorato se non controllato esplicitamente.

### 13.3.1 Parsing con DecimalFormat

`DecimalFormat` può anche effettuare il parsing dei numeri. Il parsing è permissivo per impostazione predefinita.

```java
DecimalFormat df = new DecimalFormat("#,##0.##");
Number n = df.parse("1,234.56abc");
```

- Il parsing si ferma al primo carattere non valido.
- Il testo finale viene ignorato se presente.

Per forzare un parsing rigoroso:

```java
df.setParseStrict(true);
```

### 13.3.2 CompactNumberFormat

La formattazione compatta abbrevia i numeri grandi per la leggibilità umana.

- Supporta stili SHORT e LONG.
- Usa abbreviazioni dipendenti dal locale (ad esempio K, M, “million”).

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

## 13.4 Formattazione di Data e Ora

### 13.4.1 DateTimeFormatter

Java 21 si basa su `java.time` e `DateTimeFormatter` per la formattazione moderna di data e ora.

```java
DateTimeFormatter f =
        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
System.out.println(LocalDateTime.now().format(f));
```

**Proprietà principali:**

- Immutabile.
- Thread-safe.
- Sensibile al locale.

### 13.4.2 Simboli standard di data e ora

```text
y   anno
M   numero del mese (o nome con più lettere)
d   giorno del mese
E   nome del giorno
H   ora (0–23)
h   ora (1–12)
m   minuto
s   secondo
a   indicatore AM/PM
z   fuso orario
```

### 13.4.3 datetime.format vs formatter.format

Entrambi i metodi sono funzionalmente identici:

```java
date.format(formatter);
formatter.format(date);
```

- `date.format(formatter)` → preferito per leggibilità (prima il dato, poi la formattazione).
- `formatter.format(date)` → utile in codice funzionale o con formatter riutilizzabili.

### 13.4.4 Localizzazione delle date

Gli stili localizzati adattano l’output delle date alle norme culturali.

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

Output possibile:

```bash
mercoledì 17 dicembre 2025
17/12/25
```

## 13.5 Internazionalizzazione (i18n) e Localizzazione (l10n)

### 13.5.1 Locales

Un `Locale` definisce lingua, paese e una variante opzionale.

```java
Locale l1 = Locale.US;
Locale l2 = Locale.of("fr", "FR");
Locale l3 = new Locale.Builder()
        .setLanguage("en")
        .setRegion("US")
        .build();
```

Formati di Locale:

- `en` (it, fr, ecc.): codice lingua minuscolo.
- `en_US` (fr_CA, it_IT, ecc.): codice lingua minuscolo + underscore + codice paese maiuscolo.

### 13.5.2 Categorie di Locale

Le categorie di Locale separano la formattazione dalla lingua dell’interfaccia utente.

`Locale.Category` consente a Java di usare Locale predefiniti diversi per scopi diversi.

Esistono due categorie:

| Category | Usata per |
| --- | --- |
| FORMAT | Numeri, date, valuta, altra formattazione |
| DISPLAY | Testo leggibile (UI, nomi, messaggi) |

### 13.5.3 Esempio reale

Un utente francese che vive in Germania potrebbe volere:

- Numeri e date → formato tedesco.
- Lingua dell’interfaccia → francese.

Prima di Java 7, questo non era possibile.

```java
Locale.setDefault(Locale.Category.FORMAT, Locale.GERMANY);
Locale.setDefault(Locale.Category.DISPLAY, Locale.FRANCE);
```

Effetti di esempio:

| Aspetto | Risultato (esempio) |
| --- | --- |
| Numeri | 1.234,56 |
| Date | 31.12.2025 |
| Valuta | € |
| Testo UI | Francese |
| Nomi dei mesi | décembre |
| Nomi dei paesi | Allemagne |

## 13.6 Properties e Resource Bundles

I resource bundle esternalizzano il testo e consentono la localizzazione senza modifiche al codice.

```java
ResourceBundle rb =
        ResourceBundle.getBundle("messages", Locale.GERMAN);

String msg = rb.getString("welcome");
```

### 13.6.1 Regole di risoluzione dei Resource Bundle

Java cerca i bundle seguendo un ordine di fallback rigoroso. Ad esempio, con nome base `messages` e locale `de_DE`:

- messages_de_DE.properties
- messages_de.properties
- messages.properties

Se nessuno viene trovato → `MissingResourceException`.

> [!NOTE]
> I file `.properties` tradizionali sono specificati come ISO-8859-1;
> i caratteri non ASCII devono essere codificati come escape Unicode (ad esempio `\u00E9` per é), a meno di usare meccanismi di caricamento alternativi.

## 13.7 Regole ed errori comuni

- `DateTimeFormatter` è immutabile e thread-safe.
- `NumberFormat` / `DecimalFormat` sono mutabili e non thread-safe.
- Cambiare il `Locale` influisce su come i valori sono formattati e interpretati, non sui valori numerici o temporali sottostanti.
- Il parsing con `NumberFormat` o `DecimalFormat` può riuscire parzialmente senza eccezioni se dopo un numero valido è presente testo aggiuntivo.
- `java.time` sostituisce la maggior parte degli usi delle vecchie API `java.util.Date` / `Calendar` nel codice moderno e nell’esame.

