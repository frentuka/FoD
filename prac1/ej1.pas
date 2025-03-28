program ej1;

// Realizar un algoritmo que cree un archivo de números enteros no ordenados
// y permita incorporar datos al archivo.
// Los números son ingresados desde teclado.
// La carga finaliza cuando se ingresa el número 30000,
// que no debe incorporarse al archivo.

// El nombre del archivo debe ser proporcionado por el usuario desde teclado.

uses
    SysUtils;

const
    base_folder = 'BDD\';

type
    type_intfile = file of integer;


var
    sel_file: type_intfile;
    inp_n, wbr: integer; // wbr = what's been read
    inp_file: string;

begin
    writeln('Seleccione el nombre del archivo .dat');
    readln(inp_file);

    inp_file:= base_folder + inp_file + '.dat';
    writeln(inp_file);

    assign(sel_file, inp_file);
    if FileExists(inp_file) then begin
        reset(sel_file);
        writeln('Desea leer (1) o escribir (2) ?');
        readln(inp_n);

        if inp_n = 2 then begin // escribir
            writeln('Seleccione números a guardar');

            // ir hasta el fin del archivo
            while not eof(sel_file) do
                seek(sel_file, filepos(sel_file) + 1);

            readln(inp_n);

            while (inp_n <> 30000) do begin
                write(sel_file, inp_n);
                readln(inp_n);
            end;
        end else begin // leer
            while not eof(sel_file) do begin
                read(sel_file, wbr);
                writeln(wbr);
            end;
        end;
            

    end
    else rewrite(sel_file);

    close(sel_file);
end.