{
Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.
}


program FOD_practica1_eje2;

type
	archivoIntegers = file of integer;

{Programa principal}
var 
	arch : archivoIntegers;
	nomArchivo : String;
	i,j,cantMenores,cantT,total : integer;
	prom : real;
	
Begin
	write('Ingrese el nombre del archivo: '); {'archivoIntegersFisico.dat'}
	readln(nomArchivo);
	assign(arch, nomArchivo); {asigno el valor logico al valor fisico}
	reset(arch); {abro el archivo}
	writeln();
	
	cantMenores := 0;
	total := 0;
	cantT  := 0;
	
	
	for i := 0 to (fileSize(arch)-1) do begin
		read(arch, j);
		
		if (j < 1500) then
			cantMenores := cantMenores + 1;
		
		total := total + j;
		cantT := cantT + 1;
		
		write('valor ',(i+1),': ');
		writeln(j);
	end;
	writeln();
	
	writeln('Cantidad de numeros menores a 1500: ', cantMenores);
	writeln();
	
	prom := total / cantT;
	writeln('Promedio: ', prom:0:2);
	writeln();
	
	close(arch); {cierro el archivo}
End.

