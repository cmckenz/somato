function condMean = AnalysisSLR(filename)

load(filename)

a = getTaskParameters(myscreen, task);

unDelt = unique(a.parameter.delta);

for ii = 1:length(unDelt)
    condMean(1,ii) = unDelt(ii);
    condMean(2,ii) = nanmean(a.randVars.choice(a.parameter.delta  == unDelt(ii)));
end

figure

plot(condMean(1,:), condMean(2,:),'ko')
hold on
plot(condMean(1,:), condMean(2,:))