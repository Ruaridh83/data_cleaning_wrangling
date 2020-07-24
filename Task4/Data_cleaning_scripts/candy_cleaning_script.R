---
  title: "candy"
output: html_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```


```{r}
library(readxl)
```

```{r}
library(here)
library(tidyverse)
library(janitor)
```

```{r}
candy_2015 <- read_excel(here("Raw_data/boing-boing-candy-2015.xlsx"))

```

```{r}
candy_2016 <- read_excel(here("Raw_data/boing-boing-candy-2016.xlsx"))
```

```{r}
candy_2017 <- read_excel(here("Raw_data/boing-boing-candy-2017.xlsx"))
```

#Tidying up the column names so they're consistent across all three and easier to work with. 

```{r}
candy_2015 <- clean_names(candy_2015)
candy_2016 <- clean_names(candy_2016)
candy_2017 <- clean_names(candy_2017)
```
#pivoting long, realised after the fact this was probably too early in the process to do this
#did it later in the following years
```{r}
candy_2015_long <- candy_2015 %>%
  pivot_longer(cols = c("butterfinger":"york_peppermint_patties"), 
               names_to = "candy_type",
               values_to = "description")

```

#lots of useless columns that began with please so removed them, wasn't using class notes
#effectively so googled this solution

```{r}
candy_2015_long <- candy_2015_long[grep("^please", colnames(candy_2015_long), invert = TRUE)]
candy_2015_long
```
#removing more extra columns

```{r}
candy_2015_long <- select(candy_2015_long, -guess_the_number_of_mints_in_my_hand,  -check_all_that_apply_i_cried_tears_of_sadness_at_the_end_of, 
                          -that_dress_that_went_viral_early_this_year_when_i_first_saw_it_it_was, 
                          -fill_in_the_blank_taylor_swift_is_a_force_for, 
                          -what_is_your_favourite_font, 
                          -if_you_squint_really_hard_the_words_intelligent_design_would_look_like, 
                          -fill_in_the_blank_imitation_is_a_form_of,
                          -sea_salt_flavored_stuff_probably_chocolate_since_this_is_the_it_flavor_of_the_year,
                          -necco_wafers, -which_day_do_you_prefer_friday_or_sunday)
```

#more extra columns coming out
```{r}
candy_2015_long <- select(candy_2015_long, -timestamp, -betty_or_veronica)

candy_2015_long
```

#renaming columns so they match across all the years
```{r}
candy_2015_long <- rename(candy_2015_long, age = how_old_are_you)
```

```{r}
candy_2015_long <- rename(candy_2015_long, Trick_or_treat = are_you_going_actually_going_trick_or_treating_yourself)
```

#adding in a country column because i'll need that to bind the three years on top of each other later. 

```{r}
candy_2015_long <- mutate(
  candy_2015_long, country = "n/a"
)
```

#adding in a gender column because i'll need that too

```{r}
candy_2015_long <- mutate(
  candy_2015_long, gender = "n/a"
)
```
#and a county column

```{r}
candy_2015_long <- mutate(
  candy_2015_long, county = "n/a"
)
```

#moving to the 2016 data
#starting with renaming columns this time

```{r}
candy_2016 <- candy_2016 %>% 
  rename(trick_or_treat = are_you_going_actually_going_trick_or_treating_yourself) 
```

```{r}
candy_2016 <- candy_2016 %>% 
  rename(gender = your_gender) 
```

```{r}
candy_2016 <- candy_2016 %>% 
  rename(age = how_old_are_you) 
```

#startign to remove useless column names

```{r}
candy_2016 <-
  select(candy_2016, -timestamp, -york_peppermint_patties_ignore, -which_day_do_you_prefer_friday_or_sunday)

```
#removing all those columns that start with please
```{r}
candy_2016 <- candy_2016[grep("^please", colnames(candy_2016), invert = TRUE)]
candy_2016
```
#renaming country column to match 2015
```{r}
candy_2016 <- candy_2016 %>% 
  rename(country = which_country_do_you_live_in)

```
#renaming state column to match 2015

```{r}
candy_2016 <- candy_2016 %>% 
  rename(county = state)
```
#pivoting longer to get each variable into a row

```{r}
candy_2016_longer <- candy_2016 %>%
  pivot_longer(cols = c("x100_grand_bar":"york_peppermint_patties"), 
               names_to = "candy_type",
               values_to = "description")

candy_2016_longer
```


```{r}
candy_2016_longer <- candy_2016_longer %>%
  pivot_longer(cols = c("x100_grand_bar":"boxo_raisins"), 
               names_to = "candy_type",
               values_to = "description")

candy_2016_longer
```

#removing more unwanted columns
```{r}
candy_2016_longer <-
  select(candy_2016_longer, trick_or_treat, gender, age, country, county, candy_type, description)
