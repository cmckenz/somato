function [mergeStim] = makeMergeStim(offset, delta, eventLength, condition, freq)

% Four conditions: 11, 12, 21, 22
somEvents = {};


if (condition == 11) || (condition == 22)
    
    %set buzzer to 0 or 1
    if condition == 11
        order = 0;
    else
        order = 1;
    end
    
    %if 
    if delta < eventLength
        eventLength = 2*eventLength - delta;
        
        somEvents{1}(1) = offset;
        somEvents{1}(2) = eventLength;
        somEvents{1}(3) = freq;
        somEvents{1}(4) = order;
    else
        somEvents{1}(1) = offset;
        somEvents{1}(2) = eventLength;
        somEvents{1}(3) = freq;
        somEvents{1}(4) = order;
        
        somEvents{2}(1) = offset + delta;
        somEvents{2}(2) = eventLength;
        somEvents{2}(3) = freq;
        somEvents{2}(4) = order;
    end
    
end

if condition == 12
    
    order = 0;
    
    somEvents{1}(1) = offset;
    somEvents{1}(2) = eventLength;
    somEvents{1}(3) = freq;
    somEvents{1}(4) = order;

    somEvents{2}(1) = offset + delta;
    somEvents{2}(2) = eventLength;
    somEvents{2}(3) = freq;
    somEvents{2}(4) = ~order;

end

if condition == 21
    
    order = 1;
    
    somEvents{1}(1) = offset;
    somEvents{1}(2) = eventLength;
    somEvents{1}(3) = freq;
    somEvents{1}(4) = order;

    somEvents{2}(1) = offset + delta;
    somEvents{2}(2) = eventLength;
    somEvents{2}(3) = freq;
    somEvents{2}(4) = ~order;

end

mergeStim = somTrial(somEvents, 8192);

sound(mergeStim, 8192)