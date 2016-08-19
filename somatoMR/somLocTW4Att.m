% somLocTW4Att(reverse)
% 
% Traveling wave localizer. Modified to include fixation cross attention
% task (c.f. retinotopy) and 4 stimulus locations.
%
% Reverse = 0 runs in the normal direction 1-->2-->3-->4
% Reverse = 1 runs in the reversed direction 4-->3-->2-->1


function [myscreen] = somlocTW4Att(reverse)

%SET DEVICE ID HERE
deviceID = 5;


% % check arguments
% if ~any(nargin == [0])
%   help taskTemplate
%   return
% end

global stimulus
stimulus.scan = 1;
stimulus.reverse = reverse;




%% task parameters
task{1}{1}.waitForBacktick = 1;
task{1}{1}.seglen = [1 1 1 1 1 1]; %TR is actually 1.1, this will synch at each TR
task{1}{1}.synchToVol = [1 1 1 1 1 1];
task{1}{1}.getResponse = [0 0 0 0 0 0];
task{1}{1}.parameter.stimloc = [1 2 3 4];
task{1}{1}.parameter.freq = 50;

task{1}{1}.random = 0; %DO NOT RANDOMIZE A TRAVELING WAVE

task{1}{1}.numBlocks = 1; % Total volumes: n * 7 *  3 = 210 for n = 10, 420 for n = 20, + 16 more for cal = 436


%% Initialize Stimulus

myscreen = initScreen();
%Stimulus('stimulus',myscreen);

%% create stims

sounds = makeSomatoWave4(task{1}{1}.parameter.freq, reverse);

stimulus.cond1 = mglInstallSound(sounds.cond1);
stimulus.cond2 = mglInstallSound(sounds.cond2);
stimulus.cond3 = mglInstallSound(sounds.cond3);
stimulus.cond4 = mglInstallSound(sounds.cond4);

mglSetSound(stimulus.cond1, 'deviceID', deviceID);
mglSetSound(stimulus.cond2, 'deviceID', deviceID);
mglSetSound(stimulus.cond3, 'deviceID', deviceID);
mglSetSound(stimulus.cond4, 'deviceID', deviceID);





%%

%% Setup fixation task

[task{2} myscreen] = fixStairInitTask(myscreen)



% initialize the task
for phaseNum = 1:length(task{1})
  [task{1}{phaseNum} myscreen] = initTask(task{1}{phaseNum},myscreen,@startSegmentCallback,@screenUpdateCallback,[],@startTrialCallback,[],[]);
end

phaseNum = 1;
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

function [task myscreen] = startTrialCallback(task,myscreen)

disp(sprintf('(somato) Running at location %i', task.thistrial.stimloc));

function [task myscreen] = startSegmentCallback(task, myscreen)

global stimulus

if task.thistrial.stimloc == 1
    %play stim cond 1
    mglPlaySound(stimulus.cond1)
end

if task.thistrial.stimloc == 2
    %play stim cond 2
    mglPlaySound(stimulus.cond2)
end

if task.thistrial.stimloc == 3
    %play stim cond 3
    mglPlaySound(stimulus.cond3)
end

if task.thistrial.stimloc == 4
    %play stim cond 4
    mglPlaySound(stimulus.cond3)
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function to init the stimulus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stimulus = myInitStimulus(stimulus,myscreen,task,stimfile)

% determine pedestals
params = getTaskParameters(myscreen,task);

stimfile = [];



