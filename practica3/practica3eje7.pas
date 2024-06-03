{
Se cuenta con un archivo que almacena información sobre especies de aves en vía de extinción, para ello se almacena: código, nombre de la 
especie, familia de ave, descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice un programa que elimine 
especies de aves, para ello se recibe por teclado las especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar 
todos los procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá implementar dos procedimientos, uno que 
marque los registros a borrar y posteriormente otro procedimiento que compacte el archivo, quitando los registros marcados. Para quitar los 
registros se deberá copiar el último registro del archivo en la posición del registro a borrar y luego eliminar del archivo el último 
registro de forma tal de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000.
}

program practica3ejercicio7;

uses SysUtils;

type
	cadena50 = string[50];
	
	ave = record
		codigo : longint;
		especie : cadena50;
		familia : cadena50;
		descripcion : string;
		zona : cadena50;
	end;

	archivoAves = file of ave;

procedure leerAve(var a : ave);
	begin
		write('Ingrese el codigo del ave: ');
		readln(a.codigo);
		if (a.codigo <> 500000) then begin
			write('Ingrese la especie del ave: ');
			readln(a.especie);
			write('Ingrese la familia del ave: ');
			readln(a.familia);
			write('Ingrese la descripcion del ave: ');
			readln(a.descripcion);
			write('Ingrese la zona del ave: ');
			readln(a.zona);
		end;
	end;

procedure marcarUnRegistro();

procedure marcarRegistros(var arch : archivoAves);
	var
		codAve : longint;
		aveActual : ave;
		encontrado : boolean;
	begin
		reset(arch);
		
		write('Ingrese el codigo de ave que desea eliminar: ');
		readln(codAve);
		while((not EOF(arch)) and (codAve <> 500000)) do begin
			seek(arch,0);
			encontrado := false;
			read(arch,aveActual);
			
			while ((not EOF(arch)) and(codAve <> aveActual.codigo)) do begin
				read(arch,aveActual);
			end;
			
			if (EOF(arch)) then writeln('El codigo no fue encontrado');
			else begin
				aveActual.especie := '#' + aveActual.especie; 
				seek(arch,filePos(arch)-1);
				write(arch,aveActual);
			end;
			
			write('Ingrese el codigo de ave que desea eliminar: ');
			readln(codAve);
		end;	
		
		close(arch);
	end;

procedure eliminarRegistros(var arch : archivoAves);
	var
		archN : archivoAves;
		aveActual : ave;
		primerLetra : char;
	begin
		reset(arch);
		assign(archN,'archivoAvesNuevo.dat');
		rewrite(archN);
		
		while (not EOF(arch)) do begin
			read(arch,aveActual);
			primerLetra := aveActual.especie[1];
			if (primerLetra <> '#') then write(archN,aveActual);
		end;
		
		close(archN);
		close(arch);
	end;


{programa principal}
var
	archAve : archivoAves;
Begin
	assign(archAve,'archivoAves.dat');
	marcarRegistros(archAve);
	eliminarRegistros(archAve);
End.
