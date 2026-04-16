* Table 6 
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear

*******************************************************************************
*                   Table 6 IV Regression First Stage                         *
*******************************************************************************
global Instrument2 log_NumofBusStop log_NumofXiaobaStop log_MinimumDistancetoMTRStation 
local Instrument log_MinimumDistancetoMTRStation

eststo clear

eststo: reghdfe  log_NumofBusStop $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)

eststo: reghdfe  log_NumofXiaobaStop $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)

eststo: reghdfe  log_MinimumDistancetoMTRStation $Demo $Origin $Education $Employment $Income if d2_投票率 != . , absorb(dc_class) vce(robust)
			
esttab, b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) 


esttab using "Proposals\Response\R2\R1_2_Balance_Test.tex", replace f ///
prehead(\begin{table}[H]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Regression Results of Regressing Instruments on Covariates" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep( $Demo $Origin $Education $Employment $Income ) ///
label booktabs nonotes collabels(none) ///
mgroups("Bus Stops" "Minibus Stops" "Distance to MTR", pattern(1 1 1) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) alignment(D{.}{.}{-1}) ///
nomtitles ///
obslast ///
scalars("r2 \(R^2\)") sfmt(%6.3fc) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})
