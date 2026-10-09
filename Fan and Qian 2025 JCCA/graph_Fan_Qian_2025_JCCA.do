**************************************************************************
*********Stata codes used to produce Figure 2*****************************
/* Fan, Wen, & Qian, Yue. (2025). Economic Risks and Mental Health During China's 2020 COVID-19 Outbreak: A Mixed-Methods Approach. Journal of Current Chinese Affairs. https://doi.org/10.1177/18681026251392281
*/
**************************************************************************

/*
Stata packages coefplot and cleanplots need to be installed to produce the graphs
coefplot - https://repec.sowi.unibe.ch/stata/coefplot/
cleanplots - https://www.trentonmize.com/software/cleanplots
*/

cd "/Users/yueqian/Downloads"
capture log close

global date 06012024
log using "graph_Fan_Qian_2025_JCCA", text

// #0
// program setup
version 17.0
clear all
set more off

// #1
// open data
clear
use regsample, clear

// predict insecurity
global control i.female age ib4.edu ruralhk party health i.marw2 i.covid i.incw1

logit insecure i.hubei i.wkunit
outreg2 using "$date insecurity", excel dec(3) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +)
 
logit insecure i.hubei i.wkunit $control
outreg2 using "$date insecurity", excel dec(3) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +)
margins, dydx(hubei)
margins wkunit
forvalues v = 2/3{
	test 1.wkunit = `v'.wkunit	
}
test 2.wkunit = 3.wkunit	

margins hubei wkunit, post
estimate store job

// predict income loss
logit incloss i.hubei i.wkunit
outreg2 using "$date insecurity", excel dec(3) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +)
 
logit incloss i.hubei i.wkunit $control
outreg2 using "$date insecurity", excel dec(3) alpha(0.001, 0.01, 0.05, 0.1) symbol(***, **, *, +)
margins, dydx(hubei)
margins wkunit
forvalues v = 2/3{
	test 1.wkunit = `v'.wkunit	
}
test 2.wkunit = 3.wkunit	

margins hubei wkunit, post
estimate store inc

coefplot job, bylabel("Predicted probability of job insecurity") ///
	|| inc, bylabel("Predicted probability of income loss") ///
	||, vertical ///
	recast(bar) barwidth(0.5) color(gs0*.5) ///
	citop citype(logit) ciopt(recast(rcap) lcolor(gs0)) ///
	mlabel mlabcolor(gs0) format(%9.2f) mlabposition(2) ///
	yscale(range(0 .6)) ylabel(0(.1).6) ///
	xlabel(1 `""Non-Hubei" "residents""' 2 `""Hubei" "residents""' ///
	4 `""State" "sector""' 5 `""Private" "sector"' 6 `""Self-" "employment""') ///
	groups(?.hubei = "{bf:Hubei}" ?.wkunit = "{bf:Danwei}") byopts(compact cols(1))
graph export "Figure 2.pdf"


log close
exit
