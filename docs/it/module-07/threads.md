# 30. Thread Java – Fondamenti e Modello di Esecuzione

<a id="indice"></a>
### Indice


- [30.1 Thread, Processi e il Sistema Operativo](#301-thread-processi-e-il-sistema-operativo)
- [30.2 Modello di Memoria Stack e Heap](#302-modello-di-memoria-stack-e-heap)
- [30.3 Contesto e Context Switching](#303-contesto-e-context-switching)
- [30.4 Concorrenza vs Parallelismo](#304-concorrenza-vs-parallelismo)
- [30.5 Thread in Java Modello Concettuale](#305-thread-in-java-modello-concettuale)
- [30.6 Categorie di Thread in Java 21](#306-categorie-di-thread-in-java-21)
- [30.7 Creare Thread in Java](#307-creare-thread-in-java)
- [30.8 Ciclo di Vita ed Esecuzione di un Thread](#308-ciclo-di-vita-ed-esecuzione-di-un-thread)
- [30.9 Avviare vs Eseguire un Thread Sincrono-o-Asincrono](#309-avviare-vs-eseguire-un-thread-sincrono-o-asincrono)
- [30.10 Priorità dei Thread e Scheduling](#3010-priorità-dei-thread-e-scheduling)
- [30.11 Differimento e Yield dei Thread](#3011-differimento-e-yield-dei-thread)
- [30.12 Interruzione dei Thread e Cancellazione Cooperativa](#3012-interruzione-dei-thread-e-cancellazione-cooperativa)
	- [30.12.1 Cosa Significa Interrompere un Thread](#30121-cosa-significa-interrompere-un-thread)
	- [30.12.2 Interrompere Operazioni Bloccanti](#30122-interrompere-operazioni-bloccanti)
	- [30.12.3 Controllare lo Stato di Interruzione](#30123-controllare-lo-stato-di-interruzione)
	- [30.12.4 Esempio Interrompere un Thread in Sleep](#30124-esempio-interrompere-un-thread-in-sleep)
	- [30.12.5 Osservazioni Chiave](#30125-osservazioni-chiave)
- [30.13 Thread e il Thread Principale](#3013-thread-e-il-thread-principale)
- [30.14 Concorrenza dei Thread e Stato Condiviso](#3014-concorrenza-dei-thread-e-stato-condiviso)
- [30.15 Sommario](#3015-sommario)


---

Questo capitolo introduce i **thread** a partire dai principi di base e spiega come sono modellati e utilizzati in Java 21.

Questo testo stabilisce inoltre le fondamenta concettuali necessarie per comprendere `concurrency`, `synchronization` e la `Java Concurrency API` trattata nel prossimo capitolo.

<a id="301-thread-processi-e-il-sistema-operativo"></a>
## 30.1 Thread, Processi e il Sistema Operativo

Per comprendere i thread, dobbiamo partire dal modello di esecuzione del sistema operativo. 

I moderni sistemi operativi eseguono programmi utilizzando **processi** e **thread**.

- **Processo**: Un’istanza di programma in esecuzione gestita dal sistema operativo. Un processo possiede il proprio spazio di memoria virtuale, risorse di sistema (file, socket) e almeno un thread.
- **Thread**: Un’unità di esecuzione leggera all’interno di un processo. I thread condividono memoria e risorse del processo ma eseguono in modo indipendente.
- **Task**: Un’unità logica di lavoro da eseguire. Un task può essere eseguito da un thread ma non è esso stesso un thread.
- **Core CPU**: Un’unità di esecuzione fisica o logica capace di eseguire un thread alla volta. Più core permettono vera esecuzione parallela.

Un singolo processo può contenere molti thread, tutti operanti nello stesso ambiente condiviso. Questo ambiente condiviso è sia fonte delle potenzialità della Concurrency sia dei suoi rischi.

---

<a id="302-modello-di-memoria-stack-e-heap"></a>
## 30.2 Modello di Memoria: Stack e Heap

I thread interagiscono con la memoria in due modi fondamentalmente diversi.

- **Stack del Thread**: Area di memoria privata per ogni thread. Memorizza frame delle chiamate di metodo, variabili locali e stato di esecuzione. Ogni thread ha esattamente uno stack.
- **Heap**: Area di memoria condivisa usata per oggetti e istanze di classe. Tutti i thread nello stesso processo possono accedere all’heap.

Poiché gli `stack sono isolati` e l’`heap è condiviso`, i problemi di concorrenza sorgono quando più thread accedono agli stessi oggetti nell’heap senza adeguata coordinazione.

---

<a id="303-contesto-e-context-switching"></a>
## 30.3 Contesto e Context Switching

Il sistema operativo pianifica l'esecuzione dei thread sui core della CPU.

Poiché il numero di thread eseguibili spesso supera il numero di core disponibili, il sistema operativo esegue il **context switching**.

- **Contesto**: Lo stato completo di esecuzione di un thread, inclusi registri, contatore di programma e puntatore allo stack.
- **Context Switch**: L’atto di sospendere un thread e riprenderne un altro salvando e ripristinando i rispettivi contesti.

Il `context switching` abilita la concorrenza ma ha un costo: cicli CPU vengono consumati senza eseguire logica applicativa.

I programmatori Java devono progettare sistemi che bilancino concorrenza ed efficienza.

---

<a id="304-concorrenza-vs-parallelismo"></a>
## 30.4 Concorrenza vs Parallelismo

Questi due termini sono spesso confusi ma descrivono concetti differenti.

- **Concorrenza**: Più thread sono in esecuzione nello stesso intervallo di tempo, possibilmente interlacciati su un singolo core CPU.
- **Parallelismo**: Più thread vengono eseguiti simultaneamente su core CPU differenti.

Java supporta la concorrenza indipendentemente dal parallelismo hardware.

Anche su un sistema single-core, i thread Java possono essere concorrenti tramite time slicing.

---

<a id="305-thread-in-java-modello-concettuale"></a>
## 30.5 Thread in Java: Modello Concettuale

In Java, un **thread** rappresenta un percorso indipendente di esecuzione all’interno di un singolo processo JVM. Tutti i thread Java operano nello stesso heap e nello stesso contesto di `class loading`, a meno che non siano esplicitamente isolati tramite meccanismi avanzati.

- **Thread Java**: Un oggetto di tipo `java.lang.Thread` che mappa a un’unità di esecuzione sottostante.
- **Runnable**: Un’interfaccia funzionale che rappresenta un `task` il cui metodo `run()` contiene la logica eseguibile.

Un thread esegue codice invocando il proprio metodo `run()`, direttamente o indirettamente tramite lo scheduler dei thread della JVM: vedere [Avviare vs Eseguire un Thread](#309-avviare-vs-eseguire-un-thread-sincrono-o-asincrono)

---

<a id="306-categorie-di-thread-in-java-21"></a>
## 30.6 Categorie di Thread in Java 21

Java 21 definisce diversi tipi di thread, che differiscono per ciclo di vita, scheduling e uso previsto.

- **Platform Thread**: Un thread Java tradizionale mappato uno-a-uno con un thread del sistema operativo.
- **Virtual Thread**: Un thread leggero gestito dalla JVM e schedulato su thread carrier. Introdotto per abilitare massiva concorrenza con overhead minimo.
- **Carrier Thread**: Un Platform Thread usato internamente dalla JVM per eseguire thread virtuali.
- **Daemon Thread**: Un thread in background che non impedisce la terminazione della JVM. Quando restano in esecuzione solo thread daemon, la JVM termina.
- **Thread Utente**: Qualsiasi thread non-daemon. La JVM attende che tutti i thread utente completino prima di terminare.
- **Thread di Sistema**: Thread creati internamente dalla JVM per garbage collection, compilazione JIT e altri servizi runtime.

!!! note
    I `thread virtuali` sono thread utente leggeri; **non** sono daemon per default.

---

<a id="307-creare-thread-in-java"></a>
## 30.7 Creare Thread in Java

I thread possono essere creati in diversi modi, tutti concettualmente centrati nel fornire logica eseguibile.

- Estendendo `Thread` e sovrascrivendo `run()`.
- Passando un `Runnable` al costruttore di `Thread`.
- Usando factory di thread ed executor (trattati nella sezione Concurrency API).

```java
Runnable runnable = ...

  // Crea un thread di piattaforma tramite costruttore
  Thread thread = new Thread(runnable);
  thread.start();

  // Avvia un thread daemon per eseguire un task
  Thread thread = Thread.ofPlatform().daemon().start(runnable);

  // Crea un thread non avviato con nome "duke", il suo metodo start()
  // deve essere invocato per pianificarne l'esecuzione.
  Thread thread = Thread.ofPlatform().name("duke").unstarted(runnable);

  // Una ThreadFactory che crea thread daemon chiamati "worker-0", "worker-1", ...
  ThreadFactory factory = Thread.ofPlatform().daemon().name("worker-", 0).factory();

  // Avvia un thread virtuale per eseguire un task
  Thread thread = Thread.ofVirtual().start(runnable);

  // Una ThreadFactory che crea thread virtuali
  ThreadFactory factory = Thread.ofVirtual().factory();
```

!!! warning
    - La sola creazione di un thread non ne avvia l’esecuzione.
    - L’esecuzione inizia solo quando lo scheduler della JVM è coinvolto.

---

<a id="308-ciclo-di-vita-ed-esecuzione-di-un-thread"></a>
## 30.8 Ciclo di Vita ed Esecuzione di un Thread

Un thread Java attraversa stati ben definiti durante il suo ciclo di vita.

- **New**: Oggetto thread creato ma non ancora avviato.
- **Runnable**: Idoneo all’esecuzione da parte dello scheduler.
- **Running**: In esecuzione attiva su un core CPU.
- **Blocked / Waiting**: Temporaneamente incapace di proseguire a causa di sincronizzazione o coordinazione.
- **Terminated**: Esecuzione completata o interrotta.

La JVM e il sistema operativo cooperano per muovere i thread tra questi stati.

I thread in stato `BLOCKED`, `WAITING` o `TIMED_WAITING` **non stanno utilizzando risorse CPU**

---

<a id="309-avviare-vs-eseguire-un-thread-sincrono-o-asincrono"></a>
## 30.9 Avviare vs Eseguire un Thread: Sincrono o Asincrono

Esiste una distinzione concettuale critica tra invocare `run()` e invocare `start()`.

- Chiamare direttamente `run()` esegue il metodo in modo sincrono nel thread corrente, come una normale chiamata di metodo.
- Chiamare `start()` richiede alla JVM di creare un nuovo stack di chiamata ed eseguire `run()` in modo asincrono in un thread separato.

Pertanto, codice come `new Thread(r).run();` NON crea concorrenza. L’esecuzione rimane sincrona e blocca il thread chiamante fino al completamento.

!!! note
    `Esecuzione asincrona` significa che il chiamante continua immediatamente mentre il nuovo thread prosegue in modo indipendente, soggetto allo scheduling.
    
    `Esecuzione sincrona` significa che il chiamante attende che l’operazione sia completata.

!!! important
    La concorrenza inizia **solo** quando viene invocato `start()`.

<a id="3010-priorità-dei-thread-e-scheduling"></a>
## 30.10 Priorità dei Thread e Scheduling

I thread Java hanno una priorità associata che influenza lo scheduling.

- `Priorità del Thread`: Un valore intero che ne indica l’importanza relativa, che va da minimo a massimo.
- `Scheduling`: La JVM delega le decisioni di scheduling al sistema operativo, che può o meno rispettare rigorosamente le priorità.

La priorità del thread influenza la probabilità di scheduling ma non garantisce mai l’ordine di esecuzione. Il codice Java portabile non deve mai fare affidamento sulle priorità per la correttezza.

È possibile impostare la **priorità** sui `thread di piattaforma`; per i `thread virtuali` la **priorità** è sempre impostata a **5** (`Thread.NORM_PRIORITY`) e tentare di modificarla non ha effetto.

---

<a id="3011-differimento-e-yield-dei-thread"></a>
## 30.11 Differimento e Yield dei Thread

I thread possono influenzare volontariamente il comportamento di scheduling.

Chiamare `Thread.yield()` segnala la disponibilità a sospendere l’esecuzione.

- `Yielding`: Un thread suggerisce di essere disposto a sospendere l’esecuzione per permettere ad altri thread eseguibili di proseguire.
- `Sleeping`: Un thread sospende l’esecuzione per una durata fissa, entrando in uno stato di attesa temporizzata.

Questi meccanismi non garantiscono l’esecuzione immediata di altri thread; forniscono solo suggerimenti di scheduling.

---

<a id="3012-interruzione-dei-thread-e-cancellazione-cooperativa"></a>
## 30.12 Interruzione dei Thread e Cancellazione Cooperativa

I thread Java non possono essere fermati forzatamente dall’esterno.

Invece, Java fornisce un meccanismo cooperativo chiamato **interruzione del thread**, che permette a un thread di richiedere che un altro thread interrompa ciò che sta facendo.

Il thread di destinazione decide come e quando rispondere.

<a id="30121-cosa-significa-interrompere-un-thread"></a>
### 30.12.1 Cosa Significa Interrompere un Thread

Interrompere un thread **non** lo termina. Chiamare `interrupt()` imposta un **flag di interruzione** interno sul thread di destinazione. È responsabilità del thread in esecuzione osservare questo flag e reagire in modo appropriato.

- `Richiesta di Interruzione`: Un segnale inviato a un thread che indica che dovrebbe fermarsi o cambiare la propria attività corrente.
- `Flag di Interruzione`: Uno stato booleano associato a ciascun thread, impostato quando viene invocato `interrupt()`.
- `Cancellazione Cooperativa`: Un design pattern in cui i thread controllano periodicamente eventuali interruzioni e terminano in modo pulito.

---

<a id="30122-interrompere-operazioni-bloccanti"></a>
### 30.12.2 Interrompere Operazioni Bloccanti

Alcuni metodi bloccanti in Java rispondono immediatamente all’interruzione lanciando `InterruptedException` e azzerando il flag di interruzione. Questi metodi includono `sleep()`, `wait()` e `join()`.

Quando un thread è bloccato in uno di questi metodi e un altro thread lo interrompe, il thread bloccato viene risvegliato e viene lanciata un’eccezione. Questo fornisce un punto di uscita sicuro dalle operazioni bloccanti.

---

<a id="30123-controllare-lo-stato-di-interruzione"></a>
### 30.12.3 Controllare lo Stato di Interruzione

I thread che non sono bloccati devono controllare esplicitamente se sono stati interrotti. Java fornisce due modi per farlo.

- `Thread.currentThread().isInterrupted()`: Restituisce lo stato di interruzione senza azzerarlo.
- `Thread.interrupted()`: Restituisce lo stato di interruzione e lo azzera. Questo è sottile: la chiamata successiva restituirà false.

Non controllare lo stato di interruzione può far sì che i thread ignorino richieste di cancellazione e continuino a eseguire indefinitamente.

---

<a id="30124-esempio-interrompere-un-thread-in-sleep"></a>
### 30.12.4 Esempio: Interrompere un Thread in Sleep

Il seguente esempio dimostra la cancellazione cooperativa tramite interruzione.

Un thread worker dorme mentre esegue del lavoro. Il thread main lo interrompe, causando uno shutdown pulito.

```java
class Main {

	static class Task implements Runnable {
		public void run() {
			try {
				while (true) {
					System.out.println("Working...");
					Thread.sleep(1000);
				}
			} catch (InterruptedException e) {
				System.out.println("Task interrupted, shutting down");
			}
		}
	}

	public static void main(String[] args) throws InterruptedException {
		Thread worker = new Thread(new Task());
		worker.start();
		System.out.println("main before sleep...");
		Thread.sleep(3000);
		System.out.println("main after sleep...");
		worker.interrupt();
		System.out.println("main reached END");
	}
}
```

Output:

```bash
main before sleep...
Working...
Working...
Working...
main after sleep...
main reached END
Task interrupted, shutting down
```

!!! note
    L’ordine dell’output può variare leggermente a causa dello scheduling.

---

<a id="30125-osservazioni-chiave"></a>
### 30.12.5 Osservazioni Chiave

- Chiamare `interrupt()` non ferma direttamente il thread.
- L’interruzione viene rilevata e `sleep()` lancia una `InterruptedException`.
- Il thread worker termina da solo in modo controllato.
- Una corretta gestione dell’interruzione permette ai thread di rilasciare risorse e mantenere la coerenza del programma.

!!! note
    Ignorare `InterruptedException` senza terminare o ripristinare lo stato di interruzione è considerata cattiva pratica e può portare a thread non reattivi.

---

<a id="3013-thread-e-il-thread-principale"></a>
## 30.13 Thread e il Thread Principale

Ogni applicazione Java inizia con un **thread principale**. Questo thread esegue il metodo `main(String[])`.

- Il thread principale è un thread utente.
- La JVM rimane attiva finché almeno un thread utente è in esecuzione.
- Se il thread principale termina ma esistono altri thread utente, la JVM continua l’esecuzione aspettando che i thread utente terminino.
- I thread daemon non mantengono viva la JVM.

Comprendere il ruolo del thread principale è essenziale per ragionare sulla terminazione del programma e sull’elaborazione in background.

---

<a id="3014-concorrenza-dei-thread-e-stato-condiviso"></a>
## 30.14 Concorrenza dei Thread e Stato Condiviso

La `Concorrenza` nasce quando più thread accedono a stato mutabile condiviso.

- `Stato Condiviso`: Qualsiasi dato locato nello heap accessibile da più di un thread.
- `Race Condition`: Un errore di correttezza causato da accesso non sincronizzato a stato condiviso.
- `Problema di Visibilità`: Un thread opera su dati obsoleti a causa della mancanza di corretta sincronizzazione della memoria.

Java risolve questi problemi con sincronizzazione, volatile, lock, atomiche e framework di alto livello (Executors, futures).

La sincronizzazione, le variabili volatile e le utility di concorrenza di alto livello saranno studiate nelle sezioni successive.

---

<a id="3015-sommario"></a>
## 30.15 Sommario

- I `Thread` sono il mattone fondamentale dell’esecuzione concorrente in Java.
- Esistono all’interno dei processi, condividono memoria e sono schedulati dalla JVM in cooperazione con il sistema operativo.
- Una corretta gestione dei thread evita perdite, deadlock e spreco di CPU.

