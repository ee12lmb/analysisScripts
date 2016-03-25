%% Post-processing Script
%--------------------------------------------------------------------------------------------------
clear
close all
clc

addpath('~/project/source/dev/');
setup_env

%{ 
===================================================================================================
Analysing ouputs from the following batch job scripts;
 
/nfs/see-fs-01_teaching/ee12lmb/project/analysis/scripts/batch_runs/EBSD_QTZ_conv/Jconv_EBSD_QTZ_n10000.sh
/nfs/see-fs-01_teaching/ee12lmb/project/analysis/scripts/batch_runs/EBSD_QTZ_conv/MC_conv_EBSD_QTZ_n10000.sh
/nfs/see-fs-01_teaching/ee12lmb/project/analysis/scripts/batch_runs/EBSD_QTZ_conv/MD_conv_EBSD_QTZ_n10000.sh

Which output to directories;

/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/IR/Jconv_EBSD_QTZ_n10000.out
/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/IR/MC_conv_EBSD_QTZ_n10000.out
/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/IR/MD_conv_EBSD_QTZ_n10000.out

In order to create convergence plots for each index.
===================================================================================================
%}

addpath('/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/IR/Jconv_EBSD_QTZ_n10000.out')
addpath('/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/IR/MC_conv_EBSD_QTZ_n10000.out')
addpath('/nfs/see-fs-01_teaching/ee12lmb/project/analysis/outputs/IR/MD_conv_EBSD_QTZ_n10000.out')

% vector for number of grains used in each calculation
grains = [5;10;50;100;200;500;1000;2000;5000];
steps  = [1;4;7;9];
strain = [0.02;0.16;0.3;0.42];


% J index data
for i = 1:length(steps)

    for j = 1:length(grains)

        fname = sprintf('EBSD_QTZ_j_n%d_r50_STR_%d_sd1.out',grains(j),steps(i))
        j_raw(:,j,i)  = read_texout(fname);
        
        fname = sprintf('EBSD_QTZ_mc_n%d_r50_STR_%d_sd1.out',grains(j),steps(i))
        mc_raw(:,j,i) = read_texout(fname); 
        
%         fname = sprintf('EBSD_QTZ_md_n%d_r50_STR_%d_sd1.out',grains(j),steps(i))
%         md_raw(:,j,i) = read_texout(fname); 

    end
    
end

% add in other data load here

%% Calculate average and std

% j index
j_av = zeros(length(grains),length(steps)); % initialise matrices
j_std = j_av;

% continuous m index
mc_av = j_av;
mc_std = j_av;

% discrete m index
md_av = j_av;
md_std = j_av;

for i = 1:length(steps)
    
    for j = 1:length(grains)
        
        j_av(j,i)   = mean(j_raw(:,j,i));
        j_std(j,i)  = std(j_raw(:,j,i)); 
        
        mc_av(j,i)  = mean(mc_raw(:,j,i))
        mc_std(j,i) = std(mc_raw(:,j,i));
        
%         md_av(j,i)  = mean(md_raw(:,j,i))
%         md_std(j,i) = std(md_raw(:,j,i));
        
    end
end

%% Plot index vs no. grains

% set figure constants
%--------------------------------------------------------------------
t_h     = 0.93;   % text height (precentage of max y)
lwidth  = 1.5;    % width of lines
msize   = 5;      % size of markers
labsize = 15;     % text size for labels (e.g. x axis)
itemx   = 5;      % subplot label x position (e.g. a) in top left)
itemy   = 0.06;   % scaling to how far up the y axes labels should be
w       = 'bold'; % font weight
lw      = 'bold';   % weight of subplot letters
%--------------------------------------------------------------------


