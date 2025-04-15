program ej7;


    // Se dispone de un archivo con información de los alumnos de la Facultad de Informática.
    //     Por cada alumno se dispone de:
    //         su código de alumno,
    //         apellido,
    //         nombre,
    //         cantidad de materias (cursadas) aprobadas sin final
    //         y cantidad de materias con final aprobado.
            
    //     Además, se tiene un archivo detalle con el código de alumno e información correspondiente a una materia
    //         (esta información indica si aprobó la cursada o aprobó el final).
        
    //     Todos los archivos están ordenados por código de alumno
    //     y en el archivo detalle puede haber 0, 1 ó más registros por cada alumno del archivo maestro.
    //     Se pide realizar un programa con opciones para:

    // a.
    //     Actualizar el archivo maestro de la siguiente manera:
        
    //     i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado
    //         y se decrementa en uno la cantidad de materias sin final aprobado.
        
    //     ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final.
    
    // b.
    //     Listar en un archivo de texto aquellos alumnos que tengan más materias con finales aprobados
    //         que materias sin finales aprobados.
    //     Teniendo en cuenta que este listado es un reporte de salida (no se usa con fines de carga),
    //     debe informar todos los campos de cada alumno en una sola línea del archivo de texto.
    
    // NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.

const
    base_folder = 'BDD/p2e2/';

type
    alumno = record
        codigo, cant_mat_aprobadas, cant_mat_promocionadas: integer;
        nombre, apellido: string;
    end;

    alumno_detalle = record
        codigo: integer;
        aprobo_cursada, aprobo_final: boolean;
    end;

    file_alumno = file of alumno;
    file_alumno_d = file of alumno_detalle;


// a.
//     Actualizar el archivo maestro de la siguiente manera:

//     i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado
//         y se decrementa en uno la cantidad de materias sin final aprobado.

//     ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final.

//     Se deben recorrer los archivos una única vez.

//     Todos los archivos están ordenados por código de alumno


procedure actualizarArchivoMaestro(var file_m: file_alumno; var file_d: file_alumno_d);
var tmp_alumno: alumno;
    tmp_alumno_d: alumno_detalle;
begin
    // file_m y file_d están preasignados
    reset(file_m); reset(file_d);

    // Recorrido del archivo detalle
    while not eof(file_d) do begin
        read(file_d, tmp_alumno_d);
        
        // Encontrar alumno correspondiente
        while (tmp_alumno.codigo <> tmp_alumno_d.codigo) and not eof(file_m) do
            read(file_m, tmp_alumno);

        // Realizar todas las operaciones "juntas"
        while (tmp_alumno.codigo = tmp_alumno_d.codigo) and not eof(file_d) do begin
            // Operación
            if tmp_alumno_d.aprobo_final then begin
                tmp_alumno.cant_mat_aprobadas:= tmp_alumno.cant_mat_aprobadas - 1;
                tmp_alumno.cant_mat_promocionadas:= tmp_alumno.cant_mat_promocionadas + 1;
            end else if tmp_alumno_d.aprobo_cursada do
                tmp_alumno.cant_mat_aprobadas:= tmp_alumno.cant_mat_aprobadas + 1;
            
            read(file_d, tmp_alumno_d);
        end;

        // Volver atrás una posición en archivo detalle, ya que "se pasa"
        seek(file_d, filepos(file_d) - 1);

        // Guardar en archivo maestro
        seek(file_m, filepos(file_m) - 1);
        write(file_m, tmp_alumno);
    end;

    close(file_m); close(file_d);
end;


// b.
//     Listar en un archivo de texto aquellos alumnos que tengan más materias con finales aprobados
//         que materias sin finales aprobados.
//     Teniendo en cuenta que este listado es un reporte de salida (no se usa con fines de carga),
//     debe informar todos los campos de cada alumno en una sola línea del archivo de texto.


procedure alumnosFinalesPendientes(var file_m: file_alumno; var file_t: Text);
var tmp_alumno: alumno;
begin
    // file_m y file_t están preasignados
    reset(file_m);
    rewrite(file_t);

    while not eof(file_m) do begin
        read(file_m, tmp_alumno);
        
        if (tmp_alumno.cant_mat_aprobadas > tmp_alumno.cant_mat_promocionadas) then
            writeln(file_t, tmp_alumno.codigo, ' ', tmp_alumno.nombre, ' ', tmp_alumno.apellido, ' ', tmp_alumno.cant_mat_aprobadas, ' ', tmp_alumno.cant_mat_promocionadas, ' ');
    end;

    close(file_m); close(file_t);
end;