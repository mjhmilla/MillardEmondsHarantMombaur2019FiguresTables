function figH = addMTGRow(figH,angleData1,angleColumns1,...
                               velData1, velColumns1,...
                               angleData2,angleColumns2,...
                               velData2, velColumns2,...
                               parameterData, parameterColumns,...
                               mtgName1,mtgName2,mtgNames,...
                               titleText,subPlot1Title,subPlot2Title,...
                               dirImageLeft,dirImageRight,...
                               plotLeft,plotBottom,...
                               plotWidth,plotHeight,...
                               plotHorizontalSpacing,...
                               angleRange,...
                               velocityRange,...
                               tauRange,...                               
                               flag_addAnnotations)

                           
clr0 = [0.5,0.5,0.5];
clr1 = [1,0,0];
clrGrid = [0.75,0.75,0.75];
clr2 = [0,0,1];

clrTp1 = clr1;
clrTp2 = clr2;
tpType = '-';

clrFill0=[0.75,0.75,0.75];
clrFill1=[1,1,1];
clrFill2=clrFill0;%[0.9,0.9,1];%[0.9,0.9,1];

clrFill0EdgeColor = clrFill0;
clrFill1EdgeColor = clrFill1;
clrFill2EdgeColor = clrFill2;


lineWidthNormal = 1;
lineWidthGrid   = 0.5;
lineWidthTp     = 0.1;
lineWidthTaTp   = 1.0;
lineWidthTaTpE  = 1;
lineWidthEdge   = 1;
                           
idxMtg1   = 0;
idxMtg2   = 0;
idxTiso   = getColumnIndex('tiso', parameterColumns);
idxOmega  = getColumnIndex('omegaMax', parameterColumns);

idxJointTorque = 0;
idxJointAngle = 0;
idxJointVelocity=0;
idxTaMult     = 0;
idxTvMult     = 0;
idxTpMult     = 0;

flag_series1Zero = 0;
flag_series2Zero = 0;

if(   (isempty(angleData2)==0 && isempty(velData2)==0)...
   &&  isempty(angleData1)==0 && isempty(velData1)==0)
    idxMtg1   = getColumnIndex(mtgName1,mtgNames);
    idxMtg2   = getColumnIndex(mtgName2,mtgNames);
end
if(   (isempty(angleData1)==1 && isempty(velData1)==1)...
   &&  isempty(angleData2)==0 && isempty(velData2)==0)
    angleData1      = zeros(size(angleData2));
    velData1        = zeros(size(velData2));    
    angleColumns1   = angleColumns2;
    velColumns1     = velColumns2;
    flag_series1Zero=1;
    
    idxMtg2   = getColumnIndex(mtgName2,mtgNames);
    idxMtg1   = idxMtg2;
    
end
if(   (isempty(angleData2)==1 && isempty(velData2)==1)...
   &&  isempty(angleData1)==0 && isempty(velData1)==0)
    angleData2      = zeros(size(angleData1));
    velData2        = zeros(size(velData1));    
    angleColumns2   = angleColumns1;
    velColumns2     = velColumns1;    
    flag_series2Zero=1;
    
    idxMtg1   = getColumnIndex(mtgName1,mtgNames);
    idxMtg2   = idxMtg1;    
end



idxJointTorque = getColumnIndex('jointTorque',angleColumns1);
idxJointAngle = getColumnIndex('jointAngle',angleColumns1);
idxJointVelocity=getColumnIndex('jointVelocity',angleColumns1);
idxTaMult     = getColumnIndex('activeTorqueAngleMultiplier',angleColumns1);
idxTvMult     = getColumnIndex('torqueVelocityMultiplier',angleColumns1);
idxTpMult     = getColumnIndex('passiveTorqueAngleMultiplier',angleColumns1);
    
tauSign1 = 0;
tauSign2 = 0;

tauPosKeywords = {'Ext','Rad'};
tauNegKeywords = {'Flex','Uln'};

yDirPos = '';
yDirNeg = '';
xDirPos = '';
xDirNeg = '';

for i=1:1:length(tauPosKeywords)
    if(isempty(strfind(mtgName1,tauPosKeywords{i})) == 0)
       tauSign1 = 1;  
       yDirPos = tauPosKeywords{i};
       yDirNeg = tauNegKeywords{i};
    end
    if(isempty(strfind(mtgName2,tauPosKeywords{i})) == 0)
       tauSign2 = 1;     
       yDirPos = tauPosKeywords{i};       
       yDirNeg = tauNegKeywords{i};       
    end
    if(isempty(strfind(mtgName1,tauNegKeywords{i})) == 0)
       tauSign1 = -1;     
       yDirPos = tauPosKeywords{i};       
       yDirNeg = tauNegKeywords{i};
    end
    if(isempty(strfind(mtgName2,tauNegKeywords{i})) == 0)
       tauSign2 = -1;     
       yDirPos = tauPosKeywords{i};              
       yDirNeg = tauNegKeywords{i};       
    end    
end

if(isempty(strfind(mtgName1,'Ankle'))==0)
    yDirPos = 'Pla';
    yDirNeg = 'Dor';
