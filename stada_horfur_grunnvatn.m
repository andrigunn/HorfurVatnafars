%% Horfur vatnafars
disp('Horfur vatnafars grunnvatn')
disp(datestr(now))
if ispc
    addpath C:\Users\andrigun\Dropbox\04-Repos\wiskireader\
    addpath C:\Users\andrigun\Dropbox\04-Repos\timeseriestools\
    img_dir = '\\lv-reikni-01.lv.is\data\projects\brunnur\grunnvatn\';
    vis = 'on'
elseif ismac

elseif isunix
    img_dir = '/data/projects/brunnur/grunnvatn/';
    addpath /data/git/wiskireader\
    addpath /data/git/timeseriestools\
    vis = 'off';
end

% Main settings
FigureSettings;

%%
% Settings
years2plot = [2020,2021,2022,2023,2024];
bound_type = 'athuganir';

%% Read data to structures
% G is groundwater data
clear G
baseline_period = [datetime(2000,01,01),datetime(2020,12,31)];
WData = readDataFromWiskiToTimetable(133631042); % ts id sem hætti að virka í Maí 2023 16837042
[G.VH3] = makeOverlayDataStack(WData.VH_3.Time,WData.VH_3.GWLVL,baseline_period);

WData = readDataFromWiskiToTimetable(11679042);
[G.Hraunvotn] = makeOverlayDataStack(WData.Hraunvotn.Time,WData.Hraunvotn.ResLVL,baseline_period);

WData = readDataFromWiskiToTimetable(15487042);
[G.JV3] = makeOverlayDataStack(WData.JV_3.Time,WData.JV_3.GWLVL,baseline_period);

WData = readDataFromWiskiToTimetable(15505042);
[G.JV4] = makeOverlayDataStack(WData.JV_4.Time,WData.JV_4.GWLVL,baseline_period);

WData = readDataFromWiskiToTimetable(16485042);
[G.TH_11] = makeOverlayDataStack(WData.TH_11.Time,WData.TH_11.GWLVL,baseline_period);

WData = readDataFromWiskiToTimetable(15525042);
[G.JV5] = makeOverlayDataStack(WData.JV_5.Time,WData.JV_5.GWLVL,baseline_period);

WData = readDataFromWiskiToTimetable(6067042);
[G.Thorisvatn] = makeOverlayDataStack(WData.ThorisvatnGrasatangi.Time,WData.ThorisvatnGrasatangi.ResLVL,baseline_period);

%%
cmap = litir_rennslisvidmid./255
cline = lines(3)
%
close all
figure,hold on

x = [G.Hraunvotn.prc.Time(1) G.Hraunvotn.prc.Time(end) G.Hraunvotn.prc.Time(end) G.Hraunvotn.prc.Time(1)];
y = [50 50   100 100];
patch(x, y, cmap(1,:), 'FaceAlpha', 0.25, 'EdgeColor', cmap(1,:),'Displayname','50-100%');

y = [25 25 50 50];
patch(x, y, cmap(2,:), 'FaceAlpha', 0.25, 'EdgeColor', cmap(2,:),'Displayname','25-50%');

y = [15 15 25 25];
patch(x, y, cmap(3,:), 'FaceAlpha', 0.25, 'EdgeColor', cmap(3,:),'Displayname','15-25%');

y = [5 5 15 15];
patch(x, y, cmap(4,:), 'FaceAlpha', 0.25, 'EdgeColor', cmap(4,:),'Displayname','5-15%');

y = [0 0 5 5];
patch(x, y, cmap(5,:), 'FaceAlpha', 0.25, 'EdgeColor', cmap(5,:),'Displayname','0-5%');

plot(G.JV4.prc.Time,movmean(G.JV4.prc.HY_2024,7),...
    'Color',cline(1,:),...
    'LineWidth',2,...
    'DisplayName','JV4 (2024-25)')

plot(G.JV4.prc.Time,movmean(G.JV4.prc.HY_2023,7),...
    'Color',cline(1,:),...
    'LineStyle',':',...
    'LineWidth',2,...
    'DisplayName','JV4 (2023-24)')

plot(G.Hraunvotn.prc.Time,movmean(G.Hraunvotn.prc.HY_2024,7),...
    'Color',cline(2,:),...
    'LineStyle','-',...
    'LineWidth',2,...
    'DisplayName','Hraunvötn (2024-25)')

