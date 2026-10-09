**************************************************************************
*********Stata codes used to produce Figure 1 and Figure 2****************
/* Tian, Felicia F., & Qian, Yue. (2022). Migration policies on migrant–native marriage: A multilevel analysis of 43 Chinese cities. Population, Space and Place, 28(4), e2524. https://doi.org/10.1002/psp.2524
*/
**************************************************************************

/*
Stata package cleanplots needs to be installed to produce the graphs
cleanplots - https://www.trentonmize.com/software/cleanplots
*/

cd "/Users/yueqian/Desktop"
log using "graph_Tian_Qian_2022_PSP", text

// #0
// program setup
version 14.2
clear all
set more off
matrix drop _all
set linesize 120


**************************************************************************
************************** Figure 1 - migrant men ************************
**************************************************************************

// #1
// open data for Figure 1
clear
use "regsample_men.dta", clear

// #2
// graph Figure 1
gen int1 = me2*mbar
gen int2 = me3*mbar

*https://stats.idre.ucla.edu/stata/faq/how-can-i-compute-predictive-margins-for-xtmelogit-with-random-effects/
meqrlogit inter me2 me3 mbar mexpo msexr mgdp mrank1 mrank3 int1 int2 mage murbanhk mwork mlninc mhan rentpri rentpub housoth || h0: me2 me3
matrix list e(b)	
predict re*, reffects	
describe re1 re2

tempvar rxb0 rxb1 rxb2 p0 p1 p2
generate `rxb0' = .    // initialize temp var
generate `rxb1' = .    // initialize temp var
generate `rxb2' = .    // initialize temp var
generate `p0' = .      // initialize temp var
generate `p1' = .      // initialize temp var  
generate `p2' = .      // initialize temp var
matrix m = J(22,1,0)    // initialize matrix for me1
matrix f = J(22,1,0)    // initialize matrix for me2
matrix z = J(22,1,0)    // initialize matrix for me3

local i = 1            // initialize local macro

foreach j of numlist 0.08 0.2(0.2)3.0 3.18 {
	
quietly replace `rxb0' = (_b[me2]+re1)*0 + (_b[me3]+re2)*0 + (_b[mbar])*`j' + (_b[mexpo])*mexpo + (_b[msexr])*msexr + (_b[mgdp])*mgdp + (_b[mrank1])*mrank1 + (_b[mrank3])*mrank3 ///
						+ (_b[int1])*0*`j' + (_b[int2])*0*`j' ///
						+ (_b[mage])*mage + (_b[murbanhk])*murbanhk + (_b[mwork])*mwork + (_b[mlninc])*mlninc + (_b[mhan])*mhan ///
						+ (_b[rentpri])*rentpri + (_b[rentpub])*rentpub + (_b[housoth])*housoth ///
						+ (_b[_cons]+re3)
						
quietly replace `rxb1' = (_b[me2]+re1)*1 + (_b[me3]+re2)*0 + (_b[mbar])*`j' + (_b[mexpo])*mexpo + (_b[msexr])*msexr + (_b[mgdp])*mgdp + (_b[mrank1])*mrank1 + (_b[mrank3])*mrank3 ///
						+ (_b[int1])*1*`j' + (_b[int2])*0*`j' ///
						+ (_b[mage])*mage + (_b[murbanhk])*murbanhk + (_b[mwork])*mwork + (_b[mlninc])*mlninc + (_b[mhan])*mhan ///
						+ (_b[rentpri])*rentpri + (_b[rentpub])*rentpub + (_b[housoth])*housoth ///
						+ (_b[_cons]+re3)
						
quietly replace `rxb2' = (_b[me2]+re1)*0 + (_b[me3]+re2)*1 + (_b[mbar])*`j' + (_b[mexpo])*mexpo + (_b[msexr])*msexr + (_b[mgdp])*mgdp + (_b[mrank1])*mrank1 + (_b[mrank3])*mrank3 ///
						+ (_b[int1])*0*`j' + (_b[int2])*1*`j' ///
						+ (_b[mage])*mage + (_b[murbanhk])*murbanhk + (_b[mwork])*mwork + (_b[mlninc])*mlninc + (_b[mhan])*mhan ///
						+ (_b[rentpri])*rentpri + (_b[rentpub])*rentpub + (_b[housoth])*housoth ///
						+ (_b[_cons]+re3)
						
quietly replace `p0' = exp(`rxb0')/(1+exp(`rxb0'))
quietly sum `p0'
matrix m[`i',1] = r(mean)

quietly replace `p1' = exp(`rxb1')/(1+exp(`rxb1'))
quietly sum `p1'
matrix f[`i',1] = r(mean)

