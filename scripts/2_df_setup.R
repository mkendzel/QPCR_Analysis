parts <- strsplit(df$`sample id`, "_")

new_df <- cbind(
  df,
  strain    = sapply(parts, `[`, 1),
  treatment = sapply(parts, `[`, 2),
  tissue    = sapply(parts, `[`, 3),
  mouse_id  = sapply(parts, `[`, 4)
)