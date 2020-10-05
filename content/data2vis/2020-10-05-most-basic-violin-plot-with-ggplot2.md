---
title: 用ggplot2绘制最基本的小提琴图
date: '2020-10-05'
slug: most-basic-violin-plot-with-ggplot2
---

小提琴图可以通过显示几个组的密度来比较它们的分布。请看下面如何用`R`的`ggplot2`包绘制它。在[Data2Vis](/data2vis/violin/)中了解更多关于小提琴图的介绍。

## 最基础的小提琴图

由于有专门的`geom_violin()`函数，使用`ggplot2`构建小提琴图是非常简单的。

```R
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
```

![](https://db.songqi.online/most-basic-violin-plot-with-ggplot2-1.png)

## 输入数据格式说明

`ggplot2`要求输入的数据格式是长类型（long format）的：每一行专门用于一个观测值，输入数据需要2列：

|name|value|
|:-:|:-:|
|A|11.02|
|A|5.54|
|A|18.05|
|A|6.57|

- X轴的分类变量：通常为因子型变量。
- Y轴的数字变量：通常为数值型变量。

但有时候我们拿到手的数据格式是宽类型的（wide format），

|Sepal.Length|Sepal.Width|Petal.Length|Petal.Width|
|:-:|:-:|:-:|:-:|
|5.1|3.5|1.4|0.2|
|4.9|3.0|1.4|0.2|
|4.7|3.2|1.3|0.2|
|4.6|3.1|1.5|0.2|

在这种情况下，我们需要对输入进行重新格式化。通常使用`tidyr`包的`gather()`函数将宽类型数据转化为长类型数据，它是[tidyverse](https://tidyverse.tidyverse.org/)的一部分。

```R
library(tidyr)
library(dplyr)

# Let's use the iris dataset as an example:
data_wide <- iris[, 1:4]
data_long <- data_wide %>%
  gather(key = "MesureType", value = "Val")
```

|MesureType|Val|
|:-:|:-:|
|Sepal.Length|5.1|
|Sepal.Length|4.9|
|Sepal.Length|4.7|
|Sepal.Length|4.6|


```R
library(ggplot2)

data_long %>%
  ggplot(aes(x = MesureType, y = Val, fill = MesureType)) +
  geom_violin() + theme_bw()
```

![](https://db.songqi.online/most-basic-violin-plot-with-ggplot2-2.png)
