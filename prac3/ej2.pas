program ej2;

// Definir un programa que genere un archivo con registros de longitud fija conteniendo información
//     de asistentes a un congreso a partir de la información obtenida por teclado.
//     Se deberá almacenar la siguiente información:
//         - nro de asistente
//         - apellido y nombre
//         - email
//         - teléfono
//         - DNI
//     Implementar un procedimiento que, a partir del archivo de datos generado,
//     elimine de forma lógica todos los asistentes con nro de asistente inferior a 1000.
//     Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo String a su elección.
//     Ejemplo: '@Saldaño'.

const
    base_folder = 'BDD/p3e2/';

type
    asistente = record
        numero, dni: integer;
        apellido, nombre, email, telefono: string;
    end;

    file_asistentes = file of asistente;


// La eliminación lógica colocará el prefijo '@' en el campo APELLIDO del asistente eliminado.
procedure purgarArchivo(var file_as: file_asistentes);
var tmp_as: asistente;
begin
    reset(file_as);

    while not eof(file_as) do begin
        read(file_as, tmp_as);

        if (tmp_as.numero < 1000) and (tmp_as.apellido[1] <> '@') then begin
            tmp_as.apellido:= '@' + tmp_as.apellido;
            seek(file_as, filepos(file_as) - 1);
            write(file_as, tmp_as);
            seek(file_as, filepos(file_as) + 1);
        end;
    end;

    close(file_as);
end;