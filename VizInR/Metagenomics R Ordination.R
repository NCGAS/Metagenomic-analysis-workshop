#load data
Data=read.table("Phylum__fasta__STAMP_tabular.xls", header=TRUE, row.names = 1)
Meta=read.table("metadata.txt", header=TRUE)
groups=c("adult","baby","elderly","adult","adult","adult","elderly","adult","adult","adult","baby","adult","adult","baby","adult","adult","adult","adult")

#input data - missing data, categorical data
#confirm lack of catagorical data
summary(Data)

#transpose!
Data_t=as.data.frame(t(Data))
D2=cbind(Data_t, Meta[1:18,],groups)

#install of vegan
library(vegan)

#scaling with rda()
?rda

pca=rda(Data_t)

#plot
biplot(pca, display=c("sites","species"), type=c("points"))

#add labels, points, legend, envfit
points(pca, display=c("sites"), pch=20, col=factor(D2$Title))
points(pca, display=c("sites"), pch=20, col=factor(D2$Platform))
points(pca, display=c("sites"), pch=20, col=factor(D2$BioProject))
points(pca, display=c("sites"), pch=20, col=factor(D2$groups))

fit=envfit(pca, Data_t)
plot(fit, col="red",p.max=0.05)

#add ellipses
ordihull(pca,group = D2$groups)

#goodness of fit
#get proportion explained - scroll to importance of components
summary(pca)

#can also:
pca$CA$eig

biplot(pca, display=c("sites","species"), type=c("points"), xlab="PC1 (18.15%)", ylab="PC2 (12.4%)")
points(pca, display=c("sites"),pch=20, col=factor(D2$groups))

#show points
?points

fit=envfit(pca, Data_t)
plot(fit, col="red",p.max=0.05)
ordihull(pca,group = D2$groups, col=D2$groups)

#add labels to the points as needed
?biplot.rda
biplot(pca, display=c("sites","species"), type=c("points","text"), xlab="PC1 (18.15%)", ylab="PC2 (12.4%)")
points(pca, display=c("sites"),pch=20, col=factor(D2$groups))

#Add legend
groupnames=levels(D2$groups)
legend("topright",
       col = factor(D2$groups),
       lty = 1,
       legend = groupnames)

#PCoA
#Calculate Distance
?vegdist
dist_matrix =  #FILL THIS IN!

#Compute Eigenvectors
pcoa = #FILL THIS IN!

#Plot
plot(pcoa, type="p")
fit=envfit(pcoa,Data)
plot(fit, col="black",p.max=0.05)
ordilabel(pcoa, labels=rownames(Data));
points(pcoa$points, display="sites", pch=20, col=factor(D2$groups));
legend("topright",
       col = factor(D2$groups),
       lty = 1,
       legend = groupnames)
