**************************************************************************
*********Stata codes used to produce Table 3 and Table 4******************
/* Qian, Yue, & Qian, Zhenchao. (2017). Assortative mating by education and hukou in Shanghai. Chinese Sociological Review, 49(3), 239-262. https://doi.org/10.1080/21620555.2017.1288066
*/
**************************************************************************

// #0
// program setup
version 14.0
clear all
set more off
macro drop _all
set linesize 80

// #2
// log-linear models
keep pid hhk whk hedu3 wedu3
contract hhk whk hedu3 wedu3, zero freq(count)

gen eduhomo = hedu3==wedu3	
tab hedu3 wedu3 [w=eduhomo], m
gen hkhomo = hhk==whk
tab hhk whk [w=hkhomo], m
glm count i.hhk##i.hedu3 i.whk##i.wedu3 eduhomo hkhomo, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df=e(df)
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic	
	
	
gen shanghaihk = 0
replace shanghaihk = hedu3 if hhk==1 & whk==0
replace shanghaihk = wedu3 if hhk==0 & whk==1
	
gen nonhk = 0
replace nonhk = wedu3 if hhk==1 & whk==0
replace nonhk = hedu3 if hhk==0 & whk==1	
	
glm count i.hhk i.whk i.hedu3 i.wedu3 hhk#hedu3 whk##wedu3 i.hkhomo i.eduhomo shanghaihk nonhk, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df=e(df)
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic
	
	
gen shanghaih = 0
replace shanghaih = hedu3 if hhk==1 & whk==0

gen shanghaiw = 0
replace shanghaiw = wedu3 if hhk==0 & whk==1
	
gen nonh = 0
replace nonh = hedu3 if hhk==0 & whk==1

gen nonw = 0
replace nonw = wedu3 if hhk==1 & whk==0
	
glm count i.hhk i.whk i.hedu3 i.wedu3 hhk#hedu3 whk##wedu3 i.hkhomo i.eduhomo shanghaih shanghaiw nonh nonw, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df=e(df)
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic	
	
test shanghaih = shanghaiw
test nonh = nonw	


gen exhyper = 0
replace exhyper = 1 if hhk==1 & whk==0 & wedu3 > hedu3
replace exhyper = 1 if hhk==0 & whk==1 & hedu3 > wedu3

gen exhypo = 0
replace exhypo = 1 if hhk==1 & whk==0 & wedu3 < hedu3
replace exhypo = 1 if hhk==0 & whk==1 & hedu3 < wedu3

glm count i.hhk i.whk i.hedu3 i.wedu3 hhk#hedu3 whk##wedu3 i.hkhomo i.eduhomo exhyper exhypo, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df=e(df)
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic


gen exhyper_shh = 0
replace exhyper_shh = 1 if hhk==1 & whk==0 & wedu3 > hedu3

gen exhyper_shw = 0
replace exhyper_shw = 1 if hhk==0 & whk==1 & hedu3 > wedu3

gen exhypo_shh = 0
replace exhypo_shh = 1 if hhk==1 & whk==0 & wedu3 < hedu3

gen exhypo_shw = 0
replace exhypo_shw = 1 if hhk==0 & whk==1 & hedu3 < wedu3

glm count i.hhk i.whk i.hedu3 i.wedu3 hhk#hedu3 whk##wedu3 i.hkhomo i.eduhomo exhyper_shh exhyper_shw exhypo_shh exhypo_shw, family(poisson) link(log)
    gen dev=e(deviance)
    display dev

    gen df=e(df)
    display df

    egen totfreq=sum(count)
    gen lnfreq=ln(totfreq)
    gen bic = dev-df*lnfreq

    tab bic
    drop dev-bic	
	
test exhyper_shh = exhyper_shw
test exhypo_shh = exhypo_shw	

log close
exit
