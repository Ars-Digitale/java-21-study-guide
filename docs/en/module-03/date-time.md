# 12. Date and Time in Java

<a id="table-of-contents"></a>
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
  - [12.3 Conversion and at Methods Linking Date Time and Zone](#123-conversion--at-methods-linking-date-time-and-zone)
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

<a id="121-date-and-time"></a>
## 12.1 Date and Time

Java provides a modern, consistent, immutable date/time API in the package `java.time.*`. 
 
This API replaces the old `java.util.Date` and `java.util.Calendar` classes.

Depending on the level of detail required, Java offers four main classes:

- `LocalDate` → represents a date only (year–month–day)
- `LocalTime` → represents a time only (hour–minute–second–nanosecond)
- `LocalDateTime` → combines date + time, but no time zone
- `ZonedDateTime` → full date + time + offset + time zone

!!! note
    - A **time zone** defines rules such as daylight saving changes (for example, `Europe/Paris`).
    - A **zone offset** is a fixed shift from UTC/GMT (for example, `+01:00`, `-07:00`).  
    - To compare two instants from different time zones, convert them to UTC (GMT) by applying the offset.

**Getting the Current Date/Time**

You can retrieve the current system values using the static `now()` methods:

```java
System.out.println(LocalDate.now());
System.out.println(LocalTime.now());
System.out.println(LocalDateTime.now());
System.out.println(ZonedDateTime.now());
```

- Example output (your system may differ):

```bash
2025-12-01
19:11:53.213856300
2025-12-01T19:11:53.213856300
2025-12-01T19:11:53.214856900+01:00[Europe/Paris]
```

- Example: converting `ZonedDateTime` to GMT (UTC)

```java
// Conceptual examples (not real code, just illustrating offsets):
// 2024-07-01T12:00+09:00[Asia/Tokyo]        ---> 12:00 minus 9 hours ---> 03:00 UTC
// 2024-07-01T20:00-07:00[America/Los_Angeles] ---> 20:00 plus 7 hours ---> 03:00 UTC
```

Both represent the same instant in time, simply expressed in different time zones.

<a id="1211-creating-specific-dates-and-times"></a>
### 12.1.1 Creating Specific Dates and Times

You can build precise date/time objects using the `of()` factory methods.  

All classes include multiple overloaded versions of `of()` (only the most common are listed here).

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

- Examples

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

<a id="1212-date-and-time-arithmetic-plus-and-minus-methods"></a>
### 12.1.2 Date and Time Arithmetic: `plus` and `minus` Methods

All classes in the `java.time` package (such as `LocalDate`, `LocalTime`, `LocalDateTime`, `ZonedDateTime`, etc.) are **immutable**. 
 
This means that methods like `plusXxx()` and `minusXxx()` never modify the original object — instead, they return a new instance with the adjusted value.


<a id="1213-common-patterns"></a>
### 12.1.3 Common Patterns

Most date/time classes support three kinds of arithmetic methods:

- **Type-specific shortcuts**  
- `plusDays(long daysToAdd)`  
- `plusHours(long hoursToAdd)`  
- etc.

- **Generic amount-based methods**  
- `plus(TemporalAmount amount)` → for example `Period`, `Duration`  
- `minus(TemporalAmount amount)`

- **Generic unit-based methods**  
- `plus(long amountToAdd, TemporalUnit unit)`  
- `minus(long amountToSubtract, TemporalUnit unit)`

These allow flexible and readable date/time arithmetic.

<a id="1214-localdate-arithmetic"></a>
### 12.1.4 `LocalDate` Arithmetic

`LocalDate` represents a date only (no time, no zone).

**Main `plus` / `minus` methods (overloads)**

| Method | Description |
| --- | --- |
| `plusDays(long days)` | Add days |
| `plusWeeks(long weeks)` | Add weeks |
| `plusMonths(long months)` | Add months |
| `plusYears(long years)` | Add years |
| `minusDays(long days)` | Subtract days |
| `minusWeeks(long weeks)` | Subtract weeks |
| `minusMonths(long months)` | Subtract months |
| `minusYears(long years)` | Subtract years |
| `plus(TemporalAmount amount)` | Add a Period |
| `minus(TemporalAmount amount)` | Subtract a Period |
| `plus(long amountToAdd, TemporalUnit unit)` | Add using ChronoUnit (e.g., DAYS, MONTHS) |
| `minus(long amountToSubtract, TemporalUnit unit)` | Subtract using ChronoUnit |

- Examples:

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

<a id="1215-localtime-arithmetic"></a>
### 12.1.5 `LocalTime` Arithmetic

`LocalTime` represents time only (no date, no zone).

**Main `plus` / `minus` methods (overloads)**

| Method | Description |
| --- | --- |
| `plusNanos(long nanos)` | Add nanoseconds |
| `plusSeconds(long seconds)` | Add seconds |
| `plusMinutes(long minutes)` | Add minutes |
| `plusHours(long hours)` | Add hours |
| `minusNanos(long nanos)` | Subtract nanoseconds |
| `minusSeconds(long seconds)` | Subtract seconds |
| `minusMinutes(long minutes)` | Subtract minutes |
| `minusHours(long hours)` | Subtract hours |
| `plus(TemporalAmount amount)` | Add a Duration |
| `minus(TemporalAmount amount)` | Subtract a Duration |
| `plus(long amountToAdd, TemporalUnit unit)` | Add using ChronoUnit |
| `minus(long amountToSubtract, TemporalUnit unit)` | Subtract using ChronoUnit |

- Examples

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

!!! note
    When time arithmetic crosses midnight, the date is ignored with `LocalTime`.
    For example, 23:30 + 2 hours = 01:30 (with no date involved).

<a id="1216-localdatetime-arithmetic"></a>
### 12.1.6 `LocalDateTime` Arithmetic

`LocalDateTime` combines date + time, but still no time zone.  

It supports both the date-related and time-related shortcut methods.

**Main `plus` / `minus` methods (overloads)**

| Method | Description |
| --- | --- |
| `plusYears(long years)` / `minusYears(long years)` | Adjust years |
| `plusMonths(long months)` / `minusMonths(long months)` | Adjust months |
| `plusWeeks(long weeks)` / `minusWeeks(long weeks)` | Adjust weeks |
| `plusDays(long days)` / `minusDays(long days)` | Adjust days |
| `plusHours(long hours)` / `minusHours(long hours)` | Adjust hours |
| `plusMinutes(long minutes)` / `minusMinutes(long minutes)` | Adjust minutes |
| `plusSeconds(long seconds)` / `minusSeconds(long seconds)` | Adjust seconds |
| `plusNanos(long nanos)` / `minusNanos(long nanos)` | Adjust nanoseconds |
| `plus(TemporalAmount amount)` / `minus(TemporalAmount amount)` | Add/subtract Period or Duration |
| `plus(long amountToAdd, TemporalUnit unit)` / `minus(long amountToSubtract, TemporalUnit unit)` | Using ChronoUnit |

- Examples

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

<a id="1217-zoneddatetime-arithmetic"></a>
### 12.1.7 `ZonedDateTime` Arithmetic

`ZonedDateTime` represents date + time + time zone + offset.

It supports the same `plus`/`minus` methods as `LocalDateTime`, but with extra attention to time zones and Daylight Saving Time (DST).

**Main `plus` / `minus` methods (overloads)**

| Method | Description |
| --- | --- |
| `plusYears(long years)` / `minusYears(long years)` | Adjust years |
| `plusMonths(long months)` / `minusMonths(long months)` | Adjust months |
| `plusWeeks(long weeks)` / `minusWeeks(long weeks)` | Adjust weeks |
| `plusDays(long days)` / `minusDays(long days)` | Adjust days |
| `plusHours(long hours)` / `minusHours(long hours)` | Adjust hours |
| `plusMinutes(long minutes)` / `minusMinutes(long minutes)` | Adjust minutes |
| `plusSeconds(long seconds)` / `minusSeconds(long seconds)` | Adjust seconds |
| `plusNanos(long nanos)` / `minusNanos(long nanos)` | Adjust nanoseconds |
| `plus(TemporalAmount amount)` / `minus(TemporalAmount amount)` | Period / Duration |
| `plus(long amountToAdd, TemporalUnit unit)` / `minus(long amountToSubtract, TemporalUnit unit)` | Using ChronoUnit |

- Examples (with time zones and DST):

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
- `ZonedDateTime` adjusts the offset and local time according to the zone rules, but still represents the correct instant on the timeline.

!!! important
    For `ZonedDateTime`, arithmetic is defined in terms of the local timeline and time zone rules, which can cause hour shifts during DST transitions.

<a id="1218-summary-table"></a>
### 12.1.8 Summary Table

| Class | Shortcut plus/minus methods | Generic methods |
| --- | --- | --- |
| LocalDate | plusDays, plusWeeks, plusMonths, plusYears (and minus) | plus/minus(TemporalAmount), plus/minus(long, TemporalUnit) |
| LocalTime | plusNanos, plusSeconds, plusMinutes, plusHours (and minus) | plus/minus(TemporalAmount), plus/minus(long, TemporalUnit) |
| LocalDateTime | All LocalDate + LocalTime shortcuts | plus/minus(TemporalAmount), plus/minus(long, TemporalUnit) |
| ZonedDateTime | Same as LocalDateTime, but zone-aware | plus/minus(TemporalAmount), plus/minus(long, TemporalUnit) |

---

<a id="122-withxxx-methods"></a>
## 12.2 `withXxx(...)` Methods

The `with...` methods return a copy of the object with one field changed.  
They never mutate the original instance.

| Class | Common with... methods (not exhaustive) | Description |
| --- | --- | --- |
| `LocalDate` | withYear(int year) | Same date, but with a different year |
|  | LocalDate.withMonth(int month) | Same date, different month (1–12) |
|  | LocalDate.withDayOfMonth(int dayOfMonth) | Same date, different day of month |
|  | LocalDate.with(TemporalField field, long newValue) | Generic field-based adjustment |
|  | LocalDate.with(TemporalAdjuster adjuster) | Uses an adjuster (e.g. firstDayOfMonth()) |
| `LocalTime` | withHour(int hour) | Same time, different hour |
|  | LocalTime.withMinute(int minute) | Same time, different minute |
|  | LocalTime.withSecond(int second) | Same time, different second |
|  | LocalTime.withNano(int nanoOfSecond) | Same time, different nanosecond |
|  | LocalTime.with(TemporalField field, long newValue) | Generic field-based adjustment |
|  | LocalTime.with(TemporalAdjuster adjuster) | Adjust using a temporal adjuster |
| `LocalDateTime` | withYear(int year), withMonth(int month), withDayOfMonth(int day) | Change date part only |
|  | withHour(int hour), withMinute(int minute), withSecond(int second) | Change time part only |
|  | withNano(int nanoOfSecond) | Change nanosecond |
|  | with(TemporalField field, long newValue) | Generic field-based adjustment |
|  | with(TemporalAdjuster adjuster) | Adjust using a temporal adjuster |
| `ZonedDateTime` | all the withXxx(...) of LocalDateTime | Change local date/time components |
|  | withZoneSameInstant(ZoneId zone) | Same instant, different zone (changes local time) |
|  | withZoneSameLocal(ZoneId zone) | Same local date/time, different zone (changes instant) |

---

<a id="123-conversion-at-methods-linking-date-time-and-zone"></a>
## 12.3 Conversion & `at...` Methods (Linking Date, Time, and Zone)

These methods are used to combine or convert between `LocalDate`, `LocalTime`, `LocalDateTime`, and `ZonedDateTime`.

| From | Method | Result | Description |
| --- | --- | --- | --- |
| `LocalDate` | `atTime(LocalTime time)` | LocalDateTime | Combines this date with a given time |
| LocalDate | `atTime(int hour, int minute)` | LocalDateTime | Convenience overloads with numeric time components |
| LocalDate | `atTime(int hour, int minute, int second)` | LocalDateTime | — |
| LocalDate | `atTime(int hour, int minute, int second, int nano)` | LocalDateTime | — |
| LocalDate | `atStartOfDay()` | LocalDateTime | This date at time 00:00 |
| LocalDate | `atStartOfDay(ZoneId zone)` | ZonedDateTime | This date at start of day in a specific zone |
| `LocalTime` | `atDate(LocalDate date)` | LocalDateTime | Combines this time with a given date |
| `LocalDateTime` | `atZone(ZoneId zone)` | ZonedDateTime | Adds a time zone to a local date-time |
| LocalDateTime | `toLocalDate()` | LocalDate | Extracts the date component |
| LocalDateTime | `toLocalTime()` | LocalTime | Extracts the time component |
| `ZonedDateTime` | `toLocalDate()` | LocalDate | Drops zone/offset, keeps local date |
| ZonedDateTime | `toLocalTime()` | LocalTime | Drops zone/offset, keeps local time |
| ZonedDateTime | `toLocalDateTime()` | LocalDateTime | Drops zone/offset, keeps local date-time |

---

<a id="124-period-duration-and-instant"></a>
## 12.4 Period, Duration, and Instant

The `java.time` package provides three essential temporal classes that represent amounts of time or points on the timeline:

- **Period** → human-based date amounts (years, months, days)
- **Duration** → machine-based time amounts (seconds, nanoseconds)
- **Instant** → a point on the UTC timeline

---

<a id="125-period-human-date-amounts"></a>
## 12.5 `Period` — Human Date Amounts

`Period` represents a date-based amount of time, such as “3 years, 2 months, and 5 days”.  

It is used with `LocalDate` and `LocalDateTime` (because they contain date parts).

**Creation Methods**

| Method | Description |
| --- | --- |
| Period.ofYears(int years) | Only years |
| Period.ofMonths(int months) | Only months |
| Period.ofWeeks(int weeks) | Converts weeks to days |
| Period.ofDays(int days) | Only days |
| Period.of(int years, int months, int days) | Full period |
| Period.parse(CharSequence text) | ISO-8601 format: "P1Y2M3D", "P7D", "P1W", ... |

**Key properties**

- Does not support hours, minutes, seconds, nanoseconds.
- Can be negative.
- Immutable.

- Examples

```java
Period p1 = Period.ofYears(1);             // P1Y
Period p2 = Period.of(1, 2, 3);            // P1Y2M3D
Period p3 = Period.ofWeeks(2);             // P14D (converted to days)

LocalDate base = LocalDate.of(2025, 1, 10);
LocalDate result = base.plus(p2);          // 2026-03-13
```

!!! note
    Period.parse("P1W") is allowed and represents a period of 7 days (equivalent to "P7D").

!!! tip
    Period is calendar-based: adding a period of months/years respects month lengths and leap years.

---

<a id="126-duration-machine-time-amounts"></a>
## 12.6 `Duration` — Machine Time Amounts

`Duration` represents a time-based amount in seconds and nanoseconds.
  
It is used with `LocalTime`, `LocalDateTime`, `ZonedDateTime`, and `Instant`.

**Creation Methods**

| Method | Description |
| --- | --- |
| Duration.ofDays(long days) | Converts days to seconds |
| Duration.ofHours(long hours) | Converts hours to seconds |
| Duration.ofMinutes(long minutes) | Converts minutes to seconds |
| Duration.ofSeconds(long seconds) | Base representation in seconds |
| Duration.ofSeconds(long seconds, long nanoAdjustment) | Seconds plus additional nanos |
| Duration.ofMillis(long millis) | Converts milliseconds to nanos |
| Duration.ofNanos(long nanos) | Nanoseconds only |
| Duration.between(Temporal start, Temporal end) | Compute duration between two instants |
| Duration.parse(CharSequence text) | ISO: "PT20H", "PT15M", "PT10S" |

**Key characteristics**

- Supports hours down to nanoseconds, but not years/months/weeks directly.
- Ideal for machine-level time computations.
- Immutable.

- Examples

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

!!! note
    Duration.ofDays(1) represents exactly 24 hours of machine time.
    In a zone with DST, 24 hours may not align with “the same local time tomorrow”.

---

<a id="127-instant-point-on-the-utc-timeline"></a>
## 12.7 `Instant` — Point on the UTC Timeline

`Instant` represents a single moment in time relative to UTC, with nanosecond precision.

It contains:

- Seconds since the epoch (1970-01-01T00:00Z).
- A nanoseconds adjustment.

**Creation Methods**

| Method | Description |
| --- | --- |
| Instant.now() | Current moment in UTC |
| Instant.ofEpochSecond(long seconds) | From epoch seconds |
| Instant.ofEpochSecond(long seconds, long nanos) | From seconds plus nanos |
| Instant.ofEpochMilli(long millis) | From epoch milliseconds |
| Instant.parse(CharSequence text) | ISO: "2024-01-01T10:15:30Z" |

**Conversions**

| Action | Method |
| --- | --- |
| Instant → zoned time | instant.atZone(zoneId) |
| ZonedDateTime → Instant | zdt.toInstant() |
| LocalDateTime → Instant | Not allowed directly (needs a zone) |

- Example

```java
Instant i = Instant.now();

ZonedDateTime z = i.atZone(ZoneId.of("Europe/Paris"));
Instant back = z.toInstant();  // same moment

// Duration between instants
Instant start = Instant.parse("2024-01-01T10:00:00Z");
Instant end   = Instant.parse("2024-01-01T12:30:00Z");

Duration between = Duration.between(start, end); // PT2H30M
```

!!! important
    Instant is always UTC, with no time zone information attached.
    It cannot be combined with a Period; use Duration instead.

---

<a id="128-summary-table-period-vs-duration-vs-instant"></a>
## 12.8 Summary Table (Period vs Duration vs Instant)

| Concept | Represents | Good For | Works With | Notes |
| --- | --- | --- | --- | --- |
| Period | Years, months, days | Calendar arithmetic | LocalDate, LocalDateTime | Human-based units |
| Duration | Hours to nanoseconds | Precise time calculations | LocalTime, LocalDateTime, ZonedDateTime, Instant | Machine-based |
| Instant | Exact point on UTC timeline | Timestamp representation | Convertible to/from ZonedDateTime | Cannot combine with Period |

**Common Traps**

- `Period.of(1, 0, 0)` is not the same as `Duration.ofDays(365)` (leap years!).
- `Duration.ofDays(1)` may not equal a full “calendar day” in a DST zone.
- `LocalDateTime` cannot be converted to an `Instant` without a time zone.
- `Period.parse("P1W")` is valid and results in a period of 7 days.

---

<a id="129-temporalunit-and-temporalamount"></a>
## 12.9 TemporalUnit and TemporalAmount

The `java.time` API is built on two key interfaces that define how dates, times, and durations are manipulated:

- `TemporalUnit` → represents a unit of time (for example, DAYS, HOURS, MINUTES).
- `TemporalAmount` → represents an amount of time (for example, `Period`, `Duration`).

Both are essential for understanding how the `plus`, `minus`, and `with` methods work.

<a id="1291-temporalunit"></a>
### 12.9.1 `TemporalUnit`

`TemporalUnit` represents a single unit of date/time measurement.  
The main implementation used in Java is:

<a id="1292-chronounit-enum"></a>
### 12.9.2 `ChronoUnit` enum

This enum provides the standard units used in the ISO-8601 chronology:

| Category | Units |
| --- | --- |
| Date units | DAYS, WEEKS, MONTHS, YEARS, DECADES, CENTURIES, MILLENNIA, ERAS |
| Time units | NANOS, MICROS, MILLIS, SECONDS, MINUTES, HOURS, HALF_DAYS |
| Special | FOREVER |

A `TemporalUnit` can be used directly with `plus()` and `minus()` methods.

- Examples using `ChronoUnit`:

```java
LocalDate date = LocalDate.of(2025, 3, 10);

LocalDate d1 = date.plus(10, ChronoUnit.DAYS);     // 2025-03-20
LocalDate d2 = date.minus(2, ChronoUnit.MONTHS);   // 2025-01-10

LocalTime time = LocalTime.of(10, 0);
LocalTime t1 = time.plus(90, ChronoUnit.MINUTES);  // 11:30
```

!!! important
    You cannot use time-based units with LocalDate, nor date-based units with LocalTime.

- Examples:

```java
// ❌ UnsupportedTemporalTypeException
LocalDate d = LocalDate.now().plus(5, ChronoUnit.HOURS);

// ❌ UnsupportedTemporalTypeException
LocalTime t = LocalTime.now().plus(1, ChronoUnit.DAYS);
```

<a id="1293-temporalamount"></a>
### 12.9.3 `TemporalAmount`

`TemporalAmount` represents a multiple-unit amount of time (for example, “2 years, 3 months”, or “90 minutes”).  
It is implemented by:

- `Period` → years, months, days (date-based)
- `Duration` → seconds, nanoseconds (time-based)

Both can be passed to date/time objects to adjust them using `plus()` and `minus()`.

<a id="1294-period-as-a-temporalamount"></a>
### 12.9.4 `Period` as a `TemporalAmount`

`Period` represents a human-based amount: years, months, days.

- Examples:

```java
Period p = Period.of(1, 2, 3);  // 1 year, 2 months, 3 days

LocalDate base = LocalDate.of(2025, 3, 10);
LocalDate result = base.plus(p); // 2026-05-13
```

Notes

- `Period` cannot be used with `LocalTime` (no date component).
- `Period.ofWeeks(n)` is converted internally to days (n × 7).

<a id="1295-duration-as-a-temporalamount"></a>
### 12.9.5 `Duration` as a `TemporalAmount`

`Duration` represents machine-based time: seconds + nanoseconds.

- Examples:

```java
Duration d = Duration.ofHours(5).plusMinutes(30); // PT5H30M

LocalDateTime ldt = LocalDateTime.of(2025, 3, 10, 10, 0);
LocalDateTime result = ldt.plus(d); // 2025-03-10T15:30
```

Notes

- `Duration` can be used with classes that have time components (`LocalTime`, `LocalDateTime`, `ZonedDateTime`, `Instant`).
- `Duration` cannot be applied to `LocalDate` → it will throw `UnsupportedTemporalTypeException`.
- `Duration` interacts with zones and DST transitions when applied to `ZonedDateTime`.

<a id="1296-using-temporalamount-vs-temporalunit"></a>
### 12.9.6 Using `TemporalAmount` vs `TemporalUnit`

Using a `TemporalUnit`:

```java
LocalDate d1 = LocalDate.now().plus(5, ChronoUnit.DAYS);
```

Using a `TemporalAmount`:

```java
Period p = Period.ofDays(5);
LocalDate d2 = LocalDate.now().plus(p);
```

Both produce the same result when supported.

**Differences**

| Aspect | TemporalUnit | TemporalAmount |
| --- | --- | --- |
| Represents | A single unit (e.g., DAYS) | A structured quantity (e.g. 2Y, 5M, 3D) |
| Examples | ChronoUnit.DAYS | Period.of(2,5,3) |
| Supports multiple fields | No | Yes |
| Good for | Simple increments | Complex increments |
| Common with | All date/time classes | Restricted by type |

<a id="1297-between-methods"></a>
### 12.9.7 `between(...)` Methods

Many classes provide a `between` method from `ChronoUnit`, `Duration`, or `Period`.

**Using `Duration.between` (for time-based classes)**

```java
Duration d = Duration.between(
    LocalTime.of(10, 0),
    LocalTime.of(13, 30)
);
// PT3H30M
```

**Using `Period.between` (only for dates)**

```java
Period p = Period.between(
    LocalDate.of(2025, 3, 1),
    LocalDate.of(2025, 5, 10)
);
// P2M9D
```

**Using `ChronoUnit` `between`**

```java
long days = ChronoUnit.DAYS.between(
    LocalDate.of(2025, 3, 1),
    LocalDate.of(2025, 3, 10)
);
// 9
```

!!! important
    ChronoUnit.between(...) always returns a long,
    while Period.between returns a Period,  
    and Duration.between returns a Duration.

<a id="1298-common-pitfalls"></a>
### 12.9.8 Common Pitfalls

- Applying the wrong `TemporalAmount`:

```java
// LocalTime.plus(Period.ofDays(1))   // ❌ compile-time error
// LocalDate.plus(Duration.ofHours(1)) // ❌ runtime error: UnsupportedTemporalTypeException
```

- DST changes with Duration: adding 24 hours is not always “tomorrow” in a zone with DST changes.
- `Period.ofWeeks(1)` is exactly 7 days; DST effects show up when applied to zone-aware types.
- `Instant.plus(Period)` → runtime `UnsupportedTemporalTypeException`; use `Duration` instead.
- `Instant` cannot be created directly from a `LocalDateTime`; you must first apply a time zone: `ldt.atZone(zone).toInstant()`.

<a id="1299-summary"></a>
### 12.9.9 Summary

| Feature | TemporalUnit | TemporalAmount | ChronoUnit | Period | Duration |
| --- | --- | --- | --- | --- | --- |
| Represents | A unit | An amount | enum of units | Y/M/D | S + nanos |
| Multi-field | No | Yes | No | Yes | No |
| Works with | plus/minus | plus/minus | date/time | LocalDate/LocalDateTime | Time/time-zone |
| Human-based | No | Yes | No | Yes | No |
| Machine-based | Yes | Yes | Yes | No | Yes |
