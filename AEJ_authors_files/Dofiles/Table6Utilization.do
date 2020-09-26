 
* Experimental Evidence on the Long-Run Impact of Community Based Monitoring
* American Economic Journal: Applied Economics

clear all
set more off
capture log close

cd "/Users/ma.2557/Dropbox/Documents/CRCCL2/AEJ_AppliedEcon/Replication files/Dataset/"

************************************************
*** TABLE 6: PROGRAM IMPACT ON UTILIZATION *****
************************************************

use "hf_PIPendl.dta", clear

* 2008 utilization
* average utilization, excluding months around Christmas due to heavy travelling and people are not in their regular homes during that period in rural Uganda.

* OUTPATIENT CARE *
egen avgOP=rowmean(s7_co2_m3 s7_co2_m4 s7_co2_m5 s7_co2_m6 s7_co2_m7 s7_co2_m8 s7_co2_m9 s7_co2_m10 s7_co2_m11)
label var avgOP "monthly average of outpatients above 5 years in 2008"

* DELIVERY *
egen avgDEL=rowmean(s7_co4_m9 s7_co4_m10 s7_co4_m11)
label var avgDEL "monthly average deliveries in 2008"

* ANTENATAL CARE *
egen avgANT=rowmean(s7_co5_m3 s7_co5_m4 s7_co5_m5 s7_co5_m6 s7_co5_m7 s7_co5_m8 s7_co5_m9 s7_co5_m10 s7_co5_m11)
label var avgANT "monthly avg antenatal care patients in 2008"

* FAMILY PLANNING *
by hfcode: gen avgFP=(s7_co6_m3+s7_co6_m4+s7_co6_m5+s7_co6_m6+s7_co6_m7+s7_co6_m8+s7_co6_m9+s7_co6_m10+s7_co6_m11)/9 
label var avgFP "monthly avg people seeking FP in 2008"

sort hfcode dcode year
xi i.dcode

keep avgOP avgDEL avgANT avgFP treatment _Idcode_* sample1 year hfcode dcode

sort year hfcode
save "hfutilization.dta", replace


********** REGRESSIONS *************

use "hfutilization.dta", clear

* Panel A: column i-v
mysureg (avgOP  treatment _Idcode_2- _Idcode_11) (avgDEL  treatment _Idcode_2- _Idcode_11) (avgANT treatment _Idcode_2- _Idcode_11)  (avgFP treatment  _Idcode_2- _Idcode_11)  if sample1==1, vce(robust)
sum  avgOP avgDEL avgANT avgFP if sample1==1 & treatment==0
lincom (0.25/237)*[avgOP]treatment + (0.25/11.9)*[avgDEL]treatment + (0.25/55)*[avgANT]treatment + (0.25/20.7)*[avgFP]treatment

* Panel B: column i-v
mysureg (avgOP  treatment _Idcode_2- _Idcode_11) (avgDEL  treatment _Idcode_2- _Idcode_11) (avgANT treatment _Idcode_2- _Idcode_11)  (avgFP treatment  _Idcode_2- _Idcode_11)  if sample1==0, vce(robust)
sum  avgOP avgDEL avgANT avgFP if sample1==0 & treatment==0
lincom (0.25/325)*[avgOP]treatment + (0.25/20)*[avgDEL]treatment + (0.25/56)*[avgANT]treatment + (0.25/11)*[avgFP]treatment


* PANEL C: SHORT-RUN IMPACT INFORMATION AND PARTICIPATION EXPERIMENT (REPORTED IN POWER TO THE PEOPLE, 2009, QJE) *

use "hfdata_PI2006.dta", clear

xi i.dcode
mysureg (avgOP treatment _Idcode_2- _Idcode_11) (avgDEL treatment _Idcode_2- _Idcode_11) (avgANT treatment _Idcode_2- _Idcode_11) (avgFP treatment _Idcode_2- _Idcode_11), vce(robust)
sum avgOP avgDEL avgANT avgFP if treatment==0
lincom (0.25/174.96)*[avgOP]treatment + (0.25/8.06)*[avgDEL]treatment + (0.25/59.44)*[avgANT]treatment + (0.25/17.52)*[avgFP]treatment

drop if avgOP==.
sort year hfcode
save temp.dta, replace

sort year hfcode
append using "hfutilization.dta"
sort  hfcode

merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 
drop _merge

gen charge2= avg_charge_gentreat^2
gen op2= avgOP_baseline ^2
gen hhs2=hhs^2
sort year hfcode
label var avgOP "monthly average of outpatients above 5 years"
label var avgDEL "monthly average deliveries"
label var avgANT "monthly avg antenatal care patients"
label var avgFP "monthly avg people seeking family planning"

save "hfutilization.dta", replace


* PANEL C: 

* COMPARISON I&P (SR) vs. P(SR)

use "hfutilization.dta", clear

gen sample1_t=sample1*treatment
gen SR=(sample1==1 & year==2006) | (sample1==0 & year==2009)
gen LR=(sample1==1 & year==2009) | (sample1==0 & year==2009)

gen dcode1=100+dcode
replace dcode1=0 if sample1==1
replace dcode=0 if dcode==.
replace dcode1=0 if dcode1==.

gsem ( avgOP <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (avgDEL <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (avgANT <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (avgFP <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) if SR==1, vce(robust)
sum avgOP avgDEL avgANT avgFP if SR==1 & treatment==0 & sample1==1
sum avgOP avgDEL avgANT avgFP if SR==1 & treatment==0 & sample1==0

lincom ((0.25/175)*[avgOP]treatment +(0.25/175)*[avgOP]sample1_t + (0.25/8.06)*[avgDEL]treatment + (0.25/8.06)*[avgDEL]sample1_t+ (0.25/59.4)*[avgANT]treatment + (0.25/59.4)*[avgANT]sample1_t  + (0.25/17.5)*[avgFP]treatment+ (0.25/17.5)*[avgFP]sample1_t)-((0.25/325)*[avgOP]treatment + (0.25/19.6)*[avgDEL]treatment +  (0.25/56.8)*[avgANT]treatment +  (0.25/11.1)*[avgFP]treatment)


** COMPARISON I&P(LR) vs. P(SR)

gsem ( avgOP <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (avgDEL <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (avgANT <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (avgFP <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) if LR==1, vce(robust)
sum avgOP avgDEL avgANT avgFP if LR==1 & treatment==0 & sample1==1
sum avgOP avgDEL avgANT avgFP if LR==1 & treatment==0 & sample1==0

lincom ((0.25/237)*[avgOP]treatment +(0.25/237)*[avgOP]sample1_t + (0.25/11.9)*[avgDEL]treatment + (0.25/11.9)*[avgDEL]sample1_t+ (0.25/55)*[avgANT]treatment + (0.25/55)*[avgANT]sample1_t  + (0.25/20.7)*[avgFP]treatment+ (0.25/20.7)*[avgFP]sample1_t)-((0.25/325)*[avgOP]treatment + (0.25/19.6)*[avgDEL]treatment +  (0.25/56.8)*[avgANT]treatment +  (0.25/11.1)*[avgFP]treatment)

