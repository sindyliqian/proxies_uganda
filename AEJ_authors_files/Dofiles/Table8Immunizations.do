

* Experimental Evidence on the Long-Run Impact of Community Based Monitoring
* American Economic Journal: Applied Economics

clear all
set more off
capture log close

cd "/Users/ma.2557/Dropbox/Documents/CRCCL2/AEJ_AppliedEcon/Replication files/Dataset/"

***************************
******** TABLE 8 **********
***************************

use immunization.dta, clear

gen avg_immunization_3m=(polio_3m +DPT_3m+ BCG_3m)/3 
gen avg_immunization_1y=(polio_1y + DPT_1y + BCG_1y)/3 
gen avg_immunization_2y=(measles_2y + polio_2y + DPT_2y + BCG_2y)/4 
gen avg_immunization_3y=(measles_3y + polio_3y + DPT_3y + BCG_3y)/4
gen avg_immunization_4y=(measles_4y + polio_4y + DPT_4y + BCG_4y)/4 
gen avg_immunization_5y=(measles_5y + polio_5y + DPT_5y + BCG_5y)/4 

*PANEL A AND PANEL B:
 
*** column(i): newborn ***
xi i.dcode
bys sample1: sum polio_3m DPT_3m BCG_3m if treatment==0
mysureg (polio_3m treatment  _Idcode_2- _Idcode_11) (DPT_3m treatment  _Idcode_2- _Idcode_11) (BCG_3m treatment  _Idcode_2- _Idcode_11) if sample1==1, cluster(hfcode)
lincom (0.33/ .4402)*[polio_3m]treatment + (0.33/ .4249)*[DPT_3m]treatment + (0.33/ .3798)*[BCG_3m]treatment 

mysureg (polio_3m treatment  _Idcode_2- _Idcode_11) (DPT_3m treatment  _Idcode_2- _Idcode_11) (BCG_3m treatment  _Idcode_2- _Idcode_11) if sample1==0, cluster(hfcode)
lincom (0.33/ .423)*[polio_3m]treatment + (0.33/ .4264)*[DPT_3m]treatment + (0.33/ .355)*[BCG_3m]treatment 

bys treatment sample1: sum avg_immunization_3m


*** column(ii): children<1year ***

bys sample1: sum polio_1y DPT_1y BCG_1y if treatment==0

mysureg (polio_1y treatment  _Idcode_2- _Idcode_11) (DPT_1y treatment  _Idcode_2- _Idcode_11) (BCG_1y treatment  _Idcode_2- _Idcode_11) if sample1==1 , cluster(hfcode)
lincom (0.33/ .4512)*[polio_1y]treatment + (0.33/.364)*[ DPT_1y]treatment + (0.33/ .2457)*[BCG_1y]treatment 

mysureg (polio_1y treatment  _Idcode_2- _Idcode_11) (DPT_1y treatment  _Idcode_2- _Idcode_11) (BCG_1y treatment  _Idcode_2- _Idcode_11) if sample1==0 , cluster(hfcode)
lincom (0.33/ .4478)*[polio_1y]treatment + (0.33/.3581)*[ DPT_1y]treatment + (0.33/ .2596)*[BCG_1y]treatment 

bys treatment sample1: sum avg_immunization_1y 


*** column(iii): children 1 year ***

bys sample1: sum measles_2y polio_2y DPT_2y BCG_2y if treatment==0

mysureg (measles_2y treatment _Idcode_2- _Idcode_11) (polio_2y treatment _Idcode_2- _Idcode_11) (DPT_2y treatment _Idcode_2- _Idcode_11) (BCG_2y treatment _Idcode_2- _Idcode_11)  if sample1==1, cluster(hfcode)
lincom (0.25/ .399)*[measles_2y]treatment + (0.25/.3453)*[polio_2y]treatment + (0.25/.2861)*[DPT_2y]treatment + (0.25/.1655)*[BCG_2y]treatment

mysureg (measles_2y treatment _Idcode_2- _Idcode_11) (polio_2y treatment _Idcode_2- _Idcode_11) (DPT_2y treatment _Idcode_2- _Idcode_11) (BCG_2y treatment _Idcode_2- _Idcode_11)  if sample1==0, cluster(hfcode)
lincom (0.25/ .4147)*[measles_2y]treatment + (0.25/.3511)*[polio_2y]treatment + (0.25/.2985)*[DPT_2y]treatment + (0.25/.2113)*[BCG_2y]treatment

