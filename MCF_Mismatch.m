%%----------------------------------------
%%% MCF file for Mismatch Analysis %%%
%%----------------------------------------

clear
input = '...\Logs';
MCF_folder_conc = '...\MCF_Mismatch';
Base = '...\Logs';
cd(input);
List = dir(fullfile(input,'*.mat'));
clc

if ~exist(MCF_folder_conc, 'dir')
    mkdir(MCF_folder_conc);
end
%%
for i = 1:length(List)

load(List(i).name)

%% Names, Onsets, Durations

names={};
onsets={};
durations={};

% Calculate difference time between blocks to get real elapsed time for
% block 2 and block 3

diff_blocks = [];
for j = 1:length(Experiment.OnsetBlocks)
    if j > 1
        if strcmp({Experiment.OnsetBlocks(j-1).trialType}, 'postRating')==1 && strcmp({Experiment.OnsetBlocks(j).trialType}, 'pre')==1
            if ~isempty(Experiment.OnsetBlocks(j-1).response)
                diff_blocks = [diff_blocks; (Experiment.OnsetBlocks(j-1).response)];
            else
                diff_blocks = [diff_blocks; (Experiment.OnsetBlocks(j-1).ratingQuestion + 5.5)];
            end
        end
    end
end

%% Block 1
Pre_onsets_A_1 = [Experiment.OnsetBlocks([find(strcmp({Experiment.OnsetBlocks(1:116).trialType},'pre')==1 & strcmp({Result(1:116).stimulus}, 'A')==1)]).video];
Pre_onsets_B_1 = [Experiment.OnsetBlocks([find(strcmp({Experiment.OnsetBlocks(1:116).trialType},'pre')==1 & strcmp({Result(1:116).stimulus}, 'B')==1)]).video];
Pre_onsets_X_1 = [Experiment.OnsetBlocks([find(strcmp({Experiment.OnsetBlocks(1:116).trialType},'pre')==1 & strcmp({Result(1:116).stimulus}, 'X')==1)]).video];

Post_onsets_A_1 = [Experiment.OnsetBlocks([find(strcmp({Experiment.OnsetBlocks(1:116).trialType},'post')==1 & strcmp({Result(1:116).stimulus}, 'A')==1)]).video];
Post_onsets_B_1 = [Experiment.OnsetBlocks([find(strcmp({Experiment.OnsetBlocks(1:116).trialType},'post')==1 & strcmp({Result(1:116).stimulus}, 'B')==1)]).video];
Post_onsets_X_1 = [Experiment.OnsetBlocks([find(strcmp({Experiment.OnsetBlocks(1:116).trialType},'post')==1 & strcmp({Result(1:116).stimulus}, 'X')==1)]).video];

Target_onsets_1 = [Experiment.OnsetBlocks([find(strcmp({Experiment.OnsetBlocks(1:116).trialType},'target')==1 & strcmp({Result(1:116).stimulus}, 'T')==1)]).video];
Linking_Event_1 = [Experiment.OnsetBlocks([find(strcmp({Experiment.OnsetBlocks(1:116).trialType},'imagine')==1 | strcmp({Experiment.OnsetBlocks(1:116).trialType},'link')==1....
                  & strcmp({Result(1:116).stimulus}, 'link')==1 | strcmp({Result(1:116).stimulus}, 'imagine')==1 | strcmp({Result(1:116).trialType}, 'link')==1)]).link];
Control_Event_1 = [Experiment.OnsetBlocks([find(strcmp({Experiment.OnsetBlocks(1:116).trialType},'imagine')==1 | strcmp({Experiment.OnsetBlocks(1:116).trialType},'link')==1....
                  & strcmp({Result(1:116).stimulus}, 'link')==1 | strcmp({Result(1:116).stimulus}, 'imagine')==1 | strcmp({Result(1:116).trialType}, 'link')==1)]).control];        

              
%% Block 2
Pre_onsets_A_2 = [Experiment.OnsetBlocks(116+([find(strcmp({Experiment.OnsetBlocks(117:232).trialType},'pre')==1 & strcmp({Result(117:232).stimulus}, 'A')==1)])).video];
Pre_onsets_B_2 = [Experiment.OnsetBlocks(116+([find(strcmp({Experiment.OnsetBlocks(117:232).trialType},'pre')==1 & strcmp({Result(117:232).stimulus}, 'B')==1)])).video];
Pre_onsets_X_2 = [Experiment.OnsetBlocks(116+([find(strcmp({Result(117:232).trialType},'pre')==1 & strcmp({Result(117:232).stimulus}, 'X')==1)])).video];

