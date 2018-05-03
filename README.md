# TCGA_bam_splicer

__Download BAM sections from TCGA__

#### __Dependencies:__

Downloading is performed using curl


#### __Usage__
```
  _./TCGA_splice_bam_final.sh TOKEN SAMPLE TARGETS_

  _Parameters:_
   
    TOKEN info [required]
    -t|--token	token file from gdc
    
    SAMPLE info [required]  
    -u|--uuid	sample sheet from gdc website
    -n|--uuidname	If -u specifies a single UUID (not sample sheet file),
        then use this as output prefix name

    TARGETS to download [required]
    -c|--coord	either a coorinate, or file with coordinate(s).
        Coordinate format: "chr:start-end"
    -g|--gene	Either a single gene name, of file with list of gene(s)

    OUTPUT info
    -d|--outfolder	output folder path (will be created), default: "./"
```

#### Examples

  * Downloading specific gene
  ```
./TCGA_splice_bam.sh -t token_file.txt \
                      -u 056b2c6b-fab6-42ff-ae28-96db4fb56ea6 \
                      -g TP53 \
                      -d TP53_RNA/
  ```
      
  * Downloading based on coordinate
```
./TCGA_splice_bam.sh -t token_file.txt \
                      -u 056b2c6b-fab6-42ff-ae28-96db4fb56ea6 \
                      -c chr17:7666402-7689550 -d TP53_RNA/ \
                      -d TP53_RNA/
```   
  * Downloading gene list
```
./TCGA_splice_bam.sh -t token_file.txt \
                      -u 056b2c6b-fab6-42ff-ae28-96db4fb56ea6 \
                      -g gene_list.txt \
                      -d TP53_RNA/
```   
  * Downloading coordinate list
```
./TCGA_splice_bam.sh -t token_file.txt \
                      -u 056b2c6b-fab6-42ff-ae28-96db4fb56ea6 \
                      -c coordinates.txt \
                      -d TP53_RNA/
```   
  * Downloading multiple samples (using the downloaded sample sheet from the GDC repo)
```
./TCGA_splice_bam.sh -t token_file.txt \
                      -u gdc_sample_sheet.2018-05-02.tsv \
                      -g TP53 \
                      -d TP53_RNA/
```

#### __Additional info__
For additional info such as requirements, go to the GDC guide (https://docs.gdc.cancer.gov/API/Users_Guide/BAM_Slicing/)
