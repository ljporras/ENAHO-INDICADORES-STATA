*POBREZA MONETARIA 2018

cd "D:\ENAHO 2018"

*Bajamos los archivos zipeados del modulo 100 y sumaria de la pagina del INEI
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/634-Modulo34.zip" 634-Modulo34.zip, replace

*Descomprimir los archivos "Manualmente"
use sumaria-2018.dta, clear

*VARIABLES GEOGRAFICAS (departamento, urbano/rural, costa/sierra/selva)
**************************
*Departamento
destring ubigeo, generate(dpto)
replace dpto=dpto/10000
replace dpto=round(dpto)
label variable dpto "dpto"
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
label var dpto "Departamento"

*Generar la variable urbano/rural (usar la variable estrato)
gen     area=1 if estrato<=5
replace area=2 if estrato>=6 & estrato<=8
lab var area "Area de residencia"
lab def area 1 "Urbano" 2 "Rural"
lab val area area

*Generar la variable region regiones naturales (usar la variable dominio)
gen     regnat=1 if dominio<=3 | dominio==8
replace regnat=2 if dominio>=4 & dominio<=6
replace regnat=3 if dominio==7
lab var regnat "Region natural"
lab def regnat 1 "Costa" 2 "Sierra" 3 "Selva"
lab val regnat regnat


*Pobreza Monetaria Total
*Estimamos el gasto mensual promedio de los hogares en terminos per capita
gen gpcm=gashog2d/(mieperho*12)

*Calculamos el factor de ponderacion a nivel de la poblacion
gen facpob=factor*mieperho

*Contrastamos gpcm con la linea de pobreza alimentaria (linpe) y pobreza total (linea)
gen          pobre3=1 if gpcm <  linpe
replace      pobre3=2 if gpcm >= linpe & gpcm < linea
replace      pobre3=3 if gpcm >= linea

*Etiquetamos los valores de la variable 
label define pobre3 1 "pobre_extremo" 2 "pobre_no_extremo" 3 "no_pobre"
label value  pobre3 pobre3
label var    pobre3 "Pobreza Monetaria"
gen          pobre_2=1 if gpcm <  linea
replace      pobre_2=0 if gpcm >= linea

*Etiquetamos los valores de la variable 
label define pobre_2 1 "pobre" 0 "no_pobre"
label value  pobre_2 pobre_2
label var    pobre_2 "Pobreza Monetaria Total"

*Establecemos las caracteristicas de la encuesta usando las variable 
*factor de expansion, conglomerado y estrato
svyset [pweight=facpob], psu(conglome) strata(estrato)


*INCIDENCIA, BRECHA Y SEVERIDAD DE LA POBREZA MONETARIA
*FGT(0): INCIDENCIA; FGT(1): BRECHA & FGT(2): SEVERIDAD
*FGT(0) o (P0): Incidencia de la pobreza, que representa la proporción de pobres
*o de pobres extremos como porcentaje del total de la población.
*FGT(1) o (P1): Brecha de la pobreza, que mide la insuficiencia promedio del consumo
*de los pobres respecto de la línea de pobreza, tomando en cuenta la proporción de la
*población pobre en la población total.
*FGT(2) o (P2): Severidad de la pobreza, que mide la desigualdad entre los pobres.

*Se puede usar el comando povdeco, sepov o svy
povdeco gpcm [w=facpob], varpl(linea)
sepov   gpcm [w=facpob], p(linea)

*diferencias en el formato del output usando "prop" vs. "mean"
svy: prop pobre_2
svy: mean pobre_2
svy: prop pobre_2, over(dpto)

