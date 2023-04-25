
cd "D:\DCALORICO"

***PROGRAMA PARA DETERMINAR LA NORMA CALORICA 
*Programa STATA de estimación de los requerimientos calóricos 2010*

use enaho01-2011-200.dta, clear
rename a*o anio
gen str13 identh = anio+ conglome+ vivienda+ hogar
gen str15 identi = anio+ conglome+ vivienda+ hogar+ codperso
order identh identi
sort  identh

*rename factor facpob
*facpob07 ya esta en la base
svyset [pweight=facpob07], psu(conglome) strata(estrato) 

*variables geograficas
gen     area=estrato<6 if estrato!=.
replace area=1 if dominio==8 & area==0

gen      dominio2=1 if  dominio<4 & area==1
replace  dominio2=2 if  dominio<4 & area==0
replace  dominio2=3 if  dominio>3 &  dominio<7 & area==1
replace  dominio2=4 if  dominio>3 &  dominio<7 & area==0
replace  dominio2=5 if  dominio==7 & area==1
replace  dominio2=6 if  dominio==7 & area==0
replace  dominio2=7 if  dominio==8

label define dominio2 1 "Costa urbana" 2 "Costa rural" 3 "Sierra urbana" /// 
4 "Sierra rural" 5 "Selva urbana" 6 "Selva rural" 7 "Lima Metrop."
label values dominio2 dominio2
tab dominio2

gen     region=dominio2<3 | dominio2==7 if dominio2!=.
replace region=2 if dominio2>2 & dominio2<5 & dominio2!=.
replace region=3 if dominio2>4 & dominio2<7 & dominio2!=.
label define region 1 "Costa" 2 "Sierra" 3 "Selva"
label values region region

*solo consideramos a los miembros del hogar
gen miembro=p204 
drop if miembro!=1
gen sexo=p207
recode sexo 2=0
drop if sexo==.
*edad en meses de los ninios
gen edad=p208a
gen  edadni=p208b if p208a==0
label var edadni "edad en meses de los menores de 1 anio"

*requerimientos caloricos y TMB
*Fuente: Anne J. Swindale, Punam Ohri-Vachaspati (1997): 
*"Household food consumption indicator guide". IMPACT.

* niños de 6 meses o menores
* requerimientos caloricos
gen     reqcal=470 if sexo==1 & edadni<1
replace reqcal=445 if sexo==0 & edadni<1
replace reqcal=550 if sexo==1 & edadni>=1 & edadni <2
replace reqcal=505 if sexo==0 & edadni>=1 & edadni <2
replace reqcal=610 if sexo==1 & edadni>=2 & edadni <3
replace reqcal=545 if sexo==0 & edadni>=2 & edadni <3
replace reqcal=655 if sexo==1 & edadni>=3 & edadni <4
replace reqcal=590 if sexo==0 & edadni>=3 & edadni <4
replace reqcal=695 if sexo==1 & edadni>=4 & edadni <5
replace reqcal=630 if sexo==0 & edadni>=4 & edadni <5
replace reqcal=730 if sexo==1 & edadni>=5 & edadni <6
replace reqcal=670 if sexo==0 & edadni>=5 & edadni <6

* niños de 6 meses a 11 meses 
* requerimientos caloricos
replace reqcal=765 if sexo==1 & edadni==6
replace reqcal=720 if sexo==0 & edadni==6
replace reqcal=810 if sexo==1 & edadni==7
replace reqcal=750 if sexo==0 & edadni==7
replace reqcal=855 if sexo==1 & edadni==8
replace reqcal=800 if sexo==0 & edadni==8
replace reqcal=925 if sexo==1 & edadni==9
replace reqcal=865 if sexo==0 & edadni==9
replace reqcal=970 if sexo==1 & edadni==10
replace reqcal=905 if sexo==0 & edadni==10
replace reqcal=1050 if sexo==1 & edadni==11
replace reqcal=975 if sexo==0 & edadni==11

