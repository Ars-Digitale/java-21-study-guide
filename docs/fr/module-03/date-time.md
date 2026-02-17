# 12. Date et heure en Java

<a id="table-des-matières"></a>
### Table des matières

- [12. Date et heure en Java](#12-date-et-heure-en-java)
	- [12.1 Date et heure](#121-date-et-heure)
		- [12.1.1 Créer des dates et heures spécifiques](#1211-créer-des-dates-et-heures-spécifiques)
		- [12.1.2 Arithmétique date/heure : méthodes plus et minus](#1212-arithmétique-dateheure--méthodes-plus-et-minus)
		- [12.1.3 Modèles courants](#1213-modèles-courants)
		- [12.1.4 Arithmétique LocalDate](#1214-arithmétique-localdate)
		- [12.1.5 Arithmétique LocalTime](#1215-arithmétique-localtime)
		- [12.1.6 Arithmétique LocalDateTime](#1216-arithmétique-localdatetime)
		- [12.1.7 Arithmétique ZonedDateTime](#1217-arithmétique-zoneddatetime)
		- [12.1.8 Tableau récapitulatif](#1218-tableau-récapitulatif)
	- [12.2 Méthodes withXxx](#122-méthodes-withxxx)
	- [12.3 Conversion et méthodes at (lier date, heure et zone)](#123-conversion-et-méthodes-at-lier-date-heure-et-zone)
	- [12.4 Period, Duration et Instant](#124-period-duration-et-instant)
	- [12.5 Period — Durées humaines basées sur la date](#125-period--durées-humaines-basées-sur-la-date)
	- [12.6 Duration — Durées machine basées sur le temps](#126-duration--durées-machine-basées-sur-le-temps)
	- [12.7 Instant — Point sur la chronologie UTC](#127-instant--point-sur-la-chronologie-utc)
	- [12.8 Tableau récapitulatif : Period vs Duration vs Instant](#128-tableau-récapitulatif-period-vs-duration-vs-instant)
	- [12.9 TemporalUnit et TemporalAmount](#129-temporalunit-et-temporalamount)
		- [12.9.1 TemporalUnit](#1291-temporalunit)
		- [12.9.2 Enum ChronoUnit](#1292-enum-chronounit)
		- [12.9.3 TemporalAmount](#1293-temporalamount)
		- [12.9.4 Period en tant que TemporalAmount](#1294-period-en-tant-que-temporalamount)
		- [12.9.5 Duration en tant que TemporalAmount](#1295-duration-en-tant-que-temporalamount)
		- [12.9.6 Utiliser TemporalAmount vs TemporalUnit](#1296-utiliser-temporalamount-vs-temporalunit)
		- [12.9.7 Méthodes between](#1297-méthodes-between)
		- [12.9.8 Pièges courants](#1298-pièges-courants)
		- [12.9.9 Résumé](#1299-résumé)


---

<a id="121-date-et-heure"></a>
## 12.1 Date et heure

Java fournit une API moderne, cohérente et immuable de date/heure dans le package `java.time.*`.
 
Cette API remplace les anciennes classes `java.util.Date` et `java.util.Calendar`.

Selon le niveau de détail requis, Java propose quatre classes principales :

- `LocalDate` → représente une date uniquement (année–mois–jour)
- `LocalTime` → représente une heure uniquement (heure–minute–seconde–nanoseconde)
- `LocalDateTime` → combine date + heure, mais sans fuseau horaire
- `ZonedDateTime` → date + heure + décalage + fuseau horaire

!!! note
    - Un **fuseau horaire** définit des règles comme les changements d’heure d’été (par exemple, `Europe/Paris`).
    - Un **décalage de zone** (zone offset) est un décalage fixe par rapport à UTC/GMT (par exemple, `+01:00`, `-07:00`).  
    - Pour comparer deux instants provenant de fuseaux horaires différents, convertissez-les en UTC (GMT) en appliquant le décalage.

**Obtenir la date/heure actuelle**

Vous pouvez récupérer les valeurs système actuelles en utilisant les méthodes statiques `now()` :

```java
System.out.println(LocalDate.now());
System.out.println(LocalTime.now());
System.out.println(LocalDateTime.now());
System.out.println(ZonedDateTime.now());
```

- Exemple de sortie (votre système peut différer) :

```bash
2025-12-01
19:11:53.213856300
2025-12-01T19:11:53.213856300
2025-12-01T19:11:53.214856900+01:00[Europe/Paris]
```

- Exemple : conversion de `ZonedDateTime` vers GMT (UTC)

```java
// Conceptual examples (not real code, just illustrating offsets):
// 2024-07-01T12:00+09:00[Asia/Tokyo]        ---> 12:00 minus 9 hours ---> 03:00 UTC
// 2024-07-01T20:00-07:00[America/Los_Angeles] ---> 20:00 plus 7 hours ---> 03:00 UTC
```

Les deux représentent le même instant dans le temps, simplement exprimé dans des fuseaux horaires différents.

<a id="1211-créer-des-dates-et-heures-spécifiques"></a>
### 12.1.1 Créer des dates et heures spécifiques

Vous pouvez construire des objets date/heure précis en utilisant les méthodes de fabrique `of()`.  

Toutes les classes incluent plusieurs versions surchargées de `of()` (seules les plus courantes sont listées ici).

**LocalDate — formes surchargées de `of()`
- `of(int year, int month, int dayOfMonth)`
- `of(int year, Month month, int dayOfMonth)`

**LocalTime — formes surchargées de `of()`
- `of(int hour, int minute)`
- `of(int hour, int minute, int second)`
- `of(int hour, int minute, int second, int nanoOfSecond)`

**LocalDateTime — formes surchargées de `of()`
- `of(int year, int month, int day, int hour, int minute)`
- `of(int year, int month, int day, int hour, int minute, int second)`
- `of(int year, int month, int day, int hour, int minute, int second, int nano)`
- `of(LocalDate date, LocalTime time)`

**ZonedDateTime — formes surchargées de `of()`
- `of(LocalDate date, LocalTime time, ZoneId zone)`
- `of(int y, int m, int d, int h, int min, int s, int nano, ZoneId zone)`

- Exemples

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

<a id="1212-arithmétique-dateheure--méthodes-plus-et-minus"></a>
### 12.1.2 Arithmétique date/heure : méthodes `plus` et `minus`

Toutes les classes du package `java.time` (comme `LocalDate`, `LocalTime`, `LocalDateTime`, `ZonedDateTime`, etc.) sont **immutables**.
 
Cela signifie que des méthodes comme `plusXxx()` et `minusXxx()` ne modifient jamais l’objet original — elles renvoient à la place une nouvelle instance avec la valeur ajustée.

<a id="1213-modèles-courants"></a>
### 12.1.3 Modèles courants

La plupart des classes date/heure prennent en charge trois types de méthodes arithmétiques :

- **Raccourcis spécifiques au type**  
- `plusDays(long daysToAdd)`  
- `plusHours(long hoursToAdd)`  
- etc.

- **Méthodes génériques basées sur une quantité**  
- `plus(TemporalAmount amount)` → par exemple `Period`, `Duration`  
- `minus(TemporalAmount amount)`  

- **Méthodes génériques basées sur une unité**  
- `plus(long amountToAdd, TemporalUnit unit)`  
- `minus(long amountToSubtract, TemporalUnit unit)`  

Elles permettent une arithmétique de date/heure flexible et lisible.

<a id="1214-arithmétique-localdate"></a>
### 12.1.4 Arithmétique `LocalDate`

`LocalDate` représente une date uniquement (pas d’heure, pas de zone).

**Principales méthodes `plus` / `minus` (surcharges)**

| Méthode | Description |
| --- | --- |
| `plusDays(long days)` | Ajouter des jours |
| `plusWeeks(long weeks)` | Ajouter des semaines |
| `plusMonths(long months)` | Ajouter des mois |
| `plusYears(long years)` | Ajouter des années |
| `minusDays(long days)` | Soustraire des jours |
| `minusWeeks(long weeks)` | Soustraire des semaines |
| `minusMonths(long months)` | Soustraire des mois |
| `minusYears(long years)` | Soustraire des années |
| `plus(TemporalAmount amount)` | Ajouter une Period |
| `minus(TemporalAmount amount)` | Soustraire une Period |
| `plus(long amountToAdd, TemporalUnit unit)` | Ajouter en utilisant ChronoUnit (par ex. DAYS, MONTHS) |
| `minus(long amountToSubtract, TemporalUnit unit)` | Soustraire en utilisant ChronoUnit |

- Exemples :

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

<a id="1215-arithmétique-localtime"></a>
### 12.1.5 Arithmétique `LocalTime`

`LocalTime` représente une heure uniquement (pas de date, pas de zone).

**Principales méthodes `plus` / `minus` (surcharges)**

| Méthode | Description |
| --- | --- |
| `plusNanos(long nanos)` | Ajouter des nanosecondes |
| `plusSeconds(long seconds)` | Ajouter des secondes |
| `plusMinutes(long minutes)` | Ajouter des minutes |
| `plusHours(long hours)` | Ajouter des heures |
| `minusNanos(long nanos)` | Soustraire des nanosecondes |
| `minusSeconds(long seconds)` | Soustraire des secondes |
| `minusMinutes(long minutes)` | Soustraire des minutes |
| `minusHours(long hours)` | Soustraire des heures |
| `plus(TemporalAmount amount)` | Ajouter une Duration |
| `minus(TemporalAmount amount)` | Soustraire une Duration |
| `plus(long amountToAdd, TemporalUnit unit)` | Ajouter en utilisant ChronoUnit |
| `minus(long amountToSubtract, TemporalUnit unit)` | Soustraire en utilisant ChronoUnit |

- Exemples

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
    Quand l’arithmétique des heures franchit minuit, la date est ignorée avec `LocalTime`.
    Par exemple, 23:30 + 2 heures = 01:30 (sans date impliquée).

<a id="1216-arithmétique-localdatetime"></a>
### 12.1.6 Arithmétique `LocalDateTime`

`LocalDateTime` combine date + heure, mais toujours sans fuseau horaire.  

Il prend en charge à la fois les méthodes de raccourci liées à la date et celles liées à l’heure.

**Principales méthodes `plus` / `minus` (surcharges)**

| Méthode | Description |
| --- | --- |
| `plusYears(long years)` / `minusYears(long years)` | Ajuster les années |
| `plusMonths(long months)` / `minusMonths(long months)` | Ajuster les mois |
| `plusWeeks(long weeks)` / `minusWeeks(long weeks)` | Ajuster les semaines |
| `plusDays(long days)` / `minusDays(long days)` | Ajuster les jours |
| `plusHours(long hours)` / `minusHours(long hours)` | Ajuster les heures |
| `plusMinutes(long minutes)` / `minusMinutes(long minutes)` | Ajuster les minutes |
| `plusSeconds(long seconds)` / `minusSeconds(long seconds)` | Ajuster les secondes |
| `plusNanos(long nanos)` / `minusNanos(long nanos)` | Ajuster les nanosecondes |
| `plus(TemporalAmount amount)` / `minus(TemporalAmount amount)` | Ajouter/soustraire Period ou Duration |
| `plus(long amountToAdd, TemporalUnit unit)` / `minus(long amountToSubtract, TemporalUnit unit)` | En utilisant ChronoUnit |

- Exemples

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

<a id="1217-arithmétique-zoneddatetime"></a>
### 12.1.7 Arithmétique `ZonedDateTime`

`ZonedDateTime` représente date + heure + fuseau horaire + décalage.

Il prend en charge les mêmes méthodes `plus`/`minus` que `LocalDateTime`, mais avec une attention supplémentaire aux fuseaux horaires et à l’heure d’été (DST).

**Principales méthodes `plus` / `minus` (surcharges)**

| Méthode | Description |
| --- | --- |
| `plusYears(long years)` / `minusYears(long years)` | Ajuster les années |
| `plusMonths(long months)` / `minusMonths(long months)` | Ajuster les mois |
| `plusWeeks(long weeks)` / `minusWeeks(long weeks)` | Ajuster les semaines |
| `plusDays(long days)` / `minusDays(long days)` | Ajuster les jours |
| `plusHours(long hours)` / `minusHours(long hours)` | Ajuster les heures |
| `plusMinutes(long minutes)` / `minusMinutes(long minutes)` | Ajuster les minutes |
| `plusSeconds(long seconds)` / `minusSeconds(long seconds)` | Ajuster les secondes |
| `plusNanos(long nanos)` / `minusNanos(long nanos)` | Ajuster les nanosecondes |
| `plus(TemporalAmount amount)` / `minus(TemporalAmount amount)` | Period / Duration |
| `plus(long amountToAdd, TemporalUnit unit)` / `minus(long amountToSubtract, TemporalUnit unit)` | En utilisant ChronoUnit |

- Exemples (avec fuseaux horaires et DST) :

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

Selon les règles d’heure d’été pour cette date :

- L’heure locale peut passer de 02:00 à 03:00 ou similaire.
- `ZonedDateTime` ajuste le décalage et l’heure locale selon les règles de zone, mais représente toujours le bon instant sur la timeline.

!!! important
    Pour `ZonedDateTime`, l’arithmétique est définie en fonction de la timeline locale et des règles de fuseau horaire, ce qui peut provoquer des décalages d’heures pendant les transitions DST.

<a id="1218-tableau-récapitulatif"></a>
### 12.1.8 Tableau récapitulatif

| Classe | Méthodes plus/minus de raccourci | Méthodes génériques |
| --- | --- | --- |
| LocalDate | plusDays, plusWeeks, plusMonths, plusYears (et minus) | plus/minus(TemporalAmount), plus/minus(long, TemporalUnit) |
| LocalTime | plusNanos, plusSeconds, plusMinutes, plusHours (et minus) | plus/minus(TemporalAmount), plus/minus(long, TemporalUnit) |
| LocalDateTime | Tous les raccourcis de LocalDate + LocalTime | plus/minus(TemporalAmount), plus/minus(long, TemporalUnit) |
| ZonedDateTime | Identiques à LocalDateTime, mais sensibles à la zone | plus/minus(TemporalAmount), plus/minus(long, TemporalUnit) |

---

<a id="122-méthodes-withxxx"></a>
## 12.2 Méthodes `withXxx(...)`

Les méthodes `with...` renvoient une copie de l’objet avec un champ modifié.  
Elles ne mutent jamais l’instance originale.

| Classe | Méthodes with... courantes (non exhaustif) | Description |
| --- | --- | --- |
| `LocalDate` | withYear(int year) | Même date, mais avec une année différente |
| LocalDate | LocalDate.withMonth(int month) | Même date, mois différent (1–12) |
| LocalDate | LocalDate.withDayOfMonth(int dayOfMonth) | Même date, jour du mois différent |
| LocalDate | LocalDate.with(TemporalField field, long newValue) | Ajustement générique basé sur un champ |
| LocalDate | LocalDate.with(TemporalAdjuster adjuster) | Utilise un adjuster (par ex. firstDayOfMonth()) |
| `LocalTime` | withHour(int hour) | Même heure, heure différente |
| LocalTime | LocalTime.withMinute(int minute) | Même heure, minute différente |
| LocalTime | LocalTime.withSecond(int second) | Même heure, seconde différente |
| LocalTime | LocalTime.withNano(int nanoOfSecond) | Même heure, nanoseconde différente |
| LocalTime | LocalTime.with(TemporalField field, long newValue) | Ajustement générique basé sur un champ |
| LocalTime | LocalTime.with(TemporalAdjuster adjuster) | Ajuster via un temporal adjuster |
| `LocalDateTime` | withYear(int year), withMonth(int month), withDayOfMonth(int day) | Changer uniquement la partie date |
| LocalDateTime | withHour(int hour), withMinute(int minute), withSecond(int second) | Changer uniquement la partie heure |
| LocalDateTime | withNano(int nanoOfSecond) | Changer la nanoseconde |
| LocalDateTime | with(TemporalField field, long newValue) | Ajustement générique basé sur un champ |
| LocalDateTime | with(TemporalAdjuster adjuster) | Ajuster via un temporal adjuster |
| `ZonedDateTime` | tous les withXxx(...) de LocalDateTime | Changer les composants locaux date/heure |
| ZonedDateTime | withZoneSameInstant(ZoneId zone) | Même instant, zone différente (change l’heure locale) |
| ZonedDateTime | withZoneSameLocal(ZoneId zone) | Même date/heure locale, zone différente (change l’instant) |

---

<a id="123-conversion-et-méthodes-at-lier-date-heure-et-zone"></a>
## 12.3 Conversion et méthodes `at...` (lier date, heure et zone)

Ces méthodes sont utilisées pour combiner ou convertir entre `LocalDate`, `LocalTime`, `LocalDateTime` et `ZonedDateTime`.

| Depuis | Méthode | Résultat | Description |
| --- | --- | --- | --- |
| `LocalDate` | atTime(LocalTime time) | LocalDateTime | Combine cette date avec une heure donnée |
| LocalDate | atTime(int hour, int minute) | LocalDateTime | Surcharges de convenance avec des composantes horaires numériques |
| LocalDate | atTime(int hour, int minute, int second) | LocalDateTime | — |
| LocalDate | atTime(int hour, int minute, int second, int nano) | LocalDateTime | — |
| LocalDate | atStartOfDay() | LocalDateTime | Cette date à l’heure 00:00 |
| LocalDate | atStartOfDay(ZoneId zone) | ZonedDateTime | Cette date au début de la journée dans une zone spécifique |
| `LocalTime` | atDate(LocalDate date) | LocalDateTime | Combine cette heure avec une date donnée |
| `LocalDateTime` | atZone(ZoneId zone) | ZonedDateTime | Ajoute un fuseau horaire à une date-heure locale |
| LocalDateTime | toLocalDate() | LocalDate | Extrait la composante date |
| LocalDateTime | toLocalTime() | LocalTime | Extrait la composante heure |
| `ZonedDateTime` | toLocalDate() | LocalDate | Supprime zone/décalage, conserve la date locale |
| ZonedDateTime | toLocalTime() | LocalTime | Supprime zone/décalage, conserve l’heure locale |
| ZonedDateTime | toLocalDateTime() | LocalDateTime | Supprime zone/décalage, conserve la date-heure locale |

---

<a id="124-period-duration-et-instant"></a>
## 12.4 Period, Duration et Instant

Le package `java.time` fournit trois classes temporelles essentielles qui représentent des durées ou des points sur la timeline :

- **Period** → durées humaines basées sur la date (années, mois, jours)
- **Duration** → durées machine basées sur le temps (secondes, nanosecondes)
- **Instant** → un point sur la timeline UTC

---

<a id="125-period--durées-humaines-basées-sur-la-date"></a>
## 12.5 `Period` — Durées humaines basées sur la date

`Period` représente une durée basée sur la date, telle que “3 ans, 2 mois et 5 jours”.  

Il est utilisé avec `LocalDate` et `LocalDateTime` (car ils contiennent des parties date).

**Méthodes de création**

| Méthode | Description |
| --- | --- |
| Period.ofYears(int years) | Uniquement des années |
| Period.ofMonths(int months) | Uniquement des mois |
| Period.ofWeeks(int weeks) | Convertit les semaines en jours |
| Period.ofDays(int days) | Uniquement des jours |
| Period.of(int years, int months, int days) | Période complète |
| Period.parse(CharSequence text) | Format ISO-8601 : "P1Y2M3D", "P7D", "P1W", ... |

**Propriétés clés**

- Ne prend pas en charge les heures, minutes, secondes, nanosecondes.
- Peut être négatif.
- Immuable.

- Exemples

```java
Period p1 = Period.ofYears(1);             // P1Y
Period p2 = Period.of(1, 2, 3);            // P1Y2M3D
Period p3 = Period.ofWeeks(2);             // P14D (converted to days)

LocalDate base = LocalDate.of(2025, 1, 10);
LocalDate result = base.plus(p2);          // 2026-03-13
```

!!! note
    `Period.parse("P1W")` est autorisé et représente une période de 7 jours (équivalente à "P7D").

!!! tip
    `Period` est basé sur le calendrier : ajouter une période de mois/années respecte la longueur des mois et les années bissextiles.

---

<a id="126-duration--durées-machine-basées-sur-le-temps"></a>
## 12.6 `Duration` — Durées machine basées sur le temps

`Duration` représente une durée basée sur le temps en secondes et nanosecondes.
  
Il est utilisé avec `LocalTime`, `LocalDateTime`, `ZonedDateTime` et `Instant`.

**Méthodes de création**

| Méthode | Description |
| --- | --- |
| Duration.ofDays(long days) | Convertit les jours en secondes |
| Duration.ofHours(long hours) | Convertit les heures en secondes |
| Duration.ofMinutes(long minutes) | Convertit les minutes en secondes |
| Duration.ofSeconds(long seconds) | Représentation de base en secondes |
| Duration.ofSeconds(long seconds, long nanoAdjustment) | Secondes plus nanos supplémentaires |
| Duration.ofMillis(long millis) | Convertit les millisecondes en nanos |
| Duration.ofNanos(long nanos) | Uniquement des nanosecondes |
| Duration.between(Temporal start, Temporal end) | Calculer la durée entre deux instants |
| Duration.parse(CharSequence text) | ISO : "PT20H", "PT15M", "PT10S" |

**Caractéristiques clés**

- Prend en charge des heures jusqu’aux nanosecondes, mais pas les années/mois/semaines directement.
- Idéal pour des calculs temporels au niveau machine.
- Immuable.

- Exemples

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
    `Duration.ofDays(1)` représente exactement 24 heures de temps machine.
    Dans une zone avec DST, 24 heures peuvent ne pas correspondre à “la même heure locale demain”.

---

<a id="127-instant--point-sur-la-chronologie-utc"></a>
## 12.7 `Instant` — Point sur la chronologie UTC

`Instant` représente un seul moment dans le temps par rapport à UTC, avec une précision à la nanoseconde.

Il contient :

- Des secondes depuis l’époque (1970-01-01T00:00Z).
- Un ajustement de nanosecondes.

**Méthodes de création**

| Méthode | Description |
| --- | --- |
| Instant.now() | Moment actuel en UTC |
| Instant.ofEpochSecond(long seconds) | À partir des secondes depuis l’époque |
| Instant.ofEpochSecond(long seconds, long nanos) | À partir des secondes plus nanos |
| Instant.ofEpochMilli(long millis) | À partir des millisecondes depuis l’époque |
| Instant.parse(CharSequence text) | ISO : "2024-01-01T10:15:30Z" |

**Conversions**

| Action | Méthode |
| --- | --- |
| Instant → heure zonée | instant.atZone(zoneId) |
| ZonedDateTime → Instant | zdt.toInstant() |
| LocalDateTime → Instant | Non autorisé directement (nécessite une zone) |

- Exemple

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
    `Instant` est toujours en UTC, sans information de fuseau horaire attachée.
    Il ne peut pas être combiné avec une `Period` ; utilisez `Duration` à la place.

---

<a id="128-tableau-récapitulatif-period-vs-duration-vs-instant"></a>
## 12.8 Tableau récapitulatif (Period vs Duration vs Instant)

| Concept | Représente | Bon pour | Fonctionne avec | Notes |
| --- | --- | --- | --- | --- |
| Period | Années, mois, jours | Arithmétique calendaire | LocalDate, LocalDateTime | Unités humaines |
| Duration | Heures à nanosecondes | Calculs temporels précis | LocalTime, LocalDateTime, ZonedDateTime, Instant | Unités machine |
| Instant | Point exact sur la timeline UTC | Représentation d’horodatage | Convertible vers/depuis ZonedDateTime | Ne peut pas être combiné avec Period |

**Pièges courants**

- `Period.of(1, 0, 0)` n’est pas la même chose que `Duration.ofDays(365)` (années bissextiles !).
- `Duration.ofDays(1)` peut ne pas être égal à une “journée calendaire” complète dans une zone DST.
- `LocalDateTime` ne peut pas être converti en `Instant` sans fuseau horaire.
- `Period.parse("P1W")` est valide et donne une période de 7 jours.

---

<a id="129-temporalunit-et-temporalamount"></a>
## 12.9 TemporalUnit et TemporalAmount

L’API `java.time` repose sur deux interfaces clés qui définissent comment les dates, les heures et les durées sont manipulées :

- `TemporalUnit` → représente une unité de temps (par exemple, DAYS, HOURS, MINUTES).
- `TemporalAmount` → représente une quantité de temps (par exemple, `Period`, `Duration`).

Les deux sont essentiels pour comprendre comment fonctionnent les méthodes `plus`, `minus` et `with`.

<a id="1291-temporalunit"></a>
### 12.9.1 `TemporalUnit`

`TemporalUnit` représente une seule unité de mesure date/heure.  
L’implémentation principale utilisée en Java est :

<a id="1292-enum-chronounit"></a>
### 12.9.2 Enum `ChronoUnit`

Cet enum fournit les unités standard utilisées dans la chronologie ISO-8601 :

| Catégorie | Unités |
| --- | --- |
| Unités de date | DAYS, WEEKS, MONTHS, YEARS, DECADES, CENTURIES, MILLENNIA, ERAS |
| Unités de temps | NANOS, MICROS, MILLIS, SECONDS, MINUTES, HOURS, HALF_DAYS |
| Spécial | FOREVER |

Un `TemporalUnit` peut être utilisé directement avec les méthodes `plus()` et `minus()`.

- Exemples avec `ChronoUnit` :

```java
LocalDate date = LocalDate.of(2025, 3, 10);

LocalDate d1 = date.plus(10, ChronoUnit.DAYS);     // 2025-03-20
LocalDate d2 = date.minus(2, ChronoUnit.MONTHS);   // 2025-01-10

LocalTime time = LocalTime.of(10, 0);
LocalTime t1 = time.plus(90, ChronoUnit.MINUTES);  // 11:30
```

!!! important
    Vous ne pouvez pas utiliser des unités basées sur le temps avec `LocalDate`, ni des unités basées sur la date avec `LocalTime`.

- Exemples :

```java
// ❌ UnsupportedTemporalTypeException
LocalDate d = LocalDate.now().plus(5, ChronoUnit.HOURS);

// ❌ UnsupportedTemporalTypeException
LocalTime t = LocalTime.now().plus(1, ChronoUnit.DAYS);
```

<a id="1293-temporalamount"></a>
### 12.9.3 `TemporalAmount`

`TemporalAmount` représente une quantité de temps à unités multiples (par exemple, “2 ans, 3 mois”, ou “90 minutes”).  
Elle est implémentée par :

- `Period` → années, mois, jours (basé sur la date)
- `Duration` → secondes, nanosecondes (basé sur le temps)

Les deux peuvent être passés aux objets date/heure pour les ajuster via `plus()` et `minus()`.

<a id="1294-period-en-tant-que-temporalamount"></a>
### 12.9.4 `Period` en tant que `TemporalAmount`

`Period` représente une quantité humaine : années, mois, jours.

- Exemples :

```java
Period p = Period.of(1, 2, 3);  // 1 year, 2 months, 3 days

LocalDate base = LocalDate.of(2025, 3, 10);
LocalDate result = base.plus(p); // 2026-05-13
```

Notes

- `Period` ne peut pas être utilisé avec `LocalTime` (pas de composante date).
- `Period.ofWeeks(n)` est converti en interne en jours (n × 7).

<a id="1295-duration-en-tant-que-temporalamount"></a>
### 12.9.5 `Duration` en tant que `TemporalAmount`

`Duration` représente un temps machine : secondes + nanosecondes.

- Exemples :

```java
Duration d = Duration.ofHours(5).plusMinutes(30); // PT5H30M

LocalDateTime ldt = LocalDateTime.of(2025, 3, 10, 10, 0);
LocalDateTime result = ldt.plus(d); // 2025-03-10T15:30
```

Notes

- `Duration` peut être utilisée avec des classes qui ont des composantes de temps (`LocalTime`, `LocalDateTime`, `ZonedDateTime`, `Instant`).
- `Duration` ne peut pas être appliquée à `LocalDate` → cela lance `UnsupportedTemporalTypeException`.
- `Duration` interagit avec les zones et les transitions DST lorsqu’elle est appliquée à `ZonedDateTime`.

<a id="1296-utiliser-temporalamount-vs-temporalunit"></a>
### 12.9.6 Utiliser `TemporalAmount` vs `TemporalUnit`

Utiliser un `TemporalUnit` :

```java
LocalDate d1 = LocalDate.now().plus(5, ChronoUnit.DAYS);
```

Utiliser un `TemporalAmount` :

```java
Period p = Period.ofDays(5);
LocalDate d2 = LocalDate.now().plus(p);
```

Les deux produisent le même résultat lorsque c’est pris en charge.

**Différences**

| Aspect | TemporalUnit | TemporalAmount |
| --- | --- | --- |
| Représente | Une seule unité (par ex. DAYS) | Une quantité structurée (par ex. 2Y, 5M, 3D) |
| Exemples | ChronoUnit.DAYS | Period.of(2,5,3) |
| Prend en charge plusieurs champs | Non | Oui |
| Bon pour | Incréments simples | Incréments complexes |
| Fréquent avec | Toutes les classes date/heure | Restreint selon le type |

<a id="1297-méthodes-between"></a>
### 12.9.7 Méthodes `between(...)`

De nombreuses classes fournissent une méthode `between` via `ChronoUnit`, `Duration` ou `Period`.

**Utiliser `Duration.between` (pour les classes basées sur le temps)**

```java
Duration d = Duration.between(
    LocalTime.of(10, 0),
    LocalTime.of(13, 30)
);
// PT3H30M
```

**Utiliser `Period.between` (uniquement pour les dates)**

```java
Period p = Period.between(
    LocalDate.of(2025, 3, 1),
    LocalDate.of(2025, 5, 10)
);
// P2M9D
```

**Utiliser `ChronoUnit` `between`**

```java
long days = ChronoUnit.DAYS.between(
    LocalDate.of(2025, 3, 1),
    LocalDate.of(2025, 3, 10)
);
// 9
```

!!! important
    `ChronoUnit.between(...)` renvoie toujours un `long`,
    tandis que `Period.between` renvoie une `Period`,  
    et `Duration.between` renvoie une `Duration`.

<a id="1298-pièges-courants"></a>
### 12.9.8 Pièges courants

- Appliquer le mauvais `TemporalAmount` :

```java
// LocalTime.plus(Period.ofDays(1))   // ❌ compile-time error
// LocalDate.plus(Duration.ofHours(1)) // ❌ runtime error: UnsupportedTemporalTypeException
```

- Changements DST avec `Duration` : ajouter 24 heures n’est pas toujours “demain” dans une zone avec DST.
- `Period.ofWeeks(1)` fait exactement 7 jours ; les effets DST apparaissent lorsqu’il est appliqué à des types sensibles à la zone.
- `Instant.plus(Period)` → `UnsupportedTemporalTypeException` à l’exécution ; utilisez `Duration` à la place.
- `Instant` ne peut pas être créé directement depuis un `LocalDateTime` ; vous devez d’abord appliquer une zone : `ldt.atZone(zone).toInstant()`.

<a id="1299-résumé"></a>
### 12.9.9 Résumé

| Fonctionnalité | TemporalUnit | TemporalAmount | ChronoUnit | Period | Duration |
| --- | --- | --- | --- | --- | --- |
| Représente | Une unité | Une quantité | enum d’unités | Y/M/J | S + nanos |
| Multi-champ | Non | Oui | Non | Oui | Non |
| Fonctionne avec | plus/minus | plus/minus | date/heure | LocalDate/LocalDateTime | Temps/zone |
| Basé sur l’humain | Non | Oui | Non | Oui | Non |
| Basé sur la machine | Oui | Oui | Oui | Non | Oui |

