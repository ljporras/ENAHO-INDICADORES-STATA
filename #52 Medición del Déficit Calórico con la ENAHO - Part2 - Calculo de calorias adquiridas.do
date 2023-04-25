
cd "D:\DCALORICO"

****CALCULO DE LAS CALORIAS ADQUIRIDAS POR EL HOGAR

*trabajo con archivo sumaria 
use sumaria-2011.dta, clear
compress
rename a*o anio
gen str13 identh=anio+conglome+vivienda+hogar
gen   gpcm      =gashog2d/(mieperho*12)
gen   facpob    =factor*mieperho
order identh
sort  identh
save  tempo_sumaria-2011.dta, replace

keep identh mieperho gpcm facpob
sort identh
save tempo2011, replace


*Cálculo de calorias adquiridas por rubro de gasto 

*Usando archivo 601
use enaho01-2011-601.dta, clear
keep if p601b==1
keep if substr(p601a,1,2)!="49"
drop if substr(p601a,3,2)=="00"

rename a*o anio
gen str13 identh=anio+conglome+vivienda+hogar
order identh
sort  identh
merge identh using tempo2011
tab _m
drop if _m==2
drop _m
sort produc61

*USANDO TABLA DE COMPOSICION DE ALIMENTOS en archivo 601
merge m:1 produc61 using "tabla de composicion de alimentos.dta"
tab _m
drop if _m==2
drop _m

gen     regnat=1 if (dominio>=1 & dominio<=3)
replace regnat=2 if (dominio>=4 & dominio<=6)
replace regnat=3 if (dominio==7)
replace regnat=1 if (dominio==8)
label define regnat 1 "costa"  2 "sierra"  3 "selva"
label val regnat regnat

gen     dominio2=1 if ((dominio==1 | dominio==2 | dominio==3) & (estrato >=1 & estrato<=5))
replace dominio2=2 if ((dominio==1 | dominio==2 | dominio==3) & (estrato >=6 & estrato<=8))
replace dominio2=3 if ((dominio==4 | dominio==5 | dominio==6) & (estrato >=1 & estrato<=5))
replace dominio2=4 if ((dominio==4 | dominio==5 | dominio==6) & (estrato >=6 & estrato<=8))
replace dominio2=5 if ((dominio==7 ) & (estrato >=1 & estrato<=5))
replace dominio2=6 if ((dominio==7 ) & (estrato >=6 & estrato<=8))
replace dominio2=7 if (dominio==8 )
label define dominio2 1 "costa urbana" 2 "costa rural" 3 "sierra urbana" 4 "sierra rural" 5 "selva urbana" 6 "selva rural" 7 "lima metropolitana"
label val dominio2 dominio2

