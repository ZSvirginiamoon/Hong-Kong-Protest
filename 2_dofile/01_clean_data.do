
* Merging Hong Kong Election and Census Data
* Shuo Zhang, Syracuse University
* szhang64@syr.edu

* This do file is used to merge the Hong Kong Election and Census Data, as well as the 
* detailed protest data in 2015 and 2019

*******************************************************************************
*                   1. Set Up the Environment                                 *
*******************************************************************************
cd "$root"

* I have a total of three sets of variables: Election (2015 2019), Census (2016 2021), and protest
* A total of five datasets

*******************************************************************************
*                   2. Construct Census Data                                  *
*******************************************************************************

****************** I import 2021 first
import excel "$raw_data\区议会\区议会based人口普查\DCCA_21C.xlsx", clear cellrange(A5) first sheet("DCCA") 

* Some other annotations that I need to drop, resulting in 452 obs and 1 aggregate
drop if _n >= 454
drop if dcca_class == "999"

* Some auxiliary commands
foreach var of varlist t_pop-pm_out {
	destring `var', force replace i(",")
	rename `var' `var'_2021
}

* Then save the panel
save "$clean_data\Prelim\Census_2021.dta", replace

****************** I then import 2016 
import excel "$raw_data\区议会\区议会based人口普查\DCCA_16BC.xlsx", clear cellrange(A5) first sheet("DCCA") 

* Some other annotations that I need to drop, resulting in 431 obs and 1 aggregate
drop if _n >= 433
drop if dcca_class == "999"

* Some auxiliary commands
foreach var of varlist t_pop-pm_out {
	destring `var', force replace i(",")
	rename `var' `var'_2016
}

*** One control ul_put_2016 has only 429 but others all 431
* egen temp_ul_put = sum(ul_put_2016)
* egen temp_pop = sum(t_pop_2016)
* gen temp_ul_put_share = temp_ul_put / temp_pop
* replace  ul_put_2016 = t_pop_2016 * temp_ul_put_share if  ul_put_2016 == .

* drop temp_ul_put temp_pop temp_ul_put_share

* replace  ul_put_2016 = 0 if  ul_put_2016 == .

***** Follow Lee Guidance to calculate Gini
gen totalhou = dhi_e1_2016 + dhi_e2_2016 + dhi_e3_2016 + dhi_e4_2016 + dhi_e5_2016 + dhi_e6_2016 + dhi_e7_2016
gen totalwea = 6000*dhi_e1_2016+8000*dhi_e2_2016+15000*dhi_e3_2016+25000*dhi_e4_2016+35000*dhi_e5_2016+50000*dhi_e6_2016+60000*dhi_e7_2016

gen w_1 = 6000*dhi_e1_2016/totalwea
gen w_2 = 8000*dhi_e2_2016/totalwea 
gen w_3 = 15000*dhi_e3_2016/totalwea
gen w_4 = 25000*dhi_e4_2016/totalwea
gen w_5 = 35000*dhi_e5_2016/totalwea
gen w_6 = 50000*dhi_e6_2016/totalwea
gen w_7 = 60000*dhi_e7_2016/totalwea

forvalues i = 1(1)7 {
	gen p_`i' =  dhi_e`i'_2016/totalhou
}

gen Q_1 = w_1 
gen Q_2 = w_1 + w_2
gen Q_3 = w_1 + w_2 + w_3
gen Q_4 = w_1 + w_2 + w_3 + w_4
gen Q_5 = w_1 + w_2 + w_3 + w_4 + w_5 
gen Q_6 = w_1 + w_2 + w_3 + w_4 + w_5 + w_6
gen Q_7 = w_1 + w_2 + w_3 + w_4 + w_5 + w_6 + w_7

gen gini = 1 - p_1*(2*Q_1-w_1) - p_2*(2*Q_2-w_2) - p_3*(2*Q_3-w_3) - p_4*(2*Q_4-w_4) - p_5*(2*Q_5-w_5) - p_6*(2*Q_6-w_6) - p_7*(2*Q_7-w_7)

replace gini = gini * 100

**** New on 05.21 crosswalk 
/*
merge 1:1 dcca_class using "区议会\Crosswalk.dta", nogenerate
drop dcca_class
rename dcca_class_2021 dcca_class
*/

