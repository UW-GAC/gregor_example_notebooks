# references:
# https://uw-gac.github.io/primed_example_notebooks/terra_workspace.nb.html
# https://bioconductor.org/packages/release/bioc/vignettes/AnVIL/inst/doc/Introduction.html#using-av-to-work-with-anvil-tables-and-data
#
# goals:
# - load .tsv files from workspace to tibbles
# - modify the tibbles and make data tables from them in workspace
# - attempt to do the same in a different workspace
# - if possible, load all example files in example workspaces

# get the latest version of AnVIL from github
# remotes::install_github("Bioconductor/AnVIL")

library(AnVIL)
library(tidyverse)

project <- avworkspace_namespace()
workspace <- avworkspace_name()
bucket <- avbucket()

# list files in workspace (bucket), then copy to compute node
#system(paste0("gsutil ls ",bucket), intern=TRUE)
gsutil_ls(bucket)

## participant table
participant_file_name <- "demo notebook RC 1 GRU - participant.tsv"
participant_file_path <- file.path(bucket, participant_file_name)

gsutil_cp(participant_file_path, "./")
participant_table <- read_tsv(participant_file_name)

# rename the id column and load the tibble into a workspace data table
modified_participant_table <- 
  participant_table %>%
  rename("entity:participant_id" = participant_id) %>%
  avtable_import()

## biosample table
biosample_file_name <- "demo notebook RC 1 GRU - biosample.tsv"
biosample_file_path <- file.path(bucket, biosample_file_name)

gsutil_cp(biosample_file_path, "./")
biosample_table <- read_tsv(biosample_file_name)

# rename the id column and load the tibble into a workspace data table
modified_biosample_table <- 
  biosample_table %>%
  rename("entity:biosample_id" = biosample_id) %>%
  avtable_import()

## phenotype table
phenotype_file_name <- "demo notebook RC 1 GRU - phenotype.tsv"
phenotype_file_path <- file.path(bucket, phenotype_file_name)

gsutil_cp(phenotype_file_path, "./")
phenotype_table <- read_tsv(phenotype_file_name)

# rename the id column and load the tibble into a workspace data table
# NOTE: this isn't really how we'd want to make phenotype row IDs...
modified_phenotypoe_table <- 
  phenotype_table %>%
  mutate("entity:phenotype_id" = 
           paste0(participant_id, seq(1:length(phenotype_table))), 
         .before = "participant_id") %>%
  avtable_import()

## experiment table
experiment_file_name <- "demo notebook RC 1 GRU - experiment.tsv"
experiment_file_path <- file.path(bucket, experiment_file_name)

gsutil_cp(experiment_file_path, "./")
experiment_table <- read_tsv(experiment_file_name)

# rename the id column and load the tibble into a workspace data table
modified_experiment_table <- 
  experiment_table %>%
  rename("entity:experiment_id" = experiment_id) %>%
  avtable_import()

## aligned_short_reads table
aligned_short_reads_file_name <- "demo notebook RC 1 GRU - aligned_short_reads.tsv"
aligned_short_reads_file_path <- file.path(bucket, aligned_short_reads_file_name)

gsutil_cp(aligned_short_reads_file_path, "./")
aligned_short_reads_table <- read_tsv(aligned_short_reads_file_name)

# rename the id column and load the tibble into a workspace data table
modified_aligned_short_reads_table <- 
  aligned_short_reads_table %>%
  mutate("entity:aligned_short_reads_id" = "a_made_up_md5_0123", .before = "experiment_id") %>%
  avtable_import()

# Copy this script into the bucket
gsutil_cp("./data_load.R", bucket)


# can I do the same thing for a different bucket from this workspace?
project <- avworkspace_namespace()
workspace <- "GREGoR_DCC_RC2_GRU_demo"
bucket <- avbucket(project, name = workspace)

gsutil_ls(bucket)

## participant table
participant_file_name <- "demo notebook RC 2 GRU - participant.tsv"
participant_file_path <- file.path(bucket, participant_file_name)

gsutil_cp(participant_file_path, "./")
participant_table <- read_tsv(participant_file_name)

# rename the id column and load the tibble into a workspace data table
modified_participant_table <- 
  participant_table %>%
  rename("entity:participant_id" = participant_id) %>%
  avtable_import(namespace = project, name = workspace)

# checking at https://app.terra.bio/#workspaces/GREGoR-ben/GREGoR_DCC_RC2_GRU_demo/data - it worked!

