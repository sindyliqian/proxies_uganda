

* Experimental Evidence on the Long-Run Impact of Community Based Monitoring
* American Economic Journal: Applied Economics

clear all
set more off
capture log close

cd "/Users/ma.2557/Dropbox/Documents/CRCCL2/AEJ_AppliedEcon/Replication files/Dataset/"


***********************************************************
*** TABLE 7: PROCESSES AND HEALTH TREATMENT PRACTICES *****
***********************************************************


** Column (i): Monitoring and information (health facility data)

use "hf_PIPendl.dta", clear 

** s12_14==suggestion box
** s12_11==waiting cards
** s12_5==posters for services free
** s12_4==poster on patients rights and obligations
** s12_7==duty roaster publicly visible

** Panel A, column (i)
xi i.dcode
sum s12_14 s12_11 s12_5 s12_4  s12_7  if sample1==1 & treatment==0
mysureg (s12_14 treatment  _Idcode_2-_Idcode_11) (s12_11 treatment _Idcode_2-_Idcode_11) (s12_5 treatment _Idcode_2-_Idcode_11) (s12_4 treatment _Idcode_2-_Idcode_11) (s12_7 treatment _Idcode_2-_Idcode_11) if sample1==1, vce(robust)
lincom (0.2/0.277)*[s12_14]treatment + (0.2/.277)*[s12_11]treatment + (0.2/0.332)*[s12_5]treatment + (0.2/0.2)*[s12_4]treatment + (0.2/0.277)*[s12_7]treatment 

** Panel B, column (i)
sum s12_14 s12_11 s12_5 s12_4  s12_7  if sample1==0 & treatment==0
mysureg (s12_14 treatment  _Idcode_2-_Idcode_11) (s12_11 treatment _Idcode_2-_Idcode_11) (s12_5 treatment _Idcode_2-_Idcode_11) (s12_4 treatment _Idcode_2-_Idcode_11) (s12_7 treatment _Idcode_2-_Idcode_11) if sample1==0, vce(robust)
lincom (0.2/0.39)*[s12_14]treatment + (0.2/.39)*[s12_11]treatment + (0.2/0.45)*[s12_5]treatment + (0.2/0.39)*[s12_4]treatment + (0.2/0.28)*[s12_7]treatment 


rename s12_14 suggbox
rename s12_11 waitcards
rename s12_7 dutyroster
rename s12_5 posterfreeserv
rename s12_4 posterpatrights

gen suggbox_waitcards=suggbox+waitcards

save processes.dta, replace


*  Panel C, column (i): SHORT-RUN IMPACT INFORMATION AND PARTICIPATION EXPERIMENT (REPORTED IN POWER TO THE PEOPLE, 2009, QJE) *

use "hfdata_PI2006.dta", clear

*** AVERAGE STANDARDIZED EFFECT (v) ***
* std deviation for hs12q10 in the control group is 0 so we sum hs12q10 and hs12q9.  */
gen hs12q10_9=hs12q10+hs12q9

xi i.dcode
mysureg (hs12q6 treatment  _Idcode_2-_Idcode_11) (hs12q10_9 treatment  _Idcode_2-_Idcode_11) (hs12q5 treatment  _Idcode_2-_Idcode_11) (hs12q4 treatment _Idcode_2-_Idcode_11), vce(robust) 
sum hs12q6 hs12q10_9 hs12q5 hs12q4 if treatment==0
lincom (0.25/0.49)*[hs12q6]treatment+(0.25/0.2)*[hs12q10_9]treatment + (0.25/0.33)*[hs12q5]treatment + (0.25/0.33)*[hs12q4]treatment

rename hs12q10 suggbox
rename hs12q9 waitcards
rename hs12q10_9 suggbox_waitcards
rename hs12q6 dutyroster
rename hs12q5 posterfreeserv
rename hs12q4 posterpatrights

append using processes.dta


** COMPARISON I&P(SR) vs. P(SR)

gen sample1_t=sample1*treatment

