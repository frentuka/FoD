program ej6;

// 5. Realizar un programa para una tienda de celulares, que presente un menú con opciones para:

//     a. Crear un archivo de registros no ordenados de celulares
//         y cargarlo con datos ingresados desde un archivo de texto denominado “celulares.txt”.
//         Los registros correspondientes a los celulares deben contener:
//         - código de celular
//         - nombre
//         - descripción
//         - marca
//         - precio
//         - stock mínimo
//         - stock disponible.

//     b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.

//     c. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.

//     d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt”
//         con todos los celulares del mismo. El archivo de texto generado podría ser utilizado en un futuro
//         como archivo de carga (ver inciso a), por lo que debería respetar el formato dado para este tipo de archivos en la NOTA 2.
//         - NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
//         - NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en tres líneas consecutivas.
//             En la primera se especifica:
//                 - código de celular
//                 - el precio
//                 - marca
//             En la segunda,
//                 - el stock disponible
//                 - stock mínimo
//                 - la descripción
//             y, en la tercera, nombre en ese orden.
//             Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.


// 6. Agregar al menú del programa del ejercicio 5 opciones para:

//     a. Añadir uno o más celulares al final del archivo
//          con sus datos ingresados por teclado.

//     b. Modificar el stock de un celular dado.

//     c. Exportar el contenido del archivo binario a un archivo de texto denominado ”SinStock.txt”
//          con aquellos celulares que tengan stock 0.

const
    base_folder = 'BDD/p1e6/';

type
    phone = record
        id, stock_min, stock_av: integer;
        name, desc, brand: string;
        price: real;
    end;

    phones_file = file of phone;

function readPhone_console(line_prefix: string): phone;
begin
    writeln(line_prefix, 'Ingrese los datos del teléfono');
    write(line_prefix, '      Marca > '); readln(readPhone_console.brand);
    write(line_prefix, '     Nombre > '); readln(readPhone_console.name);
    write(line_prefix, 'Descripción > '); readln(readPhone_console.desc);
    write(line_prefix, '         ID > '); readln(readPhone_console.id);
    write(line_prefix, '     Precio > '); readln(readPhone_console.price);
    write(line_prefix, ' Stock mín. > '); readln(readPhone_console.stock_min);
    write(line_prefix, 'Stock disp. > '); readln(readPhone_console.stock_av);
end;

procedure readPhone(var t: Text; var p: phone);
begin
    readln(t, p.id, p.price, p.brand);
    readln(t, p.stock_av, p.stock_min, p.desc);
    readln(t, p.name);
end;

procedure printPhone(p: phone; line_prefix: string);
begin
    writeln;
    writeln(line_prefix, '> ', p.brand, ' ', p.name, ' #', p.id);
    writeln(line_prefix, '  ', p.desc);
    writeln(line_prefix, '  Stock: ', p.stock_av, '/', p.stock_min);
    writeln(line_prefix, '  Price: $', p.price);
end;

var
    inp_str: string;
    inp_int: integer;
    found: boolean;
    bin_file: phones_file;
    txt_file: Text;
    tmp_phone: phone;
