cd "D:\Evolucion" //Cambiar el nombre segun el folder donde van a bajar la informacion

copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/546-Modulo34.zip" 546-Modulo34.zip, replace
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/603-Modulo34.zip" 603-Modulo34.zip, replace
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/634-Modulo34.zip" 634-Modulo34.zip, replace
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/687-Modulo34.zip" 687-Modulo34.zip, replace
*Descomprimo los archivos manualmente y los coloco en la carpeta


*Agregamos las bases sumaria del 2016, 2017, 2018 & 2019
use          sumaria-2016.dta, clear
append using sumaria-2017.dta
append using sumaria-2018.dta
append using sumaria-2019.dta

destring conglome, replace
tostring conglome, replace format(%06.0f)

recode ingtpu01 ingtpu02 ingtpu03 ingtpu04 ingtpu05 ig03hd1 ig03hd2 ig03hd3 ig03hd4 (.= 0)

*Renombro la variable ahno
rename a*o anio
gen     aniorec=real(anio)

*Genero variable departamento
gen     dpto= real(substr(ubigeo,1,2))
replace dpto=15 if (dpto==7)
label define dpto 1"Amazonas" 2"Ancash" 3"Apurimac" 4"Arequipa" 5"Ayacucho" /*
*/ 6"Cajamarca" 8"Cusco" 9"Huancavelica" 10"Huanuco" 11"Ica" 12"Junin" /*
*/ 13"La_Libertad" 14"Lambayeque" 15"Lima" 16"Loreto" 17"Madre_de_Dios" 18"Moquegua" /*
*/ 19"Pasco" 20"Piura" 21"Puno" 22"San_Martin" 23"Tacna" 24"Tumbes" 25"Ucayali" 
lab val dpto dpto 

*Agrego la base que contiene los deflactores
sort  aniorec dpto
merge aniorec dpto using deflactores_base2019_new.dta
tab _m
drop if _merge==2
drop _m

*Genero las variables de area de residencia, region natural y dominio geografico
replace estrato = 1 if dominio ==8 
gen     area = estrato <6
replace area = 2 if area==0
label define area 2 rural 1 urbana
label val area area

gen     region=1 if dominio>=1 & dominio<=3 
replace region=1 if dominio==8
replace region=2 if dominio>=4 & dominio<=6 
replace region=3 if dominio==7 
label define region 1 "Costa" 2 "Sierra" 3 "Selva"

gen     domin02=1 if dominio>=1 & dominio<=3 & area==1
replace domin02=2 if dominio>=1 & dominio<=3 & area==2
replace domin02=3 if dominio>=4 & dominio<=6 & area==1
replace domin02=4 if dominio>=4 & dominio<=6 & area==2
replace domin02=5 if dominio==7 & area==1
replace domin02=6 if dominio==7 & area==2
replace domin02=7 if dominio==8
label define domin02 1 "Costa_urbana" 2 "Costa_rural" 3 "Sierra_urbana" /*
*/ 4 "Sierra_rural" 5 "Selva_urbana" 6 "Selva_rural" 7 "Lima_Metropolitana"
label value domin02 domin02

gen     dominioA=1 if dominio==1 & area==1
replace dominioA=2 if dominio==1 & area==2
replace dominioA=3 if dominio==2 & area==1
replace dominioA=4 if dominio==2 & area==2
replace dominioA=5 if dominio==3 & area==1
replace dominioA=6 if dominio==3 & area==2
replace dominioA=7 if dominio==4 & area==1
replace dominioA=8 if dominio==4 & area==2
replace dominioA=9 if dominio==5 & area==1
replace dominioA=10 if dominio==5 & area==2
replace dominioA=11 if dominio==6 & area==1
replace dominioA=12 if dominio==6 & area==2
replace dominioA=13 if dominio==7 & area==1
replace dominioA=14 if dominio==7 & area==2
replace dominioA=15 if dominio==7 & (dpto==16 | dpto==17 | dpto==25) & area==1
replace dominioA=16 if dominio==7 & (dpto==16 | dpto==17 | dpto==25) & area==2
replace dominioA=17 if dominio==8 & area==1
replace dominioA=17 if dominio==8 & area==2

