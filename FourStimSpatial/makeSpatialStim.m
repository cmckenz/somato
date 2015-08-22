
function [stimArray] = makeSpatialStim(offset, stimulatorA, stimulatorB, stimFreq, stimDelta, eventLength)

%somEvents: cell array {eventNum} = [startTime, eventLength, frequency,
%channel]

somEvents{1} = [offset, eventLength, stimFreq, stimulatorA];
somEvents{2} = [offset + eventLength + stimDelta, eventLength, stimFreq, stimulatorB];

stimArray = somTrial4(somEvents);
end