Post_onsets_A_2 = [Experiment.OnsetBlocks(116+([find(strcmp({Experiment.OnsetBlocks(117:232).trialType},'post')==1 & strcmp({Result(117:232).stimulus}, 'A')==1)])).video];
Post_onsets_B_2 = [Experiment.OnsetBlocks(116+([find(strcmp({Experiment.OnsetBlocks(117:232).trialType},'post')==1 & strcmp({Result(117:232).stimulus}, 'B')==1)])).video];
Post_onsets_X_2 = [Experiment.OnsetBlocks(116+([find(strcmp({Experiment.OnsetBlocks(117:232).trialType},'post')==1 & strcmp({Result(117:232).stimulus}, 'X')==1)])).video];

Target_onsets_2 = [Experiment.OnsetBlocks(116+([find(strcmp({Experiment.OnsetBlocks(117:232).trialType},'target')==1 & strcmp({Result(117:232).stimulus}, 'T')==1)])).video];

Linking_Event_2 = [Experiment.OnsetBlocks(116+([find(strcmp({Experiment.OnsetBlocks(117:232).trialType},'imagine')==1 | strcmp({Experiment.OnsetBlocks(117:232).trialType},'link')==1....
                  & strcmp({Result(117:232).stimulus}, 'link')==1 | strcmp({Result(117:232).stimulus}, 'imagine')==1 | strcmp({Result(117:232).trialType}, 'link')==1)])).link];
Control_Event_2 = [Experiment.OnsetBlocks(116+([find(strcmp({Experiment.OnsetBlocks(117:232).trialType},'imagine')==1 | strcmp({Experiment.OnsetBlocks(117:232).trialType},'link')==1....
                  & strcmp({Result(117:232).stimulus}, 'link')==1 | strcmp({Result(117:232).stimulus}, 'imagine')==1 | strcmp({Result(117:232).trialType}, 'link')==1)])).control];
       
              
%% Block 3
Pre_onsets_A_3 = [Experiment.OnsetBlocks(232+([find(strcmp({Experiment.OnsetBlocks(233:348).trialType},'pre')==1 & strcmp({Result(233:348).stimulus}, 'A')==1)])).video];
Pre_onsets_B_3 = [Experiment.OnsetBlocks(232+([find(strcmp({Experiment.OnsetBlocks(233:348).trialType},'pre')==1 & strcmp({Result(233:348).stimulus}, 'B')==1)])).video];
Pre_onsets_X_3 = [Experiment.OnsetBlocks(232+([find(strcmp({Experiment.OnsetBlocks(233:348).trialType},'pre')==1 & strcmp({Result(233:348).stimulus}, 'X')==1)])).video];

Post_onsets_A_3 = [Experiment.OnsetBlocks(232+([find(strcmp({Experiment.OnsetBlocks(233:348).trialType},'post')==1 & strcmp({Result(233:348).stimulus}, 'A')==1)])).video];
Post_onsets_B_3 = [Experiment.OnsetBlocks(232+([find(strcmp({Experiment.OnsetBlocks(233:348).trialType},'post')==1 & strcmp({Result(233:348).stimulus}, 'B')==1)])).video];
Post_onsets_X_3 = [Experiment.OnsetBlocks(232+([find(strcmp({Experiment.OnsetBlocks(233:348).trialType},'post')==1 & strcmp({Result(233:348).stimulus}, 'X')==1)])).video];

Target_onsets_3 = [Experiment.OnsetBlocks(232+([find(strcmp({Experiment.OnsetBlocks(233:348).trialType},'target')==1 & strcmp({Result(233:348).stimulus}, 'T')==1)])).video];

Linking_Event_3 = [Experiment.OnsetBlocks(232+([find(strcmp({Experiment.OnsetBlocks(233:348).trialType},'imagine')==1 | strcmp({Experiment.OnsetBlocks(233:348).trialType},'link')==1....
                  & strcmp({Result(233:348).stimulus}, 'link')==1 | strcmp({Result(233:348).stimulus}, 'imagine')==1 | strcmp({Result(233:348).trialType}, 'link')==1)])).link];
Control_Event_3 = [Experiment.OnsetBlocks(232+([find(strcmp({Experiment.OnsetBlocks(233:348).trialType},'imagine')==1 | strcmp({Experiment.OnsetBlocks(233:348).trialType},'link')==1....
                  & strcmp({Result(233:348).stimulus}, 'link')==1 | strcmp({Result(233:348).stimulus}, 'imagine')==1 | strcmp({Result(233:348).trialType}, 'link')==1)])).control];

