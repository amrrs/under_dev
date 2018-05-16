
#install.packages(tiobeindexr)

library(tiobeindexr)


hall_of_fame()

top_20()

library(tidyverse)

top_20() %>% 
  mutate(Change = as.numeric(gsub('%','',Change))) %>% 
  ggplot(aes(x = reorder(`Programming Language`,Change), y = Change, 
         fill = `Programming Language`,
         label = paste0(Change, "%"))) + 
  geom_col() +
  coord_flip() +
  geom_text(nudge_x = 0.1) +
  xlab('Programming Language') +
  ggtitle('Programming Langauges Change from May')