gen p601n=real(substr(p601a,1,2))
*para productos que no se encontraron en tabla se usan promedios de calorías por rubro
replace energ= 313.6 if ((regnat == 1) & (p601n ==  1) & energ==.)
replace energ= 361.0 if ((regnat == 1) & (p601n ==  2) & energ==.) 
replace energ= 359.0 if ((regnat == 1) & (p601n ==  3) & energ==.) 
replace energ= 101.7 if ((regnat == 1) & (p601n ==  4) & energ==.)
replace energ=  98.4 if ((regnat == 1) & (p601n ==  5) & energ==.)
replace energ= 384.0 if ((regnat == 1) & (p601n ==  6) & energ==.)
replace energ= 141.0 if ((regnat == 1) & (p601n ==  7) & energ==.)
replace energ= 147.0 if ((regnat == 1) & (p601n ==  8) & energ==.)
replace energ= 164.6 if ((regnat == 1) & (p601n ==  9) & energ==.)
replace energ= 157.0 if ((regnat == 1) & (p601n == 10) & energ==.)
replace energ= 366.0 if ((regnat == 1) & (p601n == 11) & energ==.)
replace energ= 127.0 if ((regnat == 1) & (p601n == 12) & energ==.)
replace energ= 104.0 if ((regnat == 1) & (p601n == 13) & energ==.)
replace energ= 121.0 if ((regnat == 1) & (p601n == 14) & energ==.)
replace energ= 363.0 if ((regnat == 1) & (p601n == 15) & energ==.)
replace energ= 347.6 if ((regnat == 1) & (p601n == 16) & energ==.)
replace energ= 374.0 if ((regnat == 1) & (p601n == 17) & energ==.)
replace energ= 350.4 if ((regnat == 1) & (p601n == 18) & energ==.)
replace energ= 355.0 if ((regnat == 1) & (p601n == 19) & energ==.)
replace energ= 116.3 if ((regnat == 1) & (p601n == 20) & energ==.)
replace energ= 235.3 if ((regnat == 1) & (p601n == 21) & energ==.)
replace energ= 80.0 if ((regnat == 1) & (p601n == 22) & energ==.)
replace energ= 889.0 if ((regnat == 1) & (p601n == 23) & energ==.)
replace energ= 230.0 if ((regnat == 1) & (p601n == 24) & energ==.)
replace energ= 720.0 if ((regnat == 1) & (p601n == 25) & energ==.)
replace energ= 729.0 if ((regnat == 1) & (p601n == 26) & energ==.) 
replace energ= 67.0 if ((regnat == 1) & (p601n == 27) & energ==.) 
replace energ= 0.0 if ((regnat == 1) & (p601n == 28) & energ==.)
replace energ= 40.0 if ((regnat == 1) & (p601n == 29) & energ==.)
replace energ= 81.0 if ((regnat == 1) & (p601n == 30) & energ==.)
replace energ= 339.0 if ((regnat == 1) & (p601n == 31) & energ==.)
replace energ= 49.0 if ((regnat == 1) & (p601n == 32) & energ==.)
replace energ= 19.0 if ((regnat == 1) & (p601n == 33) & energ==.)
replace energ= 33.4 if ((regnat == 1) & (p601n == 34) & energ==.)
replace energ= 129.0 if ((regnat == 1) & (p601n == 35) & energ==.)
replace energ= 128.5 if ((regnat == 1) & (p601n == 36) & energ==.)
replace energ= 33.0 if ((regnat == 1) & (p601n == 37) & energ==.)
replace energ= 30.0 if ((regnat == 1) & (p601n == 38) & energ==.)
replace energ= 34.2 if ((regnat == 1) & (p601n == 39) & energ==.)
replace energ= 86.2 if ((regnat == 1) & (p601n == 40) & energ==.)
replace energ= 52.0 if ((regnat == 1) & (p601n == 41) & energ==.)
replace energ= 346.2 if ((regnat == 1) & (p601n == 42) & energ==.)
replace energ= 355.0 if ((regnat == 1) & (p601n == 43) & energ==.)
replace energ= 36.0 if ((regnat == 1) & (p601n == 44) & energ==.)
replace energ= 40.0 if ((regnat == 1) & (p601n == 45) & energ==.)
replace energ= 22.0 if ((regnat == 1) & (p601n == 46) & energ==.)
replace energ= 149.6 if ((regnat == 1) & (p601n == 47) & energ==.)
replace energ= 188.4 if ((regnat == 1) & (p601n == 48) & energ==.)
replace energ= 188.4 if ((regnat == 1) & (p601n == 50) & energ==.)
replace energ= 305.0 if ((regnat == 2) & (p601n ==  1) & energ==.)
replace energ= 361.0 if ((regnat == 2) & (p601n ==  2) & energ==.)
replace energ= 359.0 if ((regnat == 2) & (p601n ==  3) & energ==.)
replace energ= 139.1 if ((regnat == 2) & (p601n ==  4) & energ==.)
replace energ= 97.5 if ((regnat == 2) & (p601n ==  5) & energ==.)
replace energ= 384.0 if ((regnat == 2) & (p601n ==  6) & energ==.)
replace energ= 141.0 if ((regnat == 2) & (p601n ==  7) & energ==.)
replace energ= 164.4 if ((regnat == 2) & (p601n ==  8) & energ==.)
replace energ= 161.3 if ((regnat == 2) & (p601n ==  9) & energ==.)
replace energ= 157.0 if ((regnat == 2) & (p601n == 10) & energ==.)
replace energ= 366.0 if ((regnat == 2) & (p601n == 11) & energ==.)
replace energ= 127.0 if ((regnat == 2) & (p601n == 12) & energ==.)
replace energ= 104.0 if ((regnat == 2) & (p601n == 13) & energ==.)
replace energ= 121.0 if ((regnat == 2) & (p601n == 14) & energ==.)
replace energ= 363.0 if ((regnat == 2) & (p601n == 15) & energ==.)
replace energ= 348.9 if ((regnat == 2) & (p601n == 16) & energ==.)
replace energ= 374.0 if ((regnat == 2) & (p601n == 17) & energ==.)
replace energ= 343.9 if ((regnat == 2) & (p601n == 18) & energ==.)
replace energ= 346.3 if ((regnat == 2) & (p601n == 19) & energ==.)
replace energ= 114.0 if ((regnat == 2) & (p601n == 20) & energ==.)
replace energ= 288.0 if ((regnat == 2) & (p601n == 21) & energ==.)
replace energ= 80.0 if ((regnat == 2) & (p601n == 22) & energ==.)
replace energ= 889.0 if ((regnat == 2) & (p601n == 23) & energ==.)
replace energ= 230.0 if ((regnat == 2) & (p601n == 24) & energ==.)
replace energ= 720.0 if ((regnat == 2) & (p601n == 25) & energ==.)
replace energ= 729.0 if ((regnat == 2) & (p601n == 26) & energ==.)
replace energ= 67.0 if ((regnat == 2) & (p601n == 27) & energ==.)
replace energ= 0.0 if ((regnat == 2) & (p601n == 28) & energ==.)
replace energ= 40.0 if ((regnat == 2) & (p601n == 29) & energ==.)
replace energ= 212.0 if ((regnat == 2) & (p601n == 30) & energ==.)
replace energ= 339.0 if ((regnat == 2) & (p601n == 31) & energ==.)
replace energ= 49.0 if ((regnat == 2) & (p601n == 32) & energ==.)
replace energ= 19.0 if ((regnat == 2) & (p601n == 33) & energ==.)
replace energ= 33.5 if ((regnat == 2) & (p601n == 34) & energ==.)
replace energ= 129.0 if ((regnat == 2) & (p601n == 35) & energ==.)
replace energ= 130.3 if ((regnat == 2) & (p601n == 36) & energ==.)
replace energ= 36.0 if ((regnat == 2) & (p601n == 37) & energ==.)
replace energ= 30.0 if ((regnat == 2) & (p601n == 38) & energ==.)
replace energ= 33.7 if ((regnat == 2) & (p601n == 39) & energ==.)
replace energ= 86.9 if ((regnat == 2) & (p601n == 40) & energ==.)
replace energ= 56.1 if ((regnat == 2) & (p601n == 41) & energ==.)
replace energ= 390.3 if ((regnat == 2) & (p601n == 42) & energ==.)
replace energ= 353.7 if ((regnat == 2) & (p601n == 43) & energ==.)
replace energ= 36.0 if ((regnat == 2) & (p601n == 44) & energ==.)
replace energ= 40.0 if ((regnat == 2) & (p601n == 45) & energ==.)
replace energ= 22.0 if ((regnat == 2) & (p601n == 46) & energ==.)
replace energ= 149.6 if ((regnat == 2) & (p601n == 47) & energ==.)
replace energ= 196.9 if ((regnat == 2) & (p601n == 48) & energ==.)
replace energ= 196.9 if ((regnat == 2) & (p601n == 50) & energ==.)
replace energ= 329.8 if ((regnat == 3) & (p601n ==  1) & energ==.)
replace energ= 361.0 if ((regnat == 3) & (p601n ==  2) & energ==.)
replace energ= 359.0 if ((regnat == 3) & (p601n ==  3) & energ==.)
replace energ= 165.9 if ((regnat == 3) & (p601n ==  4) & energ==.)
replace energ= 97.4 if ((regnat == 3) & (p601n ==  5) & energ==.)
replace energ= 384.0 if ((regnat == 3) & (p601n ==  6) & energ==.)
replace energ= 141.0 if ((regnat == 3) & (p601n ==  7) & energ==.)
replace energ= 130.5 if ((regnat == 3) & (p601n ==  8) & energ==.)
replace energ= 168.5 if ((regnat == 3) & (p601n ==  9) & energ==.)
replace energ= 157.0 if ((regnat == 3) & (p601n == 10) & energ==.)
replace energ= 366.0 if ((regnat == 3) & (p601n == 11) & energ==.)
replace energ= 127.0 if ((regnat == 3) & (p601n == 12) & energ==.)
replace energ= 104.0 if ((regnat == 3) & (p601n == 13) & energ==.)
replace energ= 121.0 if ((regnat == 3) & (p601n == 14) & energ==.)
replace energ= 363.0 if ((regnat == 3) & (p601n == 15) & energ==.)
replace energ= 349.3 if ((regnat == 3) & (p601n == 16) & energ==.)
replace energ= 374.0 if ((regnat == 3) & (p601n == 17) & energ==.)
replace energ= 345.0 if ((regnat == 3) & (p601n == 18) & energ==.)
replace energ= 339.9 if ((regnat == 3) & (p601n == 19) & energ==.)
replace energ= 147.4 if ((regnat == 3) & (p601n == 20) & energ==.)
replace energ= 235.3 if ((regnat == 3) & (p601n == 21) & energ==.)
replace energ= 80.0 if ((regnat == 3) & (p601n == 22) & energ==.)
replace energ= 889.0 if ((regnat == 3) & (p601n == 23) & energ==.)
replace energ= 230.0 if ((regnat == 3) & (p601n == 24) & energ==.)
replace energ= 720.0 if ((regnat == 3) & (p601n == 25) & energ==.)
replace energ= 729.0 if ((regnat == 3) & (p601n == 26) & energ==.)
replace energ= 67.0 if ((regnat == 3) & (p601n == 27) & energ==.)
replace energ= 0.0 if ((regnat == 3) & (p601n == 28) & energ==.)
replace energ= 40.0 if ((regnat == 3) & (p601n == 29) & energ==.)
replace energ= 62.0 if ((regnat == 3) & (p601n == 30) & energ==.)
replace energ= 339.0 if ((regnat == 3) & (p601n == 31) & energ==.)
replace energ= 49.0 if ((regnat == 3) & (p601n == 32) & energ==.)
replace energ= 19.0 if ((regnat == 3) & (p601n == 33) & energ==.)
replace energ= 32.2 if ((regnat == 3) & (p601n == 34) & energ==.)
replace energ= 129.0 if ((regnat == 3) & (p601n == 35) & energ==.)
replace energ= 152.7 if ((regnat == 3) & (p601n == 36) & energ==.)
replace energ= 34.0 if ((regnat == 3) & (p601n == 37) & energ==.)
replace energ= 30.0 if ((regnat == 3) & (p601n == 38) & energ==.)
replace energ= 33.3 if ((regnat == 3) & (p601n == 39) & energ==.)
replace energ= 86.4 if ((regnat == 3) & (p601n == 40) & energ==.)
replace energ= 73.3 if ((regnat == 3) & (p601n == 41) & energ==.)
replace energ= 328.2 if ((regnat == 3) & (p601n == 42) & energ==.)
replace energ= 432.6 if ((regnat == 3) & (p601n == 43) & energ==.)
replace energ= 36.0 if ((regnat == 3) & (p601n == 44) & energ==.)
replace energ= 40.0 if ((regnat == 3) & (p601n == 45) & energ==.)
replace energ= 22.0 if ((regnat == 3) & (p601n == 46) & energ==.)
replace energ= 149.6 if ((regnat == 3) & (p601n == 47) & energ==.)
replace energ= 209.2 if ((regnat == 3) & (p601n == 48) & energ==.)
replace energ= 209.2 if ((regnat == 3) & (p601n == 50) & energ==.)

