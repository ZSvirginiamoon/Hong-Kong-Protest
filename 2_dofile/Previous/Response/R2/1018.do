* Table 7 
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "Cleaned Data\Final.dta", clear

*******************************************************************************
*                   Table 7 IV Regression Second Stage                        *
*******************************************************************************

local Instrument $Instrument2

eststo clear

eststo: reghdfe d2_投票率 log_Events_Count_1018 $Demo $Origin $Education $Employment $Income , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Weight "N"

eststo: reghdfe d2_投票率 log_Events_Count_1018 $Demo $Origin $Education $Employment $Income [aw=t_pop_2016] , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"

eststo: ivreg2 d2_投票率 (log_Events_Count_1018 = `Instrument') $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "N"

eststo: ivreg2 d2_投票率 (log_Events_Count_1018 = `Instrument') $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"

eststo: ivreg2 d2_投票率_lag (log_Events_Count_1018 = `Instrument') $Demo $Origin $Education $Employment $Income i.dc_class_f, r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "N"

eststo: ivreg2 d2_投票率_lag (log_Events_Count_1018 = `Instrument') $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"
	
esttab using "Proposals\Response\R2\Table_1018.tex", replace f ///
prehead(\begin{table}[H]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Second Stage IV Regression Results on Turnouts" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep( log_Events_Count_1018 ) coeflabel(log_Events_Count_1018 " Protest Intensity" ) ///
label booktabs nonotes collabels(none) ///
mgroups("OLS Results" "IV Results" "IV Results", pattern(1 0 1 0 1 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) alignment(D{.}{.}{-1}) ///
nomtitles ///
obslast ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "widstat Kleibergen-Paap F" "r2 \(R^2\)" ) sfmt(%6.3fc) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})

