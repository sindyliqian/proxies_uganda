/*******************************************************************************
Uganda Community Health Project

(Run this after "1 Uganda organizing data sets.do")

Merging data sets

Output: Uganda_health.csv

Sindy Li
20 Sept 2020
*******************************************************************************/

clear all
set more off
capture log close

* Replace path1 and path2 with where you store the paper author's files
global path1 "/Users/biochemistsindy/Dropbox (Personal)/Courses/ML/Surrogate proxies/Predicting with proxies/Community health project/"
global path2 "Long run community monitoring Uganda/"
cd "${path1}${path2}Intermediate_output"


********************************
* 1. Merging Endline Data Sets *
********************************

	* Merging health facility utilization data with under 5 mortality data

		use "hfutilization.dta", clear
		merge 1:1 dcode hfcode treatment exp using "u5mortality.dta"
		drop _merge
		
	* Treatment status
		/* For the information & participation experiment, 
		the units (facility/community) were first stratified by location (districts) 
		and then by population size. From each block, half of the units were 
		randomly assigned to the treatment group (25 units) and the remaining 
		health facilities were assigned to the control group. 
		
		A similar procedure was initiated in 2007 when the project was extended with 
		the partici- pation intervention; i.e., after stratifying on location and population size, 
		the 25 new facilities were randomly assigned to a treatment group (13 units) 
		and a control group (12 units).	*/
		
		* Want to only keep those in the first sample of 50
			* exp: dummy for first or end sample (50 vs 25)
			* treatment: treatment (either) or control for both samples
		keep if exp == 1
		drop exp					
		
	* Only keeping relevant variables
		egen avg_visits_mo = rowtotal(avg*)
		* avg...:
			/* (1) average number of patients visiting the facility per month for outpatient care; 
			(2) average number of deliveries at the facility per month; 
			(3) average number of antenatal visits at the facility per month; 
			(4) average number of family planning visits at the facility per month; */		
		keep dcode hfcode treatment death_exp avg_visits_mo
		* death_exp: under 5 mortality rate per 1000 child-years of exposure
			
	tempfile endline
	save `endline', replace
			
	
*********************************
* 2. Merging Baseline Data Sets *
*********************************

	*** Health facilities data ***

		use "hfmain_2004.dta", clear
		
		* Only keeping relevant variables
		rename hdcode dcode
		gen frac_alevel = alevel / (alevel + lower_alevel)
		keep dcode hfcode treatment ///
			avgOP avgDEL	///
			hhs hh_vill villagen village1 village3	///
			ws1 DMU nopower04 distLC1 dist432 drinksafely_2004 frac_alevel radio newspaper	///
			avg_eryth avg_chloro avg_cotrim avg_quinine avg_meb
		
		/*
		Utilization
			avgOP: outpatient care
			avgDEL: delivery
			
		Catchment area characteristics:
			hhs: No. of households in catchment area
			hh_vill: no. of hhs per village
			villagen: ?
			village1: ?
			village3: ?
			Catchment area statistics summarizes 
			the number of households in the catchment area, 
			the number of households per village, 
			and the distance from the vil- lages to the health facility.
			
		Health facility characteristics:
			Health facility characteristics summarizes 
			presence of piped water, 
			access to a radio, 
			access to a newspaper, 
			the existence of a separate maternity unit, 
			the distance to the nearest Local Council I, 
			the distance to the nearest public health provider, 
			number of staff with advanced A-level education, 
			number of staff with less than A-level education, 
			access to safe water 
			and days without electricity, 
			reversing the sign of days without electricity and distance to nearest local council (in panel A)
			
			ws1: presence of piped water?
			DMU: the existence of a separate maternity unit?
			nopower04: No. of days without electricity in past month
			distLC1: (reversed) distance to nearest local council I
			dist432: the distance to the nearest public health provider?
			drinksafely_2004: drank safely today -- access to safe water
			alevel: number of staff with advanced A-level education
			lower_alevel: number of staff with less than A-level education
			radio: access to radio
			newspaper: access to newspaper
			
		Supply of drugs:
			Supply of drugs summarizes the availability of erythromycin, 
			chloroquine, septrine, quinine, and mebendazole at the facility.
			avg_eryth
			avg_chloro
			avg_cotrim
			avg_quinine
			avg_meb
		*/
			
		tempfile bl_healthfacilities
		save `bl_healthfacilities', replace	
	

	*** HH data ***
		use hhmain_2004.dta, clear
		replace dcode = 5 if dcode == . & hfcode == 10
		
		* Only keeping relevant variables		
		local util hfx_ratio NGO_ratio PFP_ratio STTH_ratio OthGov_ratio Other_ratio
		
		gen polite1 = polite
		gen attention1 = attention
		gen express_free1 = express_free
		local perc polite1 attention1 express_free1
			// for werid reasons original vars don't collapse properly
		
		/* Utilization pattern:
			Utilization pattern of users summarizes use of the project facility, 
			an NGO facility, a private-for-profit facility, other government facility, 
			another provider, a traditional healer and self-treatment, 
			reversing sign of tradi- tional healer and self-treatment.
			
			hfx_ratio: use of the project facility?
			NGO_ratio: use of an NGO facility
			PFP_ratio: private for profit
			STTH_ratio: self treatment or traditional healer
			OthGov_ratio: other govt facility
			Other_ratio: another provider			
			
		Citizen perceptions:
			Citizen perceptions of treatment summarizes whether the staff was polite, 
			whether the staff was attentive, 
			and whether the patient could freely express herself.
			
			polite attention express_free
		*/
		
		* Collapsing
		collapse (mean) dcode treatment `util' `perc', by(hfcode)

		tempfile bl_hhdata
		save `bl_hhdata', replace
		
		
	*** Quality measures ***
		use wtime_equip_2004.dta, clear
		
		* Only keeping relevant variables
		local qual equip wtime
		
		/* Quality measures:
			Quality of services summarizes the use of any equipment during 
			the household’s last visit to the clinic and waiting time, 
			reversing sign of waiting time.
			
			equip wtime */		
			
		* Collapsing
		collapse (mean) treatment `qual' `charge', by(hfcode)		
		
		tempfile bl_qual
		save `bl_qual', replace		
		
		
	*** User charges ***
		use average_charges_hflevel_2004.dta, clear
		
		* Only keeping relevant variables		
		keep hfcode dcode treatment	///
			avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del
			
		/* User charges:
			User charges summarizes whether the patient needs to pay for medicine, 
			general treatment, injections and deliveries, reversing all signs.
		
			avg_charge_drugs avg_charge_gentreat avg_charge_injection avg_charge_del */
			
		
******************
* 3. Merging All *
******************

	* Start with user charges
	* 1. Merge with quality measures
	merge 1:1 hfcode treatment using `bl_qual'
	drop _merge
	
	* 2. Merge with hh data
	merge 1:1 dcode hfcode treatment using `bl_hhdata'
	drop _merge
	
	* 3. Merge with facility data
	merge 1:1 dcode hfcode treatment using `bl_healthfacilities'
	drop _merge
	
	* 4. Merge with endline data
	merge 1:1 dcode hfcode treatment using `endline'
	drop _merge
	
	*** Saving ***
	* Ordering variables
	order dcode hfcode death_exp avg_visits_mo treatment, first
	rename death_exp u5mort_end
	rename avg_visits_mo avg_visits_mo_end
	
	outsheet using "${path1}${path2}Uganda_health.csv", comma replace
