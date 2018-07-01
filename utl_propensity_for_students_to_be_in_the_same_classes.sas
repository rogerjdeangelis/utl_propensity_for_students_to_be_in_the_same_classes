SAS Forum: Propensity for students to be in the same classes

This is a matrix dot(inner product) problem.

WPS/PROC R or IML/R

github
https://tinyurl.com/ydymnyj4
https://github.com/rogerjdeangelis/utl_propensity_for_students_to_be_in_the_same_classes

https://tinyurl.com/y82rzj36
https://communities.sas.com/t5/General-SAS-Programming/How-do-I-figure-out-the-best-way-to-pair-up-between-students/m-p/474689


INPUT
=====

 SD1.HAVE total obs=4

  STUDENT    ALGEBRA    HISTORY    SCIENCE    POLYSCI    CIVICS

    PAT         1          0          0          1          1
    TIM         0          0          1          1          1
    TED         0          1          1          0          1
    LIZ         1          1          0          1          0


 EXAMPLE OUTPUT

      PAT TIM TED LIZ
  PAT   3   2   1   2
  TIM   2   3   2   1
  TED   1   2   3   1
  LIZ   2   1   1   3


RULES (Pats inner product with Pat,Tim,Ted and Liz)
---------------------------------------------------
PAT   3   2   1   2

PAT dot PAT

PAT 1 0 0 1 1 dot 1
                  0
                  0
                  1
                  1  1*1 + 0*0 +0*0 +1*1 +1*1 = 3

PAT dot Tim

PAT 1 0 0 1 1 dot 0
                  0
                  1
                  1
                  1   1*0 + 0*0 + 0*1 + 1*1 + 1*1 =2


PROCESS (working code)
======================

      have %nrstr%%*% t(have);


OUTPUT
======

WORK.WANT total obs=4

 Obs PAT    TIM    TED    LIZ

 1    3      2      1      2
 2    2      3      2      1
 3    1      2      3      1
 4    2      1      1      3

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;


options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have(drop=student);
input student $ Algebra History Science Polysci Civics;
datalines;
PAT 1 0 0 1 1
TIM 0 0 1 1 1
TED 0 1 1 0 1
LIZ 1 1 0 1 0
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;


%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk  sas7bdat "%sysfunc(pathname(work))";
libname hlp  sas7bdat "C:\Progra~1\SASHome\SASFoundation\9.4\core\sashelp";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
have<-as.matrix(read_sas("d:/sd1/have.sas7bdat"));
head(have);
want<-as.data.frame(have %nrstr(%%)*% t(have));
colnames(want)<-c("PAT", "TIM", "TED", "LIZ");
want;
endsubmit;
import r=want data=wrk.want;
run;quit;
');



