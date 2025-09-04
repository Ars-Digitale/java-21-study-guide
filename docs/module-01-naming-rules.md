# Java Naming Rules

Java defines precise rules for **identifiers**, which are the names given to variables, methods, classes, interfaces, and packages.

As long as you follow the naming rules described below, you are free to choose meaningful names for your program elements.

---

## Rules for Identifiers

### 1. Reserved Words

- Identifiers **cannot** be the same as Java’s **keywords** or **literals**.  
- Keywords are predefined words in the Java language.  
- Literals such as `true`, `false`, and `null` are also reserved and cannot be used as identifiers.  
- Example ❌:  
  ```java
  int class = 5;        // invalid: 'class' is a keyword
  boolean true = false; // invalid: 'true' is a literal
  ```

#### Java Keywords (50 total)

| | | | | |
|---|---|---|---|---|
| abstract | continue | for | new | switch |
| assert | default | goto* | package | synchronized |
| boolean | do | if | private | this |
| break | double | implements | protected | throw |
| byte | else | import | public | throws |
| case | enum | instanceof | return | transient |
| catch | extends | int | short | try |
| char | final | interface | static | void |
| class | finally | long | strictfp | volatile |
| const* | float | native | super | while |

> \* `goto` and `const` are reserved but not used.  

#### Reserved Literals

- `true`  
- `false`  
- `null`  

---

### 2. Case Sensitivity

- Identifiers in Java are **case sensitive**.  
- This means `myVar`, `MyVar`, and `MYVAR` are all different identifiers.  
- Example ✅:  
  ```java
  int myVar = 1;
  int MyVar = 2;
  int MYVAR = 3;
  System.out.println(myVar + MyVar + MYVAR); // prints 6
  ```
- While legal, such naming is discouraged because it reduces readability.

---

 