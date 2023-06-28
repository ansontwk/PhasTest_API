#!/bin/bash

#check if jq command is installed
command -v jq >/dev/null 2>&1 || { echo >&2 "Error: jq command not found. Please install jq and try again."; exit 1; }

#help page
function print_help {
    echo "Usage: bash phastest_api.sh [-h|--help] <[--submitjob][--getresults]> [--outDir DIR][--inputDir DIR]"
    echo "Automates the submission of bacterial assemblies to PHASTEST and the retrieval of summaries."
    echo ""
    echo "Options:"
    echo "  -h, --help            Print this help screen."
    echo ""
    echo "##_______________________________________________________________##"
    echo "Operation Modes:"
    echo "##_______________________________________________________________##"
    echo ""
    echo "      --submitjob       Submit genome sequences from inputDir to PHASTEST."
    echo "      --getresults      Retrieve PHASTEST results for jobs in outjsonDir."
    echo ""
    echo "##_______________________________________________________________##"
    echo "Directory:"
    echo "##_______________________________________________________________##"
    echo ""
    echo "      --inputDir /PATH/TO/GENOMES   Path to the input directory (default: Current directory)."
    echo "      --outDir /PATH/TO/RESULTS    Path to the output directory (default: ./PHASTEST_results)."
    echo ""
    echo "##_______________________________________________________________##"
    echo "Misc:"
    echo "##_______________________________________________________________##"
    echo ""
    echo "      --cleanup       Removes and cleans up intermediate json files (default: false)."
}

#Default Values
submit_job=false
get_results=false
inputDir="."
runlogDir="./SubmissionJson"
outjsonDir="./JobJson"
outDir="./PHASTEST_results"
cleanup=false

#Parse CLI arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) print_help; exit 0 ;;
        --submitjob) 
            if [ "$get_results" = true ]; then
                echo "Error: Cannot use both --submitjob and --getresults flags. Please use at most one flag."
                exit 1
            fi
            submit_job=true ;;
        --inputDir) inputDir="$2"; shift ;;
        --getresults) 
            if [ "$submit_job" = true ]; then
                echo "Error: Cannot use both --submitjob and --getresults flags. Please use at most one flag."
                exit 1
            fi
            get_results=true ;;
        --outDir) outDir="$2"; shift ;;
        --cleanup) cleanup=true ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done


if [ "$submit_job" = false ] && [ "$get_results" = false ]; then
    echo "Error: Must specify at least one of --submitjob or --getresults flags."
    exit 1
fi

#Submit Job Mode:
if [ "$submit_job" = true ]; then
    mkdir -pv "./SubmissionJson"
    get_results=false
    
    for file in $inputDir/*.fna; do

        if [ -f "$file" ]; then
            num_lines=$(grep -c "^>" "$file")
            filename=$(basename "$file" .fna)
    
            if [ "$num_lines" -eq 1 ]; then
                #Single contig Fasta file
                wget --post-file="$file" "https://phastest.ca/phastest_api" -O "$runlogDir/$filename.json"
            else
                #Multi Contig Fasta file
                wget --post-file="$file" "https://phastest.ca/phastest_api?contigs=1" -O "$runlogDir/$filename.json"
        
            fi
        fi
    done
echo "All done!"
echo "Bacterial genomes submitted to Phastest API"
fi

#Get Result Mode:
if [ "$get_results" = true ]; then
    submit_job=false
    mkdir -p "$runlogDir" "$outjsonDir" "$outDir"

    find  "$runlogDir" -type f -name "*.json" | while read file ;do
        jobid=$(jq -r '.job_id' "$file")
        filename=$(basename "$file" .json)
        echo "Filename: $filename at $file"
        echo  "Getting json file for Job ID: $jobid"
        wget "https://phastest.ca/phastest_api?acc=$jobid" -O "$outjsonDir/$filename.json"
    done

    find "$outjsonDir" -type f -name "*.json" | while read file
    do
        filename=$(basename "$file" .json)
        ziplink=$(jq -r '.zip' "$file")
        echo "Filelink at: $ziplink"
        wget "$ziplink" -O "$outDir/$filename.zip"
    done
    echo "All done!"
    echo "PHASTEST results retrieved"
fi

if [ "$cleanup" = true ]; then
    echo "Cleaning up intermediate files."
    rm -rf "$runlogDir" "$outjsonDir"
    echo "All done!"
fi
