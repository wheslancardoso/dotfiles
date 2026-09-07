# 🧪 Guia Mestre: Laboratórios no Virt-Manager / KVM (Substituição Total do VirtualBox)

> **Status:** Configurado, integrado ao Hyprland e pronto para uso em nível sênior.  
> **Backend:** Kernel Linux CachyOS com KVM nativo (`/dev/kvm`), QEMU e Libvirt.

---

## 🎯 1. Por que aposentar de vez o VirtualBox?

O VirtualBox é um hypervisor de Tipo 2 dependente de módulos externos DKMS que vivem quebrando com updates do kernel, possui suporte deficiente ao Wayland/Hyprland e taxa de transferência de disco limitada.

O **KVM (Kernel-based Virtual Machine)** é o mesmo motor usado por provedores de nuvem (AWS, Red Hat, Proxmox, Google Cloud):
- **Hypervisor Tipo 1 (In-Kernel):** A VM roda direto sobre as instruções da CPU AMD/Intel.
- **Performance I/O:** Discos VirtIO e NVMe virtuais que atingem a velocidade máxima do seu SSD real.
- **Sem bugs de compilação:** O KVM já está compilado no kernel do CachyOS.
- **Zero Gambiarras de Display:** Roda nativamente sobre Wayland com SPICE.

---

## 🗺️ 2. Tabela de Equivalência: VirtualBox vs. Virt-Manager

Tudo o que você fazia no VirtualBox tem um equivalente superior no Virt-Manager:

| Recurso / Laboratório | VirtualBox | Virt-Manager / KVM | Vantagem no KVM |
|---|---|---|---|
| **Rede NAT Padrão** | NAT | Rede Virtual `default` (`virbr0`) | Roteamento via kernel (`iptables`/`nftables`) sem perda de pacotes |
| **Laboratório Isolado** | Rede Interna / Host-Only | Rede Virtual Isolada (sem DHCP/NAT externo) | Isolamento criptográfico de tráfego, sem vazar para o roteador físico |
| **Modo Bridge** | Placa em Modo Bridge | Ponte MacVTap / Bridge `br0` | A VM ganha IP próprio da sua casa/empresa como um PC físico real |
| **Snapshots** | Instantâneos | Árvore de Snapshots QCOW2 | Rollback instantâneo (< 2 segundos), com ou sem estado de RAM |
| **Discos VHD / VHDX** | VHD do VirtualBox | Nativo no QEMU (driver `vpc` / `vhdx`) | Compatível com Sysprep, Macrium Reflect e Windows Backup |
| **Hardware / USB** | Filtros USB da Oracle | SPICE USB Redirection / Host USB Passthrough | Acesso aos pinos brutos do USB (Epson AdjProg, scanners fiscais) |
| **Segurança Win 11** | Emulação básica de TPM | `swtpm` + UEFI `OVMF` | Certificado TPM 2.0 real, aceita Windows 11 Enterprise sem bypass de registro |

---

## 🔬 3. Laboratórios Práticos Passo a Passo

### Lab 1: Manutenção de Impressoras Epson (AdjProg)
1. Conecte a impressora Epson via cabo USB no seu PC físico.
2. Abra a máquina virtual Windows no Virt-Manager.
3. Na barra de ferramentas da janela da VM, clique no menu:
   > **Máquina Virtual $\rightarrow$ Redirecionar Dispositivo USB**  
   > *(Ou clique no ícone de USB na barra superior)*
4. Selecione a sua impressora (ex: `04b8:xxxx Seiko Epson Corp.`).
5. **No Windows:** O Windows fará o som característico de dispositivo conectado e carregará o driver oficial.
6. Abra o **AdjProg.exe**: ele conseguirá ler os contadores da EEPROM, efetuar reset das almofadas e calibrar o cabeçote sem nenhum erro de comunicação.

---

### Lab 2: Imagem Master Windows, Modo de Auditoria (Sysprep) e Macrium Reflect

Se você gosta de preparar imagens personalizadas de Windows para backup ou instalação rápida:

#### A. Criando a VM com disco `.vhd` ou `.qcow2`:
1. Abra o `virt-manager` e clique em **Criar Nova Máquina Virtual**.
2. Escolha a ISO de instalação do Windows 10/11.
3. Na etapa de disco, você pode:
   - Deixar o padrão `.qcow2` (mais rápido para trabalhar);
   - Ou escolher **"Selecionar ou criar armazenamento personalizado"** e apontar diretamente para um arquivo `.vhd`.

#### B. Entrando no Modo de Auditoria:
1. Durante a instalação do Windows, na tela inicial do assistente (OOBE - "Escolha sua região"):
   - Pressione **`Ctrl + Shift + F3`**.
