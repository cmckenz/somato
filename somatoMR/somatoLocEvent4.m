function [myscreen] = somatoLocEvent4()
%write task-specific callbacks and add to init function and task update
%calls

%SET DEVICE ID HERE
deviceID = 1;


% check arguments
if ~any(nargin == [0])
  help taskTemplate
  return
end

global stimulus
stimulus.counter = 1; % This keeps track of what "run" we are on.
stimulus.scan = 1



%% Initialize Stimulus

myscreen = initScreen();
%Stimulus('stimulus',myscreen);



%% task parameters

task{1}{1}.waitForBacktick = 1;
task{1}{1}.parameter.condLength = 1;
task{1}{1}.parameter.condLength = 1;
task{1}{1}.segmin = [2 2];
task{1}{1}.segmax = [2 9];
task{1}{1}.synchToVol = [0 1];
task{1}{1}.getResponse = [0 0];
task{1}{1}.parameter.freq = 80;


task{1}{1}.random = 1;

task{1}{1}.numTrials = 10; % Total volumes: 10 * 6 * 4 = 240 + 16 (calib)

task{2}{1} = task{1}{1};
task{3}{1} = task{1}{1};
task{4}{1} = task{1}{1};



%create stims

sounds = stimCreateOneEvent(task{1}{1}.parameter.condLength, task{1}{1}.parameter.freq);

stimulus.cond1 = mglInstallSound(sounds.cond1);
stimulus.cond2 = mglInstallSound(sounds.cond2);
stimulus.cond3 = mglInstallSound(sounds.cond3);
stimulus.cond4 = mglInstallSound(sounds.cond4);

mglSetSound(stimulus.cond1, 'deviceID', deviceID);
mglSetSound(stimulus.cond2, 'deviceID', deviceID);
mglSetSound(stimulus.cond3, 'deviceID', deviceID);
mglSetSound(stimulus.cond4, 'deviceID', deviceID);





%%


% initialize the task
%INIITALIZE ALL TASKS HERE
for phaseNum = 1:length(task{1})
  [task{1}{phaseNum} myscreen] = initTask(task{1}{phaseNum},myscreen,@startSegmentCallback1,@screenUpdateCallback,[],@startTrialCallback,[],[]);
  [task{2}{phaseNum} myscreen] = initTask(task{2}{phaseNum},myscreen,@startSegmentCallback2,@screenUpdateCallback,[],@startTrialCallback,[],[]);
  [task{3}{phaseNum} myscreen] = initTask(task{3}{phaseNum},myscreen,@startSegmentCallback3,@screenUpdateCallback,[],@startTrialCallback,[],[]);
  [task{4}{phaseNum} myscreen] = initTask(task{4}{phaseNum},myscreen,@startSegmentCallback4,@screenUpdateCallback,[],@startTrialCallback,[],[]);
end

phaseNum = 1;

%CREATE TASK SPECIFIC CALLBACKS FOR STIMULUS PRESENTATION

%UPDATE ALL TASKS HERE
% Again, only one phase.
while (phaseNum <= length(task{1})) && ~myscreen.userHitEsc
    % update the task
    [task{1}, myscreen, phaseNum] = updateTask(task{1},myscreen,phaseNum);
    [task{2}, myscreen, phaseNum] = updateTask(task{2},myscreen,phaseNum);
    [task{3}, myscreen, phaseNum] = updateTask(task{3},myscreen,phaseNum);
    [task{4}, myscreen, phaseNum] = updateTask(task{4},myscreen,phaseNum);

    % flip screen
    myscreen = tickScreen(myscreen,task);
end



% if we got here, we are at the end of the experiment
myscreen = endTask(myscreen,task);

%%

function [task myscreen] = screenUpdateCallback(task, myscreen)
mglClearScreen();

function [task myscreen] = startTrialCallback(task,myscreen)

disp('(somato) Running trial.');

function [task myscreen] = startSegmentCallback1(task, myscreen)

global stimulus

if task.thistrial.thisseg == 1
      %play stim cond 1
      mglPlaySound(stimulus.cond1)
end


function [task myscreen] = startSegmentCallback2(task, myscreen)

global stimulus

    
    if task.thistrial.thisseg == 1
      %play stim cond 1
      mglPlaySound(stimulus.cond2)
    end
    

    
function [task myscreen] = startSegmentCallback3(task, myscreen)

global stimulus


    if task.thistrial.thisseg == 3
      %play stim cond 1
      mglPlaySound(stimulus.cond3)
    end

    
function [task myscreen] = startSegmentCallback4(task, myscreen)

global stimulus

    if task.thistrial.thisseg == 4
      %play stim cond 1
      mglPlaySound(stimulus.cond4)
    end
   

