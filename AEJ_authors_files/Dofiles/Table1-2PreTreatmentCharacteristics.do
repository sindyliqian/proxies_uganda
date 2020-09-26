

* Experimental Evidence on the Long-Run Impact of Community Based Monitoring
* American Economic Journal: Applied Economics

clear all
set more off
capture log close

cd "/Users/ma.2557/Dropbox/Documents/CRCCL2/AEJ_AppliedEcon/Replication files/Dataset/"


*****************************************************************************************
***** TABLE I AND II: PRE-INTERVENTION CHARACHTERISTICS PANEL A AND PANEL  B ************
*****************************************************************************************

* First, create datasets to use for the regressions in Panel B: Participation sample
* For Panel A, we are using datat from 2004 (baseline) and corresponds to data published in QJE, 2010, Power to the People paper.

* HEALTH FACILITY DATA 

*UTILIZATION
*outpatient care*

use "hf_Pbl.dta", clear

*use hf25T.dta, clear
*average number of patients visiting the facility per months
*data in 2006 only for March, May, July, September, Nov & Dec
*double counting the months march, may, july, sept, and including nov. Excluding months related to christmas travelling.

bys hfcode: gen avgOP=(2*hs7q3c+ 2*hs7q3e+ 2*hs7q3g+ 2*hs7q3i+ hs7q3k)/9 

*DELIVERY*
gen avgDEL=(hs7q5c+ hs7q5d+ hs7q5e+ hs7q5f+ hs7q5g+ hs7q5h+ hs7q5i+ hs7q5j+ hs7q5k)/9

keep sample1 treatment avgOP avgDEL hfcode dcode year
save "T25_2006_PreTreatVarsHF.dta", replace


* CATCHMENT AREA STATISTICS*
* tot hhs in village and average hhs per village 

use "samplestats_Pbl.dta", clear

sort hfcode
merge hfcode using "T25_2006_PreTreatVarsHF.dta"
drop _merge
sort hfcode
save "T25_2006_PreTreatVarsHF.dta", replace


* HEALTH FACILITY CHARACTHERISTICS *

* ACCESS TO SAFE WATER / WORKING WATER SOURCE*
*consider variable hs2q11 i.e. Is the health facility's water source working right now
use "hf_Pbl.dta", clear

recode hs2q11 (2=0) /* these are hf in which water source is not currently working - i.e. less likely that people could drink safely */

* ACCESS TO ELECTRICITY *
*No. of days without electricity in past month*
gen nopower=hs2q14
replace nopower=0 if nopower==2
replace nopower=0 if nopower==.  /* these are hf without electricity at all - i.e. is not working right now */
sum nopower

** Piped water
tab hs2q10
gen piped_water=(hs2q10==2)

**** YELLOW STAR HEALTH FACILITY (existence of seperate maternity unit)
*  DK== no yellow star

tab hs2q2
gen yellow_star=(hs2q2==1)
replace yellow_star=1 if hs2q2==3

* SUPPLY OF DRUGS
generate avg_eryth=(hs6q1b1+hs6q1b2 +hs6q1b3 +hs6q1b4 +hs6q1b5 +hs6q1b6 +hs6q1b7 +hs6q1b8+ hs6q1b9 +hs6q1b10 +hs6q1b11+ hs6q1b12)/12
label var avg_eryth "average (per month) erythromycin received in 2005 (Jan-Dec)"
generate avg_chloro= (hs6q2b1+ hs6q2b2+ hs6q2b3+ hs6q2b4+ hs6q2b5+ hs6q2b6+ hs6q2b7+ hs6q2b8+ hs6q2b9+ hs6q2b10+ hs6q2b11+ hs6q2b12)/12
label var avg_chloro "average (per month) chloroquine received in 2005 (Jan-Dec)"
generate avg_cotrim= ( hs6q3b1+ hs6q3b2+ hs6q3b3+ hs6q3b4+ hs6q3b5+ hs6q3b6+ hs6q3b7+ hs6q3b8+ hs6q3b9+ hs6q3b10+ hs6q3b11+ hs6q3b12)/12
label var avg_cotrim "average (per month) cotrimoxazole received in 2005 (Jan-Dec)"
generate avg_quinine= ( hs6q4b1+ hs6q4b2+ hs6q4b3+ hs6q4b4+ hs6q4b5+ hs6q4b6+ hs6q4b7+ hs6q4b8+ hs6q4b9+ hs6q4b10+ hs6q4b11+ hs6q4b12)/12
label var avg_quinine "average (per month) quinine received in 2005 (Jan-Dec)"
generate avg_meb= ( hs6q5b1+ hs6q5b2+ hs6q5b3+ hs6q5b4+ hs6q5b5+ hs6q5b6+ hs6q5b7+ hs6q5b8+ hs6q5b9+ hs6q5b10+ hs6q5b11+ hs6q5b12)/12
label var avg_meb "average (per month) mebendazole received in 2005 (Jan-Dec)"

