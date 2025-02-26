%%
% Setup plot parameters
%%
%totalWidth = 177.13668/10; %Frontiers journal text width.
totalWidth = 21.0;


pageWidth  = 21.0;
pageHeight = 29.7;


if(flag_usingOctave == 0)
  set(groot, 'defaultAxesFontSize',7);
  set(groot, 'defaultTextFontSize',7);
  set(groot, 'defaultAxesLabelFontSizeMultiplier',1.0);
  set(groot, 'defaultAxesTitleFontSizeMultiplier',1.0);
  set(groot, 'defaultAxesTickLabelInterpreter','latex');
  set(groot, 'defaultLegendInterpreter','latex');
  set(groot, 'defaultTextInterpreter','latex');
  set(groot, 'defaultAxesTitleFontWeight','bold');  
  set(groot, 'defaultFigurePaperUnits','centimeters');
  set(groot, 'defaultFigurePaperSize',[pageWidth pageHeight]);
  set(groot,'defaultFigurePaperType','A4');
end
plotHorizMarginCm = 2;
plotVertMarginCm  = 2;

plotHorizMarginSplitCm = 0.5;
plotVertMarginSplitCm  = 2;

plotWidth = ((pageWidth-plotHorizMarginCm)/numberOfHorizontalPlotColumns);
plotHeight= ((pageHeight-plotVertMarginCm)/numberOfVerticalPlotRows);
if(plotWidth < plotHeight)
   plotHeight=plotWidth; 
else
   plotWidth=plotHeight;
end

plotWidth  = plotWidth/pageWidth;
plotHeight = plotHeight/pageHeight;
halfPlotHeight=0.5*plotHeight;
fullPlotHeight=plotHeight;

plotHorizMargin = plotHorizMarginCm/pageWidth;
plotVertMargin  = plotVertMarginCm/pageHeight;

plotHorizMarginSplit = plotHorizMarginSplitCm/pageWidth;
plotVertMarginSplit  = plotVertMarginSplitCm/pageHeight;


topLeft = [0/pageWidth pageHeight/pageHeight];

subPlotSquare = zeros(1,4);
subPlotSquare(1,1) = topLeft(1)  + plotHorizMargin;
subPlotSquare(1,2) = topLeft(2)  - plotVertMargin/3 - plotHeight;
subPlotSquare(1,3) = plotWidth;
subPlotSquare(1,4) = plotHeight;

subPlotPanel=zeros(numberOfVerticalPlotRows,numberOfHorizontalPlotColumns,4);

flag_short22Plot = 0;
idx=1;
scale=1;
for(ai=1:1:numberOfVerticalPlotRows)
  for(aj=1:1:numberOfHorizontalPlotColumns)
      if(idx==4 && flag_short22Plot==1)
         scale = 0.5;
      else
          scale=1;
      end
      subPlotPanel(ai,aj,1) = topLeft(1) + plotHorizMargin...
                            + (aj-1)*(plotWidth);
      subPlotPanel(ai,aj,2) = topLeft(2) -plotHeight-plotVertMargin ...                                       
                            + (ai-1)*(-plotHeight);
      subPlotPanel(ai,aj,3) = (plotWidth-plotHorizMarginSplit);
      subPlotPanel(ai,aj,4) = (plotHeight*scale-plotHorizMarginSplit);
      idx=idx+1;
  end
end


%%
%Line config
%%

lineColor             = [255 0  0;...
                         0   255   0;...
                         0   0   255]./255;                     
lineWidth             = [2,1,1];
lineType              ={'-','-','-'};

xTickTime = [0,0.5,1,1.5,2,2.5,3,3.5];


