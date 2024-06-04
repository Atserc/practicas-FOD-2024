{
 parcial AComAC FOD tema 1  
}

program parcial4Repaso;

uses SysUtils;

type
	cadena30 = string[30];

	recordDinos = record
		cod : integer;
		tipo : cadena30;
		altura : real;
		peso : real;
		desc : string;
		zona : cadena30;
	end;

	tArchDinos = file of recordDinos;

procedure leerTeclado(var d : recordDinos);
	begin
		write('Ingrese el codigo del dinosaurio: ');
		readln(d.cod);
		if (d.cod <> 0) then begin
			write('Ingrese el tipo del dinosaurio: ');
			readln(d.tipo);
			write('Ingrese la altura del dinosaurio: ');
			readln(d.altura);
			write('Ingrese el peso del dinosaurio: ');
			readln(d.peso);
			write('Ingrese la descripcion del dinosaurio: ');
			readln(d.desc);
			write('Ingrese la zona del dinosaurio: ');
			readln(d.zona);
		end;
	end;

procedure agregarDinosaurios(var a : tArchDinos; registro : recordDinos);
	var
		aux, primer : recordDinos;
		pos : integer;
	begin
		reset(a);
		
		read(a,primer);
		
		if (primer.cod = 0) then begin
			seek(a,fileSize(a));
			write(a,registro);
		end else begin
			pos := primer.cod;
			seek(a,abs(pos));
			read(a,aux);
			seek(a,filePos(a)-1);
			write(a,registro);
			seek(a,0);
			write(a,aux);
		end;
		
		close(a);
	end;
	
procedure eliminarDinosaurios(var a : tArchDinos);
	var
		aux, primer : recordDinos;
		pos,codBorrar : integer;

	begin
		reset(a);
		
		writeln('-Ingrese los codigos a borrar (finaliza con 0)-');
		write('Ingrese el codigo: ');
		readln(codBorrar);
		while(codBorrar <> 0) do begin
			
			read(a,primer);
			read(a,aux);
			while ((not EOF(a)) and (aux.cod <> codBorrar)) do
				read(a,aux);
			if (EOF(a)) then
				writeln('Codigo no encontrado en el archivo')
			else begin
				pos := filePos(a) - 1;
				aux := primer;
				seek(a,pos);
				write(a,aux);
				primer.cod := pos * -1;
				seek(a,0);
				write(a,primer);
			end;
			write('Ingrese el codigo: ');
			readln(codBorrar);
		end;
		
		close(a);
	end;

procedure pasarATexto(var a : tArchDinos);
	var
		aText : Text;
		aux : recordDinos;
	begin
		assign(aText,'dinosauriosTexto.txt');
		rewrite(aText);
		reset(a);
		
		while(not EOF(a)) do begin
			read(a,aux);
			if (aux.cod > 0) then
				writeln(aText, aux.cod,aux.tipo,aux.altura,aux.peso,aux.desc,aux.zona);
		end;
		
		close(aText);
		close(a);
	end;

{Programa Principal}
var
	d : recordDinos;
	arch : tArchDinos;
Begin
	assign(arch,'dinosaurios.dat');
	writeln('Agregue los dinosaurios al archivo (finaliza con codigo 0):');
	leerTeclado(d);
	while (d.cod <> 0) do begin
		agregarDinosaurios(arch,d);
		leerTeclado(d);
	end;
	
	eliminarDinosaurios(arch);
	pasarATexto(arch);
End.
