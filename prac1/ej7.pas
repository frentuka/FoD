program ej7;

// 7. Realizar un programa que permita:

//     a) Crear un archivo binario a partir de la información almacenada en un archivo de texto.
//         El nombre del archivo de texto es: “novelas.txt”.
//         La información en el archivo de texto consiste en:
//             - código de novela
//             - nombre
//             - género
//             - precio de diferentes novelas argentinas.
//         Los datos de cada novela se almacenan en dos líneas en el archivo de texto.
//         La primera línea contendrá la siguiente información:
//             - código novela
//             - precio
//             - género
//         y la segunda línea almacenará el nombre de la novela.

//     b) Abrir el archivo binario y permitir la actualización del mismo.
//         Se debe poder agregar una novela y modificar una existente.
//         Las búsquedas se realizan por código de novela.
//         NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.

const
    base_folder = 'BDD/p1e7/';

type
    novela = record
        nombre, genero: string;
        codigo: integer;
        precio: real;
    end;

    novela_file = file of novela;

function readNovela_console(line_prefix: string): novela;
begin
    writeln(line_prefix, 'Ingrese los datos de la novela');
    write(line_prefix, ' Nombre > '); readln(readNovela_console.nombre);
    write(line_prefix, ' Género > '); readln(readNovela_console.genero);
    write(line_prefix, ' Código > '); readln(readNovela_console.codigo);
    write(line_prefix, ' Precio > '); readln(readNovela_console.precio);
end;

procedure readNovela(var t: Text; var n: novela);
begin
    readln(t, n.codigo, n.precio, n.genero);
    readln(t, n.nombre);
end;

procedure editNovela(var n: novela; line_prefix: string);
var
    inp_str: string;
    inp_real: real;
begin
    writeln(line_prefix, 'Editando novela "', n.nombre, '"');
    writeln(line_prefix, 'Deje el campo en blanco para no modificarlo');

    inp_str:= '';
    write(line_prefix, 'Nombre: ', n.nombre, ' > '); readln(inp_str);
    if inp_str <> '' then
        n.nombre:= inp_str;
    
    inp_str:= '';
    write(line_prefix, 'Género: ', n.genero, ' > '); readln(inp_str);
    if inp_str <> '' then
        n.genero:= inp_str;
    
    writeln(line_prefix, 'Campo numérico: Inserte -1 para no modificar el campo');

    inp_real:= -1;
    write(line_prefix, 'Precio: ', n.precio, ' > '); readln(inp_real);
    if inp_real <> -1 then
        n.precio:= inp_real;
end;

var
    txt_file: Text;
    bin_file: novela_file;
    inp_str: string;
    inp_int: integer;
    tmp_novela: novela;
    found: boolean;
begin

    writeln;
    writeln('(A): Crear archivo binario | (B): Modificar archivo binario');
    writeln('(X): Salir');
    write('  > '); readln(inp_str);

    while (inp_str <> 'X') and (inp_str <> 'x') do begin

        if (inp_str = 'A') or (inp_str = 'a') then begin
            assign(txt_file, base_folder + 'novelas.txt');
            reset(txt_file);

            writeln;
            writeln('  Ingrese el nombre del archivo .bin a generar');
            write('  > '); readln(inp_str);

            assign(bin_file, base_folder + inp_str + '.bin');
            rewrite(bin_file);

            while not eof(txt_file) do begin
                readNovela(txt_file, tmp_novela);
                write(bin_file, tmp_novela);
            end;

            close(bin_file);
            close(txt_file);
        end;

        if (inp_str = 'B') or (inp_str = 'b') then begin
            writeln;
            writeln('  Ingrese el nombre del archivo .bin a editar');
            write('  > '); readln(inp_str);

            assign(bin_file, base_folder + inp_str + '.bin');
            reset(bin_file);

            writeln;
            writeln('  (A): Añadir nueva novela | (B): Editar novela existente');
            writeln('  (X): Salir');
            write('  > '); readln(inp_str);
            while (inp_str <> 'X') and (inp_str <> 'x') do begin

                if (inp_str = 'A') or (inp_str = 'a') then begin
                    writeln;
                    tmp_novela:= readNovela_console('  ');

                    while not eof(bin_file) do
                        seek(bin_file, filepos(bin_file) + 1);

                    write(bin_file, tmp_novela);
                    writeln('  ! Novela añadida con éxito.');
                end;

                if (inp_str = 'B') or (inp_str = 'b') then begin
                    writeln;
                    writeln('  Ingrese el código de la novela a editar');
                    write('  > '); readln(inp_int);

                    seek(bin_file, 0);
                    found:= false;
                    while not eof(bin_file) and not found do begin
                        read(bin_file, tmp_novela);
                        
                        if (tmp_novela.codigo = inp_int) then begin
                            found:= true;

                            editNovela(tmp_novela, '  ');
                            seek(bin_file, filepos(bin_file) - 1);
                            write(bin_file, tmp_novela);

                            writeln('  ! Novela editada con éxito');
                        end;
                    end;

                    if not found then
                        writeln('  ! No se encontró la novela #', inp_int);
                end;

                writeln;
                writeln('  (A): Añadir nueva novela | (B): Editar novela existente');
                writeln('  (X): Salir');
                write('  > '); readln(inp_str);
            end;

            close(bin_file);
        end;

        writeln;
        writeln('(A): Crear archivo binario | (B): Modificar archivo binario');
        writeln('(X): Salir');
        write('  > '); readln(inp_str);
    end;


end.