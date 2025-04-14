program ej3;

// 3.
//     El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos que vende.
//     Para ello, genera un archivo maestro donde figuran todos los productos que comercializa.
//     De cada producto se maneja la siguiente información:
//         código de producto,
//         nombre comercial,
//         precio de venta,
//         stock actual
//         y stock mínimo.
//     Diariamente se genera un archivo detalle donde se registran todas las ventas de productos realizadas.
//     De cada venta se registran:
//         código de producto
//         y cantidad de unidades vendidas.
//     Se pide realizar un programa con opciones para:
//     a.
//     Actualizar el archivo maestro con el archivo detalle, sabiendo que:
//         ●Ambos archivos están ordenados por código de producto.
//         ●Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.
//         ●El archivo detalle sólo contiene registros que están en el archivo maestro.
//     b.
//     Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo stock actual
//         esté por debajo del stock mínimo permitido.

const
    base_folder = 'BDD/p2e3/';

type
    producto = record
        codigo, stock_ac, stock_min: integer;
        nombre: string;
        precio: real;
    end;

    venta = record
        codigo, unidades: integer;
    end;

    file_producto: file of producto;
    file_venta: file of venta;


//     a.
//     Actualizar el archivo maestro con el archivo detalle, sabiendo que:
//         ●Ambos archivos están ordenados por código de producto.
//         ●Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.
//         ●El archivo detalle sólo contiene registros que están en el archivo maestro.


procedure actualizar_archivo_maestro(file_m: file_producto; file_d: file_venta);
var tmp_producto: producto;
    tmp_venta: venta;
begin
    // file_m y file_d están preasignados
    reset(file_m); reset(file_d);

    // Recorrido del archivo detalle
    while not eof(file_d) do begin
        read(file_d, tmp_venta);
        
        // Encontrar alumno correspondiente
        while (tmp_producto.codigo <> tmp_venta.codigo) and not eof(file_m) do
            read(file_m, tmp_producto);

        // Realizar todas las operaciones "juntas"
        while (tmp_producto.codigo = tmp_venta.codigo) do begin
            // Operación
            tmp_producto.stock_ac:= tmp_producto.stock_ac - tmp_venta.unidades;
            
            read(file_d, tmp_venta);
        end;

        // Volver atrás una posición en archivo detalle, ya que "se pasa"
        seek(file_d, filepos(file_d) - 1);

        // Guardar en archivo maestro
        seek(file_m, filepos(file_m) - 1);
        write(file_m, tmp_producto);
    end;

    close(file_m); close(file_d);
end;