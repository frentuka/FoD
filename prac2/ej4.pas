program ej4;

// Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
//     De cada producto se almacena:
//         - código del producto
//         - nombre
//         - descripción
//         - stock disponible
//         - stock mínimo
//         - precio del producto.
//     Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena.
//     Se debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo maestro.
//     La información que se recibe en los detalles es:
//         - código de producto
//         - cantidad vendida.
//     Además, se deberá informar en un archivo de texto:
//         - nombre de producto
//         - descripción
//         - stock disponible
//         - precio
//     de aquellos productos donde stock disponible < stock mínimo.

//     Pensar alternativas sobre realizar el informe en el mismo procedimiento de actualización,
//     o realizarlo en un procedimiento separado (analizar ventajas/desventajas en cada caso).

//     Nota: todos los archivos se encuentran ordenados por código de productos.
//     En cada detalle puede venir 0 o N registros de un determinado producto.

const
    base_folder = 'BDD/p2e4';

type
    producto = record
        codigo, stock_disp, stock_min: integer;
        nombre, descripcion: string;
        precio: real;
    end;

    venta = record
        codigo, cant: integer;
    end;

    file_producto = file of producto;
    file_venta = file of venta;

    arr_venta = array[1..30] of venta;
    arr_file_venta = array[1..30] of file_venta;


procedure actualizar(var file_m: file_producto; var arr_file_ventas: arr_file_venta);
var tmp_prod: producto;
    arr_tmp_ventas: arr_venta;
    i: integer;
    informe: Text;
begin
    reset(file_m);

    assign(informe, base_folder + 'informe.txt');
    rewrite(informe);

    for i:= 1 to 30 do begin
        reset(arr_file_ventas[i]);
        if not eof(arr_file_ventas[i]) then read(arr_file_ventas[i], arr_tmp_ventas[i]);
    end;

    while not eof(file_m) do begin
        read(file_m, tmp_prod);

        for i:= 1 to 30 do begin
            while (arr_tmp_ventas[i].codigo = tmp_prod.codigo) do begin
                tmp_prod.stock_disp = tmp_prod.stock_disp - arr_tmp_ventas[i].cant;
                read(arr_file_ventas[i], arr_tmp_ventas[i]);
            end;
        end;

        seek(file_m, filepos(file_m) - 1);
        write(file_m, tmp_prod);

        // informe: nombre, desc, stock_disp, precio
        if (tmp_prod.stock_disp < tmp_prod.stock_min) then
            writeln(informe, tmp_prod.nombre, ' ', tmp_prod.descripcion, ' ', tmp_prod.stock_disp, ' ', tmp_prod.stock_disp);
    end;

    close(file_m);
    close(informe);
    for i:= 1 to 30 do
        close(arr_file_ventas[i]);

end;

