# Experimental!
I ~ "git: github.com/Marcos-cat/iris" ~ Color Draw Key Mouse Screen Texture

StartSize ← ℂ500 600

I~Open StartSize "Minesweeper"
Screen!°FPS 30

BarHeight        ← 80
FlagTx           ← Texture~LoadFile "./flag.png"
BarColor         ← Color~Hex "#79b139"
BackgroundColors ← Color~Hex "#e5c29f"_"#d7b899"
CoverColors      ← Color~Hex "#aad751"_"#99d149"
ColorPalette     ← Color~Hex "#1976d2"_"#388e3c"_"#d32f2f"_"#7b1fa2"_"#ff8f00"_"#0b99a2"_"#ed44b5"

~ {
  Difficulty
  Mines
  GridSize
  TileSize
  StartTime ← now
  EndTime ← ∞
  Covered ← ∞
  Flags ← ∞
  MineColors ← ∞
  BackgroundTx ← ∞
  NumbersTx ← ∞
  CoverTx ← ∞
}
ScreenSize ← +BarHeight /ℂ ⇌×⊃TileSize GridSize
Numbers    ← ⧈(⧻⊚) ⬚1↯3 3_3 Mines
BlankAreas ← ±⧈(⧻⊚) ⬚1↯3 3_3 =0Numbers
FlagsLeft  ← -∩(⧻⊚)⊃Flags Mines
Time       ← ⌊ -⊃(StartTime|↧nowEndTime)
LayoutGrid ← ⍥₂/≡⊂≡₀(
  ↻⟜(⌝↘×₂)⊟0⊃÷₅(layout⊙⊃(Color: ⬚White˜⊏ColorPalette-₁|˜⊏⊂@ +@1⇡9))
)
Checker    ← ⊏◿₂/+°⍉⇡GridSize
TilePx     ← +ℂ0BarHeight +˙ℂ÷₂⟜×⊃(⋅TileSize|I~T!°Coords ≡⇌⊚)
TileIdx    ← ˜⊟°ℂ⌊˜÷⊙TileSize -ℂ0BarHeight
DrawScreen ← Draw~Texture⊙⊃(-BarHeight ScreenSize|0_BarHeight)

Won     ← ≍⊃Covered Mines
Lost    ← ±⧻⊚×¬⊃Covered Mines
Playing ← ¬∨⊃Won Lost

Init ← (
  °⊸MineColors ˜°⊸⧻ °⍆ColorPalette ⊸Mines
  °⊸Mines ⊸(⍜⊙♭(°⍆ ⍜↙↥₁) ⊃(Mines|˜↯0GridSize))
  °⊸Covered ˜↯1⊸GridSize
  °⊸Flags ˜↯0⊸GridSize
  °⊸CoverTx ⊸(Texture~LoadImage°⊸Color~Alpha 1 ˜Checker CoverColors)
  °⊸BackgroundTx⊸(Texture~LoadImage ˜Checker BackgroundColors)
  °⊸NumbersTx ⊸(Texture~LoadImage LayoutGrid⊃(TileSize|×⊃(¬Mines|Numbers)))

  I~Screen!°Size ⊸ScreenSize
)

EasyGame   ← (Init New "Easy" 10 8_10 100)
MediumGame ← (Init New "Medium" 32 12_16 80)
HardGame   ← (Init New "Hard" 64 16_20 60)

SelectionScreen ← ⋅(
  Draw~Background BarColor
  {"Difficulty" "[E]asy" "[M]edium" "[H]ard"}
  Draw~Text White 70 +ℂ100 100 0_100_200_300
  Draw~Centered~Text White 40 +250 ÷₂StartSize "Press [R] to replay"
  ⨬(EasyGame|MediumGame|HardGame|0) ⊗1 I~Key~Pressed "EMH"
)

DrawBar ← (
  ⊸(Draw~Rect BarColor °⊸(◌°ℂ) BarHeight ScreenSize ⊙0_0)
  {⊃(Difficulty|$"Flags Left: _" FlagsLeft|$"Time: _" Time)}
  Draw~Text White 40 ℂ⊙20 20_200_540
)

Interact ← (
  Mouse!Pressed‼Right(⨬◌(⍜(⊡⊙Flags)¬) ◡(×⊃(⊡⊙Covered|±FlagsLeft◌)) ⊸TileIdx)
  Mouse!Pressed‼Left(
    ◡(¬⊡⊙Flags) ⊸TileIdx
    ⨬◌(⊙◡⋅BlankAreas ◡(=0⊡⊙Numbers)
       ⍜⊙Covered↥⊸Flags ⍜⊙⊙⊙Covered⨬(⍜⊡↧₀◌|⍜⊜□⍚(⍥↧₀⊸˜∊∞)⊙⍜⊡⋅∞))
  )
)

EndMessage ← (
  ⍜EndTime(↧now) ⍜⊙Covered(×¬)⊸Mines ⍜⊙Flags(×¬) ⊸Mines
  ⊸(Draw~Centered~Rect ˜⊂0.6Black 500_400 ÷₂ScreenSize)
  ⊸{⊃($"You _" ⨬"Lost""Won" Won|$"_ Mode" Difficulty|$"_ Seconds" Time)}
  Draw~Centered~Text White 70 +¯100_0_100 ÷₂◡⋅ScreenSize
)

PlayingScreen ← (
  ⊸(DrawScreen⊸BackgroundTx)
  ⊸(DrawScreen⊸NumbersTx)
  ⊸(I~Draw~Circle⊃(MineColors|÷₄TileSize|TilePx⊸Mines))
  ⊸(DrawScreen⊸CoverTx)
  ⊸(I~Draw~Centered~Texture⊃(FlagTx|˙ℂ×0.7TileSize|TilePx⊸Flags))
  ⊸(I~Draw~Square ˜⊂0.2White ⟜⍜(÷⊙(-ℂ0BarHeight)|⌊) TileSize⊙I~Mouse~Pos)
  ⊸DrawBar

  ⨬(EndMessage|Interact) ⊸Playing
  ◌°⊸(Color~Alpha Texture~Image) ⊸⊃Covered CoverTx
  Key!Pressed‼@R(°Screen~Size StartSize ⋅0)
)

◌I~Loop!(⨬(PlayingScreen|SelectionScreen)⊸≍0) $Screen 0
