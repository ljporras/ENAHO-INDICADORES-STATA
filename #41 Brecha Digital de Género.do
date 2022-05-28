cd "D:\ENAHO"
use enaho01a-2018-300.dta, clear
merge m:1 conglome vivienda hogar  using sumaria-2018.dta

*AREA DE RESIDENCIA
gen     area=1 if estrato<=5
replace area=2 if estrato>=6 & estrato<=8
lab def area 1 "urbano" 2 "rural"
lab val area area

*GRUPO DE EDAD
gen     gedad=1 if p208a>5  & p208a<12
replace gedad=2 if p208a>11 & p208a<19
replace gedad=3 if p208a>18 & p208a<25
replace gedad=4 if p208a>24 & p208a<41
replace gedad=5 if p208a>40 & p208a<60
replace gedad=6 if p208a>59
replace gedad=. if p208a==.
replace gedad=. if p314a==.

label define gedad 1 "6 a 11" 2 "12 a 18" 3 "19 a 24" /// 
4 "25 a 40" 5 "41 a 59" 6 "60 a mas", replace
label values gedad gedad

gen mujer=p207==2

gen     gedu=1 if p301a<5
replace gedu=2 if p301a>4 & p301a<7
replace gedu=3 if p301a>6 & p301a<9
replace gedu=4 if p301a==9 | p301a==10 | p301a==11  
label define gedad 1 "Primaria" 2 "Secundaria"  /// 
3 "Sup. No universitaria" 4 "Sup. universitaria", replace 
label values gedu gedu

*Nacional
tab p314a mujer [iw=factora07] , nofreq col

*Pobreza
tab p314a mujer [iw=factora07] if pobreza<3, nofreq col

tab p314a mujer [iw=factora07] if pobreza==3, nofreq col

*Area de residencia
tab p314a mujer [iw=factora07] if area==1, nofreq col

tab p314a mujer [iw=factora07] if area==2, nofreq col

*Grupo de Edad
tab p314a mujer [iw=factora07] if gedad==1, nofreq col

tab p314a mujer [iw=factora07] if gedad==2, nofreq col

tab p314a mujer [iw=factora07] if gedad==3, nofreq col

tab p314a mujer [iw=factora07] if gedad==4, nofreq col

tab p314a mujer [iw=factora07] if gedad==5, nofreq col

tab p314a mujer [iw=factora07] if gedad==6, nofreq col

*Educacion
tab p314a mujer [iw=factora07] if gedu==1, nofreq col

tab p314a mujer [iw=factora07] if gedu==2, nofreq col

tab p314a mujer [iw=factora07] if gedu==3, nofreq col

tab p314a mujer [iw=factora07] if gedu==4, nofreq col
