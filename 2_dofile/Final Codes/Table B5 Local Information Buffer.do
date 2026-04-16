* Table B5
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear


*******************************************************************************
*         Appendix Table B3 Local Information Regression Alternative          *
*******************************************************************************
local within log_Events_Count_1124 log_Within_0_500 log_Within_500_1000 
eststo clear

eststo: reghdfe d2_投票率 log_Within_0_500 $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 log_Within_0_500 $Demo $Origin $Education $Employment $Income  [aw=t_pop_2016], absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local Weight "2016 pop"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 log_Within_500_1000 $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 log_Within_500_1000 $Demo $Origin $Education $Employment $Income  [aw=t_pop_2016], absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local Weight "2016 pop"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 `within' $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"

eststo: reghdfe d2_投票率 `within' $Demo $Origin $Education $Employment $Income  [aw=t_pop_2016], absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local Weight "2016 pop"
qui estadd local District "Y"

esttab using "$output/Final Tables/Table B5 Local Buffer.tex", replace f ///
prehead(\begin{table}[htbp!]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "OLS Regression Results of Protest Intensity in Different Buffers on Turnouts" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep( `within' )  ///
label booktabs nonotes collabels(none) ///
nomtitles ///
obslast ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "r2 \(R^2\)" ) sfmt(%6.3fc) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})