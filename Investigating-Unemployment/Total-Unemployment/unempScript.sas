/*Country Unemployment Rate Data*/
/*======================================================*/

options validvarname=v7;

%let path=/home/spradhan3/my_content/Final_Project_2016/unemp;
libname data xlsx "&path/data.xlsx";
/* Looking at the top five GDP countries*/
data unemp.unemp;/*Unemployment, total (% of total labor force)*/
	set data."Data"n;
	where Country_Code in ('CHN','DEU','GBR','JPN','USA');
	drop _1960-_1990 _2015 _2016;/*time frame is 1991-2014*/
	run;

proc transpose data=unemp.unemp
	out=unemp.unemp_transpose
	(rename=(col1=CHN col2=DEU col3=GBR col4=JPN col5=USA));
	run;

data unemp.unemp_final;
	set unemp.unemp_transpose;
	year=input(_Label_,8.);
	Average=(chn+deu+gbr+jpn)/4.0;
	maximum=max(chn,deu,gbr,jpn);
	minimum=min(chn,deu,gbr,jpn);
	format  chn 8.2 deu 8.2 gbr 8.2 jpn 8.2 usa 8.2 average 8.2 maximum 8.2 minimum 8.2;
	label 	chn="China"
			deu="Germany"
			gbr="United Kingdom"
			jpn="Japan"
			usa="United States"
			year="Year"
			average ="Group Average"
			maximum="Group Maximum"
			minimum="Group Minimum";
	drop _name_ _Label_;
	run;

proc contents data=unemp.unemp_final;
run;

proc print data=unemp.unemp_final noobs label;
var year usa average maximum minimum;
title "Unemployment Rate in the US and the Group Average, Max. and Min";
run;
title;
	
proc means data=unemp.unemp_final;
var usa average maximum minimum;
title "Comparing Mean and Spread of Unemployment Rate in the US and the Group Average, Max. and Min";
run;
title;

proc univariate data=unemp.unemp_final;
var usa average maximum minimum;
title "Exploring Unemployment Data";
run;
title;



axis1 order=(1990 to 2015 by 5) label=("Year") offset=(2,2) major=(height=2) minor=(height=1)
      width=1 ;
axis2 order=(3 to 10 by 1) label=(a=90 "Unemployment Rate (%)" ) offset=(0,0) major=(height=2) minor=(height=1)width=1;
symbol1 color=blue interpol=join value=dot height=1;
symbol2 value=dot color=red interpol=join height=1;
legend1 label=none
        shape=symbol(5,1)
        position=(top center inside)
        mode=share;
title "Comparing Yearly Unemployment Rate in USA and Group Average from 1991 to 2014";
proc gplot data= unemp.unemp_final;
	plot usa*year average*year / overlay legend=legend1
	 vref=1 to 12 by 1 lvref=2
	 haxis=axis1 vaxis=axis2
	 hminor=4;
	run;quit;title;



axis1 order=(1990 to 2015 by 5) label=("Year") offset=(2,2) major=(height=2) minor=(height=1)
      width=1;
axis2 order=(1 to 11 by 1) label=(a=90 "Unemployment Rate (%)") offset=(0,0) major=(height=2) minor=(height=1)width=1;
symbol1 color=blue interpol=join value=dot height=1;
symbol2 value=dot color=red interpol=join height=1;
symbol3 value=dot color=blueviolet interpol=join height=1;
legend1 label=none
        shape=symbol(5,1)
        position=(top center inside)
        mode=share;
title "Comparing Yearly Unemployment Rate in USA and Group Max. and Min. from 1991 to 2014";
proc gplot data= unemp.unemp_final;
	plot usa*year maximum*year minimum*year / overlay legend=legend1
	 vref=1 to 12 by 1  lvref=2
	 haxis=axis1 vaxis=axis2
	 hminor= 5;
	run;quit;title;
