cd "D:\ENAHO 2017" 

*Abrir el archivo
use enaho01a-2017-400.dta, clear

*Crear variable geografica area
gen            area=estrato
recode         area (1/5=1) (6/8=2)
lab def        area 1 "Urbana" 2 "Rural", modify
lab val        area area
lab var        area "Area de residencia"
	
*POBLACION CON SEGURO DE SALUD
*Existen 8 variables que indican si una persona esta afiliado a un seguro
sum          p4191-p4198

*La codificacion de las variables es 1 & 2, lo quiero cambiar a 1 & 0
recode       p4191-p4198 (2=0)
gen          seguro= p4191 + p4192 + p4193 + p4194 + p4195 + p4196 + p4197 + p4198
gen           asegurado=1 if seguro> 0
replace       asegurado=0 if seguro==0
label define  asegurado 0 "No" 1 "Si"
label val     asegurado asegurado
label var     asegurado "Tiene seguro de salud"

*Usamos el factor de expansion de la base para obtener los resultados a nivel nacional
tab          asegurado [iweight=factor07]


*PASANDO LOS RESULTADOS A UN DOC DE WORD

*Establecemos las caracteristicas de la encuesta usando las variable 
*factor de expansion del modulo 300 (factora07), conglomerado y estrato
svyset [pweight=factora07], psu(conglome) strata(estrato)

*Empezamos a registrar los resultados en word 
*(recordar precisar el directorio en el que estan trabajando)
asdoc, text(\b INDICADORES DE SALUD) fs(12) replace

asdoc, text(\b Acceso a Seguro de Salud) fs(12) append

asdoc tab    asegurado [iweight=factor07] , /// 
title(\b Tiene seguro de salud) append fs(10)

asdoc tab    asegurado area [iweight=factor07] , /// 
title(\b Tiene seguro de salud por ambito geografico) append fs(10)

asdoc tab    asegurado area [iweight=factor07] , col nofreq  /// 
title(\b Tiene seguro de salud por ambito geografico) append fs(10)

asdoc tab    asegurado p207 [iweight=factor07] , col nofreq  /// 
title(\b Tiene seguro de salud por sexo) append fs(10)
