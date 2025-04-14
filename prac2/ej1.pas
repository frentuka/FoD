program ej1;

    // Una empresa posee un archivo con información de los ingresos percibidos por diferentes empleados
    // en concepto de comisión. De cada uno de ellos se conoce:
    //     - código de empleado
    //     - nombre
    //     - monto de la comisión.
    // La información del archivo se encuentra ordenada por código de empleado
    // y cada empleado puede aparecer más de una vez en el archivo de comisiones.

    // Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte.
    // En consecuencia, deberá generar un nuevo archivo en el cual cada empleado aparezca una única vez
    // con el valor total de sus comisiones.

    // NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser recorrido una única vez.

const
    base_folder = 'BDD/';

type
    empleado = record
        codigo: integer;
        nombre: string;
        comision: real;
    end;

    file_empleado = file of empleado;

procedure compactarArchivo(var f: file_empleado);
var
    new_f: file_empleado;
    emp_act, tmp_emp: empleado;
    temp_comision: real;
begin
    reset(f);

    assign(new_f, base_folder + 'archivo_compactado.bin');
    rewrite(new_f);

    while not eof(f) do begin
        read(f, emp_act);
        tmp_emp:= emp_act;
        seek(f, filepos(f) - 1);

        while (tmp_emp.codigo = emp_act.codigo) do begin
            write(new_f, tmp_emp);
            read(f, tmp_emp);
        end;

        seek(f, filepos(f) - 1);
    end;

    close(f);
end;

begin

end.