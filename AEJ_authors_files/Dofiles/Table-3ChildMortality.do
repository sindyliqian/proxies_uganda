
* Experimental Evidence on the Long-Run Impact of Community Based Monitoring
* American Economic Journal: Applied Economics

clear all
set more off
capture log close

cap cd "/Users/ma.2557/Dropbox/Documents/CRCCL2/AEJ_AppliedEcon/Replication files/Dataset/"

****************************************************
*** TABLE 3: PROGRAM IMPACT ON CHILD MORTALITY *****
****************************************************

* First, create a dataset for calculating the mortality results

use "sec-8-children-u5-died", clear
drop if  s8b24==.
gen birth_monthyr=s8b24 
rename s8b23 childname
rename s8b25 gender
rename s8b27 death_yr
rename s8b26 death_month
rename s8b24_yr birth_yr
rename s8b24_month birth_month
generate death=1
save "temp.dta", replace

use "sec-8-children-u5.dta", clear
destring s84, replace
drop if s84==.
gen birth_monthyr=s84 
rename s83 childname
rename s85 gender
rename s84_month birth_month
rename s84_yr birth_yr
append using "temp.dta"
replace death=0 if death==.
sort hhcode

*** 1. define date of birth (and death) according to the CMC standard (CMC=century month code; the number of the month since the start of the century)
gen bdate=(birth_yr-1900)*12+birth_month  
gen ddate=(death_yr-1900)*12+death_month 
gen age_death=ddate-bdate

*** 2. create a variable error=1 if child died died before born
gen error=(age_death<0)
tab error

gen error1=1 if death_month==18 
replace error1=1 if death_month==24

*** 3. make adjustment according to DHS recommendations for error=1 

generate death_yr1=death_yr
	replace death_yr1=birth_yr if error==1
generate death_month1=death_month
	replace death_month1=birth_month if error==1
	
generate birth_yr1=birth_yr
	replace birth_yr1=death_yr if error1==1
	replace death_month1=birth_month if error1==1 
	
gen ddate1=(death_yr1-1900)*12+death_month1
gen bdate1=(birth_yr1-1900)*12+birth_month
  
	replace ddate=. if (error==1 | error1==1)
	replace ddate= ddate1 if (error==1 | error1==1)	// 11 changes if selected
	replace bdate= bdate1 if (error==1 | error1==1)	// 2 changes if selected
	replace age_death=ddate1-bdate1 if (error==1 | error1==1) // 11 changes if selected  

*** 4. Replace birthdate end of survey when coded after survey

replace bdate=1315 if bdate==1318
replace bdate=1315 if bdate==1319
replace bdate=1315 if bdate==1320

	
save "allchildren_deadalive.dta", replace


******* REGRESSIONS ***********

*** PANEL A: DEATH RATE ESTIMATES FOR INFORMATION AND PARTICIPATION EXPERIMENT 2006-2009

drop if death_yr1<2006

gen death_inf=death
replace death_inf=. if age_death>12 &  age_death<60

gen death_neo=death
replace death_neo=. if age_death>0 &  age_death<60

gen exposure= 1 + min(1315, ddate) - max(1273, bdate)

gen exposure_inf=1+ddate-bdate if bdate>1261 & ddate>1272 & age_death<12
replace exposure_inf=min(12,1316-bdate) if bdate>1272 & ddate>1272 & death==0
replace exposure_inf=11-1272+bdate if bdate>1261 & bdate<1273 & death==0

gen births=1 if bdate>1272 & bdate<1315

gen exp_y=exposure/12
gen exp_inf_y=exposure_inf/12

* Exposure corrected mortality rates (individual data) 2006-2009

poisson death treatment i.dcode if sample1==1, exposure(exp_y) cluster(hfcode) irr  /* in the text in the paper */
poisson death_inf treatment i.dcode if sample1==1, exposure(exp_inf_y) cluster(hfcode) irr /* in the text in the paper */

collapse dcode treatment sample1 (sum) death death_inf death_neo births exposure exposure_inf exp_y exp_inf_y, by(hfcode)

* Crude death results 2006-2009 (3.58 years of data)
* Adjust for the correct time period of the data
gen death_year=death/3.58
gen death_inf_year=death_inf/3.58
gen death_neo_year=death_neo/3.58

* Panel A column i *
sum death_year if treatment==0 & sample1==1
areg death_year treatment if sample1==1, a(dcode) robust 

* Panel A column ii *
sum death_inf_year if treatment==0 & sample1==1
areg death_inf_year treatment if sample1==1, a(dcode) robust 