end



assert(tauSign1*tauSign2 == -1 || ...
       (flag_series1Zero==1 || flag_series2Zero==1),...
       'Joint torque signs do not make sense');

tiso1 = parameterData(idxMtg1,idxTiso)*(1-flag_series1Zero);
tiso2 = parameterData(idxMtg2,idxTiso)*(1-flag_series1Zero);

% err2=0;
% errMax2=1e10;
% err1=0;
% errMax1=1e10;
% for i=1:1:size(angleData1,1)
%     err1=angleData1(i,idxTpMult)-1;
%     err2=angleData2(i,idxTpMult)-1;
%     if(abs(err1) < errMax1)
%         angleTpeTiso1 = angleData1(i,idxJointAngle);
%         errMax1 = abs(err1);
%     end
%     if(abs(err2) < errMax2)
%         angleTpeTiso2 = angleData2(i,idxJointAngle);
%         errMax2 = abs(err2);
%     end    
% end






fv1Max = max(velData1(:,idxTvMult))*(1-flag_series1Zero);
fv2Max = max(velData2(:,idxTvMult))*(1-flag_series2Zero);

tauMaxE = 0;
tauMinE = 0;   
tauMaxIso = 0;
tauMinIso = 0;   
tauMin = 0;
tauMax = 0;

sign12 = 1;
if(tauSign1 == 1)
   tauMax = max(velData1(:,idxTvMult)).*(tiso1*tauSign1);
   tauMin = max(velData2(:,idxTvMult)).*(tiso2*tauSign2);
   tauMaxIso = tiso1*tauSign1;
   tauMinIso = tiso2*tauSign2;
   tauMaxE = tauMaxIso*fv1Max;
   tauMinE = tauMinIso*fv2Max;  
 
else 
   tauMin = max(velData1(:,idxTvMult)).*(tiso1*tauSign1);
   tauMax = max(velData2(:,idxTvMult)).*(tiso2*tauSign2);
   tauMinIso = tiso1*tauSign1;
   tauMaxIso = tiso2*tauSign2;
   tauMaxE = tauMaxIso*fv2Max;
   tauMinE = tauMinIso*fv1Max;   
     
end



if( abs(min(velData1(:,idxJointTorque)))  ...
        >= abs(max(velData1(:,idxJointTorque))) && tauSign1 == 1)
  sign12 = -1;
end


%Map the sign convention of the model's MTGs over to the anatomical
%convention. Here we are going for:
%
% Torque          : Ext+
% Angle           : Ext+
% Angular Velocity:
velData1(:,idxJointVelocity) = ...
    sign12.*velData1(:,idxJointVelocity);
velData1(:,idxJointAngle) = ...
    sign12.*velData1(:,idxJointAngle);



velData2(:,idxJointVelocity) = ...
    sign12.*velData2(:,idxJointVelocity);
velData2(:,idxJointAngle) = ...
    sign12.*velData2(:,idxJointAngle);



angleData1(:,idxJointAngle) = ...
    sign12.*angleData1(:,idxJointAngle);


angleData2(:,idxJointAngle) = ...
    sign12.*angleData2(:,idxJointAngle);



angleTiso1 = velData1(1,idxJointAngle);
angleTiso2 = velData2(1,idxJointAngle);

tauDelta = (tauMax-tauMin)/20;

tauMax = tauMax + tauDelta;
tauMin = tauMin - tauDelta;

if(sum(isempty(tauRange))==0)
   tauMin = tauRange(1); 
   tauMax = tauRange(2);    
end

angleMin = 0;
angleMax = 0;

if(flag_series1Zero ==0 && flag_series2Zero ==0 )
    if(min(angleData1(:,idxJointAngle)) < min(angleData2(:,idxJointAngle)))
       angleMin =  min(angleData2(:,idxJointAngle));
    else
       angleMin =  min(angleData1(:,idxJointAngle));    
    end

    if(max(angleData1(:,idxJointAngle)) > max(angleData2(:,idxJointAngle)))
       angleMax =  max(angleData2(:,idxJointAngle));
    else
       angleMax =  max(angleData1(:,idxJointAngle));    
    end
else
   if(flag_series1Zero == 1)
       angleMin =  min(angleData2(:,idxJointAngle));    
       angleMax =  max(angleData2(:,idxJointAngle));    
   end
   if(flag_series2Zero == 1)
       angleMin =  min(angleData1(:,idxJointAngle));    
       angleMax =  max(angleData1(:,idxJointAngle));           
   end

end

if(sum(isempty(angleRange)) == 0)
   angleMin=angleRange(1); 
   angleMax=angleRange(2);    
end


angleTpeTiso1 = NaN;
angleTpeTiso2 = NaN;

angleTpeTisoMin=NaN;
angleTpeTisoMax=NaN;

if(flag_series1Zero==0)
    if(max(angleData1(:,idxTpMult)) >= 1)
        idxs = find( diff(angleData1(:,idxTpMult))~=0);    
        angleTpeTiso1 = interp1(angleData1(idxs,idxTpMult),...
                                angleData1(idxs,idxJointAngle),...
                                1,'linear');
    end
