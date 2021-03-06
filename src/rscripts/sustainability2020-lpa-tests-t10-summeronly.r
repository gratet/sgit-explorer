
library(tidyr)
library(readr)
library(magrittr)
library(dplyr)
library(stringr)
library(ggcorrplot)
library(sugrrants)
library(tidyLPA)

activity <- 
  read_csv("dist/query_results/2018/log[atm]-date[2018]-card[summeronly]-fare[t10]+stops-municipalities-zones-routes-days-months+card+activity{count}.csv",
           col_types = cols(
             card = col_character(), 
             active_days = col_integer(),
             active_months = col_integer(),
             used_routes = col_integer(),
             visited_municipalities = col_integer(),
             visited_stops = col_integer(),
             visited_zones = col_integer()
           )
  )

spatial_concentration <- 
  read_csv("dist/query_results/2018/log[atm]-date[2018]-card[summeronly]-fare[t10]+transactions-transactions{tchains}-tarragonareus-cgc+card+transactions{count}.csv", 
           col_types = cols(
             card = col_character(),
             transaction_chains_summer = col_integer(),
             transactions_summer = col_integer(), 
             transactions_cgc_summer = col_integer(),
             transactions_tarragona_reus_summer = col_integer()
           )
  )

stops_concentration <- 
  read_csv("dist/query_results/2018/log[atm]-date[2018]-card[summeronly]-fare[t10]+stops-main2stops-main3stops+cards+transactions{topn}.csv", 
           col_types = cols(
             card = col_character(),
             main_three_stops = col_integer(),
             main_two_stops = col_integer(), 
             stop_id_array = col_character(),
             stop_transactions_array = col_character()
           )
  ) %>%
  dplyr::select(-ends_with("array"))

temporal_concentration <- 
  read_csv("dist/query_results/2018/log[atm]-date[2018]-card[summeronly]-fare[t10]+total-weekend-weekend[hourly]-weekend[hourly[00,02,07,11,15,19,24]]-week-week[hourly]-week[hourly[00,02,07,11,15,19,24]]+card-fare+transactions{count}.csv",
           col_types = cols(
             card = col_character(),
             fare = col_character(), transactions = col_integer(),
             week = col_integer(), 
             week_00 = col_integer(), week_01 = col_integer(), 
             week_02 = col_integer(), week_03 = col_integer(), 
             week_04 = col_integer(), week_05 = col_integer(), 
             week_06 = col_integer(), week_07 = col_integer(), 
             week_08 = col_integer(), week_09 = col_integer(), 
             week_10 = col_integer(), week_11 = col_integer(), 
             week_12 = col_integer(), week_13 = col_integer(), 
             week_14 = col_integer(), week_15 = col_integer(), 
             week_16 = col_integer(), week_17 = col_integer(), 
             week_18 = col_integer(), week_19 = col_integer(), 
             week_20 = col_integer(), week_21 = col_integer(), 
             week_22 = col_integer(), week_23 = col_integer(), 
             
             weekend = col_integer(),
             weekend_00 = col_integer(), weekend_01 = col_integer(), 
             weekend_02 = col_integer(), weekend_03 = col_integer(),
             weekend_04 = col_integer(), weekend_05 = col_integer(),
             weekend_06 = col_integer(), weekend_07 = col_integer(), 
             weekend_08 = col_integer(), weekend_09 = col_integer(),
             weekend_10 = col_integer(), weekend_11 = col_integer(),
             weekend_12 = col_integer(), weekend_13 = col_integer(), 
             weekend_14 = col_integer(), weekend_15 = col_integer(),
             weekend_16 = col_integer(), weekend_17 = col_integer(),
             weekend_18 = col_integer(), weekend_19 = col_integer(), 
             weekend_20 = col_integer(), weekend_21 = col_integer(),
             weekend_22 = col_integer(), weekend_23 = col_integer(),
             
             week_00_02 = col_integer(), week_02_07 = col_integer(), 
             week_07_11 = col_integer(), week_11_15 = col_integer(), 
             week_15_19 = col_integer(), week_19_24 = col_integer(),
             
             weekend_00_02 = col_integer(), weekend_02_07 = col_integer(), 
             weekend_07_11 = col_integer(), weekend_11_15 = col_integer(), 
             weekend_15_19 = col_integer(), weekend_19_24 = col_integer()
           )
  )