fig(1) = figure;
%=========================================================================
for i = 1:length(steps)
    
    % create subplot and plot each axis
    AX = subplot(2,2,i);
    P = get(AX,'pos') ;    % Get the position. 
    [AX,H1,H2] = plotyy(grains,j_av(:,i),grains,mc_av(:,i),'plot');
    
    set(fig(1),'CurrentAxes',AX(2))
    hold on
    %H3 = plot(grains,md_av(:,i));
    
    ymax = AX(2).YLim;     % get y axis limits
    ymax = ymax(2);        % set ymax
    
    
    % properties for each individual subplot
    if (i == 1)
        text(itemx,itemy*ymax,'a)','FontSize',labsize','FontWeight',lw);
        
        ylabel(AX(1),'J-index','FontWeight',w,'FontSize',labsize)
        
    elseif (i == 2)
        
        text(itemx,itemy*ymax,'b)','FontSize',labsize','FontWeight',lw);
        
%         % legend in top right
%         leg = legend([H1 H2 H3],{'J-index','M-index (cont.)','M-index (disc.)'},'Location','northeast');
%         leg.FontSize = labsize;
%         leg.FontWeight = w;
%         leg.Box = 'off';
        
        ylabel(AX(2),'M-index','FontWeight',w,'FontSize',labsize)
        
    elseif (i == 3)
        
        text(itemx,itemy*ymax,'c)','FontSize',labsize','FontWeight',lw);
        
        xlabel(AX(1),'No. grains','FontWeight',w,'FontSize',labsize)
        ylabel(AX(1),'J-index','FontWeight',w,'FontSize',labsize)
        
    elseif (i == 4)
        
        text(itemx,itemy*ymax,'d)','FontSize',labsize','FontWeight',lw);
        
        xlabel(AX(1),'No. grains','FontWeight',w,'FontSize',labsize)
        ylabel(AX(2),'M-index','FontWeight',w,'FontSize',labsize)
        
    end
      
    % add error bars to each axis individually
    set(fig(1),'CurrentAxes',AX(1))
    hold on
    errorbar(grains,j_av(:,i),j_std(:,i),'Color','k','LineStyle','none')
    
    set(fig(1),'CurrentAxes',AX(2))
    hold on
    errorbar(grains,mc_av(:,i),mc_std(:,i),'Color','k','LineStyle','none')
    %errorbar(grains,md_av(:,i),md_std(:,i),'Color','k','LineStyle','none')
   
    % format lines and axes
    set(AX,'xscale','log','Pos',P,'YColor','k','FontSize',labsize - 2,'FontWeight',w)
    set(H1,'LineStyle','-','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color','k','MarkerFaceColor','k')
    set(H2,'LineStyle',':','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color','k','MarkerFaceColor','k')
    %set(H3,'LineStyle','--','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color','k','MarkerFaceColor','k')
    
    title_str = sprintf('Strain = %i%%',strain(i)*100);
    title(title_str,'FontSize',labsize,'FontWeight',w)
    
    % print to pdf file
    set(fig(1),'PaperOrientation','landscape',...
               'PaperPositionMode', 'manual',...
               'PaperUnits','centimeters',...
               'Paperposition',[1 1 28.7 20])
    %print('~/project/doc/final/figs/OLV_AXC_Conv_INTERP.pdf','-painters','-dpdf','-r800')

    
end


%% Plot stdev vs no. grains

fig(2) = figure;
%=========================================================================
for i = 1:length(steps)
    
    AX = subplot(2,2,i);           % create subplot and plot each axis
    P = get(AX,'Pos');            % get the axes position
    [AX,H1,H2] = plotyy(grains,j_std(:,i),grains,mc_std(:,i));
    
    set(fig(2),'CurrentAxes',AX(2))
    hold on
    H3 = plot(grains,md_std(:,i));
    ymax = AX(2).YLim;
    ymax = ymax(2);
    itemx = 7;
    
    
    % properties for each individual subplot
    if (i == 1)
        
        text(itemx,itemy*ymax,'a)','FontSize',labsize','FontWeight',lw);
        
        ylabel(AX(1),'St. dev (J-index)','FontWeight',w,'FontSize',labsize)
        
    elseif (i == 2)
        
        text(itemx,itemy*ymax,'b)','FontSize',labsize','FontWeight',lw);
        
        % legend in top right
        leg = legend([H1 H2 H3],{'J-index','M-index (cont.)','M-index (disc.)'},'Location','northeast');
        leg.FontSize = labsize;
        leg.FontWeight = w;
        leg.Box = 'off';
        
        ylabel(AX(2),'St. dev (M-index)','FontWeight',w,'FontSize',labsize)
        
    elseif (i == 3)
        
        text(itemx,itemy*ymax,'c)','FontSize',labsize','FontWeight',lw);
        
        xlabel(AX(1),'No. grains','FontWeight',w,'FontSize',labsize)
        ylabel(AX(1),'St. dev (J-index)','FontWeight',w,'FontSize',labsize)
        
    elseif (i == 4)
        
        text(itemx,itemy*ymax,'d)','FontSize',labsize','FontWeight',lw);
        
        xlabel(AX(1),'No. grains','FontWeight',w,'FontSize',labsize)
        ylabel(AX(2),'St. dev (M-index)','FontWeight',w,'FontSize',labsize)
        
    end
      
    % format lines 
    set(AX,'xscale','log','Pos',P,'YColor','k','FontSize',labsize - 2,'FontWeight',w)
    set(H1,'LineStyle','-','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color','k','MarkerFaceColor','k')
    set(H2,'LineStyle',':','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color','k','MarkerFaceColor','k')
    set(H3,'LineStyle','--','LineWidth',lwidth,'Marker','o','MarkerSize',msize,'Color','k','MarkerFaceColor','k')
    
    title_str = sprintf('Strain = %i%%',strain(i)*100);
    title(title_str,'FontSize',labsize,'FontWeight',w)
        
    % print to pdf file
    set(fig(2),'PaperOrientation','landscape',...
               'PaperPositionMode', 'manual',...
               'PaperUnits','centimeters',...
               'Paperposition',[1 1 28.7 20])
    %print('~/project/doc/final/figs/OLV_AXC_std_conv_INTERP.pdf','-painters','-dpdf','-r800')
    
end