# From https://github.com/richelbilderbeek/razzo/issues/317 :
#
# Write script that shows the true and twin error for a BD tree
# tree when assuming a Yule tree prior
# and using a Yule twin
library(pirouette)
library(beautier)
library(beastier)
library(testthat)
library(ggplot2)

# Constants
is_testing <- is_on_ci()
example_no <- 26
rng_seed <- 314
folder_name <- paste0("example_", example_no)
n_phylogenies <- 20 # Number of replicates
if (is_testing) {
  n_phylogenies <- 2
}

# Create phylogenies
phylogenies <- list()
for (i in seq_len(n_phylogenies)) {
  set.seed(314 - 1 + i)
  phylogenies[[i]] <- create_bd_tree(n_taxa = 6, crown_age = 10)
}
expect_equal(length(phylogenies), n_phylogenies)

# Setup pirouette
pir_paramses <- create_std_pir_paramses(
  n = n_phylogenies,
  folder_name = folder_name
)
for (i in seq_along(pir_paramses)) {
  pir_paramses[[i]]$experiments[[1]]$inference_model$tree_prior <-
    create_yule_tree_prior()
}
if (is_testing) {
  pir_paramses <- shorten_pir_paramses(pir_paramses)
}

# Run pirouette
pir_outs <- pir_runs(
  phylogenies = phylogenies,
  pir_paramses = pir_paramses
)

# Save summary
pir_plots(pir_outs) +
  ggtitle(paste("Number of replicates: ", n_phylogenies)) +
  ggsave("errors.png", width = 7, height = 7)

# Save individual runs
expect_equal(length(pir_paramses), length(pir_outs))
expect_equal(length(pir_paramses), length(phylogenies))
for (i in seq_along(pir_outs)) {
  pir_save(
    phylogeny = phylogenies[[i]],
    pir_params = pir_paramses[[i]],
    pir_out = pir_outs[[i]],
    folder_name = dirname(pir_paramses[[i]]$alignment_params$fasta_filename)
  )
}
