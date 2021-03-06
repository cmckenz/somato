% makeSomatoWave: make a 4 channel waveform for the localizer experiment
% Cam McKenzie 8/1/2016

% reverse: 0 normal stimulus order
%          1 reversed stimulus order


function [stim] = makeSomatoWave4(stimFreq, reverse)

onTime = 0.45;
offTime = 0.1;

sampleRate = 8192;

onWave = sin(stimFreq * ((1/(sampleRate - 1):2*pi/(sampleRate - 1): onTime*2*pi)));
offWave = zeros(1, floor(offTime*sampleRate));

stimWave = [onWave offWave onWave];

arrayLength = length(stimWave);

stimArray = zeros(4, arrayLength);

%Stimulus sequence

% 1 & 2
% 2 & 3
% 3 & 4
% 4 & 1

stim.cond1 = stimArray;
stim.cond2 = stimArray;
stim.cond3 = stimArray;
stim.cond4 = stimArray;

%stimulus sine wave

onLength = length(stimWave);


if reverse == 0
    %cycle 1
    stim.cond1(1, :) = stimWave;
    
    %cycle 2
    stim.cond2(2, :) = stimWave;
    
    %cycle 3
    stim.cond3(3, :) = stimWave;
    
    %cycle 4
    stim.cond4(4, :) = stimWave;
    
    
end

if reverse == 1
    %cycle 2
    stim.cond1(4, :) = stimWave;
    
    %cycle 2
    stim.cond2(3, :) = stimWave;
    
    %cycle 3
    stim.cond3(2, :) = stimWave;

    %cycle 4
    stim.cond4(1, :) = stimWave;

end

end
