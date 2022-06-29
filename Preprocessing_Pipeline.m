%-----------------------------------------------------------------------
% Preprocessing und First Level Script: Sims - Task 
% Anna-Maria 
% March 2020
%-----------------------------------------------------------------------
clear all;
addpath C:\spm12;
spm('defaults','fmri');
spm_jobman('initcfg');
always = '...\EPINT_';

%% Create names for loop over subjects 
List = dir(['...\Sims_Task\log\*.mat']);
for i = 1:length(List) 
names(i,1) = {[List(i).name(5:10)]};
end

%% For Slice time correction 
% TR, TA and slices 
slices = 62;
tr = 2;
ta = tr-(tr/slices);

% define slices for slice time correction 
hdr = spm_dicom_headers('...\EPINT_EO12AL.MR.STUDIEN_UNI-HAMBURG.0006.0001.2020.02.18.15.54.31.980782.7308569.IMA');
slice_times = hdr{1}.Private_0019_1029;
%%

%% Realign: Estimate, Reslice
%Functional Filesclear matlabbatch;
batch_counter = 0;
clear matlabbatch;
clear batch;

for i = 1:length(names)
    vp = dir([always,char(names(i)),'*']);
    current = strcat(vp.folder, vp.name);

    batch_counter = batch_counter + 1;
    
