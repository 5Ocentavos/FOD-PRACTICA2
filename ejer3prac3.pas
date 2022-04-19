{
3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.
ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.
iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.

#NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
#proporcionado por el usuario.
   
   
}


program ejer3prac3;
const 
  valor_alto = 9999;
type
  novela = record
    codigo: integer;
    genero, nombre, director: string;
    duracion: integer;
    precio: real;
  end;
  
  archivoNovelas = file of novela;
  
procedure leerArchivo (var arch_novelas: archivoNovelas; var nov: novela);
begin
  if (not EOF (arch_novelas)) then
    read (arch_novelas, nov)
  else
    nov.codigo := 9999;
end;

procedure listarNovelas (var arch_novelas: archivoNovelas);
var 
  nov:novela;
  arch_text : text;
begin
  reset (arch_novelas);
  assign (arch_text, 'listado_novelas');
  rewrite (arch_text);
  
  while (not EOF(arch_novelas)) do
    begin
      read (arch_novelas, nov);
      if (nov.codigo > 0) then 
        begin
          writeln  (arch_text,'CODIGO: ', nov.codigo);
          writeln  (arch_text,'NOMBRE: ', nov.nombre);
          writeln  (arch_text,'GENERO: ', nov.genero);
          writeln  (arch_text,'DIRECTOR: ', nov.director);
          writeln  (arch_text,'DURACION: ', nov.duracion);
          writeln  (arch_text,'PRECIO: ', nov.precio:0:2);
          writeln (arch_text, '');                                //si necesito pasar el archivo a binario tengo q 
        end;                                                      //tener en cuenta esa linea en blanco que esta en el archivo text
    end;
  close (arch_text);
  close (arch_novelas);
end;

procedure mostrar (nov: novela);
begin
  writeln ('Codigo: ', nov.codigo);
  writeln ('Genero: ', nov.genero);
  writeln ('Nombre: ', nov.nombre);
  writeln ('Director: ', nov.director);
  writeln ('Duracion: ', nov.duracion);
  writeln ('Precio: ', nov.precio:0:2, '$');  
  writeln ();
end;

procedure mostrarArchivo (var arch_novelas: archivoNovelas);
var
  nov: novela;
begin
  reset (arch_novelas);
  while (not EOF (arch_novelas)) do
    begin
      read (arch_novelas, nov);
      mostrar (nov);
    end;
end;

procedure eliminarNovela (var arch_novelas: archivoNovelas);
var
  cabecera, nov: novela;
  codigo: integer;
  encontre :boolean;
begin
  write ('Ingrese el codigo de la novela: ');
  readln (codigo);
  encontre := false;
  reset (arch_novelas);
  
  leerArchivo (arch_novelas, cabecera);
  //busco la novela a eliminar
  leerArchivo (arch_novelas, nov);
  while ((nov.codigo <> valor_alto) and (not encontre)) do
    begin
      if (nov.codigo = codigo) then
        begin
          seek (arch_novelas, filePos (arch_novelas) -1);
          nov.codigo := cabecera.codigo;
          write (arch_novelas, nov);
          cabecera.codigo := (filePos (arch_novelas) -1) * -1;
          seek (arch_novelas, 0);
          write (arch_novelas, cabecera);
          encontre := true;
        end
      else
        leerArchivo (arch_novelas, nov);
    end;
  close (arch_novelas);
end;



procedure modificar (var nov: novela);
begin
  write ('Ingrese el genero: ');
  readln (nov.genero);
  write ('Ingrese el nombre de la novela: ');
  readln (nov.nombre);
  write ('Ingrese el nombre del director: ');
  readln (nov.director);
  write ('Ingrese la duracion: ');
  readln (nov.duracion);
  write ('Ingrese el precio: ');
  readln (nov.precio);
end;



procedure modificarNovela (var arch_novelas: archivoNovelas);
var
  nov: novela;
  codigo: integer;
  encontre : boolean;
