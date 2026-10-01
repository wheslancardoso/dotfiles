# 🎮 GUIA MESTRE DE EMULAÇÃO DE ALTA PERFORMANCE (ARCH / CACHYOS)
> **Hardware Alvo:** AMD Ryzen 7 5700X (8C/16T) • NVIDIA GeForce RTX 5060 • 32 GB RAM  
> **Compositor / SO:** Hyprland • CachyOS (Kernel BORE Scheduler)  
> **Script de Automação:** `~/dotfiles/scripts/setup-emulators.sh`

---

## ⚡ 1. POR QUE ESTA ARQUITETURA SUPERA O WINDOWS?

1. **Kernel CachyOS + BORE Scheduler:** Reduz drasticamente a latência de troca de contexto entre as dezenas de threads criadas por emuladores modernos (como RPCS3 e Xenia). Acaba com os micro-engasgos (*micro-stuttering*).
2. **Pilha Vulkan Pura na NVIDIA:** A RTX 5060 conversa diretamente via Vulkan no Linux sem as camadas intermediárias de sobrecarga do DirectX do Windows.
3. **Resolução dos Gargalos da Engine RAGE (Midnight Club: LA / Forza):**
   * **Memory Leak Eliminado:** `clear_memory_page_state = true` e `d3d12_readback_resolve = true` impedem que o streaming de texturas virtuais do mundo aberto sature a memória de vídeo e crashe o emulador.
   * **Desacoplamento de Física e 60 FPS:** Patches de *Game Speed Fix* (Delta Time) ativados para impedir que o jogo dobre de velocidade acima de 30 FPS.
4. **GameMode Integrado:** Todos os lançadores utilizam o daemon `gamemoderun`, travando governador da CPU em Performance e prioridade máxima de clock de GPU.

---

## 🕹️ 2. SUÍTE DE EMULADORES CONFIGURADA

| Emulador | Plataforma | Formato / Localização | Renderizador / Resolução | Particularidades & Otimizações |
| :--- | :--- | :--- | :--- | :--- |
| **PCSX2** | PS2 | Flatpak (`net.pcsx2.PCSX2`) | Vulkan • 3x Native (~1440p) | BIOS `SCPH-77000` injetada, Saves resgatados, Widescreen 16:9, Anisotropic 16x, Wizard desativado. |
| **Xenia Canary** | Xbox 360 | AppImage + Wrapper `~/.local/bin/xenia-canary` | Vulkan • 720p Interno c/ Upscale | Anti-Crash RAGE ativo, VSync interno ativado, patches MCLA e Forza Horizon 1/2 provisionados. |
| **RPCS3** | PS3 | Flatpak (`net.rpcs3.RPCS3`) | Vulkan • 150% Scale (1080p/1440p) | Compilador **LLVM Recompiler** (PPU/SPU) configurado para 16 threads, SPU Loop Detection ativo. |
| **Ryujinx** | Switch | Flatpak (`io.github.ryubing.Ryujinx`) | Vulkan • Modo Docked | Gerenciamento `HostMappedUnsafe`, Varredura automática da pasta de ROMs cadastrada, VSync ligado. |
| **Snes9x** | SNES | Flatpak (`com.snes9x.Snes9x`) | Vulkan/GL • 3x Scale | Proporção 4:3 mantida, Filtro Bilinear suave ativado sem distorção em telas widescreen. |

---

## 📁 3. ESTRUTURA CANÔNICA DE DIRETÓRIOS (`~/Games/Emulation/`)

Coloque seus jogos e arquivos de sistema nos respectivos caminhos:

```
~/Games/Emulation/
├── bios/
│   ├── ps2/              <-- BIOS do PS2 (já populada com SCPH-77000)
│   ├── ps3/              <-- Firmware oficial do PS3 (PS3UPDAT.PUP)
│   └── switch/
│       ├── keys/         <-- Arquivos prod.keys e title.keys
│       └── firmware/     <-- Firmware extraído do Switch
├── configs/
│   ├── pcsx2_memcards/   <-- Memory cards (Mcd001.ps2, Mcd002.ps2)
│   └── pcsx2_cheats/     <-- Arquivos .pnach
└── roms/
    ├── snes/             <-- ROMs de Super Nintendo (.smc, .sfc)
    ├── ps2/              <-- ISOs/CHDs de PS2
    ├── ps3/              <-- Pastas de jogos de PS3 ou .pkg
    ├── xbox360/          <-- ISOs/XEX de Xbox 360 (ex: Midnight Club LA, Forza)
    └── switch/           <-- Jogos de Switch (.nsp, .xci)
```

---

## 🚀 4. COMO INICIAR CADA EMULADOR

### Via Interface Gráfica (Hyprland / Rofi / Wofi)
Pressione o atalho do menu de aplicativos (ex: `SUPER + SPACE` ou `SUPER + D`) e pesquise por:
* `PCSX2`
* `Xenia Canary`
* `RPCS3`
* `Ryujinx`
* `Snes9x`

### Via Terminal
```bash
# PlayStation 2
flatpak run net.pcsx2.PCSX2

# Xbox 360 (Inicia diretamente com gamemoderun)
xenia-canary
xenia-canary ~/Games/Emulation/roms/xbox360/mcla.iso

# PlayStation 3
flatpak run net.rpcs3.RPCS3

# Nintendo Switch
flatpak run io.github.ryubing.Ryujinx

# Super Nintendo
flatpak run com.snes9x.Snes9x
```

---

## 🔄 5. REPRODUÇÃO E PROVISIONAMENTO EM NOVAS MÁQUINAS

Se o sistema for formatado ou replicado, basta executar o script centralizado:

```bash
~/dotfiles/scripts/setup-emulators.sh
```

O script cuidará de:
1. Criar a estrutura completa de pastas em `~/Games/Emulation/`.
2. Instalar todos os pacotes Flatpak necessários via Flathub.
3. Baixar a última release estável do Xenia Canary AppImage.
4. Aplicar automaticamente todas as configurações otimizadas de `~/dotfiles/home/dot_config/` para suas respectivas pastas de runtime.
5. Criar o wrapper e os atalhos de desktop `.desktop`.