bys treatment sample1: sum avg_immunization_2y

*** column(iv): children 2 year ***

bys sample1: sum measles_3y polio_3y DPT_3y BCG_3y if treatment==0

mysureg (measles_3y treatment  _Idcode_2- _Idcode_11) (polio_3y treatment  _Idcode_2- _Idcode_11) (DPT_3y treatment  _Idcode_2- _Idcode_11) (BCG_3y treatment  _Idcode_2- _Idcode_11) if sample1==1 , cluster(hfcode)
lincom (0.25/ .3567)*[measles_3y]treatment + (0.25/  .315)*[polio_3y]treatment + (0.25/.2622)*[DPT_3y]treatment + (0.25/.1521)*[BCG_3y]treatment 

mysureg (measles_3y treatment  _Idcode_2- _Idcode_11) (polio_3y treatment  _Idcode_2- _Idcode_11) (DPT_3y treatment  _Idcode_2- _Idcode_11) (BCG_3y treatment  _Idcode_2- _Idcode_11) if sample1==0 , cluster(hfcode)
lincom (0.25/ .3885)*[measles_3y]treatment + (0.25/  .3257)*[polio_3y]treatment + (0.25/.2669)*[DPT_3y]treatment + (0.25/.1960)*[BCG_3y]treatment 

bys treatment sample1: sum avg_immunization_3y 


*** column(v): children 3 year ***

bys sample1: sum measles_4y polio_4y DPT_4y BCG_4y if treatment==0

mysureg (measles_4y treatment  _Idcode_2- _Idcode_11) (polio_4y treatment  _Idcode_2- _Idcode_11) (DPT_4y treatment  _Idcode_2- _Idcode_11) (BCG_4y treatment  _Idcode_2- _Idcode_11)  if sample1==1 , cluster(hfcode)
lincom (0.25/.3475)*[measles_4y]treatment + (0.25/ .3172)*[polio_4y]treatment + (0.25/ .2042)*[DPT_4y]treatment + (0.25/.1499)*[BCG_4y]treatment

mysureg (measles_4y treatment  _Idcode_2- _Idcode_11) (polio_4y treatment  _Idcode_2- _Idcode_11) (DPT_4y treatment  _Idcode_2- _Idcode_11) (BCG_4y treatment  _Idcode_2- _Idcode_11)  if sample1==0 , cluster(hfcode)
lincom (0.25/.3798)*[measles_4y]treatment + (0.25/ .3255)*[polio_4y]treatment + (0.25/ .2478)*[DPT_4y]treatment + (0.25/.1978)*[BCG_4y]treatment

bys treatment sample1: sum avg_immunization_4y 

*** column(vi): children 4 year ***

bys sample1: sum measles_5y polio_5y DPT_5y BCG_5y if treatment==0

mysureg (measles_5y treatment  _Idcode_2- _Idcode_11) (polio_5y treatment  _Idcode_2- _Idcode_11) (DPT_5y treatment  _Idcode_2- _Idcode_11) (BCG_5y treatment  _Idcode_2- _Idcode_11) if sample1==1, cluster(hfcode)
lincom (0.25/ .3098)*[measles_5y]treatment + (0.25/.2951)*[polio_5y]treatment + (0.25/.0682)*[DPT_5y]treatment + (0.25/.1744)*[BCG_5y]treatment

** excluding DPT in this regression because everyone takes it so standard deviation is 0 and not possible to estimate the average standardized treatment effect.
mysureg (measles_5y treatment  _Idcode_2- _Idcode_11) (polio_5y treatment  _Idcode_2- _Idcode_11) (BCG_5y treatment  _Idcode_2- _Idcode_11) if sample1==0, cluster(hfcode)
lincom (0.33/ .3655)*[measles_5y]treatment + (0.33/.3323)*[polio_5y]treatment  + (0.33/.1923)*[BCG_5y]treatment

bys treatment sample1: sum avg_immunization_5y 



*PANEL C:

* Short-run impact (I&P): SHORT-RUN IMPACT INFORMATION AND PARTICIPATION EXPERIMENT (REPORTED IN POWER TO THE PEOPLE, 2009, QJE) *

use "immunization_2006data.dta", replace