plot(G.Hraunvotn.prc.Time,movmean(G.Hraunvotn.prc.HY_2023,7),...
    'Color',cline(2,:),...
    'LineStyle',':',...
    'LineWidth',2,...
    'DisplayName','Hraunvötn (2023-24)')

plot(G.TH_11.prc.Time,movmean(G.TH_11.prc.HY_2024,7),...
    'Color',cline(3,:),...
    'LineStyle','-',...
    'LineWidth',2,...
    'DisplayName','TH-11 (2024-25)')

plot(G.TH_11.prc.Time,movmean(G.TH_11.prc.HY_2023,7),...
    'Color',cline(3,:),...
    'LineStyle',':',...
    'LineWidth',2,...
    'DisplayName','TH-11 (2023-24)')

ylabel('Hlutfallstala %')
grid on

vline((G.TH_11.tbl.Time(end)),'--k','HandleVisibility','off');

text(0.01,0.99,['Viðmið: ',ref_title, ' (',num2str(G.TH_11.baseline_period(1).Year),' - ',num2str(G.TH_11.baseline_period(2).Year),')'],...
    'Units','normalized','HorizontalAlignment','left',...
    'VerticalAlignment','top','FontSize',12,'FontWeight','bold',...
    'Interpreter','none');

legend('Location','southoutside','NumColumns',3,'Orientation','horizontal')

title('Grunnvatnssnið - Heljargjá (Tungnaá)')

exportgraphics(gcf,[img_dir,'grunnvatn_snid_tungnaa.png'],'Resolution',450)
exportgraphics(gcf,[img_dir,'grunnvatn_snid_tungnaa.pdf'],'Resolution',450)

%%
figure,hold on

x = [G.Hraunvotn.prc.Time(1) G.Hraunvotn.prc.Time(end) G.Hraunvotn.prc.Time(end) G.Hraunvotn.prc.Time(1)];
y = [50 50   100 100];
patch(x, y, cmap(1,:), 'FaceAlpha', 0.25, 'EdgeColor', cmap(1,:),'Displayname','50-100%');

y = [25 25 50 50];
patch(x, y, cmap(2,:), 'FaceAlpha', 0.25, 'EdgeColor', cmap(2,:),'Displayname','25-50%');

y = [15 15 25 25];
patch(x, y, cmap(3,:), 'FaceAlpha', 0.25, 'EdgeColor', cmap(3,:),'Displayname','15-25%');

y = [5 5 15 15];
patch(x, y, cmap(4,:), 'FaceAlpha', 0.25, 'EdgeColor', cmap(4,:),'Displayname','5-15%');

y = [0 0 5 5];
patch(x, y, cmap(5,:), 'FaceAlpha', 0.25, 'EdgeColor', cmap(5,:),'Displayname','0-5%');


% vfill(G.Hraunvotn.prc.Time(1),G.Hraunvotn.prc.Time(end),rgb('mauve'),...
%    'edgecolor',rgb('gray'),...
%    'facealpha',0.15,'HandleVisibility','off');

plot(G.JV3.prc.Time,movmean(G.JV3.prc.HY_2024,7),...
    'Color',cline(1,:),...
    'LineWidth',2,...
    'DisplayName','JV3 (2024-25)')

plot(G.JV3.prc.Time,movmean(G.JV3.prc.HY_2023,7),...
    'Color',cline(1,:),...
    'LineStyle',':',...
    'LineWidth',2,...
    'DisplayName','JV3 (2023-24)')

plot(G.JV5.prc.Time,movmean(G.JV5.prc.HY_2024,7),...
    'Color',cline(2,:),...
    'LineWidth',2,...
    'DisplayName','JV5 (2024-25)')

plot(G.JV5.prc.Time,movmean(G.JV5.prc.HY_2023,7),...
    'Color',cline(2,:),...
    'LineStyle',':',...
    'LineWidth',2,...
    'DisplayName','JV5 (2023-24)')

plot(G.Thorisvatn.prc.Time,movmean(G.Thorisvatn.prc.HY_2024,7),...
    'Color',cline(3,:),...
    'LineWidth',2,...
    'DisplayName','Þórisvatn (2024-25)')

plot(G.Thorisvatn.prc.Time,movmean(G.Thorisvatn.prc.HY_2023,7),...
    'Color',cline(3,:),...
    'LineStyle',':',...
    'LineWidth',2,...
    'DisplayName','Þórisvatn (2023-24)')

ylabel('Hlutfallstala %')
grid on

