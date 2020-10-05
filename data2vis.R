# Violin
if (F) {
  ## 01. Basic violin plot
  # Library
  library(ggplot2)

  # Create a dataset
  data <- data.frame(
    name = c(
      rep("A", 500),
      rep("B", 500),
      rep("B", 500),
      rep("C", 20),
      rep('D', 100)
    ),
    value = c(
      rnorm(500, 10, 5),
      rnorm(500, 13, 1),
      rnorm(500, 18, 1),
      rnorm(20, 25, 4),
      rnorm(100, 12, 1)
    )
  )

  # Most basic violin chart
  # fill=name allow to automatically dedicate a color for each group
  p <- ggplot(data, aes(x = name, y = value, fill = name)) +
    geom_violin() + theme_bw()

  p

  ggsave("./static/figures/most-basic-violin-plot-with-ggplot2-1.png")


  ## 02. Note on input format
  library(tidyr)
  library(dplyr)

  # Let's use the iris dataset as an example:
  data_wide <- iris[, 1:4]
  data_long <- data_wide %>%
    gather(key = "MesureType", value = "Val")

  library(ggplot2)

  data_long %>%
    ggplot(aes(x = MesureType, y = Val, fill = MesureType)) +
    geom_violin() + theme_bw()

  ggsave("./static/figures/most-basic-violin-plot-with-ggplot2-2.png")
}





