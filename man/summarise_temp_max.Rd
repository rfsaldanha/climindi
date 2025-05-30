% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summarise_temp_max.R
\name{summarise_temp_max}
\alias{summarise_temp_max}
\title{Compute maximum temperature indicators from grouped data}
\usage{
summarise_temp_max(.x, value_var, normals_df)
}
\arguments{
\item{.x}{grouped data, created with \code{dplyr::group_by()}}

\item{value_var}{name of the variable with temperature values.}

\item{normals_df}{normals data, created with \code{summarise_normal()}}
}
\value{
A tibble.
}
\description{
The function computes maximum temperature indicators from grouped data. Expects temperature in celsius degrees.
}
\details{
The heat waves indicators are computed based on climatological normals, created with the \code{summarise_normal()} function and passed with the \code{normals_df} argument. Keys to join the normals data must be present (like id, year, and month)  and use the same names.

The following indicators are computed for each group.
\itemize{
\item{\code{count} Count of data points}
\item{\code{normal_mean} Climatological normal mean, from \code{normals_df} argument}
\item{\code{normal_p10} Climatological 10th percentile, from \code{normals_df} argument}
\item{\code{normal_p90} Climatological 90th percentile, from \code{normals_df} argument}
\item{\code{mean} Average}
\item{\code{median} Median}
\item{\code{sd} Standard deviation}
\item{\code{se} Standard error}
\item{\code{max} Maximum value}
\item{\code{min} Minimum value}
\item{\code{p10} 10th percentile}
\item{\code{p25} 25th percentile}
\item{\code{p75} 75th percentile}
\item{\code{p90} 90th percentile}
\item{\code{heat_waves_3d} Count of heat waves occurences, with 3 or more consecutive days with maximum temperature above the climatological normal value plus 5 celsius degrees}
\item{\code{heat_waves_5d} Count of heat waves occurences, with 5 or more consecutive days with maximum temperature above the climatological normal value plus 5 celsius degrees}
\item{\code{hot_days} Count of warm days, when the maximum temperature is above the normal 90th percentile}
\item{\code{t_25} Count of days with temperatures above or equal to 25 celsius degrees}
\item{\code{t_30} Count of days with temperatures above or equal to 30 celsius degrees}
\item{\code{t_35} Count of days with temperatures above or equal to 35 celsius degrees}
\item{\code{t_40} Count of days with temperatures above or equal to 40 celsius degrees}
}
}
\examples{
# Compute monthly normals
normals <- temp_max_data |>
  # Identify month
  dplyr::mutate(month = lubridate::month(date)) |>
  # Group by id variable and month
  dplyr::group_by(code_muni, month) |>
  summarise_normal(date_var = date, value_var = value, year_start = 1961, year_end = 1990) |>
  dplyr::ungroup()

# Compute indicators
temp_max_data |>
 # Identify year
 dplyr::mutate(year = lubridate::year(date)) |>
 # Identify month
 dplyr::mutate(month = lubridate::month(date)) |>
 # Group by id variable, year and month
 dplyr::group_by(code_muni, year, month) |>
 # Compute maximum temperature indicators
 summarise_temp_max(value_var = value, normals_df = normals) |>
 # Ungroup
 dplyr::ungroup()

}
