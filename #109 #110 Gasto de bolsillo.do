
*Salud
use "D:\ENAHO\enaho01a-2019-400.dta", clear

/*
P4025 En las últ 4 semanas, ¿Presentó Ud. Algún(a)? -No tuvo enfermedad, síntoma, recaída, accidente

P414$01 En las últ 4 semanas, ¿recibió: Consulta?
P414$02 En las últ 4 semanas, ¿recibió: Medicinas?
P414$03 En las últ 4 semanas, ¿recibió: Análisis?
P414$04 En las últ 4 semanas, ¿recibió: Rayos X, Tomografía, etc?
P414$05 En las últ 4 semanas, ¿recibió: Otros exámenes (Hemodiálisis, etc.)?
P414$06 En los últ 3 meses, ¿recibió: Servicio dental y conexos?
P414$07 En los últ 3 meses, ¿recibió: Servicio Oftalmológico?
P414$08 En los últ 3 meses, ¿recibió: Compra de Lentes?
P414$09 En los últ 3 meses, ¿recibió: Vacunas?
P414$10 En los últ 3 meses, ¿recibió: Control de Salud de los Niños?
P414$11 En los últ 3 meses, ¿recibió : Anticonceptivos?
P414$12 En los últ 3 meses, ¿recibió: Otros Gastos (ortopedia,termómetro, etc.)?
P414$13 En los últ 12 meses, ¿recibió: Hospitalización?
P414$14 En los últ 12 meses, ¿recibió: Intervención Quirúrgica?
P414$15 En los últ 12 meses, ¿recibió: Controles por embarazo?
P414$16 En los últ 12 meses, ¿recibió: Atenciones de parto?

¿El gasto realizado fue: Pagado por algún miembro de este hogar?:
P4151$01 Consulta
P4151$02 Medicinas/Insumos
P4151$03 Análisis
P4151$04 Rayos X, Tomografía, etc
P4151$05 Otros Exámenes (Hemodiálisis, etc.)
P4151$06 Servicio dental y conexos?
P4151$07 Servicio Oftalmológico
P4151$08 Compra de Lentes
P4151$09 Vacunas
P4151$10 Control de Salud de los Niños
P4151$11 Anticonceptivos
P4151$12 Otros Gastos (ortopedia, termómetro, etc.)
P4151$13 Hospitalización
P4151$14 Intervención Quirúrgica?
P4151$15 Controles por embarazo
P4151$16 Atenciones de parto 

¿Cuánto fue el monto total por la compra o servicio?:
P41601 Consulta
P41602 Medicinas/Insumos
P41603 Análisis
P41604 Rayos X, Tomografía, etc
P41605 Otros Exámenes (Hemodiálisis, etc.)
P41606 Servicio dental y conexos?
P41607 Servicio Oftalmológico
P41608 Compra de Lentes
P41609 Vacunas
P41610 Control de Salud de los Niños
P41611 Anticonceptivos
P41612 Otros Gastos (ortopedia, termómetro, etc.)
P41613 Hospitalización
P41614 Intervención Quirúrgica
P41615 Controles por embarazo
P41616 Atenciones de parto 

i41606 (imputado, deflactado, anualizado) Servicio dental y conexos

FACTOR07 Factor de Expansión anual de Población Proyecciones CPV-2007
*/


gen       tuvo_ps=.
replace   tuvo_ps=1 if p4025==0
label var tuvo_ps "Algún problema de salud"

gen double gto01=0
gen double gto02=0
gen double gto03=0
gen double gto04=0
gen double gto05=0
gen double gto06=0
gen double gto07=0
gen double gto08=0
gen double gto09=0
gen double gto10=0
gen double gto11=0
gen double gto12=0
gen double gto13=0
gen double gto14=0
gen double gto15=0
gen double gto16=0
replace gto01=i41601 if p4151_01==1 
replace gto02=i41602 if p4151_02==1 
replace gto03=i41603 if p4151_03==1 
replace gto04=i41604 if p4151_04==1 
replace gto05=i41605 if p4151_05==1 
replace gto06=i41606 if p4151_06==1 
replace gto07=i41607 if p4151_07==1 
replace gto08=i41608 if p4151_08==1 
replace gto09=i41609 if p4151_09==1 
replace gto10=i41610 if p4151_10==1 
replace gto11=i41611 if p4151_11==1 
replace gto12=i41612 if p4151_12==1 
replace gto13=i41613 if p4151_13==1 
replace gto14=i41614 if p4151_14==1 
replace gto15=i41615 if p4151_15==1 
replace gto16=i41616 if p4151_16==1 
egen    gto_usu=rowtotal(gto01 gto02 gto03 gto04 gto05 gto06 gto07 gto08 gto09 gto10 gto11 gto12 gto13 gto14 gto15 gto16)
lab var gto_usu "Gasto tot en salud x usuario"

