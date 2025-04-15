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
        cant_alfabetizadas, cant_encuestados: integer;
    end;

    encuesta = record
        nombre_provincia: string;
        codigo_localidad, cant_alfabetizados, cant_encuestados: integer;
    end;

//     Se reciben dos archivos detalle provenientes de dos agencias de censo diferentes.
//     Se pide realizar los módulos necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
//     NOTA: Los archivos están ordenados por nombre de provincia
//         y en los archivos detalle pueden venir 0, 1 ó más registros por cada provincia.

procedure actualizar();
begin

end;