%% Target onsets %% 

Target_onsets = [Target_onsets_1, (Target_onsets_2+diff_blocks(2)), (Target_onsets_3+diff_blocks(2)...
    +diff_blocks(4))];


%% add 6s to adjust for first 3 left out images

Pre_onsets_A_1 = Pre_onsets_A_1 + 6; 
Pre_onsets_B_1 = Pre_onsets_B_1 + 6; 
Pre_onsets_X_1 = Pre_onsets_X_1 + 6; 
Linking_Event_1 = Linking_Event_1 + 6; 
Control_Event_1 = Control_Event_1 + 6;
Post_onsets_A_1 = Post_onsets_A_1 + 6; 
Post_onsets_B_1 = Post_onsets_B_1 + 6;
Post_onsets_X_1 = Post_onsets_X_1 + 6; 

Pre_onsets_A_2 = Pre_onsets_A_2 + 6;
Pre_onsets_B_2 = Pre_onsets_B_2 + 6;
Pre_onsets_X_2 = Pre_onsets_X_2 + 6;
Linking_Event_2 = Linking_Event_2 + 6;
Control_Event_2 = Control_Event_2 + 6; 
Post_onsets_A_2 = Post_onsets_A_2 + 6;
Post_onsets_B_2 = Post_onsets_B_2 + 6;
Post_onsets_X_2 = Post_onsets_X_2 + 6;

Pre_onsets_A_3 = Pre_onsets_A_3 + 6;
Pre_onsets_B_3 = Pre_onsets_B_3 + 6;
Pre_onsets_X_3 = Pre_onsets_X_3 + 6;
Linking_Event_3 = Linking_Event_3 + 6;
Control_Event_3 = Control_Event_3 + 6;
Target_onsets = Target_onsets + 6; 
Post_onsets_A_3 = Post_onsets_A_3 + 6;
Post_onsets_B_3 = Post_onsets_B_3 + 6;
Post_onsets_X_3 = Post_onsets_X_3 + 6;

%% Rename Link and NonLink 

if strcmp(Experiment.Log.condition, 'I1') || strcmp(Experiment.Log.condition, 'L1')
    Pre_Link_1 = Pre_onsets_B_1;
    Pre_NonLink_1 = Pre_onsets_X_1;
    Pre_Link_2 = Pre_onsets_B_2;
    Pre_NonLink_2 = Pre_onsets_X_2;
    Pre_Link_3 = Pre_onsets_B_3;
    Pre_NonLink_3 = Pre_onsets_X_3;
    
    Post_Link_1 = Post_onsets_B_1;
    Post_NonLink_1 = Post_onsets_X_1;
    Post_Link_2 = Post_onsets_B_2;
    Post_NonLink_2 = Post_onsets_X_2;
    Post_Link_3 = Post_onsets_B_3;
    Post_NonLink_3 = Post_onsets_X_3;
else
    Pre_Link_1 = Pre_onsets_X_1;
    Pre_NonLink_1 = Pre_onsets_B_1;
    Pre_Link_2 = Pre_onsets_X_2;
    Pre_NonLink_2 = Pre_onsets_B_2;
    Pre_Link_3 = Pre_onsets_X_3;
    Pre_NonLink_3 = Pre_onsets_B_3;
    
    Post_Link_1 = Post_onsets_X_1;
    Post_NonLink_1 = Post_onsets_B_1;
    Post_Link_2 = Post_onsets_X_2;
    Post_NonLink_2 = Post_onsets_B_2;
    Post_Link_3 = Post_onsets_X_3;
    Post_NonLink_3 = Post_onsets_B_3;
end

              
%% make MCF file for each condition (3 blocks) separate GLM %% 

% Get story order 
Order = {'Cat',find(strcmp(Experiment.storyNames,'Cat')); 'FairFight',find(strcmp(Experiment.storyNames,'FairFight'));...
    'MorningNews',find(strcmp(Experiment.storyNames,'MorningNews'));'Kid',find(strcmp(Experiment.storyNames,'Kid'));...
    'PartyOn',find(strcmp(Experiment.storyNames,'PartyOn'));'PrettyPicture',find(strcmp(Experiment.storyNames,'PrettyPicture'))};

% LOOP through stories for all event regressors 
% get first to last 
First = Order{find([Order{1:6,2}] == 1),1};
Second = Order{find([Order{1:6,2}] == 2),1};
Third = Order{find([Order{1:6,2}] == 3),1};
Fourth = Order{find([Order{1:6,2}] == 4),1};
Fifth = Order{find([Order{1:6,2}] == 5),1};
Sixth = Order{find([Order{1:6,2}] == 6),1};

