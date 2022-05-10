get_colors <- function(name) {
  if (name == "ond" ) {
    pal <- c(
      rgb(238, 35, 96, maxColorValue = 255), 
      rgb(245, 163, 188, maxColorValue = 255), 
      
      rgb(47, 94, 201, maxColorValue = 255),
      rgb(156, 177, 223, maxColorValue = 255),
      
      
      # more classical red/blue 
      #rgb(217, 67, 31, maxColorValue = 255), 
      #rgb(255, 144, 102, maxColorValue = 255), 
      
      #rgb(57, 55, 245, maxColorValue = 255),
      #rgb(126, 160, 255, maxColorValue = 255),
      
      rgb(68, 204, 125, maxColorValue = 255), #5
      rgb(130, 255, 175, maxColorValue = 255),
      
      rgb(251, 203, 51, maxColorValue = 255),
      rgb(255, 245, 144, maxColorValue = 255),
      
      rgb(85, 3, 67, maxColorValue = 255), #9
      rgb(222, 169, 210, maxColorValue = 255),
      
      rgb(6, 53, 74, maxColorValue = 255),
      rgb(162, 195, 210, maxColorValue = 255),
      
      rgb(214, 6, 124, maxColorValue = 255),
      rgb(242, 184, 217, maxColorValue = 255), #
      
      rgb(170, 0, 162, maxColorValue = 255),
      rgb(0, 159, 142, maxColorValue = 255),
      rgb(67,95,148, , maxColorValue = 255)
      
    )
    
  } else if  (name == "ond2") {
    pal <- c(
      "firebrick2", 
      "lightpink", 
      
      "navy",
      "dodgerblue1",
      
      "hotpink2", 
      "plum1",
      
      "steelblue3",
      "slategray1")

  } else if  (name == "ukr") {
    pal <- c(
      "deepskyblue1", #blue light
      "#0057B8",  #bluedarks
      
      "#FFD700", #yellow light
      "goldenrod2" #yellowdark
      )
    
  }
  return(pal)
}

#############3


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

