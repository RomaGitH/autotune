tic();
clear;
% Basado en this paper.
##http://www.apsipa.org/proceedings_2012/papers/375.pdf

% Lectura ======================================================================

#### Distintos audios en samples/
##[song, fm] = audioread("samples/opera-vocals_129bpm_F_minor.wav");
####[song, fm] = audioread("samples/middle-east-girl_120bpm_C_minor.wav");
##[song, fm] = audioread("samples/grim-reaper.wav");
[song, fm] = audioread("samples/our-last-dance.wav");
##song = song(:,2)';
##[song, fm] = audioread("samples/old-full.wav");
##[song, fm] = audioread("samples/another-verse.wav");
##[song, fm] = audioread("test.wav");
##song = song';

% Grabar =======================================================================

##
##display('Recording...');
##fm = 44100; %Frecuencia de muestreo.
##t = 20; %Tiempo de grabacion.
##song = record(t,fm);
##song = song';
##display('Recording Finish');
##
##

## Windows =====================================================================

song_length= length(song);
window_length = 1024; %Largo Ventana.
left = song(1:window_length); %Ventana mas vieja.
center = song(window_length:(window_length*2)-1);
right = song(window_length*2:(window_length*3)-1); %Ventana mas nueva.
old_pitch = [0 0 0]; %vector para almacenar ultimos 3 pitches.
output_vector = []; %vector de salida.
dpitchs = []; %pitch detectados.
cpitchs = []; %pitch corregidos.

%COSAS =========================================================================

scale = 1.33; %multiplica la frecuencia corregida (mantiene duracion)
filterPB = true; %Aplica el filtro PB.
reverb = true; %eco
  ##reverb
  delay_times = [0.1]; % delay del eco.
  gains = [0.2]; % ganancia del eco.
overlap = window_length*0.75; %overlap entre outputs.

% Filtro PB para quitar ruido
 pkg load signal;
 cutoff_frequency = 5400;
 normalized_cutoff = cutoff_frequency / (fm / 2);
 [b, a] = butter(7, normalized_cutoff, 'low');

% Bucle principal===============================================================
i = 3;
display('Proccessing...');

while((i+1)*window_length<song_length)

    %Pitch detection and correction.
    [dpitch, cpitch, window] = pitch(left, center, right, fm, scale, old_pitch);

    %Guarda los pitches.
    dpitchs = [dpitchs dpitch];
    cpitchs = [cpitchs cpitch];

    %Aplica psola para generar ventana con pitch corregido.
    output = psola(window, dpitch, cpitch, fm, overlap);

    %Concatena la salida.
    if(i==3)
       output_vector = [output_vector output];
    else
      if(overlap != 0)
        blend = output_vector(end-overlap+1:end) + output(1:overlap);
        output_vector = [output_vector(1:end-overlap) blend output(overlap+1:end)];
      else
         output_vector = [output_vector output];
      endif
    endif

    %Avanza las ventanas.
    left = center;
    center = right;
    right = song(i*window_length:(i+1)*window_length-1);

    %Guarda el pitch.
    old_pitch  = [old_pitch(2:end) cpitch];
    i += 1;
endwhile

display('Finished...');
% Reverb========================================================================
if(reverb)

  % delay (s) -> delay (samples).
  delay_samples = round(delay_times * fm);

  % Bucle.
  for i = 1:length(delay_samples)
      delay = delay_samples(i);
      gain = gains(i);

      % Genera señal con delay.
      delayed_signal = [zeros(1, delay) output_vector(1:end-delay)] * gain;

      % Agrega a la salida.
      output_vector = output_vector + delayed_signal;
  end
endif


display('Writing...');
display(['Tiempo: ',num2str(toc()), ' s']);

%Escribe la salida==============================================================

    %Aplica el filtro anti ruido (maso).
    if(filterPB)
          output_vector = filter(b, a, output_vector);
    endif

%Normaliza (nose porque)========================================================
output_vector = output_vector/max(abs(output_vector));

audiowrite('test.wav',output_vector,fm);