label define dominioA 1 "Costa norte urbana" 2 "Costa norte rural" 3 "Costa centro urbana" 4 "Costa centro rural" /*
*/ 5 "Costa sur urbana" 6 "Costa sur rural"	7 "Sierra norte urbana"	8 "Sierra norte rural"	9 "Sierra centro urbana" /* 
*/ 10 "Sierra centro rural"	11 "Sierra sur urbana" 12 "Sierra sur rural" 13 "Selva alta urbana"	14 "Selva alta rural" /*
*/ 15 "Selva baja urbana" 16 "Selva baja rural" 17"Lima Metropolitana"
lab val dominioA dominioA 

drop ld

sort  dominioA

merge dominioA using despacial_ldnew.dta
tab _m
drop _m


*Calculamos el factor de ponderacion
gen factornd07=round(factor07*mieperho,1)

svyset [pweight = factornd07], psu(conglome)

*** Ingresos ***
gen ipcr_2 = (ingbruhd +ingindhd)/(12*mieperho*ld*i00)
gen ipcr_3 = (insedthd + ingseihd)/(12*mieperho*ld*i00)
gen ipcr_4 = (pagesphd + paesechd + ingauthd + isecauhd)/(12*mieperho*ld*i00)
gen ipcr_5 = (ingexthd)/(12*mieperho*ld*i00)
gen ipcr_1 = (ipcr_2 + ipcr_3 + ipcr_4 + ipcr_5)

gen ipcr_7 = (ingtrahd)/(12*mieperho*ld*i00)
gen ipcr_8 = (ingtexhd)/(12*mieperho*ld*i00)
gen ipcr_6 = (ipcr_7 + ipcr_8)

gen ipcr_9  = (ingtprhd)/(12*mieperho*ld*i00)
gen ipcr_10 = (ingtpuhd)/(12*mieperho*ld*i00)
gen ipcr_11 = (ingtpu01)/(12*mieperho*ld*i00)
gen ipcr_12 = (ingtpu03)/(12*mieperho*ld*i00)
gen ipcr_13 = (ingtpu05)/(12*mieperho*ld*i00)
gen ipcr_14 = (ingtpu04)/(12*mieperho*ld*i00)
gen ipcr_15 = (ingtpu02)/(12*mieperho*ld*i00)
gen ipcr_16 = (ingrenhd)/(12*mieperho*ld*i00)
gen ipcr_17 = (ingoexhd + gru13hd3 + gru23hd3 + gru33hd3 + gru43hd3 + gru53hd3 + gru63hd3 + gru73hd3 + /*
*/  gru83hd3 + gru24hd +gru44hd + gru54hd + gru74hd + gru84hd + gru14hd5)/(12*mieperho*ld*i00)

*ajuste por el alquiler imputado
gen ipcr_18 =(ia01hd +gru34hd - ga04hd + gru64hd)/(12*mieperho*ld*i00)

gen ipcr_19 = (gru13hd1 + sig24 + gru23hd1 + gru33hd1 + gru43hd1 + gru53hd1 + gru63hd1 + gru73hd1 + gru83hd1 /* 
*/+ gru14hd3 + sig26)/(12*mieperho*ld*i00)

gen ipcr_20 = (gru13hd2 + ig06hd + gru23hd2 + gru33hd2 + gru43hd2 + gru53hd2 + gru63hd2 + ig08hd + gru73hd2 + /*
*/ gru83hd2 + gru14hd4 + sg42d + sg42d1 + sg42d2 + sg42d3)/(12*mieperho*ld*i00)


gen  ipcr_0= ipcr_2 + ipcr_3 + ipcr_4 + ipcr_5+ ipcr_7 + ipcr_8 + ipcr_16 + ipcr_17 + ipcr_18 + ipcr_19 + ipcr_20

