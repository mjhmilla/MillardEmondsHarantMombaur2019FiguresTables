function figH = addResultsRow(figH,subPlotRow,dataCurves,dataFit,tisoScale,...
                              lambdaTa,lambdaPE,lambdaTv,tiso,...
                              angleScalingTa,angleShiftPE,omegaMax,...
                              titleText)


flag_usingOctave              = 0;
numberOfVerticalPlotRows      = 2;
numberOfHorizontalPlotColumns = 2;
plotConfigCustom;

rad2deg = 180/pi;
clr0 = [1,1,1].*0.5;
clr1 = [0,0,1];
clr2 = [1,0,0];
clr3 = [0.63,0.63,0.63];
clrFill0 = [1,1,1].*0.75;


subplot('Position',reshape(subPlotPanel(subPlotRow,1,:),1,4));
%    faPolyPre = [dataCurves(:,1).*rad2deg, dataCurves(:,4);...
%                 min(dataCurves(:,1).*rad2deg), 2*max(dataCurves(:,4));...
%                 max(dataCurves(:,1).*rad2deg), 2*max(dataCurves(:,4));...
%                 dataCurves(1,1).*rad2deg, dataCurves(1,4)];
    faPolyPre = zeros((size(dataCurves,1)-1)*5,2);
    j=0;
    
    yVal = max(dataCurves(:,4))*5;
    
    for i=1:1:(size(dataCurves,1)-1)
        j=j+1;
        faPolyPre(j,:) = [dataCurves(i,1).*rad2deg,yVal];
        j=j+1;
        faPolyPre(j,:) = [dataCurves(i,1).*rad2deg, dataCurves(i,4)];
        j=j+1;
        faPolyPre(j,:) = [dataCurves(i+1,1).*rad2deg, dataCurves(i+1,4)]; 
        j=j+1;
        faPolyPre(j,:) = [dataCurves(i+1,1).*rad2deg,yVal]; 
        j=j+1;
        faPolyPre(j,:) = [dataCurves(i,1).*rad2deg,yVal];
        
    end             
    
    fill(faPolyPre(:,1),faPolyPre(:,2).*tiso,clrFill0,...
        'EdgeColor',clrFill0,'LineWidth',2);
    hold on;
    
    fpPolyPre = zeros((size(dataCurves,1)-1)*5,2);
    j=0;
    
    for i=1:1:(size(dataCurves,1)-1)
        j=j+1;
        fpPolyPre(j,:) = [dataCurves(i,1).*rad2deg, 0];
        j=j+1;
        fpPolyPre(j,:) = [dataCurves(i,1).*rad2deg, dataCurves(i,3)];
        j=j+1;
        fpPolyPre(j,:) = [dataCurves(i+1,1).*rad2deg, dataCurves(i+1,3)];
        j=j+1;
        fpPolyPre(j,:) = [dataCurves(i+1,1).*rad2deg, 0];
        j=j+1;
        fpPolyPre(j,:) = [dataCurves(i,1).*rad2deg, 0];
    end
    %fpPolyPre = [dataCurves(:,1).*rad2deg, dataCurves(:,3);...
    %             200, 2;...
    %             200, 0;...
    %             dataCurves(1,1).*rad2deg, dataCurves(1,3)];
    fill(fpPolyPre(:,1),fpPolyPre(:,2).*tiso,clrFill0,...
         'EdgeColor',clrFill0,'LineWidth',2);
    hold on;
    
    xmin = min(dataCurves(:,1)).*rad2deg;
    xmax = max(dataCurves(:,1)).*rad2deg;
    ymin =-0.1.*tiso*tisoScale;
    ymax = 1.2.*tiso*tisoScale;
    
    fill([ xmin,xmax,xmax,xmin,xmin]',...
         [   0,  0,-100,-100,  0]', clrFill0,'EdgeColor',clrFill0,'LineWidth',2);
    hold on;


    
    plot(dataCurves(:,1).*rad2deg, dataCurves(:,2).*tiso,'Color',clr3);
    hold on;    
    plot(dataCurves(:,1).*rad2deg, dataCurves(:,3).*tiso,'Color',clr0);
    hold on;
    plot(dataCurves(:,1).*rad2deg, dataCurves(:,4).*tiso,'Color',clr0);
    hold on;
    %plot(dataCurves(:,1).*rad2deg, dataCurves(:,5).*tiso,...
    %        ':','Color',clr0,'LineWidth',0.5);
    %hold on;
    plot(dataCurves(:,1).*rad2deg, dataCurves(:,6).*tiso,...
            ':','Color',clr0,'LineWidth',0.5);
    %plot(dataCurves(:,1).*rad2deg, dataCurves(:,9).*tiso,...
    %        ':','Color',clr0,'LineWidth',0.5);        
    hold on;
    plot(dataFit(:,1).*rad2deg, dataFit(:,2).*tiso,'Color',clr1);      
    %hold on;
    %plot(dataFit(1,1).*rad2deg, dataFit(1,2).*tiso,'*','Color',clr1);      
    
    axis([xmin,xmax,ymin,ymax]);
    axisWidth = max(dataCurves(:,1).*rad2deg)...
               -min(dataCurves(:,1).*rad2deg);
    axisHeight= 1.2*tiso*tisoScale;
    lowerLeftCorner = [min(dataCurves(:,1).*rad2deg),0];
    
    axis square;
    box off;
    
    tta = text(50,tiso*tisoScale*1.4,titleText);
    set(tta,'FontSize',8);
    
    [val idx] = max(dataCurves(:,2));
    plot(dataCurves(idx,1).*rad2deg, dataCurves(idx,2).*tiso,'.k');
    hold on;
    
    txtSize = 6;
    
    x0 = -7.5;
    y0 = 1.15*tisoScale*tiso;
    yDelta = axisHeight*0.1;
    
    if(subPlotRow==2)
       y0 = y0*0.4; 
    end
    
    
    tt0=text(x0,(y0),['$\tau_{o}:',num2str(round(tiso)),'$ Nm']);
    set(tt0,'FontSize',txtSize);
    tt1=text(x0,(y0-yDelta),['$s_A: ',num2str(round(angleScalingTa,2)),'$']);
    set(tt1,'FontSize',txtSize);
    
    if(isa(lambdaTa,'float'))
      tt2=text(x0,(y0-yDelta*2),['$\lambda_A:',num2str(lambdaTa),'$']);
      set(tt2,'FontSize',txtSize);
    else
      tt2=text(x0,(y0-yDelta*2),['$\lambda_A:',lambdaTa,'$']);  
      set(tt2,'FontSize',txtSize);
    end
    
    if(isa(lambdaPE,'float'))
      tt3=text(85,0.5*yDelta ,['$\lambda_{P}:',num2str(round(lambdaPE,2)),'$']);    
      set(tt3,'FontSize',txtSize);
    else
      tt3=text(85,0.5*yDelta,['$\lambda_P:',lambdaPE,'$']);          
      set(tt3,'FontSize',txtSize);      
    end
    tt4=text(85,(-0.5*yDelta),['$\Delta_P:',num2str(round(angleShiftPE*rad2deg,0)),'$']);    
    set(tt4,'FontSize',txtSize);

    
    if(subPlotRow==1)
        txtInf = text(-6.5,105,'Infeasible');
        set(txtInf,'Rotation',45);
        set(txtInf,'FontSize',txtSize);
        txtFea = text(-6.5,65,'Feasible');
        set(txtFea,'FontSize',txtSize);        
        set(txtFea,'Rotation',45);        
        lblTxt1 = text(5,30,'$(\theta(t),\tau^M_{exp}(t))$');
        set(lblTxt1,'Color',clr1);
        set(lblTxt1,'Rotation',30);
        set(lblTxt1,'FontSize',txtSize);
    end
    %text(0,10,'$\tau_{HR}$');

    if(subPlotRow==1)
        txtLbl = text(lowerLeftCorner(1),...
                      lowerLeftCorner(2)+1.05*axisHeight,'A.');
        set(txtLbl,'FontSize',7);
    else
        txtLbl = text(lowerLeftCorner(1),...
                      lowerLeftCorner(2)+1.05*axisHeight,'C.');
        set(txtLbl,'FontSize',7);        
    end
    %text(0,0.95,['$s_P:',num2str(lambdaTa),'$']);    
    xlabel('Angle (deg)','FontSize',txtSize);
    ylabel('Torque (Nm)','FontSize',txtSize);
    
    hold on;

subplot('Position',reshape(subPlotPanel(subPlotRow,2,:),1,4));
    fvPolyPre = zeros((size(dataCurves,1)-1)*5,2);
    j=0;
    
    yVal = max(dataCurves(:,8))*5;
    for i=1:1:(size(dataCurves,1)-1)
        j=j+1;
        fvPolyPre(j,:) = [dataCurves(i,7).*rad2deg,yVal];
        j=j+1;
        fvPolyPre(j,:) = [dataCurves(i,7).*rad2deg, dataCurves(i,8)];
        j=j+1;
        fvPolyPre(j,:) = [dataCurves(i+1,7).*rad2deg, dataCurves(i+1,8)];        
        j=j+1;
        fvPolyPre(j,:) = [dataCurves(i+1,7).*rad2deg,yVal];
        j=j+1;
        fvPolyPre(j,:) = [dataCurves(i,7).*rad2deg, yVal];        
    end             

    xmin = min(dataCurves(:,7)).*rad2deg;
    xmax = max(dataCurves(:,7)).*rad2deg;
    ymin =-0.1.*tiso*tisoScale;
    ymax = 1.2.*tiso*tisoScale;
    
    %fvPolyPre = [dataCurves(:,7).*rad2deg, dataCurves(:,8);...
    %              200, 2;...
    %             -200,2;...
    %             dataCurves(1,7).*rad2deg, dataCurves(1,8)];
    fill(fvPolyPre(:,1),fvPolyPre(:,2).*tiso,clrFill0,...
        'EdgeColor',clrFill0,'LineWidth',2);
    hold on;
    fill([xmin,xmax,xmax,xmin,xmin],...
         [   0,  0,-100,-100,  0], clrFill0,'EdgeColor','none');
     hold on;
        
    plot(dataCurves(:,7).*rad2deg, dataCurves(:,8).*tiso,'Color',clr0);        
    hold on;
    plot(dataFit(:,3).*rad2deg, dataFit(:,4).*tiso,'Color',clr2);   
    hold on;
    

    
    %plot(dataFit(1,3).*rad2deg, dataFit(1,2).*tiso,'*','Color',clr1);      
    %hold on;
    plot(0,tiso,'.k');
    hold on;
    axis([xmin,xmax,ymin,ymax]);
    axis square;
    box off;
    
    if(subPlotRow==1)
       y0 = 0.5*axisHeight; 
    end
    
    txt5=text(-150,y0,['$\omega_{MAX}:',num2str(round(omegaMax*rad2deg)),'\,^\circ/s$']);
    set(txt5,'FontSize',txtSize);

    if(isa(lambdaTv,'float'))
      txt6=text(-150,y0-yDelta,['$\lambda_V:',num2str(lambdaTv),'$']);
      set(txt6,'FontSize',txtSize);
    else
      txt6=text(-150,y0-yDelta,['$\lambda_V:',lambdaTv,'$']);  
      set(txt6,'FontSize',txtSize);
    end    
    
    if(subPlotRow==1)
        txtInf = text(-150,200,'Infeasible');
        set(txtInf,'FontSize',txtSize);
        txtFea = text(-150,180,'Feasible');        
        set(txtFea,'FontSize',txtSize);
        
%        text(-10,30,'$t_{end}$');
        lblTxt2 = text(-150,55,'$(\omega(t),\tau^M_{A}(t))$');
        set(lblTxt2,'Color',clr2);
        set(lblTxt2,'FontSize',txtSize);
    end    
    
    axisWidth = max(dataCurves(:,7).*rad2deg)...
               -min(dataCurves(:,7).*rad2deg);
    axisHeight= 1.2*tiso*tisoScale;
    lowerLeftCorner = [min(dataCurves(:,7).*rad2deg),0];
    if(subPlotRow==1)
        txtLbl = text(lowerLeftCorner(1),...
                      lowerLeftCorner(2)+1.05*axisHeight,'B.');
        set(txtLbl,'FontSize',7);
    else
        txtLbl = text(lowerLeftCorner(1),...
                      lowerLeftCorner(2)+1.05*axisHeight,'D.');
        set(txtLbl,'FontSize',7);        
    end
    %text(15,10,'$\tau_{HR}$');    
    xlabel('Angular Velocity (deg/s)','FontSize',txtSize);
    set(gca,'YTickLabel',[]);
    %ylabel('$\tau_{\omega}^{M}$ (Nm)');

    axis square;

    hold on;

end

