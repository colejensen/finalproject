# Phylogenetic Biology - Final Project

# Was New York City a Source of International SARS-CoV-2 Spread?

## Introduction and Goals

SARS-CoV-2, a novel coronavirus, was identified as the cause of an outbreak of pneumonia in Wuhan, China, in December 2019<sub>[1](https://doi.org/10.1101/2020.02.07.937862)</sub>,<sub>[2]( https://doi.org/10.1038/s41586-020-2008-3)</sub>,<sub>[3](https://doi.org/10.1038/s41586-020-2012-7)</sub>. Cases of coronavirus disease 2019 (COVID-19) outside of China were reported as early as January 13, 2020. The virus has subsequently spread across the globe<sub>[4](https://www.who.int/docs/default-source/coronaviruse/situation-reports/20200121-sitrep-1-2019-ncov.pdf?sfvrsn=20a99c10_4)</sub>,<sub>[5](https://www.who.int/docs/default-source/coronaviruse/situation-reports/20200323-sitrep-63-covid-19.pdf?sfvrsn=b617302d_4D)</sub>. The first reported case of SARS-CoV-2 in the United States was a travel-associated case from Washington state on January 19, 2020<sub>[6](https://www.cdc.gov/media/releases/2020/p0121-novel-coronavirus-travel-case.html)</sub>. Following the US experienced an outbreak of COVID-19 that eventually made it the world's largest outbreak center at one point<sub>[7](https://www.businessinsider.com/coronavirus-us-has-worlds-biggest-outbreak-topping-china-2020-3)</sub>. 
During the early wave of the SARS-CoV-2 pandemic, thousands of people left New York City (NYC)<sub>[8](https://www.nytimes.com/interactive/2020/05/16/nyregion/nyc-coronavirus-moving-leaving.html)</sub>. The NY Times did a study to estimate where many of the city's residents went using mail forwarding requests. The results can be seen here:

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/Capture.PNG">
 </p>

Genomes associated with the NYC outbreak have been shown to have influenced the transmission of SARCoV-2 throughout the US<sub>[9](https://www.medrxiv.org/content/10.1101/2020.04.08.20056929v2)</sub>. This is similar to how Washington state<sub>[10](https://www.cell.com/cell/pdf/S0092-8674(20)30484-0.pdf)</sub> was an early hub for transmission<sub>[11](http://orbi.ulg.ac.be/handle/2268/247427)</sub> in the United States. Still, it appears that the NYC outbreak is associated with more transmission both in quantity and in locations. 
The goal of my project is to assess if there were transmission events from NYC to outside of the United States during the early wave of the pandemic. If so, how many and where? 

I will use data available at [GISAID.org](https://www.gisaid.org/) and in the [NCBI database](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Nucleotide&VirusLineage_ss=Wuhan%20seafood%20market%20pneumonia%20virus,%20taxid:2697049).  I will also use a package called `Baltic` that will loop through a phylogenetic tree and show where transmission events occurred. This loop can change modified to show where transmission events that originated from NYC spread. 

## Methods

For details and steps on how to run the various pipelines and BEAST, see the readme.md file within the folder called `Minimum Viable Analysis`. 

### Data Collection

The data for this project was gathered from [GISAID.org](https://www.gisaid.org/) and [NCBI database](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Nucleotide&VirusLineage_ss=Wuhan%20seafood%20market%20pneumonia%20virus,%20taxid:2697049). I collected over two million genomes and their associated metadata between the two sources. 

### Subsampling

I needed to subsample of the available genomes (as were far too many to use). I collected country-level mortality rates (deaths per 100,000 people) for each country around the globe<sub>[12](https://coronavirus.jhu.edu/data/mortality) </sub>. Using these rates, I found the proportion of deaths in a country with respect to the global mortality rate. Then I multiplied that proportion by the total number of desired genomes for each build. That number was used as an input for a subsampling scheme that will output roughly 1,250 genomes using the `subsampling_metadata.py` python script. This script's output is a list of genomes to include in the keep.txt file within the config folder. This process will limit the genomes used in the Nextstrain pipeline and other analyses to only those listed genomes. I subsampled three times to get three different subsamples to get an idea of the actual number of introductions.

To ensure that all the genomes included in the subsamples were from the "first wave" of the pandemic when New York City was a transmission hub, I did not include any genomes after July 31st, 2020. The subsampling scheme used to subsample the genomes and metadata allows for a subsampling start and end date. There was no starting date, but each scheme point was set to not go beyond the end of July. 

### Nextstrain

To learn more about the transmission behavior coming from New York City, I created maximum likelihood trees using a Nextstrain [pipeline](https://github.com/colejensen/sarscov2). This will result in three different `<json>` files<sub>[try1](https://github.com/colejensen/finalproject/blob/master/auspice/finalproject_1.json),[try2](https://github.com/colejensen/finalproject/blob/master/auspice/finalproject_2.json),[try3](https://github.com/colejensen/finalproject/blob/master/auspice/finalproject_3.json)</sub>. As part of this output, I also got an aligned `fasta` file called masked.fasta and a Newick tree called tree.nwk. Additionally, I was given an easy way to see how transmission occurred throughout the world from the [Nextstrain visualization tool](https://nextstrain.org/community/colejensen/finalproject).

### IQTree

I didn't intend to use IQTree at all. But I ran into a problem using the Nextstrain Newick tree output. When input into BEAST, I got errors and complaints that my starting tree (the Nextstrain Newick tree) wasn't strong enough. I used IQTree<sub>[13](http://www.iqtree.org/doc/Tutorial)</sub> to get an accurate Newick tree to use for the BEAST bayesian inference to address this problem. By bootstrapping these Nextstrain alignment files, I received a reliable Newick tree. I used the Newick tree outputs as inputs to Beast as a fixed empirical tree<sub>[13](https://www.biorxiv.org/content/10.1101/2020.05.05.078758v2.full)</sub> to infer the ancestral locations with spatially-explicit models.
  
### BEAST

I then used the aligned fasta file from the Nextstrain output, called `masked.fasta`, as input for BEAUTi. In BEAUTi, I parsed the dates using the tip dates, defined just by its order and parsed as a number. Using trait files compiled by the metadata given during data collection, I imported traits that outline the region of exposure, country, and country of exposure for each genome in the alignment. Each of these traits will create a partition. I set an HKY model with empirical base frequencies on the sites tab, a gamma site heterogeneity model with four gamma categories. I used an uncorrelated relaxed clock with a lognormal relaxed distribution<sub>[14](https://www.cell.com/cell/fulltext/S0092-8674(19)30783-4)</sub>. The tree prior used was a coalescent: exponential growth prior<sub>[15](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7366979/)</sub>. The operator mix was set to a fixed tree topology. The rest of the BEAUTi xml file used default settings. 

Before running the `<xml>` file, I opened `<xml>` file and replaced the starting tree with IQTree output Newick tree. Steps on how to do this can be found [here](https://beast.community/faq.html#starting-tree-and-fixing-trees)<sub> [16](https://beast.community/faq.html#starting-tree-and-fixing-trees)</sub>.

After running BEAST, I assessed the output using FigTree, Tracer, and TreeAnnotator. As a result, I had three viable mcc.tree files.

### Baltic

I then made tree visualizations and figured out where transmission events occured<sub>[17](https://www.nature.com/articles/nature22040)</sub>. To do this, I used the [baltic package](https://github.com/evogytis/baltic). Baltic can take BEAST and Nextstrain outputs to create visualizations and gain insights into phylogenetic trees. Using the `baltic_explodeJSON.py` script, I input the `<json>` file from the Nextstrain output to be used as a coloring tool for the tree visualization. The BEAST mcc.tree was used to create a "baltic tree" and see where transmission occurred from New York City to other countries.   

## Results

### Phylogenies

Figures 1-3 show the subsampled SARS-CoV-2 trees using the Nextstrain pipeline, which uses a maximum likelihood method. These show time-calibrated transmission events as defined by geographic region. For the sake of visualization and Bayesian inferences, New York City is defined as its own region. These trees show multiple regions where transmission events from New York City many have occurred. The gray indicated NYC. There are multiple points were it appears that NYC is the most recent common ancestors. Namely around B.1.36 and above and around B.1.9. These groupings tend to hold genomes from NYC, the US, Europe, and India. 

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/nextstrain_ss1.png">
 </p>

**Figure 1.** Nextstrain Phylogenetic Tree for the first subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/nextstrain_ss2.png">
 </p>
 
__Figure 2.__ Nextstrain Phylogenetic Tree for the second subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/nextstrain_ss3.png">
 </p>
 
**Figure 3.** Nextstrain Phylogenetic Tree for the three subsample.

Figures 4-6 show the IQTree phylogenetic tree. The tip labels are shown, and the tree is in increasing order. These offer very similar results to the maximum likelihood tree results from Nextstrain. They are, however, much harder to read since they are shown by divergence instead of time. After closely observing the data, the clade that closest matches clade B.1.9 in the Nextstrain builds is slightly different. 

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss1_iqtree.png">
 </p>
 
**Figure 4.** IQTree Phylogenetic Tree for the first subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss2_iqtree.png">
 </p>
 
**Figure 5.** IQTree Phylogenetic Tree for the second subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss3_iqtree.png">
 </p>
 
**Figure 6.** IQTree Phylogenetic Tree for the third subsample.

Figures 7-9 show the trees generated by BEAST and annotated by TreeAnotator. They are very similar to the previous phylogenies. The difference between these and the last few is that they went through Bayesian inference methods and many MCC iterations. This makes sense since the starting tree of the BEAST phylogenies is the IQTree. Which also helps explain why the clade that is the closest to clade B.1.9 in the Nextstrain build is different. This is also due to the different approach to creating the phylogeny.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss1_mcc.png">
 </p>
 
**Figure 7.** MCC Phylogenetic Tree for the first subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss2_mcc.png">
 </p>
 
**Figure 8.** MCC Phylogenetic Tree for the second subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss3_mcc.png">
 </p>
 
**Figure 9.** MCC Phylogenetic Tree for the third subsample.

After inputting the BEAST phylogenetic trees into `baltic_explodeJSON.py` and running the script, I found various introductions from New York City to other countries. Figures 10-12 show the batlic trees with the coloring from them Nextstrain tress.  In figure 13, the three subsamples' are aggregated into multiple boxplots to highlight the spread of the possible number of introductions from New York City. Each region is labeled, although some acronyms were used for display purposes. In figure 14, the overall number of introductions from New York City is shown. The complete lists of where the introduction events occurred in each subsample can be found in the BEAST folder. 

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss1_baltic.PNG">
 </p>
 
 **Figure 10.** The Baltic Phylogenetic Tree for the first subsample. 
 
 <p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss2_baltic.PNG">
 </p>
 
 **Figure 11.** The Baltic Phylogenetic Tree for the first subsample.
 
 <p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/ss3_baltic.PNG">
 </p>

**Figure 12.** The Baltic Phylogenetic Tree for the first subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/new_regions.png">
 </p>

**Figure 13.** Boxplots that show the average number of introductions from New York City. Each location is labeled as the continent (or region) the transmission event occurred in. To properly fit in the display, some acronyms were made. N.C.A. is North and Central America, and S.A. is South America. Total is in reference to the total number of introductions from New York to somewhere outside the United States from each subsample.

<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/total.png">
 </p>
 
**Figure 14.** Boxplot that shows the overall average number of introductions from New York City. 

The three different subsamples showed different results. Two of the three had the same amount of introduction events in each region, while one subsample differed. Overall, each region had roughly the same amount of transmission events both in overall count and by region. In the Middle East and in Oceania, all three subsets reported the same amount of transmission events (seven and four respectively). Of these events, the subsamples reported the same amount of transmission events to the listed countries in the region. Europe had the greatest number of transmission events from New York City occur. The aveage number of introdcutions across the subsamples was 41.3 with a high of 48 introductions. South America averaged 12 transmission events and North and Central America followed closely behind with 11.67 transmission events. Asia and Africa had the least amount of transmission events with 2.67 and 3 transmission events respectively. On average, there were 85 transmission events from New York City (outside of transmission events within the United States) across the globe. 

## Discussion

SARS-CoV-2 was first detected in Wuhan China in December 2019<sub>[1](https://doi.org/10.1101/2020.02.07.937862)</sub>,<sub>[2]( https://doi.org/10.1038/s41586-020-2008-3)</sub>,<sub>[3](https://doi.org/10.1038/s41586-020-2012-7)</sub> and has spread across the globe<sub>[4](https://www.who.int/docs/default-source/coronaviruse/situation-reports/20200121-sitrep-1-2019-ncov.pdf?sfvrsn=20a99c10_4)</sub>,<sub>[5](https://www.who.int/docs/default-source/coronaviruse/situation-reports/20200323-sitrep-63-covid-19.pdf?sfvrsn=b617302d_4D)</sub>. During what has been deemed the first wasve of the pandemic, New York City became a hub of transmission<sub>[7](https://www.businessinsider.com/coronavirus-us-has-worlds-biggest-outbreak-topping-china-2020-3)</sub>. As a result, the US and countries across the world have implemented travel bans and restrictsions<sub>[18](https://travelbans.org/)</sub>. 

These results indicate that there were multiple introductions from New York City into other countries of SARS-CoV-2 throughout the study period (from December 2019 through the end of July 2020). Each of the three subsamples shows different transmission amounts, which is consistent with having different genomes in the phylogenetic analyses. Despite the differences, there was an average of 85 introductions from New York City to other countries. This also indicates that despite the various travel bans and restrictions, introduction events from New York City (and therefore the United States) still occurred or occurred just before regulations were put into place. 

Interestingly, the various phylogenetic trees are nearly identical, even after creating them in three different ways. The IQTree and BEAST phylogenetic trees were almost similar, with only a few changes. The Nextstrain phylogenetic tree was also nearly the same, but some nodes were in different places. The maximum likelihood tree reconstructions were rather impressive for only doing two iterations. Outside of the Nextstrain visualization, it was difficult to see how the clades and nodes split due to the large number of taxa included in the builds. 

I thought it was interesting to see that Europe, by far, had the most transmission events from NYC. It makes sense with air travel, but with individuals leaving the area in an exodus like event, I thought more people would travel to countries connected to the United States. Specifically, I'm shocked that there weren't more introductions to Canada. I felt between students and working individuals going back home or going to second homes, there would be some more transmission events into Canada. Instead, there were between five and seven transmission events into Canada. 

I'm also surprised by the few transmission events into South Korea. From prior knowledge about the country's travel restrictions, I would have expected that there wouldn't be any. I was even more shocked when there were a few transmission events into South Korea and not Italy or China (who had similar travel restrictions). The other regions, like Africa, Oceania, and Asia, make more sense to me. Many individuals in NYC that were from various areas felt the need to go back to their home countries. Many could not do so immediately and left after travel restrictions were put into place. Therefore, the chance of a transmission event happening was significantly lower. 

I am perhaps the most surprised that the same amount of genomes from Oceania and the Middle East experienced transmission events from NYC in each subsample. Additionally that each subsample had the same amount of transmission events on the country level for these regions. The clustering of these genomes can be seen in the NY-clade in figures 1-3, but to know that they were children on NYC genomes in each build was great. It helped me understand that regardless of subsampling, I was able to capture introductions events. 

I was also surprised that there weren't any transmission events in India. If you look at figures 1-3, you'll see that near the clade labeled B.1.7, the coloring of the most recent common ancestor is grey. This means that NYC was the most recent common ancestor of those nodes. If you look inside those nodes on my Nextstrain builds, you'll see a fair amount of India genomes with NYC as the most recent common ancestor (again near B.1.7). The BEAST tree doesn't share the same node construction as the Nextstrain tree here, and the baltic loop helps prove it. 

The hardest part for me was implementing the Bayesian analysis. I wanted my tree to be highly resolved and have insights into the transmission from New York City at the country and regional level. The large amount of data and additional traits included in BEAST (to use in the baltic loop) made this challenging. There was a fair amount of on-the-spot learning and a lot of trial by fire. To get BEAST to run, I had to learn how to use an input tree as a starting topology and learn how to format it so that BEAST would like it.

Additionally, I learned that the time needed for some of my sample BEAST runs wasn't even close to how much time was required to do my full Bayesian analysis. It took days to run. I was worried that it would just run forever and I wouldn't get any results. I did, thankfully,  end up getting results during Thanksgiving break. 

If I were to do this again, knowing what I know now, I would consider using IQTree instead of BEAST. Early on, I had the problem of wanting to include more genomes in the analysis (initially, I wanted to include about 2,500 samples per subsample) and having the BEAUTi output file prematurely stop writing. I have found various studies or examples that included more genomes than my desired 2,500 that used BEAST<sub>19,</sub><sub>[20](https://www.nature.com/articles/s41467-019-13443-4)</sub>. I am not sure why the BEAUTi output cut off when I tried to include 2,500 genomes in light of these examples. To get around this, I reduced my desired subsample amount to be about 1,000.  After the subsampling process, each subsample ended up with about 1,300. When the alignment of these genomes was used to create an xml file, I had no problems. 

Additionally, I would want to include some epidemiological analysis to prove the validity of this analysis. Potentially, I would use travel data as prior to help guide the Bayesian analysis. Ideally, I would be able to use travel data as some sort of prior to help guide where transmissione events actually occurred. I could also use travel data and incidence data to support and graph where expected transmission events occurred. 

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

7. Jeremy Berke, & Morgan McFall-Johnsen. (2020, Mar 26,). The US now has the world's biggest coronavirus outbreak — its case total just surpassed china's. Business Insider Retrieved from https://search.proquest.com/docview/2392499878

8. Azi Paybarah, Matthew Bloch, & Scott Reinhard. (2020, May 16,). Where new yorkers moved to escape coronavirus. New York Times (Online) Retrieved from https://search.proquest.com/docview/2404205093

9. Gonzalez-Reiche, A. S., Hernandez, M. M., Sullivan, M. J., Ciferri, B., Alshammary, H., Obla, A., . . . van Bakel, H. (2020). Introductions and early spread of SARS-CoV-2 in the new york city area. Science (American Association for the Advancement of Science), 369(6501), 297-301. doi:10.1126/science.abc1917

10. Fauver, J. R., Petrone, M. E., Hodcroft, E. B., Shioda, K., Ehrlich, H. Y., Watts, A. G., . . . Grubaugh, N. D. (2020). Coast-to-coast spread of SARS-CoV-2 during the early epidemic in the united states. Cell (Cambridge), 181(5), 990-996.e5. doi:10.1016/j.cell.2020.04.021

11. Dellicour, S., Durkin, K., Hong, S., Vanmechelen, B., Marti-Carreras, J., Gill, M., . . . Maes, P. (2020). A phylodynamic workflow to rapidly gain insights into the dispersal history and dynamics of SARS-CoV-2 lineages. Retrieved from http://orbi.ulg.ac.be/handle/2268/247427

12. Mortality analysis. (2020). Retrieved from https://coronavirus.jhu.edu/data/mortality

13. Beginner’s tutorial. Retrieved from http://www.iqtree.org/doc/Tutorial

14. Grubaugh, N. D., Saraf, S., Gangavarapu, K., Watts, A., Tan, A. L., Oidtman, R. J., . . . Andersen, K. G. (2019). Travel surveillance and genomics uncover a hidden zika outbreak during the waning epidemic. Cell (Cambridge), 178(5), 1057-1071.e11. doi:10.1016/j.cell.2019.07.018

15. Nie, Q., Li, X., Chen, W., Liu, D., Chen, Y., Li, H., Li, D., Tian, M., Tan, W., & Zai, J. (2020). Phylogenetic and phylodynamic analyses of SARS-CoV-2. Virus research, 287, 198098. https://doi.org/10.1016/j.virusres.2020.198098

16. BEAST doc. (2020). Retrieved from https://beast.community/faq.html#starting-tree-and-fixing-trees

17. Dudas, G., Carvalho, L. M., Bedford, T., Tatem, A. J., Baele, G., Faria, N. R., . . . Rambaut, A. (2017). Virus genomes reveal factors that spread and sustained the ebola epidemic. Nature (London), 544(7650), 309-315. doi:10.1038/nature22040

18. Travel ban, new rules and unexpected flying restrictions. (2020). Retrieved from https://travelbans.org/

19. Brito, A. (2020). In Jensen C. (Ed.), Anderson brito's previous project

20. Zhu, Q., Mai, U., Pfeiffer, W., Janssen, S., Asnicar, F., Sanders, J. G., . . . Knight, R. (2019). Phylogenomics of 10,575 genomes reveals evolutionary proximity between domains bacteria and archaea. Nature Communications, 10(1), 5477-14. doi:10.1038/s41467-019-13443-4