label var ipcr_0 "Ingreso percapita mensual a precios de Lima monetario"
label var ipcr_1 "Ingreso percapita mensual a precios de Lima monetario por trabajo"
label var ipcr_2 "Ingreso percapita mensual a precios de Lima monetario por trabajo principal"
label var ipcr_3 "Ingreso percapita mensual a precios de Lima monetario por trabajo secundario"
label var ipcr_4 "Ingreso percapita mensual a precios de Lima pago en especie y autocon"
label var ipcr_5 "Ingreso percapita mensual a precios de Lima pago extraordinario por trabajo"
label var ipcr_6 "Ingreso percapita mensual a precios de Lima transferencia corriente"
label var ipcr_7 "Ingreso percapita mensual a precios de Lima transferencia monetaria del pais"
label var ipcr_8 "Ingreso percapita mensual a precios de Lima transferencia monetaria extranjero"
label var ipcr_9  "Ingreso percapita mensual a precios de Lima transferencia monetaria privada"
label var ipcr_10 "Ingreso percapita mensual a precios de Lima transferencia monetaria Publica total"
label var ipcr_11 "Ingreso percapita mensual a precios de Lima transferencia monetaria Publica Juntos"
label var ipcr_12 "Ingreso percapita mensual a precios de Lima transferencia monetaria Publica Pensión65"
label var ipcr_13 "Ingreso percapita mensual a precios de Lima transferencia monetaria Bono Gas"
label var ipcr_14 "Ingreso percapita mensual a precios de Lima transferencia monetaria Beca 18"
label var ipcr_15 "Ingreso percapita mensual a precios de Lima transferencia monetaria Otros Publica"
label var ipcr_16 "Ingreso percapita mensual a precios de Lima renta"
label var ipcr_17 "Ingreso percapita mensual a precios de Lima extraordinario"
label var ipcr_18 "Ingreso percapita mensual a precios de Lima alquiler imputado"
label var ipcr_19 "Ingreso percapita mensual a precios de Lima donacion publica"
label var ipcr_20 "Ingreso percapita mensual a precios de Lima donacion privada"


*** Salidas ***
svyset [pweight = factornd07], psu(conglome)strata(estrato)

*** Ingreso real promedio per capita mensual ***
svy:mean ipcr_0, over(aniorec)

outreg using "D:\Evolucion\pobreza.doc", replace stat(b se ci) nosubstat bdec(1) varlabels ///
 ctitle("Year", "Ingreso real promedio per capita mensual","Error Estandar","Intervalo de confianza al 95%") ///
 title("EVOLUCION DEL INGRESO REAL PROMEDIO PER CAPITA MENSUAL") note(""\"Fuente: ENAHO 2016-2019.")
 
svy:mean ipcr_0 if area==1, over(aniorec)
outreg using "D:\Evolucion\pobreza.doc", addtable stat(b se ci) nosubstat bdec(1) ///
 ctitle("Year", "Ingreso real promedio per capita mensual","Error Estandar","Intervalo de confianza al 95%") ///
 title("EVOLUCION DEL INGRESO REAL PROMEDIO PER CAPITA MENSUAL, URBANA") note(""\"Fuente: ENAHO 2016-2019.")
 
svy:mean ipcr_0 if area==2, over(aniorec)
outreg using "D:\Evolucion\pobreza.doc", addtable stat(b se ci) nosubstat bdec(1) ///
 ctitle("Year", "Ingreso real promedio per capita mensual","Error Estandar","Intervalo de confianza al 95%") ///
 title("EVOLUCION DEL INGRESO REAL PROMEDIO PER CAPITA MENSUAL, RURAL") note(""\"Fuente: ENAHO 2016-2019.")

svy:mean ipcr_0 if region==1, over(aniorec)
outreg using "D:\Evolucion\pobreza.doc", addtable stat(b se ci) nosubstat bdec(1) ///
 ctitle("Year", "Ingreso real promedio per capita mensual","Error Estandar","Intervalo de confianza al 95%") ///
 title("EVOLUCION DEL INGRESO REAL PROMEDIO PER CAPITA MENSUAL, COSTA") note(""\"Fuente: ENAHO 2016-2019.")
 
svy:mean ipcr_0 if region==2, over(aniorec)
outreg using "D:\Evolucion\pobreza.doc", addtable stat(b se ci) nosubstat bdec(1) ///
 ctitle("Year", "Ingreso real promedio per capita mensual","Error Estandar","Intervalo de confianza al 95%") ///
 title("EVOLUCION DEL INGRESO REAL PROMEDIO PER CAPITA MENSUAL, SIERRA") note(""\"Fuente: ENAHO 2016-2019.")

svy:mean ipcr_0 if region==3, over(aniorec)
outreg using "D:\Evolucion\pobreza.doc", addtable stat(b se ci) nosubstat bdec(1) ///
 ctitle("Year", "Ingreso real promedio per capita mensual","Error Estandar","Intervalo de confianza al 95%") ///
 title("EVOLUCION DEL INGRESO REAL PROMEDIO PER CAPITA MENSUAL, SELVA") note(""\"Fuente: ENAHO 2016-2019.")
 
 