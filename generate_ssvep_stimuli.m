%% SSVEP Stimuli Generator using Amplitude and Frequency Modulation
% This script generates various SSVEP stimuli using FM and AM techniques
% and sends them through a National Instruments DAQ device for presentation.

clc;
clear;

% Create DAQ session
s = daq.createSession('ni');
s.Rate = 100000;  % High sampling rate for smooth analog output

%% Time Vectors for Carrier and Modulating Frequencies
% Duration = 10 seconds
t = 10;
fs = s.Rate;

% Carrier and modulator frequency time vectors
t1   = linspace(0, t * 2 * pi * 75, t * fs)';   % 75 Hz carrier
t2   = linspace(0, t * 2 * pi * 45, t * fs)';   % 45 Hz modulator
t15  = linspace(0, t * 2 * pi * 15, t * fs)';   % 15 Hz
t30  = linspace(0, t * 2 * pi * 30, t * fs)';   % 30 Hz
t23  = linspace(0, t * 2 * pi * 23, t * fs)';   % 23 Hz
t46  = linspace(0, t * 2 * pi * 46, t * fs)';   % 46 Hz
t69  = linspace(0, t * 2 * pi * 69, t * fs)';   % 69 Hz
t77  = linspace(0, t * 2 * pi * 77, t * fs)';   % 77 Hz
t100 = linspace(0, t * 2 * pi * 100, t * fs)';  % 100 Hz
t115 = linspace(0, t * 2 * pi * 115, t * fs)';  % 115 Hz

%% Add DAQ Output Channels
addAnalogOutputChannel(s, 'Dev1', 0, 'Voltage'); % Channel 0: Reference (DC)
addAnalogOutputChannel(s, 'Dev1', 1, 'Voltage'); % Channel 1: Stimulus

%% Generate Frequency-Modulated Signals (FM @ 75 Hz)
outputsignal175 = 2.5 * sin(t1 + 1.37 * sin(t2)) + 2.5;
outputsignal275 = 2.5 * sin(t1 + 1.83 * sin(t2)) + 2.5;
outputsignal375 = 2.5 * sin(t1 + 2.63 * sin(t2)) + 2.5;
outputsignal475 = 2.5 * sin(t1 + 3.83 * sin(t2)) + 2.5;
outputsignal575 = 2.5 * sin(t1 + 4.48 * sin(t2)) + 2.5;
outputsignal675 = 2.5 * sin(t1 + 5.14 * sin(t2)) + 2.5;

%% Generate Amplitude-Modulated Signals (AM)
% 15 Hz modulated by 30 Hz with varying weights
outputsignal1am = 2.5 * sin(t30) + 2.5;
outputsignal2am = 2.5 * (0.2  * sin(t15) + 0.8  * sin(t30)) + 2.5;
outputsignal3am = 2.5 * (0.31 * sin(t15) + 0.69 * sin(t30)) + 2.5;
outputsignal4am = 2.5 * (0.47 * sin(t15) + 0.53 * sin(t30)) + 2.5;
outputsignal5am = 2.5 * sin(t15) + 2.5;

%% Additional FM signals at other frequencies
outputsignal130 = 2.5 * sin(t30 + 0.42 * sin(t15)) + 2.5;
outputsignal230 = 2.5 * sin(t30 + 0.68 * sin(t15)) + 2.5;
outputsignal330 = 2.5 * sin(t30 + 1.5  * sin(t15)) + 2.5;
outputsignal430 = 2.5 * sin(t30 + 2.3  * sin(t15)) + 2.5;
outputsignal530 = 2.5 * sin(t30 + 2.66 * sin(t15)) + 2.5;
outputsignal630 = 2.5 * sin(t30 + 3.05 * sin(t15)) + 2.5;

%% Additional Complex Modulations
outputsignal18 = 2.5 * sin(t46  + 1.5  * sin(t23)) + 2.5;
outputsignal19 = 2.5 * sin(t46  + 4.2  * sin(t23)) + 2.5;
outputsignal20 = 2.5 * sin(t46  + 4.01 * sin(t23)) + 2.5;
outputsignal21 = 2.5 * sin(t100 + 2    * sin(t77)) + 2.5;
outputsignal22 = 2.5 * sin(t115 + 2.63 * sin(t69)) + 2.5;

%% DC Signal (used between stimuli to reset baseline)
outputdc = 5.004 * ones(size(t1));

%% Example: Send One Stimulus (e.g., signal22)
disp('Sending outputsignal22...');
queueOutputData(s, [outputdc outputsignal22]);
s.startForeground;

% Pause between stimuli (DC baseline)
queueOutputData(s, [outputdc outputdc]);
s.startForeground;

%% Repeat for more stimuli (example for signal5am and others)
% You can uncomment and repeat the below blocks for each stimulus you want to send.

% disp('Sending outputsignal5am...');
% queueOutputData(s, [outputdc outputsignal5am]);
% s.startForeground;
% queueOutputData(s, [outputdc outputdc]);
% s.startForeground;

% (Repeat for outputsignal4am, outputsignal430, etc.)

