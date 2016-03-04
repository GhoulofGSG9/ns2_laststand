kCommonSounds =
{ 
    --RoundEndMusic = "sound/ls.fev/music/RoundEnd",
    LoadingMusic = "sound/NS2.fev/common/loading",
}

for _, soundAsset in pairs(kCommonSounds) do
    PrecacheAsset(soundAsset)
end
