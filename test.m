% Example signal (sine wave with added noise)
fm = 41000; % Sampling frequency
t = 0:1/fm:1-1/fm; % Time vector
f0 = 23; % Frequency of the sine wave (A4 note)
signal = sin(2 * pi * f0 * t); % Noisy sine wave  + 0.1 * randn(size(t))

% Window function (Hamming)
##window = hamming(length(signal))';

% Pitch detection parameters
min_lag = 50; % Minimum lag
max_lag = 1000; % Maximum lag
plot(signal(1:1024));
% Call the pitch detector function
pitch = yin(signal, 1024, 1, fm, min_lag, max_lag);
disp(['Detected pitch: ', num2str(pitch)]);
