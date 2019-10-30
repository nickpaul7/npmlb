#'@import rvest
#'@import dplyr
#'@import xml2
#'@import stringr
#'@import tibble
#'@import tidyr

#'@export

get_players_per_page <- function(url){

    html <- xml2::read_html(url)

    html %>%
        html_nodes("#players__link") %>%
        html_attr("data-label") %>%
        stringr::str_extract("\\d+")
}

#'@export

player_id <- function(x){

    x %>%
        stringr::str_extract("(?<=/)[\\w\\d\\.']+(?=.shtml)")
}

#'@export

player_links <- function(url){

    html <- xml2::read_html(url)

    text_info <- html %>%
        html_nodes("#div_players_") %>%
        html_nodes("p") %>%
        html_text()

    if(length(text_info) == 0){

        return(tibble::tibble())
    }

    name_dates <- text_info %>%
        stringr::str_replace("\\+? +\\(", ",") %>%
        stringr::str_replace("\\)","")

    hof <- text_info %>%
        stringr::str_extract("\\+") %>%
        stringr::str_replace("\\+", "HOF")

    link_info <- html %>%
        html_nodes("#div_players_") %>%
        html_nodes("p") %>%
        html_nodes("a") %>%
        html_attr("href")

    # need to find which ones are bold or active

    bold <- html %>%
        html_nodes("#div_players_") %>%
        html_nodes("p") %>%
        as.character() %>%
        stringr::str_detect("<b>.+</b>")


    df_return <- tibble::tibble(name_dates,
                   hof,
                   link_info) %>%
        tidyr::separate(name_dates, c("name", "years"), sep = ",") %>%
        tidyr::separate(years, c("start", "stop")) %>%
        dplyr::mutate_at(c("start", "stop"), as.numeric) %>%
        dplyr::mutate(link_info = stringr::str_c("https://www.baseball-reference.com",
                                         link_info)) %>%
        dplyr::mutate(player_id = player_id(link_info))



    df_return$active <- ""

    if(length(bold) > 0){

        df_return$active[bold] <- "Active"

    }


    df_return

}

find_player <- function(name){}

#'@export

scrape_hof_pitchers <- function(){

    url <- "https://www.baseball-reference.com/awards/hof_pitching.shtml"


    html <- xml2::read_html(url)

    player_links <- html %>%
        html_nodes("table") %>%
        html_nodes("a") %>%
        html_attr("href")

    df <- html %>%
        html_nodes("table") %>%
        html_table() %>%
        dplyr::bind_rows() %>%
        filter(Rk != "Rk") %>%
        mutate(player_link = player_links) %>%
        mutate(player_id = player_id(player_links))

    df
}

make_gamelog_link <- function(id, type, year){

   str_c("https://www.baseball-reference.com/players/gl.fcgi?id=",
                         id,
                         "&t=",
                         type,
                         "&year=",
                         year)


}

#'@export

scrape_player_game_logs <- function(game_log_url, type){

    # read the page with game logs ---------------------------------------------

    html <- read_html(game_log_url)

    year <- str_extract(game_log_url, "(?<=year=)\\d{4}")

    # extract player info ------------------------------------------------------

    player_name <- html %>%
        html_nodes("#meta > div:nth-child(2) > h1") %>%
        html_text()

    # extract game log table ---------------------------------------------------

    # function adds a a column name to the at column which is unnamed and causes
    # an error when trying to filter
    rename_by_pos = function(df, index, new_name){
        if(nrow(df)==0) {
            return(df)
        }
        colnames(df)[index] = new_name
        df
    }

    if(type == "p"){

        selector <- "#pitching_gamelogs"

    } else {

        selector <- "#batting_gamelogs"

    }

    game_log_table <- html %>%
        # html_nodes("table") %>%
        html_nodes(selector) %>%
        html_table() %>%
        dplyr::bind_rows()


    # clean the table ----------------------------------------------------------

    output <- game_log_table %>%
        rename_by_pos(6,"at") %>%
        dplyr::filter(str_detect(Rk,"\\d")) %>%
        mutate_all(as.character)
        # readr::type_convert() %>%
        # mutate(Date = stringr::str_c(Date, " ", year) %>%
                   # lubridate::mdy())

    cols <- colnames(output)

    # if("IR" %in% cols){
    #
    #     output <- output %>%
    #         mutate(IR = as.numeric(IR))
    #
    # }
    #
    # if("IS" %in% cols){
    #
    #     output <- output %>%
    #         mutate(IS = as.numeric(IS))
    #
    # }

    # print the output ---------------------------------------------------------
    output

}

get_game_logs_mlb <- function(year){

 roster <- scrape_mlb_full_roster(year)

 roster <- roster[1:2,]

 test <- roster %>%
     mutate(data = map(data, add_game_log_to_roster))
# batting data seems to have a problem
 #run through an example of batting data

}

#'@export

create_WHIP <- function(W, H, IP){

   full_innings <- IP %>%
       floor()

   partial_innings <- (IP - full_innings) * (1/3)

   adjusted_IP <- full_innings + partial_innings

   WHIP <- (W + H) / adjusted_IP
}



# old code ---------------------------------------------------------------------


# # url_all_pages <- stringr::str_c("https://www.baseball-reference.com/players/", letters[1], "/")
#
# df <- player_links(url)
#
# url_all_pages <- stringr::str_c("https://www.baseball-reference.com/players/", letters, "/")
#
# temp_list <- list()
#
# for(i in 1:length(letters)){
#
#     url <- stringr::str_c("https://www.baseball-reference.com/players/", letters[i], "/")
#
#     df <- player_links(url)
#
#     temp_list[[i]] <- df
#
#     Sys.sleep(1)
#
#     print(letters[i])
# }

# df_all_players <- purrr::map_df(url_all_pages, player_links)
