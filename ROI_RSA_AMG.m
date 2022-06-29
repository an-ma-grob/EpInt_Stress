%% Get Neural RDMs 

%------------------------------------------------------------------------
% You first need to warp masks back in native space, you can use the SPM
% pull function for this 
%------------------------------------------------------------------------

clear all
addpath(genpath('C:\spm12'))
spm('defaults','fmri');
spm_jobman('initcfg');
always = '...\EPINT_';

toolboxRoot = '...\rsatoolbox';
addpath(genpath(toolboxRoot));
cd(toolboxRoot)
import rsatoolbox.Engines.*
import Modules.*

List = dir(['...\Sims\Logs\*.mat']);
for i = 1:length(List) 
names(i,1) = {[List(i).name(5:10)]};
end

codes = names; 

%% Compute neural RDMs
for i = 1:length(codes) 
    
    current = ['...\Analysis\Sims\RSA\First_Level\',char(codes(i)),filesep];
    vp = dir([always,char(names(i)),'*']);
    c = strcat(vp.folder, vp.name);
    
    now = strcat(c,'\Dicom_Import\Struct\');
    

userOptions = defineUserOptions;
userOptions.analysisName = ['ROIs_',char(codes(i))];   %% Name of Analysis
userOptions.rootPath = ['...\RSA_ROI\'];
userOptions.maskPath = [now, '[[maskName]]','.nii'];
userOptions.maskNames = {'wRight_AnteriorHC';'wLeft_AnteriorHC';...
                        'wRight_PosteriorHC'; 'wLeft_PosteriorHC' }; 
userOptions.betaPath = ['...\Analysis\Sims\RSA\First_Level\',codes{i},'\[[betaIdentifier]]'];    
userOptions.subjectNames = codes(i); 

% Load in the fMRI data
fullBrainVols = fMRIDataPreparation(betaCorrespondence, userOptions);
% load in the masks
binaryMasks_native = fMRIMaskPreparation(userOptions);
% Mask the braindata
responsePatterns = fMRIDataMasking(fullBrainVols, binaryMasks_native,betaCorrespondence, userOptions);

%Make the RDMs
RDMs = constructRDMs(responsePatterns, betaCorrespondence, userOptions);

end



