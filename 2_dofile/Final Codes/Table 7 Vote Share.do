* Table 7
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear


*******************************************************************************
*                              Panel A Vote of Voters                         *
*******************************************************************************
eststo clear

eststo: ivreg2 d2_中立得票 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f , r

eststo: ivreg2 d2_中立得票 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r

eststo: ivreg2 d2_亲民主得票 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f , r

eststo: ivreg2 d2_亲民主得票 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r

eststo: ivreg2 d2_亲建制得票 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f , r

eststo: ivreg2 d2_亲建制得票 (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r

esttab using "$output/Final Tables/Table 7 Vote Share.tex", replace f ///
prehead(\begin{table}[htbp!]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Effects of the Protest Intensity on Votes and Vote Share of Different Candidates" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
posthead(\midrule \multicolumn{6}{l}{ \textit{Panel A. Votes of Registered Voters \%} } \\ ) ///
postfoot( \addlinespace ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  /// 
keep( log_Events_Count_1124 ) coeflabel(log_Events_Count_1124 "Protest Intensity" ) ///
mgroups("Neutral" "Pro-Establishment" "Pro-Democracy" , pattern(1 0 1 0 1 0) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) alignment(D{.}{.}{-1}) ///
scalars("widstat Kleibergen-Paap F" "j Hansen J stat." "jp \( \chi^2(2) \) P-value" "r2 \(R^2\)" "N Obs.") sfmt(%9.3f %9.3f %9.3f %9.3f %9.0f) ///
label booktabs noobs nonotes nolines collabels(none) ///
nomtitles

*******************************************************************************
*                          Panel B Total Vote Share                           *
*******************************************************************************
eststo clear

eststo: ivreg2 d2_中立得票_ratio (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f , r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "N"

eststo: ivreg2 d2_中立得票_ratio (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "2016 pop"

eststo: ivreg2 d2_亲民主得票_ratio (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f , r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "N"

eststo: ivreg2 d2_亲民主得票_ratio (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "2016 pop"

eststo: ivreg2 d2_亲建制得票_ratio (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f , r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "N"

eststo: ivreg2 d2_亲建制得票_ratio (log_Events_Count_1124 = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f [aw=t_pop_2016], r
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local District "Y"
qui estadd local Method "2SLS"
qui estadd local Weight "2016 pop"

esttab using "$output/Final Tables/Table 7 Vote Share.tex", append f ///
posthead(\midrule \multicolumn{6}{l}{ \textit{Panel B. Votes of Total Votes \%} } \\ ) ///
postfoot( \addlinespace \midrule ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01)  /// 
keep( log_Events_Count_1124 ) coeflabel(log_Events_Count_1124 "Protest Intensity" ) ///
scalars("widstat Kleibergen-Paap F" "j Hansen J stat." "jp \( \chi^2(2) \) P-value" "r2 \(R^2\)" "N Obs.") sfmt(%9.3f %9.3f %9.3f %9.3f %9.0f) ///
label booktabs noobs nonotes nomtitles nolines nonum collabels(none) ///
alignment(D{.}{.}{-1}) ///
nomtitles

esttab using "$output/Final Tables/Table 7 Vote Share.tex", append f ///
drop(*) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table}) ///
label booktabs collabels(none) nomtitles noobs nolines nonum alignment(D{.}{.}{-1}) ///
scalars("Demographics Demographics" "Employment Employment" "Income Income" "District District FE" "Weight Weighted" "Method Method" )