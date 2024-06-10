function output = psola(win, dpitch, cpitch, fm)
  l = length(win)/2; %2L window
  output = zeros(1,l); %inicializa la salida de duracion L.

  if (cpitch == 0) %Silencio -> f0 = 0;
    output = zeros(1,l);
    return;
  endif
  cpp = round((1/cpitch)* fm); %f0' (hz) -> f0' (samples).

  if (dpitch < 80) % No se puede cantar a menos de 80 hz...
      output = zeros(1,l);
    return;
  else
    dpp = round((1/dpitch)* fm); %f0 (hz) -> f0 (samples).
  endif

  % Detecta el primer pico para centrar las ventanas
  % en estos picos.
  [~, first_peak] = max(win((l/2) +1:(l/2) + 1 +dpp));

  % Define posicion inicial.
  start_pos = (l/2) + first_peak - floor(dpp/2);


  if(start_pos <0)
    start_pos = l - l/2; %en caso que falle la deteccion de picos.
  endif

  %Extraccion de grains=========================================================

  n = 1; %Numero de periodos en la ventana.
  while(n < 1024/cpp)
    n += 1;
  endwhile

  windows = zeros(n, cpp); %Genera matriz de n ventanas de cpp samples.
  samples = 1; %Lleva cuenta de los samples necesarios para mantener la duracion.
  i = 1;
  while ((samples < 1025) )

    if(start_pos+(i-1)*dpp+cpp>2048)
      new = windows(i-1,:); %Si se pasa de la ventana, duplica la ultima.
    else
      new = win(start_pos+(i-1)*dpp:start_pos+(i-1)*dpp+cpp-1);
      %extrae cpp muestras cada dpp.
    endif
    windows(i,:) =  new; %Agrega a la matriz.
    samples += cpp; %Actualiza samples.
    i += 1;
  endwhile



  #Overlap-add==================================================================

  overlap = cpp-dpp; %Overlap necesario para lograr el shift deseado.

  h_win = hanning(cpp)'; %Se suaviza con Hanning windows.
  for(k=1:n)
    windows(k,:) = windows(k,:) .* h_win;
  endfor


  if(cpp>1024)
    output = win(1,:); %Problemas en frecuencias bajas (<100hz).
    else
    output(1:cpp) += windows(1,:); %Suma la primer Ventana.
  endif

  %Por cada ventana suma y pisa... si overlap>0 -> f0++
  %                                si overlap<0 -> f0--
  for j=2:n
    if((1+cpp*(j-1)-overlap)> 1024-cpp+1) break; endif;
##    if(overlap>0)
      output(1+cpp*(j-1)-overlap:1+cpp*(j-1)+cpp-overlap-1) += windows(j,:);
##    else
##      output(1+cpp*(j-1)-overlap:1+cpp*(j-1)+cpp-overlap-1) += windows(j,:);
##    endif
  endfor



endfunction
