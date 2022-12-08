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
		
		

	
	