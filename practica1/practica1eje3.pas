{
Realizar un programa que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de empleados y completarlo con datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y
	i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado, el cual se proporciona desde el teclado.
	ii. Listar en pantalla los empleados de a uno por línea.
	iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.
}


program FOD_practica1_eje3;

type
	empleado = record
		numero : integer;
		apellido : String;
		nombre : String;
		edad : integer;
		DNI : LongInt;
	end;
	
	archivoEmpleados = file of empleado;

procedure leerEmpleado(var e : empleado);
	begin
		write('Ingrese el apellido del empleado: ');
		readln(e.apellido);
		if (e.apellido <> 'fin') then begin
			write('Ingrese el nombre del empleado: ');
			readln(e.nombre);
			write('Ingrese el numero del empleado: ');
			readln(e.numero);
			write('Ingrese la edad del empleado: ');
			readln(e.edad);
			write('Ingrese el DNI del empleado: ');
			readln(e.DNI);
		end;
	end;

procedure crearArchivo(var arch : archivoEmpleados);
	var
		e : empleado;
	begin
		rewrite(arch);
		leerEmpleado(e);
		while (e.apellido <> 'fin') do begin
			write(arch,e);
			leerEmpleado(e);
		end;
		close(arch);
	end;

procedure listarDatos(var arch : archivoEmpleados);
	var
	buscado : String;
	actual : empleado;
	encontrado : boolean;
	i : integer;
	begin
		encontrado := false;
		write('Ingrese el nombre o apellido buscado: ');
		readln(buscado);
		seek(arch,0);
		i:= 0;
		while ((not encontrado) and (i <= (fileSize(arch)-1))) do begin
			read(arch,actual);
			if ((actual.apellido = buscado) or (actual.nombre = buscado)) then
				encontrado := true;
			i := i+1;
		end;
		if (encontrado) then begin
			writeln('numero: ',actual.numero);
			writeln('nombre: ',actual.nombre);
			writeln('apellido: ',actual.apellido);
			writeln('edad: ',actual.edad);
			writeln('DNI: ',actual.DNI);
		end else
			writeln('No se encontro el nombre o apellido ingresado.');
	end;

procedure listarEmpleados(var arch : archivoEmpleados);
	var
		i : integer;
		actual : empleado;
	begin
		for i:= 0 to fileSize(arch)-1 do begin
			read(arch,actual);
			write('numero: ',actual.numero, ' / ');
			write('nombre: ',actual.nombre, ' / ');
			write('apellido: ',actual.apellido, ' / ');
			write('edad: ',actual.edad, ' / ');
			writeln('DNI: ',actual.DNI, '.');
		end;
	end;
procedure listarJubilandose(var arch : archivoEmpleados);
	var
		i : integer;
		actual : empleado;
	begin
		for i:= 0 to fileSize(arch)-1 do begin
			read(arch,actual);
			if (actual.edad > 70) then begin
				write('numero: ',actual.numero, ' / ');
				write('nombre: ',actual.nombre, ' / ');
				write('apellido: ',actual.apellido, ' / ');
				write('edad: ',actual.edad, ' / ');
				writeln('DNI: ',actual.DNI, '.');
			end;
		end;
	end;

procedure usarArchivo(var arch : archivoEmpleados);
	var
		opcion : integer;
	begin
		reset(arch); {abro el archivo}
		
		write('Ingrese 1 para listar un empleado, 2 para listar todos los empleados o 3 para listar los empleados proximos a jubilarse: ');
		readln(opcion);
	
		case opcion of
		   1: listarDatos(arch);
		   2: listarEmpleados(arch);
		   3: listarJubilandose(arch);
		   else writeln('opcion incorrecta');
		 end;
		 
		if ((opcion = 1) or (opcion = 2) or (opcion = 3)) then
			close(arch);
	end;

{Programa principal}
var 
	arch : archivoEmpleados;
	nomArchivo : String;
	opcion : integer;
	
Begin
	write('Ingrese el nombre del archivo: ');
	readln(nomArchivo);
	assign(arch, nomArchivo); {asigno el valor logico al valor fisico}
	
	write('Ingrese 1 para crear un archivo o 2 para utilizar un archivo: ');
	readln(opcion);
	if (opcion = 1) then begin
	
		crearArchivo(arch);
		
	end else if (opcion = 2) then begin
	
		usarArchivo(arch);
		
	end	else
		writeln('Opcion incorrecta');
End.



