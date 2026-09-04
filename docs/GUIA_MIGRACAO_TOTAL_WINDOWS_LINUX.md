# 🚀 Guia Definitivo de Desapego do Windows: Migração Total para Linux em 2026

> **Objetivo:** Um roteiro prático, honesto e consolidado para você eliminar o Windows de vez dos seus computadores pessoais e de trabalho, dominando as alternativas nativas e sabendo exatamente como rodar uma máquina virtual do Windows 11 ultrarrápida via KVM sem dor de cabeça.

---

## 🧭 1. Por Que Desapegar em 2026?

O Windows 11 deixou de ser apenas um sistema operacional: tornou-se uma plataforma de telemetria agressiva (com recursos invasivos como o Recall tirando prints constantes), anúncios embutidos no menu Iniciar e um consumo absurdo de **5 GB a 6 GB de RAM parado em idle**.

No seu ecossistema **Arch Linux + Hyprland**, você opera com:
- **~900 MB de RAM em idle** com interface fluida a 144Hz/240Hz;
- **Docker em socket de kernel real** (sem o overhead pesado e o I/O lento do WSL2);
- **Zero telemetria** e zero reinicializações forçadas de madrugada;
- **Controle total do seu hardware**.

---

## 🔄 2. A Tabela de Substituição: O Que Usar no Lugar do Windows

A grande maioria das pessoas fica presa ao Windows por hábito, e não por necessidade real. Veja a equivalência direta no seu ambiente:

| Necessidade no Windows | Solução Nativa no seu Linux | Como Funciona |
| :--- | :--- | :--- |
| **Jogos da Steam** | **Proton-GE / Steam Play** | Roda 95%+ da biblioteca com 1 clique (muitas vezes com mais FPS que no Windows). |
| **Jogos Epic / GOG / Repacks** | **Heroic Games / Lutris** | Gerencia downloads, saves na nuvem e versões do Wine/Proton automaticamente. |
| **Discord com Áudio & Tela** | **Vesktop** | Cliente moderno que transmite tela e áudio do jogo sem o bug clássico do Discord oficial. |
| **Microsoft Office (Word/Excel)** | **OnlyOffice** ou **M365 Web** | Interface idêntica ao Office da Microsoft, com compatibilidade nativa para `.docx`, `.xlsx` e `.pptx`. |
| **Fontes Oficiais da Microsoft** | **ttf-ms-win11-auto** | Traz Arial, Calibri, Segoe UI, Consolas e Times New Roman oficiais para paridade de layout perfeita. |
| **Leitor & Anotador de PDF** | **Okular** e **Zathura** | Okular para anotações completas, assinaturas e preenchimento de formulários; Zathura para leitura ultra-rápida. |
| **Reprodutor de Vídeos** | **Celluloid** e **MPV** | Aceleração por hardware NVDEC na GPU NVIDIA RTX 5060, shaders e interface moderna sem propagandas. |
| **Integração com Smartphone** | **KDE Connect** | Clipboard compartilhado (copia no celular e cola no PC), transferência de fotos Wi-Fi e notificações. |
| **Pen-drives & Discos NTFS** | **fix-pendrive & udiskie** | Automount transparente na Waybar e comando de 1 clique para limpar o dirty-bit do Windows. |
| **Particionamento & Formatação** | **GParted** | Interface visual clássica para formatar pendrives em FAT32, exFAT, NTFS ou Ext4. |
| **Downloads & Torrents** | **qBittorrent** | Leve, limpo, sem anúncios nem rastreadores, com mecanismo de busca integrado. |
| **Edição de Vídeo (Premiere)** | **DaVinci Resolve** | O padrão da indústria cinematográfica, com aceleração NVENC nativa na sua RTX. |
| **Design (Photoshop / Illustrator)** | **Figma / Photopea / Krita** | Figma roda nativo no navegador; Photopea abre arquivos `.psd` com camadas; Krita para pintura. |
| **Gravação de Tela & Clips** | `Super + Shift + R` | Grava seleção da tela em 60 FPS com áudio via **wf-recorder** e copia o vídeo pro clipboard. |
| **Extração de Texto de Imagens** | `Super + Shift + T` | OCR instantâneo na tela via **Tesseract**. |
| **Suporte Remoto (RDP/VNC)** | **Remmina** | Abas organizadas, credenciais salvas de domínio e sincronização de clipboard. |
| **Telefonia VoIP** | **MicroSIP (via Wine)** | Abre em discador flutuante compacto (`340x560`) com áudio PipeWire de baixa latência. |

