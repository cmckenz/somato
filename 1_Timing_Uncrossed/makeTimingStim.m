function [timeStim] = makeTimingStim(offset, deltaN, eventLength, freq)

delta = abs(deltaN);

if deltaN < 0
    order = 0;
end

if deltaN > 0
    order = 1;
end

% Conditions: delta < 0, 0, delta > 0, 
somEvents = {};


    somEvents{1}(1) = offset;
    somEvents{1}(2) = eventLength;
    somEvents{1}(3) = freq;
    somEvents{1}(4) = order;

    somEvents{2}(1) = offset + delta;
    somEvents{2}(2) = eventLength;
    somEvents{2}(3) = freq;
    somEvents{2}(4) = ~order;


timeStim = somTrial(somEvents, 8192);

sound(timeStim, 8192)