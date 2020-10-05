# 001. violin
if (F) {
  # Libraries
  library(tidyverse)
  library(hrbrthemes)
  library(viridis)

  # Load dataset
  data <-
    read.table(
      "https://db.songqi.online/probly.csv",
      header = TRUE,
      sep = ","
    )
  data <- data %>%
    gather(key = "text", value = "value") %>%
    mutate(text = gsub("\\.", " ", text)) %>%
    mutate(value = round(as.numeric(value), 0)) %>%
    filter(
      text %in% c(
        "Almost Certainly",
        "Very Good Chance",
        "We Believe",
        "Likely",
        "About Even",
        "Little Chance",
        "Chances Are Slight",
        "Almost No Chance"
      )
    )

  # Plot
  data %>%
    mutate(text = fct_reorder(text, value)) %>%
    ggplot(aes(
      x = text,
      y = value,
      fill = text,
      color = text
    )) +
    geom_violin(width = 2.1, size = 0.2) +
    scale_fill_viridis(discrete = TRUE) +
    scale_color_viridis(discrete = TRUE) +
    theme_ipsum() +
    theme(legend.position = "none") +
    coord_flip() +
    xlab("") +
    ylab("Assigned Probability (%)")

  ggsave("./static/figures/violin-1.png")


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

  # Sample size
  sample_size = data %>% group_by(name) %>% summarize(num = n())

  # Plot
  data %>%
    left_join(sample_size) %>%
    mutate(myaxis = paste0(name, "\n", "n=", num)) %>%
    ggplot(aes(x = myaxis, y = value, fill = name)) +
    geom_violin(width = 1.4) +
    geom_boxplot(width = 0.1,
                 color = "grey",
                 alpha = 0.2) +
    scale_fill_viridis(discrete = TRUE) +
    theme_ipsum() +
    theme(legend.position = "none",
          plot.title = element_text(size = 11)) +
    ggtitle("A Violin wrapping a boxplot") +
    xlab("")

  ggsave("./static/figures/violin-2.png")

  # Load dataset
  data <-
    read.table(
      "https://db.songqi.online/one-num-sev-cat-subgroups-sev-obs.csv",
      header = T,
      sep = ","
    ) %>%
    mutate(tip = round(tip / total_bill * 100, 1))

  # Grouped
  data %>%
    mutate(day = fct_reorder(day, tip)) %>%
    mutate(day = factor(day, levels = c("Thur", "Fri", "Sat", "Sun"))) %>%
    ggplot(aes(fill = sex, y = tip, x = day)) +
    geom_violin(position = "dodge",
                alpha = 0.5,
                outlier.colour = "transparent") +
    scale_fill_viridis(discrete = T, name = "") +
    theme_ipsum()  +
    xlab("") +
    ylab("Tip (%)") +
    ylim(0, 40)

  ggsave("./static/figures/violin-3.png")


  # Load dataset
  data <-
    read.table("https://db.songqi.online/probly.csv",
               header = TRUE,
               sep = ",")
  data <- data %>%
    gather(key = "text", value = "value") %>%
    mutate(text = gsub("\\.", " ", text)) %>%
    mutate(value = round(as.numeric(value), 0)) %>%
    filter(
      text %in% c(
        "Almost Certainly",
        "Very Good Chance",
        "We Believe",
        "Likely",
        "About Even",
        "Little Chance",
        "Chances Are Slight",
        "Almost No Chance"
      )
    )

  library(ggridges)

  data %>%
    mutate(text = fct_reorder(text, value)) %>%
    ggplot(aes(y = text, x = value,  fill = text)) +
    geom_density_ridges(alpha = 0.6, bandwidth = 4) +
    scale_fill_viridis(discrete = TRUE) +
    scale_color_viridis(discrete = TRUE) +
    theme_ipsum() +
    theme(
      legend.position = "none",
      panel.spacing = unit(0.1, "lines"),
      strip.text.x = element_text(size = 8)
    ) +
    xlab("") +
    ylab("Assigned Probability (%)")

  ggsave("./static/figures/violin-4.png")
}
# 002. most-basic-violin-plot-with-ggplot2
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
# 003. reorder-a-variable-with-ggplot2
if (F) {
  # Library
  library(ggplot2)
  library(dplyr)

  # Dataset 1: one value per group
  data <- data.frame(
    name = c(
      "north",
      "south",
      "south-east",
      "north-west",
      "south-west",
      "north-east",
      "west",
      "east"
    ),
    val = sample(seq(1, 10), 8)
  )

  # Dataset 2: several values per group (natively provided in R)
  mpg

  # load the library
  library(forcats)

  # Reorder following the value of another column:
  p1 <- data %>%
    mutate(name = fct_reorder(name, val)) %>%
    ggplot(aes(x = name, y = val)) +
    geom_bar(
      stat = "identity",
      fill = "#f68060",
      alpha = .6,
      width = .4
    ) +
    coord_flip() +
    xlab("") +
    theme_bw()

  # Reverse side
  p2 <- data %>%
    mutate(name = fct_reorder(name, desc(val))) %>%
    ggplot(aes(x = name, y = val)) +
    geom_bar(
      stat = "identity",
      fill = "#f68060",
      alpha = .6,
      width = .4
    ) +
    coord_flip() +
    xlab("") +
    theme_bw()

  library(patchwork)
  ggsave("./static/figures/reorder-a-variable-with-ggplot2-1.png", plot = p1+p2, height = 4)

  # Using median
  p1 <- mpg %>%
    mutate(class = fct_reorder(class, hwy, .fun = 'median')) %>%
    ggplot(aes(
      x = reorder(class, hwy),
      y = hwy,
      fill = class
    )) +
    geom_boxplot() +
    xlab("class") +
    theme(legend.position = "none") +
    xlab("") +
    theme_bw() +
    guides(fill=F)

  # Using number of observation per group
  p2 <- mpg %>%
    mutate(class = fct_reorder(class, hwy, .fun = 'length')) %>%
    ggplot(aes(x = class, y = hwy, fill = class)) +
    geom_boxplot() +
    xlab("class") +
    theme(legend.position = "none") +
    xlab("") +
    xlab("") +
    theme_bw() +
    guides(fill=F)

  ggsave("./static/figures/reorder-a-variable-with-ggplot2-2.png", plot = p1+p2, height = 4)

  # Reorder following a precise order
  p <- data %>%
    mutate(
      name = fct_relevel(
        name,
        "north",
        "north-east",
        "east",
        "south-east",
        "south",
        "south-west",
        "west",
        "north-west"
      )
    ) %>%
    ggplot(aes(x = name, y = val)) +
    geom_bar(stat = "identity") +
    xlab("") +
    theme_bw()
  p
  ggsave("./static/figures/reorder-a-variable-with-ggplot2-3.png", plot = p, height = 4, width = 4)

  p1 <- data %>%
    arrange(val) %>%    # First sort by val. This sort the dataframe but NOT the factor levels
    mutate(name = factor(name, levels = name)) %>%   # This trick update the factor levels
    ggplot(aes(x = name, y = val)) +
    geom_segment(aes(xend = name, yend = 0)) +
    geom_point(size = 4, color = "orange") +
    coord_flip() +
    theme_bw() +
    xlab("")

  p2 <- data %>%
    arrange(val) %>%
    mutate(name = factor(
      name,
      levels = c(
        "north",
        "north-east",
        "east",
        "south-east",
        "south",
        "south-west",
        "west",
        "north-west"
      )
    )) %>%
    ggplot(aes(x = name, y = val)) +
    geom_segment(aes(xend = name, yend = 0)) +
    geom_point(size = 4, color = "orange") +
    theme_bw() +
    xlab("")

  ggsave("./static/figures/reorder-a-variable-with-ggplot2-4.png", plot = p1+p2, height = 4)

  # reorder is close to order, but is made to change the order of the factor levels.
  mpg$class = with(mpg, reorder(class, hwy, median))

  p <- mpg %>%
    ggplot(aes(x = class, y = hwy, fill = class)) +
    geom_violin() +
    xlab("class") +
    theme(legend.position = "none") +
    xlab("") +
    theme_bw() +
    guides(fill=F)
  p

  ggsave("./static/figures/reorder-a-variable-with-ggplot2-5.png", plot = p, height = 4, width = 4)
}
# 004. violin-plot-with-included-boxplot-and-sample-size-in-ggplot2
if (F) {
  # Libraries
  library(ggplot2)
  library(dplyr)
  library(hrbrthemes)
  library(viridis)

  # create a dataset
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

  # sample size
  sample_size = data %>% group_by(name) %>% summarize(num = n())

  # Plot
  data %>%
    left_join(sample_size) %>%
    mutate(myaxis = paste0(name, "\n", "n=", num)) %>%
    ggplot(aes(x = myaxis, y = value, fill = name)) +
    geom_violin(width = 1.4) +
    geom_boxplot(width = 0.1,
                 color = "grey",
                 alpha = 0.2) +
    scale_fill_viridis(discrete = TRUE) +
    theme_ipsum() +
    theme(legend.position = "none",
          plot.title = element_text(size = 11)) +
    ggtitle("A Violin wrapping a boxplot") +
    xlab("")

  ggsave("./static/figures/violin-plot-with-included-boxplot-and-sample-size-in-ggplot2.png", height = 6)
}
# 005. violin-plot-with-the-vioplot-package
if (F) {
  # Load the vioplot library
  library(vioplot)

  # Create data
  treatment <- c(rep("A", 40) , rep("B", 40) , rep("C", 40))
  value <-
    c(sample(2:5, 40 , replace = T) ,
      sample(c(1:5, 12:17), 40 , replace = T),
      sample(1:7, 40 , replace = T))
  data <- data.frame(treatment, value)

  # Draw the plot
  with(data , vioplot(
    value[treatment == "A"] ,
    value[treatment == "B"],
    value[treatment == "C"],
    col = rgb(0.1, 0.4, 0.7, 0.7) ,
    names = c("A", "B", "C")
  ))
}
