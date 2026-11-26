ï»¿# ê°Å¸âÅ¡ mkbook

<div align="center">
  <img src="capa/logo.svg" alt="Arckhé AI" height="48" />
  <p><strong>Arckhé AI</strong></p>
</div>


> Pipeline completo pra transformar uma ideia em ebook publicado em **30 dias**, usando Claude Code como motor de escrita, ediêÂ§êÂ£o, consistêÂªncia e build.

Baseado no framework dos 7 prompts (Idea ê¢â â Outline ê¢â â Chapter ê¢â â Edit ê¢â â Launch ê¢â â Publishing ê¢â â Monetization), mas operando como **pipeline real de arquivos versionados** ê¢â¬â nêÂ£o prompts soltos no chat.

ê°Å¸ÅÂ **Curso completo (GitHub Pages):** [linnoff88-dev.github.io/arckhe-mkbook](https://linnoff88-dev.github.io/arckhe-/)
ê°Å¸ââ **RepositêÂ³rio:** [github.com/linnoff88-dev/mkbook](https://github.com/linnoff88-dev/mkbook)

---

## ê¢Å¡Â¡ TL;DR ê¢â¬â 5 comandos pra ter um livro

```bash
git clone https://github.com/linnoff88-dev/mkbook.git && cd mkbook
./scripts/setup.sh                         # ê°Å¸Â§Â¬ wizard interativo (preenche bêÂ­blia em 20 min)
./scripts/write-chapter.sh 1               # Claude gera cap 1
./scripts/edit-chapter.sh 1                # Claude edita
./scripts/build-epub.sh                    # EPUB/PDF/MOBI prontos pro KDP
```

## ê°Å¸Â§Â¬ Duas formas de preencher a bêÂ­blia

| Modo | Como rodar | Quando usar |
|---|---|---|
| **Web (visual)** | Acesse [linnoff88-dev.github.io/arckhe-/setup/](https://linnoff88-dev.github.io/arckhe-/setup/) ê¢â â preencha 12 perguntas ê¢â â baixe `bible.md` ê¢â â coloque na raiz do projeto | Quer ver progresso visual, prefere formulêÂ¡rio com previews |
| **CLI (terminal)** | `./scripts/setup.sh` | JêÂ¡ têÂ¡ no terminal, prefere fluxo rêÂ¡pido sem trocar de janela |
| **Manual** | `./scripts/new-book.sh "TêÂ­tulo"` + edita `bible.md` direto | JêÂ¡ fez antes, sabe o que quer preencher |

Os 3 modos geram o mesmo `bible.md` ê¢â¬â sêÂ³ muda a experiêÂªncia.

Repete `write-chapter.sh N` + `edit-chapter.sh N` pra cada capêÂ­tulo (1 por dia recomendado). Em 30 dias, ebook na Amazon.

---

## ê°Å¸Å½Â¯ Por que existe

Os 7 prompts virais funcionam em chat curto, mas falham em livro real:

| Problema do chat | SoluêÂ§êÂ£o do mkbook |
|---|---|
| Contexto perdido no cap 3 | Cada capêÂ­tulo êÂ© arquivo separado, alimentado por bêÂ­blia + outline + stories |
| Sem persistêÂªncia | Git versiona tudo |
| EdiêÂ§êÂ£o manual copy/paste | Skill `ebook-writer` automatiza |
| InconsistêÂªncia entre capêÂ­tulos | Agente verificador cruza glossêÂ¡rio, voz, promessas |
| Texto solto no chat | `build-epub.sh` gera EPUB + PDF + MOBI |

---

## ê°Å¸ââ Estrutura

```
mkbook/
ê¢âÅê¢ââ¬ê¢ââ¬ templates/                  # Templates iniciais
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ bible.md                # Voz, audiêÂªncia, promessa, glossêÂ¡rio
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ outline.md              # Estrutura dos 10-12 capêÂ­tulos
ê¢ââ   ê¢ââê¢ââ¬ê¢ââ¬ stories.md              # Banco de histêÂ³rias pessoais
ê¢âÅê¢ââ¬ê¢ââ¬ chapters/                   # Cada capêÂ­tulo em arquivo prêÂ³prio (gitignored)
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ 01-draft.md
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ 01-edited.md
ê¢ââ   ê¢ââê¢ââ¬ê¢ââ¬ ...
ê¢âÅê¢ââ¬ê¢ââ¬ scripts/                    # AutomaêÂ§êÂ£o shell
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ new-book.sh             # Bootstrap em 1 comando
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ write-chapter.sh        # Gera cap N
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ edit-chapter.sh         # Editor cruel
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ consistency-check.sh    # VerificaêÂ§êÂ£o cruzada
ê¢ââ   ê¢ââê¢ââ¬ê¢ââ¬ build-epub.sh           # EPUB + PDF + MOBI
ê¢âÅê¢ââ¬ê¢ââ¬ build/                      # SaêÂ­das (gitignored)
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ manuscript.md
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ book.epub
ê¢ââ   ê¢âÅê¢ââ¬ê¢ââ¬ book.pdf
ê¢ââ   ê¢ââê¢ââ¬ê¢ââ¬ book.mobi
ê¢âÅê¢ââ¬ê¢ââ¬ .claude/skills/ebook-writer/  # Skill custom que orquestra os 7 prompts
ê¢ââê¢ââ¬ê¢ââ¬ docs/                       # Curso GitHub Pages (formato ARCKHÉ AI)
```

---

## ê°Å¸âºÂ ê¯Â¸Â PrêÂ©-requisitos

```bash
# obrigatêÂ³rio
brew install pandoc git                    # macOS
# ou: sudo apt install pandoc git           # Ubuntu/Debian

# Claude Code instalado e autenticado
npm install -g @anthropic-ai/claude-code
claude --version

# opcional ê¢â¬â PDF de alta qualidade
brew install --cask basictex               # macOS
# ou: sudo apt install texlive-xetex        # Ubuntu

# opcional ê¢â¬â geraêÂ§êÂ£o de MOBI
brew install --cask calibre                # macOS
# ou: sudo apt install calibre              # Ubuntu
```

---

## ê°Å¸ââ Como criar um livro novo (passo a passo)

### Dia 1 ê¢â¬â Setup (30 minutos)

```bash
cd ~/projetos/mkbook
./scripts/new-book.sh "TêÂ­tulo ProvisêÂ³rio"
```

O script:
- Copia `templates/bible.md`, `outline.md`, `stories.md` pra raiz
- Faz `git init` e primeiro commit
- Substitui o têÂ­tulo placeholder pelo que vocêÂª passou

---

### Dia 1-3 ê¢â¬â Preencher a bêÂ­blia (3-4h totais, dividido em 3 dias)

A bêÂ­blia êÂ© a **lei** do livro. Tudo daqui pra frente lêÂª dela.

Abra `bible.md` e preencha:

| SeêÂ§êÂ£o | O que colocar |
|---|---|
| **Identidade** | TêÂ­tulo, subtêÂ­tulo, gêÂªnero, categorias Amazon, keywords |
| **Promessa central** | 1 frase: "Ao terminar, [avatar] terêÂ¡ [transformaêÂ§êÂ£o] mesmo [objeêÂ§êÂ£o]" |
| **PêÂºblico-alvo (avatar)** | 1 pessoa real ou semi-fictêÂ­cia: idade, profissêÂ£o, dor, desejo, onde estêÂ¡ hoje |
| **Voz e tom** | 3 adjetivos + autor de referêÂªncia + **amostras suas** (cola 2-5 mil palavras suas: posts longos, e-mails, threads) |
| **Estrutura por capêÂ­tulo** | Promessa especêÂ­fica de cada cap (vocêÂª preenche depois do outline) |
| **GlossêÂ¡rio controlado** | 5-10 termos com definiêÂ§êÂ£o + variaêÂ§êÂµes proibidas |
| **Linhas vermelhas** | O que o livro NUNCA faz |
| **Modelo de negêÂ³cio pêÂ³s-livro** | Curso? Consultoria? Palestras? Comunidade? |

> **ê¢Å¡Â ê¯Â¸Â NêÂ£o pule "amostras de voz".** Sem 2k+ palavras suas coladas, o agente vai gerar prosa LLM-padrêÂ£o. Isso êÂ© a diferenêÂ§a entre "parece que vocêÂª escreveu" e "parece IA".

---

### Dia 4 ê¢â¬â Gerar ideia + outline (~2h)

```bash
claude
> /ebook-writer Gere 5 ideias de livro baseadas no inventêÂ¡rio em bible.md.
                Salve em ideas.md.
```

Escolha a vencedora (marque ê¢Åâ em `ideas.md`).

```bash
> /ebook-writer Monte o outline completo do livro escolhido em outline.md.
                12 capêÂ­tulos, ~4000 palavras cada, com promessa por capêÂ­tulo.
```

Revise `outline.md` êÂ  mêÂ£o. Cap por cap. Ajuste promessas que nêÂ£o convencem.

---

### Dia 5 ê¢â¬â Banco de histêÂ³rias (~2h)

Abra `stories.md` e cole **todas** suas anedotas relevantes (cruas, sem polir). Tagueia:

```markdown
### A vez que perdi US$ 30k por nêÂ£o ter mailing list
**Tags:** #cap1 #lanêÂ§amento #arrependimento
**Ano:** 2022
**O que aconteceu:** Lancei pra "todo mundo" via Instagram. 12 vendas...
**LiêÂ§êÂ£o:** AudiêÂªncia > oferta
**Onde encaixa:** Cap 1, abertura
```

Isso êÂ© o que separa seu livro de LLM-genêÂ©rico.

---

### Dia 6-17 ê¢â¬â 1 capêÂ­tulo por dia (~2h cada)

```bash
./scripts/write-chapter.sh 1
# Claude lêÂª bible.md + outline.md + stories.md
# ê¢â â chapters/01-draft.md

# revisa rapido o draft (lêÂª todo, anota o que mudar)
$EDITOR chapters/01-draft.md

./scripts/edit-chapter.sh 1
# editor cruel: corta gordura, melhora aberturas, elimina repetiêÂ§êÂ£o
# ê¢â â chapters/01-edited.md

git add chapters/ && git commit -m "cap 1"
```

Pode automatizar com `/loop` do Claude Code:

```bash
claude
> /loop 1d Execute: ./scripts/write-chapter.sh $((dia_atual)) && ./scripts/edit-chapter.sh $((dia_atual))
```

---

### Dia 18-21 ê¢â¬â VerificaêÂ§êÂ£o de consistêÂªncia

```bash
./scripts/consistency-check.sh
```

RelatêÂ³rio:
- Termos do glossêÂ¡rio usados de forma inconsistente?
- CapêÂ­tulos destoam da voz da bêÂ­blia?
- HistêÂ³rias repetidas?
- Promessas do outline cumpridas?
- Cliffhangers funcionando entre capêÂ­tulos?
- Linhas vermelhas respeitadas?

Corrija o que aparecer.

---

### Dia 22-25 ê¢â¬â Build

```bash
./scripts/build-epub.sh
```

Gera em `build/`:
- `manuscript.md` (Markdown consolidado)
- `book.epub` (pra KDP, Kobo, Apple Books, Google Play)
- `book.pdf` (alta qualidade via xelatex, se instalado)
- `book.mobi` (Kindle antigo, se Calibre instalado)

---

### Dia 26-30 ê¢â¬â PublicaêÂ§êÂ£o no Amazon KDP

Siga a **Trilha 3** do curso (`docs/curso/trilha3/`):

1. Conta KDP + W8-BEN (pra nêÂ£o perder 30% de imposto)
2. Capa via Midjourney/DALL-E + composiêÂ§êÂ£o no Canva
3. Subir EPUB
4. 3 categorias estratêÂ©gicas (2 nichos pequenos + 1 amplo)
5. 7 keywords long-tail
6. DescriêÂ§êÂ£o com HTML bêÂ¡sico (bullets, bold)
7. PreêÂ§o estratêÂ©gico (US$ 2.99 / 5.99 / 9.99 sêÂ£o sweet spots)
8. KDP Select sim/nêÂ£o

Vai pro ar em ~12h apêÂ³s submit.

---

## ê°Å¸Å½Â¬ Plano de lanêÂ§amento (paralelo êÂ  escrita)

Veja **Trilha 4** do curso pra plano de 30 dias com prêÂ©-launch, dia do bestseller e 7 streams de monetizaêÂ§êÂ£o atrêÂ¡s do livro.

---

## ê°Å¸âÂ§ Comandos de referêÂªncia rêÂ¡pida

```bash
# Bootstrap
./scripts/new-book.sh "TêÂ­tulo"

# Pipeline diêÂ¡ria de capêÂ­tulos
./scripts/write-chapter.sh N            # gera cap N
./scripts/edit-chapter.sh N             # edita cap N

# VerificaêÂ§êÂ£o cruzada (rodar quando todos os caps estiverem prontos)
./scripts/consistency-check.sh

# Build final
./scripts/build-epub.sh                 # ê¢â â build/book.{epub,pdf,mobi}

# Ver o curso local
python3 -m http.server -d docs 8000     # abre em localhost:8000
```

---

## ê°Å¸â Ë Troubleshooting

| Problema | SoluêÂ§êÂ£o |
|---|---|
| `command not found: pandoc` | `brew install pandoc` ou `apt install pandoc` |
| `xelatex ausente ê¢â¬â PDF pulado` | `brew install --cask basictex` (macOS) |
| Voz do livro têÂ¡ genêÂ©rica | Falta amostras suas em `bible.md`. Adicione mais 2k palavras |
| CapêÂ­tulo curto demais | Outline pediu 4k palavras mas saiu 2k ê¢â¬â reforce a quantidade no prompt |
| Sobrescrever capêÂ­tulo por engano | `git log chapters/03-edited.md` + `git checkout <hash> -- chapters/03-edited.md` |
| Quero recomeêÂ§ar do zero | `rm bible.md outline.md ideas.md && ./scripts/new-book.sh "Novo"` |
| EPUB nêÂ£o abre no Kindle | Use o Send to Kindle do Amazon ou converta pra MOBI com Calibre |

---

## ê°Å¸ÅÂ Curso (GitHub Pages)

O treinamento completo em 4 trilhas (16 mêÂ³dulos êÂ· 96 têÂ³picos) estêÂ¡ em `docs/`:

| Trilha | Foco | Cor |
|---|---|---|
| **T1 Fundamentos** | Ideia validada + bêÂ­blia + outline | ê°Å¸Å¸Â¢ Emerald |
| **T2 Escrita** | Pipeline de capêÂ­tulos + ediêÂ§êÂ£o + consistêÂªncia | ê°Å¸âÂµ Blue |
| **T3 PublicaêÂ§êÂ£o** | EPUB, KDP, capa, formataêÂ§êÂ£o | ê°Å¸Å¸Â£ Purple |
| **T4 LanêÂ§amento** | 30 dias, bestseller, 7 streams de receita | ê°Å¸Å¸Â¡ Amber |

Deploy automêÂ¡tico via `.github/workflows/pages.yml`. ApêÂ³s push, vai pro ar em ~2 min.

URL: **[linnoff88-dev.github.io/arckhe-mkbook](https://linnoff88-dev.github.io/arckhe-/)**

---

## ê°Å¸âÅ LicenêÂ§a

MIT ê¢â¬â use, modifique, publique seu livro e fique com 100% da grana.

---

## ê°Å¸â¢Â CrêÂ©ditos

Framework dos 7 prompts originais: domêÂ­nio pêÂºblico (viralizou em 2024). ImplementaêÂ§êÂ£o como pipeline em arquivos versionados: [ARCKHÉ AI](https://ARCKHÉ AI).

---

<div align="center">
  <img src="capa/logo.svg" alt="Arckhé AI" height="32" />
  <p><strong>Arckhé AI</strong></p>
</div>