#!/bin/bash
# ------------------------------------------------------------------------------
# Script name:  wm_extract_rois.sh
#
# Description:  Script to extract ROIs from the Working Memory Task Network
#               
#
#
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------
# Dependencies
if [ -d /Volumes/diedrichsen_data$/data ]; then
workdir=/Volumes/diedrichsen_data$/data
elif [ -d /srv/diedrichsen/data ]; then 
workdir=/srv/diedrichsen/data
else
echo "Workdir not found. Mount or connect to server and try again."
fi
# --------------------------------------------------------------------------------------------------------
data_dir=${workdir}/Cerebellum/CerebellumWorkingMemory/WM_maps
# --------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------
# fsleyes \
# $SUITDIR/atlasesSUIT/SUIT.nii \
# $data_dir/suit/wgroup_con.encode_L2B-rest.nii -dr 0.1 0.4 -cm red-yellow \
# $data_dir/suit/wgroup_con.encode_L2F-rest.nii -dr 0.1 0.4 -cm red-yellow \
# $data_dir/suit/wgroup_con.encode_L4B-rest.nii -dr 0.1 0.4 -cm red-yellow \
# $data_dir/suit/wgroup_con.encode_L4F-rest.nii -dr 0.1 0.4 -cm red-yellow \
# $data_dir/suit/wgroup_con.encode_L6B-rest.nii -dr 0.1 0.4 -cm red-yellow \
# $data_dir/suit/wgroup_con.encode_L6F-rest.nii -dr 0.1 0.4 -cm red-yellow &

# freeview \
# $data_dir/suit/wgroup.encode-rest.cereb.func.gii  \
# $data_dir/suit/wgroup.encode-rest.cereb.func.gii  &

# ------------------------------- Extract peaks of mean activation ------------------------------
# wb_command -surface-geodesic-rois
# wb_command \
# -metric-extrema  \
# ${data_dir}/cortex/wgroup.mean_all-rest.L.func.gii -only-maxima


# ------------------------------- Manually choose ROI points ------------------------------
wb_view ${data_dir}/..//fs_LR_32/fs_LR.32k.L.inflated.surf.gii  \
${data_dir}/..//fs_LR_32/fs_LR.32k.R.inflated.surf.gii \
 ${data_dir}/cortex/wgroup.mean_all-rest.L.func.gii \
${data_dir}/cortex/wgroup.mean_all-rest.R.func.gii

# --> Save in file wm_rois.txt

# ------------------------------- Extract ROIs left and right ------------------------------
cat wm_rois.txt | grep "CortexLeft" | awk '{print $3}' > wm_rois_left.txt
cat wm_rois.txt | grep "CortexRight"| awk '{print $3}' > wm_rois_right.txt

mkdir ${data_dir}/../rois
# Extract Left ROIs
wb_command -surface-geodesic-rois ${data_dir}//fs_LR.32k.L.inflated.surf.gii \
8 \
wm_rois_left.txt ${data_dir}/../rois/wm_rois_left.func.gii

# Extract Right ROIs
wb_command -surface-geodesic-rois ${data_dir}//fs_LR.32k.R.inflated.surf.gii \
8 \
wm_rois_right.txt ${data_dir}/../rois/wm_rois_right.func.gii

# View resultant ROIs
wb_view \
${data_dir}//fs_LR.32k.R.inflated.surf.gii \
${data_dir}/wm_rois_right.func.gii &

# # ------------------------------- Extract ROIs based on extrema ------------------------------
# wb_command -metric-rois-from-extrema \
# ${data_dir}/..//fs_LR_32/fs_LR.32k.L.inflated.surf.gii \
# ${data_dir}/cortex/wgroup.mean_all-rest.L.func.gii \
# -overlap-logic CLOSEST \
# 8 \
# ${data_dir}/..//fs_LR_32/wm_rois_left_extrema.func.gii
# # --> doesn't look right


# ------------------------------- Choose 5 tessels around each ROI within the WM tesselations ------------------------------
code  wb_view ${data_dir}/..//fs_LR_32/fs_LR.32k.L.inflated.surf.gii  \


wb_view ${data_dir}/..//fs_LR_32/fs_LR.32k.L.inflated.surf.gii  \
${data_dir}/..//fs_LR_32/fs_LR.32k.R.inflated.surf.gii \
${data_dir}/cortex/wgroup.mean_all-rest.L.func.gii \
${data_dir}/cortex/wgroup.mean_all-rest.R.func.gii \
${data_dir}/../rois/wm_rois_left.func.gii \
${data_dir}/../rois/wm_rois_right.func.gii \
${data_dir}/../rois/tessels0362.label_6.L.label.gii \
${data_dir}/../rois/tessels0362.label_6.R.label.gii \
${data_dir}/../fs_LR_32//Icosahedron-362.32k.R.label.gii 
${data_dir}/../fs_LR_32//Icosahedron-362.32k.L.label.gii &

# ------------------------------- Choose 5 tessels around each ROI within the WM tesselations ------------------------------
roi_text_files=(\
'wm_roi_01_left_v1.txt' \
'wm_roi_02_left_spoc.txt' \
'wm_roi_03_left_parietal.txt' \
'wm_roi_04_left_m1.txt' \
'wm_roi_05_left_PMv.txt' \
'wm_roi_06_left_PMd.txt' \
'wm_roi_07_left_operculum.txt' \
'wm_roi_08_left_mfg.txt' \
'wm_roi_09_right_v1.txt' \
'wm_roi_10_right_ppc.txt' \
'wm_roi_11_right_SPLp.txt' \
'wm_roi_12_right_SPLa.txt' \
'wm_roi_13_right_PMv.txt' \
'wm_roi_14_right_PMd.txt' \
'wm_roi_15_right_operculum.txt' \
'wm_roi_16_right_mfg.txt')

for file in ${roi_text_files}; do
    cat ${data_dir}/../rois/$file | grep "Icosahedron" | awk '{print $3}' > ${data_dir}/../rois/${file%%.txt}_ico.txt
    cat ${data_dir}/../rois/$file | grep "Icosahedron" | awk '{print $3}' | wc
done

