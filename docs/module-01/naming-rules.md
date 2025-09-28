# Java Naming Rules

Java defines precise rules for **identifiers**, which are the names given to variables, methods, classes, interfaces, and packages.

As long as you follow the naming rules described below, you are free to choose meaningful names for your program elements.

---

## Rules for Identifiers

### 1. Reserved Words

- Identifiers **cannot** be the same as Java’s **keywords** or **reserved literals**.  
- Keywords are predefined, special words in the Java language which you are not allowed to use (see [Java Keywords](#java-reserved-keywords)).  
- Literals such as `true`, `false`, and `null` are also reserved and cannot be used as identifiers.  
- Example:  
  ```java
  int class = 5;        // invalid: 'class' is a keyword
  boolean true = false; // invalid: 'true' is a literal
  ```

#### a. Java Reserved Keywords

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

> \* `goto` and `const` are reserved but not used.  

#### b. Reserved Literals

- `true`  
- `false`  
- `null`  

---

### 2. Case Sensitivity

- Identifiers in Java are **case sensitive**.  
- This means `myVar`, `MyVar`, and `MYVAR` are all different identifiers.  
- Example:  
  ```java
  int myVar = 1;
  int MyVar = 2;
  int MYVAR = 3;
  int CLASS = 6; // legal but, please, don't do it!!
  ```
> \* **WARNING!** : Because of case sensitivity, you could use versions of keywords which differ in case. While legal, such naming is discouraged because it reduces readability and it is considered a very bad practice.

---

### 3. Beginning of Identifiers

- Identifiers in Java must begin with a letter, a currency symbol ( $, €, £, ₹...) or a _ symbol.   
- Example:  
  ```java
  int myVarA;
  int $myVarB;
  int _myVarC;
  ```
---

### 4. Numbers in Identifiers

- Identifiers in Java can include numbers but they cannot start with them.   
- Example:  
  ```java
  int my33VarA;
  int $myVar44;
  int 3myVarC; // // invalid: literal starting with a number
  ```
---

### 5. Single _ token

- A single _ (underscore) token is not allowed   
- Example:  
  ```java
  int _; // // invalid: single underscore token;
  ```
---

### 6. Numeric literals & Underscore character

- You can have one or more _ (underscore) character in number literals in order to make them easier to read.
- You can have underscores anywhere except at the beginning, at the end or right around (before/after) a decimal point.
   
- Example:  
  ```java
  int firstNum = 1_000_000;
  int secondNum = 1 _____________ 2;
  
  double firstDouble = _1000.00   // DOES NOT COMPILE
  double secondDouble = 1000_.00  // DOES NOT COMPILE
  double thirdDouble = 1000._00   // DOES NOT COMPILE
  double fourthDouble = 1000.00_  // DOES NOT COMPILE
  
  ```
---