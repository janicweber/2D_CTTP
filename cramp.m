function dose_matrix = cramp(D, x, image_data)

    ct = image_data.ct;
    [m, n] = size(ct);

    dose_matrix = reshape(D*x, m, n);
    return
end