# `clumpedcalib`: Calculate and Apply Clumped Isotope Calibrations Using Bootstrapping

[![](https://zenodo.org/badge/657580630.svg)](https://zenodo.org/badge/latestdoi/657580630)

Written by [Ilja J. Kocken](https://orcid.org/0000-0003-2196-8718) Feel
free to use this stuff, as long as you adhere to the
[file:LICENSE.md](LICENSE.md)

-   Calculate bootstrapped York regression from clumped isotope
    calibration data.
-   Calculate bootstrapped sample means for the age, d13C, d18O, and
    D47.
-   Apply the bootstrapped calibration to calculate temperature and
    d18Osw.
-   Also comes with the classic d18Occ calibrations. See
    [temp_calc()](R/temp_calc.R).
-   As well as the inverses, for when you have constraints on
    temperature and wish to calculate d18Osw. See
    [d18Osw_calc()](R/d18Osw_calc.R) .

## How to calculate bootstrapped averages and apply a clumped-isotope specific temperature calibration.

To use this:

1.  Install this package `clumpedcalib`, see
    [#installation](#installation).
2.  Update the input calibration data
    [file:dat/example_calib.csv](dat/example_calib.csv). Make sure the
    column names include `X`, `D47`, `sd_X`, `sd_D47`.
3.  Add your sample data at the replicate level.
4.  Check to see if you like [the function that calculates
    d18Osw](R/d18Osw_calc.R). Currently, you can choose from the Kim &
    O\'Neil 1997 calibration, as adjusted by Bemis et al., 1998, or the
    Marchitto et al., 2014 calibration.
5.  Create your own definition of [filter outliers](R/filter_outliers.R)
    so that it filters out bad measurements and NA\'s for your data.
6.  Walk through [the example workflow](clumped-bootstrap-calibration.org)
    step-by-step.
7.  Have a look at [the functions](R) to better understand what's
    happening.

The bootstrapped calibration idea is based on a Matlab script written by
Alvaro Fernandez.

# installation

To install this development package:

```{R}
remotes::install_github("japhir/clumpedcalib")
```

Or you can look at all the [functions](R) and only copy what you like.
