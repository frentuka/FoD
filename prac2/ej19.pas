// A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos
//     de toda la provincia de buenos aires de los últimos diez años.
//     En pos de recuperar dicha información, se deberá procesar
//     2 archivos por cada una de las 50 delegaciones distribuidas en la provincia,
//     un archivo de nacimientos y otro de fallecimientos
//     y crear el archivo maestro reuniendo dicha información.
    
//     Los archivos detalles con nacimientos contendrán la siguiente información:
//         nro partida nacimiento,
//         nombre,
//         apellido,
//         dirección detallada (calle, nro, piso, depto, ciudad),
//         matrícula del médico,
//         nombre y apellido de la madre,
//         DNI madre,
//         nombre y apellido del padre,
//         DNI del padre.
//     En cambio, los 50 archivos de fallecimientos tendrán:
//         nro partida nacimiento,
//         DNI,
//         nombre y apellido del fallecido,
//         matrícula del médico que firma el deceso,
//         fecha y hora del deceso
//         y lugar.

//         Realizar un programa que cree el archivo maestro a partir de toda la información de los archivos detalles.
//         Se debe almacenar en el maestro:
//             nro partida nacimiento,
//             nombre,
//             apellido,
//             dirección detallada (calle, nro, piso, depto, ciudad),
//             matrícula del médico,
//             nombre y apellido de la madre,
//             DNI madre,
//             nombre y apellido del padre,
//             DNI del padre y si falleció.
//             además matrícula del médico que firma el deceso,
//             fecha y hora del deceso
//             y lugar.
//         Se deberá, además, listar en un archivo de texto la información recolectada de cada persona.
//         Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
//         Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona
//         y además puede no haber fallecido.

program ej19;

const
    base_folder = 'BDD/p2e19/';
    cant_delegaciones = 3;


type
    direccion = record
        calle, depto, ciudad: string;
        nro, piso: integer;
    end;

//     Los archivos detalles con nacimientos contendrán la siguiente información:
//         nro partida nacimiento,
//         nombre,
//         apellido,
//         dirección detallada (calle, nro, piso, depto, ciudad),
//         matrícula del médico,
//         nombre y apellido de la madre,
//         DNI madre,
//         nombre y apellido del padre,
//         DNI del padre.

    detalle_nacimiento = record
        partida_nacimiento, matricula_medico, dni_madre, dni_padre: integer;
        nombre, apellido, nombre_madre, nombre_padre, apellido_madre, apellido_padre: string;
        direccion: direccion;
    end;

//     En cambio, los 50 archivos de fallecimientos tendrán:
//         nro partida nacimiento,
//         DNI,
//         nombre y apellido del fallecido,
//         matrícula del médico que firma el deceso,
//         fecha y hora del deceso
//         y lugar.

    detalle_fallecimiento = record
        partida_nacimiento, dni, matricula_medico: integer;
        nombre, apellido, fecha, lugar: string;
        hora: integer;
    end;

//         Se debe almacenar en el maestro:
//             nro partida nacimiento,
//             nombre,
//             apellido,
//             dirección detallada (calle, nro, piso, depto, ciudad),
//             matrícula del médico,
//             nombre y apellido de la madre,
//             DNI madre,
//             nombre y apellido del padre,
//             DNI del padre y si falleció.
//             además matrícula del médico que firma el deceso,
//             fecha y hora del deceso
//             y lugar.

    record_maestro = record
        partida_nacimiento, matricula_medico, matricula_medico_deceso, dni_madre, dni_padre, hora_deceso: integer;
        nombre, apellido, nombre_madre, nombre_padre, apellido_madre, apellido_padre, fecha_deceso, lugar_deceso: string;
        fallecio: boolean;
        direccion: direccion;
    end;

