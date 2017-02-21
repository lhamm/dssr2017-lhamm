% MyDate

function res=MyDate()

nowNum=now;
mytime=datestr(nowNum,15);

res=sprintf('%s%s%s_%s%s',datestr(nowNum,7), datestr(nowNum,5), datestr(nowNum,11),mytime(1:2),mytime(end-1:end) );