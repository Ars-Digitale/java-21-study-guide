# 15. Caricamento delle Classi, Inizializzazione e Costruzione degli Oggetti

<a id="indice"></a>
### Indice

- [15. Caricamento delle Classi, Inizializzazione e Costruzione degli Oggetti](#15-caricamento-delle-classi-inizializzazione-e-costruzione-degli-oggetti)
  - [15.1 Aree di Memoria Java Rilevanti per l’Inizializzazione di Classi e Oggetti](#151-aree-di-memoria-java-rilevanti-per-linizializzazione-di-classi-e-oggetti)
  - [15.2 Caricamento delle Classi con Ereditarietà](#152-caricamento-delle-classi-con-ereditarietà)
    - [15.2.1 Ordine di Caricamento delle Classi](#1521-ordine-di-caricamento-delle-classi)
    - [15.2.2 Cosa Succede Durante il Caricamento di una Classe](#1522-cosa-succede-durante-il-caricamento-di-una-classe)
  - [15.3 Creazione degli Oggetti con Ereditarietà](#153-creazione-degli-oggetti-con-ereditarietà)
    - [15.3.1 Ordine Completo di Creazione delle Istanze](#1531-ordine-completo-di-creazione-delle-istanze)
  - [15.4 Esempio Completo: Inizializzazione Statica + di Istanza nell’Ereditarietà](#154-esempio-completo-inizializzazione-statica--di-istanza-nellereditarietà)
  - [15.5 Diagramma di Visualizzazione](#155-diagramma-di-visualizzazione)
  - [15.6 Regole Chiave](#156-regole-chiave)
  - [15.7 Tabella Riassuntiva](#157-tabella-riassuntiva)

---

In Java, comprendere **come vengono caricate le classi**, **come vengono inizializzati i membri statici e di istanza**, e **come vengono eseguiti i costruttori — specialmente con l’ereditarietà** — è fondamentale per padroneggiare il linguaggio.

Questo capitolo fornisce una spiegazione unificata e chiara su:

- Come una classe viene caricata in memoria  
- Come vengono eseguite le variabili statiche e i blocchi statici  
- Come vengono creati gli oggetti passo dopo passo  
- Come vengono eseguiti i costruttori in una catena ereditaria  
- Come le diverse aree di memoria (Heap, Stack, Method Area) partecipano al processo  

<a id="151-aree-di-memoria-java-rilevanti-per-linizializzazione-di-classi-e-oggetti"></a>
## 15.1 Aree di Memoria Java rilevanti per l’Inizializzazione di Classi e Oggetti

Prima di comprendere l’ordine di inizializzazione, è utile ricordare le tre principali aree di memoria coinvolte:

- **Method Area (nota anche come Class Area)** — memorizza i metadati delle classi, le variabili statiche e i blocchi di inizializzazione statica.  
- **Heap** — memorizza tutti gli oggetti e i campi di istanza.  
- **Stack** — memorizza le chiamate ai metodi, le variabili locali e i riferimenti.  

!!! note
    I membri statici appartengono alla **classe** e vengono creati **una sola volta** nella Method Area.
    
    I membri di istanza appartengono a **ogni oggetto** e vivono nell’**Heap**.

---

<a id="152-caricamento-delle-classi-con-ereditarietà"></a>
## 15.2 Caricamento delle Classi (con Ereditarietà)

Quando un programma Java si avvia, la JVM carica le classi *su richiesta*.

Quando una classe viene referenziata per la prima volta (ad esempio tramite `new` o accedendo a un membro statico), **l’intera catena ereditaria deve essere caricata prima in memoria**.

<a id="1521-ordine-di-caricamento-delle-classi"></a>
### 15.2.1 Ordine di Caricamento delle Classi

Data una gerarchia di classi:

```java
class A { ... }
class B extends A { ... }
class C extends B { ... }
```

Se il codice esegue:

```java
public static void main(String[] args) {
    new C();
}
```

Allora il caricamento delle classi procede in questo ordine rigoroso:

- Carica la classe A  
- Inizializza le variabili statiche di A (default → esplicite)  
- Esegue i blocchi di inizializzazione statica di A (dall’alto verso il basso)  
- Carica la classe B e ripete la stessa logica  
- Carica la classe C e ripete la stessa logica  

<a id="1522-cosa-succede-durante-il-caricamento-di-una-classe"></a>
### 15.2.2 Cosa Succede Durante il Caricamento di una Classe

- **Passo 1: Le variabili statiche vengono allocate** (prima con valori di default).  
- **Passo 2: Vengono eseguite le inizializzazioni statiche esplicite**.  
- **Passo 3: Vengono eseguiti i blocchi di inizializzazione statica** nell’ordine in cui compaiono nel codice.  

!!! note
    Dopo questi passaggi, la classe è completamente pronta e può essere utilizzata (istanziata o referenziata).

---

<a id="153-creazione-degli-oggetti-con-ereditarietà"></a>
## 15.3 Creazione degli Oggetti (con Ereditarietà)

Quando viene usata la parola chiave `new`, **la creazione dell’istanza segue una sequenza rigorosa e prevedibile** che coinvolge tutte le classi genitrici.

<a id="1531-ordine-completo-di-creazione-delle-istanze"></a>
### 15.3.1 Ordine Completo di Creazione delle Istanze

- **1. Viene allocata memoria sull’Heap per il nuovo oggetto** (gli attributi ricevono valori di default).  
- **2. La catena dei costruttori viene eseguita (non ancora i corpi) dal genitore al figlio** — si parte dalla cima della gerarchia e procede verso le subclass.  
- **3. Le variabili di istanza ricevono le inizializzazioni esplicite**.  
- **4. Vengono eseguiti i blocchi di inizializzazione di istanza**.  
- **5. Viene eseguito il corpo del costruttore**: per ogni classe nella catena ereditaria, i passaggi 3–5 (inizializzazione dei campi, blocchi di istanza, corpo del costruttore) si applicano dal genitore al figlio.  

---

<a id="154-esempio-completo-inizializzazione-statica--di-istanza-nellereditarietà"></a>
## 15.4 Esempio Completo: Inizializzazione Statica + di Istanza nell’Ereditarietà

Consideriamo la seguente gerarchia a tre livelli:

```java
class A {
    static int sa = init("A static var");

    static {
        System.out.println("A static block");
    }

    int ia = init("A instance var");

    {
        System.out.println("A instance block");
    }

    A() {
        System.out.println("A constructor");
    }

    static int init(String msg) {
        System.out.println(msg);
        return 0;
    }
}

class B extends A {
    static int sb = init("B static var");

    static {
        System.out.println("B static block");
    }

    int ib = init("B instance var");

    {
        System.out.println("B instance block");
    }

    B() {
        System.out.println("B constructor");
    }
}

class C extends B {
    static int sc = init("C static var");

    static {
        System.out.println("C static block");
    }

    int ic = init("C instance var");

    {
        System.out.println("C instance block");
    }

    C() {
        System.out.println("C constructor");
    }
}

public class Test {
    public static void main(String[] args) {
        new C();
    }
}
```

Output

```bash
A static var
A static block
B static var
B static block
C static var
C static block
A instance var
A instance block
A constructor
B instance var
B instance block
B constructor
C instance var
C instance block
C constructor
```

---

<a id="155-diagramma-di-visualizzazione"></a>
## 15.5 Diagramma di Visualizzazione

```text
            CARICAMENTO DELLE CLASSI (dall’alto verso il basso)

                A  --->  B  --->  C
                |         |         |
      variabili statiche + blocchi statici eseguiti in ordine

-------------------------------------------------------

            CREAZIONE DELL’OGGETTO (dal genitore al figlio)

 new C() 
    |
    +--> allocazione memoria per C (valori di default)
    +--> chiamata al costruttore B()
            |
            +--> chiamata al costruttore A()
                    |
                    +--> inizializza variabili di istanza di A
                    +--> esegue blocchi di istanza di A
                    +--> esegue costruttore A
            +--> inizializza variabili di istanza di B
            +--> esegue blocchi di istanza di B
            +--> esegue costruttore B
    +--> inizializza variabili di istanza di C
    +--> esegue blocchi di istanza di C
    +--> esegue costruttore C
```

---

<a id="156-regole-chiave"></a>
## 15.6 Regole Chiave

- L’inizializzazione statica avviene **una sola volta** per classe.  
- Gli inizializzatori statici vengono eseguiti in ordine genitore → figlio.  
- L’inizializzazione di istanza avviene ogni volta che viene creato un oggetto.  
- Per ogni classe nella catena ereditaria, i campi di istanza e i blocchi di istanza vengono eseguiti prima del corpo del costruttore di quella classe.  
- Nel complesso, sia l’inizializzazione dei campi/blocchi di istanza sia i costruttori vengono eseguiti dal genitore al figlio.  
- I costruttori chiamano sempre il costruttore del genitore (esplicitamente o implicitamente).  

---

<a id="157-tabella-riassuntiva"></a>
## 15.7 Tabella Riassuntiva

| STATIC (Livello Classe) | INSTANCE (Livello Oggetto) |
|--------------------------|-----------------------------|
| Una sola volta | Avviene a ogni `new` |
| Eseguito genitore → figlio | Inizializzazione di istanza e costruttori genitore → figlio |
| variabili statiche (default → esplicite) | variabili di istanza (default → esplicite) |
| blocchi statici | blocchi di istanza + costruttore |
