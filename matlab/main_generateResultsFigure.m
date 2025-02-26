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

figName = fullfile('..','figures','fig1ab2ab.pdf');

dataFitPre  = csvread(fullfile('..','resultsData','fitPlotDataPre_stoop2.csv'));
dataFitPost = csvread(fullfile('..','resultsData','fitPlotDataPost_stoop2.csv'));


[angleDataPre, angleDataColNamesPre]=...
    getDataAndColumnNames(...
    fullfile('..','resultsData','HipExtension_variableLengthFixedVelocity.csv'));   
[velDataPre, velDataColNamesPre]=...
    getDataAndColumnNames(...
    fullfile('..','resultsData','HipExtension_fixedLengthVariableVelocity.csv'));   

[angleDataPost, angleDataColNamesPost]=...
    getDataAndColumnNames(...
    fullfile('..','resultsData','fitted_HipExtension_variableLengthFixedVelocity.csv'));   
[velDataPost, velDataColNamesPost]=...
    getDataAndColumnNames(...
    fullfile('..','resultsData','fitted_HipExtension_fixedLengthVariableVelocity.csv'));   

[parameterPre, parameterPreColNames] = ...
    getDataAndColumnNames(fullfile('..','resultsData','fittingParametersPre.csv'));
[parameterPost, parameterPostColNames] = ...
    getDataAndColumnNames(fullfile('..','resultsData','fittingParametersPost.csv'));



mtgNameFileId = fopen(fullfile('..','mtgData','mtgNames.csv'));
mtgNamesTmp = textscan(mtgNameFileId,'%s');
fclose(mtgNameFileId);

mtgNames = cell(size(parameterPre,1),1);
for i=1:1:size(parameterPre,1)
    mtgNames{i} = mtgNamesTmp{1}{i};
end

idxMtg1      = getColumnIndex('HipExtension',mtgNames);
idxMtg2      = getColumnIndex('HipExtension',mtgNames);
idxTiso      = getColumnIndex('tiso', parameterPreColNames);
idxOmega     = getColumnIndex('omegaMax', parameterPreColNames);
idxLambdaTA  = getColumnIndex('lambdaTA', parameterPreColNames);
idxLambdaTPE = getColumnIndex('lambdaPE', parameterPreColNames);
idxLambdaTV  = getColumnIndex('lambdaTV', parameterPreColNames);
idxSA        = getColumnIndex('angleScalingTA',parameterPreColNames);
idxDeltaTPE  = getColumnIndex('anglePE',parameterPreColNames);

dirImages1 = [];%{'fig_HipFlex.png','fig_HipExt.png'};
dirImages2 = [];

tisoPre  = parameterPre(idxMtg1,idxTiso);
tisoPost = parameterPost(idxMtg1,idxTiso);
tisoScale = tisoPost/tisoPre;



% fig_results = addResultsRow(fig_results, 1, dataCurvesPre, dataFitPre,tisoScale,...
%                 parametersPre(1,1),parametersPre(1,2),parametersPre(1,3),...
%                 parametersPre(1,4),parametersPre(1,5),parametersPre(1,7),...
%                 parametersPre(1,6),...
%                 'Default Hip Extensors');
% fig_results = addResultsRow(fig_results, 2, dataCurvesPost, dataFitPost,1,...
%                 '\epsilon^{1/4}',parametersPost(1,2),'\epsilon^{1/4}',...
%                 parametersPost(1,4),parametersPost(1,5),parametersPost(1,7),...
%                 parametersPost(1,6),...
%                 'Fitted Hip Extensors');    
  
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

angleRange    = [-150, 10].*(pi/180);
velocityRange = [-150,150].*(pi/180);
torqueRange   = [-10,220];
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
                                'HipExtension', '', mtgNames,...
                                'Default Hip Extensors', 'A','B',...
                                dirImages1, dirImages2, ...
                                x0,y0,dx0,dy0, dxM, angleRange,...
                                velocityRange,torqueRange,0);



    subplot('Position',[x0,y0,dx0,dy0]);                        

        fh1 = fill([-180,-180,20,20,-180],[0,-10,-10,0,0],clrFill0,...
              'EdgeColor',clrFill0);
        uistack(fh1,'bottom');      
        hold on;
        
        if(flag_row1a==1)
            plot(-dataFitPre(:,1).*rad2deg, dataFitPre(:,2).*tisoPre,...
                'Color',dataClr1);
            hold on;
            plot(-dataFitPre(1,1).*rad2deg, dataFitPre(1,2).*tisoPre,...
                '.','Color',dataClr1);
            hold on;
            
            lblTxt1 = text(-80,110,'$(\theta(t),\tau^M_{exp}(t))$');
            set(lblTxt1,'Color',dataClr1);
            set(lblTxt1,'Rotation',-37.5);
            set(lblTxt1,'FontSize',txtSize);  
            
        end


        lblTxt2 = text(-31,190,'Infeasible');
        set(lblTxt2,'Rotation',-50);
        set(lblTxt2,'FontSize',txtSize);

        lblTxt3 = text(-31,140,'Feasible');
        set(lblTxt3,'Rotation',-50);
        set(lblTxt3,'FontSize',txtSize);
    %     
         text(txtDx+angleRange(1)*rad2deg, tisoPre-10,'$\tau_{o}$');

    %     text(20+txtDx+angleRange(1)*rad2deg, 210,...
    %         ['$s_{A}$:', num2str(round(parameterPre(idxMtg1,idxSA),2))]);
    %     text(20+txtDx+angleRange(1)*rad2deg, 185,...
    %         ['$\lambda_{A}$:',num2str(round(parameterPre(idxMtg1,idxLambdaTA),2))]);
    %     text(txtDx+angleRange(1)*rad2deg, 20, ...
    %         ['$\lambda_{P}$:',num2str(round(parameterPre(idxMtg1,idxLambdaTPE),2))]);
    %     text(txtDx+angleRange(1)*rad2deg, 0, ...
    %         ['$\Delta_{P}$:',num2str(round(parameterPre(idxMtg1,idxDeltaTPE),2))]);
    %     


    subplot('Position',[(x0+dx0+dxM),y0,dx0,dy0]); 


        fh2=fill([-150,-150,150,150,-150],[0,-10,-10,0,0],clrFill0,...
              'EdgeColor',clrFill0);
        uistack(fh2,'bottom');
        hold on;    
        
        if(flag_row1b==1)
            plot( dataFitPre(:,3).*rad2deg, dataFitPre(:,4).*tisoPre,...
                'Color',dataClr2);
            hold on;
            plot( dataFitPre(1,3).*rad2deg, dataFitPre(1,4).*tisoPre,...
                '.','Color',dataClr2);
            hold on;

            lblTxt01 = text(-50,35,'$(\omega(t),\tau^A(t))$');
            set(lblTxt01,'Color',dataClr2);
            set(lblTxt01,'Rotation',20.);
            set(lblTxt01,'FontSize',txtSize);  

        end
        lblTxt02 = text(-140,200,'Infeasible');
        set(lblTxt02,'FontSize',txtSize);
        lblTxt03 = text(-140,160,'Feasible');
        set(lblTxt03,'FontSize',txtSize);
        
    % 
    %     text(-10, 210, ...
    %         ['$s_{V}:',num2str(round(parameterPre(idxMtg1,idxOmega)*rad2deg)),'^\circ/s$']);
    % 
    %     text(20, 185, ...
    %         ['$\lambda_{V}$:',num2str(round(parameterPre(idxMtg1,idxLambdaTV),2))]);
    %     
                     
