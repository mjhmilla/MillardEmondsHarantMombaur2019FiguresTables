clc;
close all;
clear all;

flag_usingOctave              = 0;
numberOfVerticalPlotRows      = 2;
numberOfHorizontalPlotColumns = 2;
plotConfigCustom;

rootFolder         = pwd;
mtgDataFolder      = fullfile('..','mtgData',filesep);
parametersFilePath = fullfile('..','resultsData','fittingParametersPre.csv');
mtgNameFilePath    = fullfile('..','mtgData','mtgNames.csv');

%%
%Load the starting parameters and names
%%
[parameterData, parameterColNames] = ...
    getDataAndColumnNames(parametersFilePath);

mtgNameFileId = fopen(mtgNameFilePath);
mtgNamesTmp = textscan(mtgNameFileId,'%s');
fclose(mtgNameFileId);

mtgNames = cell(size(parameterData,1),1);
for i=1:1:size(parameterData,1)
    mtgNames{i} = mtgNamesTmp{1}{i};
end



velFilePostFix      = '_fixedLengthVariableVelocity.csv';
angleFilePostFix    = '_variableLengthFixedVelocity.csv';

fig_mtg = figure;

x0   = subPlotSquare(1,1);
y0   = subPlotSquare(1,2)-plotVertMargin;
dx0  = subPlotSquare(1,3)*0.95;
dy0  = subPlotSquare(1,4)*0.95;

dxM = plotHorizMargin/2.2;
dyM = plotVertMargin;

subPlotWidth = (2*dx0 + 2.5*dxM)*pageWidth;
subPlotHeight= (dy0 + dyM)*pageHeight+0.3;


x0   = 1/subPlotWidth;
y0   = 1-((dy0)*pageHeight+1.3)/subPlotHeight;%y0*pageHeight/subPlotHeight;
dx0  = dx0*pageWidth/subPlotWidth;
dy0  = dy0*pageHeight/subPlotHeight;

dxM = dxM*pageWidth/subPlotWidth;
dyM = dyM*pageHeight/subPlotHeight;

idx= 1;

