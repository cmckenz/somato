function [ampStim] = makeAmpMaskStim(offset, ampMid, ampDiff, Lbase, maskHigh, maskDelta, maskR, eventLength, freq)

%Assign R high and low

if Lbase
   ampR = ampMid + ampDiff;
   ampL = ampMid - ampDiff;
end 

if ~Lbase
   ampR = ampMid - ampDiff;
   ampL = ampMid + ampDiff;
end 


%check we aren't scaling the sine wave up above max amplitude
if any([abs(ampL), abs(ampR)] > 1)
    disp('Make Stimulus Error: Please ensure amplitude scaling less than 1');
    return
end

%create the stimArray
somEvents = {};


    somEvents{1}(1) = offset;
    somEvents{1}(2) = eventLength;
    somEvents{1}(3) = freq;
    somEvents{1}(4) = 0;

    somEvents{2}(1) = offset;
    somEvents{2}(2) = eventLength;
    somEvents{2}(3) = freq;
    somEvents{2}(4) = 1;
    
    somEvents{3}(1) = offset + maskDelta;
    somEvents{3}(2) = eventLength;
    somEvents{3}(3) = freq;
    somEvents{3}(4) = maskR;



ampStim = somTrial(somEvents, 8192);
ampLength = floor((offset + eventLength)*8192) + 1;

%Amplitude scaling to get final stimulus
ampStim(1,1:ampLength) = ampL*ampStim(1,1:ampLength);
ampStim(2,1:ampLength) = ampR*ampStim(2,1:ampLength);

if maskHigh
    maskAmp = max(ampL, ampR);
    ampStim(:,(ampLength + 1):end) = maskAmp*ampStim(:,(ampLength + 1):end);
end

if ~maskHigh
    maskAmp = min(ampL, ampR);
    ampStim(:,(ampLength + 1):end) = maskAmp*ampStim(:,(ampLength + 1):end);
end