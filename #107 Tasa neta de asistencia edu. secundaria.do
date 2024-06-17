
***TASA NETA DE ASISTENCIA ESCOLAR
use "D:\ENAHO 2021\enaho01a-2021-300.dta", clear

/* P203 ¿Cuál es la relación de parentesco con el jefe(a) del hogar?
0. Panel
1. Jefe/Jefa
2. Esposo/Esposa
3. Hijo/Hija
4. Yerno/Nuera
5. Nieto
6. Padres/Suegros
7. Otros parientes
8. Trabajador Hogar
9. Pensionista
10. Otros no parientes

P204 ¿Es miembro del hogar? 1. Si 2. No

P207 Sexo: 1. Hombre 2. Mujer

P208A ¿Qúe edad tiene en años cumplidos? (En años)

P307 Actualmente, ¿Asiste a algún centro o programa de educación básica 
o superior bajo modalidad de educación a distancia? 1. Si 2. No

P308A ¿Cuál es el grado o año de estudios en el que está matriculado?
1. Educacion inicial
2. Primaria
3. Secundaria
4. Superior no universitaria
5. Superior universitaria
6. Maestria/Doctorado
7. Básica especial */


*Var. Geograficas
gen     area=1 if estrato<=5
replace area=2 if estrato>=6 & estrato<=8
lab def area 1 "urbano" 2 "rural"
lab val area area

gen dpto= real(substr(ubigeo,1,2))
gen pro= substr(ubigeo,1,4)
replace dpto=26 if (pro=="1501")
label define dpto 1"Amazonas" 2"Ancash" 3"Apurimac" 4"Arequipa" 5"Ayacucho" /// 
 6"Cajamarca" 7"Callao" 8"Cusco" 9"Huancavelica" 10"Huanuco" 11"Ica" 12"Junin"  13"La_Libertad" /// 
 14"Lambayeque" 15"Lima 2/" 16"Loreto" 17"Madre_de_Dios"  18"Moquegua" 19"Pasco" /// 
 20"Piura" 21"Puno" 22"San_Martin" 23"Tacna" 24"Tumbes" 25"Ucayali" 26"MML 1/"
lab val dpto dpto 


label define tna 0 "No" 1 "T_asistencia"

*12 A 16 AÑOS
gen     tna_sec=.
replace tna_sec=0 if codinfor!="00" & p204==1 & p203!= 8 & p203!= 9 & mes>= "04" & (p208a>=12 & p208a<=16)
replace tna_sec=1 if codinfor!="00" & p204==1 & p203!= 8 & p203!= 9 & mes>= "04" & (p208a>=12 & p208a<=16)& (p307==1 & p308a==3)
label value tna_sec tna


svyset [pweight = factora07], psu(conglome)strata(estrato)
svy: mean tna_sec 
svy: mean tna_sec , over(area)
svy: mean tna_sec , over(p207)
svy: mean tna_sec , over(p207 area)

