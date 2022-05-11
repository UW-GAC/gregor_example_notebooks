# goals
#
# make consortium "index workspace" that has a set of tables for each consent
# group that combines data from RC upload workspaces
#
# target workspace is
# https://app.terra.bio/#workspaces/GREGoR-ben/GREGoR_DCC_consortium_index_demo

library(AnVIL)
library(tidyverse)

# define the workspaces we're working with
RC_1_HMB_project <- avworkspace_namespace()
RC_1_HMB_workspace <- "GREGoR_DCC_RC1_HMB_demo"
RC_1_HMB_bucket <- avbucket(project, name = workspace)

RC_2_HMB_project <- avworkspace_namespace()
RC_2_HMB_workspace <- "GREGoR_DCC_RC2_HMB_demo"
RC_2_HMB_bucket <- avbucket(project, name = workspace)

RC_1_GRU_project <- avworkspace_namespace()
RC_1_GRU_workspace <- "GREGoR_DCC_RC1_GRU_demo"
RC_1_GRU_bucket <- avbucket(project, name = workspace)

RC_2_GRU_project <- avworkspace_namespace()
RC_2_GRU_workspace <- "GREGoR_DCC_RC2_GRU_demo"
RC_2_GRU_bucket <- avbucket(project, name = workspace)

release_GRU_project <- avworkspace_namespace()
release_GRU_workspace <- "GREGoR_DCC_GRU_release_index_demo"
release_GRU_bucket <- avbucket(project, name = workspace)

release_HMB_project <- avworkspace_namespace()
release_HMB_workspace <- "GREGoR_DCC_HMB_release_index_demo"
release_HMB_bucket <- avbucket(project, name = workspace)

consortium_index_project <- avworkspace_namespace()
consortium_index_workspace <- "GREGoR_DCC_consortium_index_demo"
consortium_index_bucket <- avbucket(project, name = workspace)

# first, combine HMB data tables from GREGoR_DCC_RC1_HMB_demo and from GREGoR_DCC_RC2_HMB_demo

## participant tables
# load data from source workspace data tables to R data frames
RC_1_HMB_participant_table <- 
  avtable("participant", namespace = RC_1_HMB_project, 
          name = RC_1_HMB_workspace)

RC_2_HMB_participant_table <- 
  avtable("participant", namespace = RC_2_HMB_project, 
          name = RC_2_HMB_workspace)

combined_participant_table <- 
  bind_rows(RC_1_HMB_participant_table, RC_2_HMB_participant_table) %>%
  mutate("entity:HMB_participant_id" = participant_id,
         .before = "participant_id")

avtable_import(combined_participant_table, namespace = consortium_index_project, 
               name = consortium_index_workspace)

# also put this combined data table in the HMB "release" index workspace
avtable_import(combined_participant_table, namespace = release_HMB_project, 
               name = release_HMB_workspace)


## biosample tables
# load data from source workspace data tables to R data frames
RC_1_HMB_biosample_table <- 
  avtable("biosample", namespace = RC_1_HMB_project, 
          name = RC_1_HMB_workspace)

RC_2_HMB_biosample_table <- 
  avtable("biosample", namespace = RC_2_HMB_project, 
          name = RC_2_HMB_workspace)

combined_biosample_table <- 
  bind_rows(RC_1_HMB_biosample_table, RC_2_HMB_biosample_table) %>%
  mutate("entity:HMB_biosample_id" = biosample_id,
         .before = "biosample_id")

avtable_import(combined_biosample_table, namespace = consortium_index_project, 
               name = consortium_index_workspace)

# also put this combined data table in the HMB "release" index workspace
avtable_import(combined_biosample_table, namespace = release_HMB_project, 
               name = release_HMB_workspace)

## experiment tables
# load data from source workspace data tables to R data frames
RC_1_HMB_experiment_table <- 
  avtable("experiment", namespace = RC_1_HMB_project, 
          name = RC_1_HMB_workspace)

RC_2_HMB_experiment_table <- 
  avtable("experiment", namespace = RC_2_HMB_project, 
          name = RC_2_HMB_workspace)

combined_experiment_table <- 
  bind_rows(RC_1_HMB_experiment_table, RC_2_HMB_experiment_table) %>%
  mutate("entity:HMB_experiment_id" = experiment_id,
         .before = "experiment_id")

avtable_import(combined_experiment_table, namespace = consortium_index_project, 
               name = consortium_index_workspace)

# also put this combined data table in the HMB "release" index workspace
avtable_import(combined_experiment_table, namespace = release_HMB_project, 
               name = release_HMB_workspace)

## phenotype tables
# load data from source workspace data tables to R data frames
RC_1_HMB_phenotype_table <- 
  avtable("phenotype", namespace = RC_1_HMB_project, 
          name = RC_1_HMB_workspace)

RC_2_HMB_phenotype_table <- 
  avtable("phenotype", namespace = RC_2_HMB_project, 
          name = RC_2_HMB_workspace)

combined_phenotype_table <- 
  bind_rows(RC_1_HMB_phenotype_table, RC_2_HMB_phenotype_table) %>%
  mutate("entity:HMB_phenotype_id" = phenotype_id,
         .before = "phenotype_id")

avtable_import(combined_phenotype_table, namespace = consortium_index_project, 
               name = consortium_index_workspace)

# also put this combined data table in the HMB "release" index workspace
avtable_import(combined_phenotype_table, namespace = release_HMB_project, 
               name = release_HMB_workspace)

## aligned_short_reads tables
# load data from source workspace data tables to R data frames
RC_1_HMB_aligned_short_reads_table <- 
  avtable("aligned_short_reads", namespace = RC_1_HMB_project, 
          name = RC_1_HMB_workspace)

