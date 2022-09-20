if 1
% Special Measure Configuration
    ljud_LoadDriver;
    [Error1, ljHandle1] = ljud_OpenLabJack(3,1,'1',0); %3 - DeviceType : labjack U3; 1 - connection types: USB; 
    [Error2, ljHandle2] = ljud_OpenLabJack(3,1,'2',0); 
    [Error3, ljHandle3] = ljud_OpenLabJack(3,1,'3',0); 

    global smdata;
%     global smaux smdata smscan ;

    if strcmp(char(java.net.InetAddress.getLocalHost.getHostName),'DESKTOP-TGBUF3C') % Dragonfly microscope
    %     S1 = load('C:\Users\CZC009BNRS\Documents\MATLAB\sm local data\smaux.mat');
    %     S2 = load('C:\Users\CZC009BNRS\Documents\MATLAB\sm local data\scan_twovalves.mat');
        S3 = load('C:\Users\CZC009BNRS\Documents\MATLAB\sm local data\rack_valvebank.mat');
    end

%     smaux = S1.smaux;
%     smscan = S2.smscan;
    smdata = S3.smdata;

%     clear S1 S2 S3;

    clear S3;
    
    smdata.inst(1).data.ljHandle = ljHandle1;
    smdata.inst(2).data.ljHandle = ljHandle2;
    smdata.inst(3).data.ljHandle = ljHandle3;

else
    disp ('startup script disabled. edit script to enable');
end