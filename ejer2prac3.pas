{
2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.
   
}


program ejer2prac3;
type
  asistente = record
    nro_asistente: integer;
    apellido, nombre, email: string;
    telefono, dni: longint;
  end;
 
  archivoAsistentes = file of asistente;
  
procedure mostrar (a: asistente);
begin
  writeln ('NUMERO: ', a.nro_asistente);
  writeln ('APELLIDO: ', a.apellido);
  writeln ('Nombre: ', a.nombre);
  writeln ('EMAIL: ', a.email);
  writeln ('DNI: ', a.dni);
  writeln ('TEL: ', a.telefono);  
  writeln ();
end;

  
  
procedure mostrarArchivo (var arch_asistentes: archivoAsistentes);
var
  asis: asistente;
begin
  reset (arch_asistentes);
  while (not EOF (arch_asistentes)) do
    begin
      read (arch_asistentes, asis);
      mostrar (asis);
    end;
end;

  
procedure eliminarAsistentes (var arch_asistentes: archivoAsistentes);
var
  asis: asistente;
begin
  reset (arch_asistentes);
  while (not EOF (arch_asistentes)) do 
    begin
      read (arch_asistentes, asis);
      if (asis.nro_asistente < 1000) then
        begin
          asis.apellido := '#' + asis.apellido;
          seek (arch_asistentes, filePos (arch_asistentes) - 1);
          write (arch_asistentes, asis);
        end;
    end;
  close (arch_asistentes);
end;
  
procedure leerAsistente (var asis: asistente);
begin
  write ('Ingrese el numero de asistente: ');
  readln (asis.nro_asistente);
  if (asis.nro_asistente <> -1)then
    begin
      write ('Ingrese el apellido: ');
      readln (asis.apellido);
      write ('Ingrese el nombre: ');
      readln (asis.nombre);
      write ('Ingrese el e-mail: ');
      readln (asis.email);
      write ('Ingrese la telefono: ');
      readln (asis.telefono);
      write ('Ingrese el dni: ');
     readln (asis.dni);
    end;
  writeln ();
end;
  
procedure crearArchivoYCargar (var arch_asistentes: archivoAsistentes);
var
  asis: asistente;
begin
  rewrite (arch_asistentes);
  leerAsistente (asis);
  while (asis.nro_asistente <> -1) do
    begin
      write (arch_asistentes, asis); //write escribe los datos seguidos? cuando lea y haga readln puedo ignorar datos?
      leerAsistente (asis);
    end;
  close (arch_asistentes);
end;
  
function menuOpciones (): integer;
var
  opc: integer;
begin
  writeln ('***************MENU****************');
  writeln ('1. Crear archivo y cargar');
  writeln ('2. Eliminar asistentes con numero menor a 1000');
  writeln ('3. Mostrar novelas');
  writeln ('*******************************');
  write ('Ingrese una opcion: ');
  readln (opc);
  writeln;
  if ((opc >0) and (opc < 4)) then
    menuOpciones := opc
  else
    begin 
      writeln ();
      write ('La opcion ingresada es invalida');
      menuOpciones := -1;  
    end;
end;

var
  arch_asistentes : archivoAsistentes;
  opc : integer;

BEGIN
  assign (arch_asistentes, 'archivo_asistentes');
  opc := menuOpciones ();
  case opc of
    1: crearArchivoYCargar (arch_asistentes);
    2: eliminarAsistentes (arch_asistentes);
    3: mostrarArchivo (arch_asistentes);
  end;
END.

