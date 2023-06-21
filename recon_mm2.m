function [reconstructed_image, compression_ratio, snr] = recon_mm2(image_name, num_levels, threshold)
    % Wczytaj obrazek
    image = imread(image_name);
    
    % Konwertuj obrazek na skalę szarości, jeśli jest kolorowy
    if size(image, 3) > 1
        image = rgb2gray(image);
    end
    
    % Wykonaj dekompozycję falkową na num_levels poziomów
    [C, S] = wavedec2(image, num_levels, 'haar');
    
    % Inicjalizuj macierze do przechowywania progowanych współczynników
    thresholded_C = cell(1, num_levels+1);
    
    % Progowanie dla każdego poziomu dekompozycji
    for i = 1:num_levels
        % Wyznacz próg dla danego poziomu dekompozycji
        level_threshold = threshold_selection(C(S(i, 1):S(i, 2), S(i, 3):S(i, 4)), threshold);
        
        % Progowanie twarde i miękkie
        thresholded_C{i} = hard_threshold(C(S(i, 1):S(i, 2), S(i, 3):S(i, 4)), level_threshold);
        %thresholded_C{i} = soft_threshold(C(S(i, 1):S(i, 2), S(i, 3):S(i, 4)), level_threshold);
    end
    
    % Rekonstrukcja obrazu z progowanych współczynników
    reconstructed_image = waverec2([thresholded_C{:}], S, 'haar');
    
    % Oblicz stopień kompresji
    original_size = numel(image);
    compressed_size = sum(cellfun(@numel, thresholded_C));
    compression_ratio = original_size / compressed_size;
    
    % Oblicz stosunek sygnału do szumu (SNR) dla zrekonstruowanego obrazu
    noise = image - reconstructed_image;
    signal_power = sum(image(:).^2) / numel(image);
    noise_power = sum(noise(:).^2) / numel(noise);
    snr = 10 * log10(signal_power / noise_power);
end

function level_threshold = threshold_selection(approximation, global_threshold)
    % Analiza zawartości szumu w aproksymacji
    noise_std = std2(approximation);
    
    % Wyznaczanie progu dla danego poziomu dekompozycji
    level_threshold = global_threshold * noise_std;
end

function thresholded_coeffs = hard_threshold(coeffs, threshold)
    % Progowanie twarde
    thresholded_coeffs = coeffs .* (abs(coeffs) >= threshold);
end

function thresholded_coeffs = soft_threshold(coeffs, threshold)
    % Progowanie miękkie
    thresholded_coeffs = sign(coeffs) .* max(abs(coeffs) - threshold, 0);
end
