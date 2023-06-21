function [reconstructed_image, compression_ratio, snr] = recon_mm2(image_name, num_levels, threshold)
    % Wczytaj obrazek
    image = imread(image_name);
    
    % Konwertuj obrazek na skalę szarości, jeśli jest kolorowy
    if size(image, 3) > 1
        image = rgb2gray(image);
    end
    
    % Wykonaj dekompozycję falkową na num_levels poziomów
    [C, S] = wavedec2(image, num_levels, 'haar');
    
    % Inicjalizuj macierz do przechowywania progowanych współczynników
    thresholded_C = C;
    
    % Progowanie dla każdego poziomu dekompozycji
    for i = 1:num_levels
        % Wyznacz granice poziomu dekompozycji
        start_index = sum(S(1:i, 1)) + 1;
        end_index = start_index + prod(S(i+1, :)) - 1;
        
        % Wyznacz aproksymację na danym poziomie
        approximation = thresholded_C(start_index:end_index);
        
        % Wyznacz próg dla danego poziomu dekompozycji
        level_threshold = threshold_selection(approximation, threshold);
        
        % Progowanie twarde lub miękkie na danym poziomie
        thresholded_C(start_index:end_index) = soft_threshold(approximation, level_threshold);
    end
    
    % Rekonstrukcja obrazu z progowanych współczynników
    reconstructed_image = waverec2(thresholded_C, S, 'haar');
    
    % Oblicz stopień kompresji
    original_size = numel(image);
    compressed_size = nnz(thresholded_C); % Liczba niezerowych elementów
    compression_ratio = original_size / compressed_size;
    
    % Oblicz stosunek sygnału do szumu (SNR) dla zrekonstruowanego obrazu
    image_double = im2double(image); % Konwersja na typ double
    reconstructed_double = im2double(reconstructed_image); % Konwersja na typ double
    noise = image_double - reconstructed_double;
    
    signal_power = sum(image_double(:).^2) / numel(image_double);
    noise_power = sum(noise(:).^2) / numel(noise);
    snr = 10 * log10(signal_power / noise_power);
    
    % Wyświetlanie oryginalnego obrazka
    figure;
    subplot(1, 2, 1);
    imshow(image);
    title('Oryginalny obrazek');
    
    % Wyświetlanie zrekonstruowanego obrazka
    subplot(1, 2, 2);
    imshow(reconstructed_image);
    title('Zrekonstruowany obrazek');

    % Wyświetlanie wyników
    fprintf('Stopień kompresji: %.2f\n', compression_ratio);
    fprintf('Stosunek sygnału do szumu (SNR): %.2f dB\n', snr);
end

function level_threshold = threshold_selection(approximation, threshold)
    % Analiza zawartości szumu w aproksymacji
    % Wyznaczanie progu dla danego poziomu dekompozycji
    
    % Przykładowa implementacja wyznaczania progu na podstawie analizy zawartości szumu
    % Możesz dostosować tę funkcję do własnych potrzeb
    noise_estimate = std2(approximation); % Estymacja szumu jako odchylenie standardowe aproksymacji
    level_threshold = threshold * noise_estimate;
end

function thresholded_coefficients = soft_threshold(coefficients, threshold)
    % Progowanie miękkie
    
    % Przykładowa implementacja progowania miękkiego
    thresholded_coefficients = sign(coefficients) .* max(abs(coefficients) - threshold, 0);
    % Możesz dostosować tę funkcję do własnych potrzeb
end
