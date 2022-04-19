{
4. Dada la siguiente estructura:
type
reg_flor = record
nombre: String[45];
codigo:integer;
tArchFlores = file of reg_flor;
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:

//Abre el archivo y agrega una flor, recibida como parámetro
//manteniendo la política descripta anteriormente

procedure agregarFlor (var a: tArchFlores ; nombre: string;
codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.   
}


program ejer4prac3;
type
  reg_flor = record
    nombre: String[45];
    codigo:integer;
  end;

  tArchFlores = file of reg_flor;
  
 
procedure mostrarArchivo (var a: tArchFlores);
var
  flor: reg_flor;
begin
  reset (a);
  while (not EOF (a)) do
    begin
      read (a, flor);
      writeln ('NOMBRE: ', flor.nombre);
      writeln ('CODIGO: ', flor.codigo);
      writeln ();
    end;
  close (a);
end;


procedure eliminarFlor (var a: tArchFlores; flor: reg_flor); //FLOR.CODIGO = 382
var
  cabecera, flor_act: reg_flor;      //CONTENIDO   -4 | 672 | 382 | 098 | 0  | 192 | EOF
  encontre : boolean;                //NRR          0 |  1  |  2  |  3  | 4  |  5  |
begin
  reset (a);
  read (a, cabecera);                //CABECERA -4
  encontre := false;
  while (not EOF (a) and (not encontre)) do
    begin
      read (a, flor_act);            //FLOR_ACT  672 | 382 |
                                     // A -->                NRR 3
      if (flor_act.codigo = flor.codigo) then
        begin
          encontre := true;
          flor_act.codigo := cabecera.codigo;  //FLOR_ACT.CODIGO = -4      
          cabecera.codigo := ((filePos (a) -1 )* -1); //CABECERA = -2
          seek  (a, filePos (a) -1);  
          write (a, flor_act);        //CONTENIDO   -4 | 672 | -4 | 098 | 0  | 192 | EOF
          seek (a, 0);
          write (a, cabecera);       //CONTENIDO    -2 | 672 | -4 | 098 | 0  | 192 | EOF
        end;
    end;
  close (a);
end;

procedure agregarFlor (var a: tArchFlores; nombre: string; codigo: integer);
var
  cabecera, flor : reg_flor;
begin
  reset (a);
  read (a, cabecera);
  flor.nombre := nombre;
  flor.codigo := codigo;
  if (cabecera.codigo = 0) then
    begin
      seek (a, fileSize (a));
      write (a, flor);
    end
  else
    begin
      seek (a, cabecera.codigo * -1);
      read (a, cabecera);
      seek (a, filePos (a) -1 );
      write (a, flor);    
      seek (a, 0);
      cabecera.nombre := ' ';
      write (a, cabecera);
    end;
  close (a);
end;
    
procedure crearArchivo (var arch_flores: tArchFlores);
var
  flor: reg_flor;
begin
  rewrite (arch_flores);
  flor.nombre := '';
  flor.codigo := 0;
  write (arch_flores, flor);
  close (arch_flores);
end;

function menuOpciones (): integer;
var
  opc: integer;
begin
  writeln ('***************MENU****************');
  writeln ('1. Crear archivo ');
  writeln ('2. Agregar flor');
  writeln ('3. Eliminar flor');
  writeln ('4. Mostrar novelas');
  writeln ('*******************************');
  write ('Ingrese una opcion: ');
  readln (opc);
  writeln;
  if ((opc >0) and (opc < 5)) then
    menuOpciones := opc
  else
    begin 
      writeln ();
      write ('La opcion ingresada es invalida');
      menuOpciones := -1;  
    end;
end;

var 
  arch_flores: tArchFlores;
  flor: reg_flor;
  opc: integer;
BEGIN
  assign (arch_flores, 'archivo_flores');
  opc := menuOpciones ();
  case opc of
    1: crearArchivo (arch_flores);
    2: begin 
        write ('Ingrese el nombre: ');
        readln (flor.nombre);
        write ('Ingrese el codigo: ');
        readln (flor.codigo);
        agregarFlor (arch_flores, flor.nombre, flor.codigo);
      end;
    3: begin 
         write ('Ingrese el nombre: ');
         readln (flor.nombre);
         write ('Ingrese el codigo: ');
         readln (flor.codigo);        
         eliminarFlor (arch_flores, flor);
       end;
    4: mostrarArchivo (arch_flores);
  end;	
END.

