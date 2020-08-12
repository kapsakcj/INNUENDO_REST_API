#!/bin/bash

: '
This script allows the retrieval of the legacy wgMLST profiles dataset
information available for the species covered by the INNUENDO Platform.
The user can provide an outdir, one of the available profile versions,
the path for the fastMLST program and for allegrograph.

NOTE: Should be run on the INNUENDO_REST_API folder.
'

# RUN on INNUENDO_REST_API folder

innuendo_dir=$(pwd)

# INNUENDO DIR
echo "INNUENDO dir: ${innuendo_dir}"
# Output dir
echo "Out dir: ${1}"
# Fast MLST Path
echo "fastmlst path: ${2}"
# Allegrograph client
echo "allegro client: ${3}"
export PYTHONPATH="${3}/src"
# Import version
echo "Import version: ${4}"
# Prepare Yersinia enterocolitica data
echo "---> Checking Yersinia enterocolitica data  ..."

# Create folders on defined outdir
mkdir -p ${1}/${4}/legacy_profiles
mkdir -p ${1}/${4}/indexes
mkdir -p ${1}/${4}/classifications
mkdir -p ${1}/${4}/legacy_metadata
mkdir -p ${1}/${4}/core_lists

# Check if the Y. enterocolitica file exists in the out directory, If not, it
# will download all the required files and build the Yersinia database.
if [ ! -f "${1}/${4}/legacy_profiles/profiles_Yersinia.tsv" ]; then

    echo "---> Downloading legacy dataset  ..."
    cd ${1}/${4}/legacy_profiles
    # Get wgMLST profiles for Y. enterocolitica
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Yenterocolitica_wgMLST_alleleProfiles.tsv
    mv Yenterocolitica_wgMLST_alleleProfiles.tsv profiles_Yersinia.tsv
    # Get the metadata for the Y. enterocolitica legacy dataset
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Yenterocolitica_metadata.txt
    mv Yenterocolitica_metadata.txt Yersinia_enterocolitica_metadata.txt
    # Get the list of core genes for this schema
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Yenterocolitica_cgMLST_2406_listGenes.txt
    mv Yenterocolitica_cgMLST_2406_listGenes.txt cgMLST_list_Yersinia.txt
   # GEt the INNUENDO classification for the legacy dataset
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Yentero_correct_classification.txt
    mv Yentero_correct_classification.txt goeBURST_cgMLST_9_133_1189_yersinia.txt.1
    mv Yersinia_enterocolitica_metadata.txt ../legacy_metadata/
    mv goeBURST_cgMLST_9_133_1189_yersinia.txt.1 ../classifications/goeBURST_cgMLST_9_133_1189_yersinia.txt

    cd ${innuendo_dir}

    echo "---> Parsing mlst profiles file  ..."
    python extract_core_from_wg.py -i ${1}/${4}/legacy_profiles/profiles_Yersinia.tsv -g ${1}/${4}/legacy_profiles/cgMLST_list_Yersinia.txt -o ${1}/${4}/legacy_profiles/results_alleles_yersinia_wg --inverse --onlyreplace

    echo "---> Extracting mlst profiles ..."
    python extract_core_from_wg.py -i ${1}/${4}/legacy_profiles/profiles_Yersinia.tsv -g ${1}/${4}/legacy_profiles/cgMLST_list_Yersinia.txt -o ${1}/${4}/legacy_profiles/results_alleles_yersinia_core --inverse

    echo "---> Copying profiles headers files ..."
    cp ${1}/${4}/legacy_profiles/results_alleles_yersinia_core_headers.txt ${1}/${4}/core_lists/yersinia_headers_core.txt
    cp ${1}/${4}/legacy_profiles/results_alleles_yersinia_wg_headers.txt ${1}/${4}/core_lists/yersinia_headers_wg.txt

    echo "---> Copying initial profile files for index build ..."
    rm ${1}/${4}/indexes/yersinia_wg_profiles.tab
    rm ${1}/${4}/indexes/yersinia_core_profiles.tab
    cp ${1}/${4}/legacy_profiles/results_alleles_yersinia_core.tsv ${1}/${4}/indexes/yersinia_core_profiles.tab
    cp ${1}/${4}/legacy_profiles/results_alleles_yersinia_wg.tsv ${1}/${4}/indexes/yersinia_wg_profiles.tab

    echo "---> Building profile file index ..."
    rm ${1}/${4}/indexes/yersinia_core.idx
    rm ${1}/${4}/indexes/yersinia_wg.idx
    rm ${1}/${4}/indexes/yersinia_core.ids
    rm ${1}/${4}/indexes/yersinia_wg.ids
    cat ${1}/${4}/indexes/yersinia_core_profiles.tab | ${2}/src/main -i ${1}/${4}/indexes/yersinia_core -b
    cat ${1}/${4}/indexes/yersinia_wg_profiles.tab | ${2}/src/main -i ${1}/${4}/indexes/yersinia_wg -b

    echo "---> Populating Profile Database ..."
    flask/bin/python mlst_profiles_to_db.py -i ${1}/${4}/legacy_profiles/profiles_Yersinia.tsv -c ${1}/${4}/classifications/goeBURST_cgMLST_9_133_1189_yersinia.txt -m ${1}/${4}/legacy_metadata/Yersinia_enterocolitica_metadata.txt -d Yersinia -p NFP -v ${4}

