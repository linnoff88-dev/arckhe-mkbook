#!/usr/bin/env bash
# new-book.sh — inicializa um novo livro a partir dos templates
set -euo pipefail

TITLE="${1:-Untitled Book}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "📚 Inicializando livro: $TITLE"
echo "📁 Em: $ROOT"

# Copia templates pra raiz (não sobrescreve)
for f in bible.md outline.md stories.md; do
  if [[ -f "$ROOT/$f" ]]; then
    echo "  ⚠  $f já existe, pulando"
  else
    cp "$ROOT/templates/$f" "$ROOT/$f"
    echo "  ✓ $f"
  fi
done

# Inicializa git se ainda não for repo
if [[ ! -d "$ROOT/.git" ]]; then
  ( cd "$ROOT" && git init -q && git add . && git commit -qm "init: $TITLE" )
  echo "  ✓ git init + primeiro commit"
fi

# Substitui título placeholder
sed -i.bak "s/^- \*\*Título de trabalho:\*\*$/- **Título de trabalho:** $TITLE/" "$ROOT/bible.md" 2>/dev/null || true
rm -f "$ROOT/bible.md.bak"

cat <<EOF

✅ Pronto. Próximos passos:

  1. Abra bible.md e preencha (especialmente: público, voz, amostras)
  2. Cole histórias suas em stories.md
  3. Gere o outline:
       claude "/ebook-writer outline a partir da bíblia"
  4. Escreva o primeiro capítulo:
       ./scripts/write-chapter.sh 1

EOF