end
if(flag_series2Zero == 0)
    if(max(angleData2(:,idxTpMult)) >= 1)
        idxs = find( diff(angleData2(:,idxTpMult))~=0); 
        angleTpeTiso2 = interp1(angleData2(idxs,idxTpMult),...
                                angleData2(idxs,idxJointAngle),...
                                1,'linear');    
    end
end

if(isnan(angleTpeTiso1)==0 && isnan(angleTpeTiso2)==0)
    if(angleTpeTiso1 < angleTpeTiso2)
        angleTpeTisoMin = angleTpeTiso1;
        angleTpeTisoMax = angleTpeTiso2;
    else
        angleTpeTisoMin = angleTpeTiso2;
        angleTpeTisoMax = angleTpeTiso1;        
    end    
end
if(isnan(angleTpeTiso1)==0 && isnan(angleTpeTiso2)==1)
    if(angleTpeTiso1 < (angleMax+angleMin)*0.5)
       angleTpeTisoMin =  angleTpeTiso1;
    else
       angleTpeTisoMax =  angleTpeTiso1; 
    end
end

if(isnan(angleTpeTiso1)==1 && isnan(angleTpeTiso2)==0)
    if(angleTpeTiso2 < (angleMax+angleMin)*0.5)
       angleTpeTisoMin =  angleTpeTiso2;
    else
       angleTpeTisoMax =  angleTpeTiso2; 
    end    
end

if(isnan(angleTpeTisoMax)==0 && sum(isempty(angleRange)) == 1)
   if(angleTpeTisoMax < angleMax)
      angleMax = angleTpeTisoMax*1.05; 
   end
end
if(isnan(angleTpeTisoMin)==0 && sum(isempty(angleRange)) == 1)
   if(angleTpeTisoMin > angleMin)
      angleMin = angleTpeTisoMin*1.05; 
   end
end


omegaMax1 = parameterData(idxMtg1,idxOmega);
omegaMax2 = parameterData(idxMtg2,idxOmega);
omegaMax = max(omegaMax1,omegaMax2);
 
rad2deg = 180/pi;

figure(figH);
subplot('Position',[plotLeft,plotBottom,plotWidth,plotHeight]);

    if(flag_series1Zero==0)
        tatp1 = angleData1(:,idxTaMult).*(tiso1*tauSign1)...
              +angleData1(:,idxTpMult).*(tiso1*tauSign1);
          
        if(flag_series2Zero==0)
           tatp1= tatp1   ...
                  + interp1(angleData2(:,idxJointAngle).*rad2deg,...
                       angleData2(:,idxTpMult).*(tiso2*tauSign2),...
                       angleData1(:,idxJointAngle).*rad2deg);
        end

        tatpE1 = angleData1(:,idxTaMult).*(tiso1*tauSign1*fv1Max)...
                 +angleData1(:,idxTpMult).*(tiso1*tauSign1);
        if(flag_series2Zero==0)
           tatpE1=  tatpE1 ...
                    +interp1(angleData2(:,idxJointAngle).*rad2deg,...
                             angleData2(:,idxTpMult).*(tiso2*tauSign2),...
                             angleData1(:,idxJointAngle).*rad2deg);
        end
                   
    end
    if(flag_series2Zero==0)
        tatp2 = angleData2(:,idxTaMult).*(tiso2*tauSign2)...
               +angleData2(:,idxTpMult).*(tiso2*tauSign2);
               


        if(flag_series1Zero ==0)
            tatp2=tatp2 ...
                 +interp1(angleData1(:,idxJointAngle).*rad2deg,...
                        angleData1(:,idxTpMult).*(tiso1*tauSign1),...
                        angleData2(:,idxJointAngle).*rad2deg);
        end
        tatpE2 = angleData2(:,idxTaMult).*(tiso2*tauSign2*fv2Max)...
               +angleData2(:,idxTpMult).*(tiso2*tauSign2);                
        if(flag_series1Zero ==0)
            tatpE2 =tatpE2 ...
                   + interp1(angleData1(:,idxJointAngle).*rad2deg,...
                        angleData1(:,idxTpMult).*(tiso1*tauSign1),...
                        angleData2(:,idxJointAngle).*rad2deg);   
        end

    end

                
    %Plot the feasible area between the passive curve and the tatp curves
    if(sum(clrFill1) < 3 && flag_series1Zero == 0)
        for i=2:1:size(angleData1,1)
           x0 = angleData1(i-1,idxJointAngle).*rad2deg;
           x1 = angleData1(i,idxJointAngle).*rad2deg;

           p0 = tatp1(i-1);
           p1 = tatp1(i);

           t0 = max(tatp1);
           if(tauSign1 < 0)
              t0 = min(tatp1); 
           end

           fill([x0,x0,x1,x1,x0]',[t0,p0,p1,t0,t0]',clrFill1,...
                'EdgeColor',clrFill1EdgeColor,...
                'LineWidth',lineWidthEdge);
           hold on;
        end
    end    
    if(sum(clrFill2)<3 && flag_series2Zero == 0)
        for i=2:1:size(angleData1,1)
           x1 = angleData2(i-1,idxJointAngle).*rad2deg;
           x0 = angleData2(i,idxJointAngle).*rad2deg;

           p1 = tatp2(i-1);
           p0 = tatp2(i);

           t0 = max(tatp2);
           if(tauSign2 < 0)
              t0 = min(tatp2); 
           end           

           fill([x0,x0,x1,x1,x0]',[t0,p0,p1,t0,t0]',clrFill2,...
                'EdgeColor',clrFill2EdgeColor,...
                'LineWidth',lineWidthEdge);
           hold on;
        end    
    end    
    %Plot infeasible areas under the passive curve
    %if(sum(clrFill2) < 3)
