tic();
clear;
##http://www.apsipa.org/proceedings_2012/papers/375.pdf

#### Lectura
#### Distintos audios en samples/
##[song, fm] = audioread("samples/opera-vocals_129bpm_F_minor.wav");
##[song, fm] = audioread("samples/middle-east-girl_120bpm_C_minor.wav");
##[song, fm] = audioread("samples/grim-reaper.wav");
[song, fm] = audioread("samples/our-last-dance.wav");
##[song, fm] = audioread("samples/old-full.wav");
##[song, fm] = audioread("test.wav");

song_length= length(song);
t = 0:1/fm: song_length - 1/fm;


## Windows =======================================================
window_length = 1024; %Largo Ventana.
left = song(1:window_length); %Ventana mas vieja.
center = song(window_length:(window_length*2)-1);
right = song(window_length*2:(window_length*3)-1); %Ventana mas nueva.
old_pitch = [0 0 0]; %vector para almacenar ultimos 3 pitches.
output_vector = []; %vector de salida.
dpitchs = []; %pitch detectados.
cpitchs = []; %pitch corregidos.

%COSAS ===========================================================
scale = 1; %multiplica la frecuencia corregida (mantiene duracion)
filterPB = true; %Aplica el filtro PB.
reverb = true; %eco
  ##reverb
  delay_times = [0.6]; % delay del eco;
  gains = [0.2]; % ganancia del eco;
resample = false; %no usar
bad_singer = false; %mejora un poco no mucho
overlap = 1; % ! afecta duracion;

% Filtro PB para quitar ruido
 pkg load signal;
 cutoff_frequency = 2000;
 normalized_cutoff = cutoff_frequency / (fm / 2);
 [b, a] = butter(6, normalized_cutoff, 'low');

% Bucle principal=====================================================
i = 3;
while(i*window_length<song_length)

    %Pitch detection and correction.
    [dpitch, cpitch, window] = pitch(left, center, right, fm, 2, old_pitch, bad_singer);


    %Guarda los pitches.
    dpitchs = [dpitchs dpitch];
    cpitchs = [cpitchs cpitch];

    %Aplica psola para generar ventana con pitch corregido.
    output = psola(window, dpitch, cpitch, fm);


    %Aplica el filtro anti ruido (maso).
    if(filterPB)
          output = filter(b, a, output);
    endif
    %Concatena la salida.
    output_vector = [output_vector output];

    %Avanza las ventanas.
    left = center;
    center = right;
    right = song(i*window_length:(i+1)*window_length-1);

    %Guarda el pitch.
    old_pitch  = [old_pitch(2:end) cpitch];
    i += 1;
endwhile

% Reverb==================================================
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

%Normaliza (nose porque)======================================
output_vector = output_vector/max(abs(output_vector));

%Escribe la salida============================================
audiowrite('test.wav',output_vector,fm);

