# Experimental!
I ~ "git: github.com/Marcos-cat/iris"

TileSize   ← ⍣(⋕°□⊡3&args|100)
GridSize   ← ⍣(⋕°/$"_x_"°□⊡1&args|8_10)
Dims       ← ×TileSize ⇌GridSize
NMines     ← ⍣(⋕°□⊡2&args|10)
Mines      ← ⍜♭(°⍆⍜↙¬NMines) ˜↯0GridSize
Numbers    ← ⧈(⧻⊚) ⬚1↯3 3_3 Mines
BlankAreas ← ±⧈(⧻⊚) ⬚1↯3 3_3 =0Numbers

I~Open Dims "Minesweeper"
I~Screen!°FPS 30

Checker    ← ⊏◿₂/+°⍉⇡GridSize
BgTx       ← I~Texture~LoadImage Checker I~Color~Hex"#e5c29f"_"#d7b899"
CoverTx    ← I~Texture~LoadImage Checker I~Color~Hex"#aad751ff"_"#99d149ff"
LayoutGrid ← ⍉⊟⊸⌈ ⍥₂/≡⊂≡₀(↻⟜(⌝↘×₂)⊟0⊃÷₅layout)
NumbersTx  ← I~Texture~LoadImage LayoutGrid TileSize ˜⊏⊂@ +@1⇡9 ×¬Mines Numbers

Won  ← ≍Mines
Lost ← ±⧻⊚×Mines¬

⟜¬˜↯1GridSize

TilePx  ← +÷₂⟜×TileSize≡⇌⊚
TileIdx ← ˜⊟°ℂ⌊÷TileSize
◌◌I~Loop!(
  ⍥(
    I~Mouse!Pressed‼Right(⟜× ⍜𝄐⊡¬ TileIdx)
    I~Mouse!Pressed‼Left (⊸∨ ⨬⍜⊡↧₀(⍜⊜□⍚(⍥↧₀⊸˜∊∞)BlankAreas ⍜⊡⋅∞) ⊸(=0˜⊡Numbers) TileIdx)
    ⊸(◌ °⊸(I~Color~Alpha I~Texture~Image) ⊙CoverTx)
  ) ⊸(¬∨⊃Won Lost)

  I~Texture~DrawScreen BgTx_NumbersTx
  I~Draw~Circle Black ÷₄TileSize TilePx Mines
  I~Texture~DrawScreen CoverTx
  ◡⋅(I~Draw~Square Centered:1 Red ÷₂TileSize TilePx)
  I~Draw~Square ˜⊂0.2White⟜⍜÷⌊TileSize I~Mouse~Pos
  I~Draw~Text Centered:1 Black 120 ÷₂Dims ▽⊸⊓[⊃Won Lost]{"You Win :)" "You Lose :("}
)
