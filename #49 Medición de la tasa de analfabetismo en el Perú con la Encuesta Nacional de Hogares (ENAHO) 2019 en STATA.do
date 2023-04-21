

*Cambiar el nombre segun el folder donde van a bajar la informacion
cd "D:\EDUCACION" 


*Guardar los pasos en un archivo log
log using analfabetismo_enaho2019, replace

*Abrir archivo
use  enaho01a-2019-300.dta, clear

*Grupo de edad
gen     gedad=1 if p208a>=15 &  p208a<20
replace gedad=2 if p208a>=20 &  p208a<30
replace gedad=3 if p208a>=30 &  p208a<40
replace gedad=4 if p208a>=40 &  p208a<50
replace gedad=5 if p208a>=50 &  p208a<60
replace gedad=6 if p208a>=60 
lab def gedad 1 "De 15 a 19 años" 2 "De 20 a 29 años" 3 "De 30 a 39 años" ///
4 "De 40 a 49 años" 5 "De 50 a 59 años" 6 "De 60 y más años"
lab val gedad gedad

*Area de residencia
gen            area=estrato
recode         area (1/5=1) (6/8=2)
lab def        area 1 "Urbana" 2 "Rural", modify
lab val        area area
lab var        area "Area de residencia"

*Region Natural
gen     regnat=1 if dominio<=3 | dominio==8
replace regnat=2 if dominio>=4 & dominio<=6
replace regnat=3 if dominio==7
lab var regnat   "Region natural"
lab def regnat 1 "Costa" 2 "Sierra" 3 "Selva"
lab val regnat regnat

*Dominio geografico
gen     dom=1 if regnat==1 & area==1
replace dom=2 if regnat==1 & area==2
replace dom=3 if regnat==2 & area==1
replace dom=4 if regnat==2 & area==2
replace dom=5 if regnat==3 & area==1
replace dom=6 if regnat==3 & area==2
replace dom=7 if dominio==8
lab def ldom 1 "Costa urbana" 2  "Costa rural" 3 "Sierra urbana" 4 "Sierra rural" ///
5 "Selva urbana" 6 "Selva rural" 7 "Lima Metropolitana"
lab val dom ldom

*Departamento (25)
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

*Departamento (distinguiendo Provincia de Lima/1 de Region Lima/2)
*1/Comprende los 43 distritos que conforman la provincia de Lima				
*2/Incluye las provincias de: Barranca, Cajatambo, Canta, Cañete, Huaral, Huarochiri, Huaura, Oyón y Yauyos.				
gen     dpto_26=dpto*10
replace dpto_26=151 if dom==7
replace dpto_26=152 if dpto==15 & dom~=7
label variable dpto_26 "Dpto (dist. Provincia de Lima de Region Lima)"
label define dpto_26 10 "Amazonas"
label define dpto_26 20 "Ancash", add
label define dpto_26 30 "Apurimac", add
label define dpto_26 40 "Arequipa", add
label define dpto_26 50 "Ayacucho", add
label define dpto_26 60 "Cajamarca", add
label define dpto_26 70 "Callao", add
label define dpto_26 80 "Cusco", add
label define dpto_26 90 "Huancavelica", add
label define dpto_26 100 "Huanuco", add
label define dpto_26 110 "Ica", add
label define dpto_26 120 "Junin", add
label define dpto_26 130 "La_Libertad", add
label define dpto_26 140 "Lambayeque", add
label define dpto_26 151 "Provincia de Lima", add
label define dpto_26 152 "Region Lima", add
label define dpto_26 160 "Loreto", add
label define dpto_26 170 "Madre_de_Dios", add
label define dpto_26 180 "Moquegua", add
label define dpto_26 190 "Pasco", add
label define dpto_26 200 "Piura", add
label define dpto_26 210 "Puno", add
label define dpto_26 220 "San_Martin", add
label define dpto_26 230 "Tacna", add
label define dpto_26 240 "Tumbes", add
label define dpto_26 250 "Ucayali", add
label values dpto_26 dpto_26

*ANALFABETISMO
gen          analfa=0 if p208a>=15 & p204==1
replace      analfa=1 if p208a>=15 & p302==2 & p204==1
label define analfa  0 "Si" 1 "No"
label values analfa analfa
label var    analfa "Sabe leer y escribir"
tab          analfa [iweight=factora07] 
tab          area analfa  [iweight=factora07]
tab          area analfa  [iweight=factora07], nofreq row
tab          regnat analfa  [iweight=factora07], nofreq row
tab          dpto_26 analfa [iweight=factora07], nofreq row
tab          gedad analfa [iweight=factora07], nofreq row
tab          gedad analfa [iweight=factora07] if p207==1, nofreq row
tab          gedad analfa [iweight=factora07] if p207==2, nofreq row

*Cerramo el archivo log
log close