


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
************* TABLE A.5 **************
**************************************

* Column i:  Amount of FUNDS received at the health facility

use hf_PIPendl.dta, clear

egen avg_phcfunds_2006=rowmean(s9a_3-s9a_14)
egen avg_phcfunds_2007=rowmean(s9a_15-s9a_26)
egen avg_phcfunds_2008=rowmean(s9a_27-s9a_38)

egen avg_phcfunds= rowmean(avg_phcfunds_2006 avg_phcfunds_2007 avg_phcfunds_2008)
gen avg_phcfunds_USD=avg_phcfunds/3000
bys sample1 treatment: sum avg_phcfunds_USD
bys sample1: areg avg_phcfunds_USD  treatment, abs(dcode) cluster(hfcode)


* Column ii: # of staff LEFT the health facility 

replace s5_23_a=0 if s5_22_a==0
replace s5_23_b=0 if s5_22_b==0
replace s5_23_c=0 if s5_22_c==0

*** sum over 3 years
gen s5_23_tot= s5_23_a + s5_23_b + s5_23_c

bys treatment sample1: sum s5_23_tot
bys sample1: areg s5_23_tot  treatment, abs(dcode) robust


* Column iii: SUPERVISION of the health facility by Village Health Teams 

replace s2_54=0 if s2_41==0
/*if clinic has no VHT, recieved 0 visits*/

bys treatment sample1: sum s2_54
bys sample1: areg s2_54  treatment, abs(dcode) robust


* Column iv: Amount of DRUGS per patient received at the health facility 
* average drugs recieved per month divided by the average number of patients per months in 2008

use drugs_endl.dta, clear 

collapse (mean) dcode treatment sample1 s6b_co1 s6b_co2 s6b_co3 s6b_co4, by(hfcode year)

rename s6b_co1 eryth_avg
rename s6b_co2 coartem_avg
rename s6b_co3 cotrim_avg
rename s6b_co4 quinine_avg

collapse (mean) dcode treatment sample1 eryth_avg coartem_avg cotrim_avg quinine_avg, by(hfcode)
save drugs_endl1.dta, replace

use "hfutilization.dta", clear
keep if year==2009
keep hfcode avgOP
sort hfcode
merge hfcode using drugs_endl1.dta
drop _merge

gen eryth_avg_pat=eryth_avg/avgOP
gen coartem_avg_pat=coartem_avg/avgOP
gen cotrim_avg_pat=cotrim_avg/avgOP
gen quinine_avg_pat=quinine_avg/avgOP


*Panel A
xi i.dcode
sum eryth_avg_pat coartem_avg_pat cotrim_avg_pat quinine_avg_pat if sample1==1 & treatment==0 
mysureg (eryth_avg_pat treatment  _Idcode_2-_Idcode_11) (coartem_avg_pat treatment _Idcode_2-_Idcode_11) (cotrim_avg_pat treatment _Idcode_2-_Idcode_11) (quinine_avg_pat treatment _Idcode_2-_Idcode_11) if sample1==1, vce(robust)
lincom (0.25/ 1.162424)*[eryth_avg_pat]treatment + (0.25/1.682891)*[coartem_avg_pat]treatment + (0.25/3.885255 )*[cotrim_avg_pat]treatment + (0.25/ .7693488)*[quinine_avg_pat]treatment

*Panel B
* Participation experiment
sum eryth_avg_pat coartem_avg_pat cotrim_avg_pat quinine_avg_pat if sample1==0 & treatment==0 
mysureg (eryth_avg_pat treatment  _Idcode_2-_Idcode_11) (coartem_avg_pat treatment _Idcode_2-_Idcode_11) (cotrim_avg_pat treatment _Idcode_2-_Idcode_11) (quinine_avg_pat treatment _Idcode_2-_Idcode_11) if sample1==0, vce(robust)
lincom (0.25/.7916213)*[eryth_avg_pat]treatment + (0.25/1.373142)*[coartem_avg_pat]treatment + (0.25/ 6.1029 )*[cotrim_avg_pat]treatment + (0.25/  1.299069)*[quinine_avg_pat]treatment