*** (a) AVERAGE STANDARDIZED EFFECT: IMMUNIZATION OF INFANTS ***
xi i.dcode
sum polio_3m DPT_3m BCG_3m if treatment==0
mysureg (polio_3m treatment  _Idcode_2- _Idcode_11) (DPT_3m treatment  _Idcode_2- _Idcode_11) (BCG_3m treatment  _Idcode_2- _Idcode_11), cluster(hfcode)
lincom (0.33/.502)*[polio_3m]treatment + (0.33/.439)*[DPT_3m]treatment +(0.33/0.503)*[BCG_3m]treatment

*** (b) AVERAGE STANDARDIZED EFFECT: IMMUNIZATION OF CHILDREN LESS THAN 1-YEAR OLD ***
sum polio_1y DPT_1y BCG_1y if treatment==0
mysureg (polio_1y treatment  _Idcode_2- _Idcode_11) (DPT_1y treatment  _Idcode_2- _Idcode_11) (BCG_1y treatment  _Idcode_2- _Idcode_11), cluster(hfcode)
lincom (0.33/.493)*[polio_1y]treatment + (0.33/.485)*[DPT_1y]treatment +(0.33/0.405)*[BCG_1y]treatment 

*** (c) AVERAGE STANDARDIZED EFFECT: IMMUNIZATION OF CHILDREN 1-YEAR OLD ***
sum measles_2y polio_2y DPT_2y BCG_2y if treatment==0
mysureg (measles_2y treatment _Idcode_2- _Idcode_11) (polio_2y treatment _Idcode_2- _Idcode_11) (DPT_2y treatment _Idcode_2- _Idcode_11) (BCG_2y treatment _Idcode_2- _Idcode_11), cluster(hfcode)
lincom (0.25/.379)*[measles_2y]treatment + (0.25/.384)*[polio_2y]treatment + (0.25/.425)*[DPT_2y]treatment +(0.25/0.185)*[BCG_2y]treatment

*** (d) AVERAGE STANDARDIZED EFFECT: IMMUNIZATION OF CHILDREN 2-YEAR OLD ***
sum measles_3y polio_3y DPT_3y BCG_3y if treatment==0
mysureg (measles_3y treatment  _Idcode_2- _Idcode_11) (polio_3y treatment  _Idcode_2- _Idcode_11) (DPT_3y treatment  _Idcode_2- _Idcode_11) (BCG_3y treatment  _Idcode_2- _Idcode_11) , cluster(hfcode)
lincom (0.25/.263)*[measles_3y]treatment + (0.25/.322)*[polio_3y]treatment + (0.25/.383)*[DPT_3y]treatment +(0.25/0.098)*[BCG_3y]treatment

*** (e) AVERAGE STANDARDIZED EFFECT: IMMUNIZATION OF CHILDREN 3-YEAR OLD ***
sum measles_4y polio_4y DPT_4y BCG_4y if treatment==0
mysureg (measles_4y treatment  _Idcode_2- _Idcode_11) (polio_4y treatment  _Idcode_2- _Idcode_11) (DPT_4y treatment  _Idcode_2- _Idcode_11) (BCG_4y treatment  _Idcode_2- _Idcode_11), cluster(hfcode)
lincom (0.25/.208)*[measles_4y]treatment + (0.25/.287)*[polio_4y]treatment + (0.25/.378)*[DPT_4y]treatment +(0.25/.158)*[BCG_4y]treatment


*** (f) AVERAGE STANDARDIZED EFFECT: IMMUNIZATION OF CHILDREN 4-YEAR OLD ***
sum measles_5y polio_5y DPT_5y BCG_5y if treatment==0
mysureg (measles_5y treatment  _Idcode_2- _Idcode_11) (polio_5y treatment  _Idcode_2- _Idcode_11) (DPT_5y treatment  _Idcode_2- _Idcode_11) (BCG_5y treatment  _Idcode_2- _Idcode_11), cluster(hfcode)
lincom (0.25/.185)*[measles_5y]treatment + (0.25/.282)*[polio_5y]treatment + (0.25/.306)*[DPT_5y]treatment +(0.25/.155)*[BCG_5y]treatment


* generate a dataset that can be appended to the 2009 dataset with the same variable name etc. 

sort year hhcode hfcode 
append using immunization.dta

sort year hhcode hfcode 
save immunization0609.dta, replace



replace sample1=1 if year==2006
drop treatment1
gen sample1_t=sample1*treatment

gen dcode1=100+dcode
replace dcode1=0 if sample1==1
replace dcode=0 if dcode==.
replace dcode1=0 if dcode1==.

