## Getting Started

This repository contains scripts for running pre-analyses to prepare sequence and metadata files for running `augur` and `auspice`, and for running the `nextstrain` pipeline itself.


### Dependencies

To be able to run the pipeline determined by the `Snakefile`, one needs to set up an extended `conda` nextstrain environment, which will deploy all dependencies (modules and packages) required by the python scripts located at the `scripts` directory. Check each individual script in that directory to know what they do along the workflow.


### Setting up a new conda environment

Follow the steps below to set up a conda environment for running the pipeline.

Access a directory or choice in your local machine:
```
cd 'your/directory/of/choice'
```

Clone this repository `sarscov2`
```
git clone https://github.com/colejensen/sarscov2.git
```

Rename the directory `sarscov2` as you wish. Access the newly generated directory in your local machine, change directory to `config`, and update your existing nextstrain environment as shown below:
```
cd 'your/directory/of/choice/sarscov2/config'
conda env update --file nextstrain.yaml
```

This command will install all necessary dependencies to run the pipeline.


## Preparing the working directory

This minimal set of files and directories are expected in the working directory.

```
sarscov2/
│
├── auspice/ 			→ directory where the input for auspice will be stored
│
├── config/
│ ├── auspice_config.json	→ JSON file used to create the file used by auspice
│ ├── cache_coordinates.tsv 	→ TSV file with preexisting latitudes and longitudes
│ ├── clades.tsv 		→ TSV file with clade-defining mutations
│ ├── colour_grid.html 		→ HTML file with HEX colour matrices
│ ├── dropped_strains.txt	→ TXT file with IDs of sequences to be dropped along the run
│ ├── geoscheme.xml 		→ XML file with geographic scheme
│ ├── keep.txt 			→ TXT file with accession number of genomes to be included in the analysis
│ ├── nextstrain.yaml 		→ YAML file used to install dependencies
│ ├── reference.gb 		→ GenBank file of a reference genome
│ └── remove.txt 		→ TXT file with IDs of genomes to be removed prior to the run
│
├── pre-analyses/
│ ├── gisaid_hcov-19.fasta 	→ FASTA file with the latest genomes from GISAID
│ ├── new_genomes.fasta 		→ FASTA file with the lab's newly sequenced genomes
│ ├── metadata_nextstrain.tsv	        → nextstrain metadata file, downloaded from GISAID
│ └── COVID-19_sequencing.xlsx 		→ Custom lab metadata file
│
└── README.md
```


### Preparing the input data

Files in the `pre-analyses` directory need to be downloaded from distinct sources, as shown below.
Files in the `pre-analyses` directory need to be downloaded from distinct sources, as shown below.
|              File              |                                              Source                                             |
|:------------------------------:|:-----------------------------------------------------------------------------------------------:|
| gisaid_hcov-19.fasta |         Downloaded from GISAID (all complete genomes submitted from 2019-Dec-01)        |
|        new_genomes.fasta<sup>1,4</sup>       | Newly sequenced genomes, with headers formatted as ">Yale-XXX", downloaded from the Lab's Dropbox |
| metadata_nextstrain.tsv<sup>2</sup> | File 'nextmeta.tsv' available on GISAID |
|    COVID-19_sequencing.xlsx<sup>3,5</sup>    |                     Metadata spreadsheet downloaded from an internal Google Sheet                    |



Notes:<br />
<sup>1</sup> FASTA file containing all genomes sequenced by the lab, including newly sequenced genomes<br />
<sup>2</sup> The user will need credentials (login/password) to access and download this file from GISAID<br />
<sup>3</sup> This Excel spreadsheet must have the following columns, named as shown below:<br />

- Sample-ID *→ lab samples unique identifier, as described below*
- Collection-date
- Country
- State *→ state acronym*
- Division  *→ state full name*
- Location  *→ city, town or any other local name*
- Host
- Source *→ lab source of the viral samples*
- Update *→ number of the genome release, if new genomes are released in a regular basis*

<sup>4</sup> If you don't have any lab specific genomes you need to keep this file, but it may be empty<br />
<sup>5</sup> If you don't have any lab specific genomes, keep the file as is. The script will filter out any of the metadata in the given file, but will still run. <br />

#### Adapting the Python scripts
A few lines in the scripts `add_newgenomes.py` ans `filter_metadata.py` need to be changed to match your lab's sample naming and origin.

Lines to be changed in `add_newgenomes.py`:
- Lines 45, 56 and 81: **"Yale-"** must match the unique identifier, only found in your lab's genome IDs. Ours is set (in bold) as follows: hCoV-19/USA/**CT-Yale-001**/2020

