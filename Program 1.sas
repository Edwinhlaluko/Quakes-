data  quakes;
	infile '/home/u62783616/Quakes/QUAKES - QUAKES.csv' dlm = ',' firstobs = 2;
	input Latitude Longitude Depth Magnitude Type $ ;
run;

proc print data=quakes;
run;

proc sgplot data = work.quakes;
	vbar type/ 
	stat=sum
	fillattrs= (color  = blue)
	datalabel
	nooutline
	barwidth=0.5;
run;

proc sgmap plotdata = work.quakes;
	where magnitude > 2;
	openstreetmap;
	bubble x = Longitude y= Latitude size = Magnitude;
run;


title1 'Quakes';
proc sgmap plotdata=work.quakes ;
  openstreetmap;
  scatter x=Longitude y= Latitude;
run;

title1 'Quakes';
proc sgmap plotdata=work.quakes noautolegen ;
  openstreetmap;
  scatter x=Longitude y= Latitude;
run;


title 'Where are the explosions located';
proc sgmap plotdata=WORK.QUAKES;
	where Type = "explosion";
	openstreetmap;
	text x=Longitude y=Latitude text=Type / textattrs=GraphValueText;
run;

title 'Where are the earthquake located';
proc sgmap plotdata=WORK.QUAKES;
	where Type = "earthquake";
	openstreetmap;
	text x=Longitude y=Latitude text=Type / textattrs=GraphValueText;
run;

title 'Where are the landslide located';
proc sgmap plotdata=WORK.QUAKES;
	where Type = "landslide";
	openstreetmap;
	text x=Longitude y=Latitude text=Type / textattrs=GraphValueText;
run;

title 'Where are the mining explosion located';
proc sgmap plotdata=WORK.QUAKES;
	where Type = "mining_exp";
	openstreetmap;
	text x=Longitude y=Latitude text=Type / textattrs=GraphValueText;
run;

title 'Where are the quarry located';
proc sgmap plotdata=WORK.QUAKES;
	where Type = "quarry";
	openstreetmap;
	text x=Longitude y=Latitude text=Type / textattrs=GraphValueText;
run;

title 'Where are the rock bursts located';
proc sgmap plotdata=WORK.QUAKES;
	where Type = "rock_burst";
	openstreetmap;
	text x=Longitude y=Latitude text=Type / textattrs=GraphValueText;
run;

/* Define Pie template */
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Pie Showing The percenttage of quakes" / textattrs=(size=14);
		layout region;
		piechart category=Type / stat=pct start=180 categorydirection=clockwise 
			datalabellocation=outside fillattrs=(transparency=0.25) dataskin=gloss;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=16cm height=12cm imagemap;

proc sgrender template=SASStudio.Pie data=WORK.QUAKES;
run;

ods graphics / reset;

proc sgplot data=WORK.QUAKES;
	heatmap x=RootMeanSquareTime y=Depth / name='HeatMap';
	gradlegend 'HeatMap';
run;

proc sgplot data=WORK.QUAKES(obs=10);
	where magnitude <2;
	vbar Magnitude/categoryorder=respdesc ;
	yaxis grid;
run;

proc sgplot data=WORK.QUAKES(obs=50);
	vline Magnitude / categoryorder=respdesc;
	yaxis grid;
run;

proc sgplot data=WORK.QUAKES(obs=50);
	vline RootMeanSquareTime / categoryorder=respdesc;
	yaxis grid;
run;

proc print data = quakes;
where id = 15000;
run;
 
data quakes;
set quakes;
if id = 1 then delete;
run;

tittle 'Scatter plot showing the relationship between magnitude and depth';
proc sgplot data=WORK.QUAKES;
	scatter x=Magnitude y=Depth /;
	xaxis grid;
	yaxis grid;
run;



/* Define Pie template */
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Pie Showing The percenttage of quakes" / textattrs=(size=14);
		layout region;
		piechart category=Type / stat=pct start=180 categorydirection=clockwise 
			datalabellocation=outside fillattrs=(transparency=0.25) dataskin=gloss;
		endlayout;
		endgraph;
	end;
run;

