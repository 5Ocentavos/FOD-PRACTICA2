{
2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Crear el archivo maestro a partir de un archivo de texto llamado “alumnos.txt”.
b. Crear el archivo detalle a partir de en un archivo de texto llamado “detalle.txt”.
c. Listar el contenido del archivo maestro en un archivo de texto llamado
“reporteAlumnos.txt”.
d. Listar el contenido del archivo detalle en un archivo de texto llamado
“reporteDetalle.txt”.
e. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
f. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso e) los archivos deben ser recorridos sólo una vez.
}

{
El usuario puede querer actualizar más de una vez al maestro.
¿Cómo controlo que la actualizacion del maestro no se haga más de una vez? 

}

program ejer2prac2;
const
  valorAlto = 9999;
type
  alumno = record
    codAlumno: integer;
    apellido: string;
    nombre: string;
    cantConFinal: integer;
    cantSinFinal: integer;
  end;
  
  archivoAlumnos = file of alumno;
  
  materia = record
    codAlumno: integer;
    codMateria: integer;
    estadoCursada: char;
  end;
  
  archivoMaterias = file of materia;
  
procedure listarAlumnosCursadaSinFinal (var archMaestro: archivoAlumnos);
var
  alum: alumno;
  archText : text;
begin
  assign (archText, 'alumnosCursadaSinFinal.txt');
  reset (archMaestro);
  rewrite (archText);
  while (not EOF (archMaestro)) do 
    begin
      read (archMaestro, alum);
      if (alum.cantSinFinal > 4)then
        writeln (archText, alum.codAlumno,' ', alum.nombre, ' ', alum.apellido, ' ', alum.cantConFinal, ' ', alum.cantSinFinal); 
    end;
  close (archMaestro);
  close (archText);
end;  

procedure leerMateria (var archDetalle: archivoMaterias; var mat: materia);
begin
  if (not EOF (archDetalle)) then
    read (archDetalle, mat)
  else
    mat.codAlumno := 9999;
end;
  
procedure actualizarMaestro (var archMaestro: archivoAlumnos; var archDetalle: archivoMaterias);
var
  mat: materia;
  alum: alumno;
begin
  reset (archDetalle);
  reset (archMaestro);
  leerMateria (archDetalle, mat);
  while (mat.codAlumno <> valorAlto) do
    begin
      read (archMaestro, alum);  
      while (mat.codAlumno = alum.codAlumno) do
        begin
          if (mat.estadoCursada = 'f') then
            alum.cantSinFinal := alum.cantSinFinal + 1
          else
            alum.cantConFinal := alum.cantConFinal + 1;
          leerMateria (archDetalle, mat);
        end;
      seek (archMaestro, filePos(archMaestro) -1);
      write (archMaestro, alum);
    end;
  close (archDetalle);
  close (archMaestro);
end; 
  
  
  
procedure importarArchivoDetalle (var archDetalle: archivoMaterias; var archText:  text);
var
  mat: materia;
begin
  reset (archDetalle);
  rewrite (archText);
  while (not EOF (archDetalle)) do 
    begin
      read (archDetalle, mat);
      writeln (archText, mat.codAlumno,' ', mat.codMateria, ' ', mat.estadoCursada); 
    end;
  close (archDetalle);
  close (archText);
end;  
 
procedure importarArchivoMaestro (var archMaestro: archivoAlumnos; var archText:  text);
var
  alum: alumno;
begin
  reset (archMaestro);
  rewrite (archText);
  while (not EOF (archMaestro)) do 
    begin
      read (archMaestro, alum);
      writeln (archText, alum.codAlumno,' ', alum.nombre, ' ', alum.apellido, ' ', alum.cantConFinal, ' ', alum.cantSinFinal); 
    end;
  close (archMaestro);
  close (archText);
end;  

procedure crearArchivoDetalle (var archDetalle: archivoMaterias; var archText: text);
var
  mat: materia;
begin
  rewrite (archDetalle);
  reset (archText);  //El enunciado no me dice como estan dispuestos los datos en el archivo de texto...
  while (not EOF (archText)) do
    begin
      readln (archText, mat.codAlumno, mat.codMateria, mat.estadoCursada);
      write (archDetalle, mat);
    end;
  close (archDetalle);
  close (archText);
end;
  
procedure crearArchivoMaestro (var archMaestro: archivoAlumnos; var archText: text);
var
  alum: alumno;
begin
  rewrite (archMaestro);
  reset (archText);  //El enunciado no me dice como estan dispuestos los datos en el archivo de texto...
  while (not EOF (archText)) do
    begin
      readln (archText, alum.codAlumno, alum.apellido);
      readln (archText, alum.nombre);
      readln (archText, alum.cantConFinal, alum.cantSinFinal);
      write (archMaestro, alum);
    end;
  close (archMaestro);
  close (archText);
end;

function mostrarMenu: integer;  
var 
  opc: integer;
begin
  writeln ('-------------MENU--------------');
  writeln ('1. Crear archivo maestro');
  writeln ('2. Crear archivo detalle');
  writeln ('3. Exportar contenido del archivo maestro ');
  writeln ('4. Exportar contenido del archivo detalle');	
  writeln ('5. Actualizar maestro');
  writeln ('6. Exportar alumnos que tengan más de cuatro materias con cursada aprobada pero no aprobaron el final.');
  writeln ('------------------------------------------');
  write ('Ingrese el numero de operacion que desea realizar: ');
  readln (opc);
  mostrarMenu := opc;
end; 


var
  archDetalle: archivoMaterias; // estos archivos estan ordenados
  archMaestro: archivoAlumnos; // por codigo de alumno
  archText: text;
  opc: integer;
BEGIN
  assign (archMaestro, 'archivoMaestroAlumnos');
  assign (archDetalle, 'archivoDetalleMaterias');
  opc:= mostrarMenu;
  case opc of
    1: begin
         assign (archText, 'alumnos.txt');      
         crearArchivoMaestro (archMaestro, archText);
       end;
    2: begin
         assign (archText, 'detalle.txt');
         crearArchivoDetalle (archDetalle, archText);
       end;        
    3: begin
         assign (archText, 'reporteAlumnos.txt');
         importarArchivoMaestro (archMaestro, archText);
       end;
    4: begin
         assign (archText, 'reporteDetalle.txt');
         importarArchivoDetalle (archDetalle, archText);
       end;
    5: actualizarMaestro (archMaestro, archDetalle);
    6: listarAlumnosCursadaSinFinal (archMaestro);
  end;
END.

