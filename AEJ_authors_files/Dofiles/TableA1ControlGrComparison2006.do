
* Experimental Evidence on the Long-Run Impact of Community Based Monitoring
* American Economic Journal: Applied Economics

clear all
set more off
capture log close

cd "/Users/ma.2557/Dropbox/Documents/CRCCL2/AEJ_AppliedEcon/Replication files/Dataset/"


**********************************
***** APPENDIX *******************
**********************************


*****************************************************************************************
***** TABLE A.1: COMPARISON OF CONTROL GROUP CHARACHTERISTICS IN 2006 *******************
*****************************************************************************************

* First create a dataset to use in the regressions

**** HEALTH FACILITY DATA 

** Catchment area statistics
use "samplestats_PI2006.dta", clear
sort hfcode
append using "T25_2006_PreTreatVarsHF.dta"
sort hfcode
replace sample1=1 if sample1==.
save "hfvars2006.dta", replace


use "hfdata_PI2006.dta", clear
rename avg_chloro avg_chloroq
rename  avg_cotrim avg_septrine
tab hs2q10
gen piped_water=(hs2q10==2)
gen nopower=hs2q14
replace nopower=0 if nopower==2
replace nopower=0 if nopower==.  /* these are hf without electricity at all - i.e. is not working right now */
tab hs2q2
gen yellow_star=(hs2q2==1)
replace yellow_star=1 if hs2q2==3
* judge DK== no yellow star

sort hfcode
merge hfcode using "hfvars2006.dta"
gen water_working=hs2q11
recode water_working (2=0) /* these are hf in which water source is not currently working - i.e. less likely that people could drink safely */ 
drop _merge
sort hfcode
save "hfvars2006.dta", replace


