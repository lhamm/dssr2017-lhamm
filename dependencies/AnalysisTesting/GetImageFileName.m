function [res] = GetImageFileName(FileRoot, ImageFolderName, ImageCode, Strategy, DataFile, SeqInd, Frame)

if Strategy==1 || Strategy==2
    FullImageName           = strcat(FileRoot, ImageFolderName, ImageCode);
elseif Strategy==3 %only load if a new detect
    if ~DataFile.S_Data.FrameBullsEyeDetectRecord(SeqInd, Frame) %in detect mode - check Frame and FrameLoop in these.....
        FullImageName      = strcat(FileRoot, ImageFolderName, ImageCode);
    else
        FullImageName      = 'NA';
        
    end
elseif Strategy==4 %only load if a it has estimated an eye, and it is a new detect
    if ~isnan(DataFile.S_Data.EyeTested(SeqInd, Frame)) && mod(Frame, 10)==0%&& ~DataFile.S_Data.FrameBullsEyeDetectRecord(SeqInd, FrameList(j)) %eye estimate there and new detect
        FullImageName       = strcat(FileRoot, ImageFolderName, ImageCode);
    else
        FullImageName      = 'NA';
    end
elseif Strategy==6
    FullImageName       = strcat(FileRoot, ImageFolderName, ImageCode);
else
    FullImageName           = 'NA';
end

res = FullImageName;