gen SR=(sample1==1 & year==2006) | (sample1==0 & year==2009)
gen LR=(sample1==1 & year==2009) | (sample1==0 & year==2009)

save immunization0609.dta, replace


sort hfcode
save immunization0609.dta, replace

merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 
drop _merge

gen charge2= avg_charge_gentreat^2
gen op2= avgOP_baseline^2
gen hhs2=hhs^2

sort year hhcode hfcode 
save immunization0609.dta, replace


*PANEL C:

** DIFFERENTIAL EFFECT I&P(SR) vs. P(SR)
use immunization0609.dta, clear

* infants <3m wo vitA as in 2009 regr
gsem ( polio_3m <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) ( DPT_3m <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) (BCG_3m <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) if SR==1, nocaps vce(cluster hfcode)
sum polio_3m DPT_3m BCG_3m if SR==1 & treatment==0 & sample1==1
sum polio_3m DPT_3m BCG_3m if SR==1 & treatment==0 & sample1==0
lincom ((0.33/0.50)*[polio_3m]treatment +(0.33/0.50)*[polio_3m]sample1_t + (0.33/0.44)*[DPT_3m]treatment + (0.33/0.44)*[DPT_3m]sample1_t+ (0.33/0.50)*[BCG_3m]treatment + (0.33/0.50)*[BCG_3m]sample1_t)-((0.33/0.42)*[polio_3m]treatment + (0.33/0.43)*[DPT_3m]treatment +  (0.33/0.36)*[BCG_3m]treatment)

* children <1y wo vitA as in 2009 regr
gsem ( polio_1y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) ( DPT_1y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) (BCG_1y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) if SR==1, nocaps vce(cluster hfcode)
sum polio_1y DPT_1y BCG_1y if SR==1 & treatment==0 & sample1==1
sum polio_1y DPT_1y BCG_1y if SR==1 & treatment==0 & sample1==0
lincom ((0.33/0.49)*[polio_1y]treatment +(0.33/0.49)*[polio_1y]sample1_t + (0.33/0.49)*[DPT_1y]treatment + (0.33/0.49)*[DPT_1y]sample1_t+ (0.33/0.40)*[BCG_1y]treatment + (0.33/0.40)*[BCG_1y]sample1_t)-((0.33/0.45)*[polio_1y]treatment + (0.33/0.36)*[DPT_1y]treatment +  (0.33/0.26)*[BCG_1y]treatment)

* children <2y wo vitA as in 2009 regr
gsem ( measles_2y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2)  ( polio_2y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) ( DPT_2y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) (BCG_2y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) if SR==1, nocaps vce(cluster hfcode)
sum measles_2y polio_2y DPT_2y BCG_2y if SR==1 & treatment==0 & sample1==1
sum measles_2y polio_2y DPT_2y BCG_2y if SR==1 & treatment==0 & sample1==0
lincom ((0.25/0.38)*[measles_2y]treatment +(0.25/0.38)*[measles_2y]sample1_t + (0.25/0.38)*[polio_2y]treatment +(0.25/0.38)*[polio_2y]sample1_t + (0.25/0.42)*[DPT_2y]treatment + (0.25/0.42)*[DPT_2y]sample1_t+ (0.25/0.18)*[BCG_2y]treatment + (0.25/0.18)*[BCG_2y]sample1_t)-((0.25/0.42)*[measles_2y]treatment + (0.25/0.35)*[polio_2y]treatment + (0.25/0.30)*[DPT_2y]treatment +  (0.25/0.21)*[BCG_2y]treatment)

* children <3y wo vitA as in 2009 regr
gsem ( measles_3y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2)  ( polio_3y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) ( DPT_3y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) (BCG_3y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) if SR==1, nocaps vce(cluster hfcode)
sum measles_3y polio_3y DPT_3y BCG_3y if SR==1 & treatment==0 & sample1==1
sum measles_3y polio_3y DPT_3y BCG_3y if SR==1 & treatment==0 & sample1==0
lincom ((0.25/0.26)*[measles_3y]treatment +(0.25/0.26)*[measles_3y]sample1_t + (0.25/0.32)*[polio_3y]treatment +(0.25/0.32)*[polio_3y]sample1_t + (0.25/0.38)*[DPT_3y]treatment + (0.25/0.38)*[DPT_3y]sample1_t+ (0.25/0.10)*[BCG_3y]treatment + (0.25/0.10)*[BCG_3y]sample1_t)-((0.25/0.39)*[measles_3y]treatment + (0.25/0.33)*[polio_3y]treatment + (0.25/0.27)*[DPT_3y]treatment +  (0.25/0.20)*[BCG_3y]treatment)

