---
title: 包含箱型图和样本量的小提琴图
date: '2020-10-05'
slug: violin-plot-with-included-boxplot-and-sample-size-in-ggplot2
---

在小提琴图中加入一个箱型图，既可以看到数据的分布，也可以看到它的汇总统计，非常方便。此外，通常还会在X轴上添加各组的样本量。

使用`ggplot2`的`geom_violin()`函数先直接绘制一个小提琴图，然后可以使用`geom_boxplot()`，将会显示一个箱型图外。

此外，请注意一个小技巧，它允许在X轴上提供每个组的样本量：创建一个新的列，命名为`myaxis`，然后用于X轴。

```R
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
  ```

![](https://db.songqi.online/violin-plot-with-included-boxplot-and-sample-size-in-ggplot2.png)
