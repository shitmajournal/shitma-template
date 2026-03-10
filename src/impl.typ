#import "@preview/zh-kit:0.1.0" as zh-kit


#let make-venue = move(dx: -1.8cm, dy: -1.9cm, {
  box(fill: white, height: 2.5cm, inset: (x: 0.5cm, y: 0cm))[#image("./assets/sign_full.svg")]
  set text(22pt)
})

#let make-title(
  title,
  authors,
  abstract,
  keywords,
) = {
  set par(spacing: 1em)

  align(center)[
    #par(
      text(24pt, fill: rgb("252525"), title, weight: "bold")
    )
  ]
  
  v(1em)
  line(length: 75%, stroke: (paint: rgb("#252525"), thickness: 0.75pt))

  let insts = ()
  let inst_map = (:)
  let author_info(au) = (au.institution, au.city, au.country)

  for (i, au) in authors.enumerate() {
    let new_inst = author_info(au)

    if not new_inst in insts {
      insts.push(new_inst)
      
    }

    inst_map.insert(str(i), insts.len())
  }

  text(12pt,
    inst_map.pairs()
    .map(((i, inst_idx)) => box[#link("mailto:" + authors.at(int(i)).mail)[#authors.at(int(i)).name]#super[#(inst_idx)]])
    .join(", ")
  )
  parbreak()

  


  for (i, (institution, city, country)) in insts.enumerate() [
    #set text(8pt)
    #super[#(i+1)]
    #institution,
    #city,
    #country \
  ]

  v(8pt)
  set text(10pt)
  set par(justify: true)

  [
    #heading(outlined: false, bookmarked: false)[摘要]
    #text(abstract)
    #v(3pt)
    #underline(stroke: (paint: rgb("#ffde3b"), thickness: 0.5pt), offset: 3pt)[#keywords.join(text(" / "))]
  ]
  v(18pt)
}

#let template(
    title: [],
    authors: (),
    date: [],
    doi: "",
    keywords: (),
    abstract: [],
    make-venue: make-venue,
    make-title: make-title,
    body,
) = {
    set text(font: (
      (name: "New Computer Modern", covers: "latin-in-cjk"),
      (name: "Noto Serif SC"),
    ), size: 10pt)
    show heading: set text(
      font: (
        (name: "New Computer Modern", covers: "latin-in-cjk"),
        "Noto Sans SC",
      ),
      size: 11pt
    )
    set par(justify: true)
    set list(indent: 8pt)    

    set page(
      paper: "a4",
      margin: (top: 1.9cm, bottom: 1in, x: 1.6cm),
      columns: 2
    )

    show heading.where(level: 1): set text(fill: rgb("#9e6626"), size: 14pt)
    show heading: set block(below: 8pt)
    show heading.where(level: 1): set block(below: 12pt)

    place(make-venue, top, scope: "parent", float: true)
    place(
      make-title(title, authors, abstract, keywords), 
      top, 
      scope: "parent",
      float: true
    )


    show figure: align.with(center)
    show figure: set text(8pt)
    show figure.caption: pad.with(x: 10%)

    set bibliography(style: "gb-7714-2005-numeric", title: "参考文献")

    // show: columns.with(2)
    body
  }
  