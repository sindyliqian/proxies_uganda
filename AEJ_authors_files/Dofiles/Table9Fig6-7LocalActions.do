

* Experimental Evidence on the Long-Run Impact of Community Based Monitoring
* American Economic Journal: Applied Economics

clear all
set more off
capture log close

cd "/Users/ma.2557/Dropbox/Documents/CRCCL2/AEJ_AppliedEcon/Replication files/Dataset/"

***************************
******** TABLE 9 **********
***************************


use "actionplan.dta", clear

gen sh_la_baseline=la_baseline/actions_bl
gen sh_ua_baseline=ua_baseline/actions_bl
gen sh_la_2007=la_2007/actions_2007

*** column i
bys sample1: sum no_part_meeting
reg no_part_meeting sample1 , robust


*** column ii
bys sample1: sum actions_bl
reg actions_bl sample1 , robust

*** column iii
bys sample1: sum sh_ua_baseline
reg sh_ua_baseline sample1 , robust

*** column iv
bys sample1: sum sh_la_baseline
reg sh_la_baseline sample1 , robust

*** column v
bys sample1: sum sh_la_2007
reg sh_la_2007 sample1, robust

save "actionplan1.dta", replace




******** FIGURE 6 & 7 **********

*avgOP_baseline
use "baselinecontrols.dta"
keep hfcode avgOP_baseline
sort hfcode
save tempAP.dta, replace

*avgOP endline:
use "hfutilization.dta", clear
keep dcode hfcode treatment sample1 avgOP 
rename avgOP avgOP_endline
sort hfcode
save tempAP1.dta, replace

*action plan data:
use "actionplan1.dta"
keep hfcode actions_bl sh_ua_baseline sh_la_baseline sh_la_2007 no_part_meeting
sort hfcode
merge hfcode using tempAP.dta
drop _merge
sort hfcode
merge hfcode using tempAP1.dta
sort hfcode
drop _merge
order hfcode dcode sample1 treatment avgOP_baseline avgOP_endline actions_bl no_part_meeting sh_ua_baseline sh_la_baseline sh_la_2007
save actionplan_avgOP.dta, replace

use "actionplan_avgOP.dta", clear

gen avgOP_baseline_c=avgOP_baseline if treatment==0

gen avgOP_endline_c=avgOP_endline if treatment==0

egen c_pre=mean(avgOP_baseline_c)

egen c_post=mean(avgOP_endline_c) 			


gen avgOP_baseline_c1=avgOP_baseline if treatment==0 & sample1==1

gen avgOP_endline_c1=avgOP_endline if treatment==0 & sample1==1

egen c_pre1=mean(avgOP_baseline_c1)

egen c_post1=mean(avgOP_endline_c1) 			


gen avgOP_baseline_c0=avgOP_baseline if treatment==0 & sample1==0

gen avgOP_endline_c0=avgOP_endline if treatment==0 & sample1==0

egen c_pre0=mean(avgOP_baseline_c0)

egen c_post0=mean(avgOP_endline_c0)



gen avgOP_baseline_t=avgOP_baseline if treatment==1

gen avgOP_endline_t=avgOP_endline if treatment==1

gen dif1=avgOP_endline_t-avgOP_baseline_t

gen dif2=dif1-(c_post-c_pre)

reg dif2 sh_la_baseline, robust

gen dif2_1=dif2 if sample1==1

gen dif2_0=dif2 if sample1==0

*Figure 7:

twoway (lfitci dif2 sh_la_baseline, ciplot(rline) level (90)) (scatter dif2_1 sh_la_baseline, color(darkblue)) (scatter dif2_0 sh_la_baseline, symbol(triangle) color (red)), ///
legend(off) yline(0)  xtitle("Share of local issues in action plan") ytitle("Change in number of outpatients served")


*Figure 6:

gen sh_la_baseline_s1=sh_la_baseline if sample1==1
gen sh_la_baseline_s0=sh_la_baseline if sample1==0

twoway (kdensity sh_la_baseline_s0, bwidth(.08) lwidth(thick) lpattern(dash)) (kdensity sh_la_baseline_s1, bwidth(0.06) lwidth(thick) lpattern(solid)) , ///
xline(.48) xline(.9) ytitle(density) xtitle("") legend(order(1 "Participation" 2 "Information & Participation") colgap(10) color(black) region(style(none)))

