***********
*USO DE INTERNET
*Población de 6 y más años de edad que hace uso de internet, según ámbito geográfico, 2019
*Población de 6 y más años de edad que hace uso de internet, según nivel educativo, frecuencia de uso y ámbito geográfico, 2019

*Establecer el directorio donde vamos a trabajar
*Cambiar el nombre segun el folder donde van a bajar la informacion
cd "D:\EDUCACION" 

*Bajar el modulo de educacion de la Enaho 2019 y descomprimir el folder
*Guardar los pasos en un archivo log
log using usointernet_enaho2019, replace

*Abrir archivo
use  enaho01a-2019-300.dta, clear

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

*NIVEL EDUCATIVO
gen     educa=1 if p301a<5 | p301a==12
replace educa=2 if p301a>4 & p301a<7
replace educa=3 if p301a>6 & p301a<9
replace educa=4 if p301a>8 & p301a<12
label define educa 1 "Hasta primaria 1/" 2 "Secundaria" /// 
3 "Superior no universitaria" 4 "Superior universitaria"
label value  educa educa

*FRECUENCIA DE USO DE INTERNET
recode p314d 1=1 2=2 3 4=3, gen(uso_internet)
label define uso_internet 1 "Una vez al día" 2 "Una vez a la semana" 3 "Una vez al mes o más"
label value  uso_internet uso_internet

*USO DE INTERNET
tab  p314a  [iweight=factora07] if p208>5 & p204==1
tab  area p314a     [iweight=factora07] if p208>5 & p204==1, nofreq row
tab  regnat p314a   [iweight=factora07] if p208>5 & p204==1, nofreq row
tab  dpto p314a     [iweight=factora07] if p208>5 & p204==1, nofreq row
tab  educa uso_internet  [iweight=factora07] if p208>5 & p204==1, nofreq col
tab  educa uso_internet  [iweight=factora07] if p208>5 & p204==1 & area==1, nofreq col
tab  educa uso_internet  [iweight=factora07] if p208>5 & p204==1 & area==2, nofreq col

log close
