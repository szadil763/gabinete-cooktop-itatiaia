# Gabinete de Cooktop — Itatiaia Electra Plus

Gabinete modular para embutir o cooktop a gás **Itatiaia Electra Plus**, construído em estrutura de tubo de aço galvanizado Ø25,6mm + painéis de MDF, unidos por conectores impressos em 3D (PETG). Portas em acrílico com dobradiça de nó (knuckle hinge) impressa.

## Estrutura do repositório

```
scad/            Fonte paramétrico OpenSCAD de todos os conectores e da dobradiça
stl/             STLs prontos para fatiar (exportados do .scad)
dxf/             Arquivos de corte a laser/CNC (painéis de MDF e portas de acrílico)
docs/            Plano de montagem em PDF + imagens de referência
simulacoes/      Simulações 3D interativas (abrir no navegador, offline)
perfis-impressao/ Perfil de impressão Cura (Ender-3, PETG, bico 0,6mm)
```

## Peças impressas (`scad/conectores_gabinete.scad`)

Exportação via linha de comando:

```bash
openscad -D 'part="AP"' -o conector_AP.stl conectores_gabinete.scad
```

| `part` | Peça | Quantidade |
|---|---|---|
| `AP` | Canto com abas para parafusar o MDF | 8 |
| `B` | T de 3 soquetes de travessa | 4 |
| `HB` | Suporte fixo da dobradiça (parafusado na aba do AP) | 4 |
| `HL` | Peça da dobradiça presa à porta de acrílico | 4 |
| `teste` | 4 anéis para calibrar a folga do furo do tubo | — |

Parâmetros principais: tubo Ø25,6mm, folga de furo 0,4mm (`bore_d = 26,0mm`), furos de fixação M4, porcas sextavadas embutidas.

## Montagem

Veja `docs/plano_de_montagem_gabinete_cooktop.pdf` para a sequência completa, medidas e lista de material (tubo, MDF, acrílico, parafusaria).

## Simulações 3D (offline, abrir direto no navegador)

- **`simulacao_montagem_3d_offline.html`** — montagem completa do gabinete
- **`simulacao_dobradica_hb_hl_3d.html`** — dobradiça de nó (HB/HL) com geometria STL real, animação de abrir/fechar porta
- **`simulacao_encaixe_dobradica_ap_3d.html`** — como o suporte da dobradiça (HB) encaixa e aparafusa no conector de canto (AP)

Todas as posições de furo/encaixe foram validadas por interseção booleana real entre os STLs (trimesh/manifold), não só visualmente — colisão zero nos pontos de encaixe.

## Impressão

Perfil testado em Ender-3 com garganta all-metal bimetálica e bico 0,6mm, PETG (`perfis-impressao/`). Ajustado para evitar heat creep: `cool_min_layer_time=5s`, `retraction_speed=28mm/s`, `material_print_temperature=240°C`.

Recomendações:
- Imprime `teste_folga.stl` primeiro para calibrar a folga do furo do tubo antes do lote completo.
- Para as peças `HB`/`HL` (nó da dobradiça, folga de projeto de 0,5mm), considere `layer_height=0,2mm` para mais fidelidade no entrelace dos nós.
- Furos ovalizados num eixo só (ex.: 26mm × 24mm) indicam folga mecânica em X/Y (grub screw da polia do motor ou tensão de correia) — não é parâmetro de fatiamento.