2. A máquina reiniciará automaticamente logada como **Administrador** no modo de auditoria.
3. Instale seus utilitários, drivers genéricos, ferramentas de bancada e configurações.
4. Ao terminar, feche ou marque "Generalizar" no assistente do Sysprep e escolha **Desligar**.

#### C. Clonando / Capturando com Macrium Reflect:
1. No Virt-Manager, abra os detalhes da VM (ícone de lâmpada 💡).
2. Clique em **Adicionar Hardware $\rightarrow$ Armazenamento $\rightarrow$ Tipo de Mídia: CD-ROM**.
3. Aponte para a ISO do **Macrium Reflect Rescue Media (WinPE)**.
4. Em **Opções de Boot**, marque o CD-ROM como primeiro da ordem.
5. Inicie a VM: ela dará boot direto no Macrium Reflect dentro da VM, permitindo salvar o backup `.mrimg` em uma pasta compartilhada ou converter o disco.

#### D. Conversão de Formatos de Disco:
Se você criou um disco `.qcow2` e quer transformá-lo em `.vhd` para usar em outro lugar:
```bash
# Converter QCOW2 para VHD (formato vpc da Microsoft):
qemu-img convert -f qcow2 -O vpc /var/lib/libvirt/images/minha-vm.qcow2 /home/lan/imagem-pronta.vhd

# Converter VHD existente para QCOW2 (para rodar com máxima velocidade no KVM):
qemu-img convert -f vpc -O qcow2 /home/lan/imagem-antiga.vhd /var/lib/libvirt/images/vm-rapida.qcow2
```

---

### Lab 3: Laboratório de Redes Isoladas (Active Directory / Pentest / Malware)

Se você precisa de duas ou mais VMs conversando entre si sem ter acesso à internet nem à sua rede de casa:

1. No Virt-Manager, clique em **Editar $\rightarrow$ Detalhes da Conexão**.
2. Vá até a aba **Redes Virtuais**.
3. Clique no botão **`+`** no canto inferior esquerdo:
   - **Nome:** `lab-isolado`
   - **Modo:** Desmarque "Encaminhamento para rede física" (modo isolado / isolated network).
   - **DHCP:** Ative se quiser que o libvirt distribua IPs no lab, ou desative se for subir um Windows Server com serviço DHCP/DNS próprio.
4. Nas configurações da placa de rede das suas VMs, mude a fonte de rede para `lab-isolado`.
5. Todas as VMs se enxergarão na sub-rede isolada com velocidade de barramento de memória (10 Gbps+).

---

### Lab 4: Modo Bridge (VM com IP na sua rede doméstica/empresa)

Para fazer a VM se comportar exatamente como outro computador físico conectado ao seu Wi-Fi/Switch:
1. Nos detalhes da VM $\rightarrow$ **Placa de Rede**.
2. Em **Fonte de Rede**, selecione **"Dispositivo de host MacVTap"**.
3. Em **Nome do Dispositivo**, escolha sua interface física (ex: `wlan0` para Wi-Fi ou `eth0` / `enp...` para cabo).
4. Em **Modo de Origem**, selecione **Ponte (Bridge)**.
5. A VM receberá o IP direto do roteador da sua casa (ex: `192.168.1.150`).

---

## 📸 4. Gerenciamento de Snapshots (Instantâneos)

No Virt-Manager, você nunca perde um laboratório:
1. Clique no ícone de **Gerenciar instantâneos da máquina virtual** (ícone de ramificação na barra superior).
2. Clique no **`+`**:
   - Dê um nome (ex: `1-Pre-Sysprep` ou `2-Antes-Instalar-AD`).
   - Se a VM estiver ligada, ele pode salvar inclusive a memória RAM (a VM volta exatamente no milissegundo em que você pausou).
3. Se algo quebrar, basta selecionar o snapshot e clicar no botão de **Play com seta circular (Restaurar instantâneo)**.

---

---

## 📦 5. O Segredo do SPICE: Onde Instala e Como Funciona?

Muitos perguntam: *"O SPICE instala no Linux ou dentro do Windows?"*

* **No seu Arch Linux (Host):** **Já está 100% instalado e pronto!** O pacote `qemu-desktop` já inclui os servidores SPICE (`qemu-ui-spice-core`, `qemu-chardev-spice`, etc.) e o cliente `virt-viewer` / `spice-gtk`.
* **Dentro do Windows (Guest):** A Microsoft não inclui drivers de código aberto de terceiros por padrão na ISO dela. Por isso, a VM recém-instalada roda com driver VGA básico até você instalar o pacote de integração.

### 💿 Como Instalar os Adicionais no Windows (Sem Internet / 2 Cliques):
Já baixamos e criamos a ISO pronta no seu pool local:  
📁 `/var/lib/libvirt/images/spice-guest-tools.iso`

