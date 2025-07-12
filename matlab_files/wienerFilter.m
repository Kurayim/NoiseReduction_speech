clc;
clear;

% --- Load audio file ---
[x, fs] = audioread('Recording 8.wav');
x = mean(x, 2);  % Convert to mono if stereo

% --- STFT parameters ---
frameLen = 1024;
overlap = round(frameLen * 0.75);
window = hamming(frameLen);

% --- Select noise-only segment (first 4 seconds) ---
noise_duration = 4; 
noise_samples = round(noise_duration * fs);
noise_signal = x(1:noise_samples);

% --- Compute STFT of noise segment ---
[S_noise, F, T_noise] = stft(noise_signal, fs, 'Window', window, 'OverlapLength', overlap, 'FFTLength', frameLen);
noise_mag = abs(S_noise);
noise_power_spec = mean(noise_mag.^2, 2); % Average noise power spectrum (PSD)

% --- Compute STFT of entire signal ---
[S, F, T] = stft(x, fs, 'Window', window, 'OverlapLength', overlap, 'FFTLength', frameLen);
S_mag = abs(S);
S_phase = angle(S);

% --- Estimate signal power spectrum ---
signal_power = S_mag.^2;

% --- Expand noise power spec to match signal power matrix dimensions ---
noise_power_expanded = repmat(noise_power_spec, 1, size(signal_power, 2));

% --- Calculate Wiener gain function ---
H_wiener = signal_power ./ (signal_power + noise_power_expanded);

% --- Apply smoothing in frequency and time to Wiener gain ---
% Define smoothing windows
freq_smooth_win = 5;  % smoothing window size in frequency bins
time_smooth_win = 5;  % smoothing window size in time frames

% Smooth in frequency
H_freq_smooth = movmean(H_wiener, freq_smooth_win, 1, 'Endpoints', 'shrink');

% Smooth in time
H_smooth = movmean(H_freq_smooth, time_smooth_win, 2, 'Endpoints', 'shrink');

% --- Limit gain to avoid musical noise and distortion ---
H_smooth = max(H_smooth, 0.05);
H_smooth(H_smooth > 1) = 1;

% --- Apply smoothed Wiener gain ---
S_clean = H_smooth .* S;

% --- Reconstruct cleaned signal ---
[x_clean, ~] = istft(S_clean .* exp(1j * S_phase), fs, 'Window', window, 'OverlapLength', overlap, 'FFTLength', frameLen);
x_clean = real(x_clean);

% --- Play and save cleaned audio ---
sound(x_clean, fs);
audiowrite('Recording8_WienerSmoothed.wav', x_clean, fs);
disp('Cleaned audio saved as Recording8_WienerSmoothed.wav and playing now.');

% --- Plot time-domain signals ---
figure;
subplot(2,1,1);
plot((1:length(x))/fs, x);
title('Original Signal (Noisy)');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot((1:length(x_clean))/fs, x_clean);
title('Cleaned Signal (After Smoothed Wiener Filter)');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid on;

% --- Plot spectrograms ---
figure;
subplot(2,1,1);
spectrogram(x, window, overlap, frameLen, fs, 'yaxis');
title('Spectrogram of Original Signal');

subplot(2,1,2);
spectrogram(x_clean, window, overlap, frameLen, fs, 'yaxis');
title('Spectrogram of Cleaned Signal (Smoothed Wiener)');
