pkg load signal;
tic();
#### Lectura
#### Distintos audios en samples/
##[song, fm] = audioread("samples/opera-vocals_129bpm_F_minor.wav");
[song, fm] = audioread("samples/middle-east-girl_120bpm_C_minor.wav");
##[song, fm] = audioread("samples/grim-reaper.wav");

song_lenght= length(song);
t = 0:1/fm: song_lenght - 1/fm;

#### Pitch detection algorithm
## Windows

window_lenght = 1024;
step = 512;
windows_number = ceil(((song_lenght - window_lenght)/step)+1);
hanning_window = hanning(1024)';
windows = zeros(window_lenght,windows_number); #inicializo el vector de m ventanas de n tamaño
pitch = []; #vector del pitch detectado de cada ventana

windows(:,1) = song(1:window_lenght).*hanning_window;
pitch = [pitch yin(windows(:,1), window_lenght, fm)];
for i=2:windows_number
  ##console
  display(['window n°: ', num2str(i),'/', num2str(windows_number)]);

  ## defino intervalo y multiplico por la ventana
  windows(:,i) = song(1+((i-1)*step):(window_lenght+((i-1)*step))).*hanning_window;
  f0 = yin(windows(:,i), window_lenght, fm, windows(:,i-1)); #yin (recibe dos ventanas) no mejora nada...
  pitch = [pitch f0];
endfor


## Calculo vector de pitch corregidos. no arregla sordos ni tampoco funciona...
corrected = [];
corrected = [corrected pitchCorrection(pitch(1),inf,inf)]; #inicializo 2 valores.
corrected = [corrected pitchCorrection(pitch(2),inf,inf)];

for i=3:windows_number
  corrected = [corrected pitchCorrection(pitch(i),corrected(end),corrected(end-1))];
endfor

##Console.
display('Terminado');
display(['Tiempo transcurrido: ', num2str(toc()), 's']);

#Plot de el pitch detectado y el corregido.
figure(2);
subplot(3,1,1);
plot(pitch);
subplot(3,1,2);
plot(corrected);
subplot(3,1,3);
plot(pitch);
hold on;
plot(corrected);
hold off;

##
####PSOLA ?? no anda
##p1nfm = 0;
##p2nfm = 0;
##new_song = zeros(1,2*song_lenght);
##for(i=1:windows_number-2)
##  display(['window n°: ', num2str(i),'/', num2str(windows_number)]);
##
##  nfm = (corrected(i)*fm)/pitch(i);
##
##  if(i>2)
##    if(nfm > p2nfm + p1nfm)
##      nfm = p1nfm;
##    endif
##  endif
##
##  p2nfm = p1nfm;
##  p1nfm = nfm;
##
##  paso = (i-1)*step;
##  if (pitch(i) == 0)
##    for(j=1:window_lenght)
##      new_song(1+paso+(2*(j-1))) += windows(j,i);
##    endfor
##  else
##    for(j=1:window_lenght)
##    new_song(round(1+paso+(2*(j-1)*(1/(nfm/fm))))) += windows(j,i);
##    endfor
##  endif
##endfor
##
##audiowrite('test.wav',new_song,fm*2);
##
##
##
##
##

