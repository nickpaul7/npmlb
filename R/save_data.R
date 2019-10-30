
#'@export
save_mlb_year <- function(year, save_path = "/data/mlb/"){

    df <- scrape_mlb_full_roster(year)

    df_final <- df %>%
        dplyr::mutate(data = map(data, add_game_log_to_roster))

    fix_date <- function(date, year){

        date %>%
            stringr::str_extract("\\w{3}\\s\\d{1,2}") %>%
            stringr::str_c(" ", year) %>%
            lubridate::mdy()

    }

    fix_home_away <- function(df){

        df %>%
            mutate(at = stringr::str_replace(at, "@", "Away")) %>%
            replace_na(list(at = "Home"))

    }

    df_batting_game_logs <- df_final %>%
        filter(data_type == "batting") %>%
        unnest() %>%
        select(team, year, Name, player_id, game_log) %>%
        unnest() %>%
        readr::type_convert() %>%
        mutate(Date = fix_date(Date, year)) %>%
        remove_duplicate_player_logs() %>%
        fix_home_away()

    df_pitching_game_logs <- df_final %>%
        filter(data_type == "pitching") %>%
        unnest() %>%
        select(team, year, Name, player_id, game_log) %>%
        unnest() %>%
        readr::type_convert() %>%
        mutate(Date2 = fix_date(Date, year)) %>%
        remove_duplicate_player_logs() %>%
        fix_home_away()

    df_batting_totals <- df %>%
        filter(data_type == "batting") %>%
        unnest() %>%
        readr::type_convert()

    df_pitching_totals <- df %>%
        filter(data_type == "pitching") %>%
        unnest() %>%
        readr::type_convert()



    fn_p_gl <- str_c(save_path, "pitching_", "game_log_", year)
    fn_b_gl <- str_c(save_path, "batting_", "game_log_", year)
    fn_p_total <- str_c(save_path, "pitching_", "total_", year)
    fn_b_total <- str_c(save_path, "batting_", "total_", year)

    readr::write_rds(df_pitching_game_logs, fn_p_gl)
    readr::write_rds(df_batting_game_logs,  fn_b_gl)
    readr::write_rds(df_pitching_totals, fn_p_total)
    readr::write_rds(df_batting_totals, fn_b_total)

}

remove_duplicate_player_logs <- function(df){

    df %>%
        dplyr::mutate(game_id = stringr::str_c(player_id, Date, Gtm)) %>%
        dplyr::arrange(dplyr::desc(Date)) %>%
        dplyr::distinct(game_id, .keep_all = TRUE)


}
