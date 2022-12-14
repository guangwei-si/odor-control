function varargout = odorGUI_24(varargin)
% ODORGUI_24 MATLAB code for odorGUI_24.fig
%      ODORGUI_24, by itself, creates a new ODORGUI_24 or raises the existing
%      singleton*.
%
%      H = ODORGUI_24 returns the handle to a new ODORGUI_24 or the handle to
%      the existing singleton*.
%
%      ODORGUI_24('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ODORGUI_24.M with the given input arguments.
%
%      ODORGUI_24('Property','Value',...) creates a new ODORGUI_24 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before odorGUI_24_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to odorGUI_24_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help odorGUI_24

% Last Modified by GUIDE v2.5 12-Dec-2016 17:23:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @odorGUI_24_OpeningFcn, ...
                   'gui_OutputFcn',  @odorGUI_24_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before odorGUI_24 is made visible.
function odorGUI_24_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to odorGUI_24 (see VARARGIN)

% Choose default command line output for odorGUI_24
handles.output = hObject;

%define the current mode is for test, after test, delete
%it.
handles.test_mode = 1;

currentFolder = pwd;
path = [currentFolder, '\data\'];
load([path, 'odor_inf'], 'odor_list', 'odor_concentration_list', 'odor_colormap');

handles.library.odor_total_list = odor_list;
handles.library.concentration_total_list = odor_concentration_list;
handles.library.odor_colormap = odor_colormap;

%initial channel setting
handles.channel_number = 8;
handles.channel_type = 1; %1 means 1-N chip; 2 means N-N chip.
handles.channel_water = 'A8';
handles.channel_control_water = 'A6';
handles.channel_control_odor = 'A7';
handles.odorchannel_list = [{'A1'}; {'A2'}; {'A3'}; {'A4'}; {'A5'}];
handles.channel_string = [{'A1'}; {'A2'}; {'A3'}; {'A4'}; {'A5'}; {'A6'}; {'A7'}; {'A8'};...
    {'B1'}; {'B2'}; {'B3'}; {'B4'}; {'B5'}; {'B6'}; {'B7'}; {'B8'}; ...
    {'C1'}; {'C2'}; {'C3'}; {'C4'}; {'C5'}; {'C6'}; {'C7'}; {'C8'}];
handles.all_valves=[handles.channel_control_water; handles.channel_control_odor;...
    handles.channel_water;...
    handles.odorchannel_list];

handles.channel_color = ones(5, 3); %set the bkg color of the channel
handles.conc_plus_odor_list=cell(5,1);
handles.conc_list=cell(5,1);
handles.odor_list=cell(5,1);
% initial odor sequence information 
handles.sequence_number = 6;
handles.sequence_channel = [1  2 1  3 1  4 1  5 1  6 1  ];
handles.sequence_period  = [10 5 20 5 20 5 20 5 20 5 10 ];

% initial temperature information
handles.temp_enable = 0; %temperature control enable. 
handles.tempchannel_list = [{'B1'}; {'B2'}];
handles.temp_list = [22 30];
handles.tempchannel_state = [1 0];
handles.temp_seq_enable = 0; %temperature control enable. 
handles.temp_seq_time = [60 65 0 0 0 0 0 0];

%initial log file path and name
% handles.log_file_path = 'E:\maggot images\';
handles.log_file_name = 'Orco-GCaMP6-run101';
handles.log_data=struct;
%run experiments
handles.trigger_singnal_enable = 1;


for i=1:5
    num_conc = get(findobj('Tag', ['concentration', num2str(i)]), 'Value');
    str_conc = handles.library.concentration_total_list{num_conc};
    
    num_odor = get(findobj('Tag', ['odor', num2str(i)]), 'Value');
    str_odor = handles.library.odor_total_list{num_odor};
    
    str_conc_plus_odor = [str_conc, ' ', str_odor];
    
    handles.conc_plus_odor_list{i} = str_conc_plus_odor;
    handles.conc_list{i}=str_conc;
    handles.odor_list{i}=str_odor;
 %   handles.channel_color(i,:) = handles.library.odor_colormap(((num_odor-1)*... %figure out the color of the odor and concentration14
 %       length(handles.library.concentration_total_list) + num_conc),:);
end
    handles.channel_color=gen_cmap_for_odor_seq(handles.odor_list,...
        handles.conc_list);
for i=1:5
    set(findobj('Tag', ['channel', num2str(i)]),'BackgroundColor', handles.channel_color(i,:));
    set(findobj('Tag', ['odor', num2str(i)]), 'BackgroundColor', handles.channel_color(i,:));
    set(findobj('Tag', ['concentration', num2str(i)]), 'BackgroundColor', handles.channel_color(i,:));
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes odorGUI_24 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = odorGUI_24_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in channelNum.
function channelNum_Callback(hObject, eventdata, handles)
% hObject    handle to channelNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'));
handles.channel_number = str2num(contents{get(hObject,'Value')});

if handles.channel_number == 8   
    %update the all_valves information
    handles.odorchannel_list=cell(5,1);
    handles.channel_water = handles.channel_string{get(findobj('Tag', 'channelWater'), 'Value')};
    handles.channel_control_water = handles.channel_string{get(findobj('Tag', 'channelControlWater'), 'Value')};
    handles.channel_control_odor  = handles.channel_string{get(findobj('Tag', 'channelControlOdor'),  'Value')};
    for i=1:5
        handles.odorchannel_list{i} = handles.channel_string{get(findobj('Tag', ['channel', num2str(i)]), 'Value')};
    end
    handles.all_valves = [handles.channel_control_water;...
        handles.channel_control_odor;...
        handles.channel_water;...
        handles.odorchannel_list];
    
    
    handles.conc_plus_odor_list=cell(5,1);  %update the conc_plus_odor_list
    handles.conc_list=cell(5,1);
    handles.odor_list=cell(5,1);
    handles.channel_color = ones(5, 3);     %update the bkg color of the channel
    for i=1:5
        num_conc = get(findobj('Tag', ['concentration', num2str(i)]), 'Value');
        str_conc = handles.library.concentration_total_list{num_conc};

        num_odor = get(findobj('Tag', ['odor', num2str(i)]), 'Value');
        str_odor = handles.library.odor_total_list{num_odor};

        str_conc_plus_odor = [str_conc, ' ', str_odor];
        
        handles.conc_plus_odor_list{i} = str_conc_plus_odor;
        handles.conc_list{i}=str_conc;
        handles.odor_list{i}=str_odor;
       % handles.channel_color(i,:) = handles.library.odor_colormap(((num_odor-1)*... %figure out the color of the odor and concentration14
       %     length(handles.library.concentration_total_list) + num_conc),:);
    end
    handles.channel_color=gen_cmap_for_odor_seq(handles.odor_list,...
        handles.conc_list);
    switch handles.channel_type
        case 1
            set(findobj('Tag', 'textWater'), 'String', '1');
            for i=1:handles.channel_number-3
                set(findobj('Tag', ['textC', num2str(i)]), 'String', 'N');
            end
        case 2
            set(findobj('Tag', 'textWater'), 'String', 'N1');
            for i=1:(handles.channel_number-2)/2-1
                set(findobj('Tag', ['textC', num2str(i)]), 'String', 'N1');
            end
            for i=(handles.channel_number-2)/2:handles.channel_number-3
                set(findobj('Tag', ['textC', num2str(i)]), 'String', 'N2');
            end
    end
    
    %update the panel display
    for i=1:5
        set(findobj('Tag', ['channel', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
        set(findobj('Tag', ['odor', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
        set(findobj('Tag', ['concentration', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
        set(findobj('Tag', ['textC', num2str(i)]), 'Visible', 'on');
    end
    for i=6:21
        set(findobj('Tag', ['channel', num2str(i)]),'Enable', 'on', 'Visible', 'off');
        set(findobj('Tag', ['odor', num2str(i)]),'Enable', 'on', 'Visible', 'off');
        set(findobj('Tag', ['concentration', num2str(i)]),'Enable', 'on', 'Visible', 'off');
        set(findobj('Tag', ['textC', num2str(i)]), 'Visible', 'off');
    end
    
    
elseif handles.channel_number >= 16
    max_odors=21;
    num_odors=handles.channel_number-3;
    handles.channel_list=cell(num_odors,1);
    handles.channel_water = handles.channel_string{get(findobj('Tag', 'channelWater'), 'Value')};
    handles.channel_control_water = handles.channel_string{get(findobj('Tag', 'channelControlWater'), 'Value')};
    handles.channel_control_odor  = handles.channel_string{get(findobj('Tag', 'channelControlOdor'),  'Value')};
    handles.odorchannel_list=cell(num_odors,1);
    for i=1:num_odors
        handles.odorchannel_list{i} = handles.channel_string{get(findobj('Tag', ['channel', num2str(i)]), 'Value')};
    end
    handles.all_valves = [handles.channel_control_water;...
        handles.channel_control_odor;...
        handles.channel_water;...
        handles.odorchannel_list];
    
    handles.conc_plus_odor_list=cell(num_odors,1);
    handles.conc_list=cell(num_odors,1);
    handles.odor_list=cell(num_odors,1);
    handles.channel_color = ones(num_odors, 3);     %update the bkg color of the channel
    for i=1:num_odors
        num_conc = get(findobj('Tag', ['concentration', num2str(i)]), 'Value');
        try
            str_conc = handles.library.concentration_total_list{num_conc};
        catch
            1;
        end
        num_odor = get(findobj('Tag', ['odor', num2str(i)]), 'Value');
        str_odor = handles.library.odor_total_list{num_odor};
        
        str_conc_plus_odor = [str_conc, ' ', str_odor];
        handles.conc_plus_odor_list{i} = str_conc_plus_odor;
        handles.conc_list{i}=str_conc;
        handles.odor_list{i}=str_odor;
        %handles.channel_color(i,:) = handles.library.odor_colormap(((num_odor-1)*... %figure out the color of the odor and concentration14
        %    length(handles.library.concentration_total_list) + num_conc),:);
    end
%     handles.channel_color=gen_cmap_for_odor_seq(handles.odor_list,...
%         handles.conc_list);
    switch handles.channel_type
        case 1
            set(findobj('Tag', 'textWater'), 'String', '1');
            for i=1:handles.channel_number-3
                set(findobj('Tag', ['textC', num2str(i)]), 'String', 'N');
            end
        case 2
            set(findobj('Tag', 'textWater'), 'String', 'N1');
            for i=1:(handles.channel_number-2)/2-1
                set(findobj('Tag', ['textC', num2str(i)]), 'String', 'N1');
            end
            for i=(handles.channel_number-2)/2:handles.channel_number-3
                set(findobj('Tag', ['textC', num2str(i)]), 'String', 'N2');
            end
    end
    
    for i=1:num_odors
        set(findobj('Tag', ['channel', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
        set(findobj('Tag', ['odor', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
        set(findobj('Tag', ['concentration', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
        set(findobj('Tag', ['textC', num2str(i)]), 'Visible', 'on');
    end
    if num_odors < max_odors % make non_present odors invisible
        for i=num_odors+1:max_odors
            set(findobj('Tag', ['channel', num2str(i)]),'Enable', 'off', 'Visible', 'off');
            set(findobj('Tag', ['odor', num2str(i)]),'Enable', 'off', 'Visible', 'off');
            set(findobj('Tag', ['concentration', num2str(i)]),'Enable', 'off', 'Visible', 'off');
            set(findobj('Tag', ['textC', num2str(i)]), 'Visible', 'off');
        end
    end
end

guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns channelNum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channelNum


% --- Executes during object creation, after setting all properties.
function channelNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String', {'8'; '16';'24'});

% --- Executes on selection change in chipType.
function chipType_Callback(hObject, eventdata, handles)
% hObject    handle to chipType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.channel_type = get(hObject,'Value');
switch handles.channel_type
    case 1
        set(findobj('Tag', 'textWater'), 'String', '1');
        for i=1:handles.channel_number-3
            set(findobj('Tag', ['textC', num2str(i)]), 'String', 'N');
        end
    case 2
        set(findobj('Tag', 'textWater'), 'String', 'N1');
        for i=1:(handles.channel_number-2)/2-1
            set(findobj('Tag', ['textC', num2str(i)]), 'String', 'N1');
        end
        for i=(handles.channel_number-2)/2:handles.channel_number-3
            set(findobj('Tag', ['textC', num2str(i)]), 'String', 'N2');
        end
end
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns chipType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chipType


% --- Executes during object creation, after setting all properties.
function chipType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chipType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String', {'1-N'; 'N-N'});

% --- Executes on selection change in channelWater.
function channelWater_Callback(hObject, eventdata, handles)
% hObject    handle to channelWater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'));
handles.channel_water = contents{get(hObject,'Value')};
handles.all_valves = [handles.channel_control_water;...
        handles.channel_control_odor;...
        handles.channel_water;...
        handles.odorchannel_list];
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function channelWater_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelWater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',8);


% --- Executes on selection change in channelControlWater.
function channelControlWater_Callback(hObject, eventdata, handles)
% hObject    handle to channelControlWater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.channel_control_water = contents{get(hObject,'Value')};
handles.all_valves = [handles.channel_control_water;...
        handles.channel_control_odor;...
        handles.channel_water;...
        handles.odorchannel_list];
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function channelControlWater_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelControlWater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',6);


% --- Executes on selection change in channelControlOdor.
function channelControlOdor_Callback(hObject, eventdata, handles)
% hObject    handle to channelControlOdor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
handles.channel_control_odor = contents{get(hObject,'Value')};
handles.all_valves = [handles.channel_control_water;...
        handles.channel_control_odor;...
        handles.channel_water;...
        handles.odorchannel_list];
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function channelControlOdor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelControlOdor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',7);


% --- Executes on selection change in channelN.
function channelN_Callback(hObject, eventdata, handles)
% hObject    handle to channel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
%hObject.Tag='channelN'
N=str2num(hObject.Tag(8:end));
handles.odorchannel_list{N} = contents{get(hObject,'Value')};
handles.all_valves = [handles.channel_control_water;...
        handles.channel_control_odor;...
        handles.channel_water;...
        handles.odorchannel_list];
guidata(hObject, handles);

%general odor change callback
function odor_gen_Callback(hObject, eventdata, handles)
% hObject    handle to odor4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N = str2num(hObject.Tag(5:end));
num_odor = get(findobj('Tag', ['odor', num2str(N)]), 'Value');            
str_odor = handles.library.odor_total_list{ num_odor };         %update the odor information
num_conc = get(findobj('Tag', ['concentration', num2str(N)]), 'Value');
str_conc = handles.library.concentration_total_list{ num_conc };%read the concentration information
str_conc_plus_odor = [str_conc, ' ', str_odor];                 %combine concentration and odor
handles.conc_plus_odor_list{N} = str_conc_plus_odor;            %update the string information
handles.conc_list{N}=str_conc;
handles.odor_list{N}=str_odor;
%odorColorIndex = (num_odor-1)* length(handles.library.concentration_total_list) + num_conc; %calculte the index of color
%handles.channel_color(N,:) = handles.library.odor_colormap(odorColorIndex, :); %update the information of color for each channel
% handles.channel_color=gen_cmap_for_odor_seq(handles.odor_list,...
%         handles.conc_list);
for ii=1:length(handles.conc_list)
        
    set(findobj('Tag', ['channel', num2str(ii)]), 'BackgroundColor', handles.channel_color(ii,:));    %reset the bkg color the buttons
    set(findobj('Tag', ['odor', num2str(ii)]), 'BackgroundColor', handles.channel_color(ii,:));
    set(findobj('Tag', ['concentration', num2str(ii)]), 'BackgroundColor', handles.channel_color(ii,:));
end
%update the handles
guidata(hObject, handles);

% --- Executes on selection change in concentration14 N.
function concentrationN_Callback(hObject, eventdata, handles)
% hObject    handle to concentration1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N = str2double(hObject.Tag(14:end));
num_odor = get(findobj('Tag', ['odor', num2str(N)]), 'Value');            
str_odor = handles.library.odor_total_list{ num_odor };         %update the odor information
num_conc = get(findobj('Tag', ['concentration', num2str(N)]), 'Value');
str_conc = handles.library.concentration_total_list{ num_conc };%read the concentration information
str_conc_plus_odor = [str_conc, ' ', str_odor];                 %combine concentration and odor
handles.conc_plus_odor_list{N} = str_conc_plus_odor;            %update the string information
handles.conc_list{N}=str_conc;
handles.odor_list{N}=str_odor;
%odorColorIndex = (num_odor-1)* length(handles.library.concentration_total_list) + num_conc; %calculte the index of color
%handles.channel_color(N,:) = handles.library.odor_colormap(odorColorIndex, :); %update the information of color for each channel
% handles.channel_color=gen_cmap_for_odor_seq(handles.odor_list,...
%         handles.conc_list);
for ii=1:length(handles.conc_list)
        
    set(findobj('Tag', ['channel', num2str(ii)]), 'BackgroundColor', handles.channel_color(ii,:));    %reset the bkg color the buttons
    set(findobj('Tag', ['odor', num2str(ii)]), 'BackgroundColor', handles.channel_color(ii,:));
    set(findobj('Tag', ['concentration', num2str(ii)]), 'BackgroundColor', handles.channel_color(ii,:));
end
%update the handles
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function channel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',1);



% --- Executes during object creation, after setting all properties.
function odor1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

load([pwd, '\data\', 'odor_inf'], 'odor_list');
handles.library.odor_total_list = odor_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.odor_total_list);
set(hObject,'Value', 1);



% --- Executes during object creation, after setting all properties.
function concentration1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_concentration_list');
handles.library.concentration_total_list = odor_concentration_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.concentration_total_list);
set(hObject,'Value', 1);


% --- Executes during object creation, after setting all properties.
function channel2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',2);


% --- Executes during object creation, after setting all properties.
function odor2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_list');
handles.library.odor_total_list = odor_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.odor_total_list);
set(hObject,'Value', 1);




% --- Executes during object creation, after setting all properties.
function concentration2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_concentration_list');
handles.library.concentration_total_list = odor_concentration_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.concentration_total_list);
set(hObject,'Value', 2);




% --- Executes during object creation, after setting all properties.
function channel3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',3);


% --- Executes during object creation, after setting all properties.
function odor3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_list');
handles.library.odor_total_list = odor_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.odor_total_list);
set(hObject,'Value', 1);


% --- Executes during object creation, after setting all properties.
function concentration3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_concentration_list');
handles.library.concentration_total_list = odor_concentration_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.concentration_total_list);
set(hObject,'Value', 3);





% --- Executes during object creation, after setting all properties.
function channel4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',4);




% --- Executes during object creation, after setting all properties.
function odor4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_list');
handles.library.odor_total_list = odor_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.odor_total_list);
set(hObject,'Value', 1);



% --- Executes during object creation, after setting all properties.
function concentration4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_concentration_list');
handles.library.concentration_total_list = odor_concentration_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.concentration_total_list);
set(hObject,'Value', 4);

% --- Executes during object creation, after setting all properties.
function channel5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',5);

% --- Executes during object creation, after setting all properties.
function odor5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_list');
handles.library.odor_total_list = odor_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.odor_total_list);
set(hObject,'Value', 1);


% --- Executes during object creation, after setting all properties.
function concentration5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_concentration_list');
handles.library.concentration_total_list = odor_concentration_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.concentration_total_list);
set(hObject,'Value', 5);

% --- Executes during object creation, after setting all properties.
function channel6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',9);


% --- Executes during object creation, after setting all properties.
function odor6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_list');
handles.library.odor_total_list = odor_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.odor_total_list);
set(hObject,'Value', 1);


% --- Executes during object creation, after setting all properties.
function concentration6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_concentration_list');
handles.library.concentration_total_list = odor_concentration_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.concentration_total_list);
set(hObject,'Value', 6);


% --- Executes during object creation, after setting all properties.
function channel7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',10);

% --- Executes during object creation, after setting all properties.
function odor7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_list');
handles.library.odor_total_list = odor_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.odor_total_list);
set(hObject,'Value', 2);

% --- Executes during object creation, after setting all properties.
function concentration7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_concentration_list');
handles.library.concentration_total_list = odor_concentration_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.concentration_total_list);
set(hObject,'Value', 1);


% --- Executes during object creation, after setting all properties.
function channel8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',11);

% --- Executes during object creation, after setting all properties.
function odor8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_list');
handles.library.odor_total_list = odor_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.odor_total_list);
set(hObject,'Value', 2);


% --- Executes during object creation, after setting all properties.
function concentration8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_concentration_list');
handles.library.concentration_total_list = odor_concentration_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.concentration_total_list);
set(hObject,'Value', 2);


% --- Executes during object creation, after setting all properties.
function channel9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',12);

% --- Executes during object creation, after setting all properties.
function odor9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_list');
handles.library.odor_total_list = odor_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.odor_total_list);
set(hObject,'Value', 2);

% --- Executes during object creation, after setting all properties.
function concentration9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_concentration_list');
handles.library.concentration_total_list = odor_concentration_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.concentration_total_list);
set(hObject,'Value', 3);


% --- Executes during object creation, after setting all properties.
function channel10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',13);

% --- Executes during object creation, after setting all properties.
function odor10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_list');
handles.library.odor_total_list = odor_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.odor_total_list);
set(hObject,'Value', 2);

% --- Executes during object creation, after setting all properties.
function concentration10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_concentration_list');
handles.library.concentration_total_list = odor_concentration_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.concentration_total_list);
set(hObject,'Value', 4);

% --- Executes during object creation, after setting all properties.
function channel11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',14);

% --- Executes during object creation, after setting all properties.
function odor11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_list');
handles.library.odor_total_list = odor_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.odor_total_list);
set(hObject,'Value', 2);

% --- Executes during object creation, after setting all properties.
function concentration11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_concentration_list');
handles.library.concentration_total_list = odor_concentration_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.concentration_total_list);
set(hObject,'Value', 5);


