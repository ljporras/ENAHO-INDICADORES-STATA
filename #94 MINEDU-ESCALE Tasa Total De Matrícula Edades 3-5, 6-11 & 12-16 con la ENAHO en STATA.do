
*MATRICULA
cd "G:\ENAHO 2017"

use       enaho01a-2017-400.dta, clear
merge 1:1 conglome vivienda hogar codperso using  enaho01a-2017-300.dta
keep if _merge==3
drop _m

/*
MES Mes de procesamiento de la encuesta
P203 ¿Cuál es la relación de parentesco con el jefe del hogar? 0 Panel (No Presente el año actual) 
1 Jefe(a) 2 Esposo(a) 3 Hijo(a) 4 Yerno/Nuera 5 Nieto 6 Padres/Suegros 7 Otros parientes
8 Trabajador Hogar 9 Pensionista 10 Otros no parientes

P204 ¿Es miembro del hogar? /1. Si 2. No /Rango 1-2

P205 ¿Se encuentra ausente del hogar 30 días o más? /1. Si 2. No /Rango 1-2

P206 ¿Está presente en el hogar 30 días o más? /1. Si 2. No /Rango 1-2

P207 Sexo /1. Hombre 2. Mujer /Rango 1-2

P300A ¿ Cuál es el idioma o lengua materna que aprendió en su niñez?
1 Quechua 2 Aymara 3 Otra lengua nativa 4 Castellano 6 Portugués
7 Otra lengua extranjera 8 Es sordomudo/a, mudo/a 9 Missing value

P400A1  ¿En qué día, mes y año nació? - Día /99 Missing value /Rango : 1-31
P400A2  ¿En qué día, mes y año nació? - Mes /99 Missing value /Rango : 1-12
P400A3  ¿En qué día, mes y año nació? - Año /9999 Missing value /Rango : 1900 – 2021

P306 Este año, ¿Está Matrículado en algún centro o programa de educación básica o superior? /1 Si 2 No 9 Missing value
P307 Actualmente, ¿ Asiste a algún centro o programa de educación básica o superior? /1 Si 2 No 9 Missing value
*/

gen           nihno=p207==1
lab def       nihno 0 "Niñas" 1 "Niños", modify
lab val       nihno nihno

gen           area=estrato
recode        area (1/5=1) (6/8=2)
lab def       area 1 "Urbana" 2 "Rural", modify
lab val       area area
lab var       area "Area de residencia"

tab p300a, nol
gen           lengua=1 if p300a==4
replace       lengua=2 if p300a<4 
replace       lengua=3 if p300a==6  | p300a==7 | p300a==8 
lab def       lengua 1 "Castellano" 2 "Indígena" 3 "Otros", modify
lab val       lengua lengua

destring ubigeo, generate(dpto)
replace dpto=dpto/10000
replace dpto=round(dpto)
label variable dpto "Departamento"
label define dpto 1 "Amazonas" 2 "Ancash" 3 "Apurimac" 4 "Arequipa" 5 "Ayacucho" ///
 6 "Cajamarca"  7 "Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huanuco" 11 "Ica" 12 "Junin" ///
 13 "La_Libertad" 14 "Lambayeque"  15 "Lima" 16 "Loreto" 17 "Madre_de_Dios" 18 "Moquegua" ///
 19 "Pasco" 20 "Piura" 21 "Puno" 22 "San_Martin" 23 "Tacna" 24 "Tumbes" 25 "Ucayali"
label values dpto dpto

*Se excluyen a los que participaron durante los meses de enero a marzo 
*-correspondiente a las vacaciones escolares y al primer mes de clases
destring mes, replace
gen          matri_esc=1 if p306==1 & mes>=4
replace      matri_esc=2 if p306==2 & mes>=4
label define matri_esc 1 "Matriculado" 2 "No_matriculado"
label values matri_esc matri_esc
label var    matri_esc "Tasa total de matrícula"

*Estimar edad en años cumplidos al 31 de Marzo
tab a*o
rename   a*o year
destring year, replace

sum p400a1 p400a2 p400a3
gen      edad_31Marzo=year-p400a3     
replace  edad_31Marzo=(year-p400a3-1) if p400a2>3
replace  edad_31Marzo=0 if edad_31Marzo<0
replace  edad_31Marzo=. if p400a2==.


*Usamos el factor de expansion de la base para obtener los resultados a nivel nacional
*3-5
table nihno area [iweight=factora07] if (edad_31Marzo>=3 & edad_31Marzo<=5) & p203!=8 & p204==1 , stat(fvpercent matri_esc) nformat(%5.3f) 
table lengua [iweight=factora07] if (edad_31Marzo>=3 & edad_31Marzo<=5) &  p203!=8 & p204==1 , stat(fvpercent matri_esc) nformat(%5.3f) 

*6-11
table nihno area [iweight=factora07] if (edad_31Marzo>=6 & edad_31Marzo<=11) & p203!=8 & p204==1 , stat(fvpercent matri_esc) nformat(%5.3f) 
table lengua [iweight=factora07] if (edad_31Marzo>=6 & edad_31Marzo<=11) &  p203!=8 & p204==1 , stat(fvpercent matri_esc) nformat(%5.3f) 

*12-16
table nihno area [iweight=factora07] if (edad_31Marzo>=12 & edad_31Marzo<=16) & p203!=8 & p204==1 , stat(fvpercent matri_esc) nformat(%5.3f) 
table lengua [iweight=factora07] if (edad_31Marzo>=12 & edad_31Marzo<=16) &  p203!=8 & p204==1 , stat(fvpercent matri_esc) nformat(%5.3f) 

