{
6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
con la información correspondiente a las prendas que se encuentran a la venta. De
cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.

Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
que no fueron borradas, una vez realizadas todas las bajas físicas.
   
}


program ejer6prac3;
type
  reg_prenda = record
    codigo: integer;
    descripcion, colores, tipo_prenda: string;
    stock: integer;
    precio: real;
  end;

  archivoPrendas = file of reg_prenda;
  
  archivoObsoletas = file of integer;

  
procedure compactarArchivoPrendas (var arch_prendas: archivoPrendas);
var
  prenda: reg_prenda;
  arch_prendas_actualizado: archivoPrendas;
begin
  assign (arch_prendas, 'archivo_prendas_actualizado');
  rewrite (arch_prendas_actualizado);
  reset (arch_prendas);
  while (not EOF (arch_prendas)) do
    begin
      read (arch_prendas, prenda);
      if (prenda.stock > 0) then
        begin
          write (arch_prendas_actualizado, prenda);
        end;
    end;
  close (arch_prendas);
  close (arch_prendas_actualizado);

end;

  
procedure modificarStockPrendas (var arch_prendas:archivoPrendas; var arch_obsoletas: archivoObsoletas);
var
  codigo : integer;
  prenda : reg_prenda;
  encontre: boolean;
begin
  reset (arch_obsoletas);
  reset (arch_prendas);
  codigo := 0;
  while (not EOF (arch_obsoletas)) do 
    begin
      read (arch_obsoletas, codigo);
      encontre := false;
      seek (arch_prendas, 0);
      while ((not EOF (arch_prendas)) and (not encontre))do
        begin
          read (arch_prendas, prenda);
          if (prenda.codigo = codigo) then
            begin
              encontre := true;
              prenda.stock := prenda.stock * -1;
              seek (arch_prendas, filePos (arch_prendas) -1);
              write (arch_prendas, prenda);
            end;
        end;
    end;
  close (arch_obsoletas);
  close (arch_prendas);
end;


 
procedure crearArchivoPrendas (var arch_prendas: archivoPrendas); //se dispone 
begin

end;
 
function menuOpciones (): integer;
var
  opc: integer;
begin
  writeln ('***************MENU****************');
  writeln ('1. Crear archivo de prendas ');
  writeln ('2. Crear archivo prendas obsoletas para invierno');
  writeln ('3. Modificar stock prendas');
  writeln ('4. Compactar archivo prendas');
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
  arch_prendas : archivoPrendas;
  arch_obsoletas: archivoObsoletas;
  opc: integer;
  
BEGIN 
  assign (arch_prendas, 'archivo_prendas');
  assign (arch_obsoletas, 'archivo_prendas_obsoletas');
  opc:= menuOpciones ();
  case opc of
    //1: crearArchivoPrendas (arch_prendas); //se dispone
    //2: crearArchivoObsoletas (arch_obsoletas);  //se dispone
	3: modificarStockPrendas (arch_prendas, arch_obsoletas);
    4: compactarArchivoPrendas (arch_prendas);
  end;
END.

