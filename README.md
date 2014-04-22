run_analysis.R
========================================================
This script summarizes the Human Activity Recognition Using Smartphones Data Set 
(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) measurement means and standard deviations into a data.frame called "SummaryData". 

The data set (59.7 Mb) can be downloaded either from the above link and unzipped into the current working directory, or the script can download and unzip the data set for the user. The curl tool (http://curl.haxx.se/) is required for download on non-Windows systems.

The script also reports the averages of each measurement accross activity-subject pairs to a data.frame called "ActivitySubjectMeans".

Successful implementation should yield the following input-output on the
command line:
```{r}
> source('C:/R/run_analysis.R')
> getTidySamsungData()
Generating summary data...
Generating activity-subject means...
done!
```
> Released April 22, 2014 by mericcanusta