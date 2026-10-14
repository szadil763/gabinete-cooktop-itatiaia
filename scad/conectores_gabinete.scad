// Conectores do gabinete de cooktop | tubo Ø25,6 mm | PETG | Ender-3
// Exportar: openscad -D 'part="AP"' -o conector_AP.stl conectores_gabinete.scad
//   part = "AP"     canto com abas para parafusar o MDF (8 peças)
//   part = "B"      T de 3 soquetes de travessa (4 peças)
//   part = "HB"     suporte fixo da dobradiça (4 peças)
//   part = "HL"     peça da dobradiça presa à porta (4 peças)
//   part = "teste"  4 anéis para calibrar a folga do furo
// Soquetes dos POSTES: 30 mm, com batente (compressão vai direto tubo a tubo).
// Soquetes das TRAVESSAS: 66 mm de fundo, para o último tubo de cada laço poder
// entrar fundo num lado e voltar 30 mm no outro. Trave sempre com 30 mm de encaixe.
part = "AP";

tube_d   = 25.6;
clear    = 0.4;
bore_d   = tube_d + clear;
RO       = 16.3;
stop     = 16;             // fundo do furo, a partir do centro
m_post   = 46;             // boca do soquete de poste
d_post   = m_post - stop;  // 30
m_rail   = 82;             // boca do soquete de travessa
d_rail   = m_rail - stop;  // 66
flat_y   = 16;
roof_y   = 14;
top_y    = 18;
top_w    = 11.5;
lock_r   = m_rail - 14;    // parafuso de pressão da travessa (68 mm do centro)
boss_r   = 7;
boss_out = 22;
boss_out_B = 7.5;          // ressalto de trava do conector B (T), baixo para caber sob a prateleira única com rebaixo cego
nut_af   = 8.3;
nut_h    = 4.8;
screw_d  = 5.4;

panel_D  = 23;
ear_in   = 14.5;
ear_x0   = 22;
ear_x1   = 46;
ear_len  = 36;
hole_x   = 34;
hole_at  = 26;
m4_d     = 4.4;
m4_af    = 7.3;
m4_h     = 3.4;
post_lock_x = 32;

$fn = 96;
e = 0.01;

module tear_out() {
  union() {
    intersection() {
      union() {
        circle(r = RO);
        polygon([[-RO*cos(45), -RO*sin(45)], [RO*cos(45), -RO*sin(45)], [0, -RO*sqrt(2)]]);
      }
      translate([-50, -flat_y]) square([100, 100]);
    }
    translate([-top_w, 0]) square([2*top_w, top_y]);
  }
}

module tear_bore() {
  r = bore_d/2;
  a = r*cos(45);
  union() {
    circle(r = r);
    polygon([[-a, a], [a, a], [2*a - roof_y, roof_y], [-(2*a - roof_y), roof_y]]);
  }
}

module sockX(len) { rotate([90, 0, 90]) linear_extrude(len) children(); }
module sockY(len) { mirror([0, 1, 0]) rotate([90, 0, 0]) linear_extrude(len) children(); }

module boss_solid(h = boss_out) { cylinder(r = boss_r, h = h); }
module boss_cut(out = boss_out) {
  translate([0, 0, -e]) cylinder(d = screw_d, h = out + 2*e);
  translate([0, 0, out - nut_h]) cylinder(d = nut_af/cos(30), h = nut_h + e, $fn = 6);
}

module ear2d() {
  translate([-panel_D, -panel_D]) square([panel_D + ear_len, panel_D - ear_in]);
  translate([-panel_D, -panel_D]) square([panel_D - ear_in, panel_D + ear_len]);
}

module ears() {
  translate([ear_x0, 0, 0]) sockX(ear_x1 - ear_x0) ear2d();
  mirror([1, 0, 0]) translate([ear_x0, 0, 0]) sockX(ear_x1 - ear_x0) ear2d();
  translate([-ear_x0, -panel_D, -panel_D]) cube([2*ear_x0, panel_D + m_post, panel_D - flat_y]);
  translate([-12, m_post - e, -panel_D]) cube([24, m_rail - m_post + e, panel_D - flat_y]);
}

module m4_hole_F(sx) {
  translate([sx*hole_x, hole_at, 0]) {
    translate([0, 0, -panel_D - e]) cylinder(d = m4_d, h = panel_D - ear_in + 3*e + 1);
    translate([0, 0, -ear_in - m4_h]) cylinder(d = m4_af/cos(30), h = m4_h + 1, $fn = 6);
  }
}

module m4_hole_R(sx) {
  translate([sx*hole_x, 0, hole_at]) rotate([90, 0, 0]) {
    translate([0, 0, ear_in - 1]) cylinder(d = m4_d, h = panel_D - ear_in + 1 + e);
    translate([0, 0, ear_in - 1]) cylinder(d = m4_af/cos(30), h = m4_h + 1, $fn = 6);
  }
}