fi

echo "---> Checking Salmonella enterica data  ..."

# Check if the S. enterica file exists in the out directory, If not, it
# will download all the required files and build the Salmonella database.
if [ ! -f "${1}/${4}/legacy_profiles/profiles_Salmonella.tsv" ]; then

    echo "---> Downloading legacy dataset  ..."
    cd ${1}/${4}/legacy_profiles
    # Get wgMLST profiles for S. enterica
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Senterica_wgMLST_alleleProfiles.tsv
    mv Senterica_wgMLST_alleleProfiles.tsv profiles_Salmonella.tsv
    # Get S. enterica metadata for the legacy dataset
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Senterica_metadata.txt
    mv Senterica_metadata.txt Salmonella_enterica_metadata.txt
    # Get the list of cgMLST genes for S. enterica in the legacy schema
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Senterica_cgMLST_3255_listGenes.txt
    mv Senterica_cgMLST_3255_listGenes.txt cgMLST_list_Salmonella.txt
    # Get INNUENDO classification file
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Salmonella_goeBURST_cgMLST_cleaned.-.goeBURST_cgMLST_cleaned.tsv
    mv Salmonella_goeBURST_cgMLST_cleaned.-.goeBURST_cgMLST_cleaned.tsv goeBURST_cgMLST_7_338_997_salmonella.txt.1
    mv Salmonella_enterica_metadata.txt ../legacy_metadata/
    mv goeBURST_cgMLST_7_338_997_salmonella.txt.1 ../classifications/goeBURST_cgMLST_7_338_997_salmonella.txt

    cd ${innuendo_dir}

    echo "---> Parsing mlst profiles file  ..."
    python extract_core_from_wg.py -i ${1}/${4}/legacy_profiles/profiles_Salmonella.tsv -g ${1}/${4}/legacy_profiles/cgMLST_list_Salmonella.txt -o ${1}/${4}/legacy_profiles/results_alleles_salmonella_wg --inverse --onlyreplace

    echo "---> Extracting mlst profiles ..."
    python extract_core_from_wg.py -i ${1}/${4}/legacy_profiles/profiles_Salmonella.tsv -g ${1}/${4}/legacy_profiles/cgMLST_list_Salmonella.txt -o ${1}/${4}/legacy_profiles/results_alleles_salmonella_core --inverse

    echo "---> Copying profiles headers files ..."
    cp ${1}/${4}/legacy_profiles/results_alleles_salmonella_core_headers.txt ${1}/${4}/core_lists/salmonella_headers_core.txt
    cp ${1}/${4}/legacy_profiles/results_alleles_salmonella_wg_headers.txt ${1}/${4}/core_lists/salmonella_headers_wg.txt

    echo "---> Copying initial profile files for index build ..."
    rm ${1}/${4}/indexes/salmonella_wg_profiles.tab
    rm ${1}/${4}/indexes/salmonella_core_profiles.tab
    cp ${1}/${4}/legacy_profiles/results_alleles_salmonella_core.tsv ${1}/${4}/indexes/salmonella_core_profiles.tab
    cp ${1}/${4}/legacy_profiles/results_alleles_salmonella_wg.tsv ${1}/${4}/indexes/salmonella_wg_profiles.tab

    echo "---> Building profile file index ..."
    rm ${1}/${4}/indexes/salmonella_core.idx
    rm ${1}/${4}/indexes/salmonella_wg.idx
    rm ${1}/${4}/indexes/salmonella_core.ids
    rm ${1}/${4}/indexes/salmonella_wg.ids
    cat ${1}/${4}/indexes/salmonella_core_profiles.tab | ${2}/src/main -i ${1}/${4}/indexes/salmonella_core -b
    cat ${1}/${4}/indexes/salmonella_wg_profiles.tab | ${2}/src/main -i ${1}/${4}/indexes/salmonella_wg -b

    echo "---> Populating Profile Database ..."
    flask/bin/python mlst_profiles_to_db.py -i ${1}/${4}/legacy_profiles/profiles_Salmonella.tsv -c ${1}/${4}/classifications/goeBURST_cgMLST_7_338_997_salmonella.txt -m ${1}/${4}/legacy_metadata/Salmonella_enterica_metadata.txt -d Salmonella -p NFP -v ${4}

