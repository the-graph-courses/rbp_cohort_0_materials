# Compile assignments
## Author(s)
## Date initiated

#' Description

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Load packages ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse)

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Heading X ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Load packages 
if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, here, fs, knitr, pagedown)


## Weeks 

curr_dir <- here::here()

weeks <- fs::dir_ls(path = curr_dir, type = "directory", regexp = "week_0")

for (week in weeks) {
  scripts <-
    fs::dir_ls(week,
               type = "file",
               recurse = T,
               regexp = ".Rmd$|.R$") %>% 
    as_tibble() %>% 
    filter(!str_detect(value, "demo_week_07"),
           !str_detect(value, "/data_prep/")) %>% 
    pull(1)
    
  
  ## Render HTML (from R or Rmd)
  
  knitted_docs <- c()
  for (script in scripts) {
    if (str_ends(script, ".R")) {
      
      spun_doc_path <-  knitr::spin(script, knit = F)
      rendered_doc_path <- rmarkdown::render(spun_doc_path)
      knitted_docs <- c(knitted_docs, spun_doc_path)
    }
    if (str_ends(script, ".Rmd")) {
      rendered_doc_path <- rmarkdown::render(script)
      knitted_docs <- c(knitted_docs, rendered_doc_path)
    }
  }
  
  ## PDF print
  
  chrome_printed_docs <- c()
  for (doc in knitted_docs) {
    new_chrome_printed_docs <-
      pagedown::chrome_print(input = doc,
                             output =
                               paste0(
                                 here("compile/"),
                                 basename(week),
                                 "_",
                                 basename(tools::file_path_sans_ext(doc)),
                                 ".pdf"))
    
    # append
    chrome_printed_docs <- c(chrome_printed_docs, new_chrome_printed_docs)
    
  }
  
  
}

# Cover
rendered_cover_pdf <- rmarkdown::render(here("compile_assignments/cover.Rmd"))

# Combine PDFs
pdf_paths <- fs::dir_ls(here("compile_assignments"), 
                        regexp = "week.*.pdf")

qpdf::pdf_combine(input = c(rendered_cover_pdf, 
                            pdf_paths),
                  output = here("compile_assignments/assignments.pdf"))








