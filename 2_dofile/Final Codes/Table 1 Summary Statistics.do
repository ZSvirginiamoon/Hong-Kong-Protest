* Table 1 
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear

*******************************************************************************
*                         Table: Summary Statistics                           *   
*******************************************************************************	

eststo clear
estpost tabstat ///
Events_Count Events_Count_1124 NumofBusStop NumofXiaobaStop NumofTotalStops MinimumDistancetoMTRStation $Demo $Origin $Education $Employment $Income if t_pop_2016 != . , ///
  c(stat) stat(mean sd min p25 p50 p75 max n)

esttab using "$output/Final Tables/Table 1 Summary Statistics.tex", replace ///
prehead(\begin{table}[htbp!]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Summary Statistics of Key Variables" } \begin{tabular}{l*{8}{c}} \toprule[1.5pt] ) ///
refcat(Events_Count "\vspace{0.1em} \\ \emph{Panel A: Explantory Variables}" NumofBusStop "\vspace{0.1em} \\ \emph{Panel B: Instrumental Variables}" ratio_pop_f_2016 "\vspace{0.1em} \\ \emph{Panel C: Control Variables}", nolabel) ///
 cells("mean(fmt(%12.3fc)) sd(fmt(%12.3fc)) min(fmt(0 0 0 0 0  %12.2fc)) p25(fmt(0 0 0 0 0  %12.2fc)) p50(fmt(0 0 0 0 0  %8.2fc)) p75(fmt(0 0 0 0 0 %12.2fc)) max(fmt(0 0 0 0 0 %12.2fc)) count(fmt(0))") nostar unstack nonumber ///
 compress nomtitle nonote noobs label booktabs ///
 collabels("Mean" "SD" "Min" "p25" "p50" "p75" "Max" "N") ///
 postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})