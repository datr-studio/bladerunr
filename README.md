
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bladerunr

## Overview

<!-- badges: start -->
<!-- badges: end -->

The goal of `bladerunr` is to make it easy to run long tests over a grid
of search parameters. `bladerunr` aims to solve the following common
challenges that occur with optimisation and simulation problems:

-   Set up a grid of all unique combinations of parameters.
-   Easily filter grid using tidyverse-style conditions.
-   Run tests with built-in error-handling so that can document errors
    but not fail the run.
-   Set time limits for runs to catch stalling or poor parameter
    combinations.

`bladerunr` provides you with a base platform you can trust to manage
your testing process. That frees you up to focus on the test code
itself.

## Installation

You can install the development version of bladerunr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("firthj/bladerunr")
```

## Usage

All you need to run your tests are just three functions:

### blade\_setup

First, call `blade_setup()` to set the overall configuration of your
test run.

``` r
blade_setup(
  run_name = "my_model_run",
  runr = function(...) {
    # Do cool test stuff
  }
)
```

There are only two required arguments: a `run_name` that’s memorable and
a `runr`, which is your test function, the code you’d like to execute at
each iteration.

There are also several more options that you can use to tweak your test
run, including error logging, time outs, and number of attempts for each
run. See the vignette *“Running Tests with Bladerunnr”* for more info.

### blade\_params

Next, we’ll also want to define a search grid.

``` r
grid <- blade_params(
  list(
    a = seq(1, 3, 0.5),
    b = 1:3,
    c = 3:1
  ),
  a > b,
  c == a * b
)
```

The first argument is a named list of parameters you want to combine.
You may also specify any conditions about the relationships between
these using tidyverse-style syntax.

### blade\_runr

Once your setup is complete, you’re ready for the easy part: running
tests. Simply call `blade_runr()` with your test grid and it’ll take
care of the rest.

``` r
# Not run
blade_runr(grid)
```

## Getting help

If you encounter a clear bug, please file an issue with a minimal
reproducible example on
[GitHub](https://github.com/firthj/bladerunr/issues).