RC_2_HMB_aligned_short_reads_table <- 
  avtable("aligned_short_reads", namespace = RC_2_HMB_project, 
          name = RC_2_HMB_workspace)

combined_aligned_short_reads_table <- 
  bind_rows(RC_1_HMB_aligned_short_reads_table, RC_2_HMB_aligned_short_reads_table) %>%
  mutate("entity:HMB_aligned_short_reads_id" = aligned_short_reads_id,
         .before = "aligned_short_reads_id")

avtable_import(combined_aligned_short_reads_table, namespace = consortium_index_project, 
               name = consortium_index_workspace)

# also put this combined data table in the HMB "release" index workspace
avtable_import(combined_aligned_short_reads_table, namespace = release_HMB_project, 
               name = release_HMB_workspace)

# next, combine GRU data tables from GREGoR_DCC_RC1_GRU_demo and from GREGoR_DCC_RC2_GRU_demo

## participant tables
# load data from source workspace data tables to R data frames
RC_1_GRU_participant_table <- 
  avtable("participant", namespace = RC_1_GRU_project, 
          name = RC_1_GRU_workspace)

RC_2_GRU_participant_table <- 
  avtable("participant", namespace = RC_2_GRU_project, 
          name = RC_2_GRU_workspace)

combined_participant_table <- 
  bind_rows(RC_1_GRU_participant_table, RC_2_GRU_participant_table) %>%
  mutate("entity:GRU_participant_id" = participant_id,
         .before = "participant_id")

avtable_import(combined_participant_table, namespace = consortium_index_project, 
               name = consortium_index_workspace)

# also put this combined data table in the GRU "release" index workspace
avtable_import(combined_participant_table, namespace = release_GRU_project, 
               name = release_GRU_workspace)


## biosample tables
# load data from source workspace data tables to R data frames
RC_1_GRU_biosample_table <- 
  avtable("biosample", namespace = RC_1_GRU_project, 
          name = RC_1_GRU_workspace)

RC_2_GRU_biosample_table <- 
  avtable("biosample", namespace = RC_2_GRU_project, 
          name = RC_2_GRU_workspace)

combined_biosample_table <- 
  bind_rows(RC_1_GRU_biosample_table, RC_2_GRU_biosample_table) %>%
  mutate("entity:GRU_biosample_id" = biosample_id,
         .before = "biosample_id")

avtable_import(combined_biosample_table, namespace = consortium_index_project, 
               name = consortium_index_workspace)

# also put this combined data table in the GRU "release" index workspace
avtable_import(combined_biosample_table, namespace = release_GRU_project, 
               name = release_GRU_workspace)

## experiment tables
# load data from source workspace data tables to R data frames
RC_1_GRU_experiment_table <- 
  avtable("experiment", namespace = RC_1_GRU_project, 
          name = RC_1_GRU_workspace)

RC_2_GRU_experiment_table <- 
  avtable("experiment", namespace = RC_2_GRU_project, 
          name = RC_2_GRU_workspace)

combined_experiment_table <- 
  bind_rows(RC_1_GRU_experiment_table, RC_2_GRU_experiment_table) %>%
  mutate("entity:GRU_experiment_id" = experiment_id,
         .before = "experiment_id")

avtable_import(combined_experiment_table, namespace = consortium_index_project, 
               name = consortium_index_workspace)

# also put this combined data table in the GRU "release" index workspace
avtable_import(combined_experiment_table, namespace = release_GRU_project, 
               name = release_GRU_workspace)

## phenotype tables
# load data from source workspace data tables to R data frames
RC_1_GRU_phenotype_table <- 
  avtable("phenotype", namespace = RC_1_GRU_project, 
          name = RC_1_GRU_workspace)

RC_2_GRU_phenotype_table <- 
  avtable("phenotype", namespace = RC_2_GRU_project, 
          name = RC_2_GRU_workspace)

combined_phenotype_table <- 
  bind_rows(RC_1_GRU_phenotype_table, RC_2_GRU_phenotype_table) %>%
  mutate("entity:GRU_phenotype_id" = phenotype_id,
         .before = "phenotype_id")

avtable_import(combined_phenotype_table, namespace = consortium_index_project, 
               name = consortium_index_workspace)

# also put this combined data table in the GRU "release" index workspace
avtable_import(combined_phenotype_table, namespace = release_GRU_project, 
               name = release_GRU_workspace)

## aligned_short_reads tables
# load data from source workspace data tables to R data frames
RC_1_GRU_aligned_short_reads_table <- 
  avtable("aligned_short_reads", namespace = RC_1_GRU_project, 
          name = RC_1_GRU_workspace)

RC_2_GRU_aligned_short_reads_table <- 
  avtable("aligned_short_reads", namespace = RC_2_GRU_project, 
          name = RC_2_GRU_workspace)

combined_aligned_short_reads_table <- 
  bind_rows(RC_1_GRU_aligned_short_reads_table, RC_2_GRU_aligned_short_reads_table) %>%
  mutate("entity:GRU_aligned_short_reads_id" = aligned_short_reads_id,
         .before = "aligned_short_reads_id")

avtable_import(combined_aligned_short_reads_table, namespace = consortium_index_project, 
               name = consortium_index_workspace)

# also put this combined data table in the GRU "release" index workspace
avtable_import(combined_aligned_short_reads_table, namespace = release_GRU_project, 
               name = release_GRU_workspace)

# Copy this script into current bucket
bucket <- avbucket()
gsutil_cp("./make_index_workspaces.R", bucket)