drop hs6q1b1-hs6q5b12


keep hs2q11 nopower piped_water  yellow_star  hfcode dcode  treatment sample1 hs5q1 avg_eryth avg_chloro avg_cotrim avg_quinine avg_meb
rename avg_chloro avg_chloroq
rename  avg_cotrim avg_septrine

sort hfcode
merge hfcode using "T25_2006_PreTreatVarsHF.dta"
drop _merge
sort hfcode
save "T25_2006_PreTreatVarsHF.dta", replace


** STAFF AT HEALTH FACILITY ***

use "hfstaff_Pbl.dta", clear
bys hfcode: egen ALevelStaff_hf=count(hs5q4) if hs5q4==1 |  hs5q4==2 | hs5q4==3 |  hs5q4==4 |  hs5q4==5|  hs5q4==6 | hs5q4==9 |  hs5q4==10 |  hs5q4==12
bys hfcode: egen LessALevelStaff_hf=count(hs5q4) if  hs5q4==7 |  hs5q4==8 | hs5q4==13 |  hs5q4==14

/*
1=Clinical officer
2=Medical doctor
3=Enrolled midwife
4=Registered midwife
5=Enrolled nurse
6=Registered nurse
7=Nursing aide/assistant
8=Health assistant
9=Dental assistant
10=Laboratory assistant
11=Records assistant
12=Comprehensive nurse
13=Vaccinator
14=Other
*/

collapse treatment ALevelStaff_hf LessALevelStaff_hf, by(hfcode)
replace ALevelStaff_hf=0 if ALevelStaff_hf==.
replace LessALevelStaff_hf=0 if LessALevelStaff_hf==.

gen sample1=0
sort hfcode
merge hfcode using "T25_2006_PreTreatVarsHF.dta"
drop _merge
sort hfcode
save "T25_2006_PreTreatVarsHF.dta", replace


***** USER CHARGES *******
use "hh_Pbl.dta", clear
* USER CHARGES
sort hfcode
gen avg_charge_drugs=(s5q1a==1)
gen avg_charge_gentreat=(s5q2a==1)
gen avg_charge_injection=(s5q3a==1)
gen avg_charge_del=(s7q16==1)

collapse dcode  treatment sample1   avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del, by(hfcode)

sort hfcode
merge hfcode using "T25_2006_PreTreatVarsHF.dta"
drop _merge
sort hfcode
save "T25_2006_PreTreatVarsHF.dta", replace


* HOUSEHOLD DATA  *

* QUALITY OF SERVICES ACCORDING TO USERS

use "hh_Pbl.dta", clear

* equipment
rename s3q9 equip
replace equip=0 if equip==2