* Then save the panel
save "$clean_data\Prelim\Census_2016.dta", replace

*******************************************************************************
*                   3. Construct Election Data                                *
*******************************************************************************
import excel "$raw_data\区议会\选举结果\2019.xlsx", clear first sheet("结果表") 

* Rename all the variable in 2019 form
foreach var of varlist 总票数 亲建制得票 亲民主得票 民主当选 中立当选 是否自动当选 一共参选 竞争程度HHI 选民人数 投票总数 投票率 {
	rename `var' `var'_2019
}

* rename the key variable
rename 选区号码 dcca_class

save "$clean_data\Prelim\Election_2019.dta", replace

import excel "$raw_data\区议会\选举结果\2015.xlsx", clear first sheet("结果表") 

* Rename all the variable in 2015 form
foreach var of varlist 总票数 亲建制得票 亲民主得票 民主当选 中立当选 是否自动当选 一共参选 竞争程度HHI 选民人数 投票总数 投票率 {
	rename `var' `var'_2015
}

destring 总票数_2015, force replace i(",") 
destring 亲建制得票_2015, force replace i(",") 
destring 亲民主得票_2015, force replace i(",")

* rename the key variable
rename 选区号码 dcca_class
drop if _n >= 432

**** New on 05.21 crosswalk 
/*
merge 1:1 dcca_class using "区议会\Crosswalk.dta", nogenerate
drop dcca_class
rename dcca_class_2021 dcca_class
*/

save "$clean_data\Prelim\Election_2015.dta", replace

import excel "$raw_data\区议会\选举结果\2011.xlsx", clear first sheet("结果表") 

* Rename all the variable in 2011 form
foreach var of varlist 总票数 亲建制得票 亲民主得票 民主当选 是否自动当选 一共参选 竞争程度HHI 选民人数 投票总数 投票率 {
	rename `var' `var'_2011
}
destring 总票数_2011, force replace i(",") 
destring 亲建制得票_2011, force replace i(",") 
destring 亲民主得票_2011, force replace i(",")
destring 投票率_2011, force replace i(",")

* rename the key variable
rename 选区号码 dcca_class
drop if _n >= 413

save "$clean_data\Prelim\Election_2011.dta", replace

*******************************************************************************
*                   4. Construct Protest Data                                 *
*******************************************************************************
import excel "$raw_data\区议会\Protest Count.xlsx", clear first 
* rename the key variable
rename 选区号码 dcca_class
gen log_Events_Count = ln(1+Events_Count)
gen log_Media_Count = ln(1+Media_Count)
gen log_Activist_Count = ln(1+Activist_Count)

gen log_Events_Count_1124 = ln(1+Events_Count_1124)
gen log_Media_Count_1124 = ln(1+Media_Count_1124)
gen log_Activist_Count_1124 = ln(1+Activist_Count_1124)

gen log_Events_Count_1018 = ln(1+Events_Count_1018)

foreach var of varlist Within_500m Within_0_500 Within_1000m Within_500_1000 Within_1500m Within_1000_1500 Within_2000m Within_1500_2000 Within_0_1000 Within_1000_2000 {
	gen log_`var' = ln(1 + `var')
}
 
****** Create a winsorized version 
winsor2 Events_Count Media_Count Activist_Count Events_Count_1124 Media_Count_1124 Activist_Count_1124, cuts(2 98) suffix(_win) label

gen log_Events_Count_win = ln(1+Events_Count_win)
gen log_Media_Count_win = ln(1+Media_Count_win)
gen log_Activist_Count_win = ln(1+Activist_Count_win) 

gen log_Events_Count_1124_win = ln(1+Events_Count_1124_win)
gen log_Media_Count_1124_win = ln(1+Media_Count_1124_win)
gen log_Activist_Count_1124_win = ln(1+Activist_Count_1124_win) 

** Lennon Wall
gen log_Lennon_Wall = ln(1+Lennon_Wall)

* Then save the panel
save "$clean_data\Prelim\Protest_Count.dta", replace

*******************************************************************************
*                4. Construct Neighbor Protest Data                           *
*******************************************************************************
import excel "$raw_data\区议会\Neighbor.xlsx", clear first 
collapse (sum) Neighbor_count, by (Source_dcca)
rename Source_dcca dcca_class
save "$clean_data\Prelim\Neighbor.dta", replace

