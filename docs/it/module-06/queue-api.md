# 27. API Queue & Deque

### Indice

- [27. API Queue & Deque](#27-api-queue--deque)
  - [27.1 Queue — Panoramica](#271-queue--panoramica)
    - [27.1.1 Metodi Principali di Queue](#2711-metodi-principali-di-queue)
    - [27.1.2 Implementazioni di Queue](#2712-implementazioni-di-queue)
  - [27.2 Deque — Panoramica](#272-deque--panoramica)
    - [27.2.1 Metodi Principali di Deque](#2721-metodi-principali-di-deque)
    - [27.2.2 Implementazioni di Deque](#2722-implementazioni-di-deque)
  - [27.3 Usare una Queue](#273-usare-una-queue)
  - [27.4 Usare una Deque come Queue e come Stack](#274-usare-una-deque-come-queue-e-come-stack)
    - [27.4.1 Esempio FIFO (Comportamento Queue)](#2741-esempio-fifo-comportamento-queue)
    - [27.4.2 Esempio LIFO (Comportamento Stack)](#2742-esempio-lifo-comportamento-stack)
  - [27.5 PriorityQueue — Queue Speciale](#275-priorityqueue--queue-speciale)
  - [27.6 Blocking Queue (Basi)](#276-blocking-queue-basi)
  - [27.7 Trappole Comuni](#277-trappole-comuni)
  - [27.8 Tabella Riassuntiva](#278-tabella-riassuntiva)

---

Le interfacce `Queue` e `Deque` di Java modellano collezioni ordinate progettate per elaborare elementi in una sequenza specifica.

Una **Queue** modella tipicamente una struttura **FIFO** (First-In, First-Out).  
Una **Deque** (`double-ended queue`) consente inserimento e rimozione da entrambe le estremità, permettendo comportamenti **FIFO** e **LIFO** in una singola API.

## 27.1 Queue — Panoramica

L’interfaccia `Queue` estende `Collection` ed è comunemente utilizzata nella programmazione asincrona, nella distribuzione del carico, negli algoritmi e nel buffering.

Esistono due famiglie di metodi: quelli che **lanciano eccezioni** e quelli che **restituiscono valori speciali** (di solito `null`).

### 27.1.1 Metodi Principali di Queue

| Operazione | Lancia Eccezione | Restituisce Valore Speciale | Descrizione |
|-----------|------------------|------------------------------|-------------|
| Inserimento | `add(e)` | `offer(e)` | Aggiunge un elemento; `offer` è preferibile per queue con capacità limitata |
| Rimozione | `E remove()` | `E poll()` | Rimuove e restituisce la testa. `remove()` lancia NoSuchElementException se la queue è vuota, `poll()` restituisce null |
| Lettura | `E element()` | `E peek()` | Restituisce la testa senza rimuoverla. `element()` lancia NoSuchElementException se la queue è vuota, `peek()` restituisce null |

### 27.1.2 Implementazioni di Queue

Classi comuni che implementano `Queue`:

- `LinkedList` — non limitata, implementa anche `Deque` e `List`.
- `ArrayDeque` — queue veloce basata su array ridimensionabile; non può contenere `null`.
- `PriorityQueue` — ordina gli elementi per ordine naturale o comparator; non è FIFO.
- `ConcurrentLinkedQueue` — thread-safe, lock-free.

!!! note
    `PriorityQueue` non garantisce che l’ordine di iterazione corrisponda all’ordinamento per priorità.

!!! warning
    La maggior parte delle implementazioni di Queue rifiuta `null` perché `null` è usato come valore di ritorno per “vuoto”.

---

## 27.2 Deque — Panoramica

`Deque` (double-ended queue) supporta inserimento, rimozione e ispezione sia dalla testa sia dalla coda.

È più versatile di una Queue:  
- FIFO (simile a una queue)  
- LIFO (simile a uno stack)  
- Algoritmi bidirezionali

### 27.2.1 Metodi Principali di Deque

| Operazione | Fronte | Fondo |
|-----------|--------|-------|
| Inserimento | addFirst(e), offerFirst(e) | addLast(e), offerLast(e) |
| Rimozione | removeFirst(), pollFirst() | removeLast(), pollLast() |
| Ispezione | getFirst(), peekFirst() | getLast(), peekLast() |

### 27.2.2 Implementazioni di Deque

- `ArrayDeque` — implementazione consigliata per uso generale (veloce, senza limite di capacità).
- `LinkedList` — completa ma più lenta a causa della struttura a nodi.
- `ConcurrentLinkedDeque` — deque concorrente non bloccante.

!!! note
    `Stack` è legacy; usare `Deque` per il comportamento di stack (push/pop).
    Le operazioni di queue di ArrayDeque e LinkedList (add/remove/peek) sono O(1) ammortizzato.

---

## 27.3 Usare una Queue

```java
Queue<String> q = new LinkedList<>();

q.offer("A");
q.offer("B");
q.offer("C");

System.out.println(q.peek());   // A
System.out.println(q.poll());   // A
System.out.println(q.poll());   // B
System.out.println(q.poll());   // C
System.out.println(q.poll());   // null (queue vuota)
```

---

## 27.4 Usare una Deque (come Queue e come Stack)

### 27.4.1 Esempio FIFO (Comportamento Queue)

```java
Deque<String> dq = new ArrayDeque<>();

dq.offerLast("A"); // enqueue
dq.offerLast("B");
dq.offerLast("C");

System.out.println(dq.pollFirst()); // A
System.out.println(dq.pollFirst()); // B
System.out.println(dq.pollFirst()); // C
```

### 27.4.2 Esempio LIFO (Comportamento Stack)

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

## 27.5 PriorityQueue — Queue Speciale

`PriorityQueue` ordina gli elementi per **ordine naturale** o tramite un `Comparator` fornito.

Caratteristiche importanti:

- Non FIFO — la testa è l’elemento “più piccolo”.
- L’ordine è garantito solo durante la rimozione, non durante l’iterazione.
- Gli elementi `null` non sono consentiti.

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

## 27.6 Blocking Queue (Basi)

Negli ambienti concorrenti, il package `java.util.concurrent` fornisce tipi di queue bloccanti.

- `ArrayBlockingQueue` — array sottostante a dimensione fissa.
- `LinkedBlockingQueue` — opzionalmente limitata.
- `PriorityBlockingQueue` — priority queue thread-safe.
- `DelayQueue` — elementi rilasciati dopo un ritardo.

!!! note
    BlockingQueue non consente mai `null`.
    put(e) — blocca finché c’è spazio disponibile
    take() — blocca finché un elemento è disponibile
    BlockingQueue supporta anche operazioni temporizzate: offer(e, timeout), poll(timeout)

---

## 27.7 Trappole Comuni

- I metodi di `Queue` e `Deque` esistono in varianti “con eccezione” e “con valore speciale” — memorizzare quali sono quali.
- `ArrayDeque` non può contenere `null` — `null` è usato internamente.
- L’ordine di iterazione di `PriorityQueue` NON è ordinato.
- L’uso di `Stack` è sconsigliato; usare invece `Deque`.
- Deque consente sia FIFO sia LIFO e ha l’API **più completa**.

---

## 27.8 Tabella Riassuntiva

| Interfaccia | Comportamento Tipico | Null Consentito? | Implementazioni Comuni | Note |
|------------|----------------------|------------------|------------------------|------|
| Queue | FIFO | Dipende | LinkedList, ArrayDeque, PriorityQueue | PriorityQueue non FIFO |
| Deque | FIFO + LIFO | No (ArrayDeque) | ArrayDeque, LinkedList | Operazioni complete a doppia estremità |
| PriorityQueue | Ordinata per priorità | No | PriorityQueue | Rimuove prima l’elemento più piccolo |
| BlockingQueue | FIFO thread-safe | No | ArrayBlockingQueue, LinkedBlockingQueue | differenze tra add/offer e put |
| ConcurrentLinkedQueue | FIFO lock-free | No | ConcurrentLinkedQueue | Molto veloce per il multi-threading |
