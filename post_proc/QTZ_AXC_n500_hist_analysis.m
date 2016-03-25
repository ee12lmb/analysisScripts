%% Post-processing Script
%-------------------------------------------------------------------------
clear; close all; clc;

addpath('~/project/source/dev/');
setup_env

%{ 
===================================================================================================
Script reads in histograms from 

/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/M_Disc/QTZ_AXC_n500_hist.out/

The result of running m_indexDisc using the following commands;

VPSC = '/nfs/see-fs-01_teaching/ee12lmb/project/data/quartz_axial_compress_VPSC_big/TEX_PH1.OUT'
close all; tic; [~,~,~,h] = m_indexDisc(VPSC,500,1,'crystal','quartz','bin',1,'hist');toc
for i = 1:length(h); fname = sprintf('~/QTZ_AXC_n500_hist.out/QTZ_AXC_n500_hist_st%i.fig',i); savefig(h(i),fname);end

and moving the output directory to the above location.
===================================================================================================
%}

% add path to output dir
addpath('/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/M_Disc/QTZ_AXC_n500_hist.out/')

% total number of steps
nsteps = 27;
steps = [2;9;16;22];   % strain steps to extract

% Read in figures from file
for i = 1:27
    
    fname = sprintf('QTZ_AXC_n500_hist_st%i.fig',i);
    fig{i} = openfig(fname);
    
end

%% Begin new figure 
bigfig = figure('Name','Hist subplot');

lwidth = 2;
lwidth = 1.7;    % width of lines
msize = 2;       % size of markers
tsize = 13;      % text size for labels (e.g. x axis)
w = 'bold';      % font weight
lw = 'bold';     % weight of subplot letters

for i = 1:length(steps)
    
    % extract the axes handle
    axesObjs = get(fig{steps(i)}, 'Children');
    
    % extract the objects
    dataObjs = get(axesObjs, 'Children');
    
    % extract handles for line and histogram
    line  = findobj(dataObjs, 'type', 'line');
    patch = findobj(dataObjs, 'type', 'patch');
    
    % format line and histogram
    set(line,'LineWidth',lwidth,'Color','k')
    set(patch,'FaceColor','none','EdgeColor','k')
    
    % place histogram in subplot
    ax = subplot(2,2,i);
    copyobj(allchild(axesObjs),ax);
    
    % format axes and add labels
    set(ax,'YLim',[0 0.025],'XLim',[0 105],'FontSize',tsize,'FontWeight',w,'Box','on')
    
    
    if     (i == 1)
        ylabel('Frequency density','FontWeight',w,'FontSize',tsize)
        text(2.5,0.95*0.025,'a)','FontWeight',w,'FontSize',tsize)
    elseif (i == 2)
        text(2.5,0.95*0.025,'b)','FontWeight',w,'FontSize',tsize)
    elseif (i == 3)
        ylabel('Frequency density','FontWeight',w,'FontSize',tsize)
        xlabel('Misorientation (degrees)','FontWeight',w,'FontSize',tsize)
        text(2.5,0.95*0.025,'c)','FontWeight',w,'FontSize',tsize)
    elseif (i == 4)
        xlabel('Misorientation (degrees)','FontWeight',w,'FontSize',tsize)
        text(2.5,0.95*0.025,'d)','FontWeight',w,'FontSize',tsize)
    end
    
end

%==============================================================
% Print final figure to .pdf
set(bigfig,'PaperType','a4','Units','centimeters','Position',[0 0 22.9 18.6],'PaperPositionMode','auto')
print('~/project/doc/final/figs/QTZ_AXC_n500_misor_dist.pdf','-painters','-dpdf','-r800')
    
    
    
    
    
    
    
    