% --- Executes during object creation, after setting all properties.
function channel12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',15);


% --- Executes during object creation, after setting all properties.
function odor12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

load([pwd, '\data\', 'odor_inf'], 'odor_list');
handles.library.odor_total_list = odor_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.odor_total_list);
set(hObject,'Value', 2);

% --- Executes during object creation, after setting all properties.
function concentration12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_concentration_list');
handles.library.concentration_total_list = odor_concentration_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.concentration_total_list);
set(hObject,'Value', 6);

% --- Executes during object creation, after setting all properties.
function channel13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Value',16);

% --- Executes during object creation, after setting all properties.
function odor13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_list');
handles.library.odor_total_list = odor_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.odor_total_list);
set(hObject,'Value', 3);

% --- Executes during object creation, after setting all properties.
function concentration13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
load([pwd, '\data\', 'odor_inf'], 'odor_concentration_list');
handles.library.concentration_total_list = odor_concentration_list;
guidata(hObject, handles);

set(hObject,'String', handles.library.concentration_total_list);
set(hObject,'Value', 1);


% --- Executes on button press in saveSeting.
function saveSeting_Callback(hObject, eventdata, handles)
% hObject    handle to saveSeting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in lockSetting.
function lockSetting_Callback(hObject, eventdata, handles)
% hObject    handle to lockSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lock_state = get(hObject,'Value');
if lock_state == true
    for i=1:13
        set(findobj('Tag', ['channel', num2str(i)]),'Enable', 'inactive');
        set(findobj('Tag', ['odor', num2str(i)]),'Enable', 'inactive');
        set(findobj('Tag', ['concentration', num2str(i)]),'Enable', 'inactive');
    end
    set(findobj('Tag', 'channelNum'), 'Enable', 'inactive');
    set(findobj('Tag', 'channelWater'), 'Enable', 'inactive');
    set(findobj('Tag', 'channelControlWater'), 'Enable', 'inactive');
    set(findobj('Tag', 'channelControlOdor'), 'Enable', 'inactive');  
    set(findobj('Tag', 'chipType'), 'Enable', 'inactive');
else
    for i=1:13
        set(findobj('Tag', ['channel', num2str(i)]),'Enable', 'on');
        set(findobj('Tag', ['odor', num2str(i)]),'Enable', 'on');
        set(findobj('Tag', ['concentration', num2str(i)]),'Enable', 'on');
    end
    set(findobj('Tag', 'channelNum'), 'Enable', 'on');
    set(findobj('Tag', 'channelWater'), 'Enable', 'on');
    set(findobj('Tag', 'channelControlWater'), 'Enable', 'on');
    set(findobj('Tag', 'channelControlOdor'), 'Enable', 'on');  
    set(findobj('Tag', 'chipType'), 'Enable', 'on');
end
% Hint: get(hObject,'Value') returns toggle state of lockSetting

%% Sequence Setting Callback Functions

% --- Executes on selection change in seqPeriodNum.
function seqPeriodNum_Callback(hObject, eventdata, handles)
% hObject    handle to seqPeriodNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%read out the number of periods
max_periods=24;
contents = cellstr(get(hObject,'String'));
handles.sequence_number = str2num(contents{get(hObject,'Value')});

%read out the information of the type of the chip. which will define
%the available channels for 'A' and 'B'.
switch handles.channel_type
    case 1
        % case 1, means the chip is '1-N' type, it can only switch from
        % water channel to other odor channel. So the left side will be
        % fixed as water channel.
        channel_str_A = handles.all_valves(3);
        channel_str_B = handles.all_valves(4:end);
    case 2
        %case 2, means the chip is 'N1-N2' type, it can switch any
        %channnel belongs to 'N1' group to any belongs to 'N2' group.
        channel_str_A = handles.all_valves(3:3+(handles.channel_number-2)/2-1);
        channel_str_B = handles.all_valves(3+(handles.channel_number-2)/2:end);
end

%define the variables for the sequnce of channel and sequence of pepirod.
%Because for each period there are two channel involved, so times 2.
handles.sequence_channel = ones(1, 2*handles.sequence_number + 1);
handles.sequence_period  = ones(1, 2*handles.sequence_number + 1);

for i=1:handles.sequence_number
    %read out the current information for each channel and period.
    %the left pair of channel and periods are defined as 'A', right pair as
    %'B'.
    contents = cellstr(get(findobj('Tag', ['seqChannel', num2str(i), 'A']),'String')) ; % the strings of the pop-up menu
    channel_A = contents{get(findobj('Tag', ['seqChannel', num2str(i), 'A']),'Value')}; % current value, and current string
    temp = strcmp(channel_str_A, channel_A);    %check if the current channel available
    if sum(temp) == 0   %if not, reset it.
        channel_A = channel_str_A(1);
        channel_A_value = 1;
    else
        channel_A_value = find(temp == 1);
    end
     
    index_temp = strcmp(handles.all_valves(3:end), channel_A);
    channel_A_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
    handles.sequence_channel(2*(i-1) + 1) = channel_A_index;
    
    
    contents = cellstr(get(findobj('Tag', ['seqChannel', num2str(i), 'B']),'String')) ; %same as 'A'
    channel_B = contents{get(findobj('Tag', ['seqChannel', num2str(i), 'B']),'Value')};
    temp = strcmp(channel_str_B, channel_B);    %check if the current channel available
    if sum(temp) == 0   %if not, reset it.
        channel_B = channel_str_B(1);
        channel_B_value = 1;
    else
        channel_B_value = find(temp == 1);
    end
    index_temp = strcmp(handles.all_valves(3:end), channel_B);
    channel_B_index = find(index_temp == 1);
    handles.sequence_channel(2*i) = channel_B_index;

    %read out the time perios of each sub-sequence
    time_A = str2num(get(findobj('Tag', ['seqTime', num2str(i), 'A']) , 'String'));
    handles.sequence_period(2*(i-1) + 1) = time_A;
    try
    time_B = str2num(get(findobj('Tag', ['seqTime', num2str(i), 'B']) , 'String'));
    catch
        1;
    end
    handles.sequence_period(2*(i-1) + 2) = time_B;
    
    if channel_A_index == 1
        set(findobj('Tag', ['seqChannel', num2str(i), 'A']),'Enable', 'on', 'Visible', 'on',...
            'String', channel_str_A, 'Value', channel_A_value, 'BackgroundColor', [1 1 1]);
        set(findobj('Tag', ['seqTime',    num2str(i), 'A']),'Enable', 'on', 'Visible', 'on',...
            'BackgroundColor', [1 1 1]);
    else
        set(findobj('Tag', ['seqChannel', num2str(i), 'A']),'Enable', 'on', 'Visible', 'on', ...
            'String', channel_str_A, 'Value', channel_A_value, ...
            'BackgroundColor', handles.channel_color(channel_A_index - 1,:));
        set(findobj('Tag', ['seqTime',    num2str(i), 'A']),'Enable', 'on', 'Visible', 'on',...
            'BackgroundColor', handles.channel_color(channel_A_index - 1,:));
    end

    if channel_B_index == 1
        set(findobj('Tag', ['seqChannel', num2str(i), 'B']),'Enable', 'on', 'Visible', 'on',...
            'String', channel_str_B, 'Value', channel_B_value, 'BackgroundColor', [1 1 1]);
        set(findobj('Tag', ['seqTime',    num2str(i), 'B']),'Enable', 'on', 'Visible', 'on',...
            'BackgroundColor', [1 1 1]);
    else
        set(findobj('Tag', ['seqChannel', num2str(i), 'B']),'Enable', 'on', 'Visible', 'on', ...
            'String', channel_str_B, 'Value', channel_B_value, ...
            'BackgroundColor', handles.channel_color(channel_B_index - 1,:));
        set(findobj('Tag', ['seqTime',    num2str(i), 'B']),'Enable', 'on', 'Visible', 'on',...
            'BackgroundColor', handles.channel_color(channel_B_index - 1,:));
    end
    
    %set the index visable
    set(findobj('Tag', ['seqID',    num2str(i)]), 'Visible', 'on');
end

%deal with the unused slots.
for i=handles.sequence_number+1:max_periods
    set(findobj('Tag', ['seqChannel', num2str(i), 'A']),'Enable', 'off', 'Visible', 'off');
    set(findobj('Tag', ['seqChannel', num2str(i), 'B']),'Enable', 'off', 'Visible', 'off');
    set(findobj('Tag', ['seqTime',    num2str(i), 'A']),'Enable', 'off', 'Visible', 'off');
    set(findobj('Tag', ['seqTime',    num2str(i), 'B']),'Enable', 'off', 'Visible', 'off');
    set(findobj('Tag', ['seqID',    num2str(i)]), 'Visible', 'off'); %set the index invisable
end

%deal with the last slots for ending the sequence.
contents = cellstr(get(findobj('Tag', 'seqChannelEnd'),'String')) ; % the strings of the pop-up menu
channel_end = contents{get(findobj('Tag', 'seqChannelEnd'),'Value')}; % current value, and current string
temp = strcmp(channel_str_A, channel_end);    %check if the current channel available
if sum(temp) == 0   %if not, reset it.
    channel_end = channel_str_A(1);
    channel_end_value = 1;
else
    channel_end_value = find(temp == 1);
end
     
index_temp = strcmp(handles.all_valves(3:end), channel_end);
channel_end_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*handles.sequence_number + 1) = channel_end_index;

time_end = str2num(get(findobj('Tag', 'seqTimeEnd') , 'String'));
handles.sequence_period(2*handles.sequence_number + 1) = time_end;

if channel_end_index == 1
    set(findobj('Tag','seqChannelEnd'), 'String', channel_str_A, ...
        'Value', channel_end_value, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime',    num2str(i), 'A']), 'BackgroundColor', [1 1 1]);
else
    set(findobj('Tag', 'seqChannelEnd'), 'String', channel_str_A, ...
        'Value', channel_end_value, 'BackgroundColor', ...
        handles.channel_color(channel_end_index - 1,:));
    set(findobj('Tag', 'seqChannelEnd'), 'BackgroundColor',...
        handles.channel_color(channel_end_index - 1,:));
end

guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns seqPeriodNum contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqPeriodNum


% --- Executes during object creation, after setting all properties.
function seqPeriodNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqPeriodNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function seqTime1A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime1A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime1A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime1A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime1B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime1B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime1B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime1B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function seqTime2A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime2A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime2A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime2A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime2B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime2B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime2B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime2B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime3A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime3A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime3A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime3A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime3B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime3B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime3B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime3B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime4A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime4A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime4B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime4B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime4B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime4B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime5A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime5A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime5A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime5A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime5B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime5B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime5B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime5B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime6A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime6A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime6A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime6A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime6B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime6B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime6B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime6B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime7A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime7A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles

% --- Executes during object creation, after setting all properties.
function seqTime7A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime7A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime7B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime7B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime7B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime7B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime8A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime8A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime8A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime8A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime8B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime8B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles

% --- Executes during object creation, after setting all properties.
function seqTime8B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime8B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime9A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime9A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime9A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime9A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime9B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime9B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime9B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime9B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime10A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime10A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime10A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime10A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime10B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime10B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime10B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime10B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime11A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime11A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime11A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime11A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime11B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime11B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime11B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime11B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime12A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime12A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime12A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime12A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime12B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime12B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime12B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime12B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime13A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime13A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)tag_string = get(hObject, 'Tag'); %reand out the tag.
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime13A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime13A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime13B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime13B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime13B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime13B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime14A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime14A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime14A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime14A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime14B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime14B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime14B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime14B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime15A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime15A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime15A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime15A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime15B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime15B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime15B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime15B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime16A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime16A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime16A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime16A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime16B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime16B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);

