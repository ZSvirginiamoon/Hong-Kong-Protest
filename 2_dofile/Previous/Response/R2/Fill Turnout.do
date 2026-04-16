* Table 7 
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "Cleaned Data\Final.dta", clear

local Instrument $Instrument2
*******************************************************************************
*                        Fill in Voter Turnout First                          *
*******************************************************************************

sum 投票率_2015, detail 

gen 投票率_2015_low = 投票率_2015
replace 投票率_2015_low = .4265012 if 投票率_2015_low == .
gen d2_投票率_low = (投票率_2019 - 投票率_2015_low) * 100

gen 投票率_2015_mean = 投票率_2015
replace 投票率_2015_mean = .4696027 if 投票率_2015_mean == .
gen d2_投票率_mean = (投票率_2019 - 投票率_2015_mean) * 100

gen 投票率_2015_high = 投票率_2015
replace 投票率_2015_high = .5113274 if 投票率_2015_high == .
gen d2_投票率_high = (投票率_2019 - 投票率_2015_high) * 100

*******************************************************************************
*                               Regression                                    *
*******************************************************************************
eststo clear

eststo: reghdfe d2_投票率_low log_Events_Count_1124 $Demo $Origin $Education $Employment $Income , absorb(dc_class) vce(robust)

eststo: reghdfe d2_投票率_low log_Events_Count_1124 $Demo $Origin $Education $Employment $Income [aw=t_pop_2016] , absorb(dc_class) vce(robust)

eststo: ivreg2 d2_投票率_low (log_Events_Count_1124 = `Instrument') $Demo $Origin $Education $Employment $Income i.dc_class_f, r

eststo: ivreg2 d2_投票率_low (log_Events_Count_1124 = `Instrument') $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r

esttab using "Proposals\Response\R2\R1_S4_Table_Fill.tex", replace f ///
prehead(\begin{table}[H]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Effects of the Protest Intensity on Voter Turnout, Filling In Missing Prior Turnout" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
posthead(\midrule \multicolumn{5}{l}{ \textit{Panel A. Filling with 25th Percentile} } \\ ) ///
postfoot( \addlinespace ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  /// 
keep( log_Events_Count_1124 ) coeflabel(log_Events_Count_1124 "Protest Intensity" ) ///
scalars("widstat Kleibergen-Paap F" "r2 \(R^2\)" "N Obs.") sfmt(%6.3fc %6.3fc %6.0f) ///
label booktabs noobs nonotes nolines collabels(none) ///
nomtitles


eststo clear

eststo: reghdfe d2_投票率_mean log_Events_Count_1124 $Demo $Origin $Education $Employment $Income , absorb(dc_class) vce(robust)

eststo: reghdfe d2_投票率_mean log_Events_Count_1124 $Demo $Origin $Education $Employment $Income [aw=t_pop_2016] , absorb(dc_class) vce(robust)

eststo: ivreg2 d2_投票率_mean (log_Events_Count_1124 = `Instrument') $Demo $Origin $Education $Employment $Income i.dc_class_f, r

eststo: ivreg2 d2_投票率_mean (log_Events_Count_1124 = `Instrument') $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r


esttab using "Proposals\Response\R2\R1_S4_Table_Fill.tex", append f ///
posthead(\midrule \multicolumn{5}{l}{ \textit{Panel B. Filling with Mean} } \\ ) ///
postfoot( \addlinespace  ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  /// 
keep( log_Events_Count_1124 ) coeflabel(log_Events_Count_1124 "Protest Intensity" ) ///
scalars("widstat Kleibergen-Paap F" "r2 \(R^2\)" "N Obs.") sfmt(%6.3fc %6.3fc %6.0f) ///
label booktabs noobs nonotes nomtitles nolines nonum collabels(none) ///
alignment(D{.}{.}{-1}) ///
nomtitles

eststo clear

eststo: reghdfe d2_投票率_high log_Events_Count_1124 $Demo $Origin $Education $Employment $Income , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local IV "OLS"
qui estadd local Weight "N"

eststo: reghdfe d2_投票率_high log_Events_Count_1124 $Demo $Origin $Education $Employment $Income [aw=t_pop_2016] , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local IV "OLS"
qui estadd local Weight "2016 pop"

eststo: ivreg2 d2_投票率_high (log_Events_Count_1124 = `Instrument') $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local IV "2SLS"
qui estadd local Weight "N"

eststo: ivreg2 d2_投票率_high (log_Events_Count_1124 = `Instrument') $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local IV "2SLS"
qui estadd local Weight "2016 pop"

esttab using "Proposals\Response\R2\R1_S4_Table_Fill.tex", append f ///
posthead(\midrule \multicolumn{5}{l}{ \textit{Panel C. Filling with 75th Percentile} } \\ ) ///
postfoot( \addlinespace \midrule ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  /// 
keep( log_Events_Count_1124 ) coeflabel(log_Events_Count_1124 "Protest Intensity" ) ///
scalars("widstat Kleibergen-Paap F" "r2 \(R^2\)" "N Obs.") sfmt(%6.3fc %6.3fc %6.0f) ///
label booktabs noobs nonotes nomtitles nolines nonum collabels(none) ///
alignment(D{.}{.}{-1}) ///
nomtitles

esttab using "Proposals\Response\R2\R1_S4_Table_Fill.tex", append f ///
drop(*) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table}) ///
label booktabs collabels(none) nomtitles noobs nolines nonum alignment(D{.}{.}{-1}) ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "IV Method" ) sfmt(%6.0f)