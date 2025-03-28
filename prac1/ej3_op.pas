program ej3;

// Realizar un programa que presente un menú con opciones para:

// a. Crear un archivo de registros no ordenados de empleados y completarlo con datos ingresados desde teclado.
// De cada empleado se registra: número de empleado, apellido, nombre, edad y DNI.
// Algunos empleados se ingresan con DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

// b. Abrir el archivo anteriormente generado y
    // i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado, el cual se proporciona desde el teclado.
    // ii. Listar en pantalla los empleados de a uno por línea.
// Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse. NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.

uses
    SysUtils;

const
    base_folder = 'BDD\';

type
    empleado = record
        numero, dni, edad: integer;
        nombre, apellido: string;
    end;

    file_empleado = file of empleado;

function read_employee(): empleado;
begin
    writeln('Ingrese apellido del empleado');
    readln(read_employee.apellido);

    if read_employee.apellido <> 'fin' then begin
        writeln('  Ingrese nombre de Sr./Sra. ', read_employee.apellido);
        readln(read_employee.nombre);

        writeln('  Ingrese el número de empleado de Sr./Sra. ', read_employee.apellido);
        readln(read_employee.numero);

        writeln('  Ingrese el DNI de Sr./Sra. ', read_employee.apellido);
        readln(read_employee.dni);

        writeln('  Ingrese la edad de Sr./Sra. ', read_employee.edad);
        readln(read_employee.edad);
    end;
end;

procedure write_employee(e: empleado; line_prefix: string);
begin
    writeln(line_prefix, 'Sr./Sra. ', e.apellido, ' (ID #', e.numero ,'):');
    writeln(line_prefix, '  Nombre(s): ', e.nombre);
    writeln(line_prefix, '  Edad: ', e.edad);
    writeln(line_prefix, '  DNI: ', e.dni);
end;

var
    sel_file: file_empleado;
    inp_emp: empleado;
    inp, filename: string;
begin
    writeln('Ingrese el nombre del archivo .dat a procesar');
    readln(filename);

    filename:= base_folder + filename + '.dat';
    assign(sel_file, filename);

    if not FileExists(filename) then begin
        writeln('El archivo no existe. Creando...');
        rewrite(sel_file);
    end else reset(sel_file);

    writeln('');
    writeln('¿Qué operación desea realizar?');
    writeln(' (A): Añadir nuevos empleados | (L): Listar todos los empleados');
    writeln(' (B): Ejercicio B. I | (X): Salir');
    readln(inp);

    while (inp <> 'X') and (inp <> 'x') do begin
        if (inp = 'A') or (inp = 'a') then begin
            // Move to end of file to prevent overwriting any employee
            while not eof(sel_file) do seek(sel_file, filepos(sel_file) + 1);

            // Add employee
            inp_emp:= read_employee();
            while (inp_emp.apellido <> 'fin') do begin
                write(sel_file, inp_emp);
                inp_emp:= read_employee();
            end;
        end;

        if (inp = 'L') or (inp = 'l') then begin
            seek(sel_file, 0);
            while not eof(sel_file) do begin
                read(sel_file, inp_emp);
                write_employee(inp_emp, '  ');
                writeln('');
            end;
        end;

        if (inp = 'B') or (inp = 'b') then begin
            writeln('');
            writeln('  Ejercicio B. I: Listar empleados que tengan un nombre o apellido determinado');
            writeln('   (A): Seleccionar apellido | (N): Seleccionar nombre | (X): Atrás');
            readln(inp);

            while (inp <> 'X') and (inp <> 'x') do begin
                if (inp = 'A') or (inp = 'a') then begin
                    writeln('   Apellido: ');
                    readln(inp);

                    seek(sel_file, 0);
                    while not eof(sel_file) do begin
                        read(sel_file, inp_emp);
                        if inp_emp.apellido = inp then begin
                            write_employee(inp_emp, '   ');
                            writeln('');
                        end;
                    end;
                end;
                
                if (inp = 'N') or (inp = 'n') then begin
                    writeln('   Nombre: ');
                    read(inp);

                    seek(sel_file, 0);
                    while not eof(sel_file) do begin
                        read(sel_file, inp_emp);
                        if inp_emp.nombre = inp then begin
                            write_employee(inp_emp, '   ');
                            writeln('');
                        end;
                    end;
                end;

                writeln('');
                writeln('  Ejercicio B. I: Listar empleados que tengan un nombre o apellido determinado');
                writeln('   (A): Seleccionar apellido | (N): Seleccionar nombre | (X): Atrás');
                readln(inp);
            end;

        end;
        
        writeln('');
        writeln('¿Qué operación desea realizar?');
        writeln(' (A): Añadir nuevos empleados | (L): Listar todos los empleados');
        writeln(' (B): Ejercicio B. I | (X): Salir');
        readln(inp);
    end;

    writeln('Salute!');
    close(sel_file);
end.