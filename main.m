clear all, clc, close all

%% 1 Observacion de una Trama de Bits
Tb = 1e-9;
A=2;
Pa=0.5; % Probabilidad de Bit

a = round(rand(500,1000));
dim = size(a);
% for i = 1:dim(1)
%     for j = 1:dim(2)
%         if a(i,j) == 0
%             a(i,j)=-1;
%         end
%     end
% end


%% 2 Construccion de senial PCM s(t)
for i = 1:dim(1)
    [s(i,:) T(i,:)] = LineEncoder('polnrz',a(i,:),Tb,A);
end
figure
plot(T(1,:),s(1,:),'LineWidth',2);grid on;
title('Trama de Bits')
xlabel('t (seg)')
ylabel('s(t)')

%% 3 Calculo de Media Promediada
for i=1:dim(1)
    timeAveragedMean(i,:) = mean(s(i,:));
end
disp('La media Promediada obtenida es:');
timeAveragedMean;

%% 4 Calculo de la Autocorrelacion promediada
[timeAveragedAutocorrlation,tau] = xcorr(s(1,:),'normalized');

%% 5 Grafica de las Funciones ensemble y promediadas en tiempo
[c,lags] = xcorr(s(:,20),s(:,30),'normalized');

t_timeMean=[1:500];
meanVR=zeros(1,500);

figure
plot(t_timeMean,timeAveragedMean,'b',t_timeMean,meanVR,'r','LineWidth',2);
title('Función de Media Promediada y Valor Esperado de s(t)')
legend('Media Promediada','Valor Esperado de s(t)')
xlabel('$$\zeta, t$$','interpreter','latex')
ylabel('$$<s(\zeta)>,E\{s(t)\}$$','interpreter','latex')


figure
subplot(2,1,1)
plot(lags,c);
title('Función de Autocorrelación')
xlabel('$$\tau$$','interpreter','latex')
ylabel('$$R_{SS}(\tau)$$','interpreter','latex')

subplot(2,1,2)
plot(tau,timeAveragedAutocorrlation);
title('Función de Autocorrelación promediada en el Tiempo')
xlabel('$$\tau$$','interpreter','latex')
ylabel('$$\Re_{SS}(\tau)$$','interpreter','latex')

%% 6 Determinacion de la Densidad Espectral de Potencia

Y = fft(timeAveragedAutocorrlation);
Fs = 1/Tb;            % Sampling frequency                    
L = length(tau);             % Length of signal
f = Fs*(0:(L/2))/L;
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

X = fft(s(1,:)');
Fs = 1/Tb;            % Sampling frequency 
[n m]=size(s(1,:));
L_x = m;             % Length of signal
f_x = Fs*(0:(L_x/2))/L_x;
P2_x = abs(X/L_x);
P1_x = P2_x(1:L_x/2+1);
P1_x(2:end-1) = 2*P1_x(2:end-1);


%% 7 Graficas de PSD y Periodograma
periodograma = (1/L_x)*(P1_x.^2);

figure
subplot(2,1,1)
plot(f(1:3e3),P1(1:3e3)) 
title('Densidad Espectral de potencia')
xlabel('f (Hz)')
ylabel('$$S(f)$$','interpreter','latex')

subplot(2,1,2)
plot(f_x(1:2e3),periodograma(1:2e3)) 
title('Periodograma')
xlabel('f [Hz]')
ylabel('$$\hat{S}_{SS}(f)$$','interpreter','latex')
