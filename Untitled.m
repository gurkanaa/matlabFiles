%%file operations
fid=fopen('residue.txt','r');
A=fscanf(fid,'%f');
fclose(fid)
B=reshape(A,16384,length(A)/16384);
klm=[];
for i=1:length(A)/16384
    if ((B(:,i))'*B(:,i)>0.1)
        klm=[klm B(:,i)];
    end
end
fid=fopen('motorcurrent.txt','w');
fprintf(fid,'%f ',klm);
fclose(fid)