# Phylogenetic Biology - Final Project

# Have Transmission Chains of SARSCoV2 associated with NYC Influenced Transmission Chains Outside of the US? 

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

I will use Nextstrain, Beast, IQTree, and the Baltic python package to look into this. I need to see how likely the different trees are to happen. To do this I plan on making Nextstrain trees using a [pipeline](https://github.com/colejensen/sarscov2) that I am familiar with. This will result in three different `<json>` files<sub>[try1](https://github.com/colejensen/sarscov2/blob/master/auspice/sarscov2_inc1.json),[try2](https://github.com/colejensen/sarscov2/blob/master/auspice/sarscov2_inc2.json),[try3](https://github.com/colejensen/sarscov2/blob/master/auspice/sarscov2_inc3.json)</sub>. I will then bootstrap these three trees to find out:
 1. **If the `<json>` files truely produced the most likely topology**
 2. **The cluster proportion of the branches being in that/a posistion** 
 
This is where Beast and IQTree come in. Nextstrain gives me a Maximum Likelihood tree that does 2 iteratations to find the topolgy with the most likely events. I need to figure out: 
 1. **If the `<json>` files truely produced the most likely topology**
 2. **The cluster proportion of the branches being in that/a posistion** 
 Bootstrapping these  `<json>` trees should help answer these questions. There are two ways I can do this and I intend to figure out if one is better than the other. I can input my '<json>' files to Beast and use that input as a fixed emprircal tree<sub>[11](https://www.biorxiv.org/content/10.1101/2020.05.05.078758v2.full)</sub> to infer the ancestral locations with spatially-explict models. The other option is to use IQTree<sub>[12](http://www.iqtree.org/doc/Tutorial)</sub> and have it preform 1000+ bootstraps to get similiar (hopefully nearly identical) results. 
  
I will then need to make tree visualizations. This is where baltic comes in. I will use the baltic package (this is still up in the air, but I am leaning towards using baltic) to take the outputs of Beast and IQTree and create visualiztion of the trees. These figures will be similiar to figure 1 and figure 2<sub>[13](https://www.nature.com/articles/nature22040)</sub>. Depending on the feedback I get, this portion of the project might be adjusted/voided. 

## Results

The tree in Figure 1...

## Discussion

These results indicate...

The biggest difficulty in implementing these analyses was...

If I did these analyses again, I would...

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
