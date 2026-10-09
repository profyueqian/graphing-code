**************************************************************************
*********Stata codes used to produce Figure 1, Figure 2, and Figure 3*****
/* Qian, Yue, Glauber, Rebecca, & Yavorsky, Jill E. (2023). COVID‐19 job loss and re‐employment among partnered parents: Gender and educational variations. Journal of Marriage and Family, 85(5), 1138-1152. https://doi.org/10.1111/jomf.12927
*/
**************************************************************************

/*
Stata packages coefplot and cleanplots need to be installed to produce the graphs
coefplot - https://repec.sowi.unibe.ch/stata/coefplot/
cleanplots - https://www.trentonmize.com/software/cleanplots
*/

cd "/Users/yueqian/Desktop"
log using "graph_Qian_et_al_2023_JMF", text

// #0
// program setup
version 17.0
clear all
set more off
matrix drop _all
set linesize 120

**************************************************************************
************************** Figure 1 - re-employment***********************
**************************************************************************

// #1
// open data for Figure 1
clear
use "reg_sample_reemp.dta"

// #2
// define macro for Figure 1
global controls "lnprior_occwage i.mar i.edup i.prior_wkhr i.empt1 duration age i.race4 i.kidunder5 i.year i.month" 	

// #3
// regression for Figure 1
**** overall (no interaction with education)
svy: melogit emp i.par4 i.col || cpsidp: 
margins, dydx(par4)
* p = 0.000
margins par4, predict(mu) post
estimates store m0

* adding prior job gender composition and spouse's employment 
svy: melogit emp i.par4 i.col $controls ib3.sphr i.prior_occseg || cpsidp:
margins, dydx(par4)
* p = 0.119
margins par4, predict(mu) post
estimates store m4


**** interaction with education
svy: melogit emp i.par4 i.col par4#col || cpsidp:
estimates store m0_2 
margins, dydx(par4) at(col=0)
* p = 0.000
margins, dydx(par4) at(col=1)
* p = 0.266
margins par4, at(col=0) predict(mu) post
estimates store m0_20

estimates restore m0_2
margins par4, at(col=1) predict(mu) post
estimates store m0_21

* adding prior job gender composition and spouse's employment 
svy: melogit emp i.par4 i.col par4#col $controls ib3.sphr i.prior_occseg || cpsidp:
estimates store m8 
margins, dydx(par4) at(col=0)
* p = 0.005
margins, dydx(par4) at(col=1)
* p = 0.282
margins par4, at(col=0) predict(mu) post
estimates store m80

estimates restore m8
margins par4, at(col=1) predict(mu) post
estimates store m81

// #4
// graph Figure 1
coefplot m0, bylabel("Overall") ///
	|| m0_20, bylabel("Less than BA") ///
	|| m0_21, bylabel("BA or above") ///
	||, msymbol(o) mlcolor(gs0) mfcolor(gs16) ciopt(color(gs0) recast(rcap)) ///
	byopts(cols(3) title("Panel A: baseline models without controls")) mlabel mlabcolor(gs0) mlabposition(12) format(%9.2f) ///
	xlabel(0(0.05)0.25) xscale(range(0 .20)) 
addplot 1: , note("p = 0.000") norescaling	
addplot 2: , note("p = 0.000") norescaling	
addplot 3: , note("p = 0.266") norescaling	
graph save "reemp1.gph"

coefplot m4, bylabel("Overall") ///
	|| m80, bylabel("Less than BA") ///
	|| m81, bylabel("BA or above") ///
	||, msymbol(o) mlcolor(gs0) mfcolor(gs16) ciopt(color(gs0) recast(rcap)) ///
	byopts(cols(3) title("Panel B: full models with all controls")) mlabel mlabcolor(gs0) mlabposition(12) format(%9.2f) ///
	xlabel(0(0.05)0.25) xscale(range(0 .20)) 
addplot 1: , note("p = 0.119") norescaling	
addplot 2: , note("p = 0.005") norescaling	
addplot 3: , note("p = 0.282") norescaling	
graph save "reemp2.gph"

graph combine "reemp1.gph" "reemp2.gph", col(1) b1title("Predicted probability of re-employment", size(small))
graph export "graph_Qian_et_al_2023_JMF_Figure1.pdf"


**************************************************************************
************************** Figure 2 - wage********************************
**************************************************************************

// #5
// open data for Figure 2 & Figure 3
clear
use "reg_sample_wage.dta", clear

* clear macro / stored estimates
macro drop _all
estimates clear

// #6
// define macro for Figure 2 & Figure 3
global controls "lnprior_occwage i.mar i.edup i.prior_wkhr i.empt1 duration age i.kidunder5 i.race4 i.year i.month" 	   

// #7
// regression for Figure 2
**** overall (no interaction with education)
gsem lnoccwage <- i.par4 i.col ///
	[pw=wtfinl], vce(cluster cpsidp)