module AP() {
  translate([0, 0, panel_D]) difference() {
    union() {
      sockX(m_post) tear_out();
      mirror([1, 0, 0]) sockX(m_post) tear_out();
      sockY(m_rail) tear_out();
      cylinder(r = RO, h = m_rail);
      ears();
      translate([0, lock_r, 0]) rotate([0, 90, 0]) boss_solid();
      translate([0, 0, lock_r]) rotate([0, 90, 0]) boss_solid();
    }
    translate([stop, 0, 0]) sockX(d_post + 1) tear_bore();
    translate([-stop, 0, 0]) mirror([1, 0, 0]) sockX(d_post + 1) tear_bore();
    translate([0, stop, 0]) sockY(d_rail + 1) tear_bore();
    translate([0, 0, stop]) cylinder(d = bore_d, h = d_rail + 1);
    translate([0, lock_r, 0]) rotate([0, 90, 0]) boss_cut();
    translate([0, 0, lock_r]) rotate([0, 90, 0]) boss_cut();
    for (sx = [-1, 1]) {
      translate([sx*post_lock_x, 0, 0]) rotate([90, 0, 0]) boss_cut(panel_D);
      m4_hole_F(sx);
      m4_hole_R(sx);
    }
  }
}

module B() {
  translate([0, 0, flat_y]) difference() {
    union() {
      sockX(m_rail) tear_out();
      mirror([1, 0, 0]) sockX(m_rail) tear_out();
      sockY(m_rail) tear_out();
      for (p = [[lock_r, 0], [-lock_r, 0], [0, lock_r]]) translate([p[0], p[1], 0]) boss_solid(boss_out_B);
    }
    translate([stop, 0, 0]) sockX(d_rail + 1) tear_bore();
    translate([-stop, 0, 0]) mirror([1, 0, 0]) sockX(d_rail + 1) tear_bore();
    translate([0, stop, 0]) sockY(d_rail + 1) tear_bore();
    for (p = [[lock_r, 0], [-lock_r, 0], [0, lock_r]]) translate([p[0], p[1], 0]) boss_cut(boss_out_B);
  }
}

module teste() {
  for (i = [0:3]) translate([i*40, 0, 0]) difference() {
    cylinder(r = RO, h = 20);
    translate([0, 0, -e]) cylinder(d = tube_d + 0.2 + 0.2*i, h = 20 + 2*e);
  }
}


// ---------- Dobradiças das portas de acrílico (lado direito; o esquerdo é a mesma peça girada 180° em z) ----------
// Suporte fixo: parafusa nas abas frontais dos conectores (M4 x 14). Peça da porta: presa ao acrílico com M3 x 12.
// Pino: parafuso M3 x 55 com porca, vertical.
hx = 378.5;  hz = 292;  rk = 3.5;          // eixo do pino e raio dos nós
kA = 12;  kB = 24;  kg = 0.5;              // comprimentos dos nós e folga entre eles
pin_r = 1.7;

module alongY(y0, len) { translate([0, y0 + len, 0]) rotate([90, 0, 0]) linear_extrude(len) children(); }
module tear_pin() {
  a = pin_r*cos(45);
  union() { circle(r = pin_r); polygon([[-a, a], [a, a], [0, pin_r*sqrt(2)]]); }
}
module knuckle(y0, len) { translate([hx, y0, hz]) rotate([-90, 0, 0]) cylinder(r = rk, h = len, $fn = 48); }
module bore(y0, len) { translate([hx, 0, hz]) alongY(y0 - 1, len + 2) tear_pin(); }

module HB() {   // suporte fixo
  yA1 = -(kB/2 + kg + kA);  yA2 = kB/2 + kg;
  difference() {
    union() {
      translate([327, -41, 283]) cube([55, 82, 3]);
      for (y0 = [yA1, yA2]) {
        knuckle(y0, kA);
        translate([hx - rk, y0, 286]) cube([2*rk, kA, hz - 286]);
      }
    }
    for (y = [-34, 34]) translate([334, y, 282]) cylinder(d = 4.4, h = 6, $fn = 32);
    bore(yA1, kA); bore(yA2, kA);
  }
}

module HL() {   // peça da porta
  difference() {
    union() {
      translate([351, -24.5, 287.5]) cube([374.5 - 351, 49, 8.5]);
      translate([374.4, -kB/2, 287.5]) cube([hx - 374.4, kB, 8.5]);
      knuckle(-kB/2, kB);
    }
    for (y = [-12, 12]) {
      translate([359, y, 286.5]) cylinder(d = 3.4, h = 11, $fn = 24);
      translate([359, y, 287.5 - 0.01]) cylinder(d = 5.8/cos(30), h = 2.6 + 0.01, $fn = 6);
    }
    bore(-kB/2, kB);
  }
}

if (part == "AP") AP();
else if (part == "B") B();
else if (part == "HB") HB();
else if (part == "HL") HL();
else teste();
