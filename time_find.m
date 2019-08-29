% this function is find 
function [time_ST,time_END] = time_find(time_txc,sd_txc)
[max_sd, max_sdID]=max(sd_txc);
time_END=time_txc(max_sdID);
for ii=1: max_sdID
    % jj is the id from big to small
    jj=max_sdID-ii+1;
    if (sd_txc(jj)<310)
        break
    end
end
time_ST=time_txc(jj);
end

