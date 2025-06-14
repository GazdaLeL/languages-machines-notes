#import "lib.typ" : *
#import "@preview/finite:0.5.0": automaton

#let title = [Languages and Machines]
#set page(
   paper: "a4",
   header: align(left, title),
   numbering: "1",
)

#align(center, text(17pt)[
   *#title*
   
   Matteo Bongiovanni\
   Roman Gazarek
])

= Regular Languages
== Operations
- $L = {a a, b b}$ and $M = {c, d}$ then $L M = {a a c, a a  d, b b c, b b d}$
- ${a,b, a b}^2 = {a a, a b, a a b, b a, b b, b a b, a b a, a b b, a b a b}$
- ${a,b}^* = {epsilon} union {a, b} union {a a, b b, b a, b b} union {a a a...}$
- ${a b, c d}^R = {b a, d c}$ 

== Definitions
Recursively defined over an alphabet $Sigma$ from
  - $emptyset$
  - ${epsilon}$
  - ${a}$ for all $a in Sigma$
by applying union, concatenation, and Kleene star.

*Regular Expressions*: A notation to denote regular languages
- Example: $a^*(c|d)b^*$ denotes the *regular set* ${a}^*({c}union{d}){b}^*$
- The regular expression of a set is not unique

== Limitations of regular languages
- Can only read left to right
- Finite and bounded memory
- Can only keep track of bounded history

== Proving that a language is not regular
\
*Example 1: $L_1 = {a^n b^n | n >= 1}$*\
A proof that $L_1$ is not regular:
- If $L_1$ is regular, it would be accepted by a *DFSM* $M$
- Machine M has a finite number of states, $k$
- Consider the action of $M$ on input $a^n b^n$, with $n >> k:$\
// "Trust me bro typst is so much nicer than Latex" 
#align(center)[#text(blue)[[q0]] #math.underbrace($a a a a a a a a a$, $n$) #math.underbrace($b b b b b b b b b$, $n$) #text(blue)[[$q_f$]]]

- By the pigeonhole principle (those who know), there is a state $q_i$ that is visited more than once in processing the sequence of $a$'s:
#align(center)[#text(blue)[[$q_0$]] #math.overbrace($a a a a$ +text(blue)[[$q_i$]] + $a a$ + text(blue)[[$q_i$]] + $a a$, $n$) #math.overbrace($b b b b b b b b b$, $n$) #text(blue)[[$q_f$]]]

- Let's split $a^n b^n$ into three pieces $(u,v,w)$ according to $q_i$:

#align(center)[
  #text(blue)[[$q_0$]]
  #math.underbrace($a a a a$, $u$) #text(blue)[[$q_i$]] #math.underbrace($a a$, $v$) #text(blue)[[$q_i$]]#math.underbrace($a a b b b b b b b b b$, $w$) #text(blue)[[$q_f$]
  ]
]

#align(center)[We have: #math.underbrace($accent(delta, "^")(q_0, u)=q_i$, $-->$), #math.underbrace($accent(delta, "^")(q_i, v)=q_i$, $arrow.ccw$), and #math.underbrace($accent(delta, "^")(q_i, w)=q_f in F$, $-->$).]

What does $arrow.ccw$ mean?
- We could erase $v$ and the obtained string would be accepted!

#align(center)[
  #text(blue)[[$q_0$]] #math.underbrace($a a a a$, $u$) #text(blue)[[$q_i$]] #math.underbrace($a a b b b b b b b b b$, $w$) #text(blue)[[$q_f$]]
  ]
#align(center)[This is wrong: $u w = a^(n-j)b^n in L(M)$ but $u w in.not L_1$]
- We could even insert extra copies of $v$ and the resulting string would also be accepted.

*Example 2: $L_2 = { a^(2^n) | n > 0}$*

- A DFSM $M$ with $k$ states, with $L(M) = L_2$ and start state $q_0$
- Let $n >> k$ and consider the action of $M$ on scanning string $a^(2^n)$
- By pigeonhole principle, $M$ must repeat a state $q$ while scanning the first $n$ symbols of $a^(2^n)$
- Now let $i,j,m$ be such that $2^n=i+j+m$, with $0 < j <= n$ and
#align(center)[
  $accent(delta, "^")(q_0, a^i)=q, accent(delta, "^")(q, a^j) = q, accent(delta, "^")(q, a^m) = q_f in F$
]
- Alternatively:
#align(center)[
  #text(blue)[[$q_0$]] 
  #math.overbrace(
    math.underbrace($a a a a a a a a a a$, $i$) +
    math.underbrace($a a a a a$, $j$) + math.underbrace($a a a a a a a a a a a a a a a a$, $m$), $2^n$
  )
  #text(blue)[[$q_f$]]
]

