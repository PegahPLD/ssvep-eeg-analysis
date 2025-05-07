%% SSVEP EEG Analysis - Frequency Modulation at 75 Hz
% This script processes EEG data recorded in response to FM SSVEP stimuli
% using 75 Hz carrier frequency. It computes spectral power and SNR
% at 15 Hz and 30 Hz for occipital, parietal, and their combinations.

clc; clear;

%% Set Stimulus Onset Times (in seconds)
s1 = 626;  % Offset for first group of trials
s2 = 318;  % Offset for second group of trials

% Trial start times relative to stimulus start
% Group 1 (s1 offset)
x(7)  = s1 + 0.5;
x(16) = 20.4 + s1 + 0.5;
x(6)  = 40.9 + s1 + 0.5;
x(4)  = 61.1 + s1 + 0.5;
x(17) = 81.5 + s1 + 0.5;
x(12) = 101.8 + s1 + 0.5;
x(10) = 122.1 + s1 + 0.5;
x(9)  = 142.5 + s1 + 0.5;
x(20) = 162.7 + s1 + 0.5;
x(21) = 183.0 + s1 + 0.5;
x(22) = 203.3 + s1 + 0.5;

% Group 2 (s2 offset)
x(15) = s2 + 0.5;
x(2)  = 20.4 + s2 + 0.5;
x(8)  = 40.8 + s2 + 0.5;
x(13) = 61.1 + s2 + 0.5;
x(11) = 81.4 + s2 + 0.5;
x(5)  = 101.7 + s2 + 0.5;
x(14) = 122.0 + s2 + 0.5;
x(1)  = 142.3 + s2 + 0.5;
x(3)  = 162.6 + s2 + 0.5;
x(18) = 182.9 + s2 + 0.5;
x(19) = 203.4 + s2 + 0.5;

%% Load EEG Data
% Corigin: occipital electrode
% Dorigin: parietal electrode
load('1.mat'); 

%% Analysis Parameters
fs = 250;        % Sampling rate in Hz
epoch_duration = 8;  % Duration of each trial in seconds

%% Process First 17 Trials (15 & 30 Hz targets)
for m = 1:17
    idx = ((x(m)-1)*fs+1) : ((x(m)+epoch_duration)*fs);
    
    % Segment data
    mohareko(m,:)  = Corigin(idx);                     % Occipital
    moharekp(m,:)  = Dorigin(idx);                     % Parietal
    moharekpo(m,:) = Dorigin(idx) - Corigin(idx);      % Parietal - Occipital
    moharekop(m,:) = Dorigin(idx) + Corigin(idx);      % Parietal + Occipital

    % FFT Analysis
    [p1(m,:), f(m,:)]   = compute_fft(mohareko(m,:), fs);  % Occipital
    [p12(m,:), f2(m,:)] = compute_fft(moharekp(m,:), fs);  % Parietal
    [p13(m,:), f3(m,:)] = compute_fft(moharekop(m,:), fs); % Sum
    [p14(m,:), f4(m,:)] = compute_fft(moharekpo(m,:), fs); % Difference

    % Extract Peaks and SNR
    [peak15o(m), peak30o(m), snr15o(m), snr30o(m)] = extract_snr(p1(m,:), f(m,:), 15, 30);
    [peak15p(m), peak30p(m), snr15p(m), snr30p(m)] = extract_snr(p12(m,:), f2(m,:), 15, 30);
    [peak15op(m), peak30op(m), snr15op(m), snr30op(m)] = extract_snr(p13(m,:), f3(m,:), 15, 30);
    [peak15po(m), peak30po(m), snr15po(m), snr30po(m)] = extract_snr(p14(m,:), f4(m,:), 15, 30);

    % Plot Spectrum (optional)
    figure;
    subplot(2,2,1); plot(f(m,:), p1(m,:));  title('Occipital');
    subplot(2,2,2); plot(f2(m,:), p12(m,:)); title('Parietal');
    subplot(2,2,3); plot(f3(m,:), p13(m,:)); title('Parietal + Occipital');
    subplot(2,2,4); plot(f4(m,:), p14(m,:)); title('Parietal - Occipital');
end

%% --- Helper Functions ---

function [P1, f] = compute_fft(signal, fs)
    Y = fft(signal);
    L = length(Y);
    P2 = abs(Y / L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f = fs * (0:(L/2)) / L;
end

function [peak15, peak30, snr15, snr30] = extract_snr(P, f, f1, f2)
    % Get peak at exact target frequency
    peak15 = P(f == f1);
    peak30 = P(f == f2);
    
    % Mean noise near frequency
    ppeak15 = mean(P((f > f1 - 0.57 & f < f1 - 0.1) | (f > f1 + 0.1 & f < f1 + 0.57)));
    ppeak30 = mean(P((f > f2 - 0.57 & f < f2 - 0.1) | (f > f2 + 0.1 & f < f2 + 0.57)));

    % SNR = Signal / Noise
    snr15 = peak15 / ppeak15;
    snr30 = peak30 / ppeak30;
end
