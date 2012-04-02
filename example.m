% TODO:
% Inference: TRW?
% Training: Pseudolikeliood? Piecewise?

X = {[1, 1, 1; 0.1, 0.2, 0; 1, 0.8, 0.8],...
    [0, 0.1, 0.2; 0, 0.2, 0.1; 0, 0.1, 0.1],...
    [0, 0.2, 0.1; 1, 1, 0.8; 1, 0.9, 0.8],...
    [0.8, 1, 1; 1, 1, 0.8; 1, 0.9, 0.8],...
    [0.9, 0.9, 0.9; 1, 1, 1; 0, 0.2, 0.1]};

Y = {[2, 1, 2],...
    [1, 1, 1],...
    [1, 2, 2],...
    [2, 2, 2],...
    [2, 2, 1]};

w = maxlikelihood(X, Y, zeros(1, 4 * 2 + 2), 1, @test_model, @test_phi, @test_mlexpectedphi, @lbp_sp);
lbp_mp(test_model(X{3}, w))

w = perceptron(X, Y, zeros(1, 4 * 2 + 2), 100, @test_model, @test_phi, @lbp_mp);
lbp_mp(test_model(X{3}, w))

w = cuttingplane(X, Y, zeros(1, 4 * 2 + 2), 1, @test_model, @test_phi, @lbp_mp);
lbp_mp(test_model(X{3}, w))

w = contrastive(X, Y, zeros(1, 4 * 2 + 2), 100, 0.1, 0.1, @test_model, @test_phi);
lbp_mp(test_model(X{3}, w))
