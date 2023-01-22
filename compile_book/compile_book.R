# Script title 
## Author(s)
## Date initiated

#' Description

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Load packages ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, qpdf, fs, here)

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Heading X ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Heading X.1 ----

currrent_dir <- here::here()

r_foundations_dir <- stringr::str_replace(currrent_dir, "idar_bootcamp_admin", "r_foundations_wp")
data_untangled_dir <- stringr::str_replace(currrent_dir, "idar_bootcamp_admin", "data_untangled_wp")
data_on_display_dir <- stringr::str_replace(currrent_dir, "idar_bootcamp_admin", "data_on_display_wp")


# PDFs in 
cover_path <- here("compile_book/in_pdfs/idar_cover.pdf")
r_foundations_pdf_paths <- fs::dir_ls(r_foundations_dir, recurse = T, regexp = "pdf")
data_untangled_pdf_paths <- fs::dir_ls(data_untangled_dir, recurse = T, regexp = "pdf")
data_on_display_pdf_paths <- fs::dir_ls(data_on_display_dir, recurse = T, regexp = "pdf")

# Combine
qpdf::pdf_combine(input = c(cover_path, 
                            r_foundations_pdf_paths,
                            data_untangled_pdf_paths,
                            data_on_display_pdf_paths
                            ),
                  output = here("compile_book/idar_book.pdf"))






