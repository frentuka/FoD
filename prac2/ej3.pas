program ej3;

// 3.​ A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un archivo
//     que contiene los siguientes datos:
//         nombre de provincia,
//         cantidad de personas alfabetizadas
//         y cantidad de encuestados.
//     Se reciben dos archivos detalle provenientes de dos agencias de censo diferentes. Dichos archivos contienen:
//         nombre de la provincia,
//         código de localidad,
//         cantidad de alfabetizados
//         y cantidad de encuestados.
//     Se pide realizar los módulos necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
//     NOTA: Los archivos están ordenados por nombre de provincia
//         y en los archivos detalle pueden venir 0, 1 ó más registros por cada provincia.

const
    base_folder = 'BDD/p2e3/';

type
    provincia = record
        nombre: string;
        cant_alfabetizados, cant_encuestados: integer;
    end;

    encuesta = record
        nombre_provincia: string;
        codigo_localidad, cant_alfabetizados, cant_encuestados: integer;
    end;

    file_prov = file of provincia;
    file_enc = file of encuesta;

//     Se reciben dos archivos detalle provenientes de dos agencias de censo diferentes.
//     Se pide realizar los módulos necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
//     NOTA: Los archivos están ordenados por nombre de provincia
//         y en los archivos detalle pueden venir 0, 1 ó más registros por cada provincia.

procedure actualizar(var file_m: file_prov; var file_d1: file_enc; var file_d2: file_enc);
var tmp_prov: provincia;
    tmp_enc1, tmp_enc2: encuesta;
begin
    // se presupone que los archivos ya están preasignados
    reset(file_m); reset(file_d1); reset(file_d2);

    if not eof(file_d1) then read(file_d1, tmp_enc1);
    if not eof(file_d2) then read(file_d2, tmp_enc2);

    while not eof(file_m) do begin
        read(file_m, tmp_prov);

        // leer data de archivos detalle
        while (not eof(file_d1)) and (tmp_enc1.nombre = tmp_prov.nombre) do begin
            tmp_prov.cant_alfabetizados = tmp_prov.cant_alfabetizados + tmp_enc1.cant_alfabetizados;
            tmp_prov.cant_encuestados = tmp_prov.cant_encuestados + tmp_enc1.cant_encuestados;
            if not eof(file_d1) then read(file_d1, tmp_enc1);
        end;
        
        while (not eof(file_d2)) and (tmp_enc2.nombre = tmp_prov.nombre) do begin
            tmp_prov.cant_alfabetizados = tmp_prov.cant_alfabetizados + tmp_enc2.cant_alfabetizados;
            tmp_prov.cant_encuestados = tmp_prov.cant_encuestados + tmp_enc2.cant_encuestados;
            if not eof(file_d2) then read(file_d2, tmp_enc2);
        end;

        // almacenar provincia en maestro
        seek(file_m, filepos(file_m) - 1);
        write(file_m, tmp_prov);
    end;

    close(file_m); close(file_d1); close(file_d2);
end;