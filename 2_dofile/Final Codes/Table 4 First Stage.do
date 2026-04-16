* Table 4 
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear

*******************************************************************************
*                   Table 4 IV Regression First Stage                         *
*******************************************************************************
local Instrument $Instrument2

eststo clear

eststo: reghdfe log_Events_Count_1124 `Instrument' if d2_投票率 != ., noabsorb vce(robust)
qui test `Instrument'
qui estadd scalar F_stat = r(F)
qui estadd local Weight "N"
		
eststo: reghdfe log_Events_Count_1124 `Instrument' $Demo $Origin $Education if d2_投票率 != ., noabsorb vce(robust)
qui test `Instrument'
qui estadd scalar F_stat = r(F)
qui estadd local Demographics "Y"
qui estadd local Weight "N"
		
eststo: reghdfe log_Events_Count_1124 `Instrument' $Demo $Origin $Education $Employment if d2_投票率 != ., noabsorb vce(robust)
qui test `Instrument'
qui estadd scalar F_stat = r(F)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"
qui estadd local Weight "N"
			
eststo: reghdfe log_Events_Count_1124 `Instrument' $Demo $Origin $Education $Employment $Income if d2_投票率 != ., noabsorb vce(robust)
qui test `Instrument'
qui estadd scalar F_stat = r(F)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local Weight "N"
			
eststo: reghdfe log_Events_Count_1124 `Instrument' $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)
qui test `Instrument'
qui estadd scalar F_stat = r(F)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"
			
eststo: reghdfe log_Events_Count_1124 `Instrument' $Demo $Origin $Education $Employment $Income [aw=t_pop_2016] if d2_投票率 != ., absorb(dc_class) vce(robust)
qui test `Instrument'
qui estadd scalar F_stat = r(F)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "2016 pop"
			
esttab using "$output/Final Tables/Table 4 IV First Stage.tex", replace f ///
prehead(\begin{table}[htbp!]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "First Stage Results \(log_Events_Count_1124\)" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep( `Instrument' ) ///
label booktabs nonotes collabels(none) ///
nomtitles ///
obslast ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "F_stat F-stat" "r2 \(R^2\)" ) sfmt(%9.3f %9.3f) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})
