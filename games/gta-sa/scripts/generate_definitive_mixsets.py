import os

mixsets_content = """[MixSets]
; ==============================================================================
; MIXSETS v4.3.7+ - CONFIGURACAO DEFINITIVA DE ELITE (TCE-GO AUDITOR STYLE)
; Totalmente calibrado com as 55 Anti-Annoyances e Otimizacoes Graficas / Gameplay
; Compativel com RoSA Project Evolved, Proper Fixes e 60 FPS
; ==============================================================================

[System]
FpsLimit = 60
DisableFpsLimit = 0
SkipIntro = 1
BorderlesWindowed = 0
AutoSave = 1
FixMouseLag = 1
MouseSensibility = 1.0

[Vehicles]
NoCarFlipFire = 1
VehiclesWontDisappear = 1
CarsDriveOnDebris = 1
NoPoliceCarBumping = 1
BikesStopOnBrake = 1
PlaneRudderFix = 1
WheelTurnSpeed = 1.0
PopTiresWithAnyGun = 1
MoreAccurateHandling = 1
SirensHaveLights = 1
VehicleCameraDistance = 1.1

[Peds]
DensityPeds = 140
DensityCars = 110
KeepWeaponsAfterDeath = 1
KeepWeaponsAfterArrest = 1
SprintInInteriors = 1
SprintWithHeavyWeapons = 1
CrouchWithHeavyWeapons = 1
DisablePedSpeech = 0
PedAimIK = 1
ImprovedGangWars = 1
NoDriveByCrosshairSpread = 1

[Graphics]
DrawDistance = 1.3
ShadowDistance = 1.2
GrassDistance = 1.2
VehiclesDrawDistance = 1.3
PedsDrawDistance = 1.2
VehiclesLightsDistance = 1.5
CoronasDrawDistance = 1.5
DisableColorCycleLighting = 0
NoHeatHaze = 0
MotionBlur = 0
FOV = 80.0

[Fixes]
FixVehicleExplosionCrash = 1
FixHydraLockOnCrash = 1
FixPaintjobColorCrash = 1
FixShadowZFight = 1
FixInteriorRadar = 1
FixHeliRotorColor = 1
DisableWeaponWeightSpeedDrop = 0

[Audio]
RadioVolume = 1.0
SFXVolume = 1.0
NoRadioAutoTune = 1
"""

target_dirs = [
    "/mnt/dados/Games/GTA_San_Andreas/modloader/MixSets",
    "/mnt/dados/Games/GTA_San_Andreas/modloader/_ESSENTIALS/MixSets"
]

for td in target_dirs:
    os.makedirs(td, exist_ok=True)
    ini_path = os.path.join(td, "MixSets.ini")
    with open(ini_path, "w", encoding="utf-8") as f:
        f.write(mixsets_content.strip())
    print(f"Gravado com sucesso: {ini_path}")

