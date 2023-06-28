# PhasTest_API
Automation of PHASTEST API Submission and Retrieval. Based on https://phastest.ca/


## Usage

Input path must include genome contig files in the format of ".fna"
Output folder will contain a collection of zipped files, each with the prophage summaries.

Default input file is working directory. change it using the --inputDir flag

`bash phastest_api.sh [-h|--help] <[--submitjob][--getresults]> [--outDir DIR][--inputDir DIR][--cleanup]`

Example:
 `bash phastest_api.sh --submitjob --inputDir ./00.fnafiles`


 `bash phastest_api.sh --getresults --outDir ./01.phastest_results`


 `bash phastest_api.sh --getresults --outDir ./01.phastest_results --cleanup` 

## Installation
1. Download phastest_api.sh
2. run "chmod +x phastest_api.sh" to enable execution of the code


Modes:
--submitjob - Parses the genome contig files into the phastest API. Only accepts .fna fasta files and the program will automatically detect if it is a multi-fasta file.
--getresults - Gets the results of job submissions based on json file inputs. (**Very important**) Please run this after running submit job and allow time for Phastest to run your samples.

Note: Speed in which your samples are ready depends on PHASTEST servers and queue times. This script only automates the file upload and data retrieval. 

## Prerequisites
Unix/macOS, jq command (Tested on Ubuntu 20.04 and macOS Ventura 13.4)

To install jq:
Unbuntu: sudo apt-get install jq
Homebrew: brew install jq