* waiting time
* generate two variables for time: hrs and mins from s24 and s211
tostring  s2q4, gen(s24_str)
replace s24_str="2400" if s24_str=="0"
replace s24_str="0" + s24_str if length( s24_str) == 3
gen s24_min=substr(s24_str, -2,2)
gen s24_hr=substr( s24_str, -4,2)
destring  s24_min s24_hr, replace
label var s24_min "at what time did you visit the hf? - minutes"
label var s24_hr "at what time did you visit the hf? - hour"
tostring  s2q11, gen(s211_str)
replace s211_str="2425" if s211_str=="25"
replace s211_str="0" + s211_str if length( s211_str) == 3
gen s211_min=substr(s211_str, -2,2)
gen s211_hr=substr( s211_str, -4,2)
destring  s211_min s211_hr, replace
label var s211_min "at what time did you leave the hf? - minutes"
label var s211_hr "at what time did you leave the hf? - hour"
gen temp= s211_hr- s24_hr
gen temp_min=temp*60
gen timeinhf=temp_min+ s211_min- s24_min
/*Approach used in QJE paper waiting time variable: assume that if the patient were not examined: examination-time==0*/
gen exam_time=s3q8
replace exam_time=0 if s3q2==2
gen wtime=timeinhf-exam_time
gen waittime=wtime
replace waittime=exam_time if wtime<0


keep hhcode vcode  dcode treatment sample1   waittime equip year s3q5 s3q6 s3q7
sort hhcode
save "T25_2006_PreTreatVarsHH.dta", replace



* HOUSEHOLD UTILIZATION PATTERN
use "hhutil_Pbl.dta", clear

recode s1q11b s1q11c s1q11d s1q11e s1q11f s1q11g s1q11h s1q11i (88=.)
* I) 
label var s1q11b "How many times did person x seek medical care from hfx?"
label var s1q11c "How many times did person x seek medical care from NGO?"
label var s1q11d "How many times did person x seek medical care from private (for profit)?"
label var s1q11e "How many times did person x seek medical care from a traditional healer?"
label var s1q11f "How many times did person x seek medical care from a community health worker?"
label var s1q11g "How many times did person x selft treat?"
label var s1q11h "How many times did person x seek medical care from other gvt facilities?"
label var s1q11i "How many times did person x seek medical care from other?"

* II) generate for each variable a sum for the hh
local newvar "s1q11b s1q11c s1q11d s1q11e s1q11f s1q11g s1q11h s1q11i"  
sort hhcode
foreach x of local newvar{
by hhcode: egen tot_`x'=total(`x')
}
label var tot_s1q11b "How many times did people in the hh seek medical care from hfx?"
label var tot_s1q11c "How many times did people in the hh seek medical care from NGO?"
label var tot_s1q11d "How many times did people in the hh seek medical care from private (for profit)?"
label var tot_s1q11e "How many times did people in the hh seek medical care from a traditional healer?"
label var tot_s1q11f "How many times did people in the hh seek medical care from a community health worker?"
label var tot_s1q11g "How many times did people in the hh did selft treat?"
label var tot_s1q11h "How many times did people in the hh seek medical care from other gvt facilities?"
label var tot_s1q11i "How many times did people in the hh seek medical care from other?"

egen tot_medicalvisit=rowtotal( tot_s1q11b tot_s1q11c tot_s1q11d tot_s1q11e tot_s1q11f tot_s1q11g tot_s1q11h tot_s1q11i)

* III) generate ratio (number of times people in the hh have gone to service provider X) / (total number of times people have sought ANY health care)
local newvar "tot_s1q11b tot_s1q11c tot_s1q11d tot_s1q11e tot_s1q11f tot_s1q11g tot_s1q11h tot_s1q11i" 
sort hhcode
foreach x of local newvar{
gen ratio_`x'=`x'/tot_medicalvisit if tot_medicalvisit!=0
}

gen STTH_ratio=(tot_s1q11e + tot_s1q11g)/tot_medicalvisit if tot_medicalvisit!=0

