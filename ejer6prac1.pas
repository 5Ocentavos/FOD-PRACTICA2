{
6. Agregar al menú del programa del ejercicio 5, opciones para:

a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.   
   
}


program tiendaCelulares;
type
  celular = record
    codCel: integer;
    precio: real;
    marca: string;
    stockDisp: integer;
    stockMin: integer;
    desc: string;
    nombre: string;
  end;
  
  archivoCelulares = file of celular;
  

procedure exportarArchBinSinStock (var archCel: archivoCelulares);
var
  archText: text; //¿Está bien declararlo acá?¿O tiene que estar en el PP?
  cel: celular;
begin
  assign (archText, 'SinStock.txt');
  rewrite (archText);
  reset (archCel);
  while (not eof (archCel)) do
    begin
      read (archCel, cel);
      if (cel.stockDisp = 0) then
        with cel do
          writeln (archText, codCel, ' ', precio, ' ', marca,' ', desc, ' ', nombre); 
    end;
  close (archText);
  close (archCel);
end;
    
procedure modificarStock (var archCel:archivoCelulares);
var
  nombreCel: string;
  cel: celular;
  encontre: boolean;
begin
  write ('Ingrese el nombre del celular: ');
  readln (nombreCel);
  encontre := false;  //PARA DEJAR DE RECORRER EL ARCHIVO UNA VEZ QUE LO ENCONTRE
  reset (archCel);
  while ((not eof (archCel)) and (not encontre)) do
    begin
      read (archCel, cel);
      if (cel.nombre = nombreCel) then
        begin
          encontre := true;
          write ('Ingrese el nuevo stock: ');
          readln (cel.stockDisp);
          seek (archCel, (filePos (archCel) - 1));
          write (archCel, cel);
        end;
    end;
  close (archCel);
end;

procedure leerCelular (var cel: celular);
begin
  with cel do
    begin
      write ('CODIGO : ');
      readln  (codCel);
      write ('PRECIO: ');
      readln (precio);
      write ('MARCA: '); 
      readln (marca);
      write ('STOCK DISPONIBLE: '); readln (stockDisp);
      write ('STOCK MINIMO: '); readln (stockMin);
      write ('DESCRIPCION: '); readln (desc);
      write ('NOMBRE: '); readln (nombre);
    end;
end;
  
procedure aniadirCel (var archCel: archivoCelulares);
var
  cel: celular;
begin
  leerCelular (cel);
  //append (archCel); según el compilador está instrucción solo sirve para archivos txt
  reset (archCel);
  seek (archCel, fileSize (archCel));
  write (archCel, cel);
  close (archCel);
end; 
  
  
procedure exportarArchBin (var archCel: archivoCelulares; var archText: text);
var
  cel: celular;
begin
  reset (archCel); 
  assign (archText, 'todosCelularesExpor');
  rewrite (archText);
  while (not eof(archCel)) do
    begin
      read (archCel, cel);
      with cel do
        writeln(archText,' ',codCel,' ',precio,' ', marca,' ',stockDisp,' ',stockMin, ' ', desc,' ', nombre);
    end;
  close (archCel);
  close (archText);
end;  

  
procedure mostrarInfo (cel: celular);
begin
  with cel do
    begin
      writeln ('CODIGO : ', codCel);
      writeln ('PRECIO: ',precio:3:0,'$');
      writeln ('MARCA:',marca);
      writeln ('STOCK DISPONIBLE: ',stockDisp);
      writeln ('STOCK MINIMO: ',stockMin);
      writeln ('DESCRIPCION: ',desc);
      writeln ('NOMBRE: ', nombre);
      writeln;
    end;
end;
  
  
procedure imprimirCelDesc (var archCel:archivoCelulares);
var
  cel: celular;
  descripcion: string;
begin
  write ('Ingrese una descripcion: ');
  readln (descripcion);
  reset (archCel);
  while (not eof (archCel)) do
    begin
      read (archCel, cel);
      if (cel.desc = descripcion) then
        mostrarInfo (cel);
    end;
  close (archCel); 
end;


procedure imprimirStockMin (var archCel: archivoCelulares);
var
  cel: celular;
begin
  reset (archCel);
  while (not eof (archCel)) do
    begin
      read (archCel, cel);
      if (cel.stockDisp < cel.stockMin) then
        mostrarInfo (cel);
    end;
  close (archCel); //no es necesario invocar a esta funcion ya que solo leimos los datos del archivo, no modificamos nada. 
end;

procedure crearYcargar (var archCel: archivoCelulares; var archText1: text);
var
  cel: celular;
begin
  rewrite (archCel);
  {Le asigno a mi archivo de texto su correspondiente ruta fisica}
  assign (archText1, 'todosCelulares.txt');
  reset (archText1);
  {Hago la copia/trasferencia de datos de mi archivo txt a un archivo binario}
  while (not eof (archText1)) do
    begin
      with cel do
        begin
          readln (archText1, codCel, precio, marca);
          readln (archText1, stockDisp, stockMin, desc);
          readln (archText1, nombre); //que hace esto señora??
        end;
      write (archCel, cel);
    end;
  {Cierro los respectivos archivos}
  close (archCel);
  close (archText1);
end;

function mostrarMenu: integer;  
var 
  opc: integer;
begin
  writeln ('-------------MENU--------------');
  writeln ('1. Crear archivo y cargarlo');
  writeln ('2. Imprimir Stock Minimo');
  writeln ('3. Imprimir celulares con determinada descripcion ');
  writeln ('4. Exportar archivo binario a text');	
  writeln ('5. Añadir celular al archivo');
  writeln ('6. Modificar stock de un celular existente');
  writeln ('7. Exportar archivo binario a un archivo texto los celulares sin stock');	
  writeln ('------------------------------------------');
  write ('Ingrese el numero de operacion que desea realizar: ');
  readln (opc);
  mostrarMenu := opc;
end; 


var 
  archCel: archivoCelulares;
  archText1: text;
  archText2: text;
  opc: integer;
  nomArch: string;
BEGIN
  {Leo el nombre fisico para mi archivo binario}
  write ('Ingrese el nombre del archivo: ');
  readln (nomArch);
  assign (archCel, nomArch);
  {Llamo a un metodo que muestra el menu con opciones y el leo una}
  opc := mostrarMenu;
  case opc of
    1: crearYcargar (archCel, archText1);
    2: imprimirStockMin (archCel);
    3: imprimirCelDesc (archCel);
    4: exportarArchBin (archCel, archText2);
    5: aniadirCel (archCel);
    6: modificarStock (archCel);
    7: exportarArchBinSinStock (archCel);
  end;
END.