%     if(flag_series1Zero == 0)
%         for i=2:1:size(angleData1,1)
%            x0 = angleData1(i-1,idxJointAngle).*rad2deg;
%            x1 = angleData1(i,idxJointAngle).*rad2deg;
% 
%            p0 = angleData1(i-1,idxTpMult).*(tiso1*tauSign1);
%            p1 = angleData1(i,idxTpMult).*(tiso1*tauSign1);
% 
%            fill([x0,x0,x1,x1,x0]',[0,p0,p1,0,0]',clrFill2,...
%                 'EdgeColor',clrFill2EdgeColor,...
%                 'LineWidth',lineWidthEdge);
%            hold on;
%         end
%     end
    %if(sum(clrFill1)<3)
%     if(flag_series2Zero == 0)
%         for i=2:1:size(angleData2,1)
%            x0 = angleData2(i-1,idxJointAngle).*rad2deg;
%            x1 = angleData2(i,idxJointAngle).*rad2deg;
% 
%            p0 = angleData2(i-1,idxTpMult).*(tiso2*tauSign2);
%            p1 = angleData2(i,idxTpMult).*(tiso2*tauSign2);
% 
%            fill([x0,x0,x1,x1,x0]',[0,p0,p1,0,0]',clrFill1,...
%                 'EdgeColor',clrFill1EdgeColor,...
%                 'LineWidth',lineWidthEdge);
%            hold on;
%         end    
%     end
%     
    %Plot infeasible areas above the sum of the active and passive curves
    if(sum(clrFill0)<3 && flag_series1Zero == 0)
        for i=2:1:size(angleData1,1)
           x0 = angleData1(i-1,idxJointAngle).*rad2deg;
           x1 = angleData1(i,idxJointAngle).*rad2deg;

           p0 = tatp1(i-1);
           p1 = tatp1(i);

           t0 = max(tatp1);
           if(tauSign1 < 0)
              t0 = min(tatp1); 
           end

           fill([x0,x0,x1,x1,x0]',[t0,p0,p1,t0,t0]',clrFill0,...
               'EdgeColor',clrFill0EdgeColor,...
               'LineWidth',lineWidthEdge);
           hold on;
        end
    end

    if(sum(clrFill0)<3 && flag_series2Zero == 0)
        for i=2:1:size(angleData2,1)
           x0 = angleData2(i-1,idxJointAngle).*rad2deg;
           x1 = angleData2(i,idxJointAngle).*rad2deg;

           p0 = tatp2(i-1);
           p1 = tatp2(i);

           t0 = max(tatp2);
           if(tauSign2 < 0)
              t0 = min(tatp2); 
           end

           fill([x0,x0,x1,x1,x0]',[t0,p0,p1,t0,t0]',clrFill0,...
               'EdgeColor',clrFill0EdgeColor,...
               'LineWidth',lineWidthEdge);
           hold on;
        end      
    end
    %Plot the grid
    plot([0;0],[tauMin;tauMax],'Color',clrGrid,'LineWidth',lineWidthGrid);
    hold on;    
    
    if(flag_series1Zero == 0)
        plot( angleData1(:,idxJointAngle).*rad2deg, ...
              angleData1(:,idxTaMult).*(tiso1*tauSign1),...
            'Color',clr0,'LineWidth',lineWidthNormal);
        hold on;

        plot( angleData1(:,idxJointAngle).*rad2deg, ...
              angleData1(:,idxTpMult).*(tiso1*tauSign1),...
              tpType,'Color',clrTp1,'LineWidth',lineWidthTp);
        hold on;



        plot( angleData1(:,idxJointAngle).*rad2deg, ...
              tatpE1,'--',...
            'Color',clr0,'LineWidth',lineWidthTaTpE);
        hold on;

        plot( angleData1(:,idxJointAngle).*rad2deg, ...
              tatp1,'-',...
            'Color',clr1,'LineWidth',lineWidthTaTp);
        hold on;
    end
    
    if(flag_series2Zero==0)
        plot( angleData2(:,idxJointAngle).*rad2deg, ...
              angleData2(:,idxTaMult).*(tiso2*tauSign2),...
            'Color',clr0,'LineWidth',lineWidthNormal);
        hold on;

        plot( angleData2(:,idxJointAngle).*rad2deg, ...
              angleData2(:,idxTpMult).*(tiso2*tauSign2),...          
              tpType,'Color',clrTp2,'LineWidth',lineWidthTp);
        hold on;


        plot( angleData2(:,idxJointAngle).*rad2deg, ...
              tatpE2,'--',...
            'Color',clr0,'LineWidth',lineWidthTaTpE);
        hold on;  

        plot( angleData2(:,idxJointAngle).*rad2deg, ...
              tatp2,...
            'Color',clr2,'LineWidth',lineWidthTaTp);
        hold on;  
    end
    
    if(flag_series1Zero == 0 && flag_addAnnotations)
        if( angleTiso1 > angleMin && angleTiso1 < angleMax)
            plot(angleTiso1*rad2deg, tiso1*tauSign1,'.','Color',clr1,'MarkerSize',10);
            hold on;
            text(angleTiso1*rad2deg, (tiso1*tauSign1-(tiso1+tiso2)*tauSign1*0.15),...
                 ['$',num2str(round(angleTiso1*rad2deg)),'^\circ$'],...
                 'HorizontalAlignment','center');
            hold on;        
        end
    end
    
    if(flag_series2Zero == 0 && flag_addAnnotations)
        if(angleTiso2 > angleMin && angleTiso2 < angleMax)
            plot(angleTiso2*rad2deg, tiso2*tauSign2,'.','Color',clr2,'MarkerSize',10);
            hold on;

            text(angleTiso2*rad2deg,(tiso2*tauSign2-(tiso1+tiso2)*tauSign2*0.15),...
                 ['$',num2str(round(angleTiso2*rad2deg)),'^\circ$'],...
                 'HorizontalAlignment','center');
        end
    end
    
    angleWidth = angleMax-angleMin;
    tauHeight  = tauMax-tauMin;
    sp1txt = text((angleMin+angleMax)*0.5*rad2deg,...
                  tauMax+0.1*tauHeight,...
                  [subPlot1Title,'. Torque-Angle'],...
                  'HorizontalAlignment','center');
    %set(sp1txt,'FontSize',8);
    
    centerX = ( angleMax + ...
                plotHorizontalSpacing*0.5*(angleWidth/plotWidth))*rad2deg;
    titleY  = tauMax+ 0.3*tauHeight;
    ttxt = text(centerX,titleY,titleText);
    set(ttxt,'FontSize',10);
    set(ttxt,'HorizontalAlignment','center');
    dirPosV1 = text((angleMin-0.25*angleWidth)*rad2deg,...
                    tauMax+tauHeight*0.05, [yDirPos,'.']);
    %set(dirPosH,'Rotation',90);
    %set(dirPosH,'HorizontalAlignment','center');
    dirNegV1 = text((angleMin-0.25*angleWidth)*rad2deg,...
                    tauMin-tauHeight*0.05, [yDirNeg,'.']);
                

    dirPosH2 = text((angleMax)*rad2deg,...
                    tauMin-tauHeight*0.245, [yDirPos,'.'],...
                    'HorizontalAlignment','center');
    dirNegH2 = text((angleMin)*rad2deg,...
                    tauMin-tauHeight*0.245, [yDirNeg,'.'],...
                    'HorizontalAlignment','center');    
     
                
           
    xTickMin = [];
    if(angleTpeTisoMin > angleMin)
        xTickMin = round(angleTpeTisoMin*rad2deg);
    else
        z = floor(abs(angleMin*rad2deg/45));
        xTickMin = [z:-1:1].*(-45);
    end
    
    xTickMax = [];
    if(angleTpeTisoMax < angleMax)
        xTickMax = round(angleTpeTisoMax*rad2deg);
    else
        z = floor(abs(angleMax*rad2deg/45));
        xTickMax = [1:1:z].*(45);
    end
    
    xTicks=[];
    if(sum(isempty(xTickMin))==0 && sum(isempty(xTickMax))==0)
        if(xTickMin(end) > -20)
            xTicks = round([xTickMin,xTickMax]);
        elseif(xTickMax(1) < 20)
            xTicks = round([xTickMin,xTickMax]);
        else
            xTicks = round([xTickMin,0,xTickMax]);
        end
    end
    
    
    
    
    if(flag_series1Zero == 0 && flag_series2Zero == 0)                
        set(gca,'ytick',[round(tauMinIso),0,round(tauMaxIso)]);
    elseif(tauMinIso == 0)
        set(gca,'ytick',[0,round(tauMaxIso)]);            
    elseif(tauMaxIso == 0)
        set(gca,'ytick',[0,round(tauMaxIso)]);            
    end
    
    if(flag_series1Zero == 0 && flag_series2Zero == 0)
        set(gca,'xtick',xTicks);
    else
        if(flag_series1Zero == 0)
            xTick = sort([angleTiso1, 0].*rad2deg);            
            if(isnan(angleTpeTiso1)==0)
                xTick = sort([angleTpeTiso1, angleTiso1, 0].*rad2deg);
            end
            set(gca,'xtick',round(xTick));            
        else
            xTick = sort([angleTiso2, 0].*rad2deg);            
            if(isnan(angleTpeTiso2)==0)
                xTick = sort([angleTpeTiso2, angleTiso2, 0].*rad2deg);
            end
            set(gca,'xtick',round(xTick));            
        end
        
    end
    axis([angleMin*rad2deg angleMax*rad2deg tauMin tauMax]);   
    
    %ylabel('Torque (Nm)');
    ytxt = text((angleMin-0.25*angleWidth)*rad2deg,...
                 (tauMin+ 0.4*(tauMax-tauMin)),...
                 'Torque (Nm)',...
                 'HorizontalAlignment','center');
    %set(ytxt,'FontSize',8);
    set(ytxt,'Rotation',90);
    
    
    plot([angleMin*rad2deg,angleMax*rad2deg],[0,0],'Color',clrGrid,...
         'LineWidth',lineWidthGrid);
    hold on;
    
    xlabel('Angle ($^\circ$)');
    axis square;
    box off;
    
    set(gca,'Layer','Top');
