

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
************* TABLE A.2 **************
**************************************

use "hfutilization.dta", clear

*panel A
gen opdel_bl=avgDEL_baseline+avgOP_baseline
mysureg (avgOP  treatment opdel_bl _Idcode_2- _Idcode_11) (avgDEL  treatment opdel_bl _Idcode_2- _Idcode_11) (avgANT treatment opdel_bl _Idcode_2- _Idcode_11)  (avgFP treatment opdel_bl _Idcode_2- _Idcode_11)  if sample1==1 & year==2009 , vce(robust)
sum  avgOP avgDEL avgANT avgFP if sample1==1 & treatment==0 & year==2009
lincom (0.25/237)*[avgOP]treatment + (0.25/11.9)*[avgDEL]treatment + (0.25/55)*[avgANT]treatment + (0.25/20.7)*[avgFP]treatment


*panel B
mysureg (avgOP  treatment opdel_bl _Idcode_2- _Idcode_11) (avgDEL  treatment opdel_bl _Idcode_2- _Idcode_11) (avgANT treatment opdel_bl _Idcode_2- _Idcode_11)  (avgFP treatment opdel_bl _Idcode_2- _Idcode_11)  if sample1==0  & year==2009, vce(robust)
sum  avgOP avgDEL avgANT avgFP if sample1==0 & treatment==0  & year==2009
lincom (0.25/325)*[avgOP]treatment + (0.25/19.6)*[avgDEL]treatment + (0.25/56.8)*[avgANT]treatment + (0.25/11)*[avgFP]treatment

*PANEL C:

* SHORT-RUN IMPACT INFORMATION AND PARTICIPATION EXPERIMENT (REPORTED IN POWER TO THE PEOPLE, 2009, QJE) *
mysureg ( avgOP opdel_bl treatment _Idcode_2- _Idcode_11) (avgDEL opdel_bl treatment _Idcode_2- _Idcode_11) (avgANT opdel_bl treatment _Idcode_2- _Idcode_11) (avgFP opdel_bl treatment _Idcode_2- _Idcode_11) if sample1==1  & year==2006, vce(robust)
sum avgOP avgDEL avgANT avgFP if treatment==0 & sample1==1 & year==2006
lincom (0.25/174.96)*[avgOP]treatment + (0.25/8.06)*[avgDEL]treatment + (0.25/59.44)*[avgANT]treatment + (0.25/17.52)*[avgFP]treatment


** COMPARISON I&P (SR) vs. P(SR)

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
