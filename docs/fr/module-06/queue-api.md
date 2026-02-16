# 27. API Queue & Deque

<a id="table-des-matières"></a>
### Table des matières

- [27. API Queue & Deque](#27-api-queue--deque)
  - [27.1 Queue — Vue d’ensemble](#271-queue--vue-densemble)
    - [27.1.1 Méthodes Principales de Queue](#2711-méthodes-principales-de-queue)
    - [27.1.2 Implémentations de Queue](#2712-implémentations-de-queue)
  - [27.2 Deque — Vue d’ensemble](#272-deque--vue-densemble)
    - [27.2.1 Méthodes Principales de Deque](#2721-méthodes-principales-de-deque)
    - [27.2.2 Implémentations de Deque](#2722-implémentations-de-deque)
  - [27.3 Utiliser une Queue](#273-utiliser-une-queue)
  - [27.4 Utiliser une Deque comme Queue et comme Stack](#274-utiliser-une-deque-comme-queue-et-comme-stack)
    - [27.4.1 Exemple FIFO (Comportement Queue)](#2741-exemple-fifo-comportement-queue)
    - [27.4.2 Exemple LIFO (Comportement Stack)](#2742-exemple-lifo-comportement-stack)
  - [27.5 PriorityQueue — Queue Spéciale](#275-priorityqueue--queue-spéciale)
  - [27.6 Blocking Queue (Bases)](#276-blocking-queue-bases)
  - [27.7 Pièges Courants](#277-pièges-courants)
  - [27.8 Tableau Récapitulatif](#278-tableau-récapitulatif)

---

Les interfaces `Queue` et `Deque` de Java modélisent des collections ordonnées conçues pour traiter des éléments dans une séquence particulière.

Une **Queue** modélise typiquement une structure **FIFO** (First-In, First-Out).  
Une **Deque** (`double-ended queue`) permet l’insertion et la suppression aux deux extrémités, autorisant des comportements **FIFO** et **LIFO** dans une seule API.

<a id="271-queue-vue-densemble"></a>
## 27.1 Queue — Vue d’ensemble

L’interface `Queue` étend `Collection` et est couramment utilisée dans la programmation asynchrone, la distribution du travail, les algorithmes et le buffering.

Il existe deux familles de méthodes : celles qui **lèvent des exceptions** et celles qui **retournent des valeurs spéciales** (généralement `null`).

<a id="2711-méthodes-principales-de-queue"></a>
### 27.1.1 Méthodes Principales de Queue

| Opération | Lève une Exception | Retourne une Valeur Spéciale | Description |
|-----------|--------------------|------------------------------|-------------|
| Insertion | `add(e)` | `offer(e)` | Ajoute un élément ; `offer` est préféré pour les queues à capacité limitée |
| Suppression | `E remove()` | `E poll()` | Supprime et retourne la tête. `remove()` lève NoSuchElementException si la queue est vide, `poll()` retourne null |
| Lecture | `E element()` | `E peek()` | Retourne la tête sans la supprimer. `element()` lève NoSuchElementException si la queue est vide, `peek()` retourne null |

<a id="2712-implémentations-de-queue"></a>
### 27.1.2 Implémentations de Queue

Classes courantes implémentant `Queue` :

- `LinkedList` — non bornée, implémente aussi `Deque` et `List`.
- `ArrayDeque` — queue rapide basée sur un tableau redimensionnable ; ne peut pas stocker `null`.
- `PriorityQueue` — ordonne les éléments par ordre naturel ou comparator ; n’est pas FIFO.
- `ConcurrentLinkedQueue` — thread-safe, lock-free.

!!! note
    `PriorityQueue` ne garantit pas que l’ordre d’itération corresponde à l’ordre de priorité.

!!! warning
    La plupart des implémentations de Queue rejettent `null` car `null` est utilisé comme valeur de retour pour “vide”.

---

<a id="272-deque-vue-densemble"></a>
## 27.2 Deque — Vue d’ensemble

`Deque` (double-ended queue) prend en charge l’insertion, la suppression et l’inspection à la fois en tête et en queue.

Elle est plus polyvalente qu’une Queue :  
- FIFO (comportement de queue)  
- LIFO (comportement de stack)  
- Algorithmes bidirectionnels

<a id="2721-méthodes-principales-de-deque"></a>
### 27.2.1 Méthodes Principales de Deque

| Opération | Avant | Arrière |
|-----------|-------|---------|
| Insertion | addFirst(e), offerFirst(e) | addLast(e), offerLast(e) |
| Suppression | removeFirst(), pollFirst() | removeLast(), pollLast() |
| Inspection | getFirst(), peekFirst() | getLast(), peekLast() |

<a id="2722-implémentations-de-deque"></a>
### 27.2.2 Implémentations de Deque

- `ArrayDeque` — implémentation recommandée pour un usage général (rapide, sans limite de capacité).
- `LinkedList` — complète mais plus lente en raison de la structure à nœuds.
- `ConcurrentLinkedDeque` — deque concurrente non bloquante.

!!! note
    `Stack` est legacy ; utiliser `Deque` pour le comportement de stack (push/pop).
    Les opérations de queue de ArrayDeque et LinkedList (add/remove/peek) sont en O(1) amorti.

---

<a id="273-utiliser-une-queue"></a>
## 27.3 Utiliser une Queue

```java
Queue<String> q = new LinkedList<>();

q.offer("A");
q.offer("B");
q.offer("C");

System.out.println(q.peek());   // A
System.out.println(q.poll());   // A
System.out.println(q.poll());   // B
System.out.println(q.poll());   // C
System.out.println(q.poll());   // null (queue vide)
```

---

<a id="274-utiliser-une-deque-comme-queue-et-comme-stack"></a>
## 27.4 Utiliser une Deque (comme Queue et comme Stack)

<a id="2741-exemple-fifo-comportement-queue"></a>
### 27.4.1 Exemple FIFO (Comportement Queue)

```java
Deque<String> dq = new ArrayDeque<>();

dq.offerLast("A"); // enqueue
dq.offerLast("B");
dq.offerLast("C");

System.out.println(dq.pollFirst()); // A
System.out.println(dq.pollFirst()); // B
System.out.println(dq.pollFirst()); // C
```

<a id="2742-exemple-lifo-comportement-stack"></a>
### 27.4.2 Exemple LIFO (Comportement Stack)

```java
Deque<String> stack = new ArrayDeque<>();

stack.push("A");
stack.push("B");
stack.push("C");

System.out.println(stack.pop()); // C
System.out.println(stack.pop()); // B
System.out.println(stack.pop()); // A
```

---

<a id="275-priorityqueue-queue-spéciale"></a>
## 27.5 PriorityQueue — Queue Spéciale

`PriorityQueue` ordonne les éléments par **ordre naturel** ou via un `Comparator` fourni.

Caractéristiques importantes :

- Non FIFO — la tête est l’élément “le plus petit”.
- L’ordre est garanti uniquement lors de la suppression, pas lors de l’itération.
- Les éléments `null` ne sont pas autorisés.

```java
PriorityQueue<Integer> pq = new PriorityQueue<>();

pq.offer(50);
pq.offer(10);
pq.offer(30);

System.out.println(pq.poll()); // 10
System.out.println(pq.poll()); // 30
System.out.println(pq.poll()); // 50
```

---

<a id="276-blocking-queue-bases"></a>
## 27.6 Blocking Queue (Bases)

Dans les environnements concurrents, le package `java.util.concurrent` fournit des types de queues bloquantes.

- `ArrayBlockingQueue` — tableau sous-jacent de taille fixe.
- `LinkedBlockingQueue` — optionnellement bornée.
- `PriorityBlockingQueue` — priority queue thread-safe.
- `DelayQueue` — éléments libérés après des délais.

!!! note
    BlockingQueue n’autorise jamais `null`.
    put(e) — bloque jusqu’à ce qu’un espace soit disponible
    take() — bloque jusqu’à ce qu’un élément soit disponible
    BlockingQueue prend aussi en charge des opérations temporisées : offer(e, timeout), poll(timeout)

---

<a id="277-pièges-courants"></a>
## 27.7 Pièges Courants

- Les méthodes de `Queue` et `Deque` existent en variantes “exception” et “valeur spéciale” — mémoriser lesquelles sont lesquelles.
- `ArrayDeque` ne peut pas stocker `null` — `null` est utilisé en interne.
- L’ordre d’itération de `PriorityQueue` n’est PAS trié.
- L’utilisation de `Stack` est déconseillée ; utiliser `Deque` à la place.
- Deque permet à la fois FIFO et LIFO et possède l’API **la plus complète**.

---

<a id="278-tableau-récapitulatif"></a>
## 27.8 Tableau Récapitulatif

| Interface | Comportement Typique | Null Autorisé ? | Implémentations Courantes | Notes |
|-----------|----------------------|----------------|---------------------------|-------|
| Queue | FIFO | Dépend | LinkedList, ArrayDeque, PriorityQueue | PriorityQueue non FIFO |
| Deque | FIFO + LIFO | Non (ArrayDeque) | ArrayDeque, LinkedList | Opérations complètes aux deux extrémités |
| PriorityQueue | Ordonnée par priorité | Non | PriorityQueue | Supprime d’abord l’élément le plus petit |
| BlockingQueue | FIFO thread-safe | Non | ArrayBlockingQueue, LinkedBlockingQueue | différences entre add/offer et put |
| ConcurrentLinkedQueue | FIFO lock-free | Non | ConcurrentLinkedQueue | Très rapide pour le multi-threading |
