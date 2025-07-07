[x, fs] = audioread("Recording 8.wav");

sound(x, fs);

% Plot signal in time domain
figure;
plot(x);
title('Recorded Noisy Signal (Time Domain)');
xlabel('Sample');
ylabel('Amplitude');
grid on;

% Plot spectrogram
figure;
spectrogram(x, 1024, 512, 1024, fs, 'yaxis');
title('Spectrogram of Recorded Signal');