gaps_and_islands <- 
  read_csv("dist/query_results/2018/log[atm]-date[2018]-card[summeronly]-fare[t10]+enabled+card+days{gaps.and.islands}.csv", 
           col_types = cols(
             card = col_character(),
             enabled_days = col_integer()
           )
  )

group_sizes<-
  read_csv("dist/query_results/2018/log[atm]-date[2018]-card[summeronly]-fare[t10]+max_group_size-avg_group_size+card+transactions{gaps.and.islands}.csv", 
           col_types = cols(
             card = col_character(),
             max_group_size = col_integer(),
             avg_group_size = col_integer()
           )
  )



card_stats<-
  activity %>% 
  left_join(spatial_concentration,by = "card") %>% 
  left_join(stops_concentration,by = "card") %>% 
  left_join(temporal_concentration,by = "card")%>% 
  left_join(gaps_and_islands,by = "card") %>% 
  left_join(group_sizes,by="card")

card_stats[is.na(card_stats)] <- 0

# Keep main
rm(list=setdiff(ls(), "card_stats"))

# For Regex testing see: 
# https://regexr.com/

card_stats <- 
  card_stats %>% 
  mutate(transactions_tarragona_reus=transactions_tarragona_reus_summer) %>%
  mutate(transactions_cgc=transactions_cgc_summer) %>% 
  select(-fare,
         -transactions_summer,
         -transactions_tarragona_reus_summer,-transactions_cgc_summer,
         -transaction_chains_summer) %>% 
  select(card,enabled_days, 
                transactions, visited_stops, visited_municipalities, visited_zones, used_routes, active_days,active_months,
                main_two_stops, main_three_stops,
                transactions_tarragona_reus, transactions_cgc,
                contains("group")) 
# %>%
#   select(-matches("week(\\_\\d\\d){1}\\b")) %>%
#   select(-matches("weekend(\\_\\d\\d){1}\\b"))
#   select(-matches("week(\\_\\d\\d){2}\\b")) %>%
#   select(-matches("weekend(\\_\\d\\d){2}\\b")) %>%
  # select(-weekend_04)


## Quickly convert multiple columns into percentages
fast_percent<-
  function(cols,tcol){
    for (c in cols) {
      card_stats[c]<<-ceiling((card_stats[c]/card_stats[tcol])*100)
    }
  }

transactions_column_names<-
  card_stats %>%
  select(starts_with("week"),
         starts_with("main"),
         contains("reus"),
         contains("cgc")) %>%
  names()

fast_percent(transactions_column_names,"transactions")

card_stats[, c(2:length(card_stats))] <- sapply(card_stats[, c(2:length(card_stats))], as.integer)

rm(transactions_column_names)


#####################
# FEATURE SELECTION #
#####################

## Best subset method
## https://rpubs.com/AnithaVallikunnel/VariableSelection
install.packages("leaps")
library(leaps)

model_subset <-
  regsubsets(transactions ~ . ,data = card_stats[2:length(card_stats)])

#se identifica que modelo tiene el valor máximo de R ajustado
which(summary(model_subset)$adjr2 == max(summary(model_subset)$adjr2))


# p <- ggplot(data = data.frame(n_predictors = 2:(length(card_stats)-1),
#                               R_adjusted = summary(model_subset)$adjr2),
#             aes(x = n_predictors, y = R_adjusted)) +
#   geom_line() +
#   geom_point()
# 
# #Se identifica en rojo el máximo
# p <- p + geom_point(aes(
#   x = n_predictors[which.max(summary(model_subset)$adjr2)],
#   y = R_adjusted[which.max(summary(model_subset)$adjr2)]),
#   colour = "red", size = 3)
# p <- p +  scale_x_continuous(breaks = c(0:length(card_stats)-2)) + 
#   theme_bw() +
#   labs(title = "Best model subset for summer transactions", 
#        x =  'Number of predictors',
#        y = bquote(~R^2~"adjusted"))
# p

which(summary(model_subset)$bic == min(summary(model_subset)$bic))
plot(model_subset)

