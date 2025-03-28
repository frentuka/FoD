program ej2;

// Realizar un algoritmo que, utilizando el archivo de números enteros no ordenados creado en el ejercicio 1,
// informe por pantalla cantidad de números menores a 1500 y el promedio de los números ingresados.
// El nombre del archivo a procesar debe ser proporcionado por el usuario una única vez.
// Además, el algoritmo deberá listar el contenido del archivo en pantalla.

uses
    SysUtils;

const
    base_folder = 'BDD\';

type
    type_intfile = file of integer;

procedure algoritmo(filename: string);
var
    sel_file: type_intfile;
    bread, amt_lt1500, num_sum: integer;
    prom: real;
begin
    bread:= 0;
    num_sum:= 0;
    amt_lt1500:= 0;
    prom:= 0.0;

    filename:= base_folder + filename + '.dat'; // corregir nombre añadiendo ubicación y extensión

    assign(sel_file, filename);
    if not FileExists(filename) then
        writeln('El archivo nombrado no existe. Colapsando...');
    
    reset(sel_file); // let it crash
    
    writeln('Contenido del archivo:');
    while not eof(sel_file) do begin
        read(sel_file, bread);
        writeln(bread);

        if bread < 1500 then
            amt_lt1500:= amt_lt1500 + 1;
        
        num_sum:= num_sum + bread;
    end;

    if filepos(sel_file) <> 0 then
        prom:= num_sum / filepos(sel_file);
        
    close(sel_file);
    
    writeln('Cantidad de números menores a 1500: ', amt_lt1500);
    writeln('Número promedio: ', prom:2:2);
end;

var
    inp: string;
begin
    writeln('Ingrese el nombre del archivo a analizar');
    readln(inp);
    algoritmo(inp);
end.