Lines to be changed in 'apply_geoscheme.py':
- Lines 154 - 161 uses a function to make data from NYC be presented as it's own country. If you want NYC to be included in the USA at the country level you need to remove or comment out this function.

Lines to be changed in `filter_metadata.py`:
- Line 77: `sheet_name` must be changed to match the sheet tab name (without spaces), inside the Excel file

- Lines 91 and 142: Same as described above, **"Yale-"** must match the unique identifier, only found in your lab's genome IDs. Ours is set (in bold) as follows: hCoV-19/USA/**CT-Yale-001**/2020

- Lines 156 and 179: change these lines to match the country of origin (alpha-3 ISO code)

- Lines 153 and 169: change these lines to match the name and acronym of the most likely state of origin of the samples, if the 'State' field is unknown

- Line 187: change this line to match you lab's name

- Line 188: change this line to match you lab's main author's name

## Adding NCBI data

Move the `download_sequences.py` script from scripts to the pre-analysis folder. Using the `nextstrain` environment type 
```
python download_sequences.py --fasta ncbi_hcov-19.fasta --skip redundant_entries.txt --metadata metadata_nextstrain.tsv
``` 
This will download all the NCBI SARS-CoV-2 genomes that do not match the metadata given from GISAID. This may take a while. After running this once, to update run the same code sequence in command line, but this time it will skip all the entries in `redundant_entries.txt` which will speed up the process quite a bit.  

## Making NYC genomes identify as being from the country 'New York City' to do country level analysis and find the subsample. 

To do this you need to make a copy of the metadata file created called `metadata_nextstrain.tsv`. It doesn't matter what it's called, but it needs to be an exact copy of it. Then, while inside the pre-analysis folder, employ the `presubsample.py` script. I do this in PyCharm becuase it doesn't need the nextstarin augur. Run the script and you will have changed the metadata copy to now have New York City genomes listed as being from the country 'New York City'. You will need to change the file pathway to match the local pathway on your machine. 

Now you need to subsample the data. In command line type the following:
```
python subsample_metadata.py --metadata metadata_nextstrain_copy.tsv --keep keep.txt --remove.txt --scheme subsampling_scheme.tsv -- output selected_strains.tsv --report report.tsv
```
This will subsample the metadata and give you a list of genomes based on the subsampling scheme. This scheme can be found in `selected_strains.tsv`. Copy the contents `selected_strains.tsv` and navigate to the `keep.txt` file in the config folder. Replace the contents of that `keep.txt` file with the contents in `selected_strains.tsv`. If you want to change anthing about the genomes in the subample regarind the amount, where, or when  you can change the subsampling scheme to reflect that. 


## Running the pipeline

### Generating augur input data

By running the command below, the appropriate files `sequences.fasta` and `metadata.tsv` will be created inside the `data` directory, and the TSV files `colors.tsv` and `latlongs.tsv` will be created inside the `config` directory:

```
snakemake preanalyses
```

### Running augur

By running the command below, the rest of the pipeline will be executed:
```
snakemake export
```

### Removing previous results

By running the command below files related to previous analyses in the working directory will be removed:
```
snakemake clean
```

Such command will remove the following files and directories:
```
results
auspice
data
config/colors.tsv
config/latlongs.tsv
```

### Deleting temporary input files after a successful run

This command will delete the directory `pre-analyses` and its large files:
```
snakemake delete
```


## New versions

The code in `scripts` will be updated as needed. Re-download this repository (`git clone...`) whenever a new analysis has to be done, to ensure the latest scripts are being used.

## Server Run

This process can be done using a server as well. The server will have to have the Nextstrain augur installed. Move over the `config`, `data`, `pre-analyses`, and `scripts` folders along with the `Snakefile`. Copy over the `sbatch` file called  `nextstrain.sh`. Open the terminal from the folder that all of these files or folders are stored. To run the nextstrain.sh file type:
```
sbatch nextstrain.sh
```
Depending on the amount of genomes, this can take upwards of a few hours. 

## Viewing the Maximum Likelihood Nextstrain Tree

There are two ways to do this, a permant way to see it or a temporary way to see it. 

**Temporary**:

In commandline, still using the nextstrain envirnoment, type:
```
auspice view
```
This will result in a link **`http://localhost:4000`**. Copy into a web brower that will commandline still open and you will be able to see the tree. It is important to note that you cannot do this step while utilizing a server. This has to be run on your local machine using either the command prompt (for Mac computers) or Ubuntu (for Windows). 

**Permanent**:

