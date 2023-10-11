suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(stringr)
})

"As an alternative to a social cataloguing website like Goodreads, this 
document shows some of the books I'm currently reading along with those I've 
finished recently.\n" -> intro

read_csv("books.csv", show_col_types = F) |>
  filter(status != "read", status != "to-read") |>
  arrange(status, "author/editor/translator", title) |>
  mutate(status = paste("\n## ", str_to_title(status), "\n"),
         title = paste0(" - ", title)) |>
  group_by(status) |>
  summarize(content = paste0(title, collapse = "\n")) |>
  mutate(content = paste(status, "\n", content, "\n")) |>
  pull(content) |>
  paste0(collapse = "") |>
  c(intro) |>
  rev() |>
  paste(collapse = "") |>
  write_file("README.md")