rename  ratio_tot_s1q11b hfx_ratio 
rename  ratio_tot_s1q11c NGO_ratio
rename  ratio_tot_s1q11d PFP_ratio
rename  ratio_tot_s1q11e TH_ratio
rename  ratio_tot_s1q11f CHW_ratio
rename  ratio_tot_s1q11g ST_ratio
rename  ratio_tot_s1q11h OthGov_ratio
rename  ratio_tot_s1q11i Other_ratio
label var hfx_ratio "HHratio numb times hh members sought medical care from hfx\times hh members sought ANY hc"
label var NGO_ratio "HHratio numb times hh members sought medical care from an ngo clinic\times hh members sought ANY hc"
label var PFP_ratio "HHratio numb times hh members sought medical care from private (for profit)\times hh members sought ANY hc"
label var TH_ratio "HHratio numb times hh members sought medical care from a traditional healer\times hh members sought ANY hc"
label var CHW_ratio "HHratio numb times hh members sought medical care from a community health worker\times hh members sought ANY hc"
label var ST_ratio "HHratio numb times hh members selft treated\times hh members sought ANY hc"
label var OthGov_ratio "HHratio numb times hh members sought medical care from ther gvt\times hh members sought ANY hc"
label var Other_ratio "HHratio numb times hh members sought medical care from other\times hh members sought ANY hc "

collapse vcode hfcode dcode  treatment sample1 tot_medicalvisit  hfx_ratio-STTH_ratio, by(hhcode)
sort hhcode
gen year=2006


keep hhcode vcode hfcode dcode treatment sample1  hfx_ratio NGO_ratio PFP_ratio STTH_ratio OthGov_ratio Other_ratio
sort hhcode
merge hhcode using "T25_2006_PreTreatVarsHH.dta"
save "T25_2006_PreTreatVarsHH.dta", replace



*************************************
*** REGRESSIONS TABLE 1: PANEL B ****
*************************************

use "T25_2006_PreTreatVarsHF.dta", clear

*OUTPATIENT CARE*
regr avgOP treatment if sample1==0, robust
bys treatment: sum avgOP if sample1==0

*DELIVERY*
regr avgDEL treatment if sample1==0, robust
bys treatment: sum avgDEL  if sample1==0


* NO. OF HOUSEHOLDS IN CATCHMENT AREA
reg hhs treatment, robust
bys treatment: sum hhs  

* NO OF HOUSEHOLDS PER VILLAGE
reg hh_vill treatment, robust
bys treatment: sum hh_vill  

* ACCESS TO SAFE WATER
regr hs2q11 treatment if sample1==0, robust
bys treatment: sum hs2q11  if sample1==0

* ACCESS TO ELECTRICITY
regr nopower treatment if sample1==0, robust
bys treatment: sum nopower  if sample1==0



*************************************
*** REGRESSIONS TABLE 2: PANEL B ****
*************************************
use "T25_2006_PreTreatVarsHF.dta", clear

*****AVERAGE STANDARDIZED PRE-TREATMENT EFFECTS*****

* Utilization from the health facility records
mysureg (avgOP treatment) (avgDEL treatment) if sample1==0, vce(robust)
sum avgOP avgDEL if sample1==0 & treatment==0
lincom (0.5/  330.2487)*[ avgOP]treatment + (0.5/9.981377)*[ avgDEL]treatment


* Catchment area statistics
mysureg (hhs treatment) (hh_vill treatment) (villagen treatment) (village1 treatment) (village3 treatment) , vce(robust)
sum hhs hh_vill villagen village1 village3 if treatment==0
lincom (0.2/1143.56)*[hhs]treatment + (0.2/41.7)*[hh_vill]treatment + (0.2/13.35)*[villagen]treatment + (0.2/0.97)*[village1]treatment + (0.2/4.43)*[village3]treatment


* Supply of Drugs
mysureg ( avg_eryth treatment) ( avg_chloroq treatment) ( avg_septrine treatment) ( avg_quinine treatment) ( avg_meb treatment) if sample1==0, vce(robust)
sum avg_eryth avg_chloro avg_septrine avg_quinine avg_meb if sample1==0 & treatment==0
lincom (0.20/447.78)*[ avg_eryth]treatment + (0.20/3197.9)*[ avg_chloroq]treatment+(0.20/1682.1)*[ avg_septrine]treatment + (0.20/612.12)*[ avg_quinine]treatment+(0.20/723.50)*[ avg_meb]treatment


