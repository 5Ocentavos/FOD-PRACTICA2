{
5. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información.
Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
nacimiento, nombre, apellido, dirección detallada(calle,nro, piso, depto, ciudad), matrícula
del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
padre.
En cambio los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
lugar.
Realizar un programa que cree el archivo maestro a partir de toda la información los
archivos. Se debe almacenar en el maestro: nro partida nacimiento, nombre, apellido,
dirección detallada(calle,nro, piso, depto, ciudad), matrícula del médico, nombre y apellido
de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció, además
matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se deberá,
además, listar en un archivo de texto la información recolectada de cada persona.

Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.
}

program ejer5prac2;
const
  cant_delegaciones = 50;
  valor_alto = 9999;
type
  dir = record
    calle: string;
    nro, piso, departamento: integer;
    ciudad: string;
  end;
  
  nacimiento = record
    nro_partida: integer;
    nombre, apellido: string;
    direccion: dir;
    matricula_medico_nacimiento: integer;
    nombre_madre, apellido_madre: string;
    dni_madre: integer;
    nombre_padre, apellido_padre: string;
    dni_padre: integer;
  end;
  
  archivoNacimientos = file of nacimiento;
  
  vectorArchivoNacimientos = array [1..cant_delegaciones] of archivoNacimientos;
  vectorRegistroNacimientos  = array [1..cant_delegaciones] of nacimiento;
  
  datos_defuncion = record
    dni: integer;
    matricula_medico_fallecimiento: integer;
    fecha_deceso: string;
    hora: real;
    lugar: string;
  end;
  
  fallecimiento = record
    nro_partida: integer;
    nombre, apellido: string;
    estado : boolean //true muerto, falso vivo
    dni: integer;
    matricula_medico_fallecimiento: integer;
    fecha_deceso: string;
    hora: real;
    lugar: string;
  end;
  
  archivoFallecimientos = file of fallecimiento;
  
  vectorArchivoFallecimientos = array [1..cant_delegaciones] of archivoFallecimientos;
  vectorRegistroFalleciminetos  = array [1..cant_delegaciones] of fallecimiento;
  
  acta = record
    nro_partida: integer;
    nombre, apellido: string;
    //
    direccion: dir;
    matricula_medico_nacimiento: integer;
    nombre_madre, apellido_madre: string;
    dni_madre: integer;
    nombre_padre, apellido_padre: string;
    dni_padre: integer;
    //
    
    dni: integer;
    matricula_medico_fallecimiento: integer;
    fecha_deceso: string;
    hora: real;
    lugar: string;
    
  end;
  
  archivoDeActas = file of acta;
  
procedure minimo (var persona_minima: acta; var nacimiento_minimo: nacimiento; var  fallecimiento_minimo: fallecimiento;
                  var vec_reg_nacimientos: vectorRegistroNacimientos; var vec_reg_fallecimientos: vectorRegistroFallecimientos;
                  var vec_arch_nacimientos: vectorArchivoNacimientos; var vec_arch_fallecimientos: vectorArchivoFallecimientos);
