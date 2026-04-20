% Create Figure 5 of
%    "Beyond Long-Term Changes: Interannual Variability 
%     of Carbon Uptake due to Sea Ice Loss in the Western 
%     Arctic Ocean"
% by Zhou et al.
%
% The figure includes the following subpanels:
%   - (a) yearly UCO2 and seasonal FCO2 at Canada Basin station
%   - (b) the same as (a) but for Chukchi Sea station
%
%             Author: Tianyu Zhou and Yun Li, UDel, 04/01/2026

clc; clear; close all; info_params
%=====================================================
% edit the following based on the user's needs
isfig = 1; ffig = [fdir_MSfig 'fig5_stn_contrast'];
%=====================================================
%#####################
%## figure settings ##
%#####################
fsize = 7;
fgx = 0.10; fgw = 0.60; cffw = [0.04 0.14];
fgy = 0.45; fgh = 0.32; fgdh = fgh+0.03;
xticks= obs_yrs; xlims = xticks([1 end])+0.53*[-1 1]; % year lims
xticklabels = datestr(datenum(xticks,1,1),'yy');      % year labels
mlims = t8d_clm(bid_M2A([1 end])+[-1 1]);             % month lims
mticks= datenum(0,1:12,1);                            % month ticks
mticklabels = datestr(mticks,'mmm');                  % month ticklabels
plims = mlims-mlims(1);                               % Pow lims
pticks= 0:30:120;                                     % Pow ticks
Uticks= 0:0.1:10;                                     % UCO2 lims
clims = [0 0.25]; cticks = 0:0.05:0.4;                % cflux lims
load(fcmap_FCO2); colormap(cmap);                     % color scheme of FCO2

%###############
%## load data ##
%###############
load(fdiag)
doys = unique(diag.stn.doy)';  Ndoy=length(doys);     % doy of year for 8-day time series
years= unique(diag.stn.year)'; Nyrs=length(years);    % years from 2003-2022

%##############################
%## month-year map & Tseries ##
%##############################
for ks = 1:size(stninfo,1)
  % read data
  FCO2 = diag.stn.FCO2(ks,:);                % extract air-sea CO2 flux [gC/m2/day]
  FCO2 = reshape(FCO2,[Ndoy Nyrs]);
  sid = [stninfo{ks,1}];                     % grid ID of the station
  UCO2 = diag.FCO2int(sid,:).*cff_g2Gg;      % extract i2A integrated C uptake [Gg C]
  Pow  = diag.Pow(sid,:);                    % extract i2A open water duration [days]
  Ulims = stninfo{ks,4};
  % correlation
  idd = find(~isnan(Pow+UCO2) & years>=obs_yrs(1));
  [r,p] = corr(Pow(idd)',UCO2(idd)');
  desc = ['\itr\rm=' num2str(r,'%.2f') ', \itp\rm' fun_pdesc(p)];

  pos = [fgx fgy-(ks-1)*fgdh fgw fgh];
  % CO2 flux (pcolor) axis
  axes('pos',pos); hold on; box on
  pcolor([years years(end)+1]-0.5,doys,squeeze(FCO2(:,[1:end end]))); shading flat; caxis(clims)
  set(gca,'fontsize',fsize,'layer','top',...
          'xlim',xlims,'xtick',xticks,'xticklabel','',...
          'ylim',mlims,'ytick',mticks,'yticklabel',mticklabels); xtickangle(0)
  text(xlims(1)+0.02*diff(xlims),mlims(1)+0.04*diff(mlims),[plabels{ks} ' ' stninfo{ks,2}],...
       'fontsize',fsize+1,'fontweight','bold','hor','lef','ver','bot')  % panel labels
  text(xlims(1)+0.34*diff(xlims),mlims(1)+0.04*diff(mlims),desc,...
      'fontsize',fsize,'hor','lef','ver','bot')
  if ks==1; text(xlims(1),mlims(2)+0.05*diff(mlims),'\boldmath$\mathrm{month}$',...
                 'hor','cen','ver','bot','fontsize',fsize,'interpreter','latex'); end
  if ks==2
    xlabel('year','fontsize',fsize+1); set(gca,'xticklabel',xticklabels)
    % colorbar
    hco=colorbar('horizontal','position',[fgx+0.10*fgw fgy+fgdh 0.8*fgw 0.025]);
    title(hco,['\boldmath' strjoin(label_fCO2)],'fontsize',fsize+1,'interpreter','latex')
    set(hco,'xtick',cticks,'fontweight','bold')
  end

  % Pow axis
  axes('pos',pos+[0 0 fgw*cffw(1) 0],'color','none','yaxisloc','right'); hold on
  plot(years,Pow,'-','linewidth',1.5,'color',color_Aow)
  set(gca,'fontsize',fsize,'ydir','reverse',...
          'xcolor','none'   ,'xlim',xlims+[0 diff(xlims)*cffw(1)],...
          'ycolor',color_Aow,'ylim',plims,'ytick',pticks)
  if ks==1; text(xlims(2)+diff(xlims)*cffw(1),plims(1)-0.05*diff(plims),...
                 {['\boldmath' label_Pow{1}],['\boldmath' label_Pow{2}]},...
                 'color',color_Aow,'hor','cen','ver','bot','fontsize',fsize,'interpreter','latex'); end

  % integrated CO2 flux axis
  axes('pos',pos+[0 0 fgw*cffw(2) 0],'color','none','yaxisloc','right'); hold on
  plot(years,UCO2,'-','linewidth',1.5,'color','k')
  set(gca,'fontsize',fsize,'ydir','reverse',...
          'xcolor','none'   ,'xlim',xlims+[0 diff(xlims)*cffw(2)],...
          'ycolor',[0 0 0 ] ,'ylim',Ulims,'ytick',Uticks)
  if ks==1; text(xlims(2)+diff(xlims)*cffw(2),Ulims(1)-0.05*diff(Ulims),...
                 {['\boldmath' label_UCO2_GgC{1}],['\boldmath' label_UCO2_GgC{2}]},...
                 'color',[0 0 0],'hor','cen','ver','bot','fontsize',fsize,'interpreter','latex'); end
  if ks==2; set(gca,'ytick',Uticks(1:2:end)); end  % less dense ticks
end

%#################
%## save figure ##
%#################
if isfig; print('-dpng','-r400',ffig); print('-dpng','-r400',ffig); end
