---
title: 用ggplot2绘制水平小提琴图
date: '2020-10-05'
slug: horizontal-violin-plot-with-ggplot2
---

小提琴图对于查看几个组的分布情况很有用。但有时候为了增加标签的可读性，所以绘制水平版本的小提琴图是有意义的：标签变得更易读。

有了`geom_violin()`函数，使用`ggplot2`绘制一个小提琴图是非常直接的。在这里，调用`coord_flip()`可以翻转X轴和Y轴，从而得到一个水平版本的小提琴图。此外，注意使用了`hrbrthemes`包的`theme_ipsum()`函数对图形外观进行了美化。

```R
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
```

![](https://db.songqi.online/violin-1.png)
