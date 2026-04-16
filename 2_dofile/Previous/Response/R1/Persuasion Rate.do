
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

gen tt_cf = 0
gen tt = log_Events_Count_1124

/*
ivreg2 d2_投票率 (tt = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
margins, at(tt = 0)
*/

***** t0
ivreg2 d2_投票率 (tt = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
predict double yhat_1_cf, xb

gen sample = e(sample)

replace yhat_1_cf = yhat_1_cf - _b[tt]*tt 
replace yhat_1_cf = . if sample == 0
gen t0 = yhat_1_cf + 投票率_2015*100
gen t = 投票率_2019 * 100

sum t0 t if sample == 1

* to = 70.04268
* t = 71.26091

***** v0
ivreg2 d2_亲民主得票 (tt = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
predict double yhat_2_cf, xb
replace yhat_2_cf = yhat_2_cf - _b[tt]*tt 
replace yhat_2_cf = . if sample == 0

gen v0 = yhat_2_cf + 亲民主得票_ratio_2015
gen v = 亲民主得票_ratio_2019

sum v0 v if sample == 1

* v0 = 59.78001
* v =  57.54567 
 
**** dv/ds
* 2.33686

**** dt/ds
* 1.509765

gen ss = 1 / (1 - 0.5978001 * 0.7004268) * (0.7126091*2.33686 + 0.5754567*1.509765)
gen ss2 = 1 / (1 - 0.5978001 * 0.7004268) * (0.7004268*2.33686 + 0.5978001*1.509765)


ivreg2 d2_亲建制得票 (tt = $Instrument2 ) $Demo $Origin $Education $Employment $Income i.dc_class_f, r
predict double yhat_3_cf, xb
replace yhat_3_cf = yhat_3_cf - _b[tt]*tt 
replace yhat_3_cf = . if sample == 0

gen v0_e = yhat_3_cf + 亲建制得票_ratio_2015
gen v_e = 亲建制得票_ratio_2019

sum v0_e v_e if sample == 1

* v0_e = 58.34135
* v_e =  42.06012

**** dv/ds
* .7442952

**** dt/ds
* 1.509765

gen ss_e = 1 / (- 0.5834135 * 0.7004268) * (0.7126091*1.509765 + 0.4206012*1.509765)
gen ss2_e = 1 / (- 0.5834135 * 0.7004268) * (0.7004268*1.509765 + 0.5834135*1.509765)

