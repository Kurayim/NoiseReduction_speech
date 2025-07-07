[x, fs] = audioread("Recording 8.wav");  % Read the audio file

% Design a low-pass Butterworth filter
fc = 2000;                      % Cut-off frequency (Hz)
order = 6;                      % Filter order
[b, a] = butter(order, fc/(fs/2), "low");  % Normalize cut-off and design filter

% Apply zero-phase filtering to avoid phase distortion
x_filtered = filtfilt(b, a, x);

% Play the filtered audio
sound(x_filtered, fs);
disp("Playing filtered audio...");

% Save the filtered audio to a new file
audiowrite('FilteredAudio.wav', x_filtered, fs);

% Plot original and filtered signals in time domain
figure;
subplot(2,1,1);
plot(x);
title('Original Noisy Signal');
xlabel('Sample');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(x_filtered);
title('Filtered Signal');
xlabel('Sample');
ylabel('Amplitude');
grid on;

% Plot spectrograms before and after filtering
figure;
subplot(2,1,1);
spectrogram(x, 1024, 512, 1024, fs, 'yaxis');
title('Spectrogram of Original Noisy Signal');

subplot(2,1,2);
spectrogram(x_filtered, 1024, 512, 1024, fs, 'yaxis');
title('Spectrogram of Filtered Signal');
