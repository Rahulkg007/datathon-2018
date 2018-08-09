#!/bin/bash
# Transfering files to google storage
# @Author Rahul Gupta (Rahulkg007@gmail.com)
# @Date 04-Aug-2018
# @Updated 09-Aug-2018
# 
# Change output_file, raw_file variables and target table
# 

# -------------------------
# -- Variable declaration--
# -------------------------

output_file=sample1_scan_on.csv
raw_file=Samp_1/ScanOnTransaction
target_table=source.scan_on
list_of_files=files.txt
temp_path=tmp
source_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# -------------------------
# ----- Data Cleaning -----
# -------------------------

cd ../MelbDatathon2018/
rm $temp_path/*

# Locating all zipped files
find $raw_file -type f | grep  "\.gz$" > $list_of_files

# Read file and unzip them
cat $list_of_files | while read file
do
    cp $file $temp_path
    echo [$(date)] "$file copied"
done

# Unzipping files
echo [$(date)] "Starting -- File unzipping"
gunzip $temp_path/*.txt.gz
echo [$(date)] "Finished -- File unzipping"

# Replace pipe to comma
cd $temp_path
echo [$(date)] "Starting -- Replace pipe to comma"
perl -pi -w -e 's/\|/\,/g;' *.txt
echo [$(date)] "Finished -- Replace pipe to comma"

# change file extension from txt to csv
echo [$(date)] "Starting -- txt to csv"
for f in *.txt; do
    mv "$f" "${f%.txt}.csv"
done
echo [$(date)] "Finished -- txt to csv!"

cat *.csv >> $output_file
echo [$(date)] "Merge All file to one!"

# header="Mode,BusinessDate,DateTime,CardID,CardType,VehicleID,ParentRoute,RouteID,StopID"
# ex -sc "1i|$header" -cx $output_file
# echo "Header creation done"

no_of_records=`cat $output_file | wc -l`

echo [$(date)] "Starting -- File compression"
gzip $output_file
echo [$(date)] "Finished -- File compression"

# -------------------------
# --- Cloud Operations ----
# -------------------------

echo [$(date)] "Starting -- Transfer compressed source file to Google Cloud Storage"
gsutil cp $output_file.gz gs://datathon-2018/src/
echo [$(date)] "Finished -- Transfer compressed source file to Google Cloud Storage"

echo [$(date)] "Starting -- Google Cloud Storage to Big Query"
bq --location=US load --autodetect --noreplace --source_format=CSV $target_table gs://datathon-2018/src/$output_file.gz $source_path/scan_schema.json
echo [$(date)] "$no_of_records transaction copied"
echo [$(date)] "Finished -- Google Cloud Storage to Big Query"
