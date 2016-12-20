function [myscreen] = somLatMask()
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

stimulus.targArray = [];
stimulus.foilArray = ['A', 'B', 'C']
stimulus.letterToDraw = [];



%% Initialize Stimulus
%myscreen = initScreen('test');
%myscreen = initScreen('somato_buttons');
myscreen = initScreen('fMRIprojFlex');

%Stimulus('stimulus',myscreen);



%% task parameters

task{1}{1}.waitForBacktick = 1;
task{1}{1}.parameter.condLength = 1;
task{1}{1}.segmin = [2 2];
task{1}{1}.segmax = [2 9];
task{1}{1}.synchToVol = [0 1];
task{1}{1}.getResponse = [0 0];
task{1}{1}.parameter.freq = 80;

task{1}{1}.parameter.mask = [0 0.5];
task{1}{1}.parameter.amplitude = [0.25 0.5 0.75 1];
task{1}{1}.parameter.side = [-1 1];

%allocate this in callback to track condition
task{1}{1}.randVars.calculated.condition = 'UNDEFINED';



task{1}{1}.random = 1;

task{1}{1}.numTrials = inf; % Stop with escape



%create stims
stimFreq = task{1}{1}.parameter.freq;
condLength = task{1}{1}.parameter.condLength;
stimWave = sin(stimFreq * ((0:2*pi/(8192 - 1): condLength*2*pi)));

stimulus.sound = [stimWave; stimWave]
stimulus.probestring = [];

%% Setup fixation task - COUNT THE NUMBER OF Xs

task{2}{1}.waitForBacktick = 0;
task{2}{1}.segmin = [4 4 4 4 4 4 4 4 4 4 4 4 6 2];
task{2}{1}.segmax = [4 8 4 8 4 8 4 8 4 8 4 8 6 2];
task{2}{1}.synchToVol = [zeros(1, 13) 1];
task{2}{1}.getResponse = [zeros(1, 12) 1 0];
task{2}{1}.parameter.numtarg = [1 2 3 4 5 6];
task{2}{1}.parameter.adj = [-1 0 1];
task{2}{1}.randVars.calculated.resp = nan;
task{2}{1}.random = 1;

%%


% initialize the task
%INIITALIZE ALL TASKS HERE
for phaseNum = 1:length(task{1})
  [task{1}{phaseNum} myscreen] = initTask(task{1}{phaseNum},myscreen,@startSegmentCallback1,@screenUpdateCallback,[],@startTrialCallback1,[],[]);
  [task{2}{phaseNum} myscreen] = initTask(task{2}{phaseNum},myscreen,@startSegmentCallback2,@screenUpdateCallback2,@responseCallback,@startTrialCallback2,[],[]);
end

phaseNum = 1;

%CREATE TASK SPECIFIC CALLBACKS FOR STIMULUS PRESENTATION

%UPDATE ALL TASKS HERE
% Again, only one phase.

uh = 1;
while (phaseNum <= length(task{1})) && ~myscreen.userHitEsc
    % update the task
    [task{1}, myscreen, phaseNum] = updateTask(task{1},myscreen,phaseNum);
    [task{2}, myscreen, phaseNum] = updateTask(task{2},myscreen,phaseNum);
    
    uh = uh+1;
    
    % flip screen
    myscreen = tickScreen(myscreen,task);
end



% if we got here, we are at the end of the experiment
myscreen = endTask(myscreen,task);

%%

%For the somato task - there is no screen update, just clear the screen
function [task myscreen] = screenUpdateCallback(task, myscreen)
mglClearScreen();

%For the fix task, we'll do a bunch of stuff
function [task myscreen] = screenUpdateCallback2(task, myscreen)
global stimulus

mglClearScreen();

probestring = stimulus.probestring;
letterToDraw = stimulus.letterToDraw;
    
if task.thistrial.thisseg < 13
    if (mod(task.thistrial.thisseg, 2) == 0) %even segments
        mglTextDraw(letterToDraw, [0 0], 0, 0)
        %put a letter up on the screen here
    end
end


if task.thistrial.thisseg == 13 %response segment... update
    mglTextDraw(probestring, [0 0], 0, 0);
    mglTextDraw('PRESS BUTTON IF THIS IS CORRECT', [0 -5], 0, 0);
end

if task.thistrial.thisseg == 14
    mglTextDraw('Thank you for your (non?)-response', [0 0], 0, 0);
end


function [task myscreen] = startTrialCallback1(task,myscreen)

disp('(somato) Start of trial');

function [task myscreen] = startTrialCallback2(task,myscreen)

global stimulus

%Here we will set up the task a bit
targs = task.thistrial.numtarg
targArray = [ones(1,targs) zeros(1, 6 - targs)];
targArray = targArray(randperm(length(targArray)));
    
stimulus.targArray = targArray; %freshly permuted set of targets

function [task myscreen] = startSegmentCallback1(task, myscreen)

global stimulus

if task.thistrial.thisseg == 1
    
    if task.thistrial.side == -1 %stim on the left
      trialSound = stimulus.sound;
      trialSound(1,:) = trialSound(1,:)*task.thistrial.amplitude;
      trialSound(2,:) = trialSound(2,:)*task.thistrial.mask;
      soundNum = mglInstallSound(trialSound);
      mglSetSound(soundNum, 'deviceID', stimulus.deviceID);
      disp(sprintf('Delivering stimulus to left side: amplitude = %0.3f, mask = %0.3f', task.thistrial.amplitude, task.thistrial.mask))
      mglPlaySound(soundNum)
    end
    
    if task.thistrial.side == 1 %stim on the right
      trialSound = stimulus.sound;
      trialSound(2,:) = trialSound(2,:)*task.thistrial.amplitude;
      trialSound(1,:) = trialSound(1,:)*task.thistrial.mask;
      soundNum = mglInstallSound(trialSound);
      mglSetSound(soundNum, 'deviceID', stimulus.deviceID);
      disp(sprintf('Delivering stimulus to right side: amplitude = %0.3f, mask = %0.3f', task.thistrial.amplitude, task.thistrial.mask))
      mglPlaySound(soundNum)
    end
    
    task.thistrial.condition = ['S' num2str(task.thistrial.side) 'A' num2str(task.thistrial.amplitude) 'M' num2str(task.thistrial.mask)];

end

function [task myscreen] = startSegmentCallback2(task, myscreen)

global stimulus

if task.thistrial.thisseg < 13
    if (mod(task.thistrial.thisseg, 2) == 0) %even segments
        presIndex = task.thistrial.thisseg/2;
        stimPres = stimulus.targArray(presIndex);
        if stimPres
            %Draw an "X"
            stimulus.letterToDraw = 'X';
        else
            %Draw an A, B or C
            foilInd = randi(3);
            stimulus.letterToDraw = stimulus.foilArray(foilInd);
        end
    end
end

probeVal = task.thistrial.numtarg + task.thistrial.adj;

stimulus.probestring = sprintf('The letter X occurred %i times in the last stream', probeVal);

function [task myscreen] = responseCallback(task, myscreen)

if task.thistrial.gotResponse
    task.thistrial.resp = 1;
else
    task.thistrial.resp = 0;
end


