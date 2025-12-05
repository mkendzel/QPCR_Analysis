# ---- 1) Load libraries ----
library(tidyverse)
library(performance)
library(emmeans)
library(knitr)
# ---- 2) Import Data ----
# import long-formatted .csv file from data/processed folder
long_ct <- read.csv("data/processed/.csv")

# ---- 3) Format Data columns ----
# Each categorical variable should be a factor
long_ct$treatment <- factor(long_ct$treatment)
long_ct$gene      <- factor(long_ct$gene)
long_ct$mouse_id  <- factor(long_ct$mouse_id)


#subset long_ct by tissue into separate dataframes for analysis
lung <- long_ct %>% filter(tissue == "Lung")
bone_marrow <- long_ct %>% filter(tissue == "Bone Marrow")
spleen <- long_ct %>% filter(tissue == "Spleen")
liver <- long_ct %>% filter(tissue == "Liver")


# ---- 4) run linear mixed-effect model for each tissue ----

#Create list of fit models for each tissue
model_list <- split(long_ct, long_ct$tissue) |>
  lapply(function(df) lm(ct_value ~ ct_ref + treatment * gene, data = df))


#Check each models assumptions
lapply(model_list, check_model)

#ANOVA for each model
anova_list <- lapply(model_list, anova)

#Check if treatment and gene are significant
anova_list

# ---- 5) Post-hoc Emmeans for each model ----
emmeans_list <- lapply(model_list, function(mod) {
  emmeans(mod, pairwise ~ treatment | gene, adjust = "tukey")
})
emmeans_list



emmeans(model_list$liver, pairwise ~ treatment | gene, adjust = "tukey")

# ---- 6) Save model outputs as .rds files ----
saveRDS(model_list, file = "results/ct_model_list.rds")
saveRDS(emmeans_list, file = "results/ct_emmeans_list.rds")

# Optional: load .rds files back into environment
# model_list <- readRDS("results/ct_model_list.rds")
# emmeans_list <- readRDS("results/ct_emmeans_list.rds")

# ---- 7) Create p-value table to be saved ----


pval_tbl <- bind_rows(lapply(names(emmeans_list), function(tissue) {
  df <- as.data.frame(emmeans_list[[tissue]]$contrasts)
  df$tissue <- tissue
  df[, c("tissue", "gene", "contrast", "p.value")]
})) %>%
  arrange(tissue, gene)

kable(pval_tbl, format = "pipe", digits = 4)

write.csv(pval_tbl, "results/emmeans_pvalues.csv", row.names = FALSE)