cd(Base);
run Mismatch_First_Story.m
cd(Base);
run Mismatch_Second_Story.m
cd(Base);
run Mismatch_Third_Story.m
cd(Base);
run Mismatch_Fourth_Story.m
cd(Base);
run Mismatch_Fifth_Story.m
cd(Base);
run Mismatch_Sixth_Story.m
cd(Base);


%% Create names for loop over subjects 
for m = 1:length(List) 
code(m,1) = {[List(m).name(5:10)]};
end


%% Import all into one file %%
% import single MCF files
story = {'Cat';'FairFight';'Kid'; 'MorningNews'; 'PartyOn'; 'PrettyPicture'};

for s = 1:length(story)
    folder = char(strcat(MCF_folder_conc,filesep,string(story(s))));
    
    if i < 10
        MCFs(1,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_00',string(i),'_',code(i),'.mat')))};
        MCFs(2,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Pre_AB_00',string(i),'_',code(i),'.mat')))};
        MCFs(3,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Pre_AX_00',string(i),'_',code(i),'.mat')))};
        MCFs(4,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Link_00',string(i),'_',code(i),'.mat')))};
        MCFs(5,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Control_00',string(i),'_',code(i),'.mat')))};
        MCFs(6,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Post_AB_00',string(i),'_',code(i),'.mat')))};
        MCFs(7,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Post_AX_00',string(i),'_',code(i),'.mat')))};
        
    elseif i >=10 && i < 100
        MCFs(1,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_0',string(i),'_',code(i),'.mat')))};
        MCFs(2,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Pre_AB_0',string(i),'_',code(i),'.mat')))};
        MCFs(3,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Pre_AX_0',string(i),'_',code(i),'.mat')))};
        MCFs(4,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Link_0',string(i),'_',code(i),'.mat')))};
        MCFs(5,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Control_0',string(i),'_',code(i),'.mat')))};
        MCFs(6,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Post_AB_0',string(i),'_',code(i),'.mat')))};
        MCFs(7,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Post_AX_0',string(i),'_',code(i),'.mat')))};
    else
        MCFs(1,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_',string(i),'_',code(i),'.mat')))};
        MCFs(2,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Pre_AB_',string(i),'_',code(i),'.mat')))};
        MCFs(3,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Pre_AX_',string(i),'_',code(i),'.mat')))};
        MCFs(4,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Link_',string(i),'_',code(i),'.mat')))};
        MCFs(5,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Control_',string(i),'_',code(i),'.mat')))};
        MCFs(6,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Post_AB_',string(i),'_',code(i),'.mat')))};
        MCFs(7,s) = {importdata(fullfile(folder,strcat('\MCF_',string(story(s)),'_Post_AX_',string(i),'_',code(i),'.mat')))};
    end
end

clear onsets names durations; 


%% connect everything into one file 
names = {};
onsets = {}; 
durations = {}; 
n = 1; 
for k = 1:size(MCFs,2)
    for l = 1:size(MCFs,1)
        if l < 2
        names{n} = MCFs{l,k}.names{1,1};
        onsets{n} = MCFs{l,k}.onsets{1,1};
        durations{n}= MCFs{l,k}.durations{1,1};
        n = n+1;
        end
    end
end

names(n) = {'Target'};
onsets(n) = {Target_onsets};
durations(n) = {((zeros(length(Target_onsets),1)))};

pmod = {};
for k = 1:size(MCFs,2)
    n = 1; 
    for l = 2:size(MCFs,1)
        pmod(k).name{n}= MCFs{l,k}.name{1,1};
        pmod(k).param{n}= MCFs{l,k}.param{1,1};
        pmod(k).poly{n}= MCFs{l,k}.poly{1,1};
        n = n+1;
    end
    
end




%% Save everything
cd(MCF_folder_conc);
if i == 1
name = ['001_',Experiment.Log.participantName];
eval(['save MCF_Mismatch_',name,' names onsets durations pmod']);
elseif i == 38
name = ['038_',Experiment.Log.participantCode];
eval(['save MCF_Mismatch_',name,' names onsets durations pmod']);
elseif i == 58
name = ['058_',Experiment.Log.participantCode];
eval(['save MCF_Mismatch_',name,' names onsets durations pmod']);
else
name = [Experiment.Log.participantName,'_', Experiment.Log.participantCode];
eval(['save MCF_Mismatch_',name,' names onsets durations pmod']);
end
cd(Base);

onsets = {}; 
names = {}; 
durations = {}; 
pmod = {};



end
clear; 
              