recode i601b2 i601d2 (.=0)
gen    cant601 = ((i601b2+ i601d2)*1000)/(mieperho*30*12)
gen    calor601 = (cant601*energ)/100
recode i601c i601e (.=0)
gen    gast601 = (i601c+ i601e)/(mieperho*30*12)

collapse (sum) cant601 calor601 gast601, by (identh)
save tempo601_2011, replace

use tempo_sumaria-2011.dta, clear
merge 1:1 identh using tempo601_2011
tab _m
drop _m
recode  cant601 calor601 gast601 (.=0)
save, replace


**en capítulo 602 A PARTIR DE LA ENAHO 2007
use enaho01-2011-602.dta, clear
rename a*o anio
gen str13 identh=anio+conglome+vivienda+hogar
order identh
sort  identh
merge identh using tempo2011
tab _m
drop if _m==2
drop _m
keep if p602==1

*Asignacion de calorias a cada item de consumo de alimentos dentro del hogar
*obtenido de instituciones beneficas con archivo 6 
gen     ragrpcd=((p602a * p602b/(7*mieperho)) * 27.5) if p602n==1
replace ragrpcd=((p602a * p602b/(7*mieperho)) * 160)  if p602n==2
replace ragrpcd=((p602a * p602b/(7*mieperho)) * 600)  if p602n==3
replace ragrpcd=((p602a * p602b/(7*mieperho)) * 600)  if p602n==4
replace ragrpcd=((p602a * p602b/(7*mieperho)) * 160)  if p602n==5
replace ragrpcd=((p602a * p602b/(7*mieperho)) * 600)  if p602n==6
replace ragrpcd=((p602a * p602b/(7*mieperho)) * 600)  if p602n==7
recode  ragrpcd  (.=0)

