function stimArray = somTrial4(somEvents, sampleRate)

%somEvents: cell array {eventNum} = [startTime, eventLength, frequency,
%channel]
sampleRate = 8192;
totalTime = somEvents{end}(1) + somEvents{end}(2);

stimArray = zeros(4, floor(totalTime*sampleRate) + 1);

for ii = 1:length(somEvents)
    
    startTime = somEvents{ii}(1);
    eventLength = somEvents{ii}(2);
    frequency = somEvents{ii}(3);
    channel = somEvents{ii}(4);
    
    signal = ((1:(floor(eventLength*sampleRate) + 1))*2*pi)/sampleRate;
    signal = sin(frequency*signal);
    
    firstStimSample = floor(startTime*sampleRate);
    
    sigLength = length(signal);
    
    
    stimArray(channel, firstStimSample:(firstStimSample + sigLength - 1)) = signal;
end