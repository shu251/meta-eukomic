# Compile outputs from annotation

library(tidyverse)

annot_marf <- read_delim("/scratch/group/hu-lab/meta-eukomics/annotation/meta-eukomic_marferret_07082024.txt", col_names = FALSE)

# This is the flag used in the DIAMOND run: --outfmt 6 qseqid sseqid sallseqid evalue bitscore qlen slen

colnames(annot_marf) <- c("qseqid", "sseqid", "sallseqid", "evalue", "bitscore", "qlen", "slen")

head(annot_marf)

tx_gene_pre <- annot_marf %>% 
  select(qseqid, GENE_ID = sseqid) %>% 
  separate(qseqid,into = c("TRANSCRIPT_ID", "Transdecoder_suffix"), sep = "\\.", remove = FALSE) 

tx_gene_KEY <- tx_gene_pre %>% 
  select(TRANSCRIPT_ID, GENE_ID) %>% 
  distinct()

# Save this R object for tximport later.
save(tx_gene_KEY, file = "meta-eukomic/output-files/txi_key_annot.RData")

# Get more information from database:
pfams_marf <- read_delim("/scratch/group/hu-lab/marferret/data/MarFERReT.v1.1.1.best_pfam_annotations.csv.gz")
glimpse(pfams_marf) #our sseqid will match "aa_id"

tax_key <- read_delim("/scratch/group/hu-lab/marferret/data/MarFERReT.v1.1.1.taxonomies.tab.gz")
glimpse(tax_key) # need to re-set accession.version to be "sseqid"

tax_names <- read_delim("/scratch/group/hu-lab/marferret/data/MarFERReT.v1.1.1.metadata.csv")
glimpse(tax_names) #tax id should match tax id columns

metat_annot_info <- annot_marf %>%
  left_join(pfams_marf, by = join_by(sseqid == aa_id)) %>% 
  left_join(tax_key %>% select(sseqid = accession.version, tax_id = taxid)) %>% 
  left_join(tax_names)

# Save all annotation information
glimpse(metat_annot_info)

save(metat_annot_info, file = "/scratch/group/hu-lab/meta-eukomics/annotation/metat_annot_info.RData")
