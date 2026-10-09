cd "/Users/yueqian/Desktop"
log using "table_Qian_Qian_2023_JEMS", text

**************************************************************************
*********Stata codes used to produce Table 3 and Table 4******************
/* Qian, Zhenchao, & Qian, Yue. (2023). Generation, education, and intermarriage of Asian Americans. Journal of Ethnic and Migration Studies, 46(24), 2880–2895. https://doi.org/10.1080/1369183X.2019.1585006
*/
**************************************************************************

/*
Stata package desmat needs to be installed to run log-linear models
The command desmat can be obtained by typing search dm73_3 in the command line
*/

// #0
// program setup
version 14.0
clear all
set more off
matrix drop _all
set linesize 120


// #1
// open data
clear
use "count data", clear

/*
How were count data and assortative mating variables generated?

* convert couple-level data to count data
contract yr0515 r4_1 r4_2 ed1 ed2, zero freq(count)
tab count, m

rename r4_1 h
rename r4_2 w
*** note: h = 1 first generation asian; h = 2 second generation asian; h = 3 third generation asian; h = 4 white
*** w: same coding for wives' generational status
*** ed1 husband's edu
*** ed2 wife's edu

gen c = 0
replace c = 1 if (h<2 & w>=2) | (w<2 & h>=2)
replace c = 2 if (h<3 & w>=3) | (w<3 & h>=3)
replace c = 3 if (h<4 & w>=4) | (w<4 & h>=4)
label var c "nativity crossings"

gen nhyper = h>w
label var nhyper "husband more native than wife"	

gen eduhomo = ed1==ed2
label var eduhomo "edu homogamy"	

gen educol = ed1==2 & ed2==2
label var educol "both college"

saveold "count data"
*/


// #2
// log-linear models - Table 3
** model 1: marginal
desmat: glm count yr0515 h w ed1 ed2 h*ed1 w*ed2, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df= $S_2
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic
	
** model 2: add nativity crossings
desmat: glm count yr0515 h w ed1 ed2 h*ed1 w*ed2 c, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df= $S_2
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic		

** model 3: add gender asymmetry in generational pairing
desmat: glm count yr0515 h w ed1 ed2 h*ed1 w*ed2 c nhyper, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df= $S_2
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic		
	
** model 4: nativity crossings + educol (both spouses are college graduates)
desmat: glm count yr0515 h w ed1 ed2 h*ed1 w*ed2 c educol, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df= $S_2
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic	
	
** model 5: marginal distributions of nativity vary by year
desmat: glm count yr0515 h w ed1 ed2 h*ed1 w*ed2 c educol yr0515*h yr0515*w, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df= $S_2
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic

** model 6: nativity crossings vary by year
desmat: glm count yr0515 h w ed1 ed2 h*ed1 w*ed2 c educol yr0515*h yr0515*w yr0515*c, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df= $S_2
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic	

** model 7: marginal distributions of education vary by year
desmat: glm count yr0515 h w ed1 ed2 h*ed1 w*ed2 c educol yr0515*h yr0515*w ///
					yr0515*ed1 yr0515*ed2, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df= $S_2
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic

** model 8: educol vary by year
desmat: glm count yr0515 h w ed1 ed2 h*ed1 w*ed2 c educol yr0515*h yr0515*w ///
					yr0515*ed1 yr0515*ed2 yr0515*educol, family(poisson) link(log)
	gen dev=e(deviance)
    display dev

    gen df= $S_2
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic		
	
** model 9: nativity crossings vary by educational pairings
desmat: glm count yr0515 h w ed1 ed2 h*ed1 w*ed2 yr0515*h yr0515*w yr0515*ed1 yr0515*ed2 ///
					c educol c*educol, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df= $S_2
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic	

** model 10: nativity crossings * educational pairings * year
desmat: glm count yr0515 h w ed1 ed2 h*ed1 w*ed2 yr0515*h yr0515*w yr0515*ed1 yr0515*ed2 ///
					c educol c*educol*yr0515, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df= $S_2
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic		

// #3
// log-linear models - Table 4
** model 7: marginal distributions of education vary by year
glm count i.yr0515 i.h i.w i.ed1 i.ed2 h#ed1 w#ed2 yr0515#h yr0515#w yr0515#ed1 yr0515#ed2 ///
			i.c i.educol, family(poisson) link(log)

** model 9: nativity crossings vary by educational pairings
glm count i.yr0515 i.h i.w i.ed1 i.ed2 h#ed1 w#ed2 yr0515#h yr0515#w yr0515#ed1 yr0515#ed2 ///
			i.c i.educol ///
			c#educol, family(poisson) link(log)

** model 10: nativity crossings * educational pairings * year
glm count i.yr0515 i.h i.w i.ed1 i.ed2 h#ed1 w#ed2 yr0515#h yr0515#w yr0515#ed1 yr0515#ed2 ///
			i.c i.educol ///
			c#yr0515 educol#yr0515 c#educol ///
			c#educol#yr0515, family(poisson) link(log)
			
log close
exit
