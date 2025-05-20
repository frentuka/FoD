program p3p2ej3;
{
Suponga que trabaja en una oficina donde está montada una LAN (red local).
    La misma fue construida sobre una topología de red que conecta 5 máquinas entre sí
    y todas las máquinas se conectan con un servidor central.
    
    Semanalmente cada máquina genera un archivo de logs informando las sesiones abiertas por cada usuario en cada terminal
    y por cuánto tiempo estuvo abierta.
    
    Cada archivo detalle contiene los siguientes campos:
        cod_usuario, 
        fecha,
        tiempo_sesion.
    
    Debe realizar un procedimiento que reciba los archivos detalle y genere un archivo maestro con los siguientes datos:
        cod_usuario,
        fecha,
        tiempo_total_de_sesiones_abiertas.
    
    Notas:
        ● Los archivos detalle no están ordenados por ningún criterio.
        ● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o inclusive, en diferentes máquinas.
}

const
    base_folder = 'BDD/p3p2e3';

type
    log = record
        cod_usuario: integer;
        fecha: string;
        tiempo_sesion: real;
    end;

    full_log = record
        cod_usuario: integer;
        fecha: string;
        tiempo_total_de_sesiones_abiertas: real;
    end;

    file_log = file of log;
    file_full_log = file of full_log;

    red = array[1..5] of file_log;

procedure crear_full_log(var file_fl: file_full_log; var file_red: red);
var tmp_fl: full_log;
    tmp_log: log;
    i: integer;
begin
    rewrite(file_fl);
    for i:= 1 to 5 do
        reset(file_red[i]);

    tmp_fl.cod_usuario:= -32768;
    tmp_fl.fecha = '';

    for i:=1 to 5 do begin
        while not eof(file_red[i]) do begin
            read(file_red[i], tmp_log);

            // encontrar coincidencia en maestro
            seek(file_fl, 0);
            while not eof(file_fl) and tmp_fl.cod_usuario <> tmp_log.cod_usuario and tmp_fl.fecha <> tmp_log.fecha do
                read(file_fl, tmp_fl);
            
            // actualizar
            if tmp_fl.cod_usuario <> tmp_log.cod_usuario and tmp_fl.fecha <> tmp_log.fecha then begin
                tmp_fl.tiempo_total_de_sesiones_abiertas:= tmp_fl.tiempo_total_de_sesiones_abiertas + tmp_fl.tiempo_sesion;
                seek(file_fl, filepos(file_fl) - 1);
            end else begin
                tmp_fl.cod_usuario:= tmp_log.cod_usuario;
                tmp_fl.fecha:= tmp_log.fecha;
                tmp_fl.tiempo_total_de_sesiones_abiertas:= tmp_fl.tiempo_sesion;
            end;

            write(file_fl, tmp_fl);
        end;
    end;

    close(file_fl);
    for i:=1 to 5 do
        close(file_red[i]);
end;