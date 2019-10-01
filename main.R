library(tercen)
library(dplyr)
library(reshape2)
library(ranger)
 

do.unique = function(df){
  result = unique(df)
  if (dim(result)[1] > 1) stop('One label is required')
  return (result %>% select_(.dots = ("-.ci")))
}

set.seed(42)
ctx = tercenCtx()

if (length(ctx$labels) < 1) stop("One or more label factors are required.")

pred.table = ctx$select(unlist(list(ctx$labels, '.ci')))  %>% 
  group_by(.ci) %>% 
  do(do.unique(.)) 
  
table = as.data.frame(ctx %>% select(.ci, .ri, .y) %>%
                        reshape2::acast(.ci ~ .ri, value.var='.y', fun.aggregate=mean)) %>%
  rename_all(.funs=function(cname) paste0('c', cname)) %>%
  mutate(.pred = do.call(function(...) paste(..., sep='.'), pred.table [unlist(ctx$labels)]))

rf = ranger(.pred ~ ., data = table, importance='impurity')
 
imp.table = data.frame(.ri=seq(from=0, to=length(rf$variable.importance)- 1),
                       rfImp = -rf$variable.importance) %>% 
  ctx$addNamespace()

pred.error  <- rf$prediction.error

cTable = tibble(.ci=seq.int(0,ctx$cschema$nRows-1)) %>% mutate(pred.error=pred.error)
rTable = tibble(.ri=seq.int(0,ctx$rschema$nRows-1)) %>% mutate(pred.error=pred.error)

pred.table <- cTable %>% full_join(rTable) %>%
  ctx$addNamespace()
 
ctx$save(list(imp.table, pred.table))



