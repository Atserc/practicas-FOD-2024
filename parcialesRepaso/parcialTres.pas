{
Parcial del repositorio de FM, primera fecha 05/06/2018
}


program parcial3Repaso;

uses SysUtils;

const
	valorAlto = 13;

type
	acceso = record
		anio : integer;
		mes : integer;
		dia : integer;
		idUsuario : integer;
		tiempo : real;
	end;

	archivoAccesos = file of acceso;

procedure leer (var arch : archivoAccesos; var regA : acceso);
	begin
		if(not EOF(arch)) then begin
			read(arch,regA);
		end else
			regA.mes := valorAlto;
	end;

{Programa principal}
var
	arch : archivoAccesos;
	dato : acceso;
	anioBuscado, mesActual, diaActual, totAnio, totMes, totDia : integer;
	
Begin
	assign(arch, 'accesos.dat');
	reset(arch);
	
	write('Ingrese el año del que desea la informacion: ');
	readln(anioBuscado);
	leer(arch,dato);
	while (dato.anio < anioBuscado) and (not EOF(arch)) do
		leer(arch,dato);
	if (EOF(arch)) then
		writeln('No existen datos para el año ingresado');
	else begin
		writeln('Año: ', dato.anio);
		while (dato.anio = anioBuscado) do begin
			totAnio := 0;
			while (dato.mes <> 13) do begin
				mesActual := dato.mes;
				totMes := 0;
				writeln('Mes: ',dato.mes);
				while (dato.mes = mesActual) do begin
					dia := dato.dia;
					totDia := 0;
					writeln('Dia: ',dato.dia);
					while (dato.dia = diaActual) do begin
						writeln('idUsuario ', dato.idUsuario, ' ', dato.tiempo);
						writeln('------');
						totDia := totDia + dato.tiempo;
						leer(arch,dato);
					end;
					writeln('Tiempo total acceso dia ', dato.dia, ' mes ', dato.mes, ': ', totDia);
					writeln('------');
					totMes := totMes + totDia;
				end;
				writeln('Tiempo total acceso mes ',dato.mes, ': ', totMes);
				writeln('------');
				totAnio := totAnio + totMes;
			end;
			writeln('Tiempo total acceso anio ', dato.anio, ': ', totAnio);
		end;
	end;
	
	close(arch);
End.