use "$clean_data\Prelim\Protest_Count.dta", clear 
merge 1:1 dcca_class using "$clean_data\Prelim\Neighbor.dta"

* Two areas have no neighbors, replace with 0
replace Neighbor_count = 0 if _merge == 1
drop _merge

gen log_Neighbor_Count = ln(1+ Neighbor_count)

capture destring Rec_distance, force replace i(",") 

* Then save the panel
save "$clean_data\Prelim\Protest_Count.dta", replace

**** Generate the Distance measure
* import delimited "区议会\Distance.csv", clear 
* gen Rec_distance = 1 / near_dist 
* collapse (sum) Rec_distance, by (in_fid)
* export delimited "区议会\Event Distance.csv", replace

*******************************************************************************
*                   5. Construct Instrument Data                              *
*******************************************************************************
import excel "$raw_data\区议会\Instrument.xlsx", clear first 
* rename the key variable
rename 选区号码 dcca_class
 
gen log_NumofTramStop = ln(1+NumofTramStop)
gen log_NumofBusStop = ln(1+NumofBusStop)
gen log_NumofXiaobaStop = ln(1+NumofXiaobaStop)
gen log_NumofTotalStops = ln(1+NumofTotalStops)
 
* Main Test Using Central Points
* Distance is too large. use KM
replace MinimumDistancetoUniversity = MinimumDistancetoUniversity/1000
replace MinimumDistancetoPoliceStati = MinimumDistancetoPoliceStati/1000
replace MinimumDistancetoMTRStation = MinimumDistancetoMTRStation/1000
replace MinimumDistancetoPolling = MinimumDistancetoPolling/1000

gen log_MinimumDistancetoUniversity = log(MinimumDistancetoUniversity)
gen log_MinimumDistancetoPoliceStati = log(MinimumDistancetoPoliceStati)
gen log_MinimumDistancetoMTRStation = log(MinimumDistancetoMTRStation)
gen log_MinimumDistancetoPolling = log(MinimumDistancetoPolling)

label var MinimumDistancetoUniversity "Min. Dist. to the Univ. (km)"
label var MinimumDistancetoPoliceStati "Min. Dist. to the Police (km)" 
label var MinimumDistancetoMTRStation "Min. Dist. to the MTR (km)"
label var log_MinimumDistancetoUniversity "ln(Min. Dist. to the Univ.)"
label var log_MinimumDistancetoPoliceStati "ln(Min. Dist. to the Police)"
label var log_MinimumDistancetoMTRStation " ln(Min. Dist. to the MTR)"
label var log_MinimumDistancetoPolling " ln(Min. Dist. to the Polling)"

* Robustness Using Centroid

replace CentroidMinDistancetoUnivers = CentroidMinDistancetoUnivers/1000
replace CentroidMinDisttoPoliceStat = CentroidMinDisttoPoliceStat/1000
replace CentroidMinDisttoMTRStation = CentroidMinDisttoMTRStation/1000
replace CentroidMinDisttoPolling = CentroidMinDisttoPolling/1000

gen log_CenMiniDistancetoUniversity = log(CentroidMinDistancetoUnivers)
gen log_CenMiniDistancetoPoliceStati = log(CentroidMinDisttoPoliceStat)
gen log_CenMiniDistancetoMTRStation = log(CentroidMinDisttoMTRStation)
gen log_CenMiniDistancetoPolling = log(CentroidMinDisttoPolling)

label var CentroidMinDistancetoUnivers "Centroid Min. Dist. to the Univ. (km)"
label var CentroidMinDisttoPoliceStat "Centroid Min. Dist. to the Police (km)" 
label var CentroidMinDisttoMTRStation "Centroid Min. Dist. to the MTR (km)"
label var log_CenMiniDistancetoUniversity "ln(Centroid Min. Dist. to the Univ.)"
label var log_CenMiniDistancetoPoliceStati "ln(Centroid Min. Dist. to the Police)"
label var log_CenMiniDistancetoMTRStation " ln(Centroid Min. Dist. to the MTR)"
label var log_CenMiniDistancetoPolling " ln(Centroid Min. Dist. to the Polling)"

