---
title: 用ggplot2对变量进行重新排序
date: '2020-10-05'
slug: reorder-a-variable-with-ggplot2
---

在`ggplot2`绘制的图中重新排列组别顺序可能会很困难。这是由于`ggplot2`考虑的是因子级别的顺序，而不是你在数据框中看到的顺序。或许你说你可以用`sort()`或`arrange()`对你的输入数据框进行排序，但这样操作永远不会对你的`ggplot2`输出产生任何影响。

本篇文章通过几个例子来展示如何对因子的级别进行重新排序。示例基于以下2个数据集：

```R
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
```

## 法一：使用`forecats`包

[tidyverse](https://www.tidyverse.org/)众多包之一的[`forecats`包](https://github.com/tidyverse/forcats)是专门用来处理R中的因子。它提供了一些简单快捷的函数来解决因子的常见问题。`fct_reorder()`函数可以根据值的(这里是`data$val`)大小对因子(`data$name`)重新排序。

```R
# load the library
library(forcats)

# Reorder following the value of another column:
data %>%
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
data %>%
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
```

![](https://db.songqi.online/reorder-a-variable-with-ggplot2-1.png)

如果你的因子每个级别有几个值，你可以指定应用哪个函数来确定顺序。默认情况下是使用中位数，但你可以使用每组的数据点数量来进行分类。

```R
# Using median
mpg %>%
  mutate(class = fct_reorder(class, hwy, .fun = 'median')) %>%
  ggplot(aes(
    x = reorder(class, hwy),
    y = hwy,
    fill = class
  )) +
  geom_boxplot() +
  xlab("class") +
  theme(legend.position = "none") +
  xlab("")

# Using number of observation per group
mpg %>%
  mutate(class = fct_reorder(class, hwy, .fun = 'length')) %>%
  ggplot(aes(x = class, y = hwy, fill = class)) +
  geom_boxplot() +
  xlab("class") +
  theme(legend.position = "none") +
  xlab("") +
  xlab("")
```

![](https://db.songqi.online/reorder-a-variable-with-ggplot2-2.png)

最后一个常见的操作是使用`fct_relevel()`函数按照特定的顺序进行排序。

```R
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
```

<img align=center src="https://db.songqi.online/reorder-a-variable-with-ggplot2-3.png" width = 50% height = 50% />

## 法二：只使用`dplyr`包

`dplyr`包的`mutate()`函数允许创建一个新的变量或修改一个现有的变量。可以用它来重新创建一个具有特定顺序的因子。这里有两个例子。

- 第一个使用`arrange()`对你的数据进行排序，并按照这个所需的顺序对因子进行重新排序。
- 第二个为因子指定一个特定的顺序。

```R
data %>%
  # First sort by val. This sort the dataframe but NOT the factor levels
  arrange(val) %>%
  # This trick update the factor levels
  mutate(name = factor(name, levels = name)) %>%
  ggplot(aes(x = name, y = val)) +
  geom_segment(aes(xend = name, yend = 0)) +
  geom_point(size = 4, color = "orange") +
  coord_flip() +
  theme_bw() +
  xlab("")

data %>%
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
```

![](https://db.songqi.online/reorder-a-variable-with-ggplot2-4.png)

## 法三：使用R自带的`reorder()`函数


```R
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
```

<img align=center src="https://db.songqi.online/reorder-a-variable-with-ggplot2-5.png" width = 50% height = 50% />
