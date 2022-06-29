%% Model specification for univariate analyses %% 

clear all;
addpath C:\spm12;
spm('defaults','fmri');
spm_jobman('initcfg');
always = '...\EPINT_';
MCF_files = '...\Paradigmen\Sims_Task\log\MCF_Univariate\';

V = dir(['...\Paradigmen\Sims_Task\log\*.mat']);
for i = 1:length(V) 
names(i,1) = {[V(i).name(5:10)]};
end



batch_counter = 0;
clear batch;
clear matlabbatch;

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
    functionalList = dir([outputdir,'\swarf*']); 
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
in = now;
mo = dir([in, '\rp*']);
mov = {strcat(mo.folder,'\',mo.name)};

%% calculate GLM - model estimation  
% clear matlabbatch;
Analysis = char(strcat('...\Analysis\Sims\Univariate',filesep,char(names(i))));

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
for i = 1:length(names)
    vp = dir([always,char(names(i)),'*']);
    current = strcat(vp.folder, vp.name);
    
%% current directory 
now = strcat(current,'\Dicom_Import\Bold\Sims\');
Analysis = char(strcat('...\Analysis\Sims\Univariate',filesep,char(names(i))));

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

for i = 1:length(names)
    vp = dir([always,char(names(i)),'*']);
    current = strcat(vp.folder, vp.name);
    
    batch_counter = batch_counter + 1;

%% current directory 
% now noch ändern 
now = strcat(current,'\Dicom_Import\Bold\Sims\');
Analysis = char(strcat('...\Analysis\Sims\Univariate',filesep,char(names(i))));
cd(now);

matlabbatch = [];
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

for i = 1:length(names)
    vp = dir([always,char(names(i)),'*']);
    current = strcat(vp.folder, vp.name);
    
    batch_counter = batch_counter + 1;

%% current directory 
% now noch ändern 
now = strcat(current,'\Dicom_Import\Bold\Sims\');
Analysis = char(strcat('...\Analysis\Sims\Univariate',filesep,char(names(i))));
cd(now);


matlabbatch = [];
matlabbatch{1}.spm.stats.con.spmmat = {[Analysis,'\SPM.mat']};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Link_pre';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.convec = [0.5 0.5 0 0 0 0 0 0 0];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Link_post';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.convec = [0 0 0 0 0 0.5 0.5 0 0];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Linkpost > Linkpre';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.convec = [-0.5 -0.5 0 0 0 0.5 0.5 0 0];
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Linkpre > Linkpost';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.convec = [0.5 0.5 0 0 0 -0.5 -0.5 0 0];
matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'NonLinkpost > NonLinkpre';
matlabbatch{1}.spm.stats.con.consess{5}.tcon.convec = [-0.5 0 -0.5 0 0 0.5 0 0.5 0];
matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'NonLinkpre > NonLinkpost';
matlabbatch{1}.spm.stats.con.consess{6}.tcon.convec = [0.5 0 0.5 0 0 -0.5 0 -0.5 0];
matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';

 batch{batch_counter} = matlabbatch;
end

parfor i = 1:length(batch)
    spm_jobman('run', batch{i})
    disp(['Finished specify for job no.', i]);
end
