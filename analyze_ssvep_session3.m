%% SSVEP EEG Analysis - Session 3
% Processes EEG responses to SSVEP stimuli in Session 3 using FFT and SNR analysis.
% Evaluates occipital, parietal, parietal+occipital, and parietal-occipital combinations.

clc; clear; close all;

%% Stimulus Start Times
s1 = 400;  % Offset for one group of trials
s2 = 84;   % Offset for another group

% Group 1
x(22) = s1 + 0.5;
x(21) = 20.4 + s1 + 0.5;
x(20) = 40.7 + s1 + 0.5;
x(2)  = 61.0 + s1 + 0.5;
x(8)  = 81.3 + s1 + 0.5;
x(13) = 101.5 + s1 + 0.5;
x(5)  = 121.9 + s1 + 0.5;
x(14) = 142.2 + s1 + 0.5;
x(9)  = 162.6 + s1 + 0.5;
x(16) = 183.1 + s1 + 0.5;
x(3)  = 203.5 + s1 + 0.5;

% Group 2
x(19) = s2 + 0.5;
x(18) = 20.4 + s2 + 0.5;
x(11) = 40.7 + s2 + 0.5;
x(7)  = 61.0 + s2 + 0.5;
x(1)  = 81.3 + s2 + 0.5;
x(15) = 101.6 + s2 + 0.5;
x(6)  = 122.0 + s2 + 0.5;
x(4)  = 142.3 + s2 + 0.5;
x(17) = 162.6 + s2 + 0.5;
x(12) = 182.9 + s2 + 0.5;
x(10) = 203.2 + s2 + 0.5;

%% Load EEG Data
load('3.mat');  % Contains Corigin (occipital), Dorigin (parietal)

%% Parameters
fs = 250;             % Sampling rate
epoch_duration = 8;   % seconds

%% Analyze First 17 Trials (focused on 15 & 30 Hz targets)
for m = 1:17
    idx = ((x(m)-1)*fs + 1) : ((x(m)+epoch_duration)*fs);
    
    % Segment signals
    mohareko(m,:)  = Corigin(idx);                     % Occipital
    moharekp(m,:)  = Dorigin(idx);                     % Parietal
    moharekpo(m,:) = Dorigin(idx) - Corigin(idx);      % Difference
    moharekop(m,:) = Dorigin(idx) + Corigin(idx);      % Sum

    % FFT
    [p1(m,:), f(m,:)]   = compute_fft(mohareko(m,:), fs);
    [p12(m,:), f2(m,:)] = compute_fft(moharekp(m,:), fs);
    [p13(m,:), f3(m,:)] = compute_fft(moharekop(m,:), fs);
    [p14(m,:), f4(m,:)] = compute_fft(moharekpo(m,:), fs);

    % SNR @ 15 & 30 Hz
    [peak15o(m), peak30o(m), snr15o(m), snr30o(m)]     = extract_snr(p1(m,:), f(m,:), 15, 30);
    [peak15p(m), peak30p(m), snr15p(m), snr30p(m)]     = extract_snr(p12(m,:), f2(m,:), 15, 30);
    [peak15op(m), peak30op(m), snr15op(m), snr30op(m)] = extract_snr(p13(m,:), f3(m,:), 15, 30);
    [peak15po(m), peak30po(m), snr15po(m), snr30po(m)] = extract_snr(p14(m,:), f4(m,:), 15, 30);

    % Plot
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

function [peakA, peakB, snrA, snrB] = extract_snr(P, f, f1, f2)
    % Peak amplitudes
    peakA = P(f == f1);
    peakB = P(f == f2);
    
    % Mean noise near each freq
    pnoiseA = mean(P((f > f1 - 0.57 & f < f1 - 0.1) | (f > f1 + 0.1 & f < f1 + 0.57)));
    pnoiseB = mean(P((f > f2 - 0.57 & f < f2 - 0.1) | (f > f2 + 0.1 & f < f2 + 0.57)));

    % SNR
    snrA = peakA / pnoiseA;
    snrB = peakB / pnoiseB;
end
