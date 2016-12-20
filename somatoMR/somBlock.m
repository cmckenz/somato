
function [myscreen] = somBlock()

%SET DEVICE ID HERE
deviceID = 2;
amp = 0.6;

% % check arguments
% if ~any(nargin == [0])
%   help taskTemplate
%   return
% end

global stimulus
stimulus.scan = 1;



%% Initialize Stimulus

myscreen = initScreen('test');
%Stimulus('stimulus',myscreen);



%% task parameters
task{1}{1}.waitForBacktick = 1;
task{1}{1}.seglen = [0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95 0.95]; %TR is actually 0.5, this should synch at each TR
task{1}{1}.synchToVol = ones(1,12);
task{1}{1}.getResponse = zeros(1,12);
task{1}{1}.parameter.stimloc = [1 2];
task{1}{1}.parameter.freq = 30;

task{1}{1}.random = 0;


task{1}{1}.numBlocks = 20; % Total volumes: 20 * 3 * 7 = 420 + 16 (calib) = 436

%create stims

sounds = makeBlockWave(task{1}{1}.parameter.freq, amp);

stimulus.cond1 = mglInstallSound(sounds.cond1);


mglSetSound(stimulus.cond1, 'deviceID', deviceID);





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
    if mod(task.thistrial.thisseg,2) == 1
        disp('You feel that? That is a buzzing on your fingers.')
        mglPlaySound(stimulus.cond1)
    end
end

if task.thistrial.stimloc == 2
    %play stim cond 2
    disp('Hush, dear. (no sound delivered)')
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function to init the stimulus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stimulus = myInitStimulus(stimulus,myscreen,task,stimfile)

% determine pedestals
params = getTaskParameters(myscreen,task);

stimfile = [];



