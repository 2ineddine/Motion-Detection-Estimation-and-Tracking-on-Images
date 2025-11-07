function [xKp1, omegaKp1] = particleFiltering(img, xK, omegaK, nbPart, hRef, l, w, sigma, lambda, alpha)
%----------------------------------------------------------------------%
% Particle Filtering: 
%   - propagate particles
%   - update weights based on likelihood
%   - normalize weights
%   - resample if necessary and display particles before and after
%----------------------------------------------------------------------%
sImg = size(img);

%--- 1. Propagation (Gaussian random walk)
xKp1 = xK + sigma * randn(2, nbPart);
xKp1(1, :) = max(min(xKp1(1, :), sImg(2)), 1);
xKp1(2, :) = max(min(xKp1(2, :), sImg(1)), 1);

%--- Store for display before resampling
xBefore = xKp1;

%--- 2. Weight calculation
pYkXk = getVraisemblance(hRef, img, nbPart, xKp1, l, w, lambda);
omegaKp1 = omegaK .* pYkXk;

%--- 3. Normalize weights
omegaKp1 = omegaKp1 / sum(omegaKp1);

%--- 4. Display propagated particles before resampling
figure(1); clf;
imagesc(img); axis image; axis off; hold on;
plot(xBefore(1,:), xBefore(2,:), 'g+', 'MarkerSize', 8); % red = before resampling
title('Particle Filter: before and after resampling');
drawnow;

%--- 5. Resampling if needed
if sum(omegaKp1.^2) < alpha * nbPart
    [xKp1, omegaKp1] = resampleParticles(xKp1, omegaKp1, nbPart);
    
    % Display resampled particles
    plot(xKp1(1,:), xKp1(2,:), 'r+', 'MarkerSize', 8); % green = after resampling
    drawnow;
end
hold off;

%----------------------------------------------------------------------%
% Nested function for multinomial resampling
%----------------------------------------------------------------------%
function [pS, wS] = resampleParticles(p, w, nbPart)
    c = cumsum(w);
    r = rand(nbPart, 1);
    pS = zeros(size(p));
    wS = ones(size(w)) / nbPart;
    for i = 1:nbPart
        idx = find(c > r(i), 1);
        pS(:, i) = p(:, idx);
    end
end

end

