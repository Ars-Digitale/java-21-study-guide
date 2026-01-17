# 12. Data e ora in Java

### Indice

- [12. Data e ora in Java](#12-date-and-time-in-java)
	- [12.1 Data e ora](#121-date-and-time)
		- [12.1.1 Creare date e ore specifiche](#1211-creating-specific-dates-and-times)
		- [12.1.2 Aritmetica su data e ora: metodi plus e minus](#1212-date-and-time-arithmetic-plus-and-minus-methods)
		- [12.1.3 Pattern comuni](#1213-common-patterns)
		- [12.1.4 Aritmetica su LocalDate](#1214-localdate-arithmetic)
		- [12.1.5 Aritmetica su LocalTime](#1215-localtime-arithmetic)
		- [12.1.6 Aritmetica su LocalDateTime](#1216-localdatetime-arithmetic)
		- [12.1.7 Aritmetica su ZonedDateTime](#1217-zoneddatetime-arithmetic)
		- [12.1.8 Tabella riassuntiva](#1218-summary-table)
	- [12.2 Metodi withXxx](#122-withxxx-methods)
	- [12.3 Conversione e metodi at: collegare data, ora e zona](#123-conversion--at-methods-linking-date-time-and-zone)
	- [12.4 Period, Duration e Instant](#124-period-duration-and-instant)
	- [12.5 Period — quantità “umane” di data](#125-period--human-date-amounts)
	- [12.6 Duration — quantità “macchina” di tempo](#126-duration--machine-time-amounts)
	- [12.7 Instant — punto sulla timeline UTC](#127-instant--point-on-the-utc-timeline)
	- [12.8 Tabella riassuntiva: Period vs Duration vs Instant](#128-summary-table-period-vs-duration-vs-instant)
	- [12.9 TemporalUnit e TemporalAmount](#129-temporalunit-and-temporalamount)
		- [12.9.1 TemporalUnit](#1291-temporalunit)
		- [12.9.2 enum ChronoUnit](#1292-chronounit-enum)
		- [12.9.3 TemporalAmount](#1293-temporalamount)
		- [12.9.4 Period come TemporalAmount](#1294-period-as-a-temporalamount)
		- [12.9.5 Duration come TemporalAmount](#1295-duration-as-a-temporalamount)
		- [12.9.6 Usare TemporalAmount vs TemporalUnit](#1296-using-temporalamount-vs-temporalunit)
		- [12.9.7 Metodi between](#1297-between-methods)
		- [12.9.8 Problemi comuni](#1298-common-pitfalls)
		- [12.9.9 Riepilogo](#1299-summary)

---

## 12.1 Data e ora

Java fornisce un’API moderna, coerente e immutabile per data/ora nel package `java.time.*`.
Questa API sostituisce le vecchie classi `java.util.Date` e `java.util.Calendar` ed è ampiamente testata negli esami di certificazione.

A seconda del livello di dettaglio richiesto, Java offre quattro classi principali:

- `LocalDate` → rappresenta solo una data (anno–mese–giorno)
- `LocalTime` → rappresenta solo un orario (ora–minuto–secondo–nanosecondo)
- `LocalDateTime` → combina data + ora, ma senza fuso orario
- `ZonedDateTime` → data + ora + offset + fuso orario completi

> [!NOTE]
> - Un **fuso orario** definisce regole come i cambi dell’ora legale (ad esempio, `Europe/Paris`).  
> - Un **offset di zona** è uno spostamento fisso rispetto a UTC/GMT (ad esempio, `+01:00`, `-07:00`).  
> - Per confrontare due istanti provenienti da fusi orari diversi, convertili in UTC (GMT) applicando l’offset.

**Ottenere la data/ora corrente**

Puoi recuperare i valori correnti del sistema usando i metodi statici `now()`:

```java
System.out.println(LocalDate.now());
System.out.println(LocalTime.now());
System.out.println(LocalDateTime.now());
System.out.println(ZonedDateTime.now());
```

- Esempio di output (il tuo sistema potrebbe differire):

```bash
2025-12-01
19:11:53.213856300
2025-12-01T19:11:53.213856300
2025-12-01T19:11:53.214856900+01:00[Europe/Paris]
```

- Esempio: conversione di `ZonedDateTime` in GMT (UTC)

```java
// Conceptual examples (not real code, just illustrating offsets):
// 2024-07-01T12:00+09:00[Asia/Tokyo]        ---> 12:00 minus 9 hours ---> 03:00 UTC
// 2024-07-01T20:00-07:00[America/Los_Angeles] ---> 20:00 plus 7 hours ---> 03:00 UTC
```

Entrambi rappresentano lo stesso istante nel tempo, semplicemente espresso in fusi orari diversi.

### 12.1.1 Creare date e ore specifiche

Puoi costruire oggetti di data/ora precisi usando i metodi factory `of()`.
Tutte le classi includono più versioni sovraccaricate di `of()` (qui sono elencate solo le più comuni).

**LocalDate — forme sovraccaricate di `of()`**
- `of(int year, int month, int dayOfMonth)`
- `of(int year, Month month, int dayOfMonth)`

**LocalTime — forme sovraccaricate di `of()`**
- `of(int hour, int minute)`
- `of(int hour, int minute, int second)`
- `of(int hour, int minute, int second, int nanoOfSecond)`

**LocalDateTime — forme sovraccaricate di `of()`**
- `of(int year, int month, int day, int hour, int minute)`
- `of(int year, int month, int day, int hour, int minute, int second)`
- `of(int year, int month, int day, int hour, int minute, int second, int nano)`
- `of(LocalDate date, LocalTime time)`

**ZonedDateTime — forme sovraccaricate di `of()`
- `of(LocalDate date, LocalTime time, ZoneId zone)`
- `of(int y, int m, int d, int h, int min, int s, int nano, ZoneId zone)`

- Esempi

```java
// Creating specific dates

var localDate1 = LocalDate.of(2025, 7, 31);
var localDate2 = LocalDate.of(2025, Month.JULY, 31);

// Creating specific times

var localTime1 = LocalTime.of(13, 21);
System.out.println(localTime1);                     // 13:21
System.out.println(LocalTime.of(13, 21, 52));       // 13:21:52
System.out.println(LocalTime.of(13, 21, 52, 200));  // 13:21:52.000000200

// Creating LocalDateTime

var localDateTime1 = LocalDateTime.of(2025, 7, 31, 13, 55, 22);
var localDateTime2 = LocalDateTime.of(localDate1, localTime1);

// Creating a ZonedDateTime

var zoned = ZonedDateTime.of(2025, 7, 31, 13, 55, 22, 0, ZoneId.of("Europe/Paris"));
```

### 12.1.2 Aritmetica su data e ora: metodi `plus` e `minus`

Tutte le classi nel package `java.time` (come `LocalDate`, `LocalTime`, `LocalDateTime`, `ZonedDateTime`, ecc.) sono **immutabili**.
Ciò significa che metodi come `plusXxx()` e `minusXxx()` non modificano mai l’oggetto originale — restituiscono invece una nuova istanza con il valore regolato.

### 12.1.3 Pattern comuni

La maggior parte delle classi di data/ora supporta tre tipi di metodi aritmetici:

- **Scorciatoie specifiche per tipo**
- `plusDays(long daysToAdd)`
- `plusHours(long hoursToAdd)`
- ecc.

- **Metodi generici basati su “amount”**
- `plus(TemporalAmount amount)` → ad esempio `Period`, `Duration`
- `minus(TemporalAmount amount)`

- **Metodi generici basati su “unit”**
- `plus(long amountToAdd, TemporalUnit unit)`
- `minus(long amountToSubtract, TemporalUnit unit)`

Questi consentono un’aritmetica su data/ora flessibile e leggibile.

### 12.1.4 Aritmetica su `LocalDate`

`LocalDate` rappresenta solo una data (niente ora, niente zona).

**Principali metodi `plus` / `minus` (overload)**

| Metodo | Descrizione |
| --- | --- |
| `plusDays(long days)` | Aggiunge giorni |
| `plusWeeks(long weeks)` | Aggiunge settimane |
| `plusMonths(long months)` | Aggiunge mesi |
| `plusYears(long years)` | Aggiunge anni |
| `minusDays(long days)` | Sottrae giorni |
| `minusWeeks(long weeks)` | Sottrae settimane |
| `minusMonths(long months)` | Sottrae mesi |
| `minusYears(long years)` | Sottrae anni |
| `plus(TemporalAmount amount)` | Aggiunge un Period |
| `minus(TemporalAmount amount)` | Sottrae un Period |
| `plus(long amountToAdd, TemporalUnit unit)` | Aggiunge usando ChronoUnit (es., DAYS, MONTHS) |
| `minus(long amountToSubtract, TemporalUnit unit)` | Sottrae usando ChronoUnit |

- Esempi:

```java
LocalDate date = LocalDate.of(2025, 3, 10);

LocalDate d1 = date.plusDays(5);            // 2025-03-15
LocalDate d2 = date.minusWeeks(2);          // 2025-02-24
LocalDate d3 = date.plusMonths(1);          // 2025-04-10
LocalDate d4 = date.plusYears(2);           // 2027-03-10

// Using ChronoUnit
LocalDate d5 = date.plus(10, ChronoUnit.DAYS);   // 2025-03-20

// Using Period
Period p = Period.of(1, 2, 3);  // 1 year, 2 months, 3 days
LocalDate d6 = date.plus(p);
```

### 12.1.5 Aritmetica su `LocalTime`

`LocalTime` rappresenta solo un orario (niente data, niente zona).

**Principali metodi `plus` / `minus` (overload)**

| Metodo | Descrizione |
| --- | --- |
| `plusNanos(long nanos)` | Aggiunge nanosecondi |
| `plusSeconds(long seconds)` | Aggiunge secondi |
| `plusMinutes(long minutes)` | Aggiunge minuti |
| `plusHours(long hours)` | Aggiunge ore |
| `minusNanos(long nanos)` | Sottrae nanosecondi |
| `minusSeconds(long seconds)` | Sottrae secondi |
| `minusMinutes(long minutes)` | Sottrae minuti |
| `minusHours(long hours)` | Sottrae ore |
| `plus(TemporalAmount amount)` | Aggiunge una Duration |
| `minus(TemporalAmount amount)` | Sottrae una Duration |
| `plus(long amountToAdd, TemporalUnit unit)` | Aggiunge usando ChronoUnit |
| `minus(long amountToSubtract, TemporalUnit unit)` | Sottrae usando ChronoUnit |

- Esempi

```java
LocalTime time = LocalTime.of(13, 30);       // 13:30

LocalTime t1 = time.plusHours(2);            // 15:30
LocalTime t2 = time.minusMinutes(45);        // 12:45
LocalTime t3 = time.plusSeconds(90);         // 13:31:30

// Using ChronoUnit
LocalTime t4 = time.plus(3, ChronoUnit.HOURS);    // 16:30

// Using Duration
Duration d = Duration.ofMinutes(90);
LocalTime t5 = time.plus(d);                // 15:00
```

> [!NOTE]
> Quando l’aritmetica sull’ora supera la mezzanotte, con `LocalTime` la data viene ignorata.  
> Per esempio, 23:30 + 2 ore = 01:30 (senza alcuna data coinvolta).

### 12.1.6 Aritmetica su `LocalDateTime`

`LocalDateTime` combina data + ora, ma ancora senza fuso orario.
Supporta sia le scorciatoie legate alla data sia quelle legate all’ora.

**Principali metodi `plus` / `minus` (overload)**

| Metodo | Descrizione |
| --- | --- |
| `plusYears(long years)` / `minusYears(long years)` | Regola gli anni |
| `plusMonths(long months)` / `minusMonths(long months)` | Regola i mesi |
| `plusWeeks(long weeks)` / `minusWeeks(long weeks)` | Regola le settimane |
| `plusDays(long days)` / `minusDays(long days)` | Regola i giorni |
| `plusHours(long hours)` / `minusHours(long hours)` | Regola le ore |
| `plusMinutes(long minutes)` / `minusMinutes(long minutes)` | Regola i minuti |
| `plusSeconds(long seconds)` / `minusSeconds(long seconds)` | Regola i secondi |
| `plusNanos(long nanos)` / `minusNanos(long nanos)` | Regola i nanosecondi |
| `plus(TemporalAmount amount)` / `minus(TemporalAmount amount)` | Aggiunge/sottrae Period o Duration |
| `plus(long amountToAdd, TemporalUnit unit)` / `minus(long amountToSubtract, TemporalUnit unit)` | Usando ChronoUnit |

- Esempi

```java
LocalDateTime ldt = LocalDateTime.of(2025, 3, 10, 13, 30); // 2025-03-10T13:30

LocalDateTime l1 = ldt.plusDays(1);          // 2025-03-11T13:30
LocalDateTime l2 = ldt.minusHours(3);        // 2025-03-10T10:30
LocalDateTime l3 = ldt.plusMinutes(90);      // 2025-03-10T15:00

// Using ChronoUnit
LocalDateTime l4 = ldt.plus(2, ChronoUnit.WEEKS); // 2025-03-24T13:30

// Using Period and Duration
Period p = Period.ofDays(10);
Duration d = Duration.ofHours(5);

LocalDateTime l5 = ldt.plus(p);    // 2025-03-20T13:30
LocalDateTime l6 = ldt.plus(d);    // 2025-03-10T18:30
```

### 12.1.7 Aritmetica su `ZonedDateTime`

`ZonedDateTime` rappresenta data + ora + fuso orario + offset.

Supporta gli stessi metodi `plus`/`minus` di `LocalDateTime`, ma con attenzione aggiuntiva ai fusi orari e all’ora legale (DST).

**Principali metodi `plus` / `minus` (overload)**

| Metodo | Descrizione |
| --- | --- |
| `plusYears(long years)` / `minusYears(long years)` | Regola gli anni |
| `plusMonths(long months)` / `minusMonths(long months)` | Regola i mesi |
| `plusWeeks(long weeks)` / `minusWeeks(long weeks)` | Regola le settimane |
| `plusDays(long days)` / `minusDays(long days)` | Regola i giorni |
| `plusHours(long hours)` / `minusHours(long hours)` | Regola le ore |
| `plusMinutes(long minutes)` / `minusMinutes(long minutes)` | Regola i minuti |
| `plusSeconds(long seconds)` / `minusSeconds(long seconds)` | Regola i secondi |
| `plusNanos(long nanos)` / `minusNanos(long nanos)` | Regola i nanosecondi |
| `plus(TemporalAmount amount)` / `minus(TemporalAmount amount)` | Period / Duration |
| `plus(long amountToAdd, TemporalUnit unit)` / `minus(long amountToSubtract, TemporalUnit unit)` | Usando ChronoUnit |

- Esempi (con fusi orari e DST):

```java
ZonedDateTime zdt = ZonedDateTime.of(
    2025, 3, 30, 1, 30, 0, 0,
    ZoneId.of("Europe/Paris")
);

// Add 2 hours across a possible DST change
ZonedDateTime z1 = zdt.plusHours(2);
System.out.println(zdt);
System.out.println(z1);
```

A seconda delle regole dell’ora legale per quella data:

- L’orario locale potrebbe saltare da 02:00 a 03:00 o simile.
- `ZonedDateTime` regola l’offset e l’orario locale secondo le regole della zona, ma rappresenta comunque l’istante corretto sulla timeline.

> [!IMPORTANT]
> Per `ZonedDateTime`, l’aritmetica è definita in termini di timeline locale e regole del fuso orario, il che può causare spostamenti di ore durante le transizioni DST.

### 12.1.8 Tabella riassuntiva

| Classe | Metodi shortcut plus/minus | Metodi generici |
| --- | --- | --- |
| LocalDate | plusDays, plusWeeks, plusMonths, plusYears (e minus) | plus/minus(TemporalAmount), plus/minus(long, TemporalUnit) |
| LocalTime | plusNanos, plusSeconds, plusMinutes, plusHours (e minus) | plus/minus(TemporalAmount), plus/minus(long, TemporalUnit) |
| LocalDateTime | Tutte le scorciatoie di LocalDate + LocalTime | plus/minus(TemporalAmount), plus/minus(long, TemporalUnit) |
| ZonedDateTime | Come LocalDateTime, ma con consapevolezza della zona | plus/minus(TemporalAmount), plus/minus(long, TemporalUnit) |

---

## 12.2 Metodi `withXxx(...)`

I metodi `with...` restituiscono una copia dell’oggetto con un campo modificato.
Non mutano mai l’istanza originale.

| Classe | Metodi with... comuni (non esaustivo) | Descrizione |
| --- | --- | --- |
| `LocalDate` | withYear(int year) | Stessa data, ma con un anno diverso |
| LocalDate | LocalDate.withMonth(int month) | Stessa data, mese diverso (1–12) |
| LocalDate | LocalDate.withDayOfMonth(int dayOfMonth) | Stessa data, giorno del mese diverso |
| LocalDate | LocalDate.with(TemporalField field, long newValue) | Regolazione generica basata su campo |
| LocalDate | LocalDate.with(TemporalAdjuster adjuster) | Usa un adjuster (es. firstDayOfMonth()) |
| `LocalTime` | withHour(int hour) | Stessa ora, ora (hour) diversa |
| LocalTime | LocalTime.withMinute(int minute) | Stessa ora, minuto diverso |
| LocalTime | LocalTime.withSecond(int second) | Stessa ora, secondo diverso |
| LocalTime | LocalTime.withNano(int nanoOfSecond) | Stessa ora, nanosecondo diverso |
| LocalTime | LocalTime.with(TemporalField field, long newValue) | Regolazione generica basata su campo |
| LocalTime | LocalTime.with(TemporalAdjuster adjuster) | Regola usando un temporal adjuster |
| `LocalDateTime` | withYear(int year), withMonth(int month), withDayOfMonth(int day) | Cambia solo la parte data |
| LocalDateTime | withHour(int hour), withMinute(int minute), withSecond(int second) | Cambia solo la parte ora |
| LocalDateTime | withNano(int nanoOfSecond) | Cambia il nanosecondo |
| LocalDateTime | with(TemporalField field, long newValue) | Regolazione generica basata su campo |
| LocalDateTime | with(TemporalAdjuster adjuster) | Regola usando un temporal adjuster |
| `ZonedDateTime` | tutti i withXxx(...) di LocalDateTime | Cambia i componenti locali di data/ora |
| ZonedDateTime | withZoneSameInstant(ZoneId zone) | Stesso istante, zona diversa (cambia l’ora locale) |
| ZonedDateTime | withZoneSameLocal(ZoneId zone) | Stessa data/ora locale, zona diversa (cambia l’istante) |

---

## 12.3 Conversione e metodi `at...` (collegare data, ora e zona)

Questi metodi sono usati per combinare o convertire tra `LocalDate`, `LocalTime`, `LocalDateTime` e `ZonedDateTime`.

| Da | Metodo | Risultato | Descrizione |
| --- | --- | --- | --- |
| `LocalDate` | atTime(LocalTime time) | LocalDateTime | Combina questa data con un’ora data |
| LocalDate | atTime(int hour, int minute) | LocalDateTime | Overload di convenienza con componenti numerici dell’ora |
| LocalDate | atTime(int hour, int minute, int second) | LocalDateTime | — |
| LocalDate | atTime(int hour, int minute, int second, int nano) | LocalDateTime | — |
| LocalDate | atStartOfDay() | LocalDateTime | Questa data all’ora 00:00 |
| LocalDate | atStartOfDay(ZoneId zone) | ZonedDateTime | Questa data all’inizio del giorno in una zona specifica |
| `LocalTime` | atDate(LocalDate date) | LocalDateTime | Combina questa ora con una data data |
| `LocalDateTime` | atZone(ZoneId zone) | ZonedDateTime | Aggiunge un fuso orario a una data/ora locale |
| LocalDateTime | toLocalDate() | LocalDate | Estrae il componente data |
| LocalDateTime | toLocalTime() | LocalTime | Estrae il componente ora |
| `ZonedDateTime` | toLocalDate() | LocalDate | Rimuove zona/offset, mantiene la data locale |
| ZonedDateTime | toLocalTime() | LocalTime | Rimuove zona/offset, mantiene l’ora locale |
| ZonedDateTime | toLocalDateTime() | LocalDateTime | Rimuove zona/offset, mantiene la data/ora locale |

---

## 12.4 Period, Duration e Instant

Il package `java.time` fornisce tre classi temporali essenziali che rappresentano quantità di tempo o punti sulla timeline:

- **Period** → quantità di data “umane” (anni, mesi, giorni)
- **Duration** → quantità di tempo “macchina” (secondi, nanosecondi)
- **Instant** → un punto sulla timeline UTC

---

## 12.5 `Period` — quantità “umane” di data

`Period` rappresenta una quantità di tempo basata su data, come “3 anni, 2 mesi e 5 giorni”.
Si usa con `LocalDate` e `LocalDateTime` (perché contengono parti di data).

**Metodi di creazione**

| Metodo | Descrizione |
| --- | --- |
| Period.ofYears(int years) | Solo anni |
| Period.ofMonths(int months) | Solo mesi |
| Period.ofWeeks(int weeks) | Converte settimane in giorni |
| Period.ofDays(int days) | Solo giorni |
| Period.of(int years, int months, int days) | Periodo completo |
| Period.parse(CharSequence text) | Formato ISO-8601: "P1Y2M3D", "P7D", "P1W", ... |

**Proprietà chiave**

- Non supporta ore, minuti, secondi, nanosecondi.
- Può essere negativo.
- Immutabile.

- Esempi

```java
Period p1 = Period.ofYears(1);             // P1Y
Period p2 = Period.of(1, 2, 3);            // P1Y2M3D
Period p3 = Period.ofWeeks(2);             // P14D (converted to days)

LocalDate base = LocalDate.of(2025, 1, 10);
LocalDate result = base.plus(p2);          // 2026-03-13
```

> [!NOTE]
> Period.parse("P1W") is allowed and represents a period of 7 days (equivalent to "P7D").

> [!TIP]
> Period is calendar-based: adding a period of months/years respects month lengths and leap years.

---

## 12.6 `Duration` — quantità “macchina” di tempo

`Duration` rappresenta una quantità di tempo basata su secondi e nanosecondi.
Si usa con `LocalTime`, `LocalDateTime`, `ZonedDateTime` e `Instant`.

**Metodi di creazione**

| Metodo | Descrizione |
| --- | --- |
| Duration.ofDays(long days) | Converte i giorni in secondi |
| Duration.ofHours(long hours) | Converte le ore in secondi |
| Duration.ofMinutes(long minutes) | Converte i minuti in secondi |
| Duration.ofSeconds(long seconds) | Rappresentazione base in secondi |
| Duration.ofSeconds(long seconds, long nanoAdjustment) | Secondi più nanos aggiuntivi |
| Duration.ofMillis(long millis) | Converte i millisecondi in nanos |
| Duration.ofNanos(long nanos) | Solo nanosecondi |
| Duration.between(Temporal start, Temporal end) | Calcola la durata tra due istanti |
| Duration.parse(CharSequence text) | ISO: "PT20H", "PT15M", "PT10S" |

**Caratteristiche chiave**

- Supporta ore fino ai nanosecondi, ma non anni/mesi/settimane direttamente.
- Ideale per calcoli temporali a livello “macchina”.
- Immutabile.

- Esempi

```java
Duration d1 = Duration.ofHours(5);           // PT5H
Duration d2 = Duration.ofMinutes(90);        // PT1H30M

LocalTime t = LocalTime.of(10, 0);
LocalTime t2 = t.plus(d2);                   // 11:30

ZonedDateTime z1 = ZonedDateTime.of(
    2024, 3, 30, 1, 0, 0, 0,
    ZoneId.of("Europe/Paris")
);

ZonedDateTime z2 = z1.plusHours(2);          // DST-aware
ZonedDateTime z3 = z1.plus(d2);              // Duration-based
```

> [!NOTE]
> Duration.ofDays(1) represents exactly 24 hours of machine time.  
> In a zone with DST, 24 hours may not align with “the same local time tomorrow”.

---

## 12.7 `Instant` — punto sulla timeline UTC

`Instant` rappresenta un singolo momento nel tempo relativo a UTC, con precisione al nanosecondo.

Contiene:

- Secondi dall’epoca (1970-01-01T00:00Z).
- Un’aggiunta di nanosecondi.

**Metodi di creazione**

| Metodo | Descrizione |
| --- | --- |
| Instant.now() | Momento corrente in UTC |
| Instant.ofEpochSecond(long seconds) | Da secondi dall’epoca |
| Instant.ofEpochSecond(long seconds, long nanos) | Da secondi più nanos |
| Instant.ofEpochMilli(long millis) | Da millisecondi dall’epoca |
| Instant.parse(CharSequence text) | ISO: "2024-01-01T10:15:30Z" |

**Conversioni**

| Azione | Metodo |
| --- | --- |
| Instant → ora con zona | instant.atZone(zoneId) |
| ZonedDateTime → Instant | zdt.toInstant() |
| LocalDateTime → Instant | Non consentito direttamente (serve una zona) |

- Esempio

```java
Instant i = Instant.now();

ZonedDateTime z = i.atZone(ZoneId.of("Europe/Paris"));
Instant back = z.toInstant();  // same moment

// Duration between instants
Instant start = Instant.parse("2024-01-01T10:00:00Z");
Instant end   = Instant.parse("2024-01-01T12:30:00Z");

Duration between = Duration.between(start, end); // PT2H30M
```

> [!IMPORTANT]
> Instant è sempre UTC, senza informazioni di fuso orario associate.  
> Non può essere combinato con un Period; usa invece Duration.

---

## 12.8 Tabella riassuntiva (Period vs Duration vs Instant)

| Concetto | Rappresenta | Utile per | Funziona con | Note |
| --- | --- | --- | --- | --- |
| Period | Anni, mesi, giorni | Aritmetica di calendario | LocalDate, LocalDateTime | Unità basate su “umano” |
| Duration | Ore fino ai nanosecondi | Calcoli temporali precisi | LocalTime, LocalDateTime, ZonedDateTime, Instant | Basato su “macchina” |
| Instant | Punto esatto sulla timeline UTC | Rappresentazione timestamp | Convertibile da/a ZonedDateTime | Non combinabile con Period |

**Trappole comuni**

- `Period.of(1, 0, 0)` non è la stessa cosa di `Duration.ofDays(365)` (anni bisestili!).
- `Duration.ofDays(1)` potrebbe non essere uguale a un “giorno di calendario” pieno in una zona con DST.
- `LocalDateTime` non può essere convertito in un `Instant` senza un fuso orario.
- `Period.parse("P1W")` è valido e produce un periodo di 7 giorni.

---

## 12.9 TemporalUnit e TemporalAmount

L’API `java.time` si basa su due interfacce chiave che definiscono come date, orari e durate vengono manipolati:

- `TemporalUnit` → rappresenta un’unità di tempo (ad esempio, DAYS, HOURS, MINUTES).
- `TemporalAmount` → rappresenta una quantità di tempo (ad esempio, `Period`, `Duration`).

Entrambe sono essenziali per capire come funzionano i metodi `plus`, `minus` e `with`, e compaiono spesso nelle domande di certificazione.

### 12.9.1 `TemporalUnit`

`TemporalUnit` rappresenta una singola unità di misura di data/ora.
L’implementazione principale usata in Java è:

### 12.9.2 enum `ChronoUnit`

Questo enum fornisce le unità standard usate nella cronologia ISO-8601:

| Categoria | Unità |
| --- | --- |
| Unità di data | DAYS, WEEKS, MONTHS, YEARS, DECADES, CENTURIES, MILLENNIA, ERAS |
| Unità di tempo | NANOS, MICROS, MILLIS, SECONDS, MINUTES, HOURS, HALF_DAYS |
| Speciale | FOREVER |

Un `TemporalUnit` può essere usato direttamente con i metodi `plus()` e `minus()`.

- Esempi usando `ChronoUnit`:

```java
LocalDate date = LocalDate.of(2025, 3, 10);

LocalDate d1 = date.plus(10, ChronoUnit.DAYS);     // 2025-03-20
LocalDate d2 = date.minus(2, ChronoUnit.MONTHS);   // 2025-01-10

LocalTime time = LocalTime.of(10, 0);
LocalTime t1 = time.plus(90, ChronoUnit.MINUTES);  // 11:30
```

> [!IMPORTANT]
> Non puoi usare unità basate sul tempo con LocalDate, né unità basate sulla data con LocalTime.

- Esempi:

```java
// ❌ UnsupportedTemporalTypeException
LocalDate d = LocalDate.now().plus(5, ChronoUnit.HOURS);

// ❌ UnsupportedTemporalTypeException
LocalTime t = LocalTime.now().plus(1, ChronoUnit.DAYS);
```

### 12.9.3 `TemporalAmount`

`TemporalAmount` rappresenta una quantità di tempo multi-unità (per esempio, “2 anni, 3 mesi”, o “90 minuti”).
È implementato da:

- `Period` → anni, mesi, giorni (basato su data)
- `Duration` → secondi, nanosecondi (basato su tempo)

Entrambi possono essere passati agli oggetti di data/ora per regolarli usando `plus()` e `minus()`.

### 12.9.4 `Period` come `TemporalAmount`

`Period` rappresenta una quantità “umana”: anni, mesi, giorni.

- Esempi:

```java
Period p = Period.of(1, 2, 3);  // 1 year, 2 months, 3 days

LocalDate base = LocalDate.of(2025, 3, 10);
LocalDate result = base.plus(p); // 2026-05-13
```

Note

- `Period` non può essere usato con `LocalTime` (nessun componente data).
- `Period.ofWeeks(n)` viene convertito internamente in giorni (n × 7).

### 12.9.5 `Duration` come `TemporalAmount`

`Duration` rappresenta tempo “macchina”: secondi + nanosecondi.

- Esempi:

```java
Duration d = Duration.ofHours(5).plusMinutes(30); // PT5H30M

LocalDateTime ldt = LocalDateTime.of(2025, 3, 10, 10, 0);
LocalDateTime result = ldt.plus(d); // 2025-03-10T15:30
```

Note

- `Duration` può essere usata con classi che hanno componenti di ora (`LocalTime`, `LocalDateTime`, `ZonedDateTime`, `Instant`).
- `Duration` non può essere applicata a `LocalDate` → lancerà `UnsupportedTemporalTypeException`.
- `Duration` interagisce con zone e transizioni DST quando applicata a `ZonedDateTime`.

### 12.9.6 Usare `TemporalAmount` vs `TemporalUnit`

Usare un `TemporalUnit`:

```java
LocalDate d1 = LocalDate.now().plus(5, ChronoUnit.DAYS);
```

Usare un `TemporalAmount`:

```java
Period p = Period.ofDays(5);
LocalDate d2 = LocalDate.now().plus(p);
```

Entrambi producono lo stesso risultato quando supportati.

**Differenze**

| Aspetto | TemporalUnit | TemporalAmount |
| --- | --- | --- |
| Rappresenta | Una singola unità (es., DAYS) | Una quantità strutturata (es. 2Y, 5M, 3D) |
| Esempi | ChronoUnit.DAYS | Period.of(2,5,3) |
| Supporta più campi | No | Sì |
| Utile per | Incrementi semplici | Incrementi complessi |
| Comune con | Tutte le classi data/ora | Limitato dal tipo |

### 12.9.7 Metodi `between(...)`

Molte classi forniscono un metodo `between` da `ChronoUnit`, `Duration` o `Period`.

**Usare `Duration.between` (per classi basate sul tempo)**

```java
Duration d = Duration.between(
    LocalTime.of(10, 0),
    LocalTime.of(13, 30)
);
// PT3H30M
```

**Usare `Period.between` (solo per date)**

```java
Period p = Period.between(
    LocalDate.of(2025, 3, 1),
    LocalDate.of(2025, 5, 10)
);
// P2M9D
```

**Usare `ChronoUnit` `between`**

```java
long days = ChronoUnit.DAYS.between(
    LocalDate.of(2025, 3, 1),
    LocalDate.of(2025, 3, 10)
);
// 9
```

> [!IMPORTANT]
> ChronoUnit.between(...) always returns a long,  
> while Period.between returns a Period,  
> and Duration.between returns a Duration.

### 12.9.8 Problemi comuni

- Applicare il `TemporalAmount` sbagliato:

```java
// LocalTime.plus(Period.ofDays(1))   // ❌ compile-time error
// LocalDate.plus(Duration.ofHours(1)) // ❌ runtime error: UnsupportedTemporalTypeException
```

- Cambi DST con Duration: aggiungere 24 ore non è sempre “domani” in una zona con cambi DST.
- `Period.ofWeeks(1)` è esattamente 7 giorni; gli effetti DST compaiono quando applicato a tipi consapevoli della zona.
- `Instant.plus(Period)` → runtime `UnsupportedTemporalTypeException`; usa `Duration` se possibile.
- `Instant` non puo esser creata direttamente da `LocalDateTime`; devi applicare prima una time zone: `ldt.atZone(zone).toInstant()`.

### 12.9.9 Summary

| Feature | TemporalUnit | TemporalAmount | ChronoUnit | Period | Duration |
| --- | --- | --- | --- | --- | --- |
| Represents | A unit | An amount | enum of units | Y/M/D | S + nanos |
| Multi-field | No | Yes | No | Yes | No |
| Works with | plus/minus | plus/minus | date/time | LocalDate/LocalDateTime | Time/time-zone |
| Human-based | No | Yes | No | Yes | No |
| Machine-based | Yes | Yes | Yes | No | Yes |
