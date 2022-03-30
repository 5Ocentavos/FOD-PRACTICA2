{
3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
}

program ejer3prac2;
uses SysUtils;  ///LPM 
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
  
  vectorArchivoVentas = array [1..30] of archivoVentas;
  vectorRegistroVenta = array [1..30] of venta;
  

procedure buscarMinimoYActualizar (var vectorArchivoDetalles: vectorArchivoVentas; var vectorRegistrosDetalle: vectorRegistroVenta; 
                                   var ventaMin: venta);
var
  i: integer;
begin
  

end;
                                   
  
procedure cargarVectorRegistros (var vecArchDetalles: vectorArchivoVentas; var vecRegDetalle: vectorRegistroVenta);  
var
  i: integer;
begin
  for i := 1 to 30 do
    begin
      if (not EOF (vecArchDetalles [i])) then
        read (vecArchDetalles[i], vecRegDetalle [i])
      else
        vecRegDetalle [i].codProd := 9999;
    end;
end;


procedure actualizarMaestro (var archivoMaestro: archivoProductos; var vectorArchivoDetalles: vectorArchivoVentas);
var
  prod : producto;
  ventaMin, ventaAct: venta;
  vecRegistrosDetalle: vectorRegistroVenta;
begin
  cargarVectorRegistros (vectorArchivoDetalles, vectorRegistrosDetalle);
  buscarMinimoYActualizar (vectorArchivoDetalles, vectorRegistrosDetalle, ventaMin);
  
  while (ventaMin.codProd <> 9999) do 
    begin
      ventaAct.codProd := ventaMin.codProd;
      ventaAct.cantVend := 0;
      while (ventaAct.codProd = ventaMin.codProd) do
        begin
          ventaAct.cantVend := ventaAct.cantVend + ventaMin.cantVend;
          buscarMinimoYActualizar (vectorArchivoDetalles, vectorRegistrosDetalle, ventaMin);    
        end;
      //busco el codigo en el maestro
      while ((not EOF (archivoMaestro)) and (prod.codProd <> ventaAct.codProd)) do
        read (archMaestro, prod);
      prod.stockDisp := prod.stockDisp - ventaAct.cantVend;
      seek (archivoMaestro, filePos (archivoMaestro) -1);
      write (archivoMaestro, prod);
    end;
  
end;

procedure hacerAssignDeLosDetallesYAbrirlos (var vectorArchivoDetalle: vectorArchivoVentas);
var 
  i: integer;
  nomArch: string;
begin
  for i := 1 to 30 do
    begin
      nomArch := ('detalle_'+IntToStr(i));
      assign (vectorArchivoDetalle [i], nomArch);
      reset (vectorArchivoDetalle [i]);
    end;
end;



var
  archivoMaestro : archivoProductos;
  vectorArchivoDetalles: vectorArchivoVentas;
  

BEGIN
  assign (archivoMaestro, 'archivo_maestro');
  reset (archivoMaestro);
  hacerAssignDeLosDetallesYAbrirlos (vectorArchivoDetalles);
  actualizarMaestro (archivoMaestro, vectorArchivoDetalles);
//  listarStockPorDebajo (archivoMaestro);
END.

