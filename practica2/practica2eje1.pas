{
 Una empresa posee un archivo con información de los ingresos percibidos por diferentes empleados en concepto de comisión, de cada uno de 
ellos se conoce: código de empleado, nombre y monto de la comisión. La información del archivo se encuentra ordenada por código de 
empleado y cada empleado puede aparecer más de una vez en el archivo de comisiones.
 Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En consecuencia, deberá generar un nuevo archivo en el 
cual, cada empleado aparezca una única vez con el valor total de sus comisiones.

NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser recorrido una única vez.  
}


program practica2eje1;

type
	cadena50 = string[50]

	ingresoEmpleado = record
		codigo : integer;
		nombre : cadena50;
		monto : real;
	end;
	
	archivoIngresosEmpleado = file of ingresoEmpleado;s


{Programa Principal}
var
	det,mae : archivoIngresosEmpleado;
	e,aux: ingresoEmpleado;
Begin
	asset(det,'detalles.dat');
	asset(mae,'maestro.dat');
	
	reset(det);
	rewrite(mae);
	
	while(not EOF(det)) do begin
		read(det,e);
		aux := e;
		
		while (e.codigo = aux.codigo) do begin
			aux.total = aux.total + e.total;
			read(det,e);
		end;
		write(mae,aux);
		seek(det,filePos(det)-1);
	
	end;
	
	close(det);
	close(mae);
End.

