clc;
clear;

%% Load audio file
[x, fs] = audioread('Recording 8.wav');   % x: original signal (speech + noise)
N = length(x);                            % Total number of samples

%% Training (first 4 seconds)
t_train = 4;                              % Training time in seconds
samples_train = round(t_train * fs);      % Number of samples in training window

d_train = x(1:samples_train);             % Desired signal (speech + noise)
x_ref = x(1:samples_train);               % Reference noise

%% LMS filter parameters
M = 64;                                   % Filter order (number of taps)
mu = 0.03;                                % Learning rate
w = zeros(M, 1);                          % Initial filter weights

% Zero-padding input
x_pad = [zeros(M-1,1); x_ref];  
e_train = zeros(samples_train,1);         % Error vector for training

%% Training loop
for n = 1:samples_train
    x_vec = x_pad(n+M-1:-1:n);            % Input vector (sliding window)
    y = w' * x_vec;                       % Filter output
    e_train(n) = d_train(n) - y;          % Error (desired - output)
    w = w + mu * x_vec * e_train(n);      % Update weights
end

%% Apply fixed filter to entire signal
x_full_pad = [zeros(M-1,1); x];           % Zero-padded full input
y_full = zeros(N,1);                      % Output (estimated noise)
e_full = zeros(N,1);                      % Error (cleaned signal)

for n = 1:N
    x_vec = x_full_pad(n+M-1:-1:n);       % Sliding window
    y_full(n) = w' * x_vec;               % Estimated noise
    e_full(n) = x(n) - y_full(n);         % Filtered output (speech)
end

%% Play and save filtered audio
sound(e_full, fs);
audiowrite('Filtered_ManualLMS.wav', e_full, fs);
disp('Filtered_ManualLMS.wav saved and playing.');

%% Time-domain comparison
figure;
subplot(2,1,1);
plot(x);
title('Original Signal (With Noise)');
xlabel('Sample'); ylabel('Amplitude'); grid on;

subplot(2,1,2);
plot(e_full);
title('Filtered Signal (After Manual LMS)');
xlabel('Sample'); ylabel('Amplitude'); grid on;

%% Spectrogram comparison
figure;
subplot(2,1,1);
spectrogram(x, 1024, 512, 1024, fs, 'yaxis');
title('Spectrogram of Original Signal');

subplot(2,1,2);
spectrogram(e_full, 1024, 512, 1024, fs, 'yaxis');
title('Spectrogram of Filtered Signal (Manual LMS)');













