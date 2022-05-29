cd  "D:\ENAHO"
use enaho01a-2018-500.dta, clear

*Area urbana/rural
gen     area=1 if estrato<=5
replace area=2 if estrato>=6 & estrato<=8
lab def area 1 "urbano" 2 "rural"
lab val area area

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

*Etnia
gen     etnia=1 if p558c<4 | p558c==9
replace etnia=2 if p558c==4
replace etnia=3 if p558c==6
replace etnia=4 if p558c==5 | p558c==7 
replace etnia=5 if p558c==8
lab def etnia 1 "Indigena 1/" 2 "Negro, mulato, Afro peruano" 3 "Mestizo/a" 4 "Otro 2/" 5 "No sabe"
lab val etnia etnia
*1/ Incluye: Quechua, Aimara y Nativo o Indígena de la Amazonía.
*2/ Incluye: Blanco y otro

*Grupos de edad
gen     edad=1 if p208a>13 & p208a<25
replace edad=2 if p208a>24 & p208a<45
replace edad=3 if p208a>44 & p208a<60
replace edad=4 if p208a>59 & p208a<65
replace edad=5 if p208a>64
label define edad 1 "14-24" 2 "25-44" 3 "45-59" 4 "60-64" 5 "65 y mas"
lab val edad edad

*Estado civil
gen       ecivil=1 if p209==1
replace ecivil=2 if p209==2
replace ecivil=3 if p209==3 | p209==4 | p209==5
replace ecivil=4 if p209==6
lab def ecivil 1 "Conviviente" 2 "Casado/a" 3 "Alguna vez unido/a 1/" 4 " Soltero/a"  
lab val ecivil ecivil
*1/ Incluye: Separado/a, divorciado/a y viudo/a.

*Establecer a los residentes habituales
gen resi=1 if ((p204==1 & p205==2) | (p204==2 & p206==1))

*Población ocupada por tamahno de empresa
gen       tamahno=1 if p512b>=1  & p512b<11
replace tamahno=2 if p512b>=11 & p512b<51
replace tamahno=3 if p512b>50
replace tamahno=4 if p512b==. & (p512a==1 | p512a==2 )
label define tamahno 1 "De 1 a 10 trabajadores" 2 "De 11 a 50 trabajadores" /// 
3 "De 51 a más trabajadores" 4 "No especificado", replace
label value tamahno tamahno

/* Ingreso proveniente del trabajo
i524a1  Ingreso total trimestral (Imputado, deflactado, Anualizado)
d529t   Pago en especie dependiente (Deflactado, Anualizado)
i530a   Ganancia (ocupación principal independiente) (Imputado, deflactado, Anualizado)
d536    Valor de los productos para su consumo (Deflactado, Anualizado)
i538a1  Ingreso total (Imputado, deflactado, Anualizado)
d540t   Pago en especie (dependiente) (Deflactado, Anualizado)
i541a   Ganancia (ocupación secundaria independiente) (Imputado, deflactado, Anualizado)
d543    Valor de los productos utilizados para su consumo (Deflactado, Anualizado)
d544t   Ingreso extraordinario (Deflactado, Anualizado) */

egen  ingtrabw= rowtotal(i524a1 d529t i530a d536 i538a1 d540t i541a d543 d544t) 
gen   ingtra_n= ingtrabw/12
label var   ingtrabw "ingreso por trabajo anual"
label var   ingtra_n "ingreso por trabajo mensual"
keep if ocu500 == 1 & ingtra_n > 0 

*Perú: Ingreso promedio mensual proveniente del trabajo de
*la población ocupada, según etnia
table etnia [iw=fac500a] if resi==1 , c(mean ingtra_n) row

*Perú: Ingreso promedio mensual proveniente del trabajo,
*según estado civil o conyugal
table ecivil [iw=fac500a] if resi==1 , c(mean ingtra_n) row

*Perú: Ingreso promedio mensual proveniente del trabajo,
*según tamaño de empresa y área urbana
table tamahno area  [iw=fac500a] if resi==1 , c(mean ingtra_n) row

*Perú: Ingreso promedio mensual proveniente del trabajo de hombres y mujeres, 
*según área de residencia
table area p207 [iw=fac500a] if resi==1 , c(mean ingtra_n) row

*Perú urbano: Ingreso promedio mensual proveniente del trabajo, 
*según grupos de edad
table edad [iw=fac500a] if resi==1 & area==1 , c(mean ingtra_n) row

*Perú: Ingreso promedio mensual proveniente del trabajo
*de hombres y mujeres y Brechas, según grupos de edad
table edad p207 [iw=fac500a] if resi==1 , c(mean ingtra_n) row

*Perú: Brechas de género en ingreso promedio proveniente
*del trabajo, según departamento
table dpto p207 [iw=fac500a] if resi==1, c(mean ingtra_n) row
