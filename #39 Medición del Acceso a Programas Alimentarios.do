*ACCESO A PROGRAMA ALIMENTARIO
*Establecer carpeta de trabajo
cd  "D:\ENAHO"

*Bajar y unir los archivos del modulo 02, 34 & 37
********************************************************************************

use enaho01-2019-700.dta, clear
gen            area=estrato
recode         area (1/5=1) (6/8=2)
label define   area 1 "Urbana" 2 "Rural"

label values   area area

*Hogares con al menos un miembro beneficiario con algún programa alimentario, 
*por área de residencia
tab p701_09 area [iw=factor07], nofreq col


********************************************************************************

use enaho01-2019-700a.dta, clear
rename p702 codperso

egen c_p703=count(p703), by(conglome vivienda hogar codperso)

collapse (max) c_p703  , by(conglome vivienda hogar codperso)
 
merge 1:1 conglome vivienda hogar codperso using enaho01-2019-200.dta, nogenerate

*Establecer a los residentes habituales
gen resi=1 if ((p204==1 & p205==2) | (p204==2 & p206==1))

*Grupo de edad
gen     gedad=1 if p208a<18
replace gedad=2 if p208a>17 & p208a<30
replace gedad=3 if p208a>29 & p208a<60
replace gedad=4 if p208a>59
replace gedad=. if p208a==.

label define   gedad 1 "De 0 a 17 años de edad" 2 "De 18 a 29 añosde edad" /// 
3 "De 30 a 59 años de edad" 4 "De 60 y más años de edad"
label values   gedad gedad

gen       b_pa=c_p703~=.
label var b_pa "Beneficiarios Pro. Alimentario"

*Población beneficiaria con algún programa alimentario, por grupos de edad
tab       b_pa gedad [iw=facpob07] if resi==1, nofreq col


********************************************************************************
use enaho01-2019-700a.dta, clear
rename p702 codperso

egen c_p703=count(p703), by(conglome vivienda hogar codperso)

gen vd_l=p703==1
gen co_p=p703==2
gen de_e=p703==3
gen al_e=p703==4
gen wa_w=p703==5
gen ot_p=p703>5

collapse (max) c_p703 (sum) vd_l co_p de_e al_e wa_w ot_p  /// 
 , by(conglome vivienda hogar codperso)
 
merge 1:1 conglome vivienda hogar codperso using enaho01-2019-200.dta, nogenerate

*Distribución de la población beneficiaria de programas alimentarios 
*por tipo de programa que recibió
gen      prog=5 if c_p703~=. 
replace  prog=1 if vd_l==1 & c_p703==1
replace  prog=2 if vd_l==1 & c_p703>1
replace  prog=3 if de_e==1 & c_p703==1
replace  prog=4 if al_e==1 & c_p703==1
label define prog 1 "Solo Vaso de Leche" 2 "Vaso de Leche y Otros" /// 
3 "Solo Desayuno Escolar" 4 "Solo Almuerzo Escolar" 5 "Otros"
label value prog prog

tab   prog [iw=facpob07] 

