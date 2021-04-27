library(tidyverse)

temp <- tempfile()
download.file("https://www.ons.gov.uk/file?uri=/methodology/classificationsandstandards/standardoccupationalclassificationsoc/standardoccupationalclassificationsocextensionproject/soc2020extendedframeworkforpublishing08042021.xlsx",
              temp)
df <- readxl::read_excel(temp)

tidy <- naniar::replace_with_na(df, list(
  `Major Group` = "'",
  `Sub-Major Group` = "'",
  `Minor Group` = "'",
  `Unit Group` = "'",
  `Sub-Unit Group` = "'"
  )) %>%
  # The structure of the spreadsheets means sequential fills are required.
  fill(
    `Major Group`
  ) %>%
  group_by(`Major Group`) %>%
  fill(
    `Sub-Major Group`
  ) %>%
  group_by(`Sub-Major Group`) %>%
  fill(
    `Minor Group`
  ) %>% 
  group_by(`Minor Group`) %>%
  fill(
    `Unit Group`
  ) %>%
  # Some titles are repeated but given different notations, so need something
  # else to create a unique composite key.
  mutate(row = row_number()) %>%
  pivot_longer(cols=c(`Major Group`, `Sub-Major Group`, `Minor Group`,
                      `Unit Group`, `Sub-Unit Group`)) %>%
  filter(`Group Title` != "'", !is.na(value)) %>%
  rename(level = name, notation = value) %>%
  mutate(level = factor(level, levels = c("Major Group", "Sub-Major Group",
                                          "Minor Group", "Unit Group",
                                          "Sub-Unit Group"))) %>%
  group_by(`Group Title`, row) %>%
  filter(as.numeric(level) == max(as.numeric(level)) |
           as.numeric(level) == max(as.numeric(level)) - 1)

tidy <- tidy %>% 
  filter(as.numeric(level) == max(as.numeric(level))) %>%
  left_join(tidy %>% 
              filter(as.numeric(level) == min(as.numeric(level))), by = c("Group Title", "row")) %>%
  ungroup() %>%
  select(`Group Title`, Notation = notation.x, Parent = notation.y) %>%
  mutate(Parent = case_when(
    Parent == Notation ~ NA_character_,
    TRUE ~ Parent))

tidy %>% write_csv("~/Documents/projects/soc-csvw/soc-2020-extended-framework.csv", na = "")
