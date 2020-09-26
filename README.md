# Predicting Mortality Outcomes in Randomized Trials with Proxies: Preliminary Demonstration using Uganda Data

This project applies the estimator developed in [Bastani (2019)](https://hamsabastani.github.io/proxies.pdf) to predict mortality outcome in a randomized controlled trial in global health. It attempts to use a proxy variable to improve the predictive accuracy on the true outcome of interest, mortality. Note that this is still work in progress, and here we present a preliminary demonstration on data from a study in Uganda. We may apply the technique to different data sets in the future.

Write-up on the motivation, background, data, method and results are in `Uganda_health_proxy.ipynb`.

We use the data from [Björkman Nyqvist, Walque and Svensson (2017)](https://www.aeaweb.org/articles?id=10.1257/app.20150027), which can be downloaded [here](https://www.openicpsr.org/openicpsr/project/113630/version/V1/view). We also include the files in the folder `AEJ_authors_files`.

The Stata do files `1-Uganda_organizing_data_sets.do` and `2-Uganda_merging` were used to reorganize data provided by the authors. Data sets generated in the process are stored in the folder `Intermediate_output`, and were used to generate the data set used in this exercise, `Uganda_health.csv`.
