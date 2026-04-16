* Table B1
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear


*******************************************************************************
*                  Table 4 Robustness on Turnouts                             *
*******************************************************************************

** Create Inverse hyperbolic sine
gen sin_events = asinh(Events_Count_1124)

** Create Dummy
gen Events_dummy = .
replace Events_dummy = 0 if log_Events_Count_1124 == 0
replace Events_dummy = 1 if log_Events_Count_1124 > 0
*replace Events_dummy = 1 if log_Events_Count_1124 > 0 & log_Events_Count_1124 != .

********************* Robustness I: Using Winsorized Samples
********************* Robustness II: Using Arcsinh
********************* Robustness III: Using level Events
********************* Robustness IV: Using Indicators: Extensive Margin

eststo clear

eststo: reghdfe d2_投票率 log_Events_Count_1124_win $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 log_Events_Count_1124_win $Demo $Origin $Education $Employment $Income [aw=t_pop_2016] , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 sin_events $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 sin_events $Demo $Origin $Education $Employment $Income [aw=t_pop_2016] , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 Events_dummy $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 Events_dummy $Demo $Origin $Education $Employment $Income [aw=t_pop_2016] , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income if Events_dummy == 1 , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income if Events_dummy == 1 [aw=t_pop_2016] , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"

esttab using "$output/Final Tables/Table B1 Turnout Robustness.tex", replace f ///
prehead(\begin{table}[htbp!]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Robustness Checks: OLS Regression Results on Turnouts Using Alternative Measures" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep(log_Events_Count_1124_win sin_events Events_dummy log_Events_Count_1124) coeflabel(log_Events_Count_1124_win "\(\text{Protest Intensity}_{2,98} \) " sin_events "\( \text{Arcsinh(Event)} \) " Events_dummy "\( \textbf{1}_{Event > 0} \)" log_Events_Count_1124 "Protest Intensity") ///
label booktabs nonotes collabels(none) ///
mgroups("Winsorized" "Inv. Hyperbolic Sine" "Extensive Margin" "Intensive Margin", pattern(1 0 1 0 1 0 1 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) alignment(D{.}{.}{-1})  ///
nomtitles ///
obslast ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "r2 \(R^2\)" ) sfmt(%6.3fc) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})