- Now given $accent(delta, "^")(p, a^j) = p$, we could insert an extra $a^j$, to get $a^(2^n + j)$, and the resulting string would be erroneously accepted:

#align(center)[
  #text(blue)[[$q_0$]]
  #math.underbrace($a a a a a a a a a a$, $i$)
  #text(blue)[[$q$]]
  #math.underbrace($a a a a a$, $j$)
  #text(blue)[[$q$]]
  #math.underbrace($a a a a a$, $j$)
  #text(blue)[[$q$]]
  #math.underbrace($a a a a a a a a a a a a a a a a$, $m$)
  #text(blue)[[$q_f$]]
]

#align(center)[Indeed, we can derive $accent(delta, "^")(q_0, a^(2^n + j)) = q_f in F$]

- But this is wrong, because $2^n + j$ is not a power of 2:

#align(center)[
  $2^n + j <= 2^n + n$\
  $2^n + j < 2^n + 2^n$\
  $= 2^(n +1)$\
  $2^(n+1)$ is the next power of $2$ greater than $2^n$
]

Apparently this is a contradiction.

== Regular Expressions
Regular Expression Identities : \
- $emptyset u = u emptyset = emptyset$
- $epsilon u = u epsilon = u$
- $emptyset^* = emptyset$
- $epsilon^* = epsilon$
- $u | v = v | u$
- $u | emptyset = u$
- $u | u = u$
- $u(v | w) = u v | u w$
- $(u | v)w = u w | v w$
- $u^* = (u^*)^*$
- $(u | v)^* = (u^* | v)^* = u^*(u | v)^* = (u | v u^*)^* = (u^* v^*) = u^*(v u^*)^* = (u^* v u^*)^*$


== DFSM, NFSM, N$epsilon$FSM

A *deterministic finite state machine (DFSM)* is a quintuple $M = (Q, Sigma, delta, q_0, F)$ where:
- $Q$ is a finite set of states
- $Sigma$ is the input alphabet
- $delta : Q times Sigma -> Q$ is the _transition function_
- $q_0$ is the initial state
- $F subset.eq$ is a set of _accepting_ (or _final_) states\
When symbol $a$ is read in a state $q_n$, the state becomes $delta (q_n, a)$.
#align(center, automaton(
  (
  q0: (q1: "a"),
  q1: (),
  ),
  labels: (q0: $q_n$, q1: $q_i$)
  ))
#align(center, text(12pt)[
  $delta(q_n, a) = q_i$
])

- *Determinism*
 - A system that is deterministic will always produce the same output/behaviour for a given input from a given starting state

- *Non-determinism*
 - A system is nondeterministic if it may produce a different output when running with the same input in the same state.

A *Non-deterministic finite state machine (NFSM)* is a quintuple $M = (Q, Sigma, delta, q_0, F)$ where:
- $Q$ is a finite set of states
- $Sigma$ is the input alphabet
- $delta : Q times Sigma -> PP(Q)$ is the _transition function_

#bluebox("Important Note!!!")[- $PP(Q)$ denotes the set of all subsets $Q$]

- $q_0$ is the initial state
- $F subset.eq$ is a set of _accepting_ (or _final_) states\
#bluebox("Important Note v.2!!!")[
- When symbol $a$ is read in a state $q$, the next state is in the set $delta (q, a)$.
// Cringe typst moment
- We define $(q, a w) tack.r""_M (q',w)$ if $q' in delta(q, a)$.
]

An *N$epsilon$FSM* is a quintuple $M = (Q, Sigma, delta, q_0, F)$ where:
- $Q$ is a finite set of states
- $Sigma$ is the input alphabet
- $delta : Q times (Sigma union {epsilon}) -> PP(Q)$ is the _transition function_

- $q_0$ is the initial state
- $F subset.eq$ is a set of _accepting_ (or _final_) states

$delta(q_n, epsilon):$ Set of states reachable from $q_n$ without reading input:

#align(center, automaton(
  (
    // For some reason doing $epsilon$ doesn't work
  q0: (q1: "\u{03b5}"),
  q1: (),
  ),
  labels: (q0: $q_n$, q1: $q_i$),
))

