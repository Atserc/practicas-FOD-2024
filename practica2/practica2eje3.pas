{
 El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos que vende. Para ello, genera un 
archivo maestro donde figuran todos los productos que comercializa. De cada producto se maneja la siguiente información: código de producto, 
nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las ventas 
de productos realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide realizar un programa con 
opciones para:
	a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
		● Ambos archivos están ordenados por código de producto.
		● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.
		● El archivo detalle sólo contiene registros que están en el archivo maestro.
	b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo stock actual esté por debajo del stock mínimo 
	permitido.
}


program practica2eje3;

type
	cadena80 = string[80];
	
	producto = record;
		codigo : integer;
		nombre : cadena80;
		precio : real;
		stockAct : integer;
		stockMin : integer;
	end;
	
	venta = record;
		codigoProducto : integer;
		cantidadVendida : integer;
	end;

	archivoProductos = file of producto;
	archivoVentas = file of venta;

{
Actualizar el archivo maestro con el archivo detalle, sabiendo que:
		● Ambos archivos están ordenados por código de producto.
		● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.
		● El archivo detalle sólo contiene registros que están en el archivo maestro.
}

procedure minimo(var det1 : archivoVentas, var det2 : archivoVentas, var det3 : archivoVentas, regd1 : venta, regd2 : venta, regd3 : venta, var min : venta);
	begin
		if ((regd1.codigo > regd2.codigo) and (regd1.codigo > regd3.codigo)) then begin
			min := regd1;
			read(det1,regd1);
		end else if (regd2.codigo > regd3.codigo) begin
			min := regd1;
			read(det2,regd2);
		end else begin
			min := regd1;
			read(det3,regd3);
		end;
	end;

procedure actualizarMaestro(var mae : archivoProductos);
	var
		det1,det2,det3 : archivoDetalle;
		regm : producto;
		regd1,regd2,regd3, min : venta;
	begin
		reset(mae);
		
		assign(det,'detalle1.dat');
		reset(det1);
		assign(det,'detalle2.dat');
		reset(det2);
		assign(det,'detalle3.dat');
		reset(det3);
		
		read(det1,reg1);
		read(det2,reg2);
		read(det3,reg3);
		while(not EOF(mae)) do begin
			read(mae);
			minimo(det1,det2,det3,regd1,regd2,regd3,min);
			regm.stockAct := regm.stockAct - min.cantidadVendida;
			
		end;
		
		close(mae);
	end;

procedure listarStockMinimo(var mae : archivoProductos);
	var
		t : Text;
		p : producto;
	begin
		assign(t, 'stock_minimo.txt');
		reset(mae);
		rewrite(t);
		
		while (not EOF(mae)) do begin
			read(mae,p);
			if (p.stockAct < p.stockMin) then
				write(t,p.codigo, p.nombre, p.precio, p.stockAct, p.stockMin);
		end;
		
		close(mae);
		close(t);
	end;

{Programa Principal}
var
	mae : archivoProductos;
	opc : integer;

Begin
	assign(mae,'maestro.dat');
	opc := 999;
	repeat
		writeln('Que desea realizar ?');
		writeln('0 : finalizar.');
		writeln('1 : actualizar el archivo maestro.');
		writeln('2 : listar los productos cuyo stock actual sea menor al minimo.');
		write('Ingrese su opcion: ');
		readln(opc);
		
		case (opc) of
			0 : writeln();
			1 : actualizarMaestro(mae);
			2 :	listarStockMinimo(mae);
			else
				writeln('Opcion incorrecta.');
		end;
		
	until (opc = 0);
	
End.