* Health facility characteristics
mysureg (hs2q11  treatment) (piped_water treatment ) (nopower treatment )  (yellow_star treatment )  (ALevelStaff_hf treatment ) (LessALevelStaff_hf treatment )if sample1==0, vce(robust)
sum hs2q11 piped_water nopower yellow_star ALevelStaff_hf LessALevelStaff_hf  if sample1==0 & treatment==0
lincom (0.167/0.1)*[hs2q11]treatment +(0.167/0.29)*[piped_water]treatment + (0.167/0.51)*[nopower]treatment +(0.167/0.45)*[yellow_star]treatment+(0.167/1.73)*[ALevelStaff_hf]treatment+(0.167/1.36)*[LessALevelStaff_hf]treatment


* User charges
mysureg ( avg_charge_drugs treatment) ( avg_charge_gentreat treatment) ( avg_charge_injection treatment) ( avg_charge_del treatment) if sample1==0, vce(robust)
sum avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del if sample1==0 & treatment==0
lincom -(0.25/.0077025)*[ avg_charge_drugs]treatment-(0.25/.0063024 )*[ avg_charge_gentreat]treatment-(0.25/.0418115 )*[ avg_charge_injection]treatment-(0.25/.021387 )*[avg_charge_del]treatment

use "T25_2006_PreTreatVarsHH.dta", clear

* Quality of services according to the users
mysureg (equip treatment) ( waittime treatment ) if sample1==0, cluster(hfcode)
sum equip waittime if sample1==0 & treatment==0
lincom (0.5/0.49)*[equip]treatment - (0.5/114.8)*[ waittime]treatment

* Utilization from the household
mysureg (hfx_ratio treatment) (NGO_ratio treatment) (PFP_ratio treatment) (OthGov_ratio treatment) (Other_ratio treatment) ( STTH_ratio treatment) if sample1==0, cluster(hfcode)
sum hfx_ratio NGO_ratio PFP_ratio STTH_ratio OthGov_ratio Other_ratio if sample1==0 & treatment==0
lincom (0.167/.2222)*[hfx_ratio]treatment+(0.167/0.09598)*[NGO_ratio]treatment+(0.167/0.16521)*[PFP_ratio]treatment+(0.167/0.1096)*[OthGov_ratio]treatment+(0.167/0.1769)*[Other_ratio]treatment-(0.167/.2235)*[STTH_ratio]treatment

* Citizen perceptions of treatment
mysureg ( s3q5 treatment) ( s3q6 treatment) ( s3q7 treatment) if sample1==0, cluster(hfcode)
sum s3q5 s3q6 s3q7   if sample1==0 & treatment==0
lincom (0.33/0.54)*[s3q5]treatment + (0.33/0.58)*[s3q6]treatment+(0.33/0.50)*[s3q7]treatment 


*************************************
*** REGRESSIONS TABLE 1: PANEL A ****
*************************************

* data for this sample is generated for the paper published in Quarterly Journal of Economics, 2009, "Power to the People". 
* We are here providing the variables used in the regressions

*use "/Users/ma.2557/Dropbox/Documents/CRCCL impact evaluation 2006/PtoP_QJE Replication/Replication/Data/final/hfmain_2004.dta", clear

use hfmain_2004.dta, clear

*OUTPATIENT CARE*
bys treatment: sum avgOP if year==2004
regr avgOP treatment if year==2004, robust

*DELIVERY*
bys treatment: sum avgDEL if year==2004
regr avgDEL treatment if year==2004, robust

* No. of households in catchment area*
bys treatment: sum hhs if year==2004
regr hhs treatment if year==2004, robust

*No. of households per village*
bys treatment: sum hh_vill if year==2004
regr hh_vill treatment if year==2004, robust

*DRANK SAFELY TODAY*
bys treatment: sum drinksafely_2004 if year==2004
regr drinksafely_2004 treatment if year==2004, robust

*No. of days without electricity in past month*
bys treatment: sum nopower04 if year==2004
regr nopower04 treatment if year==2004, robust


*************************************
*** REGRESSIONS TABLE 2: PANEL A ****
*************************************

*****AVERAGE STANDARDIZED PRE-TREATMENT EFFECTS*****