gen     caloria=(ragrpcd * 484.0)/100 if p602n==1
replace caloria=(ragrpcd * 223.6)/100 if p602n==2
replace caloria=(ragrpcd * 196.3)/100 if p602n==3
replace caloria=(ragrpcd * 196.3)/100 if p602n==4
replace caloria=(ragrpcd * 223.6)/100 if p602n==5
replace caloria=(ragrpcd * 196.3)/100 if p602n==6
replace caloria=(ragrpcd * 196.3)/100 if p602n==7
recode  caloria i602e1 (.=0)

gen     gast602=i602e1/(mieperho*30*12)

gen     prexrac=i602e1/(51.96*p602a*p602b) if p602==1 & (p602da==1 | p602db==2)
gen     precxkg=prexrac*1000/27.5 if p602n==1
replace precxkg=prexrac*1000/160 if p602n==2 | p602==5 
replace precxkg=prexrac*1000/600 if p602n==3 | p602n==4 | p602n==6 | p602n==7

*agregar (sumar sin ponderar) la variable caloria a nivel de hogar
*obtención de precios por kilogramo de lo consumido de instituciones beneficas.

rename (ragrpcd caloria) (cant602 calor602)
collapse (sum) cant602 calor602 gast602, by (identh)
save tempo602_2011, replace

