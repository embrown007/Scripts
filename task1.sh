#!/bin/bash

# set environment variable for URL
CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"

# set name for the file
CSV_FILE="csv_file.csv"
TRNSFRM_FILE="2023_year_finance.csv"

# set name of folders

CSV_FOLDER="raw"
TRNSFRM="Transformed"

# Create raw directory if it doesn't exist
mkdir -p "$CSV_FOLDER" "$TRNSFRM"

# Begin file download
echo "Downloading file......"

curl -o "$CSV_FOLDER/$CSV_FILE" "$CSV_URL" 

# check if download was successful
if [ $? -eq 0 ]; then

	echo "File download successfull"

	# check if file was saved to raw folder
	if [ -f "$CSV_FOLDER/$CSV_FILE" ]; then
		echo "File has been saved successfully in the $CSV_FOLDER folder"
		
		echo "Transformation in progress....."
		 awk -F, 'BEGIN {OFS=","}
        	NR==1 {
            		for (i=1; i<=NF; i++) {
                		if ($i == "Variable_code") {
                    			$i = "variable_code"
                		}
                		if ($i == "year" || $i == "Value" || $i == "Units" || $i == "variable_code") {
                    			cols[i] = 1
                		}
            		}
		}
        	{
            		out = ""
            		for (i=1; i<=NF; i++) {
                		if (i in cols) {
                    			out = (out != "" ? out "," : "") $i
                		}
            		}
            		print out
        	}' "$CSV_FOLDER/$CSV_FILE" > "$TRNSFRM/$TRNSFRM_FILE"

        	# Check if the transformation was successful
        	if [ -f "$TRNSFRM/$TRNSFRM_FILE" ]; then
            		echo "Transformation completed successfully."

        	else
            		echo "Error: Failed to create the transformed file."
        	fi

		# Copying file to Gold folder
		cp "$TRNSFRM/$TRNSFRM_FILE" "$GOLD/"

		#check if file in gold folder
		if [ -f "$GOLD_DIR/$TRNSFRM_FILE" ]; then
                	echo "File has been successfully loaded to the Gold directory."
		else
			echo "File failed to load to load to Gold directory"
		fi

	else 
	    	echo "Error: File failed to save in $CSV_FOLDER folder"
	fi

else 
	echo "Error: Failed to download file"
fi







