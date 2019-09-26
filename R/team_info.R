
#'@export
scrape_team_full_roster <- function(team, lookup_year){

    # create URL ---------------------------------------------------------------
    # team_url_start <- "https://www.baseball-reference.com/teams/"
    #
    # team_url_end <- ".shtml"
    #
    # url <- stringr::str_c(team_url_start, team, "/", year, team_url_end)

    #Look up team
    url <- npmlb::historical_team_pages %>%
        dplyr::filter(lookup_year == year, abbreviation == team) %>%
        pull(link)

    # read the page ------------------------------------------------------------
    html <- xml2::read_html(url)

    # extract pitching and batting tables --------------------------------------

    pitching <- extract_roster(html, "p", lookup_year)

    batting <- extract_roster(html, "b", lookup_year)

    # store both data frames into a signle data frae ---------------------------
    df <- tibble::tibble(team = team,
                         year = lookup_year,
                         data_type = c("pitching", "batting"),
                         data = list(pitching, batting))

    df
}

#'@export
scrape_mlb_full_roster <- function(lookup_year){

    teams <- npmlb::team_pages$abbreviation

    df <- map_df(teams, scrape_team_full_roster, lookup_year)

    df
}

get_all_team_pages <- function(){

    link <- "https://www.baseball-reference.com/teams/"


    page <- link %>%
        read_html()

    team_pages <- page %>%
        html_nodes("#all_teams_active a") %>%
        html_attr("href") %>%
        str_replace_all("teams|/","") %>%
        unique() %>%
        str_c(link, .)

    df <- tibble::tibble(team_page = team_pages) %>%
        dplyr::mutate(abbreviation = stringr::str_extract(team_page, "\\w{3}$"))

    df
}

get_historical_team_pages <- function(team){

    df_team <- npmlb::team_pages %>%
        dplyr::filter(abbreviation == team)

    team_page <- df_team$team_page

    html <- team_page %>%
        read_html()

    links <- html %>%
        html_nodes("#franchise_years > tbody > tr:nth-child(n) > td:nth-child(2) > a")  %>%
        html_attr("href") %>%
        str_c(domain, .)

    df <- tibble::tibble(link = links) %>%
        mutate(year = stringr::str_extract(link, "\\d{4}"),
               team_page = df_team$team_page,
               abbreviation = df_team$abbreviation)

    df

}

get_link_text <- function(html){

    link <- html %>%
        html_attr("href")

    text <- html %>%
        html_text()

    df <- tibble::tibble(link, text)
}

extract_roster <- function(html, type, lookup_year){
    # is there a way to not include lookup_year parameter?
    # set the css_selector for pitching or batting roster tables ---------------

    if(type == "p"){

        css_selector <- "#team_pitching"

    } else if(type == "b") {

        css_selector <- "#team_batting"

    } else {

        stop("type must be 'b' or 'p'")
    }

    # extract roster table from page -------------------------------------------

    roster <- html %>%
        rvest::html_nodes(css_selector) %>%
        rvest::html_table() %>%
        dplyr::bind_rows() %>%
        tibble::as_tibble() %>%
        filter(!Rk %in% c("", "Rk")) %>%  # get rid of non-player rows
        mutate(Rk = Rk %>% as.numeric())


    # extract player links from roster table page ------------------------------

    roster_with_links <- html %>%
        rvest::html_nodes(css_selector) %>%
        rvest::html_nodes("tbody > tr:nth-child(n) > td:nth-child(3)") %>%
        html_nodes("a") %>%
        get_link_text()

    # combine roster with links ------------------------------------------------

    roster_combined <- dplyr::bind_cols(roster, roster_with_links)

    # Add additional columns to combined data frame ----------------------------

    output <- roster_combined %>%
        mutate(type = type) %>%
        mutate(player_id = player_id(link),
               game_log_link = make_gamelog_link(player_id, type, lookup_year))

    # Print results ------------------------------------------------------------

    output

}

add_game_log_to_roster <- function(roster){

    roster

    output <- roster %>%
            mutate(game_log = map2(game_log_link, type, scrape_player_game_logs))

    print(output)

    sleep <- runif(1)

    Sys.sleep(sleep)

    output

}
