library(lme4)
library(lmerTest)
library(emmeans)
library(sjPlot)
library(sjmisc)
library(ggplot2)
library(extdplyr)
library(Jmisc)
library(reshape2)
library(Hmisc)
library(RColorBrewer)
library(ggpubr)
library(PupillometryR)
library(plyr)
library(dplyr)
library(gganimate)
library(ggimage)

path_root = here::here("")
setwd(path_root)
figpath = here::here("paper-repo/figures/Beta_Animation/")

#### TTheme
raincloud_theme = theme(
  text = element_text(size = 12),
  axis.title.x = element_text(size = 18),
  axis.title.y = element_text(size = 18),
  axis.text = element_text(size = 14),
  axis.text.x = element_text(angle = 0, vjust = 0.5),
  legend.title=element_text(size=16),
  legend.text=element_text(size=16),
  legend.position = "right",
  plot.title = element_text(lineheight=.8, face="bold", size = 16),
  panel.border = element_blank(),
  panel.grid.minor = element_blank(),
  panel.grid.major = element_blank(),
  axis.line.x = element_line(colour = 'black', size=0.5, linetype='solid'),
  axis.line.y = element_line(colour = 'black', size=0.5, linetype='solid'),
  # Spacing between legends. 
  #:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  legend.spacing = unit(0.4, "cm"), 
  legend.spacing.x = NULL,                 # Horizontal spacing
  legend.spacing.y = NULL,                 # Vertical spacing
  
  # Legend box
  #:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  # Arrangement of multiple legends ("horizontal" or "vertical")
  legend.box = NULL, 
  # Margins around the full legend area
  legend.box.margin = margin(0, 0, 0, 0, "cm"), 
  # Background of legend area: element_rect()
  legend.box.background = element_blank(), 
  # The spacing between the plotting area and the legend box
  legend.box.spacing = unit(0.4, "cm")
  
)


#### Define 1-state model
beta1state <- function(o,p) {
  c =1

  P = rep(0,1,length(o))
  al = rep(p$al0,1,length(o))
  be = rep(p$be0,1,length(o))
  for (i in o) {
      P[c] = (al[c] - 1) / (al[c] + be[c] - 2)
      if (i == 1) {
          al[c+1] = p$lambda*(al[c] + p$t_nosh)
          be[c+1] = p$lambda*(be[c])
      } else if (i == 0) {
          be[c+1] = p$lambda*(be[c] + p$t_sh)
          al[c+1] = p$lambda*(al[c])
      }
    c = c+1;
  }
  df <- data.frame(o=o, p=P, al=al[1:length(al)-1], be=be[1:length(be)-1])
  
  return(df)
}


### Generate 1-state model predictions
p$al0 = 2
p$be0 = 2
p$t_sh = 1
p$t_nosh = 1
p$eta = 3 
p$lambda = 0.95
o<- c(rbinom(n=8, size=1, prob=0.1), rbinom(n=8, size=1, prob=0.9))# , rbinom(n=8, size=1, prob=0.1))
df_b <- beta1state(o,p)

### Genreate DF to plot animation
df <- data.frame()
l=50
x <- seq(0,1,length=l)
for (i in  1:dim(df_b)[1]) {
  df <- rbind(df, data.frame(x=x, 
                             y=dbeta(x,df_b$al[i],df_b$be[i]), 
                             alpha = df_b$al[i],
                             beta = df_b$be[i],
                             mode=rep(((df_b$al[i]-1)/(df_b$be[i]+df_b$al[i]-2)),l), 
                             ymax=rep(max(dbeta(df_b$al[i],df_b$be[i],i)),l),
                             al = rep(df_b$al[i],l),
                             be = rep(df_b$be[i],l),
                             o = rep(df_b$o[i],l),
                             turn=rep(i,l))
                    )
}

df$outs_str <- mapvalues(df$o,
                      from = c(0,1),
                      to = c("No-Shock", "Shock"))
df$out_img <- mapvalues(df$o,
                         from = c(0,1),
                         to = c(paste0(figpath, "noshock.svg"), paste0(figpath, "shock.svg")))

df_red = df %>%
  group_by(outs_str,out_img,o, turn, alpha, beta) %>%
  summarise_at(c("x", "y"), mean, na.rm = TRUE)
df_red$x_lab = 1.03
df_red$y_lab = 3


b <- ggplot(data=df,mapping=aes(x=x, y=y)) +
  geom_line()+
  #geom_line(aes(x=x, y=turn-1)) +
  geom_area(fill="#9838fb", alpha=0.2) +
  geom_point(aes(x=mode, y=ymax+1*(turn-1))) +
  geom_label(data=df_red, aes(x=o, y=turn, label = outs_str)) +
  #geom_image(data=df_red, aes(x=o, y=turn, image=out_img), size=0.1) +
  
  theme(
    text = element_text(size = 12),
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text = element_text(size = 14),
    axis.text.x = element_text(angle = 0, vjust = 0.5)) + 
  #geom_text(aes(outs_str)) +
  labs(y= "Trials", x="Shock Probability") +
  transition_states(turn,
                    transition_length = 0,
                    state_length = 2) 

animate(b + shadow_mark(alpha = 0.01, size = 1), renderer=magick_renderer(loop = TRUE))
