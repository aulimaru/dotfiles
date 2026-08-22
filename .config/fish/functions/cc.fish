function cc --wraps='systemd-run --user --scope -p MemoryHigh=3G -p MemoryMax=5G -p MemorySwapMax=1G -p CPUQuota=200% claude' --description 'alias cc systemd-run --user --scope -p MemoryHigh=3G -p MemoryMax=5G -p MemorySwapMax=1G -p CPUQuota=200% claude'
    systemd-run --user --scope -p MemoryHigh=3G -p MemoryMax=5G -p MemorySwapMax=1G -p CPUQuota=200% claude $argv
end
