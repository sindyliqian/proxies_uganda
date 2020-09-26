

* Experimental Evidence on the Long-Run Impact of Community Based Monitoring
* American Economic Journal: Applied Economics

clear all
set more off
capture log close

cd "/Users/ma.2557/Dropbox/Documents/CRCCL2/AEJ_AppliedEcon/Replication files/Dataset/"


**********************************
***** APPENDIX *******************
**********************************


***************************************
************* TABLES A.4A-4E **************
***************************************


************* TABLE A.4A **************

use hf_PIPendl.dta, clear 

** s12_14==suggestion box
** s12_11==waiting cards
** s12_7==staff duty roaster publicly visible
** s12_5==posters for services free
** s12_4==poster on patients rights and obligations

*Panel A:
bys treatment: sum s12_14 s12_11 s12_7 s12_5 s12_4 if sample1==1
areg  s12_14 treatment if sample1==1, abs(dcode) cluster(hfcode)
areg  s12_11 treatment if sample1==1, abs(dcode) cluster(hfcode)
areg  s12_7 treatment if sample1==1, abs(dcode) cluster(hfcode)
areg  s12_5 treatment if sample1==1, abs(dcode) cluster(hfcode)
areg  s12_4 treatment if sample1==1, abs(dcode) cluster(hfcode)

*Panel B:
bys treatment: sum s12_14 s12_11 s12_7 s12_5 s12_4 if sample1==0
areg  s12_14 treatment if sample1==0, abs(dcode) cluster(hfcode)
areg  s12_11 treatment if sample1==0, abs(dcode) cluster(hfcode)
areg  s12_7 treatment if sample1==0, abs(dcode) cluster(hfcode)
areg  s12_5 treatment if sample1==0, abs(dcode) cluster(hfcode)
areg  s12_4 treatment if sample1==0, abs(dcode) cluster(hfcode)


************* TABLE A.4B **************


use monitoring_hh.dta, clear
drop if year==2006

*Panel A:
bys treatment: sum lcmtg_discuss humc s411 s618 monitoring_hhs if sample1==1
areg  lcmtg_discuss treatment if sample1==1, abs(dcode) cluster(hfcode)
areg  humc treatment if sample1==1, abs(dcode) cluster(hfcode)
areg  s411 treatment if sample1==1, abs(dcode) cluster(hfcode)
areg  s618 treatment if sample1==1, abs(dcode) cluster(hfcode)
areg  monitoring_hhs treatment if sample1==1, abs(dcode) cluster(hfcode)


*Panel B:
bys treatment: sum lcmtg_discuss humc s411 s618 monitoring_hhs if sample1==0
areg  lcmtg_discuss treatment if sample1==0, abs(dcode) cluster(hfcode)
areg  humc treatment if sample1==0, abs(dcode) cluster(hfcode)
areg  s411 treatment if sample1==0, abs(dcode) cluster(hfcode)
areg  s618 treatment if sample1==0, abs(dcode) cluster(hfcode)
areg  monitoring_hhs treatment if sample1==0, abs(dcode) cluster(hfcode)


************* TABLE A.4C **************


** Column i-ii
use "wtimeequip.dta", clear
bys treatment sample1: sum equip waittime
bys sample1: areg  equip treatment, abs(dcode) cluster(hfcode)
bys sample1: areg  waittime treatment, abs(dcode) cluster(hfcode)


** Column iii-v
use "absence_cond_stockouts09.dta", clear
bys treatment sample1: sum absence_rate clean stockouts
bys sample1: areg absence_rate  treatment, abs(dcode) robust
bys sample1: areg clean  treatment, abs(dcode) robust
bys sample1: areg stockouts  treatment, abs(dcode) robust


************* TABLE A.4D **************

use ante_postnatal.dta, clear

bys sample1 treatment: sum s7_17b s7_20a s7_20d s7_20e s7_21 s7_51
bys sample1: areg s7_17b  treatment, abs(dcode) cluster(hfcode)
bys sample1: areg s7_20a  treatment, abs(dcode) cluster(hfcode)
bys sample1: areg s7_20d  treatment, abs(dcode) cluster(hfcode)
bys sample1: areg s7_20e  treatment, abs(dcode) cluster(hfcode)
bys sample1: areg s7_21  treatment, abs(dcode) cluster(hfcode)
bys sample1: areg s7_51  treatment, abs(dcode) cluster(hfcode)


************* TABLE A.4E **************


use hh_PIPendl.dta, clear

**AIDS STIGMA: people agree with statement that people with AIDS should be ashamed of themselves
gen aids_stigma= (s96==1) if s96!=3 & s96!=.
label var aids_stigma "==1 agree that people with aids should be ashamed"
* Protection of children from getting malaria 
replace s919a=. if s919g==1 /*no kids under 5 in the household*/

keep s91 aids_stigma s99a s919a treatment sample1 hfcode dcode hhcode

bys sample1 treatment: sum s91 aids_stigma s99a s919a
bys sample1: areg s91  treatment, abs(dcode) cluster(hfcode)
bys sample1: areg aids_stigma  treatment, abs(dcode) cluster(hfcode)
bys sample1: areg s99a  treatment, abs(dcode) cluster(hfcode)
bys sample1: areg s919a  treatment, abs(dcode) cluster(hfcode)