---

## ⚡ 3. A Única Barreira Real (O "0.5%")

O único cenário técnico em que o Linux **não** consegue substituir o Windows são jogos com **Anti-Cheat invasivo a nível de Ring-0 (Kernel Driver)**:
- *Valorant* (Riot Vanguard);
- *League of Legends* (Riot Vanguard);
- *Fortnite* (EasyAntiCheat bloqueado pela Epic para Linux).

> **Regra de Ouro:** Se você não joga ativamente esses títulos específicos com Vanguard, você não tem nenhum motivo técnico para manter o Windows instalado na máquina física.

---

## 💾 4. Pen-drives & Dispositivos Removíveis Sem Dor de Cabeça

Muitos usuários que migram do Windows para o Linux reclamam de pen-drives que "não abrem" ou "só montam como somente-leitura". **O motivo é quase sempre o Windows:**
1. **O Dirty-Bit do Windows**: O Windows vem com o recurso *Fast Startup* ativado por padrão. Ele não desliga o computador completamente: ele hiberna o kernel e deixa as partições NTFS e FAT32 com uma flag de bloqueio de escrita.
2. **Remoção sem Ejeção Segura**: Puxar o pen-drive do PC sem clicar em "Ejetar com Segurança" deixa o sistema de arquivos em estado "sujo" (unclean).

### 🛠️ Como o seu ambiente resolve isso 100%:

1. **Automount Transparente (`udiskie`)**:
   - Assim que você espeta qualquer pen-drive ou HD externo, ele é montado automaticamente com suas permissões de usuário em `/run/media/$USER/<nome_do_disco>`.
   - Um ícone no tray da Waybar permite clicar e ejetar com segurança a qualquer momento.
2. **Desbloqueio com 1 Comando (`fix-pendrive`)**:
   - Se um pen-drive vier bloqueado do Windows, basta abrir o terminal e rodar:
     ```bash
     fix-pendrive
     ```
   - O script detecta a partição USB, desmonta temporariamente, limpa o dirty-bit com `ntfsfix` ou repara o FAT32/exFAT e remonta o disco na hora com permissão total de leitura e escrita.
3. **Formatador Visual (`GParted`)**:
   - Precisa formatar um pen-drive para FAT32, exFAT ou NTFS? Abra o menu de apps (`Super + D` -> `gparted`) e formate com 2 cliques.

---

## 📱 5. Integração com Smartphone: KDE Connect

No Windows, a Microsoft oferece o aplicativo "Vincular ao Celular", que é lento e exige conta Microsoft. No seu Linux, você conta com o **KDE Connect**:

- **Área de Transferência Compartilhada**: Copie uma chave Pix, código de autenticação ou link no celular (Android ou iPhone) e pressione `Ctrl + V` no computador para colar imediatamente.
- **Envio de Arquivos sem Fio**: Envie fotos da galeria para o PC diretamente pela rede Wi-Fi local sem cabos.
- **Notificações Sincronizadas**: Mensagens do WhatsApp, SMS e ligações aparecem como notificações elegantes na tela.
- **Controle Multimídia**: Use o celular como controle remoto para pausar vídeos do YouTube ou controlar o volume.

> O serviço `kdeconnect-indicator` já inicia automaticamente com a sua sessão, e as regras de firewall do UFW já foram pré-configuradas no `setup.sh` (portas 1714-1764).

---

## 🖥️ 6. Virtualização Sem Estresse: O Segredo do KVM com Quickemu

Você tentou usar o **KVM/Virt-Manager** no passado e não conseguiu? **Isso é normal.**

O Virt-Manager clássico tem 4 armadilhas para novatos:
1. A rede virtual NAT (`default`) vem desligada;
2. O usuário não tem permissão nos grupos `libvirt` e `kvm`;
3. O Windows 11 exige TPM 2.0 e BIOS UEFI que exigem configurar `swtpm` e `OVMF` manualmente;
4. O instalador do Windows não acha o disco VirtIO sem uma ISO secundária de drivers da Red Hat.

### 🌟 A Solução Moderna: Quickemu & Quickgui

O **Quickemu** usa o motor de alta performance do KVM (98% da velocidade do hardware real), mas **elimina 100% da dor de cabeça de configuração**:

