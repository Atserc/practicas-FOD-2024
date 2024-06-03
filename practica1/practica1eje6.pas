{
Agregar al menú del programa del ejercicio 5, opciones para:
	a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
	b. Modificar el stock de un celular dado.
	c. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.	
}

program practica1eje6;

type
	celular = record
		codigo : integer;
		precio : real;
		marca : String;
		stockDisp : integer;
		stockMin : integer;
		descripcion : String;
		nombre : String;
	end;
	
	archivoCelulares = file of celular;


procedure crearArchivo(var a : archivoCelulares);
	var
		archT : Text;
		cel : celular;
	begin
		assign(archT,'celulares.txt');
		
		reset(archT);
		rewrite(a);
		
		while (not eof(archT)) do begin
			readln(archT, cel.codigo,cel.precio,cel.marca);
			readln(archT, cel.stockDisp,cel.stockMin,cel.descripcion);
			readln(archT, cel.nombre);
			write(a,cel);
		end;
		writeln('--Carga finalizada--');
		close(archT);
		close(a);
	end;

procedure imprimirCelPantalla(c : celular);
	begin
		
		writeln('Codigo: ', c.codigo);
		writeln('Nombre: ', c.nombre);
		writeln('Descripcion: ', c.descripcion);
		writeln('Marca: ', c.marca);
		writeln('Precio: ', c.precio);
		writeln('Stock minimo: ', c.stockMin);
		writeln('Stock disponible: ', c.stockDisp);
	end;

procedure celularesBajoStock(var a : archivoCelulares);
	var
		cel :celular;
	begin
		reset(a);
		
		while(not EOF(a)) do begin
			read(a,cel);
			if (cel.stockMin >= cel.stockDisp) then
				imprimirCelPantalla(cel);
		end;
		
		close(a);
	end;
	
function contieneString(cad : String; desc : String) : boolean;
	var
	p : integer;
	begin
		p := Pos(cad,desc);
		if (p <> 0) then begin
			contieneString := true;
		end else
			contieneString := false;
	end;

procedure buscarPorString(var a : archivoCelulares);
	var
		cadena : String;
		cel : celular;
	begin
		reset(a);
		
		write('Ingrese la cadena buscada: ');
		readln(cadena);
		
		while(not EOF(a)) do begin
			read(a,cel);
			if (contieneString(cadena,cel.descripcion)) then
				imprimirCelPantalla(cel);
		end;
		
		close(a);
	end;
	
procedure exportarArchivo(var a : archivoCelulares);
	var
		archT : Text;
		cel : celular;
	begin
		assign(archT,'celulares.txt');
		
		reset(a);
		rewrite(archT);
		
		while (not eof(archT)) do begin
			read(a,cel);
			writeln(archT, cel.codigo,cel.precio,cel.marca);
			writeln(archT, cel.stockDisp,cel.stockMin,cel.descripcion);
			writeln(archT, cel.nombre);
		end;
		writeln('--Carga finalizada--');
		close(archT);
		close(a);
	end;
	
function leerCelular() : celular;
	var c : celular;
	begin
		write('Ingrese el codigo (0 para finalizar): ');
		readln(c.codigo);
		if (c. codigo <> 0) then begin
			write('Ingrese el nombre: ');
			readln(c.nombre);
			write('Ingrese la descripcion: ');
			readln(c.descripcion);
			write('Ingrese la marca: ');
			readln(c.marca);
			write('Ingrese el precio: ');
			readln(c.precio);
			write('Ingrese el stock minimo: ');
			readln(c.stockMin);
			write('Ingrese el stock disponible: ');
			readln(c.stockDisp);
		end;
		leerCelular := c;
	end;

procedure agregarCelular(var a : archivoCelulares);
	var
		c : celular;
	begin
		reset(a);
		
		seek(a,fileSize(a));
		
		c := leerCelular();
		while(c.codigo <> 0) do begin
			write(a,c);
			c := leerCelular();
		end;
		
		close(a);
	end;

procedure modificarStock(var a : archivoCelulares; cBuscado : celular);
	var
		c: celular;
		anterior : integer;
		encontrado : boolean;
	begin
		reset(a);
		encontrado := false;

		while(not EOF(a)) do begin
			read(a,c);
			if (c.codigo = cBuscado.codigo) then begin
				encontrado := true;
				
				write('Ingrese el nuevo stock: ');
				readln(c.stockDisp);
				
				anterior := filePos(a)-1; 
				seek(a,anterior);
				write(a,c);
			end;
		end;
		
		if (encontrado) then
			writeln('Stock actualizado correctamente')
		else
			writeln('No se encontro el celular especificado');
		
		close(a);
	end;

procedure exportarSinStock(var a : archivoCelulares);
	var
		archT : Text;
		cel : celular;
	begin
		assign(archT,'celulares.txt');
		
		reset(a);
		rewrite(archT);
		
		while (not eof(archT)) do begin
			read(a,cel);
			if (cel.stockDisp = 0) then begin
				writeln(archT, cel.codigo,cel.precio,cel.marca);
				writeln(archT, cel.stockDisp,cel.stockMin,cel.descripcion);
				writeln(archT, cel.nombre);
			end;
		end;
		writeln('--Carga finalizada--');
		
		close(archT);
		close(a);
	end;

{Programa principal}
var 
	arch : archivoCelulares;
	nomArchivo : String;
	opcion : integer;
	cBuscado : celular;

Begin
	write('Ingrese el nombre del archivo: ');
	readln(nomArchivo); writeln();
	assign(arch, nomArchivo);

	repeat
		writeln('¿ Que desea hacer ? (0 para finalizar)');
		writeln('Ingrese 1 para crear un archivo de celulares desde un txt');
		writeln('Ingrese 2 para listar los celulares con stock menor al minimo');
		writeln('Ingrese 3 para listar celulares que incluya una cadena de caracteres');
		writeln('Ingrese 4 para exportar el archivo de celulares a txt');
		writeln('Ingrese 5 para añadir celulares');
		writeln('Ingrese 6 para modificar el stock de un celular');
		writeln('Ingrese 7 para exportar los celulares sin stock a un txt');
		write('Ingrese su opcion: '); readln(opcion);
	
		case opcion of
			0:	writeln('Hasta pronto!');
			1:	begin 
					crearArchivo(arch);
					writeln();
				end;
			2:	begin 
					celularesBajoStock(arch);
					writeln();
				end;
			3:	begin 
					buscarPorString(arch);
					writeln();
				end;
			4:	begin 
					exportarArchivo(arch);
					writeln();
				end;
			5:	begin 
					agregarCelular(arch);
					writeln();
				end;
			6:	begin
					writeln('Ingrese los datos del celular a modificar');
					cBuscado := leerCelular();
					modificarStock(arch,cBuscado);
					writeln();
				end;
			7:	begin 
					exportarSinStock(arch);
					writeln();
				end;
			
			else begin 
				writeln('opcion incorrecta');
				writeln();
			end
		end;
	until (opcion = 0);
	
End.

