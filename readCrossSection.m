function [area, pere, redi, topW]=readCrossSection(X,Y,wl)
% made by Beg, Md Nazmul Azim, February 6, 2021
% Disclaimer: Some part of the code has been adopted from codes from Kelin
% Hu, Tulane University, LA

    % X and Y are vectors representing the surveyed cross section
    % wl is a vector with different values of water level
    % area, pere, redi, topw will be vectors each having the same length as
    % of wl and corresponding sequence represent the area, peremeter,
    % wetted peremeter and the topwidth of the channel.
    
    figureDraw = 1;
    if figureDraw == 1
        figure(1);
        plot(X,Y,'ko-');
        hold on;
    end
    
    XY = [X Y];
    XY = sortrows(XY,1);
    X = XY(:,1);
    Y = XY(:,2);
    clear XY;
    
    area = wl*0;
    pere = wl*0;
    redi = wl*0;
    topW = wl*0;
    
    X = [X(1);X;X(end)];
    Y = [Y(1);Y;Y(end)];
    
    el_min = min(Y);
    el_max = max(Y);
    Y(1)=el_max+0.01;
    Y(end)=el_max+0.01;
    
    for i =1:length(wl)
        if wl(i)<=el_min
            area(i)=0;
            pere(i)=0;
            redi(i)=0;
            topW(i)=0;
            if figureDraw == 1
                plot([min(X) max(X)], [wl(i) wl(i)],'g-');
            end
        elseif (wl(i)-el_min)*(wl(i)-el_max)<0
            j_area = 0;
            j_start(1) = -999;
            j_end(1) = -999;
            j_find = 0;
            
            for j=1:length(X)-1
                if (wl(i) <= Y(j)) && (wl(i) > Y(j+1)) && (j_find == 0)
                    j_find=1;
                    j_area=j_area+1;
                    j_start(j_area)=j;
                end
                if (wl(i) > Y(j)) && (wl(i) <= Y(j+1)) && (j_find == 1)
                    j_find=0;
                    j_end(j_area)=j;
                end
            end
            area(i)=0;
            pere(i)=0;
            topW(i)=0;
            for j=1:j_area
                if Y(j_start(j)+1) == Y(j_start(j))
                    x_start = Y(j_start(j));
                else
                    x_start=X(j_start(j))+(wl(i)-Y(j_start(j)))/(Y(j_start(j)+1)-Y(j_start(j)))*(X(j_start(j)+1)-X(j_start(j)));
                end
                
                if Y(j_end(j)+1) == Y(j_end(j))
                    x_end = Y(j_end(j));
                else
                    x_end=X(j_end(j))+(wl(i)-Y(j_end(j)))/(Y(j_end(j)+1)-Y(j_end(j)))*(X(j_end(j)+1)-X(j_end(j)));
                end
                
                topW(i)=x_end-x_start+topW(i);
                xxx = [x_start; X(j_start(j)+1:j_end(j)); x_end];
                yyy = [wl(i); Y(j_start(j)+1:j_end(j)); wl(i)];
                area(i) = area(i) + polyarea([xxx; x_start],[yyy; wl(i)]);
                pere(i) = pere(i) + sum(sqrt((xxx(1:end-1)-xxx(2:end)).^2+(yyy(1:end-1)-yyy(2:end)).^2));
                if figureDraw == 1
                    plot([x_start x_end], [wl(i) wl(i)],'g-');
                end
            end
            redi(i) = area(i) / pere(i);
        else
            x_start = X(1);
            x_end = X(end);
            xxx = [x_start; X; x_end];
            yyy = [wl(i); Y; wl(i)];
            topW(i)=x_end-x_start;
            area(i) = polyarea([xxx; x_start],[yyy; wl(i)]);
            pere(i) = sum(sqrt((xxx(1:end-1)-xxx(2:end)).^2+(yyy(1:end-1)-yyy(2:end)).^2));
            redi(i) = area(i) / pere(i);
            if figureDraw == 1
                plot([x_start x_end], [wl(i) wl(i)],'g-');
            end
        end
    end
    
    if figureDraw == 1
        ylim([min(min(Y)-(max(Y)-min(Y))*0.2, min(wl)-(max(wl)-min(wl))*0.2),max(max(Y)+(max(Y)-min(Y))*0.2, max(wl)+(max(wl)-min(wl))*0.2)]);
    end

end

% if want to plot