```bash
# 1. Instalar o Quickemu e a interface gráfica Quickgui:
yay -S --needed quickemu quickgui-bin

# 2. Baixar e preparar o Windows 11 oficial já com TPM 2.0 e VirtIO pré-configurados:
quickget windows 11

# 3. Iniciar a máquina virtual com 1 comando (com rede, som e aceleração funcionando):
quickemu --vm windows-11.conf
```

Se preferir interface gráfica com janelas e botões, basta abrir o **Quickgui** pelo menu de aplicativos (`Super + D` -> `quickgui`). Você escolhe o Windows 11, aperta *Download* e depois *Run*.

---

## 🪜 7. A Escala de Isolamento: Quando Usar Cada Abordagem?

Antes de ligar uma máquina virtual inteira que consome 4 GB de RAM e 30 GB de disco, siga esta regra:

```
[ Nível 1: Nativo no Linux ] ───▶ 98% das suas tarefas (Docker, código, navegadores, jogos Steam, OBS)
            │
            ▼
[ Nível 2: Wine / Bottles ]  ───▶ Programas leves em .exe isolados (ex: MicroSIP, utilitários de suporte)
            │
            ▼
[ Nível 3: KVM / Quickemu ]  ───▶ Software corporativo restrito que exige Windows 11 com TPM ou driver legado
```

---

## 🛡️ 8. A Bateria de Antiatritos: O Que Torna Esse Linux Superior ao Windows

Muitos usuários desistem do Linux por pequenos atritos que nunca foram corrigidos em tutoriais genéricos da internet. No seu repositório, cada um desses problemas foi cirurgicamente eliminado:

### 💤 1. Suspensão Sem Acordar Sozinho (O Bug do Wakeup Espúrio)
* **O Problema:** Você manda o PC suspender, as luzes apagam por 2 segundos e ele liga sozinho imediatamente.
* **A Causa:** Pacotes de broadcast na rede local (Wake-on-LAN), vibrações ou poeira no sensor de mouses de alto DPI (Logitech/Razer) e controladores ACPI USB (`XHC`/`GLAN`) disparando interrupções.
* **A Solução:**
  - `disable-wol.conf` desativa o Wake-on-LAN no NetworkManager;
  - Regras udev em `90-disable-spurious-mouse-wakeup.rules` desativam o gatilho de acordar no mouse (o PC só acorda ao pressionar uma tecla no teclado ou botão power);
  - Serviço `disable-spurious-acpi-wakeup.service` desativa gatilhos de rede e PCI express no `/proc/acpi/wakeup`;
  - Ferramenta `fix-suspend` no terminal para diagnosticar e testar suspensão limpa a qualquer momento.

### ⚡ 2. Blindagem de VRAM na NVIDIA RTX (`PreserveVideoMemoryAllocations`)
* **O Problema:** No Wayland/Hyprland com placas NVIDIA, ao acordar da suspensão as janelas ficam com telas pretas ou o Hyprland fecha.
* **A Solução:** `NVreg_PreserveVideoMemoryAllocations=1` ativo com `nvidia-suspend.service` e `nvidia-resume.service` salva a VRAM em `/var/tmp` antes de dormir e restaura em 1 segundo.

### 🛑 3. Desligamento Instantâneo (Fim do "A stop job is running...")
* **O Problema:** O systemd espera 90 a 120 segundos por processos zumbis ao desligar ou reiniciar.
* **A Solução:** `DefaultTimeoutStopSec=10s` garante desligamento em no máximo 10 segundos, sempre.

### 🚀 4. Limites de Kernel para Devs & Gamers (Zero ENOSPC no Vite/Docker)
* **O Problema:** Erro `ENOSPC: System limit for number of file watchers reached` em projetos Next.js/React e travamentos em jogos Unreal Engine 5.
* **A Solução:** `fs.inotify.max_user_watches = 524288` e `vm.max_map_count = 2147483642` em `/etc/sysctl.d/99-anti-friction-limits.conf`.

### 🧊 5. ZRAM Swap Ultra-rápido com Compressão ZSTD
* **O Problema:** Se a memória RAM encher, o Linux tradicional congela o mouse e a interface por minutos antes de matar processos (OOM freeze).
* **A Solução:** Swap comprimido em tempo real na própria RAM via algoritmo `zstd`, com latência zero e preservando o SSD.

