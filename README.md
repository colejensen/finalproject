# Phylogenetic Biology - Final Project

## Guidelines - you can delete this section before submission

This repository is a stub for your final project. Fork it, develop your project, and submit it as a pull request. Edit/ delete the text in this readme as needed.

Some guidelines and tips:

- Use the stubs below to write up your final project. Alternatively, if you would like the writeup to be an executable document (with [knitr](http://yihui.name/knitr/), [jupytr](http://jupyter.org/), or other tools), you can create it as a separate file and put a link to it here in the readme.

- For information on formatting text files with markdown, see https://guides.github.com/features/mastering-markdown/ . You can use markdown to include images in this document by linking to files in the repository, eg `![GitHub Logo](/images/logo.png)`.

- The project must be entirely reproducible. In addition to the results, the repository must include all the data (or links to data) and code needed to reproduce the results.

- If you are working with unpublished data that you would prefer not to publicly share at this time, please contact me to discuss options. In most cases, the data can be anonymized in a way that putting them in a public repo does not compromise your other goals.

- Paste references (including urls) into the reference section, and cite them with the general format (Smith at al. 2003).

- Commit and push often as you work.

OK, here we go.

# Have Transmission Chains of SARSCoV2 associated with NYC Influenced Transmission Chains Outside of the US? 

## Introduction and Goals

During the early wave of the SARSCoV-2 pandemic, thousands of peopel left NYC. The NY Times did a study to estimate where many of the city's residents went uisng mail forwarding requests. The results can be shown here:
<p align="center">
 <img src="https://github.com/colejensen/finalproject/blob/master/images/Capture.PNG">
 </p>

It can be seen that genomes associated with the NYC outbreak have [influenced transmission of SARCoV-2 throughout the US](https://www.medrxiv.org/content/10.1101/2020.04.08.20056929v2). 
The goal of my project is to see if transmission of SARSCoV-2 that is tied to this exodus of NYC  during the early wave of the pandemic in NYC led to introdctions of SARSCoV2 outside of the USA and if it did, did it result in last transmission chains?

The methods I will use to do this are Nextstrain, Beast, IQTree, and the Baltic python package. I need to see how likely the different trees are to happen. To do this I plan on making Nextstrain trees using a [pipeline](https://github.com/colejensen/sarscov2) that I am familiar with. This will result in three different `<json>` files<sub>[1](https://github.com/colejensen/sarscov2/blob/master/auspice/sarscov2_inc1.json),[2](https://github.com/colejensen/sarscov2/blob/master/auspice/sarscov2_inc2.json),[3](https://github.com/colejensen/sarscov2/blob/master/auspice/sarscov2_inc3.json)</sub>. 
 
 I plan on then bootstrapping this tree. This is where Beast and IQTree come in. Nextstrain gives me a Maximum Likelihood tree that does 2 iteratations to find the topolgy with the most likely events. I need to figure out if that is: 
 1. **Truely the most likely topology**
 2. **The cluster proportion of the branches being in that/a posistion** 
There are two ways I can do this and I intend to figure out if one is better than the other. I can input my '<json>' files to Beast and use that input as a [fixed emprircal tree](https://www.biorxiv.org/content/10.1101/2020.05.05.078758v2.full) to infer the ancestral locations with spatially-explict models. The other option is to use [IQTree](http://www.iqtree.org/doc/Tutorial) and have it preform 1000+ bootstraps to get similiar (hopefully nearly identical) results. 
  
I will then need to make tree visualizations. This is where baltic comes in. I will use the baltic package (this is still up in the air, but I am leaning towards using baltic) to take the outputs of Beast and IQTree and create visualiztion of the trees. These figures will be similiar to [figure 1 and figure 2](https://www.nature.com/articles/nature22040). Depending on the feedback I get, this portion of the project might be adjusted/voided. 

I will use data generated from the [Grubaugh Lab](http://grubaughlab.com/) and data available at [GISAID.org](https://www.gisaid.org/) and in the [NCBI database](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Nucleotide&VirusLineage_ss=Wuhan%20seafood%20market%20pneumonia%20virus,%20taxid:2697049). I can also create loop in the baltic code that will create a count to see how many genomes from NYC cluster with genomes from other countires and how many genomes are part of those chains after the NYC genome(s). 

## Methods

The tools I used were... See analysis files at (links to analysis files).

## Results

The tree in Figure 1...

## Discussion

These results indicate...

The biggest difficulty in implementing these analyses was...

If I did these analyses again, I would...

## References

