function [ampStim] = makeAmpStim(offset, ampMid, ampDiff, Lbase, eventLength, freq)

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


ampStim = somTrial(somEvents, 8192);

%Amplitude scaling to get final stimulus
ampStim(1,:) = ampL*ampStim(1,:);
ampStim(2,:) = ampR*ampStim(2,:);