gen SR=(sample1==1 & year==2006) | (sample1==0 & year==2009)
gen LR=(sample1==1 & year==2009) | (sample1==0 & year==2009)

gen dcode1=100+dcode
replace dcode1=0 if sample1==1
replace dcode=0 if dcode==.
replace dcode1=0 if dcode1==.

sort  hfcode
save hfdata.dta, replace

merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 

gen charge2= avg_charge_gentreat^2
gen op2= avgOP_baseline ^2
gen hhs2=hhs^2

drop _merge

sort year hfcode
save processes_hf.dta, replace


gsem (dutyroster <-  sample1 treatment sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (suggbox_waitcards <-  sample1 treatment sample1_t   i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (posterpatrights <-  sample1 treatment sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (posterfreeserv <-  sample1 treatment sample1_t   i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) if SR==1, vce(robust) 
sum suggbox_waitcards dutyroster posterfreeserv posterpatrights if SR==1 & treatment==0 & sample1==1
sum suggbox_waitcards dutyroster posterfreeserv posterpatrights if SR==1 & treatment==0 & sample1==0
lincom ((0.25/0.49)*[dutyroster]treatment+(0.25/0.49)*[dutyroster]sample1_t +(0.25/0.2)*[suggbox_waitcards]treatment+(0.25/0.2)*[suggbox_waitcards]sample1_t+ (0.25/0.33)*[posterpatrights]treatment+ (0.25/0.33)*[posterpatrights]sample1_t+ (0.25/0.33)*[posterfreeserv]treatment+ (0.25/0.33)*[posterfreeserv]sample1_t)-((0.25/0.29)*[dutyroster]treatment +(0.25/0.49)*[suggbox_waitcards]treatment+ (0.25/0.39)*[posterpatrights]treatment+ (0.25/0.45)*[posterfreeserv]treatment)



** COMPARISON I&P(LR) vs. P(SR)


gsem (dutyroster <-  sample1 treatment sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (suggbox_waitcards <-  sample1 treatment sample1_t   i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (posterpatrights <-  sample1 treatment sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (posterfreeserv <-  sample1 treatment sample1_t   i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) if LR==1, vce(robust) 
sum suggbox_waitcards dutyroster posterfreeserv posterpatrights if LR==1 & treatment==0 & sample1==1
sum suggbox_waitcards dutyroster posterfreeserv posterpatrights if LR==1 & treatment==0 & sample1==0
lincom ((0.25/0.28)*[dutyroster]treatment+(0.25/0.28)*[dutyroster]sample1_t +(0.25/0.37)*[suggbox_waitcards]treatment+(0.25/0.37)*[suggbox_waitcards]sample1_t+ (0.25/0.2)*[posterpatrights]treatment+ (0.25/0.2)*[posterpatrights]sample1_t+ (0.25/0.33)*[posterfreeserv]treatment+ (0.25/0.33)*[posterfreeserv]sample1_t)-((0.25/0.29)*[dutyroster]treatment +(0.25/0.49)*[suggbox_waitcards]treatment+ (0.25/0.39)*[posterpatrights]treatment+ (0.25/0.45)*[posterfreeserv]treatment)



** Column (ii): Monitoring and information (household data)

use "hh_PIPendl.dta", clear
xi i.dcode

*Performance of staff/health facility discussed in LC meetings during past yar
* summarized variable of three dummy vars: max=3 if discuss everything at the LC meeting, min=0 if no discussion at all at LC meeting
replace s623=. if s623==8 
gen lcmtg_discuss=s623+ s624+ s625

replace s618=. if s618==8

gen monitoring_hhs=(s649+ s651+ s653+ s655+ s661)


** Panel A, column (ii)
gsem (lcmtg_discuss <-  treatment  i.dcode) (s627 <-  treatment  i.dcode) (s411 <- treatment  i.dcode) (s618 <- treatment i.dcode)(monitoring_hhs <- treatment  i.dcode)  if sample1==1, vce(cluster hfcode) 
sum lcmtg_discuss s627 s411 s618 monitoring_hhs if treatment==0 & sample1==1
lincom (0.20/1.11)*[lcmtg_discuss]treatment + (0.20/.35)*[s627]treatment+(0.20/.43)*[s411]treatment + (0.20/.36)*[s618]treatment+(0.20/.65)*[monitoring_hhs]treatment 


** Panel B, column (ii)

gsem (lcmtg_discuss <-  treatment  i.dcode) (s627 <-  treatment  i.dcode) (s411 <- treatment  i.dcode) (s618 <- treatment i.dcode)(monitoring_hhs <- treatment  i.dcode)  if sample1==0, vce(cluster hfcode)
sum lcmtg_discuss s627 s411 s618 monitoring_hhs if treatment==0 & sample1==0
lincom (0.20/1.14)*[lcmtg_discuss]treatment + (0.20/.33)*[s627]treatment+(0.20/.45)*[s411]treatment + (0.20/.36)*[s618]treatment+(0.20/.64)*[monitoring_hhs]treatment 

keep hhcode hfcode dcode treatment sample1   lcmtg_discuss s627 s411 s618 monitoring_hhs

gen year=2009

rename s627 humc

sort year hhcode
save monitoring_hh.dta, replace


*  Panel C, column (ii): SHORT-RUN IMPACT INFORMATION AND PARTICIPATION EXPERIMENT (REPORTED IN POWER TO THE PEOPLE, 2009, QJE) *

use "hhdata_PI2006.dta", clear

rename s6q24 lcmtg_discuss
rename s6q27 humc
append using monitoring_hh.dta

sort year hhcode 
save monitoring_hh.dta, replace


** COMPARISON I&P(LR) vs. P(SR)


use monitoring_hh.dta, clear
sort hfcode
save monitoring_hh.dta, replace

merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 
drop _merge

gen charge2= avg_charge_gentreat^2
gen op2= avgOP_baseline ^2
gen hhs2=hhs^2


gen sample1_t=sample1*treatment

gen SR=(sample1==1 & year==2006) | (sample1==0 & year==2009)
gen LR=(sample1==1 & year==2009) | (sample1==0 & year==2009)

gen dcode1=100+dcode
replace dcode1=0 if sample1==1
replace dcode=0 if dcode==.
replace dcode1=0 if dcode1==.


sort year hhcode 
save monitoring_hh.dta, replace


gsem (lcmtg_discuss <-  sample1 treatment sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (humc <-  sample1 treatment sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (s411 <- sample1 treatment sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (s618 <- sample1 treatment sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2)(monitoring_hhs <- sample1 treatment sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) if LR==1, vce(cluster hfcode) 
sum lcmtg_discuss humc s411 s618 monitoring_hhs if LR==1 & treatment==0 & sample1==1
sum lcmtg_discuss humc s411 s618 monitoring_hhs if LR==1 & treatment==0 & sample1==0
lincom ((0.20/1.11)*[lcmtg_discuss]treatment+(0.20/1.11)*[lcmtg_discuss]sample1_t + (0.20/.35)*[humc]treatment+ (0.20/.35)*[humc]sample1_t+(0.20/.45)*[s411]treatment+ (0.20/.36)*[s618]treatment+ (0.2/.36)*[s618]sample1_t+(0.20/.65)*[monitoring_hhs]treatment+(0.20/.65)*[monitoring_hhs]sample1_t) - ((0.20/1.14)*[lcmtg_discuss]treatment+ (0.20/.33)*[humc]treatment+(0.20/.25)*[s411]treatment  + (0.20/.36)*[s618]treatment + (0.20/.64)*[monitoring_hhs]treatment)


** COMPARISON I&P(SR) vs. P(SR)

**Not possible since no SR data on I&P project



** Column (iv): Health practices (general)

*waiting time at the clinic and whether any equipment was used during examination reported by the patients 

use "hh_PIPendl.dta", clear

gen equip=s39 if s39!=3

replace s211_hr=24 if s211_str=="00.25"

gen temp= s211_hr- s24_hr
gen temp_min=temp*60
gen timeinhf=temp_min+ s211_min- s24_min

*Approach used in QJE paper waiting time variable: assume that if the patient were not examined: examination-time==0*

gen exam_time=s38
replace exam_time=0 if s32==0
gen wtime=timeinhf-exam_time
gen waittime=wtime
replace waittime=exam_time if wtime<0

keep equip treatment sample1 waittime hhcode hfcode dcode year

save wtimeequip.dta, replace

* Panel A, column (iv)::
gsem (waittime <-  treatment i.dcode  ) ( equip <-  treatment i.dcode) if sample1==1, vce(cluster hfcode)
sum waittime equip if treatment==0 & sample1==1
lincom (0.50/0.47)*[equip]treatment -(0.50/105.6)*[waittime]treatment 

* Panel B, column (iv)::
gsem (waittime <-  treatment i.dcode  ) ( equip <-  treatment i.dcode) if sample1==0, vce(cluster hfcode)
sum waittime equip if treatment==0 & sample1==0
lincom (0.50/0.47)*[equip]treatment -(0.50/105.6)*[waittime]treatment 


*  Panel C, column (iv): SHORT-RUN IMPACT INFORMATION AND PARTICIPATION EXPERIMENT (REPORTED IN POWER TO THE PEOPLE, 2009, QJE) *

use "hhdata_PI2006.dta", clear

rename wtime waittime

gsem (waittime <-  treatment i.dcode  ) ( equip <-  treatment i.dcode), vce(cluster hfcode)
sum waittime equip if treatment==0 
lincom (0.50/0.49)*[equip]treatment -(0.50/95.9)*[waittime]treatment 

append using wtimeequip.dta

gen sample1_t=sample1*treatment

gen SR=(sample1==1 & year==2006) | (sample1==0 & year==2009)
gen LR=(sample1==1 & year==2009) | (sample1==0 & year==2009)

gen dcode1=100+dcode
replace dcode1=0 if sample1==1
replace dcode=0 if dcode==.
replace dcode1=0 if dcode1==.


sort year hhcode hfcode 
save waittimeequip0609.dta, replace

** COMPARISON I&P(SR) vs. P(SR)
use waittimeequip0609.dta, clear
sort hfcode
save waittimeequip0609.dta, replace


merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 
drop _merge

gen charge2= avg_charge_gentreat^2
gen op2= avgOP_baseline ^2
gen hhs2=hhs^2

sort year hhcode hfcode 
save waittimeequip0609.dta, replace


gsem (waittime <-  treatment sample1 sample1_t i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) ( equip <-  treatment sample1 sample1_t treatment i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) if SR==1, vce(cluster hfcode)
sum waittime equip if SR==1 & treatment==0 & sample1==1
sum waittime equip if SR==1 & treatment==0 & sample1==0
lincom ((0.50/0.49)*[equip]treatment + (0.50/0.49)*[equip]sample1_t -(0.50/95.9)*[waittime]treatment - (0.50/95.9)*[waittime]sample1_t)-((0.50/0.48)*[equip]treatment - (0.50/122.1)*[waittime]treatment)



** COMPARISON I&P(LR) vs. P(SR)
gsem (waittime <-  treatment sample1 sample1_t i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2 ) ( equip <-  treatment sample1 sample1_t treatment i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) if LR==1, vce(cluster hfcode)
sum waittime equip if LR==1 & treatment==0 & sample1==1
sum waittime equip if LR==1 & treatment==0 & sample1==0
lincom ((0.50/0.47)*[equip]treatment + (0.50/0.47)*[equip]sample1_t -(0.50/105.6)*[waittime]treatment - (0.50/105.6)*[waittime]sample1_t)-((0.50/0.48)*[equip]treatment - (0.50/122.1)*[waittime]treatment)



** Column (iii): Management of the clinic

*** ABSENCE RATE ***

use "absenteeism.dta", clear

*creating variables
bys hfcode part: egen nrpresent_today=count(present_today) if present_today==1
label var nrpresent_today "summed from present_today"
* definition of staff present as the point in the qnaire where the enumerator went through together with the in-charge the staff present today
* variable on first page on staff present is just counting how many staff the enumerator saw present when he arrived. Might not be the same as those who were actually there if staff were working in a closed room!

bys hfcode part: egen nr_staff=count(present_today) if present_today!=.
label var nr_staff "counted from present_today var"

bys hfcode part: egen staff_outreach=count(staff_today) if staff_today==2
replace staff_outreach=0 if staff_outreach==.


foreach v of var * {
	local l`v' : variable label `v'
        if `"`l`v''"' == "" {
		local l`v' "`v'"
 	}
 }
collapse (max) dcode id treatment sample1 staff_outreach nrpresent_today nr_staff, by(hfcode part)
sort hfcode

foreach v of var * {
	label var `v' "`l`v''"
 }


gen absence_rate=1-( nrpresent_today/(nr_staff- staff_outreach)) 
bys sample1: sum absence_rate 

** Generating an average absenteeism measure from all unannounced visits
collapse (mean) treatment dcode sample1 absence_rate, by(hfcode)

gen year=2009

keep absence_rate sample1 treatment hfcode dcode year
sort hfcode
save "absence09.dta", replace


*** CONDITION OF THE CLINIC ***

*use "/Users/ma.2557/Dropbox/Documents/CRCCL2/DATA 2009/hfdata_reentered_2009/Regressions/HF 20.12.2010/hf main data set 33T1.dta", clear

use "hf_PIPendl.dta", clear 

gen cl1=4- s14_15
gen cl2=4- s14_16
gen cl3=4- s14_17
gen cl4=4- s14_18
pca  cl1 cl2 cl3 cl4 if sample1==1
predict clean

keep clean sample1 treatment hfcode dcode year
sort hfcode
merge hfcode using absence09.dta
drop _merge
sort hfcode
save absence_cond.dta, replace


*** STOCK OUTS ***

use "sec8_drugsdata.dta", clear

bys hfcode year: egen avg_eryth=mean(s8_b_1)
gen stockouts_eryth= 1-avg_eryth
bys hfcode year: egen avg_coartem=mean(s8_b_2)
gen stockouts_coartem= 1-avg_coartem
bys hfcode year: egen avg_cotri=mean(s8_b_3)
gen stockouts_cotri= 1-avg_cotri
bys hfcode year: egen avg_quin=mean(s8_b_4)
gen stockouts_quin= 1-avg_quin

gen missingdata=1 if stockouts_eryth==.  |  stockouts_coartem==.  |  stockouts_cotri==.  |  stockouts_quin==.

*only include health facilities that have a complete record of drugs
gen stockouts=( stockouts_eryth+ stockouts_coartem+ stockouts_cotri+ stockouts_quin)/4
*egen stockouts=rowmean( stockouts_eryth stockouts_coartem stockouts_cotri stockouts_quin)

collapse  id dcode treatment   sample1  s8_b_1  s8_b_2 s8_b_3 s8_b_4 avg_eryth stockouts_eryth avg_coartem avg_cotri avg_quin stockouts_coartem stockouts_cotri stockouts_quin stockouts, by(hfcode year)

egen stockouts1=rowmean( stockouts_eryth  stockouts_coartem  stockouts_cotri  stockouts_quin) if  stockouts_eryth!=.  |  stockouts_coartem!=.  |  stockouts_cotri!=.  |  stockouts_quin!=.

*** the average across all three years (2006-2008)

collapse (max) dcode treatment sample1 (mean) stockouts_eryth stockouts_coartem stockouts_cotri stockouts_quin stockouts stockouts1, by(hfcode)


gen year=2009
keep stockouts treatment sample1 dcode hfcode year
sort hfcode
merge hfcode using absence_cond.dta
drop _merge
sort hfcode

* Panel A, Column (iii):

gsem (absence_rate <-  treatment i.dcode ) ( clean <-  treatment  i.dcode) ( stockouts <-  treatment i.dcode) if year==2009 & sample1==1, vce(robust)
sum absence_rate clean stockouts if year==2009 & sample1==1 & treatment==0
lincom (0.33/1.79)*[clean]treatment -(0.33/0.12)*[absence_rate]treatment -(0.33/0.10)*[stockouts]treatment 

* Panel B, Column (iii):

gsem (absence_rate <-  treatment i.dcode ) ( clean <-  treatment  i.dcode) ( stockouts <-  treatment i.dcode) if year==2009 & sample1==0, vce(robust)
sum absence_rate clean stockouts if year==2009 & sample1==0 & treatment==0
lincom (0.33/1.13)*[clean]treatment -(0.33/0.13)*[absence_rate]treatment -(0.33/0.15)*[stockouts]treatment 


save absence_cond_stockouts09.dta, replace

use "hfdata_PI2006.dta", clear

rename absence absence_rate

sort hfcode
append using absence_cond_stockouts09.dta
sort year hfcode
save absence_cond_stockouts0609.dta, replace


*  Panel C, column (iii): SHORT-RUN IMPACT INFORMATION AND PARTICIPATION EXPERIMENT (REPORTED IN POWER TO THE PEOPLE, 2009, QJE) *

gsem (absence_rate <-  treatment i.dcode ) ( clean <-  treatment  i.dcode) ( stockouts <-  treatment i.dcode) if year==2006 & sample1==1, vce(robust)
sum absence_rate clean stockouts if year==2006 & sample1==1 & treatment==0

lincom (0.33/1.99)*[clean]treatment -(0.33/0.26)*[absence_rate]treatment -(0.33/0.20)*[stockouts]treatment 


use absence_cond_stockouts0609.dta, clear
sort hfcode
save absence_cond_stockouts0609.dta, replace


merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 
drop _merge

gen charge2= avg_charge_gentreat^2
gen avgOP_baseline2= avgOP_baseline ^2
gen hhs2=hhs^2

gen sample1_t=sample1*treatment

gen SR=(sample1==1 & year==2006) | (sample1==0 & year==2009)
gen LR=(sample1==1 & year==2009) | (sample1==0 & year==2009)

gen dcode1=100+dcode
replace dcode1=0 if sample1==1
replace dcode=0 if dcode==.
replace dcode1=0 if dcode1==.

sort year hfcode 
save absence_cond_stockouts0609.dta, replace

*Panel C, Column (iii):

** DIFFERENTIAL EFFECT I&P(SR) vs. P(SR)
use absence_cond_stockouts0609.dta, clear

gsem (absence_rate <-  treatment sample1 sample1_t i.dcode i.dcode1  avg_charge_gentreat avgOP_baseline hhs charge2 avgOP_baseline2 hhs2) ( clean <-  treatment sample1 sample1_t treatment i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 avgOP_baseline2 hhs2) ( stockouts <-  treatment sample1 sample1_t treatment i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 avgOP_baseline2 hhs2) if SR==1, vce(robust)
sum absence_rate clean stockouts if SR==1 & treatment==0 & sample1==1
sum absence_rate clean stockouts if SR==1 & treatment==0 & sample1==0
lincom ((0.33/1.98)*[clean]treatment + (0.33/1.98)*[clean]sample1_t -(0.33/0.26)*[absence_rate]treatment - (0.33/0.26)*[absence_rate]sample1_t  -(0.33/0.21)*[stockouts]treatment - (0.33/0.21)*[stockouts]sample1_t)-((0.33/1.13)*[clean]treatment - (0.33/0.13)*[absence_rate]treatment - (0.33/0.15)*[stockouts]treatment)

** DIFFERENTIAL EFFECT I&P(LR) vs. P(SR)

gsem (absence_rate <-  treatment sample1 sample1_t i.dcode i.dcode1  avg_charge_gentreat avgOP_baseline hhs charge2 avgOP_baseline2 hhs2) ( clean <-  treatment sample1 sample1_t treatment i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 avgOP_baseline2 hhs2) ( stockouts <-  treatment sample1 sample1_t treatment i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 avgOP_baseline2 hhs2) if LR==1, vce(robust)
sum absence_rate clean stockouts if LR==1 & treatment==0 & sample1==1
sum absence_rate clean stockouts if LR==1 & treatment==0 & sample1==0
lincom ((0.33/1.79)*[clean]treatment + (0.33/1.79)*[clean]sample1_t -(0.33/0.12)*[absence_rate]treatment - (0.33/0.12)*[absence_rate]sample1_t  -(0.33/0.10)*[stockouts]treatment - (0.33/0.10)*[stockouts]sample1_t)-((0.33/1.13)*[clean]treatment - (0.33/0.13)*[absence_rate]treatment - (0.33/0.15)*[stockouts]treatment)


** Column (v): Antenatal and postnatal care

use "sec7_birth_preg.dta", replace

xi i.dcode

gen sample1_t=sample1*treatment

gen dcode1=100+dcode
replace dcode1=0 if sample1==1
replace dcode=0 if dcode==.
replace dcode1=0 if dcode1==.

* PANEL A:
sum s7_17b s7_20a s7_20d s7_20e s7_21 s7_51 if sample1==1 & treatment==0
mysureg (s7_17b  treatment  _Idcode_2- _Idcode_11) (s7_20a  treatment  _Idcode_2- _Idcode_11) (s7_20d  treatment  _Idcode_2- _Idcode_11) (s7_20e  treatment  _Idcode_2- _Idcode_11) (s7_21  treatment  _Idcode_2- _Idcode_11) (s7_51  treatment  _Idcode_2- _Idcode_11)  if sample1==1, cluster(hfcode)
lincom (0.167/.33)*[s7_17b]treatment + (0.167/.49)*[s7_20a]treatment + (0.167/0.50)*[s7_20d]treatment + (0.167/0.21)*[s7_20e]treatment + (0.167/0.50)*[s7_21]treatment + (0.167/0.48)*[s7_51]treatment 

*PANEL B:
sum s7_17b s7_20a s7_20d s7_20e s7_21 s7_51 if sample1==0 & treatment==0
mysureg (s7_17b  treatment  _Idcode_2- _Idcode_11) (s7_20a  treatment  _Idcode_2- _Idcode_11) (s7_20d  treatment  _Idcode_2- _Idcode_11) (s7_20e  treatment  _Idcode_2- _Idcode_11) (s7_21  treatment  _Idcode_2- _Idcode_11) (s7_51  treatment  _Idcode_2- _Idcode_11)  if sample1==0, cluster(hfcode)
lincom (0.167/.18)*[s7_17b]treatment + (0.167/.44)*[s7_20a]treatment + (0.167/0.50)*[s7_20d]treatment + (0.167/0.20)*[s7_20e]treatment + (0.167/0.48)*[s7_21]treatment + (0.167/0.46)*[s7_51]treatment 


*PANEL C:
*can not do I&P(SR) vs. P(SR) comparison since we did not collect this data in 2006.

** DIFFERENTIAL EFFECT I&P(LR) vs. P(SR)

sort hfcode
save ante_postnatal.dta, replace

merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 
drop _merge

gen charge2= avg_charge_gentreat^2
gen op2= avgOP_baseline ^2
gen hhs2=hhs^2

sort year hhcode 
save ante_postnatal.dta, replace

gsem (s7_17b <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (s7_20a <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (s7_20d <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (s7_20e <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (s7_21 <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (s7_51 <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2), vce(cluster hfcode) 
sum s7_17b s7_20a s7_20d s7_20e s7_21 s7_51 if sample1==1 & treatment==0
sum s7_17b s7_20a s7_20d s7_20e s7_21 s7_51 if sample1==0 & treatment==0

lincom ((0.167/0.33)*[s7_17b]treatment +(0.167/0.33)*[s7_17b]sample1_t + (0.167/0.49)*[s7_20a]treatment + (0.167/0.49)*[s7_20a]sample1_t+ (0.167/0.50)*[s7_20d]treatment + (0.167/0.50)*[s7_20d]sample1_t  + (0.167/0.21)*[s7_20e]treatment+ (0.167/0.21)*[s7_20e]sample1_t+ (0.167/0.50)*[s7_21]treatment+ (0.167/0.50)*[s7_21]sample1_t)-((0.167/0.18)*[s7_17b]treatment + (0.167/0.44)*[s7_20a]treatment + (0.167/0.50)*[s7_20d]treatment + (0.167/0.20)*[s7_20e]treatment+ (0.167/0.48)*[s7_21]treatment)

save ante_postnatal.dta, replace



** Column (vi): Health education

use "hh_PIPendl.dta", clear

**AIDS STIGMA: people agree with statement that people with AIDS should be ashamed of themselves
gen aids_stigma= (s96==1) if s96!=3 & s96!=.
label var aids_stigma "==1 agree that people with aids should be ashamed"
* Protection of children from getting malaria 
replace s919a=. if s919g==1 /*no kids under 5 in the household*/

keep s91 aids_stigma s99a s919a treatment sample1 hfcode dcode hhcode
xi i.dcode


*PANEL A:
sum s91 aids_stigma s99a s919a if sample1==1 & treatment==0
mysureg (s91  treatment  _Idcode_2- _Idcode_11) (aids_stigma  treatment  _Idcode_2- _Idcode_11) (s99a  treatment  _Idcode_2- _Idcode_11) (s919a  treatment  _Idcode_2- _Idcode_11) if sample1==1, cluster(hfcode)
lincom (0.25/.04)*[s91]treatment - (0.25/.28)*[aids_stigma]treatment + (0.25/0.59)*[s99a]treatment + (0.25/0.49)*[s919a]treatment 

*PANEL B:
sum s91 aids_stigma s99a s919a if sample1==0 & treatment==0
mysureg (s91  treatment  _Idcode_2- _Idcode_11) (aids_stigma  treatment  _Idcode_2- _Idcode_11) (s99a  treatment  _Idcode_2- _Idcode_11) (s919a  treatment  _Idcode_2- _Idcode_11) if sample1==0, cluster(hfcode)
lincom (0.25/.04)*[s91]treatment - (0.25/.48)*[aids_stigma]treatment + (0.25/0.50)*[s99a]treatment + (0.25/0.50)*[s919a]treatment 


*PANEL C:

*can not do I&P(SR) vs. P(SR) comparison since we did not collect this data in 2006.

** DIFFERENTIAL EFFECT I&P(LR) vs. P(SR)

gen sample1_t=sample1*treatment

gen dcode1=100+dcode
replace dcode1=0 if sample1==1
replace dcode=0 if dcode==.
replace dcode1=0 if dcode1==.

sort hfcode
save health_educ.dta, replace

merge m:1  hfcode using  "baselinecontrols.dta", keepusing(avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del avgDEL_baseline avgOP_baseline hhs hh_vill) 
drop _merge

gen charge2= avg_charge_gentreat^2
gen op2= avgOP_baseline^2
gen hhs2=hhs^2

gen year=2009
sort year hhcode 
save health_educ.dta, replace


gsem (s91 <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (aids_stigma <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (s99a <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) (s919a <-  treatment sample1 sample1_t  i.dcode i.dcode1 avg_charge_gentreat avgOP_baseline hhs charge2 op2 hhs2) , vce(cluster hfcode)
sum s91 aids_stigma s99a s919a if sample1==1 & treatment==0
sum s91 aids_stigma s99a s919a if sample1==0 & treatment==0
lincom ((0.25/.04)*[s91]treatment+(0.25/.04)*[s91]sample1_t - (0.25/.28)*[aids_stigma]treatment - (0.25/.28)*[aids_stigma]sample1_t + (0.25/0.59)*[s99a]treatment + 0.25/0.59*[s99a]sample1_t + (0.25/0.49)*[s919a]treatment + (0.25/0.49)*[s919a]sample1_t)-((0.25/.04)*[s91]treatment - (0.25/.24)*[aids_stigma]treatment + (0.25/0.59)*[s99a]treatment + (0.25/0.50)*[s919a]treatment)


