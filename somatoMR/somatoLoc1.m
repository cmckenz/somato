

function [myscreen] = somatoLoc1()


% check arguments
if ~any(nargin == [0])
  help taskTemplate
  return
end

global stimulus

stimulus.counter = 1; % This keeps track of what "run" we are on.
stimulus.scan = 1



%% Initialize Stimulus

myscreen = initStimulus('stimulus',myscreen);



%% task parameters
task{1}.waitForBacktick = 1;
task{1}.segmin = [6 6 6 6];
task{1}.segmax = [6 6 6 6];
task{1}.synchToVol = [0 0 0 1];
task{1}.getResponse = [0 0 0 0];
task{1}.parameter.freq = 80;
task{1}.parameter.condLength = 6.6;

task{1}.random = 0;

task{1}.numBlocks = 10; %12 blocks per session

%create stims

sounds = stimcreate2(task{1}.parameter.condLength, task{1}.parameter.freq);

cond1 = mglInstallSound(sounds.cond1);
cond2 = mglInstallSound(sounds.cond2);
cond3 = mglInstallSound(sounds.cond3);
cond4 = mglInstallSound(sounds.cond4);

mglSetSound(cond1, 'deviceID', deviceID);
mglSetSound(cond2, 'deviceID', deviceID);
mglSetSound(cond3, 'deviceID', deviceID);
mglSetSound(cond4, 'deviceID', deviceID);





%%


% initialize the task
for phaseNum = 1:length(task)
  [task{phaseNum} myscreen] = initTask(task{phaseNum},myscreen,@startSegmentCallback,[],[]);
end

%%

function [task myscreen] = startSegmentCallback(task, myscreen)

if task.thistrial.thisseg == 1
    %play stim cond 1
    mglPlaySound(cond1)
end

if task.thistrial.thisseg == 2
    %play stim cond 2
    mglPlaySound(cond2)
end

if task.thistrial.thisseg == 3
    %play stim cond 3
    mglPlaySound(cond3)
end

if task.thistrial.thisseg == 4
    %play stim cond 4
    mglPlaySound(cond4)
end

