%% Get averaged RSA results %% 
clear;
addpath C:\spm12;
spm('defaults','fmri');
spm_jobman('initcfg');

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
VP = '...\';
cd(VP);
[~,~,RAW]=xlsread('Data.xlsx');

Performance(1).Condition = [];
for i = 1:59 
if strcmp(RAW(i+1,4), 'Control')==1
    Performance(i).Stress = 1;
elseif strcmp(RAW(i+1,4), 'Stress')==1
    Performance(i).Stress = 0;
else Performance(i).Stress = NaN;
    
end
end

%% Counterbalancing %%
Performance(1).Condition = [];
for i = 1:59 
    Performance(i).Condition = RAW{i+1,99};
end

%% Extract averaged dissimilarities per ROI

[~, sortidx] = sort({Performance.Code});
Performance = Performance(sortidx);

Dir = '...\RDMs';
files = dir([Dir,'\*.mat']);
cd(Dir);

for i = 1:numel(files)
    equalto(i,1) = {[files(i).name(9:14)]};
end

for i = 1:length(files)
    new(i,1) = dir(['*',equalto{i},'_RDMs.mat']);
end

for i=1:length(files)
    B(i) = load([new(i).name]);
end


for k = 1:length(B)
    for j = 1:length(B(k).RDMs)
        Name = [];
        AB_pre = []; AX_pre = []; AB_post = []; AX_post = [];
    Name = char(extractBetween(B(k).RDMs(j).name, "w", " "));
    Name = strrep(Name,'-','_');
    AB_pre = [Name, '_AB_pre'];
    AX_pre = [Name, '_AX_pre'];
    AB_post = [Name, '_AB_post'];
    AX_post = [Name, '_AX_post'];
    Performance(k).(AB_pre) = (B(k).RDMs(j).RDM(1,2)+B(k).RDMs(j).RDM(7,8)+B(k).RDMs(j).RDM(13,14)+B(k).RDMs(j).RDM(19,20)+...
    B(k).RDMs(j).RDM(25,26)+B(k).RDMs(j).RDM(31,32))/6;
    Performance(k).(AX_pre) = (B(k).RDMs(j).RDM(1,3)+B(k).RDMs(j).RDM(7,9)+B(k).RDMs(j).RDM(13,15)+B(k).RDMs(j).RDM(19,21)+...
    B(k).RDMs(j).RDM(25,27)+B(k).RDMs(j).RDM(31,33))/6;
    Performance(k).(AB_post) = (B(k).RDMs(j).RDM(4,5)+B(k).RDMs(j).RDM(10,11)+B(k).RDMs(j).RDM(16,17)+B(k).RDMs(j).RDM(22,23)+...
    B(k).RDMs(j).RDM(28,29)+B(k).RDMs(j).RDM(34,35))/6;
    Performance(k).(AX_post) = (B(k).RDMs(j).RDM(4,6)+B(k).RDMs(j).RDM(10,12)+B(k).RDMs(j).RDM(16,18)+B(k).RDMs(j).RDM(22,24)+...
    B(k).RDMs(j).RDM(28,30)+B(k).RDMs(j).RDM(34,36))/6;
    end
    
end
