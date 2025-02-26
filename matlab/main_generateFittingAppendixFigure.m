clc;
close all;
clear all;

flag_usingOctave              = 0;
numberOfVerticalPlotRows      = 2;
numberOfHorizontalPlotColumns = 2;
plotConfigCustom;

flag_row1  = 1;
flag_row1a = 1;
flag_row1b = 1;
flag_row2  = 1;
flag_row2a = 1;
flag_row2b = 1;

figName = fullfile('..','figures','figAppExample.pdf');

dataLineWidth = 0.75;

dataFitPre  = csvread(fullfile('..','fittingExample','ael_InfoPre.csv'));
dataFitPost = csvread(fullfile('..','fittingExample','ael_InfoPost.csv'));

[angleDataPre, angleDataColNamesPre]=...
    getDataAndColumnNames(...
    fullfile('..','fittingExample','ael_initial_profile_variableLengthFixedVelocity.csv'));   
[velDataPre, velDataColNamesPre]=...
    getDataAndColumnNames(...
    fullfile('..','fittingExample','ael_initial_profile_fixedLengthVariableVelocity.csv'));   

[angleDataPost, angleDataColNamesPost]=...
    getDataAndColumnNames(...
    fullfile('..','fittingExample','ael_fitted_profile_variableLengthFixedVelocity.csv'));   
[velDataPost, velDataColNamesPost]=...
    getDataAndColumnNames(...
    fullfile('..','fittingExample','ael_fitted_profile_fixedLengthVariableVelocity.csv'));   

[parameterPre, parameterPreColNames] = ...
    getDataAndColumnNames(fullfile('..','fittingExample','mtgFitPlotDataPre.csv'));
[parameterPost, parameterPostColNames] = ...
    getDataAndColumnNames(fullfile('..','fittingExample','mtgFitPlotDataPost.csv'));



mtgNameFileId = fopen(fullfile('..','fittingExample','mtgNames.csv'));
mtgNamesTmp = textscan(mtgNameFileId,'%s');
fclose(mtgNameFileId);

mtgNames = cell(size(parameterPre,1),1);
for i=1:1:size(parameterPre,1)
    mtgNames{i} = mtgNamesTmp{1}{i};
end

idxMtg1      = getColumnIndex('AnkleExtensionLeft',mtgNames);
idxMtg2      = getColumnIndex('AnkleExtensionLeft',mtgNames);
idxTiso      = getColumnIndex('tiso', parameterPreColNames);
idxOmega     = getColumnIndex('omegaMax', parameterPreColNames);
idxLambdaTA  = getColumnIndex('lambdaTA', parameterPreColNames);
idxLambdaTPE = getColumnIndex('lambdaPE', parameterPreColNames);
idxLambdaTV  = getColumnIndex('lambdaTV', parameterPreColNames);
idxSA        = getColumnIndex('angleScalingTA',parameterPreColNames);
idxDeltaTPE  = getColumnIndex('anglePE',parameterPreColNames);

dirImages1 = [];
dirImages2 = [];

tisoPre  = parameterPre(idxMtg1,idxTiso);
tisoPost = parameterPost(idxMtg1,idxTiso);
tisoScale = tisoPost/tisoPre;
  
x0   = subPlotSquare(1,1);
y0   = subPlotSquare(1,2)-plotVertMargin;
dx0  = subPlotSquare(1,3)*0.95;
dy0  = subPlotSquare(1,4)*0.95;

dxM = plotHorizMargin/2.2;
dyM = plotVertMargin;

subPlotWidth = (2*dx0 + 2.5*dxM)*pageWidth;
subPlotHeight = (dyM+dy0*2+dyM*1.3)*pageHeight +0.3;

x0   = 1/subPlotWidth;
y0   = 1-((dy0)*pageHeight+1.2)/subPlotHeight;
dx0  = dx0*pageWidth/subPlotWidth;
dy0  = dy0*pageHeight/subPlotHeight;

dxM = dxM*pageWidth/subPlotWidth;
dyM = dyM*pageHeight/subPlotHeight;

if(flag_usingOctave==0)
  set(groot, 'defaultFigurePaperSize',[subPlotWidth subPlotHeight]);
  set(groot, 'defaultAxesFontSize',8);
  set(groot, 'defaultTextFontSize',8);  
end

fig_results = figure;

rad2deg = 180/pi;

angleRange    = [-30, 30].*(pi/180);
velocityRange = [-300,300].*(pi/180);
torqueRange   = [-1,18];
txtDx = 5;

clrFill0=[0.75,0.75,0.75];
dataClr1 = [0,0,0]./255;
dataClr2 = [146,0,0]./255;
txtSize = 6;


