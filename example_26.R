# From https://github.com/richelbilderbeek/razzo/issues/317 :
#
# Write script that shows the true and twin error for a BD tree
# tree when assuming a Yule tree prior
# and using a Yule twin
library(pirouette)
library(beautier)
library(beastier)

# Constants
is_testing <- is_on_ci()
example_no <- 26
rng_seed <- 314
folder_name <- paste0("example_", example_no, "_", rng_seed)

# Create phylogeny
set.seed(rng_seed)
phylogeny <- create_bd_tree(n_taxa = 6, crown_age = 10)

# Setup pirouette
pir_params <- create_std_pir_params(folder_name = folder_name)
# Generative models assumes Yule
pir_params$experiments[[1]]$inference_model$tree_prior <-
  create_yule_tree_prior()
if (is_testing) {
  pir_params <- shorten_pir_params(pir_params)
}

# Run pirouette
pir_out <- pir_run(
  phylogeny,
  pir_params = pir_params
)

# Save results
pir_save(
  phylogeny = phylogeny,
  pir_params = pir_params,
  pir_out = pir_out,
  folder_name = folder_name
)

