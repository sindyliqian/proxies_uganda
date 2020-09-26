


* Experimental Evidence on the Long-Run Impact of Community Based Monitoring
* American Economic Journal: Applied Economics

clear all
set more off
capture log close

cd "/Users/ma.2557/Dropbox/Documents/CRCCL2/AEJ_AppliedEcon/Replication files/Dataset/"


**********************************
***** APPENDIX *******************
**********************************

**************************************
************* TABLE A.3 **************
**************************************

* Household utilization *

use "hhutil_PIPendl.dta", clear

egen tot_hfx=rowtotal(s1b6) if s1b3>=15
egen tot_STTH=rowtotal(s1b13 s1b14) if s1b3>=15

collapse (mean) dcode vcode  hfcode treatment sample1 year (sum) tot_medicalvisit  tot_hfx tot_STTH, by(hhcode)

gen  hfx_ratio= tot_hfx/tot_medicalvisit if tot_medicalvisit!=0
*label var STTH_ratio "HHratio adults self treated or trad healer"

gen  STTH_ratio= tot_STTH/tot_medicalvisit if tot_medicalvisit!=0

*** The person had 0 visits to the provider if he went nowhere in the last 3 month ***
replace hfx_ratio=0 if  tot_medicalvisit==0
replace STTH_ratio =0 if  tot_medicalvisit==0

sort year hhcode
save "hhutil_endl1.dta", replace


* PANEL A:

** The two providers: Government Health facility (hfx) that were part of the project and Self-treatment and Traditional Healer (STTH)
xi i.dcode
mysureg (hfx_ratio treatment _Idcode_2- _Idcode_11) (STTH_ratio treatment _Idcode_2- _Idcode_11) if sample1==1, vce(robust)
sum hfx_ratio STTH_ratio if sample1==1 & treatment==0
lincom (0.5/.2614116)*[ hfx_ratio]treatment - (0.5/.0688354)*[STTH_ratio]treatment

* PANEL B:

mysureg (hfx_ratio treatment _Idcode_2- _Idcode_11) (STTH_ratio treatment _Idcode_2- _Idcode_11) if sample1==0, vce(robust)
sum hfx_ratio STTH_ratio if sample1==0 & treatment==0
lincom (0.5/.2825369)*[ hfx_ratio]treatment - (0.5/.0576942)*[STTH_ratio]treatment


* PANEL C:

*** short-run results I&P with district fixed effects
use "hhdata_PI2006.dta", clear
xi i.dcode
mysureg (hfx_ratio treatment _Idcode_2- _Idcode_11) (STTH_ratio treatment _Idcode_2- _Idcode_11), vce(robust)
sum hfx_ratio STTH_ratio if treatment==0
lincom (0.5/.28)*[ hfx_ratio]treatment - (0.5/.30)*[STTH_ratio]treatment

sort year hhcode
merge year hhcode using hhutil_endl1.dta
drop _merge
sort year hfcode
save hhutil_all.dta, replace


merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 
drop _merge

gen charge2= avg_charge_gentreat^2
gen op2= avgOP_baseline ^2
gen hhs2=hhs^2
sort year hhcode


** DIFFERENTIAL EFFECT I&P(SR) vs. P(SR)

rename STTH_ratio stth_ratio

gen sample1_t=sample1*treatment

gen SR=(sample1==1 & year==2006) | (sample1==0 & year==2009)
gen LR=(sample1==1 & year==2009) | (sample1==0 & year==2009)

gen dcode1=100+dcode
replace dcode1=0 if sample1==1
replace dcode=0 if dcode==.
replace dcode1=0 if dcode1==.

gsem ( hfx_ratio <-  treatment sample1 sample1_t i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (stth_ratio <-  treatment sample1 sample1_t treatment i.dcode i.dcode1  avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) if SR==1, vce(robust) nocapslatent
sum hfx_ratio stth_ratio if SR==1 & treatment==0 & sample1==1
sum hfx_ratio stth_ratio if SR==1 & treatment==0 & sample1==0
lincom ((0.50/.2791844)*[hfx_ratio]treatment+(0.50/.2791844)*[hfx_ratio]sample1_t-(0.50/.2955248)*[stth_ratio]treatment+(0.50/.2955248)*[stth_ratio]sample1_t)-((0.50/ .2825369)*[hfx_ratio]treatment-(0.50/.0576942)*[stth_ratio]treatment)


** DIFFERENTIAL EFFECT I&P(LR) vs. P(SR)
gsem ( hfx_ratio <-  treatment sample1 sample1_t i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) ( stth_ratio <-  treatment sample1 sample1_t treatment i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) if LR==1, vce(robust)
sum hfx_ratio stth_ratio if LR==1 & treatment==0 & sample1==1
sum hfx_ratio stth_ratio if LR==1 & treatment==0 & sample1==0
lincom ((0.50/.2614116)*[hfx_ratio]treatment+(0.50/.2614116)*[hfx_ratio]sample1_t-(0.50/.0688354 )*[stth_ratio]treatment+(0.50/.0688354 )*[stth_ratio]sample1_t)-((0.50/.2825369)*[hfx_ratio]treatment-(0.50/.0576942)*[stth_ratio]treatment)