/*Modify*/
%macro modifying(id, magnitude, type);
data work.quakes;
	set work.quakes;
	modify quakes;
	magnitude = magnitude +1;
	type = "Edwin";
	depth = 3;
	where id = &id;
	proc print data=work.quakes (obs=10);
	
run;
%mend modifying;
%modifying(5);

/* second modify*/
%macro search(id=);
proc print data = quakes;
where id = &id;
run;
%mend search;
%search(id=55);
 
 

/*Importing the quakes dataset in csv format to SAS studio */
proc import out = quakes
	file ='/home/u62783616/Quakesfirst/QUAKES - QUAKES (1).csv'
	DBMS = CSV
	replace;
run;

/*Print the contents of the dataset*/
proc print data=quakes;
run;

/*Determine all the statistical values from the dataset*/
proc means data = WORK.QUAKES;
run;

/*Used the mean of dNearestStation and RootMeanSquareTime to fill all the null values within the two columns*/
data WORK.QUAKES;
	set WORK.QUAKES;
 
	dNearestStation = coalesce(dNearestStation,0.0749059);
	RootMeanSquareTime = coalesce(RootMeanSquareTime,0.2140344);
	
run;

/*Print the new data after filling the null values*/
proc print data=quakes;
run;

/*From here is the beginning of the data visualization using SAS sgmap and SAS shplot to visualize the analysis*/

/*This is the first map, which shows the region of the analysis*/
title 'Map of the region';
proc sgmap plotdata=WORK.QUAKES;
	openstreetmap;
	text x=Longitude y=Latitude text=Type / textattrs=GraphValueText;
run;

/*This is is the bar graph displaying the types of quakes that happened in the area*/
title 'Number and types of quakes in the region';
proc sgplot data = WORK.QUAKES;
	vbar type/ 
	stat=sum
	fillattrs= (color  = blue)
	datalabel
	nooutline
	barwidth=0.5;
run;

proc sort  data=WORK.QUAKES out=_BarChartTaskData;
	by Magnitude descending Magnitude;
run;

/*This map shows the affected region in the dataset*/
title 'A map showing regions with severe quakes';
proc sgmap plotdata=WORK.QUAKES;
	where magnitude > 6;
	openstreetmap;
	bubble x=Longitude y=Latitude size=Magnitude/;
run;

/*This map shows the areas which were largely affected */
title 'Regions where a large perimeter was affected';
proc sgmap plotdata = WORK.QUAKES;
	where depth > 20;
	openstreetmap;
	bubble x=Longitude y=Latitude size=Depth/ group=depth 
		name="bubblePlot";
	keylegend "bubblePlot" / title='depth';
run;

/*This histogram shows the overall occurance in terms of magnitude */
title 'Histogram showing count of magnitude';
proc sgplot data=WORK.QUAKES;
	histogram Magnitude / scale=count;
	yaxis grid;
run;

/*This histogram shows the orall root mean square time*/ 
title 'Histogram of Root mean square';
proc sgplot data=WORK.QUAKES;
	histogram RootMeanSquareTime / scale=count;
	yaxis grid;
run;

/*This histogram shows the overall depth*/
title 'Histogram of depth';
proc sgplot data=WORK.QUAKES;
	histogram Depth /;
	yaxis grid;
run;

/*This heat map compares the relationship between magnitude and depth */
title 'The depths with the highest magnitudes';
proc sgplot data=WORK.QUAKES;
	where magnitude >4;
	heatmap x=Depth y=Magnitude / name='HeatMap';
	gradlegend 'HeatMap';
run;

/*This map shows an area where nearest station are located*/
title 'Where are the nearest station are located?';
proc sgmap plotdata=WORK.QUAKES;
	openstreetmap;
	scatter x=Longitude y=Latitude/ group=dNearestStation name="scatterPlot" 
		markerattrs=(size=7);
	keylegend "scatterPlot"/ title='dNearestStation';
run;

/*This map shows an area where explosions took place*/
title 'Where are the explosions located';
proc sgmap plotdata=WORK.QUAKES;
	where Type = "explosion";
	openstreetmap;
	text x=Longitude y=Latitude text=Type / textattrs=GraphValueText;
