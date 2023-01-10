if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, janitor, here, lubridate, ggthemes, patchwork)


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Febrile Diseases Burkina Faso ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

febrile_diseases_burkina_faso <- read_csv(here("week_02/data/01_febrile_diseases_burkina_faso.csv"))

#  make a frequency table of the ims_final_full_classification variable

tabyl(febrile_diseases_burkina_faso, ims_final_full_classification) 

tabyl(febrile_diseases_burkina_faso, ims_final_full_classification) %>% 
  write_csv(here("week_02/outputs/tabyl_ims_final_full_classification.csv"))

# POINT A: The most common diagnosis was of bacterial diseases
(p <- ggplot(febrile_diseases_burkina_faso) + 
  geom_bar(aes(y = ims_final_full_classification, fill = ims_final_full_classification)))

ggsave(filename = here("week_02/outputs/fig_ims_final_full_classification.pdf"), 
         plot = p)

# POINT B: A majority of children five years and older reported abdominal pain

(p <- febrile_diseases_burkina_faso %>%
  filter(age_category %in% "5 years or older") %>%
  ggplot() +
  aes(x = abd_pain) +
  geom_bar(fill = "#112446") +
  theme_minimal())

ggsave(filename = here("week_02/outputs/children_above_5_abd_pain.pdf"), 
       plot = p)

#  DATA REQUEST: Count the number of people who had up to four symptoms.

symptoms_count <- 
  febrile_diseases_burkina_faso %>% 
  select(vomiting_anamnestic:lethargy) %>%
  mutate(across(.fns = ~ ifelse(.x == "yes", 1, 0))) %>% 
  mutate(total_symptoms = rowSums(across())) %>% 
  count(total_symptoms)

symptoms_count

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## India TB pathways and costs ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

india_tb_pathways_and_costs <- read_csv(here("week_02/data/02_india_tb_pathways_and_costs.csv"))

#  make a frequency table of the first visit location variable
tabyl(india_tb_pathways_and_costs, `first visit location`)

# POINT A: The most common education category was "No Education"
ggplot(india_tb_pathways_and_costs) +
 aes(x = Education) +
 geom_bar(fill = "#112446") +
 theme_minimal()


# POINT B: About half of the male respondents do not drink alcohol
india_tb_pathways_and_costs %>%
  filter(Sex %in% "Male") %>%
  ggplot() +
  aes(x = Alcohol) +
  geom_bar(fill = "#112446") +
  theme_minimal()

#  DATA REQUEST: Find the average amount of money paid across all three TB visits by people in each Education level group

india_tb_pathways_and_costs %>% 
  group_by(Education) %>% 
  select(Education, `first visit cost`, `second visit cost`, `third visit cost`) %>% 
  summarise(total_paid = sum(`first visit cost`, `second visit cost`, `third visit cost`), 
            number_in_group = n()) %>% 
  mutate(average = total_paid/number_in_group)

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Colombia motor accidents ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


motorcycle_accidents_colombia <- read_csv(here("week_02/data/03_motorcycle_accidents_colombia.csv"))

#  make a frequency table of the first visit location variable
tabyl(motorcycle_accidents_colombia, REC_MUNRES)

# POINT A: The most common education category was "No Education"
ggplot(motorcycle_accidents_colombia) +
  aes(x = `REC_GRUPO EDAD`) +
  geom_bar(fill = "#112446") +
  theme_minimal()


# POINT B: About half of the male respondents do not drink alcohol
motorcycle_accidents_colombia %>%
  filter(REC_SEXO %in% "Femenino") %>%
  ggplot() +
  aes(x = REC_CONDICION) +
  geom_bar(fill = "#112446") +
  theme_minimal()

# DATA REQUEST: Find out if the number of accidents in Medellin was increasing or decreasing between 2012 and 2015

year_counts <- 
  motorcycle_accidents_colombia %>% 
  count(year_count = lubridate::year(FECHA_DEF))
  