assign_var_types <- function(dfloc, fields) {
  
  if ("trial_type_str" %in% fields) {dfloc$trial_type_str <- as.factor(dfloc$trial_type_str) }
  if ("rev_type_str" %in% fields) {dfloc$rev_type_str <- as.factor(dfloc$rev_type_str) }
  if ("phase_str" %in% fields) {dfloc$phase_str <- as.factor(dfloc$phase_str) }
  if ("half" %in% fields) {dfloc$half <- as.factor(dfloc$half) }
  if ("prepost" %in% fields) {dfloc$prepost <- as.factor(dfloc$prepost) }
  if ("outcome_str" %in% fields) {dfloc$outcome_str <- as.factor(dfloc$outcome_str) }
  if ("outc" %in% fields) {dfloc$outc <- as.factor(dfloc$outc) }
  if ("roi" %in% fields) {dfloc$roi <- as.factor(dfloc$roi) }
 # if ("drug_str" %in% fields) {dfloc$drug_str <- as.factor(dfloc$drug_str) }
  if ("group" %in% fields) {dfloc$group <- as.factor(dfloc$group) }
  if ("half_str" %in% fields) {dfloc$half_str <- as.factor(dfloc$half_str) }
  if ("model_str" %in% fields) {dfloc$model_str <- as.factor(dfloc$model_str) }
  if ("visit_str" %in% fields) {dfloc$visit_str <- as.factor(dfloc$visit_str) }
  if ("model" %in% fields) {dfloc$model <- as.factor(dfloc$model) }
  if ("id" %in% fields) {dfloc$id <- as.factor(dfloc$id) }
  if ("Session" %in% fields) { 
    dfloc$Session <- as.numeric(dfloc$Session) 
    dfloc <- dfloc %>% mutate(half = case_when(Session %in% c(1,2) ~ "first", Session %in% c(3,4) ~ "second"))
    dfloc$half <- as.factor(dfloc$half)
  }
  if ("STAI_state" %in% fields) { dfloc$sa <- as.numeric(dfloc$STAI_state)}
  if ("sa" %in% fields) { dfloc$sa <- demean(dfloc$sa)
        dfloc["sabin"]<-dicho(dfloc$sa)
        dfloc$sabin <- mapvalues(dfloc$sabin,
                                 from = c(0,1),
                                 to = c("lowStAnx", "hiStAnx"))}
  
                                  
  
  if ("pe" %in% fields) { dfloc$pe <- as.numeric(dfloc$pe) }
  if ("ta" %in% fields) {
    dfloc$ta <- as.numeric(dfloc$ta) 
    dfloc$ta_orig_scale <- dfloc$ta
    dfloc$ta <- demean(dfloc$ta)
    dfloc["tabin"]<-dicho(dfloc$ta)
    dfloc$tabin <- mapvalues(dfloc$tabin,
                             from = c(0,1),
                             to = c("lowAnx", "hiAnx"))
  }
  if ("sb" %in% fields ) {
      dfloc$sb <- mapvalues(dfloc$sb,
                             from = c(25,75),
                             to = c("lowSt", "hiSt"))
    
  }
  if ("order" %in% fields ) {
    dfloc$order_str <- mapvalues(dfloc$order,
                          from = c(1,2,3),
                          to = c("first", "second", "third"))
    
  }
  if ("cue" %in% fields ) {
    dfloc$cue_str <- mapvalues(dfloc$cue,
                          from = c(1,2,3),
                          to = c("stable-high", "stable-low", "reversal"))
    
  }
  if ("study" %in% fields ) {
    dfloc$study_str <- mapvalues(dfloc$study,
                                 from = c(1,2,3),
                                 to = c("s1", "s2","s3"))
    dfloc$study_str <- as.factor(dfloc$study_str)   
  }
  if ("Session" %in% fields ) {
  data$Session <- mapvalues(data$Session,
                            from = c(1,2,3,4),
                            to = c("s1", "s2","s3","s4"))
  }
  if ("visit" %in% fields ) {
    dfloc$visit_str <- mapvalues(dfloc$visit,
                          from = c(1,2,3),
                          to = c("v1", "v2","v3"))
    
  }
  if ("outc_pre" %in% fields ) {
    dfloc$outc_pre_str <- mapvalues(dfloc$outc_pre,
                                 from = c(0,1),
                                 to = c("nosh", "sh"))
    dfloc$outc_pre_str <- as.factor(dfloc$outc_pre_str)
    
  }
  
  if ("drug" %in% fields ) {
    dfloc$drug_str <- mapvalues(dfloc$drug,
                          from = c(0,1),
                          to = c("placebo", "losartan"))
    dfloc$drug_str <- as.factor(dfloc$drug_str)
    
  }
  if ("lrtype" %in% fields) {
    dfloc$lrtype <- as.factor(dfloc$lrtype)
  }
  
  if ("rev_type" %in% fields) {
    dfloc <- dfloc %>% mutate(rev_str =
                                case_when(rev_type %in% 1 ~ "acq", 
                                          rev_type %in% 2 ~ "ext")
    )
    dfloc$rev_str <- as.factor(dfloc$rev_str)}
  
  if ("rev_trl" %in% fields) {
    dfloc$rev_trl = as.numeric(dfloc$rev_trl)
    
  }
  
  if ("phase" %in% fields) {
    dfloc <- dfloc %>% mutate(phase_str =
                                case_when(phase %in% 1 ~ "acq", 
                                          phase %in% 2 ~ "ext")
    )
    dfloc$phase_str <- as.factor(dfloc$phase_str)}
  if ("winSize" %in% fields) {
    dfloc <- dfloc %>% mutate(winBinary =
                                case_when(winSize == 0 ~ "noWin", 
                                          winSize > 0 ~ "yesWin")
    )
    dfloc <- dfloc %>% mutate(winSizeCat =
                                case_when(winSize %in% c(1,2) ~ "1-2", 
                                          winSize %in% c(3,4) ~ "3-4",
                                          winSize %in% c(5,6) ~ "5-6",
                                          winSize %in% c(7,8,9) ~ "7+",)
    )
    dfloc$winSizeCat <- as.factor(dfloc$winSizeCat)
    dfloc$winBinary <- as.factor(dfloc$winBinary)}
  
  if ("shockSum" %in% fields) {
    dfloc <- dfloc %>% mutate(shockSumCat =
                                case_when(shockSum %in% c(0,1) ~ "0-1", 
                                          shockSum %in% c(2,3,4) ~ "2-4",
                                          shockSum %in% c(5,6,7) ~ "4+"))
    
  }
  
  
  
  
  return(dfloc)
}