alphabet = {'A','B','C','D','E','F','G','H','I','J','K','L','M',...
            'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};


mIdx = [1,2,3,4,5,6,13,14,19,20,21,22,23,24];     
%Hip Ext/Flex
%Knee Ext/Flex
%Ankle Ext/Flex
%Lumbar Ext/Flex
%Shoulder Ext/Flex
%Elbow Ext/Flex
%Wrist Uln/Rad


nPlots = length(mIdx)*0.5;
fig(nPlots) = struct('h',[]);

if(flag_usingOctave==0)
  set(groot, 'defaultFigurePaperSize',[subPlotWidth subPlotHeight]);
  set(groot, 'defaultAxesFontSize',8);
  set(groot, 'defaultTextFontSize',8);  
end

dirImages1={...
  fullfile('..','insetImages','fig_HipExt.png'),...
  fullfile('..','insetImages','fig_KneeExt.png'),...
  fullfile('..','insetImages','fig_AnkleExt.png'),...
  fullfile('..','insetImages','fig_LumbarExt.png'),...
  fullfile('..','insetImages','fig_ShoulderExt.png'),...
  fullfile('..','insetImages','fig_ElbowExt.png'),...
  fullfile('..','insetImages','fig_WristUlnarDev.png')...
  };

dirImages2 = {...
  fullfile('..','insetImages','fig_HipFlex.png'),...
  fullfile('..','insetImages','fig_KneeFlex.png'),...
  fullfile('..','insetImages','fig_AnkleFlex.png'),...
  fullfile('..','insetImages','fig_LumbarFlex.png'),...
  fullfile('..','insetImages','fig_ShoulderFlex.png'),...
  fullfile('..','insetImages','fig_ElbowFlex.png'),...
  fullfile('..','insetImages','fig_WristRadialDev.png')...
};


fig = figure;
   

for i=1:1:nPlots
    
    
   mtgName1 = mtgNames{mIdx(idx)};
   idx=idx+1;
   mtgName2 = mtgNames{mIdx(idx)};
   idx=idx+1;
   
   angleFileName1    = [mtgDataFolder,mtgName1,angleFilePostFix];
   velocityFileName1 = [mtgDataFolder,mtgName1,velFilePostFix];   
   [angleData1, angleDataColNames1]=getDataAndColumnNames(angleFileName1);   
   [velData1,   velDataColNames1]  =getDataAndColumnNames(velocityFileName1);

   angleFileName2    = [mtgDataFolder,mtgName2,angleFilePostFix];
   velocityFileName2 = [mtgDataFolder,mtgName2,velFilePostFix];   
   [angleData2, angleDataColNames2]=getDataAndColumnNames(angleFileName2);   
   [velData2,   velDataColNames2]  =getDataAndColumnNames(velocityFileName2);
   
   
   xLabelName = '';
   yLabelName = '';
   titleName = '';
   
   jointName = '';
   dirPairName = '';
   flag_nameFound = 0;
   if(isempty(strfind(mtgName1,'Extension'))==0)
       z = strfind(mtgName1,'Extension');
       jointName = mtgName1(1:(z-1));
       dirPairName = 'Extension/Flexion.';
       flag_nameFound = 1;       
   end
   if(isempty(strfind(mtgName1,'Radial'))==0)
       z = strfind(mtgName1,'Radial');
       jointName = mtgName1(1:(z-1));
       dirPairName = 'Radal/Ulnar Deviation';       
       flag_nameFound = 1; 
       
       %tmp = mtgName1;
       %mtgName1=mtgName2;
       %mtgName2=tmp;
   end 
   
   if(isempty(strfind(mtgName1,'MiddleTrunk'))==0)
      jointName = 'Lumbar';
   end
   
   if(isempty(strfind(mtgName1,'Ankle'))==0)
      dirPairName = 'Plantarflexion/Dorsiflexion';
   end   
   
   titleName = [jointName,' ', dirPairName];
   subPlot1Title = [alphabet{idx-2}];
   subPlot2Title = [alphabet{idx-1}];   
   assert(flag_nameFound==1,'Direction of the MTG not found');
   
   fig = addMTGRow(fig, angleData1,angleDataColNames1,...
                                velData1, velDataColNames1,...
                                angleData2,angleDataColNames2,...
                                velData2, velDataColNames2,...
                                parameterData, parameterColNames,...
                                mtgName1, mtgName2, mtgNames,...
                                titleName, subPlot1Title,subPlot2Title,...
                                dirImages2{i}, dirImages1{i}, ... 
                                x0,y0,dx0,dy0, dxM, [],[],[], 1);
                            
    %y0 = y0 - dy0 - dyM;
    
    if(i==1)
      txtSize = 6;
      subplot('Position',[x0,y0,dx0,dy0]);
      
      lblTxt01 = text(0,90,'$a_{+} = 1$','HorizontalAlignment','center');      
        set(lblTxt01,'FontSize',txtSize);
        set(lblTxt01,'Color',[1,0,0]);
        set(lblTxt01,'Rotation',-33);        
      lblTxt02 = text(-30,10,'$a_{+} = 0$');      
        set(lblTxt02,'FontSize',txtSize);
        set(lblTxt02,'Color',[1,0,0]);
      lblTxt03 = text(-83,100,'$t^{PE}_{+}$');      
        set(lblTxt03,'FontSize',txtSize);
        set(lblTxt03,'Color',[1,0,0]);
      lblTxt04 = text(10,130,'$t^{A}_{+} + t^{PE}_{+}$','HorizontalAlignment','center');      
        set(lblTxt04,'FontSize',txtSize);
        set(lblTxt04,'Color',[1,0,0]);
        set(lblTxt04,'Rotation',-25);
        
       lblTxt05 = text(-45, 50,'Feasible','HorizontalAlignment','center');
         set(lblTxt05,'FontSize',txtSize);
       lblTxt06 = text(-45,-50,'Feasible','HorizontalAlignment','center');
         set(lblTxt06,'FontSize',txtSize);
       lblTxt05 = text(30,190,'Infeasible','HorizontalAlignment','right');
         set(lblTxt05,'FontSize',txtSize);        
        
        
      lblTxt11 = text(0,-120,'$a = 1$','HorizontalAlignment','center');      
        set(lblTxt11,'Color',[0,0,1]);      
        set(lblTxt11,'FontSize',txtSize);
        set(lblTxt11,'Rotation',20);
      lblTxt12 = text(-30,-10,'$a = 0$');      
        set(lblTxt12,'FontSize',txtSize);
        set(lblTxt12,'Color',[0,0,1]);            
      lblTxt13 = text(10,-70,'$t^{PE}$');      
        set(lblTxt13,'FontSize',txtSize);
        set(lblTxt13,'Color',[0,0,1]);
      lblTxt14 = text(0,-165,'$t^{A} + t^{PE}$','HorizontalAlignment','center');      
        set(lblTxt14,'FontSize',txtSize);
        set(lblTxt14,'Color',[0,0,1]);      
        set(lblTxt14,'Rotation',15);

        subplot('Position',[(x0+dx0+dxM),y0,dx0,dy0]);
          lblTxt21 = text(-500,160,'$t^{V}_{+}$');
          set(lblTxt21,'FontSize',txtSize);
          set(lblTxt21,'Color',[1,0,0]);
        
          lblTxt22 = text(420,-160,'$t^{V}$');
          set(lblTxt22,'FontSize',txtSize);
          set(lblTxt22,'Color',[0,0,1]);
        
          lblTxt23 = text(0,0,'Feasible','HorizontalAlignment','center');          
          set(lblTxt23,'FontSize',txtSize);
          set(lblTxt23,'Rotation',-35);
          lblTxt24 = text(500,190,'Infeasible','HorizontalAlignment','right');
          set(lblTxt24,'FontSize',txtSize);
          
    end
        
    
    pause(0.1);
    
    figure(fig);    
    set(fig,'Units','centimeters',...
       'PaperUnits','centimeters',...
       'PaperSize',[subPlotWidth subPlotHeight],...
       'PaperPositionMode','manual',...
       'PaperPosition',[0 0 subPlotWidth subPlotHeight]);     
       %set(findall(figList(i).h,'-property','FontSize'),'FontSize',10);     
       set(fig,'renderer','painters');     
       print('-dpdf', fullfile('..','figures',['fig_mtg_',num2str(i),'.pdf'])); 
       print('-dpdf', fullfile('..','figures',['fig_mtg_',num2str(i),'.pdf']));  
       
    pause(0.1);
   
    clf(fig)
end


   