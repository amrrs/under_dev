#installing the required library
#install.packages('cowplot')


#loading the required libraries
library(cowplot)
library(ggplot2)

#building the first plot

plot_histogram_SL <- ggplot(iris) + 
  geom_histogram(aes(Sepal.Length))

#building the second plot

plot_histogram_PL <- ggplot(iris) + 
  geom_histogram(aes(Petal.Length))

#Arranging Multiple Plots

plot_grid(plot_histogram_PL,
          plot_histogram_SL,
          labels = c('Fig A','Fig B'),
          label_x = 0.2,
          nrow = 2)


