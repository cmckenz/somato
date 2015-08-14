function condMean = AnalysisSA(filename)

load(filename)

a = getTaskParameters(myscreen, task);

ampDiffV = a.parameter.ampUp - a.parameter.ampMid;

ampDiffV(logical(a.parameter.Lbase)) = -1*ampDiffV(logical(a.parameter.Lbase));

unDiff = unique(ampDiffV);

for ii = 1:length(unDiff)
    condMean(1,ii) = unDiff(ii);
    condMean(2,ii) = nanmean(a.randVars.choice(ampDiffV  == unDiff(ii)));
end

figure

plot(condMean(1,:), condMean(2,:),'ko')
hold on
plot(condMean(1,:), condMean(2,:))