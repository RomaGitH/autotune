pkg load signal;
tic();
#### Lectura
#### Distintos audios en samples/
##[song, fm] = audioread("samples/opera-vocals_129bpm_F_minor.wav");
##[song, fm] = audioread("samples/middle-east-girl_120bpm_C_minor.wav");
[song, fm] = audioread("samples/grim-reaper.wav");

song_length= length(song);
t = 0:1/fm: song_length - 1/fm;

#### Pitch detection algorithm
## Windows

window_length = 256;
step = 128;
windows_number = floor(((song_length - window_length)/step));
hanning_window = hanning(window_length)';
windows = zeros(window_length,windows_number); #inicializo el vector de m ventanas de n tamaño
pitch = []; #vector del pitch detectado de cada ventana

windows(:,1) = song(1:window_length).*hanning_window;
pitch = [pitch yin(windows(:,1), window_length, fm)];
## Primero ventaneo y despues?
for i=2:windows_number
  ##console
  display(['window n°: ', num2str(i),'/', num2str(windows_number)]);

  ## defino intervalo y multiplico por la ventana
  windows(:,i) = song(1+((i-1)*step):(window_length+((i-1)*step))).*hanning_window;
  f0 = yin(windows(:,i), window_length, fm, windows(:,i-1)); #yin (recibe dos ventanas) no mejora nada...
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


##Time Stretch--pitch shift...
pitch_shift_factor = 3;
overlap = 128-(8*pitch_shift_factor);

new_length = (window_length)*windows_number; %1.5*original
new_step = (step*2)-overlap;
new_song = zeros(new_length,1);
##new_song = [];

##for i=1:windows_number-1
##    new_song((i-1)*new_step+1:(i-1)*new_step+(window_length)) += windows(:,i);
##endfor
k = 1;
for i=1:windows_number-1

   if(mod(i,pitch_shift_factor) != 0)
      new_song((k-1)*window_length+1:(k-1)*(window_length)+window_length) += windows(:,i);
      k += 1;
   endif

endfor
new_song = new_song(1:k*window_length);

##new_song = new_song / max(abs(new_song));


audiowrite('test.wav',new_song,fm);

##sfafaaudiowrite('test.wav',new_song,(1+pitch_shift_factor/15)*fm);

##
##while (i < windows_number)
##
##  old_f0 = pitch(i);
##  new_f0 = corrected(i);
##
##  shift_factor = new_f0 / old_f0;
##  up_shift = true;
##  no_shift = false;
##
##  if(old_f0 == 0 || shift_factor == 1)
##    no_shift = 1;
##  endif
##
##  if (shift_factor > 1)
##    shift_factor =  shift_factor - 1;
##  else
##    shift_factor = 1 - shift_factor;
##    up_shift = false; %Downshift
##  endif
##
##  if(!no_shift)
##
##    shift_factor = shift_factor * 50;
##    window_a = i;
##    window_b = i;
##    window_pitch = corrected(i);
##
##
##    while corrected(window_b) == window_pitch
##      window_b += 1;
##      if(window_b > windows_number) break endif;
##    endwhile
##    debug = i;
##    pitch_lenght = window_b-window_a;
##    shift_factor = pitch_lenght/shift_factor;
##
##    for(j=1:pitch_lenght)
##      k = window_a-1+j;
##
##
##    endfor
##    i += pitch_lenght;
##  else
##    new_song(((i-1)*step)+1:((i-1)*step)+window_length) = new_song(((i-1)*step)+1:((i-1)*step)+window_length) + windows(:,i);
##    debug = i;
##    i +=1;
##  endif
##endwhile

####PSOLA...
##
##new_song = zeros(song_lenght,1);
##i = 1;
##while (i < windows_number)
##
##  old_f0 = pitch(i);
##  new_f0 = corrected(i);
##
##  shift_factor = new_f0 / old_f0;
##  up_shift = true;
##  no_shift = false;
##
##  if(old_f0 == 0 || shift_factor == 1)
##    no_shift = 1;
##  endif
##
##  if (shift_factor > 1)
##    shift_factor =  shift_factor - 1;
##  else
##    shift_factor = 1 - shift_factor;
##    up_shift = false; %Downshift
##  endif
##
##  if(!no_shift)
##
##    shift_factor = shift_factor * 50;
##    window_a = i;
##    window_b = i;
##    window_pitch = corrected(i);
##
##
##    while corrected(window_b) == window_pitch
##      window_b += 1;
##      if(window_b > windows_number) break endif;
##    endwhile
##    debug = i;
##    pitch_lenght = window_b-window_a;
##    shift_factor = pitch_lenght/shift_factor;
##
##    for(j=1:pitch_lenght)
##      k = window_a-1+j;
##
##      if( k > windows_number) break endif;
##      if(j > shift_factor)
##        shift_factor = shift_factor*2;
##        if(up_shift)
##          new_song((k*step)+1:(k*step)+window_length) =  new_song((k*step)+1:(k*step)+window_length) + windows(:,k);
##        endif
##        else
##        new_song(((k-1)*step)+1:((k-1)*step)+window_length) = new_song(((k-1)*step)+1:((k-1)*step)+window_length) + windows(:,k);
##      endif
##    endfor
##    i += pitch_lenght;
##  else
##    new_song(((i-1)*step)+1:((i-1)*step)+window_length) = new_song(((i-1)*step)+1:((i-1)*step)+window_length) + windows(:,i);
##    debug = i;
##    i +=1;
##  endif
##endwhile

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


##
##
##
##
##

