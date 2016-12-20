% makeSomatoWave: make a 4 channel waveform for the localizer experiment
% Cam McKenzie 8/1/2016

% reverse: 0 normal stimulus order
%          1 reversed stimulus order


function [stim] = makeBlockWave(stimFreq, amp)

onTime = 0.4;
offTime = 0.2;

sampleRate = 8192;

sigBase = (1:(round(onTime*sampleRate)+1))*(2*pi/sampleRate);

onWave = sin(stimFreq * sigBase);
offWave = zeros(1, floor(offTime*sampleRate));

stimWave = [onWave offWave onWave];
stimWave = amp*stimWave;
stimWave = [stimWave; stimWave]


%Stimulus sequence

% 1 & 2
% 2 & 3
% 3 & 4
% 4 & 1

stim.cond1 = stimWave;
