* Table B6
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear

*******************************************************************************
*               Appendix Table B4 Summary Statistics by Events                *
*******************************************************************************
gen Events_dummy = .
replace Events_dummy = 0 if log_Events_Count_1124 == 0
replace Events_dummy = 1 if log_Events_Count_1124 > 0

*replace Events_dummy = 1 if log_Events_Count_1124 > 0 & log_Events_Count_1124 != .
 
est clear
estpost ttest $Demo $Origin $Education $Employment $Income , by(Events_dummy)

esttab using "$output/Final Tables/Table B6 Summary by Event.tex", replace ///
  prehead(\begin{table}[htbp!]\centering ///
  \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
  \caption{ "Summary Statistics of Control Variables by Whether There is an Event" } \begin{tabular}{l*{5}{c}} \toprule[1.5pt] ) ///
  cells("mu_1(fmt(3)) mu_2(fmt(3))  b(star) ") ///
  collabels("\(Events = 0\)" "\(Events > 0\)" "Difference between Two Groups" ) ///
  star(* 0.10 ** 0.05 *** 0.01) ///
  label booktabs nonum gaps  compress ///
  postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})
