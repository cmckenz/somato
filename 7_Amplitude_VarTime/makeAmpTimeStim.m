function [ampStim] = makeAmpTimeStim(offset, deltaN, eventLength, freq, Lbase, ampMid, ampUp)

delta = abs(deltaN);

if deltaN < 0
    order = 0;
end

if deltaN > 0
    order = 1;
end



%Assign R high and low
if Lbase
    ampL = ampMid;
    ampR = ampMid + ampUp;
end

if ~Lbase
   ampR = ampMid;
   ampL = ampMid + ampUp;
end 


%check we aren't scaling the sine wave up above max amplitude
if any([abs(ampL), abs(ampR)] > 1)
    disp('Make Stimulus Error: Please ensure amplitude scaling less than 1');
    return
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


ampStim = somTrial(somEvents, 8192);

%Amplitude scaling to get final stimulus
ampStim(1,:) = ampL*ampStim(1,:);
ampStim(2,:) = ampR*ampStim(2,:);