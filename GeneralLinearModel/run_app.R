pkgs<-c('shiny', 'RColorBrewer', 'sciplot')
for (i in c(1:length(pkgs))){
  if(pkgs[i] %in% rownames(installed.packages()) == FALSE) {
    install.packages(pkgs[i])}
}
lapply(pkgs, require, character.only=T)

#!!!!!below in between the "" the path on your computer where you downloaded the app
runApp("~/R/GeneralLinearModel")

