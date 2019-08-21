library(ggplot2)
library(dplyr)
library(tidyr)
knitr::opts_chunk$set(echo = FALSE, warning = FALSE, message = FALSE)
options(stringsAsFactors = FALSE)
theme_set(new = theme_bw())


# import data - averaged within recordings, make link to raw data
bd <- read.csv(file = "../data/behav_manutracked_reduced_dataset.csv", header = TRUE) # manual data
bdr <- read.csv(file = "../data/behav_autotracked_reduced_dataset.csv", header = TRUE) # auto-tracked data
infd <- read.csv(file = "../data/GxG_inf2.csv", header = TRUE, fileEncoding = "UTF-8-BOM") #excel attached BOM to csv





# AUTO DATA
bdr <- mutate(bdr, speed_per_sec = tot_dist/frames_tracked * 2,
              cop_name = substring(fname, 1, 5),
              dpi = substring(fname, 7, 8),
              plate_no = substring(fname, 1, 2),
              rec_time = factor(group, levels = c('before the drop', 'after the drop')))%>%
  select(-group)%>%
  select(fname, cop_name, dpi, rec_time, tot_dist, var_dist, frames_tracked, speed_per_sec)


write.csv(bdr, file = "../data/dryad_versions/behav_autotracked.csv", row.names = F)




# MANUAL DATA
bd <- mutate(bd, speed_per_sec = tot_dist/frames_tracked * 0.5,
             cop_name = substring(fname, 1, 5),
             dpi = substring(fname, 7, 8),
             plate_no = substring(fname, 1, 2),
             rec_time = factor(group, levels = c('before the drop', 'after the drop')))%>%
  select(-group)%>%
  select(fname, cop_name, dpi, rec_time, tot_dist, var_dist, frames_tracked, speed_per_sec)


write.csv(bd, file = "../data/dryad_versions/behav_manuallytracked.csv", row.names = F)







# INFECTION DATA
infd <- mutate(infd, proc_size = (proc_size1 + proc_size2)/2)


# better labels to trts
infd <- mutate(infd,
               exposed = if_else(exposed == 0, "unexposed", "exposed"),
               trt = factor(trt, levels = c('unexposed', 'uninfected', 'infected')),
               trt = factor(trt, labels = c('unexposed, control', 'exposed, uninfected', 'infected')),
               parasite_fam = factor(parasite_fam, labels = c('A', 'B', 'C', 'D', 'E')),
               box = factor(box),
               cop_length = cop_length * 0.002,
               dead = if_else(dead == 0, "died during experiment", "survived 21 dpi"),
               infection = if_else(infected == 0, "uninfected", "infected"))%>% # make a nice variable for infection
  mutate(infection = factor(infection, levels = c("uninfected", "infected")),
         date_exposed = if_else(box == 1, "24_08_2010",
                                if_else(box == 2, "25_10_2010", "26_10_2010")))


infd <- select(infd, 
               cop_name, block = box, exposed, date_exposed, infection, trt,
               cop_geno = cop_fam, parasite_geno = parasite_fam,
               cerc_d9, dead, days_surv, cop_length, proc_size)%>%
  filter(!is.na(exposed))

write.csv(infd, file = "../data/dryad_versions/infection_data.csv", row.names = F)



