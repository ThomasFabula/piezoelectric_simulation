program PIEZOMOD;

{ rechnet piezoelektrische Koeffizienten in Moduln um:  d_ij ---> e_ij

  Voraussetzung: hexagonale Kristallsymmetrie (6mm)
                 d.h.: ZnO, AlN, PZT

  Eingabe-Datei: PIEZO.KOF
   d_31, d_33, d_15 : piezoelektrische Koeffizienten
   C-11, C_12, C_13, C_33, C_44 : Elastizitaetsmodule

  Ausgabe-Datei: PIEZO.MOD
   e_31, e_33, e_15 : piezoelektrische Module
}

const  eps0=8.85542e-12;   {Dielektrizitästkonstante}

var d31,d33,d15,e31,e33,e15    : real;
    c11,c12,c13,c33,c44,s11    : real;
    eps11,eps33,k33,k31,kp,
    eps110,eps330              : real;
    kom1,kom2,kom3,kom4,
    filename                   : string[80];
    infile,outf                : text;

begin
 writeln('PIEZOMOD:      V1.1, 6/94, T.F. - HSG-IMIT');
 writeln('--------');
 writeln('rechnet piezoelektrische Koeffizienten in Moduln um:  d_ij ---> e_ij');
 writeln('unbedingte Voraussetzung: hexagonale Kristallsymmetrie (6mm)' );
 writeln('  z.B.: ZnO, AlN, PZT');
 writeln('Eingabe-Datei: PIEZO.KOF');
 writeln('  1. Kommentarzeile: Material');
 writeln('  2. Kommentarzeile: piezoelektrische Koeffizienten [C/N]');
 writeln('     d_31, d_33, d_15 ');
 writeln('  3. Kommentarzeile: Elastizitaetsmoduln [Pa]');
 writeln('     C_11, C_12, C_13, C_33, C_44 ');
 writeln('  4. Kommentarzeile: Permittivitaeten [C/Vm]');
 writeln('     eps_11^T, eps_33^T ');

 writeln('Ausgabe-Datei: PIEZO.MOD');
 writeln('Eingabe-Datei ergaenzt um:');
 writeln('  Kommentarzeile: piezoelektrische Moduln [C/N]');
 writeln('     e_31, e_33, e_15 ');

{ writeln('  elektromechanische Kopplungsfaktoren:');
 writeln('   longitudinal: k_11, transversal: k_31, planar: k_p');
}
 writeln('  transversaler elektromechanischer Kopplungsfaktor: k_31');
 writeln;

 write('Umrechnung beginnt...');

 assign(infile,'PIEZO.KOF');
 assign(outf,'PIEZO.MOD');
 reset(infile);
 rewrite(outf);
  readln(infile,kom1);            {1. Kommentarzeile einlesen}
  readln(infile,kom2);            {2. Kommentarzeile einlesen}
  readln(infile,d31, d33, d15);
  readln(infile,kom3);            {3. Kommentarzeile einlesen}
  readln(infile,c11,c12,c13,c33,c44);
  readln(infile,kom4);            {4. Kommentarzeile einlesen}
  readln(infile,eps11,eps33);
   eps110:=eps11*eps0;            {absolute Permittivitaeten}
   eps330:=eps33*eps0;

  { Berechnung der Module nach: e = d * C_E }
   e31:=d31*c11+d31*c12+d33*c13;
   e33:=2*(d31*c13)+d33*c33;
   e15:=d15*c44;

  { Berechnung der Kopplungsfaktoren }
   s11:=1/c11;
   k31:=abs(d31)/sqrt(s11*eps330);  {transversaler Effekt}

   {nue:=-s12/s11}
   {k33:=abs(d33)/sqrt(s33*eps330);}
   {kp:=2*k31/(1-nue)};

  writeln(outf,kom1);
  writeln(outf,kom2);
  writeln(outf,d31:10,'   ',d33:10,'   ',d15:10);
  writeln(outf,kom3);
  writeln(outf,c11:10,'   ',c12:10,'   ',c13:10,'   ',c33:10,'   ',c44:10);
  writeln(outf,kom4);
  writeln(outf,eps11:10,'   ',eps33:10);
  writeln(outf,'**** piezoelektrische Moduln: e_31, e_33, e_15 [C/N]');
  writeln(outf,e31:10,'   ',e33:10,'   ',e15:10);
  writeln(outf,'**** elektromechanischer Kopplungsfaktor:');
  writeln(outf,'---> k_31 = ',k31:10);

  {writeln(outf,'**** elektromechanische Kopplungsfaktoren: k_11, k_31, k_p');
  writeln(outf,k33:10,'   ',k31:10,'   ',kp:10);}

  writeln(outf,'---------------------------------------------------------------');
 close(infile);
 close(outf);
 writeln(' b e e n d e t !');
 writeln('piezoelektrische Moduln: e_31, e_33, e_15  [C/N]');
 writeln(e31:10,'   ',e33:10,'   ',e15:10);
 writeln('elektromechanischer Kopplungsfaktor:');
 writeln('---> k_31 = ',k31:10);
 writeln('---------------------------------------------------------------');
end.
