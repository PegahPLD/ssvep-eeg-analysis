%% SSVEP EEG Analysis - Session 2 (15 Hz and 30 Hz Targets)
% Processes EEG responses to SSVEP stimuli using FFT and SNR analysis.
% Evaluates occipital, parietal, their sum, and their difference signals.

clc; clear; close all;

%% Stimulus Onset Times
s1 = 418;  % Offset for group 1
s2 = 100;  % Offset for group 2

% Group 1 trial starts (stimulus window start in seconds)
x(15) = s1 + 0.5;
x(2)  = 20.4 + s1 + 0.5;
x(1)  = 40.7 + s1 + 0.5;
x(13) = 61.0 + s1 + 0.5;
x(11) = 81.4 + s1 + 0.5;
x(5)  = 101.6 + s1 + 0.5;
x(20) = 122.0 + s1 + 0.5;
x(18) = 142.3 + s1 + 0.5;
x(14) = 162.5 + s1 + 0.5;
x(8)  = 182.8 + s1 + 0.5;
x(3)  = 203.1 + s1 + 0.5;

% Group 2 trial starts
x(22) = s2 + 0.5;
x(17) = 20.4 + s2 + 0.5;
x(16) = 40.7 + s2 + 0.5;
x(4)  = 61.1 + s2 + 0.5;
x(9)  = 81.4 + s2 + 0.5;
x(12) = 101.7 + s2 + 0.5;
x(10) = 122.0 + s2 + 0.5;
x(7)  = 142.4 + s2 + 0.5;
x(6)  = 162.7 + s2 + 0.5;
x(19) = 182.9 + s2 + 0.5;
x(21) = 203.3 + s2 + 0.5;

%% Load EEG Data
load('2.mat');  % Contains Corigin (occipital) and Dorigin (parietal)

%% Parameters
fs = 250;  % Sampling rate (Hz)
epoch_duration = 8;  % Seconds

%% Trial Loop - Analyze First 17 Stimuli
for m = 1:17
    idx = ((x(m)-1)*fs + 1) : ((x(m)+epoch_duration)*fs);
    
    % Segment EEG Data
    mohareko(m,:)  = Corigin(idx);                     % Occipital
    moharekp(m,:)  = Dorigin(idx);                     % Parietal
    moharekpo(m,:) = Dorigin(idx) - Corigin(idx);      % Parietal - Occipital
    moharekop(m,:) = Dorigin(idx) + Corigin(idx);      % Parietal + Occipital

    % FFT
    [p1(m,:), f(m,:)]   = compute_fft(mohareko(m,:), fs);
    [p12(m,:), f2(m,:)] = compute_fft(moharekp(m,:), fs);
    [p13(m,:), f3(m,:)] = compute_fft(moharekop(m,:), fs);
    [p14(m,:), f4(m,:)] = compute_fft(moharekpo(m,:), fs);

    % SNR
    [peak15o(m), peak30o(m), snr15o(m), snr30o(m)]     = extract_snr(p1(m,:), f(m,:), 15, 30);
    [peak15p(m), peak30p(m), snr15p(m), snr30p(m)]     = extract_snr(p12(m,:), f2(m,:), 15, 30);
    [peak15op(m), peak30op(m), snr15op(m), snr30op(m)] = extract_snr(p13(m,:), f3(m,:), 15, 30);
    [peak15po(m), peak30po(m), snr15po(m), snr30po(m)] = extract_snr(p14(m,:), f4(m,:), 15, 30);

    % Plot Spectrum
    figure;
    subplot(2,2,1); plot(f(m,:), p1(m,:)); title('Occipital');
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
    % Extract peak values at f1 and f2
    peak15 = P(f == f1);
    peak30 = P(f == f2);
    
    % Average nearby noise bands
    ppeak15 = mean(P((f > f1 - 0.57 & f < f1 - 0.1) | (f > f1 + 0.1 & f < f1 + 0.57)));
    ppeak30 = mean(P((f > f2 - 0.57 & f < f2 - 0.1) | (f > f2 + 0.1 & f < f2 + 0.57)));

    % Signal-to-noise ratios
    snr15 = peak15 / ppeak15;
    snr30 = peak30 / ppeak30;
end