ggplot(year_counts) + 
  geom_col(aes(n, factor(year_count)), fill = "dodgerblue4") + 
  theme_economist()

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Covid US ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

covid_19_us <- read_csv(here("week_02/data/04_covid_19_united_states.csv"))

# freq tab
tabyl(covid_19_us, weekday_admit)

# POINT A: The sample is mostly composed of older individuals, aged above 50
ggplot(covid_19_us) +
  aes(x = age) +
  geom_histogram(bins = 30L, fill = "#112446") +
  theme_minimal()

# POINT B: A majority of black patients had hypertension 
covid_19_us %>%
  filter(race %in% "black" | is.na(race)) %>%
  ggplot() +
  aes(x = hypertension) +
  geom_bar(fill = "#112446") +
  theme_minimal()

# DATA REQUEST: Which racial groups had a higher incidence of diabetes?

diab_incid <- 
  covid_19_us %>% 
  group_by(race) %>% 
  count(diabetes) %>% 
  ungroup() %>% 
  pivot_wider(names_from = diabetes, values_from = n) %>% 
  mutate(prev = yes/(yes+no)) 

ggplot(diab_incid) + 
  geom_col(aes(prev, race), fill = "dodgerblue4") + 
  theme_economist()

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Sex survey UK ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sex_uk <- read_csv(here("week_02/data/05_sex_attitudes_survey_uk.csv"))

# freq tab
tabyl(sex_uk, rnssecgp_6)

# POINT A: The majority of respondents are in the 25-34 age group (`agrp` variable)

ggplot(sex_uk) +
  aes(x = agrp) +
  geom_bar(fill = "#112446") +
  theme_minimal()

# POINT B: Among respondents aged 65-74, a large proportion consider religion to be "Fairly important" (`religimp` variable) 

sex_uk %>%
  filter(agrp %in% "65-74") %>%
  ggplot() +
  aes(x = religimp) +
  geom_bar(fill = "#112446") +
  theme_minimal()

# DATA REQUEST: Among the "agree with opinion" questions (from `snpres` to `snearly`) which have the largest difference between male and female respondents?


# Variable = snearly	Variable label = Young people today start having sex too early 
# Variable = snmedia	Variable label = Too much sex in the media 

# first a plot
sex_uk %>%  
  select(rsex, snpres:snearly) %>% 
  # recode into factor
  mutate(across(snpres:snearly, 
                .fns = ~ factor(.x, 
                                levels = c("Disagree strongly",
                                           "Disagree",
                                           "Neither agree or disagree",
                                           "Agree",
                                           "Agree strongly")))) %>% 
  # pivot so you can do all plots at once
  pivot_longer(snpres:snearly) %>% 
  drop_na() %>% 
  group_by(rsex, name) %>% 
  count(value) %>%
  ggplot() + 
  geom_col(aes(y = n,
               x = value,
              group = rsex, 
              fill = rsex), position = "dodge") + 
  facet_wrap(~ name, ncol = 1)


# actual numbers
sex_uk %>%  
  select(rsex, snpres:snearly) %>% 
  # recode into numeric
  mutate(across(snpres:snearly, 
                .fns = ~ recode(.x, 
                                "Disagree strongly" = -2,
                                "Disagree" = -1,
                                "Neither agree or disagree" = 0,
                                "Agree" = 1,
                                "Agree strongly" = 2, 
                                "Don't know" = NA_real_))) %>% 
  # pivot so you can do all calculations at once
  pivot_longer(snpres:snearly) %>% 
  drop_na() %>% 
  group_by(rsex, name) %>% 
  summarise(average = sum(value)/n()) %>% 
  ungroup() %>% 
  pivot_wider(names_from = rsex, values_from = average) %>% 
  mutate(difference = Female - Male)

## Women are more likely to agree with men on all statements. 
# The biggest difference is for the question "Young people today start having sex too early"
# The smallest difference is for the question "Natural for people to want sex less as they get older"



