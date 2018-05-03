# TCBA_bam_splicer

### Download BAM sections from TCGA

__Usage__
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