## biosample table
biosample_file_name <- "demo notebook RC 2 GRU - biosample.tsv"
biosample_file_path <- file.path(bucket, biosample_file_name)

gsutil_cp(biosample_file_path, "./")
biosample_table <- read_tsv(biosample_file_name)

# rename the id column and load the tibble into a workspace data table
modified_biosample_table <- 
  biosample_table %>%
  rename("entity:biosample_id" = biosample_id) %>%
  avtable_import(namespace = project, name = workspace)

## phenotype table
phenotype_file_name <- "demo notebook RC 2 GRU - phenotype.tsv"
phenotype_file_path <- file.path(bucket, phenotype_file_name)

gsutil_cp(phenotype_file_path, "./")
phenotype_table <- read_tsv(phenotype_file_name)

# rename the id column and load the tibble into a workspace data table
# NOTE: this isn't really how we'd want to make phenotype row IDs...
modified_phenotype_table <- 
  phenotype_table %>%
  mutate("entity:phenotype_id" = 
           paste0(participant_id, seq(1:length(phenotype_table))), 
         .before = "participant_id") %>%
  avtable_import(namespace = project, name = workspace)

## experiment table
experiment_file_name <- "demo notebook RC 2 GRU - experiment.tsv"
experiment_file_path <- file.path(bucket, experiment_file_name)

gsutil_cp(experiment_file_path, "./")
experiment_table <- read_tsv(experiment_file_name)

# rename the id column and load the tibble into a workspace data table
modified_experiment_table <- 
  experiment_table %>%
  rename("entity:experiment_id" = experiment_id) %>%
  avtable_import(namespace = project, name = workspace)

## aligned_short_reads table
aligned_short_reads_file_name <- "demo notebook RC 2 GRU - aligned_short_reads.tsv"
aligned_short_reads_file_path <- file.path(bucket, aligned_short_reads_file_name)

gsutil_cp(aligned_short_reads_file_path, "./")
aligned_short_reads_table <- read_tsv(aligned_short_reads_file_name)

# rename the id column and load the tibble into a workspace data table
modified_aligned_short_reads_table <- 
  aligned_short_reads_table %>%
  mutate("entity:aligned_short_reads_id" = "a_made_up_md5_0456", .before = "experiment_id") %>%
  avtable_import(namespace = project, name = workspace)

# Copy this script into the bucket
gsutil_cp("./data_load.R", bucket)


## do again for HMB data from RC 1:
# can I do the same thing for a different bucket from this workspace?
project <- avworkspace_namespace()
workspace <- "GREGoR_DCC_RC1_HMB_demo"
bucket <- avbucket(project, name = workspace)

gsutil_ls(bucket)

## participant table
participant_file_name <- "demo notebook RC 1 HMB - participant.tsv"
participant_file_path <- file.path(bucket, participant_file_name)

gsutil_cp(participant_file_path, "./")
participant_table <- read_tsv(participant_file_name)

# rename the id column and load the tibble into a workspace data table
modified_participant_table <- 
  participant_table %>%
  rename("entity:participant_id" = participant_id) %>%
  avtable_import(namespace = project, name = workspace)

# checking at https://app.terra.bio/#workspaces/GREGoR-ben/GREGoR_DCC_RC2_GRU_demo/data - it worked!

## biosample table
biosample_file_name <- "demo notebook RC 1 HMB - biosample.tsv"
biosample_file_path <- file.path(bucket, biosample_file_name)

gsutil_cp(biosample_file_path, "./")
biosample_table <- read_tsv(biosample_file_name)

# rename the id column and load the tibble into a workspace data table
modified_biosample_table <- 
  biosample_table %>%
  rename("entity:biosample_id" = biosample_id) %>%
  avtable_import(namespace = project, name = workspace)

## phenotype table
phenotype_file_name <- "demo notebook RC 1 HMB - phenotype.tsv"
phenotype_file_path <- file.path(bucket, phenotype_file_name)

gsutil_cp(phenotype_file_path, "./")
phenotype_table <- read_tsv(phenotype_file_name)

# rename the id column and load the tibble into a workspace data table
# NOTE: this isn't really how we'd want to make phenotype row IDs...
modified_phenotype_table <- 
  phenotype_table %>%
  mutate("entity:phenotype_id" = 
           paste0(participant_id, seq(1:length(phenotype_table))), 
         .before = "participant_id") %>%
  avtable_import(namespace = project, name = workspace)