1. Na janela da VM no Virt-Manager, clique na **lâmpada 💡 (Detalhes de Hardware)**.
2. Clique em **Adicionar Hardware $\rightarrow$ Armazenamento**:
   - **Tipo de Mídia:** CD-ROM.
   - **Caminho:** Selecione `spice-guest-tools.iso` (que já aparece listada na lista de volumes).
3. Dentro do Windows, abra o **Explorador de Arquivos $\rightarrow$ Este Computador**.
4. Dê duplo clique no drive de CD e execute o instalador:
   - Ele instala em 10 segundos: driver de vídeo QXL (resolução dinâmica), driver de rede VirtIO Gigabit, sincronização de clipboard e som.
5. Reinicie a VM e aproveite o redimensionamento fluido de tela no Hyprland!

---

## 📁 6. Compartilhamento Bidirecional de Pastas e Arquivos

### A. Arrastar e Soltar (Drag & Drop):
Com o `spice-guest-tools` instalado, basta arrastar um arquivo da sua área de trabalho ou gerenciador de arquivos no Arch e soltar na janela do Windows.

### B. Pasta Compartilhada Ultra-Rápida (`virtiofs`):
Para compartilhar uma pasta permanente (ex: `~/Compartilhado_VM` ou `~/Downloads`):
1. No Virt-Manager $\rightarrow$ Detalhes da VM 💡 $\rightarrow$ **Adicionar Hardware $\rightarrow$ Sistema de Arquivos**.
2. **Modo:** `virtiofs` (roda na velocidade da RAM).
3. **Caminho de Origem:** `/home/lan/Downloads` (ou qualquer pasta do Arch).
4. **Tag Alvo:** `compartilhado`.
5. No Windows, instale o serviço WinFsp (já incluso no ISO de drivers) e monte como unidade `Z:`.

### 🔒 Como Desligar Tudo para Testes de Segurança (Modo Sandbox):
Se for testar um script duvidoso, um malware ou fazer um laboratório estritamente isolado:
- Nos detalhes da VM $\rightarrow$ **Exibir Spice** $\rightarrow$ Desmarque *"Compartilhar Área de Transferência"*.
- Remova o dispositivo de *Sistema de Arquivos*.
- Mude a placa de rede para *Isolada* (sem internet).
- A VM vira uma ilha 100% isolada e segura.

---

## 🎙️ 7. O Ecossistema Linux Desktop 2026: Tela, Voz e Câmera

Seu sistema está afinado e com o que há de mais moderno no ecossistema Linux:

* **Microfone com IA (Melhor que no Windows):**
  - O **PipeWire 1.6.8** e **WirePlumber** gerenciam o fluxo de áudio com baixa latência.
  - O **`noise-suppression-for-voice`** e o **`EasyEffects`** rodam em segundo plano usando redes neurais (RNNoise) para filtrar cliques mecânicos, ventilador e ruídos com apenas 3ms de atraso.
* **Compartilhamento de Tela no Hyprland (Wayland):**
  - O **`xdg-desktop-portal-hyprland`** está ativo e se comunica diretamente com o **Vesktop** (Discord), Brave e Chrome.
  - Ao compartilhar, o Hyprland oferece uma interface visual suave para escolher monitores ou janelas específicas a 60 FPS com aceleração por hardware e áudio compartilhado.
* **Webcam Plug & Play (UVC):**
  - Dispositivos de vídeo USB (`/dev/video*`) utilizam os drivers nativos do kernel, prontos para OBS Studio, Google Meet e chamadas sem instaladores de terceiros.

---

## ⚡ 8. Atalhos e Dicas de Ouro no Hyprland

* **Como abrir o Virt-Manager:**
  - Pelo lançador de apps: `Super + Espaço` (ou `Super + D`) $\rightarrow$ digite `virt-manager`.
  - Pelo terminal: `virt-manager`.
* **Regras de Janela Pré-configuradas no Hyprland:**
  - O `virt-manager` e os consoles `virt-viewer` abrem automaticamente em modo flutuante centralizado e responsivo (`WindowRules.conf`).
* **Mouse Transparente (Sem Tecla Host):**
  - Como as VMs usam o dispositivo **Tablet USB**, o cursor sai da janela da VM sem necessidade de apertar teclas de escape (Right Ctrl).

---

## 🛠️ 9. Manutenção e Solução de Problemas

Se um dia a rede NAT padrão não subir após um reboot ou update do sistema:
```bash
# Verificar status da rede:
virsh net-list --all

# Forçar inicialização da rede padrão:
virsh net-start default

# Re-executar o script de ajuste fino das dotfiles:
~/dotfiles/scripts/setup-virt-manager.sh
```
