# Violin
# Libraries
library(tidyverse)
library(hrbrthemes)
library(viridis)

# Load dataset from github
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

# Load dataset from github
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