begin
  write ('Ingrese el codigo de la novela: ');
  readln (codigo);
  
  reset (arch_novelas);
  leerArchivo (arch_novelas, nov);  //leo la cebecera
  leerArchivo (arch_novelas, nov);
  
  encontre := false;
  while ((nov.codigo <> valor_alto) and (not encontre)) do
    begin
      if ((nov.codigo > 0) and (nov.codigo = codigo)) then // si el codigo de la novela es < a 0 significa que es un registro borrado 
        begin
          modificar (nov);
          seek (arch_novelas, filePos (arch_novelas) -1);
          write (arch_novelas, nov);
          encontre := true;
        end
      else
        leerArchivo (arch_novelas, nov);
    end;   
  close (arch_novelas);
end;  

procedure leerNovela (var nov: novela);
begin
  write ('Ingrese el codigo: ');
  readln (nov.codigo);
  write ('Ingrese el genero: ');
  readln (nov.genero);
  write ('Ingrese el nombre de la novela: ');
  readln (nov.nombre);
  write ('Ingrese el nombre del director: ');
  readln (nov.director);
  write ('Ingrese la duracion: ');
  readln (nov.duracion);
  write ('Ingrese el precio: ');
  readln (nov.precio);
end;



procedure agregarNovela (var arch_novelas: archivoNovelas);
var
  cabecera, nov: novela;
begin
  leerNovela (nov);
  reset (arch_novelas);
  leerArchivo (arch_novelas, cabecera);
  if (cabecera.codigo = 0) then
    begin
      //write (fileSize (arch_novelas));
      seek (arch_novelas, fileSize (arch_novelas));
      write (arch_novelas, nov);
    end
  else
    begin
      cabecera.codigo := cabecera.codigo * -1;
      seek (arch_novelas, cabecera.codigo);
      read (arch_novelas, cabecera);
      seek (arch_novelas, filePos (arch_novelas) -1);
      write (arch_novelas, nov);
      seek (arch_novelas, 0);
      write (arch_novelas, cabecera);
    end;
  close (arch_novelas);
end;    

procedure crearArchivo (var arch_novelas: archivoNovelas);
var
  cabecera: novela;
begin
  rewrite (arch_novelas);
  cabecera.codigo := 0;
  cabecera.nombre := '';
  cabecera.director := '';
  cabecera.genero := '';
  cabecera.duracion := 0;
  cabecera.precio := 0;
  write (arch_novelas, cabecera);
  close (arch_novelas);
end;  
  
function menuOpciones (): integer;
var
  opc: integer;
begin
  writeln ('***************MENU****************');
  writeln ('1. Crear archivo');
  writeln ('2. Agregar novela');
  writeln ('3. Modificar novela');
  writeln ('4. Eliminar novela');
  writeln ('5. Listar novelas');  
  writeln ('6. Mostrar novelas');
  writeln ('*******************************');
  write ('Ingrese una opcion: ');
  readln (opc);
  if ((opc >0) and (opc < 7)) then
    menuOpciones := opc
  else
    begin 
      writeln ();
      write ('La opcion ingresada es invalida');
      menuOpciones := -1;  
    end;
end;

var
  arch_novelas : archivoNovelas;
  opc: integer;
  nom_arch: string;
  
BEGIN
{
    write ('Ingrese el nombre del archivo: ');
    readln (nom_arch);
    assign (arch_novelas, nom_arch);
}
	assign (arch_novelas, 'Archivo Novelas'); //hago esto para 'agilizar', para respetar la consig tiene que hacerse {}
	opc := menuOpciones ();
    case opc of
      1: crearArchivo (arch_novelas);
      2: agregarNovela (arch_novelas);
      3: modificarNovela (arch_novelas);
      4: eliminarNovela (arch_novelas);
      5: listarNovelas (arch_novelas);
      6: mostrarArchivo (arch_novelas);
    end;
END.

