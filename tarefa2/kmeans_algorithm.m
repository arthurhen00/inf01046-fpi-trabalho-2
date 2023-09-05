function [cluster_indices, centroids] = kmeans_algorithm(data, k, max_iterations)
    num_samples = size(data, 1);
    num_features = size(data, 2);
    centroids = data(randperm(num_samples, k), :);

    for iteration = 1:max_iterations
        % Atribuir cada ponto ao centróide mais próximo
        distances = pdist2(data, centroids);
        [~, cluster_indices] = min(distances, [], 2);

        % Atualizar os centróides
        new_centroids = zeros(k, num_features);
        for i = 1:k
            cluster_points = data(cluster_indices == i, :);
            if ~isempty(cluster_points)
                new_centroids(i, :) = mean(cluster_points);
            else
                new_centroids(i, :) = centroids(i, :);
            end
        end

        % Verificar convergência
        if isequal(centroids, new_centroids)
            break;
        end
        centroids = new_centroids;
    end
end