% Img = imread('ISEP.jpg');
% ImgSize = size(Img);
% AxesH = axes('Units', 'pixels',...
%              'position', [10 20 180 30], ...
%              'YDir', 'reverse', ...
%              'XLim', [0, ImgSize(2)], ...
%              'YLim', [0, ImgSize(1)], ...
%              'NextPlot', 'add', ...
%              'Visible', 'off');
% image(Img, 'Parent', AxesH);    
    
    
    if(isempty(dirImageLeft)==0 && isempty(dirImageRight)==0)
        yS = 0.2;
        xS = (117/148)*0.15;
        yOff= 0.01*plotHeight;
        
        [imgLeft, mapLeft,alphaLeft] = imread(dirImageLeft);
        dx0 = plotWidth*xS;
        x0  = plotLeft-0.25*dx0;        
        y0  = plotBottom+plotHeight+yOff;
        dy0 = plotHeight*yS;    
        subplot('Position',[x0,y0,dx0,dy0]);        
        fL = image(imgLeft);
        set(fL,'AlphaData',alphaLeft);
        box off;
        axis off;
        [imgRight, mapRight,alphaRight] = imread(dirImageRight);
        
        dx1 = plotWidth*xS;        
        x1  = plotLeft+plotWidth-dx1*0.75;
        y1  = plotBottom+plotHeight+yOff;
        dy1 = plotHeight*yS;    
        subplot('Position',[x1,y1,dx1,dy1]);        
        fR = image(imgRight);
        set(fR,'AlphaData',alphaRight);
        box off;
        axis off;
    end
    