time = str2num(get(hObject, 'String')); %read out the string of time.

switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

handles.sequence_period(2*(str2num(N1)-1) + N) = time;
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTime16B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime16B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel1A.
function seqChannel1A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel1A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles



% --- Executes during object creation, after setting all properties.
function seqChannel1A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel1A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel2A.
function seqChannel2A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel2A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel2A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel2A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel3A.
function seqChannel3A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel3A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel3A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel3A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel4A.
function seqChannel4A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel4A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel4A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel5A.
function seqChannel5A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel5A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel5A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel5A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel6A.
function seqChannel6A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel6A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel6A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel6A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel7A.
function seqChannel7A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel7A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel7A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel7A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel8A.
function seqChannel8A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel8A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel8A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel8A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel9A.
function seqChannel9A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel9A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel9A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel9A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel10A.
function seqChannel10A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel10A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel10A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel10A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel11A.
function seqChannel11A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel11A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles



% --- Executes during object creation, after setting all properties.
function seqChannel11A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel11A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel12A.
function seqChannel12A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel12A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles



% --- Executes during object creation, after setting all properties.
function seqChannel12A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel12A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel13A.
function seqChannel13A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel13A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles



% --- Executes during object creation, after setting all properties.
function seqChannel13A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel13A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel14A.
function seqChannel14A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel14A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles



