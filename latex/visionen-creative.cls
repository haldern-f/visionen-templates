\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{visionenlayout}[2026/11/11 A5 text-image layout variant]
\LoadClass[a5paper,twoside]{article}
\RequirePackage[
  a5paper,inner=11mm,outer=16.9mm,top=8mm,bottom=17.1mm
]{geometry}
\RequirePackage{fontspec,mathtools}
\RequirePackage[math-style=TeX,bold-style=TeX]{unicode-math}
\RequirePackage{graphicx,lettrine,luacode,enumitem,needspace,titlesec}
\RequirePackage[highlightmode=immediate]{minted}
\RequirePackage[protrusion=true,expansion=true]{microtype}
\RequirePackage{xurl,ragged2e}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{tikz}
\urlstyle{same}

\defaultfontfeatures{Path=./fonts/}
\defaultfontfeatures[
  SourceSans3-VariableFont_wght.ttf,
  SourceSans3-Italic-VariableFont_wght.ttf
]{RawFeature={+cv02,+cv03}}
\setmainfont{SourceSans3-VariableFont_wght.ttf}[
  Renderer=HarfBuzz,
  ItalicFont=SourceSans3-Italic-VariableFont_wght.ttf,
  BoldFont=SourceSans3-VariableFont_wght.ttf,
  BoldItalicFont=SourceSans3-Italic-VariableFont_wght.ttf,
  UprightFeatures={Weight=370},ItalicFeatures={Weight=370},
  BoldFeatures={Weight=700},BoldItalicFeatures={Weight=700},
  Ligatures={Common,TeX},Numbers={OldStyle,Proportional},
  RawFeature={+cv04}
]
\newfontfamily\OperatorFont{SourceSans3-VariableFont_wght.ttf}[Weight=400]
\newfontface\SectionHeadingFont{SourceSans3-VariableFont_wght.ttf}[
  Renderer=HarfBuzz,
  Weight=500,Ligatures={Common,TeX},
  Numbers={OldStyle,Proportional},RawFeature={+cv04}
]
\newfontface\SubsectionHeadingFont{SourceSans3-VariableFont_wght.ttf}[
  Weight=550,Ligatures={Common,TeX},
  Numbers={OldStyle,Proportional},RawFeature={+cv04}
]
\newfontfamily\DropCapTypeface{AkzidenzGrotesk-LightCond.otf}[Ligatures=TeX]
\newfontfamily\ArticleTitleFont{AkzidenzGrotesk-MediumCond.otf}[
  LetterSpace=-2,Ligatures=TeX
]
\newfontface\ArticleBylineFont{SourceSans3-VariableFont_wght.ttf}[
  Weight=500,Ligatures={Common,TeX},
  Numbers={OldStyle,Proportional},RawFeature={+cv04}
]
\newcommand{\ArticleTitleSize}{38bp}
\newcommand{\ArticleBylineSize}{9.5bp}
\newcommand{\ArticleBylineLeading}{12bp}
\newcommand{\ArticleBylineGap}{6bp}
\renewcommand{\LettrineFontHook}{\DropCapTypeface}
\setmonofont{MonaspaceArgon-Variable.ttf}[
  Weight=400,
  BoldFont=MonaspaceArgon-Variable.ttf,BoldFeatures={Weight=700},
  RawFeature={+calt,+ss07,+liga,+kern}
]
\newcommand{\CodeFontSize}{7.5bp}
\AddToHook{ttfamily}{\fontsize{\CodeFontSize}{\baselineskip}}
\newcommand{\CodeFont}{\ttfamily\fontsize{\CodeFontSize}{10bp}\selectfont}

