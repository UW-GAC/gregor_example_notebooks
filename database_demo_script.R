# references:
# https://uw-gac.github.io/primed_example_notebooks/terra_workspace.nb.html
# https://bioconductor.org/packages/release/bioc/vignettes/AnVIL/inst/doc/Introduction.html#using-av-to-work-with-anvil-tables-and-data
#
# goals:
# - make 2 .tsv files in workspace
# - make data tables from .tsv files in workspace
# - load data from data tables to R data frames
# - load data from data frames to SQLite databse
# - do a SQL join/query on the database

# get the latest version of AnVIL from github
# remotes::install_github("Bioconductor/AnVIL")
# install.packages(RSQLite)

library(AnVIL)
library(tidyverse)

# early question: I can save files to the current R working directory. How do I
# copy them to the workspace Files folder?
# see here: https://support.terra.bio/hc/en-us/articles/360027300571-How-and-why-to-save-data-generated-in-a-notebook-to-workspace-storage
project <- Sys.getenv('WORKSPACE_NAMESPACE')
workspace <- Sys.getenv('WORKSPACE_NAME')
bucket <- Sys.getenv('WORKSPACE_BUCKET')

# Copy all files generated in the notebook into the bucket
#system(paste0("gsutil cp ./* ",bucket),intern=TRUE)

# Copy this script into the bucket
system(paste0("gsutil cp ./demo_script.R ",bucket),intern=TRUE)

# Run list command to see if file is in the bucket
system(paste0("gsutil ls ",bucket),intern=TRUE)

# first, make some toy data frames and save as .tsv files.
# I'll just use examples from 
# https://www.datasciencemadesimple.com/join-in-r-merge-in-r/

tibble_1 <- tibble(
  CustomerId = c(1:6),
  Product = c("Oven","Television","Mobile","WashingMachine","Lightings","Ipad")
)

tibble_2 <- tibble(
  CustomerId = c(2, 4, 6, 7, 8),
  State = c("California","Newyork","Santiago","Texas","Indiana")
)

# note that an AnVIL "data table load file" has particular requirements
# (see https://support.terra.bio/hc/en-us/articles/360047102512#h_01EFEZK3MD9RJ2P09P84TDYJ1A)
# - the first column must be be the ID, and must named entity:your-entity-name_id

tibble_1 <- 
  tibble_1 %>% 
  mutate("entity:table1_id" = CustomerId,
         .before = CustomerId)
tibble_2 <- 
  tibble_2 %>% 
  mutate("entity:table2_id" = CustomerId,
         .before = CustomerId)

write_tsv(tibble_1, "table_1.tsv")
write_tsv(tibble_2, "table_2.tsv")

# Copy the .tsv files into the workspace storage bucket
system(paste0("gsutil cp ./*.tsv ",bucket),intern=TRUE)


# next, I want to make data tables in the workspace from these .tsv files
rm(tibble_1, tibble_2)

read_tsv("table_1.tsv") %>%
  avtable_import()

read_tsv("table_2.tsv") %>%
  avtable_import()

# check if the data tables are in the workspace
avtables()

# also confirmed by looking at AnVIL workspace web GUI

# next, load data from data tables to R data frames

table_1 <- avtable("table1")
table_2 <- avtable("table2")

# next, load data from data frames to SQLite databse
# I'll base this on examples from the dbplyr vignette:
# https://dbplyr.tidyverse.org/
con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
copy_to(con, table_1)
copy_to(con, table_2)

# finally, do a SQL join/query on the database
table_1_db <- tbl(con, "table_1")
table_2_db <- tbl(con, "table_2")

# Left Join using inner_join function 
table_1_db %>% inner_join(table_2_db, by="CustomerId")

# and that demonstrates some essential functionality for working with data frames, .tsv files, AnVIL data tables, and databses.

# Copy this script into the bucket
system(paste0("gsutil cp ./demo_script.R ",bucket),intern=TRUE)