% --- Executes during object creation, after setting all properties.
function seqChannel14A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel14A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel15A.
function seqChannel15A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel15A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel15A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel15A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in seqChannel16A.
function seqChannel16A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel16A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles



% --- Executes during object creation, after setting all properties.
function seqChannel16A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel16A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in seqChannel1B.
function seqChannel1B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel1B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel1B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel1B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel2B.
function seqChannel2B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel2B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel2B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel2B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel3B.
function seqChannel3B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel3B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel3B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel3B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel4B.
function seqChannel4B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel4B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel4B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel4B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel5B.
function seqChannel5B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel5B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel5B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel5B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel6B.
function seqChannel6B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel6B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel6B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel6B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel7B.
function seqChannel7B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel7B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel7B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel7B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel8B.
function seqChannel8B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel8B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel8B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel8B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel9B.
function seqChannel9B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel9B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel9B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel9B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel10B.
function seqChannel10B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel10B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel10B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel10B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel11B.
function seqChannel11B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel11B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel11B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel11B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel12B.
function seqChannel12B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel12B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel12B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel12B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel13B.
function seqChannel13B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel13B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel13B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel13B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel14B.
function seqChannel14B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel14B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel14B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel14B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel15B.
function seqChannel15B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel15B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel15B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel15B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel16B.
function seqChannel16B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel16B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tag_string = get(hObject, 'Tag'); %reand out the tag.
N1 = tag_string(end-2:end-1); %got the number of slot.
N2 = tag_string(end);
switch N2
    case 'A'
        N = 1;
    case 'B'
        N = 2;
end

contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*(str2num(N1)-1) + N) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', ['seqTime', N1, N2]), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannel16B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel16B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function seqTimeEnd_Callback(hObject, eventdata, handles)
% hObject    handle to seqTimeEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.sequence_period(2*handles.sequence_number + 1) = str2num(get(hObject, 'String')); %read out the string of time.
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqTimeEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTimeEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannelEnd.
function seqChannelEnd_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannelEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String')) ; % the strings of the pop-up menu
channel = contents{get(hObject,'Value')}; % current value, and current string

index_temp = strcmp(handles.all_valves(3:end), channel);
channel_index = find(index_temp == 1);    %find the index of this channel in the all_valves string.
handles.sequence_channel(2*handles.sequence_number + 1) = channel_index;