use tempo_sumaria-2011.dta, clear
sort  identh
merge 1:1 identh using tempo602_2011
tab _m
drop _m
recode  cant602- gast602 (.=0)
save, replace


*En capítulo 602A A PARTIR DE LA ENAHO 2007
use enaho01-2011-602a.dta, clear
rename a*o anio
gen str13 identh=anio+conglome+vivienda+hogar
order identh
sort  identh
merge identh using tempo2011
tab _m
drop if _m==2
drop _m
keep if p6021==1

*Asignacion de calorias a cada item de consumo de alimentos dentro del hogar 
*obtenido de instituciones beneficas con archivo 6 
gen     ragrpcd=((p602a1 * p602b1/(7*mieperho)) * 160) if p602n1==1
replace ragrpcd=((p602a1 * p602b1/(7*mieperho)) * 600) if p602n1==2
replace ragrpcd=((p602a1 * p602b1/(7*mieperho)) * 600) if p602n1==3
replace ragrpcd=((p602a1 * p602b1/(7*mieperho)) * 600) if p602n1==4
replace ragrpcd=((p602a1 * p602b1/(7*mieperho)) * 600) if p602n1==5
recode  ragrpcd  (.=0)

gen     caloria=(ragrpcd * 223.6)/100 if p602n1==1
replace caloria=(ragrpcd * 196.3)/100 if p602n1==2
replace caloria=(ragrpcd * 196.3)/100 if p602n1==3
replace caloria=(ragrpcd * 196.3)/100 if p602n1==4
replace caloria=(ragrpcd * 196.3)/100 if p602n1==5
recode  caloria i602e3 (.=0)