* children <4y wo vitA as in 2009 regr
gsem ( measles_4y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2)  ( polio_4y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) ( DPT_4y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) (BCG_4y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) if SR==1, nocaps vce(cluster hfcode)
sum measles_4y polio_4y DPT_4y BCG_4y if SR==1 & treatment==0 & sample1==1
sum measles_4y polio_4y DPT_4y BCG_4y if SR==1 & treatment==0 & sample1==0
lincom ((0.25/0.21)*[measles_4y]treatment +(0.25/0.21)*[measles_4y]sample1_t + (0.25/0.29)*[polio_4y]treatment +(0.25/0.29)*[polio_4y]sample1_t + (0.25/0.38)*[DPT_4y]treatment + (0.25/0.38)*[DPT_4y]sample1_t+ (0.25/0.16)*[BCG_4y]treatment + (0.25/0.16)*[BCG_4y]sample1_t)-((0.25/0.38)*[measles_4y]treatment + (0.25/0.33)*[polio_4y]treatment + (0.25/0.25)*[DPT_4y]treatment +  (0.25/0.20)*[BCG_4y]treatment)


* children <5y wo vitA as in 2009 regr
gsem ( measles_5y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2)  ( polio_5y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) ( DPT_5y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) (BCG_5y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) if SR==1, nocaps vce(cluster hfcode)
sum measles_5y polio_5y DPT_5y BCG_5y if SR==1 & treatment==0 & sample1==1
sum measles_5y polio_5y DPT_5y BCG_5y if SR==1 & treatment==0 & sample1==0
lincom ((0.25/0.18)*[measles_5y]treatment +(0.25/0.18)*[measles_5y]sample1_t + (0.25/0.28)*[polio_5y]treatment +(0.25/0.28)*[polio_5y]sample1_t + (0.25/0.31)*[DPT_5y]treatment + (0.25/0.31)*[DPT_5y]sample1_t+  (0.25/0.15)*[BCG_5y]treatment + (0.25/0.15)*[BCG_5y]sample1_t)-((0.25/0.37)*[measles_5y]treatment + (0.25/0.33)*[polio_5y]treatment +  (0.25/0.19)*[BCG_5y]treatment) + (0.25/0.00001)*[DPT_5y]treatment 



** DIFFERENTIAL EFFECT I&P(LR) vs. P(SR)

* infants <3m 
gsem ( polio_3m <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) ( DPT_3m <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) (BCG_3m <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) if LR==1, nocaps vce(cluster hfcode)
sum polio_3m DPT_3m BCG_3m if LR==1 & treatment==0 & sample1==1
sum polio_3m DPT_3m BCG_3m if LR==1 & treatment==0 & sample1==0
lincom ((0.33/0.44)*[polio_3m]treatment +(0.33/0.44)*[polio_3m]sample1_t + (0.33/0.42)*[DPT_3m]treatment + (0.33/0.42)*[DPT_3m]sample1_t+ (0.33/0.38)*[BCG_3m]treatment + (0.33/0.38)*[BCG_3m]sample1_t)-((0.33/0.42)*[polio_3m]treatment + (0.33/0.43)*[DPT_3m]treatment +  (0.33/0.36)*[BCG_3m]treatment)

* children <1y wo vitA as in 2009 regr
gsem ( polio_1y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) ( DPT_1y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) (BCG_1y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) if LR==1, nocaps vce(cluster hfcode)
sum polio_1y DPT_1y BCG_1y if LR==1 & treatment==0 & sample1==1
sum polio_1y DPT_1y BCG_1y if LR==1 & treatment==0 & sample1==0
lincom ((0.33/0.45)*[polio_1y]treatment +(0.33/0.45)*[polio_1y]sample1_t + (0.33/0.36)*[DPT_1y]treatment + (0.33/0.36)*[DPT_1y]sample1_t+ (0.33/0.25)*[BCG_1y]treatment + (0.33/0.25)*[BCG_1y]sample1_t)-((0.33/0.45)*[polio_1y]treatment + (0.33/0.36)*[DPT_1y]treatment +  (0.33/0.26)*[BCG_1y]treatment)