*UTILIZATION*
*use  "/Users/ma.2557/Dropbox/Documents/CRCCL impact evaluation 2006/PtoP_QJE Replication/Replication/Data/final/hfmain_2004.dta",clear
use hfmain_2004.dta, clear
mysureg (avgOP treatment) (avgDEL treatment) if year==2004, vce(robust)
sum avgOP if year==2004 & treatment==0
sum avgDEL if year==2004 & treatment==0
lincom (0.5/286.21)*[ avgOP]treatment+ (0.5/6.80)*[ avgDEL]treatment


*UTILIZATION PATTERN*
*use "/Users/ma.2557/Dropbox/Documents/CRCCL impact evaluation 2006/PtoP_QJE Replication/Replication/Data/final/hhmain_2004.dta", clear	
use hhmain_2004.dta, clear

mysureg (hfx_ratio treatment) (NGO_ratio treatment) (PFP_ratio treatment) (STTH_ratio treatment) (OthGov_ratio treatment) (Other_ratio treatment) if year==2004, cluster(hfcode)
sum hfx_ratio if  treatment==0
sum NGO_ratio  if treatment==0
sum PFP_ratio if  treatment==0
sum STTH_ratio if  treatment==0
sum OthGov_ratio if  treatment==0
sum Other_ratio if  treatment==0
lincom (0.14/0.335)*[hfx_ratio]treatment+(0.14/0.102)*[NGO_ratio]treatment+(0.14/0.282)*[PFP_ratio]treatment-(0.14/0.34)*[STTH_ratio]treatment+(0.14/0.199)*[OthGov_ratio]treatment+(0.14/0.061)*[Other_ratio]treatment
*reversing sign on STTH


*QUALITY MEASURES*
*use "/Users/ma.2557/Dropbox/Documents/CRCCL impact evaluation 2006/PtoP_QJE Replication/Replication/Data/final/wtime_equip_2004.dta", clear
use wtime_equip_2004.dta, clear
mysureg (equip treatment) ( wtime treatment ), cluster(hfcode)
sum equip if treatment==0
sum wtime if treatment==0
lincom (0.5/.50)*[equip]treatment - (0.5/98.09)*[ wtime]treatment
*reversing sign on wtime


*CATCHMENT AREA CHARACTERISTICS*
*use  "/Users/ma.2557/Dropbox/Documents/CRCCL impact evaluation 2006/PtoP_QJE Replication/Replication/Data/final/hfmain_2004.dta",clear
use hfmain_2004.dta,clear
mysureg (hhs treatment) (hh_vill treatment) (villagen treatment) (village1 treatment) (village3 treatment) if year==2004, vce(robust)
sum hhs if year==2004 & treatment==0
sum hh_vill if year==2004 & treatment==0
sum villagen if year==2004 & treatment==0
sum village1 if year==2004 & treatment==0
sum village3 if  year==2004 & treatment==0
lincom (0.2/1021.38)*[hhs]treatment + (0.2/31.59)*[hh_vill]treatment + (0.2/12.07)*[villagen]treatment + (0.2/1.31)*[village1]treatment + (0.2/6.73)*[village3]treatment



*HEALTH FACILITY CHARACTERISTICS*
mysureg (ws1 treatment) (DMU treatment ) (nopower04 treatment ) (distLC1 treatment ) (dist432 treatment ) (drinksafely_2004 treatment )( alevel treatment ) ( lower_alevel treatment ) (radio treatment) (newspaper treatment) if year==2004, vce(robust)
sum ws1 if year==2004 & treatment==0
sum DMU if year==2004 & treatment==0
sum nopower04 if  year==2004 & treatment==0
sum distLC1 if  year==2004 & treatment==0
sum dist432 if  year==2004 & treatment==0
sum drinksafely_2004 if year==2004 & treatment==0
sum alevel if  year==2004 & treatment==0
sum lower_alevel if  year==2004 & treatment==0
sum radio if  year==2004 & treatment==0
sum newspaper if year==2004 & treatment==0
lincom (0.1/0.2)*[ws1]treatment + (0.1/0.37)*[DMU]treatment-(0.1/14.5)*[nopower04]treatment - (0.1/1.05)*[distLC1]treatment+ (0.1/8.98)*[dist432]treatment+ (0.1/0.48)*[drinksafely_2004]treatment+ (0.1/0.73)*[alevel]treatment+ (0.1/1.52)*[lower_alevel]treatment+(0.1/0.48)*[radio]treatment+(0.1/0.37)*[newspaper]treatment