use "hfdata_PI2006.dta", clear
replace hs5q4_01=1 if (hs5q4_01 ==1 |  hs5q4_01 ==2 | hs5q4_01 ==3 |  hs5q4_01 ==4 |  hs5q4_01 ==5|  hs5q4_01 ==6 | hs5q4_01 ==9 |  hs5q4_01 ==10 |  hs5q4_01 ==12)
replace hs5q4_01=0 if (hs5q4_01!=1 &  hs5q4_01!=.) 
replace hs5q4_02=1 if (hs5q4_02 ==1 |  hs5q4_02 ==2 | hs5q4_02 ==3 |  hs5q4_02 ==4 |  hs5q4_02 ==5|  hs5q4_02 ==6 | hs5q4_02 ==9 |  hs5q4_02 ==10 |  hs5q4_02 ==12)
replace hs5q4_02=0 if (hs5q4_02!=1 &  hs5q4_02!=.) 
replace hs5q4_03=1 if (hs5q4_03 ==1 |  hs5q4_03 ==2 | hs5q4_03 ==3 |  hs5q4_03 ==4 |  hs5q4_03 ==5|  hs5q4_03 ==6 | hs5q4_03 ==9 |  hs5q4_03 ==10 |  hs5q4_03 ==12)
replace hs5q4_03=0 if (hs5q4_03!=1 &  hs5q4_03!=.) 
replace hs5q4_04=1 if (hs5q4_04 ==1 |  hs5q4_04 ==2 | hs5q4_04 ==3 |  hs5q4_04 ==4 |  hs5q4_04 ==5|  hs5q4_04 ==6 | hs5q4_04 ==9 |  hs5q4_04 ==10 |  hs5q4_04 ==12)
replace hs5q4_04=0 if (hs5q4_04!=1 &  hs5q4_04!=.) 
replace hs5q4_05=1 if (hs5q4_05 ==1 |  hs5q4_05 ==2 | hs5q4_05 ==3 |  hs5q4_05 ==4 |  hs5q4_05 ==5|  hs5q4_05 ==6 | hs5q4_05 ==9 |  hs5q4_05 ==10 |  hs5q4_05 ==12)
replace hs5q4_05 =0 if (hs5q4_05!=1 &  hs5q4_05!=.) 
replace hs5q4_06=1 if (hs5q4_06 ==1 |  hs5q4_06 ==2 | hs5q4_06 ==3 |  hs5q4_06 ==4 |  hs5q4_06 ==5|  hs5q4_06 ==6 | hs5q4_06 ==9 |  hs5q4_06 ==10 |  hs5q4_06 ==12)
replace hs5q4_06 =0 if (hs5q4_06!=1 &  hs5q4_06!=.) 
replace hs5q4_07=1 if (hs5q4_07 ==1 |  hs5q4_07 ==2 | hs5q4_07 ==3 |  hs5q4_07 ==4 |  hs5q4_07 ==5|  hs5q4_07 ==6 | hs5q4_07 ==9 |  hs5q4_07 ==10 |  hs5q4_07 ==12)
replace hs5q4_07 =0 if (hs5q4_07!=1 &  hs5q4_07!=.) 
replace hs5q4_08=1 if (hs5q4_08 ==1 |  hs5q4_08 ==2 | hs5q4_08 ==3 |  hs5q4_08 ==4 |  hs5q4_08 ==5|  hs5q4_08 ==6 | hs5q4_08 ==9 |  hs5q4_08 ==10 |  hs5q4_08 ==12)
replace hs5q4_08 =0 if (hs5q4_08!=1 &  hs5q4_08!=.) 
replace hs5q4_09=1 if (hs5q4_09 ==1 |  hs5q4_09 ==2 | hs5q4_09 ==3 |  hs5q4_09 ==4 |  hs5q4_09 ==5|  hs5q4_09 ==6 | hs5q4_09 ==9 |  hs5q4_09 ==10 |  hs5q4_09 ==12)
replace hs5q4_09 =0 if (hs5q4_09!=1 &  hs5q4_09!=.) 
replace hs5q4_10=1 if (hs5q4_10 ==1 |  hs5q4_10 ==2 | hs5q4_10 ==3 |  hs5q4_10 ==4 |  hs5q4_10 ==5|  hs5q4_10 ==6 | hs5q4_10 ==9 |  hs5q4_10 ==10 |  hs5q4_10 ==12)
replace hs5q4_10 =0 if (hs5q4_10!=1 &  hs5q4_10!=.) 
replace hs5q4_11=1 if (hs5q4_11 ==1 |  hs5q4_11 ==2 | hs5q4_11 ==3 |  hs5q4_11 ==4 |  hs5q4_11 ==5|  hs5q4_11 ==6 | hs5q4_11 ==9 |  hs5q4_11 ==10 |  hs5q4_11 ==12)
replace hs5q4_11 =0 if (hs5q4_11!=1 &  hs5q4_11!=.) 
replace hs5q4_12=1 if (hs5q4_12 ==1 |  hs5q4_12 ==2 | hs5q4_12 ==3 |  hs5q4_12 ==4 |  hs5q4_12 ==5|  hs5q4_12 ==6 | hs5q4_12 ==9 |  hs5q4_12 ==10 |  hs5q4_12 ==12)
replace hs5q4_12 =0 if (hs5q4_12!=1 &  hs5q4_12!=.) 
replace hs5q4_13=1 if (hs5q4_13 ==1 |  hs5q4_13 ==2 | hs5q4_13 ==3 |  hs5q4_13 ==4 |  hs5q4_13 ==5|  hs5q4_13 ==6 | hs5q4_13 ==9 |  hs5q4_13 ==10 |  hs5q4_13 ==12)
replace hs5q4_13 =0 if (hs5q4_13!=1 &  hs5q4_13!=.) 
replace hs5q4_14=1 if (hs5q4_14 ==1 |  hs5q4_14 ==2 | hs5q4_14 ==3 |  hs5q4_14 ==4 |  hs5q4_14 ==5|  hs5q4_14 ==6 | hs5q4_14 ==9 |  hs5q4_14 ==10 |  hs5q4_14 ==12)
replace hs5q4_14 =0 if (hs5q4_14!=1 &  hs5q4_14!=.) 

egen ALevelStaff_hf=rowtotal(hs5q4_01-hs5q4_14) 
gen LessALevelStaff_hf=hs5q1-ALevelStaff_hf
keep hfcode ALevelStaff_hf LessALevelStaff_hf
sort hfcode
merge hfcode using "hfvars2006.dta"
drop _merge
sort hfcode
replace sample2=0 if sample2==.
save "hfvars2006.dta", replace


**** HOUSEHOLD DATA 

use "hhdata_PI2006.dta", clear
sort hfcode
append using "T25_2006_PreTreatVarsHH.dta"
replace sample1=1 if sample1==.
sort hhcode hfcode
drop _merge
save "hhvars2006.dta", replace

use "hhdata_PI2006.dta", clear
rename wtime waittime
sort hhcode hfcode
merge hhcode hfcode using "hhvars2006.dta"
sort hhcode hfcode
drop _merge
save "hhvars2006.dta", replace

use "hhdata_PI2006.dta", clear
sort hfcode
gen avg_charge_drugs=(s5q1a==1)
gen avg_charge_gentreat=(s5q2a==1)
gen avg_charge_injection=(s5q3a==1)
gen avg_charge_del=(s7q16==1)
collapse   avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del, by(hfcode)
sort hfcode
merge hfcode using "hfvars2006.dta"
drop _merge
save "hfvars2006.dta", replace


****** REGRESSIONS **********

*** HEALTH FACILITY REGRESSIONS *****

use "hfvars2006.dta", clear

reg avgOP  sample1 if treatment==0, robust
bys sample1: sum avgOP if treatment==0

