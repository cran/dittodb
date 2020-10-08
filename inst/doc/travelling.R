## ----recording, include = FALSE, eval = FALSE---------------------------------
#  library(dplyr)
#  library(dbplyr)
#  
#  con_psql <- DBI::dbConnect(
#    RPostgres::Postgres(),
#    dbname = "nycflights",
#    host = "127.0.0.1",
#    user = getOption("dittodb.test.user"),
#    password = getOption("dittodb.test.pw")
#  )
#  DBI::dbSendStatement(con_psql, "CREATE DATABASE travelling")
#  DBI::dbDisconnect(con_psql)
#  
#  
#  con_psql <- DBI::dbConnect(
#    RPostgres::Postgres(),
#    dbname = "travelling",
#    host = "127.0.0.1",
#    user = getOption("dittodb.test.user"),
#    password = getOption("dittodb.test.pw")
#  )
#  nycflights13_create_sql(con_psql)
#  DBI::dbDisconnect(con_psql)
#  
#  start_db_capturing(path = "./")
#  con_psql <- DBI::dbConnect(
#    RPostgres::Postgres(),
#    dbname = "travelling",
#    host = "127.0.0.1",
#    user = getOption("dittodb.test.user"),
#    password = getOption("dittodb.test.pw")
#  )
#  
#  tbl(con_psql, "flights") %>%
#    filter(!is.na(tailnum)) %>%
#    filter(arr_delay >= 180) %>%
#    select(tailnum) %>%
#    distinct() %>%
#    collect()
#  
#  dbDisconnect(con_psql)
#  stop_db_capturing()

## ----setup, include=FALSE-----------------------------------------------------
library(dittodb)

# set the mockPaths for this vignette
db_mock_paths("travelling")

knitr::opts_chunk$set(eval = TRUE, message = FALSE, warning = FALSE)

## ---- error=TRUE, eval=FALSE--------------------------------------------------
#  library(dplyr)
#  library(dbplyr)
#  
#  con_psql <- DBI::dbConnect(
#    RPostgres::Postgres(),
#    dbname = "travelling",
#    host = "127.0.0.1",
#    user = "m.ciccone"
#  )
#  
#  tbl(con_psql, "flights") %>%
#    filter(!is.na(tailnum)) %>%
#    filter(arr_delay >= 180) %>%
#    select(tailnum) %>%
#    distinct()

## ---- eval=FALSE--------------------------------------------------------------
#  library(dittodb)
#  
#  start_db_capturing()
#  
#  con_psql <- DBI::dbConnect(
#      RPostgres::Postgres(),
#      dbname = "dittodb",
#      host = "postgres.server",
#      user = "m.ciccone"
#    )
#  
#  flights_delayed <- tbl(con_psql, "flights") %>%
#    filter(!is.na(tailnum)) %>%
#    filter(arr_delay >= 180) %>%
#    select(tailnum) %>%
#    distinct() %>%
#    collect()
#  
#  flights_delayed
#  
#  dbDisconnect(con_psql)
#  
#  stop_db_capturing()

## ----cooking show trick, echo=FALSE-------------------------------------------
library(dplyr)
library(dbplyr)

# this is the same code that is echoed below, but used here to show output that 
# the chunk above would produce if it were able to connect
with_mock_db({
  con_psql <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = "travelling",
    host = "127.0.0.1",
    user = "m.ciccone"
  )

  flights_delayed_from_mock <- tbl(con_psql, "flights") %>%
    filter(!is.na(tailnum)) %>%
    filter(arr_delay >= 180) %>%
    select(tailnum) %>%
    distinct() %>% 
    collect()
  
  flights_delayed_from_mock
})

# `dbDisconnect` returns TRUE
TRUE

## -----------------------------------------------------------------------------
with_mock_db({
  con_psql <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = "travelling",
    host = "127.0.0.1",
    user = "m.ciccone"
  )

  flights_delayed_from_mock <- tbl(con_psql, "flights") %>%
    filter(!is.na(tailnum)) %>%
    filter(arr_delay >= 180) %>% 
    select(tailnum) %>%
    distinct() %>%
    collect()
  
  flights_delayed_from_mock
})

