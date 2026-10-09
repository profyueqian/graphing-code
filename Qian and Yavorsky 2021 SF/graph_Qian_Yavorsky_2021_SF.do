**************************************************************************
*********Stata codes used to produce Figure 1, Figure 2, and Figure 3*****
/*
Qian, Yue, & Yavorsky, Jill E. (2021). The under-utilization of women's talent: academic achievement and future leadership positions. Social Forces, 100(2), 564-598. https://doi.org/10.1093/sf/soaa126
*/
**************************************************************************

cd "/Users/yueqian/Desktop"
log using "graph_Qian_Yavorsky_2021_SF", text

// #0
// program setup
version 14.2
clear all
set more off
matrix drop _all
set linesize 120

* we used Stata's default graphic scheme
set scheme s2color, perm

**************************************************************************
************************** Figure 1 **************************************
**************************************************************************

clear
use regsample, clear

* Figure 1, Panel A
menbreg v2reg_numlead i.female##c.agpa || caseid_1979:, pweight(weight)
margins female, at(agpa=(-2.5(0.5)1.5)) atmeans
marginsplot, title("All") ytitle(Number of Supervisees) xtitle(High School GPA) ///	
	plot1opts(msymbol(circle) mcolor(gs8) msize(small) lpattern(solid) lcolor(gs8)) ///
	ci1opts(lpattern(solid) lcolor(gs8))  ///
	plot2opts(msymbol(triangle) mcolor(black) msize(small) lpattern(dash) lcolor(black)) ///
	ci2opts(lpattern(dash) lcolor(black)) ///
	graphregion(color(white)) ///
	ylabel(0(5)25, grid labsize(vsmall)) legend(order(1 "Men" 2 "Women")) ///
	xlabel(-2.5 "0.0" -2 "0.5" -1.5 "1.0" -1 "1.5" -0.5 "2.0" 0 "2.5" 0.5 "3.0" 1 "3.5" 1.5 "4.0")
graph export "graph_Qian_Yavorsky_2021_SF_Figure1A.pdf"

* Figure 1, Panel B, nonparents
preserve
keep if status==1
menbreg v2reg_numlead i.female##c.agpa || caseid_1979:, pweight(weight)
margins female, at(agpa=(-2.5(0.5)1.5)) atmeans
marginsplot, title("Non-parents") ytitle(Number of Supervisees) xtitle(High School GPA) ///	
	plot1opts(msymbol(circle) mcolor(gs8) msize(small) lpattern(solid) lcolor(gs8)) ///
	ci1opts(lpattern(solid) lcolor(gs8))  ///
	plot2opts(msymbol(triangle) mcolor(black) msize(small) lpattern(dash) lcolor(black)) ///
	ci2opts(lpattern(dash) lcolor(black)) ///
	graphregion(color(white)) ///
	ylabel(0(5)25, grid labsize(vsmall)) legend(order(1 "Men" 2 "Women")) ///
	xlabel(-2.5 "0.0" -2 "0.5" -1.5 "1.0" -1 "1.5" -0.5 "2.0" 0 "2.5" 0.5 "3.0" 1 "3.5" 1.5 "4.0")
graph save Graph "s_raw1.gph"
restore

* Figure 1, Panel B, parents
preserve
keep if status==2
menbreg v2reg_numlead i.female##c.agpa || caseid_1979:, pweight(weight)
margins female, at(agpa=(-2.5(0.5)1.5)) atmeans
marginsplot, title("Parents") ytitle(Number of Supervisees) xtitle(High School GPA) ///	
	plot1opts(msymbol(circle) mcolor(gs8) msize(small) lpattern(solid) lcolor(gs8)) ///
	ci1opts(lpattern(solid) lcolor(gs8))  ///
	plot2opts(msymbol(triangle) mcolor(black) msize(small) lpattern(dash) lcolor(black)) ///
	ci2opts(lpattern(dash) lcolor(black)) ///
	graphregion(color(white)) ///
	ylabel(0(5)25, grid labsize(vsmall)) legend(order(1 "Men" 2 "Women")) ///
	xlabel(-2.5 "0.0" -2 "0.5" -1.5 "1.0" -1 "1.5" -0.5 "2.0" 0 "2.5" 0.5 "3.0" 1 "3.5" 1.5 "4.0")
