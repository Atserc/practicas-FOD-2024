{
Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado.
}


program FOD_practica1_eje1;

type
	archivoIntegers = file of integer;

{Programa principal}
var 
	arch : archivoIntegers;
	i : integer;

Begin
	assign(arch, 'archivoIntegersFisico.dat'); {asigno el valor logico al valor fisico}
	
	rewrite(arch); {creo el archivo}
	
	write('Ingrese un numero (finaliza con 30000): ');
	readln(i); {leo un numero}
	while (i <> 30000) do begin
		write(arch,i); {agrego el dato al archivo}
		write('Ingrese otro numero (finaliza con 30000): '); 
		readln(i); {leo otro numero}
	end;
	close(arch); {cierro el archivo}
End.