margins, dydx(par4) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2)))
* p = 0.000
margins par4, expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2))) post
estimates store m0

* adding prior job gender composition and spouse's employment 
gsem lnoccwage <- i.par4 i.col $controls ib3.sphr i.occseg ///
	[pw=wtfinl], vce(cluster cpsidp)
margins, dydx(par4) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2)))
* p = 0.462
margins par4, expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2))) post
estimates store m4


**** interaction with education
gsem lnoccwage <- i.par4 i.col par4#col ///
	[pw=wtfinl], vce(cluster cpsidp)
estimates store m0_2 
margins, dydx(par4) at(col=0) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2)))
* p = 0.000
margins, dydx(par4) at(col=1) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2)))
* p = 0.020
margins par4, at(col=0) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2))) post
estimates store m0_20

estimates restore m0_2
margins par4, at(col=1) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2))) post
estimates store m0_21

* adding prior job gender composition and spouse's employment 
gsem lnoccwage <- i.par4 i.col par4#col $controls ib3.sphr i.occseg ///
	[pw=wtfinl], vce(cluster cpsidp)
estimates store m8 
margins, dydx(par4) at(col=0) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2)))
* p = 0.839
margins, dydx(par4) at(col=1) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2)))
* p = 0.154
margins par4, at(col=0) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2))) post
estimates store m80

estimates restore m8
margins par4, at(col=1) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2))) post
estimates store m81

// #8
// graph Figure 2
coefplot m0, bylabel("Overall") ///
	|| m0_20, bylabel("Less than BA") ///
	|| m0_21, bylabel("BA or above") ///
	||, msymbol(o) mlcolor(gs0) mfcolor(gs16) ciopt(color(gs0) recast(rcap)) ///
	byopts(cols(3) title("Panel A: baseline models without controls")) mlabel mlabcolor(gs0) mlabposition(12) format(%9.2f) ///
	xlabel(20(5)45, format(%9.0f)) xscale(range(20 45))
addplot 1: , note("p = 0.000") norescaling	
addplot 2: , note("p = 0.000") norescaling	
addplot 3: , note("p = 0.020") norescaling	
graph save "wage1.gph"
	
coefplot m4, bylabel("Overall") ///
	|| m80, bylabel("Less than BA") ///
	|| m81, bylabel("BA or above") ///
	||, msymbol(o) mlcolor(gs0) mfcolor(gs16) ciopt(color(gs0) recast(rcap)) ///
	byopts(cols(3) title("Panel B: full models with all controls")) mlabel mlabcolor(gs0) mlabposition(12) format(%9.2f) ///
	xlabel(20(5)45, format(%9.0f)) xscale(range(20 45))
addplot 1: , note("p = 0.462") norescaling	
addplot 2: , note("p = 0.839") norescaling	
addplot 3: , note("p = 0.154") norescaling	
graph save "wage2.gph"	

graph combine "wage1.gph" "wage2.gph", col(1) b1title("Job-level wage", size(small))
graph export "graph_Qian_et_al_2023_JMF_Figure2.pdf"

**************************************************************************
************************** Figure 3 - wage (excluding segregation)********
**************************************************************************

// #9
// regression for Figure 3
**** overall (no interaction with education)
gsem lnoccwage <- i.par4 i.col $controls ib3.sphr ///
	[pw=wtfinl], vce(cluster cpsidp)
margins, dydx(par4) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2)))
* p = 0.001
margins par4, expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2))) post
estimates store m2


**** interaction with education
gsem lnoccwage <- i.par4 i.col par4#col $controls ib3.sphr ///
	[pw=wtfinl], vce(cluster cpsidp)
estimates store m6 
margins, dydx(par4) at(col=0) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2)))
* p = 0.013
margins, dydx(par4) at(col=1) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2)))
* p = 0.021
margins par4, at(col=0) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2))) post
estimates store m60

estimates restore m6
margins par4, at(col=1) expression(exp(predict(eta))*(exp((_b[/var(e.lnoccwage)])/2))) post
estimates store m61

// #10
// graph Figure 3
coefplot m2, bylabel("Overall") ///
	|| m60, bylabel("Less than BA") ///
	|| m61, bylabel("BA or above") ///
	||, msymbol(o) mlcolor(gs0) mfcolor(gs16) ciopt(color(gs0) recast(rcap)) ///
	byopts(cols(3) title("Panel A: models excluding job-level gender composition")) mlabel mlabcolor(gs0) mlabposition(12) format(%9.2f) ///
	xlabel(20(5)45, format(%9.0f)) xscale(range(20 45))
addplot 1: , note("p = 0.001") norescaling	
addplot 2: , note("p = 0.013") norescaling	
addplot 3: , note("p = 0.021") norescaling	
graph save "wage3.gph"

graph combine "wage3.gph" "wage2.gph", col(1) b1title("Job-level wage", size(small))
graph export "graph_Qian_et_al_2023_JMF_Figure3.pdf"


log close
exit