graph save Graph "s_raw2.gph"
restore

graph combine s_raw1.gph s_raw2.gph, graphregion(color(white))
graph export "graph_Qian_Yavorsky_2021_SF_Figure1B.pdf"


**************************************************************************
************************** Figure 2 **************************************
**************************************************************************

* Figure 2, Panel A
menbreg v2reg_numlead i.female##c.agpa ///	
	ib1.mar3 age ib1.pare5 afqt2 afqt3 afqt4 afqtm ib1.esteem5 ib1.eduexp5 health_limit health_limit_m r2 r3 r4 rm hisp black i.yr || caseid_1979:, pweight(weight)
margins female, at(agpa=(-2.5(0.5)1.5)) atmeans
marginsplot, title("All") ytitle(Number of Supervisees) xtitle(High School GPA) ///	
	plot1opts(msymbol(circle) mcolor(gs8) msize(small) lpattern(solid) lcolor(gs8)) ///
	ci1opts(lpattern(solid) lcolor(gs8))  ///
	plot2opts(msymbol(triangle) mcolor(black) msize(small) lpattern(dash) lcolor(black)) ///
	ci2opts(lpattern(dash) lcolor(black)) ///
	graphregion(color(white)) ///
	ylabel(0(2)14, grid labsize(vsmall)) legend(order(1 "Men" 2 "Women")) ///
	xlabel(-2.5 "0.0" -2 "0.5" -1.5 "1.0" -1 "1.5" -0.5 "2.0" 0 "2.5" 0.5 "3.0" 1 "3.5" 1.5 "4.0")
graph export "graph_Qian_Yavorsky_2021_SF_Figure2A.pdf"

* Figure 2, Panel B, nonparents
preserve
keep if status==1
menbreg v2reg_numlead i.female##c.agpa ///	
	ib1.mar3 age ib1.pare5 afqt2 afqt3 afqt4 afqtm ib1.esteem5 ib1.eduexp5 health_limit health_limit_m r2 r3 r4 rm hisp black i.yr || caseid_1979:, pweight(weight)
margins female, at(agpa=(-2.5(0.5)1.5) ///
               0.mar3          =    .2675928 ///
               1.mar3          =    .6082765 ///
               2.mar3          =    .1241307 ///
               age             =    31.78071 ///
               1.pare5         =    .1620859 ///
               2.pare5         =    .4434084 ///
               3.pare5         =    .3841942 ///
               5.pare5         =    .0103115 ///
               afqt2           =    .2345544 ///
               afqt3           =    .2383069 ///
               afqt4           =    .2463416 ///
               afqtm           =    .0301785 ///
               1.esteem5       =    .3069638 ///
               2.esteem5       =     .236849 ///
               3.esteem5       =    .2099753 ///
               4.esteem5       =    .2201273 ///
               5.esteem5       =    .0260845 ///
               1.eduexp5       =    .3403827 ///
               2.eduexp5       =    .1951071 ///
               3.eduexp5       =    .3225148 ///
               4.eduexp5       =    .1385753 ///
               5.eduexp5       =    .0034202 ///
               health_limit    =    .0375324 ///
               health_limit_m  =    .0120016 ///
               r2              =    .3053414 ///
               r3              =      .34044 ///
               r4              =    .1637631 ///
               rm              =    .0044751 ///
               hisp            =    .0437022 ///
               black           =    .1222089 ///
               1988.yr         =    .2504624 ///
               1989.yr         =    .2541481 ///
               1996.yr         =    .2500164 ///
               1998.yr         =    .2453731)
