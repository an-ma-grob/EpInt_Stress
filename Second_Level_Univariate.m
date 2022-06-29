%% Second Level: Univariate %% 
clear;
addpath C:\spm12;
spm('defaults','fmri');
spm_jobman('initcfg');

Level_two = {'StressP_ConP'};

Dir = '...\Sims\Logs';
files = dir([Dir,'\*.mat']);
cd(Dir);

for i=1:length(files)
    Sims(i) = load([files(i).name]);
end

Performance = {};

for k = 1:numel(Sims)
        Performance(k).VP = files(k).name(1:3);
        Performance(k).Code = files(k).name(5:10);
end

%% In which condition: Stress vs. Control

VP = '...\Code\';
cd(VP);
[~,~,RAW]=xlsread('Data.xlsx');

Performance(1).Stress = [];
for i = 1:59 
if strcmp(RAW(i+1,4), 'Control')==1
    Performance(i).Stress = 1;
elseif strcmp(RAW(i+1,4), 'Stress')==1
    Performance(i).Stress = 0;
else Performance(i).Stress = NaN;
    
end
end


%% Link pre
clear matlabbatch;
Analysis = '...\Analysis\Sims\Univariate\01_Analysis\01_Link_pre';

if ~exist(Analysis)
    mkdir(Analysis)
end

a = 1;c = 1; 
FuncFilenames_ConP = {};
FuncFilenames_StressP = {};
for k = 1:numel(Performance)
    if Performance((k)).Stress == 0
            FuncFilenames_ConP{a,1} = strcat('...\Analysis\Sims\Univariate',filesep, Performance((k)).Code, '\con_0001.nii',',1');
            a = a + 1;
    elseif Performance((k)).Stress == 1
            FuncFilenames_StressP{c,1} = strcat('...\Analysis\Sims\Univariate',filesep, Performance((k)).Code, '\con_0001.nii',',1');
            c = c + 1;
    end
end

