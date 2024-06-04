% Example signal (sine wave with added noise)
fm = 48000; % Sampling frequency
t = 0:1/fm:1-1/fm; % Time vector
pitch = [];
for (f0=80:1000)
   signal = sin(2 * pi * f0 * t); % Noisy sine wave  + 0.1 * randn(size(t))

  % Window function (Hamming)
##  window = hamming(length(signal))';
##  signal = signal .* window;

  pitch = [pitch yin(signal, 1024,fm)];
##  disp(['Detected pitch: ', num2str(pitch)]);
endfor
plot(80:1000,pitch);