// A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos
//     de toda la provincia de buenos aires de los últimos diez años.
//     En pos de recuperar dicha información, se deberá procesar
//     2 archivos por cada una de las 50 delegaciones distribuidas en la provincia,
//     un archivo de nacimientos y otro de fallecimientos
//     y crear el archivo maestro reuniendo dicha información.

    file_nacimiento = file of detalle_nacimiento;
    file_fallecimiento = file of detalle_fallecimiento;
    file_maestro = file of record_maestro;

    detalle_delegacion = record
        nacimientos: file_nacimiento;
        fallecimientos: file_fallecimiento;
    end;

    arr_delegaciones = array[1..cant_delegaciones] of detalle_delegacion;


    procedure copiarDireccion(origen: direccion; var destino: direccion);
    begin
{
        direccion = record
            calle, depto, ciudad: string;
            nro, piso: integer;
        end;
}
        destino.calle:= origen.calle; destino.depto:= origen.depto; destino.ciudad:= origen.ciudad;
        destino.nro:= origen.nro; destino.piso:= origen.piso;
    end;

    procedure resetearDetalleMaestro(var det: record_maestro);
    begin
{
        record_maestro = record
            partida_nacimiento, matricula_medico, matricula_medico_deceso, dni_madre, dni_padre, hora_deceso: integer;
            nombre, apellido, nombre_madre, nombre_padre, apellido_madre, apellido_padre, fecha_deceso, lugar_deceso: string;
            fallecio: boolean;
            direccion: direccion;
        end;
}
        det.partida_nacimiento:= -1; det.matricula_medico:= -1; det.matricula_medico_deceso:= -1; det.dni_madre:= -1; det.dni_padre:= -1; det.hora_deceso:= -1;
        det.nombre:= ''; det.apellido:= ''; det.nombre_madre:= ''; det.nombre_padre:= ''; det.apellido_madre:= ''; det.apellido_padre:= ''; det.fecha_deceso:= ''; det.lugar_deceso:= '';
        det.fallecio:= false;
        det.direccion.calle:= ''; det.direccion.depto:= ''; det.direccion.ciudad:= ''; det.direccion.nro:= -1; det.direccion.piso:= -1;
    end;


    // encontrar la menor partida de nacimiento entre todos los archivos
    // TRUE -> hay resultado válido
    // FALSE -> no hay resultado válido porque todos EOF=TRUE en todos los archivos
    function min_nacimiento(var delegaciones: arr_delegaciones; var min: detalle_nacimiento): boolean;
    var min_partida, i: integer;
        tmp_nacimiento: detalle_nacimiento;
    begin
        min_partida:= 32767;
        min_nacimiento:= false;

        for i:= 1 to cant_delegaciones do
            if not eof(delegaciones[i].nacimientos) then begin
                read(delegaciones[i].nacimientos, tmp_nacimiento);

                if tmp_nacimiento.partida_nacimiento < min_partida then begin
                    min_partida:= tmp_nacimiento.partida_nacimiento;
                    min:= tmp_nacimiento;

                    min_nacimiento:= true;
                end else seek(delegaciones[i].nacimientos, filepos(delegaciones[i].nacimientos) - 1); // volver atrás, dato encontrado no relevante
            end;
    end;

    // encontrar la menor partida de nacimiento entre todas las actas de defunción
    // TRUE -> hay resultado válido
    // FALSE -> no hay resultado válido porque todos EOF=TRUE en todos los archivos
    function min_fallecimiento(var delegaciones: arr_delegaciones; var min: detalle_fallecimiento): boolean;
    var min_partida, i: integer;
        tmp_fallecimiento: detalle_fallecimiento;
    begin
        min_partida:= 32767;
        min_fallecimiento:= false;

        for i:= 1 to cant_delegaciones do
            if not eof(delegaciones[i].fallecimientos) then begin
                read(delegaciones[i].fallecimientos, tmp_fallecimiento);

                if tmp_fallecimiento.partida_nacimiento < min_partida then begin
                    min_partida:= tmp_fallecimiento.partida_nacimiento;
                    min:= tmp_fallecimiento;

                    min_fallecimiento:= true;
                end else seek(delegaciones[i].fallecimientos, filepos(delegaciones[i].fallecimientos) - 1); // volver atrás, dato encontrado no relevante
            end;
    end;

{

    CREAR MAESTRO

}

    procedure crear_maestro(var file_m: file_maestro; var delegaciones: arr_delegaciones; var textfile: Text);
    var tmp_maestro: record_maestro;
        tmp_nacimiento: detalle_nacimiento;
        tmp_fallecimiento: detalle_fallecimiento;
        hay_fallecimiento: boolean;
        i: integer;
    begin
        // file_m y archivos de delegaciones pre-asignados
        rewrite(file_m); // debe ser reescrito
        rewrite(textfile);

        // abrir todos los archivos
        for i:= 1 to cant_delegaciones do begin
            reset(delegaciones[i].nacimientos);
            reset(delegaciones[i].fallecimientos);
        end;

        resetearDetalleMaestro(tmp_maestro);

        // que el primer tmp_nacimiento tenga valor de partida -1 para evitar usar una variable no inicializada
        tmp_maestro.partida_nacimiento:= -1;

