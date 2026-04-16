* Table new DID
*******************************************************************************
*                   1. Set Up the Environment                                 *
*******************************************************************************
cap log close
set more off
clear all

cd "E:\OneDrive - Syracuse University\E盘\Google Drive\Hong Kong"
* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

use "Cleaned Data\Final.dta", clear

* Basic Demographic characteristics
global Demo ratio_pop_f_2016 ratio_age_1_2016 ratio_age_2_2016 ratio_age_3_2016 ratio_age_4_2016 ratio_age_5_2016 ratio_married_2016
global Origin ratio_born_hk_2016 ratio_born_chi_2016 ratio_ul_can_2016 ratio_ul_put_2016

* This is sum of education
global Education ratio_edu_dip_2016 ratio_edu_sub_2016 ratio_edu_deg_2016 
* global Education ratio_post_college_2016

* global Employment ratio_t_lf_2016 
global Employment ratio_t_wp_2016

*global Income ma_hh_2016
global Income ma_econhh_2016 

keep 投票率_2019 投票率_2015 dcca_class

reshape long 投票率_, i(dcca_class) j(year)

replace 投票率_ = 投票率_ * 100

merge m:1 dcca_class using "Cleaned Data\Final.dta", keepus(log_Events_Count_1124 Events_Count_1124 dc_class t_pop_2016 $Demo $Origin $Education $Employment $Income)

foreach var in log_Events_Count_1124 Events_Count_1124 $Demo $Origin $Education $Employment $Income {
	replace `var' = 0 if year == 2015 
}

eststo clear

eststo: reghdfe 投票率_ log_Events_Count_1124 , absorb(dcca_class year) vce(robust)
qui estadd local FE "c,t"
qui estadd local Weight "N"

eststo: reghdfe 投票率_ log_Events_Count_1124 $Demo $Origin $Education , absorb(dcca_class year) vce(robust)
qui estadd local FE "c,t"
qui estadd local Demographics "Y"	
qui estadd local Weight "N"

eststo: reghdfe 投票率_ log_Events_Count_1124 $Demo $Origin $Education $Employment , absorb(dcca_class year) vce(robust)
qui estadd local FE "c,t"
qui estadd local Demographics "Y"
qui estadd local Employment "Y"		
qui estadd local Weight "N"

eststo: reghdfe 投票率_ log_Events_Count_1124 $Demo $Origin $Education $Employment $Income, absorb(dcca_class year) vce(robust)
qui estadd local FE "c,t"
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"		
qui estadd local Weight "N"

eststo: reghdfe 投票率_ log_Events_Count_1124 $Demo $Origin $Education $Employment $Income [aw=t_pop_2016], absorb(dcca_class year) vce(robust)
qui estadd local FE "c,t"
qui estadd local Demographics "Y"
qui estadd local Employment "Y"	
qui estadd local Income "Y"	
qui estadd local Weight "2016 pop"

esttab using "./Proposals/Final Tables/Table 4_1 DID Turnout.tex", replace f ///
prehead(\begin{table}[H]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Effects of the Protest Intensity on Voter Turnout, Using Difference-in-Differences Model" } \begin{tabular}{l*{@M}{c}} \toprule[1.5pt] ) ///
b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
keep( log_Events_Count_1124 ) coeflabel(log_Events_Count_1124 "Protest Intensity" ) ///
label booktabs nonotes collabels(none) ///
nomtitles ///
obslast ///
scalars("FE Fixed Effects" "Demographics Demographics" "Employment Employment" "Income Income" "Weight Weighted" "r2 \(R^2\)" ) sfmt(%6.3fc) ///
postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})