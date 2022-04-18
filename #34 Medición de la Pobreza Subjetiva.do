********************************************************************************
*POBREZA SUBJETIVA //Modulo 85 de GOBERNABILIDAD de la ENAHO
/*
Perú: Perfil de la pobreza por dominios geográficos, 2008-2018
https://www.inei.gob.pe/media/MenuRecursivo/publicaciones_digitales/Est/Lib1699/
5.1 Percepción del bienestar  
5.2 Percepción de la situación económica de los hogares  
5.3 Percepción acerca de los ingresos del hogar 
5.5 Percepción acerca del nivel de vida de los Hogares 
*/

cd "D:\ENAHO"
use enaho01b-2018-2.dta, clear
merge 1:1 conglome vivienda hogar using sumaria-2018.dta

*Creo la variable pobreza categorizada como pobre/no pobre 
*sobre la base de la variable "pobreza" que ya se encuentra en el archivo
gen          pobre2=1 if pobreza<3
replace      pobre2=2 if pobreza==3
*Etiquetamos los valores de la variable 
label define pobre2 1 "pobre" 2 "no_pobre"
label value  pobre2 pobre2

*Percepción de bienestar 
tab p37 pobreza [aweight=factor07], col nofreq 
tab p37 pobre2  [aweight=factor07], col nofreq 
graph bar [aweight=factor07],  over(p37) over(pobre2) ///
asyvars percentages blabel(bar,format(%9.1f))

*Percepción de la situación económica
tab p32          [aweight=factor07]
tab p32 pobreza  [aweight=factor07], col nofreq 
tab p32 pobre2   [aweight=factor07], col nofreq 
graph bar [aweight=factor07],  over(p32) over(pobre2) /// 
asyvars percentages blabel(bar,format(%9.1f))

*Percepción acerca de los ingresos del hogar
tab pobreza p38a  [aweight=factor07], row nofreq 
tab pobre2 p38a  [aweight=factor07], row nofreq 
graph bar [aweight=factor07],  over(p38a) over(pobre2) /// 
asyvars percentages blabel(bar,format(%9.1f))

*Percepción acerca del nivel de vida de los Hogares 
tab p34         [aweight=factor07]
tab p34 pobreza [aweight=factor07], col nofreq 
