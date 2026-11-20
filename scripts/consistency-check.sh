#!/usr/bin/env bash
# consistency-check.sh — roda agente verificador contra todos os capítulos editados
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EDITED=( "$ROOT"/chapters/*-edited.md )

[[ ${#EDITED[@]} -gt 0 ]] || { echo "❌ Nenhum capítulo editado em chapters/"; exit 1; }

echo "🔍 Verificando consistência em ${#EDITED[@]} capítulos..."

claude --no-interactive <<PROMPT
Use a skill ebook-writer.

Tarefa: verificação de consistência cruzada do livro completo.

Leia: $ROOT/bible.md (fonte da verdade)
Leia todos os arquivos: $ROOT/chapters/*-edited.md

Cheque e reporte:

1. **Glossário**: algum termo do glossário usado de forma divergente?
2. **Voz**: algum capítulo destoa do tom definido?
3. **Repetição**: histórias ou exemplos citados em mais de um capítulo?
4. **Promessas**: cada capítulo entrega o que a bíblia prometeu?
5. **Cliffhangers**: as transições entre capítulos funcionam?
6. **Linhas vermelhas**: alguma foi cruzada?

Para cada problema, indique:
- Capítulo + trecho
- Tipo de inconsistência
- Sugestão de fix (1 linha)

Se tudo limpo, responda "✅ Livro consistente."
PROMPT
