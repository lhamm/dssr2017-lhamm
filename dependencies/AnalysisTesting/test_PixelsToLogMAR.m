%% test pixel to logmar calculation

assert(round(10.^(PixelsToLogMAR(100,100, 57,1))) == 60,'At 57cm 1 degree (60minutes) is about 1cm') 