candy_2016_longer
```

```{r}
colnames(candy_2015_long)
```


#moving onto the 2017 data
#removing the column name suffixes

```{r}
candy_2017 <- candy_2017 %>% 
  rename_all(funs(str_replace(., "q6_", ""))) %>%
  rename_all(funs(str_replace(., "q5_", ""))) %>%
  rename_all(funs(str_replace(., "q4_", ""))) %>%
  rename_all(funs(str_replace(., "q3_", ""))) %>%
  rename_all(funs(str_replace(., "q2_", ""))) %>%
  rename_all(funs(str_replace(., "q1_", ""))) %>%
  rename_all(funs(str_replace(., "q7_", ""))) %>%
  rename_all(funs(str_replace(., "q8_", ""))) %>%
  rename_all(funs(str_replace(., "q9_", ""))) %>%
  rename_all(funs(str_replace(., "q10_", ""))) %>%
  rename_all(funs(str_replace(., "q11_", ""))) %>%
  rename_all(funs(str_replace(., "q12_", ""))) 

```

#renaming some columns to match 2015 & 2016

```{r}
candy_2017 <- candy_2017 %>% 
  rename(state = state_province_county_etc) 
```

```{r}
candy_2017 <- candy_2017 %>%
  rename(x100_grand_bar = "100_grand_bar")
```
#starting to remove extra columns i don't need
```{r}
candy_2017 <-
  select(candy_2017, -timestamp, -york_peppermint_patties_ignore, -which_day_do_you_prefer_friday_or_sunday)
```

```{r}
candy_2017 <-
  select(candy_2017, -bonkers_the_board_game, -chick_o_sticks_we_don_t_know_what_that_is,  
         -creepy_religious_comics_chick_tracts, -dental_paraphenalia, -generic_brand_acetaminophen, 
         -glow_sticks, -gum_from_baseball_cards, -healthy_fruit, -hugs_actual_physical_hugs,                                        -real_housewives_of_orange_county_season_9_blue_ray, -sandwich_sized_bags_filled_with_boo_berry_crunch, 
         -vials_of_pure_high_fructose_corn_syrup_for_main_lining_into_your_vein, 
         -vicodin, -white_bread, -whole_wheat_anything, -joy_other, -despair_other, -other_comments, -dress, -x114, 
         -day, -media_daily_dish, -media_science, -media_espn, -media_yahoo, -click_coordinates_x_y)
```

```{r}
candy_2017 <-
  select(candy_2017, -internal_id)
```

```{r}
candy_2017 <- candy_2017 %>% 
  rename(toblerone = tolberone_something_or_other) %>%
  rename(sweetums = sweetums_a_friend_to_diabetes) %>%
  rename(sourpatch_kids = sourpatch_kids_i_e_abominations_of_nature) 


```

```{r}
colnames(candy_2017)
```
#renamed this column to match the others now all years now have the same columns plus 
#candy & candy details, time to pivot longer

```{r}
candy_2017 <- candy_2017 %>% 
  rename(county = state)
```


```{r}
candy_2017_long <- candy_2017 %>%
  pivot_longer(cols = c("x100_grand_bar":"york_peppermint_patties"), 
               names_to = "candy_type",
               values_to = "description")

candy_2017_long 
```
#running clean names again as had a few caps in the changes i'd made previously. 
```{r}
candy_2015_long <- clean_names(candy_2015_long)
candy_2016_longer <- clean_names(candy_2016_longer)
candy_2017_long <- clean_names(candy_2017_long)
```

```{r}
colnames(candy_2016_longer)
```
#had to go back and remove more useless columns

```{r}
candy_2016_longer <-
  select(candy_2016_longer, -when_you_see_the_above_image_of_the_4_different_websites_which_one_would_you_most_likely_check_out_please_be_honest, -do_you_eat_apples_the_correct_way_east_to_west_side_to_side_or_do_you_eat_them_like_a_freak_of_nature_south_to_north_bottom_to_top, -what_is_your_favourite_font, -betty_or_veronica, -guess_the_number_of_mints_in_my_hand)
```

```{r}
candy_2016_longer <-
  select(candy_2016_longer, -that_dress_that_went_viral_a_few_years_back_when_i_first_saw_it_it_was)
```
#to match the other years
```{r}
candy_2016_longer <- candy_2016_longer %>% 
  rename(county = state)
```

```{r}
candy_2017_long <- candy_2017_long %>% 
  rename(trick_or_treat = going_out)
```

```{r}
candy_all <- bind_rows(candy_2015_long, candy_2016_longer, candy_2017_long)
```

```{r}
candy_all
table(candy_all$country)
```

```{r}
candy_all
```

```{r}
write_csv(candy_all, here("Clean_data/candy_all.csv"))

```


