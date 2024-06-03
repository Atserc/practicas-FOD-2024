{
Parcial del repositorio de FM, primera fecha 04/06/2019
}


program practicaParcial1;

uses SysUtils;

const
	dimF = 30;
type
	cadena20 = string[20];

	venta = record
		cod_farmaco : integer;
		nombre : cadena20;
		fecha : cadena20;
		cantidad_vendida : integer;
		forma_pago : cadena20;
	end;
	
	farmacoResumido = record
		cod_farmaco : integer;
		nombre : cadena20;
		fecha : cadena20;
		cantidad_total_vendida : integer;
	end;
	
	archivoVentas = file of venta;
	detalles = array[1..dimF] of archivoVentas;
	ventasMax = array[1..dimF] of venta;

procedure leer(var det : archivoVentas; var regV : venta);
	begin
		if (EOF(det)) then
			regV.cod_farmaco := -1
		else
			read(det,regV);
	end;
	
procedure imprimirVenta(v : venta);
	begin
		writeln('Farmaco: ', v.cod_farmaco);
		writeln(' / Nombre: ', v.nombre);
		writeln(' / Fecha: ', v.fecha);
		writeln(' / Cantidad vendida: ', v.cantidad_vendida);
		writeln(' / Forma de pago: ', v.forma_pago);
	end;

procedure maximo(var dets : detalles; var regV : ventasMax; var max : venta);
	var
		vMaxCod,vMaxPos,i : integer;
		vMaxFecha : cadena20;
	begin
		vMaxCod := -1;
		vMaxPos := -1;
		vMaxFecha := 'aaa';
		
		for i := 1 to dimF do begin
			if (regV[i].cod_farmaco <> -1) then begin
				if ((regV[i].cod_farmaco > vMaxCod) or ((regV[i].cod_farmaco = vMaxCod) and (regV[i].fecha > vMaxFecha))) then begin
					vMaxCod := regV[i].cod_farmaco;
					vMaxFecha := regV[i].fecha;
					vMaxPos := i;
				end;
			end;
		end;
		
		if (vMaxCod <> -1) then begin
			max := regV[vMaxPos];
			leer(dets[vMaxPos],regV[vMaxPos]);
		end else
			max.cod_farmaco := -1;
	end;

procedure informarMayorCant(var dets : detalles);
	var
		i : integer;
		mayorCant,max,actual : venta;
		ventasAct : ventasMax;
	begin
		for i := 1 to dimF do begin
			leer(dets[i],ventasAct[i]);
		end;
		
		max.cod_farmaco := -1;
		mayorCant.cantidad_vendida := 0;
		maximo(dets, ventasAct, max);
		
		while (max.cod_farmaco <> -1) do begin
			actual := max;
			while ((max.cod_farmaco <> -1) and (max.cod_farmaco = actual.cod_farmaco)) do begin
				actual.cantidad_vendida := actual.cantidad_vendida + max.cantidad_vendida;
				maximo(dets, ventasAct, max);
			end;
			if (actual.cantidad_vendida > mayorCant.cantidad_vendida) then 
				mayorCant := actual;
		end;
		
		imprimirVenta(max);
	end;
	
procedure pasarATexto (var dets : detalles);
	var
		i : integer;
		archText : Text;
		max : venta;
		actual : farmacoResumido;
		ventasAct : ventasMax;
	begin
		assign(archText,'resumenFarmacos.txt');
		rewrite(archText);
		
		for i := 1 to dimF do begin
			leer(dets[i],ventasAct[i]);
		end;
		
		max.cod_farmaco := -1;
		maximo(dets, ventasAct, max);
		
		while (max.cod_farmaco <> -1) do begin
			actual.cod_farmaco := max.cod_farmaco;
			actual.nombre := max.nombre;
			actual.fecha := max.fecha;
			actual.cantidad_total_vendida := max.cantidad_vendida;
			
			maximo(dets, ventasAct, max);
			
			while ((max.cod_farmaco <> -1) and (actual.cod_farmaco = max.cod_farmaco) and (actual.fecha = max.fecha)) do begin
				actual.cantidad_total_vendida := actual.cantidad_total_vendida + max.cantidad_vendida;
				maximo(dets, ventasAct, max);
			end;
			
			writeln(archText, actual.cod_farmaco, actual.nombre, actual.fecha, actual.cantidad_total_vendida);
		end;
		
		close(archText);
	end;

{Programa Principal}
var
	i : integer;
	nombreArchivo : cadena20;
	dets : detalles;
Begin
	
	for i := 1 to dimF do begin
		nombreArchivo := 'detalle' + IntToStr(i) + '.dat';
		assign(dets[i],nombreArchivo);
		reset(dets[i]);
	end;
	
	informarMayorCant(dets);
	pasarATexto (dets);

	for i := 1 to dimF do begin
		close(dets[i]);
	end;
End.
