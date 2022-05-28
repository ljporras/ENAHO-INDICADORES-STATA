
cd "D:\ENAHO" //Cambiar el nombre segun el folder donde van a bajar la informacion

*Bajamos el modulo sumaria de la pagina del INEI
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/634-Modulo34.zip" 634-Modulo34.zip, replace
*Descomprimir los archivos "Manualmente"

use    sumaria-2018.dta, clear

*Generar la variable urbano/rural (usar la variable estrato)
gen     area=1 if estrato<=5
replace area=2 if estrato>=6 & estrato<=8
lab var area "Area de residencia"
lab def area 1 "Urbano" 2 "Rural"
lab val area area

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

*Estimamos el gasto mensual promedio de los hogares en terminos per capita
gen    gpcm=gashog2d/(mieperho*12)

*Creamos la variable factor de expansion de la poblacion
gen    facpob=factor07*mieperho

*Establecemos las caracteristicas de la encuesta usando las variables 
*factor de expansion, conglomerado y estrato
svyset [pweight=facpob], psu(conglome) strata(estrato)


*Para medir la pobreza relativa se debe establecer una linea de pobreza 
*igual para todos los hogares. Dicha linea es la media,
*por ello estimamos el valor promedo del gasto mensual per capita de los hogares

svy: mean gpcm //esto arroja un valor de 671.8312 para la ENAHO 2018

sum gpcm  [w=facpob]
gen p_relativa=(gpcm<r(mean))*100
label var p_relativa "Pobreza Relativa"

svy: mean p_relativa

*Pasandolo a doc en word usando el comando outreg
svy: mean p_relativa
outreg using Enaho2018.doc, replace addrows("****************") /// 
 stat(b se ci) nosubstat bdec(4) varlabels ///
 ctitle("Ambito","Porcentaje","Error Estandar","Intervalo de confianza al 95%") ///
 title("Pobreza Monetaria Relativa - 2018") /// 
 note(""\"Fuente: ENAHO 2018")
 
svy: mean p_relativa, over(area)
outreg using Enaho2018.doc, append addrows("****************") /// 
 stat(b se ci) nosubstat bdec(4) varlabels ///
 ctitle("","Porcentaje","Error Estandar","Intervalo de confianza al 95%") ///
 title("Pobreza Monetaria Relativa - 2018") /// 
 note(""\"Fuente: ENAHO 2018")
 
svy: mean p_relativa, over(dpto)
outreg using Enaho2018.doc, append   /// 
 stat(b se ci) nosubstat bdec(4) varlabels ///
 ctitle("","Porcentaje","Error Estandar","Intervalo de confianza al 95%") ///
 title("Pobreza Monetaria Relativa - 2018") /// 
 note(""\"Fuente: ENAHO 2018")