* Then save the panel
save "$clean_data\Prelim\Instrument.dta", replace

*******************************************************************************
*                   5. Construct Longitude  Data                              *
*******************************************************************************
import excel "$raw_data\区议会\Central Point.xlsx", clear first 

rename 选区号码 dcca_class

save "$clean_data\Prelim\Central Point.dta", replace

*******************************************************************************
*                   5. Merge all the Data                                     *
*******************************************************************************
* I first concord all the 2019 data, which has 452 obs
use "$clean_data\Prelim\Census_2021.dta", clear

merge 1:1 dcca_class using "$clean_data\Prelim\Election_2019.dta" 
drop _merge

merge 1:1 dcca_class using "$clean_data\Prelim\Protest_Count.dta" 
drop _merge

merge 1:1 dcca_class using "$clean_data\Prelim\Instrument.dta"
drop _merge

save "$clean_data\Prelim\2019.dta", replace

* Then I concord all the 2015 data, which has 431 obs
use "$clean_data\Prelim\Census_2016.dta", clear

merge 1:1 dcca_class using "$clean_data\Prelim\Election_2015.dta"
drop _merge 

save "$clean_data\Prelim\2015.dta", replace

* Finally I merge two datasets together
use "$clean_data\Prelim\2019.dta", clear
merge 1:1 dcca_class using "$clean_data\Prelim\2015.dta" 
rename _merge merge2019_2015

* Save the final data and drop the prelim datasets
save "$clean_data\Final.dta", replace

* Merge 2011 as a potential robustness check
use "$clean_data\Final.dta", clear
merge 1:1 dcca_class using "$clean_data\Prelim\Election_2011.dta"
drop _merge

* Merge Longitude and Latitude data
merge 1:1 dcca_class using "$clean_data\Prelim\Central Point.dta", keepus(Longitude Latitude)
drop _merge

*******************************************************************************
*                   6. Create the Regression Variables                        *
*******************************************************************************
egen dc_class_f = group(dc_class)

******************** I define the control variables first
foreach var of varlist pop_f_2016 age_1_2016 age_2_2016 age_3_2016 age_4_2016 age_5_2016 born_hk_2016 born_chi_2016 born_else_2016 ul_can_2016 ul_put_2016 ul_othchi_2016 ul_eng_2016 ul_oth_2016 edu_prepri_2016 edu_pri_2016 edu_lsed_2016 edu_usec_2016 edu_dip_2016 edu_sub_2016 edu_deg_2016 t_lf_2016 t_wp_2016 {
    gen ratio_`var' = `var' / t_pop_2016 * 100
	label var ratio_`var' "Ratio of `var'"
}

* Alternative education
gen ratio_post_college_2016 = ratio_edu_dip_2016 + ratio_edu_sub_2016 + ratio_edu_deg_2016

* This is married 
gen ratio_married_2016 = (ms_ma_m_2016 + ms_m_f_2016)/t_pop_2016 * 100
label var ratio_married_2016 "Ratio of Married People"

* This is income
label var ma_hh_2016 "Median Household Income I"
label var ma_econhh_2016 "Median Household Income II"

******************** same for 2021
foreach var of varlist pop_f_2021 age_1_2021 age_2_2021 age_3_2021 age_4_2021 age_5_2021 born_hk_2021 born_chi_2021 born_else_2021 ul_can_2021 ul_put_2021 ul_othchi_2021 ul_eng_2021 ul_oth_2021 edu_prepri_2021 edu_pri_2021 edu_lsed_2021 edu_usec_2021 edu_dip_2021 edu_sub_2021 edu_deg_2021 t_lf_2021 t_wp_2021 {
    gen ratio_`var' = `var' / t_pop_2021 * 100
	label var ratio_`var' "Ratio of `var'"
}

* Alternative education
gen ratio_post_college_2021 = ratio_edu_dip_2021 + ratio_edu_sub_2021 + ratio_edu_deg_2021

* This is married 
gen ratio_married_2021 = (ms_ma_m_2021 + ms_m_f_2021)/t_pop_2021 * 100
label var ratio_married_2021 "Ratio of Married People"

* This is income
label var ma_hh_2021 "Median Household Income I"
label var ma_econhh_2021 "Median Household Income II