plotLeft2 = plotLeft + plotWidth + plotHorizontalSpacing;
subplot('Position',[plotLeft2,plotBottom,plotWidth,plotHeight]);
    
    if(sum(clrFill1)<3 && flag_series1Zero == 0)
        for i=2:1:size(velData1,1)
           x0 = velData1(i-1,idxJointVelocity).*rad2deg;
           x1 = velData1(i,idxJointVelocity).*rad2deg;

           p0 = velData1(1,idxTvMult).*(tiso1*tauSign1);
           p1 = velData1(1,idxTvMult).*(tiso1*tauSign1);

           t0 = max(velData1(:,idxTvMult)).*(tiso1*tauSign1*1.5);

           fill([x0,x0,x1,x1,x0]',[t0,p0,p1,t0,t0]',clrFill1,...
                'EdgeColor',clrFill1EdgeColor,...
                'LineWidth',lineWidthEdge);
           hold on;
        end
    end
    if(sum(clrFill2)<3 && flag_series2Zero == 0)
        for i=2:1:size(velData2,1)
           x0 = velData2(i-1,idxJointVelocity).*rad2deg;
           x1 = velData2(i,idxJointVelocity).*rad2deg;

           p0 = velData2(1,idxTvMult).*(tiso2*tauSign2);
           p1 = velData2(1,idxTvMult).*(tiso2*tauSign2);

           t0 = max(velData2(:,idxTvMult)).*(tiso2*tauSign2*1.5);

           fill([x0,x0,x1,x1,x0]',[t0,p0,p1,t0,t0]',clrFill2,...
                'EdgeColor',clrFill2EdgeColor,...
                'LineWidth',lineWidthEdge);
           hold on;
        end
    end
    plot([-omegaMax*1.5;omegaMax*1.5].*rad2deg,[0;0],...
            'Color',clrGrid,'LineWidth',lineWidthGrid);
    hold on;
    plot([0;0],[tauMin;tauMax],...
            'Color',clrGrid,'LineWidth',lineWidthGrid);
    hold on;
    plot([-omegaMax*1.5;0].*rad2deg,[tauMaxIso;tauMaxIso],...
            'Color',clrGrid,'LineWidth',lineWidthGrid);
    hold on;
    plot([0;omegaMax*1.5].*rad2deg,[tauMinIso;tauMinIso],...
            'Color',clrGrid,'LineWidth',lineWidthGrid);
    hold on;

    
    
    omegaMaxPos = 0;
    omegaMaxNeg = 0;
    
    if(flag_series1Zero == 0 && flag_series2Zero == 0)
        if(tauSign1 == 1)
            omegaMaxPos = omegaMax1*tauSign1;
            omegaMaxNeg = omegaMax2*tauSign2;        
        else
            omegaMaxPos = omegaMax2*tauSign2;
            omegaMaxNeg = omegaMax1*tauSign1;                
        end
    else
        if(omegaMax1 == 0)
            omegaMaxPos = abs(omegaMax1);
            omegaMaxNeg = -abs(omegaMax1);        
        else
            omegaMaxPos = abs(omegaMax2);
            omegaMaxNeg = -abs(omegaMax2);                    
        end
    end
       

 
    
    %Plot infeasible areas outside of the fv curves
    
    if(sum(clrFill0) < 3 && flag_series1Zero == 0)
        if(abs(omegaMaxNeg) > abs(omegaMaxPos))      
           w =abs(omegaMaxNeg)-abs(omegaMaxPos);
           x0 = omegaMaxNeg.*rad2deg;
           x1 = (omegaMaxNeg + w ).*rad2deg;

           p0 = velData1(1,idxTvMult).*(tiso1*tauSign1);
           p1 = velData1(1,idxTvMult).*(tiso1*tauSign1);

      
           t0 = max(velData1(:,idxTvMult)).*(tiso1*tauSign1*1.5);


           fill([x0,x0,x1,x1,x0]',[t0,p0,p1,t0,t0]',...
               clrFill0,'EdgeColor',clrFill0EdgeColor,...
               'LineWidth',lineWidthEdge);
           hold on;

           plot( [x0;x1], ...
                 [p0;p1],...
                 'Color',clr1,'LineWidth',lineWidthNormal);
           hold on;        
        end
    end
    if(sum(clrFill0)<3 && flag_series2Zero == 0)
        if(abs(omegaMaxNeg) < abs(omegaMaxPos))      
           w =abs(omegaMaxNeg)-abs(omegaMaxPos);
           x0 = omegaMaxPos.*rad2deg;
           x1 = (omegaMaxPos + w ).*rad2deg;

           p0 = velData2(1,idxTvMult).*(tiso2*tauSign2);
           p1 = velData2(1,idxTvMult).*(tiso2*tauSign2);

           t0 = max(velData2(:,idxTvMult)).*(tiso2*tauSign2*1.5);
      
           fill([x0,x0,x1,x1,x0]',[t0,p0,p1,t0,t0]',...
               clrFill0,'EdgeColor',clrFill0EdgeColor,...
               'LineWidth',lineWidthEdge);
           hold on;

           plot( [x0;x1], ...
                 [p0;p1],...
                 'Color',clr2,'LineWidth',lineWidthNormal);
           hold on;        
        end    
    end
    
    if(sum(clrFill0)<3 && flag_series1Zero == 0)
        for i=2:1:size(velData1,1)
           x0 = velData1(i-1,idxJointVelocity).*rad2deg;
           x1 = velData1(i,idxJointVelocity).*rad2deg;

           p0 = velData1(i-1,idxTvMult).*(tiso1*tauSign1);
           p1 = velData1(i,  idxTvMult).*(tiso1*tauSign1);

           t0 = max(velData1(:,idxTvMult)).*(tiso1*tauSign1*1.5);
     
           fill([x0,x0,x1,x1,x0]',[t0,p0,p1,t0,t0]',...
               clrFill0,'EdgeColor',clrFill0EdgeColor,...
               'LineWidth',lineWidthEdge);
           hold on;
        end    
    end
    
    if(sum(clrFill0)<3 && flag_series2Zero == 0)
        for i=2:1:size(velData1,1)
           x0 = velData2(i-1,idxJointVelocity).*rad2deg;
           x1 = velData2(i,idxJointVelocity).*rad2deg;

           p0 = velData2(i-1,idxTvMult).*(tiso2*tauSign2);
           p1 = velData2(i,  idxTvMult).*(tiso2*tauSign2);

           t0 = max(velData2(:,idxTvMult)).*(tiso2*tauSign2*1.5);
       
           fill([x0,x0,x1,x1,x0]',[t0,p0,p1,t0,t0]',...
               clrFill0,'EdgeColor',clrFill0EdgeColor,...
               'LineWidth',lineWidthEdge);
           hold on;
        end     
    end
    
    tauAtHalfOmega1 = 0;
    tauAtHalfOmega2 = 0;
    if(flag_series1Zero == 0 )
        tauAtHalfOmega1 = interp1(velData1(:,idxJointVelocity),...
                                  velData1(:,idxTvMult),...
                                  omegaMax1*tauSign1*0.5);
    end
    if(flag_series2Zero == 0)
        tauAtHalfOmega2 = interp1(velData2(:,idxJointVelocity),...
                                  velData2(:,idxTvMult),...
                                  omegaMax2*tauSign2*0.5);    
    end                      
    tauMinCHalf = 0;
    tauMaxCHalf = 0;
    if(tauSign1==1)
      if(flag_series2Zero == 0)
        tauMinCHalf = tauAtHalfOmega2*tiso2*tauSign2;
      end
      if(flag_series1Zero == 0)
        tauMaxCHalf = tauAtHalfOmega1*tiso1*tauSign1;        
      end
    else
      if(flag_series2Zero == 0)
        tauMaxCHalf = tauAtHalfOmega2*tiso2*tauSign2;
      end
      if(flag_series1Zero == 0)
        tauMinCHalf = tauAtHalfOmega1*tiso1*tauSign1;                       
      end
    end
                   
    if(flag_series1Zero == 0)
        plot( velData1(:,idxJointVelocity).*rad2deg, ...
              velData1(:,idxTvMult).*(tiso1*tauSign1),...
            'Color',clr1,'LineWidth',lineWidthNormal);
        hold on;
        if(flag_addAnnotations)
            plot(omegaMax1*tauSign1*rad2deg*0.5, ...
                 tauAtHalfOmega1*tiso1*tauSign1,...
                '.','Color',clr1,'MarkerSize',10);
            hold on;
            plot(0, tiso1*tauSign1,'.','Color',clr1,'MarkerSize',10);
            hold on;
        end
        
    end
    if(flag_series2Zero == 0)
        plot( velData2(:,idxJointVelocity).*rad2deg, ...
              velData2(:,idxTvMult).*(tiso2*tauSign2),...
            'Color',clr2,'LineWidth',lineWidthNormal);
        hold on;
        if(flag_addAnnotations)
            plot(omegaMax2*tauSign2*rad2deg*0.5, ...
                tauAtHalfOmega2*tiso2*tauSign2,...
                '.','Color',clr2,'MarkerSize',10);
            hold on;
            plot(0, tiso2*tauSign2,'.','Color',clr2,'MarkerSize',10);
            hold on;    
        end
    end

    
    

    omegaMaxLeft = omegaMaxNeg;
    omegaMaxRight = omegaMaxPos;

    if(sum(isempty(velocityRange))==0)
        omegaMaxLeft = velocityRange(1);
        omegaMaxRight = velocityRange(2);        
    end
    omegaWidth = omegaMaxRight-omegaMaxLeft;
    
    dirPosH2 = text((omegaMaxRight)*rad2deg,...
                    tauMin-tauHeight*0.245, [yDirPos,'.'],...
                    'HorizontalAlignment','center');
    dirNegH2 = text((omegaMaxLeft)*rad2deg,...
                    tauMin-tauHeight*0.245, [yDirNeg,'.'],...
                    'HorizontalAlignment','center');
    
    sp2txt = text((omegaMaxLeft+omegaMaxRight)*0.5*rad2deg,...
                  tauMax+0.1*tauHeight,...
                  [subPlot2Title,'. Torque-Velocity'],...
                  'HorizontalAlignment','center');
    %set(sp2txt,'FontSize',6);                
                
    if(flag_series1Zero == 0 && flag_series2Zero == 0)
        set(gca,'ytick',[round(tauMinE),...
                         round(tauMinCHalf),...
                         round(tauMaxCHalf),...
                         round(tauMaxE)]);        
    else
        if(abs(tauMinCHalf) > 0 && abs(tauMaxCHalf) ==  0)
            set(gca,'ytick',[round(tauMinE),...
                             round(tauMinCHalf),...
                             round(tauMaxE)]);                    
        end
        if(abs(tauMaxCHalf) > 0 && abs(tauMinCHalf) == 0)
            set(gca,'ytick',[round(tauMinE),...
                             round(tauMaxCHalf),...
                             round(tauMaxE)]);                                
        end
        
    end
    
    
    
