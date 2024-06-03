{
Realizar un programa que genere un archivo de novelas filmadas durante el presente año. De cada novela se registra: código, género, nombre, 
duración, director y precio. El programa debe presentar un menú con las siguientes opciones:
	a.  Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se utiliza la técnica de lista invertida para recuperar espacio 
		libre en el archivo. Para ello, durante la creación del archivo, en el primer registro del mismo se debe almacenar la cabecera de la 
		lista. Es decir un registro ficticio, inicializando con el valor cero (0) el campo correspondiente al código de novela, el cual 
		indica que no hay espacio libre dentro del archivo.
	b.  Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el inciso a., se utiliza lista invertida para recuperación 
		de espacio. En particular, para el campo de ´enlace´ de la lista, se debe especificar los números de registro referenciados con signo 
		negativo, (utilice el código de novela como enlace).Una vez abierto el archivo, brindar operaciones para:
		  i. Dar de alta una novela leyendo la información desde teclado. Para esta operación, en caso de ser posible, deberá recuperarse el 
			 espacio libre. Es decir, si en el campo correspondiente al código de novela del registro cabecera hay un valor negativo, por 
			 ejemplo -5, se debe leer el registro en la posición 5, copiarlo en la posición 0 (actualizar la lista de espacio libre) y grabar 
			 el nuevo registro en la posición 5. Con el valor 0 (cero) en el registro cabecera se indica que no hay espacio libre.
		 ii. Modificar los datos de una novela leyendo la información desde teclado. El código de novela no puede ser modificado. 
		iii. Eliminar una novela cuyo código es ingresado por teclado. Por ejemplo, si se da de baja un registro en la posición 8, en el 
			 campo código de novela del registro cabecera deberá figurar -8, y en el registro en la posición 8 debe copiarse el antiguo 
			 registro cabecera.
	c.  Listar en un archivo de texto todas las novelas, incluyendo las borradas, que representan la lista de espacio libre. El archivo debe 
		llamarse “novelas.txt”.

NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser proporcionado por el usuario.
}


program practica3eje3;

uses SysUtils;

type
	cadena20 = string[20];

	novela = record
		codigo : integer;
		genero : cadena20;
		nombre : cadena20;
		duracion : cadena20;
		director : cadena20;
		precio : real;
	end;

	archivoNovelas = file of novela;

procedure leerNovela(var n : novela);
	begin
		write('Ingrese el genero de la novela: ');
		readln(n.genero);
		write('Ingrese el nombre de la novela: ');
		readln(n.nombre);
		write('Ingrese la duracion de la novela: ');
		readln(n.duracion);
		write('Ingrese el director de la novela: ');
		readln(n.director);
		write('Ingrese el precio de la novela: ');
		readln(n.precio);
		end;
	end;

procedure crearArchivo(var arch : archivoNovelas);
	var
		n : novela;
	begin
		rewrite(arch);
		
		n.codigo := 0;
		write(arch,n);
		
		write('Ingrese el codigo de la novela: ');
		readln(n.codigo);
		if (n.codigo <> 0) then leerNovela(n);
		while (n.codigo <> 0) do begin
			write(arch,n);
			
			write('Ingrese el codigo de la novela: ');
			readln(n.codigo);
			if (n.codigo <> 0) then leerNovela(n);
		end;
		
		close(arch);
	end;

procedure agregarNovela(var arch : archivoNovelas);
	var
		nov : novela;
	begin
		write('Ingrese el codigo de la novela: ');
		readln(nov.codigo);
		if (n.codigo <> 0) then leerNovela(nov);
		seek(arch,FileSize(arch)-1);
		write(arch,nov);
	end;

procedure modificarNovela(var arch : archivoNovelas);
	var
		nov,novActual : novela;
	begin
		write('Ingrese el codigo de la novela: ');
		readln(nov.codigo);
		
		read(arch,novActual);
		while ((not EOF(arch)) and (novActual.codigo <> nov.codigo)) do begin
			read(arch,eActual);
		end;
		
		if (EOF(arch)) then writeln('Novela no encontrada')
		else begin
			writeln('Ingrese los nuevos datos de la novela:');
			leerNovela(nov);
		end;
	end;

procedure eliminarNovela(var arch : archivoNovelas);
	var
		nov,novActual : novela;
	begin
		write('Ingrese el codigo de la novela: ');
		readln(nov.codigo);
		
		read(arch,novActual);
		while ((not EOF(arch)) and (novActual.codigo <> nov.codigo)) do begin
			read(arch,eActual);
		end;
		
		if (EOF(arch)) then writeln('Novela no encontrada')
		else begin
			read(arch,nov);
			seek(arch,(filePos(arch) - 2));
			write(arch,nov);
			while(not EOF(arch)) do begin
				seek(arch,(filePos(arch) + 1));
				read(arch,nov);
				seek(arch,(filePos(arch) - 2));
				write(arch,nov);
			end;
			truncate(arch);
		end;
		
	end;

procedure mantenimientoArchivo(var arch : archivoNovelas);
	var
		opc : integer;
	begin
		reset(arch);
		
		writeln('Que desea realizar con el archivo?');
		writeln('Ingrese 0 para salir.');
		writeln('Ingrese 1 para agregar una novela.');
		writeln('Ingrese 2 para modificar una novela.');
		writeln('Ingrese 3 para eliminar una novela.');
		write('Ingrese su opcion: ');
		readln(opc);
		case opc of
			0: writeln();
			1: agregarNovela(arch);
			2: modificarNovela(arch);
			3: eliminarNovela(arch);
			
			else writeln('opcion incorrecta');
		end;
		
		close(arch);
	end;
	
procedure listarArchivo(var arch : archivoNovelas);
	var
		
	begin
		reset(arch);
		
		
		
		close(arch);
	end;
	
{Programa principal}
var
	arch : archivoNovelas;
	opc : integer;
Begin
	assign (arch,'archivoNovelas.dat');
	
	writeln('Que desea realizar ?');
	writeln('Ingrese 0 para finalizar.');
	writeln('Ingrese 1 para crear el archivo.');
	writeln('Ingrese 2 para modificar el archivo.');
	writeln('Ingrese 3 para listar el archivo.');
	write('Ingrese su opcion: ');
	readln(opc);
	while (opc <> 0) do begin
		case opc of
			0: writeln();
			1: crearArchivo(arch);
			2: mantenimientoArchivo(arch);
			3: listarArchivo(arch);
			
			else writeln('opcion incorrecta');
		end;
		
		writeln('Desea realizar otra operacion?');
		writeln('Ingrese 0 para finalizar.');
		writeln('Ingrese 1 para crear el archivo.');
		writeln('Ingrese 2 para modificar el archivo.');
		writeln('Ingrese 3 para listar el archivo.');
		write('Ingrese su opcion: ');
		readln(opc);
	end;
End.
