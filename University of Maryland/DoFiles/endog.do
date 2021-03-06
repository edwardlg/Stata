/*Problem Set 1 - Econ 645*/

clear all 
cap log close
set more off 

log using "C:\Users\faith\Documents\Cleaned Stata Files\ProblemSet1.log", replace
use fertility.dta, clear

/* Explore the data.
a. What is the average age of a mom in this dataset?
30.39327 
b. How many weeks did a mom work on average in 1979?
19.01833
c. What fraction of moms did not work at all in 1979?
47.18
d. How many weeks did a mom work, conditional on having worked, in 1979?
36.00466 
e. What fraction of moms have at least two kids?
38.06 
f. What fraction of moms have same gendered first two kids?
50.56
*/

summarize agem1
sum weeksm1
gen nowork = (weeksm1==0)
tab nowork

summarize weeksm1 if nowork == 0
tab morekids
tab samesex

/*8. Estimate a naïve regression of weeks worked on the dummy for having more than two kids.
*/

regress weeksm1 morekids

/*
a. On average, do women with more than two children work less than women with two children? 
Explain using the regression results.  

Yes; the coefficient is negative. Pvalue = 0.  

b. Now add controls for race and age of the mother.  */

regress weeksm1 morekids black hispan othrace agem1

/* Interpret the coefficient on morekids.

After adding controls, the coefficient becomes larger in absolute value and the tscore
increases. The standard error decreases somewhat but not by much. */

/*9. Why is OLS inappropriate for estimating the causal effect of fertility (morekids) on labor supply
(weeksm1)

Because morekids may be endogenous in the model and correlated with the error term. 

*/

/*10. Angrist and Evans propose using an indicator for whether the mother’s first two children are of the
same gender (samesex) an instrument for morekids
a. Estimate a first stage regression of morekids on samesex (as well as the other regressors we added in part (3).
*/

reg morekids samesex black hispan othrace agem1

/*11. Generate a new variable called xhat that is the predicted value of morekids based on the
regression you estimated in (6).*/
predict xhat, xb

/*
b. Explain why samesex is a valid instrument.

	Samesex is a valid instrument for morekids because it is correlated to morekids and not with the error.

c. Is samesex a weak or strong instrument? */
test samesex
corr morekids samesex

/*Same sex is not strongly correlated with morekids but it is statistically different from zero. */


/*12. Now estimate the second stage regression of weeks worked on xhat and the additional age and
race variables.
a. Save your second-stage output to your outreg2 file.
b. Compare the coefficient on xhat to the one on morekids from the OLS regression.
It is less negative.
*/
reg weeksm1 black hispan othrace agem1 xhat

/*13. We can carry out the steps in (7) – (9) in a single line of code using the ivregress command. And
while we get the same coefficient both ways, the standard errors are calculated correctly by
ivregress.
a. Use ivregress to replicate the results you got when you manually performed 2SLS
(including additional regressors for age and race).
b. What happened to the standard error on morekids in the second stage?
The standard error increased */

ivregress 2sls weeksm1 black hispan othrace agem1 (morekids = samesex)

log close
