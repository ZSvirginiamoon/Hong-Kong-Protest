* Figure 6
*******************************************************************************
*                   1. Set Up the Environment                                 *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "Cleaned Data\Final.dta", clear

*******************************************************************************
*                   2. Set Up Different Instrumental Variables                *
*******************************************************************************
gen Bus_pop = NumofBusStop/t_pop_2016 * 1000
gen Xiaoba_pop = NumofXiaobaStop/t_pop_2016 * 1000
gen Total_pop = NumofTotalStops/t_pop_2016 * 1000

gen Bus_area = NumofBusStop/Area_Sqkm
gen Xiaoba_area = NumofXiaobaStop/Area_Sqkm
gen Total_area = NumofTotalStops/Area_Sqkm

gen log_Bus_pop = ln(1 + Bus_pop)
gen log_Xiaoba_pop = ln(1 + Xiaoba_pop)
gen log_Total_pop = ln(1 + Total_pop)

gen log_Bus_area = ln(1 + Bus_area)
gen log_Xiaoba_area = ln(1 + Xiaoba_area)
gen log_Total_area = ln(1 + Total_area)


gen bus = .
gen minibus = .
gen totalbus = .
gen MTR = log_MinimumDistancetoMTRStation
********************* I then define the instrument variables and dependent variables

** Panel A

replace bus = log_NumofBusStop 
replace minibus = log_NumofXiaobaStop
local IV bus minibus MTR

eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)
qui test `IV'
qui estadd local F_stat = round(`r(F)',.001)

replace totalbus = log_NumofTotalStops
local IV totalbus MTR

eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)
qui test `IV'
qui estadd local F_stat = round(`r(F)',.001)

replace bus = log_Bus_pop 
replace minibus = log_Xiaoba_pop
local IV bus minibus MTR

eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)
qui test `IV'
qui estadd local F_stat = round(`r(F)',.001)

replace bus = log_Bus_area 
replace minibus = log_Xiaoba_area
local IV bus minibus MTR

eststo: reghdfe log_Events_Count_1124 `IV' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)
qui test `IV'
qui estadd local F_stat = round(`r(F)',.001)


esttab using "./Proposals/Response/Table B7 Different IV Bus.tex", replace f ///
prehead(\begin{table}[htbp!]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Effects of Local Public Transportation on the Protest Intensity, Using Different Instruments" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
posthead(\midrule \multicolumn{4}{l}{ \textit{First-Stage Regression Results} } \\ ) ///
postfoot( \addlinespace ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  /// 
keep( bus  minibus totalbus MTR) ///
mgroups("Bus & Minibus (Main Result)" "Total Stops (Bus + Minibus)" "Bus & Minibus, per 1000 person" "Bus & Minibus, per square area" , pattern(1 1 1 1) ) ///
scalars("F_stat Kleibergen-Paap F") sfmt(%6.3fc) ///
label booktabs noobs nonotes nolines collabels(none) ///
nomtitles


** Panel B
est clear 

replace bus = log_NumofBusStop 
replace minibus = log_NumofXiaobaStop
local IV bus minibus MTR

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = `IV' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Weight "N"

replace totalbus = log_NumofTotalStops
local IV totalbus MTR

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = `IV' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Weight "N"

replace bus = log_Bus_pop 
replace minibus = log_Xiaoba_pop
local IV bus minibus MTR

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = `IV' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Weight "N"

replace bus = log_Bus_area 
replace minibus = log_Xiaoba_area
local IV bus minibus MTR

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = `IV' ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Weight "N"

esttab using "./Proposals/Response/Table B7 Different IV Bus.tex", append f ///
posthead(\midrule \multicolumn{4}{l}{ \textit{Second-stage Regression Results} } \\ ) ///
postfoot( \addlinespace \midrule ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  /// 
keep( log_Events_Count_1124 ) coeflabel(log_Events_Count_1124 "Protest Intensity" ) ///
label booktabs noobs nonotes nomtitles nolines nonum collabels(none) ///
alignment(D{.}{.}{-1}) ///
nomtitles

esttab using "./Proposals/Response/Table B7 Different IV Bus.tex", append f ///
drop(*) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table}) ///
label booktabs collabels(none) nomtitles nolines nonum alignment(D{.}{.}{-1}) ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "r2 \(R^2\)" ) sfmt(%6.3fc)