---
title: 使用vioplot包绘制小提琴图
date: '2020-10-05'
slug: violin-plot-with-the-vioplot-package
---

小提琴图对于比较几个组的分布情况很有用。我强烈建议使用`ggplot2`来绘制，但如果你不想使用，`vioplot`包也是一个替代方案。

`vioplot`包其实是将小提琴图绘制为一个箱型图，然后每边有一个旋转的核密度图。如果你想进行分组，可以使用`with()`函数，如下所示。

```R
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
```

![](https://db.songqi.online/violin-plot-with-the-vioplot-package.png)
