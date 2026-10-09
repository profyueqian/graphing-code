**************************************************************************
*********Stata codes used to produce Figure 2*****************************
/* Qian, Yue, & Sayer, Liana C. (2022). Gender and Educational Variation in How Temporal Dimensions of Paid Work Affect Parental Child Care Time. Socius, 8. https://doi.org/10.1177/23780231221132383

Full replication package for this study is available at https://osf.io/7cu6v/
*/
**************************************************************************

/*
Stata packages coefplot and cleanplots need to be installed to produce the graphs
coefplot - https://repec.sowi.unibe.ch/stata/coefplot/
cleanplots - https://www.trentonmize.com/software/cleanplots
*/

cd "/Users/yueqian/Desktop"
log using "graph_Qian_Sayer_2022_Socius", text

// #0
// program setup
version 16.1
clear all
set more off
matrix drop _all
set linesize 120

***********************************************************************
**************************svyset data**********************************
***********************************************************************  

/* 
information sources:
Nielsen, R. B. & Seay, M. C. (2014). ATUS complex sample specification for SAS and Stata. Technical
note, Department of Housing and Consumer Economics, University of Georgia, Athens, GA.
https://drive.google.com/file/d/0B4rt_j6NBtDQa09xbXRwOFdhSDg/edit?resourcekey=0-onDOCDNNPt-FeNHK04X3Kw
https://cps.ipums.org/cps/repwt.shtml 
*/
use regsample, clear
tab year, m
svyset [pweight=lvwt], sdrweight(rlvwt_1-rlvwt_160) vce(sdr)

* define macro
global control "ib2.wkhr i.spousepres age i.race4 i.prof_manag kid agec i.weekend i.year i.summer"
global predictor "ib3.access3 i.shift i.wkwkend3 i.inflex i.shortnotice i.col"

***********************************************************************
**************************margins & figure 1***************************
*********************************************************************** 

**figure 1A
svy, subpop(reg_female): reg educare $predictor $control ///
		shift#col
margins shift, subpop(if reg_female==1) at(col=0) atmeans post
estimates store f0_educare

svy, subpop(reg_female): reg educare $predictor $control ///
		shift#col
margins shift, subpop(if reg_female==1) at(col=1) atmeans post
estimates store f1_educare

graph set window fontface "Times New Roman"
coefplot 	(f0_educare, label("Less than BA") msymbol(o) mlcolor(gs0) mfcolor(gs16) ciopt(color(gs0)) mlabel mlabcolor(gs0) mlabposition(12)) ///
			(f1_educare, label("BA or above") msymbol(o) mlcolor(gs8) mfcolor(gs8) ciopt(color(gs8)) mlabel mlabcolor(gs8) mlabposition(12)), ///
			||, title("1A: Type of Work Shift") format(%5.2f) ylabel(1 "A regular day shift" 2 "A regular evening/night shift" 3 "Other shifts", notick) ///
			xtitle("Mothers' Developmental Child Care Time (Minutes)", size(small)) yscale(noline) xlabel(0 30 60 90 120) legend(position(6) rows(1) region(lcolor(black))) 
graph save "F1A"


**figure 1B
svy, subpop(reg_female): reg educare $predictor $control ///
		wkwkend3#col
margins wkwkend3, subpop(if reg_female==1) at(col=0) atmeans post
estimates store f2_educare

svy, subpop(reg_female): reg educare $predictor $control ///
		wkwkend3#col
margins wkwkend3, subpop(if reg_female==1) at(col=1) atmeans post
estimates store f3_educare

coefplot 	(f2_educare, label("Less than BA") msymbol(o) mlcolor(gs0) mfcolor(gs16) ciopt(color(gs0)) mlabel mlabcolor(gs0) mlabposition(12)) ///
			(f3_educare, label("BA or above") msymbol(o) mlcolor(gs8) mfcolor(gs8) ciopt(color(gs8)) mlabel mlabcolor(gs8) mlabposition(12)), ///
			||, title("1B: Usual Days Worked") format(%5.2f) ylabel(1 "Work on weekdays only" 2 "Work on weekends" 3 "Usual days worked vary", notick) ///
			xtitle("Mothers' Developmental Child Care Time (Minutes)", size(small)) yscale(noline) xlabel(0 30 60 90 120) legend(position(6) rows(1) region(lcolor(black))) 
graph save "F1B"


**figure 1
graph combine F1A.gph F1B.gph, col(2)
graph export "graph_Qian_Sayer_2022_Socius_Figure1.pdf"


***********************************************************************
**************************margins & figure 2***************************
*********************************************************************** 

**figure 2A
svy, subpop(reg_male): reg routine $predictor $control ///
		shift#col
margins shift, subpop(if reg_male==1) at(col=0) atmeans post
estimates store m0_routine

svy, subpop(reg_male): reg routine $predictor $control ///
		shift#col
margins shift, subpop(if reg_male==1) at(col=1) atmeans post
estimates store m1_routine

coefplot 	(m0_routine, label("Less than BA") msymbol(o) mlcolor(gs0) mfcolor(gs16) ciopt(color(gs0)) mlabel mlabcolor(gs0) mlabposition(12)) ///
			(m1_routine, label("BA or above") msymbol(o) mlcolor(gs8) mfcolor(gs8) ciopt(color(gs8)) mlabel mlabcolor(gs8) mlabposition(12)), ///
			||, title("2A: Type of Work Shift") format(%5.2f) ylabel(1 "A regular day shift" 2 "A regular evening/night shift" 3 "Other shifts", notick) ///
			xtitle("Fathers' Routine Child Care Time (Minutes)") yscale(noline) xlabel(0 30 60 90 120) legend(position(6) rows(1) region(lcolor(black))) 
graph save "F2A"	


**figure 2B
svy, subpop(reg_male): reg routine $predictor $control ///
		shortnotice#col
margins shortnotice, subpop(if reg_male==1) at(col=0) atmeans post
estimates store m2_routine

svy, subpop(reg_male): reg routine $predictor $control ///
		shortnotice#col
margins shortnotice, subpop(if reg_male==1) at(col=1) atmeans post
estimates store m3_routine

coefplot (m2_routine, label("Less than BA") msymbol(o) mlcolor(gs0) mfcolor(gs16) ciopt(color(gs0)) mlabel mlabcolor(gs0) mlabposition(12)) ///
			(m3_routine, label("BA or above") msymbol(o) mlcolor(gs8) mfcolor(gs8) ciopt(color(gs8)) mlabel mlabcolor(gs8) mlabposition(12)), ///
			||, title("2B: Advance Notice of Work Schedules") format(%5.2f) ylabel(1 "At least two-weeks advanced notice" 2 "Less than two-weeks advanced notice", notick) ///
			xtitle("Fathers' Routine Child Care Time (Minutes)") yscale(noline) xlabel(0 30 60 90 120) legend(position(6) rows(1) region(lcolor(black))) 
graph save "F2B"


**figure 2
graph combine F2A.gph F2B.gph, col(2)		
graph export "graph_Qian_Sayer_2022_Socius_Figure2.pdf"
		

log close
exit
