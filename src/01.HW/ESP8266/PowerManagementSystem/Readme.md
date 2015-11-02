> 
> # Information
> 
> Current sensor can get ampere value and send analog data to Vout Pin
> 
> Arduino had 10-bit ADC resolution(1024) values between 0V to 5V
> Equation for WCS1500 is
> 
>   y = 0.0101x + 1.6956 (x: A, y: V )
>   
> # Environment
> 
> 1. Supply Voltage: 3V3
> 2. Voltage of Object: 220V
> 
> When there is no current,
> 1024 : 5V = x : (0.0101*0) + 1.6956V
> 
> So, default raw data 'x' = 347.2589
> 
> # Equation for Alternating current (AC)
> 
> Alternating current Periodically reverses direction 
> So, 'Root mean square' is needed to Measure AC
> 
> # Result of Measuring Electricity consumption of Eletric fan
> 
> Default value of raw data was about 1.3
> Measured raw data was about 2.1
> -> 347.2589 + (2.1 - 1.3) = 348.0589
> 
> Vout = (348.0589 * 5V) / 1024 = 1.6995V
> -> Almost 1.700V
> Xa = (1.700-1.696)/0.0101 = 0.396A
> 
> So, Electricity consumption is 
> 220V * 0.396A = 87.120W
> 
