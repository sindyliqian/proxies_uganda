
* Experimental Evidence on the Long-Run Impact of Community Based Monitoring
* American Economic Journal: Applied Economics

clear all
set more off
capture log close

cd "/Users/ma.2557/Dropbox/Documents/CRCCL2/AEJ_AppliedEcon/Replication files/Dataset/"


********************************************************** 
*** TABLE 4: PROGRAM IMPACT ON BIRTH AND PREGNANCIES *****
**********************************************************

* First, create a dataset to use for regressions

use "sec7_birth_preg.dta", replace

**** Pregnancy since 2006:

egen nr_pregnancies=rownonmiss(s7_3 s7_6 s7_9)
replace nr_pregnancies=1 if nr_pregnancies==0 & s7_1==3

**** Birth since 2006: 
tab s7_4 if sample1==1
tab s7_7 if sample1==1
tab s7_10 if sample1==1
gen s7_4new=s7_4
replace s7_4new=. if s7_4==88 | s7_4==77
gen s7_7new=s7_7
replace s7_7new=. if s7_7==88 | s7_7==77
gen s7_10new=s7_10
replace s7_10new=. if s7_10==88 | s7_10==77

egen birth06=rowtotal( s7_4new s7_7new s7_10new) if s7_4new!=. | s7_7new!=. | s7_10new!=.
replace birth06=0 if birth06==.

sort hhcode 

*collapse data at household level
collapse sample1 treatment year hfcode dcode (sum) nrbirth=birth06 nrpregnancies=nr_pregnancies, by(hhcode)

sort hhcode 
save birth_preg_hh.dta, replace

*add households with no women in fertile age to the dataset (section 7 only includes women in fertile age so need to add the other households to get complete dataset including full sample!)
use hh_PIPendl.dta, clear
count if year==2009
count if year==2009 & sample1==1
count if year==2009 & sample1==0
keep  hhcode hfcode dcode year treatment sample1
sort hhcode
save hhsample_2009.dta, replace

merge hhcode using birth_preg_hh.dta

replace nrbirth=0 if _merge==1
replace nrpregnancies=0 if _merge==1
drop _merge

*collapse data at health facility level
*average # of births per household during the period
collapse sample1 treatment year dcode (mean) nrpregnancies nrbirth , by(hfcode)

*adjusted for correct time period of the project: 
*2006-2009=3.58 years - T50
*2007-2009=2.33 years - T25

gen nrbirth_year=nrbirth/3.58 if sample1==1
replace nrbirth_year=nrbirth/2.33 if sample1==0

gen nrpregnancies_year=nrpregnancies/3.58 if sample1==1
replace nrpregnancies_year=nrpregnancies/2.33 if sample1==0

sort year hfcode
save "birth_preg_hf.dta", replace


******** REGRESSIONS ************

use "birth_preg_hf.dta", clear

* PANEL A AND B:

areg nrpregnancies_year treatment if sample1==1, robust abs(dcode)
areg nrpregnancies_year treatment if sample1==0, robust abs(dcode)

areg nrbirth_year treatment if sample1==1, robust abs(dcode)
areg nrbirth_year treatment if sample1==0, robust abs(dcode)

bys sample1 treatment: sum nrpregnancies_year nrbirth_year  if year==2009



* PANEL C: SHORT-RUN IMPACT INFORMATION AND PARTICIPATION EXPERIMENT (REPORTED IN POWER TO THE PEOPLE, 2009, QJE) *

use "births_2006.dta", clear

* Panel C
areg nrbirth treatment if sample1==1 & year==2006, abs(dcode) robust

sort year hfcode
append using "birth_preg_hf.dta"
sort year hfcode


*** adding 2005+(2006-2009)
bys hfcode: egen nrbirthLR=sum(nrbirth)
replace nrbirthLR=. if year==2006

*adjusting for correct time period project has been running: 
*2006-2009=4.58 years - T50
*2007-2009=2.33 years - T25

gen nrbirthLR_year=nrbirthLR/4.58 if sample1==1 & year==2009
replace nrbirthLR_year=nrbirthLR/2.33 if sample1==0 & year==2009
replace nrbirthLR_year=nrbirth if sample1==1 & year==2006

sort year hfcode

gen sample1_t=sample1*treatment
gen SR=(sample1==1 & year==2006) | (sample1==0 & year==2009)
gen LR=(sample1==1 & year==2009) | (sample1==0 & year==2009)

gen dcode1=100+dcode
replace dcode1=0 if sample1==1
replace dcode=0 if dcode==.
replace dcode1=0 if dcode1==.

sort year hfcode
merge year hfcode using "birth_preg_hf.dta"
sort hfcode
drop _merge

** PANEL C: COMPARISON I&P vs. P
* can not run this on nr_pregnancies because we did not collect that data in 2006. 

merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 
drop _merge

gen charge2= avg_charge_gentreat^2
gen op2= avgOP_baseline ^2
gen hhs2=hhs^2
sort year hfcode
save birth_preg_hf0609.dta, replace


* Panel C, column (i)
reg nrbirthLR_year treatment sample1 sample1_t i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2 if SR==1,  cluster(hfcode) 
reg nrbirthLR_year treatment sample1 sample1_t i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2 if LR==1,  robust

save birth_preg_hf0609.dta, replace