*CITIZEN PERCEPTIONS*
*use "/Users/ma.2557/Dropbox/Documents/CRCCL impact evaluation 2006/PtoP_QJE Replication/Replication/Data/final/hhmain_2004.dta", clear
use hhmain_2004.dta, clear
mysureg (polite treatment) (attention treatment) ( express_free treatment), cluster(hfcode)
sum polite if  treatment==0
sum attention if treatment==0
sum express_free if  treatment==0
lincom (0.33/0.6415)*[polite]treatment+(0.33/0.6819)*[attention]treatment+(0.33/0.6498)*[express_free]treatment


*SUPPLY OF DRUGS*
*use  "/Users/ma.2557/Dropbox/Documents/CRCCL impact evaluation 2006/PtoP_QJE Replication/Replication/Data/final/hfmain_2004.dta",clear
use hfmain_2004.dta, clear
mysureg ( avg_eryth treatment) ( avg_chloro treatment) ( avg_cotrim treatment) ( avg_quinine treatment) ( avg_meb treatment) if year==2004, vce(robust)
sum avg_eryth if year==2004 & treatment==0
sum avg_chloro if year==2004 & treatment==0
sum avg_cotrim if year==2004 & treatment==0
sum avg_quinine if year==2004 & treatment==0
sum avg_meb if year==2004 & treatment==0
lincom (0.20/332.64)*[ avg_eryth]treatment+(0.20/1688.00)*[ avg_chloro]treatment+(0.20/2012.76)*[ avg_cotrim]treatment+(0.20/365.17)*[ avg_quinine]treatment+(0.20/750)*[ avg_meb]treatment

*USER CHARGES*
*use "/Users/ma.2557/Dropbox/Documents/CRCCL impact evaluation 2006/PtoP_QJE Replication/Replication/Data/final/average_charges_hflevel_2004.dta", clear
use average_charges_hflevel_2004.dta, clear
mysureg ( avg_charge_drugs treatment) ( avg_charge_gentreat treatment) ( avg_charge_injection treatment) ( avg_charge_del treatment) if year==2004, vce(robust)
sum avg_charge_drugs if year==2004 & treatment==0
sum avg_charge_gentreat if year==2004 & treatment==0
sum avg_charge_injection if year==2004 & treatment==0
sum avg_charge_del if year==2004 & treatment==0
lincom -(0.25/0.031)*[ avg_charge_drugs]treatment-(0.25/0.052)*[ avg_charge_gentreat]treatment-(0.25/0.228)*[ avg_charge_injection]treatment-(0.25/0.289)*[avg_charge_del]treatment


** CREATE CONTROL VARIABLE FILE FOR COMPARISON REGRESSIONS **

*use  "/Users/ma.2557/Dropbox/Documents/CRCCL impact evaluation 2006/PtoP_QJE Replication/Replication/Data/final/hfmain_2004.dta",clear
use hfmain_2004.dta,clear
keep hfcode  avgDEL avgOP hhs hh_vill
merge hfcode using "/Users/ma.2557/Dropbox/Documents/CRCCL impact evaluation 2006/PtoP_QJE Replication/Replication/Data/final/average_charges_hflevel_2004.dta"
* merge hfcode using average_charges_hflevel_2004.dta
keep hfcode avgDEL avgOP hhs hh_vill  avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del
rename avgDEL avgDEL_baseline
rename avgOP avgOP_baseline
sort hfcode
save "baselinecontrols.dta", replace

use "T25_2006_PreTreatVarsHF.dta", clear
keep hfcode avgOP avgDEL hhs hh_vill avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del
rename avgDEL avgDEL_baseline
rename avgOP avgOP_baseline
sort hfcode
append using "baselinecontrols.dta"
sort hfcode
save "baselinecontrols.dta", replace

