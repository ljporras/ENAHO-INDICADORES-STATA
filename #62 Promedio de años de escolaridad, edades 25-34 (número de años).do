cd "E:\ESCOLARIDAD"

use enaho01a-2019-400.dta, clear
merge 1:1 conglome vivienda hogar codperso using  enaho01a-2019-300.dta
keep if _merge==3
drop _m
merge m:1  conglome vivienda hogar using  sumaria-2019.dta, nogenerate

*Lengua materna
gen      lengua=1 if p300a==4
replace  lengua=2 if p300a<4
replace  lengua=3 if p300a>5
lab def  lengua 1 "Castellano" 2 "Indígena" 3 "Otros", modify
lab val  lengua lengua

*Crear variable geografica area
gen            area=estrato
recode         area (1/5=1) (6/8=2)
lab def        area 1 "Urbana" 2 "Rural", modify
lab val        area area
lab var        area "Area de residencia"

*Tomando de la sintaxis de la tesis
*POBREZA Y LOGRO EDUCATIVO EN LA REGIÓN PIURA 2015
*Presentada por: Br. Econ. Charlye Casariego Acenjo
*https://repositorio.unp.edu.pe/bitstream/handle/UNP/1498/ECO-CAS-ASE-2018.pdf?sequence=1&isAllowed=y
generate byte X5=p301b
replace X5=0 if p301a==1 | p301a==2
recode  X5 (1=1) (2=2) (3=3) (4=4)               if p301a==3
recode  X5 (5=5) (6=6)                           if p301a==4
recode  X5 (1=7) (2=8) (3=9) (4=10)              if p301a==5
recode  X5 (5=11)(6=12)                          if p301a==6
recode  X5 (1=12)(2=13)(3=14)(4=15)              if p301a==7
recode  X5 (3=14)(4=15)(5=16)                    if p301a==8
recode  X5 (1=12)(2=13)(3=14)(4=15)(5=16) (6=17) if p301a==9
recode  X5 (4=15)(5=16)(6=17)(7=18)              if p301a==10
recode  X5 (1=17)(2=18)                          if p301a==11
g      _p301c=p301c
recode _p301c (0=1)
replace X5=_p301c if p301b==0 & p301a!=2
label value X5 X5
label variable X5 "Años de estudio del individuo" 

*Estimar edad en años cumplidos al 31 de Marzo
rename   a*o year
destring year, replace
gen      edad_31Marzo=year-p400a3     
replace  edad_31Marzo=(year-p400a3-1) if p400a2>3
replace  edad_31Marzo=0 if edad_31Marzo<0

gen   escolt2534=X5  if (edad_31Marzo >= 25 & edad_31Marzo <= 34)  

sum   escolt2534 [iweight=factora07] 
sum   escolt2534 [iweight=factora07] if p207==2
sum   escolt2534 [iweight=factora07] if p207==1
sum   escolt2534 [iweight=factora07] if area==1 
sum   escolt2534 [iweight=factora07] if area==1 & p207==2
sum   escolt2534 [iweight=factora07] if area==1 & p207==1
sum   escolt2534 [iweight=factora07] if area==2
sum   escolt2534 [iweight=factora07] if area==2 & p207==2
sum   escolt2534 [iweight=factora07] if area==2 & p207==1

tab lengua
sum   escolt2534 [iweight=factora07] if lengua==1
sum   escolt2534 [iweight=factora07] if lengua==2

tab pobreza
sum   escolt2534 [iweight=factora07] if pobreza==3
sum   escolt2534 [iweight=factora07] if pobreza==2
sum   escolt2534 [iweight=factora07] if pobreza==1
