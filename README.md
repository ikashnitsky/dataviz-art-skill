# <img src="https://i.imgur.com/lLufdBo.png" align="right" width="177" height="177" />   Data Visualization – the Art/Skill Cocktail 

In the ever-growing universe of dry academic texts, impressive and efficient graphics are quite rare. Driven by widespread software legacy issues and mostly outdated limitations imposed by traditional scientific publishers, researchers often consider producing high quality graphics as a peripheral optional task – “if time allows” (spoiler: it won’t). Yet, modern tools place data visualization in the focus of research workflows when it comes to conveying the results. Hence, the ability to turn a large dataset into an insightful visualization is an increasingly valuable skill in academia.

The course aims to empower the participants with the flexibility that the R+tidyverse framework gives to visualize data (the practical examples mostly use demographic data). The course covers some aspects of data visualization theory and best/worst practice examples, but it's primarily practice oriented including live coding sessions and short lecture/showcase parts.

Practical coding sessions start from basic introduction to tidy data manipulation and ggplot2 basics. Next, practical examples cover the creation of certain most useful types of plots. Important data visualization choices and caveats are discussed along the way. Special attention is devoted to producing geographical maps, which are no longer the luxury of professional cartographers but have turned, with the help of R, into yet another data visualization type. Going beyond ggplot2, the course presents an introduction to interactive data visualization.

# Course Twitter account: [@DatavizArtSkill](https://twitter.com/DatavizArtSkill)
# Video lectures: https://bit.ly/dataviz-art-skill

# Prerequisites
- [R](https://cloud.r-project.org)  
- [Rstudio](https://www.rstudio.com/products/rstudio/download/#download)  
- [Git](https://git-scm.com/downloads) ([help page](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN))
- [R {packages}](/day1/install-pkg.R)
- Basic familiarity with R, consider [RStudio Primers](https://rstudio.cloud/learn/primers)


# Outline

### Day 1: BASICS
- Basic dataviz principles ([slides][slides-gg])
- Impressive dataviz showcases
- Tidy approach to data

### Day 2: TUNE-UP
- {ggplot2} basics
- Colors in dataviz
- Themes and fonts

### Day 3: TOOLBOX
- Useful types of plots
- Dotplots – the most neglected and powerful type of dataviz
- Heatmaps, equality-line, ggridges, treemap

### Day 4: MAPS
- The basics of map projections ([slides][slides-map])
- {sf} – the game changer in #rspatial, `geom_sf`
- Useful spatial processing tricks

### Day 5: ROCK
- Creative legends: {biscale}, {tricolore}
- Interactivity: {plotly}, {gganimate}
- Intro to {shiny}


# Links


[slides-gg]: https://ikashnitsky.github.io/share/2106-mpidr-dataviz/slides-dataviz.html#/
[slides-map]: https://ikashnitsky.github.io/share/2106-mpidr-dataviz/slides-maps.html#/