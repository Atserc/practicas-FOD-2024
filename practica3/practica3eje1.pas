{
Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados), agregándole una opción para realizar bajas copiando el último 
registro del archivo en la posición del registro a borrar y luego truncando el archivo en la posición del último registro de forma tal de 
evitar duplicados.
}

program FOD_practica3_eje1;

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

procedure darDeBajaEmpleado(var arch : archivoEmpleados);
	var
		regE : empleado;
		numBorrar : integer;
	begin
		
		write('Ingrese el numero del empleado a borrar: ');
		readln(numBorrar);
		
		read(arch,regE);
		while((regE.numero <> numBorrar) and (not EOF(arch))) do begin
			read(arch,regE);
		end;
		
		if (EOF(arch)) then writeln('Empleado no encontrado, el borrado no es posible.')
		else begin
			read(arch,regE);
			seek(arch,(filePos(arch) - 2));
			write(arch,regE);
			while(not EOF(arch)) do begin
				seek(arch,(filePos(arch) + 1));
				read(arch,regE);
				seek(arch,(filePos(arch) - 2));
				write(arch,regE);
			end;
			truncate(arch);
		end;
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
		writeln('Ingrese 8 para dar de baja un empleado');
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
			8:	darDeBajaEmpleado(arch);
		
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
			cont := cont + 1;
			crearArchivo(arch);
			
		end else if (opcion = 2) then begin
			cont := cont + 1;
			usarArchivo(arch);
			
		end	else if (opcion <> 0) then
			writeln('Opcion incorrecta');
	until (opcion = 0);
	
	if (cont <> 0) then
		close(arch);
End.

