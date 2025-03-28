program ej4;

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

        writeln('  Ingrese la edad de Sr./Sra. ', read_employee.apellido);
        readln(read_employee.edad);
    end;
end;

procedure read_employee_modification(var e: empleado; line_prefix: string);
var inp_str: string; inp_int: integer;
begin
    inp_str:= ''; inp_int:= -1;
    writeln(line_prefix, 'Modificando el campo del empleado #', e.numero);
    writeln(line_prefix, 'Deje el campo vacío para no realizar ninguna modificación.');

    write(line_prefix, e.apellido, ' -> ');
    read(inp_str); readln();
    if inp_str <> '' then begin
        e.apellido:= inp_str;
        inp_str:= '';
    end;

    write(line_prefix, e.nombre, ' -> ');
    read(inp_str); readln();
    if inp_str <> '' then begin
        e.nombre:= inp_str;
        inp_str:= ''; // innecesario
    end;

    write(line_prefix, e.dni, ' -> ');
    read(inp_int); readln();
    if inp_int <> -1 then begin
        e.dni:= inp_int;
        inp_int:= -1;
    end;

    write(line_prefix, e.edad, ' -> ');
    read(inp_int); readln();
    if inp_int <> -1 then begin
        e.edad:= inp_int;
        inp_int:= -1; // innecesario
    end;
end;

procedure write_employee(e: empleado; line_prefix: string);
begin
    writeln(line_prefix, 'Sr./Sra. ', e.apellido, ' (ID #', e.numero ,'):');
    writeln(line_prefix, '  Nombre(s): ', e.nombre);
    writeln(line_prefix, '  Edad: ', e.edad);
    writeln(line_prefix, '  DNI: ', e.dni);
end;

function employee_exists(var emp_file: file_empleado; employee_id: integer): boolean;
var
    read_emp: empleado;
begin
    employee_exists:= false;

    seek(emp_file, 0);
    while not eof(emp_file) and (not employee_exists) do begin
        read(emp_file, read_emp);
        if read_emp.numero = employee_id then
            employee_exists:= true;
    end;
end;

procedure get_employee(var emp_file: file_empleado; id: integer; var emp: empleado);
begin
    seek(emp_file, 0);
    while not eof(emp_file) and (emp.numero <> id) do
        read(emp_file, emp);
end;

procedure modify_employee(var emp_file: file_empleado; e: empleado);
var read_emp: empleado; found: boolean;
begin
    found:= false;
    seek(emp_file, 0);
    while not eof(emp_file) and not found do begin
        read(emp_file, read_emp);

        // if found
        if read_emp.numero = e.numero then
            found:= true;
    end;

    if found then begin
        // go back to employee location
        seek(emp_file, filepos(emp_file) - 1);
        write(emp_file, e);
    end;
end;

procedure export_all_employees(var emp_file: file_empleado; loc: string);
var e: empleado;
    new_f: file_empleado;
begin
    assign(new_f, loc);
    rewrite(new_f);
    
    seek(emp_file, 0);
    while not eof(emp_file) do begin
        read(emp_file, e);
        write(new_f, e);
    end;

    close(new_f);
end;

procedure export_all_dniless_employees(var emp_file: file_empleado; loc: string);
var e: empleado;
    new_f: file_empleado;
begin
    assign(new_f, loc);
    rewrite(new_f);
    
    seek(emp_file, 0);
    while not eof(emp_file) do begin
        read(emp_file, e);
        if e.dni = 0 then
            write(new_f, e);
    end;

    close(new_f);
end;

procedure verify_and_correct_employee_id(var emp_file: file_empleado; var id: integer; line_prefix: string);
begin
    while (employee_exists(emp_file, id)) do begin
        writeln(line_prefix, 'La ID del empleado #', id, ' ya está en uso.');
        writeln(line_prefix, 'Por favor, seleccione otra ID que no esté ocupada:');
        readln(id);
    end;
end;

var
    sel_file: file_empleado;
    inp_emp, aux_emp: empleado;
    inp, filename: string;
    inp_id: integer;
    finish: boolean;
begin
    finish:= false;

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
    writeln(' (M): Modificar un empleado | (B): Buscar un empleado | (X): Salir');
    readln(inp);

    while (inp <> 'X') and (inp <> 'x') do begin
        if (inp = 'A') or (inp = 'a') then begin
            // Read employee
            inp_emp:= read_employee();

            // Verify that the input ID has not been already assigned
            verify_and_correct_employee_id(sel_file, inp_emp.numero, '  ');

            // Add employee
            while (inp_emp.apellido <> 'fin') do begin
                // Move to end of file to prevent overwriting any employee
                while not eof(sel_file) do seek(sel_file, filepos(sel_file) + 1);
                write(sel_file, inp_emp);

                inp_emp:= read_employee();

                if inp_emp.apellido <> 'fin' then
                    verify_and_correct_employee_id(sel_file, inp_emp.numero, '  ');
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

        if (inp = 'M') or (inp = 'm') then begin
            writeln('');
            writeln('  Seleccione la ID de empleado que desea modificar');
            writeln('  Seleccione -1 para salir');
            readln(inp_id);

            while (inp_id <> -1) do begin
                if employee_exists(sel_file, inp_id) then begin
                    get_employee(sel_file, inp_id, inp_emp);
                    read_employee_modification(inp_emp, '   ');
                    modify_employee(sel_file, inp_emp);

                    writeln('  Empleado modificado exitosamente.');
                end else
                    writeln('CUACK! El empleado seleccionado no pareciera existir...');

                writeln('');
                writeln('  Seleccione la ID de empleado que desea modificar');
                writeln('  Seleccione -1 para salir');
                readln(inp_id);
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
        writeln(' (M): Modificar un empleado | (B): Buscar un empleado | (X): Salir');
        readln(inp);
    end;

    writeln('');
    writeln('¿Desea exportar todos los empleados en BDD/todos_los_empleados.txt?');
    writeln('(S): Sí | (N): No');
    readln(inp);

    while (inp <> 'N') and (inp <> 'n') and not finish do begin
        if (inp = 'S') or (inp = 's') then begin
            export_all_employees(sel_file, base_folder + 'todos_los_empleados.txt');
            writeln(' Exportados exitosamente.');
            finish:= true;
        end;

        if not finish then begin
            writeln('');
            writeln('¿Desea exportar todos los empleados en BDD/todos_los_empleados.txt?');
            writeln('(S): Sí | (N): No');
            readln(inp);
        end;
    end;

    
    writeln('');
    writeln('¿Desea exportar todos los empleados sin DNI asignado?');
    writeln('(S): Sí | (N): No');
    readln(inp);

    finish:= false;
    while (inp <> 'N') and (inp <> 'n') and not finish do begin
        if (inp = 'S') or (inp = 's') then begin
            export_all_dniless_employees(sel_file, base_folder + 'empleados_sin_dni.txt');
            writeln(' Exportados exitosamente.');
            finish:= true;
        end;

        if not finish then begin
            writeln('');
            writeln('¿Desea exportar todos los empleados sin DNI asignado?');
            writeln('(S): Sí | (N): No');
            readln(inp);
        end;
    end;

    writeln('Salute!');
    close(sel_file);
end.