* niños de 1 a 5 años
* requerimientos caloricos
replace reqcal=1200 if sexo==1 & edad==1
replace reqcal=1140 if sexo==0 & edad==1
replace reqcal=1410 if sexo==1 & edad==2
replace reqcal=1310 if sexo==0 & edad==2
replace reqcal=1560 if sexo==1 & edad==3
replace reqcal=1440 if sexo==0 & edad==3
replace reqcal=1690 if sexo==1 & edad==4
replace reqcal=1540 if sexo==0 & edad==4
replace reqcal=1810 if sexo==1 & edad==5
replace reqcal=1630 if sexo==0 & edad==5

* niños de 6 a 9 años 
* requerimientos caloricos
replace reqcal=1900 if sexo==1 & edad==6
replace reqcal=1700 if sexo==0 & edad==6
replace reqcal=1990 if sexo==1 & edad==7
replace reqcal=1770 if sexo==0 & edad==7
replace reqcal=2070 if sexo==1 & edad==8
replace reqcal=1830 if sexo==0 & edad==8
replace reqcal=2150 if sexo==1 & edad==9
replace reqcal=1880 if sexo==0 & edad==9

*tasas de metabolismo basal por edades y sexo
gen     tmb=(17.5*30.6)+651 if sexo==1 & edad==10
replace tmb=(12.2*31.7)+746 if sexo==0 & edad==10
replace tmb=(17.5*32.4)+651 if sexo==1 & edad==11
replace tmb=(12.2*35.7)+746 if sexo==0 & edad==11 
replace tmb=(17.5*36.5)+651 if sexo==1 & edad==12
replace tmb=(12.2*40.0)+746 if sexo==0 & edad==12
replace tmb=(17.5*41.4)+651  if sexo==1 & edad==13
replace tmb=(12.2*41.6)+746  if sexo==0 & edad==13
replace tmb=(17.5*46.9)+651  if sexo==1 & edad==14
replace tmb=(12.2*47.8)+746  if sexo==0 & edad==14
replace tmb=(17.5*52.3)+651  if sexo==1 & edad==15
replace tmb=(12.2*48.1)+746  if sexo==0 & edad==15
replace tmb=(17.5*53.1)+651  if sexo==1 & edad==16
replace tmb=(12.2*49.8)+746  if sexo==0 & edad==16
replace tmb=(17.5*56.3)+651  if sexo==1 & edad==17
replace tmb=(12.2*50.4)+746  if sexo==0 & edad==17
replace tmb=(15.3*58.2)+679  if sexo==1 & edad>17 & edad<30
replace tmb=(14.7*51.0)+496  if sexo==0 & edad>17 & edad<30
replace tmb=(11.6*58.2)+879  if sexo==1 & edad>29 & edad<60
replace tmb=(8.7*51.0)+829  if sexo==0 & edad>29 & edad<60
replace tmb=(13.5*58.2)+487  if sexo==1 & edad>59 & edad!=.
replace tmb=(10.5*51.0)+596  if sexo==0 & edad>59 & edad!=.
label var tmb "tasa metabolica basal"

*tasas de metabolismo basal corregidos por tipo de actividad
*fuente de los coeficientes de correccion por niveles de actividad:
*José Maria Bengoa, Benjamin Torùn, Moisés Bahar y Nevin Scrimshaw: 
*Food nutrition Bulletin, vol 11, n°1. p.8 cuadro 1.The United Nations University

*tmbam= actividad moderada
*tmbai= actividad intensa

*tmbal= actividad ligera
gen     tmbal=tmb*1.75 if sexo==1 & edad>9 & edad<13
replace tmbal=tmb*1.64 if sexo==0 & edad>9 & edad<13
replace tmbal=tmb*1.68 if sexo==1 & edad>12 & edad<15
replace tmbal=tmb*1.59 if sexo==0 & edad>12 & edad<15
replace tmbal=tmb*1.62 if sexo==1 & edad>14 & edad<18
replace tmbal=tmb*1.55 if sexo==0 & edad>14 & edad<18
replace tmbal=tmb*1.55 if sexo==1 & edad>17 & edad<66
replace tmbal=tmb*1.55 if sexo==0 & edad>17 & edad<66
replace tmbal=tmb*1.40 if sexo==1 & edad>65 & edad!=.
replace tmbal=tmb*1.40 if sexo==0 & edad>65 & edad!=.
label var tmbal "tmb con actividad ligera"

