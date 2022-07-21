cd "D:\ENAHO 2017" 

*Bajamos el archivos zipeado la pagina del INEI - ENAHO 2017
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/603-Modulo03.zip" 603-Modulo03.zip, replace

*Tambien se puede bajar manualmente los archivos de la pagina "microdatos" del INEI

*Abrir archivo
use enaho01a-2017-300.dta, clear
gen           area=estrato
recode        area (1/5=1) (6/8=2)
lab def       area 1 "Urbana" 2 "Rural", modify
lab val       area area
lab var       area "Area de residencia"

gen           regnat=dominio 
recode        regnat (1/3 8 =1) (4/6=2) (7=3)
label var     regnat "region natural"
label define  regnat 1 "costa" 2 "sierra" 3 "selva"
label values  regnat regnat
************************************************************

*MATRICULA
*Definimos la poblacion segun edad normativa: 
*de 6 a 11 anios (Primaria) & de 12 a 17 anios (Secundaria)
gen            edad_norma=1 if p208a>=6 & p208a<=11
replace        edad_norma=2 if p208a>=12 & p208a<=17
label define   edad_norma 1 "Primaria" 2 "Secundaria"
label val      edad_norma edad_norma
label var      edad_norma "Edad Normativa"

gen          matri_esc=1 if p208a>=6 & p208a<=17 & p306==1 
replace      matri_esc=2 if p208a>=6 & p208a<=17 & p306==2
label define matri_esc 1 "Matriculado" 2 "No matriculado"
label values matri_esc matri_esc
label var    matri_esc "Matricula Escolar"
*Usamos el factor de expansion de la base para obtener los resultados a nivel nacional
tab          matri_esc  edad_norma [iweight=factora07] , col nofreq

*ASISTENCIA ESCOLAR
tab         p307  area [iweight=factora07] if p208a>=6 & p208a<=17, col nofreq
tab         p307  edad_norma [iweight=factora07] 
tab         p307  edad_norma [iweight=factora07] , col nofreq

/*En este caso no se incluye a los estudiantes que cursan primaria 
y tienen 12 y más años. Tampoco se incluye a los estudiantes que cursan 
secundaria y tienen 18 y más años. Dado que el atraso escolar es medido 
de más de dos años, el atraso escolar empieza desde los 9 años*/

*p308c, Grado de estudios al que asiste (primaria)
tab        p308c p208a [iweight=factora07] if p208a>=6  & p208a<=11

*p308b, Ahno de estudios al que asiste (secundaria)
tab        p308b p208a [iweight=factora07] if p308a==3 &p208a>=12 & p208a<=17

*ANALFABETISMO
gen       analfa=0       if p208a>=15 & p204==1
replace analfa=1       if p208a>=15 & p204==1 &  p302==2
tab        analfa [iweight=factora07]

*NIVEL DE ESCOLARIDAD
tab         p301a [iweight=factora07] if p208a>=18

***************************************************************
***************************************************************
*PASANDO LOS RESULTADOS A UN DOC DE WORD
	
*Establecemos las caracteristicas de la encuesta usando las variable 
*factor de expansion del modulo 300 (factora07), conglomerado y estrato
svyset [pweight=factora07], psu(conglome) strata(estrato)

*Empezamos a registrar los resultados en word 
*(recordar precisar el directorio en el que estan trabajando)

asdoc, text(\b INDICADORES DE EDUCACION) fs(12) replace

asdoc, text(\b Matricula Escolar) fs(12) append

asdoc tab    matri_esc  edad_norma [iweight=factora07] , /// 
title(\b Cantidad de ninos y ninas entre 6 y 17 ahnos matriculados por nivel educativo) fs(10) append

asdoc tab    matri_esc  edad_norma [iweight=factora07] , ///
 title(\b Cantidad de ninos y ninas entre 6 y 17 ahnos matriculados por nivel educativo) col nofreq fs(10) append

*ASISTENCIA ESCOLAR
asdoc, text(\b Asistencia Escolar) fs(12) append

asdoc tab   p307  area [iweight=factora07] if p208a>=6 & p208a<=17, /// 
title(\b Nivel de Inasistencia Escolar por Area) fs(10) append

asdoc tab   p307  edad_norma [iweight=factora07] , /// 
title(\b Nivel de Inasistencia Escolar por Edad Normativa) fs(10) append

asdoc tab   p307  edad_norma [iweight=factora07] , /// 
title(\b Nivel de Inasistencia Escolar por Edad Normativa) col nofreq fs(10) append

*RETRASO ESCOLAR (PORCENTAJE DE NINOS CON MAS DE 2 AHNOS DE RETRASO ESCOLAR)
asdoc, text(\b Retraso escolar) fs(12) append

*p308c, Grado de estudios al que asiste (primaria)
asdoc tab  p308c p208a [iweight=factora07] if p208a>=6  & p208a<=11, /// 
title(\b Numero de estudiantes por edad y ahno de estudio que cursa - nivel primaria) fs(10) append

*p308b, Ahno de estudios al que asiste (secundaria)
asdoc tab  p308b p208a [iweight=factora07] if p308a==3 &p208a>=12 & p208a<=17, /// 
title(\b Numero de estudiantes por edad y ahno de estudio que cursa - nivel secundaria) fs(10) append

*ANALFABETISMO
asdoc, text(\b Analfabetismo) fs(12) append

asdoc tab    analfa [iweight=factora07], /// 
title(\b Tasa de analfabetismo, personas mayores de 15 ahnos) fs(10) append

*NIVEL DE ESCOLARIDAD
asdoc, text(\b Nivel de Escolaridad) fs(12) append

asdoc tab   p301a [iweight=factora07] if p208a>=18, /// 
title(\b Grado de Instruccion de personas de 18 ahnos a mas) fs(10) dec(1) append
asdoc tab   p301a p207 [iweight=factora07] if p208a>=18, /// 
title(\b Grado de Instruccion de personas de 18 ahnos a mas por sexo) fs(10) dec(1) append
