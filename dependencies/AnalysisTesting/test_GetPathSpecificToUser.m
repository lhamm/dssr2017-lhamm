%% Explain
%DestinationAfterUser1 = 'Desktop';
%DestinationAfterUser2 = 'Dssr2017-lhamm';
%DestinationAfterUser3 = 'Dummy';
%DestinationAfterUser4 = 'Should not exist';

assert(strcmp (GetPathSpecificToUser('Desktop', 'Dssr2017-lhamm', 'Dummy'),'C:\Users\Dakin Lab\Desktop\Dssr2017-lhamm\Dummy\') ==1,'The strings should be the same') 