* children <2y wo vitA as in 2009 regr
gsem ( measles_2y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2)  ( polio_2y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) ( DPT_2y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) (BCG_2y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) if LR==1, nocaps vce(cluster hfcode)
sum measles_2y polio_2y DPT_2y BCG_2y if LR==1 & treatment==0 & sample1==1
sum measles_2y polio_2y DPT_2y BCG_2y if LR==1 & treatment==0 & sample1==0
lincom ((0.25/0.40)*[measles_2y]treatment +(0.25/0.40)*[measles_2y]sample1_t + (0.25/0.35)*[polio_2y]treatment +(0.25/0.35)*[polio_2y]sample1_t + (0.25/0.29)*[DPT_2y]treatment + (0.25/0.29)*[DPT_2y]sample1_t+ (0.25/0.17)*[BCG_2y]treatment + (0.25/0.17)*[BCG_2y]sample1_t)-((0.25/0.41)*[measles_2y]treatment + (0.25/0.35)*[polio_2y]treatment + (0.25/0.30)*[DPT_2y]treatment +  (0.25/0.21)*[BCG_2y]treatment)

* children <3y wo vitA as in 2009 regr
gsem ( measles_3y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2)  ( polio_3y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) ( DPT_3y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) (BCG_3y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) if LR==1, nocaps vce(cluster hfcode)
sum measles_3y polio_3y DPT_3y BCG_3y if LR==1 & treatment==0 & sample1==1
sum measles_3y polio_3y DPT_3y BCG_3y if LR==1 & treatment==0 & sample1==0
lincom ((0.25/0.36)*[measles_3y]treatment +(0.25/0.36)*[measles_3y]sample1_t + (0.25/0.32)*[polio_3y]treatment +(0.25/0.32)*[polio_3y]sample1_t + (0.25/0.26)*[DPT_3y]treatment + (0.25/0.26)*[DPT_3y]sample1_t+ (0.25/0.15)*[BCG_3y]treatment + (0.25/0.15)*[BCG_3y]sample1_t)-((0.25/0.39)*[measles_3y]treatment + (0.25/0.33)*[polio_3y]treatment + (0.25/0.27)*[DPT_3y]treatment +  (0.25/0.20)*[BCG_3y]treatment)

* children <4y wo vitA as in 2009 regr
gsem ( measles_4y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2)  ( polio_4y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) ( DPT_4y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) (BCG_4y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) if LR==1, nocaps vce(cluster hfcode)
sum measles_4y polio_4y DPT_4y BCG_4y if LR==1 & treatment==0 & sample1==1
sum measles_4y polio_4y DPT_4y BCG_4y if LR==1 & treatment==0 & sample1==0
lincom ((0.25/0.35)*[measles_4y]treatment +(0.25/0.35)*[measles_4y]sample1_t + (0.25/0.32)*[polio_4y]treatment +(0.25/0.32)*[polio_4y]sample1_t + (0.25/0.20)*[DPT_4y]treatment + (0.25/0.20)*[DPT_4y]sample1_t+ (0.25/0.15)*[BCG_4y]treatment + (0.25/0.15)*[BCG_4y]sample1_t)-((0.25/0.38)*[measles_4y]treatment + (0.25/0.33)*[polio_4y]treatment + (0.25/0.25)*[DPT_4y]treatment +  (0.25/0.20)*[BCG_4y]treatment)


* children <5y wo vitA as in 2009 regr
gsem ( measles_5y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2)  ( polio_5y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2)  (BCG_5y <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat  avgOP_baseline hhs  charge2 op2 hhs2) if LR==1, nocaps vce(cluster hfcode)
sum measles_5y polio_5y DPT_5y BCG_5y if LR==1 & treatment==0 & sample1==1
sum measles_5y polio_5y DPT_5y BCG_5y if LR==1 & treatment==0 & sample1==0
lincom ((0.33/0.31)*[measles_5y]treatment +(0.33/0.31)*[measles_5y]sample1_t + (0.33/0.30)*[polio_5y]treatment +(0.33/0.30)*[polio_5y]sample1_t +  (0.33/0.17)*[BCG_5y]treatment + (0.33/0.17)*[BCG_5y]sample1_t)-((0.33/0.37)*[measles_5y]treatment + (0.33/0.33)*[polio_5y]treatment +  (0.33/0.19)*[BCG_5y]treatment) 
