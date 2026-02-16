# 30. Thread Java – Fondamentaux et Modèle d’Exécution

<a id="indice"></a>
### Indice

- [30. Thread Java – Fondamentaux et Modèle d’Exécution](#30-thread-java--fondamentaux-et-modèle-dexécution)
  - [30.1 Thread, Processus et le Système d’Exploitation](#301-thread-processus-et-le-système-dexploitation)
  - [30.2 Modèle de Mémoire Stack et Heap](#302-modèle-de-mémoire-stack-et-heap)
  - [30.3 Contexte et Context Switching](#303-contexte-et-context-switching)
  - [30.4 Concurrency vs Parallelisme](#304-concurrency-vs-parallelisme)
  - [30.5 Thread en Java Modèle Conceptuel](#305-thread-en-java-modèle-conceptuel)
  - [30.6 Catégories de Thread en Java 21](#306-catégories-de-thread-en-java-21)
  - [30.7 Créer des Thread en Java](#307-créer-des-thread-en-java)
  - [30.8 Cycle de Vie et Exécution d’un Thread](#308-cycle-de-vie-et-exécution-dun-thread)
  - [30.9 Démarrer vs Exécuter un Thread Synchrone-ou-Asynchrone](#309-démarrer-vs-exécuter-un-thread-synchrone-ou-asynchrone)
  - [30.10 Priorité des Thread et Scheduling](#3010-priorité-des-thread-et-scheduling)
  - [30.11 Différément et Yield des Thread](#3011-différément-et-yield-des-thread)
  - [30.12 Interruption des Thread et Annulation Coopérative](#3012-interruption-des-thread-et-annulation-coopérative)
    - [30.12.1 Ce que Signifie Interrompre un Thread](#30121-ce-que-signifie-interrompre-un-thread)
    - [30.12.2 Interrompre des Opérations Bloquantes](#30122-interrompre-des-opérations-bloquantes)
    - [30.12.3 Vérifier le Statut d’Interruption](#30123-vérifier-le-statut-dinterruption)
    - [30.12.4 Exemple Interrompre un Thread en Sleep](#30124-exemple-interrompre-un-thread-en-sleep)
    - [30.12.5 Observations Clés](#30125-observations-clés)
  - [30.13 Thread et le Thread Principal](#3013-thread-et-le-thread-principal)
  - [30.14 Concurrency des Thread et État Partagé](#3014-concurrency-des-thread-et-état-partagé)
  - [30.15 Sommaire](#3015-sommaire)

Ce chapitre introduit les **thread** à partir des principes de base et explique comment ils sont modélisés et utilisés en Java 21.

Ce texte établit également les fondations conceptuelles nécessaires pour comprendre `concurrency`, `synchronization` et la `Java Concurrency API` traitée dans le prochain chapitre.

<a id="301-thread-processus-et-le-système-dexploitation"></a>
## 30.1 Thread, Processus et le Système d’Exploitation

Pour comprendre les thread, nous devons partir du modèle d’exécution du système d’exploitation.

Les systèmes d’exploitation modernes exécutent des programmes en utilisant des **processus** et des **thread**.

- **Processus**: Une instance de programme en exécution gérée par le système d’exploitation. Un processus possède son propre espace de mémoire virtuelle, des ressources système (fichiers, sockets) et au moins un thread.
- **Thread**: Une unité d’exécution légère à l’intérieur d’un processus. Les thread partagent la mémoire et les ressources du processus mais s’exécutent de manière indépendante.
- **Task**: Une unité logique de travail à exécuter. Un task peut être exécuté par un thread mais n’est pas lui-même un thread.
- **Core CPU**: Une unité d’exécution physique ou logique capable d’exécuter un thread à la fois. Plusieurs core permettent une véritable exécution parallèle.

Un seul processus peut contenir de nombreux thread, tous opérant dans le même environnement partagé. Cet environnement partagé est à la fois source des potentialités de la Concurrency et de ses risques.

---

<a id="302-modèle-de-mémoire-stack-et-heap"></a>
## 30.2 Modèle de Mémoire: Stack et Heap

Les thread interagissent avec la mémoire de deux manières fondamentalement différentes.

- **Stack du Thread**: Zone de mémoire privée pour chaque thread. Elle stocke les frames des appels de méthode, les variables locales et l’état d’exécution. Chaque thread a exactement un stack.
- **Heap**: Zone de mémoire partagée utilisée pour les objets et les instances de classe. Tous les thread dans le même processus peuvent accéder au heap.

Puisque les `stack sont isolés` et le `heap est partagé`, les problèmes de concurrence surviennent lorsque plusieurs thread accèdent aux mêmes objets dans le heap sans coordination adéquate.

---

<a id="303-contexte-et-context-switching"></a>
## 30.3 Contexte et Context Switching

Le système d’exploitation planifie l’exécution des thread sur les core de la CPU.

Puisque le nombre de thread exécutables dépasse souvent le nombre de core disponibles, le système d’exploitation effectue le **context switching**.

- **Contexte**: L’état complet d’exécution d’un thread, y compris registres, compteur de programme et pointeur de stack.
- **Context Switch**: L’acte de suspendre un thread et d’en reprendre un autre en sauvegardant et en restaurant leurs contextes respectifs.

Le `context switching` permet la concurrence mais a un coût: des cycles CPU sont consommés sans exécuter de logique applicative.

Les programmeurs Java doivent concevoir des systèmes qui équilibrent concurrence et efficacité.

---

<a id="304-concurrency-vs-parallelisme"></a>
## 30.4 Concurrency vs Parallelisme

Ces deux termes sont souvent confondus mais décrivent des concepts différents.

- **Concurrence**: Plusieurs thread sont en exécution dans le même intervalle de temps, éventuellement entrelacés sur un seul core CPU.
- **Parallelisme**: Plusieurs thread s’exécutent simultanément sur des core CPU différents.

Java supporte la concurrence indépendamment du parallélisme matériel.

Même sur un système single-core, les thread Java peuvent être concurrents via le time slicing.

---

<a id="305-thread-en-java-modèle-conceptuel"></a>
## 30.5 Thread en Java: Modèle Conceptuel

En Java, un **thread** représente un chemin indépendant d’exécution à l’intérieur d’un seul processus JVM. Tous les thread Java opèrent dans le même heap et dans le même contexte de `class loading`, à moins qu’ils ne soient explicitement isolés via des mécanismes avancés.

- **Thread Java**: Un objet de type `java.lang.Thread` qui mappe à une unité d’exécution sous-jacente.
- **Runnable**: Une interface fonctionnelle qui représente un `task` dont la méthode `run()` contient la logique exécutable.

Un thread exécute du code en invoquant sa propre méthode `run()`, directement ou indirectement via le scheduler des thread de la JVM: voir [Démarrer vs Exécuter un Thread](#309-démarrer-vs-exécuter-un-thread-synchrone-ou-asynchrone)

---

<a id="306-catégories-de-thread-en-java-21"></a>
## 30.6 Catégories de Thread en Java 21

Java 21 définit différents types de thread, qui diffèrent par cycle de vie, scheduling et usage prévu.

- **Platform Thread**: Un thread Java traditionnel mappé un-à-un à un thread du système d’exploitation.
- **Virtual Thread**: Un thread léger géré par la JVM et schedulé sur des thread carrier. Introduit pour permettre une concurrence massive avec un overhead minimal.
- **Carrier Thread**: Un Platform Thread utilisé en interne par la JVM pour exécuter des thread virtuels.
- **Daemon Thread**: Un thread en arrière-plan qui n’empêche pas la terminaison de la JVM. Quand seuls des thread daemon restent en exécution, la JVM se termine.
- **Thread Utilisateur**: Tout thread non-daemon. La JVM attend que tous les thread utilisateur terminent avant de se terminer.
- **Thread Système**: Des thread créés en interne par la JVM pour le garbage collection, la compilation JIT et d’autres services runtime.

!!! note
    Les `thread virtuels` sont des thread utilisateur légers; ils **ne** sont pas daemon par défaut.

---

<a id="307-créer-des-thread-en-java"></a>
## 30.7 Créer des Thread en Java

Les thread peuvent être créés de différentes manières, toutes conceptuellement centrées sur la fourniture de logique exécutable.

- En étendant `Thread` et en redéfinissant `run()`.
- En passant un `Runnable` au constructeur de `Thread`.
- En utilisant des factories de thread et des executor (traités dans la section Concurrency API).

```java
Runnable runnable = ...

  // Crée un thread de plateforme via constructeur
  Thread thread = new Thread(runnable);
  thread.start();

  // Démarre un thread daemon pour exécuter un task
  Thread thread = Thread.ofPlatform().daemon().start(runnable);

  // Crée un thread non démarré nommé "duke", sa méthode start()
  // doit être invoquée pour planifier son exécution.
  Thread thread = Thread.ofPlatform().name("duke").unstarted(runnable);

  // Une ThreadFactory qui crée des thread daemon nommés "worker-0", "worker-1", ...
  ThreadFactory factory = Thread.ofPlatform().daemon().name("worker-", 0).factory();

  // Démarre un thread virtuel pour exécuter un task
  Thread thread = Thread.ofVirtual().start(runnable);

  // Une ThreadFactory qui crée des thread virtuels
  ThreadFactory factory = Thread.ofVirtual().factory();
```

!!! warning
    - La seule création d’un thread ne démarre pas son exécution.
    - L’exécution commence seulement lorsque le scheduler de la JVM est impliqué.

---

<a id="308-cycle-de-vie-et-exécution-dun-thread"></a>
## 30.8 Cycle de Vie et Exécution d’un Thread

Un thread Java traverse des états bien définis au cours de son cycle de vie.

- **New**: Objet thread créé mais pas encore démarré.
- **Runnable**: Éligible à l’exécution par le scheduler.
- **Running**: En exécution active sur un core CPU.
- **Blocked / Waiting**: Temporairement incapable de continuer à cause de synchronisation ou de coordination.
- **Terminated**: Exécution terminée ou interrompue.

La JVM et le système d’exploitation coopèrent pour déplacer les thread entre ces états.

Les thread dans l’état `BLOCKED`, `WAITING` ou `TIMED_WAITING` **n’utilisent pas de ressources CPU**

---

<a id="309-démarrer-vs-exécuter-un-thread-synchrone-ou-asynchrone"></a>
## 30.9 Démarrer vs Exécuter un Thread: Synchrone ou Asynchrone

Il existe une distinction conceptuelle critique entre invoquer `run()` et invoquer `start()`.

- Appeler directement `run()` exécute la méthode de manière synchrone dans le thread courant, comme un appel de méthode normal.
- Appeler `start()` demande à la JVM de créer un nouveau stack d’appel et d’exécuter `run()` de manière asynchrone dans un thread séparé.

Par conséquent, du code comme `new Thread(r).run();` NE crée PAS de concurrence. L’exécution reste synchrone et bloque le thread appelant jusqu’à l’achèvement.

!!! note
    `Exécution asynchrone` signifie que l’appelant continue immédiatement tandis que le nouveau thread progresse de manière indépendante, soumis au scheduling.
    
    `Exécution synchrone` signifie que l’appelant attend que l’opération soit terminée.

!!! important
    La concurrence commence **seulement** lorsque `start()` est invoqué.

<a id="3010-priorité-des-thread-et-scheduling"></a>
## 30.10 Priorité des Thread et Scheduling

Les thread Java ont une priorité associée qui influence le scheduling.

- `Priorité du Thread`: Une valeur entière indiquant son importance relative, allant de minimum à maximum.
- `Scheduling`: La JVM délègue les décisions de scheduling au système d’exploitation, qui peut ou non respecter strictement les priorités.

La priorité du thread influence la probabilité de scheduling mais ne garantit jamais l’ordre d’exécution. Le code Java portable ne doit jamais dépendre des priorités pour la correction.

Il est possible de définir la **priorité** sur les `platform threads`; pour les `thread virtuels` la **priorité** est toujours fixée à **5** (`Thread.NORM_PRIORITY`) et tenter de la modifier n’a aucun effet.

---

<a id="3011-différément-et-yield-des-thread"></a>
## 30.11 Différément et Yield des Thread

Les thread peuvent influencer volontairement le comportement de scheduling.

Appeler `Thread.yield()` signale la disponibilité à suspendre l’exécution.

- `Yielding`: Un thread suggère qu’il est disposé à suspendre l’exécution pour permettre à d’autres thread exécutables de progresser.
- `Sleeping`: Un thread suspend l’exécution pour une durée fixe, entrant dans un état d’attente temporisée.

Ces mécanismes ne garantissent pas l’exécution immédiate d’autres thread; ils fournissent seulement des suggestions de scheduling.

---

<a id="3012-interruption-des-thread-et-annulation-coopérative"></a>
## 30.12 Interruption des Thread et Annulation Coopérative

Les thread Java ne peuvent pas être arrêtés de force depuis l’extérieur.

À la place, Java fournit un mécanisme coopératif appelé **interruption du thread**, qui permet à un thread de demander qu’un autre thread interrompe ce qu’il est en train de faire.

Le thread cible décide comment et quand répondre.

<a id="30121-ce-que-signifie-interrompre-un-thread"></a>
### 30.12.1 Ce que Signifie Interrompre un Thread

Interrompre un thread **ne** le termine **pas**. Appeler `interrupt()` définit un **flag d’interruption** interne sur le thread cible. Il est de la responsabilité du thread en exécution d’observer ce flag et de réagir de manière appropriée.

- `Demande d'interruption`: Un signal envoyé à un thread indiquant qu’il devrait s’arrêter ou changer son activité courante.
- `Flag d'interruption`: Un statut booléen associé à chaque thread, défini lorsque `interrupt()` est invoqué.
- `Annulation Coopérative`: Un design pattern dans lequel les thread vérifient périodiquement d’éventuelles interruptions et se terminent proprement.

---

<a id="30122-interrompre-des-opérations-bloquantes"></a>
### 30.12.2 Interrompre des Opérations Bloquantes

Certaines méthodes bloquantes en Java répondent immédiatement à l’interruption en lançant `InterruptedException` et en mettant à zéro le flag d’interruption. Ces méthodes incluent `sleep()`, `wait()` et `join()`.

Lorsqu’un thread est bloqué dans l’une de ces méthodes et qu’un autre thread l’interrompt, le thread bloqué est réveillé et une exception est lancée. Cela fournit un point de sortie sûr des opérations bloquantes.

---

<a id="30123-vérifier-le-statut-dinterruption"></a>
### 30.12.3 Vérifier le Statut d’Interruption

Les thread qui ne sont pas bloqués doivent vérifier explicitement s’ils ont été interrompus. Java fournit deux façons de le faire.

- `Thread.currentThread().isInterrupted()`: Retourne le statut d’interruption sans le mettre à zéro.
- `Thread.interrupted()`: Retourne le statut d’interruption et le met à zéro. Ceci est subtil: l’appel suivant retournera false.

Ne pas vérifier le statut d’interruption peut amener les thread à ignorer des demandes d’annulation et à continuer à s’exécuter indéfiniment.

---

<a id="30124-exemple-interrompre-un-thread-en-sleep"></a>
### 30.12.4 Exemple: Interrompre un Thread en Sleep

L’exemple suivant démontre l’annulation coopérative via interruption.

Un thread worker dort pendant qu’il exécute du travail. Le thread main l’interrompt, provoquant un shutdown propre.

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
    L’ordre de l’output peut varier légèrement à cause du scheduling.

---

<a id="30125-observations-clés"></a>
### 30.12.5 Observations Clés

- Appeler `interrupt()` n’arrête pas directement le thread.
- L’interruption est détectée et `sleep()` lance une `InterruptedException`.
- Le thread worker se termine de lui-même de manière contrôlée.
- Une gestion correcte de l’interruption permet aux thread de libérer des ressources et de maintenir la cohérence du programme.

!!! note
    Ignorer `InterruptedException` sans terminer ou restaurer le statut d’interruption est considéré comme une mauvaise pratique et peut mener à des thread non réactifs.

---

<a id="3013-thread-et-le-thread-principal"></a>
## 30.13 Thread et le Thread Principal

Chaque application Java commence avec un **thread principal**. Ce thread exécute la méthode `main(String[])`.

- Le thread principal est un thread utilisateur.
- La JVM reste active tant qu’au moins un thread utilisateur est en exécution.
- Si le thread principal se termine mais qu’il existe d’autres thread utilisateur, la JVM continue l’exécution en attendant que les thread utilisateur se terminent.
- Les thread daemon ne maintiennent pas la JVM en vie.

Comprendre le rôle du thread principal est essentiel pour raisonner sur la terminaison du programme et le traitement en arrière-plan.

---

<a id="3014-concurrency-des-thread-et-état-partagé"></a>
## 30.14 Concurrency des Thread et État Partagé

La `Concurrence` naît lorsque plusieurs thread accèdent à un état mutable partagé.

- `État partagé`: Toute donnée située dans le heap accessible par plus d’un thread.
- `Race Condition`: Une erreur de correction causée par un accès non synchronisé à un état partagé.
- `Problème de visibilité`: Un thread opère sur des données obsolètes à cause de l’absence de synchronisation mémoire correcte.

Java résout ces problèmes avec synchronization, volatile, lock, atomiques et des frameworks de haut niveau (Executors, futures).

La synchronization, les variables volatile et les utilities de concurrence de haut niveau seront étudiées dans les sections suivantes.

---

<a id="3015-sommaire"></a>
## 30.15 Sommaire

- Les `Thread` sont le bloc de construction fondamental de l’exécution concurrente en Java.
- Ils existent à l’intérieur des processus, partagent la mémoire et sont schedulés par la JVM en coopération avec le système d’exploitation.
- Une gestion correcte des thread évite des fuites, des deadlocks et du gaspillage de CPU.
