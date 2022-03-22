{
1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.
   
}


program ejer1prac2;
type
  comision = record
    codEmp: integer;
    nomEmp: string;
    monto: real;
  end;
  
  archivoComisiones = file of comision;

procedure leerComision (var archTodos: archivoComisiones; var comi: comision);
begin
  if (not eof (archTodos)) then
    read (archTodos, comi)
  else
    comi.codEmp := 9999;
end;
  
procedure compactar (var archTodos: archivoComisiones; var archNuevo: archivoComisiones);
var
  comiTotal, comiAct: comision;
 
begin
  reset (archTodos);
  rewrite (archNuevo);
  leerComision (archTodos, comiAct);
  while (comiAct.codEmp <> 9999) do
    begin
      comiTotal.monto := 0;
      comiTotal.codEmp := comiAct.codEmp;
      comiTotal.nomEmp := comiAct.nomEmp;
      while (comiAct.codEmp = comiTotal.codEmp) do
        begin
          comiTotal.monto := comiTotal.monto + comiAct.monto;
          leerComision (archTodos, comiAct);
        end;
      write (archNuevo, comiTotal);    
    end;
  close (archTodos);
  close (archNuevo);
end;

var
  archNuevo: archivoComisiones;
  archTodos: archivoComisiones;
  nomArch: string;
BEGIN
  write ('Ingrese el nombre del archivo a compactar: ');
  readln (nomArch);
  assign (archTodos, nomArch);
  write ('Ingrese el nombre del nuevo archivo: ');
  readln (nomArch);
  assign (archNuevo, nomArch);
  compactar (archTodos, archNuevo);
END.

