# 3. Java Naming Rules

### Table of Contents

- [3. Java Naming Rules](#3-java-naming-rules)
  - [3.1 Rules for Identifiers](#31-rules-for-identifiers)
    - [3.1.1 Reserved Words](#311-reserved-words)
      - [3.1.1.1 Java Reserved Keywords](#3111-java-reserved-keywords)
      - [3.1.1.2 Reserved Literals](#3112-reserved-literals)
    - [3.1.2 Case Sensitivity](#312-case-sensitivity)
    - [3.1.3 Beginning of Identifiers](#313-beginning-of-identifiers)
    - [3.1.4 Numbers in Identifiers](#314-numbers-in-identifiers)
    - [3.1.5 Single _ Token](#315-single-_-token)
    - [3.1.6 Numeric Literals & Underscore Character](#316-numeric-literals--underscore-character)

---

Java defines precise rules for **identifiers**, which are the names given to variables, methods, classes, interfaces, and packages.

As long as you follow the naming rules described below, you are free to choose meaningful names for your program elements.


## 3.1 Rules for Identifiers

### 3.1.1 Reserved Words

`Identifiers` **cannot** be the same as Java’s **keywords** or **reserved literals**.
  
`Keywords` are predefined, special words in the Java language which you are not allowed to use (see Table below).
  
`Literals` such as `true`, `false`, and `null` are also reserved and cannot be used as identifiers.
  
- Example:  
```java
int class = 5;        // invalid: 'class' is a keyword
boolean true = false; // invalid: 'true' is a literal
int year = 2024;   	// valid
```

#### 3.1.1.1 Java Reserved Keywords

| a -> c | c -> f  | f -> n | n -> s | s -> w|
|---|---|---|---|---|
| abstract | continue | for | new | switch |
| assert   | default  | goto* | package | synchronized |
| boolean  | do       | if | private | this |
| break    | double   | implements | protected | throw |
| byte     | else     | import | public | throws |
| case     | enum     | instanceof | return | transient |
| catch    | extends  | int | short | try |
| char     | final    | interface | static | void |
| class    | finally  | long | strictfp | volatile |
| const*   | float    | native | super | while |

> [!NOTE]
>  `goto` and `const` are reserved but not used.  

#### 3.1.1.2 Reserved Literals

- `true`  
- `false`  
- `null`  


### 3.1.2 Case Sensitivity

Identifiers in Java are **case sensitive**.  
This means `myVar`, `MyVar`, and `MYVAR` are all different identifiers.
  
- Example:  
```java
int myVar = 1;
int MyVar = 2;
int MYVAR = 3;
int CLASS = 6; // legal but, please, don't do it!!
```
  
> [!TIP]
> Java treats identifiers literally: Count, count, and COUNt are unrelated and may exist together.
>
> Because of case sensitivity, you could use versions of keywords which differ in case. 
> While legal, such naming is discouraged because it reduces readability and it is considered a very bad practice.


### 3.1.3 Beginning of Identifiers

Identifiers in Java must begin with a letter, a currency symbol ( $, €, £, ₹...) or a _ symbol.   

Example:  
```java
int myVarA;
int $myVarB;
int _myVarC;
String €uro = "currency"; // legal (rarely seen in practice)
```

> [!NOTE]
> Currency symbols are legal but not recommended in real-world code.


### 3.1.4 Numbers in Identifiers

Identifiers in Java can include numbers but they cannot start with them.   

Example:  
```java
int my33VarA;
int $myVar44;
int 3myVarC; // invalid: identifier cannot start with a digit
int var2024 = 10; // valid
```


### 3.1.5 Single `_` token

- A single underscore (`_`) is not allowed as an identifier.
- Since Java 9, `_` is a reserved token for future language use.

- Example:  
```java
int _;  // invalid since Java 9
```

> [!WARNING]
> `_` is legal inside number literals (see next section), but not as a standalone identifier.


### 3.1.6 Numeric literals & Underscore character

You can have one or more `_` (underscore) character in number literals in order to make them easier to read.

You can have underscores anywhere except at the beginning, at the end or right around (before/after) a decimal point.
   
- Example:  
```java
int firstNum = 1_000_000;
int secondNum = 1 _____________ 2;

double firstDouble = _1000.00   // DOES NOT COMPILE
double secondDouble = 1000_.00  // DOES NOT COMPILE
double thirdDouble = 1000._00   // DOES NOT COMPILE
double fourthDouble = 1000.00_  // DOES NOT COMPILE

double pi = 3.14_159_265; // valid
long mask = 0b1111_0000;  // valid in binary literals
```

> [!TIP]
> Underscores improve readability:
> 1_000_000 is easier than 1000000.

