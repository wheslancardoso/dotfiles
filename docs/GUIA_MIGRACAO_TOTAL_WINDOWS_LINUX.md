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

## 🖥️ 4. Virtualização Sem Estresse: O Segredo do KVM com Quickemu

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

## 🪜 5. A Escala de Isolamento: Quando Usar Cada Abordagem?

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

## 📋 6. Checklist de Desapego para Máquinas Pessoais

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
   - Ao reiniciar, você entra direto no seu ambiente neon cyberpunk com todos os atalhos, automount de pendrives, calculadoras e ferramentas de dev prontas para uso.

Você estará rodando uma máquina de elite, estável e livre de qualquer dependência da Microsoft.
