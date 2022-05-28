cd "D:\ENAHO"
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/634-Modulo05.zip" 634-Modulo05.zip, replace
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/634-Modulo04.zip" 634-Modulo04.zip, replace
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/634-Modulo34.zip" 634-Modulo34.zip, replace

*Bajar el modulo de empleo/ingreso de la ENAHO y descomprimirlo (manualmente)
use enaho01a-2018-500.dta, clear

/* ocu500 indicador de la PEA: 1. ocupado 2. desocupado abierto 3. desocupado oculto 4. no pea
fac500 factor de expansion de empleo/ingresos
p500i  codigo informante del capitulo 500
p204   es miembro del hogar
p205   se encuentra ausente del hogar 30 dias o mas
p206   esta presente en el hogar 30 dias o mas
p207   sexo
p208a  edad
p209   estado civil
p301a  ultimo grado de estudios
p558c. Por sus antepasados y de acuerdo a sus costumbres, ¿Ud. se considera: 
1. Quechua? 2. Aimara? 3. Nativo o Indígena de la Amazonía? 
4. Negro/ Mulato/Zambo/Afro peruano? 5. Blanco? 6. Mestizo? 7. Otro? 8. No Sabe? 
9. Perteneciente o parte de otro pueblo indígena u originario */

rename a*o year
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

*Dominio geografico
gen     domin02=1 if dominio>=1 & dominio<=3 & area==1
replace domin02=2 if dominio>=1 & dominio<=3 & area==2
replace domin02=3 if dominio>=4 & dominio<=6 & area==1
replace domin02=4 if dominio>=4 & dominio<=6 & area==2
replace domin02=5 if dominio==7 & area==1
replace domin02=6 if dominio==7 & area==2
replace domin02=7 if dominio==8
label define domin02 1 "Costa_urbana" 2 "Costa_rural" 3 "Sierra_urbana" /// 
 4 "Sierra_rural" 5 "Selva_urbana" 6 "Selva_rural" 7 "Lima_Metropolitana"
label value domin02 domin02

*Departamento
gen     dpto= real(substr(ubigeo,1,2))
replace dpto=15 if (dpto==7)
label define dpto 1"Amazonas" 2"Ancash" 3"Apurimac" 4"Arequipa" 5"Ayacucho" ///
 6"Cajamarca" 8"Cusco" 9"Huancavelica" 10"Huanuco" 11"Ica" 12"Junin" ///
 13"La_Libertad" 14"Lambayeque" 15"Lima" 16"Loreto" 17"Madre_de_Dios" 18"Moquegua" ///
 19"Pasco" 20"Piura" 21"Puno" 22"San_Martin" 23"Tacna" 24"Tumbes" 25"Ucayali" 
lab val dpto dpto 

*Se establece quienes son residentes habituales
gen resi=1 if ((p204==1 & p205==2) | (p204==2 & p206==1))

*Grupos de edad
gen     edad=1 if p208a>13 & p208a<25
replace edad=2 if p208a>24 & p208a<60
replace edad=3 if p208a>59 & p208a<65
replace edad=4 if p208a>64
label define edad 1 "14-24" 2 "25-59" 3 "60-64" 4 "65 y mas"
lab val edad edad

*Estado civil
gen     ecivil=1 if p209==3 | p209==4 | p209==5
replace ecivil=2 if p209==6
replace ecivil=3 if p209==1 | p209==2
lab def ecivil 1 "Alguna vez unido/a 2/" 2 " Soltero/a" 3 "Unido/a 1/" 
lab val ecivil ecivil
*1/ Incluye : Conviviente y casado/a
*2/ Incluye: Separado/a, divorciado/a y viudo/a.

*Educacion
gen     educ=1 if p301a<5  |  p301a==12
replace educ=2 if p301a==5 |  p301a==6
replace educ=3 if p301a==7 |  p301a==8
replace educ=4 if p301a==9 |  p301a==10 | p301a==11
lab def educ 1 "Primaria 1/" 2 "Educacion secundaria" 3 "Superior no universitaria" ///
4 "Superior universitaria"
lab val educ educ
*1/ Incluye sin nivel e inicial. A partir del año 2017 se incluye educación básica especial

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

*Población en Edad de Trabajar por sexo, según ámbito geográfico
tab area   p207 [iw= fac500a] if resi==1
tab region p207 [iw= fac500a] if resi==1

*Población en Edad de Trabajar, según área de residencia y grupos de edad
tab edad area [iw= fac500a] if resi==1

*Poblacion Economicamente Activa, según ámbito geográfico
tab area   ocu500 [iw= fac500a ] if ocu500<3 & resi==1
tab region ocu500 [iw= fac500a ] if ocu500<3 & resi==1

*Población Económicamente Activa según etnia
tab etnia   ocu500 [iw= fac500a ] if ocu500<3 & resi==1, nofreq col

*Población Económicamente Activa, según estado civil o conyugal y sexo
tab ecivil   p207 [iw= fac500a ] if ocu500<3 & resi==1, nofreq col

*Tasa de actividad
*El cociente de la Población Económicamente Activa entre el total de Población en Edad de Trabajar
gen     t_act=0  if p208a>=14
replace t_act=1  if ocu500==1 | ocu500==2
lab def t_act 0 "" 1 "Tasa de Actividad"
lab val t_act t_act

tab t_act area   [iw= fac500a] if  resi==1, col nofreq
tab t_act region [iw= fac500a] if  resi==1, col nofreq

*Componentes de la Población Económicamente Inactiva, según sexo
gen     c_pei=1 if p546==6
replace c_pei=2 if p546==3 | p546==8
replace c_pei=3 if p546==7
replace c_pei=4 if p546==4
replace c_pei=5 if p546==5
lab def c_pei 1 "Vivía de su pensión o jubilación u otras rentas" 2 "Otro 1/" ///
3 "Enfermo o incapacitado" 4 "Estudiando" 5 "Quehaceres del hogar"
lab val c_pei c_pei
*1/ Incluye : Esperando el inicio de un trabajo dependiente, otro y no especificado

tab  c_pei p207  [iw= fac500a ] if ocu500>2 & resi==1, nofreq col

*Población ocupada según nivel de educación alcanzado
tab  educ  [iw= fac500a ] if ocu500==1 & resi==1 

*Tasa de desempleo abierto
*Es la proporción de la fuerza de trabajo desocupada disponible y que busca activamente trabajo
gen     t_de_a=0 if ocu500==1 | ocu500==2
replace t_de_a=1 if ocu500==2
lab def t_de_a 0 "" 1 "Tasa de Desempleo Abierto"
lab val t_de_a t_de_a

*Perú urbano: Tasa de desempleo abierto por sexo, según etnia
tab etnia t_de_a  [iw= fac500a] if  resi==1 & area==1 & p207==1, row nofreq
tab etnia t_de_a  [iw= fac500a] if  resi==1 & area==1 & p207==2, row nofreq
