# QC data frame
# md <- read.csv("RNAExtractions_Metadata_V1 - june222026.csv")
md_clean <- read.csv("RNAExtractions_Metadata_V1_cleaned.csv")
md_format <- md %>%
  filter((`Sequence.ID` != "NOT SEQ'D")) %>% 
  filter((`Sequence.ID` != "")) |> 
  mutate(Depth = case_when(
    (Filter == "A" | Filter == "B") ~ "30 m",
    TRUE ~ "35 m"
  )) %>% 
  # Lysis disruption type
  mutate(Lysis_reag = case_when(
    grepl("Beta Merc", `Lysis.notes..TCEP.or.betamercaptoethanol.`) ~ "β-mercaptoethanol",
    grepl("TCEP", `Lysis.notes..TCEP.or.betamercaptoethanol.`) ~ "+TCEP",
    TRUE ~ NA),
    Lysis_reag_bin = "yes") %>% 
  pivot_wider(names_from = Lysis_reag, values_from = Lysis_reag_bin) |> select(-`NA`) |> 
  # Physical disruption
  mutate(Physical_distruption = case_when(
    grepl("\\?", `Beater.type`) ~ "Unknown_PhysicalDist",
    (`Beater.type` %in% combo) ~ "Vortex with beads",
    (`Beater.type` == "Beads" | `Beater.type` == "Biospec Mini Beadbeater") ~ "Beads",
    (`Beater.type` == "Vortex") ~ "Vortex"),
    Physical_distruption = case_when(
      is.na(Physical_distruption) ~ "Unknown_PhysicalDist",
      TRUE ~ Physical_distruption),
    phys_dis_bin = "yes") %>% 
  pivot_wider(names_from = Physical_distruption, values_from = phys_dis_bin) |> 
  # DNase
  mutate(DNase = case_when(
    (DNase_brand == "//?" | DNase_brand == "" | is.na(DNase_brand)) ~ "Unknown_DNase",
    (DNase_brand == "Qiagen RNase-free DNase" | DNase_brand == "Part of Qiagen Kit" | DNase_brand ==  "Qiagen RNase-free DNase kit") ~ "Qiagen RNase-free DNase",
    (DNase_brand == "Turbo DNase" | DNase_brand =="TurboDNAse Thermo-Fisher") ~ "Turbo DNase",
    (DNase_brand == "Qiagen Kit/TurboDNase") ~ "Qiagen RNase-free DNase,Turbo DNase",
    (DNase_brand == "Kit provided" | DNase_brand == "rDNase part of kit" | DNase_brand == "part of Zymo kit" | DNase_brand == "Part of Zymo Kit" | DNase_brand == "rDNAse part of Macherey-Nagel \nkit") ~ "Kit provided",
    (DNase_brand == "RNAqueous-4PCR Total RNA Isolation") ~ "Kit provided")) %>% 
  mutate(Elution = case_when(
    grepl("Elution", `Elution.Type`) ~ "Elution solution",
    TRUE ~ "RNase-free water"
  )) %>% 
  mutate(Quantification = case_when(
    grepl("Qubit", `RNA.quant.device`) ~ "Qubit",
    TRUE ~ `RNA.quant.device`)) %>% 
  # mutate(Physical_bin = case_when(
  #   (`Physical.disruption..Y.N.` == "Y") ~ 1,
  #   TRUE ~ 0)) |> 
  select(SequenceID = `Sequence.ID`, Filter, Depth,
    `+TCEP`, `β-mercaptoethanol`, 
    Beads, Vortex, `Vortex with beads`, Unknown_PhysicalDist,
    Protocol = `Extraction.Protocol`, Kit = `Exact_kit_name`, 
    DNase, Elution, Quantification) |> 
# unique(md_format$DNase)
  # Extraction protocol
  mutate(ext_PA = "yes") |> 
  pivot_wider(names_from = Protocol, values_from = ext_PA) |> 
  # DNase
  separate_longer_delim(DNase, delim = ",") %>%
  mutate(dnase_bin = "yes") |>
  pivot_wider(names_from = DNase, values_from = dnase_bin) |>
  # Elution
  mutate(elut_PA = "yes") |>
  pivot_wider(names_from = Elution, values_from = elut_PA) |> 
  # Quant
  mutate(quant_PA = "yes") |>
  pivot_wider(names_from = Quantification, values_from = quant_PA) |> 
  mutate(SampleID_ORDER = factor(SequenceID, levels = sample_order))
colnames(md_format)

#  `Qiagen RNeasy`, `Qiagen AllPrep RNA/DNA`, `Qiagen PowerWater RNA`, `Qiagen RNeasy Plant Mini Kit`, `Zymo Quick DNA/RNA miniprep kit`, `Zymo RNA Quick`, `Zymo RNA MiniPrep Plus`, `Thermo Fisher Trizol`, `NucleoSpin RNA`, `NucleoMag RNA`, `RNAqueous-4PCR Total RNA Isolation`,