marginsplot, title("Non-parents") ytitle(Number of Supervisees) xtitle(High School GPA) ///	
	plot1opts(msymbol(circle) mcolor(gs8) msize(small) lpattern(solid) lcolor(gs8)) ///
	ci1opts(lpattern(solid) lcolor(gs8))  ///
	plot2opts(msymbol(triangle) mcolor(black) msize(small) lpattern(dash) lcolor(black)) ///
	ci2opts(lpattern(dash) lcolor(black)) ///
	graphregion(color(white)) ///
	ylabel(0(2)14, grid labsize(vsmall)) legend(order(1 "Men" 2 "Women")) ///
	xlabel(-2.5 "0.0" -2 "0.5" -1.5 "1.0" -1 "1.5" -0.5 "2.0" 0 "2.5" 0.5 "3.0" 1 "3.5" 1.5 "4.0")
graph save Graph "s_ad1.gph"
restore

* Figure 2, Panel B, parents
preserve
keep if status==2
menbreg v2reg_numlead i.female##c.agpa ///	
	ib1.mar3 age ib1.pare5 afqt2 afqt3 afqt4 afqtm ib1.esteem5 ib1.eduexp5 health_limit health_limit_m r2 r3 r4 rm hisp black i.yr || caseid_1979:, pweight(weight)
margins female, at(agpa=(-2.5(0.5)1.5) ///
               0.mar3          =    .2675928 ///
               1.mar3          =    .6082765 ///
               2.mar3          =    .1241307 ///
               age             =    31.78071 ///
               1.pare5         =    .1620859 ///
               2.pare5         =    .4434084 ///
               3.pare5         =    .3841942 ///
               5.pare5         =    .0103115 ///
               afqt2           =    .2345544 ///
               afqt3           =    .2383069 ///
               afqt4           =    .2463416 ///
               afqtm           =    .0301785 ///
               1.esteem5       =    .3069638 ///
               2.esteem5       =     .236849 ///
               3.esteem5       =    .2099753 ///
               4.esteem5       =    .2201273 ///
               5.esteem5       =    .0260845 ///
               1.eduexp5       =    .3403827 ///
               2.eduexp5       =    .1951071 ///
               3.eduexp5       =    .3225148 ///
               4.eduexp5       =    .1385753 ///
               5.eduexp5       =    .0034202 ///
               health_limit    =    .0375324 ///
               health_limit_m  =    .0120016 ///
               r2              =    .3053414 ///
               r3              =      .34044 ///
               r4              =    .1637631 ///
               rm              =    .0044751 ///
               hisp            =    .0437022 ///
               black           =    .1222089 ///
               1988.yr         =    .2504624 ///
               1989.yr         =    .2541481 ///
               1996.yr         =    .2500164 ///
               1998.yr         =    .2453731)
marginsplot, title("Parents") ytitle(Number of Supervisees) xtitle(High School GPA) ///	
	plot1opts(msymbol(circle) mcolor(gs8) msize(small) lpattern(solid) lcolor(gs8)) ///
	ci1opts(lpattern(solid) lcolor(gs8))  ///
	plot2opts(msymbol(triangle) mcolor(black) msize(small) lpattern(dash) lcolor(black)) ///
	ci2opts(lpattern(dash) lcolor(black)) ///
	graphregion(color(white)) ///
	ylabel(0(2)14, grid labsize(vsmall)) legend(order(1 "Men" 2 "Women")) ///
	xlabel(-2.5 "0.0" -2 "0.5" -1.5 "1.0" -1 "1.5" -0.5 "2.0" 0 "2.5" 0.5 "3.0" 1 "3.5" 1.5 "4.0")
graph save Graph "s_ad2.gph"
restore

graph combine s_ad1.gph s_ad2.gph, graphregion(color(white))
graph export "graph_Qian_Yavorsky_2021_SF_Figure2B.pdf"


**************************************************************************
************************** Figure 3 **************************************
**************************************************************************

