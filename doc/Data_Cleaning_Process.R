library(tidyverse)

aaa %>% 
  group_by(OFNS_DESC) %>% 
  summarize(count = n()) %>% 
  arrange(desc(count))-> a


load("/Users/ruozhou_zhang/Documents/statistic_S02/GR5243_Applied_Data_Science/Spring2020-Project2-group-2/data/NYPD_Arrests_Data__Historic_.RData")

arrest.cleaned <-
  arrest %>% 
  dplyr::select(-c("ARREST_KEY", "PD_CD", "PD_DESC", "KY_CD", "LAW_CODE" )) %>% 
  na.omit() %>% 
  filter(OFNS_DESC != "") %>% 
  filter(ARREST_BORO != "") %>% 
  filter(AGE_GROUP != "") %>% 
  filter(PERP_RACE != "UNKNOWN") %>% 
  filter(LAW_CAT_CD != "") %>% 
  select(-c("X_COORD_CD","Y_COORD_CD")) %>% 
  mutate(ARREST_BORO = fct_recode(ARREST_BORO, 
                                  "Bronx" = "B",
                                  "StatenIsland" = "S",
                                  "Manhattan" = "M",
                                  "Queens" = "Q",
                                  "Brooklyn" = "K")) %>% 
  mutate(ARREST_BORO = as.character(ARREST_BORO)) %>% 
  mutate(LAW_CAT_CD = fct_recode(LAW_CAT_CD,
                                 "Felony" = "F",
                                 "Misdemeanor" = "M",
                                 "Violation" = "V",
                                 "Infraction" = "I")) %>% 
  mutate(JURISDICTION_CODE = factor(JURISDICTION_CODE,
                                    levels = c(0,1,2),
                                    labels = c("Patrol", "Transit", "Housing"))) %>% 
  mutate(JURISDICTION_CODE = as.character(JURISDICTION_CODE)) %>% 
  replace_na(list(JURISDICTION_CODE = "Others")) %>% 
  mutate(PERP_SEX = fct_recode(PERP_SEX,
                               "Male" = "M",
                               "Female" = "F")) %>% 
  mutate(OFNS_DESC = factor(tolower(OFNS_DESC))) %>% 
  mutate(OFNS_DESC = fct_collapse(OFNS_DESC,
                                  "administrative code" = c("administrative code", "administrative codes"),
                                  "burglary" = c("burglar's tools", "burglary"),
                                  "child abandonment/non support" = c("child abandonment/non support", "child abandonment/non support 1"),
                                  "criminal mischief & related offenses" = c("criminal mischief & related offenses", "criminal mischief & related of"),
                                  "harassment" = c("harassment", "harrassment 2"),
                                  "homicide-negligent" = c("homicide-negligent-vehicle", "homicide-negligent,unclassified"),
                                  "intoxicated & impaired driving" = c("intoxicated & impaired driving", "intoxicated/impaired driving"),
                                  "murder & non-negl. manslaughter" = c("murder & non-negl. manslaughter", "murder & non-negl. manslaughte"),
                                  "off. agnst pub ord sensblty &" = c("off. agnst pub ord sensblty &", "off. agnst pub ord sensblty & rghts to priv"),
                                  "offenses against public administration" = c("offenses against public administration", "offenses against public admini"),
                                  "other state laws (non penal law)" = c("other state laws (non penal law)", "other state laws (non penal la"),
                                  "possession of stolen property" = c("possession of stolen property", "possession of stolen property 5"))) %>% 
  group_by(OFNS_DESC) %>% 
  mutate(count = n()) %>% 
  ungroup() %>% 
  filter(count > 500) %>% 
  mutate(OFNS_DESC = factor(as.character(OFNS_DESC))) %>% 
  select(-c(count)) %>% 
  mutate(OFNS_DESC = fct_collapse(OFNS_DESC,
                                  "assault" = c("assault 3 & related offenses", 
                                                "felony assault"),
                                  "crime related to children" = c("child abandonment/non support",
                                                                  "offenses related to children"),
                                  "drug dealing" = c("dangerous drugs",
                                                     "loitering for drug purposes"),
                                  "fraud" = c("frauds",
                                              "fraudulent accosting",
                                              "theft-fraud",
                                              "gambling"),
                                  "gambling" = c("gambling",
                                                 "loitering/gambling (cards, dice, etc)"),
                                  "grand larceny" = c("grand larceny",
                                                      "grand larceny of motor vehicle"),
                                  "harassment" = c("forcible touching",
                                                   "harassment"),
                                  "kidnapping" = c("kidnapping & related offenses"),
                                  "criminal mischief" = c("criminal mischief & related offenses"),
                                  "murder" = c("murder & non-negl. manslaughter"),
                                  "offenses against public safety" = c("off. agnst pub ord sensblty &",
                                                                       "offenses against public administration",
                                                                       "offenses against public safety",
                                                                       "offenses against the person"),
                                  "offenses state_law" = c("other state laws",
                                                           "other state laws (non penal law)"),
                                  "petit" = c("petit larceny",
                                              "possession of stolen property"),
                                  "prostitution" = c("prostitution & related offenses"),
                                  "theft" = c("other offenses related to theft"),
                                  "violate traffic laws" = c("intoxicated & impaired driving",
                                                             "other traffic infraction",
                                                             "unauthorized use of a vehicle 3 (uuv)",
                                                             "vehicle and traffic laws"))) %>% 
  mutate(ARREST_DATE = as.character(ARREST_DATE) %>% as.Date("%m/%d/%Y")) %>% 
  filter(AGE_GROUP %in% c("<18", "18-24", "25-44", "45-64", "65+")) %>% 
  filter(ARREST_DATE >= as.Date("2013-01-01"))

save(arrest.cleaned, file = "/Users/ruozhou_zhang/Documents/statistic_S02/GR5243_Applied_Data_Science/Spring2020-Project2-group-2/output/arrest_cleaned.RData")
