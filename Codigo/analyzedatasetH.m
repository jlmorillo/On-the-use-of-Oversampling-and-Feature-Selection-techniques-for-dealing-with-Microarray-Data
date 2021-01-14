function [rand_indices datos_por_paquete]= analyzedatasetH(set,numPaquetes)
% ANALYZEDATASETH ANALIZA EL DATASET, ESTUDIA SI SE PUEDE DIVIDIR EN PAQUETES CON UNA DISTRIBUCI�N HOMOG�NEA DE LAS CLASES
% ENTRADA:
%   set: Dataset de entrada
%   numPaquetes: n�mero de paquetes a dividir
% SALIDA:
%   rand_indices: Matriz organizada en paquetes con distribuci�n de datos homog�nea
%   datos_por_paquete: resultado de n�mero de datos por paquetes a dividir
    
        
    %Obtenemos el n�mero de caracter�sticas e instancias del dataset de entrada
    [nInst nFeat]=size(set);

    %Para obtener el n�mero de clases deberemos recorrer el dataset e ir a�adiendo los distintos valores de la ultima columna en un vector e ir
    %contando el numero de ocurrencias de cada una de ellas

    nClasses=0; %Se inicializa el contador de clases

    %Recorre todo el dataset
     format longG;
     iniTime= tic;

%-----------------------------------------------------------------------------------
%-------------AGRUPACI�N DE �NDICES DE INSTANCIAS POR CLASE-------------------------
    for i = 1:nInst
        found=0;                                                %Flag: Encontrado = 0
        m=1;                                                    %�ndice de recorrido en el vector de clases (m=N�mero de clases encontradas)
        %Clasifica las instancias en funcion de la clase a la que pertenecen
        while (found==0)
            if (m>nClasses) %Clase nueva
                vectorClasses(m,1)=set(i,nFeat);                %Se almacena la clase
                vectorClasses(m,2)=1;                           %Se almacena el n�mero de instancias perteneciente a esa clase
                vectorClasses(m,3)=0;                           %Se inicializa a cero para contar luego el numero de instancias despues de dividir en paquetes
                almacenVectores(m,1)=i;                         %Se a�ade el �ndice de la primera instancia con la clase m al vector
                found=1;                                        %Salimos del bucle de b�squeda
                nClasses=nClasses+1;
            else %Clase ya existente
                if (vectorClasses(m,1)==set(i,nFeat))           %La clase actual ya est� inventariada
                    numInstanciasClase=vectorClasses(m,2)+1;    %Aumentamos el n�mero de ocurrencias de la clase
                    vectorClasses(m,2)= numInstanciasClase;
                    almacenVectores(m,numInstanciasClase)=i;    %Se a�ade el �ndice de la instancia perteneciente a la clase m al vector
                    found=1;                                    %Salimos del bucle de b�squeda
                else %Esta no es la clase
                    m=m+1;                                          %Se avanza el �ndice de clase
                end
            end
        end                                                     %Seguimos buscando la clase
    end   
     finTime=toc(iniTime);
     fprintf('Tiempo en recorrer bucle separaci�n de clases: %f\n',finTime);

%-----------------------------------------------------------------------------------
%-------------C�LCULO DEL MCD DE LAS OCURRENCIAS DE CADA CLASE----------------------
    A=vectorClasses(:,2);
    B=nonzeros(abs(A));
    t=all(bsxfun(@mod, B, 1:max(B))==0, 1);
    maxComDiv = find(t, 1, 'last'); 

%-----------------------------------------------------------------------------------
%-------------SELECCION OPCIONAL DEL NUMERO DE PAQUETES OPTIMO----------------------
%------------------------SOLO SI NUMPAQUETES=0--------------------------------------
    minClase=min(vectorClasses(1:nClasses,2,1));
    if (numPaquetes==0) 
        if(maxComDiv ~= 1)
            numPaquetes=maxComDiv;
        else
            numPaquetes=minClase;   %%%%%%HAY QUE ESTUDIAR ESTE VALOR
        end
    end
%-----------------------------------------------------------------------------------
%--------------------------DIVISI�N EN PAQUETES-------------------------------------
%-----------------------------------------------------------------------------------
    tStartIfFinal=tic;
    if (numPaquetes <= minClase) 
        rand_indices=[];
        %DIVISI�N EN PAQUETES DE DATOS - CREAMOS EL VECTOR DATASETSINDICES(numPaquete,numInstancia,vector)
        for z = 1:numPaquetes
            inicio=1;
            for nClase=1:nClasses
                numElementos=floor(vectorClasses(nClase,2)/numPaquetes);
                K=(z-1)*numElementos;
                %PARA CONTAR LA NUEVA PROPORCION 
                vectorClasses(nClase,3)=vectorClasses(nClase,3)+numElementos;
                %datasetsIndices(z,inicio:inicio+numElementos-1,:)=set(almacenVectores(nClase,1+K:numElementos+K),:);                
                datasetsIndices(z,inicio:inicio+numElementos-1)=almacenVectores(nClase,1+K:numElementos+K);                
                inicio=inicio+numElementos;
            end
            [numpaquetes datos_por_paquete caracteristicas]=size(datasetsIndices);
            %SE CONSTRUYE EL VECTOR FINAL CONCATENANDO LOS PAQUETES
            rand_indices=[rand_indices datasetsIndices(z,randperm(datos_por_paquete),:)];
        end
        %CAMBIA EL FORMATO DEL VECTOR
        %[c instancias caracteristicas]=size(rand_indices);
        %rand_indices=reshape(rand_indices,[instancias caracteristicas]);
    else
        fprintf('No es posible dividir en %i de paquetes respetando homogeneidad: minimo clase: %i\n',numPaquetes, minClase);
        %datasetsIndices=0;
        exit;
    end
    finTime=toc(tStartIfFinal);
    fprintf('Tiempo en dividir el dataset en %i paquetes: %f\n',numPaquetes,finTime);
    fprintf('Numero de instancias original: %i\n',numPaquetes);    
    
%-----------------------------------------------------------------------------------
fprintf('--------------ESTADISTICAS--------------------\n');     
fprintf('Numero total de clases: %i\n',nClasses);
for j=1:nClasses
    fprintf('Ocurrencias %i: %i - Proporci�n: %f\n',vectorClasses(j,1),vectorClasses(j,2),(vectorClasses(j,2)*100)/(numpaquetes*datos_por_paquete));
end
fprintf('MCD de las ocurrencias de las clases: %i\n',maxComDiv);
fprintf('M�ximo n�mero de paquetes a dividir: %i\n',minClase);
fprintf('Se divide en %i paquetes\n',numPaquetes);
%-----------------------------------------------------------------------------------    
end