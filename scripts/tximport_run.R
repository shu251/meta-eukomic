# Tximport

library(tximport)

# Load tx2gene file made in "compile_output_metat.R"
load(file = "/home/skhu/meta-eukomic/output-files/txi_key_annot.RData", verbose = TRUE)


## Typically we have a series of samples. Our example only has one.
## To do this, follow these instructions:

# (1) get list of all files
# files <- Sys.glob("$SCRATCH/salmon/*_quant/quant.sf")
# files

## (1.1) Parse sample list for quant.sf files:
# Create a sample list dataframe
# sample_merged <- data.frame("Files"=files) %>%
#   tidyr::separate(Files,sep="salmon/",into=c("STEM","Name")) %>%
#   tidyr::separate(Name,sep="_quant",into=c("SampleName_rep","EXCESS")) %>%
#   dplyr::mutate(Replicate = case_when(
#     stringr::str_detect(SampleName_rep, "_1$") ~ "REP1",
#     stringr::str_detect(SampleName_rep, "_2$") ~ "REP2"
#   )) %>% 
#   dplyr::mutate(SampleName = 
#                   stringr::str_remove(SampleName_rep, "_[:digit:]$")) %>% 
#   dplyr::left_join(sample_list, by = c("SampleName" = "SITE_NUM_FIELDYR_VENT_EXP_SAMPLEID")) %>% 
#   tidyr::unite("SAMPLE_REP", SampleName, Replicate, sep = "_", remove = FALSE) %>% 
#   mutate(TYPE_BIN = case_when(
#     str_detect(VENT, "Plume|plume|IntlDist") ~ "Non-vent",
#     str_detect(VENT, "BSW|Background|Transit") ~ "Non-vent",
#     TRUE ~ "Vent")) %>% 
#   mutate(TYPE = case_when(
#     str_detect(VENT, "Plume|plume|IntlDist") ~ "Plume",
#     str_detect(VENT, "BSW|Background|Transit") ~ "Background",
#     TRUE ~ "Vent"))
# 
# # Make sure these two lines are consistent when run witn tximport
# sample_merged$SAMPLE_REP
# names(files) <- sample_merged$SAMPLE_REP

## (1.2) For our example we only have the 1 count file.
files <- Sys.glob("/scratch/group/hu-lab/meta-eukomics/salmon-quant/quant/quant.sf")
files
sample_merged <- data.frame(rownametmp = "HS039_S90", SAMPLENAME = "HS039_S90", ORIGIN = "Hu", FILE = files) %>% 
  column_to_rownames(var = "rownametmp")
sample_merged
# Make sure the rownames of "sample_merged" will match the column names of my output txi_metat list elements

# Run tximport step
txi_metat <- tximport::tximport(files = "/scratch/group/hu-lab/meta-eukomics/salmon-quant/quant/quant.sf", type = "salmon", tx2gene = tx_gene_KEY)

# Check
rownames(sample_merged)
glimpse(sample_merged)

colnames(txi_metat$counts) <- rownames(sample_merged)
colnames(txi_metat$abundance) <- rownames(sample_merged)
colnames(txi_metat$length) <- rownames(sample_merged)

cat("\nCheck colnames for txi are correct\n")
colnames(txi_metat$counts)

cat("\nAnd they should match these rownames:\n")
rownames(sample_merged)

save(txi_metat, sample_merged, file = "/scratch/group/hu-lab/meta-eukomics/annotation/txi_objects.RData")
