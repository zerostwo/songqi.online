---
title: 用ggplot2对小提琴图进行分组
date: '2020-10-05'
slug: grouped-violin-chart-with-ggplot2
---

这是普通小提琴图的扩展，分组小提琴图展示了变量在组和子组中的分布。下面这个例子中，组是一周中的几天，子组是男性和女性。由于`geom_violin()`函数的`position="dodge"`选项，`ggplot2`允许这种表示方式。组必须提供给x，子组必须提供`fill`。

```R
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
 ```

![](https://db.songqi.online/violin-3.png)
