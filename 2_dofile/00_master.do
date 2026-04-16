cap log close
set more off
clear all

global root "E:\OneDrive - Syracuse University\E盘\Google Drive\Hong Kong"
global raw_data 0_raw_data
global clean_data 1_clean_data
global program 2_dofile
global output 3_output

cd "$root"

*******************************************************************************
*                        1. Clean and Merge the Dataset                       *
*******************************************************************************

** Clean the Data
do "$program\01_clean_data.do"

*******************************************************************************
*                   2. Set Up the Regression Specification                    *
*******************************************************************************

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

********************* I then define the instrument variables and dependent variables
global Treatment log_Events_Count_1124
global Instrument2 log_NumofBusStop log_NumofXiaobaStop log_MinimumDistancetoMTRStation 
global Instrument4 log_NumofTotalStops log_MinimumDistancetoMTRStation 

*******************************************************************************
*                       3. Do All The Table Files                             *
*******************************************************************************

do "$program\Final Codes\Table 1 Summary Statistics.do"
do "$program\Final Codes\Table 2 OLS Turnout.do"
do "$program\Final Codes\Table 3 Local Information.do"
do "$program\Final Codes\Table 4 First Stage.do"
do "$program\Final Codes\Table 5 Second Stage.do"
do "$program\Final Codes\Table 6 IV Robust.do"
do "$program\Final Codes\Table 7 Vote Share.do"
do "$program\Final Codes\Table 8 Stay Growth.do"

do "$program\Final Codes\Table B1 Robustness Check.do"
do "$program\Final Codes\Table B2 Redistricting.do"
do "$program\Final Codes\Table B3 Cluster Std.do"
do "$program\Final Codes\Table B4 Summary by 2015 Election.do"
do "$program\Final Codes\Table B5 Local Information Buffer.do"
do "$program\Final Codes\Table B6 Summary by Events.do"
do "$program\Final Codes\Table B7 Balance Test.do"
do "$program\Final Codes\Table B8 IV Robustness Combined.do"
do "$program\Final Codes\Table B9 Turnout Subsample.do"
do "$program\Final Codes\Table B10 Vote Share Subsample.do"

*******************************************************************************
*                       4. Do All The Figure Files                            *
*******************************************************************************

** Figures 1 and 2 are already made by Matlab and ArcGIS, the remaining are the following
do "$program\Final Codes\Figure 3 Subsample Vote Share.do"

** Figure B1 is made by Matlab.
do "$program\Final Codes\Figure B2 Summary Scatter Plot.do"
do "$program\Final Codes\Figure B3 Placebo Protest.do"
do "$program\Final Codes\Figure B4 Drop One DC.do"
do "$program\Final Codes\Figure B5 IV Scatter.do"
do "$program\Final Codes\Figure B6 IV Robustness.do"
do "$program\Final Codes\Figure B7 Conley (2012).do"

** Figure B8 is made by ArcGIS.
