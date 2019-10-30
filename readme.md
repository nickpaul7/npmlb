npmlb: Collecting Baseball Data
================

Introduction
============

This package is designed to collect baseball data from the web. Currently the package supports pulling data from the following sites:

<https://www.baseball-reference.com/>

-   Player Game Logs
-   HOF Players
-   Career Statistics

Install
=======

To install the latest version use the following code:

``` r
devtools::install_github("nickpaul7/npmlb")
```

Required Packages
=================

``` r
library(tidyverse)
```

    ## ── Attaching packages ──────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
    ## ✔ tibble  1.4.2     ✔ dplyr   0.7.6
    ## ✔ tidyr   0.8.1     ✔ stringr 1.2.0
    ## ✔ readr   1.1.1     ✔ forcats 0.3.0

    ## ── Conflicts ─────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

Player Game Logs
================

To get all player game logs for entire season, use the code below.

``` r
npmlb::save_mlb_year(2019)
```

Get Team Roster
===============

The `scrape_team_full_roster()` function will collect the pitching and batting roster for a given team.

``` r
team <- "NYY"
year <- "2019"
df_roster <- npmlb::scrape_team_full_roster(team, year)
```

    ## Warning: The `printer` argument is deprecated as of rlang 0.3.0.
    ## This warning is displayed once per session.

    ## Warning: `list_len()` is deprecated as of rlang 0.2.0.
    ## Please use `new_list()` instead.
    ## This warning is displayed once per session.

To extract the rosters, you can use the following code.

``` r
df_roster %>% 
    filter(data_type == "pitching") %>% 
    unnest()
```

    ## Warning: Unquoting language objects with `!!!` is deprecated as of rlang 0.4.0.
    ## Please use `!!` instead.
    ## 
    ##   # Bad:
    ##   dplyr::select(data, !!!enquo(x))
    ## 
    ##   # Good:
    ##   dplyr::select(data, !!enquo(x))    # Unquote single quosure
    ##   dplyr::select(data, !!!enquos(x))  # Splice list of quosures
    ## 
    ## This warning is displayed once per session.

    ## Warning: `lang()` is deprecated as of rlang 0.2.0.
    ## Please use `call2()` instead.
    ## This warning is displayed once per session.

    ## Warning: `new_overscope()` is deprecated as of rlang 0.2.0.
    ## Please use `new_data_mask()` instead.
    ## This warning is displayed once per session.

    ## Warning: `overscope_eval_next()` is deprecated as of rlang 0.2.0.
    ## Please use `eval_tidy()` with a data mask instead.
    ## This warning is displayed once per session.

    ## # A tibble: 32 x 42
    ##    team  year  data_type    Rk Pos   Name   Age   W     L     `W-L%` ERA  
    ##    <chr> <chr> <chr>     <dbl> <chr> <chr>  <chr> <chr> <chr> <chr>  <chr>
    ##  1 NYY   2019  pitching      1 SP    Masah… 30    11    9     .550   4.45 
    ##  2 NYY   2019  pitching      2 SP    J.A. … 36    12    8     .600   4.91 
    ##  3 NYY   2019  pitching      3 SP    James… 30    15    6     .714   3.82 
    ##  4 NYY   2019  pitching      4 SP    Domin… 26    18    4     .818   4.03 
    ##  5 NYY   2019  pitching      5 SP    CC Sa… 38    5     8     .385   4.95 
    ##  6 NYY   2019  pitching      6 CL    Arold… 31    3     2     .600   2.21 
    ##  7 NYY   2019  pitching      7 RP    Chad … 28    4     4     .500   4.17 
    ##  8 NYY   2019  pitching      8 RP    Adam … 33    6     5     .545   1.90 
    ##  9 NYY   2019  pitching      9 RP    Zack … 31    3     1     .750   1.91 
    ## 10 NYY   2019  pitching     10 RP    Tommy… 29    3     2     .600   3.67 
    ## # ... with 22 more rows, and 31 more variables: G <chr>, GS <chr>,
    ## #   GF <chr>, CG <chr>, SHO <chr>, SV <chr>, IP <chr>, H <chr>, R <chr>,
    ## #   ER <chr>, HR <chr>, BB <chr>, IBB <chr>, SO <chr>, HBP <chr>,
    ## #   BK <chr>, WP <chr>, BF <chr>, `ERA+` <chr>, FIP <chr>, WHIP <chr>,
    ## #   H9 <chr>, HR9 <chr>, BB9 <chr>, SO9 <chr>, `SO/W` <chr>, link <chr>,
    ## #   text <chr>, type <chr>, player_id <chr>, game_log_link <chr>

The `team_pages` data object contains the abbreviations for each team.

``` r
npmlb::team_pages
```

    ## # A tibble: 30 x 2
    ##    team_page                                    abbreviation
    ##    <chr>                                        <chr>       
    ##  1 https://www.baseball-reference.com/teams/ANA ANA         
    ##  2 https://www.baseball-reference.com/teams/ARI ARI         
    ##  3 https://www.baseball-reference.com/teams/ATL ATL         
    ##  4 https://www.baseball-reference.com/teams/BAL BAL         
    ##  5 https://www.baseball-reference.com/teams/BOS BOS         
    ##  6 https://www.baseball-reference.com/teams/LAD LAD         
    ##  7 https://www.baseball-reference.com/teams/CHC CHC         
    ##  8 https://www.baseball-reference.com/teams/CHW CHW         
    ##  9 https://www.baseball-reference.com/teams/CIN CIN         
    ## 10 https://www.baseball-reference.com/teams/CLE CLE         
    ## # ... with 20 more rows

Scrape a Player Page
====================

``` r
link <- "https://www.baseball-reference.com/players/gl.fcgi?id=lemahdj01&t=b&year=2019"
type = "b"
df_player_log <- npmlb::scrape_player_game_logs(link, type)
```

    ## Warning: `is_lang()` is deprecated as of rlang 0.2.0.
    ## Please use `is_call()` instead.
    ## This warning is displayed once per session.

    ## Warning: `mut_node_car()` is deprecated as of rlang 0.2.0.
    ## This warning is displayed once per session.