{
        record_maestro = record
            partida_nacimiento, matricula_medico, matricula_medico_deceso, dni_madre, dni_padre, hora_deceso: integer;
            nombre, apellido, nombre_madre, nombre_padre, apellido_madre, apellido_padre, fecha_deceso, lugar_deceso: string;
            fallecio: boolean;
            direccion: direccion;
        end;
}

        hay_fallecimiento:= min_fallecimiento(delegaciones, tmp_fallecimiento);

        while min_nacimiento(delegaciones, tmp_nacimiento) do begin
            resetearDetalleMaestro(tmp_maestro);
{
            detalle_nacimiento = record
                partida_nacimiento, matricula_medico, dni_madre, dni_padre: integer;
                nombre, apellido, nombre_madre, nombre_padre, apellido_madre, apellido_padre: string;
                direccion: direccion;
            end;
}

            // copiar datos
            tmp_maestro.partida_nacimiento:= tmp_nacimiento.partida_nacimiento;
            tmp_maestro.nombre:= tmp_nacimiento.nombre;
            tmp_maestro.apellido:= tmp_nacimiento.apellido;
            copiarDireccion(tmp_nacimiento.direccion, tmp_maestro.direccion);
            tmp_maestro.matricula_medico:= tmp_nacimiento.matricula_medico;
            tmp_maestro.nombre_madre:= tmp_nacimiento.nombre_madre;
            tmp_maestro.nombre_padre:= tmp_nacimiento.nombre_padre;
            tmp_maestro.apellido_madre:= tmp_nacimiento.apellido_madre;
            tmp_maestro.apellido_padre:= tmp_nacimiento.apellido_padre;
            tmp_maestro.dni_madre:= tmp_nacimiento.dni_madre;
            tmp_maestro.dni_padre:= tmp_nacimiento.dni_padre;

            if hay_fallecimiento then
{
                detalle_fallecimiento = record
                    partida_nacimiento, dni, matricula_medico: integer;
                    nombre, apellido, fecha, lugar: string;
                    hora: integer;
                end;
}
                if tmp_fallecimiento.partida_nacimiento = tmp_nacimiento.partida_nacimiento then begin
                    writeln('Fallecido: Partida ', tmp_maestro.partida_nacimiento);
                    tmp_maestro.fallecio:= true;

                    // copiar datos
                    tmp_maestro.matricula_medico_deceso:= tmp_fallecimiento.matricula_medico;
                    tmp_maestro.fecha_deceso:= tmp_fallecimiento.fecha;
                    tmp_maestro.lugar_deceso:= tmp_fallecimiento.lugar;
                    tmp_maestro.hora_deceso:= tmp_fallecimiento.hora;

                    // encontrar siguiente fallecimiento
                    hay_fallecimiento:= min_fallecimiento(delegaciones, tmp_fallecimiento);
                end;

