


[x, fs] = audioread("Recording 8.wav");

%sound(x,fs)

% رسم سیگنال در حوزه زمان
%figure;
%plot(x);
%title('Recorded Noisy Signal (Time Domain)');
%xlabel('Sample');
%ylabel('Amplitude');
%grid on;

% نمایش طیف زمانی-فرکانسی
%figure;
%spectrogram(x, 1024, 512, 1024, fs, 'yaxis');
%title('Spectrogram of Recorded Signal');


fc = 2000;
order = 6;
[b, a] = butter(order, fc/(fs/2), "low");
x_filtered = filtfilt(b, a, x);

%sound(x_filtered, fs);
%disp("Playing filtered audio...");

%audiowrite('FilteredAudio.wav', x_filtered, fs);

% figure;
% subplot(2,1,1);
% plot(x);
% title('Original Noisy Signal');
% xlabel('Sample');
% ylabel('Amplitude');
% grid on;
% 
% subplot(2,1,2);
% plot(x_filtered);
% title('Filtered Signal');
% xlabel('Sample');
% ylabel('Amplitude');
% grid on;


% % spectrogram 
% figure;
% subplot(2,1,1);
% spectrogram(x, 1024, 512, 1024, fs, 'yaxis');
% title('Spectrogram of Original Noisy Signal');
% 
% % spectrogram 
% subplot(2,1,2);
% spectrogram(x_filtered, 1024, 512, 1024, fs, 'yaxis');
% title('Spectrogram of Filtered Signal');




% f0 = 200;
% bw = 4000;
% w0 = f0/(fs/2);
% bw_norm = bw/(fs/2);
% [b, a] = iirnotch(w0, bw_norm);
% 
% x_notched = filtfilt(b, a, x);
% %sound(x_notched, fs);
% audiowrite('NotchedAudio.wav', x_notched, fs);
% 
% 
% 
% 
% 
% figure;
% subplot(2,1,1);
% plot(x);
% title('Original Noisy Signal');
% xlabel('Sample');
% ylabel('Amplitude');
% grid on;
% 
% subplot(2,1,2);
% plot(x_notched);
% title('Signal after Notch Filter');
% xlabel('Sample');
% ylabel('Amplitude');
% grid on;
% 
% 
% figure;
% subplot(2,1,1);
% spectrogram(x, 1024, 512, 1024, fs, 'yaxis');
% title('Spectrogram of Original Noisy Signal');
% 
% subplot(2,1,2);
% spectrogram(x_notched, 1024, 512, 1024, fs, 'yaxis');
% title('Spectrogram after Notch filter');
% 











% clc;
% clear;
% 
% %% Load audio file
% [x, fs] = audioread('Recording 8.wav');   % x: original signal (speech + noise)
% N = length(x);                            % Total number of samples
% 
% %% Training (first 4 seconds)
% t_train = 4;                              % Training time in seconds
% samples_train = round(t_train * fs);      % Number of samples in training window
% 
% d_train = x(1:samples_train);             % Desired signal (speech + noise)
% x_ref = x(1:samples_train);               % Reference noise
% 
% %% LMS filter parameters
% M = 64;                                   % Filter order (number of taps)
% mu = 0.01;                                % Learning rate
% w = zeros(M, 1);                          % Initial filter weights
% 
% % Zero-padding input
% x_pad = [zeros(M-1,1); x_ref];  
% e_train = zeros(samples_train,1);         % Error vector for training
% 
% %% Training loop
% for n = 1:samples_train
%     x_vec = x_pad(n+M-1:-1:n);            % Input vector (sliding window)
%     y = w' * x_vec;                       % Filter output
%     e_train(n) = d_train(n) - y;          % Error (desired - output)
%     w = w + mu * x_vec * e_train(n);      % Update weights
% end
% 
% %% Apply fixed filter to entire signal
% x_full_pad = [zeros(M-1,1); x];           % Zero-padded full input
% y_full = zeros(N,1);                      % Output (estimated noise)
% e_full = zeros(N,1);                      % Error (cleaned signal)
% 
% for n = 1:N
%     x_vec = x_full_pad(n+M-1:-1:n);       % Sliding window
%     y_full(n) = w' * x_vec;               % Estimated noise
%     e_full(n) = x(n) - y_full(n);         % Filtered output (speech)
% end
% 
% %% Play and save filtered audio
% sound(e_full, fs);
% audiowrite('Filtered_ManualLMS.wav', e_full, fs);
% disp('Filtered_ManualLMS.wav saved and playing.');
% 
% %% Time-domain comparison
% figure;
% subplot(2,1,1);
% plot(x);
% title('Original Signal (With Noise)');
% xlabel('Sample'); ylabel('Amplitude'); grid on;
% 
% subplot(2,1,2);
% plot(e_full);
% title('Filtered Signal (After Manual LMS)');
% xlabel('Sample'); ylabel('Amplitude'); grid on;
% 
% %% Spectrogram comparison
% figure;
% subplot(2,1,1);
% spectrogram(x, 1024, 512, 1024, fs, 'yaxis');
% title('Spectrogram of Original Signal');
% 
% subplot(2,1,2);
% spectrogram(e_full, 1024, 512, 1024, fs, 'yaxis');
% title('Spectrogram of Filtered Signal (Manual LMS)');








