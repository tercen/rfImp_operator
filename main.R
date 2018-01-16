library(tercen)
library(dplyr)
library(reshape2)
library(ranger)
 
do.unique = function(df){
  result = unique(df)
  if (dim(result)[1] > 1) stop('One color per column is required')
  return (result %>% select_(.dots = ("-.ci")))
}

ctx = tercenCtx()

if (length(ctx$colors) < 1) stop("A color factor is required.")

pred.table = ctx$select(unlist(list(ctx$colors, '.ci')))  %>% 
  group_by(.ci) %>% 
  do(do.unique(.)) 
  
table = as.data.frame(ctx %>% select(.ci, .ri, .y) %>%
                        reshape2::acast(.ci ~ .ri, value.var='.y', fun.aggregate=mean)) %>%
  rename_all(.funs=function(cname) paste0('c', cname)) %>%
  mutate(.pred = do.call(function(...) paste(..., sep='.'), pred.table [ctx$colors]))

rf = ranger(.pred ~ ., data = table, importance='impurity')
 
imp.table = data.frame(.ri=seq(from=0, to=length(rf$variable.importance)- 1),
                       rfImp = rf$variable.importance) %>% 
  ctx$addNamespace()
 
pred.table = data.frame(rfError=c(rf$prediction.error)) %>% 
  ctx$addNamespace()
 
ctx$save(list(imp.table, pred.table))