{
            Se deberá, además, listar en un archivo de texto la información recolectada de cada persona.
            Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
            Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona
            y además puede no haber fallecido.
}

            writeln(textfile, 'Partida: ', tmp_maestro.partida_nacimiento, ' | Nombre y apellido: ', tmp_maestro.nombre, ' ', tmp_maestro.apellido, ' | Matrícula del médico: ', tmp_maestro.matricula_medico);
            writeln(textfile, 'Nombre y apellido MADRE: ', tmp_maestro.nombre_madre, ' ', tmp_maestro.apellido_madre, ' | Nombre y apellido PADRE: ', tmp_maestro.nombre_padre, ' ', tmp_maestro.apellido_padre);
            writeln(textfile, 'DNI Madre: ', tmp_maestro.dni_madre, ' | DNI Padre: ', tmp_maestro.dni_padre);
            writeln(textfile, 'Dirección: Calle ', tmp_maestro.direccion.calle, ' N.', tmp_maestro.direccion.nro, ', Piso ', tmp_maestro.direccion.piso, ', ', tmp_maestro.direccion.depto, ', ', tmp_maestro.direccion.ciudad);
            writeln(textfile, 'Fallecido: ', tmp_maestro.fallecio);
            if tmp_maestro.fallecio then
                writeln(textfile, 'Matrícula del médico de defunción: ', tmp_maestro.matricula_medico_deceso, ' | Fecha: ', tmp_maestro.fecha_deceso, ' | Lugar: ', tmp_maestro.lugar_deceso, ' | Hora: ', tmp_maestro.hora_deceso);

            write(file_m, tmp_maestro);
        end;

        close(file_m);
        close(textfile);

        for i:= 1 to cant_delegaciones do begin
            close(delegaciones[i].nacimientos);
            close(delegaciones[i].fallecimientos);
        end;
    end;


                ////////////////    ////////////////    ////////////////    ////////////////    ////////////////
                ////////////////    ////////////////    ////////////////    ////////////////    ////////////////
                      ////          ////                ////                      ////          //// 
                      ////          //////////////      ////////////////          ////          ////////////////
                      ////          //////////////      ////////////////          ////          ////////////////
                      ////          ////                            ////          ////                      ////
                      ////          ////////////////    ////////////////          ////          ////////////////
                      ////          ////////////////    ////////////////          ////          ////////////////


procedure CrearDatosFijosNacimiento(var arch: file_nacimiento; nombre: string; delegacion: integer);
var
    reg: detalle_nacimiento;
begin
    assign(arch, nombre);
    rewrite(arch);
    
    if delegacion = 1 then begin
        // Persona 1 - Juan Perez (fallecerá)
        reg.partida_nacimiento := 1001;
        reg.matricula_medico := 5001;
        reg.dni_madre := 20123456;
        reg.dni_padre := 20123457;
        reg.nombre := 'Juan';
        reg.apellido := 'Perez';
        reg.nombre_madre := 'Maria';
        reg.nombre_padre := 'Pedro';
        reg.apellido_madre := 'Gomez';
        reg.apellido_padre := 'Perez';
        reg.direccion.calle := 'Av. Libertador';
        reg.direccion.depto := 'D1';
        reg.direccion.ciudad := 'Cordoba';
        reg.direccion.nro := 1234;
        reg.direccion.piso := 5;
        write(arch, reg);
        
        // Persona 2 - Ana Lopez (no fallece)
        reg.partida_nacimiento := 1002;
        reg.matricula_medico := 5002;
        reg.dni_madre := 20123458;
        reg.dni_padre := 20123459;
        reg.nombre := 'Ana';
        reg.apellido := 'Lopez';
        reg.nombre_madre := 'Lucia';
        reg.nombre_padre := 'Carlos';
        reg.apellido_madre := 'Rodriguez';
        reg.apellido_padre := 'Lopez';
        reg.direccion.calle := 'San Martin';
        reg.direccion.depto := 'D2';
        reg.direccion.ciudad := 'Cordoba';
        reg.direccion.nro := 5678;
        reg.direccion.piso := 3;
        write(arch, reg);
    end
    else if delegacion = 2 then begin
        // Persona 3 - Pedro Gomez (fallecerá)
        reg.partida_nacimiento := 1003;
        reg.matricula_medico := 5003;
        reg.dni_madre := 20123460;
        reg.dni_padre := 20123461;
        reg.nombre := 'Pedro';
        reg.apellido := 'Gomez';
        reg.nombre_madre := 'Sofia';
        reg.nombre_padre := 'Luis';
        reg.apellido_madre := 'Fernandez';
        reg.apellido_padre := 'Gomez';
        reg.direccion.calle := 'Belgrano';
        reg.direccion.depto := 'D3';
        reg.direccion.ciudad := 'Buenos Aires';
        reg.direccion.nro := 9101;
        reg.direccion.piso := 7;
        write(arch, reg);
    end
    else if delegacion = 3 then begin
        // Persona 4 - Maria Rodriguez (no fallece)
        reg.partida_nacimiento := 1004;
        reg.matricula_medico := 5004;
        reg.dni_madre := 20123462;
        reg.dni_padre := 20123463;
        reg.nombre := 'Maria';
        reg.apellido := 'Rodriguez';
        reg.nombre_madre := 'Clara';
        reg.nombre_padre := 'Jose';
        reg.apellido_madre := 'Martinez';
        reg.apellido_padre := 'Rodriguez';
        reg.direccion.calle := 'Rivadavia';
        reg.direccion.depto := 'D4';
        reg.direccion.ciudad := 'Rosario';
        reg.direccion.nro := 1122;
        reg.direccion.piso := 1;
        write(arch, reg);
    end;
    close(arch);
