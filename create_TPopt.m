function TPopt = create_TPopt(data)

    TPopt = struct;
    n_vois = numel(data.voinames);

    %dose specification
    dose_ONA = data.d_para_ONA;
    dose_tumor = data.d_para_OIR;
    dose_OAR = data.d_para_OAR;
    
    %Organs at Risk
    OAR = data.oar;

    %Organs at Intentional Risk
    OIR = data.oir;

    %Organs not at risk
    voi_ONA = 1:1:n_vois;

    %-------------------------------------------------------------------
    OAR_index = [0];
    k = 1;
    for i = OAR
        voi_index = find(contains(data.voinames, i));
        OAR_index(k) = voi_index;
        k = k + 1;
    end
    
    OIR_index = [0];
    c = 1;
    for i = OIR
        voi_index = find(contains(data.voinames, i));
        OIR_index(c) = voi_index;
        c = c + 1;
    end

    for i = [OAR_index, OIR_index]
        voi_ONA = voi_ONA(voi_ONA~=i);
    end

    ONA_index = voi_ONA;
    %-------------------------------------------------------------------

    vois = cell(n_vois,1);

    for i = ONA_index
        v = struct;
        v.name = data.voinames{i};
        v.nVoxel = sum(sum(data.voi==i));
        v.maxdose = dose_ONA(2);
        v.overdosepenalty = dose_ONA(3)/v.nVoxel;
        v.mindose = dose_ONA(1);
        v.underdosepenalty = 0;
        vois{i} = v;
    end

    for i = OAR_index
        v = struct;
        v.name = data.voinames{i};
        v.nVoxel = sum(sum(data.voi==i));
        v.maxdose = dose_OAR(2);
        v.overdosepenalty = dose_OAR(3)/v.nVoxel;
        v.mindose = dose_OAR(1);
        v.underdosepenalty = 0;
        vois{i} = v;
    end

    for i = OIR_index
        v = struct;
        v.name = data.voinames{i};
        v.nVoxel = sum(sum(data.voi==i));
        v.maxdose = dose_tumor(2);
        v.overdosepenalty = dose_tumor(3)/v.nVoxel;
        v.mindose = dose_tumor(1);
        v.underdosepenalty = dose_tumor(4)/v.nVoxel;
        vois{i} = v;
    end

    TPopt.vois = vois;

    %-------------------------------------------------------------------

    [m,n] = size(data.voi);
    maxdose = zeros(m,n);
    mindose = zeros(m,n);
    overdosepenalty = zeros(m,n);
    underdosepenalty = zeros(m,n);
    for i = 1:m
         for j = 1:n
             organ_index = data.voi(i,j);
             if organ_index == 0
                continue
             else
                maxdose(i,j) = TPopt.vois{organ_index}.maxdose;
                mindose(i,j) = TPopt.vois{organ_index}.mindose;
                overdosepenalty(i,j) = TPopt.vois{organ_index}.overdosepenalty;
                underdosepenalty(i,j) = TPopt.vois{organ_index}.underdosepenalty;
             end
         end

     end

     TPopt.maxdose = reshape(maxdose, m*n, 1);
     TPopt.mindose = reshape(mindose, m*n, 1);
     TPopt.overdosepenalty = reshape(overdosepenalty, m*n, 1);
     TPopt.underdosepenalty = reshape(underdosepenalty, m*n, 1);


    return

end    