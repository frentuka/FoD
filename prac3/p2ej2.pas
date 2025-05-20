program p2ej2;

{
2. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por localidad en la provincia de Buenos Aires.
    Para ello, se posee un archivo con la siguiente información:
        código de localidad,
        número de mesa
        y cantidad de votos en dicha mesa.
    Presentar en pantalla un listado como se muestra a continuación:
    Código de localidad              Cantidad de votos
    ...................              .................
    ...................              .................
    ...................              .................
    ...................              .................
    Total de votos:                  .................

    ● La información en el archivo no está ordenada por ningún criterio.
    ● Trate de resolver el problema sin modificar el contenido del archivo dado.
    ● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para llevar el control de las localidades que han sido procesadas.
}

const
    base_folder = 'p3p2e2';

type
    mesa = record
        localidad, numero, votos: integer;
    end;

    localidad = record
        codigo, votos: integer;
    end;

    file_mesas = file of mesa;
    file_localidades = file of localidad;

procedure crear_archivo_localidades(var file_loc: file_localidades; var file_mesas: file_mesas);
var tmp_mesa: mesa;
    tmp_loc: localidad;
begin
    reset(file_mesas); rewrite(file_loc);
    tmp_loc.codigo:= -32768;

    while not eof(file_mesas) do begin
        read(file_mesas, tmp_mesa);

        // encontrar localidad (si existe)
        seek(file_loc, 0);
        while not eof(file_loc) and tmp_loc.codigo <> tmp_mesa.localidad do
            read(file_loc, tmp_loc);

        // existe?
        if tmp_loc.codigo = tmp_mesa.localidad then begin
            tmp_loc.votos:= tmp_loc.votos + tmp_mesa.votos;
            seek(file_loc, filepos(file_loc) - 1);
        end else begin
            tmp_loc.codigo:= tmp_mesa.localidad;
            tmp_loc.votos:= tmp_mesa.votos; // filepos debería ya estar en EOF
        end;

        write(file_loc, tmp_loc);
    end;

    close(file_mesas); close(file_loc);
end;

procedure presentar_listado(var file_loc: file_localidades);
var tmp_loc: localidad;
    total_votos: integer;
begin
    reset(file_loc);
    total_votos:= 0;

    writeln;
    writeln('Código de localidad              Cantidad de votos');

    while not eof(file_loc) do begin
        read(file_loc, tmp_loc);
        writeln(file_loc.codigo, '              ', file_loc.votos);
        total_votos:= total_votos + file_loc.votos;
    end;

    writeln('Total de votos:              ', total_votos);

    close(file_loc);
end;