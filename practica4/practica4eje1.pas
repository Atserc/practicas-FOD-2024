{
Considere que desea almacenar en un archivo la información correspondiente a los
alumnos de la Facultad de Informática de la UNLP. De los mismos deberá guardarse
nombre y apellido, DNI, legajo y año de ingreso. Suponga que dicho archivo se organiza
como un árbol B de orden M.
}


program practica4eje4a;

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
		cantDatos : integer;
		datos : array[1..(m-1)] of alumno;
		hijos : array[1..m] of integer;
	end;
	
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
punto 1-b:  registro de persona son 64 bytes.
			cada nodo tiene 512 bytes.
			integer ocupa 4 bytes.
			
			N = (M-1) * A + M * B + C
			N es el tamaño del nodo (en bytes)
			A es el tamaño de un registro (en bytes)
			B es el tamaño de cada enlace a un hijo
			C es el tamaño que ocupa el campo referido a la cantidad de claves.

			512 = (m-1) * 64 + m * 4 + 4
			512 =  64m - 64 + 4m + 4
			512 =  68m - 60
			572 = 68m
			8.411 = m
			
			como m debe ser entero M = 8
			
			N = (8 - 1) * 64 + 8 * 4 + 4
			N = 7 * 64 + 8 * 4 + 4
			N = 448 + 32 + 4
			N = 484


punto 1-c:  al cambiarse la cantidad de informacion de cada registro se afecta el valor A, por lo que entrarian menos registros por nodo, y
			por consiguiente, el valor de m aumenta.

punto 1-d:  el legajo, dado que es unico y no tan grande. Otra opcion es el dni, pero cada dni es mas extenso que cada legajo.

punto 1-e:  Si los alumnos se encuentran ordenados por legajo, se deberia buscar en la raiz el legajo que se quiera, y en caso de no 
			encontrarlo, se revisa si es mayor o menos que cada dato, hasta encontrar el o los datos mas cercanos. Ahi se va al nodo al cual
			apunta el puntero entre estos dos datos (o al menor o al mayor en caso de que solo tenga un dato cercano) y se repite este
			proceso	hasta encontrar el dato o llegar al final del arbol.
			En el peor de los casos seria el caso del arbol binario. Serian H lecturas de disco (H es la altura).
			En el mejor de los casos seria solo una lectura, y es el caso en el que el dato buscado se encuentra en la raiz.

punto 1-f:  En ese caso la busqueda podria ser mucho mas larga, en el peor de los casos debido a que hay que recorrer todos los nodos del 
			arbol, o hasta encontrarlo ya que no hay forma de ir "acercandose".

}

