% An script for generating demo images including
% (1) linearly separable (two gaussians), 
% (2) approximate linearly separable (from gmm)
% (3) not linearly separable.
clearvars; close all; clc

%% Linearly separable sample
mu1  = [8, 5];
sig1 = [1.3, 1.1; 1.1, 1.3];
LS1   = mvnrnd(mu1, sig1, 200);

mu2  = [16, 4];
sig2 = [1, 0.2; 0.2, 0.8];
LS2   = mvnrnd(mu2, sig2, 200);

x1 = 0:0.01:24;
x2 = 0:0.01:10;
[X1, X2] = meshgrid(x1, x2);

figure(1)
F1 = mvnpdf([X1(:) X2(:)], mu1, sig1);
F1 = reshape(F1, length(x2), length(x1));
mvncdf([0 0],[1 1], mu1, sig1);
contour(x1, x2, F1, [0.01 0.1 .05:.1:.5], 'linewidth', 1.5, 'color', 'r');
hold on;

F2 = mvnpdf([X1(:) X2(:)], mu2, sig2);
F2 = reshape(F2,length(x2), length(x1));
mvncdf([0 0],[1 1], mu2, sig2);
contour(x1, x2, F2, [0.01 0.1 .05:.1:.5], 'linewidth', 1.5, 'color', 'b');
axis([0 24 0 10])

p1 = plot(LS1(:, 1), LS1(:, 2), 'ro', 'markersize', 9);
p2 = plot(LS2(:, 1), LS2(:, 2), 'bo', 'markersize', 9);
legend([p1, p2], 'positive', 'negative')
xlabel('$x_1$', 'interpreter', 'latex')
ylabel('$x_2$', 'interpreter', 'latex')
title('Linearly Separable Case')
grid on
set(gca, 'fontsize', 18)
hold off;

%% Approximately linearly separable
clearvars; close all
mu  = [1 1; 4 4];
sig = cat(3, [2 0; 0 .5], [1 0; 0 1]);
P   = ones(1,2)/2;
gm  = gmdistribution(mu, sig, P);
gmPDF = @(x,y)pdf(gm,[x y]);
h = ezcontour(gmPDF,[-5 10],[-1 6.5]); hold on;
set(h, 'linewidth', 1.5, 'color', 'g');
LS1 = random(gm, 400);
for i=1:size(LS1, 1)
    X1 = pdist([LS1(i, 1), LS1(i, 2); 1, 1]);
    X2 = pdist([LS1(i, 1), LS1(i, 2); 4, 4]);
    if X1 < X2 - 0.5
        LS1(i, 3) = 1;
        p1 = plot(LS1(i, 1), LS1(i, 2), 'ro', 'markersize', 9);
    else
        LS1(i, 3) = 2;
        p2 = plot(LS1(i, 1), LS1(i, 2), 'bo', 'markersize', 9);
    end
end
xlabel('$x_1$', 'interpreter', 'latex')
ylabel('$x_2$', 'interpreter', 'latex')
legend([p1, p2], 'positive', 'negative')
title('Approximately Linearly Separable Case')
grid on
set(gca, 'fontsize', 18)
hold off;

%% None linear dataset
clearvars; closea all;
n  = 200; 
R  = 0.5;
x0 = 0;
y0 = 0;

t  = 2 * pi * rand(n,1);
r  = R * sqrt(rand(n,1));

r_ = 1.1 * R * sqrt(1 + rand(n,1));
t_ = 2 * pi * rand(n,1);

x = x0 + r.*cos(t);
y = y0 + r.*sin(t);

x_ = x0 + r_.*cos(t_);
y_ = y0 + r_.*sin(t_);

plot(x, y, 'ro'); hold on;
plot(x_, y_, 'bo'); grid on;

xlabel('$x_1$', 'interpreter', 'latex')
ylabel('$x_2$', 'interpreter', 'latex')

legend('positive', 'negative');
axis([-1 1 -1 1]);
title('Not Linearly Separable Case');
set(gca, 'fontsize', 18);
hold off;
