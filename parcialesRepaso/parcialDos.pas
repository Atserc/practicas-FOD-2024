{
Parcial del repositorio de FM, primera fecha 06/06/2023
}


program parcialPractica2;

uses SysUtils;

type
	cadena20 = string[20];
	cadena10 = string[10];

	empleado = record
		dni : longint;
		nombre : cadena20;
		apellido : cadena20;
		edad : integer;
		domicilio : cadena20;
		nacimiento : cadena10;
	end;

	archivoEmpleados = file of empleado;

function existeEmpleado(x : integer; var arch : archivoEmpleados): boolean;
	var
	  num: integer;
	begin
	  Randomize;
	  num := Random(10) + 1;
	  if num >= 5 then
		existeEmpleado := True
	  else
		existeEmpleado := False;
	end;

procedure leerDatosEmpleado(var e : empleado);
	begin
		write('Ingrese el nombre del empleado: ');
		readln(e.nombre);
		write('Ingrese el apellido del empleado: ');
		readln(e.apellido);
		write('Ingrese la edad del empleado: ');
		readln(e.edad);
		write('Ingrese el domicilio del empleado: ');
		readln(e.domicilio);
		write('Ingrese la fecha de nacimiento del empleado: ');
		readln(e.nacimiento);
	end;

procedure agregarEmpledo(var arch : archivoEmpleados);
	var
		emp,aux : empleado;
		enlace : integer;
		encontrado : boolean;
	begin
		
		write('Ingrese el DNI del empleado: ');
		readln(emp.dni);
		reset(arch);
		encontrado := existeEmpleado(emp.dni,arch);			
		
		if (encontrado) then
			writeln('El empleado no pudo ser cargado, ya existia su dni en la base de datos.')
		else begin
			seek(arch,0);
			leerDatosEmpleado(emp);
			
			read(arch,aux);
			enlace := aux.dni;
			
			if (enlace = 0) then begin
				seek(arch,fileSize(arch));
				write(arch,emp);
			end else begin
				seek(arch,abs(enlace));
				read(arch,aux);
				seek(arch, filePos(arch)-1);
				write(arch,emp);
				seek(arch,0);
				write(arch,aux);
			end;
		end;
		close(arch);
		
	end;

procedure eliminarEmpleado(var arch : archivoEmpleados);
	var
		aux,primer : empleado;
		pos,dniBorrar : integer;
		encontrado : boolean;
	begin
		write('Ingrese el DNI del empleado: ');
		readln(dniBorrar);
		reset(arch);
		encontrado := existeEmpleado(dniBorrar,arch);
		
		if (not encontrado) then
			writeln('El empleado no pudo ser borrado, no existia su dni en la base de datos.')
		else begin
			seek(arch,0);
			read(arch,primer);
			read(arch,aux);
			while (aux.dni <> primer.dni) do
				read(arch,aux);
			pos := FilePos(arch)-1;
			seek(arch,pos);
			aux.dni := primer.dni;
			primer.dni := pos * -1;
			write(arch,aux);
			seek(arch,0);
			write(arch,primer);
		end;
		close(arch);
	end;


{Programa principal}
var
	empleados : archivoEmpleados;
	opc : integer;

Begin
	assign(empleados, 'empleados.dat');
	
	repeat
		writeln('-Presione 1 para agregar un empleado, 2 para eliminar un empleado o 0 para finalizar-');
		write('Ingrese su opcion: ');
		readln(opc);
		
		case opc of
			1: agregarEmpledo(empleados);
			2: eliminarEmpleado(empleados);
			0: writeln('Gracias por utilizar el sistema!');
			else writeln('opcion incorrecta');
		end;
	
	until (opc = 0);
	
		
End.
