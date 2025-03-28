program ej5;

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

const
    base_folder = 'BDD\p1e5\';

type
    phone = record
        id, stock_min, stock_av: integer;
        name, desc, brand: string;
        price: real;
    end;

    phones_file = file of phone;


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
    bin_file: phones_file;
    txt_file: Text;
    tmp_phone: phone;
begin
    

    writeln;
    writeln('(A): Crear archivo binario | (B): Listar celulares en stock');
    writeln('(C): Buscar por descripción | (D): Exportar archivo inc. A');
    writeln('(X): Salir');
    write('> '); readln(inp_str);

    while (inp_str <> 'X') and (inp_str <> 'x') do begin

        while (inp_str = 'A') or (inp_str = 'a') do begin
            writeln;
            writeln('  Ingresa el nombre del archivo .bin a crear');
            write('  > '); readln(inp_str);
            
            // crear archivo de registros de celulares y cargarlo con datos ingresados desde el archivo 'celulares.txt'
            // asignar archivo binario
            assign(txt_file, base_folder + 'celulares.txt');
            reset(txt_file); // se dispone

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

        writeln;
        writeln('(A): Crear y cargar un archivo | (B): Listar celulares en stock');
        writeln('(C): Buscar por descripción | (D): Exportar archivo inc. A');
        write('> '); readln(inp_str);
    end;

    writeln;
    writeln('  > Salute ;)');
end.