gen     gast602A1=i602e3/(mieperho*30*12)

gen     prexrac=i602e3/(51.96*p602a1*p602b1) if p6021==1 & (p602d1a==1 | p602d1b==2)
gen     precxkg=prexrac*1000/27.5 if p602n1==1
replace precxkg=prexrac*1000/600 if p602n1==2 | p602n1==3 | p602n1==4 | p602n1==5

*agregar (sumar sin ponderar) la variable caloria1 a nivel de hogar
*obtención de precios por kilogramo de lo consumido de instituciones beneficas.
rename (ragrpcd caloria) (cant602A1 calor602A1)
collapse (sum) cant602A1 calor602A1 gast602A1, by (identh)
save tempo602a_2011, replace

use  tempo_sumaria-2011.dta, clear
sort  identh
merge 1:1 identh using tempo602a_2011
tab _m
drop _m
recode  cant602A1- gast602A1 (.=0)
save, replace


*Asignacion de calorias a cada item de consumo de alimentos fuera del hogar con archivo 3
*A PARTIR DEL 2007
use enaho01a-2011-500.dta, clear
rename a*o anio
gen str13 identh=anio+conglome+vivienda+hogar
gen str15 identi=anio+conglome+vivienda+hogar+codperso
order identh identi

gen desadg = (p559a_01 /7) * 160 if p559_01==1
gen almudg = (p559a_02 /7) * 600 if p559_02==1
gen cenadg = (p559a_03 /7) * 600 if p559_03==1
gen otrodg1= (p559a_04 /7) * 222 if p559_04==1
gen otrodg2= (p559a_05 /7) * 222 if p559_05==1
gen otrodg3= (p559a_06 /7) * 222 if p559_06==1
gen otrodg4= (p559a_07 /7) * 222 if p559_07==1
gen otrodg5= (p559a_08 /7) * 222 if p559_08==1
gen otrodg6= (p559a_09 /7) * 222 if p559_09==1
gen otrodg7= (p559a_10 /7) * 222 if p559_10==1

recode desadg almudg cenadg otrodg1 otrodg2 otrodg3 otrodg4 otrodg5 otrodg6 otrodg7 (.=0)
gen caldesa = desadg * 223.6/100
gen calalmu = almudg * 196.3/100
gen calcena = cenadg * 196.3/100
gen calotro1 = otrodg1 * 113.0/100
gen calotro2 = otrodg2 * 113.0/100
gen calotro3 = otrodg3 * 113.0/100
gen calotro4 = otrodg4 * 113.0/100
gen calotro5 = otrodg5 * 113.0/100
gen calotro6 = otrodg6 * 113.0/100
gen calotro7 = otrodg7 * 113.0/100

