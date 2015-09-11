
function [myscreen] = somatoLocEvent1()


%SET DEVICE ID HERE
deviceID = 5;


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
task{1}{1}.segmin = [2 2];
task{1}{1}.segmax = [2 9];
task{1}{1}.synchToVol = [0 1];
task{1}{1}.getResponse = [0 0];
task{1}{1}.parameter.freq = 80;
task{1}{1}.parameter.condLength = 2;
task{1}{1}.parameter.cond = [1 2 3 4];


task{1}{1}.random = 1;

task{1}{1}.numTrials = 50; % Total volumes: 10 * 6 * 4 = 240 + 16 (calib)

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

disp('(somato) Running trial.');

function [task myscreen] = startSegmentCallback(task, myscreen)

global stimulus

if task.thistrial.thisseg == 1
    if task.thistrial.cond == 1
      %play stim cond 1
      mglPlaySound(stimulus.cond1)
    end
    
    if task.thistrial.cond == 2
      %play stim cond 1
      mglPlaySound(stimulus.cond2)
    end
    
    if task.thistrial.cond == 3
      %play stim cond 1
      mglPlaySound(stimulus.cond3)
    end
    
    if task.thistrial.cond == 4
      %play stim cond 1
      mglPlaySound(stimulus.cond4)
    end
    
end





  