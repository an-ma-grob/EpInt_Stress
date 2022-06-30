%% Create concatenated MCF files for Sims Task %%
clear
input = '...\Logs';
MCF_folder_conc = '...\MCF_univariate';
cd(input);
List = dir(fullfile(input,'*.mat'));
clc

if ~exist(MCF_folder_conc, 'dir')
    mkdir(MCF_folder_conc);
end

for i = 1:length(List)
    
    load(List(i).name)
 
%% Names, Onsets, Durations

names={};
onsets={};
durations={};

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

% Stick function: Target müssen die tatsächlichen Responsezeiten genommen
% werden 
Target_onsets_1 = [Experiment.OnsetBlocks([find(strcmp({Experiment.OnsetBlocks(1:116).trialType},'target')==1 & strcmp({Result(1:116).stimulus}, 'T')==1)]).video];
Linking_Event_1 = [Experiment.OnsetBlocks([find(strcmp({Experiment.OnsetBlocks(1:116).trialType},'imagine')==1 | strcmp({Experiment.OnsetBlocks(1:116).trialType},'link')==1....
                  & strcmp({Result(1:116).stimulus}, 'link')==1 | strcmp({Result(1:116).stimulus}, 'imagine')==1 | strcmp({Result(1:116).trialType}, 'link')==1)]).link];
Control_Event_1 = [Experiment.OnsetBlocks([find(strcmp({Experiment.OnsetBlocks(1:116).trialType},'imagine')==1 | strcmp({Experiment.OnsetBlocks(1:116).trialType},'link')==1....
                  & strcmp({Result(1:116).stimulus}, 'link')==1 | strcmp({Result(1:116).stimulus}, 'imagine')==1 | strcmp({Result(1:116).trialType}, 'link')==1)]).control];        

names{1}=['Pre_on_A'];
if strcmp(Experiment.Log.condition(2), '1')
names{2}=['Pre_on_B'];
names{3}=['Pre_on_X'];
else
names{2}=['Pre_on_X'];
names{3}=['Pre_on_B'];
end
names{4}=['Link'];
names{5}=['Control'];
names{6}=['Post_on_A'];
if strcmp(Experiment.Log.condition(2), '1')
names{7}=['Post_on_B'];
names{8}=['Post_on_X'];
else
names{7}=['Post_on_X'];
names{8}=['Post_on_B'];
end
names{9}=['Target'];

onsets{1}=Pre_onsets_A_1;
%make Link alway second regressor 
if strcmp(Experiment.Log.condition(2), '1')
    onsets{2}=Pre_onsets_B_1;
    onsets{3}=Pre_onsets_X_1;
else
    onsets{2}=Pre_onsets_X_1;
    onsets{3}=Pre_onsets_B_1;
end
onsets{4}=Linking_Event_1;
onsets{5}=Control_Event_1;
onsets{6}=Post_onsets_A_1;
%make Link second regressor 
if strcmp(Experiment.Log.condition(2), '1')
    onsets{7}=Post_onsets_B_1;
    onsets{8}=Post_onsets_X_1;
else
    onsets{7}=Post_onsets_X_1;
    onsets{8}=Post_onsets_B_1;
end
onsets{9}=Target_onsets_1;
  
durations{1}=(zeros(length(Pre_onsets_A_1),1));
if strcmp(Experiment.Log.condition(2), '1')
    durations{2}=(zeros(length(Pre_onsets_B_1),1));
    durations{3}=(zeros(length(Pre_onsets_X_1),1));
else
    durations{2}=(zeros(length(Pre_onsets_X_1),1));
    durations{3}=(zeros(length(Pre_onsets_B_1),1));
end
% Nummer 3 und Nummer 4 hatten kürzere Linkingphase --> nur 2 s
if i == 3 || i ==4
    durations{4}=(zeros(length(Linking_Event_1),1));
    durations{5}=(zeros(length(Control_Event_1),1));
else
    durations{4}=(zeros(length(Linking_Event_1),1));
    durations{5}=(zeros(length(Control_Event_1),1));
end
durations{6}=(zeros(length(Post_onsets_A_1),1));
if strcmp(Experiment.Log.condition(2), '1')
    durations{7}=(zeros(length(Post_onsets_B_1),1));
    durations{8}=(zeros(length(Post_onsets_X_1),1));
else
    durations{7}=(zeros(length(Post_onsets_X_1),1));
    durations{8}=(zeros(length(Post_onsets_B_1),1));
end
durations{9}=(zeros(length(Target_onsets_1),1));

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
       

onsets{1}=[onsets{1},(Pre_onsets_A_2+diff_blocks(2))];
if strcmp(Experiment.Log.condition(2), '1')
    onsets{2}=[onsets{2},(Pre_onsets_B_2+diff_blocks(2))];
    onsets{3}=[onsets{3},(Pre_onsets_X_2+diff_blocks(2))];
else
    onsets{2}=[onsets{2},(Pre_onsets_X_2+diff_blocks(2))];
    onsets{3}=[onsets{3},(Pre_onsets_B_2+diff_blocks(2))];
end
onsets{4}=[onsets{4},(Linking_Event_2+diff_blocks(2))];
onsets{5}=[onsets{5},(Control_Event_2+diff_blocks(2))];
onsets{6}=[onsets{6},(Post_onsets_A_2+diff_blocks(2))];
if strcmp(Experiment.Log.condition(2), '1')
    onsets{7}=[onsets{7},(Post_onsets_B_2+diff_blocks(2))];
    onsets{8}=[onsets{8},(Post_onsets_X_2+diff_blocks(2))];
