pkg load signal;
#### Lectura
##[song, fm] = audioread("samples/opera-vocals_129bpm_F_minor.wav");
tic();
##[song, fm] = audioread("samples/middle-east-girl_120bpm_C_minor.wav");
[song, fm] = audioread("samples/grim-reaper.wav");

song_lenght= length(song);

t = 0:1/fm: song_lenght - 1/fm;

#### Pitch detection algorithm
## Windows

window_lenght = 1024;
step = 512;
window_number = ((song_lenght - window_lenght)/step)+1;

pitch = [];
db = 0; #debug
for i=1:window_number
  display(['window n°: ', num2str(i),'/', num2str(window_number)]);
  pitch = [pitch yin(song, window_lenght, ((i-1)*step)+ 1, fm, 60, 1000,db)];
  clc;
endfor

plot(pitch)
corrected = [];
corrected = [corrected tone(pitch(1),inf,inf)];
corrected = [corrected tone(pitch(2),inf,inf)];

for i=3:window_number
  corrected = [corrected tone(pitch(i),corrected(end),corrected(end-1))];
endfor

display('Terminado');
display(['Tiempo transcurrido: ', num2str(toc()), 's']);

##

