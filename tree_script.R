setwd("/Users/d1794974/Documents/PhD/Wood_ants/bacterial_genomes/bcgTree")

# install ggtree 

# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install(version = "3.13")
# 
# BiocManager::install(c("ggtree"))

library(tidyverse)
library(ggtree)
library(ggrepel)
library(treeio)

# read in tree
tree <- read.tree("/Users/d1794974/Documents/PhD/Wood_ants/bacterial_genomes/bcgTree/results/RAxML_bestTree.final")
# basic plot
plot(tree)

# IMPORTANT WARNING: Sequences Isolate_14.faa and Isolate_28.faa are exactly identical


# IMPORTANT WARNING: Sequences Isolate_2.faa and Isolate_3.faa are exactly identical
# ggtree examples


ggtree(tree)
ggtree(tree, layout="roundrect")
ggtree(tree, layout="slanted")
ggtree(tree, layout="ellipse")
ggtree(tree, layout="circular")
ggtree(tree, layout="fan", open.angle=120)
ggtree(tree, layout="equal_angle")
ggtree(tree, layout="daylight")
ggtree(tree, branch.length='none')
ggtree(tree, layout="ellipse", branch.length="none")
ggtree(tree, branch.length='none', layout='circular')
ggtree(tree, layout="daylight", branch.length = 'none')

ggtree(tree) + scale_x_reverse()
ggtree(tree) + coord_flip()
ggtree(tree) + layout_dendrogram()
#ggplotify::as.ggplot(ggtree(x), angle=-30, scale=.9)
ggtree(tree, layout='slanted') + coord_flip()
ggtree(tree, layout='slanted', branch.length='none') + layout_dendrogram()
ggtree(tree, layout='circular') + xlim(-10, NA)
ggtree(tree) + layout_inward_circular()
ggtree(tree) + layout_inward_circular(xlim=15)

# unrooted
ggtree(tree, layout="daylight")
ggtree(tree, layout="equal_angle")

# The daylight method starts from an initial tree built by equal angle and iteratively improves it by 
#successively going to each interior node and swinging subtrees so that the arcs of “daylight” are equal 
#(Figure 4.2H). This method was firstly implemented in PAUP* (Wilgenbusch and Swofford 2003). https://yulab-smu.top/treedata-book/chapter4.html

# labels https://yulab-smu.top/treedata-book/faq.html#faq-label-truncated 
ggtree(tree, layout="daylight") +
  geom_tiplab(aes(angle=angle), color='blue') +
  theme_tree2(plot.margin=margin(80, 80, 80, 80)) +
  coord_cartesian(clip = 'off') 

# change tip labels
lb = get.tree(tree)$tip.label # get tip labels into labels object
d = data.frame(label=lb, newlab = paste(substring(lb, 9, 10)))

ggtree(tree, layout = "daylight") %<+% d + 
  geom_tiplab(aes(label=newlab)) 

ggtree(tree, layout="daylight") +
  geom_cladelabel(node=1, label="test label", angle=0, 
                  fontsize=8, offset=.5, vjust=.5)  

  geom_cladelabel(node=55, label='another clade', 
                  angle=-95, hjust=.5, fontsize=8)