### 🎧 6. Bluetooth Instantâneo
* **O Problema:** Bluetooth desligado no boot ou fones demorando 10 segundos para parear.
* **A Solução:** `AutoEnable=true` e `FastConnectable=true` no `/etc/bluetooth/main.conf`.

### 🛡️ 7. Atualização Blindada (Fim do "Fiquei 2 Semanas Sem Atualizar e Quebrou")
* **O Problema Clássico do Arch:** Ficar alguns dias sem atualizar e, ao rodar `pacman -Syu`, o sistema quebra com `invalid or corrupted package (PGP signature)` porque as chaves de segurança dos desenvolvedores expiraram antes do pacote ser baixado. Ou pior: o kernel atualiza, mas a compilação do driver NVIDIA não roda antes do reboot, gerando tela preta.
* **A Solução:**
  - **Hook do Pacman para NVIDIA (`95-nvidia.hook`)**: Roda automaticamente o `mkinitcpio -P` sempre que o kernel ou a NVIDIA forem atualizados, garantindo que o boot e o driver de vídeo estejam 100% sincronizados.
  - **Script `safe-update` (alias `pacup`)**:
    1. Cria um snapshot Btrfs pré-atualização para rollback instantâneo;
    2. Atualiza o chaveiro oficial (`archlinux-keyring`) **ANTES** de qualquer pacote, eliminando 100% dos erros de PGP;
    3. Atualiza pacotes nativos e AUR com segurança;
    4. Avisa se uma reinicialização for recomendada por troca de versão de kernel.

### 🛠️ 8. Ferramentas de Auto-Cura (Zero Pânico no Terminal)
* **`fix-pacman`**: Se a internet cair ou o terminal fechar e o Pacman travar com erro de `db.lck`, rode `fix-pacman` para destravar e limpar pacotes parciais corrompidos (`.part`) com segurança.
* **`fix-keys`**: Se alguma chave de segurança PGP corromper, re-inicializa e popula as chaves oficiais em 1 comando.
* **`fix-mirrors`**: Testa e ranqueia automaticamente os mirrors mais velozes e atualizados do Brasil e América do Sul.
* **`fix-audio`**: Reinicia o PipeWire e WirePlumber na hora se algum fone ou microfone tiver estalos.

### 🌐 9. Aceleração GPU por Hardware & Wayland Nativo nos Navegadores
* **O Problema:** Google Chrome, VS Code, Spotify e Discord rodando via XWayland com fontes levemente borradas e vídeos 4K consumindo 70% de CPU.
* **A Solução:** Configurados `chrome-flags.conf`, `code-flags.conf` e `electron-flags.conf` com `--ozone-platform-hint=auto` e decodificação NVDEC por hardware na GPU RTX 5060 (0% de CPU ao assistir vídeos em 4K e fontes perfeitamente nítidas).

### 💾 10. Preservação do SSD (Coredumps Desativados)
* **O Problema:** Crashes de jogos pesados gravam dumps gigantescos da memória RAM no SSD (`/var/lib/systemd/coredump/`), consumindo dezenas de gigabytes sem você saber.
* **A Solução:** `disable.conf` no coredump desativa memory dumps desnecessários, poupando espaço e vida útil do SSD.

---


## 📋 9. Checklist de Desapego para Máquinas Pessoais

Ao formatar seu PC pessoal ou notebook para ter **100% Arch Linux**:

1. **Backup Pré-Formatação**:
   - Salve suas chaves SSH (`~/.ssh`);
   - Salve chaves GPG ou carteiras;
   - Faça backup de saves locais de jogos com o **Ludusavi** (incluso no repositório);
   - Suba seus projetos de código para o GitHub/GitLab.
2. **Desativar BitLocker & Fast Startup**:
   - No Windows, antes de reiniciar para o pendrive do Arch, desative o *BitLocker* e desligue o *Fast Startup* nas opções de energia (para liberar o SSD sem travamentos de partição).
3. **Instalação do seu Rice**:
   - Dê boot no pendrive do Arch;
   - Clone seu repositório: `git clone https://github.com/wheslancardoso/dotfiles.git ~/dotfiles`;
   - Execute `./setup.sh`;
   - Ao reiniciar, você entra direto no seu ambiente neon cyberpunk com todos os atalhos, automount de pendrives, calculadoras, antiatritos e ferramentas de dev prontas para uso.

Você estará rodando uma máquina de elite, estável e livre de qualquer dependência da Microsoft.


