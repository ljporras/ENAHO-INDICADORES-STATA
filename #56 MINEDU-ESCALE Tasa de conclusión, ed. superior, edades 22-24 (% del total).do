
Estimad@s, en este video les muestro como estimar la Tasa de conclusión, ed. superior, edades 22-24 (% del total) con la Encuesta Nacional de Hogares (ENAHO) del 2019 en STATA. Gracias a Gustavo Espinoza Peralta por compartir el do-file.

***************************************************

*Tasa de conclusión
clear all

cd "D:\CONCLUSION"

*Unir las bases del módulo salud, educación y sumaria
use "enaho01a-2019-400.dta",clear
merge 1:1 conglome vivienda hogar codperso using  "enaho01a-2019-300.dta"
keep if _merge==3
drop _m
merge m:1 conglome vivienda hogar using "sumaria-2019.dta", nogenerate

*Estimar edad en años cumplidos al 31 de Marzo
rename   a*o year
destring year, replace
gen      edad_31Marzo=year-p400a3     if p400a2<4
replace  edad_31Marzo=(year-p400a3-1) if p400a2>3 & p400a2<=12
replace  edad_31Marzo=0 if edad_31Marzo<0

*Variables geográficas (departamento, urbano/rural)
*Departamento (distinguir Lima Metropolitana de Lima Provincias)
destring ubigeo, generate(dpto)
replace dpto=dpto/10000
replace dpto=round(dpto)
replace dpto=26 if (dominio==8) //Lima Metropolitana
replace dpto=27 if (dpto==15 & dominio!=8) //Lima Provincias
label define dpto_num 1  "Amazonas"
label define dpto_num 2  "Ancash",       add
label define dpto_num 3  "Apurimac",     add
label define dpto_num 4  "Arequipa",     add
label define dpto_num 5  "Ayacucho",     add
label define dpto_num 6  "Cajamarca",    add
label define dpto_num 7  "Callao",       add
label define dpto_num 8  "Cusco",        add
label define dpto_num 9  "Huancavelica", add
label define dpto_num 10 "Huanuco",      add
label define dpto_num 11 "Ica",          add
label define dpto_num 12 "Junin",        add
label define dpto_num 13 "La_Libertad",  add
label define dpto_num 14 "Lambayeque",   add
*label define dpto_num 15 "Lima",         add
label define dpto_num 16 "Loreto",       add
label define dpto_num 17 "Madre_de_Dios",add
label define dpto_num 18 "Moquegua",     add
label define dpto_num 19 "Pasco",        add
label define dpto_num 20 "Piura",        add
label define dpto_num 21 "Puno",         add
label define dpto_num 22 "San_Martin",   add
label define dpto_num 23 "Tacna",        add
label define dpto_num 24 "Tumbes",       add
label define dpto_num 25 "Ucayali",      add
label define dpto_num 26 "Lima_Metropolitana",   add
label define dpto_num 27 "Lima_Provincias",      add
label values dpto dpto_num

*Area
recode estrato (1/5=1 "Urbana")(6/8=2 "Rural"), gen(area)
lab var area "Area de Residencia"

*Etiquetar la variable pobreza monetaria
*Usar variable "pobreza" de sumaria
label define pobre_3 1 "pobre_extremo" 2 "pobre_no_extremo" 3 "no_pobre"
label value  pobreza pobre_3

*Crear la variable lengua materna
*Lengua indígena: quechua, aymara, otra lengua nativa
*Lengua Castellano
recode p300a (4=1 "Castellano")(1/3=2 "Indigena")(5/9=.), gen(lengua)

****************************************************
*Establecer las caracteristicas de la encuesta usando las variables 
*factor de expansion del modulo 300 (factora07), conglomerado y estrato
svyset [pweight=factora07], psu(conglome) strata(estrato) singleunit(centered)

*Tasa de conclusión, educación superior, grupo de edades 22-24 (% del total)
gen       conclusnyu2224=0 if  edad_31Marzo>=22 & edad_31Marzo<=24
replace   conclusnyu2224=1 if (edad_31Marzo>=22 & edad_31Marzo<=24) & (p301a==8 | p301a==10 | p301a==11)
label def con_l 0 "Incompleta" 1 "Completa" 
label val conclusnyu2224 con_l
label var conclusnyu2224 "Tasa de conclusion, educacion superior, edades 22-24"

*Estimar resultados
svy: prop conclusnyu2224 
outreg using conclusion, stat(b se ci) bdec(4) nosubstat varlabels replace ///
 title("Tasa de conclusion - educacion superior - edades 22-24") /// 
 ctitle("","","Pro","SE","Intervalo de Confianza")

svy: prop conclusnyu2224  , over(p207)
outreg using conclusion, stat(b se ci) bdec(4) nosubstat varlabels addtable /// 
 title("Tasa de conclusion - educacion superior - edades 22-24, por sexo") /// 
 ctitle("Ed. Superior","Sexo","Pro","SE","Intervalo de Confianza")
 
svy: prop conclusnyu2224 , over(area)
outreg using conclusion, stat(b se ci) bdec(4) nosubstat varlabels addtable ///
 title("Tasa de conclusion - educacion superior - edades 22-24, por area") /// 
 ctitle("Ed. Superior","Area","Pro","SE","Intervalo de Confianza")

svy: prop conclusnyu2224 , over(lengua)
outreg using conclusion, stat(b se ci) bdec(4) nosubstat varlabels addtable /// 
 title("Tasa de conclusion - educacion superior - edades 22-24, por lengua materna") /// 
 ctitle("Ed. Superior","Lengua","Pro","SE","Intervalo de Confianza")

svy: prop conclusnyu2224 , over(pobreza)
outreg using conclusion, stat(b se ci) bdec(4) nosubstat varlabels addtable /// 
 title("Tasa de conclusion - educacion superior - edades 22-24, por pobreza") /// 
 ctitle("Ed. Superior","Pobreza","Pro","SE","Intervalo de Confianza")

svy: prop conclusnyu2224 , over(dpto)
outreg using conclusion, stat(b se ci) bdec(4) nosubstat varlabels addtable /// 
 title("Tasa de conclusion - educacion superior - edades 22-24, por dpto") /// 
 ctitle("Ed. Superior","Dpto","Pro","SE","Intervalo de Confianza")
 