********************* I finally define the treatment variables 

gen d2_民主当选 = 民主当选_2019 - 民主当选_2015
gen d2_中立当选 = 中立当选_2019 - 中立当选_2015
gen d2_投票率 = (投票率_2019 - 投票率_2015) * 100

gen 亲民主得票_ratio_2015 = 亲民主得票_2015 / 总票数_2015 * 100
gen 亲民主得票_ratio_2019 = 亲民主得票_2019 / 总票数_2019 * 100
gen d2_亲民主得票_ratio = 亲民主得票_ratio_2019 - 亲民主得票_ratio_2015

gen 亲民主得票_ratio_2015_two = 亲民主得票_2015 / (亲民主得票_2015 + 亲建制得票_2015) * 100
gen 亲民主得票_ratio_2019_two = 亲民主得票_2019 / (亲民主得票_2019 + 亲建制得票_2019) * 100
gen d2_亲民主得票_ratio_two = 亲民主得票_ratio_2019_two  - 亲民主得票_ratio_2015_two 

gen 亲建制得票_ratio_2015 = 亲建制得票_2015 / 总票数_2015 * 100
gen 亲建制得票_ratio_2019 = 亲建制得票_2019 / 总票数_2019 * 100
gen d2_亲建制得票_ratio = 亲建制得票_ratio_2019 - 亲建制得票_ratio_2015

gen 中立得票_ratio_2019 = 100 - 亲民主得票_ratio_2019 - 亲建制得票_ratio_2019
gen 中立得票_ratio_2015 = 100 - 亲民主得票_ratio_2015 - 亲建制得票_ratio_2015
gen d2_中立得票_ratio = 中立得票_ratio_2019 - 中立得票_ratio_2015

gen 中立得票_2019 = (总票数_2019 - (亲民主得票_2019 + 亲建制得票_2019) ) / 选民人数_2019 *100
gen 中立得票_2015 = (总票数_2015 - (亲民主得票_2015 + 亲建制得票_2015) ) / 选民人数_2015 *100
gen d2_中立得票 = 中立得票_2019 - 中立得票_2015

gen d2_亲民主得票 = 亲民主得票_2019/选民人数_2019 * 100 - 亲民主得票_2015/选民人数_2015 * 100 
gen d2_亲建制得票 = 亲建制得票_2019/选民人数_2019 * 100 - 亲建制得票_2015/选民人数_2015 * 100 

***************** Potential Robustness: Use 2011
gen d2_民主当选_lag = 民主当选_2015 - 民主当选_2011
gen d2_投票率_lag = (投票率_2015 - 投票率_2011) * 100

gen 亲民主得票_ratio_2011 = 亲民主得票_2011 / 总票数_2011 * 100
gen d2_亲民主得票_lag = 亲民主得票_ratio_2015 - 亲民主得票_ratio_2011

gen 亲建制得票_ratio_2011 = 亲建制得票_2011 / 总票数_2011 * 100
gen d2_亲建制得票_ratio_lag = 亲建制得票_ratio_2015 - 亲建制得票_ratio_2011

gen 中立得票_ratio_2011 = 100 - 亲民主得票_ratio_2011 - 亲建制得票_ratio_2011
gen d2_中立得票_ratio_lag = 中立得票_ratio_2015 - 中立得票_ratio_2011

***************** Heterogeneity: For population density

gen density = t_pop_2016 / Area_Sqkm /1000
sum density, detail
gen density_high = .
replace density_high = 1 if density > 75.59215
replace density_high = 0 if density < 75.59215
gen density_median_high = .
replace density_median_high = 1 if density > 68.2045 
replace density_median_high = 0 if density < 68.2045 

***************** For the last part: Population Outflow
*foreach var of varlist pm* {
*	replace `var' = 0 if `var' == .
*}

gen tpop_stay_2021 = pm_samearea_2021 + pm_same_2021
gen tpop_stay_2016 = pm_samearea_2016 + pm_same_2016

gen stay_grow = ( (tpop_stay_2021 - tpop_stay_2016) / ( (tpop_stay_2016 + tpop_stay_2021) * 0.5 ) ) * 100

save "$clean_data\Final.dta", replace

!del "$clean_data\Prelim\*.dta"