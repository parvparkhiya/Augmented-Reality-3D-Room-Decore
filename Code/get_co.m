function mx = get_co(i,rows)
    mx=zeros(1,2);
    mx(2)=floor(i/rows);
    mx(1)=i-rows*mx(2);
end