* Panel A column iii *
sum death_neo_year if treatment==0 & sample1==1
areg death_neo_year treatment if sample1==1, a(dcode) robust


* Exposure corrected mortality rates (cluster level data) 2006-2009

* Panel A column iv *
gen exp_y1000=exp_y/1000
poisson death treatment i.dcode if sample1==1, exposure(exp_y1000) robust irr
gen death_exp=death/exp_y1000
areg death_exp treatment if sample1==1, a(dcode) robust 
sum death_exp if treatment==0 & sample1==1

* Panel A column v *
gen exp_inf_y1000=exp_inf_y/1000
poisson death_inf treatment i.dcode if sample1==1, exposure(exp_inf_y1000) robust irr
gen death_inf_exp=death_inf/exp_inf_y1000
areg death_inf_exp treatment if sample1==1, a(dcode) robust
sum death_inf_exp if treatment==0 & sample1==1

* Panel A column vi *
gen neo_mr=death_neo/(births/1000)
areg neo_mr treatment  if sample1==1, robust a(dcode)
sum neo_mr if treatment==0 & sample1==1
sum neo_mr if treatment==1 & sample1==1

rename sample1 exp
drop if exp==0
save "did1.dta", replace


*** PANEL B: DEATH RATE ESTIMATES FOR PARTICIPATION EXPERIMENT 2007-2009
	
use "allchildren_deadalive.dta", clear

drop if death_yr1<2007
gen death_inf=death
replace death_inf=0 if age_death>12 &  age_death<60
gen death_neo=death
replace death_neo=0 if age_death>0 &  age_death<60
gen exposure= 1 + min(1315, ddate) - max(1285, bdate)
gen exposure_inf=1+ddate-bdate if bdate>1273 & ddate>1284 & age_death<12
replace exposure_inf=min(12,1316-bdate) if bdate>1284 & ddate>1284 & death==0
replace exposure_inf=11-1284+bdate if bdate>1273 & bdate<1285 & death==0
gen exp_y=exposure/12
gen exp_inf_y=exposure_inf/12
gen births=1 if bdate>1284 & bdate<1315


* Exposure corrected mortality rates (individual data) 2006-2009

poisson death treatment i.dcode if sample1==0, exposure(exp_y) cluster(hfcode) irr  /* in the text in the paper */
poisson death_inf treatment i.dcode if sample1==0, exposure(exp_inf_y) cluster(hfcode) irr /* in the text in the paper */


collapse dcode treatment sample1 (sum) death death_inf death_neo births exposure exposure_inf exp_y exp_inf_y, by(hfcode)

* Crude death results 2007-2009 (2.33 years of data)
gen death_year=death/2.33
gen death_inf_year=death_inf/2.33
gen death_neo_year=death_neo/2.33


* Panel B column i *
sum death_year if treatment==0 & sample1==0
areg death_year treatment if sample1==0, a(dcode) robust 

* Panel B column ii *
sum death_inf_year if treatment==0 & sample1==0
areg death_inf_year treatment if sample1==0, a(dcode) robust

* Panel B column iii *
sum death_neo_year if treatment==0 & sample1==0
areg death_neo_year treatment if sample1==0, a(dcode) robust


* Exposure corrected mortality rates (cluster level data) 2006-2009

* Panel B column iv *
gen exp_y1000=exp_y/1000
poisson death treatment i.dcode if sample1==0, exposure(exp_y1000) robust irr 
gen death_exp=death/exp_y1000
areg death_exp treatment if sample1==0, a(dcode) robust
sum death_exp if treatment==0 & sample1==0

* Panel B column v *
gen exp_inf_y1000=exp_inf_y/1000
poisson death_inf treatment i.dcode if sample1==0, exposure(exp_inf_y1000) robust irr 
gen death_inf_exp=death_inf/exp_inf_y1000
areg death_inf_exp treatment if sample1==0, a(dcode) robust
sum death_inf_exp if treatment==0 & sample1==0

* Panel B column vi *
gen neo_mr=death_neo/(births/1000)
areg neo_mr treatment  if sample1==0, robust a(dcode) 
sum neo_mr if treatment==0 & sample1==0
sum neo_mr if treatment==1 & sample1==0

rename sample1 exp
drop if exp==1

save "p0709.dta", replace


* PANEL C: SHORT-RUN IMPACT INFORMATION AND PARTICIPATION EXPERIMENT (REPORTED IN POWER TO THE PEOPLE, 2009, QJE) *

use "childmortality_2006data.dta", clear

