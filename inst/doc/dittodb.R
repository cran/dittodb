## ---- include = FALSE---------------------------------------------------------
library(testthat)
library(dittodb)

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

db_mock_paths("dittodb")

## ----setup db, include = FALSE, eval = FALSE----------------------------------
#  # setup the DB used in the rest of the vignette
#  
#  con <- dbConnect(
#    RMariaDB::MariaDB(),
#    dbname = "nycflights",
#    host = "127.0.0.1",
#    username = "travis",
#    password = ""
#  )
#  
#  nycflights13_create_sql(con, schema = "nycflights13")
#  
#  # record interactions
#  
#  start_db_capturing()
#  out <- mean_delays("day")
#  out <- mean_delays("month")
#  stop_db_capturing()

## ----mean_delays--------------------------------------------------------------
library(DBI)

mean_delays <- function(group_col) {
  con <- dbConnect(
    RMariaDB::MariaDB(),
    dbname = "nycflights"
  )
  on.exit(dbDisconnect(con))

  query <- glue::glue(
    "SELECT {group_col}, AVG(arr_delay) as mean_delay from nycflights13.flights ",
    "WHERE arr_delay > 0 GROUP BY {group_col}"
  )

  return(dbGetQuery(con, query))
}

## ----mean_delays_rpostgres, eval = FALSE--------------------------------------
#  library(DBI)
#  
#  mean_delays <- function(group_col) {
#    con <- dbConnect(
#      RPostgres::Postgres(),
#      dbname = "nycflights"
#    )
#    on.exit(dbDisconnect(con))
#  
#    query <- glue::glue(
#      "SELECT {group_col}, AVG(arr_delay) as mean_delay from nycflights13.flights ",
#      "WHERE arr_delay > 0 GROUP BY {group_col}"
#    )
#  
#    return(dbGetQuery(con, query))
#  }

## ----mean_delays_rsqlite, eval = FALSE----------------------------------------
#  library(DBI)
#  
#  mean_delays <- function(group_col) {
#    con <- dbConnect(
#      RSQLite::SQLite(),
#      dbname = "nycflights"
#    )
#    on.exit(dbDisconnect(con))
#  
#    query <- glue::glue(
#      "SELECT {group_col}, AVG(arr_delay) as mean_delay from nycflights13.flights ",
#      "WHERE arr_delay > 0 GROUP BY {group_col}"
#    )
#  
#    return(dbGetQuery(con, query))
#  }

## ----month, eval = FALSE------------------------------------------------------
#  mean_delays("month")

## ----cooking_show, echo = FALSE-----------------------------------------------
with_mock_db(mean_delays("month"))

## ----tests_1, eval = FALSE----------------------------------------------------
#  library(testthat)
#  
#  test_that("mean_delays()", {
#    out <- mean_delays("month")
#    expect_named(out, c("month", "mean_delay"))
#    expect_equal(dim(out), c(12, 2))
#  })

## ----recording, eval = FALSE--------------------------------------------------
#  start_db_capturing()
#  out <- mean_delays("month")
#  stop_db_capturing()

## ----with_mock_1--------------------------------------------------------------
with_mock_db(
  mean_delays("month")
)

## ----tests_2------------------------------------------------------------------
library(testthat)
library(dittodb)

with_mock_db(
  test_that("mean_delays()", {
    out <- mean_delays("month")
    expect_named(out, c("month", "mean_delay"))
    expect_equal(dim(out), c(12, 2))
  })
)

## ----recording_days, eval = FALSE---------------------------------------------
#  start_db_capturing()
#  out <- mean_delays("day")
#  stop_db_capturing()

## ----tests_day_2--------------------------------------------------------------
with_mock_db(
  test_that("mean_delays()", {
    out <- mean_delays("day")
    expect_named(out, c("day", "mean_delay"))
    expect_equal(dim(out), c(31, 2))
  })
)

## ----editing, eval = FALSE----------------------------------------------------
#  # read in the recorded fixture
#  df_fixt <- source("nycflights/SELECT-16d120.R", keep.source = FALSE)$value
#  
#  # filter out anything after february and all days after the 9th of the month
#  df_fixt <- dplyr::filter(df_fixt, month <= 2 & day < 10)
#  
#  # save the fixture for use in tests
#  dput(df_fixt, file = "nycflights/SELECT-16d120.R", control = c("all", "hexNumeric"))