fi

echo "---> Checking Escherichia coli data  ..."

# Check if the E. coli file exists in the out directory, If not, it
# will download all the required files and build the Ecoli database.
if [ ! -f "${1}/${4}/legacy_profiles/profiles_Ecoli.tsv" ]; then

    echo "---> Downloading legacy dataset  ..."
    cd ${1}/${4}/legacy_profiles
    # Get E. coli profiles for the legacy dataset
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Ecoli_wgMLST_alleleProfiles.tsv
    mv Ecoli_wgMLST_alleleProfiles.tsv profiles_Ecoli.tsv
    # Get the E. coli metadata
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Ecoli_metadata.txt
    mv Ecoli_metadata.txt Escherichia_coli_metadata.txt
    # Get the list of core genes for the legacy E. coli schema
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Ecoli_cgMLST_2360_listGenes.txt
    mv Ecoli_cgMLST_2360_listGenes.txt cgMLST_list_Ecoli.txt
    # Get the INNUENDO classification for E. coli
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Ecoli_goeBURST_FULL_pub.-.goeBURST_FULL.tsv
    mv Ecoli_goeBURST_FULL_pub.-.goeBURST_FULL.tsv goeBURST_FULL_8_112_793_ecoli.txt
    mv Escherichia_coli_metadata.txt ../legacy_metadata/
    mv goeBURST_FULL_8_112_793_ecoli.txt ../classifications/goeBURST_FULL_8_112_793_ecoli.txt

    cd ${innuendo_dir}

    echo "---> Parsing mlst profiles file  ..."
    python extract_core_from_wg.py -i ${1}/${4}/legacy_profiles/profiles_Ecoli.tsv -g ${1}/${4}/legacy_profiles/cgMLST_list_Ecoli.txt -o ${1}/${4}/legacy_profiles/results_alleles_ecoli_wg --inverse --onlyreplace

    echo "---> Extracting mlst profiles ..."
    python extract_core_from_wg.py -i ${1}/${4}/legacy_profiles/profiles_Ecoli.tsv -g ${1}/${4}/legacy_profiles/cgMLST_list_Ecoli.txt -o ${1}/${4}/legacy_profiles/results_alleles_ecoli_core --inverse

    echo "---> Copying profiles headers files ..."
    cp ${1}/${4}/legacy_profiles/results_alleles_ecoli_core_headers.txt ${1}/${4}/core_lists/ecoli_headers_core.txt
    cp ${1}/${4}/legacy_profiles/results_alleles_ecoli_wg_headers.txt ${1}/${4}/core_lists/ecoli_headers_wg.txt

    echo "---> Copying initial profile files for index build ..."
    rm ${1}/${4}/indexes/ecoli_wg_profiles.tab
    rm ${1}/${4}/indexes/ecoli_core_profiles.tab
    cp ${1}/${4}/legacy_profiles/results_alleles_ecoli_core.tsv ${1}/${4}/indexes/ecoli_core_profiles.tab
    cp ${1}/${4}/legacy_profiles/results_alleles_ecoli_wg.tsv ${1}/${4}/indexes/ecoli_wg_profiles.tab

    echo "---> Building profile file index ..."
    rm ${1}/${4}/indexes/ecoli_core.idx
    rm ${1}/${4}/indexes/ecoli_wg.idx
    rm ${1}/${4}/indexes/ecoli_core.ids
    rm ${1}/${4}/indexes/ecoli_wg.ids
    cat ${1}/${4}/indexes/ecoli_core_profiles.tab | ${2}/src/main -i ${1}/${4}/indexes/ecoli_core -b
    cat ${1}/${4}/indexes/ecoli_wg_profiles.tab | ${2}/src/main -i ${1}/${4}/indexes/ecoli_wg -b

    echo "---> Populating Profile Database ..."
    flask/bin/python mlst_profiles_to_db.py -i ${1}/${4}/legacy_profiles/profiles_Ecoli.tsv -c ${1}/${4}/classifications/goeBURST_FULL_8_112_793_ecoli.txt -m ${1}/${4}/legacy_metadata/Escherichia_coli_metadata.txt -d E.coli -p NFP -v ${4}

