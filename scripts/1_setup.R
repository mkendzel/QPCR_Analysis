# ---- Install Packages ----
install.packages("renv")

# ---- Download files from renv.lock ----
renv::restore()
