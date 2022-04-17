/*  Sintaxis extraida del documento de Trabajo Nº 21-2014
INDICADORES SOCIALES Y DE DESIGUALDAD EN BASE A LA ENAHO CON STATA
por Alfonso Ayala-  Diciembre 22, 2014
ISSN 2312-4776
https://economia.unmsm.edu.pe/data/doc_trab/21-2014-OBG.pdf

I.  INTRODUCCIÓN
II. ENTORNO DE TRABAJO EN STATA
III.ANALISIS DE VARIABLES EN ENCUESTA NACIONAL DE HOGARES**
IV. BREVE INTRODUCCIÓN A LA PROGRAMACIÓN EN STATA
V.  ANÁLISIS DE LA DISTRIBUCIÓN DEL INGRESO EN LA ENAHO */

*Establecer carpeta de trabajo
cd "D:\ENAHO2013"

*Unir modulo de la vivienda con archivo sumaria
use enaho01-2013-100.dta, clear
merge 1:1 conglome vivienda hogar using sumaria-2013.dta
keep if _m==3

*Calculamos el factor de ponderación a nivel de la población
gen factor_personas=factor*mieperho

*Cálculo de la variable region natural (pag 18)
gen     region_natural=.
label   variable region_natural "Región Natural"
replace region_natural=1 if dominio<=3|dominio==8
replace region_natural=2 if dominio>=4& dominio<=6
replace region_natural=3 if dominio==7
label define etiq_region_natural 1 "Costa" 2 "Sierra" 3 "Selva"
label values region_natural etiq_region_natural

*Cálculo de la variable region  (pag 12/13)
destring ubigeo, generate(region)
replace region=region/10000
replace region=round(region)

label define etiq_region 1 "Amazonas" 2 "Ancash" 3 "Apurimac" 4 "Arequipa" /// 
5 "Ayacucho" 6 "Cajamarca" 7 "Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huanuco" /// 
11 "Ica" 12 "Junin" 13 "La Libertad" 14 "Lambayeque" 15 "Lima" 16 "Loreto" /// 
17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" 21 "Puno" /// 
22 "San Martín" 23 "Tacna" 24 "Tumbes" 25 "Ucayali"
label values region etiq_region

*Pobreza Monetaria Total
*Estimamos el gasto mensual promedio de los hogares en terminos per capita 
*(ver video de estimacion de pobreza)
gen gpcm=gashog2d/(mieperho*12)
*Contrastamos con la linea de pobreza total (linea) y etiquetamos la variable
gen          pobre_2=1 if gpcm <  linea
replace      pobre_2=0 if gpcm >= linea
*etiquetamos la variable y los valores que toma la variable
label var    pobre_2 "Pobreza Monetaria Total"
label define pobre_2 1 "pobre" 0 "no_pobre"
label value  pobre_2 pobre_2

*Pobreza a nivel regional (pag 13/14)
table region [iw=factor_personas], c(mean pobre_2)
*Para calcular el indicador de pobreza nacional se agrega la opción row (pag 16)
table region [iw=factor_personas], c(mean pobre_2) row

*Graficar (pag 15/16)
graph hbar pobre_2 [w=factor_personas], over(region, sort((mean) pobre_2))
graph hbar pobre_2 [w=factor_personas], over(region, sort((mean) pobre_2)) blabel(bar, format(%5.2f))
graph save Graph "Graph1.gph", replace
graph export "Graph1.png", as(png) replace

*Uso de la opción by(varlist) (pag 17)
/*Mediante la opción by(varlist) Stata calcula los estadísticos según los grupos
formados por la variable varlist. Por ejemplo: los estadísticos número de observaciones, 
la media, el valor mínimo y el valor máximo del ingreso bruto del hogar (inghog1d) 
por cada Región para el año 2013 se obtiene mediante: */
tabstat inghog1d [w=factor07], stat(n mean min max) by(region)

*Cálculo de quintiles de ingreso (pag 23)
/* xtile calcula los nq quintiles de la variable ingreso neto total (inghog2d), 
en este caso se pondera por el factor de expansión factor07. */
xtile quintiles_ing = inghog2d [w=factor07], nq(5) 

*Tenencia de bienes en la vivienda (celular) (pag 23/24)
*Usamos el módulo 100 de la ENAHO (Características de la Vivienda y del Hogar)
lookfor celular
gen TieneCelular = p1142 

*Etiquetamos la variable TieneCelular y los valores de la variable: 
label variable TieneCelular "Tenencia de celular en el hogar" 
label define etiq_celular 1 "Tiene cel" 0 "No tiene" 
label values TieneCelular etiq_celular 

*Calculamos la tenencia de celular por hogar: 
sum TieneCelular [iw=factor07]
tab TieneCelular [iw=factor07]

*Calculamos la tenencia de celular por regiones naturales y regiones: 
*Por regiones naturales
table region_natural [iw=factor07], c(mean TieneCelular) row
*Otra forma de verlo
tab   region_natural  TieneCelular [iw=factor07], nofreq row
*Por regiones
table region [iw=factor07], c(mean TieneCelular) row

*Calculamos los quintiles de ingreso según el acceso a algún servicio o 
*tenencia de algún bien (pag 27) 
table quintiles_ing [iw=factor07], c(mean TieneCelular)