run;

/*This map shows an area where explosions took place*/
title 'Where are the earthquake located';
proc sgmap plotdata=WORK.QUAKES;
	where Type = "earthquake";
	openstreetmap;
	text x=Longitude y=Latitude text=Type / textattrs=GraphValueText;
run;

/*This map shows an area where landslide took place*/
title 'Where are the landslide located';
proc sgmap plotdata=WORK.QUAKES;
	where Type = "landslide";
	openstreetmap;
	text x=Longitude y=Latitude text=Type / textattrs=GraphValueText;
run;

/*This map shows an area where mining explosions took place*/
title 'Where are the mining explosion located';
proc sgmap plotdata=WORK.QUAKES;
	where Type = "mining_exp";
	openstreetmap;
	text x=Longitude y=Latitude text=Type / textattrs=GraphValueText;
run;

/*This map shows an area where quarry took place*/
title 'Where are the quarry located';
proc sgmap plotdata=WORK.QUAKES;
	where Type = "quarry";
	openstreetmap;
	text x=Longitude y=Latitude text=Type / textattrs=GraphValueText;
run;

 proc sort data=sonic7;
 by music sidobs;
run;

/*This map shows an area where rock bursts took place*/
title 'Where are the rock bursts located';
proc sgmap plotdata=WORK.QUAKES;
	where Type = "rock_burst";
	openstreetmap;
	text x=Longitude y=Latitude text=Type / textattrs=GraphValueText;
run;

/* This Pie chart compares all the quakes(in percentange) */
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Pie Showing The percenttage of quakes" / textattrs=(size=14);
		layout region;
		piechart category=Type / stat=pct start=180 categorydirection=clockwise 
			datalabellocation=outside fillattrs=(transparency=0.25) dataskin=gloss;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=16cm height=12cm imagemap;

/* STATGRAPH 'SASStudio.Pie' has been saved to: WORK.TEMPLAT*/
proc sgrender template=SASStudio.Pie data=WORK.QUAKES;
run;

/*This heat map shows the relationship between root mean square time and depth*/ 
title 'Heatmap showing the relationship between root mean square time and depth';
proc sgplot data=WORK.QUAKES;
	heatmap x=RootMeanSquareTime y=Depth / name='HeatMap';
	gradlegend 'HeatMap';
run;

/*This scatter plot shows the distribution of magnitude against the magnitude*/
tittle 'Scatter plot showing the relationship between magnitude and depth';
proc sgplot data=WORK.QUAKES;
	scatter x=Magnitude y=Depth /;
	xaxis grid;
	yaxis grid;
run;


/*This Pie chart shows  the percentage of each magnitude */
title 'Pie chart showing the percentage of each magnitude';
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		layout region;
		piechart category=Magnitude / start=90 fillattrs=(transparency=0.25) 
			dataskin=gloss;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.QUAKES;
run;


proc rank data=WORK.QUAKES out=work.Rank;
	var Depth;
	ranks rank_Depth;
run;

proc print data=work.Rank(obs=10);
	title "Subset of work.Rank";
run;

title;


proc sort data=WORK.QUAKES out=work.sortDS equals;
	by descending Depth;
run;


proc print data=work.sortds;
run;

/*Insert*/
%macro insert_(id=, depth=);
data work.quakes;
	set work.quakes;
	insert quakes;
	depth =3.6;
	id =&id;
run;
%mend insert_;
%insert_(8);
	   
	   
/*Modify*/
%macro modifying(id, magnitude, type);
data work.quakes;
	set work.quakes;
	modify quakes;
	magnitude = magnitude +1;
	type = "Edwin";
	depth = 3;
	where id = &id;
	proc print data=work.quakes (obs=10);
	
run;
%mend modifying;
%modifying(5);

/*Search function*/
%macro search(id=);
proc print data = quakes;
where id = &id;
run;
%mend search;
%search(id=55);
 
/*Delete function*/
%macro delete_(id =);
proc print data = quakes;
data quakes;
set quakes;
if id = 10 then delete;
run;
%mend delete_;
%delete_(id= 10);


		
		

	
	