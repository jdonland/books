suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(stringr)
})

"As an alternative to a social cataloguing website like Goodreads, this 
document shows some of the books I'm currently reading along with those I've 
finished recently.\n" -> intro

read_csv("books.csv", show_col_types = F) |>
  select(status, title, link) |>
  filter(status != "read", status != "to-read") |>
  mutate(status = str_c("\n## ", str_to_title(status), "\n"),
         title = str_c(" - [", title, "](", link, ")"),
         .keep = "used") |>
  group_by(status) |>
  summarize(content = str_c(title, collapse = "\n")) |>
  mutate(content = str_c(status, "\n", content, "\n")) |>
  pull(content) |>
  str_c(collapse = "") |>
  c(intro) |>
  rev() |>
  paste(collapse = "") |>
  write_file("README.md")