end;

procedure CrearDatosFijosFallecimiento(var arch: file_fallecimiento; nombre: string; delegacion: integer);
var
    reg: detalle_fallecimiento;
begin
    assign(arch, nombre);
    rewrite(arch);
    
    if delegacion = 1 then begin
        // Fallecimiento de Juan Perez (partida 1001)
        reg.partida_nacimiento := 1001;
        reg.dni := 30123456;
        reg.matricula_medico := 6001;
        reg.nombre := 'Juan';
        reg.apellido := 'Perez';
        reg.fecha := '15/06/2023';
        reg.lugar := 'Cordoba';
        reg.hora := 14;
        write(arch, reg);
    end
    else if delegacion = 2 then begin
        // Fallecimiento de Pedro Gomez (partida 1003)
        reg.partida_nacimiento := 1003;
        reg.dni := 30123457;
        reg.matricula_medico := 6002;
        reg.nombre := 'Pedro';
        reg.apellido := 'Gomez';
        reg.fecha := '20/09/2023';
        reg.lugar := 'Buenos Aires';
        reg.hora := 10;
        write(arch, reg);
    end;
    // Delegacion 3 no tiene fallecimientos
    close(arch);
end;

// Procedimientos para mostrar contenido
procedure MostrarNacimiento(var arch: file_nacimiento);
var
    reg: detalle_nacimiento;
begin
    reset(arch);
    while not eof(arch) do begin
        read(arch, reg);
        writeln('Nacimiento: ', reg.nombre, ' ', reg.apellido, ' - Partida: ', reg.partida_nacimiento);
    end;
    close(arch);
end;

procedure MostrarFallecimiento(var arch: file_fallecimiento);
var
    reg: detalle_fallecimiento;
begin
    reset(arch);
    while not eof(arch) do begin
        read(arch, reg);
        writeln('Fallecimiento: ', reg.nombre, ' ', reg.apellido, ' - Partida: ', reg.partida_nacimiento);
    end;
    close(arch);
end;

procedure MostrarMaestro(var arch: file_maestro);
var
    reg: record_maestro;
begin
    reset(arch);
    while not eof(arch) do begin
        read(arch, reg);
        writeln('Maestro: ', reg.nombre, ' ', reg.apellido);
        writeln('Partida: ', reg.partida_nacimiento, ' - Fallecio: ', reg.fallecio);
        writeln('Direccion: ', reg.direccion.calle, ' ', reg.direccion.nro, ', ', reg.direccion.ciudad);
        if reg.fallecio then
            writeln('Fallecimiento: ', reg.fecha_deceso, ' en ', reg.lugar_deceso, ' a las ', reg.hora_deceso, 'hs');
        writeln;
    end;
    close(arch);
end;

// Test chamber
var
    i: integer;
    fileNames: array[1..cant_delegaciones] of string = ('1', '2', '3');
    delegaciones: arr_delegaciones;
    maestro: file_maestro;
    textfile: Text;
begin
    // Crear delegaciones con datos fijos
    for i := 1 to cant_delegaciones do begin
        CrearDatosFijosNacimiento(delegaciones[i].nacimientos, base_folder + 'nacimiento_' + fileNames[i] + '.dat', i);
        CrearDatosFijosFallecimiento(delegaciones[i].fallecimientos, base_folder + 'fallecimiento_' + fileNames[i] + '.dat', i);
        writeln('Delegacion ', i, ' - Nacimientos:');
        MostrarNacimiento(delegaciones[i].nacimientos);
        writeln('Delegacion ', i, ' - Fallecimientos:');
        MostrarFallecimiento(delegaciones[i].fallecimientos);
        writeln;
    end;

    assign(maestro, base_folder + 'maestro.dat');
    assign(textfile, base_folder + 'resumen.txt');

    crear_maestro(maestro, delegaciones, textfile);

    MostrarMaestro(maestro);
end.