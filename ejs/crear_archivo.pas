program crear_archivo;

type
    usuario = record
        nombre: string;
        id: integer;
    end;

    archivo_usuario = file of usuario;


var
    archivo: archivo_usuario;
    user1: usuario = (nombre: 'abecedario'; id: 13548);
    user2: usuario;
begin
    assign (archivo, 'C:\Users\srleg\Desktop\asd.dat');
    reset(archivo);
    write (archivo, user1);
    close(archivo);

    reset(archivo);
    read(archivo, user2);
    writeln(user2.nombre, ' ', user2.id);

    
end.