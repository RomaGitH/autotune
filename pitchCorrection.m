# Funcion de correcion de frecuencia fundamental.
# Retorna la nota musical más cercana.
# Recibe x (el valor a evaluar) y dos valores previos).

function y = pitchCorrection(x, prev1, prev2)
  if (x == 0)
    y=0;  # Caso x = 0;
  elseif (abs(x-prev2) > prev1&& prev1*prev2 > 0)
    y = prev1;  # Intento de corregir phonemas sordos
    ## no funciona
  else
    piano_notes_freq = [
      % Octave 3
      65.406,  % C3
      69.296,  % C#3/Db3
      73.416,  % D3
      77.782,  % D#3/Eb3
      82.407,  % E3
      87.307,  % F3
      92.499,  % F#3/Gb3
      97.999,  % G3
      103.826, % G#3/Ab3
      % Octave 4
      110.0,  % A4 (Middle A)
      116.541, % A#4/Bb4
      123.471, % B4
      % Octave 5
      130.813, % C5
      138.591, % C#5/Db5
      146.832, % D5
      155.563, % D#5/Eb5
      164.814, % E5
      174.614, % F5
      184.997, % F#5/Gb5
      195.998, % G5
      207.652, % G#5/Ab5
      % Octave 6
      220.0,  % A6
      233.082, % A#6/Bb6
      246.942, % B6
      % Octave 7
      261.626, % C7
      277.183, % C#7/Db7
      293.665, % D7
      311.127, % D#7/Eb7
      329.628, % E7
      349.228, % F7
      369.994, % F#7/Gb7
      391.995, % G7
      415.305, % G#7/Ab7
      % Octave 8
      440.0,  % A8
      466.164, % A#8/Bb8
      493.883, % B8
      % Octave 9
      523.251, % C8
      554.365, % C#8/Db8
      587.33,  % D8
      622.254, % D#8/Eb8
      659.255, % E8
      698.456, % F8
      739.989, % F#8/Gb8
      783.991, % G8
      830.609, % G#8/Ab8
      % Octave 10
      880.0,  % A9
      932.328, % A#9/Bb9
      987.767, % B9
      % Octave 11
      1046.502 % C10
    ];

    ##Busco la pos de la minima diferencia en valor absoluto.
    [~,pos] = min(abs(piano_notes_freq-x));
    ## Retorno la f más cercana a f0
    y = piano_notes_freq(pos);
  endif;
endfunction