%     plot([omegaMaxNeg,omegaMaxNeg*0.5,omegaMaxNeg*0.5].*rad2deg,...
%          [tauMinCHalf,tauMinCHalf,tauMin],...
%          'Color',clrGrid,'LineWidth',lineWidthGrid);
%     hold on;
%     plot([omegaMaxNeg,omegaMaxPos*0.5,omegaMaxPos*0.5].*rad2deg,...
%          [tauMaxCHalf,tauMaxCHalf,tauMin],...
%          'Color',clrGrid,'LineWidth',lineWidthGrid);
%     hold on;
    
    if(sum(isempty(velocityRange))==0)
        delta = (velocityRange(2)-velocityRange(1))*rad2deg*0.01;
        axis([(velocityRange(1)*rad2deg-delta) (velocityRange(2)*rad2deg+delta) tauMin tauMax]);  
    else
        axis([omegaMaxNeg*rad2deg*1.01 omegaMaxPos*rad2deg*1.01 tauMin tauMax]);  
    end
    
    if(sum(isempty(velocityRange))==0)
        set(gca,'xtick',[round(velocityRange(1)*rad2deg),...
                         0,...
                         round(velocityRange(2)*rad2deg)]);        
    else
        set(gca, 'xtick',[round(omegaMaxNeg.*rad2deg),...
                          0,...
                          round(omegaMaxPos.*rad2deg)]);
    end
    axis square;
    box off;
    
    xlabel('Vel. ($^\circ/s$)');

    plot([omegaMaxNeg*rad2deg*1.01,omegaMaxPos*rad2deg*1.01],...
         [0,0],'Color',clrGrid,...
        'LineWidth',lineWidthGrid);
    hold on;
     
    set(gca,'Layer','Top');
    