In Github create a folder within a reporository, create a folder called `auspice`. Upload the `.JSON` file output called `cov_update.json` unless renamed. You will need to rename the file to match this format **`reponame_filename.json`**. Then go to your personalized nextstrain page on **https://nextstrain.org/community/githubusername/reporname/filename**. 

For example, the builds done for this project can be found at **https://nextstrain.org/community/colejensen/finalproject**.

## Creating the IQTree

Due to the low node value probabilities, the newick tree from the Nextstrain build may not have enough strength for BEAST to be happy. To get around this I ran the `iqtree.sh` to make a newick with more concrete node values. This takes in the `masked.fasta` file and will output a stronger tree than the Nextstrain maximum likelihood tree. 

## Doing the Bayesian Analysis

The the `results` folder there will be a alignmed and masked fasta file called `masked.fasta`. Using BEAUTi input this file set your parameters and model settings. For this minimumal viable analysis I set it as the following:

1. On the `Tips` tab click `use tip dates`. Click the `Parse Dates` button and then press `OK`. 
2. On the `Sites` tab set the substitution model to `HKY`, base frequencies to `Empirical`, site heterogeneity model to `Gamma`, and the number of gamma caegories to `4`. 
3. On the `Clocks` tab set the clock type to `uncorrelated relaxed clock`. 
4. On the `Trees` tab set the tree prior to `Coalescent: Exponential Growth` (I plan on using a different prior in the future, this was just to make sure it worked) 
5. The rest I left as the default. 
6. Go to the `Traits` tab. Click `Add trait` and select `Import trait(s)` and press `OK`. Then navigate to whereever you have save traits. For the purpose of my analysis I made a copy of the metadata from the Nextstrain build and took out every column other than the taxa column,which has to be renamed `traits `, and the region_exposure and country columns. Once this is imported, click each trait and then press `Create partition from trait...`. You will need to do this with each trait to be included. 
6. Click the `Genereate BEAST File...` button and choose the location and name.

To set the ML tree as a starting tree, you need to change the `.xml` file in the following way. 
1. Replace the block that creates the random `startingTree` with:
<newick id="startingTree">
    insert you starting tree here in Newick format (from the IQTree output)
</newick>
2. The <treeModel> XML element then needs to contain a reference to this starting tree XML element:
<newick idref="startingTree"/>

Something to note here, is that you may need to do some find and replace here. The newick starting tree has to match exactly to the taxon labels in the xml file. To make sure that this works, I would suggest to makes edits and then running the xml file in BEAST locally before running it on the server using the beast.sh sbatch file. By doing it this way, you will see if there is a mispelling in the newick tree before you run it on the server and forget about it. It'll save you time in the long run. Once it gets past introducing the starting tree on the local run, you can end the BEAST run and upload the xml file to a server. Then use the xml file and beast.sh sbatch file to run BEAST.
 
Then you are ready for BEAST!

Open `BEAST` and using the `Choose File...` option select the `.xml` file. Then `Run`. If you want to run this on a server upload the `xml` file to your server and make sure that `BEAST` is installed. Additionally, upload the `beast.sh` file to the same place on the server. In command line call the `sbatch` file and point it to the `xml` file. Ther terminal code will look something like this:

```
sbatch beast.sh filename.xml
```

In the event that the analysis takes more than the alloted time in the `beast.sh` file (currently set to 200 hours) run the following code based on how far the the analysis has gotten (the largest `state_somenumber` output).

```
sbatch beast.sh filename.xml -load_state state_number
```

## Analysis the BEAST run

You can check how well the MCMC worked by using **`Tracer`** and uploading the `.log` file in the output. 

To build the MCC tree open `TreeAnnotator`. Set the burn in to 1/5 the MCMC state and input the `.trees` file. You will then have to click the `Choose File...` next to output file and set the name of the output file and location it will be saved. 
Then press `Run`. 

You can then input that mcc file into `FigTree` to see the tree. 

To see how well BEAST ran in terms of convergence and to analyze various paramters use `Tracer`. Upload the `.log` file into Tracer and you can see the various parameters and use the tools near the top center of the window to observe differe statstics and visualizations to help assess if the BEAST file ran long enough. 


## Using Baltic

Using the `baltic_explodeJSON.py` file in PyCharm or a similiar python editor input the mcc tree and run it. You will get and output another tree and a list of where New York City introduced disease to a different country. You will need to change the pathways to the your locally saved `JSON` and `MCC` files. Once you run this you will get output in your console about where introdctions occur from New York City to some other location. Copy and paste that into Excel or some text editor and you have your list of introductions. This will also give a tree that colored based on the `JSON` file. 
