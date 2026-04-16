* Table B4
*******************************************************************************
*                         1. Set Up the Environment                           *
*******************************************************************************
clear all

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "$clean_data\Final.dta", clear

*******************************************************************************
*          Appendix Table B3 Summary Statistics by 2015 Elections             *
*******************************************************************************
 
est clear
estpost ttest Events_Count_1124 $Demo $Origin $Education $Employment $Income, by(是否自动当选_2015)

esttab using "$output/Final Tables/Table B4 Summary by Election.tex", replace ///
  prehead(\begin{table}[htbp!]\centering ///
  \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
  \caption{ "Summary Statistics of Control Variables by Whether Having Elections in 2015" } \begin{tabular}{l*{5}{c}} \toprule[1.5pt] ) ///
  cells("mu_1(fmt(3)) mu_2(fmt(3))  b(star) ") ///
  collabels("\(\text{Has No 2015 Elections}\)" "\(\text{Has 2015 Elections}\)" "Difference between Two Groups" ) ///
  star(* 0.10 ** 0.05 *** 0.01) ///
  label booktabs nonum gaps compress ///
  postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})