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

program ejer2prac2;
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
    estadoFinal: boolean
    estadoCursada: boolean;
  end;
  
  archivoMateria = file of materia;
  
var
  archDetalle: archivoMateria; // estos archivos estan ordenados
  archMaestro: archivoAlumnos; // por codigo de alumno
  archText: text;
  opc: integer;
BEGIN
  assign (archMaestro, 'archivoMaestroAlumnos');
  assign (archDetalle, 'archivoDetalleMaterias');
  opc:= menuOpciones;
  case opc of
    1..2: if opc = 1 then
            begin
              assign (archText, 'alumnos.txt');      
              crearArchivo (archMaestro, archText);
            end
          else
            begin
              assign (archText, 'detalle.txt');
              crearArchivo (archDetalle, archText);
            end;
    3..4: if opc = 3 then
            begin
              assign (archText, 'reporteAlumnos.txt');
              importarArchivo (archMaestro, archText);
            end
          else
            begin
              assign (archText, 'reporteDetalle.txt');
              importarArchivo (archDetalle, archText);
            end;
    5: actualizarMaestro (archMaestro, archDetalle);
    6: listarAlumnosCursadaSinFinal (archMaestro);
       
  end;
END.

