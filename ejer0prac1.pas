{
   
   
}


program ejer0prac2;
type
  comision = record
    codEmp: integer;
    nomEmp: string;
    monto: real;
  end;
  
  archivoComisiones = file of comision;
  
procedure mostrarInfo (comi:comision);
begin
  writeln ('CODIGO: ', comi.codEmp);
  writeln ('NOMBRE: ', comi.nomEmp);
  writeln ('MONTO: ', comi.monto:3:0);
  writeln;
end;
  
procedure imprimirArchivo (var arch: archivoComisiones);
var
  comi: comision;
begin
  reset (arch);
  while (not eof (arch)) do
    begin
      read (arch, comi);  
      mostrarInfo (comi);
    end;
  close (arch);
end;

procedure leerComision (var comi: comision);
begin
  with comi do
    begin
      write ('Ingrese codigo de empleado: ');
      readln (codEmp);
      if (codEmp <> -1) then
        begin
          write ('Ingrese nombre del empleado: ');
          readln (nomEmp);
          write ('Ingrese monto: ');
          readln (monto);
        end;
    end;
end;
  
procedure generarArchivo (var arch: archivoComisiones);
var
  comi: comision;
begin
  rewrite (arch);
  leerComision (comi);
  while (comi.codEmp <> -1) do
    begin
      write (arch, comi);
      leerComision (comi);
    end;
  close (arch);
end;

  
function menuOpciones : integer;
var 
  opc: integer;
begin
  writeln ('-------------MENU--------------');
  writeln ('1. Generar archivo');
  writeln ('2. Imprimir archivo');
  writeln ('------------------------------------------');
  writeln;
  write ('Ingrese el numero de operacion que desea realizar: ');
  readln (opc);
  menuOpciones := opc;
end; 

var
  archComi: archivoComisiones;
  nomArch: string;
  opc: integer;
BEGIN
  write ('Ingrese el nombre del archivo: ');
  readln (nomArch);
  assign (archComi, nomArch);
  opc := menuOpciones;
  case opc of
    1: generarArchivo (archComi);
    2: imprimirArchivo (archComi);
  end;
END.

