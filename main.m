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
windows_number = ceil(((song_lenght - window_lenght)/step)+1);
hanning_window = hanning(1024)';
windows = zeros(window_lenght,windows_number);
pitch = [];
db = 0; #debug

for i=1:windows_number
  display(['window n°: ', num2str(i),'/', num2str(window_number)]);
  windows(:,i) = song(1+((i-1)*step):(window_lenght+((i-1)*step))).*hanning_window;
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

##PSOLA ??
p1nfm = 0;
p2nfm = 0;
new_song = zeros(1,2*song_lenght);
for(i=1:windows_number-2)
  display(['window n°: ', num2str(i),'/', num2str(window_number)]);

  nfm = (corrected(i)*fm)/pitch(i);

  if(i>2)
    if(nfm > p2nfm + p1nfm)
      nfm = p1nfm;
    endif
  endif

  p2nfm = p1nfm;
  p1nfm = nfm;

  paso = (i-1)*step*2;
  if (pitch(i) == 0)
    for(j=1:window_lenght)
      new_song(1+paso+(2*(j-1))) += windows(j,i);
    endfor
  else
    for(j=1:window_lenght)
    new_song(round(1+paso+(2*(j-1)*(1/(nfm/fm))))) += windows(j,i);
    endfor
  endif
endfor

audiowrite('test.wav',new_song,2*fm);






