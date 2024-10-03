#import "@preview/touying:0.4.2": *
// #import "@preview/a2c-nums:0.0.1": int-to-cn-ancient-num
#import "@preview/octique:0.1.0": *
#import "@preview/lovelace:0.3.0": *
#import "@preview/ctheorems:1.1.2": *
#show: thmrules.with(qed-symbol: $square$)

#set page(width: 16cm, height: auto, margin: 1.5cm)
#set heading(numbering: "1.1.")

#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em)).with(numbering: none)

#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")
#let problem = thmbox("problem", "Problem", fill: rgb("#eeffee")).with(numbering: none)

// Functions
#let linkto(url, icon: "link") = link(url, box(baseline: 30%, move(dy: -.15em, octique-inline(icon))))
#let keydown(key) = box(stroke: 2pt, inset: .2em, radius: .2em, baseline: .2em, key)

#let s = themes.university.register(
  aspect-ratio: "16-9",
  footer-a: self => self.info.author,
  footer-c: self => h(1fr) + utils.info-date(self) + h(1fr) + states.slide-counter.display() + h(1fr)
)
#let s = (s.methods.info)(
  self: s,
  title: [Briefly, what is a Matroid #footnote[#text(weight: "regular")[The title is borrowed from https://www.math.lsu.edu/~oxley/matroid_intro_summ.pdf \ \ ]]],
  author: [丛宇],
  date: datetime(year: 2024, month: 8, day: 13),
  institution: [UESTC],
)

// NO SECTION SLIDES
#(s.methods.touying-new-section-slide = none)

// #let s = (s.methods.datetime-format)(self: s, "[year] 年 [month] 月 [day] 日")
// hack for hiding list markers
#let s = (s.methods.update-cover)(self: s, body => box(scale(x: 0%, body)))

// // numbering
// #let s = (s.methods.numbering)(self: s, "1.")

// // handout mode
// #let s = (s.methods.enable-handout-mode)(self: s)

#let (init, slides, touying-outline, alert) = utils.methods(s)
#show: init

// global styles
#set text(font: ("IBM Plex Serif", "Source Han Serif SC", "Noto Serif CJK SC"), lang: "zh", region: "cn")
#set text(weight: "medium")
#set par(justify: true)
#set raw(lang: "typ")
#set underline(stroke: .05em, offset: .25em)
#show raw: set text(font: ("IBM Plex Mono", "Source Han Sans SC", "Noto Sans CJK SC"))
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: .3em, y: 0em),
  outset: (x: 0em, y: .3em),
  radius: .2em,
)
#show raw.where(block: true): set par(justify: false)
#show strong: alert

#let (slide, empty-slide, title-slide, focus-slide) = utils.slides(s)
#show: slides

= independence structure
== Matroids
#slide[
#set text(weight: "regular",size: 0.8em)

A _matroid_ is an important structure in combinatorial optimization, which generalizes the notion of linear independence in vector spaces.

#definition("Matroid")[
  A matroid $M$ is a pair $(E,cal(I))$, where $E$ is a finite set (ground set) and $cal(I)$ is a family of subsets of $E$ (independence sets). The family $cal(I)$ satisfies the following properties:
  - $emptyset in cal(I)$
  - If $I in cal(I)$ and $J subset.eq I$, then $J in cal(I)$
  - If $I, J in cal(I)$ and $|I| < |J|$, then there exists an element $x in J - I$ such that $I union {x} in cal(I)$.
]
Matroid is a blueprint for what independence should mean.
]

== combinatorial optimization
#slide[
combinatorial optimization ≈ optimize over discrete structures
#show: columns.with(2)
#set text(size: 0.8em)
#figure(
  numbering: none,
  image("images/knapsack.png", width: 40%),
  caption: [
    #text(size: 0.6em)[The knapsack problem is a classic \ combinatorial optimization problem. \ The goal is finding the most valuable combination of items that can be fit into a knapsack of limited capacity.]
  ]
)

#colbreak()
#set par(justify: false)
CO problems are often NP-hard.

However, some discrete structures allow efficient optimization algorithms.

#v(2em)

#highlight[Matroid] is such a structure.
]


= from an algebraic perspective

== linearly independent sets

#slide[
#set text(size: 0.6em)
Matrix is just a rectangular array of numbers, e.g.,
#set math.mat(delim: "[")
$
mat(
  1, 2, ..., 10;
  2, 2, ..., 10;
  dots.v, dots.v, dots.down, dots.v;
  10, 10, ..., 10;
)
$
set of column vectors
$
mat(
vec(1,2,dots.v,10), ..., vec(10,10,dots.v,10))
$
The family of linearly independent columns forms a matroid.

][
  #set text(size:0.6em)
  $cal(I)=$ the family of linearly independent columns vectors

  - $emptyset in cal(I)$ #text(fill: olive)[(trivially true)]
  - If $I in cal(I)$ and $J subset.eq I$, then $J in cal(I)$ #text(fill: olive)[(subsets of linearly independent columns are linearly independent!)]
  - If $I, J in cal(I)$ and $|I| < |J|$, then there exists an element $x in J - I$ such that $I union {x} in cal(I)$. #text(fill: olive)[(this is the Steinitz exchange lemma in linear algebra. #linkto("https://en.wikipedia.org/wiki/Steinitz_exchange_lemma"))]

  #v(2em)
  This matroid is called the _vector matroid_.
]

= from the perspective of graph theory
== Spanning Trees
#slide[
#set text(size: 0.6em)
A _spanning tree_ of a graph $G=(V,E)$ is a subgraph of $G$ and contains all the vertices of $G$ but no cycle.

#figure(
  numbering: none,
  image("images/spanningtree.png", width: 50%),
  caption: [
    #text(size: 0.6em)[A graph with 6 vertices and 8 edges.\ The 3 red edges form a cycle. \ The 5 green edges form a spanning tree.]
  ]
)

][
  #set text(size: 0.6em)
  $E=$ the set of edges in $G$ \
  $cal(I)=$ the family of trees(subgraphs without cycles)

  - $emptyset in cal(I)$ #text(fill: olive)[(trivially true)]
  - If $I in cal(I)$ and $J subset.eq I$, then $J in cal(I)$ #text(fill: olive)[(subset of  a tree is still a tree!)]
  - If $I, J in cal(I)$ and $|I| < |J|$, then there exists an element $x in J - I$ such that $I union {x} in cal(I)$. #text(fill: olive)[(try to prove it )]

  #v(2em)
  This matroid is called the _graphic matroid_.
]

= from the perspective of optimization
== Greedy Algorithm
#slide[
#set text(size: 0.6em)
#problem("optimization over matroids")[
  Given a matroid $M=(E,cal(I))$ and a weight function $w:E arrow.r R^+$, find a maximum-weight independent set.
]

#figure(
  numbering: none,
  pseudocode-list(hooks: .5em,booktabs: true, title: smallcaps[Max-Weighted Independent Set])[
  + let $E={e_1,...,e_n}$ such that $w(e_1) >= w(e_2) >= ... >= w(e_n)$
  + $x arrow.l emptyset$
  + *for* $i=1$ to $n$ do
    + *if* $X union {e_i} in cal(I)$ *then*
      + $X arrow.l X union {e_i}$
  + *return* $X$
  ]
)<alg>

- For vector matroids, the greedy algorithm is conceptually the same as Gaussian elimination.
- For graphic matroids, the greedy algorithm is the same as Kruskal's algorithm.
]