fi

echo "---> Checking Campylobacter jejuni data  ..."

# Check if the C. jejuni file exists in the out directory, If not, it
# will download all the required files and build the Campy database.
if [ ! -f "${1}/${4}/legacy_profiles/profiles_Cjejuni.tsv" ]; then

    echo "---> Downloading legacy dataset  ..."
    cd ${1}/${4}/legacy_profiles
    # Get C. jejuni profiles
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Cjejuni_wgMLST_alleleProfiles.tsv
    mv Cjejuni_wgMLST_alleleProfiles.tsv profiles_Cjejuni.tsv
    # Get C. jejuni metadata
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Cjejuni_metadata.txt
    mv Cjejuni_metadata.txt Campylobacter_jejuni_metadata.txt
    # Get list of core genes from C. jejuni dataset
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Cjejuni_cgMLST_678_listGenes.txt
    mv Cjejuni_cgMLST_678_listGenes.txt cgMLST_list_cjejuni.tsv
    # Get INNUENDO classification for C. jejuni
    wget https://github.com/bfrgoncalves/INNUENDO_schemas/releases/download/1.1/Campylobacter_goeBURST_cgMLST_correct.tsv
    mv Campylobacter_goeBURST_cgMLST_correct.tsv goeBURST_cgMLST_4_59_292_campy.txt
    mv Campylobacter_jejuni_metadata.txt ../legacy_metadata/
    mv goeBURST_cgMLST_4_59_292_campy.txt ../classifications/goeBURST_cgMLST_4_59_292_campy.txt

    cd ${innuendo_dir}

    echo "---> Parsing mlst profiles file  ..."
    python extract_core_from_wg.py -i ${1}/${4}/legacy_profiles/profiles_Cjejuni.tsv -g ${1}/${4}/legacy_profiles/cgMLST_list_cjejuni.tsv -o ${1}/${4}/legacy_profiles/results_alleles_campy_wg --inverse --onlyreplace

    echo "---> Extracting mlst profiles ..."
    python extract_core_from_wg.py -i ${1}/${4}/legacy_profiles/profiles_Cjejuni.tsv -g ${1}/${4}/legacy_profiles/cgMLST_list_cjejuni.tsv -o ${1}/${4}/legacy_profiles/results_alleles_campy_core --inverse

    echo "---> Copying profiles headers files ..."
    cp ${1}/${4}/legacy_profiles/results_alleles_campy_core_headers.txt ${1}/${4}/core_lists/campy_headers_core.txt
    cp ${1}/${4}/legacy_profiles/results_alleles_campy_wg_headers.txt ${1}/${4}/core_lists/campy_headers_wg.txt

    echo "---> Copying initial profile files for index build ..."
    rm ${1}/${4}/indexes/campy_wg_profiles.tab
    rm ${1}/${4}/indexes/campy_core_profiles.tab
    cp ${1}/${4}/legacy_profiles/results_alleles_campy_core.tsv ${1}/${4}/indexes/campy_core_profiles.tab
    cp ${1}/${4}/legacy_profiles/results_alleles_campy_wg.tsv ${1}/${4}/indexes/campy_wg_profiles.tab

    echo "---> Building profile file index ..."
    rm ${1}/${4}/indexes/campy_core.idx
    rm ${1}/${4}/indexes/campy_wg.idx
    rm ${1}/${4}/indexes/campy_core.ids
    rm ${1}/${4}/indexes/campy_wg.ids
    cat ${1}/${4}/indexes/campy_core_profiles.tab | ${2}/src/main -i ${1}/${4}/indexes/campy_core -b
    cat ${1}/${4}/indexes/campy_wg_profiles.tab | ${2}/src/main -i ${1}/${4}/indexes/campy_wg -b

    echo "---> Populating Profile Database ..."
    flask/bin/python mlst_profiles_to_db.py -i ${1}/${4}/legacy_profiles/profiles_Cjejuni.tsv -c ${1}/${4}/classifications/goeBURST_cgMLST_4_59_292_campy.txt -m ${1}/${4}/legacy_metadata/Campylobacter_jejuni_metadata.txt -d Campylobacter -p NFP -v ${4}

fi

