# Get tables for intercalibration effort
library(tidyverse)
library(tximport)


# Load txi objects
load(file = "/scratch/group/hu-lab/meta-eukomics/annotation/txi_objects.RData", verbose = TRUE)

# Make counts from matrices
counts_metat_all <- makeCountsFromAbundance(
  as.matrix(txi_metat$counts),
  as.matrix(txi_metat$abundance),
  as.matrix(txi_metat$length),
  countsFromAbundance = c("scaledTPM", "lengthScaledTPM"))


# Create dataframe
counts_metat_df <- as.data.frame(counts_metat_all)
glimpse(counts_metat_df)

# Import annotations
load("/scratch/group/hu-lab/meta-eukomics/annotation/metat_annot_info.RData", verbose = TRUE)

## Join
# sseqid
counts_metat_df_annot <- counts_metat_df %>% 
  rownames_to_column(var = "sseqid") %>% 
  left_join(metat_annot_info)

glimpse(counts_metat_df_annot)

save(counts_metat_df_annot, file = "/scratch/group/hu-lab/meta-eukomics/counts_metat_df_annot.RData")
