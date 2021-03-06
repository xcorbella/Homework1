% This program solves a convection-diffusion problem 
% in a square domain [0,1]x[0,1] using bilinear elements.

clear, close all, home

global diffusion  h 

disp(' ')
disp('This program solves a diffusion equation')
disp(' ')
disp('No source term is considered');

addpath('Elements');
addpath('Model');

disp(' ')
file=input('Type the name of the project:', 's');
T=load(strcat('elem_',file)); T = T(:,2:end);
X = load(strcat('nodes_',file)); X = X(:,2:end);
inlet = load(strcat('inlet_',file,'.dat'))';
outlet = load(strcat('outlet_',file,'.dat'))';
diffusion = load('prop.dat');

nelem = length(T);
nnode = length(X);
dimension=size(X,2);
nodes=size(T,2);
switch file
    case 'C2D3'
        type=5;
        [n,wpg,pospg,N,dNdxi] = C2D3 ;
        [K,f] = CreateMatrix2D(X,T,pospg,wpg,N,dNdxi);

    case 'C2D6'
        type=22;
        [n,wpg,pospg,N,dNdxi] = C2D6 ;
        [K,f] = CreateMatrix2D(X,T,pospg,wpg,N,dNdxi);

    case 'C2D4'
        type=9;
        [n,wpg,pospg,N,dNdxi] = C2D4 ;
        [K,f] = CreateMatrix2D(X,T,pospg,wpg,N,dNdxi);
        
    case 'C2D8'
        type=23;
        [n,wpg,pospg,N,dNdxi] = C2D8 ;
        [K,f] = CreateMatrix2D(X,T,pospg,wpg,N,dNdxi);
        
    case 'C3D4'
        type=10;
        [n,wpg,pospg,N,dNdxi] = C3D4 ;
        [K,f] = CreateMatrix3D(X,T,pospg,wpg,N,dNdxi);

    case 'C3D10'
        type=24;
        [n,wpg,pospg,N,dNdxi] = C3D10 ;
        [K,f] = CreateMatrix3D(X,T,pospg,wpg,N,dNdxi);

    case 'C3D8'
        type=12;
        [n,wpg,pospg,N,dNdxi] = C3D8 ;
        [K,f] = CreateMatrix3D(X,T,pospg,wpg,N,dNdxi);
        
    case 'C3D20'
        type=25;
        [n,wpg,pospg,N,dNdxi] = C3D20 ;
        [K,f] = CreateMatrix3D(X,T,pospg,wpg,N,dNdxi);
end;

C = [inlet, ones(length(inlet),1);
    outlet, zeros(length(outlet),1)];

ndir = size(C,1);
neq  = size(f,1);
A = zeros(ndir,neq);
A(:,C(:,1)) = eye(ndir);
b = C(:,2);


% SOLUTION OF THE LINEAR SYSTEM
% Entire matrix
Ktot = [K A';A zeros(ndir,ndir)];
ftot = [f;b];

sol = Ktot\ftot;
Temp = sol(1:neq);

if dimension ==2
    geo2D_vtk;
elseif dimension ==3
    geo3D_vtk;
end
display('Done!')