quietly replace `p2' = exp(`rxb2')/(1+exp(`rxb2'))
quietly sum `p2'
matrix z[`i',1] = r(mean)
local i = `i' + 1      // increment local macro
}

matrix list m
matrix r = (0.08\.2\.4\.6\.8\1.0\1.2\1.4\1.6\1.8\2.0\2.2\2.4\2.6\2.8\3.0\3.18)
svmat r
svmat m
svmat f
svmat z
list r1 m1 f1 z1 in 1/17
twoway (line m1 r1, lpattern(solid) lcolor(gs8)) ///
		(line f1 r1, lpattern(dash) lcolor(black)) ///
		(line z1 r1, lpattern(shortdash_dot) lcolor(black)), ///
		graphregion(color(white)) ///
		title("Migrant Men") ytitle("Probability of Intermarriage") xtitle("The City's Entry Barrier (CEB) Index") ///	
		ylabel(0(.05).45, grid labsize(vsmall)) legend(order(1 "<high school" 2 "High school" 3 "college or above")) ///
		xla(0(0.2)3.2, format(%9.1f))
graph export "graph_Tian_Qian_2022_PSP_Figure1.pdf"



**************************************************************************
************************** Figure 2 - migrant women **********************
**************************************************************************

// #3
// open data for Figure 2
clear
use "regsample_women.dta", clear

// #2
// graph Figure 2
gen int1 = fe2*fbar
gen int2 = fe3*fbar

*https://stats.idre.ucla.edu/stata/faq/how-can-i-compute-predictive-margins-for-xtmelogit-with-random-effects/
meqrlogit inter fe2 fe3 fbar fexpo fsexr fgdp frank1 frank3 int1 int2 fage furbanhk fwork flninc fhan rentpri rentpub housoth || h0: fe2 fe3
matrix list e(b)	
predict re*, reffects	
describe re1 re2

tempvar rxb0 rxb1 rxb2 p0 p1 p2
generate `rxb0' = .    // initialize temp var
generate `rxb1' = .    // initialize temp var
generate `rxb2' = .    // initialize temp var
generate `p0' = .      // initialize temp var
generate `p1' = .      // initialize temp var  
generate `p2' = .      // initialize temp var
matrix m = J(22,1,0)    // initialize matrix for fe1
matrix f = J(22,1,0)    // initialize matrix for fe2
matrix z = J(22,1,0)    // initialize matrix for fe3

local i = 1            // initialize local macro

foreach j of numlist 0.08 0.2(0.2)3.0 3.18 {
	
quietly replace `rxb0' = (_b[fe2]+re1)*0 + (_b[fe3]+re2)*0 + (_b[fbar])*`j' + (_b[fexpo])*fexpo + (_b[fsexr])*fsexr + (_b[fgdp])*fgdp + (_b[frank1])*frank1 + (_b[frank3])*frank3 ///
						+ (_b[int1])*0*`j' + (_b[int2])*0*`j' ///
						+ (_b[fage])*fage + (_b[furbanhk])*furbanhk + (_b[fwork])*fwork + (_b[flninc])*flninc + (_b[fhan])*fhan ///
						+ (_b[rentpri])*rentpri + (_b[rentpub])*rentpub + (_b[housoth])*housoth ///
						+ (_b[_cons]+re3)
						
quietly replace `rxb1' = (_b[fe2]+re1)*1 + (_b[fe3]+re2)*0 + (_b[fbar])*`j' + (_b[fexpo])*fexpo + (_b[fsexr])*fsexr + (_b[fgdp])*fgdp + (_b[frank1])*frank1 + (_b[frank3])*frank3 ///
						+ (_b[int1])*1*`j' + (_b[int2])*0*`j' ///
						+ (_b[fage])*fage + (_b[furbanhk])*furbanhk + (_b[fwork])*fwork + (_b[flninc])*flninc + (_b[fhan])*fhan ///
						+ (_b[rentpri])*rentpri + (_b[rentpub])*rentpub + (_b[housoth])*housoth ///
						+ (_b[_cons]+re3)
						
quietly replace `rxb2' = (_b[fe2]+re1)*0 + (_b[fe3]+re2)*1 + (_b[fbar])*`j' + (_b[fexpo])*fexpo + (_b[fsexr])*fsexr + (_b[fgdp])*fgdp + (_b[frank1])*frank1 + (_b[frank3])*frank3 ///
						+ (_b[int1])*0*`j' + (_b[int2])*1*`j' ///
						+ (_b[fage])*fage + (_b[furbanhk])*furbanhk + (_b[fwork])*fwork + (_b[flninc])*flninc + (_b[fhan])*fhan ///
						+ (_b[rentpri])*rentpri + (_b[rentpub])*rentpub + (_b[housoth])*housoth ///
						+ (_b[_cons]+re3)
						
quietly replace `p0' = exp(`rxb0')/(1+exp(`rxb0'))
quietly sum `p0'
matrix m[`i',1] = r(mean)

quietly replace `p1' = exp(`rxb1')/(1+exp(`rxb1'))
quietly sum `p1'
matrix f[`i',1] = r(mean)

quietly replace `p2' = exp(`rxb2')/(1+exp(`rxb2'))
quietly sum `p2'
matrix z[`i',1] = r(mean)
local i = `i' + 1      // increment local macro
}

matrix list m
matrix r = (0.08\.2\.4\.6\.8\1.0\1.2\1.4\1.6\1.8\2.0\2.2\2.4\2.6\2.8\3.0\3.18)
svmat r
svmat m
svmat f
svmat z
list r1 m1 f1 z1 in 1/17
twoway (line m1 r1, lpattern(solid) lcolor(gs8)) ///
		(line f1 r1, lpattern(dash) lcolor(black)) ///
		(line z1 r1, lpattern(shortdash_dot) lcolor(black)), ///
		graphregion(color(white)) ///
		title("Migrant Women") ytitle("Probability of Intermarriage") xtitle("The City's Entry Barrier (CEB) Index") ///	
		ylabel(0(.05).45, grid labsize(vsmall)) legend(order(1 "<high school" 2 "High school" 3 "college or above")) ///
		xla(0(0.2)3.2, format(%9.1f))
graph export "graph_Tian_Qian_2022_PSP_Figure2.pdf"

log close
exit
