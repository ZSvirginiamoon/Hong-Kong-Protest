* Table B7
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "Cleaned Data\Final.dta", clear

gen hhi = (亲民主得票_ratio_2015^2 + 亲建制得票_ratio_2015^2 + 中立得票_ratio_2015^2)/100
*******************************************************************************
*               Table 8.6 IV Robustness controlling Polling Station           *
*******************************************************************************

eststo clear

eststo: reghdfe d2_投票率 hhi $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 hhi $Demo $Origin $Education $Employment $Income  [aw=t_pop_2016], absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "2016 pop"

eststo: reghdfe d2_投票率 log_Events_Count_1124 hhi $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 log_Events_Count_1124 hhi $Demo $Origin $Education $Employment $Income  [aw=t_pop_2016], absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "2016 pop"

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2) hhi $Demo $Origin $Education $Employment $Income i.dc_class_f , r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2) hhi $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "2016 pop"

esttab using "./Proposals/Final Tables/Table B7 IV Robust Competition.tex", replace f ///
prehead(\begin{table}[H]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "IV Regression: Regression Results Controlling Competition in Previous Election" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep( log_Events_Count_1124 hhi ) coeflabel(log_Events_Count_1124 "Protest Intensity" hhi "\( \text{HHI}_{2015} \)" ) ///
label booktabs nonotes collabels(none) ///
mgroups("OLS Results" "OLS Results" "IV Results", pattern(1 0 1 0 1 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) alignment(D{.}{.}{-1})  ///
nomtitles ///
obslast ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE"  "Weight Weighted" "r2 \(R^2\)" ) sfmt(%6.3fc) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})