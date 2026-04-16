* Table 6 New
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear

gen hhi = (亲民主得票_ratio_2015^2 + 亲建制得票_ratio_2015^2 + 中立得票_ratio_2015^2)/100

eststo clear


eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2) density $Demo $Origin $Education $Employment $Income i.dc_class_f , r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"
qui estadd local Method "2SLS"

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2) density $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "2016 pop"
qui estadd local Method "2SLS"

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2) log_MinimumDistancetoPolling $Demo $Origin $Education $Employment $Income i.dc_class_f , r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"
qui estadd local Method "2SLS"

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2) log_MinimumDistancetoPolling $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "2016 pop"
qui estadd local Method "2SLS"

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2) hhi $Demo $Origin $Education $Employment $Income i.dc_class_f , r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"
qui estadd local District "Y"
qui estadd local Method "2SLS"

eststo: ivreg2 d2_投票率 (log_Events_Count_1124 = $Instrument2) hhi $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local District "Y"
qui estadd local Weight "2016 pop"
qui estadd local Method "2SLS"

esttab using "$output/Final Tables/Table 6 IV Robust.tex", replace f ///
prehead(\begin{table}[htbp!]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "IV Regression: Regression Results Excluding Alternative Mechanisms" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep( log_Events_Count_1124 density log_MinimumDistancetoPolling hhi) coeflabel(log_Events_Count_1124 "Protest Intensity" density "Pop. Density (pop / $\text{km}^2$)" log_MinimumDistancetoPolling "\( \ln ( \text{Dist. To Nearest Polling Sta.}) \)"  hhi "\( \text{HHI}_{2015} \)") ///
order( log_Events_Count_1124 density log_MinimumDistancetoPolling hhi) ///
label booktabs nonotes collabels(none) ///
nomtitles ///
obslast ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "Method Method" "widstat Kleibergen-Paap F" "j Hansen J stat." "jp \( \chi^2(2) \) P-value" "r2 \(R^2\)" ) sfmt(%9.3f %9.3f %9.3f %9.3f) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})