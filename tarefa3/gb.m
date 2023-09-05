function gbfilter=gb(imsize, lamda, theta, sigma)

phase = 0;                           
trim = 0;                            

X = 1:imsize;                        
X0 = (X / imsize) - 0.5;             

sin_wav = sin(X0 * 2*pi);            

f = imsize/lamda;                    
Xf = X0 * f * 2*pi;                  
sin_wav = sin(Xf) ;                     
phaseRad = (phase * 2* pi);             
sin_wav = sin( Xf + phaseRad) ;         

[Xm Ym] = meshgrid(X0, X0);             

Xf = Xm * f * 2*pi;
grating = sin( Xf + phaseRad);          

thetaRad = 2*pi*(theta/360);        
Xt = Xm * cos(thetaRad);             
Yt = Ym * sin(thetaRad);             
XYt =  Xt + Yt ;                     
XYf = 2*pi*XYt*f;                
grating = sin(XYf+phaseRad);         

s = sigma / imsize;                     
Xg = exp( -( ( (X0.^2) ) ./ (2* s^2) ));
Xg = normpdf(X0, 0, (20/imsize)); Xg = Xg/max(Xg);  

gauss = exp( -(((Xm.^2)+(Ym.^2)) ./ (2* s^2)) );   

gauss(gauss < trim) = 0;                 
gbfilter = grating .* gauss;               
end