significant_vars <-
  as.data.frame(summary(model_subset, matrix.logical = TRUE)$which[8,]) %>%
  tibble::rownames_to_column(var = "variable") %>%
  stats::setNames(c("variable","bool")) %>%
  filter(bool==TRUE) %>%
  filter(variable != "(Intercept)") %>%
  select(variable) %>%
  rbind("transactions")


# LPA
lpa_profiles <-
  card_stats[2:length(card_stats)] %>%
  scale() %>%
  as.data.frame() %>%
  select(one_of(significant_vars$variable)) %>% 
  estimate_profiles(n_profiles = 2:9,
                    models = c(1))

lpa_profiles_comparison <-
  lpa_profiles %>% 
  compare_solutions(statistics = c("AIC", "AWE", "BIC", "CLC", "KIC"))

lpa_selected <-
  card_stats[2:length(card_stats)] %>%
  # scale() %>%
  as.data.frame() %>%
  select(one_of(significant_vars$variable)) %>% 
  estimate_profiles(n_profiles = 7,
                    models = 1)

# Format variable names for plotting
variable_labels<-
  significant_vars$variable %>% 
  str_replace_all(pattern = "_",replacement = "\n")

legend_labels<-
  vapply(1:7, 
         FUN = function(x) paste0(x," (",sum(lpa_selected$model_1_class_7$dff$Class==x),")"), 
         FUN.VALUE = "string")


lpa_plot <-
  plot_profiles(lpa_selected,rawdata = FALSE,
                variables=significant_vars$variable) +
  ggtitle("Latent Profile Analysis from smart card data") + 
  scale_shape_discrete(labels=legend_labels) +
  scale_color_discrete(labels=legend_labels) +
  scale_linetype_discrete(labels=legend_labels) + 
  scale_x_discrete(labels = variable_labels)

lpa_clusters<-
  lpa_selected[["model_1_class_7"]][["dff"]] %>% 
  select(contains("CPROB"), Class)

lpa_clusters<-
  card_stats %>% 
  cbind(lpa_clusters)

names(lpa_clusters) %<>% tolower

lpa_cluster_stats<-
  lpa_clusters %>% 
  select(significant_vars$variable,class) %>% 
  group_by(class) %>%
  summarise_all(.funs = c(mean="mean", max="max", min="min", sd="sd",median= "median")) %>% 
  mutate_if(is.numeric, round, 2) %>% 
  select(order(colnames(.))) %>% 
  select(class, everything())

write.csv(lpa_cluster_stats, file = "dist/lpa-cluster-stats.csv",row.names = FALSE)

library(table1)

table1(~ transactions + enabled_days + visited_stops 
       + used_routes + active_days 
       + main_three_stops 
       + transactions_cgc + avg_group_size + max_group_size | class, 
       data=lpa_clusters, overall="Total")


####################
# Analyze clusters #
####################
t10_dataset <- 
  read_csv("dist/query_results/2018/log[atm]-date[2018]-card[summeronly]-fare[t10]+id-card-timestamp-agency-fare-route-stop-machine++transactions{list}.csv",
           col_types = cols(
             card = col_character()
           )) %>% 
  select(card,time_stamp)

cl1_sample <-
  lpa_clusters %>% 
  top_n(100,cprob1)

cl2_sample <-
  lpa_clusters %>% 
  top_n(100,cprob2)

cl3_sample <-
  lpa_clusters %>% 
  top_n(100,cprob3)

cl4_sample <-
  lpa_clusters %>% 
  top_n(100,cprob4)

cl5_sample <-
  lpa_clusters %>% 
  top_n(100,cprob5)

cl6_sample <-
  lpa_clusters %>% 
  top_n(100,cprob6)

cl7_sample <-
  lpa_clusters %>% 
  top_n(100,cprob7)

clust_sample <-
  cl1_sample %>% 
  rbind(cl2_sample) %>% 
  rbind(cl3_sample) %>% 
  rbind(cl4_sample) %>% 
  rbind(cl5_sample) %>% 
  rbind(cl6_sample) %>% 
  rbind(cl7_sample) 

# Get times
clust_sample<-
  clust_sample[,c("card","class")] %>% 
  left_join(t10_dataset,by="card")