for k = 1:length(Level_two)
clear matlabbatch; 
A = [Analysis,'\T_test\',Level_two{k}];
S = [Analysis,'\T_test\',Level_two{k},'\SPM.mat'];
Func = {FuncFilenames_StressP,FuncFilenames_ConP};
Con = {'StressP > ConP','ConP > StressP'};

if ~exist(A)
    mkdir(A)
end

cd(A)
matlabbatch = [];
matlabbatch{1}.spm.stats.factorial_design.dir = {A};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = Func{1};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = Func{2};
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = {S};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

%define contrasts
matlabbatch{3}.spm.stats.con.spmmat(1) = {S};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = Con{1};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = Con{2};
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

spm_jobman('run',matlabbatch);
clear matlabbatch; 

end

%% Link Post
clear matlabbatch;
Analysis = '...\Analysis\Sims\Univariate\01_Analysis\02_Link_post';

if ~exist(Analysis)
    mkdir(Analysis)
end

a = 1;c = 1; 
FuncFilenames_ConP = {};
FuncFilenames_StressP = {};
for k = 1:numel(Performance)
    if Performance((k)).Stress == 0
            FuncFilenames_ConP{a,1} = strcat('...\Analysis\Sims\Univariate',filesep, Performance((k)).Code, '\con_0002.nii',',1');
            a = a + 1;
    elseif Performance((k)).Stress == 1
            FuncFilenames_StressP{c,1} = strcat('...\Analysis\Sims\Univariate',filesep, Performance((k)).Code, '\con_0002.nii',',1');
            c = c + 1;
    end
end

for k = 1:length(Level_two)
clear matlabbatch; 
A = [Analysis,'\T_test\',Level_two{k}];
S = [Analysis,'\T_test\',Level_two{k},'\SPM.mat'];
Func = {FuncFilenames_StressP,FuncFilenames_ConP};
Con = {'StressP > ConP','ConP > StressP'};

if ~exist(A)
    mkdir(A)
end

cd(A)
matlabbatch = [];
matlabbatch{1}.spm.stats.factorial_design.dir = {A};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = Func{1};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = Func{2};
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = {S};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

%define contrasts
matlabbatch{3}.spm.stats.con.spmmat(1) = {S};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = Con{1};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = Con{2};
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

spm_jobman('run',matlabbatch);
clear matlabbatch; 

end

%% Linkpost > Linkpre
clear matlabbatch;
Analysis = '...\Analysis\Sims\Univariate\01_Analysis\03_Linkpost_bigger_Linkpre';

if ~exist(Analysis)
    mkdir(Analysis)
end

a = 1;c = 1; 
FuncFilenames_ConP = {};
FuncFilenames_StressP = {};
for k = 1:numel(Performance)
    if Performance((k)).Stress == 0
            FuncFilenames_ConP{a,1} = strcat('...\Analysis\Sims\Univariate',filesep, Performance((k)).Code, '\con_0003.nii',',1');
            a = a + 1;
    elseif Performance((k)).Stress == 1
            FuncFilenames_StressP{c,1} = strcat('...\Analysis\Sims\Univariate',filesep, Performance((k)).Code, '\con_0003.nii',',1');
            c = c + 1;
    end
end

for k = 1:length(Level_two)
clear matlabbatch; 
A = [Analysis,'\T_test\',Level_two{k}];
S = [Analysis,'\T_test\',Level_two{k},'\SPM.mat'];
Func = {FuncFilenames_StressP,FuncFilenames_ConP};
Con = {'StressP > ConP','ConP > StressP'};

if ~exist(A)
    mkdir(A)
end

cd(A)
matlabbatch = [];
matlabbatch{1}.spm.stats.factorial_design.dir = {A};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = Func{1};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = Func{2};
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = {S};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

%define contrasts
matlabbatch{3}.spm.stats.con.spmmat(1) = {S};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = Con{1};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = Con{2};
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

spm_jobman('run',matlabbatch);
clear matlabbatch; 

end

%% Linkpre > Linkpost
clear matlabbatch;
Analysis = '...\Analysis\Sims\Univariate\01_Analysis\04_Linkpre_bigger_Linkpost';

if ~exist(Analysis)
    mkdir(Analysis)
end

a = 1;c = 1; 
FuncFilenames_ConP = {};
FuncFilenames_StressP = {};
for k = 1:numel(Performance)
    if Performance((k)).Stress == 0
            FuncFilenames_ConP{a,1} = strcat('...\Analysis\Sims\Univariate',filesep, Performance((k)).Code, '\con_0004.nii',',1');
            a = a + 1;
    elseif Performance((k)).Stress == 1
            FuncFilenames_StressP{c,1} = strcat('...\Analysis\Sims\Univariate',filesep, Performance((k)).Code, '\con_0004.nii',',1');
            c = c + 1;
    end
end

for k = 1:length(Level_two)
clear matlabbatch; 
A = [Analysis,'\T_test\',Level_two{k}];
S = [Analysis,'\T_test\',Level_two{k},'\SPM.mat'];
Func = {FuncFilenames_StressP,FuncFilenames_ConP};
Con = {'StressP > ConP','ConP > StressP'};

if ~exist(A)
    mkdir(A)
end

cd(A)
matlabbatch = [];
matlabbatch{1}.spm.stats.factorial_design.dir = {A};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = Func{1};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = Func{2};
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = {S};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

%define contrasts
matlabbatch{3}.spm.stats.con.spmmat(1) = {S};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = Con{1};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = Con{2};
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

spm_jobman('run',matlabbatch);
clear matlabbatch; 

end

%% NonLinkpost > NonLinkpre
clear matlabbatch;
Analysis = '...\Analysis\Sims\Univariate\01_Analysis\05_NonLinkpost_bigger_NonLinkpre';

if ~exist(Analysis)
    mkdir(Analysis)
end

a = 1;c = 1; 
FuncFilenames_ConP = {};
FuncFilenames_StressP = {};
for k = 1:numel(Performance)
    if Performance((k)).Stress == 0
            FuncFilenames_ConP{a,1} = strcat('...\Analysis\Sims\Univariate',filesep, Performance((k)).Code, '\con_0005.nii',',1');
            a = a + 1;
    elseif Performance((k)).Stress == 1
            FuncFilenames_StressP{c,1} = strcat('...\Analysis\Sims\Univariate',filesep, Performance((k)).Code, '\con_0005.nii',',1');
            c = c + 1;
    end
end


for k = 1:length(Level_two)
clear matlabbatch; 
A = [Analysis,'\T_test\',Level_two{k}];
S = [Analysis,'\T_test\',Level_two{k},'\SPM.mat'];
Func = {FuncFilenames_StressP,FuncFilenames_ConP};
Con = {'StressP > ConP','ConP > StressP'};

if ~exist(A)
    mkdir(A)
end

cd(A)
matlabbatch = [];
matlabbatch{1}.spm.stats.factorial_design.dir = {A};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = Func{1};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = Func{2};
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = {S};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

%define contrasts
matlabbatch{3}.spm.stats.con.spmmat(1) = {S};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = Con{1};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = Con{2};
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

spm_jobman('run',matlabbatch);
clear matlabbatch; 

end

%% NonLinkpre > NonLinkpost
clear matlabbatch;
Analysis = '...\Analysis\Sims\Univariate\01_Analysis\06_NonLinkpre_bigger_NonLinkpost';

if ~exist(Analysis)
    mkdir(Analysis)
end

a = 1;c = 1; 
FuncFilenames_ConP = {};
FuncFilenames_StressP = {};
for k = 1:numel(Performance)
    if Performance((k)).Stress == 0
            FuncFilenames_ConP{a,1} = strcat('...\Analysis\Sims\Univariate',filesep, Performance((k)).Code, '\con_0006.nii',',1');
            a = a + 1;
    elseif Performance((k)).Stress == 1
            FuncFilenames_StressP{c,1} = strcat('...\Analysis\Sims\Univariate',filesep, Performance((k)).Code, '\con_0006.nii',',1');
            c = c + 1;
    end
end

for k = 1:length(Level_two)
clear matlabbatch; 
A = [Analysis,'\T_test\',Level_two{k}];
S = [Analysis,'\T_test\',Level_two{k},'\SPM.mat'];
Func = {FuncFilenames_StressP,FuncFilenames_ConP};
Con = {'StressP > ConP','ConP > StressP'};

if ~exist(A)
    mkdir(A)
end

cd(A)
matlabbatch = [];
matlabbatch{1}.spm.stats.factorial_design.dir = {A};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = Func{1};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = Func{2};
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = {S};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

%define contrasts
matlabbatch{3}.spm.stats.con.spmmat(1) = {S};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = Con{1};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = Con{2};
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

spm_jobman('run',matlabbatch);
clear matlabbatch; 

end
