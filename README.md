# Phylogenetic Biology - Final Project

# Was New York City a Source of International SARS-CoV-2 Spread?

## Introduction and Goals

SARS-CoV-2, a novel coronavirus, was identified as the cause of an outbreak of pneumonia in Wuhan, China, in December 2019<sub>[1](https://doi.org/10.1101/2020.02.07.937862)</sub>,<sub>[2]( https://doi.org/10.1038/s41586-020-2008-3)</sub>,<sub>[3](https://doi.org/10.1038/s41586-020-2012-7)</sub>. Cases of coronavirus disease 2019 (COVID-19) outside of China were reported as early as January 13, 2020. The virus has subsequently spread across the globe<sub>[4](https://www.who.int/docs/default-source/coronaviruse/situation-reports/20200121-sitrep-1-2019-ncov.pdf?sfvrsn=20a99c10_4)</sub>,<sub>[5](https://www.who.int/docs/default-source/coronaviruse/situation-reports/20200323-sitrep-63-covid-19.pdf?sfvrsn=b617302d_4D)</sub>. The first reported case of SARS-CoV-2 in the United States was a travel-associated case from Washington state on January 19, 2020<sub>[6](https://www.cdc.gov/media/releases/2020/p0121-novel-coronavirus-travel-case.html)</sub>. Following the US expereinced an outbreak of COVID-19 that eventually made it the world's largest outbreak center at one point<sub>[7](https://www.businessinsider.com/coronavirus-us-has-worlds-biggest-outbreak-topping-china-2020-3)</sub>. 
During the early wave of the SARSCoV-2 pandemic, thousands of peopel left NYC<sub>[8](https://www.nytimes.com/interactive/2020/05/16/nyregion/nyc-coronavirus-moving-leaving.html)</sub>. The NY Times did a study to estimate where many of the city's residents went uisng mail forwarding requests. The results can be shown here:
<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/Capture.PNG">
 </p>

It can be seen that genomes associated with the NYC outbreak have influenced transmission of SARCoV-2 throughout the US<sub>[9](https://www.medrxiv.org/content/10.1101/2020.04.08.20056929v2)</sub>. This is similiar to how Washington state<sub>[10](https://www.cell.com/cell/pdf/S0092-8674(20)30484-0.pdf)</sub> was an early hub for transmission in the United States, but it appears that the NYC outbreak is associated with more transmission. 
The goal of my project is to see if transmission of SARSCoV-2 that is tied to this exodus of NYC  during the early wave of the pandemic in NYC led to introdctions of SARSCoV2 outside of the USA and if it did, did it result in last transmission chains?

I will use data generated from the [Grubaugh Lab](http://grubaughlab.com/) and data available at [GISAID.org](https://www.gisaid.org/) and in the [NCBI database](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Nucleotide&VirusLineage_ss=Wuhan%20seafood%20market%20pneumonia%20virus,%20taxid:2697049). I can also create loop in the baltic code that will create a count to see how many genomes from NYC cluster with genomes from other countires and how many genomes are part of those chains after the NYC genome(s). 

## Methods

### Data Collection

The data for this project were collected from [GISAID.org](https://www.gisaid.org/) and [NCBI database](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Nucleotide&VirusLineage_ss=Wuhan%20seafood%20market%20pneumonia%20virus,%20taxid:2697049). I collected over two million genomes and their assoicated metadadta between the two sources. 

### Subsampling

I need to get a subsample of the available genomes (as there are far too many to use). I collected country level mortality rates (deaths per 100,000 people) for each country<sub>[source number](https://coronavirus.jhu.edu/data/mortality) </sub>. Using these rates, I find the proportion of genomes for each country and input them as a subsampling scheme that will output roughly 1,250 genomes using the `subsampling_metadata.py` python script. This subsampling scheme will not subsample any genomes after July 31st, 2020. This will create a list of genomes to include in the keep.txt file within the config folder to only use the listed genomes in the Nextstrain pipeline. This will be repeated three times to get three different subsamples.

### Nextstrain

In order to learn more about the transmission behavior coming from New York City, I will create maximum likelihood trees using a Nextstrain [pipeline](https://github.com/colejensen/sarscov2). This will result in three different `<json>` files<sub>[try1](https://github.com/colejensen/finalproject/blob/master/auspice/finalproject_1.json),[try2](https://github.com/colejensen/finalproject/blob/master/auspice/finalproject_2.json),[try3](https://github.com/colejensen/finalproject/blob/master/auspice/finalproject_3.json)</sub>. As part of this output, I will get an aligned fasta file and a newick tree. Additionally, I will be given a way to easily see how transmission occured throughout the world using the Nextstrain vizualization tool.

### IQTree

I used the Nextstrain output files to bootstrap these three trees to find out using IQTree to get an accurate newick tree to use for the BEAST bayesian inference. By bootstrapping these Nextstrain trees will result in a reliable newick tree. From these outputs, I can see if how similiar the differently subsampled trees if one is better than the other. Additionally, I used the newwick tree outputs as inputs to Beast and use that input as a fixed emprircal tree<sub>[11](https://www.biorxiv.org/content/10.1101/2020.05.05.078758v2.full)</sub> to infer the ancestral locations with spatially-explict models. The other option is to use IQTree<sub>[12](http://www.iqtree.org/doc/Tutorial)</sub> and have it preform 1000+ bootstraps to get similiar (hopefully nearly identical) results. 
  
### BEAST

I then used the aligned fasta file from the Nextstrain output, called `masked.fasta`, as an input for BEAUTi. In BEAUTi I will parse the dates by using the tip dates, defined just by its order and parsed as a number. Using trait files compiled by the metadata given during data collection, I will import traits that outline region of exposure, country, and country of exposure for each genome in the alignment. Each of these traits will create a partition. Sites will be set to use an HKY model with emprical base frequencies, a gamma site heterogeneity model with four gamma categories. I used an uncorrelated relaxed clock with a lognormal relaxed distribution. The tree prior used was a coalescent: exponential growth prior. The operator mix was set to a fixed tree topology. The rest of the BEAUTi xml file was set as deafult. 

Before running the `<xml>` file, I opened `<xml>` file and replaced the starting tree with IQTree output treefile. How to do this can be found [here](https://beast.community/faq.html#starting-tree-and-fixing-trees)<sub> [source number](https://beast.community/faq.html#starting-tree-and-fixing-trees)</sub>.

After running BEAST, the output will be assessed using FigTree, Tracer, and TreeAnnotator. This resulted in a viable mcc.tree file output.

### Baltic

I then make tree visualizations and figure out where transmission events occured. This is where baltic comes in. I will use the [baltic package](https://github.com/evogytis/baltic) to take the outputs of Beast and Nextstrain to create visualiztion of the trees. Using the `baltic_explodeJSON.py` script, I will input the `<json>` file from the Nextstrain output to be used as a coloring tool for the tree visualization. The BEAST mcc.tree file output will be used to create a tree and see where transmission occurred from New York City to other countires.   

## Results

### Phylogenies

Figures 1-3 show the subsampled SARS-CoV-2 trees using the Nextstrain pipeline which uses a maximum likelihood method. These show time calibarated transmission events as defined by geographic region. New York City, for the sake visualization and bayesian inferences, is it's own region. This shows there were multiple regions where transmission events from New York City many have occured. 
<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/nextstrain_ss1.png">
 </p>

**Figure 1.** Nextstrain phylogeny for the first subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/nextstrain_ss2.png">
 </p>
**Figure 2.** Nextstrain phylogeny for the second subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/nextstrain_ss3.png">
 </p>
**Figure 3.** Nextstrain phylogeny for the three subsample.

Figures 4-6 show the IQTree treefile results. The tip labels are shown and the tree is in increasing order. These show very similiar results to the maximum likelihood tree results from Nextstrain.
<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss1_iqtree.png">
 </p>
**Figure 4.** IQTree phylogeny for the first subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss2_iqtree.png">
 </p>
**Figure 5.** IQTree phylogeny for the second subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss3_iqtree.png">
 </p>
**Figure 6.** IQTree phylogeny for the third subsample.

Figures 7-9 show the trees generated by BEAST and annoated by TreeAnotator. They are very similiar to the previous phylogenies. The difference between these and the last few are that they went through bayesian inference methods and many iterations of MCC. 

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss1_mcc.png">
 </p>
**Figure 7.** MCC phylogeny for the first subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss2_mcc.png">
 </p>
**Figure 8.** MCC phylogeny for the second subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss3_mcc.png">
 </p>
**Figure 9.** MCC phylogeny for the third subsample.

After inputing the BEAST MCC trees in the `baltic_explodeJSON.py` script and running the script, I found that there were various introductions from New York City to other countries. In figure 10 the boxplot of the three subsamples is shown to highlight the spread of the possible number of introductions from New York City. Figure 11 shows the introdcution spread by region. The complete lists of where the introduction events occured in each subsample can be found in the results folder.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/total_boxplots.png">
 </p>
**Figure 10.** Boxplot to show the average number of introductions from New York City.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/region_boxplots.png">
 </p>
**Figure 11.** Boxplots that show the average number of introductions from New York City into different regions.


## Discussion

SARS-CoV-2 was first detected in Wuhan China in December 2019<sub>[1](https://doi.org/10.1101/2020.02.07.937862)</sub>,<sub>[2]( https://doi.org/10.1038/s41586-020-2008-3)</sub>,<sub>[3](https://doi.org/10.1038/s41586-020-2012-7)</sub> and has spread across the globe<sub>[4](https://www.who.int/docs/default-source/coronaviruse/situation-reports/20200121-sitrep-1-2019-ncov.pdf?sfvrsn=20a99c10_4)</sub>,<sub>[5](https://www.who.int/docs/default-source/coronaviruse/situation-reports/20200323-sitrep-63-covid-19.pdf?sfvrsn=b617302d_4D)</sub>. During what has been deemed the first wasve of the pandemic, New York City became a hub of transmission<sub>[7](https://www.businessinsider.com/coronavirus-us-has-worlds-biggest-outbreak-topping-china-2020-3)</sub>. As a result, the US and countries across the world have implemented travel bans and restrictsions<sub>[source number](https://travelbans.org/)</sub>. 

These results indicate that there were multiple introductions from New York City into other countires of SARS-CoV-2 throughout the study period (from December 2019 through the end of July 2020). Each of the three subsamples show different amounts of transmission, which is consistent with having different genomes in the phylogenetic analyses. Despite the differences, the aveage number of introductions from New York City to other countires is **blank**. This also indicates that despite the various travel bans and restrictions, introduction events from New York City (and therefore the United States) still occurred.

It is interesting to point out that the various phylogentic trees are nearly identical, even after creating them in three different ways. Outside of the Nextstrain visualization, it was difficult to see how the clades and nodes split due to the large number of taxa included in the builds. 

The biggest difficulty in implementing these analyses related to the bayesian analysis. I wanted my tree to be highly resolved and have insights to the transmission from New York City at the country and regional level. I think due to the large amount of data and additional traits included in BEAST to left baltic show introduction from New York City made this hard. There was a good amount of on the spot learning that I needed to do that led to the completion of BEAST bayesian analysis, which I will use in the future. 

If I did these analyses again, I would consider using IQTree instead of BEAST. I had the problem of wanting to include more genomes in the analysis (intially I wanted to inlcude about 2,500 samples per subsample). I have found various studies or examples taht have included more genomes than my desired 2,500. I am not sure why the xml output from BEAUTi cut off when I tried to include 2,500 genomes in light of these examples. I reduced my desired amount to be about 1,000, but after the subsampling process each subsample ended up with about 1,300. When these genomes were used to create an xml file, I had no problems. 

Additionally, I think I would want to include some kind of epidelogical data and analysis to this to further prove the truth and validity of this analysis. Getting travel data and some kind of time series or expected transmission marker would help further this. 

## References

1. Severe acute respiratory syndrome-related coronavirus: The species and its viruses – a statement of the Coronavirus Study Group
Alexander E. Gorbalenya, Susan C. Baker, Ralph S. Baric, Raoul J. de Groot, Christian Drosten, Anastasia A. Gulyaeva, Bart L. Haagmans, Chris Lauber, Andrey M Leontovich, Benjamin W. Neuman, Dmitry Penzar, Stanley Perlman, Leo L.M. Poon, Dmitry Samborskiy, Igor A. Sidorov, Isabel Sola, John Ziebuhr
bioRxiv 2020.02.07.937862; doi: https://doi.org/10.1101/2020.02.07.937862

2. Wu, F., Zhao, S., Yu, B. et al. A new coronavirus associated with human respiratory disease in China. Nature 579, 265–269 (2020). https://doi.org/10.1038/s41586-020-2008-3 

3. Zhou, P., Yang, X., Wang, X. et al. A pneumonia outbreak associated with a new coronavirus of probable bat origin. Nature 579, 270–273 (2020). https://doi.org/10.1038/s41586-020-2012-7

4. World Health Organization
Novel Coronavirus (2019-nCoV) Situation Report-1.
(January 21, 2020)https://www.who.int/docs/default-source/coronaviruse/situation-reports/20200121-sitrep-1-2019-ncov.pdf?sfvrsn=20a99c10_4 Date: 2020

5. World Health Organization
Coronavirus disease 2019 (COVID-19) Situation Report-63.
(March 23, 2020)https://www.who.int/docs/default-source/coronaviruse/situation-reports/20200323-sitrep-63-covid-19.pdf?sfvrsn=b617302d_4 Date: 2020

6. Centers for Disease Control and Prevention
First Travel-related Case of 2019 Novel Coronavirus Detected in United States.
(January 21, 2020)https://www.cdc.gov/media/releases/2020/p0121-novel-coronavirus-travel-case.html Date: 2020

7. https://www.businessinsider.com/coronavirus-us-has-worlds-biggest-outbreak-topping-china-2020-3

8. https://www.nytimes.com/interactive/2020/05/16/nyregion/nyc-coronavirus-moving-leaving.html

9. https://www.medrxiv.org/content/10.1101/2020.04.08.20056929v2

10. https://www.cell.com/cell/pdf/S0092-8674(20)30484-0.pdf

11. https://www.biorxiv.org/content/10.1101/2020.05.05.078758v2.full

12. http://www.iqtree.org/doc/Tutorial

13. https://www.nature.com/articles/nature22040

14. update