# Pivot longer
variable_fill <- list(
  "Filter" = "Filter",
  "Depth" = "Depth",
  "+TCEP" = "+TCEP",
  "β-mercaptoethanol" = "β-mercaptoethanol",
  "Beads" = "Beads",
  "Vortex" = "Vortex",
  "Vortex with beads" = "Vortex with beads",
  "Unknown_PhysicalDist" = "Unknown_PhysicalDist",
  "Qiagen RNeasy" = "Qiagen RNeasy",
  "Qiagen AllPrep RNA/DNA" = "Qiagen AllPrep RNA/DNA",
  "Qiagen PowerWater RNA" = "Qiagen PowerWater RNA",
  "Qiagen RNeasy Plant Mini Kit" = "Qiagen RNeasy Plant Mini Kit",
  "Zymo Quick DNA/RNA miniprep kit" = "Zymo Quick DNA/RNA miniprep kit",
  "Zymo RNA Quick" = "Zymo RNA Quick",
  "Zymo RNA MiniPrep Plus" = "Zymo RNA MiniPrep Plus",
  "Thermo Fisher Trizol" = "Thermo Fisher Trizol",
  "NucleoSpin RNA" = "NucleoSpin RNA",
  "NucleoMag RNA" = "NucleoMag RNA",
  "RNAqueous-4PCR Total RNA Isolation" = "RNAqueous-4PCR Total RNA Isolation",
  #DNase
  "Qiagen RNase-free DNase" = "Qiagen RNase-free DNase",
  "Turbo DNase" = "Turbo DNase",
  "Kit provided" = "Kit provided",
  "Unknown_DNase" = "Unknown_DNase",
  # Elution solution
  "Elution solution" = "Elution solution", 
  "RNase-free water" = "RNase-free water",
  #QUANT
  "Qubit" = "Qubit",
  "Bioanalyzer" = "Bioanalyzer",
  "Nanodrop" = "Nanodrop",
  "RiboGreen" = "RiboGreen")
# length(variable_fill)

scale_fill <- list(
  # Filter
  scale_fill_manual(values = c("#ae2f6d","#67c9ba", "#fbef52", "#f2bfc9", "#cc504a", "#3f65c5")),
  # Depth
  scale_fill_manual(values = c("grey75","grey25")),
  ## LYSIS
  # Tcep
  scale_fill_manual(values = c("#040C14", "white")),
  # beta-mer
  scale_fill_manual(values = c("#040C14", "white")),
  ## PHYSICAL DISRUPTION
  # beads
  scale_fill_manual(values = c("blue", "white")),
  # vortex
  scale_fill_manual(values = c("blue", "white")),
  # vortex and beads
  scale_fill_manual(values = c("blue", "white")),
  # unknown
  scale_fill_manual(values = c("blue", "white")),
  ## EXTRACTION
  scale_fill_manual(values = c("red", "white")),
  scale_fill_manual(values = c("red", "white")),
  scale_fill_manual(values = c("red", "white")),
  scale_fill_manual(values = c("red", "white")),
  scale_fill_manual(values = c("red", "white")),
  scale_fill_manual(values = c("red", "white")),
  scale_fill_manual(values = c("red", "white")),
  scale_fill_manual(values = c("red", "white")),
  scale_fill_manual(values = c("red", "white")),
  scale_fill_manual(values = c("red", "white")),
  scale_fill_manual(values = c("red", "white")),
  # DNase
  scale_fill_manual(values = c("yellow", "white")),
  scale_fill_manual(values = c("yellow", "white")),
  scale_fill_manual(values = c("yellow", "white")),
  scale_fill_manual(values = c("yellow", "white")),
  # Elution
  scale_fill_manual(values = c("orange", "white")),
  scale_fill_manual(values = c("orange", "white")),
  #QUANT
  scale_fill_manual(values = c("purple", "white")),
  scale_fill_manual(values = c("purple", "white")),
  scale_fill_manual(values = c("purple", "white")),
  scale_fill_manual(values = c("purple", "white"))
  )

length(variable_fill);length(scale_fill)
names(scale_fill) <- names(variable_fill)
var_levels <- names(variable_fill)
# var_levels
# variable_fill

ggplot(md_format, aes(y = SampleID_ORDER)) +
  purrr::imap(
    variable_fill, \(x, y) {
      list(
        geom_tile(
          aes(
            x = y,
            fill = .data[[x]]
          ),
          color = "black",
          width = .95
        ),
        scale_fill[[y]],
        ggnewscale::new_scale_fill()
      )
    }
  ) +
  scale_x_discrete(
    limits = var_levels
  ) +
  theme_void() +
  theme(
    axis.text.y = element_blank(),
    axis.text.x = element_text(
      angle = 90,
      hjust = 1
    ),
    axis.title = element_blank(),
    strip.text = element_blank(),
    legend.position = "right",
    panel.border = element_rect(fill = NA, linewidth = 0.8),
    panel.background = element_rect(colour = NA, fill = "transparent"),
    plot.background = element_rect(colour = NA, fill = "transparent"),
    plot.margin = margin(0, 0, 0, 0, "cm"),
    panel.spacing = unit(0, "cm"),
    legend.title = element_blank()
  )
# 