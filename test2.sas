DATA CASUSER.HEART_Clean;
  SET CASUSER.HEART1;

  IF Sex = "Y" THEN Sex = 1; 
    ELSE Sex = 0;

  IF ExerciseAngina = "Y" THEN ExerciseAngina = 1; 
    ELSE ExerciseAngina = 0;

  IF RestingECG = "LVH" THEN RestingECG_dummy = 1;
	ELSE RestingECG_dummy = 0;
  IF RestingECG = "Normal" THEN RestingECG_dummy1 = 1;
	ELSE RestingECG_dummy1 = 0;
  IF RestingECG = "ST" THEN RestingECG_dummy2 = 1;
	ELSE RestingECG_dummy2 = 0;

  IF ST_Slope = "Up" THEN ST_Slope_dummy = 1;
	ELSE ST_Slope_dummy = 0;
  IF ST_Slope = "Down" THEN ST_Slope_dummy1 = 1;
	ELSE ST_Slope_dummy1 = 0;
  IF ST_Slope = "Flat" THEN ST_Slope_dummy2 = 1;
	ELSE ST_Slope_dummy2 = 0;

  IF ChestPainType = "ASY" THEN ChestPainType_Dummy = 1;
	ELSE ChestPainType_Dummy = 0;
  IF ChestPainType = "NAP" THEN ChestPainType_Dummy1 = 1;
	ELSE ChestPainType_Dummy1 = 0;  
  IF ChestPainType = "ATA" THEN ChestPainType_Dummy2 = 1;
	ELSE ChestPainType_Dummy2 = 0;
run;

data casuser.heart1;
set CASUSER.HEART_Clean;
drop RestingECG ST_Slope ChestPainType;
run;

proc means n nmiss;
  var _numeric_;


proc means;
  var _numeric_;


PROC UNIVARIATE PLOT NORMAL;

proc sgplot;
  histogram Age;
  density Age;
run;

proc gradboost data=CASUSER.heart1 outmodel=CASUSER.gradboost_model;
   input Age RestingBP Cholesterol FastingBS MaxHR Oldpeak / level = interval;
   input Sex RestingECG_dummy RestingECG_dummy1 RestingECG_dummy2 ST_Slope_dummy 
	ST_Slope_dummy1 ST_Slope_dummy2 ChestPainType_Dummy ChestPainType_Dummy1 
	ChestPainType_Dummy2  / level = nominal;
   target HeartDisease /level=nominal;
   autotune popsize=5 maxiter=2 objective=ASE;
   output out=CASUSER.score_at_runtime;
   ods output FitStatistics=fit_at_runtime;
run;
