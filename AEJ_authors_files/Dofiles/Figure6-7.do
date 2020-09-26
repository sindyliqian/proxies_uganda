
* Experimental Evidence on the Long-Run Impact of Community Based Monitoring
* American Economic Journal: Applied Economics

clear all
set more off
capture log close


************** FIGURE 6 AND 7 ***************

use "actionplan_avgOP.dta", clear
* this is a dataset with the action plan data and utilization at baseline and endline

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

* Figure 7
twoway (lfitci dif2 sh_la_baseline, ciplot(rline) level (90)) (scatter dif2_1 sh_la_baseline, color(darkblue)) (scatter dif2_0 sh_la_baseline, symbol(triangle) color (red)), ///
legend(off) yline(0)  xtitle("Share of local issues in action plan") ytitle("Change in number of outpatients served")

gen sh_la_baseline_s1=sh_la_baseline if sample1==1
gen sh_la_baseline_s0=sh_la_baseline if sample1==0

* Figure 6
twoway (kdensity sh_la_baseline_s0, bwidth(.08) lwidth(thick) lpattern(dash)) (kdensity sh_la_baseline_s1, bwidth(0.06) lwidth(thick) lpattern(solid)) , ///
xline(.48) xline(.9) ytitle(density) xtitle("") legend(order(1 "Participation" 2 "Information & Participation") colgap(10) color(black) region(style(none)))

