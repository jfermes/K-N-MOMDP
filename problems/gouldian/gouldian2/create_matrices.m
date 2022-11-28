P = zeros(81, 81, 2, 4);
R = zeros(81, 4);


fid = fopen('transitions.txt');

tline = fgetl(fid);

while ischar(tline)
    
    tline = fgetl(fid);
    
    if tline == -1
        break;
        
    end
    
    t = str2num(tline);
    
    
    
    a = t(1);
    y = t(2);
    s1 = t(3);
    s2 = t(4);
    p = t(5);

    
    if s1 > 80
        s1 = s1 - 81 + 1;
    else 
        s1 = s1 + 1;
    end
    
    if s2 > 80
        s2 = s2 - 81 + 1;
    else 
        s2 = s2 + 1;
    end
    



    P(s1, s2, y, a) = p;
      
    
end
fclose(fid);






fid2 = fopen('rewards.txt');

tline2 = fgetl(fid2);

while ischar(tline2)
    [tline2] = fgetl(fid2);
    
    if tline2 == -1
        break;
        
    end
    
    rl = str2num(tline2);
    
    a = rl(1);
    s = rl(2);
    r = rl(3);
    
    s = s + 1;
    
    R(s,a) = r;
 
end
fclose(fid2);


P(10,28,1,1)



save('P.mat', 'P');
save('R.mat', 'R');
