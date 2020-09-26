/*******************************************************************************
Uganda Community Health Project

Pre-processing and organizing data from existing data sets from paper
Experimental Evidence on the Long-Run Impact of Community Based Monitoring
American Economic Journal: Applied Economics
(https://www.aeaweb.org/articles?id=10.1257/app.20150027)

Data set available at: http://doi.org/10.3886/E113630V1

Sindy Li
20 Sept 2020

Endline data:
	- Table 3: child mortality outcomes
		- death_exp: under 5 mortality rate per 1000 child-years of exposure
		
	- Table 6: health facility utilization
		- avg*
		(1) average number of patients visiting the facility per month for outpatient care; 
		(2) average number of deliveries at the facility per month; 
		(3) average number of antenatal visits at the facility per month; 
		(4) average number of family planning visits at the facility per month;	
		
	- Table 7: processes and practices
		- column 5: antenatal and prenatal care quality
		- column 6: health knowledge
		
Baseline data:
	- Table 1 & 2: baseline characteristics and outcomes
*******************************************************************************/


clear all
set more off
capture log close

* Replace path1 and path2 with where you store the paper author's files
global path1 "/Users/biochemistsindy/Dropbox (Personal)/Courses/ML/Surrogate proxies/Predicting with proxies/Community health project/"
global path2 "Long run community monitoring Uganda/"
cd "${path1}${path2}AEJ_authors_files/Dataset/"
global savingdest "${path1}${path2}Intermediate_output/"


