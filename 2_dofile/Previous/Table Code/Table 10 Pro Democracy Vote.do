* Table 10
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "Cleaned Data\Final.dta", clear


*******************************************************************************
*               Table 10 Second Stage Results on Democracy Share              *
*******************************************************************************
eststo clear

eststo: ivreg2 d2_亲民主得票 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f ,  r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"
qui estadd local IV "IV"

eststo: ivreg2 d2_亲民主得票 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016] , r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"
qui estadd local IV "IV"

eststo: ivreg2 d2_亲建制得票 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f ,  r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"
qui estadd local IV "IV"

eststo: ivreg2 d2_亲建制得票 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016] , r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"
qui estadd local IV "IV"

eststo: ivreg2 d2_亲民主得票_ratio (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f ,  r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"
qui estadd local IV "IV"

eststo: ivreg2 d2_亲民主得票_ratio (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016] , r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "2016 pop"
qui estadd local District "Y"
qui estadd local IV "IV"

esttab using "./Proposals/Final Tables/Table 10 ProDem Vote.tex", replace f ///
prehead(\begin{table}[H]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "IV Regression Results on Votes and Vote Shares of Pro-Establishment and Pro-Democracy Candidates" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep( log_Events_Count_1124 ) coeflabel(log_Events_Count_1124 "Protest Intensity" ) ///
label booktabs nonotes collabels(none) ///
mgroups("Votes, of Total Voters" "Total Vote Shares" "Votes, of Total Voters" "Total Vote Shares" , pattern(1 0 1 0 1 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) alignment(D{.}{.}{-1}) ///
nomtitles ///
obslast ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "IV Method" "widstat Kleibergen-Paap F" "r2 \(R^2\)" ) sfmt(%6.3fc) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})