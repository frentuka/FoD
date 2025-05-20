{
El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos que vende.
    Para ello, genera un archivo maestro donde figuran todos los productos que comercializa.
    De cada producto se maneja la siguiente información:
        código de producto,
        nombre comercial,
        precio de venta,
        stock actual
        y stock mínimo.
    Diariamente se genera un archivo detalle donde se registran todas las ventas de productos realizadas.
    De cada venta se registran:
        código de producto
        y cantidad de unidades vendidas.
    Resuelve los siguientes puntos:

a. Se pide realizar un procedimiento que actualice el archivo maestro con el archivo detalle, teniendo en cuenta que:
    i. Los archivos no están ordenados por ningún criterio.
    ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.

b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que cada registro del archivo maestro
    puede ser actualizado por 0 o 1 registro del archivo detalle?
}

program p2ej1;

const
    base_folder = 'BDD/p3p2e1/';

type
    producto = record
        codigo, stock_disp, stock_min: integer;
        nombre: string;
        precio: real;
    end;

    venta = record
        codigo, unidades: integer;
    end;

    file_producto = file of producto;
    file_venta = file of venta;

{
a. Se pide realizar un procedimiento que actualice el archivo maestro con el archivo detalle, teniendo en cuenta que:
    i. Los archivos no están ordenados por ningún criterio.
    ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.
}

procedure actualizar_archivo_maestro(var file_m, var file_d);
var tmp_prod: producto;
    tmp_venta: venta;
begin
    reset(file_m); reset(file_d);

    // itero sobre maestro pq detalle podría tener 0/1/+1 ventas
    while not eof(file_m) do begin
        read(file_m, tmp_prod);
        
        seek(file_d, 0);
        while not eof(file_d) do begin
            read(file_d, tmp_venta);
        
            // si se encontró venta, modificar producto
            if tmp_prod.codigo = tmp_venta.codigo then
                tmp_prod.stock_disp = tmp_prod.stock_disp - tmp_venta.unidades;
        end;
        
        seek(file_m, filepos(file_m) - 1);
        write(file_m, tmp_prod);
    end;

    close(file_m); close(file_d);
end;

{
b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que cada registro del archivo maestro
    puede ser actualizado por 0 o 1 registro del archivo detalle?
}

procedure actualizar_archivo_maestro_2(var file_m, var file_d);
var tmp_prod: producto;
    tmp_venta: venta;
    encontrado: boolean;
begin
    reset(file_m); reset(file_d);

    while not eof(file_d) do begin
        read(file_d, tmp_venta);

        seek(file_m, 0);
        encontrado:= false;
        while not eof(file_m) and not encontrado do begin
            read(file_m, tmp_prod);

            if tmp_prod.codigo = tmp_venta.codigo then begin
                encontrado:= true;
                tmp_prod.stock_disp = tmp_prod.stock_disp - tmp_venta.unidades;
                seek(file_m, filepos(file_m) - 1);
                write(file_m, tmp_prod);
            end;
        end;
    end;

    close(file_m); close(file_d);
end;