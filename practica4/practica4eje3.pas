{

}

program practica4eje3c;

uses SysUtils;

const m = 4;

type
	cadena20 = string[20];

	dato = record
		dato1 : integer;
		dato2 : integer; 
	end;

	TNodo = record
		cantClaves : integer;
		clavesLegajo : array[1..(m-1)] of integer;
		enlaces : array[1..(m-1)] of integer;
		hijos : array[1..m] of integer;
	end;

	archivoAl = file of dato;
	arbolBMas = file of TNodo;

{Programa principal}
var
	archivoAlumnos : arbolBMas;

Begin
	assign(archivoAlumnos,'arbolBMasAlumnos.dat');
	rewrite(archivoAlumnos);
	close(archivoAlumnos);
	
End.