%% current directory 
now = strcat(current,'\Dicom_Import\Bold\Sims\');
% cd(now);
 
FuncFilenames_1 = {};
FuncFilenames_2 = {};
FuncFilenames_3 = {};
for block = 1:3
    outputdir = [now,'Block_',num2str(block)];
    functionalList = dir([outputdir,'\f*']);
    if block == 1
        for j = 1:length(functionalList)
            FuncFilenames_1(j,1) = {strcat(functionalList(j).folder,'\',functionalList(j).name,',1')};
        end
    elseif block == 2
        for j = 1:length(functionalList)
            FuncFilenames_2(j,1) = {strcat(functionalList(j).folder,'\',functionalList(j).name,',1')};
        end
    else
        for j = 1:length(functionalList)
            FuncFilenames_3(j,1) = {strcat(functionalList(j).folder,'\',functionalList(j).name,',1')};
        end
        
    end
end
    
block = 1;
matlabbatch{block}.spm.spatial.realign.estwrite.data = {FuncFilenames_1,FuncFilenames_2,FuncFilenames_3};
matlabbatch{block}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{block}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{block}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{block}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{block}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{block}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{block}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{block}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{block}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{block}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{block}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{block}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    
batch{batch_counter} = matlabbatch;

end

parfor i = 1:length(batch)
    spm_jobman('run', batch{i})
    disp(['Finished specify for job no.', i]);
end

%% General movement file
for i = 1:length(names)
    vp = dir([always,char(names(i)),'*']);
    current = strcat(vp.folder, vp.name);
    now = strcat(current,'\Dicom_Import\Bold\Sims\');

    
%general movement file --> move to GLM script 
for block = 1:3 
    outputdir = [now,'Block_',num2str(block)];
    functionalList(block,1) = dir([outputdir,'\rp*']);
    for k = 1:length(functionalList)
        FuncFilenames(k,1) = {strcat(functionalList(k).folder,'\',functionalList(k).name)};
    end
end

    one = load(char(FuncFilenames(1)));
    two = load(char(FuncFilenames(2)));
    three = load(char(FuncFilenames(3)));
    rp_general = [one; two; three];
    
    writematrix(rp_general,[now,'rp_general.txt']);

end

%% Slice Time correction 
batch_counter = 0;
clear matlabbatch;
clear batch;

for i = 1:length(names)
    vp = dir([always,char(names(i)),'*']);
    current = strcat(vp.folder, vp.name);

    batch_counter = batch_counter + 1;
    
%% current directory 
now = strcat(current,'\Dicom_Import\Bold\Sims\');
clear block;
clear j;

FuncFilenames_1 = {};
FuncFilenames_2 = {};
FuncFilenames_3 = {};
for block = 1:3
    outputdir = [now,'Block_',num2str(block)];
    functionalList = dir([outputdir,'\rf*']);
    if block == 1
        for j = 1:length(functionalList)
            FuncFilenames_1(j,1) = {strcat(functionalList(j).folder,'\',functionalList(j).name,',1')};
        end
    elseif block == 2
        for j = 1:length(functionalList)
            FuncFilenames_2(j,1) = {strcat(functionalList(j).folder,'\',functionalList(j).name,',1')};
        end
    else
        for j = 1:length(functionalList)
            FuncFilenames_3(j,1) = {strcat(functionalList(j).folder,'\',functionalList(j).name,',1')};
        end
        
    end
end
    
block = 1;
matlabbatch{block}.spm.temporal.st.scans = {FuncFilenames_1,FuncFilenames_2,FuncFilenames_3};
matlabbatch{block}.spm.temporal.st.nslices = slices;
matlabbatch{block}.spm.temporal.st.tr = tr;
matlabbatch{block}.spm.temporal.st.ta = ta;
matlabbatch{block}.spm.temporal.st.so = slice_times;
matlabbatch{block}.spm.temporal.st.refslice = 15; 
matlabbatch{block}.spm.temporal.st.prefix = 'a';

batch{batch_counter} = matlabbatch;
end

parfor i = 1:length(batch)
    spm_jobman('run', batch{i})
    disp(['Finished specify for job no.', i]);
end

%% Coregistration: Estimation & Reslice 
batch_counter = 0;
clear batch;
clear matlabbatch;

for i = 1:length(names)
    vp = dir([always,char(names(i)),'*']);
    current = strcat(vp.folder, vp.name);

    batch_counter = batch_counter + 1;
    
%% current directory 
now = strcat(current,'\Dicom_Import\Bold\Sims\'); 
clear block;
clear j;

    % define meanImage
    m = dir([now,'Block_1','\mean*']);
    mean = {};
    mean = {strcat(m.folder,'\',m(1).name)};
    
    % struct image
    s = strcat(current,'\Dicom_Import\Struct');
    st = dir([s,'\s*']);
    struct = {};
    struct = {strcat(st(1).folder,'\',st(1).name,',1')};
    
    block = 1; 
    matlabbatch{block}.spm.spatial.coreg.estwrite.ref = mean;
    matlabbatch{block}.spm.spatial.coreg.estwrite.source = struct;
    %matlabbatch{block}.spm.spatial.coreg.estwrite.other = FuncFilenames;
    matlabbatch{block}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{block}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{block}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{block}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{block}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    matlabbatch{block}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{block}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{block}.spm.spatial.coreg.estwrite.roptions.prefix = 'c';
    
    batch{batch_counter} = matlabbatch;
end

parfor i = 1:length(batch)
    spm_jobman('run', batch{i})
    disp(['Finished specify for job no.', i]);
end

% %% Segmentation: get GM, CSF,.. to create masks  
% % get struct image
% batch_counter = 0;
% clear batch;
% clear matlabbatch;
% 
% for i = 1:length(names)
%     
%     vp = dir([always,char(names(i)),'*']);
%     current = strcat(vp.folder, vp.name);
% 
%     batch_counter = batch_counter + 1;
%     
% %% current directory 
% now = strcat(current,'\Dicom_Import\Bold\Sims\');
% clear block;
% clear j;
% 
% s = strcat(current,'\Dicom_Import\Struct');
% if ~isdir([s,'\GM.nii']) 
% st = dir([s,'\cs*']);
% struct = {};
% % Eventuell noch ändern: muss nicht (1) sein, funktioniert aber vermutlich
% % trotzdem 
% struct = {strcat(st(1).folder,'\',st(1).name,',1')};
% 
% matlabbatch{1}.spm.spatial.preproc.channel.vols = struct;
% matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
% matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
% matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
% %gray matter
% matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'C:\spm12\tpm\TPM.nii,1'};
% matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
% matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
% matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
% % white matter
% matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'C:\spm12\tpm\TPM.nii,2'};
% matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
% matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
% matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
% % CSF 
% matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'C:\spm12\tpm\TPM.nii,3'};
% matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
% matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
% matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
% matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'C:\spm12\tpm\TPM.nii,4'};
% matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
% matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [0 0];
% matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
% matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'C:\spm12\tpm\TPM.nii,5'};
% matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
% matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [0 0];
% matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
% matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'C:\spm12\tpm\TPM.nii,6'};
% matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
% matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
% matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
% matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
% matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
% matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
% matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
% matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
% matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
% matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0];
% end
% 
%     batch{batch_counter} = matlabbatch;
% end
% 
% parfor i = 1:length(batch)
%     spm_jobman('run', batch{i})
%     disp(['Finished specify for job no.', i]);
% end


%% Normalization: Estimate & Write
batch_counter = 0;
clear batch;
clear matlabbatch;

for i = 1:length(names)
    clear matlabbatch;
    clear struct; 
    vp = dir([always,char(names(i)),'*']);
    current = strcat(vp.folder, vp.name);

    batch_counter = batch_counter + 1;
    
%% current directory 
now = strcat(current,'\Dicom_Import\Bold\Sims\'); 
clear block;
clear j;

% get struct image
s = strcat(current,'\Dicom_Import\Struct');
st = dir([s,'\cs*']);
struct = {};
struct = {strcat(st(1).folder,'\',st(1).name,',1')};

for block = 1:3
    outputdir = [now,'Block_',num2str(block)];
    functionalList = dir([outputdir,'\arf*']);
    FuncFilenames = {};
    for j = 1:length(functionalList)
        FuncFilenames(j,1) = {strcat(functionalList(j).folder,'\',functionalList(j).name,',1')};
    end
    
    matlabbatch{block}.spm.spatial.normalise.estwrite.subj(1).vol(1) = struct;
    matlabbatch{block}.spm.spatial.normalise.estwrite.subj(1).resample = FuncFilenames;
    matlabbatch{block}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{block}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
    matlabbatch{block}.spm.spatial.normalise.estwrite.eoptions.tpm = {'C:\spm12\tpm\TPM.nii'};
    matlabbatch{block}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
    matlabbatch{block}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{block}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
    matlabbatch{block}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
    matlabbatch{block}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{block}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
    matlabbatch{block}.spm.spatial.normalise.estwrite.woptions.interp = 4;
    matlabbatch{block}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
       
end

batch{batch_counter} = matlabbatch;

end

parfor i = 1:length(batch)
    spm_jobman('run', batch{i})
    disp(['Finished specify for job no.', i]);
end

%% Smoothing 
batch_counter = 0;
clear batch;
clear matlabbatch;
for i =  1:length(names)
    vp = dir([always,char(names(i)),'*']);
    current = strcat(vp.folder, vp.name);

    batch_counter = batch_counter + 1;
    
%% current directory 
now = strcat(current,'\Dicom_Import\Bold\Sims\'); 
clear block;
clear j;

for block = 1:3
    outputdir = [now,'Block_',num2str(block)];
    functionalList = dir([outputdir,'\warf*']);
    FuncFilenames = {};
    for j = 1:length(functionalList)
        FuncFilenames(j,1) = {strcat(functionalList(j).folder,'\',functionalList(j).name,',1')};
    end
    
    matlabbatch{block}.spm.spatial.smooth.data = FuncFilenames;
    matlabbatch{block}.spm.spatial.smooth.fwhm = [6 6 6]; %Gaussian filter should be 2-3 times voxel size
    matlabbatch{block}.spm.spatial.smooth.dtype = 0;
    matlabbatch{block}.spm.spatial.smooth.im = 0;
    matlabbatch{block}.spm.spatial.smooth.prefix = 's';
    
    
    batch{batch_counter} = matlabbatch;
end
end

parfor i = 1:length(batch)
    spm_jobman('run', batch{i})
    disp(['Finished specify for job no.', i]);
end

batch_counter = 0;