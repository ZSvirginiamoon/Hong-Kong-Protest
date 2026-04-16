* Table B9
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear

*******************************************************************************
*              Table 8 Heterogeneity Test on 2015 Stance                     *
*******************************************************************************
eststo clear
local Condition1 if 民主当选_2015 == 0 
local Condition2 if 民主当选_2015 == 1

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "N"

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016] , r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "2016 pop"

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f `Condition1', r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "N"

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016] `Condition1' , r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "2016 pop"

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f `Condition2', r partial(i.dc_class_f)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "N"

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016] `Condition2' , r partial(i.dc_class_f)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "2016 pop"

esttab using "$output/Final Tables/Table B9 Turnout Subsample.tex", replace f ///
prehead(\begin{table}[htbp!]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Regression Results on Turnout, Subsample of Previous Pro-Establishment Areas" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep( log_Events_Count_1124 ) coeflabel(log_Events_Count_1124 "Protest Intensity" ) ///
label booktabs nonotes collabels(none) ///
mgroups("Full Sample" "Previous Non-Pro-Democracy" "Previous Pro-Democracy" , pattern(1 0 1 0 1 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) alignment(D{.}{.}{-1}) ///
nomtitles ///
obslast ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "Method Method" "widstat Kleibergen-Paap F" "j Hansen J stat." "jp \( \chi^2(2) \) P-value" "r2 \(R^2\)") sfmt(%9.3f %9.3f %9.3f %9.3f) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})
