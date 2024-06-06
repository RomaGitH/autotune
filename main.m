pkg load signal;
tic();
#### Lectura
#### Distintos audios en samples/
##[song, fm] = audioread("samples/opera-vocals_129bpm_F_minor.wav");
##[song, fm] = audioread("samples/middle-east-girl_120bpm_C_minor.wav");
[song, fm] = audioread("samples/grim-reaper.wav");

song_lenght= length(song);
t = 0:1/fm: song_lenght - 1/fm;

#### Pitch detection algorithm
## Windows

window_lenght = 1024;
step = 512;
windows_number = floor(((song_lenght - window_lenght)/step));
hanning_window = hanning(1024)';
windows = zeros(window_lenght,windows_number); #inicializo el vector de m ventanas de n tamaño
pitch = []; #vector del pitch detectado de cada ventana

windows(:,1) = song(1:window_lenght).*hanning_window;
pitch = [pitch yin(windows(:,1), window_lenght, fm)];
## Primero ventaneo y despues?
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
##figure(2);
##subplot(3,1,1);
##plot(pitch);
##subplot(3,1,2);
##plot(corrected);
##subplot(3,1,3);
##plot(pitch);
##hold on;
##plot(corrected);
##hold off;


##
debug = 1;
new_song = zeros(song_lenght,1);
i = 1;
while (i < windows_number)

  old_f0 = pitch(i);
##  new_f0 = corrected(i);
  new_f0 = pitch(i)*2;

  shift_factor = new_f0 / old_f0;
  up_shift = true;
  no_shift = false;

##  if(debug == i)
##    display('ok');
##  else
##    display(['error :',num2str(i),'!=', num2str(debug)]);
##    debug = i;
##  endif

  if(old_f0 == 0 || shift_factor == 1)
    no_shift = 1;
  endif

  if (shift_factor > 1)
    shift_factor =  shift_factor - 1;
  else
    shift_factor = 1 - shift_factor;
    up_shift = false; %Downshift
  endif

  if(!no_shift)

##          disp('shift');
    shift_factor = shift_factor * 100;
    window_a = i;
    window_b = i;
    window_pitch = corrected(i);


    while corrected(window_b) == window_pitch
      window_b += 1;
      if(window_b > windows_number) break endif;
    endwhile
    debug = i;
    pitch_lenght = window_b-window_a;
    shift_factor = pitch_lenght/shift_factor;

    for(j=1:33333333)
      k = window_a-1+j;

      if( k > windows_number) break endif;
      if(j > shift_factor)
        shift_factor = shift_factor*2;
        if(up_shift)
          disp('upshift');
          new_song((k*step)+1:(k*step)+1024) =  new_song((k*step)+1:(k*step)+1024) + windows(:,k);
        endif
        else
        new_song(((k-1)*step)+1:((k-1)*step)+1024) = new_song(((k-1)*step)+1:((k-1)*step)+1024) + windows(:,k);
      endif
    endfor
    i += pitch_lenght;
  else
    new_song(((i-1)*step)+1:((i-1)*step)+1024) = new_song(((i-1)*step)+1:((i-1)*step)+1024) + windows(:,i);
    debug = i;
    i +=1;
  endif
endwhile

##Plot de el pitch detectado y el corregido.
figure(1);
subplot(3,1,1);
plot(song);
subplot(3,1,2);
plot(new_song);
subplot(3,1,3);
plot(pitch);
hold on;
plot(corrected);
hold off;


audiowrite('test.wav',new_song,fm);
##
##
##
##
##

