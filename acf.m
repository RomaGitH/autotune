## Autocorrelation function.
## Paso 1.
function x = acf(f, window, t, lag)
##  x = f(t:t+window) * (f(lag + t: lag + t + window))';

function x = acf_fft(f, window, t, lag)
    % Extract the sub-sequences for autocorrelation
    subsequence1 = f(t : t + window);
    subsequence2 = f(lag + t : lag + t + window);

    % Compute FFT of the subsequences
    fft_subsequence1 = fft(subsequence1);
    fft_subsequence2 = fft(subsequence2);

    % Compute complex conjugate of the FFT of the second subsequence
    fft_subsequence2_conj = conj(fft_subsequence2);

    % Multiply the FFTs element-wise
    fft_product = fft_subsequence1 .* fft_subsequence2_conj;

    % Take the inverse FFT of the product
    x = ifft(fft_product);

    % Return the autocorrelation value
    x = x(lag); % Only the first element is needed since we're computing at lag 0

end

endfunction