*Total
egen double g_salud=total(gto_usu *factor07/1000000)
lab var     g_salud "Total Gasto en salud, mill"
sum g_salud

*Tuvo algun problema de salud
egen double g_ps = total(gto_usu * factor07/1000000) if tuvo_ps==1
gen p_ps = g_ps*100/g_salud
label var g_ps "G. salud de quienes presentan algun p.s., mill"
label var p_ps "G. salud de quienes presentan algun p.s., %"
sum g_ps p_ps

*Por tipo de gasto (en millones)
egen double g_1=total(gto01 * factor07/1000000)
egen double g_2=total(gto02 * factor07/1000000)
egen double g_3=total(gto03 * factor07/1000000)
egen double g_4=total(gto04 * factor07/1000000)
egen double g_5=total(gto05 * factor07/1000000)
egen double g_6=total(gto06 * factor07/1000000)
egen double g_7=total(gto07 * factor07/1000000)
egen double g_8=total(gto08 * factor07/1000000)
egen double g_9=total(gto09 * factor07/1000000)
egen double g_10=total(gto10 * factor07/1000000)
egen double g_11=total(gto11 * factor07/1000000)
egen double g_12=total(gto12 * factor07/1000000)
egen double g_13=total(gto13 * factor07/1000000)
egen double g_14=total(gto14 * factor07/1000000)
egen double g_15=total(gto15 * factor07/1000000)
egen double g_16=total(gto16 * factor07/1000000)

*Por tipo de gasto (Como porcentaje del gto total)
gen p_1 = g_1*100/g_salud
gen p_2 = g_2*100/g_salud
gen p_3 = g_3*100/g_salud
gen p_4 = g_4*100/g_salud
gen p_5 = g_5*100/g_salud
gen p_6 = g_6*100/g_salud
gen p_7 = g_7*100/g_salud
gen p_8 = g_8*100/g_salud
gen p_9 = g_9*100/g_salud
gen p_10 = g_10*100/g_salud
gen p_11 = g_11*100/g_salud
gen p_12 = g_12*100/g_salud
gen p_13 = g_13*100/g_salud
gen p_14 = g_14*100/g_salud
gen p_15 = g_15*100/g_salud
gen p_16 = g_16*100/g_salud

label var g_1 "Consulta, mill"
label var g_2 "Medicamentos, mill"
label var g_3 "Análisis, mill"
label var g_4 "Rayos X, Tomografía, etc"
label var g_5 "Otros Exámenes (Hemodiálisis, etc.), mill"
label var g_6 "Servicio dental y conexos, mill"
label var g_7 "Servicio Oftalmológico, mill"
label var g_8 "Compra de Lentes, mill"
label var g_9 "Vacunas, mill"
label var g_10 "Control de Salud de los Niños, mill"
label var g_11 "Anticonceptivos, mill"
label var g_12 "Otros Gastos (ortopedia, termómetro, etc.), mill"
label var g_13 "Hospitalización, mill"
label var g_14 "Intervención Quirúrgica, mill"
label var g_15 "Controles por embarazo, mill"
label var g_16 "Atenciones de parto, mill"
label var p_1 "Consulta, %"
label var p_2 "Medicamentos, %"
label var p_3 "Análisis, %"
label var p_4 "Rayos X, Tomografía, etc"
label var p_5 "Otros Exámenes (Hemodiálisis, etc.), %"
label var p_6 "Servicio dental y conexos, %"
label var p_7 "Servicio Oftalmológico, %"
label var p_8 "Compra de Lentes, %"
label var p_9 "Vacunas, %"
label var p_10 "Control de Salud de los Niños, %"
label var p_11 "Anticonceptivos, %"
label var p_12 "Otros Gastos (ortopedia, termómetro, etc.), %"
label var p_13 "Hospitalización, %"
label var p_14 "Intervención Quirúrgica, %"
label var p_15 "Controles por embarazo, %"
label var p_16 "Atenciones de parto, %"

*Pasarlo a un archivo en excel
keep  g_* p_*
duplicates drop
drop if p_ps==.
format p_* %5.2fc

export excel using "D:\ENAHO\Gto de bolsillo 2019.xls", replace firstrow(varlabels)
