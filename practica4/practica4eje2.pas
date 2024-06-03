{
Considere que desea almacenar en un archivo la información correspondiente a los
alumnos de la Facultad de Informática de la UNLP. De los mismos deberá guardarse
nombre y apellido, DNI, legajo y año de ingreso. Suponga que dicho archivo se organiza
como un árbol B de orden M.
}


program practica4eje2a;

uses SysUtils;

const m = 4;

type
	cadena20 = string[20];

	alumno = record
		nombre : cadena20;
		apellido : cadena20;
		dni : longint;
		legajo : integer;
		anioIngreso : integer;
	end;
	
	TNodo = record
		cantClaves : integer;
		clavesLegajo : array[1..(m-1)] of integer;
		enlaces : array[1..(m-1)] of integer;
		hijos : array[1..m] of integer;
	end;
	
	archivoAl = file of alumno;
	arbolB = file of TNodo;

{Programa principal}
var
	archivoAlumnos : arbolB;

Begin
	assign(archivoAlumnos,'arbolAlumnos.dat');
	
	rewrite(archivoAlumnos);
	
	
	
	close(archivoAlumnos);
	
End.


{
punto 2-b:  cada nodo tiene 512 bytes.
			integer ocupa 4 bytes.
			
			N = (M-1) * A + M * B + C + (M-1) * D
			N es el tamaño del nodo (en bytes)
			A es el tamaño de un registro (en bytes)
			B es el tamaño de cada enlace a un hijo
			C es el tamaño que ocupa el campo referido a la cantidad de claves.

			512 = (m-1) * 64 + m * 4 + 4 + (m-1) * 4
			512 = 64(m-1) + 4(m-1) + 4m + 4
			512 = 64m - 64 + 4m - 4 + 4m + 4
			512 =  72m - 64
			576 = 72m
			8 = m

			En este caso da directamente 8, por lo que ya es un entero.
}

