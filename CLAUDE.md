# Contexto do projeto — Gabinete de Cooktop

Projeto físico (não software): gabinete modular para o cooktop Itatiaia Electra Plus, estrutura de tubo galvanizado Ø25,6mm + MDF, unidos por conectores PETG impressos em 3D. Dono: Adilson.

## Decisões de projeto já tomadas

- **Dobradiça das portas de acrílico**: sistema de nó (knuckle hinge, módulos `HB`/`HL` no `.scad`) — escolhido no lugar de um sistema alternativo de pivô/sapata que foi avaliado, teve colisão diagnosticada e **removido do projeto** por decisão explícita do usuário (ele topa furar o acrílico, então o nó de dobradiça venceu por ser mais simples e já validado).
- Todas as posições de furo/encaixe entre peças (AP↔HB, HB↔HL) foram validadas por interseção booleana real entre os STLs exportados (trimesh + engine manifold), não só por inspeção visual — zero colisão confirmada nos pontos de montagem documentados.
- `bore_d = tube_d(25,6) + clear(0,4) = 26,0mm` é a fórmula compartilhada por todos os soquetes de tubo (AP e B usam a mesma). Se um conector sair ovalizado e outro não, o problema é mecânico da impressora (grub screw/correia XY), não do `.scad`.

## Ao editar `scad/conectores_gabinete.scad`

- Qualquer peça nova ou alterada que tenha furo de encaixe com outra peça deve ser revalidada por interseção booleana real (trimesh/manifold), não só visualmente — é o padrão que este projeto já usa.
- Reexportar os STLs afetados em `stl/` e, se a geometria de encaixe mudou, atualizar a simulação 3D correspondente em `simulacoes/`.

## Impressão

Impressora de referência: Ender-3 do Adilson, hotend all-metal bimetálico, bico 0,6mm, PETG. Perfil validado em `perfis-impressao/`. Não assumir bico 0,4mm ao sugerir ajustes de fatiamento.
