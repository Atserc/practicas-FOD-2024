{
 Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por cada alumno se dispone de su código de alumno, 
apellido, nombre, cantidad de materias (cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene un archivo 
detalle con el código de alumno e información correspondiente a una materia (esta información indica si aprobó la cursada o aprobó el final).

 Todos los archivos están ordenados por código de alumno y en el archivo detalle puede haber 0, 1 ó más registros por cada alumno del archivo 
 maestro. Se pide realizar un programa con opciones para:
	a. Actualizar el archivo maestro de la siguiente manera:
		i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado, y se decrementa en uno la cantidad de materias 
		sin final aprobado.
		ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final.
	b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales aprobados que materias sin finales aprobados. 
	Teniendo en cuenta que este listado es un reporte de salida (no se usa con fines de carga), debe informar todos los campos de cada alumno 
	en una sola línea del archivo de texto.

NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
}


program practica2eje2;

type
	cadena50 = string[50];

	alumno = record
		codigo : integer;
		apellido : cadena50;
		nombre : cadena50;
		materiasCursadas : integer;
		materiasAprobadas : integer;
	end;
	
	detAlumno = record
		codigo : integer;
		cursadaAprobada : boolean;
		finalAprobado : boolean;
	end;

	archivoAlumnosMae = file of alumno;
	archivoAlumnosDet = file of detAlumno;
	

procedure actualizarMaestro(var mae : archivoAlumnosMae);
	var
		det : archivoAlumnosDet;
		aMae : alumno;
		aDet : detAlumno;
	begin
		assign(det,'detalle.dat');
		reset(det);
		
		while(not EOF(det)) do begin
			read(det,aDet);
			read(mae,aMae);
			
			while (aDet.codigo <> aMae.codigo) do
				read(mae,aMae);
			
			if (aDet.finalAprobado) then begin
				aMae.materiasAprobadas := aMae.materiasAprobadas + 1;
				aMae.materiasCursadas := aMae.materiasCursadas - 1;
			end
			else if (aDet.cursadaAprobada) then
				aMae.materiasCursadas := aMae.materiasCursadas + 1;
			
			seek(mae, filePos(mae)-1);
			write(mae,aMae);
			
		end;
		
		close(det);
	end;

procedure listarMasFinalesAprobados(var mae : archivoAlumnosMae);
	var
		t : Text;
		a : alumno;
	begin
		assign(t,'salida.txt');
		rewrite(t);
		
		while (not EOF(mae)) do begin
			read(mae, a);
			if (a.materiasAprobadas > a.materiasCursadas) then
				write(t, a.codigo, a.apellido, a.nombre, a.materiasCursadas, a.materiasAprobadas);
		end;
		
		close(t);
	end;


{Programa Principal}
var
	mae : archivoAlumnosMae;
	opc : integer;

Begin
	assign(mae,'maestro.dat');
	reset(mae);
	opc := 999;
	repeat
		writeln('Que desea realizar ?');
		writeln('0 : finalizar.');
		writeln('1 : actualizar el archivo maestro.');
		writeln('2 : listar los alumnos con mas materias con finales aprobados que sin.');
		write('Ingrese su opcion: ');
		readln(opc);
		
		case (opc) of
			0 : writeln();
			1 : actualizarMaestro(mae);
			2 :	listarMasFinalesAprobados(mae);
			else
				writeln('Opcion incorrecta.');
		end;
		
	until (opc = 0);
	
	
	close(mae);
End.