calview_main_plot_df <-
  clust_sample %>% 
  select(card,time_stamp,class) %>% 
  mutate(
    class=as.factor(class),
    Date=as.Date(format(time_stamp,"%Y-%m-%d")),
    Year=as.integer(format(time_stamp,"%Y")),
    Month=format(time_stamp,"%B"),
    Mdate=as.integer(format(time_stamp,"%m")),
    Day=format(time_stamp,"%A"),
    Time=as.integer(format(time_stamp,"%H"))) %>% 
  group_by(class,Date, Year,Mdate,Day,Time) %>% 
  count(class) %>% 
  ungroup()

levels(calview_main_plot_df$class) <- legend_labels

calview_main_plot <- 
  calview_main_plot_df %>%
  mutate(Weekend = if_else(Day %in% c("Saturday", "Sunday"), "Weekend", "Weekday")) %>%
  frame_calendar(x = Time, y = n, date = Date, ncol = 4) %>% 
  ggplot(aes(x = .Time, y = .n, group = Date, colour = Weekend)) +
  geom_line() +
  theme_bw() +
  theme(legend.position = "none") +
  facet_wrap(~ class, nrow = 7, strip.position="right") +
  expand_limits(y = c(-0.4, 1.2)) +
  theme(strip.text.y = element_text(angle = 0))
calview_main_plot<-
  prettify(calview_main_plot,
           label = c("label","text", "text2"),
           size = 3, label.padding = unit(0.2, "lines"))

ggsave(filename = "dist/img/tiff/full-frame-calendar.tiff", 
       plot = calview_main_plot, 
       height=18, width=15, units='cm', 
       dpi = 300)
ggsave(filename = "dist/img/png/full-frame-calendar.png", 
       plot = calview_main_plot, 
       height=18, width=15, units='cm', 
       dpi = 300)

#TODO: frame calendar individual
calview_detail_plot_df <-
  lpa_clusters %>% 
  left_join(t10_dataset,by="card") %>% 
  select(card,time_stamp,class) %>% 
  mutate(
    class=as.factor(class),
    Date=as.Date(format(time_stamp,"%Y-%m-%d")),
    Year=as.integer(format(time_stamp,"%Y")),
    Month=format(time_stamp,"%B"),
    Mdate=as.integer(format(time_stamp,"%m")),
    Day=format(time_stamp,"%A"),
    Time=as.integer(format(time_stamp,"%H"))) %>% 
  group_by(class,Date, Year,Mdate,Day,Time) %>% 
  count(class) %>% 
  ungroup() %>% 
  rename("Transactions"=n)

levels(calview_detail_plot_df$class) <- legend_labels

# TODO: determine the biggest cluster and some stats and plot it
calview_detail_plot <- 
  calview_detail_plot_df %>%
  filter(class == legend_labels[1]) %>%
  mutate(Week = if_else(Day %in% c("Saturday", "Sunday"), "Weekend", "Weekday")) %>%
  ggplot(aes(x = Time, y = Transactions, colour = Week)) +
  geom_line() + 
  scale_y_continuous(breaks=c(0, 100, 200)) +
  scale_x_continuous(breaks=c(0, 6, 12, 18)) +
  facet_calendar(~ Date) +
  geom_text(aes(label = format(Date, format = "%d")), colour = "black", x = Inf, y = Inf, hjust = 1.5, vjust = 1.5) +
  theme_bw() +
  theme(legend.position = "none",
        strip.background = element_blank(),
        strip.text = element_blank())

calview_detail_plot<-
  ggdraw(calview_detail_plot) + 
  draw_label("June", x = 0.28, y = 0.95,size = 16) +
  draw_label("July", x = 0.9, y = 0.95,size = 16) +
  draw_label("August", x = 0.14, y = 0.47,size = 16) +
  draw_label("September", x = 0.81, y = 0.47,size = 16)

ggsave(filename = "dist/img/tiff/activity-main-cluster-faceted-calendar.tiff", 
       plot = calview_detail_plot, 
       height=20, width=30, units='cm', 
       dpi = 300)
ggsave(filename = "dist/img/png/activity-main-cluster-faceted-calendar.png", 
       plot = calview_detail_plot, 
       height=20, width=30, units='cm', 
       dpi = 300)
