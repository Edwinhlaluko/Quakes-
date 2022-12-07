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