if(flag_row1==1)

    fig_results = addMTGRow(fig_results, ...
                                angleDataPre,angleDataColNamesPre,...
                                velDataPre, velDataColNamesPre,...
                                [],[],...
                                [], [],...
                                parameterPre, parameterPreColNames,...
                                'AnkleExtensionLeft', '', mtgNames,...
                                'Weakened Left Plantarflexor', 'A','B',...
                                dirImages1, dirImages2, ...
                                x0,y0,dx0,dy0, dxM, angleRange,...
                                velocityRange,torqueRange,0);



    subplot('Position',[x0,y0,dx0,dy0]);                        

        fh1 = fill([-50,-50,50,50,-50],[0,-10,-10,0,0],clrFill0,...
              'EdgeColor',clrFill0);
        uistack(fh1,'bottom');      
        hold on;
        
        if(flag_row1a==1)
            plot(-dataFitPre(:,1).*rad2deg, dataFitPre(:,2).*tisoPre,...
                'Color',dataClr1,'LineWidth',dataLineWidth);
            hold on;
            plot(-dataFitPre(1,1).*rad2deg, dataFitPre(1,2).*tisoPre,...
                '.','Color',dataClr1);
            hold on;
            
            lblTxt1 = text(-0,3.2,'$(\theta(t),\tau^M_{exp}(t))$');
            set(lblTxt1,'Color',dataClr1);
            %set(lblTxt1,'Rotation',-37.5);
            set(lblTxt1,'FontSize',txtSize);
            
        end


        lblTxt2 = text(5,11.,'Infeasible');
        set(lblTxt2,'Rotation',-35);
        set(lblTxt2,'FontSize',txtSize);

        lblTxt3 = text(5,7.5,'Feasible');
        set(lblTxt3,'Rotation',-33);
        set(lblTxt3,'FontSize',txtSize);
 
         text(txtDx+angleRange(1)*rad2deg, tisoPre-1,'$\tau_{o}$');

    subplot('Position',[(x0+dx0+dxM),y0,dx0,dy0]); 


        fh2=fill([-350,-350,350,350,-350],[0,-10,-10,0,0],clrFill0,...
              'EdgeColor',clrFill0);
        uistack(fh2,'bottom');
        hold on;    
        
        if(flag_row1b==1)
            plot( dataFitPre(:,3).*rad2deg, dataFitPre(:,4).*tisoPre,...
                'Color',dataClr2,'LineWidth',dataLineWidth);
            hold on;
            plot( dataFitPre(1,3).*rad2deg, dataFitPre(1,4).*tisoPre,...
                '.','Color',dataClr2);
            hold on;

            lblTxt01 = text(-50,3.2,'$(\omega(t),\tau^A(t))$');
            set(lblTxt01,'Color',dataClr2);
            %set(lblTxt01,'Rotation',20.);
            set(lblTxt01,'FontSize',txtSize);  
            set(lblTxt01,'HorizontalAlignment','Right');

        end
        lblTxt02 = text(-300,14,'Infeasible');
        set(lblTxt02,'FontSize',txtSize);
        lblTxt03 = text(-300,12,'Feasible');
        set(lblTxt03,'FontSize',txtSize);

                     
end

    y10 = y0 - dy0 - dyM*1.3;   
    
if(flag_row2 ==1)
    
    fig_results = addMTGRow(fig_results, ...
                                angleDataPost,angleDataColNamesPost,...
                                velDataPost, velDataColNamesPost,...
                                [],[],...
                                [], [],...
                                parameterPost, parameterPostColNames,...
                                'AnkleExtensionLeft', '', mtgNames,...
                                'Fitted Left PlantarFlexor', 'C','D',...
                                dirImages1, dirImages2, ...                            
                                x0,y10,dx0,dy0, dxM, angleRange,...
                                velocityRange,torqueRange,0);                        

    subplot('Position',[x0,y10,dx0,dy0]);                        

        fh3=fill([-50,-50,50,50,-50],[0,-10,-10,0,0],clrFill0,...
              'EdgeColor',clrFill0);
        uistack(fh3,'bottom');
        hold on;    
        
        if(flag_row2a==1)
            plot(-dataFitPost(:,1).*rad2deg, dataFitPost(:,2).*tisoPost,...
                'Color',dataClr1,'LineWidth',dataLineWidth);
            hold on;
            plot(-dataFitPost(1,1).*rad2deg, dataFitPost(1,2).*tisoPost,...
                '.','Color',dataClr1);
            hold on;
             text(txtDx+angleRange(1)*rad2deg, tisoPost-1,'$\tau_{o}$');
        end

    subplot('Position',[(x0+dx0+dxM),y10,dx0,dy0]);                        

        fh4=fill([-350,-350,350,350,-350],[0,-10,-10,0,0],clrFill0,...
              'EdgeColor',clrFill0);
        uistack(fh4,'bottom');
        hold on;    
        
        if(flag_row2b==1)
            plot( dataFitPost(:,3).*rad2deg, dataFitPost(:,4).*tisoPost,...
                'Color',dataClr2,'LineWidth',dataLineWidth);
            hold on;
            plot( dataFitPost(1,3).*rad2deg, dataFitPost(1,4).*tisoPost,...
                '.','Color',dataClr2);
            hold on;
        end

end    
set(fig_results,'Units','centimeters',...
   'PaperUnits','centimeters',...
   'PaperSize',[subPlotWidth subPlotHeight],...
   'PaperPositionMode','manual',...
   'PaperPosition',[0 0 subPlotWidth subPlotHeight]);     
   set(fig_results,'renderer','painters');     
   print('-dpdf','-r600', figName); 
   print('-dpdf','-r600', figName);       
          
    