% clc;
% clear;
% 
% % --- Load audio file ---
% [x, fs] = audioread('Recording 8.wav');
% x = mean(x, 2);  % Convert to mono if stereo
% 
% % --- STFT parameters ---
% frameLen = 1024;            % Frame length
% overlap = frameLen / 2;     % Overlap between frames
% window = hamming(frameLen); % Window function
% 
% % --- Select noise-only segment (assumed first 1 second) ---
% noise_duration = 1; % seconds
% noise_samples = round(noise_duration * fs);
% noise_signal = x(1:noise_samples);
% 
% % Compute STFT of noise segment
% [S_noise, F, T_noise] = stft(noise_signal, fs, 'Window', window, 'OverlapLength', overlap, 'FFTLength', frameLen);
% noise_mag = abs(S_noise);
% mean_noise_mag = mean(noise_mag, 2); % Average noise magnitude spectrum
% 
% % Compute STFT of entire signal
% [S, F, T] = stft(x, fs, 'Window', window, 'OverlapLength', overlap, 'FFTLength', frameLen);
% S_mag = abs(S);
% S_phase = angle(S);
% 
% % --- Spectral Subtraction ---
% clean_mag = S_mag - mean_noise_mag;
% clean_mag(clean_mag < 0) = 0;  % Avoid negative magnitudes
% 
% % Reconstruct cleaned signal using original phase
% S_clean = clean_mag .* exp(1j * S_phase);
% [x_clean, ~] = istft(S_clean, fs, 'Window', window, 'OverlapLength', overlap, 'FFTLength', frameLen);
% 
% % Take real part to avoid complex data error in sound()
% x_clean = real(x_clean);
% 
% % --- Play and save cleaned audio ---
% sound(x_clean, fs);
% audiowrite('Recording8_Cleaned.wav', x_clean, fs);
% disp('Cleaned audio saved as Recording8_Cleaned.wav and playing now.');
% 
% % --- Plot time-domain signals ---
% figure;
% subplot(2,1,1);
% plot((1:length(x))/fs, x);
% title('Original Signal (Noisy)');
% xlabel('Time (seconds)');
% ylabel('Amplitude');
% grid on;
% 
% subplot(2,1,2);
% plot((1:length(x_clean))/fs, x_clean);
% title('Cleaned Signal (After Spectral Subtraction)');
% xlabel('Time (seconds)');
% ylabel('Amplitude');
% grid on;
% 
% % --- Plot spectrograms ---
% figure;
% subplot(2,1,1);
% spectrogram(x, window, overlap, frameLen, fs, 'yaxis');
% title('Spectrogram of Original Signal');
% 
% subplot(2,1,2);
% spectrogram(x_clean, window, overlap, frameLen, fs, 'yaxis');
% title('Spectrogram of Cleaned Signal');







% % Load the audio file
% [x, fs] = audioread('Recording 8.wav');  % x: audio data, fs: sampling frequency
% 
% % Duration of noise-only segment (first 4 seconds)
% noise_duration = 4;  
% samples_noise = fs * noise_duration;
% 
% % Extract noise-only segment (reference noise)
% x_noise = x(1:samples_noise);
% 
% % Total length of the audio signal
% N = length(x);
% 
% % Repeat the noise segment to create a reference noise signal the same length as the audio
% ref_noise = repmat(x_noise, ceil(N / samples_noise), 1);
% ref_noise = ref_noise(1:N);  % Trim to exact length
% 
% % The full noisy signal (including speech + noise)
% x_all = x;
% 
% % LMS filter parameters
% filter_length = 64;   % Number of taps in the adaptive filter
% step_size = 0.0005;   % Learning rate for the LMS algorithm
% 
% % Create the LMS filter object
% lms = dsp.LMSFilter('Length', filter_length, 'StepSize', step_size);
% 
% % Apply the LMS adaptive filter
% % Inputs: reference noise and noisy signal
% % Outputs: estimated noise and error (cleaned signal)
% [estimated_noise, cleaned_signal] = lms(ref_noise, x_all);
% 
% % Listen to the cleaned signal
% %sound(cleaned_signal, fs);
% 
% % Save the cleaned audio to a new file
% audiowrite('cleaned_output.wav', cleaned_signal, fs);
% 
% 
% % Time vector for plotting
% t = (0:N-1) / fs;
% 
% % Plot original noisy signal vs cleaned signal
% figure;
% subplot(2,1,1);
% plot(t, x_all);
% title('Original Noisy Signal');
% xlabel('Time (seconds)');
% ylabel('Amplitude');
% 
% subplot(2,1,2);
% plot(t, cleaned_signal);
% title('Cleaned Signal After LMS Filtering');
% xlabel('Time (seconds)');
% ylabel('Amplitude');
% 
% % Zoom in to a short segment (e.g. 0.5 seconds) for clearer comparison
% segment_duration = 0.5; % seconds
% segment_samples = round(segment_duration * fs);
% 
% figure;
% subplot(2,1,1);
% plot(t(1:segment_samples), x_all(1:segment_samples));
% title(['Zoomed-in Original Signal (First ', num2str(segment_duration), ' seconds)']);
% xlabel('Time (seconds)');
% ylabel('Amplitude');
% 
% subplot(2,1,2);
% plot(t(1:segment_samples), cleaned_signal(1:segment_samples));
% title(['Zoomed-in Cleaned Signal (First ', num2str(segment_duration), ' seconds)']);
% xlabel('Time (seconds)');
% ylabel('Amplitude');
% 
% % Plot spectrograms
% window = 256;
% noverlap = round(0.75 * window);
% nfft = 512;
% 
% figure;
% subplot(2,1,1);
% spectrogram(x_all, window, noverlap, nfft, fs, 'yaxis');
% title('Spectrogram of Original Noisy Signal');
% 
% subplot(2,1,2);
% spectrogram(cleaned_signal, window, noverlap, nfft, fs, 'yaxis');
% title('Spectrogram of Cleaned Signal After LMS Filtering');














