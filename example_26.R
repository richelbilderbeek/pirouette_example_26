# From https://github.com/richelbilderbeek/razzo/issues/317 :
#
# Write script that shows the true and twin error for a BD tree
# tree when assuming a Yule tree prior
# and using a Yule twin
suppressMessages(library(pirouette))
suppressMessages(library(ggplot2))

################################################################################
# Constants
################################################################################
is_testing <- is_on_travis()
example_no <- 26
rng_seed <- 314
folder_name <- paste0("example_", example_no, "_", rng_seed)

################################################################################
# Create phylogeny
################################################################################
set.seed(rng_seed)
phylogeny <- create_bd_tree(n_taxa = 6, crown_age = 10)

################################################################################
# Setup pirouette
################################################################################
pir_params <- create_std_pir_params(folder_name = folder_name)
for (i in seq_along(pir_params$experiments)) {
  pir_params$experiments[[i]]$inference_model$tree_prior <- 
    create_yule_tree_prior()
}

if (is_testing) {
  pir_params <- shorten_pir_params(pir_params)
}

################################################################################
# Run pirouette
################################################################################
errors <- pir_run(
  phylogeny,
  pir_params = pir_params
)

utils::write.csv(
  x = errors,
  file = file.path(folder_name, "errors.csv"),
  row.names = FALSE
)

pir_plot(errors) +
  ggsave(file.path(folder_name, "errors.png"), width = 7, height = 7)

pir_to_pics(
  phylogeny = phylogeny,
  pir_params = pir_params,
  folder = folder_name
)

pir_to_tables(
  pir_params = pir_params,
  folder = folder_name
)

