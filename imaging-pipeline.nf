// Module 1: dcm2niix

#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process dcm2niixConversion {
    container "scitran/dcm2niix"
    
    input:
    path dicomInput
    path outputDirdcm
    
    output:
    path "output" into niftiOutput
    
    script:
    """
    docker run --rm -ti -v \${dicomInput}:/flywheel/v0/input/dcm2niix_input -v \${outputDir}:/flywheel/v0/output scitran/dcm2niix
    """
}

workflow {
    inputDir = "/Users/mahi021/Documents/USB-data-psychatry-data/Rawdata_MRscanner/10/ccplac/Anatomie_raw"
    outputDir = "/Users/mahi021/Documents/USB-data-psychatry-data/BIDS/sub-10/anat"
}

// Module 2: bids-validator

#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process bidsValidator {
    container "bids/validator"
    
    input:
    path inputDir
    
    script:
    """
    docker run --rm -v /Users/mahi021/BIDS_validator/:/data:ro bids/validator /data 
    """
}

workflow {
    inputDir = "/Users/mahi021/BIDS_validator/"  
}

// Module 3: Pydeface

#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process pydefaceProcess {
    container "poldracklab/pydeface"
    
    input:
    path inputDir

    script:
    """
    docker run --rm --platform linux/amd64 -v /Users/mahi021/Psychatry-department-data/:/data poldracklab/pydeface pydeface /data/BIDS/sub-10/anat/sub-10_inv-1_MP2RAGE.nii.gz
    """

}

workflow {
    inputDir = "/Users/mahi021/Psychatry-department-data/BIDS/sub-10/anat/sub-10_inv-1_MP2RAGE.nii.gz"
}