* Figure 3, M1
preserve
keep if status==2
menbreg v2reg_numlead i.female##c.agpa ///	
	ib1.mar3 age ib1.pare5 afqt2 afqt3 afqt4 afqtm ib1.esteem5 ib1.eduexp5 health_limit health_limit_m r2 r3 r4 rm hisp black i.yr ///
	|| caseid_1979:, pweight(weight)
margins female, at(agpa=(-2.5(0.5)1.5) ///
               0.mar3          =    .2675928 ///
               1.mar3          =    .6082765 ///
               2.mar3          =    .1241307 ///
               age             =    31.78071 ///
               1.pare5         =    .1620859 ///
               2.pare5         =    .4434084 ///
               3.pare5         =    .3841942 ///
               5.pare5         =    .0103115 ///
               afqt2           =    .2345544 ///
               afqt3           =    .2383069 ///
               afqt4           =    .2463416 ///
               afqtm           =    .0301785 ///
               1.esteem5       =    .3069638 ///
               2.esteem5       =     .236849 ///
               3.esteem5       =    .2099753 ///
               4.esteem5       =    .2201273 ///
               5.esteem5       =    .0260845 ///
               1.eduexp5       =    .3403827 ///
               2.eduexp5       =    .1951071 ///
               3.eduexp5       =    .3225148 ///
               4.eduexp5       =    .1385753 ///
               5.eduexp5       =    .0034202 ///
               health_limit    =    .0375324 ///
               health_limit_m  =    .0120016 ///
               r2              =    .3053414 ///
               r3              =      .34044 ///
               r4              =    .1637631 ///
               rm              =    .0044751 ///
               hisp            =    .0437022 ///
               black           =    .1222089 ///
               1988.yr         =    .2504624 ///
               1989.yr         =    .2541481 ///
               1996.yr         =    .2500164 ///
               1998.yr         =    .2453731)
marginsplot, title("Baseline Model (M1)") ytitle(Number of Supervisees) xtitle(High School GPA) ///	
	plot1opts(msymbol(circle) mcolor(gs8) msize(small) lpattern(solid) lcolor(gs8)) ///
	ci1opts(lpattern(solid) lcolor(gs8))  ///
	plot2opts(msymbol(triangle) mcolor(black) msize(small) lpattern(dash) lcolor(black)) ///
	ci2opts(lpattern(dash) lcolor(black)) ///
	graphregion(color(white)) ///
	ylabel(0(2)14, grid labsize(vsmall)) legend(order(1 "Men" 2 "Women")) ///
	xlabel(-2.5 "0.0" -2 "0.5" -1.5 "1.0" -1 "1.5" -0.5 "2.0" 0 "2.5" 0.5 "3.0" 1 "3.5" 1.5 "4.0")
graph save Graph "s2_m1.gph"
restore

* Figure 3, M2
preserve
keep if status==2
menbreg v2reg_numlead i.female##c.agpa ///	
	ib1.mar3 age ib1.pare5 afqt2 afqt3 afqt4 afqtm ib1.esteem5 ib1.eduexp5 health_limit health_limit_m r2 r3 r4 rm hisp black i.yr ///
	stugov stugov_m ///
	|| caseid_1979:, pweight(weight)
margins female, at(agpa=(-2.5(0.5)1.5) ///
               0.mar3          =    .2675928 ///
               1.mar3          =    .6082765 ///
               2.mar3          =    .1241307 ///
               age             =    31.78071 ///
               1.pare5         =    .1620859 ///
               2.pare5         =    .4434084 ///
               3.pare5         =    .3841942 ///
               5.pare5         =    .0103115 ///
               afqt2           =    .2345544 ///
               afqt3           =    .2383069 ///
               afqt4           =    .2463416 ///
               afqtm           =    .0301785 ///
               1.esteem5       =    .3069638 ///
               2.esteem5       =     .236849 ///
               3.esteem5       =    .2099753 ///
               4.esteem5       =    .2201273 ///
               5.esteem5       =    .0260845 ///
               1.eduexp5       =    .3403827 ///
               2.eduexp5       =    .1951071 ///
               3.eduexp5       =    .3225148 ///
               4.eduexp5       =    .1385753 ///
               5.eduexp5       =    .0034202 ///
               health_limit    =    .0375324 ///
               health_limit_m  =    .0120016 ///
               r2              =    .3053414 ///
               r3              =      .34044 ///
               r4              =    .1637631 ///
               rm              =    .0044751 ///
               hisp            =    .0437022 ///
               black           =    .1222089 ///
               1988.yr         =    .2504624 ///
               1989.yr         =    .2541481 ///
               1996.yr         =    .2500164 ///
               1998.yr         =    .2453731) atmeans
