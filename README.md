# rfImp operator

#### Description
`rfImp` operator computes random forest importance values for a given dataset

##### Usage
Input projection|.
---|---
`labels`   | indicates the groups to compare 
`row`  | indicates the variables (e.g. genes, markers) 
`col`  | indicates the observations (e.g. samples, cells, individuals) 
`y-axis`| measurement value

Output relations|.
---|---
` rfImp`| numeric, importance value calculated per row (i.e. variable)

##### Details
`rfImp` operator computes random forest importance values for each independant variable (i.e. row) of the dataset. An importance value is a value representing how important the variable is for the seperation of the groups. 


#### References
- Wright, M. N. & Ziegler, A. (2017). ranger: A fast implementation of random forests for high dimensional data in C++ and R. J Stat Softw 77:1-17. https://doi.org/10.18637/jss.v077.i01.
- see the `ranger::ranger` function of the R package for the documentation. 



##### See Also
[ttest](https://github.com/tercen/ttest_operator), [anova](https://github.com/tercen/anova_operator)

#### Examples


