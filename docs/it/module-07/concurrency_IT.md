# 31. Java Concurrency APIs

### Indice

- [31. Java Concurrency APIs](#31-java-concurrency-apis)
  - [31.1 Obiettivi e Ambito della Concurrency API](#311-obiettivi-e-ambito-della-concurrency-api)
  - [31.2 Problemi Fondamentali del Threading](#312-problemi-fondamentali-del-threading)
    - [31.2.1 Race Conditions](#3121-race-conditions)
    - [31.2.2 Deadlock](#3122-deadlock)
    - [31.2.3 Starvation](#3123-starvation)
    - [31.2.4 Livelock](#3124-livelock)
  - [31.3 Dai Thread ai Task](#313-dai-thread-ai-task)
  - [31.4 Executor Framework](#314-executor-framework)
    - [31.4.1 Submitting Task e Futures](#3141-submitting-task-e-futures)
    - [31.4.2 Callable vs Runnable](#3142-callable-vs-runnable)
  - [31.5 Thread Pools e Scheduling](#315-thread-pools-e-scheduling)
  - [31.6 Lifecycle e Terminazione dell'Executor](#316-lifecycle-e-terminazione-dellexecutor)
  - [31.7 Strategie di Thread Safety](#317-strategie-di-thread-safety)
    - [31.7.1 Sincronizzazione](#3171-sincronizzazione)
    - [31.7.2 Variabili Atomiche](#3172-variabili-atomiche)
      - [31.7.2.1 Atomic classes](#31721-atomic-classes)
      - [31.7.2.2 Metodi Atomici](#31722-metodi-atomici)
    - [31.7.3 Lock Framework](#3173-lock-framework)
      - [31.7.3.1 Lock implementations](#31731-lock-implementations)
      - [31.7.3.2 Common Lock methods](#31732-common-lock-methods)
    - [31.7.4 Coordination Utilities](#3174-coordination-utilities)
  - [31.8 Concurrent Collections](#318-concurrent-collections)
  - [31.9 Parallel Streams](#319-parallel-streams)
  - [31.10 Relazione con Virtual Threads](#3110-relazione-con-virtual-threads)
  - [31.11 Sommario](#3111-sommario)

Questo capitolo introduce la **Java Concurrency API**, che fornisce astrazioni di alto livello per gestire la concorrenza in modo sicuro, efficiente e scalabile.

A differenza della manipolazione di basso livello dei thread presentata nel capitolo precedente, la Concurrency API si concentra su **task**, **executor** e **meccanismi di coordination**, permettendo ai programmatori di ragionare su cosa debba essere fatto piuttosto che su come i thread vengano schedulati.

## 31.1 Obiettivi e Ambito della Concurrency API

La `Java Concurrency API`, principalmente collocata nel package `java.util.concurrent`, è stata introdotta per affrontare problemi fondamentali inerenti alla gestione manuale dei thread.

- Separare la sottomissione dei task dalla gestione dei thread.
- Ridurre la `synchronization` di basso livello soggetta a errori.
- Migliorare scalabilità e performance su sistemi multi-core.
- Fornire meccanismi strutturati per `coordination`, `cancellation` e `shutdown`.

L'API non elimina i problemi di concorrenza ma fornisce strumenti per gestirli in modo sicuro e prevedibile.

Invece di creare e controllare esplicitamente i thread, i programmatori eseguono task e lasciano che il framework gestisca **thread allocation, riuso, e synchronization**.

```java
ExecutorService executor = Executors.newSingleThreadExecutor();
executor.execute(() -> System.out.println("Task executed"));
executor.shutdown();
```

---

## 31.2 Problemi Fondamentali del Threading

Prima di comprendere la `Concurrency API`, è essenziale comprendere le problematiche di concorrenza che essa vuole mitigare.

Questi problemi sorgono da `shared mutable state`, `scheduling unpredictability` e `improper coordination`.

### 31.2.1 Race Conditions

Una **race condition** si verifica quando più thread accedono a `shared mutable state` (uno stato mutabile e condiviso) e la correttezza del programma dipende dal timing o dall’intercalare della loro esecuzione.

- Causata da accesso non sincronizzato a dati condivisi.
- Porta a stato del programma inconsistente o incorretto.

```java
class Counter {
    int count = 0;
    void increment() {
	   count++;
    }
}
```

Se più thread invocano `increment()` in modo concorrente, alcuni incrementi possono andare persi perché l’operazione non è atomica.

### 31.2.2 Deadlock

Un **deadlock** si verifica quando due o più thread sono bloccati in modo permanente, ciascuno in attesa di una risorsa detenuta da un altro thread.

- Tipicamente causato da dipendenze circolari tra lock.
- Nessun thread coinvolto può fare progressi.

```java
synchronized (lockA) {
    synchronized (lockB) {
    }
}
```

Se un altro thread acquisisce prima `lockB` e poi attende `lockA`, può verificarsi un deadlock.

> [!NOTE]
> I deadlock nel mondo reale coinvolgono tipicamente lock multipli e inversioni d’ordine.

### 31.2.3 Starvation

La **starvation** si verifica quando a un thread viene negato indefinitamente l’accesso alle risorse, anche se tali risorse sono disponibili.

- Spesso causata da `unfair locking` o policy di scheduling.
- Il thread rimane `runnable` ma non viene mai eseguito.

```java
ReentrantLock lock = new ReentrantLock(false); // unfair lock
```

Alcuni thread possono acquisire ripetutamente il lock mentre altri attendono indefinitamente.

### 31.2.4 Livelock

In un **livelock**, i thread non sono bloccati ma reagiscono continuamente l’uno all’altro in un modo che ne impedisce il progresso.

- I thread rimangono attivi ma inefficaci.
- Spesso causato da logica di retry o avoidance aggressiva.

```java
while (!tryLock()) {
    Thread.sleep(10);
}
```

Entrambi i thread possono ripetere continuamente il retry, impedendo il forward progress.

---

## 31.3 Dai Thread ai Task

La Concurrency API sposta il modello di programmazione dalla gestione diretta dei **thread** alla sottomissione di **task**.

Un **task** rappresenta un’unità logica di lavoro indipendente dal thread che lo esegue.

- **Runnable**: Rappresenta un task che non restituisce un risultato.
- **Callable**: Rappresenta un task che restituisce un risultato e può lanciare checked exceptions.

```java
Runnable task = () -> System.out.println("Runnable task");
Callable<Integer> callable = () -> 42;
```

Questa astrazione permette ai task di essere riusati, schedulati in modo flessibile ed eseguiti tramite strategie di esecuzione differenti.

---

## 31.4 Executor Framework

L’**Executor Framework** è il cuore della Concurrency API.

Gestisce la creazione dei thread, il riuso ed l'esecuzione dei task attraverso una interfaccia semplice.

- **Executor**: Interfaccia di base per eseguire task.
- **ExecutorService**: Estende Executor con controllo del lifecycle e gestione dei risultati.
- **ScheduledExecutorService**: Supporta esecuzione di task delayed e periodici.

```java
ExecutorService executor = Executors.newFixedThreadPool(2);
executor.execute(() -> System.out.println("Task 1"));
executor.execute(() -> System.out.println("Task 2"));
executor.shutdown();
```

### 31.4.1 Submitting Task e Futures

I task sottomessi tramite `execute()` restituiscono `void`: è un metodo "fire-and-forget" che non restituisce alcuna informazione sul risultato del task.

I task sottomessi usando `submit()` restituiscono un **Future**, che rappresenta il risultato di una computazione asincrona.

Entrambi i metodi sono usati per sottomettere lavoro per esecuzione asincrona.

```java
Future<Integer> future = executor.submit(() -> 10 + 20);
Integer result = future.get();
```

| Method | Description |
| --- | --- |
| void **execute(Runnable task)** | Esegue un task in modo asincrono senza valore di ritorno e senza `Future`. |
| Future<?> **submit(Runnable task)** | Esegue un task in modo asincrono; non viene prodotto alcun risultato (`Future.get()` restituisce `null`). |
| <T> Future<T> **submit(Callable<T> task)** | Esegue un task in modo asincrono e restituisce un risultato di tipo `T`. |
| <T> List<Future<T>> **invokeAll(Collection<? extends Callable<T>> tasks)** | Esegue tutti i task e restituisce un `Future` per ciascuno, dopo che tutti completano. |
| <T> T **invokeAny(Collection<? extends Callable<T>> tasks)** | Esegue i task e restituisce il risultato di uno che completa con successo; gli altri vengono cancellati. |

| Method | Description |
| --- | --- |
| boolean **isDone()** | Restituisce `true` se il task è completato (normalmente, eccezionalmente, o via cancellazione). |
| boolean **isCancelled()** | Restituisce `true` se il task è stato cancellato prima del completamento normale. |
| boolean **cancel(boolean mayInterruptIfRunning)** | Tenta di cancellare l’esecuzione. Se `true`, interrompe il thread in esecuzione se possibile. |
| T **get()** | Blocca fino al completamento e restituisce il risultato, o lancia un’eccezione se fallito o cancellato. |
| T **get(long timeout, TimeUnit unit)** | Blocca fino al timeout dato e restituisce il risultato, o lancia `TimeoutException` se non completato. |

> [!WARNING]
> `execute()` scarterà le eccezioni silenziosamente a meno che non vengano gestite all’interno del task.

### 31.4.2 Callable vs Runnable

Entrambe le interfacce rappresentano task, ma con capacità differenti.

- `Runnable`: Nessun valore di ritorno, non può lanciare checked exceptions.
- `Callable`: Restituisce un valore e supporta checked exceptions.

```java
Callable<String> c = () -> "done";
Runnable r = () -> System.out.println("done");
```

Per computazione asincrona orientata al risultato, `Callable` è generalmente preferito.

## 31.5 Thread Pools e Scheduling

Gli executor gestiscono thread pools che riutilizzano un numero fisso o dinamico di thread per eseguire i task in modo efficiente.

- **Fixed thread pool**: Limita la concorrenza a un numero fisso di thread.
- **Cached thread pool**: Cresce e si riduce dinamicamente in base alla domanda: crea nuovi thread quando necessario ma riusa thread disponibili.
- **Single-thread executor**: Garantisce esecuzione sequenziale dei task.
- **Scheduled executor**: Supporta task delayed e periodici.

| Metodo Factory | Tipo di Ritorno | Descrizione |
| --- | --- | --- |
| `Executors.newFixedThreadPool(int nThreads)` | ExecutorService | Crea un thread pool con un numero fisso di thread. |
| `Executors.newFixedThreadPool(int nThreads, ThreadFactory threadFactory)` | ExecutorService | Come newFixedThreadPool ma con un ThreadFactory personalizzato. |
| `Executors.newSingleThreadExecutor()` | ExecutorService | Crea un thread pool a singolo thread che esegue i task in modo sequenziale. |
| `Executors.newSingleThreadExecutor(ThreadFactory threadFactory)` | ExecutorService | Executor a singolo thread con un ThreadFactory personalizzato. |
| `Executors.newCachedThreadPool()` | ExecutorService | Crea un thread pool che crea nuovi thread quando necessario e riutilizza quelli inattivi. |
| `Executors.newCachedThreadPool(ThreadFactory threadFactory)` | ExecutorService | Thread pool cached con un ThreadFactory personalizzato. |
| `Executors.newSingleThreadScheduledExecutor()` | ScheduledExecutorService | Crea un scheduled executor a singolo thread. |
| `Executors.newSingleThreadScheduledExecutor(ThreadFactory threadFactory)` | ScheduledExecutorService | Scheduled executor a singolo thread con ThreadFactory personalizzato. |
| `Executors.newScheduledThreadPool(int corePoolSize)` | ScheduledExecutorService | Crea un scheduled thread pool con la dimensione core specificata. |
| `Executors.newScheduledThreadPool(int corePoolSize, ThreadFactory threadFactory)` | ScheduledExecutorService | Scheduled thread pool con ThreadFactory personalizzato. |
| `Executors.newWorkStealingPool()` | ExecutorService | Crea un work-stealing pool usando il numero di processori disponibili come livello di parallelismo. |
| `Executors.newWorkStealingPool(int parallelism)` | ExecutorService | Crea un work-stealing pool con il livello di parallelismo specificato. |
| `Executors.newThreadPerTaskExecutor(ThreadFactory threadFactory)` | ExecutorService | Crea un executor che avvia un nuovo thread per ogni task. |
| `Executors.newVirtualThreadPerTaskExecutor()` | ExecutorService | Crea un executor che avvia un nuovo virtual thread per ogni task. |


`Task scheduling`: i task sottomessi a un executor vengono messi in coda e prelevati dai thread del pool; l’ordine di esecuzione dipende dall’implementazione dell’executor, dalla politica della coda e dalla disponibilità dei thread. 
Nei scheduled executor, i task sono ordinati in base al delay di attivazione; i task periodici vengono reinseriti in coda dopo ogni esecuzione.

```java
ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

scheduler.schedule(
	() -> System.out.println("Delayed"),
	2, TimeUnit.SECONDS);
```

| Metodo | Descrizione|
| --- | --- |
| ScheduledFuture<?> schedule(Runnable command, long delay, TimeUnit unit) | Pianifica un’azione one-shot che diventa eseguibile dopo il delay specificato. |
| <V> ScheduledFuture<V> schedule(Callable<V> callable, long delay, TimeUnit unit) | Pianifica un task one-shot che restituisce un valore dopo il delay specificato. |
| ScheduledFuture<?> scheduleAtFixedRate(Runnable command, long initialDelay, long period, TimeUnit unit) | Pianifica un’esecuzione periodica a fixed rate: ogni esecuzione è pianificata rispetto al tempo iniziale; se un’esecuzione è in ritardo, le successive possono tentare di “recuperare”. |
| ScheduledFuture<?> scheduleWithFixedDelay(Runnable command, long initialDelay, long delay, TimeUnit unit) | Pianifica un’esecuzione periodica con fixed delay: ogni esecuzione è pianificata rispetto al completamento della precedente; non esiste comportamento di recupero. |

> [!IMPORTANT]
> Non creare mai thread manualmente in un loop:
> usa invece pools o virtual threads.

---

## 31.6 Lifecycle e Terminazione dell'Executor

Gli executor devono essere chiusi esplicitamente per rilasciare risorse e permettere la terminazione della JVM.

- **shutdown()**: Inizia shutdown ordinato: completa i task in attesa ma non accetta ulteriori task.
- **close()**: (Java 19+) chiama shutdown() e attende che i task finiscano, comportandosi come supporto try-with-resources per ExecutorService.
- **shutdownNow()**: Tenta shutdown immediato e interrompe i task in esecuzione.
- **awaitTermination()**: Attende completamento o timeout.

```java
executor.shutdown();
executor.awaitTermination(5, TimeUnit.SECONDS);
```

---

## 31.7 Strategie di Thread Safety

La Concurrency API fornisce molteplici strategie complementari per ottenere thread safety.

### 31.7.1 Sincronizzazione

La sincronizzazione impone `mutual exclusion` e `memory visibility` usando un lock intrinseco (monitor) associato a un oggetto o a una classe.

```java
synchronized void increment() {
    count++;
}
```

Quando un thread entra in un metodo synchronized:

- Acquisisce l’intrinsic lock dell’oggetto target (`this` per i metodi di istanza).
- Solo un thread alla volta può detenere lo stesso lock, prevenendo esecuzione concorrente.
- Quando il metodo termina, il lock viene rilasciato automaticamente.

La synchronization stabilisce una **happens-before relationship** nel Java Memory Model:

- Tutte le scritture fatte dentro la regione synchronized vengono flushate nella memoria principale quando il lock viene rilasciato.
- Un thread che acquisisce lo stesso lock in seguito è garantito vedere quegli update.

La keyword synchronized può essere applicata a:

- **Metodi di istanza** (lock su `this`)
- **Metodi statici** (lock sull’oggetto `Class`)
- **Blocchi** (lock su un oggetto specifico, permettendo controllo più fine)

> [!IMPORTANT]
> La sincronizzazione è semplice ma può ridurre la scalabilità sotto contention.

---

### 31.7.2 Variabili Atomiche

Le `atomic classes` forniscono operazioni lock-free, thread-safe implementate usando primitive CPU di basso livello come Compare-And-Swap (CAS).

```java
AtomicInteger count = new AtomicInteger();
count.incrementAndGet();
```

### 31.7.2.1 Atomic classes

| Atomic Class | Description |
| --- | --- |
| **AtomicBoolean** | Aggiorna e legge atomicamente un valore `boolean`. |
| **AtomicInteger** | Aggiorna e legge atomicamente un valore `int`. |
| **AtomicLong** | Aggiorna e legge atomicamente un valore `long`. |
| **AtomicReference<T>** | Aggiorna e legge atomicamente un reference a oggetto. |
| **AtomicIntegerArray** | Fornisce operazioni atomiche sugli elementi di un array `int`. |
| **AtomicLongArray** | Fornisce operazioni atomiche sugli elementi di un array `long`. |
| **AtomicReferenceArray<T>** | Fornisce operazioni atomiche sugli elementi di un array di reference. |
| **AtomicStampedReference<T>** | Aggiorna atomicamente un reference con un integer stamp per evitare problemi ABA. |
| **AtomicMarkableReference<T>** | Aggiorna atomicamente un reference con un boolean mark. |

### 31.7.2.2 Metodi Atomici

| Method | Description |
| --- | --- |
| **get()** | Restituisce il valore corrente con semantica volatile-read. |
| **set(value)** | Imposta il valore con semantica volatile-write. |
| **lazySet(value)** | Imposta eventualmente il valore con garanzie di ordering più deboli. |
| **compareAndSet(expect, update)** | Imposta atomicamente il valore se il valore corrente è uguale al valore atteso. |
| **getAndSet(value)** | Imposta atomicamente il valore e restituisce il valore precedente. |
| **incrementAndGet()** | Incrementa atomicamente il valore e restituisce il risultato aggiornato. |
| **getAndIncrement()** | Incrementa atomicamente il valore e restituisce il risultato precedente. |
| **decrementAndGet()** | Decrementa atomicamente il valore e restituisce il risultato aggiornato. |
| **getAndDecrement()** | Decrementa atomicamente il valore e restituisce il risultato precedente. |
| **addAndGet(delta)** | Aggiunge atomicamente il delta dato e restituisce il risultato aggiornato. |
| **getAndAdd(delta)** | Aggiunge atomicamente il delta dato e restituisce il risultato precedente. |

<ins>Variabili Atomiche</ins>:

- Eseguono singole operazioni **atomicamente**
- Forniscono **memory visibility guarantees** simili a `volatile`
- Evitano thread blocking, rendendole altamente scalabili sotto contention

Tuttavia, le atomic variables garantiscono atomicità solo per **operazioni individuali**.

Comporre più operazioni richiede comunque synchronization esterna.

<ins>Le variabili atomiche sono tipicamente usate per</ins>:

- Counter e sequence generator
- Flag e state indicator
- Update ad alto throughput e bassa latenza

---

### 31.7.3 Lock Framework

Il package `java.util.concurrent.locks` fornisce meccanismi di locking espliciti che offrono maggiore flessibilità e controllo rispetto a synchronized.

```java
ReentrantLock lock = new ReentrantLock();
lock.lock();
try {
    // critical section
} finally {
    lock.unlock();
}
```

Caratteristiche chiave del Lock framework:

- I lock devono essere acquisiti e rilasciati esplicitamente
- L’acquisizione del lock può essere interruptible o time-bounded
- I lock possono essere configurati con fairness policy (parametro) quando l’ordering è richiesto (quando devi controllare l’ordine in cui i thread girano)
- Più oggetti Condition possono essere associati a un singolo lock

### 31.7.3.1 Lock implementations

| Lock Implementation | Description |
| --- | --- |
| **Lock** | Interfaccia core che definisce operazioni di lock esplicite. |
| **ReentrantLock** | Lock reentrant di mutual exclusion con fairness policy opzionale. |
| **ReadWriteLock** | Interfaccia che definisce lock separati di read e write. |
| **ReentrantReadWriteLock** | Fornisce lock separati reentrant di read e write per migliorare la scalabilità in lettura. |
| **StampedLock** | Lock che supporta modalità optimistic, read e write locking (non-reentrant). |

> [!WARNING]
> A differenza di altri lock, StampedLock **non è reentrant** —
> riacquisirlo dallo stesso thread causa deadlock.

### 31.7.3.2 Common Lock methods

| Method | Description |
| --- | --- |
| **lock()** | Acquisisce il lock, bloccando indefinitamente finché disponibile. |
| **unlock()** | Rilascia il lock; deve essere chiamato dal thread proprietario. |
| **tryLock()** | Tenta di acquisire il lock immediatamente senza bloccare: restituisce boolean che indica se il lock è stato acquisito con successo |
| **tryLock(long, TimeUnit)** | Tenta di acquisire il lock entro il timeout dato. |
| **lockInterruptibly()** | Acquisisce il lock a meno che il thread sia interrotto. |
| **newCondition()** | Crea un’istanza `Condition` per coordination fine-grained tra thread. |

A differenza di synchronized, i lock non vengono rilasciati automaticamente, rendendo essenziale l’uso corretto di try/finally per evitare deadlock.

### 31.7.4 Coordination Utilities

Le coordination utilities permettono ai thread di coordinare fasi di esecuzione senza proteggere dati condivisi tramite mutual exclusion.

Altre coordination primitives includono:
- `CountDownLatch`
- `Semaphore`
- `Phaser`

```java
import java.util.concurrent.CyclicBarrier;

public class BarrierExample {

    private static final int THREAD_COUNT = 3;

    public static void main(String[] args) {

        CyclicBarrier barrier = new CyclicBarrier(
            THREAD_COUNT,
            () -> System.out.println("All threads reached the barrier. Proceeding...")
        );

        Runnable task = () -> {
            String name = Thread.currentThread().getName();
            try {
                System.out.println(name + " performing initial work");
                Thread.sleep((long) (Math.random() * 2000));

                // Wait for other threads
                System.out.println(name + " waiting at barrier");
                barrier.await();

                // Executed only after all threads reach the barrier
                System.out.println(name + " performing next phase");

            } catch (Exception e) {
                e.printStackTrace();
            }
        };

        for (int i = 1; i <= THREAD_COUNT; i++) {
            new Thread(task, "Worker-" + i).start();
        }
    }
}
```

Sample Output:

```bash
Worker-1 performing initial work
Worker-2 performing initial work
Worker-3 performing initial work
Worker-3 waiting at barrier
Worker-1 waiting at barrier
Worker-2 waiting at barrier
All threads reached the barrier. Proceeding...
Worker-3 performing next phase
Worker-1 performing next phase
Worker-2 performing next phase
```

Un `CyclicBarrier`:

- Blocca i thread finché un numero predefinito di thread raggiunge la barrier
- Rilascia simultaneamente tutti i thread in attesa una volta che la barrier viene tripped
- Può essere riusato per più cicli di coordination

Queste utilities si concentrano su execution ordering e synchronization, non su data protection.

---

## 31.8 Concurrent Collections

Le concurrent collections sono **thread-safe data structures** progettate per supportare **alti livelli di concorrenza** senza richiedere sincronizzazione esterna.

A differenza dei synchronized wrappers (es. `Collections.synchronizedMap`), le concurrent collections:
- Usano **fine-grained locking** o **lock-free techniques**
- Permettono a più thread di accedere e modificare la collection simultaneamente
- Scalano meglio sotto contention

Esempi comuni includono:

- **ConcurrentHashMap**
- Una concurrent map ad alte performance che permette letture e update concorrenti partizionando lo stato interno e minimizzando lock contention.

- **CopyOnWriteArrayList**
- Una thread-safe list ottimizzata per scenari con **molte letture e poche scritture**. Le operazioni di write creano un nuovo array interno, permettendo alle letture di procedere senza locking.

- **BlockingQueue**
- Una queue progettata per **producer-consumer patterns**, dove i thread possono bloccare mentre attendono elementi o capacità disponibile.

```java
BlockingQueue<String> queue = new LinkedBlockingQueue<>();
queue.put("item");   // blocks if the queue is full
queue.take();        // blocks if the queue is empty
```

Le blocking queue gestiscono la synchronization internamente, semplificando la coordination tra thread producer e consumer.

> [!CAUTION]
> Le CopyOnWrite collections sono memory-expensive; evitarle in workload write-heavy.

---

## 31.9 Parallel Streams

I `parallel streams` forniscono **declarative data parallelism**, permettendo che le operazioni dello stream vengano eseguite in modo concorrente su più thread con cambiamenti minimi di codice.

Caratteristiche chiave:
- Attivati tramite `parallelStream()` o `stream().parallel()`
- Eseguiti internamente usando il **common ForkJoinPool**
- Dividono automaticamente i dati in chunk processati in parallelo

I parallel streams funzionano meglio quando:
- Le operazioni sono **CPU-bound**
- Le funzioni sono **stateless e non-blocking**
- La sorgente dati è abbastanza grande da ammortizzare l’overhead della parallelizzazione

```java
list.parallelStream()
    .map(x -> x * x)
    .forEach(System.out::println);
```

Poiché l’ordine di esecuzione non è garantito, i parallel streams dovrebbero evitare:
- Shared mutable state
- Blocking I/O
- Order-dependent side effects

> [!NOTE]
> Usa `forEachOrdered()` se è richiesto output deterministico.

---

## 31.10 Relazione con Virtual Threads

In Java 21, l’`Executor framework` integra in modo seamless con **virtual threads**, abilitando massive concurrency con uso minimo di risorse.

```java
ExecutorService executor =
Executors.newVirtualThreadPerTaskExecutor();

executor.submit(() -> blockingIO());
executor.close();
```

Questo permette al codice blocking di scalare efficientemente senza ridisegnare le API.

---

## 31.11 Summary

- La `Java Concurrency API` fornisce un’alternativa robusta, scalabile e più sicura alla gestione manuale dei thread.
- Astrarre l’esecuzione, coordinare i task e offrire utilities thread-safe permette agli sviluppatori di costruire sistemi concorrenti sia performanti sia manutenibili.
- Scegli lo strumento giusto: synchronized → locks → atomics → executors → virtual threads.


