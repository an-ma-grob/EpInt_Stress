%% Model specification for RSA %% 

clear all;
addpath C:\spm12;
spm('defaults','fmri');
spm_jobman('initcfg');
always = '...\EPINT_';
MCF_files = '...\Paradigmen\Sims_Task\log\MCF_RSA';

%% Create names for loop over subjects 
List = dir(['H:\Paradigmen\Sims_Task\log\*.mat']);
for i = 1:length(List) 
names(i,1) = {[List(i).name(5:10)]};
end


batch_counter = 0;
clear batch;
clear matlabbatch;
clear struct; 
for i = 1:length(names)
    vp = dir([always,char(names(i)),'*']);
    current = strcat(vp.folder, vp.name);
    
    batch_counter = batch_counter + 1;

%% current directory 
now = strcat(current,'\Dicom_Import\Bold\Sims\');
cd(now);

%% Model specification

counter = 1;
FuncFilenames = {};
for block = 1:3
    outputdir = [now,'Block_',num2str(block)];
    functionalList = dir([outputdir,'\arf*']); %take non-normalized, smoothing and normalization will take place later 
    for l = 1:length(functionalList)
        FuncFilenames{counter,1} = strcat(functionalList(l).folder,'\',functionalList(l).name,',1');
        counter = counter + 1;
    end
end


% MCF file 
cd(MCF_files);
MCF = dir(strcat('*',names{i},'.mat')); 
file = {strcat(MCF.folder,'\',MCF.name)};
    
% Movement parameter
% in = now;
mo = dir([now, '\rp*']);
mov = {strcat(mo.folder,'\',mo.name)};

%% calculate GLM - model estimation  
clear matlabbatch;
Analysis = char(strcat('H:\Analysis\Sims\RSA\First_Level',filesep,char(names(i))));

if ~isfolder(Analysis)
    mkdir(Analysis);
end

cd(Analysis);
matlabbatch{1}.spm.stats.fmri_spec.dir = {Analysis};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 62;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 15;
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = FuncFilenames;

matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = file;
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = mov;
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.2;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

 batch{batch_counter} = matlabbatch;
end

parfor i = 1:length(batch)
    spm_jobman('run', batch{i})
    disp(['Finished specify for job no.', i]);
end


%% Concatenation of Blocks 
for i =  1:length(names)
    vp = dir([always,char(names(i)),'*']);
    current = strcat(vp.folder, vp.name);
   

%% current directory 
now = strcat(current,'\Dicom_Import\Bold\Sims\');
Analysis = char(strcat('...\Analysis\Sims\RSA\First_Level',filesep,char(names(i))));

cd(now);
n_block1 = length(dir([now,'Block_1\f*']));
n_block2 = length(dir([now,'Block_2\f*']));
n_block3 = length(dir([now,'Block_3\f*']));

scans = [n_block1, n_block2, n_block3];

spm_fmri_concatenate([Analysis,'\SPM.mat'], scans);

end

%% Model estimation
batch_counter = 0;
clear batch;
clear matlabbatch;
for i =  1:length(names)
    vp = dir([always,char(names(i)),'*']);
    current = strcat(vp.folder, vp.name);
    
    batch_counter = batch_counter + 1;

%% current directory 
now = strcat(current,'\Dicom_Import\Bold\Sims\');
cd(now);
Analysis = char(strcat('...\Analysis\Sims\RSA\First_Level',filesep,char(names(i))));


matlabbatch{1}.spm.stats.fmri_est.spmmat = {[Analysis,'\SPM.mat']};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

 batch{batch_counter} = matlabbatch;
end

parfor i = 1:length(batch)
    spm_jobman('run', batch{i})
    disp(['Finished specify for job no.', i]);
end

%% T-Images 
batch_counter = 0;
clear batch;
clear matlabbatch;
for i =  1:length(names)
    vp = dir([always,char(names(i)),'*']);
    current = strcat(vp.folder, vp.name);
    

%% current directory 
now = strcat(current,'\Dicom_Import\Bold\Sims\');
Analysis = char(strcat('...\Analysis\Sims\RSA\First_Level',filesep,char(names(i))));

story = {'Cat';'FairFight';'Kid'; 'MorningNews'; 'PartyOn'; 'PrettyPicture'};
Contrasts = {'Pre_A', 'Pre_Link','Pre_NonLink','Control', 'Link', 'Post_A','Post_Link','Post_NonLink'};
Z = zeros(49,1)';
u = 0;
for s = 1:length(story)
    for c = 1:length(Contrasts)
        cd(Analysis);
        C = Z;
        C(c + u) = 1;
        clear matlabbatch;
        matlabbatch{1}.spm.stats.con.spmmat = {[Analysis,'\SPM.mat']};
        matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = [char(strcat(string(story(s)), '_', Contrasts(c)))];
        matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = C;
        matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        spm_jobman('run', matlabbatch);
        clear matlabbatch;
    end
    u = u+8;
end

% T-Image für Target 
C = Z;
C(49) = 1;
clear matlabbatch;
matlabbatch{1}.spm.stats.con.spmmat = {[Analysis,'\SPM.mat']};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = ['Target'];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = C;
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
spm_jobman('run', matlabbatch);
clear matlabbatch;

end

