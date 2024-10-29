# PHASTEST_API
Utility Script for the automation of PHASTEST API Submission and Retrieval. Based on https://phastest.ca/ 

Reference
- Wishart DS, Han S, Saha S, et al. PHASTEST: faster than PHASTER, better than PHAST. Nucleic Acids Res. 2023;51(W1):W443-W450. doi:10.1093/nar/gkad382

## Prerequisites

### OS
Unix/macOS

(Tested on Ubuntu 20.04 and macOS Ventura 13.4)


### Programs
`jq` command

To install jq:

- Ubuntu: `sudo apt-get install jq`
- Homebrew: `brew install jq`


## Installation

1. Download phastest_api.sh
2. run "chmod +x phastest_api.sh" to enable execution of the code


## Usage

- Input path must include genome contig files in the format of `.fna`
- Output folder will contain a collection of zipped files, each with the prophage summaries.
- Default input file is working directory, change it using the `--inputDir` flag

`bash phastest_api.sh [-h|--help] <[--submitjob][--getresults]> [--outDir DIR][--inputDir DIR][--cleanup]`

### Example:

 `bash phastest_api.sh --submitjob --inputDir ./00.fnafiles`


 `bash phastest_api.sh --getresults --outDir ./01.phastest_results`


 `bash phastest_api.sh --getresults --outDir ./01.phastest_results --cleanup` 


### Modes:

`--submitjob` 
- Parses the genome contig files into the PHASTEST API. Only accepts `.fna` fasta files and the script will automatically detect if it is a multi-fasta file.

`--getresults` 
- Gets the results of job submissions based on JSON file inputs. 
(**Very important**) Please run this after running submit job and allow time for Phastest to run your samples.

Note: The speed at which your samples are ready depends on PHASTEST servers and queue times. This script only automates the file upload and data retrieval. 



