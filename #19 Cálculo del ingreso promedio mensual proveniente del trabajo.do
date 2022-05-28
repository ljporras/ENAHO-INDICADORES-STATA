

Estimad@s, en este video comparto el cálculo del ingreso promedio mensual proveniente del trabajo con la Encuesta Nacional de Hogares (ENAHO) del 2017 en STATA. El ingreso promedio por trabajo corresponde a la PEA ocupada con ingresos mayores a cero y que provienen de su actividad principal, actividad secundaria, dependiente e independiente y puede ser monetario o no monetario.

Archivo: "enaho01a-2017-500.dta" que se ubica dentro del Módulo 500 de la Encuesta Nacional de Hogares (ENAHO) 2017

Variables que utilizaremos:
fac500a Factor de Expansión de Empleo/Ingresos proyecciones CPV-2007

ocu500
1 Ocupado
2 Desocupado Abierto
3 Desocupado Oculto
4 No PEA

I524A1  Ingreso total trimestral (Imputado, deflactado, Anualizado)
D529T   Pago en especie dependiente (Deflactado, Anualizado)
I530A   Ganancia (ocupación principal independiente) (Imputado, deflactado, Anualizado)
D536    Valor de los productos para su consumo (Deflactado, Anualizado)
I538A1  Ingreso total (Imputado, deflactado, Anualizado)
D540T   Pago en especie (dependiente) (Deflactado, Anualizado)
I541A   Ganancia (ocupación secundaria independiente) (Imputado, deflactado, Anualizado)
D543    Valor de los productos utilizados para su consumo (Deflactado, Anualizado)
D544T   Ingreso extraordinario (Deflactado, Anualizado)

P204 ¿Es miembro del hogar?
P205 ¿Se encuentra ausente del hogar 30 días o más?
P206 ¿Está presente en el hogar 30 días o más?

Fuente: INEI, Perú: Evolución de los Indicadores de Empleo e Ingreso por Departamento, 2007-2018.
Janet Porras
*******
/*
INGRESO PROMEDIO MENSUAL PROVENIENTE DEL TRABAJO - 2017
El ingreso promedio corresponde a la PEA ocupada con ingresos mayores a cero y 
que provienen de su actividad principal, actividad secundaria, 
dependiente e independiente y puede ser monetario o no monetario.

https://www.inei.gob.pe/media/MenuRecursivo/publicaciones_digitales/Est/Lib1678/libro.pdf

Archivo:
********
Usamos el modulo 500 de la ENAHO 2017

Variables que utilizaremos:
***************************

fac500a Factor de Expansión de Empleo/Ingresos proyecciones CPV-2007

ocu500
1	Ocupado
2	Desocupado Abierto
3	Desocupado Oculto
4	No PEA


I524A1  Ingreso total trimestral (Imputado, deflactado, Anualizado)
D529T   Pago en especie dependiente (Deflactado, Anualizado)
I530A   Ganancia (ocupación principal independiente) (Imputado, deflactado, Anualizado)
D536    Valor de los productos para su consumo (Deflactado, Anualizado)
I538A1  Ingreso total (Imputado, deflactado, Anualizado)
D540T   Pago en especie (dependiente) (Deflactado, Anualizado)
I541A   Ganancia (ocupación secundaria independiente) (Imputado, deflactado, Anualizado)
D543    Valor de los productos utilizados para su consumo (Deflactado, Anualizado)
D544T   Ingreso extraordinario (Deflactado, Anualizado)

P204 ¿Es miembro del hogar?

P205 ¿Se encuentra ausente del hogar 30 días o más?

P206 ¿Está presente en el hogar 30 días o más?

*/*


use "D:\enaho01a-2017-500.dta", clear
gen     area=1 if estrato<=5
replace area=2 if estrato>=6 & estrato<=8
lab def area 1 "urbano" 2 "rural"
lab val area area

destring ubigeo, generate(dpto)
replace dpto=dpto/10000
replace dpto=round(dpto)
label variable dpto "Departamento"
label define dpto 1 "Amazonas"
label define dpto 2 "Ancash", add
label define dpto 3 "Apurimac", add
label define dpto 4 "Arequipa", add
label define dpto 5 "Ayacucho", add
label define dpto 6 "Cajamarca", add
label define dpto 7 "Callao", add
label define dpto 8 "Cusco", add
label define dpto 9 "Huancavelica", add
label define dpto 10 "Huanuco", add
label define dpto 11 "Ica", add
label define dpto 12 "Junin", add
label define dpto 13 "La_Libertad", add
label define dpto 14 "Lambayeque", add
label define dpto 15 "Lima", add
label define dpto 16 "Loreto", add
label define dpto 17 "Madre_de_Dios", add
label define dpto 18 "Moquegua", add
label define dpto 19 "Pasco", add
label define dpto 20 "Piura", add
label define dpto 21 "Puno", add
label define dpto 22 "San_Martin", add
label define dpto 23 "Tacna", add
label define dpto 24 "Tumbes", add
label define dpto 25 "Ucayali", add
label values dpto dpto

egen  ingtrabw= rowtotal(i524a1 d529t i530a d536 i538a1 d540t i541a d543 d544t) 
gen   ingtra_n= ingtrabw/12
label var   ingtrabw "ingreso por trabajo anual"
label var   ingtra_n "ingreso por trabajo mensual"

*Establecer a los residentes habituales
gen resi=1 if ((p204==1 & p205==2) | (p204==2 & p206==1))

keep if ocu500 == 1 & ingtra_n > 0 

table area [iw=fac500a] if resi==1, c(mean ingtra_n) row
table dpto [iw=fac500a] if resi==1, c(mean ingtra_n) row