* Crude death results 2005

areg death treatment, a(dcode) robust  /* table 3C column i */
areg death_inf treatment, a(dcode) robust /* table 3C column ii */


* Exposure corrected mortality rates (cluster level data) 2005

gen exp_y1000=exp_y/1000
poisson death treatment i.dcode, exposure(exp_y1000) robust irr   /* table 3C column iv */ 
gen death_exp=death/exp_y1000

gen exp_inf_y1000=exp_inf_y/1000
poisson death_inf treatment i.dcode, exposure(exp_inf_y1000) robust irr   /* table 3C column v */
gen death_inf_exp=death_inf/exp_inf_y1000

gen exp=1
save "did2.dta", replace


* merging all three mortality measures to compare them in Panel C

use "did1.dta", clear

append using "p0709.dta"

save "did1a.dta", replace

use "p0709.dta", clear

keep hfcode dcode treatment death death_inf death_neo neo_mr exposure exposure_inf exp_y exp_inf_y exp_y1000 death_exp exp_inf_y1000 death_inf_exp exp

save "temp1.dta", replace

use "did2.dta", clear

append using "temp1.dta"

save "did2a.dta", replace


** Panel C: COMPARISON I&P vs. P

merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 
drop _merge

gen charge2= avg_charge_gentreat^2
gen op2= avgOP_baseline ^2
gen hhs2=hhs^2

gen exp_t=exp*treatment

gen death_y=death

replace death_y=death/2.33 if exp==0

gen dcode1=100+dcode
replace dcode1=0 if exp==1

* I&P(SR) vs. P(SR)

* Panel C column i
areg death_y exp t exp_t i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2, a(dcode) robust 

* Panel C column iv
areg death_exp exp t exp_t i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2 , a(dcode) robust

gen death_inf_y=death_inf
replace death_inf_y=death_inf/2.33 if exp==0

* Panel C column ii
areg death_inf_y exp t exp_t i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2, a(dcode) robust 

* Panel C column v
areg death_inf_exp exp t exp_t i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2 , a(dcode) robust 


* I&P(LR) vs. P(SR)

** Aggregating 2005+2006-2009

use "did2.dta", clear

rename death death05
rename death_inf death_inf05
rename exp_y exp_y05
rename exp_inf_y exp_inf_y05

merge m:1  hfcode using  "did1.dta", keepusing(death death_inf exp_y exp_inf_y) 
drop _merge

drop exp exp_y1000 exp_inf_y1000 death_exp death_inf_exp


gen deathT=death+death05
gen death_infT=death_inf+death_inf05

gen deathT_year=deathT/4.58
gen deathT_inf_year=death_infT/4.58

sum deathT_year if treatment==1
sum deathT_year if treatment==0

sum deathT_inf_year if treatment==1
sum deathT_inf_year if treatment==0

gen exp_y1000=(exp_y+exp_y05)/1000
gen death_exp=deathT/exp_y1000

gen exp_inf_y1000=(exp_inf_y+exp_inf_y05)/1000
gen death_inf_exp=death_infT/exp_inf_y1000

drop death05 death_inf05 death_neo exposure exposure_inf exp_y05 exp_inf_y05 death death_inf exp_y exp_inf_y

rename deathT death
rename death_infT death_inf
rename deathT_year death_year
rename deathT_inf_year death_inf_year

gen exp=1

save "agg.dta", replace

use "p0709.dta", clear

drop death_neo births exposure exposure_inf exp_y exp_inf_y death_neo_year neo_mr 

save "temp4.dta", replace

use "agg.dta", clear

append using "temp4.dta"

gen exp_t=exp*treatment
gen dcode1=100+dcode
replace dcode1=0 if exp==1

merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 
drop _merge

gen charge2= avg_charge_gentreat^2
gen op2= avgOP ^2
gen hhs2=hhs^2

* Panel C column i
areg death_y exp t exp_t i.dcode1 avg_charge_gentreat avgOP hhs charge2 op2 hhs2, a(dcode) robust

* Panel C column ii 
areg death_inf_y exp t exp_t i.dcode1 avg_charge_gentreat avgOP hhs charge2 op2 hhs2, a(dcode) robust 

* Panel C column iv 
areg death_exp exp t exp_t i.dcode1 avg_charge_gentreat avgOP hhs charge2 op2 hhs2 , a(dcode) robust

* Panel C column v
areg death_inf_exp exp t exp_t i.dcode1 avg_charge_gentreat avgOP hhs charge2 op2 hhs2 , a(dcode) robust