marginsplot, title("M2 (M1 + Leadership in high school)") ytitle(Number of Supervisees) xtitle(High School GPA) ///	
	plot1opts(msymbol(circle) mcolor(gs8) msize(small) lpattern(solid) lcolor(gs8)) ///
	ci1opts(lpattern(solid) lcolor(gs8))  ///
	plot2opts(msymbol(triangle) mcolor(black) msize(small) lpattern(dash) lcolor(black)) ///
	ci2opts(lpattern(dash) lcolor(black)) ///
	graphregion(color(white)) ///
	ylabel(0(2)14, grid labsize(vsmall)) legend(order(1 "Men" 2 "Women")) ///
	xlabel(-2.5 "0.0" -2 "0.5" -1.5 "1.0" -1 "1.5" -0.5 "2.0" 0 "2.5" 0.5 "3.0" 1 "3.5" 1.5 "4.0")
graph save Graph "s2_m2.gph"
restore

* Figure 3, M3
preserve
keep if status==2
menbreg v2reg_numlead i.female##c.agpa ///	
	ib1.mar3 age ib1.pare5 afqt2 afqt3 afqt4 afqtm ib1.esteem5 ib1.eduexp5 health_limit health_limit_m r2 r3 r4 rm hisp black i.yr ///
	stugov stugov_m ///
	i.female##i.e3 ///
	|| caseid_1979:, pweight(weight)
margins female, at(agpa=(-2.5(0.5)1.5) ///
               0.mar3          =    .2675928 ///
               1.mar3          =    .6082765 ///
               2.mar3          =    .1241307 ///
               age             =    31.78071 ///
               1.pare5         =    .1620859 ///
               2.pare5         =    .4434084 ///
               3.pare5         =    .3841942 ///
               5.pare5         =    .0103115 ///
               afqt2           =    .2345544 ///
               afqt3           =    .2383069 ///
               afqt4           =    .2463416 ///
               afqtm           =    .0301785 ///
               1.esteem5       =    .3069638 ///
               2.esteem5       =     .236849 ///
               3.esteem5       =    .2099753 ///
               4.esteem5       =    .2201273 ///
               5.esteem5       =    .0260845 ///
               1.eduexp5       =    .3403827 ///
               2.eduexp5       =    .1951071 ///
               3.eduexp5       =    .3225148 ///
               4.eduexp5       =    .1385753 ///
               5.eduexp5       =    .0034202 ///
               health_limit    =    .0375324 ///
               health_limit_m  =    .0120016 ///
               r2              =    .3053414 ///
               r3              =      .34044 ///
               r4              =    .1637631 ///
               rm              =    .0044751 ///
               hisp            =    .0437022 ///
               black           =    .1222089 ///
               1988.yr         =    .2504624 ///
               1989.yr         =    .2541481 ///
               1996.yr         =    .2500164 ///
               1998.yr         =    .2453731) atmeans post