- For the transition relation we have
 - $(q, a w) tack.r""_M (q', w)$ if $q in delta(q, a);$
 - $(q, w) tack.r""_M (q', w)$ if $q' in delta(q, epsilon)$.


== FSM to regular expression
== FSM minimization
== Pumping lemma for regular languages
Dumbass lemma. You have a sufficiently long string, find a substring which you can pump (repeat an arbitrary amount of times),bam you've proven a language is not regular.
== Regular grammars
A grammar $(V, Sigma, P, S)$ is *regular* if every production rule in $P$ has one of the following forms $(a in Sigma$ and $A, B in V)$:
- $A -> a B$ or
- $A -> epsilon$
A language is regular *iff* it is generated by a regular grammar.\
*Example*: A non-regular grammar for the regular expression $(a b)^* a^*$:\
#align(center, text(12pt)[$S -> a b S A | epsilon \ A -> A a | epsilon $])\
An equivalent regular grammar:\
#align(center, text(12pt)[$S -> a B | epsilon \ B -> b S | b A \ A -> a A | epsilon$])

=== Useful, Generating & Generated Sumbols
Let $G = (V , Sigma, P, S )$ be a grammar. Let $x in V union Sigma $ be a symbol.
- x is *useful* if there is a derivation\
#align(center, text(12pt)[ $S =>""^* u x v =>""^* w$ with $u, v in (V union Sigma)^*$ and $w in Sigma^*$])
- x is called *useless* if it is not useful
- x is *generating* if $x =>""^* w$ holds for some $w in Sigma^*$
- x is *generated* if there are $u, v in (V union Sigma)^*$ with $S =>""^* u x v$.
Therefore:
- Useful symbols are both generating and generated
- However, generating and generated symbols may not be useful

== Closure properties

- _Union_, _concatenation_, _Kleene Star_:\ Immediate by considering regular expressions
- _Complement_:\Obtain a DFSA $M$ of the given language, and define another DFSA $M'$ in which the accepting states of $M$ become non-accepting states of $M'$, and vice versa
- _Intersection_: Two possibilities:\

TODO: Fix this (typst moment)
+ Use the law $L_1 inter L_2 = #overline[#overline[$L_1$] $union$ #overline[$L_2$]]$ (and reduce the cases above)
+ Define a construction that runs two DFSAs in "parallel"\
Given $M_i = (Q_i, Sigma, delta_i, q_i, F_i)$ (with $i in {1,2}$), define $M=(Q_1 times Q_2, Sigma, delta, (q_1,q_2), F_1 times F_2)$, where $delta((p,q),a) = (delta_1(p,a),delta_2(q,a))$.

- _Reversal_: Given a machine $M$ and create a machine $M^R$ by:
 - convert $M$ to normal form
 - reverse all arcs in the state diagram
 - swap the starting and the accepting states

= Context-free languages
== Definitions
*Context-Free Grammars*\
A Formal system used to generate the strings of a language. A quadruple ($V, Sigma, P, S$) where\
- $V$ is a set of *variables* or *nonterminals*
- $Sigma$ is an alphabet of *terminals*, disjoint from $V$
- $P$ is a finite set of *production rules*, taken from set $V times (V union Sigma)^*$. We write $A arrow$ instead of $(A, w)$.
- $S in V$ is the *start symbol*.
== PDM
== CFG to PDM
== Closure properties and proofs
== making a grammar productive


/* Maybe irrelevant?
= Context-sensitive
== Linearly-bounded Machines
*/

= Decidable and semi-decidable languages
== Definitions
== TMs
- Computing a function vs recognizing a language
- Acceptance criteria
- Multi-track, multi-tape, nondeterministic
== Proving decidability, semi-decidability or undecidability


= Support lecture

== Pumping lemma

Prove tht L is not regular by the pumping lemma


There exists a $k >= 0$ such that
for every $z in L "for which" |z| >= k$, there exists a splitting
$z = u v w$ with $|u v| <= k$ and $v != epsilon$ such that
for every $i >= 0$ we have $u v^i w in L$

$forall exists forall exists$


$ L = {w w | w in {a, b}^*} $

Take $z = a^k b a^k b$ By the PL, there is a splitting $z = u v w$ such that $|u v| <= k$
and $v != epsilon$

Because the first $k$ symbols are all 'a'

$
 u = a^i, v = a^j, i + j <= k \
 w = a^(k - i - j) b a^k b
$

$z = u v^0 w$ is not in $L$ (prove), so $L$ is nonregular