begin

    writeln;
    writeln('(A): Crear archivo binario | (B): Listar celulares en stock');
    writeln('(C): Buscar por descripción | (D): Exportar archivo inc. A');
    writeln('(A2): Añadir celular | (B2): Modificar stock de un celular');
    writeln('(C2): Exportar celulares sin stock | (X): Salir');
    write('> '); readln(inp_str);

    while (inp_str <> 'X') and (inp_str <> 'x') do begin

        while (inp_str = 'A') or (inp_str = 'a') do begin
            // crear archivo de registros de celulares y cargarlo con datos ingresados desde el archivo 'celulares.txt'
            // asignar archivo binario
            assign(txt_file, base_folder + 'celulares.txt');
            reset(txt_file); // se dispone
            
            writeln;
            writeln('  Ingresa el nombre del archivo .bin a crear');
            write('  > '); readln(inp_str);

            // asignar archivo de texto
            assign(bin_file, base_folder + inp_str + '.bin');
            rewrite(bin_file); // crear/sobreescribir
            
            // leer texto
            while not eof(txt_file) do begin
                readPhone(txt_file, tmp_phone);

                // escribir en archivo binario
                write(bin_file, tmp_phone);
            end;

            writeln;
            writeln('  ! Se creó exitosamente el archivo ', inp_str, '.bin');
            writeln('    conteniendo toda la información del archivo celulares.txt');

            inp_str:= '';
            close(txt_file);
            close(bin_file);
        end;

        while (inp_str = 'B') or (inp_str = 'b') do begin
            writeln;
            writeln('  Celulares con stock menor al mínimo:');

            assign(txt_file, base_folder + 'celulares.txt');
            reset(txt_file); // se dispone

            while not eof(txt_file) do begin
                readPhone(txt_file, tmp_phone);

                if tmp_phone.stock_av < tmp_phone.stock_min then
                    printPhone(tmp_phone, '  ');
            end;

            inp_str:= '';
            close(txt_file);
        end;

        while (inp_str = 'C') or (inp_str = 'c') do begin
            writeln;
            writeln('  Ingresa una cadena a buscar entre las descripciones');
            write('  > '); readln(inp_str);

            assign(txt_file, base_folder + 'celulares.txt');
            reset(txt_file);

            while not eof(txt_file) do begin
                readPhone(txt_file, tmp_phone);

                if Pos(inp_str, tmp_phone.desc) > 0 then
                    printPhone(tmp_phone, '  ');
            end;

            inp_str:= '';
            close(txt_file);
        end;

        while (inp_str = 'D') or (inp_str = 'd') do begin
            writeln;
            writeln('  Ingresa el nombre del archivo .bin ya creado');
            writeln('  para exportarlo como un nuevo archivo "celulares.txt"');
            write('  > '); readln(inp_str);

            writeln(base_folder + inp_str + '.bin');

            assign(bin_file, base_folder + inp_str + '.bin');
            reset(bin_file);

            assign(txt_file, base_folder + 'celulares.txt');
            rewrite(txt_file);

            while not eof(bin_file) do begin
                read(bin_file, tmp_phone);

                writeln(txt_file, tmp_phone.id, ' ', tmp_phone.price, ' ', tmp_phone.brand);
                writeln(txt_file, tmp_phone.stock_av, ' ', tmp_phone.stock_min, ' ', tmp_phone.desc);
                writeln(txt_file, tmp_phone.name);
            end;

            writeln;
            writeln('  ! Se creó exitosamente el archivo celulares.txt');
            writeln('    conteniendo toda la información del archivo ', inp_str ,'.bin');

            inp_str:= '';
            close(txt_file);
            close(bin_file);
        end;

        //////////
        // ej 6 //
        //////////

        // a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
        if (inp_str = 'A2') or (inp_str = 'a2') then begin
            writeln;

            writeln('  Ingrese el nombre del archivo .bin a editar');
            write('  > '); readln(inp_str);

            assign(bin_file, base_folder + inp_str + '.bin');
            reset(bin_file);

            inp_str:= 'a2';
            while ((inp_str = 'A2') or (inp_str = 'a2')) and (inp_str <> 'X') and (inp_str <> 'x') do begin
                tmp_phone:= readPhone_console('  ');

                while not eof(bin_file) do
                    seek(bin_file, filepos(bin_file) + 1);

                write(bin_file, tmp_phone);

                writeln;
                writeln('  (*): Agregar otro teléfono.');
                writeln('  (X): Salir');
                write('  > '); readln(inp_str);

                if (inp_str <> 'X') and (inp_str <> 'x') then
                    inp_str:= 'a2';
            end;

            close(bin_file);
        end;

        // b. Modificar el stock de un celular dado.
        if (inp_str = 'B2') or (inp_str = 'b2') then begin
            writeln;
            writeln('  Ingrese el nombre del archivo .bin a editar');
            write('  > '); readln(inp_str);

            assign(bin_file, base_folder + inp_str + '.bin');
            reset(bin_file);

            writeln;
            writeln('  Ingrese la ID de un teléfono');
            write('  > '); readln(inp_int);

            found:= false;
            while not eof(bin_file) and not found do begin
                read(bin_file, tmp_phone);
                if (tmp_phone.id = inp_int) then begin
                    found:= true;
                    seek(bin_file, filepos(bin_file) - 1);

                    writeln;
                    writeln('  ! Teléfono encontrado. Indique nuevo stock:');
                    write('  ', tmp_phone.stock_av ,' > '); readln(inp_int);

                    tmp_phone.stock_av:= inp_int;
                    write(bin_file, tmp_phone);
                end;
            end;

            if not found then begin
                writeln;
                writeln('  ! No se ha encontrado el teléfono #', inp_int);
            end;
        end;

        // c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”
        // con aquellos celulares que tengan stock 0.
        if (inp_str = 'C2') or (inp_str = 'c2') then begin
            writeln;
            writeln('  Ingrese el nombre del archivo .bin');
            write('  > '); readln(inp_str);

            assign(bin_file, base_folder + inp_str + '.bin');
            reset(bin_file);

            assign(txt_file, base_folder + 'SinStock.txt');
            rewrite(txt_file);

            while not eof(bin_file) do begin
                read(bin_file, tmp_phone);

                if (tmp_phone.stock_av = 0) then begin
                    writeln(txt_file, tmp_phone.id, ' ', tmp_phone.price, ' ', tmp_phone.brand);
                    writeln(txt_file, tmp_phone.stock_av, ' ', tmp_phone.stock_min, ' ', tmp_phone.desc);
                    writeln(txt_file, tmp_phone.name);
                end;
            end;

            close(txt_file);
            close(bin_file);

            writeln;
            writeln('  ! Teléfonos sin stock exportados correctamente');
        end;

        writeln;
        writeln('(A): Crear archivo binario | (B): Listar celulares en stock');
        writeln('(C): Buscar por descripción | (D): Exportar archivo inc. A');
        writeln('(A2): Añadir celular | (B2): Modificar stock de un celular');
        writeln('(C2): Exportar celulares sin stock | (X): Salir');
        write('> '); readln(inp_str);
    end;

    writeln;
    writeln('  > Salute ;)');
end.