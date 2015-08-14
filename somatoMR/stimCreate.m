% make a waveform for the localizer experiment

%lower number stimulators are proximal, first set (ch 1 + 2) on left arm,
%second set (ch 3 and 4) on right arm.

%1: proximal left
%2: distal left
%3: proximal right
%4: distal right

stimFreq = 120;
sampleRate = 8192;

stimArray = zeros(4, sampleRate*24);

%Stimulus sequence

% 1 & 2
% 2 & 3
% 3 & 4
% 4 & 1

%stimulus sine wave

stimWave = sin(stimFreq * (1: (6 * sampleRate)));
onLength = length(stimWave);

%cycle 1
stimArray(1, 1:onLength) = stimWave;
stimArray(2, 1:onLength) = stimWave;
    
%cycle 2
stimArray(2, ((onLength + 1):(onLength + onLength))) = stimWave;
stimArray(3, ((onLength + 1):(onLength + onLength))) = stimWave;

%cycle 3
stimArray(3, ((2*onLength + 1):(onLength + 2*onLength))) = stimWave;
stimArray(4, ((2*onLength + 1):(onLength + 2*onLength))) = stimWave;


%cycle 4
stimArray(4, ((3*onLength + 1):(onLength + 3*onLength))) = stimWave;
stimArray(1, ((3*onLength + 1):(onLength + 3*onLength))) = stimWave;