else
    onsets{7}=[onsets{7},(Post_onsets_X_2+diff_blocks(2))];
    onsets{8}=[onsets{8},(Post_onsets_B_2+diff_blocks(2))];
end
onsets{9}=[onsets{9},(Target_onsets_2+diff_blocks(2))];
  
durations{1}=[durations{1};((zeros(length(Pre_onsets_A_2),1)))];
if strcmp(Experiment.Log.condition(2), '1')
    durations{2}=[durations{2};((zeros(length(Pre_onsets_B_2),1)))];
    durations{3}=[durations{3};((zeros(length(Pre_onsets_X_2),1)))];
else
    durations{2}=[durations{2};((zeros(length(Pre_onsets_X_2),1)))];
    durations{3}=[durations{3};((zeros(length(Pre_onsets_B_2),1)))];
end

% Nummer 3 und Nummer 4 hatten kürzere Linkingphase --> nur 2 s
if i == 3 || i ==4
    durations{4}=[durations{4};(zeros(length(Linking_Event_2),1))];
    durations{5}=[durations{5};(zeros(length(Control_Event_2),1))];
else
    durations{4}=[durations{4};(zeros(length(Linking_Event_2),1))];
    durations{5}=[durations{5};(zeros(length(Control_Event_2),1))];
end
durations{6}=[durations{6};((zeros(length(Post_onsets_A_2),1)))];
if strcmp(Experiment.Log.condition(2), '1')
    durations{7}=[durations{7};((zeros(length(Post_onsets_B_2),1)))];
    durations{8}=[durations{8};((zeros(length(Post_onsets_X_2),1)))];
else
    durations{7}=[durations{7};((zeros(length(Post_onsets_X_2),1)))];
    durations{8}=[durations{8};((zeros(length(Post_onsets_B_2),1)))];
end
durations{9}=[durations{9};((zeros(length(Target_onsets_2),1)))];

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
 
              
onsets{1}=[onsets{1},(Pre_onsets_A_3+diff_blocks(4)+diff_blocks(2))];
if strcmp(Experiment.Log.condition(2), '1')
    onsets{2}=[onsets{2},(Pre_onsets_B_3+diff_blocks(4)+diff_blocks(2))];
    onsets{3}=[onsets{3},(Pre_onsets_X_3+diff_blocks(4)+diff_blocks(2))];
else
    onsets{2}=[onsets{2},(Pre_onsets_X_3+diff_blocks(4)+diff_blocks(2))];
    onsets{3}=[onsets{3},(Pre_onsets_B_3+diff_blocks(4)+diff_blocks(2))];
end
onsets{4}=[onsets{4},(Linking_Event_3+diff_blocks(4)+diff_blocks(2))];
onsets{5}=[onsets{5},(Control_Event_3+diff_blocks(4)+diff_blocks(2))];
onsets{6}=[onsets{6},(Post_onsets_A_3+diff_blocks(4)+diff_blocks(2))];
if strcmp(Experiment.Log.condition(2), '1')
    onsets{7}=[onsets{7},(Post_onsets_B_3+diff_blocks(4)+diff_blocks(2))];
    onsets{8}=[onsets{8},(Post_onsets_X_3+diff_blocks(4)+diff_blocks(2))];
else
    onsets{7}=[onsets{7},(Post_onsets_X_3+diff_blocks(4)+diff_blocks(2))];
    onsets{8}=[onsets{8},(Post_onsets_B_3+diff_blocks(4)+diff_blocks(2))];
end
onsets{9}=[onsets{9},(Target_onsets_3+diff_blocks(4)+diff_blocks(2))];
  
durations{1}=[durations{1};((zeros(length(Pre_onsets_A_3),1)))];
if strcmp(Experiment.Log.condition(2), '1')
    durations{2}=[durations{2};((zeros(length(Pre_onsets_B_3),1)))];
    durations{3}=[durations{3};((zeros(length(Pre_onsets_X_3),1)))];
else
    durations{2}=[durations{2};((zeros(length(Pre_onsets_X_3),1)))];
    durations{3}=[durations{3};((zeros(length(Pre_onsets_B_3),1)))];
end

% Nummer 3 und Nummer 4 hatten kürzere Linkingphase --> nur 2 s
if i == 3 || i ==4
    durations{4}=[durations{4};(zeros(length(Linking_Event_3),1))];
    durations{5}=[durations{5};(zeros(length(Control_Event_3),1))];
else
    durations{4}=[durations{4};((zeros(length(Linking_Event_3),1)))];
    durations{5}=[durations{5};((zeros(length(Control_Event_3),1)))];
end
durations{6}=[durations{6};((zeros(length(Post_onsets_A_3),1)))];
if strcmp(Experiment.Log.condition(2), '1')
    durations{7}=[durations{7};((zeros(length(Post_onsets_B_3),1)))];
    durations{8}=[durations{8};((zeros(length(Post_onsets_X_3),1)))];
else
    durations{7}=[durations{7};((zeros(length(Post_onsets_X_3),1)))];
    durations{8}=[durations{8};((zeros(length(Post_onsets_B_3),1)))];
end
durations{9}=[durations{9};((zeros(length(Target_onsets_3),1)))];



%% Make onsets correct 
for k = 1:length(onsets)
 onsets{k} = onsets{k} + 6;
end

%% save MCF file for all 
cd(MCF_folder_conc);
if i == 1
name = ['001_',Experiment.Log.participantName];
eval(['save MCF_',name,' names onsets durations']);
else
name = [Experiment.Log.participantName,'_', Experiment.Log.participantCode];
eval(['save MCF_',name,' names onsets durations']);
end
cd(input);

end
clear;
