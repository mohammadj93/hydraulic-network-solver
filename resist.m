function y=resist(L,W,H)
    if W<H
        s=H;
        H=W;
        W=s;
    end
    y=12*L/(1-0.63*H/W)/H^3/W;
end