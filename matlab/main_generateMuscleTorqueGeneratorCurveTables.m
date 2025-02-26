clc;
close all;
clear all;

flag_usingOctave              = 0;

%This is the number of points used in the table. The 
%csv tables have 1000 points, which is quite a lot.
npts = 100; 

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

mtgNames = cell(size(mtgNamesTmp{1},1),1);
for i=1:1:size(mtgNames,1)
    mtgNames{i} = mtgNamesTmp{1}{i};
end

velFilePostFix      = '_fixedLengthVariableVelocity.csv';
angleFilePostFix    = '_variableLengthFixedVelocity.csv';

%MTG names contains the names of the MTGs for the planar model.
%Since we just want the MTGs for each muscle group here we use
%this vector to pick out the MTGS for one leg, the torso, the neck, and
%one arm
mIdx = [1:6,13:18,19:24];
   
numberOfVerticalPlotRows      = length(mIdx);
numberOfHorizontalPlotColumns = 2;
plotHorizMarginSplitCm = 2;
plotVertMarginSplitCm = 2;
pageWidth = numberOfHorizontalPlotColumns*7;
pageHeight = numberOfVerticalPlotRows*7;
plotConfigCustom;

fig=figure;

angleTable = zeros(npts,length(mIdx));
angularVelocityTable = zeros(npts,length(mIdx));
taTable = zeros(npts,length(mIdx));
tpeTable = zeros(npts,length(mIdx));
tvTable = zeros(npts,length(mIdx));

fid = fopen(fullfile('..','curveTables','mtgNamesParameters.csv'),'w');

fprintf(fid,'%s,%s,%s,%s\n','name','tiso(Nm)','omegaMax(rad/s)','column');

