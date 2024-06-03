{
Definir un programa que genere un archivo con registros de longitud fija conteniendo información de asistentes a un congreso a partir de la 
información obtenida por teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y nombre, email, teléfono y D.N.I. 
Implementar un procedimiento que, a partir del archivo de datos generado, elimine de forma lógica todos los asistentes con nro de asistente 
inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo String a su elección. Ejemplo: ‘@Saldaño’.
}


program FOD_practica3_eje2;

uses SysUtils;

type
	cadena20 = String[20];
	cadena50 = String[50];

	asistente = record
		nro : integer;
		apellido : cadena20;
		nombre : cadena20;
		email : cadena50;
		telefono : longint;
		dni  : integer;
	end;

	archivoAsistentes = file of asistente;

procedure leerAsistente(var a : asistente);
	begin
		write('Ingrese el numero de asistente: ');
		readln(a.nro);
		if (a.nro <> 0) then begin
			write('Ingrese el numero del asistente: ');
			readln(a.apellido);
			write('Ingrese el numero del asistente: ');
			readln(a.nombre);
			write('Ingrese el email del asistente: ');
			readln(a.email);
			write('Ingrese el telefono del asistente: ');
			readln(a.telefono);
			write('Ingrese el dni del asistente: ');
			readln(a.dni);
		end;
	end;

procedure borrarMenorMil(var arch : archivoAsistentes);
	var
		regA : asistente;
	begin
		
		reset(arch);
		
		while (not EOF(arch)) do begin
			read(arch,regA);
			if (regA.nro < 1000) then begin
				regA.apellido := '@' + regA.apellido;
				seek(arch,filePos(arch)-1);
				write(arch,regA);
			end;
		end;
	end;

{Programa principal}
var
	arch : archivoAsistentes;
	asistenteAux : asistente;
	opc : integer;

Begin
	assign(arch, 'asistentes.dat');
	rewrite(arch);
	
	writeln('Ingrese el primer asistente o 0 para cancelar:');
	leerAsistente(asistenteAux);
	while(asistenteAux.nro <> 0) do begin
		write(arch,asistenteAux);
		writeln('Ingrese otro asistente(numero de asistente 0 para finalizar la carga):');
		leerAsistente(asistenteAux);
	end;
	
	write('Ingrese 1 si desea borrar los asistentes con numero menor a 1000: ');
	readln(opc);
	if (opc = 1) then borrarMenorMil(arch);
	
	close(arch);
End.
