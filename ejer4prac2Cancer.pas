program j1r4;
uses SysUtils;
const
	cant_pc=5;
	valoralto = 9999;  
type
 fec=record
	dia:integer;
	mes:String;
	anio:integer;
 end;
 log=record
	cod:integer;
	fecha:fec;
	tiempo:real;
end;



 archivo_detalles=file of log;
  archivo_Maestro=file of log;
  detallesArc=array[1..cant_pc] of archivo_detalles;
  detalles= array[1..cant_pc] of log;
  procedure leer (var archivo:archivo_detalles; var dato:log);    
begin      

if (not eof( archivo ))  then begin
 read (archivo, dato);
 end 
 else begin dato.cod := valoralto;    end;
 

end;
procedure minimo (var reg_det: detalles; var min:log; var deta:detallesArc);    
var
  i,indiceMin:integer;
begin
  indiceMin:=1;
  min.cod:=valoralto;
  min.fecha.dia:=valoralto;
  for i:=1 to cant_pc do
    if (reg_det[i].cod < min.cod) then begin
      indiceMin:=i;
      min:=reg_det[i];
    end;
  leer(deta[indiceMin],reg_det[indiceMin]);
end;
 
  var
   logdt:log;
   dtArc:detallesArc;
   dtReg:detalles;
	mtArc:archivo_Maestro;
	mtReg:log;
   i:integer;
   c:String;
   nombreDefault,nombreArchivo:String;
begin

		writeln('Ingrese el nombre del archivo a crear :' );
		readln(nombreDefault);
		{crea archivo binarios}
	for i:= 1 to cant_pc do begin   
		c:=' '+IntToStr(i);
		nombreArchivo:=nombreDefault+c;
		
		assign(dtArc[i],nombreArchivo);
		
		rewrite(dtArc[i]);
			 writeln('crear Archivo ',nombreArchivo);
	writeln('-----------------------------');
			 writeln('Ingrese codigo de usuario: ');
			 readln(logdt.cod);
	 while (logdt.cod<>0) do begin
				
				 writeln('Ingrese dia: ');
				 readln(logdt.fecha.dia);
				 writeln('Ingrese mes: ');
				 readln(logdt.fecha.mes);
				 writeln('Ingrese anño: ');
				 readln(logdt.fecha.anio);
				 writeln('Ingrese tiempo de uso: ');
				 readln(logdt.tiempo);
				 write(dtArc[i],logdt);
				 writeln('-----------------------------');
				 writeln('Ingrese cod: ');
				 readln(logdt.cod);
			 end;
      

      close(dtArc[i]);

	end;{}
 {lectura de binarios    }
 writeln('lectura de binarios ');
writeln('-----------------------------');
for i:= 1 to cant_pc do begin  
		c:=' '+IntToStr(i);
		nombreArchivo:=nombreDefault+c;
		assign(dtArc[i],nombreArchivo); 
		 reset(dtArc[i]);
while not eof(dtArc[i]) do begin
			   read(dtArc[i], logdt);
			   
					writeln('Codigo : ', logdt.cod);
					writeln('tiempo: ', logdt.tiempo);
					writeln('año: ', logdt.fecha.anio);
					writeln('mes: ', logdt.fecha.mes);
					writeln('dia: ', logdt.fecha.dia);
					writeln('-----------------------------');

	end;
	close(dtArc[i]);
end;
{Actualizar Un Maestro con n detalle}
writeln('Actualizar Un Maestro con n detalle ');
writeln('-----------------------------');
for i:= 1 to cant_pc do begin    
		c:=' '+IntToStr(i);
		nombreArchivo:=nombreDefault+c;
		assign(dtArc[i],nombreArchivo);    { ojo lo anterior es incompatible en tipos}        
reset( dtArc[i] );    
leer( dtArc[i], dtReg[i] );  
end;  
assign (mtArc, 'maestro'); 
rewrite (mtArc);  
minimo (dtReg, logdt, dtArc);
while (logdt.cod <> valoralto) do begin       
	mtReg.cod := logdt.cod;  
	mtReg.fecha:= logdt.fecha;       
	mtReg.tiempo := 0;   
 
	while(  {(mtReg.fecha.dia = logdt.fecha.dia)and}(mtReg.cod = logdt.cod) ) do begin      
		
		mtReg.tiempo :=mtReg.tiempo+logdt.tiempo;     
		
		minimo (dtReg, logdt, dtArc);    
		
	end;    
	writeln(logdt.cod);
	write(mtArc, mtReg);     
end;  
  close(mtArc);
  writeln('Mostrar Maestro ');
writeln('-----------------------------');
  for i:=1 to cant_pc do
    close(dtArc[i]);   
    assign (mtArc, 'maestro'); 
		 reset(mtArc);
while not eof(mtArc) do begin
			   read(mtArc,mtReg);
			   
					writeln('Codigo : ', mtReg.cod);
					writeln('fecha : ', mtReg.fecha.dia,'/',mtReg.fecha.mes,'/',mtReg.fecha.anio);
					writeln('tiempo: ', mtReg.tiempo:2:2);

					writeln('-----------------------------');

	end;
	close(mtArc);

end.
