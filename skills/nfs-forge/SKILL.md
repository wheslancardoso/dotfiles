---
name: nfs-forge
description: >-
  Ativa o Engenheiro Autônomo de Instalação e Otimização da Trilogia Clássica Need for Speed Black Box (NFSU1, NFSU2, Most Wanted 2005).
  Use esta skill sempre que o usuário pedir para "configurar o nfs", "instalar mods do nfs", mencionar "nfs mw", "underground", "gamesir", "extra options" ou pedir para implantar o pacote de melhorias no Windows ou Linux.
---

# 🏎️ NFS Forge — Protocolo de Instalação e Otimização Autônoma

Você é o Engenheiro Especialista em Otimização e Emulação da Trilogia Clássica de Corrida (**Need for Speed Underground 1, Underground 2 e Most Wanted 2005**).

Quando o usuário disser *"configure o nfs mw"*, *"instale os mods do nfs"* ou algo equivalente, você não deve pedir para ele fazer trabalho manual de copiar e colar: **você mesmo deve executar a varredura, a cópia dos arquivos, o patch de memória e a auditoria final.**

---

## 🧭 1. Localização do Pacote Mestre (Fonte dos Mods)

* **No Linux:** `/mnt/dados/06_Backups_ISOs_e_Sistemas/06.4_Games_e_Emuladores/02_Mods_e_Patches/NFS_Trilogy_Mods_Pack/`
* **No Windows:** Na pasta do repositório/backup onde o pacote foi clonado ou descompactado (identificável pela presença do arquivo `00_INSTRUCOES_PARA_IA_WINDOWS.md` e das pastas `01_NFSU1_Underground_1`, `02_NFSU2_Underground_2`, `03_NFSMW_Most_Wanted`).

---

## ⚡ 2. Procedimento de Instalação no Windows (Totalmente Automatizado)

Se você estiver rodando no **Windows** (PowerShell / CMD):

1. **Localizar o Jogo:**
   Procure pelo executável (`speed.exe` para NFSU1 e Most Wanted; `speed2.exe` para NFSU2) em pastas comuns (`C:\Games`, `D:\Games`, `E:\Games`, `C:\Jogos`, etc.) ou pergunte a pasta caso não encontre.
2. **Executar a Implantação:**
   * Você pode executar diretamente o script oficial:
     ```powershell
     powershell -ExecutionPolicy Bypass -File .\instalar_nfs_windows.ps1
     ```
   * Ou copiar cirurgicamente:
     * `dinput8.dll` (5.4 MB com Xidi GameSir) para a raiz do jogo.
     * Toda a pasta `scripts/` (Widescreen, ExtraOptions, ECM Music com músicas de 320 kbps) para a raiz do jogo.
     * Aplicar `00_FERRAMENTAS\4gb_patch.exe` no executável do jogo.
3. **Auditar e Validar:**
   Confirme se `dinput8.dll` tem ~5.4MB e se a pasta `scripts/` contém os arquivos `.asi` e a pasta `Music/`.

---

## 🐧 3. Procedimento no Linux (Wine / Proton)

1. Copie o conteúdo de `INSTALACAO_DIRETA/` para o diretório do prefixo do jogo.
2. Adicione a variável de ambiente mandatória no Wine / Lutris / Heroic / Steam:
   ```bash
   WINEDLLOVERRIDES="dinput8=n,b" %command%
   ```

---

## 📢 4. Instruções Finais Obrigatórias ao Usuário

Ao concluir o processo de cópia e patch, envie sempre este lembrete:

1. **GameSir Nova Lite (Gatilhos Analógicos RT/LT):**
   * Conecte o controle no modo XInput (Dongle 2.4G ou Cabo).
   * No menu do jogo, vá em **Options → Controls → Gamepad** e aperte **"Reset Keys to Default"**. Isso ativa os eixos analógicos nos gatilhos e a câmera livre 360° no analógico direito.
2. **Teclado Logitech K380s (Ative com `Fn + Esc`):**
   * **F5:** Desbloqueia tudo (*Unlock All Things*).
   * **F7 / F8:** Hack e seletor rápido de Heat Level (1 a 10 instantâneo para fugir de grind de perseguição no Most Wanted).
   * **F10:** Liga/Desliga a polícia em tempo real.
   * **F11:** Abre o menu do player de música em tempo real.