reg avgDEL  sample1 if treatment==0, robust
bys sample1: sum avgDEL if treatment==0

reg hhs  sample1 if treatment==0, robust
bys sample1: sum hhs if treatment==0

reg hh_vill  sample1 if treatment==0, robust
bys sample1: sum hh_vill if treatment==0

reg water_working  sample1 if treatment==0, robust
bys sample1: sum water_working if treatment==0

reg nopower  sample1 if treatment==0, robust
bys sample1: sum nopower if treatment==0


* Average standardized effects:

*** hfutilization 
mysureg (avgOP  sample1) (avgDEL sample1 ) if treatment==0, vce(robust)
sum avgOP  avgDEL if sample1==1 & treatment==0
lincom (0.50/175)*[avgOP]sample1 + (0.50/8.06)*[avgDEL]sample1

*** catchment area statistics
mysureg (hhs sample1) (hh_vill sample1) (villagen sample1) (village1 sample1) (village3 sample1) if treatment==0, vce(robust)
sum hhs hh_vill villagen village1 village3 if sample1==0 & treatment==0
lincom (0.20/1143.5)*[hhs]sample1 + (0.20/41.7)*[hh_vill]sample1 + (0.20/13.3)*[villagen]sample1 + (0.20/0.96)*[village1]sample1 + (0.20/4.43)*[village3]sample1


**** Supply of drugs
mysureg (avg_eryth  sample1) (avg_chloroq sample1 ) (avg_septrine sample1 )  (avg_quinine sample1 ) (avg_meb sample1 ) if treatment==0, vce(robust)
sum avg_eryth  avg_chloroq  avg_septrine avg_quinine  avg_meb  if sample1==1 & treatment==0
lincom (0.20/282)*[avg_eryth]sample1 +(0.20/1483)*[avg_chloroq]sample1 + (0.20/1738)*[avg_septrine]sample1+(0.20/296)*[avg_quinine]sample1+(0.20/2157)*[avg_meb]sample1

*** health facility characteristics
mysureg (water_working  sample1) (piped_water sample1 ) (nopower sample1 )  (yellow_star sample1 )  (ALevelStaff_hf sample1 ) (LessALevelStaff_hf sample1 )if treatment==0, vce(robust)
sum water_working piped_water nopower yellow_star ALevelStaff_hf LessALevelStaff_hf  if sample1==1 & treatment==0
lincom (0.167/0.2)*[water_working]sample1 +(0.167/0.2)*[piped_water]sample1 + (0.167/0.51)*[nopower]sample1+(0.167/0.49)*[yellow_star]sample1+(0.167/1.12)*[ALevelStaff_hf]sample1+(0.167/1.03)*[LessALevelStaff_hf]sample1


*** User charges 
mysureg (avg_charge_drugs sample1) ( avg_charge_gentreat sample1) ( avg_charge_injection sample1)   ( avg_charge_del sample1)  if treatment==0, vce(robust)
sum avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del  if sample1==0 & treatment==0 
lincom -(0.25/ .007)*[ avg_charge_drugs]sample1 -(0.25/ .01)*[ avg_charge_gentreat]sample1 -(0.25/.05)*[ avg_charge_injection]sample1 -(0.25/ .02)*[avg_charge_del]sample1


*** HOUSEHOLD REGRESSIONS ***

use "hhvars2006.dta", clear

* Average standardized effects:

*hhutilization
mysureg (hfx_ratio sample1) (NGO_ratio sample1) (PFP_ratio sample1) (OthGov_ratio sample1) (Other_ratio sample1) ( STTH_ratio sample1) if treatment==0 , cluster(hfcode)
sum hfx_ratio NGO_ratio PFP_ratio STTH_ratio OthGov_ratio Other_ratio if treatment==0  & sample1==1
lincom (0.167/.28)*[hfx_ratio]sample1+(0.167/0.09)*[NGO_ratio]sample1+(0.167/0.23)*[PFP_ratio]sample1+(0.167/0.17)*[OthGov_ratio]sample1+(0.167/0.16)*[Other_ratio]sample1-(0.167/.37)*[STTH_ratio]sample1

** Quality of services according to the users
mysureg (waittime sample1 ) (equip sample1 ) if treatment==0, cluster(hfcode)
sum waittime  equip  if sample1==1 & treatment==0
lincom -(0.50/96)*[waittime]sample1 + (0.50/0.49)*[equip]sample1


*** Citizen perceptions of treatment
mysureg (s3q5 sample1 ) (s3q6 sample1 ) (s3q7 sample1 ) if treatment==0, cluster(hfcode)
sum s3q5  s3q6  s3q7   if sample1==1 & treatment==0
lincom (0.33/0.63)*[s3q5]sample1 + (0.33/0.68)*[s3q6]sample1+ (0.33/0.65)*[s3q7]sample1

