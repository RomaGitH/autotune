pkg load signal;
tic();
#### Lectura
#### Distintos audios en samples/
##[song, fm] = audioread("samples/opera-vocals_129bpm_F_minor.wav");
clear;
[song, fm] = audioread("samples/middle-east-girl_120bpm_C_minor.wav");
##[song, fm] = audioread("samples/grim-reaper.wav");

song_length= length(song);
t = 0:1/fm: song_length - 1/fm;

#### Pitch detection algorithm
## Windows

window_length = 1024;
hanning_window = hanning(window_length)';

left = song(1:1023);
center = song(1024:2047);
right = song(2048:3071);
output_vector = [];
dpitchs = [];
cpitchs = [];
i = 3;
while(i*1024<song_length)

    [dpitch, cpitch] = pitch(left, center, right, fm, 1);

    dpitchs = [dpitchs dpitch];
    cpitchs = [cpitchs cpitch];

    output = psola(center, dpitch, cpitch, fm);
    output_vector = [output_vector output];

    left = center;
    center = right;
    right = song(i*1024:(i+1)*1024-1);

    i += 1;
endwhile
audiowrite('test.wav',output_vector,fm);


