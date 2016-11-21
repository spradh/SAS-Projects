options validvarname=v7;

%let path=/home/spradhan3/my_content/xlsx_dataset;
libname Wbank_np xlsx "&path/Nepal.xlsx";
libname Wbank_af xlsx "&path/Afganistan.xlsx";
libname Wbank_bg xlsx "&path/Bangladesh.xlsx";
libname Wbank_bt xlsx "&path/Bhutan.xlsx";
libname Wbank_in xlsx "&path/India.xlsx";
libname Wbank_lk xlsx "&path/Srilanka.xlsx";
libname Wbank_pa xlsx "&path/Pakistan.xlsx";

proc contents data= Wbank_pa._all_;
run;

data finalpro.np;
	set Wbank_np.'Data'n;
run;

data finalpro.af;
	set Wbank_af.'Data'n;
run;

data finalpro.bg;
	set Wbank_bg.'Data'n;
run;

data finalpro.bt;
	set Wbank_bt.'Data'n;
run;

data finalpro.in;
	set Wbank_in.'Data'n;
run;

data finalpro.lk;
	set Wbank_lk.'Data'n;
run;

data finalpro.pa;
	set Wbank_pa.'Data'n;
run;


libname Wbank_np clear;
libname Wbank_af clear;
libname Wbank_bg clear;
libname Wbank_bt clear;
libname Wbank_in clear;
libname Wbank_lk clear;
libname Wbank_pa clear;



data finalpro.np_gdpdata;
	set finalpro.np;
	where Indicator_Code in ('NY.GDP.MKTP.CD' , 'NY.GDP.MKTP.KD.ZG' , 'NY.GDP.PCAP.CD');
run;

data finalpro.af_gdpdata;
	set finalpro.af;
	where Indicator_Code in ('NY.GDP.MKTP.CD' , 'NY.GDP.MKTP.KD.ZG' , 'NY.GDP.PCAP.CD');
run;

data finalpro.bg_gdpdata;
	set finalpro.bg;
	where Indicator_Code in ('NY.GDP.MKTP.CD' , 'NY.GDP.MKTP.KD.ZG' , 'NY.GDP.PCAP.CD');
run;

data finalpro.bt_gdpdata;
	set finalpro.bt;
	where Indicator_Code in ('NY.GDP.MKTP.CD' , 'NY.GDP.MKTP.KD.ZG' , 'NY.GDP.PCAP.CD');
run;

data finalpro.in_gdpdata;
	set finalpro.in;
	where Indicator_Code in ('NY.GDP.MKTP.CD' , 'NY.GDP.MKTP.KD.ZG' , 'NY.GDP.PCAP.CD');
run;

data finalpro.lk_gdpdata;
	set finalpro.lk;
	where Indicator_Code in ('NY.GDP.MKTP.CD' , 'NY.GDP.MKTP.KD.ZG' , 'NY.GDP.PCAP.CD');
run;

data finalpro.pa_gdpdata;
	set finalpro.pa;
	where Indicator_Code in ('NY.GDP.MKTP.CD' , 'NY.GDP.MKTP.KD.ZG' , 'NY.GDP.PCAP.CD');
run;


proc print data=finalpro.pa_gdpdata;
run;





data finalpro.gdp_current_us_dollar;
	set  finalpro.af_gdpdata finalpro.bg_gdpdata finalpro.bt_gdpdata finalpro.in_gdpdata 
		 finalpro.lk_gdpdata finalpro.np_gdpdata finalpro.pa_gdpdata;
	drop Country_Name Indicator_Name Indicator_Code _1960-_1969 _2015;
	where Indicator_Code="NY.GDP.MKTP.CD"; 
	by Country_Code;
run;

data finalpro.gdp_growth;
	set  finalpro.af_gdpdata finalpro.bg_gdpdata finalpro.bt_gdpdata finalpro.in_gdpdata 
		 finalpro.lk_gdpdata finalpro.np_gdpdata finalpro.pa_gdpdata;
	drop Country_Name Indicator_Name Indicator_Code _1960-_1969 _2015;
	where Indicator_Code="NY.GDP.MKTP.KD.ZG"; 
	by Country_Code;
run;


data finalpro.gdp_per_capita;
	set  finalpro.af_gdpdata finalpro.bg_gdpdata finalpro.bt_gdpdata finalpro.in_gdpdata 
		 finalpro.lk_gdpdata finalpro.np_gdpdata finalpro.pa_gdpdata;
	drop Country_Name Indicator_Name Indicator_Code _1960-_1969 _2015;
	where Indicator_Code="NY.GDP.PCAP.CD"; 
	by Country_Code;
run;



proc transpose data=finalpro.gdp_current_us_dollar
				out=finalpro.gdp_current_us_dollar_transpose (rename=(col1=AFG col2=BGD
				 col3=BTN col4=IND col5=LKA col6=NPL 
				col7=PAK _Label_=Year));
run;

Data finalpro.final_gdp;
	set finalpro.gdp_current_us_dollar_transpose;
	Total_GDP= SUM(AFG, BGD,BTN,IND,LKA,NPL,PAK );
	NPL_Percent=NPL/Total_GDP*100;
	drop _NAME_ AFG BGD BTN IND LKA PAK;
run;

proc print data=finalpro.final_gdp;
	LABEL NPL="Nepal GDP"
		Total_GDP= "Total SAARC GDP" 
		NPL_Percent="Nepal GDP in Percent";
run;
/*GDP growth*/
proc transpose data=finalpro.gdp_growth
				out=finalpro.gdp_growth_transpose (rename=(col1=AFG col2=BGD
				 col3=BTN col4=IND col5=LKA col6=NPL 
				col7=PAK _Label_=Year));
run;

data finalpro.final_gdp_growth;
	set finalpro.gdp_growth_transpose;
	drop _NAME_;
	average_gdp_growth=mean(AFG, BGD,BTN,IND,LKA,NPL,PAK);
run;

proc transpose data=finalpro.gdp_per_capita
				out=finalpro.gdp_per_capita_transpose (rename=(col1=AFG col2=BGD
				 col3=BTN col4=IND col5=LKA col6=NPL 
				col7=PAK _Label_=Year));
run;

data finalpro.final_gdp_per_capita;
	set finalpro.gdp_per_capita_transpose;
	drop _NAME_;
	average_gdp_per_capita=mean(AFG, BGD,BTN,IND,LKA,NPL,PAK);
run;

			



