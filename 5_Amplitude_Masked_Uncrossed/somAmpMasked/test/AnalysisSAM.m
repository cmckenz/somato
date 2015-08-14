function output = AnalysisSAM(filename)

load(filename)

a = getTaskParameters(myscreen, task);


a.randVars.choice(isnan(a.randVars.choice)) = 0.5;

a = getTaskParameters(myscreen, task);

ampDiffV = a.parameter.ampUp - a.parameter.ampMid;

ampDiffV(logical(a.parameter.Lbase)) = -1*ampDiffV(logical(a.parameter.Lbase));

unDiff = unique(ampDiffV);

for ii = 1:length(unDiff)
    condMean(1,ii) = unDiff(ii);
    condMean(2,ii) = nanmean(a.randVars.choice(ampDiffV  == unDiff(ii)));
end


output.condMean = condMean;

RMaskAmpDiff = ampDiffV(logical(a.parameter.maskR));
LMaskAmpDiff = ampDiffV(~logical(a.parameter.maskR));

Rchoice = a.randVars.choice(logical(a.parameter.maskR));
Lchoice = a.randVars.choice(~logical(a.parameter.maskR));

for ii = 1:length(unDiff)
    LMean(1,ii) = unDiff(ii);
    LMean(2,ii) = nanmean(Lchoice(LMaskAmpDiff  == unDiff(ii)));
    
    RMean(1,ii) = unDiff(ii);
    RMean(2,ii) = nanmean(Rchoice(RMaskAmpDiff  == unDiff(ii)));
end

unMD = unique(a.parameter.maskDelta);

RD = a.parameter.maskDelta(logical(a.parameter.maskR));
LD = a.parameter.maskDelta(~logical(a.parameter.maskR)); 

for ii = 1:length(unMD)
    LMMean(1,ii) = unMD(ii);
    LMMean(2,ii) = nanmean(Lchoice(LD  == unMD(ii)));
    
    RMMean(1,ii) = unMD(ii);
    RMMean(2,ii) = nanmean(Rchoice(RD  == unMD(ii)));
end

figure

plot(condMean(1,:), condMean(2,:),'ko')
hold on
plot(condMean(1,:), condMean(2,:))

plot(LMean(1,:), LMean(2,:), 'r')
plot(RMean(1,:), RMean(2,:), 'g')

figure

plot(LMMean(1,:), LMMean(2,:), 'r')

hold on

plot(RMMean(1,:), RMMean(2,:), 'g')






