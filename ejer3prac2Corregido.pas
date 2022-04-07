{
3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. 
Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
}

program ejer3prac2;
uses SysUtils;  ///LPM 
const 
  cantSucursales = 30;
  valorAlto = 9999;
type
  producto = record
    codProd: integer;
    nombre: string;
    descripcion: string;
    stockDisp: integer;
    stockMin: integer;
    precio: real;
  end;
  
  archivoProductos = file of producto;
  
  venta = record
    codProd : integer;
    cantVend: integer;
  end;
  
  archivoVentas = file of venta;
  
  vectorArchivoVentas = array [1..cantSucursales] of archivoVentas;
  vectorRegistroVenta = array [1..cantSucursales] of venta;
  
  
procedure listarStockPorDebajo (var archMaestro: archivoProductos);
var
  archText: text;
  prod: producto;
begin
  assign (archText, 'productos_debajo_del_stockMin');
  rewrite (archText);
  reset (archMaestro);
  while (not EOF (archMaestro)) do
    begin
      read (archMaestro, prod);
      if (prod.stockDisp < prod.stockMin) then
        begin
          writeln (archText,prod.nombre);
          writeln (archText, prod.stockDisp);
          writeln (archText, prod.precio);
          writeln (archText, prod.descripcion);
        end;
    end;
  close (archMaestro);
  close (archText);
end;  
  
procedure cerrarArchivoDetalles (var vecArchDetalles: vectorArchivoVentas);
var 
  i: integer;
begin
  for i := 1 to cantSucursales do
    begin
      close (vecArchDetalles [i]);
    end;

end;
  
procedure leerDetalle (var archDetalle: archivoVentas; var vent:venta);
begin
  if (not EOF (archDetalle)) then
    read (archDetalle, vent)
  else
    vent.codProd := valorAlto;
end;


procedure buscarMinimoYActualizar (var vecArchDetalles: vectorArchivoVentas; var vecRegDetalles: vectorRegistroVenta; 
                                   var ventaMin: venta);
var
  i, pos: integer;
begin
  ventaMin.codProd := valorAlto;
  for i:= 1 to cantSucursales do 
    begin
      if (vecRegDetalles[i].codProd < ventaMin.codProd) then
        begin
          ventaMin := vecRegDetalles[i];
          pos := i;
        end;
    end;
  if (ventaMin.codProd <> valorAlto) then
     leerDetalle (vecArchDetalles [pos], vecRegDetalles [pos]);
end;
                                   
  
procedure cargarVectorRegistros (var vecArchDetalles: vectorArchivoVentas; var vecRegDetalles: vectorRegistroVenta);  
var
  i: integer;
begin
  for i := 1 to cantSucursales do
    leerDetalle (vecArchDetalles [i], vecRegDetalles [i]);
end;


procedure resetVectorArchivoDetalles (var vecArchDetalle: vectorArchivoVentas);
var 
  i: integer;
begin
  for i := 1 to cantSucursales do
    reset (vecArchDetalle [i]);
end;


procedure actualizarMaestro (var archMaestro: archivoProductos; var vecArchDetalles: vectorArchivoVentas);
var
  prod : producto;
  ventaMin, ventaAct: venta;
  vecRegDetalles: vectorRegistroVenta;
begin
  reset (archMaestro);
  resetVectorArchivoDetalles (vecArchDetalles);
  cargarVectorRegistros (vecArchDetalles, vecRegDetalles);
  buscarMinimoYActualizar (vecArchDetalles, vecRegDetalles, ventaMin);  
  while (ventaMin.codProd <> valorAlto) do 
    begin
      ventaAct.codProd := ventaMin.codProd;
      ventaAct.cantVend := 0;
      while (ventaAct.codProd = ventaMin.codProd) do
        begin
          ventaAct.cantVend := ventaAct.cantVend + ventaMin.cantVend;
          buscarMinimoYActualizar (vecArchDetalles, vecRegDetalles, ventaMin);    
        end;
      //busco el codigo en el maestro
      read (archMaestro, prod);
      while (prod.codProd <> ventaAct.codProd) do
        read (archMaestro, prod);
      prod.stockDisp := prod.stockDisp - ventaAct.cantVend;
      seek (archMaestro, filePos (archMaestro) -1);
      write (archMaestro, prod);
    end;
  close (archMaestro);
  cerrarArchivoDetalles (vecArchDetalles);
end;

procedure assignVectorArchivoDetalles (var vecArchDetalles: vectorArchivoVentas);
var 
  i: integer;
  nomArch: string;
begin
  for i := 1 to cantSucursales do
    begin
      nomArch := ('detalle_'+IntToStr(i));
      assign (vecArchDetalles [i], nomArch);
    end;
end;

var
  archMaestro : archivoProductos;
  vecArchDetalles: vectorArchivoVentas;
  
BEGIN
  assign (archMaestro, 'archivo_maestro');
  assignVectorArchivoDetalles (vecArchDetalles);
  actualizarMaestro (archMaestro, vecArchDetalles);
  listarStockPorDebajo (archivoMaestro);
END.

