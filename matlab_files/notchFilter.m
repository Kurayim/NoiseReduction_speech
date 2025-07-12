[x, fs] = audioread("Recording 8.wav");


f0 = 200;
bw = 1000;
w0 = f0/(fs/2);
bw_norm = bw/(fs/2);
[b, a] = iirnotch(w0, bw_norm);

x_notched = filtfilt(b, a, x);
%sound(x_notched, fs);
audiowrite('NotchedAudio.wav', x_notched, fs);





figure;
subplot(2,1,1);
plot(x);
title('Original Noisy Signal');
xlabel('Sample');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(x_notched);
title('Signal after Notch Filter');
xlabel('Sample');
ylabel('Amplitude');
grid on;


figure;
subplot(2,1,1);
spectrogram(x, 1024, 512, 1024, fs, 'yaxis');
title('Spectrogram of Original Noisy Signal');

subplot(2,1,2);
spectrogram(x_notched, 1024, 512, 1024, fs, 'yaxis');
title('Spectrogram after Notch filter');





