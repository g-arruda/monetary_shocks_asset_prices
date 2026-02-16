#' Download historical exchange rate data
#'
#' @description
#' Function that downloads historical exchange rate data for different currencies
#' relative to a base currency, using Yahoo Finance data through the tidyquant package.
#' Uses USD triangulation to handle less liquid currency pairs.
#'
#' @param currency_tickers Character vector with the desired currency codes (e.g., c("EUR", "CNY", "GBP"))
#' @param base_currency Base currency for conversion. Default is "BRL" (Brazilian Real)
#' @param start_date Start date in "YYYY-MM-DD" format. Default is "2010-01-01"
#' @param end_date End date in "YYYY-MM-DD" format. Default is "2024-12-01"
#'
#' @return
#' Returns a dataframe with monthly data containing:
#' - date: Date (first day of the month)
#' - cambio_[currency]: Columns with monthly average exchange rate for each currency
#' - cambio_usd: USD exchange rate (always included)
#'
#' @details
#' The function:
#' 1. Downloads all currencies in Yahoo Finance format (SYMBOL=X, which represents USD/CURRENCY)
#' 2. Always includes BRL=X (USD/BRL rate)
#' 3. Calculates cross rates via triangulation: Moeda/BRL = (BRL=X) / (Moeda=X)
#' 4. Pivots data to wide format
#' 5. Renames columns adding "cambio_" prefix
#' 6. Calculates monthly averages
#'
#' Yahoo Finance Convention:
#' - SYMBOL=X returns USD/CURRENCY (e.g., CNY=X = USD/CNY, how many CNY for 1 USD)
#' - To get CURRENCY/BRL we calculate: (USD/BRL) / (USD/CURRENCY) = BRL=X / CURRENCY=X
#'
#' @examples
#' # Download Euro, Yuan and Pound exchange rates to BRL
#' df <- download_cambio(c("EUR", "CNY", "GBP"))
#'
#' @importFrom tidyquant tq_get
#' @importFrom dplyr select rename_with mutate group_by summarise arrange across left_join filter bind_rows
#' @importFrom tidyr pivot_wider
#' @importFrom lubridate floor_date
download_cambio <- function(
    currency_tickers,
    base_currency = "BRL",
    start_date = "2010-01-01",
    end_date = Sys.Date()) {
    
    # Add =X suffix to all currency tickers (Yahoo Finance format)
    currency_tickers_yf <- paste0(currency_tickers, "=X") |> tolower()
    
    # Always include base currency ticker (e.g., BRL=X for USD/BRL rate)
    base_ticker <- paste0(base_currency, "=X") |> tolower()
    
    # Combine all tickers, ensuring base ticker is included
    all_tickers <- unique(c(currency_tickers_yf, base_ticker))
    
    # Download all currency pairs from Yahoo Finance
    df_download <- tidyquant::tq_get(
        all_tickers,
        from = start_date,
        to = end_date,
        get = "stock.prices"
    ) |>
        dplyr::select(date, symbol, close)
    
    # Isolate base currency rate (USD/BRL)
    df_base <- df_download |>
        dplyr::filter(symbol == base_ticker) |>
        dplyr::rename(usd_to_base = close) |>
        dplyr::select(date, usd_to_base)
    
    # Process other currencies: calculate cross rate via triangulation
    # Formula: Moeda/BRL = (BRL=X) / (Moeda=X)
    df_currencies <- df_download |>
        dplyr::filter(symbol != base_ticker) |>
        # Join with base rate
        dplyr::left_join(df_base, by = "date") |>
        # Calculate cross rate: divide USD/BRL by USD/Currency
        dplyr::mutate(
            close = usd_to_base / close,
            # Clean up symbol name (remove "=x" suffix)
            symbol = gsub("=x$", "", symbol)
        ) |>
        dplyr::select(date, symbol, close)
    
    # Add USD rate (it's the base rate itself: BRL=X)
    df_usd_rate <- df_base |>
        dplyr::mutate(
            symbol = "usd",
            close = usd_to_base
        ) |>
        dplyr::select(date, symbol, close)
    
    # Combine all currencies
    df_all <- dplyr::bind_rows(df_currencies, df_usd_rate) |>
        tidyr::pivot_wider(
            names_from = symbol,
            values_from = close
        ) |>
        dplyr::rename_with(
            ~ paste0("cambio_", .x),
            -date
        )
    
    # Calculate monthly averages
    df_mensal <- df_all |>
        dplyr::mutate(date = lubridate::floor_date(date, "month")) |>
        dplyr::group_by(date) |>
        dplyr::summarise(
            dplyr::across(
                dplyr::starts_with("cambio_"),
                ~ mean(.x, na.rm = TRUE)
            )
        ) |>
        dplyr::arrange(date)
    
    return(df_mensal)
}