gen calor559 = caldesa + calalmu + calcena + calotro1+ calotro2 + calotro3 + calotro4 + calotro5 + calotro6 + calotro7
gen cant559  = desadg+ almudg+ cenadg+ otrodg1+ otrodg2+ otrodg3+ otrodg4+ otrodg5+ otrodg6+ otrodg7
recode i559d1 i559d2 i559d3 i559d41 i559d42 i559d43 i559d44 i559d45 i559d46 i559d47 (.=0)
gen gast559  = (i559d1+ i559d2+ i559d3+ i559d41+ i559d42+ i559d43+ i559d44+ i559d45 +i559d46 +i559d47)/100

*solo considerar miembren=1 y parentem dif 7 y 8
*agregar (sumar sin ponderar) caloria2 a nivel de hogar y luego ponerlo a percapita (con mieperho).
*obtención de precios por kilogramo de lo consumido fuera del hogar (utilizando inf imp).

gen pxkg_des = i559d1*1000/(51.96*p559a_01*160)  if p559_01 == 1 & p559c_01 == 1
gen pxkg_alm = i559d2*1000/(51.96*p559a_02*600)  if p559_02 == 1 & p559c_02 == 1
gen pxkg_cen = i559d3*1000/(51.96*p559a_03*600)  if p559_03 == 1 & p559c_03 == 1
gen pxkg_ot1 = i559d41*1000/(51.96*p559a_04*222) if p559_04 == 1 & p559c_04 == 1
gen pxkg_ot2 = i559d42*1000/(51.96*p559a_05*222) if p559_05 == 1 & p559c_05 == 1
gen pxkg_ot3 = i559d43*1000/(51.96*p559a_06*222) if p559_06 == 1 & p559c_06 == 1
gen pxkg_ot4 = i559d44*1000/(51.96*p559a_07*222) if p559_07 == 1 & p559c_07 == 1
gen pxkg_ot5 = i559d45*1000/(51.96*p559a_08*222) if p559_08 == 1 & p559c_08 == 1
gen pxkg_ot6 = i559d46*1000/(51.96*p559a_09*222) if p559_09 == 1 & p559c_09 == 1
gen pxkg_ot7 = i559d47*1000/(51.96*p559a_10*222) if p559_10 == 1 & p559c_10 == 1

egen p559a_40 = rmean(p559a_04 - p559a_10)
egen i559d40= rsum (i559d41- i559d47)
gen  pxkg_otr = i559d40*1000/(51.96*p559a_40*222) if ((p559_05 == 1) & (p559c_05 == 1)) 

keep if p204==1 & (p203!=8 | p203!=9)
collapse (sum) cant559 calor559 gast559, by (identh)
save tempo500_2011, replace

use   tempo_sumaria-2011.dta, clear
sort  identh
merge 1:1 identh using tempo500_2011
tab _m
drop _m
recode  cant559- gast559 (.=0)
save, replace

********************************************************************************
use   tempo_sumaria-2011.dta, clear
sort  identh
merge identh using normacalorica2011
drop _m

*EN ARCHIVO A NIVEL DE HOGARES
replace calor559 = calor559 /mieperho
replace cant559  = cant559  /mieperho
replace gast559  = gast559  /mieperho

replace reqcalad=reqcalad/mieperho
replace reqcalam=reqcalam/mieperho

*A partir del 2007
recode calor601 calor602 calor559 calor602A1 cant601 cant602 cant559 cant602A1 /// 
	   gast601  gast602  gast559   gast602A1 (.=0)
	   
gen caloria   = calor601   + calor602  + calor602A1 + calor559

*Calculo de la incidencia de pobreza
gen   pobreC=             caloria< reqcalam if caloria!=.
note  pobreC: gen pobreC= caloria< reqcalam if caloria!=.

*Variables geograficas
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

tab region pobreC [iw=facpob], nofreq row
***END
