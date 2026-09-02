# 🎮 Guia Mestre: Gaming, FitGirl Repacks, Streaming & Áudio no Arch + Hyprland

> **O manual definitivo para extrair 100% de desempenho da sua GPU NVIDIA RTX e do seu processador AMD Ryzen no Linux moderno, com zero ruído no microfone, streaming em 60 FPS com áudio e compatibilidade total com repacks de jogos.**

---

## 🧭 Visão Geral da Arquitetura

No Linux moderno (Wayland + Pipewire + Proton), você **não precisa de emuladores nem máquinas virtuais pesadas** para jogar ou transmitir:

```
┌────────────────────────────────────────────────────────────────────────┐
│                          APLICAÇÃO / JOGO                              │
│         (FitGirl Repack / Steam / Heroic / Discord / OBS)              │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
       ┌────────────────────────────┴────────────────────────────┐
       ▼                                                         ▼
┌──────────────────────────────┐        ┌────────────────────────────────┐
│   GRÁFICOS & TRADUÇÃO        │        │   ÁUDIO, VÍDEO & STREAMS       │
│  • Proton-GE / Wine-Staging  │        │  • PipeWire + WirePlumber      │
│  • DXVK (DirectX 9/10/11➔VK) │        │  • EasyEffects (IA RNNoise)    │
│  • VKD3D (DirectX 12➔Vulkan) │        │  • xdg-desktop-portal-hyprland │
│  • GameMode + MangoHud       │        │  • OBS Studio (NVENC Hardware) │
│  • NVIDIA Proprietary Driver │        │  • Vesktop (Wayland Screen+Som)│
└──────────────┬───────────────┘        └────────────────┬───────────────┘
               │                                         │
               ▼                                         ▼
┌────────────────────────────────────────────────────────────────────────┐
│                HARDWARE: AMD Ryzen 7 + NVIDIA RTX 5060                 │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 🕹️ 1. Como Rodar Jogos da FitGirl Repacks (Passo a Passo)

Os instaladores da FitGirl utilizam scripts de descompressão intensivos de CPU e RAM. Graças aos 32GB de RAM e 16 threads do seu Ryzen 7 5700X, a instalação no Linux será ultrarrápida.

### Método Recomendado: Via Lutris

1. **Instale o Proton-GE**:
   - Abra o **ProtonUp-Qt** (instalado via `protonup-qt`).
   - Clique em **Add Version** ➔ Selecione **GE-Proton** (versão mais recente) para o **Lutris** e para a **Steam**.
2. **Criar a "Garrafa" e Instalar**:
   - Abra o **Lutris**.
   - Clique no ícone de `+` no topo esquerdo ➔ **"Install a Windows game from an executable"**.
   - Digite o nome do jogo (ex: `Cyberpunk 2077`).
   - Em **Installer file**, aponte para o `setup.exe` da pasta descompactada da FitGirl.
   - Em **Game directory / Wine prefix**, escolha um diretório dedicado (ex: `/home/seu-usuario/Games/Cyberpunk2077`).
3. **Executar a Instalação**:
   - O instalador oficial da FitGirl abrirá na sua tela.
   - Avance normalmente e conclua a instalação.
4. **Apontar para o Executável Final**:
   - Clique com o botão direito no jogo no Lutris ➔ **Configure**.
   - Na aba **Game options** ➔ em **Executable**, mude de `setup.exe` para o executável do jogo instalado (ex: `/home/seu-usuario/Games/Cyberpunk2077/drive_c/Games/Cyberpunk 2077/bin/x64/Cyberpunk2077.exe`).
   - Na aba **Runner options**:
     - **Wine version**: Selecione `GE-Proton (Latest)`.
     - **Enable DXVK**: Ativado.
     - **Enable VKD3D**: Ativado.
     - **Enable Esync / Fsync**: Ativado.
   - Na aba **System options**:
     - **Enable GameMode**: Ativado.
5. **Jogar!** Dê Play no Lutris.

---

## ⚡ 2. Otimizações de Alto Desempenho (NVIDIA RTX & AMD Ryzen)

### GameMode (Feral Interactive)
O `gamemode` ajusta o escalonador da CPU para desempenho máximo e instrui a GPU NVIDIA a trabalhar no clock máximo durante a jogatina:
- **No Lutris / Heroic**: Basta marcar a chave **"Enable GameMode"**.
- **Na Steam**: Clique com o botão direito no jogo ➔ **Propriedades** ➔ **Opções de Inicialização**:
  ```bash
  gamemoderun %command%
  ```

### MangoHud (Monitoramento de FPS, Temp e VRAM)
Para exibir o overlay de telemetria na tela (estilo MSI Afterburner):
```bash
mangohud gamemoderun %command%
```
- Você pode alternar a visibilidade do MangoHud dentro do jogo a qualquer momento com o atalho `Shift_R + F12`.

---

## 🎙️ 3. Áudio Cristalino & Microfone Sem Ruído (PipeWire + EasyEffects)

Acabe de vez com barulho de teclado mecânico, ventoinhas ou eco:

1. **Ativação Automática**:
   - O daemon do EasyEffects já inicia silenciosamente em segundo plano graças à linha no seu `Startup_Apps.conf`:
     ```ini
     exec-once = easyeffects --gapplication-service
     ```
2. **Configurando o Filtro por Inteligência Artificial**:
   - Abra o **EasyEffects** (pelo Rofi ou terminal).
   - Vá na aba superior **PipeWire / Entrada (Microfone)**.
   - Clique em **Adicionar Efeito** ➔ Selecione **Supressão de Ruído (Noise Suppression)**.
   - Selecione o modelo **RNNoise** ou **DeepFilterNet**.
   - Ative a chave. Teste falar e teclar: seu microfone ficará com qualidade de estúdio profissional com 0% de latência.

---

## 📺 4. Compartilhamento de Tela no Discord (Vesktop)

O cliente oficial do Discord no Linux não possui suporte adequado ao protocolo PipeWire do Wayland. Por isso usamos o **Vesktop**:

- **Instalação**: Já incluído na suíte (`vesktop-bin`).
- **Recursos**:
  - Compartilhamento de qualquer tela ou janela individual com **áudio nativo da aplicação**.
  - Suporte a 1080p / 1440p a 60 FPS.
  - Notificações nativas integradas ao SwayNC.
  - Vencord embutido com plugins visuais e de produtividade.

---

## 🎥 5. Gravação e Transmissão com OBS Studio (NVENC RTX)

Grave sua gameplay ou crie tutoriais sem perder sequer 1 FPS usando o encoder de hardware da sua RTX 5060:

1. Abra o **OBS Studio**.
2. **Fonte de Captura**:
   - Em Fontes ➔ Adicione **Captura de Tela (PipeWire)**.
   - Escolha a tela inteira ou janela específica do Hyprland.
3. **Configuração de Saída (Output)**:
   - Modo de Saída: **Avançado**.
   - Codificador de Vídeo: **NVIDIA NVENC H.264 (FFmpeg)** ou **NVIDIA NVENC HEVC / AV1**.
   - Taxa de Bits: `15000 Kbps` para 1080p60 ou `30000 Kbps` para 1440p60.
   - Predefinição: `P5: Slow (Good Quality)` ou `P6: Slower (Better Quality)`.

---

## 🛡️ 6. Backup de Saves de Jogos (Ludusavi)

Para nunca perder seu progresso, mesmo alternando entre computadores ou sistemas:

- Abra o **Ludusavi** (`ludusavi`).
- Ele detecta automaticamente os saves de jogos instalados via Steam, Heroic, Lutris e Windows.
- Clique em **Backup** para sincronizar seus saves para uma pasta no seu Drive / SSD externo (`~/Documents/06_Backups_ISOs_e_Sistemas/Ludusavi_Saves`).

---

## 🚫 7. Tabela de Compatibilidade de Anti-Cheat

| Jogo | Funciona no Linux? | Tipo de Anti-Cheat | Observações |
|---|---|---|---|
| **Elden Ring** | ✅ Perfeito | Easy Anti-Cheat | Suporte nativo Proton |
| **Counter-Strike 2** | ✅ Perfeito | VAC | Nativo Linux Vulkan |
| **Dota 2** | ✅ Perfeito | VAC | Nativo Linux Vulkan |
| **Apex Legends** | ✅ Perfeito | Easy Anti-Cheat | Habilitado pela Respawn |
| **Helldivers 2** | ✅ Perfeito | nProtect GameGuard | Compatível via Proton-GE |
| **Cyberpunk 2077** | ✅ Perfeito (FitGirl) | Sem DRM | Desempenho total + DLSS |
| **Red Dead Redemption 2** | ✅ Perfeito (FitGirl) | Sem DRM / Vulkan | Desempenho total |
| **God of War Ragnarok** | ✅ Perfeito (FitGirl) | Sem DRM | Roda liso na RTX 5060 |
| **Valorant / LoL** | ❌ Não | Vanguard (Ring 0) | Bloqueado pela Riot para Linux |
| **Fortnite** | ❌ Não | BattlEye/EAC Kernel | Bloqueado pela Epic Games |
| **Call of Duty (Warzone)** | ❌ Não | Ricochet | Bloqueado pela Activision |

---

<div align="center">
  Aproveite a verdadeira liberdade do PC Gaming sem telemetria e com potência máxima! 🚀
</div>