for i=1:1:length(mIdx)
    
    
   mtgName1 = mtgNames{mIdx(i)};
   
   idxTiso = getColumnIndex('tiso',parameterColNames);
   tiso = parameterData(mIdx(i),idxTiso);
   idxOmegaMax=getColumnIndex('omegaMax',parameterColNames);
   omegaMax= parameterData(mIdx(i),idxOmegaMax);

   fprintf(fid,'%s,%1.6f,%1.6f,%i\n',mtgName1,tiso,omegaMax,i);


   %
   % Read in Torque-angle data
   %
   angleFileName1    = [mtgDataFolder,mtgName1,angleFilePostFix];
   [angleData1, angleDataColNames1]=getDataAndColumnNames(angleFileName1);   


   angle = angleData1(:, getColumnIndex('jointAngle',angleDataColNames1));
   activeTorqueAngleMultiplier = ...
       angleData1(:, getColumnIndex('activeTorqueAngleMultiplier',angleDataColNames1));
   passiveTorqueAngleMultiplier = ...
       angleData1(:, getColumnIndex('passiveTorqueAngleMultiplier',angleDataColNames1));
   %
   % Down sample
   %
   zeroOne = [0:(1/(length(angle)-1)):1]';
   zeroOneDs = [0:(1/(npts-1)):1]';
   angleDs = interp1(zeroOne,angle,zeroOneDs);
   activeTorqueAngleMultiplierDs = ...
        interp1(zeroOne,activeTorqueAngleMultiplier,zeroOneDs);
   passiveTorqueAngleMultiplierDs = ...
        interp1(zeroOne,passiveTorqueAngleMultiplier,zeroOneDs);

   angleTable(:,i)  = angleDs;
   taTable(:,i)     = activeTorqueAngleMultiplierDs;
   tpeTable(:,i)    = passiveTorqueAngleMultiplierDs;

   %
   % Plot
   %
   subplot('Position',reshape(subPlotPanel(i,1,:,:),1,4));
   plot(angle,activeTorqueAngleMultiplier,'-','Color',[1,1,1].*0.5,...
        'LineWidth',2,'DisplayName','$$t^A(\theta)$$');
   hold on;
   plot(angleDs,activeTorqueAngleMultiplierDs,'-','Color',[1,0,0],...
       'LineWidth',0.5,'DisplayName','$$t^A(\theta)$$ DS');
   hold on;
   plot(angle,passiveTorqueAngleMultiplier,'-','Color',[1,1,1].*0.5,...
       'LineWidth',2,'DisplayName','$$t^P(\theta)$$');
   hold on;
   plot(angleDs,passiveTorqueAngleMultiplierDs,'-','Color',[0,0,1],...
       'LineWidth',0.5,'DisplayName','$$t^P(\theta)$$ DS');
   hold on;


   xlabel('Joint Angle (radians)');
   ylabel('Torque Multiplier');
   
   xlim([min(angleDs),max(angleDs)]);
   ylim([0,1.01]);
   yticks([0,1]);

   if(i==1)
    legend('Location','NorthEast');
    legend('boxoff');
    title({[mtgName1,' $$\tau^A(\theta)$$ and $$\tau^P(\theta)$$'],...
           '(DS: downsample)'});
   else
    title([mtgName1,' $$\tau^A(\theta)$$ and $$\tau^P(\theta)$$']);
   end
   box off;

   %
   % Read in Torque-velocity data
   %
   
   velocityFileName1 = [mtgDataFolder,mtgName1,velFilePostFix];   
   [velData1,   velDataColNames1]  =getDataAndColumnNames(velocityFileName1);

   angularVelocity = ...
        velData1(:, getColumnIndex('jointVelocity',velDataColNames1));
   torqueVelocityMultiplier = ...
       velData1(:, getColumnIndex('torqueVelocityMultiplier',velDataColNames1));

   %
   % Down sample
   %
   zeroOne = [0:(1/(length(angularVelocity)-1)):1]';
   zeroOneDs = [0:(1/(npts-1)):1]';
   angularVelocityDs = interp1(zeroOne,angularVelocity,zeroOneDs);
   torqueVelocityMultiplierDs = ...
        interp1(zeroOne,torqueVelocityMultiplier,zeroOneDs);

   angularVelocityTable(:,i) = angularVelocityDs;
   tvTable(:,i) = torqueVelocityMultiplierDs;

   %
   % Plot
   %
   subplot('Position',reshape(subPlotPanel(i,2,:,:),1,4));
   plot(angularVelocity,torqueVelocityMultiplier,'-','Color',[1,1,1].*0.5,...
        'LineWidth',2,'DisplayName','$$t^V(\dot{\theta})$$');
   hold on;
   plot(angularVelocityDs,torqueVelocityMultiplierDs,'-','Color',[1,0,0],...
       'LineWidth',0.5,'DisplayName','$$t^V(\dot{\theta})$$ DS');
   

   
   xlabel('Joint Angular Velocity (radians/s)');
   ylabel('Torque Velocity Multiplier');   
   xlim([min(angularVelocityDs),max(angularVelocityDs)]);
   ylim([0,max(torqueVelocityMultiplierDs)+0.01]);
   yticks([0,1,round(max(torqueVelocityMultiplierDs),2)]);

   if(i==1)
    legend('Location','SouthWest');
    legend('boxoff');
    title({[mtgName1,' $$\tau^V(\dot{\theta})$$'],...
           '(DS: downsample)'});
   else
    title([mtgName1,' $$\tau^V(\dot{\theta})$$']);
   end
   box off;   


end

fclose(fid);

dlmwrite(fullfile('..','curveTables','jointAngle.csv'),...
    angleTable,',');
dlmwrite(fullfile('..','curveTables','jointAngularVelocity.csv'),...
    angularVelocityTable,',');
dlmwrite(fullfile('..','curveTables','activeTorqueAngleMultiplier.csv'),...
    taTable,',');
dlmwrite(fullfile('..','curveTables','passiveTorqueAngleMultiplier.csv'),...
    tpeTable,',');
dlmwrite(fullfile('..','curveTables','torqueVelocityMultiplier.csv'),...
    tvTable,',');


set(fig,'Units','centimeters',...
   'PaperUnits','centimeters',...
   'PaperSize',[pageWidth,pageHeight],...
   'PaperPositionMode','manual',...
   'PaperPosition',[0 0 pageWidth pageHeight]);     
   %set(findall(figList(i).h,'-property','FontSize'),'FontSize',10);     
   set(fig,'renderer','painters');     
   print('-dpdf', fullfile('..','figures',['fig_mtg_curveTables.pdf'])); 

   