%% This script catpures a webcam image, and looks for faces and bullseye targets of specified sizes
% be carefull how much goes in this script, as it runs every 'frame'
TimeAtStart     = clock;
videoFrame      = snapshot(cam);                          % Get the next frame.
videoFrameGray  = rgb2gray(videoFrame);                   % Convert to grayscale
videoFrameGray  = uint8(ImClip(videoFrameGray,ClipSize)); % Convert to cropped image ready for analysis and saving

%% face
if FaceTracking
    if numPts < 10 % I need to detect the face
        DR=1; %track if we needed to detect again!
        try
            bbox = faceDetector.step(videoFrameGray);        % Detection mode for face - this is the lengthy part!
        catch
        end
        if ~isempty(bbox) % there are contents produced by the face detector - yeah!
            points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));            % Find corner points inside the detected region.
            xyPoints = points.Location;            % Re-initialize the point tracker.
            numPts = size(xyPoints,1);
            release(pointTracker);
            initialize(pointTracker, xyPoints, videoFrameGray);
            oldPoints = xyPoints;
            bboxPoints = bbox2points(bbox(1, :)); % Convert the rectangle represented as [x, y, w, h] into an M-by-2 matrix of [x,y] coordinates of the four corners.
            FaceWidth = max(bboxPoints(:,1))-min(bboxPoints(:,1)); %check this
            FaceTrack=1;
        else
            FaceTrack=0;
        end
    else % have the face
        DetectRecord=0; %track if we needed to detect again!
        [xyPoints, isFound] = step(pointTracker, videoFrameGray);        % Tracking mode - quick!.
        visiblePoints = xyPoints(isFound, :);
        oldInliers = oldPoints(isFound, :);
        numPts = size(visiblePoints, 1);
        if numPts >= 10
            [xform, oldInliers, visiblePoints] = estimateGeometricTransform(oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);               % Estimate the geometric transformation between the old points and the new points.
            bboxPoints = transformPointsForward(xform, bboxPoints);            % Apply the transformation to the bounding box.
            oldPoints = visiblePoints;            % Reset the points.
            setPoints(pointTracker, oldPoints);
            FaceTrack=1;
        else
            FaceTrack=0;
        end
    end
end
%% same thing for bullseye
if BullsEyeTracking
    if BEFound==0; %need bullseye
        T1=mean(All(videoFrameGray))-0.5*std(double(All(videoFrameGray)));
        T2=mean(All(videoFrameGray))-0.7*std(double(All(videoFrameGray)));
        try
            [x0, y0, A] = get_bullseye_center_LH(videoFrameGray,LB, UB, T1, T2);
            BEbbox=A;
            [BEFound, BullsEyeWidth, EstimatedVD, EyeTestedGuess]=SubPixelAnalysis(videoFrameGray,BEbbox,SizeOfLargeTarget,PixelsPerDegreeOfIm, x0, y0);
        catch
            BEbbox=NaN; BEFound=0; BullsEyeWidth=NaN; EstimatedVD=[]; EyeTestedGuess=NaN;
        end
        if BEFound
            BEpoints = detectMinEigenFeatures(videoFrameGray, 'ROI', BEbbox(1, :));            % Find corner points inside the detected region.
            BExyPoints = BEpoints.Location;            % Re-initialize the point tracker.
            BEnumPts = size(BExyPoints,1);
            if exist('BEpointTracker','var')
                release(BEpointTracker); %not sure about this
            end
            try
                initialize(BEpointTracker, BExyPoints, videoFrameGray); %not sure about this
                BEoldPoints = BExyPoints;
                BEbboxPoints = bbox2points(BEbbox(1, :));             % Convert the rectangle represented as [x, y, w, h] into an M-by-2 matrix of [x,y] coordinates of the four corners
            catch
            end
        end
    elseif BEFound==1;   % have the bullseye - just want to track it
        try
        [BExyPoints, BEisFound] = step(BEpointTracker, videoFrameGray);
        BEvisiblePoints = BExyPoints(BEisFound, :);
        BEoldInliers = BEoldPoints(BEisFound, :);
        BEnumPts = size(BEvisiblePoints, 1);
        catch
        end
        if BEnumPts >= 10
            [BExform, BEoldInliers, BEvisiblePoints] = estimateGeometricTransform(BEoldInliers, BEvisiblePoints, 'similarity', 'MaxDistance', 4);               % Estimate the geometric transformation between the old points and the new points.
            BEbboxPoints = transformPointsForward(BExform, BEbboxPoints);            % Apply the transformation to the bounding box.
            BEoldPoints = BEvisiblePoints;            % Reset the points.
            setPoints(BEpointTracker, BEoldPoints);
            BEbbox=[BEbboxPoints(1,1),BEbboxPoints(1,2),(BEbboxPoints(2,1)-BEbboxPoints(1,1)),(BEbboxPoints(3,2)-BEbboxPoints(1,2))];
            %get subpixel accuracy
            try
                [BEFound, BullsEyeWidth, EstimatedVD, EyeTestedGuess, ClipIm]=SubPixelAnalysis(videoFrameGray,BEbbox,SizeOfLargeTarget,PixelsPerDegreeOfIm, x0, y0);
            catch
                BEbbox=NaN; BEFound=0; BullsEyeWidth=NaN; EstimatedVD=[]; EyeTestedGuess=NaN;
            end
        end
    end
end