****************************************************
*** TABLE 3: PROGRAM IMPACT ON CHILD MORTALITY *****
****************************************************
* Code taken from authors' do file "Table-3ChildMortality.do"

	* First, create a dataset for calculating the mortality results

	use "sec-8-children-u5-died", clear
	drop if  s8b24==.
	gen birth_monthyr=s8b24 
	rename s8b23 childname
	rename s8b25 gender
	rename s8b27 death_yr
	rename s8b26 death_month
	rename s8b24_yr birth_yr
	rename s8b24_month birth_month
	generate death=1
	save "temp.dta", replace

	use "sec-8-children-u5.dta", clear
	destring s84, replace
	drop if s84==.
	gen birth_monthyr=s84 
	rename s83 childname
	rename s85 gender
	rename s84_month birth_month
	rename s84_yr birth_yr
	append using "temp.dta"
	replace death=0 if death==.
	sort hhcode

	*** 1. define date of birth (and death) according to the CMC standard (CMC=century month code; the number of the month since the start of the century)
	gen bdate=(birth_yr-1900)*12+birth_month  
	gen ddate=(death_yr-1900)*12+death_month 
	gen age_death=ddate-bdate

	*** 2. create a variable error=1 if child died died before born
	gen error=(age_death<0)
	tab error

	gen error1=1 if death_month==18 
	replace error1=1 if death_month==24

	*** 3. make adjustment according to DHS recommendations for error=1 

	generate death_yr1=death_yr
		replace death_yr1=birth_yr if error==1
	generate death_month1=death_month
		replace death_month1=birth_month if error==1
		
	generate birth_yr1=birth_yr
		replace birth_yr1=death_yr if error1==1
		replace death_month1=birth_month if error1==1 
		
	gen ddate1=(death_yr1-1900)*12+death_month1
	gen bdate1=(birth_yr1-1900)*12+birth_month
	  
		replace ddate=. if (error==1 | error1==1)
		replace ddate= ddate1 if (error==1 | error1==1)	// 11 changes if selected
		replace bdate= bdate1 if (error==1 | error1==1)	// 2 changes if selected
		replace age_death=ddate1-bdate1 if (error==1 | error1==1) // 11 changes if selected  

	*** 4. Replace birthdate end of survey when coded after survey

	replace bdate=1315 if bdate==1318
	replace bdate=1315 if bdate==1319
	replace bdate=1315 if bdate==1320

		
	save "allchildren_deadalive.dta", replace


	******* REGRESSIONS ***********

	*** PANEL A: DEATH RATE ESTIMATES FOR INFORMATION AND PARTICIPATION EXPERIMENT 2006-2009

	drop if death_yr1<2006

	gen death_inf=death
	replace death_inf=. if age_death>12 &  age_death<60

	gen death_neo=death
	replace death_neo=. if age_death>0 &  age_death<60

	gen exposure= 1 + min(1315, ddate) - max(1273, bdate)

	gen exposure_inf=1+ddate-bdate if bdate>1261 & ddate>1272 & age_death<12
	replace exposure_inf=min(12,1316-bdate) if bdate>1272 & ddate>1272 & death==0
	replace exposure_inf=11-1272+bdate if bdate>1261 & bdate<1273 & death==0

	gen births=1 if bdate>1272 & bdate<1315

	gen exp_y=exposure/12
	gen exp_inf_y=exposure_inf/12

	* Exposure corrected mortality rates (individual data) 2006-2009

	poisson death treatment i.dcode if sample1==1, exposure(exp_y) cluster(hfcode) irr  /* in the text in the paper */
	poisson death_inf treatment i.dcode if sample1==1, exposure(exp_inf_y) cluster(hfcode) irr /* in the text in the paper */

	collapse dcode treatment sample1 (sum) death death_inf death_neo births exposure exposure_inf exp_y exp_inf_y, by(hfcode)

	* Crude death results 2006-2009 (3.58 years of data)
	* Adjust for the correct time period of the data
	gen death_year=death/3.58
	gen death_inf_year=death_inf/3.58
	gen death_neo_year=death_neo/3.58

	* Panel A column i *
	sum death_year if treatment==0 & sample1==1
	areg death_year treatment if sample1==1, a(dcode) robust 

	* Panel A column ii *
	sum death_inf_year if treatment==0 & sample1==1
	areg death_inf_year treatment if sample1==1, a(dcode) robust 

	* Panel A column iii *
	sum death_neo_year if treatment==0 & sample1==1
	areg death_neo_year treatment if sample1==1, a(dcode) robust


	* Exposure corrected mortality rates (cluster level data) 2006-2009

	* Panel A column iv *
	gen exp_y1000=exp_y/1000
	poisson death treatment i.dcode if sample1==1, exposure(exp_y1000) robust irr
	gen death_exp=death/exp_y1000
	areg death_exp treatment if sample1==1, a(dcode) robust 
	sum death_exp if treatment==0 & sample1==1

	* Panel A column v *
	gen exp_inf_y1000=exp_inf_y/1000
	poisson death_inf treatment i.dcode if sample1==1, exposure(exp_inf_y1000) robust irr
	gen death_inf_exp=death_inf/exp_inf_y1000
	areg death_inf_exp treatment if sample1==1, a(dcode) robust
	sum death_inf_exp if treatment==0 & sample1==1

	* Panel A column vi *
	gen neo_mr=death_neo/(births/1000)
	areg neo_mr treatment  if sample1==1, robust a(dcode)
	sum neo_mr if treatment==0 & sample1==1
	sum neo_mr if treatment==1 & sample1==1

	rename sample1 exp

	*** SL
	* drop if exp==1
	* save "did1.dta", replace
	save "${savingdest}u5mortality.dta", replace


************************************************
*** TABLE 6: PROGRAM IMPACT ON UTILIZATION *****
************************************************
* Code taken from authors' do file "Table6Utilization.do"

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


	*** SL
	rename sample1 exp
	save "${savingdest}hfutilization.dta", replace

	
***********************************************************
*** TABLE 7: PROCESSES AND HEALTH TREATMENT PRACTICES *****
***********************************************************
* Code taken from authors' do file "Table7ProcessesPractices.do"

/* Omitting for now as too many variables

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
	*/
	
	

*****************************************************************************************
***** TABLE I AND II: PRE-INTERVENTION CHARACHTERISTICS PANEL A AND PANEL  B ************
*****************************************************************************************
	foreach file in hfmain_2004 hhmain_2004 wtime_equip_2004 average_charges_hflevel_2004	{
		use "`file'.dta", clear
		save "${savingdest}`file'.dta", replace
		}
	
* Code taken from authors' do file "Table1-2PreTreatmentCharacteristics.do"

	/* The following code for reference to see what the variables are

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
	*/