marginsplot, title("M3 (M2 + Educational attainment)") ytitle(Number of Supervisees) xtitle(High School GPA) ///	
	plot1opts(msymbol(circle) mcolor(gs8) msize(small) lpattern(solid) lcolor(gs8)) ///
	ci1opts(lpattern(solid) lcolor(gs8))  ///
	plot2opts(msymbol(triangle) mcolor(black) msize(small) lpattern(dash) lcolor(black)) ///
	ci2opts(lpattern(dash) lcolor(black)) ///
	graphregion(color(white)) ///
	ylabel(0(2)14, grid labsize(vsmall)) legend(order(1 "Men" 2 "Women")) ///
	xlabel(-2.5 "0.0" -2 "0.5" -1.5 "1.0" -1 "1.5" -0.5 "2.0" 0 "2.5" 0.5 "3.0" 1 "3.5" 1.5 "4.0")
graph save Graph "s2_m3.gph"
restore

* Figure 3, M4
preserve
keep if status==2
menbreg v2reg_numlead i.female##c.agpa ///	
	ib1.mar3 age ib1.pare5 afqt2 afqt3 afqt4 afqtm ib1.esteem5 ib1.eduexp5 health_limit health_limit_m r2 r3 r4 rm hisp black i.yr ///
	stugov stugov_m ///
	i.female##i.e3 ///
	lnfirmsize firm_m government ib12.ind14 ///
	reg_hrwkv3 reg_hrwk_m reg_totalwk reg_tenure_yr reg_tenure_wk_m ///
	|| caseid_1979:, pweight(weight)
margins female, at(agpa=(-2.5(0.5)1.5) ///
               0.mar3          =    .2675928 ///
               1.mar3          =    .6082765 ///
               2.mar3          =    .1241307 ///
               age             =    31.78071 ///
               1.pare5         =    .1620859 ///
               2.pare5         =    .4434084 ///
               3.pare5         =    .3841942 ///
               5.pare5         =    .0103115 ///
               afqt2           =    .2345544 ///
               afqt3           =    .2383069 ///
               afqt4           =    .2463416 ///
               afqtm           =    .0301785 ///
               1.esteem5       =    .3069638 ///
               2.esteem5       =     .236849 ///
               3.esteem5       =    .2099753 ///
               4.esteem5       =    .2201273 ///
               5.esteem5       =    .0260845 ///
               1.eduexp5       =    .3403827 ///
               2.eduexp5       =    .1951071 ///
               3.eduexp5       =    .3225148 ///
               4.eduexp5       =    .1385753 ///
               5.eduexp5       =    .0034202 ///
               health_limit    =    .0375324 ///
               health_limit_m  =    .0120016 ///
               r2              =    .3053414 ///
               r3              =      .34044 ///
               r4              =    .1637631 ///
               rm              =    .0044751 ///
               hisp            =    .0437022 ///
               black           =    .1222089 ///
               1988.yr         =    .2504624 ///
               1989.yr         =    .2541481 ///
               1996.yr         =    .2500164 ///
               1998.yr         =    .2453731) atmeans
marginsplot, title("M4 (M3 + Employment-related characteristics)") ytitle(Number of Supervisees) xtitle(High School GPA) ///	
	plot1opts(msymbol(circle) mcolor(gs8) msize(small) lpattern(solid) lcolor(gs8)) ///
	ci1opts(lpattern(solid) lcolor(gs8))  ///
	plot2opts(msymbol(triangle) mcolor(black) msize(small) lpattern(dash) lcolor(black)) ///
	ci2opts(lpattern(dash) lcolor(black)) ///
	graphregion(color(white)) ///
	ylabel(0(2)14, grid labsize(vsmall)) legend(order(1 "Men" 2 "Women")) ///
	xlabel(-2.5 "0.0" -2 "0.5" -1.5 "1.0" -1 "1.5" -0.5 "2.0" 0 "2.5" 0.5 "3.0" 1 "3.5" 1.5 "4.0")
graph save Graph "s2_m4.gph"
restore

graph combine s2_m1.gph s2_m2.gph s2_m3.gph s2_m4.gph, graphregion(color(white))
graph export "graph_Qian_Yavorsky_2021_SF_Figure3.pdf"


log close
exit