if channel_index == 1 %reset the background color the slot
    set(hObject, 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', 'seqTimeEnd'), 'BackgroundColor', [1 1 1]);
else
    set(hObject, 'BackgroundColor', handles.channel_color(channel_index - 1,:));
    set(findobj('Tag', 'seqTimeEnd'), 'BackgroundColor', ...
        handles.channel_color(channel_index - 1,:));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function seqChannelEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannelEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lockSetting2.
function lockSetting2_Callback(hObject, eventdata, handles)
% hObject    handle to lockSetting2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lock_state = get(hObject,'Value');
if lock_state == true
    for i=1:16
        set(findobj('Tag', ['seqChannel', num2str(i),'A']),'Enable', 'inactive');
        set(findobj('Tag', ['seqChannel', num2str(i),'B']),'Enable', 'inactive');
        set(findobj('Tag', ['seqTime', num2str(i),'A']),'Enable', 'inactive');
        set(findobj('Tag', ['seqTime', num2str(i),'B']),'Enable', 'inactive');        
    end
    set(findobj('Tag', 'seqChannelEnd'), 'Enable', 'inactive');
    set(findobj('Tag', 'seqTimeEnd'), 'Enable', 'inactive');
    set(findobj('Tag', 'seqPeriodNum'), 'Enable', 'inactive');
else
    for i=1:16
        set(findobj('Tag', ['seqChannel', num2str(i),'A']),'Enable', 'on');
        set(findobj('Tag', ['seqChannel', num2str(i),'B']),'Enable', 'on');
        set(findobj('Tag', ['seqTime', num2str(i),'A']),'Enable', 'on');
        set(findobj('Tag', ['seqTime', num2str(i),'B']),'Enable', 'on');        
    end
    set(findobj('Tag', 'seqChannelEnd'), 'Enable', 'on');
    set(findobj('Tag', 'seqTimeEnd'), 'Enable', 'on');
    set(findobj('Tag', 'seqPeriodNum'), 'Enable', 'on');
end

% --- Executes on button press in saveSetting.
function saveSetting_Callback(hObject, eventdata, handles)
% hObject    handle to saveSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
channel_number = handles.channel_number;
channel_type = handles.channel_type;
all_valves =  handles.all_valves;
channel_color = handles.channel_color;
conc_plus_odor_list = handles.conc_plus_odor_list;
temp_enable = handles.temp_enable;
temp_list = handles.temp_list;
temp_seq_enable = handles.temp_seq_enable;
temp_seq_time = handles.temp_seq_time;
sequence_number = handles.sequence_number;
sequence_channel = handles.sequence_channel;
sequence_period  = handles.sequence_period;

    
uisave({'channel_number', ...
    'channel_type', ...
    'all_valves', ...
    'channel_color', ...
    'conc_plus_odor_list', ...
    'temp_enable', ...
    'temp_list', ...
    'temp_seq_enable', ...
    'temp_seq_time', ...
    'sequence_number', ...
    'sequence_channel', ...
    'sequence_period'}, ...
    [pwd, '\data\settings.mat']);

% --- Executes on button press in loadSetting.
function loadSetting_Callback(hObject, eventdata, handles)
% hObject    handle to loadSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% read out the data.
uiopen([pwd, '\data\*.mat']);

handles.channel_number = channel_number;
handles.channel_type = channel_type;
handles.all_valves = all_valves;
handles.channel_color = channel_color;
handles.conc_plus_odor_list = conc_plus_odor_list;
handles.temp_enable = temp_enable;
handles.temp_list = temp_list;
handles.temp_seq_enable = temp_seq_enable;
handles.temp_seq_time = temp_seq_time;
handles.sequence_number = sequence_number;
handles.sequence_channel = sequence_channel;
handles.sequence_period = sequence_period;
handles.conc_list = cellfun(@(x)x(1:strfind(x,' ')-1),conc_plus_odor_list,'UniformOutput',false);
handles.odor_list = cellfun(@(x)x(strfind(x,' ')+1:end), conc_plus_odor_list,'UniformOutput',false);
%unlock the lockSetting button
set(findobj('Tag', 'lockSetting'), 'Value', 0);
for i=1:21
    set(findobj('Tag', ['channel', num2str(i)]),'Enable', 'on');
    set(findobj('Tag', ['odor', num2str(i)]),'Enable', 'on');
    set(findobj('Tag', ['concentration', num2str(i)]),'Enable', 'on');
end
set(findobj('Tag', 'channelNum'), 'Enable', 'on');
set(findobj('Tag', 'channelWater'), 'Enable', 'on');
set(findobj('Tag', 'channelControlWater'), 'Enable', 'on');
set(findobj('Tag', 'channelControlOdor'), 'Enable', 'on');  
set(findobj('Tag', 'chipType'), 'Enable', 'on');
    
%unlock the locksetting2 button
set(findobj('Tag', 'lockSetting2'),'Value', 0);
for i=1:24
    set(findobj('Tag', ['seqChannel', num2str(i),'A']),'Enable', 'on');
    set(findobj('Tag', ['seqChannel', num2str(i),'B']),'Enable', 'on');
    set(findobj('Tag', ['seqTime', num2str(i),'A']),'Enable', 'on');
    set(findobj('Tag', ['seqTime', num2str(i),'B']),'Enable', 'on');        
end
set(findobj('Tag', 'seqChannelEnd'), 'Enable', 'on');
set(findobj('Tag', 'seqTimeEnd'), 'Enable', 'on');
set(findobj('Tag', 'seqPeriodNum'), 'Enable', 'on');

%update the channelType information
set(findobj('Tag', 'chipType'),  'Value', handles.channel_type);
switch handles.channel_type
    case 1
        set(findobj('Tag', 'textWater'), 'String', '1');
        for i=1:handles.channel_number-3
            set(findobj('Tag', ['textC', num2str(i)]), 'String', 'N');
        end
    case 2
        set(findobj('Tag', 'textWater'), 'String', 'N1');
        for i=1:(handles.channel_number-2)/2-1
            set(findobj('Tag', ['textC', num2str(i)]), 'String', 'N1');
        end
        for i=(handles.channel_number-2)/2:handles.channel_number-3
            set(findobj('Tag', ['textC', num2str(i)]), 'String', 'N2');
        end
end

%rewrite the control water, control odor, and water channel
cmp = strcmp(handles.all_valves{1}, handles.channel_string);
set(findobj('Tag', 'channelControlWater'), 'Value', find(cmp));

cmp = strcmp(handles.all_valves{2}, handles.channel_string);
set(findobj('Tag', 'channelControlOdor'), 'Value', find(cmp));

cmp = strcmp(handles.all_valves{3}, handles.channel_string);
set(findobj('Tag', 'channelWater'), 'Value', find(cmp));


switch handles.channel_number
    case 8
        %rewrite the channelNum information
        set(findobj('Tag', 'channelNum'),  'Value', 1);
        
        %rewrite the channel, odor and concentration14 information, and their
        %bkg color
        for i=1:5
            %rewrite the channel information
            cmp1 = strcmp(handles.all_valves{3+i}, handles.channel_string);  
            set(findobj('Tag', ['channel', num2str(i)]), 'Value', find(cmp1), 'BackgroundColor', handles.channel_color(i,:));
            %rewrite the concentration14 information
            str_conc = handles.conc_plus_odor_list{i}(1 : strfind(handles.conc_plus_odor_list{i}, ' ') - 1);
            cmp2 = strcmp(str_conc, handles.library.concentration_total_list);  
            set(findobj('Tag', ['concentration', num2str(i)]), 'Value', find(cmp2), 'BackgroundColor', handles.channel_color(i,:));
            %rewrite the odor information
            str_odor = handles.conc_plus_odor_list{i}(strfind(handles.conc_plus_odor_list{i}, ' ')+1 : end);
            cmp3 = strcmp(str_odor, handles.library.odor_total_list );  
            set(findobj('Tag', ['odor', num2str(i)]), 'Value', find(cmp3), 'BackgroundColor', handles.channel_color(i,:));
        end
    
        %update the panel display
        for i=1:5   %available panels 
            set(findobj('Tag', ['channel', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
            set(findobj('Tag', ['odor', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
            set(findobj('Tag', ['concentration', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
            set(findobj('Tag', ['textC', num2str(i)]), 'Visible', 'on');
        end
        for i=6:21  %unavailable panels
            set(findobj('Tag', ['channel', num2str(i)]),'Enable', 'on', 'Visible', 'off');
            set(findobj('Tag', ['odor', num2str(i)]),'Enable', 'on', 'Visible', 'off');
            set(findobj('Tag', ['concentration', num2str(i)]),'Enable', 'on', 'Visible', 'off');
            set(findobj('Tag', ['textC', num2str(i)]), 'Visible', 'off');
        end
    
    case 16
        %rewrite the channelNum information
        set(findobj('Tag', 'channelNum'),  'Value', 2);

        %rewrite the channel, odor and concentration14 information, and their
        %bkg color
        for i=1:13
            %rewrite the channel information
            cmp1 = strcmp(handles.all_valves{3+i}, handles.channel_string);  
            set(findobj('Tag', ['channel', num2str(i)]), 'Value', find(cmp1), 'BackgroundColor', handles.channel_color(i,:));
            %rewrite the concentration14 information
            str_conc = handles.conc_plus_odor_list{i}(1 : strfind(handles.conc_plus_odor_list{i}, ' ') - 1);
            cmp2 = strcmp(str_conc, handles.library.concentration_total_list);  
            set(findobj('Tag', ['concentration', num2str(i)]), 'Value', find(cmp2), 'BackgroundColor', handles.channel_color(i,:));
            %rewrite the odor information
            str_odor = handles.conc_plus_odor_list{i}(strfind(handles.conc_plus_odor_list{i}, ' ')+1 : end);
            cmp3 = strcmp(str_odor, handles.library.odor_total_list );  
            set(findobj('Tag', ['odor', num2str(i)]), 'Value', find(cmp3), 'BackgroundColor', handles.channel_color(i,:));
        end
    
        %update the panel display
        for i=1:13
            set(findobj('Tag', ['channel', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
            set(findobj('Tag', ['odor', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
            set(findobj('Tag', ['concentration', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
            set(findobj('Tag', ['textC', num2str(i)]), 'Visible', 'on');
        end
    case 24
        %rewrite the channelNum information
        set(findobj('Tag', 'channelNum'),  'Value', 3);

        %rewrite the channel, odor and concentration14 information, and their
        %bkg color
        for i=1:21
            %rewrite the channel information
            cmp1 = strcmp(handles.all_valves{3+i}, handles.channel_string);  
            set(findobj('Tag', ['channel', num2str(i)]), 'Value', find(cmp1), 'BackgroundColor', handles.channel_color(i,:));
            %rewrite the concentration14 information
            str_conc = handles.conc_plus_odor_list{i}(1 : strfind(handles.conc_plus_odor_list{i}, ' ') - 1);
            cmp2 = strcmp(str_conc, handles.library.concentration_total_list);  
            set(findobj('Tag', ['concentration', num2str(i)]), 'Value', find(cmp2), 'BackgroundColor', handles.channel_color(i,:));
            %rewrite the odor information
            str_odor = handles.conc_plus_odor_list{i}(strfind(handles.conc_plus_odor_list{i}, ' ')+1 : end);
            cmp3 = strcmp(str_odor, handles.library.odor_total_list );  
            set(findobj('Tag', ['odor', num2str(i)]), 'Value', find(cmp3), 'BackgroundColor', handles.channel_color(i,:));
        end
    
        %update the panel display
        for i=1:21
            set(findobj('Tag', ['channel', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
            set(findobj('Tag', ['odor', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
            set(findobj('Tag', ['concentration', num2str(i)]),'Enable', 'on', 'Visible', 'on', 'BackgroundColor', handles.channel_color(i,:));
            set(findobj('Tag', ['textC', num2str(i)]), 'Visible', 'on');
        end
    
end

%% rewrite the sequence number information

set(findobj('Tag', 'seqPeriodNum'),  'Value', handles.sequence_number);

%read out the information of the type of the chip. which will define
%the available channels for 'A' and 'B'.
switch handles.channel_type
    case 1
        % case 1, means the chip is '1-N' type, it can only switch from
        % water channel to other odor channel. So the left side will be
        % fixed as water channel.
        channel_str_A = handles.all_valves(3);
        channel_str_B = handles.all_valves(4:end);
    case 2
        %case 2, means the chip is 'N1-N2' type, it can switch any
        %channnel belongs to 'N1' group to any belongs to 'N2' group.
        channel_str_A = handles.all_valves(3:3+(handles.channel_number-2)/2-1);
        channel_str_B = handles.all_valves(3+(handles.channel_number-2)/2:end);
end

%rewrite all odor sequences
for i=1:handles.sequence_number
    %rewrite the string, enable and visible for panel A. Reset the bkg
    %color
    set(findobj('Tag', ['seqChannel', num2str(i), 'A']), 'String', channel_str_A, ...
        'Enable', 'on', 'Visible', 'on', 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', num2str(i), 'A']), 'String', num2str(handles.sequence_period(2*i-1)), ...
        'Enable', 'on', 'Visible', 'on', 'BackgroundColor', [1 1 1]);
    %figure out the value and bkg color
    channel_str = handles.all_valves{handles.sequence_channel(2*i-1) + 2};
    cmpA1 = strcmp(channel_str, channel_str_A);
    set(findobj('Tag', ['seqChannel', num2str(i), 'A']), 'Value', find(cmpA1));
    cmpA2 = strcmp(channel_str, handles.all_valves(4:end));
    numA = find(cmpA2);
    if ~isempty(numA)
        set(findobj('Tag', ['seqChannel', num2str(i), 'A']), 'BackgroundColor', handles.channel_color(numA,:));
        set(findobj('Tag', ['seqTime', num2str(i), 'A']), 'BackgroundColor', handles.channel_color(numA,:));
    end
    
    %Do the same things for panel B
    set(findobj('Tag', ['seqChannel', num2str(i), 'B']), 'String', channel_str_B, ...
        'Enable', 'on', 'Visible', 'on', 'BackgroundColor', [1 1 1]);
    set(findobj('Tag', ['seqTime', num2str(i), 'B']), 'String', num2str(handles.sequence_period(2*i)), ...
        'Enable', 'on', 'Visible', 'on', 'BackgroundColor', [1 1 1]);
    channel_str = handles.all_valves{handles.sequence_channel(2*i) + 2};
    cmpB1 = strcmp(channel_str, channel_str_B);
    set(findobj('Tag', ['seqChannel', num2str(i), 'B']), 'Value', find(cmpB1));
    cmpB2 = strcmp(channel_str, handles.all_valves(4:end));
    numB = find(cmpB2);
    if ~isempty(numB)
        set(findobj('Tag', ['seqChannel', num2str(i), 'B']), 'BackgroundColor', handles.channel_color(numB,:));
        set(findobj('Tag', ['seqTime', num2str(i), 'B']), 'BackgroundColor', handles.channel_color(numB,:));
    end
    
    %set the index visible
    set(findobj('Tag', ['seqID', num2str(i)]), 'Visible', 'on');
end

%deal with the unused slots.
for i=handles.sequence_number+1:16
    set(findobj('Tag', ['seqChannel', num2str(i), 'A']),'Enable', 'off', 'Visible', 'off');
    set(findobj('Tag', ['seqChannel', num2str(i), 'B']),'Enable', 'off', 'Visible', 'off');
    set(findobj('Tag', ['seqTime',    num2str(i), 'A']),'Enable', 'off', 'Visible', 'off');
    set(findobj('Tag', ['seqTime',    num2str(i), 'B']),'Enable', 'off', 'Visible', 'off');
    set(findobj('Tag', ['seqID',    num2str(i)]), 'Visible', 'off'); %set the index invisable
end

%deal with the end sequence
set(findobj('Tag', 'seqChannelEnd'), 'String', channel_str_A, ...
    'Enable', 'on', 'Visible', 'on', 'BackgroundColor', [1 1 1]);
set(findobj('Tag', 'seqTimeEnd'), 'String', num2str(handles.sequence_period(end)), ...
    'Enable', 'on', 'Visible', 'on', 'BackgroundColor', [1 1 1]);
channel_str = handles.all_valves{handles.sequence_channel(end) + 2};
cmpEnd1 = strcmp(channel_str, channel_str_A);
set(findobj('Tag', 'seqChannelEnd'), 'Value', find(cmpEnd1));
cmpEnd2 = strcmp(channel_str, handles.all_valves(4:end));
numEnd = find(cmpEnd2);
if ~isempty(numEnd)
    set(findobj('Tag', 'seqChannelEnd'), 'BackgroundColor', handles.channel_color(numEnd,:));
    set(findobj('Tag', 'seqTimeEnd'), 'BackgroundColor', handles.channel_color(numEnd,:));
end

%% rewrite the temperature setting
% rewrite the temperature enable button.
set(findobj('Tag', 'tempEnable'), 'Value', handles.temp_enable);
switch handles.temp_enable
    case 1
        set(findobj('Tag', 'tempChannelB1'), 'Enable', 'on'); 
        set(findobj('Tag', 'temp1'), 'Enable', 'on', 'String', num2str(temp_list(1)));
        set(findobj('Tag', 'tempChannelB2'), 'Enable', 'on'); 
        set(findobj('Tag', 'temp2'), 'Enable', 'on', 'String', num2str(temp_list(2)));
        set(findobj('Tag', 'tempSeqEnable'), 'Enable', 'on', 'Value', handles.temp_seq_enable);
        if handles.temp_seq_enable
            for i=1:8
                set(findobj('Tag', ['tempSeqTime', num2str(i)]), 'Enable', 'on', ...
                    'String', num2str(handles.temp_seq_time(i))); 
            end
        else
            for i=1:8
                set(findobj('Tag', ['tempSeqTime', num2str(i)]), 'Enable', 'off'); 
            end
        end
    case 0
        set(findobj('Tag', 'tempChannelB1'), 'Enable', 'off'); 
        set(findobj('Tag', 'temp1'), 'Enable', 'off');
        set(findobj('Tag', 'tempChannelB2'), 'Enable', 'off'); 
        set(findobj('Tag', 'temp2'), 'Enable', 'inactive');
        set(findobj('Tag', 'tempSeqEnable'), 'Enable', 'off');
        for i=1:8
            set(findobj('Tag', ['tempSeqTime', num2str(i)]), 'Enable', 'off'); 
        end
end


%%
guidata(hObject, handles);  %update handles



% --- Executes on button press in tempEnable.
function tempEnable_Callback(hObject, eventdata, handles)
% hObject    handle to tempEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.temp_enable = get(hObject,'Value');

%check whether the odor channel number is set correctly.
if handles.temp_enable
    if handles.channel_number ~= 8
        errordlg('When checking this box, Number of Channles must set at 8');
        set(hObject, 'Value', 0);
    end
end

%set the buttons
switch handles.temp_enable
    case 1
        set(findobj('Tag', 'tempChannelB1'), 'Enable', 'on'); 
        set(findobj('Tag', 'temp1'), 'Enable', 'on');
        set(findobj('Tag', 'tempChannelB2'), 'Enable', 'on'); 
        set(findobj('Tag', 'temp2'), 'Enable', 'on');
        set(findobj('Tag', 'tempSeqEnable'), 'Enable', 'on');
    case 0
        set(findobj('Tag', 'tempChannelB1'), 'Enable', 'off'); 
        set(findobj('Tag', 'temp1'), 'Enable', 'off');
        set(findobj('Tag', 'tempChannelB2'), 'Enable', 'off'); 
        set(findobj('Tag', 'temp2'), 'Enable', 'inactive');
        set(findobj('Tag', 'tempSeqEnable'), 'Enable', 'off');
        for i=1:8
            set(findobj('Tag', ['tempSeqTime', num2str(i)]), 'Enable', 'off'); 
        end
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function tempEnable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function temp1_Callback(hObject, eventdata, handles)
% hObject    handle to temp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(str2double(get(hObject,'String')))
    errordlg('Input must be number.');
else
    handles.temp_list(1) = str2double(get(hObject,'String'));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function temp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function temp2_Callback(hObject, eventdata, handles)
% hObject    handle to temp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(str2double(get(hObject,'String')))
    errordlg('Input must be number.');
else
    handles.temp_list(2) = str2double(get(hObject,'String'));
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function temp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tempChannelB1.
function tempChannelB1_Callback(hObject, eventdata, handles)
% hObject    handle to tempChannelB1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = get(hObject,'Value');
handles.tempchannel_state(1) = value;
smset('B1', value);
% disp(['smset(B1, ', num2str(value), ')']);
guidata(hObject, handles);  %update handles

% --- Executes on button press in tempChannelB2.
function tempChannelB2_Callback(hObject, eventdata, handles)
% hObject    handle to tempChannelB2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = get(hObject,'Value');
handles.tempchannel_state(2) = value;
smset('B2', value);
% disp(['smset(B2, ', num2str(value), ')']);
guidata(hObject, handles);  %update handles


% --- Executes on button press in tempSeqEnable.
function tempSeqEnable_Callback(hObject, eventdata, handles)
% hObject    handle to tempSeqEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.temp_seq_enable = get(hObject,'Value');
%set the buttons
switch handles.temp_seq_enable
    case 1
        for i=1:8
            set(findobj('Tag', ['tempSeqTime', num2str(i)]), 'Enable', 'on'); 
        end
    case 0
        for i=1:8
            set(findobj('Tag', ['tempSeqTime', num2str(i)]), 'Enable', 'off'); 
        end
end

guidata(hObject, handles);  %update handles



function tempSeqTime1_Callback(hObject, eventdata, handles)
% hObject    handle to tempSeqTime1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(str2double(get(hObject,'String')))
    errordlg('Input must be number.');
else
    handles.temp_seq_time(1) = str2double(get(hObject,'String'));
end
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function tempSeqTime1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempSeqTime1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tempSeqTime2_Callback(hObject, eventdata, handles)
% hObject    handle to tempSeqTime2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(str2double(get(hObject,'String')))
    errordlg('Input must be number.');
else
    handles.temp_seq_time(2) = str2double(get(hObject,'String'));
end
guidata(hObject, handles);  %update handles



% --- Executes during object creation, after setting all properties.
function tempSeqTime2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempSeqTime2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tempSeqTime3_Callback(hObject, eventdata, handles)
% hObject    handle to tempSeqTime3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(str2double(get(hObject,'String')))
    errordlg('Input must be number.');
else
    handles.temp_seq_time(3) = str2double(get(hObject,'String'));
end
guidata(hObject, handles);  %update handles



% --- Executes during object creation, after setting all properties.
function tempSeqTime3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempSeqTime3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tempSeqTime4_Callback(hObject, eventdata, handles)
% hObject    handle to tempSeqTime4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(str2double(get(hObject,'String')))
    errordlg('Input must be number.');
else
    handles.temp_seq_time(4) = str2double(get(hObject,'String'));
end
guidata(hObject, handles);  %update handles



% --- Executes during object creation, after setting all properties.
function tempSeqTime4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempSeqTime4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tempSeqTime5_Callback(hObject, eventdata, handles)
% hObject    handle to tempSeqTime5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(str2double(get(hObject,'String')))
    errordlg('Input must be number.');
else
    handles.temp_seq_time(5) = str2double(get(hObject,'String'));
end
guidata(hObject, handles);  %update handles



% --- Executes during object creation, after setting all properties.
function tempSeqTime5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempSeqTime5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function tempSeqTime6_Callback(hObject, eventdata, handles)
% hObject    handle to tempSeqTime6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(str2double(get(hObject,'String')))
    errordlg('Input must be number.');
else
    handles.temp_seq_time(6) = str2double(get(hObject,'String'));
end
guidata(hObject, handles);  %update handles



% --- Executes during object creation, after setting all properties.
function tempSeqTime6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempSeqTime6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tempSeqTime7_Callback(hObject, eventdata, handles)
% hObject    handle to tempSeqTime7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(str2double(get(hObject,'String')))
    errordlg('Input must be number.');
else
    handles.temp_seq_time(7) = str2double(get(hObject,'String'));
end
guidata(hObject, handles);  %update handles



% --- Executes during object creation, after setting all properties.
function tempSeqTime7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempSeqTime7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tempSeqTime8_Callback(hObject, eventdata, handles)
% hObject    handle to tempSeqTime8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isnan(str2double(get(hObject,'String')))
    errordlg('Input must be number.');
else
    handles.temp_seq_time(8) = str2double(get(hObject,'String'));
end
guidata(hObject, handles);  %update handles



% --- Executes during object creation, after setting all properties.
function tempSeqTime8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempSeqTime8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function path_Callback(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.log_file_path = get(hObject,'String');

%check the path end with '\'
if handles.log_file_path(end) ~= '\'
    msgbox('Path name should end with \.', 'Invalid path name.', 'error');
end

% if the input path does not exist, a new dir will be created.
if ~isequal(exist(handles.log_file_path, 'dir'),7)
    mkdir(handles.log_file_path);
end

guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

y = year(date);
m = month(date);
d = day(date);

dateStr = [num2str(y,'%04i'),'-', num2str(m,'%02i'),'-', num2str(d,'%02i')];
handles.log_file_path = ['D:\lyb\', dateStr, '\'];

set(hObject,'String', handles.log_file_path);

% if the input path does not exist, a new dir will be created.
if ~isequal(exist(handles.log_file_path, 'dir'),7)
    mkdir(handles.log_file_path);
end

guidata(hObject, handles);  %update handles


function fileName_Callback(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.log_file_name = get(hObject,'String');
% if the input path does not exist, a new dir will be created.
if isequal(exist([handles.log_file_path, handles.log_file_name, '.txt'], 'file'), 2)
    msgbox('The log file already exists. Keep runing will overwrite the old file.', 'This file already exist', 'warn');
end
guidata(hObject, handles);  %update handles


% --- Executes during object creation, after setting all properties.
function fileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in triggerSingalEnable.
function triggerSingalEnable_Callback(hObject, eventdata, handles)
% hObject    handle to triggerSingalEnable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.trigger_singnal_enable = get(hObject,'Value');


% --- Executes on button press in runExp.
function runExp_Callback(hObject, eventdata, handles)
%% Plot sequence // same as push the button of 'Plot Sequence'
% Check all the data need is ready

idx=strfind(handles.log_file_name,'-run')+4;
runnum=str2double(handles.log_file_name(idx:idx+2));
if runnum==101
    side=questdlg('Which side of animal is facing the objective?',...
        'Choose Side','Dorsal','Ventral','I don''t care!','I don''t care!');
    
    handles.log_data.which_side{1}=side;
end
if handles.LRcheckbox.Value
    handles.log_data.which_side{2}=questdlg('Which side are you imaging?',...
        'Which side','Left','Right','Who cares?');
end

total_odor_time = sum(handles.sequence_period);
% if handles.temp_seq_enable
%     total_temp_time = sum(handles.temp_seq_time);
%     if total_odor_time ~= total_temp_time
%         msgbox(['The peirods of odor sequence is ', num2str(total_odor_time), ...
%             's. Periods of temperature sequence is', num2str(total_temp_time), ...
%             's. They are unequal. Set them as equal.'], 'Mismatched peirods', 'error');
%         return;
%     end
% end
% plot odor sequence
fig = findobj('Tag', 'fig'); %get the handle of odor figure.

axis([0 total_odor_time 0 1]); %fix the axis.
hold on;
tick = zeros(1, length(handles.sequence_period)+1); %x tick
label = cell(1, length(handles.sequence_period)+1); %x label
label{1} = '0';

for i = 1:length(handles.sequence_period)
    x_l = sum(handles.sequence_period(1 : i-1));	%define the left boundary of color box on x axis
    x_r = sum(handles.sequence_period(1 : i));	 %define the right boundary of color box on x axis
    tick(i+1) = x_r;              %update the x tick and x label
    label{i+1} = num2str(x_r);
    X = [x_l x_r x_r x_l];	%generate the x axis of the color box
    Y = [0 0 1 1];  %generate the x axis of the color box
    if handles.sequence_channel(i)== 1
        C = [1 1 1];
    else
        C= handles.channel_color(handles.sequence_channel(i)-1,:); %pick the color for each odor.
    end
    patch(X, Y, C);     %draw a color box for each odor.
end
set(gca, 'XTick', tick);    %set the tick and label for x axis.
set(gca, 'XTickLabel', label); 

% plot temperature sequence, if defined
if handles.temp_enable
    axis([0 total_odor_time 0 2]); %fix the axis.
    plot(0:1:total_odor_time, ones(1, total_odor_time+1));
    if ~handles.temp_seq_enable
        if handles.tempchannel_state(2) == 1
            C = [0.5 0.5 0.5];
        else
            C = [1 1 1];
        end
        patch([0 total_odor_time total_odor_time 0], [1 1 2 2], C); %make the box gray if it is high temperature.
    else
        for i =1:1:length(handles.temp_seq_time)
            if handles.temp_seq_time(i) ~= 0
                x_l = sum(handles.temp_seq_time(1 : i-1));	%define the left boundary of color box on x axis
                x_r = sum(handles.temp_seq_time(1 : i));
                X = [x_l x_r x_r x_l];  Y = [1 1 2 2];
                if rem(i,2) == 0
                    C = [0.5 0.5 0.5];      %T2 color set as [0.5 0.5 0.5]
                else
                    C = [1 1 1];    %T1 color is set as [1 1 1]
                end
                patch(X, Y, C);
            end
        end
    end
end
hold off;

%% figure out the cmd to send in next section
[ cmd_odor,  cmd_temp, period_temp ] = generateCmd( handles.channel_type, ...
    handles.all_valves, handles.sequence_channel, handles.sequence_period, ...
    handles.temp_enable, handles.temp_seq_enable, handles.temp_seq_time);

[ cmd, period, all_valves ] = mergeCmd(cmd_odor, handles.sequence_period, handles.all_valves, cmd_temp, period_temp, handles.tempchannel_list);

%% define timers to control valves
% seq_odor = zeros(length(handles.sequence_period), 1);
% for i =1:length(handles.sequence_period)
%     seq_odor(i) = sum(handles.sequence_period(1:i));
% end
% 
% seq_temp = zeros(length(period_temp), 1);
% for i =1:length(period_temp)
%     seq_temp(i) = sum(period_temp(1:i));
% end
% 
% %define the timer for odor sequence
% handles.T_odor = timer;  
% set(handles.T_odor,'BusyMode', 'queue');
% set(handles.T_odor,'ExecutionMode', 'fixedRate');
% set(handles.T_odor,'Period', 0.1);
% set(handles.T_odor,'TasksToExecute', 10*sum(handles.sequence_period)+1);
% 
% %define the timer for temperature sequence
% if handles.temp_enable && handles.temp_seq_enable
%     handles.T_temp = timer;
%     set(handles.T_temp,'BusyMode', 'queue');
%     set(handles.T_temp,'ExecutionMode', 'fixedRate');
%     set(handles.T_temp,'Period', 0.1);
%     set(handles.T_temp,'TasksToExecute', 10*sum(handles.sequence_period)+1);
% end


%define the timer for odor sequence
handles.T_plot = timer;  
set(handles.T_plot,'BusyMode', 'queue');
set(handles.T_plot,'ExecutionMode', 'fixedRate');
set(handles.T_plot,'Period', 0.1);
set(handles.T_plot,'TasksToExecute', 10*sum(handles.sequence_period)+1);


% %define two global counter, used in timer callback functions
% global  counter_odor   
% counter_odor = 1;
% 
% if handles.temp_enable && handles.temp_seq_enable
% global counter_temp
% counter_temp = 1;
% end

%define the max value of y for the time line
max_y = 1;
if handles.temp_enable
    max_y=2;
end

guidata(hObject, handles); 
%% Control valves
% prepar for plotting the time line
fig = findobj('Tag', 'fig'); %get the handle to update the plot
hold on;

% initiallize the valves
% disp(cmd_odor(1,:));
% smset(handles.all_valves, cmd_odor(1,:));
% smset(handles.tempchannel_list, cmd_temp(1,:));
smset(all_valves, cmd(1,:));

global lh
lh = line([0 , 0 ], [0 max_y], 'Color', 'g', 'LineWidth', 4);

% wait for the trigger signal
if handles.trigger_singnal_enable %check if need to wait the trigger signal from microscope
    disp('Waiting for the trigger signal from microscope.')
	while ~cell2mat(smget('camera'))   %if yes, wait until the camera signal is sent.
    end
    disp('Experiment start.')
end

%read out the initial clock
init_time = now; 

%set the timer callback functions
% set(handles.T_odor,'TimerFcn', {@callback_fcn_odor, init_time, 10*seq_odor, cmd_odor, handles.all_valves});
% 
% if handles.temp_enable && handles.temp_seq_enable
%     set(handles.T_temp,'TimerFcn', {@callback_fcn_temp, init_time, 10*seq_temp, cmd_temp, handles.tempchannel_list});
% end

set(handles.T_plot,'TimerFcn', {@callback_fcn_plot, init_time, max_y});

%start the timers
% start(handles.T_odor); 
% if handles.temp_enable && handles.temp_seq_enable
%     start(handles.T_temp);
% end
start(handles.T_plot); 

tic
for i = 1 : 1 : length(period)
    smset(all_valves,cmd(i,:));
    pause(period(i) -toc);
    tic
end
% pause(sum(handles.sequence_period) + 1);

%delete timers after running
% stop(handles.T_odor); delete(handles.T_odor); 
% 
% if handles.temp_enable && handles.temp_seq_enable
%     stop(handles.T_temp);     delete(handles.T_temp);
% end

stop(handles.T_plot); delete(handles.T_plot); 

hold off;

% delete(lh);  %clear the time line;

%% write the Log file
writeLogFile(handles.log_file_path, strcat('log_',handles.log_file_name),...
    handles.conc_plus_odor_list, handles.sequence_channel,...
    handles.sequence_period, handles.temp_enable, handles.temp_list,...
    handles.tempchannel_state, handles.temp_seq_enable,  handles.temp_seq_time);

log_data=handles.log_data;
log_data.conc_list=handles.conc_list;
log_data.odor_list=handles.odor_list;
log_data.sequence_period=handles.sequence_period;
log_data.sequence_channel=handles.sequence_channel;
log_data.annotations=handles.annotations.String;
save(strcat(handles.log_file_path,'log_',handles.log_file_name,'.mat'),...
    'log_data')


%% update the name of log file after the experiment is done.
old_file_name = get(findobj('Tag', 'fileName'), 'String'); 

if  sum(isstrprop(old_file_name(end-2:end), 'digit')) ~= 3 %check if the last three characters are not all numbers 
    new_file_name = strcat(old_file_name, '101'); %if not numbers, add number at the end of the string
elseif isstrprop(old_file_name(end-3), 'digit')
    old_num = str2num(old_file_name(end-3: end));
    new_num = old_num + 1;
    new_file_name = strcat(old_file_name(1:end-4), num2str(new_num));
else
    old_num = str2num(old_file_name(end-2: end));
    new_num = old_num + 1;
    new_file_name = strcat(old_file_name(1:end-3), num2str(new_num));
end

handles.log_file_name = new_file_name;
guidata(hObject, handles);  %update handles firstly.

set(findobj('Tag', 'fileName'), 'String', new_file_name); %refreash the display

guidata(hObject, handles);  %update handles again


% --- Executes on button press in abortExp.
function abortExp_Callback(hObject, eventdata, handles)
% hObject    handle to abortExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop(handles.T_plot); delete(handles.T_plot); 

stop(timerfind); delete(timerfind);
% stop(handles.T_odor); stop(handles.T_temp);
% delete(handles.T_odor); delete(handles.T_temp);
% 
% fig = findobj('Tag', 'fig');
% line([0, 0], [0 2], 'Color', 'g', 'LineWidth', 4);

guidata(hObject, handles);  %update handles

error('User Interrupted!');

% --- Executes on button press in runCleanCycle.
function runCleanCycle_Callback(hObject, eventdata, handles)
% hObject    handle to runCleanCycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 runCleanCycle( handles.all_valves, 7.5);

% --- Executes on button press in runWaterOnly.
function runWaterOnly_Callback(hObject, eventdata, handles)
% hObject    handle to runWaterOnly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 runWaterOnly( handles.all_valves);

% --- Executes on button press in closeAll.
function closeAll_Callback(hObject, eventdata, handles)
% hObject    handle to closeAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 runCloseAll( handles.all_valves);

% --- Executes on button press in plotSeq.
function plotSeq_Callback(hObject, eventdata, handles)
% hObject    handle to plotSeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Check all the data need is ready
total_odor_time = sum(handles.sequence_period);
if handles.temp_seq_enable
    total_temp_time = sum(handles.temp_seq_time);
    if total_odor_time ~= total_temp_time
        msgbox(['The peirods of odor sequence is ', num2str(total_odor_time), ...
            's. Periods of temperature sequence is', num2str(total_temp_time), ...
            's. They are unequal. Set them as equal.'], 'Mismatched peirods', 'error');
        return;
    end
end

%% plot odor sequence
fig = findobj('Tag', 'fig'); %get the handle of odor figure.

axis([0 total_odor_time 0 1]); %fix the axis.
hold on;
tick = zeros(1, length(handles.sequence_period)+1); %x tick
label = cell(1, length(handles.sequence_period)+1); %x label
label{1} = '0';

for i = 1:length(handles.sequence_period)
    x_l = sum(handles.sequence_period(1 : i-1));	%define the left boundary of color box on x axis
    x_r = sum(handles.sequence_period(1 : i));	 %define the right boundary of color box on x axis
    tick(i+1) = x_r;              %update the x tick and x label
    label{i+1} = num2str(x_r);
    X = [x_l x_r x_r x_l];	%generate the x axis of the color box
    Y = [0 0 1 1];  %generate the x axis of the color box
    if handles.sequence_channel(i)== 1
        C = [1 1 1];
    else
        C= handles.channel_color(handles.sequence_channel(i)-1,:); %pick the color for each odor.
    end
    patch(X, Y, C);     %draw a color box for each odor.
end
set(gca, 'XTick', tick);    %set the tick and label for x axis.
set(gca, 'XTickLabel', label); 

%% plot temperature sequence, if defined
if handles.temp_enable
    axis([0 total_odor_time 0 2]); %fix the axis.
    plot(0:1:total_odor_time, ones(1, total_odor_time+1));
    if ~handles.temp_seq_enable
        if handles.tempchannel_state(2) == 1
            C = [0.5 0.5 0.5];
        else
            C = [1 1 1];
        end
        patch([0 total_odor_time total_odor_time 0], [1 1 2 2], C); %make the box gray if it is high temperature.
    else
        for i =1:1:length(handles.temp_seq_time)
            if handles.temp_seq_time(i) ~= 0
                x_l = sum(handles.temp_seq_time(1 : i-1));	%define the left boundary of color box on x axis
                x_r = sum(handles.temp_seq_time(1 : i));
                X = [x_l x_r x_r x_l];  Y = [1 1 2 2];
                if rem(i,2) == 0
                    C = [0.5 0.5 0.5];      %T2 color set as [0.5 0.5 0.5]
                else
                    C = [1 1 1];    %T1 color is set as [1 1 1]
                end
                patch(X, Y, C);
            end
        end
    end
end
hold off;

function edit63_Callback(hObject, eventdata, handles)

function edit63_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit64_Callback(hObject, eventdata, handles)

function edit64_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit65_Callback(hObject, eventdata, handles)

function edit65_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.



% --- Executes on button press in newAnimal.
function newAnimal_Callback(hObject, eventdata, handles)
% hObject    handle to newAnimal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    idx=strfind(handles.fileName.String,'-run');
    if isempty(idx)
        newrunnum=101;
        new_logfile=strcat(handles.log_file_name,num2str(newrunnum));
    else
        runnum=str2double(handles.fileName.String(idx+4:end));
        newrunnum=(floor(runnum/100)+1)*100+1;
        new_logfile=strcat(handles.log_file_name(1:idx+3),num2str(newrunnum));
    end
    handles.log_file_name=new_logfile;
    handles.fileName.String=new_logfile;
    side=questdlg('Which side of animal is facing the objective?',...
        'Choose Side','Dorsal','Ventral','I don''t care!','I don''t care!');
    handles.log_data.which_side{1}=side;
    guidata(hObject, handles);


function annotations_Callback(hObject, eventdata, handles)
% hObject    handle to annotations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of annotations as text
%        str2double(get(hObject,'String')) returns contents of annotations as a double


% --- Executes during object creation, after setting all properties.
function annotations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to annotations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function runExp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to runExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in LRcheckbox.
function LRcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to LRcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LRcheckbox


% --- Executes on selection change in channel14.
function channel14_Callback(hObject, eventdata, handles)
% hObject    handle to channel14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channel14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel14


% --- Executes during object creation, after setting all properties.
function channel14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in odor14.
function odor14_Callback(hObject, eventdata, handles)
% hObject    handle to odor14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns odor14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from odor14


% --- Executes during object creation, after setting all properties.
function odor14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in concentration14.
function concentration14_Callback(hObject, eventdata, handles)
% hObject    handle to concentration14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns concentration14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from concentration14


% --- Executes during object creation, after setting all properties.
function concentration14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in channel15.
function channel15_Callback(hObject, eventdata, handles)
% hObject    handle to channel15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channel15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel15


% --- Executes during object creation, after setting all properties.
function channel15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in odor15.
function odor15_Callback(hObject, eventdata, handles)
% hObject    handle to odor15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns odor15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from odor15


% --- Executes during object creation, after setting all properties.
function odor15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in concentration15.
function concentration15_Callback(hObject, eventdata, handles)
% hObject    handle to concentration15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns concentration15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from concentration15


% --- Executes during object creation, after setting all properties.
function concentration15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in channel16.
function channel16_Callback(hObject, eventdata, handles)
% hObject    handle to channel16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channel16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel16


% --- Executes during object creation, after setting all properties.
function channel16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in odor16.
function odor16_Callback(hObject, eventdata, handles)
% hObject    handle to odor16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns odor16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from odor16


% --- Executes during object creation, after setting all properties.
function odor16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in concentration16.
function concentration16_Callback(hObject, eventdata, handles)
% hObject    handle to concentration16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns concentration16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from concentration16


% --- Executes during object creation, after setting all properties.
function concentration16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in channel17.
function channel17_Callback(hObject, eventdata, handles)
% hObject    handle to channel17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channel17 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel17


% --- Executes during object creation, after setting all properties.
function channel17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in odor17.
function odor17_Callback(hObject, eventdata, handles)
% hObject    handle to odor17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns odor17 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from odor17


% --- Executes during object creation, after setting all properties.
function odor17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in concentration17.
function concentration17_Callback(hObject, eventdata, handles)
% hObject    handle to concentration17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns concentration17 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from concentration17


% --- Executes during object creation, after setting all properties.
function concentration17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in channel18.
function channel18_Callback(hObject, eventdata, handles)
% hObject    handle to channel18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channel18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel18


% --- Executes during object creation, after setting all properties.
function channel18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in odor18.
function odor18_Callback(hObject, eventdata, handles)
% hObject    handle to odor18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns odor18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from odor18


% --- Executes during object creation, after setting all properties.
function odor18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in concentration18.
function concentration18_Callback(hObject, eventdata, handles)
% hObject    handle to concentration18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns concentration18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from concentration18


% --- Executes during object creation, after setting all properties.
function concentration18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in channel19.
function channel19_Callback(hObject, eventdata, handles)
% hObject    handle to channel19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channel19 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel19


% --- Executes during object creation, after setting all properties.
function channel19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in odor19.
function odor19_Callback(hObject, eventdata, handles)
% hObject    handle to odor19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns odor19 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from odor19


% --- Executes during object creation, after setting all properties.
function odor19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in concentration19.
function concentration19_Callback(hObject, eventdata, handles)
% hObject    handle to concentration19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns concentration19 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from concentration19


% --- Executes during object creation, after setting all properties.
function concentration19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in channel21.
function channel21_Callback(hObject, eventdata, handles)
% hObject    handle to channel21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channel21 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel21


% --- Executes during object creation, after setting all properties.
function channel21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in odor20.
function odor20_Callback(hObject, eventdata, handles)
% hObject    handle to odor20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns odor20 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from odor20


% --- Executes during object creation, after setting all properties.
function odor20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in concentration20.
function concentration20_Callback(hObject, eventdata, handles)
% hObject    handle to concentration20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns concentration20 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from concentration20


% --- Executes during object creation, after setting all properties.
function concentration20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in channel20.
function channel20_Callback(hObject, eventdata, handles)
% hObject    handle to channel20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channel20 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel20


% --- Executes during object creation, after setting all properties.
function channel20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in odor21.
function odor21_Callback(hObject, eventdata, handles)
% hObject    handle to odor21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns odor21 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from odor21


% --- Executes during object creation, after setting all properties.
function odor21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to odor21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in concentration21.
function concentration21_Callback(hObject, eventdata, handles)
% hObject    handle to concentration21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns concentration21 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from concentration21


% --- Executes during object creation, after setting all properties.
function concentration21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime17A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime17A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime17A as text
%        str2double(get(hObject,'String')) returns contents of seqTime17A as a double


% --- Executes during object creation, after setting all properties.
function seqTime17A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime17A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime17B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime17B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime17B as text
%        str2double(get(hObject,'String')) returns contents of seqTime17B as a double


% --- Executes during object creation, after setting all properties.
function seqTime17B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime17B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime18A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime18A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime18A as text
%        str2double(get(hObject,'String')) returns contents of seqTime18A as a double


% --- Executes during object creation, after setting all properties.
function seqTime18A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime18A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime18B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime18B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime18B as text
%        str2double(get(hObject,'String')) returns contents of seqTime18B as a double


% --- Executes during object creation, after setting all properties.
function seqTime18B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime18B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime19_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime19 as text
%        str2double(get(hObject,'String')) returns contents of seqTime19 as a double


% --- Executes during object creation, after setting all properties.
function seqTime19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime19B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime19B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime19B as text
%        str2double(get(hObject,'String')) returns contents of seqTime19B as a double


% --- Executes during object creation, after setting all properties.
function seqTime19B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime19B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime20A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime20A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime20A as text
%        str2double(get(hObject,'String')) returns contents of seqTime20A as a double


% --- Executes during object creation, after setting all properties.
function seqTime20A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime20A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime20B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime20B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime20B as text
%        str2double(get(hObject,'String')) returns contents of seqTime20B as a double


% --- Executes during object creation, after setting all properties.
function seqTime20B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime20B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime21A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime21A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime21A as text
%        str2double(get(hObject,'String')) returns contents of seqTime21A as a double


% --- Executes during object creation, after setting all properties.
function seqTime21A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime21A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime21B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime21B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime21B as text
%        str2double(get(hObject,'String')) returns contents of seqTime21B as a double


% --- Executes during object creation, after setting all properties.
function seqTime21B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime21B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel17A.
function seqChannel17A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel17A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel17A contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel17A


% --- Executes during object creation, after setting all properties.
function seqChannel17A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel17A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel18A.
function seqChannel18A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel18A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel18A contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel18A


% --- Executes during object creation, after setting all properties.
function seqChannel18A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel18A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel19A.
function seqChannel19A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel19A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel19A contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel19A


% --- Executes during object creation, after setting all properties.
function seqChannel19A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel19A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel21A.
function seqChannel21A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel21A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel21A contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel21A


% --- Executes during object creation, after setting all properties.
function seqChannel21A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel21A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel20A.
function seqChannel20A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel20A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel20A contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel20A


% --- Executes during object creation, after setting all properties.
function seqChannel20A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel20A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel17B.
function seqChannel17B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel17B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel17B contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel17B


% --- Executes during object creation, after setting all properties.
function seqChannel17B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel17B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel18B.
function seqChannel18B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel18B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel18B contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel18B


% --- Executes during object creation, after setting all properties.
function seqChannel18B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel18B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel19B.
function seqChannel19B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel19B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel19B contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel19B


% --- Executes during object creation, after setting all properties.
function seqChannel19B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel19B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel17B.
function popupmenu168_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel17B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel17B contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel17B


% --- Executes during object creation, after setting all properties.
function popupmenu168_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel17B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel18B.
function popupmenu169_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel18B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel18B contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel18B


% --- Executes during object creation, after setting all properties.
function popupmenu169_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel18B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit72_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime17A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime17A as text
%        str2double(get(hObject,'String')) returns contents of seqTime17A as a double


% --- Executes during object creation, after setting all properties.
function edit72_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime17A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit74_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime18A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime18A as text
%        str2double(get(hObject,'String')) returns contents of seqTime18A as a double


% --- Executes during object creation, after setting all properties.
function edit74_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime18A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime19A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime19A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime19A as text
%        str2double(get(hObject,'String')) returns contents of seqTime19A as a double


% --- Executes during object creation, after setting all properties.
function seqTime19A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime19A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit78_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime20A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime20A as text
%        str2double(get(hObject,'String')) returns contents of seqTime20A as a double


% --- Executes during object creation, after setting all properties.
function edit78_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime20A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit80_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime21A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime21A as text
%        str2double(get(hObject,'String')) returns contents of seqTime21A as a double


% --- Executes during object creation, after setting all properties.
function edit80_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime21A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime22A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime22A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime22A as text
%        str2double(get(hObject,'String')) returns contents of seqTime22A as a double


% --- Executes during object creation, after setting all properties.
function seqTime22A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime22A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime22B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime22B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime22B as text
%        str2double(get(hObject,'String')) returns contents of seqTime22B as a double


% --- Executes during object creation, after setting all properties.
function seqTime22B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime22B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime23A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime23A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime23A as text
%        str2double(get(hObject,'String')) returns contents of seqTime23A as a double


% --- Executes during object creation, after setting all properties.
function seqTime23A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime23A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime23B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime23B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime23B as text
%        str2double(get(hObject,'String')) returns contents of seqTime23B as a double


% --- Executes during object creation, after setting all properties.
function seqTime23B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime23B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime24A_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime24A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime24A as text
%        str2double(get(hObject,'String')) returns contents of seqTime24A as a double


% --- Executes during object creation, after setting all properties.
function seqTime24A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime24A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTime24B_Callback(hObject, eventdata, handles)
% hObject    handle to seqTime24B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTime24B as text
%        str2double(get(hObject,'String')) returns contents of seqTime24B as a double


% --- Executes during object creation, after setting all properties.
function seqTime24B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTime24B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel17A.
function popupmenu160_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel17A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel17A contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel17A


% --- Executes during object creation, after setting all properties.
function popupmenu160_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel17A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel18A.
function popupmenu161_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel18A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel18A contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel18A


% --- Executes during object creation, after setting all properties.
function popupmenu161_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel18A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel19A.
function popupmenu162_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel19A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel19A contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel19A


% --- Executes during object creation, after setting all properties.
function popupmenu162_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel19A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel20A.
function popupmenu163_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel20A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel20A contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel20A


% --- Executes during object creation, after setting all properties.
function popupmenu163_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel20A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel21A.
function popupmenu164_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel21A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel21A contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel21A


% --- Executes during object creation, after setting all properties.
function popupmenu164_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel21A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel22A.
function seqChannel22A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel22A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel22A contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel22A


% --- Executes during object creation, after setting all properties.
function seqChannel22A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel22A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel24A.
function seqChannel24A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel24A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel24A contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel24A


% --- Executes during object creation, after setting all properties.
function seqChannel24A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel24A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel23A.
function seqChannel23A_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel23A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel23A contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel23A


% --- Executes during object creation, after setting all properties.
function seqChannel23A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel23A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel19B.
function popupmenu170_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel19B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel19B contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel19B


% --- Executes during object creation, after setting all properties.
function popupmenu170_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel19B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel20B.
function seqChannel20B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel20B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel20B contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel20B


% --- Executes during object creation, after setting all properties.
function seqChannel20B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel20B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel21B.
function seqChannel21B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel21B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel21B contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel21B


% --- Executes during object creation, after setting all properties.
function seqChannel21B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel21B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel22B.
function seqChannel22B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel22B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel22B contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel22B


% --- Executes during object creation, after setting all properties.
function seqChannel22B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel22B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel24B.
function seqChannel24B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel24B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel24B contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel24B


% --- Executes during object creation, after setting all properties.
function seqChannel24B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel24B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in seqChannel23B.
function seqChannel23B_Callback(hObject, eventdata, handles)
% hObject    handle to seqChannel23B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns seqChannel23B contents as cell array
%        contents{get(hObject,'Value')} returns selected item from seqChannel23B


% --- Executes during object creation, after setting all properties.
function seqChannel23B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqChannel23B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
