
cap log close
set more off
clear all

cd "E:\OneDrive - Syracuse University\E盘\Google Drive\Hong Kong"

use "Cleaned Data\Final.dta", clear

*******************************************************************************
*                   2. Set Up the Regression Specification                    *
*******************************************************************************

* Basic Demographic characteristics
global Demo ratio_pop_f_2016 ratio_age_1_2016 ratio_age_2_2016 ratio_age_3_2016 ratio_age_4_2016 ratio_age_5_2016 ratio_married_2016
global New_Demo ratio_pop_f_2016 ratio_age_1_2016 ratio_age_2_2016 ratio_age_3_2016 ratio_age_4_2016 ratio_married_2016

global Origin ratio_born_hk_2016 ratio_born_chi_2016 ratio_ul_can_2016 ratio_ul_put_2016

* This is sum of education
global Education ratio_edu_dip_2016 ratio_edu_sub_2016 ratio_edu_deg_2016 
* global Education ratio_post_college_2016

* global Employment ratio_t_lf_2016 
global Employment ratio_t_wp_2016

*global Income ma_hh_2016
global Income ma_econhh_2016 

********************* I then define the instrument variables and dependent variables
global Treatment log_Events_Count_1124
global Instrument2 log_NumofBusStop log_NumofXiaobaStop log_MinimumDistancetoMTRStation 

tab dc_class_f, gen(region_dummy)
drop region_dummy18

gen sample = (ratio_pop_f_2016 != . )
*******************************************************************************
*                         Table: Summary Statistics                           *   
*******************************************************************************	

eststo clear
estpost tabstat ///
d2_投票率 d2_中立得票 d2_中立得票_ratio d2_亲民主得票 d2_亲民主得票_ratio d2_亲建制得票 d2_亲建制得票_ratio stay_grow Events_Count_1124 NumofBusStop NumofXiaobaStop NumofTotalStops MinimumDistancetoMTRStation $Demo $Origin $Education $Employment $Income if sample == 1, ///
  c(stat) stat(mean sd n)

esttab using "Proposals/Response/Table 1 Summary Statistics New.tex", replace ///
prehead(\begin{table}[H]\centering ///
\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} ///
\caption{ "Summary Statistics of Key Variables" } \begin{tabular}{l*{8}{c}} \toprule[1.5pt] ) ///
refcat(Events_Count "\emph{Panel A: Treatments}" NumofBusStop "\vspace{0.1em} \\ \emph{Panel B: Instruments}" ratio_pop_f_2016 "\vspace{0.1em} \\ \emph{Panel C: Control Variables}", nolabel) ///
 cells("mean(fmt(%8.3fc)) sd(fmt(%8.3fc)) min(fmt(0 0 0 0 0  %8.2fc)) p25(fmt(0 0 0 0 0  %8.2fc)) p50(fmt(0 0 0 0 0  %8.2fc)) p75(fmt(0 0 0 0 0 %8.2fc)) max(fmt(0 0 0 0 0 %8.2fc)) count(fmt(0))") nostar unstack nonumber ///
 compress nomtitle nonote noobs label booktabs ///
 collabels("Mean" "SD" "Min" "p25" "p50" "p75" "Max" "N") ///
 postfoot(\bottomrule[1.5pt] \end{tabular} \\ \end{table})