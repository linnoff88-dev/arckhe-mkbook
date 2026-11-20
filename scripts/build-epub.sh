#!/usr/bin/env bash
# build-epub.sh — concatena capítulos editados e gera EPUB + PDF
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build"
MANUSCRIPT="$BUILD/manuscript.md"

mkdir -p "$BUILD"

command -v pandoc >/dev/null || { echo "❌ pandoc não encontrado. Instale: brew/apt install pandoc"; exit 1; }

EDITED=( "$ROOT"/chapters/*-edited.md )
[[ ${#EDITED[@]} -gt 0 ]] || { echo "❌ Nenhum capítulo editado em chapters/"; exit 1; }

# Extrai título e autor da bíblia
TITLE=$(grep -m1 '^- \*\*Título de trabalho:\*\*' "$ROOT/bible.md" | sed 's/.*\*\*Título de trabalho:\*\* *//')
TITLE="${TITLE:-Meu Livro}"

echo "📦 Build: $TITLE"
echo "   capítulos: ${#EDITED[@]}"

# Monta manuscript
{
  echo "---"
  echo "title: \"$TITLE\""
  echo "author: \"$(git config user.name || echo Autor)\""
  echo "lang: pt-BR"
  echo "---"
  echo ""
  for f in "${EDITED[@]}"; do
    cat "$f"
    echo ""
    echo ""
  done
} > "$MANUSCRIPT"

echo "  ✓ manuscript.md ($(wc -w < "$MANUSCRIPT") palavras)"

# EPUB
pandoc "$MANUSCRIPT" \
  --from markdown \
  --to epub3 \
  --toc --toc-depth=2 \
  --output "$BUILD/book.epub"
echo "  ✓ book.epub"

# PDF (precisa de LaTeX; falha silenciosamente se não tiver)
if command -v xelatex >/dev/null 2>&1; then
  pandoc "$MANUSCRIPT" \
    --pdf-engine=xelatex \
    --toc --toc-depth=2 \
    -V mainfont="Helvetica" \
    -V geometry:margin=1in \
    --output "$BUILD/book.pdf"
  echo "  ✓ book.pdf"
else
  echo "  ⚠  xelatex ausente — PDF pulado (instale basictex pra gerar)"
fi

# MOBI (opcional via Calibre)
if command -v ebook-convert >/dev/null 2>&1; then
  ebook-convert "$BUILD/book.epub" "$BUILD/book.mobi" >/dev/null 2>&1 && echo "  ✓ book.mobi"
fi

echo ""
echo "✅ Build em: $BUILD/"
ls -lh "$BUILD/"
