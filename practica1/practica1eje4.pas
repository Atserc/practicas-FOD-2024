{
4. Agregar al menú del programa del ejercicio 3, opciones para:
	a. Añadir uno o más empleados al final del archivo con sus datos ingresados por teclado. Tener en cuenta que no se debe agregar al archivo un empleado 
		con un número de empleado ya registrado (control de unicidad).
	b. Modificar la edad de un empleado dado.
	c. Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.
	d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.
}


program FOD_practica1_eje4;

uses SysUtils;

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

procedure agregarEmpleados(var arch : archivoEmpleados);
	var
		eNuevo : empleado;
		eActual : empleado;
	begin
		leerEmpleado(eNuevo);
		read(arch,eActual);
		while ((not EOF(arch)) and (eActual.numero <> eNuevo.numero)) do begin
			read(arch,eActual);
		end;
		if (eActual.numero <> eNuevo.numero) then begin
			seek(arch, filePos(arch));
			write(arch,eNuevo);
		end;
		writeln('-Empleado agregado-')
	end;

procedure modificarEdad(var arch : archivoEmpleados; e : empleado);
	var
		eActual : empleado;
	begin
		read(arch,eActual);
		while ((not EOF(arch)) and (eActual.numero <> e.numero)) do begin
			read(arch,eActual);
		end;
		
		write('Ingrese la nueva edad del empleado: ');
		readln(eActual.edad);
		
		seek(arch, filePos(arch)-1);
		write(arch,eActual);
	end;

function transformarString(var e : empleado) : String;
	begin
		transformarString := 'numero: ' + IntToStr(e.numero) + ' Apellido: ' + e.apellido + ' Nombre: ' + e.nombre + ' Edad: ' + IntToStr(e.edad) + ' DNI: ' + IntToStr(e.DNI);

	end;

procedure pasarTxt(var arch : archivoEmpleados);
	var
		archTxt : textFile;
		e : empleado;
		nomTxt : String;
	begin
		write('Ingrese el nombre del archivo txt: ');
		readln(nomTxt);
		assign(archTxt,nomTxt);
		rewrite(archTxt);
		while(not EOF(arch)) do begin
			read(arch,e);
			writeln(archTxt,e.numero,' ',e.apellido,' ',e.nombre,' ',e.edad,' ',e.DNI);
		end;
		close(archTxt);
	end;

procedure pasarTxtSinDNI(var arch : archivoEmpleados);
	var
		archTxt : textFile;
		e : empleado;
		nomTxt : String;
	begin
		write('Ingrese el nombre del archivo txt: ');
		readln(nomTxt);
		assign(archTxt,nomTxt);
		rewrite(archTxt);
		while(not EOF(arch)) do begin
			read(arch,e);
			if (e.DNI = 00) then
				writeln(archTxt,e.numero,' ',e.apellido,' ',e.nombre,' ',e.edad,' ',e.DNI);
		end;
		close(archTxt);
	end;

procedure usarArchivo(var arch : archivoEmpleados);
	var
		opcion : integer;
		var e: empleado;
	begin
		reset(arch); {abro el archivo}
		
		writeln('¿ Que desea hacer con el archivo?');
		writeln('Ingrese 1 para listar un empleado');
		writeln('Ingrese 2 para listar todos los empleados');
		writeln('Ingrese 3 para listar los empleados proximos a jubilarse');
		writeln('Ingrese 4 para añadir uno o mas empleados');
		writeln('Ingrese 5 para modificar la edad de un empleado');
		writeln('Ingrese 6 para exportar en txt los empleados');
		writeln('Ingrese 7 para exportar un txt con los empleados sin DNI cargado (en 00)');
		write('Ingrese su opcion: '); readln(opcion);
	
		case opcion of
			1:	listarDatos(arch);
			2:	listarEmpleados(arch);
			3:	listarJubilandose(arch);
			4:	agregarEmpleados(arch);
			5: 	begin 
					leerEmpleado(e);
					modificarEdad(arch,e);
				end;
			6:	pasarTxt(arch);
			7:	pasarTxtSinDNI(arch);
		
			else writeln('opcion incorrecta');
		end;
	end;

{Programa principal}
var 
	arch : archivoEmpleados;
	nomArchivo : String;
	opcion, cont : integer;
	
Begin
	write('Ingrese el nombre del archivo: ');
	readln(nomArchivo); writeln();
	assign(arch, nomArchivo); {asigno el valor logico al valor fisico}
	cont := 0;
	repeat
	write('Ingrese 1 para crear un archivo, 2 para utilizar un archivo, o 0 para finalizar: ');
	readln(opcion);writeln();	
		if (opcion = 1) then begin
			cont = cont + 1;
			crearArchivo(arch);
			
		end else if (opcion = 2) then begin
			cont = cont + 1;
			usarArchivo(arch);
			
		end	else if (opcion <> 0) then
			writeln('Opcion incorrecta');
	until (opcion = 0);
	
	if (cont <> 0) then
		close(arch);
End.

