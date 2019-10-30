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

Player Game Logs
================

To get all player game logs for entire season, use the code below.

``` r
path <- "/data/"
npmlb::save_mlb_year(2019, save_path = path)
```

Get Team Roster
===============

The `scrape_team_full_roster()` function will collect the pitching and batting roster for a given team.

``` r
team <- "NYY"
year <- "2019"
df_roster <- npmlb::scrape_team_full_roster(team, year)
```

To extract the rosters, you can use the following code.

``` r
df_roster %>% 
    filter(data_type == "pitching") %>% 
    unnest()
```

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
dplyr::glimpse(df_player_log)
```

    ## Observations: 145
    ## Variables: 38
    ## $ Rk        <chr> "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "...
    ## $ Gcar      <chr> "956", "957", "958", "959", "960", "961", "962", "96...
    ## $ Gtm       <chr> "2 (1)", "3", "4", "5", "6", "7", "8", "9", "10", "1...
    ## $ Date      <chr> "Mar 30", "Mar 31", "Apr 1", "Apr 2", "Apr 3", "Apr ...
    ## $ Tm        <chr> "NYY", "NYY", "NYY", "NYY", "NYY", "NYY", "NYY", "NY...
    ## $ at        <chr> "", "", "", "", "", "@", "@", "@", "@", "@", "@", ""...
    ## $ Opp       <chr> "BAL", "BAL", "DET", "DET", "DET", "BAL", "BAL", "BA...
    ## $ Rslt      <chr> "L,3-5", "L,5-7", "W,3-1", "L,1-3", "L,1-2", "W,8-4"...
    ## $ Inngs     <chr> "CG", "CG", "CG", "CG", "CG", "CG", "CG", "GS-7", "C...
    ## $ PA        <chr> "4", "5", "3", "4", "4", "4", "4", "4", "4", "4", "4...
    ## $ AB        <chr> "4", "2", "2", "4", "4", "4", "4", "4", "4", "4", "3...
    ## $ R         <chr> "1", "1", "0", "1", "1", "1", "1", "1", "1", "0", "0...
    ## $ H         <chr> "2", "2", "0", "2", "1", "1", "3", "1", "1", "0", "3...
    ## $ `2B`      <chr> "1", "0", "0", "0", "1", "0", "0", "1", "1", "0", "1...
    ## $ `3B`      <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0...
    ## $ HR        <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0...
    ## $ RBI       <chr> "1", "1", "0", "0", "0", "0", "0", "1", "0", "0", "2...
    ## $ BB        <chr> "0", "2", "1", "0", "0", "0", "0", "0", "0", "0", "0...
    ## $ IBB       <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0...
    ## $ SO        <chr> "0", "0", "2", "0", "2", "1", "0", "0", "0", "1", "0...
    ## $ HBP       <chr> "0", "1", "0", "0", "0", "0", "0", "0", "0", "0", "0...
    ## $ SH        <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0...
    ## $ SF        <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "1...
    ## $ ROE       <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0...
    ## $ GDP       <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0...
    ## $ SB        <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0...
    ## $ CS        <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0...
    ## $ BA        <chr> ".500", ".667", ".500", ".500", ".438", ".400", ".45...
    ## $ OBP       <chr> ".500", ".778", ".667", ".625", ".550", ".500", ".53...
    ## $ SLG       <chr> ".750", ".833", ".625", ".583", ".563", ".500", ".54...
    ## $ OPS       <chr> "1.250", "1.611", "1.292", "1.208", "1.113", "1.000"...
    ## $ BOP       <chr> "9", "9", "7", "5", "1", "6", "7", "6", "7", "6", "6...
    ## $ aLI       <chr> "1.68", "1.47", ".61", "1.06", ".91", ".90", "1.36",...
    ## $ WPA       <chr> "0.078", "0.213", "-0.011", "-0.027", "-0.030", "-0....
    ## $ RE24      <chr> "0.93", "2.44", "-0.16", "0.11", "-0.18", "-0.40", "...
    ## $ `DFS(DK)` <chr> "12.00", "16.00", "2.00", "8.00", "7.00", "5.00", "1...
    ## $ `DFS(FD)` <chr> "15.70", "21.70", "3.00", "9.20", "9.20", "6.20", "1...
    ## $ Pos       <chr> "3B", "2B", "3B", "3B", "3B", "3B", "3B 2B", "2B", "...
