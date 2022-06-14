% matlab -nodesktop -nosplash
% Add dependencies to path
if isdir('/Volumes/diedrichsen_data$/data')
    workdir='/Volumes/diedrichsen_data$/data';
elseif isdir('/srv/diedrichsen/data')
    workdir='/srv/diedrichsen/data';
else
    fprintf("Workdir not found. Mount or connect to server and try again.");
end
addpath(sprintf('%s/../matlab/spm12',workdir));
addpath(sprintf('%s/../matlab/spm12/toolbox/suit/',workdir));
addpath(sprintf('%s/../matlab/dataframe',workdir));
addpath(sprintf('%s/../matlab/imaging/tools/',workdir));

roi_path = sprintf('%s/Cerebellum/CerebellumWorkingMemory/rois/',workdir);


%%%%%% Left hemisphere ROIS %%%%%%%%


% import tesselation file
tesselation = gifti(sprintf('%s/../fs_LR_32/Icosahedron-362.32k.L.label.gii',roi_path));

% import roi list
roi_list = dir(sprintf('%s/Cerebellum/CerebellumWorkingMemory/rois/*left*_ico.txt',workdir));
n_rois = size(roi_list,1);

% roi names
roi_names = {roi_list(:).name};
roi_names{n_rois + 1} = '???';

% roi colors
cmap = colorcube(n_rois);
color_list =  [cmap ones(n_rois,1)];

% create empty roi file
roi_mask = struct('cdata', zeros(size(tesselation.cdata)));
roi_mask.labels.name = roi_names;
roi_mask.labels.key = [zeros(1, size(roi_list,1)+1)];
roi_mask.labels.rgba = [color_list; 0 0 0 0];


% read in every roi in list of rois
for r = 1:n_rois

    % import roi file
    roi_txt = readmatrix(sprintf('%s/%s',roi_list(r).folder, roi_list(r).name));   % load the ROI text fileparts

    % replace vertex values in roi_mask with roi value
    for t = 1:size(roi_txt,1)
        tessel = roi_txt(t);
        roi_mask.cdata(tesselation.cdata == tessel) = r;
    end
end
roi_mask.cdata = int32(roi_mask.cdata);
G=surf_makeLabelGifti(roi_mask.cdata, 'anatomicalStruct', 'CortexLeft')
save(G,sprintf('%s/rois_hand.L.label.gii', roi_path))



%%%%%% Right hemisphere ROIS %%%%%%%%

% import tesselation file
tesselation = gifti(sprintf('%s/../fs_LR_32/Icosahedron-362.32k.R.label.gii',roi_path));

% import roi list
roi_list = dir(sprintf('%s/Cerebellum/CerebellumWorkingMemory/rois/*right*_ico.txt',workdir));
n_rois = size(roi_list,1);


% read in every roi in list of rois
for r = 1:n_rois

    % import roi file
    roi_txt = readmatrix(sprintf('%s/%s',roi_list(r).folder, roi_list(r).name));   % load the ROI text fileparts

    % replace vertex values in roi_mask with roi value
    for t = 1:size(roi_txt,1)
        tessel = roi_txt(t);
        roi_mask.cdata(tesselation.cdata == tessel) = r;
    end
end
roi_mask.cdata = int32(roi_mask.cdata);
G=surf_makeLabelGifti(roi_mask.cdata, 'anatomicalStruct', 'CortexRight')
save(G,sprintf('%s/rois_hand.R.label.gii', roi_path))