\setmathfont{Euler-Math.otf}[Path={}]
\setmathfont{SourceSans3-VariableFont_wght.ttf}[
  range={up/{latin,Latin,greek,Greek,num},sfup/{latin,Latin,num},
      "0021,"002C,"002E,"003A,"003B,"003F,"2026,"2113,"2202},Weight=400
]
\setmathfont{SourceSans3-Italic-VariableFont_wght.ttf}[
  range={it/{latin,Latin,greek,Greek},sfit/{latin,Latin}},Weight=400
]
\setmathfont{SourceSans3-VariableFont_wght.ttf}[
  range={bfup/{latin,Latin,greek,Greek,num},bfsfup/{latin,Latin,num}},Weight=700
]
\setmathfont{SourceSans3-Italic-VariableFont_wght.ttf}[
  range={bfit/{latin,Latin,greek,Greek},bfsfit/{latin,Latin}},Weight=700
]
\setmathfont{FiraMath-Regular.otf}[Path={},range={"1D716,"1D718,"1D71A,"1D71B}]
\setoperatorfont\mathrm

\setlength{\columnsep}{12bp}
\newdimen\GridUnit
\GridUnit=12bp
\setlength{\topskip}{12bp}
\setlength{\parindent}{0bp}
\setlength{\parskip}{0bp}
\raggedbottom
\frenchspacing
\pretolerance=1000
\tolerance=2000
\emergencystretch=0.6em
\hyphenpenalty=100
\exhyphenpenalty=10000
\doublehyphendemerits=10000
\adjdemerits=3000
\clubpenalty=10000
\widowpenalty=10000
\displaywidowpenalty=10000
\brokenpenalty=10000

\makeatletter
\renewcommand\normalsize{\@setfontsize\normalsize{9.5bp}{12bp}\setlength\abovedisplayskip{0bp}\setlength\belowdisplayskip{0bp}}
\makeatother
\AtBeginDocument{\RaggedRight\normalsize}
\pagestyle{empty}

\ExplSyntaxOn
\NewDocumentCommand{\ArticleStart}{m}{
  \str_case:nnF {#1}{
    {recto}{\AtBeginDocument{\setcounter{page}{1}}}
    {verso}{\AtBeginDocument{\setcounter{page}{2}}}
  }{\ClassError{visionen}{Unknown~article~start~'#1'}{Use~recto~or~verso.}}
}
\ExplSyntaxOff
\makeatletter
\@onlypreamble\ArticleStart
\makeatother


\NewCommandCopy\DesignBoldSeries\bfseries
\RenewDocumentCommand{\bfseries}{}{\ClassError{visionen}{Explicit bold text is disabled}{Use \string\emph\space or \string\textit\space for emphasis.}}

\newcommand{\SmallCapsTracking}{20}
\let\UntrackedTextSmallCaps\textsc
\RenewDocumentCommand{\textsc}{m}{{\textls[\SmallCapsTracking]{\UntrackedTextSmallCaps{\addfontfeatures{RawFeature={-cv04}}#1}}}}

\begin{luacode*}
local function context_font(tfm, value)
  tfm.properties.microtypecontext = value
end
fonts.constructors.features.otf.register {
  name = 'microtypecontext',
  initializers = {base = context_font, node = context_font, plug = context_font}
}
\end{luacode*}
\makeatletter
\def\MT@lua@copyfont#1 #2 #3\@nil{\global\expandafter\font\MT@font@copy=\directlua{
    local specification = "\luaescapestring{#3}"
    local name, size = specification:match("^(.*) at (.*)$")
    if not name then
    tex.sprint(luatexbase.registernumber('catcodetable@atletter'), specification)
    return
    end
    if name:find(':', 1, true) then
    local context = ('\MT@ex@context'):gsub('@', 'default')
    name = name..';microtypecontext='..context
    end
    tex.sprint(luatexbase.registernumber('catcodetable@atletter'), '"'..name..'" at '..size)
  }\relax}
\makeatother

\SetProtrusion[load=T1-default]{encoding=TU,family=\rmdefault}{-={500,600}}
\SetExpansion[stretch=30,shrink=30,step=1]{encoding=TU}{}
\newcommand{\ReferenceCompressionLimit}{150}
\newcommand{\ReferenceCompression}[1]{\renewcommand{\ReferenceCompressionLimit}{#1}}
\AtBeginDocument{\SetExpansion[context=references,stretch=30,shrink=\ReferenceCompressionLimit,step=1]{encoding=TU}{}}
\SetExpansion[context=section,stretch=30,shrink=70,step=1]{encoding=TU}{}
\SetExpansion[context=subsection,stretch=30,shrink=65,step=1]{encoding=TU}{}

\newcommand{\RaggedHeading}{\RaggedRight\hyphenpenalty=10000\exhyphenpenalty=10000}
\titleformat{\section}[block]
{\RaggedHeading\microtypecontext{expansion=section}\SectionHeadingFont\fontsize{11.5bp}{12bp}\selectfont}
{\thesection}{0.5em}{}
\titlespacing*{\section}{0bp}{12bp}{12bp}
\titleformat{\subsection}[block]
{\RaggedHeading\microtypecontext{expansion=subsection}\SubsectionHeadingFont\fontsize{9.5bp}{12bp}\selectfont}
{\thesubsection}{0.5em}{}
\titlespacing*{\subsection}{0bp}{12bp}{0bp}

\begin{luacode*}
local glyph = node.id('glyph')
local hlist = node.id('hlist')
local vlist = node.id('vlist')
local centers = {}
function grid_operator_center(head)
  for n in node.traverse(head) do
    if n.id == glyph then
      centers[n.font] = centers[n.font] or {}
      local cache = centers[n.font]
      if not cache[n.char] then
        local f = font.getfont(n.font)
        local bounds = f.shared.rawdata.descriptions[n.char].boundingbox
        cache[n.char] = math.floor((bounds[2] + bounds[4]) * f.size / (2 * f.units) + 0.5)
      end
      return cache[n.char]
    elseif n.id == hlist or n.id == vlist then
      local center = grid_operator_center(n.head)
      if center then return center end
    end
  end
end
\end{luacode*}
\makeatletter
\newcommand{\SourceAxisGlyph}[1]{\mathpalette\SourceAxisGlyphAux{#1}}
\newcommand{\SourceAxisGlyphAux}[2]{\begingroup
  \setbox0=\hbox{$\m@th#1\text{\OperatorFont\char"#2}$}\dimen0=\dimexpr\Umathaxis#1-\directlua{tex.sprint(grid_operator_center(tex.box[0].head).."sp")}\relax
  \raise\dimen0\box0
  \endgroup
}
\newcommand{\SourceBinary}[1]{\mathbin{\SourceAxisGlyph{#1}}}
\newcommand{\SourceRelation}[1]{\mathrel{\SourceAxisGlyph{#1}}}
\newcommand{\SourceOrdinary}[1]{\mathord{\SourceAxisGlyph{#1}}}

\begingroup
\catcode43 13\relax \gdef+{\SourceBinary{002B}}
\catcode45 13\relax \gdef-{\SourceBinary{2212}}
\catcode61 13\relax \gdef={\SourceRelation{003D}}
\catcode60 13\relax \gdef<{\SourceRelation{003C}}
\catcode62 13\relax \gdef>{\SourceRelation{003E}}
\endgroup
\mathcode43 "8000\relax
\mathcode45 "8000\relax
\mathcode61 "8000\relax
\mathcode60 "8000\relax
\mathcode62 "8000\relax
\renewcommand{\pm}{\SourceBinary{00B1}}
\renewcommand{\times}{\SourceBinary{00D7}}
\renewcommand{\div}{\SourceBinary{00F7}}
\renewcommand{\approx}{\SourceRelation{2248}}
\renewcommand{\neq}{\SourceRelation{2260}}
\let\ne\neq
\renewcommand{\leq}{\SourceRelation{2264}}
\let\le\leq
\renewcommand{\geq}{\SourceRelation{2265}}
\let\ge\geq
\renewcommand{\infty}{\SourceOrdinary{221E}}

\Umathchardef\MathColonEquals="3 "0 "2254
\let\coloneqq\MathColonEquals
\makeatother

\makeatletter
\Umathchardef\SourceMathOpenParen="4 "0 "0028
\Umathchardef\SourceMathCloseParen="5 "0 "0029
\begingroup
\catcode`\(=\active
\gdef({\SourceMathOpenParen\mkern0.5mu}\catcode`\)=\active
\gdef){\mkern0.3mu\SourceMathCloseParen}\endgroup
\mathcode`\(="8000
\mathcode`\)="8000

\Umathchardef\SourceMathOpenSquare="4 "0 "005B
\Umathchardef\SourceMathCloseSquare="5 "0 "005D
\begingroup
\catcode`\[=\active
  \gdef[{\SourceMathOpenSquare\mkern0.5mu}\catcode`\]=\active
\gdef]{\mkern0.3mu\SourceMathCloseSquare}\endgroup
\mathcode`\[="8000
  \mathcode`\]="8000

\makeatother
\newcommand{\graphvertexfont}{\fontsize{9.5bp}{12bp}\selectfont}
\tikzset{
  math graph/.style={line width=0.45bp,line cap=round,line join=round,
    every node/.style={font=\graphvertexfont,circle,inner sep=-0.5bp,outer sep=0pt}},
  graph edge/.style={draw,shorten <=2bp,shorten >=2bp},
  graph full edge/.style={draw,shorten <=0bp,shorten >=0bp},
  relation rule/.style={draw}
}


% ---------------------------------------------------------------------------
% Text/image layouts
% The ratio applies to the usable width after the 12 bp inter-column gap.
% Use \TextImageLayout{...}{...} for 60% text / 40% image.
% Use \ImageTextLayout{...}{...} for 40% image / 60% text.
% The image argument can contain \includegraphics[width=\linewidth]{...}.
% ---------------------------------------------------------------------------
\newlength{\TextImageGap}
\setlength{\TextImageGap}{12bp}
\newlength{\TextImageTextWidth}
\newlength{\TextImageImageWidth}
\newcommand{\SetTextImageWidths}{%
  \setlength{\TextImageTextWidth}{\dimexpr
    3\textwidth/5-3\TextImageGap/5\relax}%
  \setlength{\TextImageImageWidth}{\dimexpr
    2\textwidth/5-2\TextImageGap/5\relax}%
}
\newcommand{\TextImageLayout}[2]{%
  \par\noindent\SetTextImageWidths
  \begin{minipage}[t]{\TextImageTextWidth}
    \vspace{0pt}\RaggedRight #1
  \end{minipage}\hspace{\TextImageGap}%
  \begin{minipage}[t]{\TextImageImageWidth}
    \vspace{0pt}\RaggedRight #2
  \end{minipage}\par
}
\newcommand{\ImageTextLayout}[2]{%
  \par\noindent\SetTextImageWidths
  \begin{minipage}[t]{\TextImageImageWidth}
    \vspace{0pt}\RaggedRight #1
  \end{minipage}\hspace{\TextImageGap}%
  \begin{minipage}[t]{\TextImageTextWidth}
    \vspace{0pt}\RaggedRight #2
  \end{minipage}\par
}

\newbox\GridContentBox
\newcount\GridRows
\newdimen\GridRequiredHeight
\newdimen\GridAllocatedHeight
\newdimen\GridNaturalHeight
\newdimen\GridTopGlue
\newdimen\GridBottomGlue
\newdimen\GridMinimumTotalClearance
\GridMinimumTotalClearance=6bp
\newdimen\GridOpticalDownshift
\GridOpticalDownshift=3bp
\newcommand{\GridBlock}[1]{\par\nobreak
  \begingroup
  \setbox\GridContentBox=\hbox{#1}\ifdim\wd\GridContentBox>\columnwidth
    \PackageError{A5-grid}{Display wider than column: \the\wd\GridContentBox\space vs \the\columnwidth}{Shorten math, use aligned, or move vertices closer.}\fi
  \GridNaturalHeight=\dimexpr\ht\GridContentBox+\dp\GridContentBox\relax
  \GridRequiredHeight=\dimexpr\GridNaturalHeight+\GridMinimumTotalClearance\relax
  \GridRows=1
  \loop\ifdim\dimexpr\GridRows\GridUnit\relax<\GridRequiredHeight
  \advance\GridRows by1
  \repeat
  \GridAllocatedHeight=\dimexpr\GridRows\GridUnit\relax
  \GridTopGlue=\dimexpr
  (\GridAllocatedHeight-\GridNaturalHeight)/2+\GridOpticalDownshift\relax
  \GridBottomGlue=\dimexpr
  \GridAllocatedHeight-\GridNaturalHeight-\GridTopGlue\relax
  \ifdim\prevdepth>-999pt\vskip-\prevdepth\fi
  \nointerlineskip
  \vbox to \GridAllocatedHeight{\vskip\GridTopGlue
    \hbox to\columnwidth{\hfil\box\GridContentBox\hfil}\vskip\GridBottomGlue
  }\prevdepth=0pt
  \endgroup
}
\newcommand{\GridMath}[1]{\GridBlock{$\displaystyle #1$}}

\newbox\CaptionContentBox
\newbox\CaptionFirstLineBox
\newdimen\CaptionSurroundingOffset
\NewDocumentEnvironment{Caption}{m +b}{\par
  \CaptionSurroundingOffset=\dimexpr
    \baselineskip-\fontcharht\font`H\relax
  \ifdim\prevdepth>-999pt
    \advance\CaptionSurroundingOffset by\prevdepth
  \fi
  \fontsize{8bp}{10bp}\selectfont\itshape
  \setbox\CaptionContentBox=\vbox{\hsize=\columnwidth\RaggedRight
    \leftskip=#1\relax\parindent=0bp
    \leavevmode\hbox{}#2\hbox{}\par
  }
  \setbox\CaptionFirstLineBox=\vtop{\unvcopy\CaptionContentBox}
  \GridMinimumTotalClearance=0bp
  \GridOpticalDownshift=\dimexpr(
    \CaptionSurroundingOffset-\ht\strutbox+\ht\CaptionFirstLineBox
    +\dp\strutbox-\dp\CaptionContentBox)/2\relax
  \setbox\CaptionContentBox=\vbox{
    \kern\dimexpr\ht\strutbox-\ht\CaptionFirstLineBox\relax
    \box\CaptionContentBox
  }
  \dp\CaptionContentBox=\dp\strutbox
  \GridBlock{\box\CaptionContentBox}
}{}

\newbox\GridTitleContent
\newcommand{\ArticleHeading}[2]{\par
  \begingroup
  \setbox\GridTitleContent=\vbox{\hsize=\columnwidth
    \parindent=0pt\parskip=0pt
    \raggedright\hyphenpenalty=10000\exhyphenpenalty=10000
    \pretolerance=10000
    \vskip12bp
    {\ArticleTitleFont\fontsize{\ArticleTitleSize}{\ArticleTitleSize}\selectfont
      \noindent #1\par}\vskip\ArticleBylineGap
    {\ArticleBylineFont\fontsize{\ArticleBylineSize}{\ArticleBylineLeading}\selectfont
      \noindent #2\par}\vskip24bp
  }\GridRequiredHeight=\dimexpr\ht\GridTitleContent+\dp\GridTitleContent\relax
  \GridRows=1
  \loop\ifdim\dimexpr\GridRows\GridUnit\relax<\GridRequiredHeight
  \advance\GridRows by1
  \repeat
  \GridAllocatedHeight=\dimexpr\GridRows\GridUnit\relax
  \nointerlineskip
  \vbox to\GridAllocatedHeight{\unvbox\GridTitleContent\vfil}\prevdepth=0pt
  \endgroup
}

% Full-width variant (for use with \twocolumn[ ... ])
\newbox\GridWideTitleContent
\newcommand{\ArticleHeadingWide}[2]{\par
  \begingroup
  \setbox\GridWideTitleContent=\vbox{\hsize=\textwidth
    \parindent=0pt\parskip=0pt
    \raggedright\hyphenpenalty=10000\exhyphenpenalty=10000
    \pretolerance=10000
    \vskip12bp
    {\ArticleTitleFont\fontsize{\ArticleTitleSize}{\ArticleTitleSize}\selectfont
      \noindent #1\par}\vskip\ArticleBylineGap
    {\ArticleBylineFont\fontsize{\ArticleBylineSize}{\ArticleBylineLeading}\selectfont
      \noindent #2\par}\vskip24bp
  }\GridRequiredHeight=\dimexpr\ht\GridWideTitleContent+\dp\GridWideTitleContent\relax
  \GridRows=1
  \loop\ifdim\dimexpr\GridRows\GridUnit\relax<\GridRequiredHeight
  \advance\GridRows by1
  \repeat
  \GridAllocatedHeight=\dimexpr\GridRows\GridUnit\relax
  \nointerlineskip
  \vbox to\GridAllocatedHeight{\unvbox\GridWideTitleContent\vfil}\prevdepth=0pt
  \endgroup
}

\begin{luacode*}
function grid_opening_paragraph(raw)
  local s=raw:gsub('^%s+', '')
  local pos=1
  local last=0
  local words=0
  while words < 3 do
    local x,y=s:find('^%s*[^%s%.%?!:;]+', pos)
    if not x then break end
    last=y
    words=words+1
    pos=y+1
    local sep=s:sub(pos,pos)
    if sep:match('[%.%?!:;]') then break end
  end
  if last==0 then
    tex.sprint(s)
    return
  end
  local selected=s:sub(1,last)
  local rest=s:sub(last+1)
  local start2=utf8.offset(selected,2)
  if not start2 then start2=#selected+1 end
  local initial=selected:sub(1,start2-1)
  local small=selected:sub(start2)
  tex.sprint('\\lettrine[lines=3,lhang=0,nindent=0bp,findent=0.13em]{'
    ..initial..'}{\\textsc{'..small..'}}'..rest)
end
\end{luacode*}
\newcommand{\OpeningParagraph}[1]{\par\directlua{grid_opening_paragraph("\luaescapestring{\detokenize{#1}}")}\par}

\renewcommand{\descriptionlabel}[1]{\hspace\labelsep\normalfont\DesignBoldSeries#1}

\setlist[enumerate,itemize,description]{beginpenalty=10000}

\newcommand{\ListNumberFont}{\fontsize{8bp}{12bp}\selectfont
  \addfontfeatures{Numbers={OldStyle,Monospaced}}}
\newlength{\ListNumberWidth}
\newcommand{\IndentNumberList}[1]{
  \settowidth{\ListNumberWidth}{{\ListNumberFont #1}}
  \leftmargin=\dimexpr\ListNumberWidth+\labelsep\relax
  \labelindent=\leftmargin
  \itemindent=\labelsep
}
\setlist[enumerate,1,2,3,4]{
  wide=0bp,
  rightmargin=0bp,
  nosep,
  font=\ListNumberFont,
  labelsep=.5em
}
\setlist*[enumerate,1]{label=\arabic*}
\setlist*[enumerate,2]{
  label=\theenumi.\arabic*,
  before=\IndentNumberList{\theenumi}
}
\setlist*[enumerate,3]{
  label=\theenumii.\arabic*,
  before=\IndentNumberList{\theenumii}
}
\setlist*[enumerate,4]{
  label=\theenumiii.\arabic*,
  before=\IndentNumberList{\theenumiii}
}

\setlist[itemize,1,2]{
  wide=0bp,
  rightmargin=0pt,
  nosep,
  label=\textbullet,
  font=\fontsize{8bp}{12bp}\selectfont,
  labelsep=.5em
}

\newlength{\ListBulletWidth}
\settowidth{\ListBulletWidth}{{\fontsize{8bp}{12bp}\selectfont\textbullet}}
\setlist*[itemize,2]{
  labelindent=\dimexpr\ListBulletWidth+\labelsep\relax,
  leftmargin=\labelindent
}

\newdimen\GridReferencePhase

\newcommand{\GridAlignAfterReferences}{\par
  \penalty10000
  \begingroup
  \GridReferencePhase=
  \dimexpr\pagetotal-\topskip\relax

  \ifdim\GridReferencePhase>0bp
  \loop
  \ifdim\GridReferencePhase>12bp
    \advance\GridReferencePhase by -12bp
    \repeat

    \ifdim\GridReferencePhase<12bp
      \vskip\dimexpr
      12bp-\GridReferencePhase
      \relax
    \fi
  \fi
  \endgroup
}

\NewDocumentEnvironment{GridReferences}{}{\par
  \Needspace{36bp}\begingroup

  \setlength{\parindent}{8bp}\setlength{\parskip}{0bp}\setlength{\leftskip}{0bp}\setlength{\rightskip}{0bp}\RaggedRight
  \vspace*{12bp}
  {\fontsize{9.5bp}{12bp}\selectfont
    \noindent\textsc{references}\par
  }
  \microtypecontext{expansion=references}
  \fontsize{8bp}{10bp}\selectfont
  \pretolerance=-1\emergencystretch=2em

  \begin{itemize}[
    label={},
    leftmargin=0bp,
    rightmargin=0bp,
    labelsep=0bp,
    labelwidth=0bp,
    itemindent=0bp,
    listparindent=0bp,
    topsep=0bp,
    partopsep=0bp,
    itemsep=0bp,
    parsep=0bp
  ]\end{itemize}\endgroup\GridAlignAfterReferences}

\newcommand{\DOI}[1]{\href{https://doi.org/#1}{\textsc{\nolinkurl{#1}}}}

\usemintedstyle{gruvbox-light}
\makeatletter
\newenvironment{CodeBlock}[1]{\VerbatimEnvironment
  \let\bfseries\DesignBoldSeries
  \begin{minted}[
    formatcom=\CodeFont,breaklines=true,breakindent=6bp,breakautoindent=true,
    xleftmargin=0bp,xrightmargin=0bp,frame=none,
    listparameters={\if@minipage\topsep=0bp\partopsep=0bp\fi}
  ]{#1}}{\end{minted}}
\makeatother
