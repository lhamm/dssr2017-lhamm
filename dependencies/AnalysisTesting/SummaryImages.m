function SummaryImages(VAResults)

NearInd             = find(VAResults(:,2,1)==40);
RERegNear           = VAResults(NearInd, 3, 1:2); BadRERegNear= find(RERegNear>0.2);
REVanNear           = VAResults(NearInd, 4, 1:2); BadREVanNear= find(REVanNear>0.2);
LERegNear           = VAResults(NearInd, 5, 1:2); BadLERegNear= find(LERegNear>0.2);
LEVanNear           = VAResults(NearInd, 6, 1:2); BadLEVanNear= find(LEVanNear>0.2);
NearCodes           = VAResults(NearInd, 1, 1:2);
PluggedInNear       = VAResults(NearInd, 4, 3); %only for RE vanishing


[CorR_LENear, CorP_LENear, BA_LENear] = LisaBlandAltman(LERegNear, LEVanNear, 'LERegNear', 'LEVanNear', NearCodes, PluggedInNear);
[CorR_RENear, CorP_RENear, BA_RENear] = LisaBlandAltman(RERegNear, REVanNear, 'RERegNear', 'REVanNear', NearCodes, PluggedInNear);

DistInd             = find(VAResults(:,2,1)==150);
RERegDist           = VAResults(DistInd, 3, 1:2);
REVanDist           = VAResults(DistInd, 4, 1:2);
LERegDist           = VAResults(DistInd, 5, 1:2);
LEVanDist           = VAResults(DistInd, 6, 1:2);
DistCodes           = VAResults(DistInd, 1, 1:2);
PluggedInDist       = VAResults(DistInd, 4, 3); %only for RE vanishing

[CorR_LEDist, CorP_LEDist, BA_LEDist] = LisaBlandAltman(LERegDist, LEVanDist, 'LERegDist', 'LEVanDist', DistCodes, PluggedInDist);
[CorR_REDist, CorP_REDist, BA_REDist] = LisaBlandAltman(RERegDist, REVanDist, 'RERegDist', 'REVanDist', DistCodes, PluggedInDist);

%% find the bad eggs
% find confidence >= 0.2
for i=1:2
    if i==1
        Dist=NearInd;
    else
        Dist=DistInd;
    end
    Inds=(find(VAResults(Dist, 3,2)>=0.2))';
    RERegParticipantsPoorCI(i, 1:length(Inds))=NearCodes(Inds);
    Inds=(find(VAResults(Dist, 4,2)>=0.2))';
    REVanParticipantsPoorCI(i, 1:length(Inds))=NearCodes(Inds);
    Inds=(find(VAResults(Dist, 5,2)>=0.2))';
    LERegParticipantsPoorCI(i, 1:length(Inds))=NearCodes(Inds);
    Inds=(find(VAResults(Dist, 6,2)>=0.2))';
    LEVanParticipantsPoorCI(i, 1:length(Inds))=NearCodes(Inds);
end

% find VA >=0.2
for i=1:2
    if i==1
        Dist=NearInd;
    else
        Dist=DistInd;
    end
    Inds=(find(VAResults(Dist, 3,1)>=0.2))';
    RERegParticipantsPoorVA(i, 1:length(Inds))=NearCodes(Inds);
    Inds=(find(VAResults(Dist, 4,1)>=0.2))';
    REVanParticipantsPoorVA(i, 1:length(Inds))=NearCodes(Inds);
    Inds=(find(VAResults(Dist, 5,1)>=0.2))';
    LERegParticipantsPoorVA(i, 1:length(Inds))=NearCodes(Inds);
    Inds=(find(VAResults(Dist, 6,1)>=0.2))';
    LEVanParticipantsPoorVA(i, 1:length(Inds))=NearCodes(Inds);
end