# Check if the V. cholerae file exists in the out directory, If not, it
# will download all the required files and build the Salmonella database.
if [ ! -f "${1}/${4}/legacy_profiles/profiles_VibrioCholerae.tsv" ]; then

     echo "---> Downloading legacy dataset  ..."
     cd ${1}/${4}/legacy_profiles
     # Get wgMLST profiles for V. cholerae
     wget https://raw.githubusercontent.com/kapsakcj/INNUENDO_schemas/master/Vcholerae_cgMLST_alleleProfiles.txt
     mv Vcholerae_cgMLST_alleleProfiles.txt profiles_VibrioCholerae.tsv
     # Get V. cholerae metadata for the legacy dataset
     wget https://raw.githubusercontent.com/kapsakcj/INNUENDO_schemas/master/Vcholerae_metadata.txt
     mv Vcholerae_metadata.txt Vibrio_cholerae_metadata.txt
     # Get the list of cgMLST genes for V. cholerae in the legacy schema
     wget https://raw.githubusercontent.com/kapsakcj/INNUENDO_schemas/master/Vcholerae_cgMLST_2404_listGenes.txt
     mv Vcholerae_cgMLST_2404_listGenes.txt cgMLST_list_VibrioCholerae.txt
     # Get INNUENDO classification file
     wget https://raw.githubusercontent.com/kapsakcj/INNUENDO_schemas/master/Vcholera_correct_classification.txt
     # no need to rename our VC correct classification file
     #mv Salmonella_goeBURST_cgMLST_cleaned.-.goeBURST_cgMLST_cleaned.tsv goeBURST_cgMLST_7_338_997_salmonella.txt.1

     # move metadata
     mv Vibrio_cholerae_metadata.txt ../legacy_metadata/
     # move INNUENDO classification file
     mv Vcholera_correct_classification.txt ../classifications/

     cd ${innuendo_dir}

     echo "---> Parsing mlst profiles file  ..."
     python extract_core_from_wg.py -i ${1}/${4}/legacy_profiles/profiles_VibrioCholerae.tsv -g ${1}/${4}/legacy_profiles/cgMLST_list_VibrioCholerae.txt -o ${1}/${4}/legacy_profiles/results_alleles_vibrio_wg --inverse --onlyreplace

     echo "---> Extracting mlst profiles ..."
     python extract_core_from_wg.py -i ${1}/${4}/legacy_profiles/profiles_VibrioCholerae.tsv -g ${1}/${4}/legacy_profiles/cgMLST_list_VibrioCholerae.txt -o ${1}/${4}/legacy_profiles/results_alleles_vibrio_core --inverse

     echo "---> Copying profiles headers files ..."
     cp ${1}/${4}/legacy_profiles/results_alleles_vibrio_core_headers.txt ${1}/${4}/core_lists/vibrio_headers_core.txt
     cp ${1}/${4}/legacy_profiles/results_alleles_vibrio_wg_headers.txt ${1}/${4}/core_lists/vibrio_headers_wg.txt

     echo "---> Copying initial profile files for index build ..."
     rm ${1}/${4}/indexes/vibrio_wg_profiles.tab
     rm ${1}/${4}/indexes/vibrio_core_profiles.tab
     cp -v ${1}/${4}/legacy_profiles/results_alleles_vibrio_core.tsv ${1}/${4}/indexes/vibrio_core_profiles.tab
     cp -v ${1}/${4}/legacy_profiles/results_alleles_vibrio_wg.tsv ${1}/${4}/indexes/vibrio_wg_profiles.tab

     echo "---> Building profile file index ..."
     rm ${1}/${4}/indexes/vibrio_core.idx
     rm ${1}/${4}/indexes/vibrio_wg.idx
     rm ${1}/${4}/indexes/vibrio_core.ids
     rm ${1}/${4}/indexes/vibrio_wg.ids
     cat ${1}/${4}/indexes/vibrio_core_profiles.tab | ${2}/src/main -i ${1}/${4}/indexes/vibrio_core -b
     cat ${1}/${4}/indexes/vibrio_wg_profiles.tab | ${2}/src/main -i ${1}/${4}/indexes/vibrio_wg -b

     echo "---> Populating Profile Database ..."
     flask/bin/python mlst_profiles_to_db.py -i ${1}/${4}/legacy_profiles/profiles_VibrioCholerae.tsv -c ${1}/${4}/classifications/Vcholera_correct_classification.txt -m ${1}/${4}/legacy_metadata/Vibrio_cholerae_metadata.txt -d Vibrio -p NFP -v ${4}
fi
