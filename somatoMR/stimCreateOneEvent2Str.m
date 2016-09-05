% make a waveform for the localizer experiment

%lower number stimulators are proximal, first set (ch 1 + 2) on left arm,
%second set (ch 3 and 4) on right arm.

%1: proximal left
%2: distal left
%3: proximal right
%4: distal right

function [stim] = stimCreateOneEvent2Str(condLength, stimFreq)

sampleRate = 8192;

arrayLength = floor(sampleRate * condLength);

stimArray = zeros(2, arrayLength);

%Stimulus sequence

% 1 & 2
% 2 & 3
% 3 & 4
% 4 & 1

stim.cond1 = stimArray;
stim.cond2 = stimArray;

%stimulus sine wave

stimWave = sin(stimFreq * ((0:2*pi/(8192 - 1): condLength*2*pi)));
onLength = length(stimWave);

%cycle 1
stim.cond1(1, 1:onLength) = stimWave;
    
%cycle 2
stim.cond2(2, 1:onLength) = stimWave;


end