## experiment table
experiment_file_name <- "demo notebook RC 1 HMB - experiment.tsv"
experiment_file_path <- file.path(bucket, experiment_file_name)

gsutil_cp(experiment_file_path, "./")
experiment_table <- read_tsv(experiment_file_name)

# rename the id column and load the tibble into a workspace data table
modified_experiment_table <- 
  experiment_table %>%
  rename("entity:experiment_id" = experiment_id) %>%
  avtable_import(namespace = project, name = workspace)

## aligned_short_reads table
aligned_short_reads_file_name <- "demo notebook RC 1 HMB - aligned_short_reads.tsv"
aligned_short_reads_file_path <- file.path(bucket, aligned_short_reads_file_name)

gsutil_cp(aligned_short_reads_file_path, "./")
aligned_short_reads_table <- read_tsv(aligned_short_reads_file_name)

# rename the id column and load the tibble into a workspace data table
modified_aligned_short_reads_table <- 
  aligned_short_reads_table %>%
  mutate("entity:aligned_short_reads_id" = "a_made_up_md5_0789", .before = "experiment_id") %>%
  avtable_import(namespace = project, name = workspace)

# Copy this script into the bucket
gsutil_cp("./data_load.R", bucket)

## do again for HMB data from RC 2:
# can I do the same thing for a different bucket from this workspace?
project <- avworkspace_namespace()
workspace <- "GREGoR_DCC_RC2_HMB_demo"
bucket <- avbucket(project, name = workspace)

gsutil_ls(bucket)

## participant table
participant_file_name <- "demo notebook RC 2 HMB - participant.tsv"
participant_file_path <- file.path(bucket, participant_file_name)

gsutil_cp(participant_file_path, "./")
participant_table <- read_tsv(participant_file_name)

# rename the id column and load the tibble into a workspace data table
modified_participant_table <- 
  participant_table %>%
  rename("entity:participant_id" = participant_id) %>%
  avtable_import(namespace = project, name = workspace)

# checking at https://app.terra.bio/#workspaces/GREGoR-ben/GREGoR_DCC_RC2_GRU_demo/data - it worked!

## biosample table
biosample_file_name <- "demo notebook RC 2 HMB - biosample.tsv"
biosample_file_path <- file.path(bucket, biosample_file_name)

gsutil_cp(biosample_file_path, "./")
biosample_table <- read_tsv(biosample_file_name)

# rename the id column and load the tibble into a workspace data table
modified_biosample_table <- 
  biosample_table %>%
  rename("entity:biosample_id" = biosample_id) %>%
  avtable_import(namespace = project, name = workspace)

## phenotype table
phenotype_file_name <- "demo notebook RC 2 HMB - phenotype.tsv"
phenotype_file_path <- file.path(bucket, phenotype_file_name)

gsutil_cp(phenotype_file_path, "./")
phenotype_table <- read_tsv(phenotype_file_name)

# rename the id column and load the tibble into a workspace data table
# NOTE: this isn't really how we'd want to make phenotype row IDs...
modified_phenotype_table <- 
  phenotype_table %>%
  mutate("entity:phenotype_id" = 
           paste0(participant_id, seq(1:length(phenotype_table))), 
         .before = "participant_id") %>%
  avtable_import(namespace = project, name = workspace)

## experiment table
experiment_file_name <- "demo notebook RC 2 HMB - experiment.tsv"
experiment_file_path <- file.path(bucket, experiment_file_name)

gsutil_cp(experiment_file_path, "./")
experiment_table <- read_tsv(experiment_file_name)

# rename the id column and load the tibble into a workspace data table
modified_experiment_table <- 
  experiment_table %>%
  rename("entity:experiment_id" = experiment_id) %>%
  avtable_import(namespace = project, name = workspace)

## aligned_short_reads table
aligned_short_reads_file_name <- "demo notebook RC 2 HMB - aligned_short_reads.tsv"
aligned_short_reads_file_path <- file.path(bucket, aligned_short_reads_file_name)

gsutil_cp(aligned_short_reads_file_path, "./")
aligned_short_reads_table <- read_tsv(aligned_short_reads_file_name)

# rename the id column and load the tibble into a workspace data table
modified_aligned_short_reads_table <- 
  aligned_short_reads_table %>%
  mutate("entity:aligned_short_reads_id" = "a_made_up_md5_1011", .before = "experiment_id") %>%
  avtable_import(namespace = project, name = workspace)

# Copy this script into the bucket
gsutil_cp("./data_load.R", bucket)

