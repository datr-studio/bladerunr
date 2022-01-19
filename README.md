
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bladerunr

<!-- badges: start -->
<!-- badges: end -->

The goal of bladerunr is to …

## Installation

You can install the development version of bladerunr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("firthj/bladerunr")
#> Downloading GitHub repo firthj/bladerunr@HEAD
#> Skipping 1 packages ahead of CRAN: datr
#> * checking for file ‘/private/var/folders/b0/gtgr_jys3yj5jx70g8tympjr0000gn/T/RtmpzJ8tpR/remotes79f72da8cf0c/datr-studio-bladerunr-f795d3f/DESCRIPTION’ ... OK
#> * preparing ‘bladerunr’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> * building ‘bladerunr_0.0.0.9000.tar.gz’
#> Installing package into '/private/var/folders/b0/gtgr_jys3yj5jx70g8tympjr0000gn/T/Rtmpj1zQiM/temp_libpath77c86ef19d8c'
#> (as 'lib' is unspecified)
```

## Overview

Put simply, `bladerunr` exists to manage large tests runs, typically
across a grid of changing parameters. It is intended to balance
flexibility with stablility. On the one hand, it is highly flexible so
that you can execute whatever you like each run; on the other hand,
`bladerunr` will manage your test outputs for your and vigiliently
ensure that any tests that stall or fail don’t ruin the rest of your
run.

## Where to start?

Getting started with `bladerunr` is easy. Before you can start a run,
you’ll need to call `blade_setup()`, which will take care of the details
for you. To call it you’ll need to specify a few basic parameters.

``` r
library(bladerunr)
blade_setup(
  run_name = "my_grid_search",
  runr = function(x) x^2,
  output_dir = "validation/outputs",
  timeout = 300,
  max_attempts = 2
)
#> Setup complete.
```

First let’s get to know the straight-forward ones, and then we’ll talk
about callbacks.

## Basic Settings

#### run\_name

`run_name` should be an easy to remember name for your current test. It
will also be used to create a subfolder in your output directory (if you
use one).

#### output\_dir

`output_dir` is an optional directory that will be set up and passed to
your runrs. If you specify one, `bladerunr` will make sure that it’s
empty (or warn you if it isn’t) before each run so that you can be sure
your results are fresh. It can also be used by your runrs (more on that
below).

### timeout

`timeout` is a value in seconds representing the maximum amount of time
you want to try a run. After this time is exceeded, `bladerunr` will
admit defeat and move on to the next test (or, if you’ve specified more
than one `max_attempts`, it’ll try until again it reaches that max).
This is helpful when you may have to include certain parameters that
cause your model to run for very long time, but you’d rather skip these.

### max\_attempts

`max_attempts` is the number of times to try if your runr fails. This
can be useful if your model may unexpectedly fail for some reason on
occasion. Instead of ruining the whole search, `bladerunr` will try
again as many times as you like. At the end of the run, if `bladerunr`
was unsuccessful in completing a run, it’ll let you know and give you a
list of those failed runs.

### use\_sound

`use_sound` indicates whether you’d like to hear sounds as your tests
run. This can be useful if you’re multitasking but want to know how it’s
going.

## Callbacks

To make `bladerunr` flexible, it encorporates three different
*callbacks* (what we call `runrs`) that can be executed at each
iteration. A *callback* is simply a function that will be executed by
`bladerunr`. You can specify three different types of runrs, which are
described in more detail below. First, however, a word about `context`.

### Context

Each of the callback functions will receive a context object their last
argument.

The context object is a `list()` that contains the following
information:

-   `test_n`
-   `run_name`
-   `output_dir` (which may be `NULL`, if not specified in
    `blade_setup()`)

**This means that your callbacks must accept the context argument, even
if you don’t intend to use it.**

If your function doesn’t care about context, simply include `...` and it
will be ignored. In addition to context, the runrs have different
arguments, explained below.

### The Pre-Runr

The `pre_runr` argument in `blade_setup` is an *optional* function to
run before each iteration. This can be useful if your model has
comprehensive setup tasks, or requires side-effect to be enacted before
execution each time.

A `pre_runr` will be given a list of `params` at each iteration as its
first argument.

#### params

At each run, `bladerunr` will take a rowwise slice of your grid, which
you can use to execute your tests. Here’s an example to make that
clearer:

``` r
library(tibble)
# If your grid looked something like this:
grid <- tibble(a = 1:3, b = seq(10, 30, 10))

# Then your params object would be a rowwise slice of that at each iteration.

# Test 1 would look like this:
# A tibble: 1 × 2
#       a     b
#   <int> <dbl>
# 1     1    10
```

Therefore, a `pre_runr` needs to accept two arguments: params and
context.

``` r
my_pre_runr <- function(params, context) {
  my_var <- params$my_var
  # Do stuff
}
```

Note that, by design, if your `pre_runr` fails, the test will not
continue. Note also that `bladerunr` will not pay attention to any
return values from this function. It should be called for side effects
only.

### The Runr

A `runr` is required, otherwise what’s the point of running a test. It’s
the main workhorse of your tests and it’s the function which is watched
for failures and stalls. Like the `pre_runr`, it also must accept the
same two arguments: params and context.

``` r
my_runr <- function(params, context) {
  # Run my awesome test
}
```

#### Return values

If your `runr` returns a value, it will be passed on to your `post_runr`
(if you have one). You can return any type you like.

### The Post-Runr

The `post_runr` is our last callback executed at each iteration. Like
the others, it receives the context object as its final argument; unlike
the others, it does not receive the params but instead will be passed
the results of the `runr`, if there were some. If your `runr` did not
return a result, however, none will be passed on and its only argument
will be the context.

``` r
my_post_runr_with_results <- function(result, context) {
  # Do something with my results (and context)
}

my_post_runr_without_results <- function(context) {
  # Do something with context
}
```

Note also that `bladerunr` will not pay attention to any return values
from this function.

## Setting up your search grid
