# AFA Projekt Rekonstrukcji Obrazu
**Wojciech Czerski s20458 i Kinga Kalbarczyk s20474**

Ten projekt ma na celu przeprowadzenie rekonstrukcji obrazu przy użyciu algorytmu `recon_mm2` w MATLAB. Algorytm wykorzystuje narzędzia Wavelet Toolbox do przetwarzania obrazów.

## Przegląd projektu

Celem tego projektu jest rekonstrukcja obrazu przy użyciu algorytmu `recon_mm2`, który wykorzystuje transformację falkową atrous. Algorytm przyjmuje obraz wejściowy i wykonuje analizę wieloskalową, używając transformacji falkowej do dekompozycji obrazu na różne pasma częstotliwościowe. Następnie stosuje zmodyfikowaną wersję transformacji falkowej atrous, aby wzmocnić konkretne detale i cechy obrazu. Ostatecznie algorytm odtwarza obraz przy użyciu odwrotnej transformacji falkowej.

## Spis treści
1. [Wymagania](#wymagania)
	- [Instrukcja](#instrukcja)
	- [Przykład](#przykład)
2. [Wyniki](#wyniki)
	- [Stopień kompresji](#stopień-kompresji)
	- [Stosunek sygnału do szumu](#stosunek-sygnału-do-szumu)
	- [Podsumowanie](#podsumowanie)
3. [Dokumentacja](#dokumentacja)
	- [recon_mm2](#recon_mm2)
	- [mm_atrous_lena](#mm_atrous_lena)

## Wymagania
Aby uruchomić ten projekt, będziesz potrzebować:

- MATLAB z dostępem do narzędzi Wavelet Toolbox.
- Obraz wejściowy do rekonstrukcji.

### Instrukcja

1. Otwórz MATLAB i upewnij się, że masz dostęp do narzędzi Wavelet Toolbox.

2. Ustaw katalog roboczy na lokalizację plików projektu.

3. Wczytaj:
	- obraz wejściowy do MATLAB. Możesz użyć funkcji `image_name = 'twoja_nazwa_obrazka.png';`, aby wczytać obraz z pliku.
	- ustal liczbę poziomów za pomocą `levels = twoja_liczba`
	- ustal progi za pomocą `threshold = [liczba1, liczba2, ...]`

	Pamiętaj, aby **liczba progów** miała taką samą długość co **liczba poziomów !**
	`levels = threshold.length`

4. Uruchom skrypt `recon_mm2` w MATLAB. Skrypt ten implementuje algorytm rekonstrukcji obrazu przy użyciu funkcji "dyadup" z narzędzi Wavelet Toolbox.

5. Jeśli napotkasz błąd związanym z narzędziami Wavelet Toolbox, upewnij się, że masz wymagane licencje lub spróbuj alternatywnych technik rekonstrukcji obrazu dostępnych w MATLAB.

6. Przejrzyj wyjściowy obraz. Odtworzony obraz zostanie wyświetlony w oknie figury MATLAB.

7. Eksperymentuj z różnymi parametrami (`levels`, `threshold`) i obrazami wejściowymi (`image_name`), aby uzyskać pożądane rezultaty.

### Przykład
Poniżej znajduje się przykładowe użycie projektu.

W oknie poleceń MATLAB wprowadź następujące polecenie:
```matlab
image_name = 'Lena.bmp';
levels = 3;
threshold = [25, 25, 10];

recon_mm2(levels, threshold, image_name);
```

## Wyniki
**Reconstructed Image from the Modulus Maxima - SNR =** `17.8953 dB`

**Wyliczony stopień kompresji =** `99.6826`
![Wynik kompresji](results/wynik_final.jpg)

![Modulus Maximum](results/modulus_maximum.jpg)

### Stopień kompresji
Wyliczony stopień kompresji wynosi 99.6826. Oznacza to, że model osiągnął wysoki stopień kompresji, co jest pozytywnym wynikiem. Im wyższy stopień kompresji, tym mniejsze zajętość danych, co może być korzystne w przypadku przechowywania i przesyłania obrazów.

### Stosunek sygnału do szumu
SNR wynosi 17.8953 dB. SNR jest miarą jakości rekonstrukcji obrazu i informuje o stosunku sygnału obrazu do poziomu szumu. Wyższy SNR oznacza lepszą jakość rekonstrukcji, gdzie większa część informacji obrazowej została zachowana. Wartość 17.8953 dB wskazuje na przyzwoitą jakość rekonstrukcji, choć może być jeszcze pole do poprawy.

### Podsumowanie
Ten model osiągnął wysoki stopień kompresji, co jest korzystne z punktu widzenia efektywnego wykorzystania miejsca, ale jakość rekonstrukcji może być dalej doskonalona w celu zwiększenia SNR i zachowania większej liczby detali obrazu.

## Dokumentacja
Sekcja ta zawiera krótkie podsumowanie celu i zawartości dokumentacji. Jej celem jest przedstawienie czytelnikowi informacji na temat tego, czego dotyczy dokumentacja oraz jakie informacje i zasoby mogą zostać znalezione w dokumencie. W tej sekcji opisuje się główny temat dokumentacji, czyli w przypadku powyższej dokumentacji dla funkcji `mm_atrous_lena` i `recon_mm2`, ich funkcje, parametry, wyniki i inne istotne informacje, które czytelnik może znaleźć w dokumentacji.

### recon_mm2

Funkcja `recon_mm2` jest odpowiedzialna za rekonstrukcję obrazu przy użyciu algorytmu 'mm_atrous_lena' z zastosowaniem transformacji falkowej. Przyjmuje trzy argumenty: `lvl` (poziomy dekompozycji), `Threshold` (progi progowania) i `image_name` (nazwa pliku obrazu wejściowego).

#### Argumenty

- `lvl` - Liczba poziomów dekompozycji.
- `Threshold` - Próg progowania lub wektor progów dla każdego poziomu dekompozycji.
- `image_name` - Nazwa pliku obrazu wejściowego.

#### Opis działania

1. Wczytanie obrazu wejściowego `image_name` przy użyciu funkcji `imread` i przekształcenie go na obraz w skali szarości `Lena`.
2. Przygotowanie fragmentu obrazu `y` poprzez wybranie określonego obszaru z `Lena`.
3. Zastosowanie funkcji `mm_atrous_lena` do obliczenia analizy multirezolucyjnej i otrzymania współczynników dekompozycji: `a`, `D1_MM`, `D2_MM`, `gprime`, `hprime` oraz `compressionRate`.
4. Dla każdego poziomu dekompozycji:
   - Zastosowanie progowania twardego i miękkiego na macierzach `D1_MM` i `D2_MM` przy użyciu funkcji `wthresh`.
   - Rekonstrukcja obrazu przy użyciu funkcji `atrous_up`.
5. Inicjalizacja zmiennych i rozpoczęcie pętli `ConjGrad_2d`.
6. Wyliczenie współczynnika sygnału do szumu (SNR) na podstawie porównania oryginalnego obrazu `save_orig` i zrekonstruowanego obrazu `f_image`.
7. Wyświetlenie obrazów oryginalnego i zrekonstruowanego oraz informacji o SNR i stopniu kompresji.

#### Przykład użycia

```matlab
lvl = 3;
Threshold = [25, 25, 10];
image_name = 'obraz_wejsciowy.bmp';

recon_mm2(lvl, Threshold, image_name);
```

W powyższym przykładzie funkcja `recon_mm2` zostanie wywołana z podanymi argumentami: `lvl` ustawionym na 3, `Threshold` ustawionym na wektor `[25, 25, 10]` i `image_name` ustawionym na 'obraz_wejsciowy.bmp'. Funkcja przeprowadzi rekonstrukcję obrazu i wyświetli wyniki.

### mm_atrous_lena

Funkcja `mm_atrous_lena` wykonuje dekompozycję falkową na obrazie Lena oraz oblicza moduł maksymalny. Zwraca również różne parametry i generuje wykresy dla analizy wyników.

#### Składnia

```matlab
[y, D1_MM, D2_MM, gprime, hprime, compressionRate] = mm_atrous_lena(decomp_times, Threshold, image_name)
```

#### Parametry

- `decomp_times`: Liczba iteracji dekompozycji falkowej (poziom szczegółowości).
- `Threshold`: Wartość progowa, która określa poziom odrzucenia nieznaczących współczynników falkowych.
- `image_name`: Nazwa pliku obrazu, na którym ma być wykonana dekompozycja.

#### Wyniki

- `y`: Przetworzony obraz Lena po wycięciu fragmentu i wykonaniu dekompozycji.
- `D1_MM`: Macierz detalów poziomych dla każdego poziomu dekompozycji.
- `D2_MM`: Macierz detalów pionowych dla każdego poziomu dekompozycji.
- `gprime`: Filtr horyzontalny falki.
- `hprime`: Filtr wertykalny falki.
- `compressionRate`: Stopień kompresji obrazu po zastosowaniu modułu maksymalnego.

#### Opis działania

1. Wczytuje obraz Lena z pliku o podanej nazwie.
2. Przetwarza obraz Lena przez wycięcie fragmentu o wymiarach (50:177, 50:177).
3. Inicjalizuje zmienne i filtry falkowe.
4. Wykonuje iteracyjną dekompozycję falkową na obrazie Lena.
5. Oblicza detalne współczynniki (d1 i d2) na podstawie przesunięć i splotów z filtrami falkowymi.
6. Oblicza moduł transformacji falkowej (wtm) oraz kąt wektora transformacji falkowej (alpha).
7. Znajduje i zaznacza moduł maksymalny na podstawie kryteriów warunkowych.
8. Buduje macierze detalów (d1_mm i d2_mm) zawierające tylko istotne współczynniki na podstawie modułu maksymalnego.
9. Generuje wykresy dla analizy wyników, w tym przybliżenia, szczegóły, moduł transformacji i kąt wektora transformacji.
10. Oblicza stopień kompresji obrazu na podstawie liczby zerowych współczynników modułu maksymalnego.

### Wykresy

1. Przybliżenia dla każdego poziomu dekompozycji.
2. Szczegóły horyzontalne dla każdego poziomu dekompozycji.
3. Szczegóły wertykalne dla każdego poziomu

 dekompozycji.
4. Moduł transformacji falkowej dla każdego poziomu dekompozycji.
5. Kąt wektora transformacji falkowej dla każdego poziomu dekompozycji.
6. Moduł maksymalny dla każdego poziomu dekompozycji.

#### Przykład użycia

```matlab
[y, D1_MM, D2_MM, gprime, hprime, compressionRate] = mm_atrous_lena(3, 0.5, 'lena.png');
```

W powyższym przykładzie zostanie wykonana dekompozycja falkowa obrazu 'lena.png' z użyciem 3 poziomów dekompozycji oraz wartości progowej 0.5. Wyniki zostaną zapisane do zmiennych `y`, `D1_MM`, `D2_MM`, `gprime`, `hprime`, `compressionRate`.