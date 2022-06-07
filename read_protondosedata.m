function [ProtonPlan] = read_protondosedata(path)

    ProtonPlan = struct;

    % get dose data
    ProtonPlan.protondatapath = path;
    ProtonPlan.energies = load([ProtonPlan.protondatapath 'edata.dat']);
    ProtonPlan.nEnergies = length(ProtonPlan.energies);
    ProtonPlan.ranges = load([ProtonPlan.protondatapath 'rdata.dat']);
    ProtonPlan.dosedata = cell(ProtonPlan.nEnergies,1);

    for i=1:ProtonPlan.nEnergies
        
        ProtonPlan.dosedata{i} = load([ProtonPlan.protondatapath 'pbmcs' num2str(ProtonPlan.energies(i),'%10.1f') '.dat']);

    end

    return
end



