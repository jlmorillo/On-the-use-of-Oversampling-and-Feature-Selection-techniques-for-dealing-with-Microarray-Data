function [head] = getHead(dataset)

switch dataset 
    case {'brain' 'cns' 'colon' 'gli85' 'ovarian' }
        head = 'cabeceras/cabecera0-1.txt';
    case {'leukemia1' 'leukemia2'}
        head = 'cabeceras/cabecera0-2.txt';
    case {'brain_tumor2' 'srbct'}
        head = 'cabeceras/cabecera0-3.txt';        
    case {'brain_tumor1' 'lung_cancer'}
        head = 'cabeceras/cabecera0-4.txt';
    case '9_tumors'
        head = 'cabeceras/cabecera0-8.txt';
    case '11_tumors'
        head = 'cabeceras/cabecera0-10.txt'; 
    case '14_tumors'
        head = 'cabeceras/cabecera0-25.txt';   
    case 'cll'
        head = 'cabeceras/cabecera1-3.txt';
    case 'gla'
        head = 'cabeceras/cabecera1-4.txt';     
    case 'lymphoma'
        head = 'cabeceras/cabecera1-9.txt';      
    case 'gcm'
        head = 'cabeceras/cabecera1-14.txt';        
otherwise
        disp('Error');
           
end

end        