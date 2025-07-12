



clc;
clear;

% --- Load audio file ---
[x, fs] = audioread('Recording 8.wav');
x = mean(x, 2);  % Convert to mono if stereo

% --- STFT parameters ---
frameLen = 1024;            % Frame length
overlap = frameLen / 2;     % Overlap between frames
window = hamming(frameLen); % Window function

% --- Select noise-only segment (assumed first 1 second) ---
noise_duration = 4; % seconds
noise_samples = round(noise_duration * fs);
noise_signal = x(1:noise_samples);

% Compute STFT of noise segment
[S_noise, F, T_noise] = stft(noise_signal, fs, 'Window', window, 'OverlapLength', overlap, 'FFTLength', frameLen);
noise_mag = abs(S_noise);
mean_noise_mag = mean(noise_mag, 2); % Average noise magnitude spectrum

% Compute STFT of entire signal
[S, F, T] = stft(x, fs, 'Window', window, 'OverlapLength', overlap, 'FFTLength', frameLen);
S_mag = abs(S);
S_phase = angle(S);

% --- Spectral Subtraction ---
clean_mag = S_mag - mean_noise_mag;
clean_mag(clean_mag < 0) = 0;  % Avoid negative magnitudes

% Reconstruct cleaned signal using original phase
S_clean = clean_mag .* exp(1j * S_phase);
[x_clean, ~] = istft(S_clean, fs, 'Window', window, 'OverlapLength', overlap, 'FFTLength', frameLen);

% Take real part to avoid complex data error in sound()
x_clean = real(x_clean);

% --- Play and save cleaned audio ---
sound(x_clean, fs);
audiowrite('Recording8_Cleaned.wav', x_clean, fs);
disp('Cleaned audio saved as Recording8_Cleaned.wav and playing now.');

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
title('Cleaned Signal (After Spectral Subtraction)');
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
title('Spectrogram of Cleaned Signal');





