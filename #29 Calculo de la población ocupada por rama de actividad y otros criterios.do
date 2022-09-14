use "D:\ENAHO\sumaria-2018.dta", clear
*Creamos la variable factor de expansion de la poblacion
gen    facpob=factor07*mieperho

*Usando la variable pobreza generada por el INEI //con sumaria
generate pobreza2=1 if pobreza<3
replace  pobreza2=2 if pobreza==3
label    define pobreza2 1 "Pobre" 2 "No pobre"
label    value pobreza2 pobreza2

merge 1:m conglome vivienda hogar using "D:\ENAHO\enaho01a-2018-500.dta"
drop if p500i=="00"

*Area de residencia
gen     area=1 if estrato<=5
replace area=2 if estrato>=6 & estrato<=8
lab def area 1 "urbano" 2 "rural"
lab val area area

*Region natural
gen     region=1 if dominio>=1 & dominio<=3 
replace region=1 if dominio==8
replace region=2 if dominio>=4 & dominio<=6 
replace region=3 if dominio==7 
label define region 1 "Costa" 2 "Sierra" 3 "Selva"
lab val region region

*Se establece quienes son residentes habituales
gen resi=1 if ((p204==1 & p205==2) | (p204==2 & p206==1))

*Población ocupada en empleo informal
tab   ocu500 ocupinf [iw= fac500a]  if resi==1

*Población ocupada en empleo informal por Condición de pobreza
tab   pobreza2 ocupinf  [iw=fac500a] if  resi==1 & ocu500==1, nofreq row

*Población ocupada por tamahno de empresa
gen     tamahno=1 if p512b>=1  & p512b<11
replace tamahno=2 if p512b>=11 & p512b<51
replace tamahno=3 if p512b>50
replace tamahno=4 if p512b==. & (p512a==1 | p512a==2 )
label define tamahno 1 "De 1 a 10 trabajadores" 2 "De 11 a 50 trabajadores" /// 
3 "De 51 a más trabajadores" 4 "No especificado", replace
label value tamahno tamahno

tab   tamahno  area    [iw=fac500a] if  resi==1 & ocu500==1
tab   tamahno  region  [iw=fac500a] if  resi==1 & ocu500==1


*Población ocupada, según ramas de actividad
*CIIU
gen      ciiu_aux1 =substr("0"+string(p506r4),1,.)
replace  ciiu_aux1 =substr(string(p506r4),1,.) if p506r4>999
gen      ciiu_aux2 =substr(ciiu_aux1 ,1,2)
destring ciiu_aux2, generate(ciiu_2d)
gen      ciiu_1d=1 if  ciiu_2d<=2
replace  ciiu_1d=2 if  ciiu_2d==3
replace  ciiu_1d=3 if  ciiu_2d>=5  & ciiu_2d<=9
replace  ciiu_1d=4 if  ciiu_2d>=10 & ciiu_2d<=33
replace  ciiu_1d=5 if  ciiu_2d>=41 & ciiu_2d<=43
replace  ciiu_1d=6 if  ciiu_2d>=45 & ciiu_2d<=47
replace  ciiu_1d=7 if (ciiu_2d>=49 & ciiu_2d<=53) | (ciiu_2d>=58 & ciiu_2d<=63)
replace  ciiu_1d=8 if  ciiu_2d==84
replace  ciiu_1d=9 if  ciiu_2d>=55 & ciiu_2d<=56
replace  ciiu_1d=10 if ciiu_2d==68 | (ciiu_2d>=69 & ciiu_2d<=82)
replace  ciiu_1d=11 if ciiu_2d==85 					 
replace  ciiu_1d=12 if (ciiu_2d>=35 & ciiu_2d<=39) | (ciiu_2d>=64 & ciiu_2d<=66)  | ///
  (ciiu_2d>=86 & ciiu_2d<=88) |  (ciiu_2d>=90 & ciiu_2d<=93)| (ciiu_2d>=94 & ciiu_2d<=98) |  ciiu_2d==99
					 				 
label var ciiu_1d "Division CIIU"
la de ciiu_1d 1 "Agricultura" 2 "Pesca"  3 "Mineria" 4 "Manufactura" 5 "Construccion" ///
 6 "Comercio" 7 "Transportes y Comunicaciones"  8 "Gobierno" 9 "Hoteles y Restaurantes" ///
 10 "Inmobiliarias y alquileres" 11 "Ensehnanza" 12 "Otros Servicios 1/"
 label values ciiu_1d ciiu_1d
*1/ Otros Servicios lo componen las ramas de actividad de Electricidad, Gas y Agua, 
*Intermediación Financiera, Actividades de Servicios Sociales y de Salud, Otras activ.
*de Serv. Comunitarias, Sociales y Personales y Hogares privados con servicio doméstico.

tab ciiu_1d [iw= fac500a]  if resi==1 & ocu500==1, m

*Población ocupada en empleo informal por Rama de Actividad
gen      ciiu_6c=1 if ciiu_1d<4
replace  ciiu_6c=2 if ciiu_1d==4
replace  ciiu_6c=3 if ciiu_1d==5
replace  ciiu_6c=4 if ciiu_1d==6
replace  ciiu_6c=5 if ciiu_1d==7
replace  ciiu_6c=6 if ciiu_1d>7

label var ciiu_6c "Division CIIU-6 categorias"
la de ciiu_6c 1 "Agricultura/Pesca/Mineria" 2 "Manufactura" 3 "Construccion" ///
 4 "Comercio" 5 "Transportes y Comunicaciones" 6 "Otros Servicios 1/"
 label values ciiu_6c ciiu_6c
*1/ Otros Servicios lo componen las ramas de actividad de Electricidad, Gas y Agua, 
*Intermediación Financiera, Actividades de Servicios Sociales y de Salud, Otras activ.
*de Serv. Comunitarias, Sociales y Personales y Hogares privados con servicio doméstico.
*Adicionalmente incluye Gobierno, Hoteles y Restaurantes, Inmobiliarias y alquileres y Ensehnanza

tab ciiu_6c ocupinf [iw= fac500a]  if resi==1 & ocu500==1, nofreq row

drop _m
********************************************************************************
merge 1:1 conglome vivienda hogar codperso using "D:\ENAHO\enaho01a-2018-400.dta"
keep if _m==3
drop _m

recode  p4191 p4192 p4193 p4194 p4195 p4196 p4197 p4198 (2=0)
*no incluyo a los que tienen seguro escolar
gen     seguro= p4191 + p4192 + p4193 + p4194 + p4195 + p4196 + p4198 
tab     seguro
replace seguro=1 if seguro>=1 & seguro<=3

tab ocu500 seguro        [iw=fac500a] if  resi==1 & ocu500==1, row

tab area  seguro [iw=fac500a] if  resi==1 & ocu500==1, row
