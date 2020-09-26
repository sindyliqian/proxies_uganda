

* Experimental Evidence on the Long-Run Impact of Community Based Monitoring
* American Economic Journal: Applied Economics

clear all
set more off
capture log close

cd "/Users/ma.2557/Dropbox/Documents/CRCCL2/AEJ_AppliedEcon/Replication files/Dataset/"


*******************************************************************
**** TABLE 5: PROGRAM IMPACT ON WEIGHT AND LENGTH OF CHILDREN *****
*******************************************************************


**** WEIGHT FOR AGE Z-SCORES **********

use "sec8_weightheight.dta", clear

** generating a dataset with cort97 (growth chart by Cortinovis et.al (1997) to exclude outliers) - see footnote for more informaiton **

gen gender=s85
gen months=s821a
sort gender months 
save "sec8_weightheight_cort97.dta", replace
merge gender months using cort97w.dta
drop _merge
save "sec8_weightheight_cort97wh.dta", replace
sort months
merge months using cort97h.dta
drop _merge
save "sec8_weightheight_cort97wh.dta", replace

egen zw1=zanthro(s821b,wa,US), xvar(s821a) gender (s85) gencode(male=1, female=0) ageunit(month)

save "weight_height_cort97.dta", replace


********* REGRESSIONS ***********

use "weight_height_cort97.dta", clear

*** Column (i): Children 0-12 months ***

bys treatment: sum zw1 if  s821a<13 & zw1>-4.5 & zw1<4.5 &   s821b<cort97 & sample1==1
areg   zw1 treatment if  s821a<13 & zw1>-4.5 & zw1<4.5 &  s821b<cort97 & sample1==1, a(dcode) cluster(hfcode)

bys treatment: sum zw1 if  s821a<13 & zw1>-4.5 & zw1<4.5 &   s821b<cort97 & sample1==0
areg   zw1 treatment if  s821a<13 & zw1>-4.5 & zw1<4.5 &   s821b<cort97 & sample1==0, a(dcode) cluster(hfcode)


*** Column (ii):  Children 13-59 months ***

bys treatment: sum zw1 if  s821a>12 & zw1>-4.5 & zw1<4.5 &  s821b<cort97 & sample1==1
areg   zw1 treatment if  s821a>12 & zw1>-4.5 & zw1<4.5 &  sample1==1, a(dcode) cluster(hfcode)

bys treatment: sum zw1 if  s821a>12 & zw1>-4.5 & zw1<4.5 &  s821b<cort97 & sample1==0
areg   zw1 treatment if  s821a>12 & zw1>-4.5 & zw1<4.5 & sample1==0, a(dcode) cluster(hfcode)

keep zw1 treatment gender s821a s821b cort97 sample1 dcode hfcode hhcode 


*** FIGURE 4:
graph twoway kdensity zw1 if sample1==1 &  s821a<13 & zw1>-4.5 & zw1<4.5 & s821b<cort97 & treatment==0, clpattern(dash) width(.46) xline(-0.69, lpattern(dash)) xline(-0.46)  || kdensity zw1 if sample1==1 & s821a<13 & zw1>-4.5 & zw1<4.5 & s821b<cort97 & treatment==1, width(.33) legend(label(1 "Control group") label(2 "Treatment group"))  xtitle("z scores") ytitle("density") ylabel(,nogrid)

gen year=2009
rename zw1 zw
rename s821a age_months
rename s821b weight
sort year hhcode hfcode
save weight.dta, replace


* PANEL C: SHORT-RUN IMPACT INFORMATION AND PARTICIPATION EXPERIMENT (REPORTED IN POWER TO THE PEOPLE, 2009, QJE) *
*use "/Users/ma.2557/Dropbox/Documents/3ie replication folder_feb2015/Data/final/crc2006_s8q12_gender_ctrls", clear

use weight_2006data.dta, clear
* Without controls here (different from QJE). Note that we omit observations with a recorded
* weight above the 90th percentile in the growth chart reported in Cortinovis et al.(1997); i.e. exclude if
* weight>12kg.

* column i:
areg zw treatment if s8q12a<18 & s8q12b<12, a(dcode) cluster(hfcode)

* column ii:
areg zw treatment if s8q12a>18, a(dcode) cluster(hfcode)

sort hfcode
save weight_2006data.dta, replace
merge hfcode using hfdcode.dta
drop _merge

keep zw treatment  s8q12a s8q12b hfcode hhcode dcode
rename s8q12a age_months
rename s8q12b weight
gen year=2006
gen treatment1=treatment
gen sample1=1
sort year hhcode hfcode

append using weight.dta

gen sample1_t=sample1*treatment

gen SR=(sample1==1 & year==2006) | (sample1==0 & year==2009)
gen LR=(sample1==1 & year==2009) | (sample1==0 & year==2009)