*tmbam= actividad moderada
gen     tmbam=tmb*1.75 if sexo==1 & edad>9 & edad<13
replace tmbam=tmb*1.64 if sexo==0 & edad>9 & edad<13
replace tmbam=tmb*1.68 if sexo==1 & edad>12 & edad<15
replace tmbam=tmb*1.59 if sexo==0 & edad>12 & edad<15
replace tmbam=tmb*1.80 if sexo==1 & edad>14 & edad<18
replace tmbam=tmb*1.65 if sexo==0 & edad>14 & edad<18
replace tmbam=tmb*1.80 if sexo==1 & edad>17 & edad<66
replace tmbam=tmb*1.65 if sexo==0 & edad>17 & edad<66
replace tmbam=tmb*1.60 if sexo==1 & edad>65 & edad!=.
replace tmbam=tmb*1.60 if sexo==0 & edad>65 & edad!=.
label var tmbam "tmb con actividad moderada"

*tmbai= actividad intensa
gen     tmbai=tmb*1.75 if sexo==1 & edad>9 & edad<13
replace tmbai=tmb*1.64 if sexo==0 & edad>9 & edad<13
replace tmbai=tmb*1.68 if sexo==1 & edad>12 & edad<15
replace tmbai=tmb*1.59 if sexo==0 & edad>12 & edad<15
replace tmbai=tmb*2.10 if sexo==1 & edad>14 & edad<18
replace tmbai=tmb*1.80 if sexo==0 & edad>14 & edad<18
replace tmbai=tmb*2.10 if sexo==1 & edad>17 & edad<66
replace tmbai=tmb*1.80 if sexo==0 & edad>17 & edad<66
replace tmbai=tmb*1.90 if sexo==1 & edad>65 & edad!=.
replace tmbai=tmb*1.80 if sexo==0 & edad>65 & edad!=.
label var tmbai "tmb con actividad intensa"

*requerimientos calóricos individuales con actividad moderada
gen       reqcalam=reqcal
replace   reqcalam=tmbam if edad>9 & edad!=.
label var reqcalam "r. calori. ind. act. moderada en las a. urb. y en las a. rur."
note  reqcalam: requerimientos caloricos individuales con actividad moderada en las areas urbanas y en las areas rurales

*requerimientos calóricos individuales con actividad moderada 
*en las areas urbanas e intensa en las areas rurales
gen       reqcalad=reqcalam
replace   reqcalad=tmbai if area==0 & edad>9 & edad!=.
label var reqcalad "r. calori. ind. act. moderada en las a. urb. e intensa en las a. rur."
note reqcalad: requerimientos caloricos individuales con actividad moderada en las areas urbanas e intensa en las areas rurales

*test de diferencias en los requerimientos caloricos con actividad moderada
*en area urbana y en area rural
svy: mean reqcalam, over(area)
lincom reqcalam#1.area-reqcalam#0.area

*por dominios respecto a Lima
svy: mean reqcalam, over(dominio2)
lincom reqcalam#7.dominio2 - reqcalam#1.dominio2
lincom reqcalam#7.dominio2 - reqcalam#2.dominio2
lincom reqcalam#7.dominio2 - reqcalam#3.dominio2
lincom reqcalam#7.dominio2 - reqcalam#4.dominio2
lincom reqcalam#7.dominio2 - reqcalam#5.dominio2
lincom reqcalam#7.dominio2 - reqcalam#6.dominio2

*por region natural respecto a la Costa
svy: mean reqcalam, over(region)
lincom reqcalam#1.region-reqcalam#2.region
lincom reqcalam#1.region-reqcalam#3.region

*entre sierra y selva
lincom reqcalam#2.region-reqcalam#3.region

collapse (sum) reqcalam reqcalad, by (identh)
save normacalorica2011, replace