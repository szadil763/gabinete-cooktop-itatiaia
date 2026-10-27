// Peça de teste de calibração XY — verifica ovalização/erro de escala por eixo
// Imprimir SEM girar no slicer: a seta "X" fica paralela à frente da impressora
// (eixo X do carro do bico) e a seta "Y" aponta para o fundo (eixo Y da mesa).
// openscad -o calibracao_xy.stl calibracao_xy.scad

plate_w = 100;     // largura (X)
plate_d = 100;     // profundidade (Y)
plate_h = 3;        // espessura da base

boss_w  = 50;       // bloco de referência: deve medir exatamente 50,00mm em X e em Y
boss_h  = 2;

hole_big_d   = 26;   // mesmo diâmetro nominal do soquete de tubo (bore_d do projeto)
hole_small_d = 10;

$fn = 96;
e = 0.01;

module arrow(len, w) {
  linear_extrude(1.2)
    polygon([
      [0, -w/2], [len*0.65, -w/2], [len*0.65, -w],
      [len, 0], [len*0.65, w], [len*0.65, w/2], [0, w/2]
    ]);
}

module label(txt, sz = 9) {
  linear_extrude(1.2) text(txt, size = sz, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
}

module calibracao_xy() {
  union() {
    difference() {
      cube([plate_w, plate_d, plate_h]);
      translate([78, 28, -1]) cylinder(d = hole_big_d, h = plate_h + 2);
      translate([78, 50, -1]) cylinder(d = hole_small_d, h = plate_h + 2);
    }

    // bloco de referência 50 x 50mm, elevado 2mm — medir com paquímetro em X e em Y
    translate([5, 5, plate_h]) cube([boss_w, boss_w, boss_h]);

    // seta ao longo de +X (eixo do carro do bico)
    translate([60, 80, plate_h]) arrow(26, 6);
    translate([93, 80, plate_h]) label("X");

    // seta ao longo de +Y (eixo da mesa)
    translate([25, 60, plate_h]) rotate([0, 0, 90]) arrow(26, 6);
    translate([25, 93, plate_h]) label("Y");

    // rótulos dos diâmetros nominais, ao lado de cada furo
    translate([78, 10, plate_h]) label(str("D", hole_big_d), 5);
    translate([93, 50, plate_h]) label(str("D", hole_small_d), 4);
  }
}

calibracao_xy();
