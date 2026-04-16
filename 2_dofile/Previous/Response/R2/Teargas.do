* Table 5_1 
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "Cleaned Data\Final.dta", clear

*******************************************************************************
*                   Table 5_1 Lennon and Teargas                              *
*******************************************************************************

eststo clear

eststo: reghdfe d2_投票率 log_Events_Count_1124 $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Weight "N"

eststo: reghdfe d2_投票率 log_Activist_Count_1124 $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Weight "N"

eststo: reghdfe d2_投票率 log_Lennon_Wall $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Weight "N"

eststo: reghdfe d2_投票率 log_Events_Count_1124 log_Activist_Count_1124 $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Weight "N"

eststo: reghdfe d2_投票率 log_Events_Count_1124 log_Lennon_Wall $Demo $Origin $Education $Employment $Income  , absorb(dc_class) vce(robust)
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Weight "N"


esttab using "Proposals\Response\R2\R1_1_Table_Teargas.tex", replace f ///
prehead(\begin{table}[H]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Effects of Protest, Teargas, and Lennon Walls on Voter Turnout" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep( log_Events_Count_1124 log_Activist_Count_1124 log_Lennon_Wall) coeflabel(log_Events_Count_1124 "Protest Intensity" log_Activist_Count_1124 "\( \ln ( \text{Teargas Deployments}) \)" log_Lennon_Wall "\( \ln ( \text{Lennon Walls}) \)") ///
label booktabs nonotes collabels(none) ///
nomtitles ///
obslast ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "r2 \(R^2\)" ) sfmt(%6.3fc) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})