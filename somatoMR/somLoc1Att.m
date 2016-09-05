function [myscreen] = somLoc1Att()
% somLoc1Att
%
%One stream (rather than 2 stream parallel) somato amplitude localizer with
%attention task.



% check arguments
if ~any(nargin == [0])
  help taskTemplate
  return
end

%SET DEVICE ID HERE
global stimulus
stimulus.deviceID = 2;
stimulus.counter = 1; % This keeps track of what "run" we are on.
stimulus.scan = 1



%% Initialize Stimulus

%myscreen = initScreen('fMRIprojflex');
myscreen = initScreen('test');

%Stimulus('stimulus',myscreen);



%% task parameters

task{1}{1}.waitForBacktick = 1;
task{1}{1}.parameter.condLength = 1;
task{1}{1}.segmin = [2 2];
task{1}{1}.segmax = [2 9];
task{1}{1}.synchToVol = [0 1];
task{1}{1}.getResponse = [0 0];
task{1}{1}.parameter.freq = 80;
task{1}{1}.parameter.amplitude = [0.25 0.5 0.75 1];


task{1}{1}.random = 1;

task{1}{1}.numTrials = inf; % Stop with escape

task{2}{1} = task{1}{1};



%create stims

stimulus.sounds = stimCreateOneEvent2Str(task{1}{1}.parameter.condLength, task{1}{1}.parameter.freq);


%% Setup fixation task

[task{2} myscreen] = fixStairInitTask(myscreen);


%%


% initialize the task
%INIITALIZE ALL TASKS HERE
for phaseNum = 1:length(task{1})
  [task{1}{phaseNum} myscreen] = initTask(task{1}{phaseNum},myscreen,@startSegmentCallback1,@screenUpdateCallback,[],@startTrialCallback1,[],[]);
end

phaseNum = 1;

%CREATE TASK SPECIFIC CALLBACKS FOR STIMULUS PRESENTATION

%UPDATE ALL TASKS HERE
% Again, only one phase.
while (phaseNum <= length(task{1})) && ~myscreen.userHitEsc
    % update the task
    [task{1}, myscreen, phaseNum] = updateTask(task{1},myscreen,phaseNum);
    [task{2}, myscreen, phaseNum] = updateTask(task{2},myscreen,phaseNum);
    
    % flip screen
    myscreen = tickScreen(myscreen,task);
end



% if we got here, we are at the end of the experiment
myscreen = endTask(myscreen,task);

%%

function [task myscreen] = screenUpdateCallback(task, myscreen)
mglClearScreen();

function [task myscreen] = startTrialCallback1(task,myscreen)

disp('(somato) Running trial at location 1.');


function [task myscreen] = startSegmentCallback1(task, myscreen)

global stimulus

if task.thistrial.thisseg == 1
      %play stim cond 1
      trialSound = task.thistrial.amplitude*stimulus.sounds.cond1;
      soundNum = mglInstallSound(trialSound);
      mglSetSound(soundNum, 'deviceID', stimulus.deviceID);
      mglPlaySound(soundNum)
end

