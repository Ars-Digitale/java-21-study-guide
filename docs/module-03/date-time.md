# 12. Date and Time in Java

### Table of Contents

- [12. Date and Time in Java](#12-date-and-time-in-java)
  - [12.1 Date and Time](#121-date-and-time)
    - [12.1.1 Creating Specific Dates and Times](#1211-creating-specific-dates-and-times)
    - [12.1.2 Date and Time Arithmetic plus and minus Methods](#1212-date-and-time-arithmetic-plus-and-minus-methods)
    - [12.1.3 Common Patterns](#1213-common-patterns)
    - [12.1.4 LocalDate Arithmetic](#1214-localdate-arithmetic)
    - [12.1.5 LocalTime Arithmetic](#1215-localtime-arithmetic)
    - [12.1.6 LocalDateTime Arithmetic](#1216-localdatetime-arithmetic)
    - [12.1.7 ZonedDateTime Arithmetic](#1217-zoneddatetime-arithmetic)
    - [12.1.8 Summary Table](#1218-summary-table)
  - [12.2 withXxx Methods](#122-withxxx-methods)
  - [12.3 Conversion and at Methods Linking Date Time and Zone](#123-conversion-and-at-methods-linking-date-time-and-zone)
  - [12.4 Period Duration and Instant](#124-period-duration-and-instant)
  - [12.5 Period — Human Date Amounts](#125-period--human-date-amounts)
  - [12.6 Duration — Machine Time Amounts](#126-duration--machine-time-amounts)
  - [12.7 Instant — Point on the UTC Timeline](#127-instant--point-on-the-utc-timeline)
  - [12.8 Summary Table Period vs Duration vs Instant](#128-summary-table-period-vs-duration-vs-instant)
  - [12.9 TemporalUnit and TemporalAmount](#129-temporalunit-and-temporalamount)
    - [12.9.1 TemporalUnit](#1291-temporalunit)
    - [12.9.2 ChronoUnit enum](#1292-chronounit-enum)
    - [12.9.3 TemporalAmount](#1293-temporalamount)
    - [12.9.4 Period as a TemporalAmount](#1294-period-as-a-temporalamount)
    - [12.9.5 Duration as a TemporalAmount](#1295-duration-as-a-temporalamount)
    - [12.9.6 Using TemporalAmount vs TemporalUnit](#1296-using-temporalamount-vs-temporalunit)
    - [12.9.7 between Methods](#1297-between-methods)
    - [12.9.8 Common Pitfalls](#1298-common-pitfalls)
    - [12.9.9 Summary](#1299-summary)


---

## 12.1 Date and Time

Java provides a modern, consistent, immutable date/time API in the package **`java.time.*`**.  
This API replaces the old `java.util.Date` and `java.util.Calendar` classes and is widely tested in certification exams.

Depending on the level of detail required, Java offers four main classes:

- **`LocalDate`** → represents a *date* only (year-month-day)
- **`LocalTime`** → represents a *time* only (hour-minute-second-nanosecond)
- **`LocalDateTime`** → combines *date + time*, but **no time zone**
- **`ZonedDateTime`** → full *date + time + offset + time zone*

> [!NOTE]
> - A **time zone** defines rules such as daylight saving changes (e.g., `Europe/Paris`).  
> - A **zone offset** is a fixed shift from UTC/GMT (e.g., `+01:00`, `-07:00`).  
> - To compare two instants from different time zones, convert them to UTC (GMT) by applying the offset.

**Getting the Current Date/Time**

You can retrieve the current system values using the `static now()` method:

```java
System.out.println(LocalDate.now());
System.out.println(LocalTime.now());
System.out.println(LocalDateTime.now());
System.out.println(ZonedDateTime.now());
```

Example output (your system may differ):

```bash
2025-12-01
19:11:53.213856300
2025-12-01T19:11:53.213856300
2025-12-01T19:11:53.214856900+01:00[Europe/Paris]
```

Example: Converting ZonedDateTime to GMT (UTC)

```java
2024-07-01T12:00+09:00[Asia/Tokyo]        ---> 12:00 minus 9 hours ---> 03:00 UTC
2024-07-01T20:00-07:00[America/Los_Angeles] ---> 20:00 plus 7 hours ---> 03:00 UTC
```

Both represent **the same instant in time**, simply expressed in different time zones.


### 12.1.1 Creating Specific Dates and Times

You can build precise date/time objects using the `of()` factory methods.  
All classes include multiple overloaded versions of `of()` (not listed in examples, but included below).

**LocalDate — overloaded `of()` forms**
- `of(int year, int month, int dayOfMonth)`
- `of(int year, Month month, int dayOfMonth)`

**LocalTime — overloaded `of()` forms**
- `of(int hour, int minute)`
- `of(int hour, int minute, int second)`
- `of(int hour, int minute, int second, int nanoOfSecond)`

**LocalDateTime — overloaded `of()` forms**
- `of(int year, int month, int day, int hour, int minute)`
- `of(int year, int month, int day, int hour, int minute, int second)`
- `of(int year, int month, int day, int hour, int minute, int second, int nano)`
- `of(LocalDate date, LocalTime time)`

**ZonedDateTime — overloaded `of()` forms**
- `of(LocalDate date, LocalTime time, ZoneId zone)`
- `of(int y, int m, int d, int h, int min, int s, int nano, ZoneId zone)`

Examples

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

### 12.1.2 Date and Time Arithmetic: `plus` and `minus` Methods

All classes in the `java.time` package (`LocalDate`, `LocalTime`, `LocalDateTime`, `ZonedDateTime`, etc.) are **immutable**.  
This means that methods like `plusXxx()` and `minusXxx()` **never modify** the original object — instead, they return a **new instance** with the adjusted value.

These methods are heavily used and frequently tested in certification exams.


### 12.1.3 Common Patterns

Most date/time classes support three kinds of arithmetic methods:

1. **Type-specific shortcuts**  
   - `plusDays(long daysToAdd)`  
   - `plusHours(long hoursToAdd)`  
   - etc.

2. **Generic amount-based methods**  
   - `plus(TemporalAmount amount)` → e.g. `Period`, `Duration`  
   - `minus(TemporalAmount amount)`

3. **Generic unit-based methods**  
   - `plus(long amountToAdd, TemporalUnit unit)`  
   - `minus(long amountToSubtract, TemporalUnit unit)`  

These allow flexible and readable date/time arithmetic.


### 12.1.4 `LocalDate` Arithmetic

`LocalDate` represents a **date only** (no time, no zone).

**Main `plus` / `minus` methods (overloads)**

| Method | Description |
|--------|-------------|
| `plusDays(long days)` | Add days |
| `plusWeeks(long weeks)` | Add weeks |
| `plusMonths(long months)` | Add months |
| `plusYears(long years)` | Add years |
| `minusDays(long days)` | Subtract days |
| `minusWeeks(long weeks)` | Subtract weeks |
| `minusMonths(long months)` | Subtract months |
| `minusYears(long years)` | Subtract years |
| `plus(TemporalAmount amount)` | Add a `Period` |
| `minus(TemporalAmount amount)` | Subtract a `Period` |
| `plus(long amountToAdd, TemporalUnit unit)` | Add using `ChronoUnit` (e.g., DAYS, MONTHS) |
| `minus(long amountToSubtract, TemporalUnit unit)` | Subtract using `ChronoUnit` |

Examples:

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


### 12.1.5 `LocalTime` Arithmetic

`LocalTime` represents **time only** (no date, no zone).

**Main `plus` / `minus` methods (overloads)**

| Method | Description |
|--------|-------------|
| `plusNanos(long nanos)` | Add nanoseconds |
| `plusSeconds(long seconds)` | Add seconds |
| `plusMinutes(long minutes)` | Add minutes |
| `plusHours(long hours)` | Add hours |
| `minusNanos(long nanos)` | Subtract nanoseconds |
| `minusSeconds(long seconds)` | Subtract seconds |
| `minusMinutes(long minutes)` | Subtract minutes |
| `minusHours(long hours)` | Subtract hours |
| `plus(TemporalAmount amount)` | Add a `Duration` |
| `minus(TemporalAmount amount)` | Subtract a `Duration` |
| `plus(long amountToAdd, TemporalUnit unit)` | Add using `ChronoUnit` |
| `minus(long amountToSubtract, TemporalUnit unit)` | Subtract using `ChronoUnit` |

Examples

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
> When time arithmetic crosses midnight, the date is **ignored** with `LocalTime`.  
> For example, 23:30 + 2 hours = 01:30 (with no date involved).


### 12.1.6 `LocalDateTime` Arithmetic

`LocalDateTime` combines **date + time**, but still **no time zone**.

It supports both the date-related and time-related shortcut methods.

**Main `plus` / `minus` methods (overloads)**

| Method | Description |
|--------|-------------|
| `plusYears(long years)` / `minusYears(long years)` | Adjust years |
| `plusMonths(long months)` / `minusMonths(long months)` | Adjust months |
| `plusWeeks(long weeks)` / `minusWeeks(long weeks)` | Adjust weeks |
| `plusDays(long days)` / `minusDays(long days)` | Adjust days |
| `plusHours(long hours)` / `minusHours(long hours)` | Adjust hours |
| `plusMinutes(long minutes)` / `minusMinutes(long minutes)` | Adjust minutes |
| `plusSeconds(long seconds)` / `minusSeconds(long seconds)` | Adjust seconds |
| `plusNanos(long nanos)` / `minusNanos(long nanos)` | Adjust nanoseconds |
| `plus(TemporalAmount amount)` / `minus(TemporalAmount amount)` | Add/subtract `Period` or `Duration` |
| `plus(long amountToAdd, TemporalUnit unit)` / `minus(long amountToSubtract, TemporalUnit unit)` | Using `ChronoUnit` |

Examples

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

### 12.1.7 `ZonedDateTime` Arithmetic

`ZonedDateTime` represents **date + time + time zone + offset**.  

It supports the same plus/minus methods as `LocalDateTime`, but with extra attention to **time zones** and **Daylight Saving Time (DST)**.

**Main `plus` / `minus` methods (overloads)**

| Method | Description |
|--------|-------------|
| `plusYears(long years)` / `minusYears(long years)` | Adjust years |
| `plusMonths(long months)` / `minusMonths(long months)` | Adjust months |
| `plusWeeks(long weeks)` / `minusWeeks(long weeks)` | Adjust weeks |
| `plusDays(long days)` / `minusDays(long days)` | Adjust days |
| `plusHours(long hours)` / `minusHours(long hours)` | Adjust hours |
| `plusMinutes(long minutes)` / `minusMinutes(long minutes)` | Adjust minutes |
| `plusSeconds(long seconds)` / `minusSeconds(long seconds)` | Adjust seconds |
| `plusNanos(long nanos)` / `minusNanos(long nanos)` | Adjust nanoseconds |
| `plus(TemporalAmount amount)` / `minus(TemporalAmount amount)` | `Period` / `Duration` |
| `plus(long amountToAdd, TemporalUnit unit)` / `minus(long amountToSubtract, TemporalUnit unit)` | Using `ChronoUnit` |

Examples (with time zones and DST)

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

Depending on Daylight Saving rules for that date:

- The local time might jump from 02:00 to 03:00 or similar.
- `ZonedDateTime` adjusts the **offset and local time** according to the zone rules, but still represents the correct instant on the timeline.

> [!IMPORTANT]  
> For `ZonedDateTime`, arithmetic is defined in terms of the **local timeline** and **time zone rules**, which can cause hour shifts during DST transitions. 



### 12.1.8 Summary Table

| Class           | Shortcut `plus`/`minus` methods                                | Generic methods                                |
|----------------|------------------------------------------------------------------|-----------------------------------------------|
| `LocalDate`    | `plusDays`, `plusWeeks`, `plusMonths`, `plusYears` (and `minus`) | `plus/minus(TemporalAmount)`, `plus/minus(long, TemporalUnit)` |
| `LocalTime`    | `plusNanos`, `plusSeconds`, `plusMinutes`, `plusHours` (and `minus`) | `plus/minus(TemporalAmount)`, `plus/minus(long, TemporalUnit)` |
| `LocalDateTime`| All `LocalDate` + `LocalTime` shortcuts                         | `plus/minus(TemporalAmount)`, `plus/minus(long, TemporalUnit)` |
| `ZonedDateTime`| Same as `LocalDateTime`, but zone-aware                         | `plus/minus(TemporalAmount)`, `plus/minus(long, TemporalUnit)` |


## 12.2 `withXxx(...)` Methods

The `with...` methods return a **copy** of the object with one field changed.  
They never mutate the original instance.

| Class           | Common `with...` methods (not exhaustive)                                 | Description                                      |
|----------------|----------------------------------------------------------------------------|--------------------------------------------------|
| `LocalDate`    | `withYear(int year)`                                                      | Same date, but with a different year             |
|                | `withMonth(int month)`                                                    | Same date, different month (1–12)                |
|                | `withDayOfMonth(int dayOfMonth)`                                          | Same date, different day of month                |
|                | `with(TemporalField field, long newValue)`                                | Generic field-based adjustment                   |
|                | `with(TemporalAdjuster adjuster)`                                         | Uses an adjuster (e.g. `firstDayOfMonth()`)      |
| `LocalTime`    | `withHour(int hour)`                                                      | Same time, different hour                        |
|                | `withMinute(int minute)`                                                  | Same time, different minute                      |
|                | `withSecond(int second)`                                                  | Same time, different second                      |
|                | `withNano(int nanoOfSecond)`                                              | Same time, different nanosecond                  |
|                | `with(TemporalField field, long newValue)`                                | Generic field-based adjustment                   |
|                | `with(TemporalAdjuster adjuster)`                                         | Adjust using a temporal adjuster                 |
| `LocalDateTime`| `withYear(int year)`, `withMonth(int month)`, `withDayOfMonth(int day)`   | Change date part only                            |
|                | `withHour(int hour)`, `withMinute(int minute)`, `withSecond(int second)`  | Change time part only                            |
|                | `withNano(int nanoOfSecond)`                                              | Change nanosecond                                |
|                | `with(TemporalField field, long newValue)`                                | Generic field-based adjustment                   |
|                | `with(TemporalAdjuster adjuster)`                                         | Adjust using a temporal adjuster                 |
| `ZonedDateTime`| All the `withXxx(...)` of `LocalDateTime`                                 | Change local date/time components                |
|                | `withZoneSameInstant(ZoneId zone)`                                        | Same instant, different zone (changes local time)|
|                | `withZoneSameLocal(ZoneId zone)`                                          | Same local date/time, different zone (changes instant) |



## 12.3 Conversion & `at...` Methods (Linking Date, Time, and Zone)

These methods are used to **combine** or **convert** between `LocalDate`, `LocalTime`, `LocalDateTime`, and `ZonedDateTime`.

| From              | Method                                     | Result           | Description                                        |
|-------------------|--------------------------------------------|------------------|----------------------------------------------------|
| `LocalDate`       | `atTime(LocalTime time)`                   | `LocalDateTime`  | Combines this date with a given time               |
|                   | `atTime(int hour, int minute)`             | `LocalDateTime`  | Convenience overloads with numeric time components |
|                   | `atTime(int hour, int minute, int second)` | `LocalDateTime`  |                                                    |
|                   | `atTime(int hour, int minute, int second, int nano)` | `LocalDateTime` |                                                    |
|                   | `atStartOfDay()`                           | `LocalDateTime`  | This date at time `00:00`                          |
|                   | `atStartOfDay(ZoneId zone)`                | `ZonedDateTime`  | This date at start of day in a specific zone       |
| `LocalTime`       | `atDate(LocalDate date)`                   | `LocalDateTime`  | Combines this time with a given date               |
| `LocalDateTime`   | `atZone(ZoneId zone)`                      | `ZonedDateTime`  | Adds a time zone to a local date-time              |
|                   | `toLocalDate()`                            | `LocalDate`      | Extracts the date component                        |
|                   | `toLocalTime()`                            | `LocalTime`      | Extracts the time component                        |
| `ZonedDateTime`   | `toLocalDate()`                            | `LocalDate`      | Drops zone/offset, keeps local date                |
|                   | `toLocalTime()`                            | `LocalTime`      | Drops zone/offset, keeps local time                |
|                   | `toLocalDateTime()`                        | `LocalDateTime`  | Drops zone/offset, keeps local date-time           |


## 12.4 Period, Duration, and Instant

The `java.time` package provides three essential temporal classes that represent **amounts of time** or **points on the timeline**, independent of human calendar systems:

- **Period** → human‐based date amounts (years, months, days)
- **Duration** → machine-based time amounts (seconds, nanoseconds)
- **Instant** → a point on the UTC timeline

These are foundational for date/time arithmetic and are frequently tested in the certification exam.

## 12.5 `Period` — Human Date Amounts

A `Period` represents a **date-based amount of time**, such as “3 years, 2 months, and 5 days”.  
It is used with **LocalDate** and **LocalDateTime** (because they contain date parts).

**✔ Creation Methods**

| Method | Description |
|--------|-------------|
| `Period.ofYears(int years)` | Only years |
| `Period.ofMonths(int months)` | Only months |
| `Period.ofWeeks(int weeks)` | Converts weeks → days |
| `Period.ofDays(int days)` | Only days |
| `Period.of(int years, int months, int days)` | Full period |
| `Period.parse(CharSequence text)` | ISO-8601 format: `"P1Y2M3D"` |

✔ Key properties

- **Does NOT support hours, minutes, seconds, nanoseconds**  
- **Can be negative**  
- **Immutable**  

Examples

```java
Period p1 = Period.ofYears(1);             // P1Y
Period p2 = Period.of(1, 2, 3);            // P1Y2M3D
Period p3 = Period.ofWeeks(2);             // P14D (converted to days)

LocalDate base = LocalDate.of(2025, 1, 10);
LocalDate result = base.plus(p2);          // 2026-03-13
```

✔ Common Pitfall
`Period.ofWeeks(1)` is **not** 7 calendar days in all contexts when combined with DST-sensitive classes.  
(But DST issues mainly affect `ZonedDateTime + Duration`.)


## 12.6 `Duration` — Machine Time Amounts

A `Duration` represents a **time-based amount** in seconds and nanoseconds.  
It is used with **LocalTime**, **LocalDateTime**, and **ZonedDateTime**.

**✔ Creation Methods**

| Method | Description |
|--------|-------------|
| `Duration.ofDays(long days)` | Converts days → seconds |
| `Duration.ofHours(long hours)` | Converts hours → seconds |
| `Duration.ofMinutes(long minutes)` | Converts minutes → seconds |
| `Duration.ofSeconds(long seconds)` | Base representation |
| `Duration.ofSeconds(long seconds, long nanoAdjustment)` | sec + nanos |
| `Duration.ofMillis(long millis)` | Converts ms → nanos |
| `Duration.ofNanos(long nanos)` | Nanos only |
| `Duration.between(Temporal start, Temporal end)` | Compute duration between two instants |
| `Duration.parse(CharSequence text)` | ISO: `"PT20H"` `"PT15M"` `"PT10S"` |

✔ Key characteristics

- Supports **hours → nanoseconds**, but **NOT years/months/weeks**  
- Ideal for machine-level time computations  
- Immutable  

Examples

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

✔ Common pitfall
`Duration.ofDays(1)` is **not necessarily 24h of local time** in zones with DST changes.


## 12.7 `Instant` — Point on the UTC Timeline

An `Instant` represents a single moment in time relative to **UTC**, with nanosecond precision.

It contains:

- seconds since epoch (1970-01-01T00:00Z)
- nanoseconds adjustment

**✔ Creation Methods**

| Method | Description |
|--------|-------------|
| `Instant.now()` | Current moment in UTC |
| `Instant.ofEpochSecond(long seconds)` | Epoch seconds |
| `Instant.ofEpochSecond(long seconds, long nanos)` | With nanos |
| `Instant.ofEpochMilli(long millis)` | Epoch milliseconds |
| `Instant.parse(CharSequence text)` | ISO: `"2024-01-01T10:15:30Z"` |

**✔ Conversions**

| Action | Method |
|--------|--------|
| Convert `Instant` → zoned time | `instant.atZone(zoneId)` |
| Convert `ZonedDateTime` → Instant | `zdt.toInstant()` |
| Convert `LocalDateTime` → Instant | **Not allowed** (needs a zone) |

Example
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
> `Instant` is always **UTC**, no time zone attached.  
> It cannot be combined with a `Period`.


## 12.8 Summary Table (Period vs Duration vs Instant)

| Concept | Represents | Good For | Works With | Notes |
|--------|------------|-----------|------------|-------|
| **Period** | Years, months, days | Calendar arithmetic | `LocalDate`, `LocalDateTime` | Human-based units |
| **Duration** | Hours → nanoseconds | Precise time calculations | `LocalTime`, `LocalDateTime`, `ZonedDateTime`, `Instant` | Machine-based |
| **Instant** | Exact point on UTC timeline | Timestamp representation | Convertable to/from `ZonedDateTime` | Cannot combine with Period |


Common Traps

- `Period.of(1, 0, 0)` ≠ `Duration.ofDays(365)` (leap years!)
- `Duration.ofDays(1)` may not equal a full day in a DST zone  
  (e.g., “lost hour” in spring)
- `LocalDateTime` cannot be converted to an `Instant` without a time zone
- `Period.parse("P1W")` is NOT allowed — only `"P7D"` results from creation using weeks


## 12.9 TemporalUnit and TemporalAmount

The `java.time` API is built on two key interfaces that define how dates, times, and durations are manipulated:

- **`TemporalUnit`** → represents a *unit of time* (e.g., DAYS, HOURS, MINUTES)
- **`TemporalAmount`** → represents an *amount of time* (e.g., `Period`, `Duration`)

Both are essential for understanding how the plus/minus and with methods work, and they frequently appear in certification questions.


### 12.9.1 `TemporalUnit`

`TemporalUnit` represents a **single unit** of date/time measurement.  
The main implementation used in Java is:

### 12.9.2 `ChronoUnit` (enum)

This enum provides the standard units used in the ISO-8601 chronology:

| Category | Units |
|----------|-------|
| **Date units** | `DAYS`, `WEEKS`, `MONTHS`, `YEARS`, `DECADES`, `CENTURIES`, `MILLENNIA`, `ERAS` |
| **Time units** | `NANOS`, `MICROS`, `MILLIS`, `SECONDS`, `MINUTES`, `HOURS`, `HALF_DAYS` |
| **Special** | `FOREVER` |

Note:  
A `TemporalUnit` can be used directly with `plus()` and `minus()` methods.

Examples using `ChronoUnit`

```java
LocalDate date = LocalDate.of(2025, 3, 10);

LocalDate d1 = date.plus(10, ChronoUnit.DAYS);     // 2025-03-20
LocalDate d2 = date.minus(2, ChronoUnit.MONTHS);   // 2025-01-10

LocalTime time = LocalTime.of(10, 0);
LocalTime t1 = time.plus(90, ChronoUnit.MINUTES);  // 11:30
```

✔ Common Pitfall
You **cannot** use time-based units with `LocalDate`, nor date-based units with `LocalTime`.

Examples:

```java
// ❌ UnsupportedTemporalTypeException
LocalDate d = LocalDate.now().plus(5, ChronoUnit.HOURS);

// ❌ UnsupportedTemporalTypeException
LocalTime t = LocalTime.now().plus(1, ChronoUnit.DAYS);
```


### 12.9.3 `TemporalAmount`

`TemporalAmount` represents a **multiple-unit amount** of time (e.g. “2 years, 3 months”, or “90 minutes”).  
It is implemented by:

- **`Period`** → years, months, days (date-based)
- **`Duration`** → seconds, nanoseconds (time-based)

Both can be passed to date/time objects to adjust them using `plus()` and `minus()`.


### 12.9.4 `Period` as a `TemporalAmount`

`Period` represents a human-based amount: **years, months, days**.

Examples:

```java
Period p = Period.of(1, 2, 3);  // 1 year, 2 months, 3 days

LocalDate base = LocalDate.of(2025, 3, 10);
LocalDate result = base.plus(p); // 2026-05-13
```

Notes
- A `Period` **cannot** be used with `LocalTime` (no date).  
- `Period.ofWeeks(n)` is converted internally to *days*.


### 12.9.5 `Duration` as a `TemporalAmount`

`Duration` represents machine-based time: **seconds + nanoseconds**.

Examples:

```java
Duration d = Duration.ofHours(5).plusMinutes(30); // PT5H30M

LocalDateTime ldt = LocalDateTime.of(2025, 3, 10, 10, 0);
LocalDateTime result = ldt.plus(d); // 2025-03-10T15:30
```

Notes
- A `Duration` **can** be used with classes that have time components (`LocalTime`, `LocalDateTime`, `ZonedDateTime`, `Instant`).  
- A `Duration` **cannot** be applied to `LocalDate`: it will throw `UnsupportedTemporalTypeException`.  
- `Duration` interacts with zones and DST transitions if applied to `ZonedDateTime`.


### 12.9.6 Using `TemporalAmount` vs `TemporalUnit`

✔ Using a TemporalUnit

```java
LocalDate d1 = LocalDate.now().plus(5, ChronoUnit.DAYS);
```

✔ Using a TemporalAmount

```java
Period p = Period.ofDays(5);
LocalDate d2 = LocalDate.now().plus(p);
```

Both produce the same result when supported.

**Differences**

| Aspect | `TemporalUnit` | `TemporalAmount` |
|--------|----------------|------------------|
| Represents | A single unit (e.g., DAYS) | A structured quantity (e.g. 2Y, 5M, 3D) |
| Examples | `ChronoUnit.DAYS` | `Period.of(2,5,3)` |
| Supports multiple fields | No | Yes |
| Good for | Simple increments | Complex increments |
| Common with | all date/time classes | restricted by type |

### 12.9.7 `between(...)` Methods

Many classes provide a `between` method from `ChronoUnit`, `Duration`, or `Period`.

✔ Using `Duration.between` (for time-based classes)

```java
Duration d = Duration.between(
    LocalTime.of(10, 0),
    LocalTime.of(13, 30)
);
// PT3H30M
```

✔ Using `Period.between` (ONLY for dates)

```java
Period p = Period.between(
    LocalDate.of(2025, 3, 1),
    LocalDate.of(2025, 5, 10)
);
// P2M9D
```

✔ Using ChronoUnit BETWEEN

```java
long days = ChronoUnit.DAYS.between(
    LocalDate.of(2025, 3, 1),
    LocalDate.of(2025, 3, 10)
);
// 9
```

> [!IMPORTANT]  
> `ChronoUnit.between(...)` always returns a **long**,  
> while `Period.between` returns a `Period`,  
> and `Duration.between` returns a `Duration`.


### 12.9.8 Common Pitfalls

1. **Applying the wrong TemporalAmount**  
   - `LocalTime.plus(Period.ofDays(1))` → ❌ compile-time error  
   - `LocalDate.plus(Duration.ofHours(1))` → ❌ runtime error (UnsupportedTemporalTypeException)

2. **DST changes with Duration**  
   `Duration` represents machine time; adding 24 hours is not always “tomorrow” in a DST zone.

3. **Period weeks convert to days**  
   `Period.ofWeeks(1)` is exactly **7 days**, nothing else.

4. **Instant cannot use Period**  
   - `Instant plus Period` → ❌ runtime UnsupportedTemporalTypeException  
   - Must use `Duration` instead.

5. **Instant cannot be created from LocalDateTime**  
   - Needs a time zone: `ldt.atZone(zone).toInstant()`.


### 12.9.9 Summary

| Feature | TemporalUnit | TemporalAmount | ChronoUnit | Period | Duration |
|---------|--------------|----------------|------------|--------|----------|
| Represents | a unit | an amount | enum of units | Y/M/D | S + nanos |
| Multi-field | ❌ | ✔ | ❌ | ✔ | ❌ |
| Works with | plus/minus | plus/minus | date/time | LocalDate/LocalDateTime | Time/time-zone |
| Human-based | ❌ | ✔ | ❌ | ✔ | ❌ |
| Machine-based | ✔ | ✔ | ✔ | ❌ | ✔ |


