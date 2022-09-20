function val = smcLabJack(ico, val, rate)
% Driver for LabJack U3 device, currently only supports FIO digital IO
% ports.  Drivers for the device should be downloaded from the Labjack
% website and installed in appropriate directories
% ico(1): instrument
% ico(2): channel (1-8 --> FIO 0-7)       
% ico(3): operation (0 --> read, 1 --> set)


global smdata;

% constants copied from ljud_Constants.m provided by vendor
LJ_ioGET_DIGITAL_BIT_STATE = 32; % does not change direction of bit, allowing readback of output
LJ_ioPUT_DIGITAL_BIT = 40; % UE9 + U3
LJ_ioPIN_CONFIGURATION_RESET = 2017; % U3
% end

% store the handle to the labjack object in this variable
ljHandle = smdata.inst(ico(1)).data.ljHandle;


%Start by using the pin_configuration_reset IOType so that all
%pin assignments are in the factory default condition.
Error = ljud_ePut (ljHandle, LJ_ioPIN_CONFIGURATION_RESET, 0, 0, 0);
Error_Message(Error)

switch ico(3)
    case 0 %get
        [Error val] = ljud_eGet(ljHandle,LJ_ioGET_DIGITAL_BIT_STATE,ico(2)-1,0,0);
        Error_Message(Error)
    case 1 %set
        Error = ljud_ePut(ljHandle,LJ_ioPUT_DIGITAL_BIT,ico(2)-1,val,0);
        Error_Message(Error)
end
