%% Sixth story: 
% Make folder for story 
Story = [MCF_folder_conc,'\',Sixth];
if ~exist(Story, 'dir')
    mkdir(Story);
end

%% Make parametric log regressors 
Help = zeros(48,9)';
Help(1,1:48) = [Pre_onsets_A_3(7:12), Pre_Link_3(7:12), Pre_NonLink_3(7:12),Linking_Event_3(7:12), Control_Event_3(7:12),...
    Post_onsets_A_3(7:12), Post_Link_3(7:12), Post_NonLink_3(7:12)];
Help(2,1:6) = zeros(6,1)'+1; %Pre_A
Help(2,7:12) = zeros(6,1)'+2; %Pre_B
Help(2,13:18) = zeros(6,1)'+3; %Pre_X
Help(2,19:24) = zeros(6,1)'+100; %Link
Help(2,25:30) = zeros(6,1)'+200; %Control
Help(2,31:36) = zeros(6,1)'+4; %Post_A
Help(2,37:42) = zeros(6,1)'+5; %Post_B
Help(2,43:48) = zeros(6,1)'+6; %Post_X

Help = sortrows(Help',1)';

%% Par_Pre_AB
idx = find(Help(2,:) == 1 | Help(2,:) == 2);
for k = 2:12
    Help(4,idx(k)) = -log(Help(1,idx(k)) - Help(1,idx(k-1)));
end

Par_Pre_A_B = Help(4,:);
Id = find(Par_Pre_A_B ~= 0);
Par_Pre_A_B(Id) = nonzeros(Par_Pre_A_B) - mean(nonzeros(Par_Pre_A_B));

%% Par_Pre_AX
idx = find(Help(2,:) == 1 | Help(2,:) == 3);
for k = 2:12
    Help(5,idx(k)) = -log(Help(1,idx(k)) - Help(1,idx(k-1)));
end

Par_Pre_A_X = Help(5,:);
Id = find(Par_Pre_A_X ~= 0);
Par_Pre_A_X(Id) = nonzeros(Par_Pre_A_X) - mean(nonzeros(Par_Pre_A_X));

%% Link
idx = find(Help(2,:) == 100);
for k = 2:6
    Help(6,idx(k)) = -log(Help(1,idx(k)) - Help(1,idx(k-1)));
end

Par_Link = Help(6,:);
Id = find(Par_Link ~= 0);
Par_Link(Id) = nonzeros(Par_Link) - mean(nonzeros(Par_Link));

%% Control
idx = find(Help(2,:) == 200);
for k = 2:6
    Help(7,idx(k)) = -log(Help(1,idx(k)) - Help(1,idx(k-1)));
end

Par_Control = Help(7,:);
Id = find(Par_Control ~= 0);
Par_Control(Id) = nonzeros(Par_Control) - mean(nonzeros(Par_Control));

%% Par_Post_AB
idx = find(Help(2,:) == 4 | Help(2,:) == 5);
for k = 2:12
    Help(8,idx(k)) = -log(Help(1,idx(k)) - Help(1,idx(k-1)));
end

Par_Post_A_B = Help(8,:);
Id = find(Par_Post_A_B ~= 0);
Par_Post_A_B(Id) = nonzeros(Par_Post_A_B) - mean(nonzeros(Par_Post_A_B));

%% Par_Post_AX
idx = find(Help(2,:) == 4 | Help(2,:) == 6);
for k = 2:12
    Help(9,idx(k)) = -log(Help(1,idx(k)) - Help(1,idx(k-1)));
end

Par_Post_A_X = Help(9,:);
Id = find(Par_Post_A_X  ~= 0);
Par_Post_A_X (Id) = nonzeros(Par_Post_A_X) - mean(nonzeros(Par_Post_A_X));

%% Make Main regressor
% Sixth Story regressor
names{1} = [Sixth, '_Events'];
onsets{1}=sort([Pre_onsets_A_3(7:12) + diff_blocks(2) + diff_blocks(4), Pre_Link_3(7:12) + diff_blocks(2) + diff_blocks(4), Pre_NonLink_3(7:12) + diff_blocks(2) + diff_blocks(4),Linking_Event_3(7:12) + diff_blocks(2) + diff_blocks(4), Control_Event_3(7:12) + diff_blocks(2) + diff_blocks(4),...
    Post_onsets_A_3(7:12) + diff_blocks(2) + diff_blocks(4), Post_Link_3(7:12) + diff_blocks(2) + diff_blocks(4), Post_NonLink_3(7:12) + diff_blocks(2) + diff_blocks(4)]);
durations{1}=[(zeros(18,1))',(zeros(12,1))',(zeros(18,1))'];

cd(Story);
if i == 1
name = ['001_',Experiment.Log.participantName];
eval(['save MCF_',Sixth,'_',name,' names onsets durations']);
elseif i == 38
name = ['038_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_',name,' names onsets durations']);
elseif i == 58
name = ['058_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_',name,' names onsets durations']); 
else
name = [Experiment.Log.participantName,'_', Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_',name,' names onsets durations']);
end
cd(input);

% Parametric regressors
pmod.name{1} = [Sixth, '_Pre_AB'];
pmod.param{1}= Par_Pre_A_B;
pmod.poly{1}  = 1;


cd(Story);
if i == 1
name = ['001_',Experiment.Log.participantName];
eval(['save MCF_',Sixth,'_Pre_AB_',name,' pmod']);
elseif i == 38
name = ['038_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Pre_AB_',name,' pmod']);
elseif i == 58
name = ['058_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Pre_AB_',name,' pmod']);
else
name = [Experiment.Log.participantName,'_', Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Pre_AB_',name,' pmod']);
end
cd(input);

pmod.name{1} = [Sixth, '_Pre_AX'];
pmod.param{1}= Par_Pre_A_X;
pmod.poly{1}  = 1;

cd(Story);
if i == 1
name = ['001_',Experiment.Log.participantName];
eval(['save MCF_',Sixth,'_Pre_AX_',name,' pmod']);
elseif i == 38
name = ['038_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Pre_AX_',name,' pmod']);
elseif i == 58
name = ['058_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Pre_AX_',name,' pmod']);
else
name = [Experiment.Log.participantName,'_', Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Pre_AX_',name,' pmod']);
end
cd(input);

pmod.name{1} = [Sixth, '_Link'];
pmod.param{1}= Par_Link;
pmod.poly{1}  = 1;

cd(Story);
if i == 1
name = ['001_',Experiment.Log.participantName];
eval(['save MCF_',Sixth,'_Link_',name,' pmod']);
elseif i == 38
name = ['038_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Link_',name,' pmod']);
elseif i == 58
name = ['058_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Link_',name,' pmod']);
else
name = [Experiment.Log.participantName,'_', Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Link_',name,' pmod']);
end
cd(input);

pmod.name{1} = [Sixth, '_Control'];
pmod.param{1}= Par_Control;
pmod.poly{1}  = 1;

cd(Story);
if i == 1
name = ['001_',Experiment.Log.participantName];
eval(['save MCF_',Sixth,'_Control_',name,' pmod']);
elseif i == 38
name = ['038_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Control_',name,' pmod']);
elseif i == 58
name = ['058_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Control_',name,' pmod']);
else
name = [Experiment.Log.participantName,'_', Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Control_',name,' pmod']);
end
cd(input);

pmod.name{1} = [Sixth, '_Post_AB'];
pmod.param{1}= Par_Post_A_B;
pmod.poly{1}  = 1;

cd(Story);
if i == 1
name = ['001_',Experiment.Log.participantName];
eval(['save MCF_',Sixth,'_Post_AB_',name,' pmod']);
elseif i == 38
name = ['038_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Post_AB_',name,' pmod']);
elseif i == 58
name = ['058_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Post_AB_',name,' pmod']);
else
name = [Experiment.Log.participantName,'_', Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Post_AB_',name,' pmod']);
end
cd(input);

pmod.name{1} = [Sixth, '_Post_AX'];
pmod.param{1}= Par_Post_A_X;
pmod.poly{1}  = 1;


cd(Story);
if i == 1
name = ['001_',Experiment.Log.participantName];
eval(['save MCF_',Sixth,'_Post_AX_',name,' pmod']);
elseif i == 38
name = ['038_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Post_AX_',name,' pmod']);
elseif i == 58
name = ['058_',Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Post_AX_',name,' pmod']);
else
name = [Experiment.Log.participantName,'_', Experiment.Log.participantCode];
eval(['save MCF_',Sixth,'_Post_AX_',name,' pmod']);
end
cd(input);

onsets = {}; 
names = {}; 
durations = {}; 
pmod = {};
