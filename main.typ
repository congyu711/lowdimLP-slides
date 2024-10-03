#import "@preview/touying:0.5.2": *
#import themes.university: *
#import "@preview/cetz:0.2.2"
#import "@preview/fletcher:0.5.1" as fletcher: node, edge
#import "@preview/ctheorems:1.1.2": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/octique:0.1.0": *
#import "@preview/lovelace:0.3.0": *

// cetz and fletcher bindings for touying
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

// Theorems configuration by ctheorems
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")

// font settings
#set text(font: ("IBM Plex Serif", "Source Han Serif SC", "Noto Serif CJK SC"), lang: "zh", region: "cn")
#set text(weight: "medium")
#set par(justify: true)
#set raw(lang: "typ")
#set underline(stroke: .05em, offset: .25em)
#show raw: set text(font: ("IBM Plex Mono", "Source Han Sans SC", "Noto Sans CJK SC"))
#show link: underline

// functions
#let linkto(url, icon: "link") = link(url, box(baseline: 30%, move(dy: -.15em, octique-inline(icon))))

#show: university-theme.with(
  aspect-ratio: "16-9",
  // config-common(handout: true),
  config-info(
    title: [Linear Programming \ in Low Dimensions],
    // subtitle: [LP in Low Dimensions],
    author: [丛宇],
    date: datetime.today(),
    institution: [UESTC],
    // logo: emoji.school,
  ),
  footer-b: [LP in Low Dimensions],
  config-common(new-section-slide-fn: none),
)
#show figure.caption: set text(14pt)

#set heading(numbering: numbly("{1}.", default: "1.1"))
#show footnote: set text(16pt)


#title-slide()

// == Outline <touying:hidden>

// #components.adaptive-columns(outline(title: none, indent: 1em))

= LP is relevant to the course!
== What is LP?

#definition(numbering: none)[
  A linear program (LP) is an optimization problem of the form:
  $ max & c^T x \
    s.t. quad A x &>= b \
      x & >= 0 $
]

LPs are easy to solve #pause #highlight[in low dimensions.]

== LP in Machine Learning

Machine learning is full of convex optimization problems. Why focus on the special case of LP?

- Solving LPs are fast (compared to convex optimization problems)  e.g. #link("https://www.sciencedirect.com/science/article/pii/S0031320301002102")[linear programming SVM]
- #link("https://www.cs.princeton.edu/~bee/courses/scribe/lec_10_07_2013.pdf")[Sparse Linear Models]
- #link("https://web.stanford.edu/~yyye/NeurIPSOPT.pdf")[Online learning via LPs]
- ...

= Theoretical view

== LP in $d$ Dimension

For fixed dimensions, LPs can be solved in linear time!

#figure(
  image("images/table.png", width: 90%),
  caption: [table stolen from #link("https://dl.acm.org/doi/10.1145/3155312")],
  numbering: none,
)

== Seidel's Algorithm - $O(d!n)$

The well-loved randomized algorithm is extremely simple.


#figure(
  image("images/2dlp_1.png", width: 55%),
  caption: [LPs are just finding an extreme point in some direction in a polytope.\ #link("https://www.cs.cmu.edu/~15451-f15/lectures/lect1021-lpII.pdf")],
  numbering: none,
)

Let's add in the constraints one at a time and keep track of the current optimal solution $x^*$.

After adding a new constraint $a_m dot x <= b_m$, there will be two cases,

1. $x^*$ satisfies the new constraint,
2. $x^*$ does not satisfy the new constraint.

#set text(22pt)

#figure(
  grid(columns: 2, gutter: 2mm, 
  image("images/2dlp_2.png", fit: "contain"), 
  image("images/2dlp_3.png", fit: "contain")),
  numbering: none,
)
The new optimal $x^*$ should locate on a $d-1$ dimension hyperplane \ $a_m dot x = b_m$. 

// We can map every other constraints on $a_m dot x = b_m$!



Assume that our $d$ dimensional LP is feasible and the optimal $x^*$ is qnique. Then $x^*$ is defined by exactly $d$ constraints(hyperplanes). 
#figure(
  numbering: none,
```
algorithm seidel(S, f, X) is
    R := empty set
    B := X
    for x in a random permutation of S:
        if f(B) ≠ f(B ∪ {x}):           // case 2
            B := seidel(R, f, X ∪ {x})
        R := R ∪ {x}
    return B
```
)

Case 2 is more expensives than 1. What is the chance of getting case 2 when inserting the $m$'th constraint?

If we are inserting constraints in a random order,
$ P(text("case 2")) <= (d-|X|)/m <= d/m $


#figure(
  numbering: none,
```
algorithm seidel(S, f, X) is
    R := empty set
    B := X
    for x in a random permutation of S:
        if f(B) ≠ f(B ∪ {x}):           // case 2
            B := seidel(R, f, X ∪ {x})
        R := R ∪ {x}
    return B
```
)

#text(size: 18pt, [We need $O(d)$ time to do the violation test for case 2. 
Let the expected number of violation tests be $T(s,x)$,

$ T(s,x) <= sum_(i=d)^s (d-x)/i (1+T(i,x+1)) $

After solving the recurence, we get $T(s,x)=O(d!s)$. Thus Seidel's alg has expected complexity $O(d!n)$ on any $d$-dimension LP with $n$ constraints.])