vline((G.JV5.tbl.Time(end)),'--k','HandleVisibility','off');

text(0.01,0.99,['Viðmið: ',ref_title, ' (',num2str(G.JV5.baseline_period(1).Year),' - ',num2str(G.JV5.baseline_period(2).Year),')'],...
    'Units','normalized','HorizontalAlignment','left',...
    'VerticalAlignment','top','FontSize',12,'FontWeight','bold',...
    'Interpreter','none');

legend('Location','southoutside','NumColumns',3,'Orientation','horizontal')

title('Grunnvatnssnið - Hágöngur - Þórisvatn (TVM)')

exportgraphics(gcf,[img_dir,'grunnvatn_snid_thorisvatn.png'],'Resolution',450)
exportgraphics(gcf,[img_dir,'grunnvatn_snid_thorisvatn.pdf'],'Resolution',450)

%%
%function h = plt_overlay(s, fig_title, ymin, ymax,years2plot,p_startTime,p_endTime,p_all_years, p_years2plot,p_mean, p_quantiles)
figure('Visible',vis)
plt_overlay_groundwater(G.VH3,years2plot,'VH3','m y. s.','Grunnvatnshæð',bound_type);
exportgraphics(gcf,[img_dir,'grunnvatn_VH3.png'],'Resolution',450)
exportgraphics(gcf,[img_dir,'grunnvatn_VH3.pdf'],'Resolution',450)

%%
figure('Visible',vis)
plt_overlay_groundwater(G.Hraunvotn,years2plot,'Hraunvötn','m y. s.','Grunnvatnshæð',bound_type);
exportgraphics(gcf,[img_dir,'grunnvatn_hraunvotn.png'],'Resolution',450)
exportgraphics(gcf,[img_dir,'grunnvatn_hraunvotn.pdf'],'Resolution',450)

%%
figure('Visible',vis)
plt_overlay_groundwater(G.JV3,years2plot,'JV3','m y. s.','Grunnvatnshæð',bound_type);
exportgraphics(gcf,[img_dir,'grunnvatn_JV3.png'],'Resolution',450)
exportgraphics(gcf,[img_dir,'grunnvatn_JV3.pdf'],'Resolution',450)

%%
figure('Visible',vis)
plt_overlay_groundwater(G.JV4,years2plot,'JV4','m y. s.','Grunnvatnshæð',bound_type);
exportgraphics(gcf,[img_dir,'grunnvatn_JV4.png'],'Resolution',450)
exportgraphics(gcf,[img_dir,'grunnvatn_JV4.pdf'],'Resolution',450)

%%
figure('Visible',vis)
plt_overlay_groundwater(G.JV5,years2plot,'JV5','m y. s.','Grunnvatnshæð',bound_type);
exportgraphics(gcf,[img_dir,'grunnvatn_JV5.png'],'Resolution',450)
exportgraphics(gcf,[img_dir,'grunnvatn_JV5.pdf'],'Resolution',450)

%%
figure('Visible',vis)
plt_overlay_groundwater(G.TH_11,years2plot,'TH-11','m y. s.','Grunnvatnshæð',bound_type);
exportgraphics(gcf,[img_dir,'grunnvatn_TH11.png'],'Resolution',450)
exportgraphics(gcf,[img_dir,'grunnvatn_TH11.pdf'],'Resolution',450)

%%
figure('Visible',vis)
plt_overlay_groundwater(G.Thorisvatn,years2plot,'Þórisvatn','m y. s.','Grunnvatnshæð',bound_type);
exportgraphics(gcf,[img_dir,'grunnvatn_þorisvatn.png'],'Resolution',450)
exportgraphics(gcf,[img_dir,'grunnvatn_þorisvatn.pdf'],'Resolution',450)


function FigureSettings()
    set(0,'defaultfigurepaperunits','centimeters');
    set(0,'DefaultAxesFontSize',15)
    set(0,'defaultfigurecolor','w');
    set(0,'defaultfigureinverthardcopy','off');
    set(0,'defaultfigurepaperorientation','landscape');
    set(0,'defaultfigurepapersize',[29.7 16]);
    set(0,'defaultfigurepaperposition',[.25 .25 [29.7 16]-0.5]);
    set(0,'DefaultTextInterpreter','none');
    set(0, 'DefaultFigureUnits', 'centimeters');
    set(0, 'DefaultFigurePosition', [.25 .25 [29.7 16]-0.5]);
end
