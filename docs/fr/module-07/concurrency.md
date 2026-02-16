# 31. Java Concurrency APIs

<a id="indice"></a>
### Indice

- [31. Java Concurrency APIs](#31-java-concurrency-apis)
  - [31.1 Objectifs et Portée de la Concurrency API](#311-objectifs-et-portée-de-la-concurrency-api)
  - [31.2 Problèmes Fondamentaux du Threading](#312-problèmes-fondamentaux-du-threading)
    - [31.2.1 Race Conditions](#3121-race-conditions)
    - [31.2.2 Deadlock](#3122-deadlock)
    - [31.2.3 Starvation](#3123-starvation)
    - [31.2.4 Livelock](#3124-livelock)
  - [31.3 Des Thread aux Task](#313-des-thread-aux-task)
  - [31.4 Executor Framework](#314-executor-framework)
    - [31.4.1 Submitting Task et Futures](#3141-submitting-task-et-futures)
    - [31.4.2 Callable vs Runnable](#3142-callable-vs-runnable)
  - [31.5 Thread Pools et Scheduling](#315-thread-pools-et-scheduling)
  - [31.6 Lifecycle et Terminaison de l'Executor](#316-lifecycle-et-terminaison-de-lexecutor)
  - [31.7 Stratégies de Thread Safety](#317-stratégies-de-thread-safety)
    - [31.7.1 Synchronisation](#3171-synchronisation)
    - [31.7.2 Variables atomiques](#3172-variables-atomiques)
      - [31.7.2.1 Atomic classes](#31721-atomic-classes)
      - [31.7.2.2 Méthodes Atomiques](#31722-méthodes-atomiques)
    - [31.7.3 Lock Framework](#3173-lock-framework)
      - [31.7.3.1 Lock implementations](#31731-lock-implementations)
      - [31.7.3.2 Common Lock methods](#31732-common-lock-methods)
    - [31.7.4 Coordination Utilities](#3174-coordination-utilities)
  - [31.8 Concurrent Collections](#318-concurrent-collections)
  - [31.9 Parallel Streams](#319-parallel-streams)
  - [31.10 Relation avec Virtual Threads](#3110-relation-avec-virtual-threads)
  - [31.11 Summary](#3111-summary)

Ce chapitre introduit la **Java Concurrency API**, qui fournit des abstractions de haut niveau pour gérer la concurrence de manière sûre, efficace et scalable.

À la différence de la manipulation de bas niveau des thread présentée dans le chapitre précédent, la Concurrency API se concentre sur **task**, **executor** et **mécanismes de coordination**, permettant aux programmeurs de raisonner sur ce qui doit être fait plutôt que sur la manière dont les thread sont schedulés.

<a id="311-objectifs-et-portée-de-la-concurrency-api"></a>
## 31.1 Objectifs et Portée de la Concurrency API

La `Java Concurrency API`, principalement située dans le package `java.util.concurrent`, a été introduite pour affronter des problèmes fondamentaux inhérents à la gestion manuelle des thread.

- Séparer la soumission des task de la gestion des thread.
- Réduire la `synchronization` de bas niveau sujette à erreurs.
- Améliorer scalabilité et performance sur des systèmes multi-core.
- Fournir des mécanismes structurés pour `coordination`, `cancellation` et `shutdown`.

L'API n’élimine pas les problèmes de concurrence mais fournit des outils pour les gérer de manière sûre et prévisible.

Au lieu de créer et de contrôler explicitement les thread, les programmeurs exécutent des task et laissent le framework gérer **thread allocation, riuso, et synchronization**.

```java
ExecutorService executor = Executors.newSingleThreadExecutor();
executor.execute(() -> System.out.println("Task executed"));
executor.shutdown();
```

---

<a id="312-problèmes-fondamentaux-du-threading"></a>
## 31.2 Problèmes Fondamentaux du Threading

Avant de comprendre la `Concurrency API`, il est essentiel de comprendre les problématiques de concurrence qu’elle veut atténuer.

Ces problèmes proviennent de `shared mutable state`, `scheduling unpredictability` et `improper coordination`.

<a id="3121-race-conditions"></a>
### 31.2.1 Race Conditions

Une **race condition** se produit lorsque plusieurs thread accèdent à `shared mutable state` (un état mutable et partagé) et la correction du programme dépend du timing ou de l’intercalage de leur exécution.

- Causée par un accès non synchronisé à des données partagées.
- Conduit à un état du programme inconsistent ou incorrect.

```java
class Counter {
    int count = 0;
    void increment() {
	   count++;
    }
}
```

Si plusieurs thread invoquent `increment()` de manière concurrente, certains increments peuvent être perdus parce que l’opération n’est pas atomique.

<a id="3122-deadlock"></a>
### 31.2.2 Deadlock

Un **deadlock** se produit lorsque deux ou plusieurs thread sont bloqués de manière permanente, chacun en attente d’une ressource détenue par un autre thread.

- Typiquement causé par des dépendances circulaires entre lock.
- Aucun thread impliqué ne peut faire de progrès.

```java
synchronized (lockA) {
    synchronized (lockB) {
    }
}
```

Si un autre thread acquiert d’abord `lockB` et ensuite attend `lockA`, un deadlock peut se produire.

!!! note
    Les deadlock dans le monde réel impliquent typiquement des lock multiples et des inversions d’ordre.

<a id="3123-starvation"></a>
### 31.2.3 Starvation

La **starvation** se produit lorsqu’un thread se voit refuser indéfiniment l’accès aux ressources, même si ces ressources sont disponibles.

- Souvent causée par `unfair locking` ou des policy de scheduling.
- Le thread reste `runnable` mais n’est jamais exécuté.

```java
ReentrantLock lock = new ReentrantLock(false); // unfair lock
```

Certains thread peuvent acquérir de manière répétée le lock tandis que d’autres attendent indéfiniment.

<a id="3124-livelock"></a>
### 31.2.4 Livelock

Dans un **livelock**, les thread ne sont pas bloqués mais réagissent continuellement l’un à l’autre d’une manière qui en empêche le progrès.

- Les thread restent actifs mais inefficaces.
- Souvent causé par une logique de retry ou d’avoidance agressive.

```java
while (!tryLock()) {
    Thread.sleep(10);
}
```

Les deux thread peuvent répéter continuellement le retry, empêchant le forward progress.

---

<a id="313-des-thread-aux-task"></a>
## 31.3 Des Thread aux Task

La Concurrency API déplace le modèle de programmation de la gestion directe des **thread** vers la soumission de **task**.

Un **task** représente une unité logique de travail indépendante du thread qui l’exécute.

- **Runnable**: Représente un task qui ne retourne pas un résultat.
- **Callable**: Représente un task qui retourne un résultat et peut lancer des checked exceptions.

```java
Runnable task = () -> System.out.println("Runnable task");
Callable<Integer> callable = () -> 42;
```

Cette abstraction permet aux task d’être réutilisés, schedulés de manière flexible et exécutés via des stratégies d’exécution différentes.

---

<a id="314-executor-framework"></a>
## 31.4 Executor Framework

L’**Executor Framework** est le cœur de la Concurrency API.

Il gère la création des thread, le riuso et l'exécution des task à travers une interface simple.

- **Executor**: Interface de base pour exécuter des task.
- **ExecutorService**: Étend Executor avec contrôle du lifecycle et gestion des résultats.
- **ScheduledExecutorService**: Supporte l’exécution de task delayed et périodiques.

```java
ExecutorService executor = Executors.newFixedThreadPool(2);
executor.execute(() -> System.out.println("Task 1"));
executor.execute(() -> System.out.println("Task 2"));
executor.shutdown();
```

<a id="3141-submitting-task-et-futures"></a>
### 31.4.1 Submitting Task et Futures

Les task soumis via `execute()` retournent `void`: c’est une méthode "fire-and-forget" qui ne retourne aucune information sur le résultat du task.

Les task soumis en utilisant `submit()` retournent un **Future**, qui représente le résultat d’une computation asynchrone.

Les deux méthodes sont utilisées pour soumettre du travail pour une exécution asynchrone.

```java
Future<Integer> future = executor.submit(() -> 10 + 20);
Integer result = future.get();
```

| Method | Description |
| --- | --- |
| void **execute(Runnable task)** | Exécute un task de manière asynchrone sans valeur de retour et sans `Future`. |
| Future<?> **submit(Runnable task)** | Exécute un task de manière asynchrone; aucun résultat n’est produit (`Future.get()` retourne `null`). |
| <T> Future<T> **submit(Callable<T> task)** | Exécute un task de manière asynchrone et retourne un résultat de type `T`. |
| <T> List<Future<T>> **invokeAll(Collection<? extends Callable<T>> tasks)** | Exécute tous les task et retourne un `Future` pour chacun, après que tous complètent. |
| <T> T **invokeAny(Collection<? extends Callable<T>> tasks)** | Exécute les task et retourne le résultat d’un qui complète avec succès; les autres sont annulés. |

| Method | Description |
| --- | --- |
| boolean **isDone()** | Retourne `true` si le task est terminé (normalement, exceptionnellement, ou via cancellation). |
| boolean **isCancelled()** | Retourne `true` si le task a été annulé avant la fin normale. |
| boolean **cancel(boolean mayInterruptIfRunning)** | Tente d’annuler l’exécution. Si `true`, interrompt le thread en exécution si possible. |
| T **get()** | Blocque jusqu’à la fin et retourne le résultat, ou lance une exception si échoué ou annulé. |
| T **get(long timeout, TimeUnit unit)** | Blocque jusqu’au timeout donné et retourne le résultat, ou lance `TimeoutException` si non terminé. |

!!! warning
    `execute()` rejettera les exceptions silencieusement à moins qu’elles ne soient gérées à l’intérieur du task.

<a id="3142-callable-vs-runnable"></a>
### 31.4.2 Callable vs Runnable

Les deux interfaces représentent des task, mais avec des capacités différentes.

- `Runnable`: Aucune valeur de retour, ne peut pas lancer de checked exceptions.
- `Callable`: Retourne une valeur et supporte des checked exceptions.

```java
Callable<String> c = () -> "done";
Runnable r = () -> System.out.println("done");
```

Pour une computation asynchrone orientée résultat, `Callable` est généralement préféré.

<a id="315-thread-pools-et-scheduling"></a>
## 31.5 Thread Pools et Scheduling

Les executor gèrent des **thread pools**, qui réutilisent un nombre fixe ou dynamique de thread pour exécuter des task de manière efficace.

- **Fixed thread pool**: Limite la concurrence à un nombre fixe de thread.
- **Cached thread pool**: Croît et se réduit dynamiquement selon la demande: crée de nouveaux thread quand nécessaire mais réutilise des thread disponibles.
- **Single-thread executor**: Garantit l’exécution séquentielle des task.
- **Scheduled executor**: Supporte des task delayed et périodiques.

| Méthode Factory | Type de Retour | Description |
| --- | --- | --- |
| `Executors.newFixedThreadPool(int nThreads)` | ExecutorService | Crée un thread pool avec un nombre fixe de threads. |
| `Executors.newFixedThreadPool(int nThreads, ThreadFactory threadFactory)` | ExecutorService | Identique à newFixedThreadPool mais avec un ThreadFactory personnalisé. |
| `Executors.newSingleThreadExecutor()` | ExecutorService | Crée un thread pool à un seul thread qui exécute les task de manière séquentielle. |
| `Executors.newSingleThreadExecutor(ThreadFactory threadFactory)` | ExecutorService | Executor à un seul thread avec un ThreadFactory personnalisé. |
| `Executors.newCachedThreadPool()` | ExecutorService | Crée un thread pool qui crée de nouveaux threads si nécessaire et réutilise ceux inactifs. |
| `Executors.newCachedThreadPool(ThreadFactory threadFactory)` | ExecutorService | Thread pool cached avec un ThreadFactory personnalisé. |
| `Executors.newSingleThreadScheduledExecutor()` | ScheduledExecutorService | Crée un scheduled executor à un seul thread. |
| `Executors.newSingleThreadScheduledExecutor(ThreadFactory threadFactory)` | ScheduledExecutorService | Scheduled executor à un seul thread avec ThreadFactory personnalisé. |
| `Executors.newScheduledThreadPool(int corePoolSize)` | ScheduledExecutorService | Crée un scheduled thread pool avec la taille core spécifiée. |
| `Executors.newScheduledThreadPool(int corePoolSize, ThreadFactory threadFactory)` | ScheduledExecutorService | Scheduled thread pool avec ThreadFactory personnalisé. |
| `Executors.newWorkStealingPool()` | ExecutorService | Crée un work-stealing pool en utilisant le nombre de processeurs disponibles comme niveau de parallélisme. |
| `Executors.newWorkStealingPool(int parallelism)` | ExecutorService | Crée un work-stealing pool avec le niveau de parallélisme spécifié. |
| `Executors.newThreadPerTaskExecutor(ThreadFactory threadFactory)` | ExecutorService | Crée un executor qui démarre un nouveau thread pour chaque task. |
| `Executors.newVirtualThreadPerTaskExecutor()` | ExecutorService | Crée un executor qui démarre un nouveau virtual thread pour chaque task. |

`Task scheduling` : les task soumis à un executor sont placés dans une file et récupérés par les threads du pool ; l’ordre d’exécution dépend de l’implémentation de l’executor, de la politique de file et de la disponibilité des threads. Dans un scheduled executor, les task sont ordonnés selon leur temps d’activation ; les task périodiques sont réinsérés dans la file après chaque exécution.

```java
ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

scheduler.schedule(
	() -> System.out.println("Delayed"),
	2, TimeUnit.SECONDS);
```

| Method | Description |
| --- | --- |
| ScheduledFuture<?> schedule(Runnable command, long delay, TimeUnit unit) | Planifie une action one-shot qui devient exécutable après le delay spécifié. |
| <V> ScheduledFuture<V> schedule(Callable<V> callable, long delay, TimeUnit unit) | Planifie un task one-shot qui retourne une valeur après le delay spécifié. |
| ScheduledFuture<?> scheduleAtFixedRate(Runnable command, long initialDelay, long period, TimeUnit unit) | Planifie une exécution périodique à fixed rate : chaque exécution est planifiée par rapport au temps initial ; si une exécution est retardée, les suivantes peuvent tenter de « rattraper ». |
| ScheduledFuture<?> scheduleWithFixedDelay(Runnable command, long initialDelay, long delay, TimeUnit unit) | Planifie une exécution périodique avec fixed delay : chaque exécution est planifiée par rapport à la fin de la précédente ; aucun comportement de rattrapage. |

!!! important
    Ne jamais créer des thread manuellement dans une boucle:
    utilise plutôt des pools ou des virtual threads.

---

<a id="316-lifecycle-et-terminaison-de-lexecutor"></a>
## 31.6 Lifecycle et Terminaison de l'Executor

Les executor doivent être fermés explicitement pour libérer des ressources et permettre la terminaison de la JVM.

- **shutdown()**: Démarre un shutdown ordonné: complète les task en attente mais n’accepte pas de task supplémentaires.
- **close()**: (Java 19+) appelle shutdown() et attend que les task finissent, se comportant comme support try-with-resources pour ExecutorService.
- **shutdownNow()**: Tente un shutdown immédiat et interrompt les task en exécution.
- **awaitTermination()**: Attend la complétion ou un timeout.

```java
executor.shutdown();
executor.awaitTermination(5, TimeUnit.SECONDS);
```

---

<a id="317-stratégies-de-thread-safety"></a>
## 31.7 Stratégies de Thread Safety

La Concurrency API fournit de multiples stratégies complémentaires pour obtenir thread safety.

<a id="3171-synchronisation"></a>
### 31.7.1 Synchronisation

La synchronisation impose `mutual exclusion` et `memory visibility` en utilisant un intrinsic lock (monitor) associé à un objet ou à une classe.

```java
synchronized void increment() {
    count++;
}
```

Quand un thread entre dans une méthode synchronized:

- Il acquiert l’intrinsic lock de l’objet target (`this` pour les méthodes d’instance).
- Un seul thread à la fois peut détenir le même lock, empêchant une exécution concurrente.
- Quand la méthode se termine, le lock est libéré automatiquement.

La synchronization établit une **happens-before relationship** dans le Java Memory Model:

- Toutes les écritures faites dans la région synchronized sont flushées dans la mémoire principale quand le lock est libéré.
- Un thread qui acquiert le même lock ensuite est garanti de voir ces update.

La keyword synchronized peut être appliquée à:

- **Méthodes d’instance** (lock sur `this`)
- **Méthodes statiques** (lock sur l’objet `Class`)
- **Blocs** (lock sur un objet spécifique, permettant un contrôle plus fin)

!!! important
    La synchronisation est simple mais peut réduire la scalabilité sous contention.

---

<a id="3172-variables-atomiques"></a>
### 31.7.2 Variables Atomiques

Les `atomic classes` fournissent des opérations lock-free, thread-safe implémentées en utilisant des primitives CPU de bas niveau comme Compare-And-Swap (CAS).

```java
AtomicInteger count = new AtomicInteger();
count.incrementAndGet();
```

<a id="31721-atomic-classes"></a>
### 31.7.2.1 Atomic classes

| Atomic Class | Description |
| --- | --- |
| **AtomicBoolean** | Met à jour et lit de manière atomique une valeur `boolean`. |
| **AtomicInteger** | Met à jour et lit de manière atomique une valeur `int`. |
| **AtomicLong** | Met à jour et lit de manière atomique une valeur `long`. |
| **AtomicReference<T>** | Met à jour et lit de manière atomique un reference à objet. |
| **AtomicIntegerArray** | Fournit des opérations atomiques sur les éléments d’un array `int`. |
| **AtomicLongArray** | Fournit des opérations atomiques sur les éléments d’un array `long`. |
| **AtomicReferenceArray<T>** | Fournit des opérations atomiques sur les éléments d’un array de reference. |
| **AtomicStampedReference<T>** | Met à jour de manière atomique un reference avec un integer stamp pour éviter des problèmes ABA. |
| **AtomicMarkableReference<T>** | Met à jour de manière atomique un reference avec un boolean mark. |

<a id="31722-méthodes-atomiques"></a>
### 31.7.2.2 Méthodes Atomiques

| Method | Description |
| --- | --- |
| **get()** | Retourne la valeur courante avec une sémantique volatile-read. |
| **set(value)** | Définit la valeur avec une sémantique volatile-write. |
| **lazySet(value)** | Définit éventuellement la valeur avec des garanties d’ordering plus faibles. |
| **compareAndSet(expect, update)** | Définit de manière atomique la valeur si la valeur courante est égale à la valeur attendue. |
| **getAndSet(value)** | Définit de manière atomique la valeur et retourne la valeur précédente. |
| **incrementAndGet()** | Incrémente de manière atomique la valeur et retourne le résultat mis à jour. |
| **getAndIncrement()** | Incrémente de manière atomique la valeur et retourne le résultat précédent. |
| **decrementAndGet()** | Décrémente de manière atomique la valeur et retourne le résultat mis à jour. |
| **getAndDecrement()** | Décrémente de manière atomique la valeur et retourne le résultat précédent. |
| **addAndGet(delta)** | Ajoute de manière atomique le delta donné et retourne le résultat mis à jour. |
| **getAndAdd(delta)** | Ajoute de manière atomique le delta donné et retourne le résultat précédent. |

<ins>Variables Atomiques</ins>:

- Exécutent des opérations uniques **atomiquement**
- Fournissent des **memory visibility guarantees** similaires à `volatile`
- Évitent le thread blocking, les rendant hautement scalables sous contention

Cependant, les atomic variables garantissent l’atomicité seulement pour des **opérations individuelles**.

Composer plusieurs opérations requiert quand même une synchronization externe.

<ins>Les Variables atomiques sont typiquement utilisées pour</ins>:

- Counter et sequence generator
- Flag et state indicator
- Update à haut throughput et basse latence

---

<a id="3173-lock-framework"></a>
### 31.7.3 Lock Framework

Le package `java.util.concurrent.locks` fournit des mécanismes de locking explicites qui offrent plus de flexibilité et de contrôle que synchronized.

```java
ReentrantLock lock = new ReentrantLock();
lock.lock();
try {
    // critical section
} finally {
    lock.unlock();
}
```

Caractéristiques clés du Lock framework:

- Les lock doivent être acquis et libérés explicitement
- L’acquisition du lock peut être interruptible ou time-bounded
- Les lock peuvent être configurés avec une fairness policy (paramètre) quand l’ordering est requis (quand tu dois contrôler l’ordre dans lequel les thread tournent)
- Plusieurs objets Condition peuvent être associés à un seul lock

<a id="31731-lock-implementations"></a>
### 31.7.3.1 Lock implementations

| Lock Implementation | Description |
| --- | --- |
| **Lock** | Interface core qui définit des opérations de lock explicites. |
| **ReentrantLock** | Lock reentrant de `mutual exclusion` avec fairness policy optionnelle. |
| **ReadWriteLock** | Interface qui définit des lock séparés de read et write. |
| **ReentrantReadWriteLock** | Fournit des lock séparés reentrant de read et write pour améliorer la scalabilité en lecture. |
| **StampedLock** | Lock qui supporte des modes optimistic, read et write locking (non-reentrant). |

!!! warning
    À la différence d’autres lock, StampedLock **n’est pas reentrant** —
    le réacquérir depuis le même thread cause un deadlock.

<a id="31732-common-lock-methods"></a>
### 31.7.3.2 Common Lock methods

| Method | Description |
| --- | --- |
| **lock()** | Acquiert le lock, bloquant indéfiniment jusqu’à disponibilité. |
| **unlock()** | Libère le lock; doit être appelé par le thread propriétaire. |
| **tryLock()** | Tente d’acquérir le lock immédiatement sans bloquer: retourne un boolean indiquant si le lock a été acquis avec succès |
| **tryLock(long, TimeUnit)** | Tente d’acquérir le lock dans le timeout donné. |
| **lockInterruptibly()** | Acquiert le lock à moins que le thread ne soit interrompu. |
| **newCondition()** | Crée une instance `Condition` pour une coordination fine-grained entre thread. |

À la différence de synchronized, les lock ne sont pas libérés automatiquement, rendant essentiel l’usage correct de try/finally pour éviter des deadlock.

<a id="3174-coordination-utilities"></a>
### 31.7.4 Coordination Utilities

Les coordination utilities permettent aux thread de coordonner des phases d’exécution sans protéger des données partagées via `mutual exclusion`.

D’autres coordination primitives incluent:
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

- Bloque les thread jusqu’à ce qu’un nombre prédéfini de thread atteigne la barrier
- Libère simultanément tous les thread en attente une fois que la barrier est tripped
- Peut être réutilisé pour plusieurs cycles de coordination

Ces utilities se concentrent sur execution ordering et synchronization, pas sur data protection.

---

<a id="318-concurrent-collections"></a>
## 31.8 Concurrent Collections

Les concurrent collections sont des **thread-safe data structures** conçues pour supporter des **niveaux élevés de concurrence** sans exiger une synchronization externe.

À la différence des synchronized wrappers (ex. `Collections.synchronizedMap`), les concurrent collections:
- Utilisent **fine-grained locking** ou des **lock-free techniques**
- Permettent à plusieurs thread d’accéder et de modifier la collection simultanément
- Scalent mieux sous contention

Des exemples communs incluent:

- **ConcurrentHashMap**
- Une concurrent map à hautes performance qui permet des lectures et des update concurrents en partitionnant l’état interne et en minimisant le lock contention.

- **CopyOnWriteArrayList**
- Une thread-safe list optimisée pour des scénarios avec **beaucoup de lectures et peu d’écritures**. Les opérations de write créent un nouvel array interne, permettant aux lectures de procéder sans locking.

- **BlockingQueue**
- Une queue conçue pour des **producer-consumer patterns**, où les thread peuvent se bloquer en attendant des éléments ou une capacité disponible.

```java
BlockingQueue<String> queue = new LinkedBlockingQueue<>();
queue.put("item");   // blocks if the queue is full
queue.take();        // blocks if the queue is empty
```

Les blocking queue gèrent la synchronization en interne, simplifiant la coordination entre thread producer et consumer.

!!! caution
    Les CopyOnWrite collections sont memory-expensive; les éviter dans des workload write-heavy.

---

<a id="319-parallel-streams"></a>
## 31.9 Parallel Streams

Les `parallel streams` fournissent du **declarative data parallelism**, permettant que les opérations du stream soient exécutées de manière concurrente sur plusieurs thread avec des changements minimaux de code.

Caractéristiques clés:
- Activés via `parallelStream()` ou `stream().parallel()`
- Exécutés en interne en utilisant le **common ForkJoinPool**
- Divisent automatiquement les données en chunk traités en parallèle

Les parallel streams fonctionnent mieux quand:
- Les opérations sont **CPU-bound**
- Les fonctions sont **stateless et non-blocking**
- La source de données est suffisamment grande pour amortir l’overhead de la parallélisation

```java
list.parallelStream()
    .map(x -> x * x)
    .forEach(System.out::println);
```

Puisque l’ordre d’exécution n’est pas garanti, les parallel streams devraient éviter:
- Shared mutable state
- Blocking I/O
- Order-dependent side effects

!!! note
    Utilise `forEachOrdered()` si un output déterministique est requis.

---

<a id="3110-relation-avec-virtual-threads"></a>
## 31.10 Relation avec Virtual Threads

En Java 21, l’`Executor framework` s’intègre de manière seamless avec **virtual threads**, permettant massive concurrency avec usage minimal de ressources.

```java
ExecutorService executor =
Executors.newVirtualThreadPerTaskExecutor();

executor.submit(() -> blockingIO());
executor.close();
```

Cela permet au code blocking de scaler efficacement sans redessiner les API.

---

<a id="3111-summary"></a>
## 31.11 Summary

- La `Java Concurrency API` fournit une alternative robuste, scalable et plus sûre à la gestion manuelle des thread.
- Abstraire l’exécution, coordonner les task et offrir des utilities thread-safe permet aux développeurs de construire des systèmes concurrents à la fois performants et maintenables.
- Choisis l’outil juste: synchronized → locks → atomics → executors → virtual threads.
