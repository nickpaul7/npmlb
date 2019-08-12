#'@import rvest
#'

#player page
#"https://www.baseball-reference.com/players/s/sabatc.01-pitch.shtml"

#'@export
scrape_pitching_career_stats <- function(url, player = NULL){

    # some function that finds the player you want and creates url

    # url <- find_player()
    # url <- "https://www.baseball-reference.com/players/s/sabatc.01.shtml"

    Sys.sleep(runif(1)*2)

    # read the html

    html <- xml2::read_html(url)

    # get the pitching table

    non_numeric_columns <- c("Tm", "Lg", "Awards")

    df_pitching_raw <-  html %>%
        # html_nodes("table") %>%
        html_nodes("#pitching_standard") %>%
        html_table(fill = TRUE) %>%
        dplyr::bind_rows() %>%
        .[!is.na(names(.))]

    print(url)

    if(nrow(df_pitching_raw) == 0){
        return(tibble::tibble())
    }

    df_pitching_raw %>%
        mutate_at(vars(-one_of(non_numeric_columns)), as.numeric) %>%
        mutate(lg_type = str_extract(Tm, "min")) %>%
        invisible()

}

#'@export
filter_career_totals <- function(df){

    df %>%
        filter(stringr::str_detect(Tm, "^\\d{1,2} Yrs?$"))


}







