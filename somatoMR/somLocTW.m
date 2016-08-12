
function [myscreen] = somLocTW(reverse)

%SET DEVICE ID HERE
deviceID = 5;
amp = 3;

% % check arguments
% if ~any(nargin == [0])
%   help taskTemplate
%   return
% end

global stimulus
stimulus.scan = 1;
stimulus.reverse = reverse;



%% Initialize Stimulus

myscreen = initScreen();
%Stimulus('stimulus',myscreen);



%% task parameters
task{1}{1}.waitForBacktick = 1;
task{1}{1}.seglen = [1 1 1 1 1 1 1]; %TR is actually 1.1, this will synch at each TR
task{1}{1}.synchToVol = [1 1 1 1 1 1 1];
task{1}{1}.getResponse = [0 0 0 0 0 0 0];
task{1}{1}.parameter.stimloc = [1 2 3];
task{1}{1}.parameter.freq = 30;

task{1}{1}.random = 0;

task{1}{1}.numBlocks = 20; % Total volumes: 20 * 3 * 7 = 420 + 16 (calib) = 436

%create stims

sounds = makeSomatoWave3(task{1}{1}.parameter.freq, reverse, amp);

stimulus.cond1 = mglInstallSound(sounds.cond1);
stimulus.cond2 = mglInstallSound(sounds.cond2);
stimulus.cond3 = mglInstallSound(sounds.cond3);

mglSetSound(stimulus.cond1, 'deviceID', deviceID);
mglSetSound(stimulus.cond2, 'deviceID', deviceID);
mglSetSound(stimulus.cond3, 'deviceID', deviceID);





%%


% initialize the task
for phaseNum = 1:length(task)
  [task{1}{phaseNum} myscreen] = initTask(task{1}{phaseNum},myscreen,@startSegmentCallback,@screenUpdateCallback,[],@startTrialCallback,[],[]);
end

phaseNum = 1;
% Again, only one phase.
while (phaseNum <= length(task{1})) && ~myscreen.userHitEsc
    % update the task
    [task{1}, myscreen, phaseNum] = updateTask(task{1},myscreen,phaseNum);
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

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function to init the stimulus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stimulus = myInitStimulus(stimulus,myscreen,task,stimfile)

% determine pedestals
params = getTaskParameters(myscreen,task);

stimfile = [];



