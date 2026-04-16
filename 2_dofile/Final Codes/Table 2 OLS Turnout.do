* Table 2 
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear

*******************************************************************************
*               Table 2 OLS Regression Results on Turnout                     *
*******************************************************************************

********************* OLS Results
eststo clear

eststo: reghdfe d2_投票率 log_Events_Count_1124 , noabsorb vce(robust)
qui estadd local Weight "N"

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education , noabsorb vce(robust)
qui estadd local Demographics "Y"	
qui estadd local Weight "N"

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment , noabsorb vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"		
qui estadd local Weight "N"

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income , noabsorb vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income  [aw=t_pop_2016], absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "2016 pop"

eststo: reghdfe d2_投票率_lag log_Events_Count_1124 $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率_lag log_Events_Count_1124 $Demo $Origin $Education $Employment $Income  [aw=t_pop_2016], absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "2016 pop"

esttab using "$output/Final Tables/Table 2 OLS Turnout.tex", replace f ///
prehead(\begin{table}[htbp!]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "OLS Regression Results of Protest Intensity on Turnouts" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep( log_Events_Count_1124 ) coeflabel(log_Events_Count_1124 "Protest Intensity" ) ///
mgroups("\( \Delta Turnout_{2019-2015} \)" "\( \Delta Turnout_{2015-2011} \)", pattern(1 0 0 0 0 0 1 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) alignment(D{.}{.}{-1}) ///
label booktabs nonotes collabels(none) ///
nomtitles ///
obslast ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "r2 \(R^2\)" ) sfmt(%9.3f) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})