begin
  persona_minima.numero_partida := valor_alto;
  minimoNacimiento (nacimiento_minimo, vec_reg_nacimientos, vec_arch_nacimientos);
  minimoFallecimiento (fallecimiento_minimo, vec_reg_nacimientos, vec_arch_nacimientos);
  if ((nacimiento_minimo.numero_partida <> valor_alto) and (fallecimiento_minimo.numero_partida <> valor_alto)) then
    begin
      if (nacimiento_minimo.numero_partida = fallecimiento_minimo.numero_partida) then 
        begin
          persona_minima.numero_partida := nacimiento_minimo.numero_partida;
          persona_minima.nombre := nacimiento_minimo.nombre;
          persona_minima.apellido := nacimiento_minimo.apellido;
          
          persona_minima.direccion := nacimiento_minimo.direccion;
          persona_minima.matricula_medico_nacimiento := nacimiento_minimo.matricula_medico_nacimiento;
          persona_minima.nombre_madre := nacimiento_minimo.nombre_madre;
          persona_minima.apellido_madre := nacimiento_minimo.apellido_madre;
          persona_minima.nombre_padre := nacimiento_minimo.nombre_padre;
          persona_minima.apellido_padre := nacimiento_minimo.apellido_padre;
          persona_minima.dni_padre := nacimiento_minimo.dni_padre;
          
          persona_minima.matricula_medico_fallecimiento := fallecimiento_minimo.matricula_medico_fallecimiento;
          persona_minima.fecha_deceso := fallecimiento_minimo.fecha_deceso;
          persona_minima.hora := fallecimiento_minimo.hora;
          persona_minima.lugar := fallecimiento_minimo.lugar;
        end;
      else
        if (nacimiento_minimo.numero_partida < fallecimiento_minimo.numero_partida) then
          begin
            persona_minima.numero_partida := nacimiento_minimo.numero_partida;
            persona_minima.nombre := nacimiento_minimo.nombre;
            persona_minima.apellido := nacimiento_minimo.apellido;
            
            persona_minima.direccion := nacimiento_minimo.direccion;
            persona_minima.matricula_medico_nacimiento := nacimiento_minimo.matricula_medico_nacimiento;
            persona_minima.nombre_madre := nacimiento_minimo.nombre_madre;
            persona_minima.apellido_madre := nacimiento_minimo.apellido_madre;
            persona_minima.nombre_padre := nacimiento_minimo.nombre_padre;
            persona_minima.apellido_padre := nacimiento_minimo.apellido_padre;
            persona_minima.dni_padre := nacimiento_minimo.dni_padre;
            
            persona_minima.matricula_medico_fallecimiento := 0;
            persona_minima.fecha_deceso := ' ';
            persona_minima.hora := 0;
            persona_minima.lugar := ' ';
            
          end;
        else
          begin
            persona_minima.numero_partida := fallecimiento_minimo.numero_partida;
            persona_minima.nombre := fallecimiento_minimo.nombre;
            persona_minima.apellido := fallecimiento_minimo.apellido;
          
            persona_minima.direccion := ' ';
            persona_minima.matricula_medico_nacimiento := ' ';
            persona_minima.nombre_madre := ' ';
            persona_minima.apellido_madre := ' ';
            persona_minima.nombre_padre := ' ';
            persona_minima.dni_madre := 0;
            persona_minima.apellido_padre := ' ';
            persona_minima.dni_padre := 0;
          
            persona_minima.matricula_medico_fallecimiento := fallecimiento_minimo.matricula_medico_fallecimiento;
            persona_minima.fecha_deceso := fallecimiento_minimo.fecha_deceso;
            persona_minima.hora := fallecimiento_minimo.hora;
            persona_minima.lugar := fallecimiento_minimo.lugar;
           
          end;
    end;
end;

procedure crearMaestro (var arch_maestro: archivoDeActas; var vec_arch_nacimientos: vectorArchivoNacimientos; 
                                                          var vec_arch_fallecimientos: vectorArchivoFallecimientos);
var
  persona_minima: acta;
  nacimiento_minimo: nacimiento;
  fallecimiento_minimo: fallecimiento;
  vec_reg_nacimientos: vectorRegistroNacimientos;
  vec_reg_fallecimientos: vectorRegistroFallecimientos;
begin
  rewrite (arch_maestro);
  resetVectorNacimientos (vec_arch_nacimientos);
  resetVectorFallecimientos (vec_arch_fallecimientos);
  //
  cargarVectorNacimientos (vec_reg_nacimientos, vec_arch_nacimientos);
  cargarVectorFallecimientos (vec_reg_fallecimientos, vec_arch_fallecimientos);
  //
  minimo (persona_minima, nacimiento_minimo, fallecimiento_minimo, vec_reg_nacimientos, vec_reg_fallecimientos, vec_arch_nacimientos, vec_arch_fallecimientos);
  while (persona_minima.numero_partida <> valor_alto) do
    begin
      write (arch_maestro, persona_minima);
      minimo (persona_minima, nacimiento_minimo, fallecimiento_minimo, vec_reg_nacimientos, vec_reg_fallecimientos, vec_arch_nacimientos, vec_arch_fallecimientos);
    end;
  //
  close (arch_maestro);
  closeVectorNacimientos (vec_arch_nacimientos);
  closeVectorFallecimientos (vec_arch_fallecimientos);
end;
  
var
  arch_maestro: archivoDeActas;
  vec_arch_nacimientos: vectorArchivoNacimientos;
  vec_arch_fallecimientos: vectorArchivoFallecimientos;
BEGIN
  assign (arch_maestro, ' ');
  assignVectorArchivoNacimientos (vec_arch_nacimientos);
  assignVectorArchivoFallecimientos (vec_arch_fallecimientos);
  crearMaestro (arch_maestro, vec_arch_nacimientos, vec_arch_fallecimientos);
  listarInfoMaestro (arch_maestro);
END.