%% Make summary historgrams
% Results in VA
figure(1)
Eye={'Right Eye', 'Left Eye'};
Index=[2 3];
for i=1:2
    subplot(2,2,i)
    hold on
    h1=histogram(VAResults(NearInd, i+Index(i), 1));
    h1.BinWidth = 0.05;
    h1=histogram(VAResults(NearInd, i+Index(i)+1, 1));
    h1.BinWidth = 0.05;
    h1.FaceColor = [0 0.5 0.5];
    if i==1
        text(0.5,8,sprintf('\n%0.2f',RERegParticipantsPoorVA(1,:)), 'Color',[0 0.3 0.6])
        text(0.8,8,sprintf('\n%0.2f',REVanParticipantsPoorVA(1,:)),'Color',[0 0.5 0.5])
    else
        text(0.5,8,sprintf('\n%0.2f',LERegParticipantsPoorVA(1,:)), 'Color',[0 0.3 0.6])
        text(0.8,8,sprintf('\n%0.2f',LEVanParticipantsPoorVA(1,:)),'Color',[0 0.5 0.5])
    end
    axis([-0.4 1.2 0 10])
    title(sprintf('%s: Near', Eye{i}));
    
    subplot(2,2,i+2)
    hold on
    h2=histogram(VAResults(DistInd, i+Index(i), 1));
    h2.BinWidth = 0.05;
    h2=histogram(VAResults(DistInd, i+Index(i)+1, 1));
    h2.BinWidth = 0.05;
    h2.FaceColor = [0 0.5 0.5];
    if i==1
        text(0.5,8,sprintf('\n%0.2f',RERegParticipantsPoorVA(2,:)), 'Color',[0 0.3 0.6])
        text(0.8,8,sprintf('\n%0.2f',REVanParticipantsPoorVA(2,:)),'Color',[0 0.5 0.5])
    else
        text(0.5,8,sprintf('\n%0.2f',LERegParticipantsPoorVA(2,:)), 'Color',[0 0.3 0.6])
        text(0.8,8,sprintf('\n%0.2f',LEVanParticipantsPoorVA(2,:)),'Color',[0 0.5 0.5])
    end
    title(sprintf('%s: Distance', Eye{i}));
    axis([-0.4 1.2 0 10])
    
end
figure(2)
% Confidence in VA threshold estimations
Eye={'Right Eye', 'Left Eye'};
Index=[2 3];
for i=1:2
    subplot(2,2,i)
    hold on
    h1=histogram(VAResults(NearInd, i+Index(i), 2));
    h1.BinWidth = 0.05;
    h1=histogram(VAResults(NearInd, i+Index(i)+1, 2));
    h1.BinWidth = 0.05;
    h1.FaceColor = [0 0.5 0.5];
    if i==1
        text(0.2,15,sprintf('\n%0.2f',RERegParticipantsPoorCI(1,:)), 'Color',[0 0.3 0.6])
        text(0.4,15,sprintf('\n%0.2f',REVanParticipantsPoorCI(1,:)),'Color',[0 0.5 0.5])
    else
        text(0.2,15,sprintf('\n%0.2f',LERegParticipantsPoorCI(1,:)), 'Color',[0 0.3 0.6])
        text(0.4,15,sprintf('\n%0.2f',LEVanParticipantsPoorCI(1,:)),'Color',[0 0.5 0.5])
    end
    axis([-0.1 0.6 0 25])
    title(sprintf('%s: Near', Eye{i}));
    
    subplot(2,2,i+2)
    hold on
    h2=histogram(VAResults(DistInd, i+Index(i), 2));
    h2.BinWidth = 0.05;
    h2=histogram(VAResults(DistInd, i+Index(i)+1, 2));
    h2.BinWidth = 0.05;
    h2.FaceColor = [0 0.5 0.5];
    if i==1
        text(0.2,15,sprintf('\n%0.2f',RERegParticipantsPoorCI(2,:)), 'Color',[0 0.3 0.6])
        text(0.4,15,sprintf('\n%0.2f',REVanParticipantsPoorCI(2,:)),'Color',[0 0.5 0.5])
    else
        text(0.2,15,sprintf('\n%0.2f',LERegParticipantsPoorCI(2,:)), 'Color',[0 0.3 0.6])
        text(0.4,15,sprintf('\n%0.2f',LEVanParticipantsPoorCI(2,:)),'Color',[0 0.5 0.5])
    end
    title(sprintf('%s: Distance', Eye{i}));
    axis([-0.1 0.6 0 25])
    
end