end

    y10 = y0 - dy0 - dyM*1.3;   
    
if(flag_row2 ==1)
    
    fig_results = addMTGRow(fig_results, ...
                                angleDataPost,angleDataColNamesPost,...
                                velDataPost, velDataColNamesPost,...
                                [],[],...
                                [], [],...
                                parameterPost, parameterPostColNames,...
                                'HipExtension', '', mtgNames,...
                                'Fitted Hip Extensors', 'C','D',...
                                dirImages1, dirImages2, ...                            
                                x0,y10,dx0,dy0, dxM, angleRange,...
                                velocityRange,torqueRange,0);                        

    subplot('Position',[x0,y10,dx0,dy0]);                        

        fh3=fill([-180,-180,20,20,-180],[0,-10,-10,0,0],clrFill0,...
              'EdgeColor',clrFill0);
        uistack(fh3,'bottom');
        hold on;    
        
        if(flag_row2a==1)
            plot(-dataFitPost(:,1).*rad2deg, dataFitPost(:,2).*tisoPost,...
                'Color',dataClr1);
            hold on;
            plot(-dataFitPost(1,1).*rad2deg, dataFitPost(1,2).*tisoPost,...
                '.','Color',dataClr1);
            hold on;
             text(txtDx+angleRange(1)*rad2deg, tisoPost-10,'$\tau_{o}$');
        end

    %     text(-60+angleRange(2)*rad2deg, 200,...
    %         ['$s_{A}$:', num2str(round(parameterPost(idxMtg1,idxSA),2))]);
    %     text(-60+angleRange(2)*rad2deg, 175,...
    %         ['$\lambda_{A}:\sqrt[4]{\epsilon}$']);
    %     text(txtDx+angleRange(1)*rad2deg, 25, ...
    %         ['$\lambda_{P}$: ',num2str(round(parameterPost(idxMtg1,idxLambdaTPE),2))]);
    %     text(txtDx+angleRange(1)*rad2deg, 0, ...
    %         ['$\Delta_{P}$:',num2str(round(parameterPost(idxMtg1,idxDeltaTPE)*rad2deg,2))]);
    %     

    subplot('Position',[(x0+dx0+dxM),y10,dx0,dy0]);                        

        fh4=fill([-150,-150,150,150,-150],[0,-10,-10,0,0],clrFill0,...
              'EdgeColor',clrFill0);
        uistack(fh4,'bottom');
        hold on;    
        
        if(flag_row2b==1)
            plot( dataFitPost(:,3).*rad2deg, dataFitPost(:,4).*tisoPost,...
                'Color',dataClr2);
            hold on;
            plot( dataFitPost(1,3).*rad2deg, dataFitPost(1,4).*tisoPost,...
                '.','Color',dataClr2);
            hold on;
        end
    %     text(-10, 210, ...
    %         ['$s_{V}:',num2str(round(parameterPost(idxMtg1,idxOmega)*rad2deg)),'^\circ/s$']);
    %     
    %     text(20, 185, ...
    %         ['$\lambda_{V}:\sqrt[4]{\epsilon}$']);

end    
set(fig_results,'Units','centimeters',...
   'PaperUnits','centimeters',...
   'PaperSize',[subPlotWidth subPlotHeight],...
   'PaperPositionMode','manual',...
   'PaperPosition',[0 0 subPlotWidth subPlotHeight]);     
   %set(findall(figList(i).h,'-property','FontSize'),'FontSize',10);     
   set(fig_results,'renderer','painters');     
   print('-dpdf','-r600', figName); 
   print('-dpdf','-r600', figName);       
          
    