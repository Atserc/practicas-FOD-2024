{
Realizar un programa para una tienda de celulares, que presente un menú con opciones para:
	a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos ingresados desde un archivo de texto denominado 
	“celulares.txt”. Los registros correspondientes a los celulares deben contener: código de celular, nombre, descripción, marca, precio, 
	stock mínimo y stock disponible.
	b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.
	c. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.
	d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo. El 
	archivo de texto generado podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que debería respetar el formato 
	dado para este tipo de archivos en la NOTA 2.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique entres líneas consecutivas. En la primera se 
especifica: código de celular, el precio y marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera nombre 
en ese orden. Cada celular se carga leyendo tres líneas del archivo“celulares.txt”.
}

program practica1eje5;

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


{Programa principal}
var 
	arch : archivoCelulares;
	nomArchivo : String;
	opcion : integer;

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
			
			else begin 
				writeln('opcion incorrecta');
				writeln();
			end
		end;
	until (opcion = 0);
	
End.

