% somLeftRight.m
%
%        $Id:$ 
%      usage: somAmpCrossed()
%         by: cameron mckenzie (edited from justin gardner 'somdis')
%       date: 06/22/15
%    purpose: Crossed Hands Somatosensory Amplitude Discrimination
%

% [mergeStim] = makeMergeStim(offset, delta, eventLength, condition, freq)

%Let's do method of constant stim to start, staircase later

% MAKE SURE LEFT HAND GETS STIMULATOR ONE


%makeAmpStim(offset, ampMid, ampUp, Lbase, eventLength, freq)

%1: proximal stimulator

function myscreen = somAmpCrossed()

% check arguments
if ~any(nargin == [0])
  help taskTemplate
  return
end

% initalize the screen

%tab is 49, \ is 43
myscreen.responseKeys = {49 43};
myscreen = initScreen(myscreen);

%are hands crossed in this experiment?

crossed = 1;

% get the last stimfile
stimfile = getLastStimfile(myscreen,'stimfileNum=-1');

% task parameters
task{1}.waitForBacktick = 1;
task{1}.segmin = [1.5 2 1];
task{1}.segmax = [1.5 2 9];
task{1}.synchToVol = [0 0 0];
task{1}.getResponse = [0 1 0];
task{1}.numBlocks = 6; %12 blocks per session

%fixed stimulus parameters
task{1}.parameter.offset = 0.3;
task{1}.parameter.eventLength = 0.01;
task{1}.parameter.freq = 60;

%variable stimulus parameter - gap between two middle stimulations
task{1}.parameter.ampMid = [0.3 0.4 0.5 0.6 0.7];
task{1}.parameter.ampUp = [0.1 0.2 0.3];
task{1}.parameter.Lbase = [0 1];



task{1}.randVars.calculated.choice = nan;

task{1}.random = 1;

%TESTING FLAG... REDUCES SEG LENGTHS, KILLS BACKTICK
testing = true;

if testing
  task{1}.waitForBacktick = 0;
  task{1}.segmin = [1 2 0.5];
  task{1}.segmax = [1 2 1.5];
% task{1}.parameter.pedestal = [-1 0.5 0.25 0.125 0];
% task{1}.parameter.pedestal = [-1 0.5];
  task{1}.synchToVol = [0 0 0];
end

% initialize the task
for phaseNum = 1:length(task)
  [task{phaseNum} myscreen] = initTask(task{phaseNum},myscreen,@startSegmentCallback,@screenUpdateCallback,@responseCallback);
end

% init the stimulus
global stimulus;
myscreen = initStimulus('stimulus',myscreen);
stimulus = myInitStimulus(stimulus,myscreen,task,stimfile);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main display loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phaseNum = 1;
while (phaseNum <= length(task)) && ~myscreen.userHitEsc
  % update the task
  [task myscreen phaseNum] = updateTask(task,myscreen,phaseNum);
  % flip screen
  myscreen = tickScreen(myscreen,task);
end

% if we got here, we are at the end of the experiment
myscreen = endTask(myscreen,task);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function that gets called at the start of each segment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [task myscreen] = startSegmentCallback(task, myscreen)

%global stimulus;

if task.thistrial.thisseg == 1
  % time, so that we can preciesly set the two stimulation intervals
  %timeNow = mglGetSecs;
  
  % stimulus parameters
  offset = task.thistrial.offset;
  ampMid = task.thistrial.ampMid;
  ampUp = task.thistrial.ampUp;
  Lbase = task.thistrial.Lbase;
  eventLength = task.thistrial.eventLength;
  freq = task.thistrial.freq;

  [trialStim] = makeAmpStim(offset, ampMid, ampUp, Lbase, eventLength, freq);
  
  
  
  sound(trialStim)
  
end

% if task.thistrial.thisseg == 3
%   % no response
%   if isnan(task.thistrial.correct)
%     task.thistrial.correct = false;
%     % update appropriate staircase
%     staircaseNum = find(stimulus.pedestal==task.thistrial.pedestal);
%     stimulus.s(staircaseNum) = doStaircase('update',stimulus.s(staircaseNum),task.thistrial.correct);
%     %  threshold = doStaircase('threshold',stimulus.s(staircaseNum));
%     disp(sprintf('  No response. Delta: %0.2f',task.thistrial.delta));
%   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function that gets called to draw the stimulus each frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [task myscreen] = screenUpdateCallback(task, myscreen)

%global stimulus
% 
 % display fixation cross
mglClearScreen;
if (task.thistrial.thisseg == 1)
    mglFixationCross(1,1,[0 1 1]);
end

if task.thistrial.thisseg == 3
    if isnan(task.thistrial.choice)
        mglFillOval(0, 0, [1, 1],  [1 0 0]);
    else
        mglFillOval(0, 0, [1, 1],  [0 1 0]);
    end
end


end

%%%%%%%%%%%%%%%%%%%%%%%%%%
%    responseCallback    %
%%%%%%%%%%%%%%%%%%%%%%%%%%
function [task myscreen] = responseCallback(task,myscreen)

%global stimulus

if task.thistrial.gotResponse < 1
    if task.thistrial.whichButton == 1 %TAB
        task.thistrial.choice = 0;
    end
           
    if task.thistrial.whichButton == 2 %\
       task.thistrial.choice = 1;
    end
    
    if crossed
        task.thistrial.choice = ~task.thistrial.choice;
    end
    
    task = jumpSegment(task);
    
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function to init the stimulus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stimulus = myInitStimulus(stimulus,myscreen,task,stimfile)

% determine pedestals
params = getTaskParameters(myscreen,task);

stimfile = [];


end

end