gen dcode1=100+dcode
replace dcode1=0 if sample1==1
replace dcode=0 if dcode==.
replace dcode1=0 if dcode1==.


sort year hhcode hfcode 
save weight.dta, replace


** PANEL C: COMPARISON I&P vs. P
use weight.dta, clear
sort hfcode
save weight.dta, replace
 
merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 
drop _merge

gen charge2= avg_charge_gentreat^2
gen op2= avgOP_baseline ^2
gen hhs2=hhs^2
sort year hhcode
save weight.dta, replace

*** I&P(SR) vs. P(SR)

areg zw  sample1 treatment sample1_t i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2 if SR==1 & age_months<13 & zw>-4.5 & zw<4.5 & weight<cort97, a(dcode)  cluster(hfcode)
areg zw  sample1 treatment sample1_t i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2 if SR==1 & age_months>12 &  zw>-4.5 & zw<4.5 &  weight<cort97, a(dcode)  cluster(hfcode)

*** I&P(LR) vs. P(SR)

areg zw  sample1 treatment sample1_t i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2 if LR==1 & age_months<13 &  zw>-4.5 & zw<4.5 & weight<cort97, a(dcode)  cluster(hfcode)
areg zw  sample1 treatment sample1_t i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2 if LR==1 & age_months>12 &  zw>-4.5 & zw<4.5 &  weight<cort97, a(dcode)  cluster(hfcode)



**** Column (ii): HEIGT FOR AGE **********
*can only do this for 2009 since we did not collect this data for 2006

use "weight_height_cort97.dta", clear

*** Create height-for-age measures ***

egen zha=zanthro(s821e,ha,US), xvar(s821a) gender (s85) gencode(male=1, female=0) ageunit(month)
egen zhb=zanthro(s821e,la,US), xvar(s821a) gender (s85) gencode(male=1, female=0) ageunit(month)

gen zh1=zha if  s821a>=24
replace zh1=zhb if  s821a<24

save "weight_height_cort97.dta", replace

*** Drop height above the 97 percentile for each month which is given in the variable cort97_h
use "weight_height_cort97.dta", clear

*** Age 0-12 months ***
bys treatment sample1: sum zh1 if s821a<13 & zh1>-4.5 & zh1<4.5 & s821e<cort97_h

areg  zh1 treatment if sample1==1 & s821a<13 & zh1>-4.5 & zh1<4.5 & s821e<cort97_h, a(dcode) cluster(hfcode)
areg  zh1 treatment if sample1==0 & s821a<13 & zh1>-4.5 & zh1<4.5 & s821e<cort97_h, a(dcode) cluster(hfcode)

*** Age 13-59 months ***
bys treatment sample1: sum zh1 if s821a>12 & zh1>-4.5 & zh1<4.5 & s821e<cort97_h

areg  zh1 treatment  if sample1==1 & s821a>12 & zh1>-4.5 & zh1<4.5 & s821e<cort97_h, a(dcode) cluster(hfcode)
areg  zh1 treatment  if sample1==0 & s821a>12 & zh1>-4.5 & zh1<4.5 & s821e<cort97_h, a(dcode) cluster(hfcode)


** PANEL C: COMPARISON I&P vs. P

gen sample1_t=sample1*treatment

gen dcode1=100+dcode
replace dcode1=0 if sample1==1
replace dcode=0 if dcode==.
replace dcode1=0 if dcode1==.

sort hfcode
save height.dta, replace


merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 
drop _merge

gen charge2= avg_charge_gentreat^2
gen op2= avgOP_baseline ^2
gen hhs2=hhs^2

sort hhcode
save height.dta, replace

*** I&P(SR) vs. P(SR)

*** Below 1 year (13 months) ***
areg  zh1 treatment sample1 sample1_t i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2  if  s821a<13 & zh1>-4.5 & zh1<4.5 & s821e<cort97_h, a(dcode) cluster(hfcode)

*** Above 1 year ***
areg  zh1 treatment sample1 sample1_t i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2   if  s821a>12 & zh1>-4.5 & zh1<4.5 & s821e<cort97_h, a(dcode) cluster(hfcode)


********************

******* FIGURE 5 ******

use "weight_height_cort97.dta", clear

gen exposure=s821a if s821a<60

replace exposure=48 if s821a>48 & s821a<60

areg  zh1 treatment##c.exposure if  zh1>-4.5 & zh1<4.5 & sample1==1 & s821e<cort97_h, a(dcode) cluster(hfcode)

margins, dydx(treatment) at(exposure=(10(1)48))

marginsplot, level(90) yline(0) recastci(rline)   recast(line) xtitle("Month of exposure to treatment", color(black)) ytitle("Height-for-age z-scores", color(black)) title("")


