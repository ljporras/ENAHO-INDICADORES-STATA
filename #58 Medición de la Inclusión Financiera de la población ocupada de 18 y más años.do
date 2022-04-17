*Establecer carpeta de trabajo
cd  "D:\ENAHO"

*Bajar y unir los archivos del modulo de empleo y sumaria
use enaho01a-2017-500.dta, clear
merge m:1 conglome vivienda hogar using "sumaria-2017.dta"

*Area urbana/rural
gen     area=1 if estrato<=5
replace area=2 if estrato>=6 & estrato<=8
lab def area 1 "urbano" 2 "rural"
lab val area area

*Region Natural
gen     regnat=1 if dominio<=3 | dominio==8
replace regnat=2 if dominio>=4 & dominio<=6
replace regnat=3 if dominio==7
lab var regnat   "Region natural"
lab def regnat 1 "Costa" 2 "Sierra" 3 "Selva"
lab val regnat regnat

*Departamento
destring ubigeo, generate(dpto)
replace dpto=dpto/10000
replace dpto=round(dpto)
label variable dpto "Departamento"
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

*Grupos de edad
gen     edad=1 if p208a>17 & p208a<25
replace edad=2 if p208a>24 & p208a<45
replace edad=3 if p208a>44
label   define edad 1 "18-24" 2 "25-44" 3 "45 y mas"
lab val edad edad

*Nivel educativo
gen     educa=1 if p301a<5 | p301a==12
replace educa=2 if p301a>4 & p301a<7
replace educa=3 if p301a>6 & p301a<9
replace educa=4 if p301a>8 & p301a<12
label define educa 1 "Hasta primaria 1/" 2 "Secundaria" /// 
3 "Superior no universitaria" 4 "Superior universitaria"
label value  educa educa

*Etiquetar la variable pobreza monetaria
*Usar variable "pobreza" de sumaria
gen pobre=pobreza<3
label define pobre 1 "pobre" 0 "no pobre"
label value  pobre pobre

*Crear variable inclusion
recode p558e6 (6=0 "no accede")(0=1 "accede"), gen(inclusion)

*Establecer a los residentes habituales
gen resi=1 if ((p204==1 & p205==2) | (p204==2 & p206==1))

*Perú: Inclusion financiera de la poblacion ocupada mayor a 18 ahnos
tab inclusion [iw= fac500a ]      if resi==1 & ocu500 == 1 

tab inclusion [iw= fac500a ]      if resi==1 & ocu500 == 1 & p208a>17

*Perú: Inclusion financiera de la poblacion ocupada mayor a 18 ahnos, por sexo
tab p207 inclusion [iw= fac500a ] if resi==1 & ocu500 == 1, nofreq row

*Perú: Inclusion financiera de la poblacion ocupada mayor a 18 ahnos, por edad
tab edad inclusion [iw= fac500a ] if resi==1 & ocu500 == 1, nofreq row

*Perú: Inclusion financiera de la poblacion ocupada mayor a 18 ahnos, por edu
tab educa inclusion [iw= fac500a ] if resi==1 & ocu500 == 1, nofreq row

*Perú: Inclusion financiera de la poblacion ocupada mayor a 18 ahnos, por pobreza
tab pobre inclusion [iw= fac500a ] if resi==1 & ocu500 == 1, nofreq row

*Perú: Inclusion financiera de la poblacion ocupada mayor a 18 ahnos, por area
tab area inclusion [iw= fac500a ] if resi==1 & ocu500 == 1, nofreq row

*Perú: Inclusion financiera de la poblacion ocupada mayor a 18 ahnos, por region
tab regnat inclusion [iw= fac500a ] if resi==1 & ocu500 == 1, nofreq row

*Perú: Inclusion financiera de la poblacion ocupada mayor a 18 ahnos, por dpto
tab dpto inclusion [iw= fac500a ] if resi==1 & ocu500 == 1, nofreq row








