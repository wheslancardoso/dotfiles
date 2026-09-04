# 🏢 Guia Definitivo: Arch Linux em Ambiente Corporativo, Suporte & Active Directory

> **Objetivo:** Permitir que o seu setup de elite (*Arch Linux + Hyprland*) opere com perfeição em redes empresariais da Microsoft (Windows Server, Active Directory, RDP, VNC, telefonia MicroSIP e compartilhamentos de rede SMB), **sem alterar o padrão limpo do seu sistema**.

---

## 🧭 Visão Geral das Ferramentas

Quando você precisa atuar em suporte técnico, DevOps ou ambiente corporativo com infraestrutura Windows, não é necessário voltar para o Windows. O Linux possui ferramentas nativas de nível empresarial que entregam desempenho superior:

| Necessidade Corporativa | Solução no seu Arch Linux | Vantagem sobre o Windows |
| :--- | :--- | :--- |
| **Acesso Remoto (RDP)** | **Remmina** / **FreeRDP** | Abas organizadas, credenciais salvas de múltiplos domínios, aceleração gráfica e multi-monitor sem engasgo. |
| **Acesso Remoto (VNC)** | **Remmina (VNC plugin)** / **TigerVNC** | Leveza extrema, reconexão automática e histórico de conexões por cliente. |
| **Telefonia VoIP** | **MicroSIP (via Wine)** ou **Linphone** | Abre flutuante compacto (`340x560`) com áudio PipeWire de baixíssima latência. |
| **Domínio Active Directory** | **Realmd + SSSD + Kerberos** | Permite autenticar com o usuário da empresa (`usuario@dominio`) diretamente no login. |
| **Pastas de Rede (`\\servidor\share`)** | **CIFS Utils / smbclient** | Montagem transparente direto no sistema de arquivos ou via navegador de arquivos (`smb://`). |
| **Software Exclusivo Windows** | **KVM/QEMU com TPM 2.0** / **WinApps** | VM Windows 11 com velocidade nativa (VirtIO); apps do Windows abrem como janelas soltas no Hyprland. |

---

## ⚡ 1. Instalação Modular Rápida (Script Incluso)

No seu repositório existe um script dedicado que só instala o que você pedir:

```bash
~/dotfiles/scripts/enterprise-support-setup.sh
```

Ele exibirá um menu com opções de 1 a 6 para instalar:
1. Remmina (RDP + VNC);
2. Suporte a Pastas de Rede Windows (Samba/CIFS);
3. MicroSIP com lançador oficial no menu;
4. Ferramentas de Active Directory (Realmd, SSSD, Kerberos);
5. Virtualização KVM para Windows 11 VM;
6. Tudo de uma vez só.

---

## 🖥️ 2. Suporte Remoto de Elite (RDP & VNC)

### Remmina: O Canivete Suíço de Suporte
O Remmina é a ferramenta definitiva para suporte a computadores Windows 10/11 e servidores Windows Server:

- **Iniciar**: Pressione `Super + Espaço` e digite `remmina`.
- **Janela Pré-configurada**: Já possui regra no Hyprland para abrir em janela flutuante ampla (`75% x 80%`).
- **Conectar em Windows com Domínio**:
  - **Protocolo**: RDP.
  - **Servidor**: `192.168.1.100` ou `desktop-financeiro.empresa.local`.
  - **Usuário**: `joao.silva`.
  - **Domínio**: `EMPRESA` (ou deixe em branco se usar `joao.silva@empresa.local`).
  - **Recursos**: Ative o compartilhamento de Clipboard (copiar e colar texto e arquivos funciona perfeitamente).

### Dica Ninja: Conexão RDP Ultra-rápida via Terminal (FreeRDP)
Se você tem que entrar rápido num servidor sem abrir interface:
```bash
wlfreerdp /v:192.168.1.10 /u:administrador /d:EMPRESA /dynamic-resolution +clipboard
```

---

## 📞 3. MicroSIP & Telefonia Corporativa (VoIP)

O **MicroSIP** é o softphone mais leve e confiável do suporte técnico. Ele roda perfeitamente no Linux:

### Como funciona no seu setup:
1. O script baixa o MicroSIP oficial e cria o lançador `microsip.desktop`.
2. Para abrir: `Super + Espaço` -> digite `MicroSIP`.
3. Uma regra do Hyprland ([WindowRules.conf](file:///home/lan/dotfiles/home/dot_config/hypr/UserConfigs/WindowRules.conf)) já garante que ele abrirá como um discador flutuante compacto (`340x560`), igual a um celular fixado no canto.
4. **Áudio**: O PipeWire redireciona seu microfone e headset automaticamente com cancelamento de eco.

---

## 🌐 4. Integrando o Arch Linux no Active Directory (Domínio da Empresa)

Se a sua empresa exige que seu computador faça parte do domínio Windows para acessar recursos internos ou autenticar seu usuário no login:

### 🚀 Método 1: Assistente 100% Interativo (Recomendado)
Criamos um script que faz tudo para você (DNS, descoberta, join, ajuste do SSSD, criação de `/home` e sudo):

```bash
~/dotfiles/scripts/join-domain.sh
```
O assistente vai pedir:
1. O nome do domínio (ex: `empresa.local`);
2. O IP do Domain Controller para ajustar o DNS caso necessário;
3. O usuário com permissão de join (ex: `Administrator`);
4. Se deseja conceder `sudo` para o grupo `Domain Admins`;
5. O seu login para testar a resolução instantânea do AD!

---

### 🛠️ Método 2: Passo a Passo Manual

#### Passo 1: Apontar o DNS para o DC do Windows
O Active Directory requer que o DNS resolva os registros SRV do domínio:
```bash
# Apontar DNS da conexão ativa via NetworkManager:
nmcli connection modify "Sua-Conexao" ipv4.dns "192.168.1.10" ipv4.dns-search "empresa.local"
nmcli connection up "Sua-Conexao"
```

#### Passo 2: Sincronizar Relógio (Essencial para Kerberos)
Diferenças maiores que 5 minutos travam o Kerberos:
```bash
sudo timedatectl set-ntp true
```

#### Passo 3: Descobrir e Ingressar no Domínio
```bash
realm discover empresa.local
sudo realm join --user=Administrator empresa.local
```

#### Passo 4: Otimizar SSSD para Login Curto (`/etc/sssd/sssd.conf`)
Para logar com `joao` em vez de `joao@empresa.local`:
```ini
[domain/empresa.local]
use_fully_qualified_names = False
fallback_homedir = /home/%u
```
Reinicie o SSSD: `sudo systemctl restart sssd`

#### Passo 5: Criar `/home` Automaticamente no Primeiro Login
Adicione ao final de `/etc/pam.d/system-auth`:
```text
session optional pam_mkhomedir.so skel=/etc/skel umask=077
```

#### Passo 6: Dar Permissão de Sudo aos Administradores do AD
Crie o arquivo `/etc/sudoers.d/99-domain-admins`:
```text
%Domain\ Admins ALL=(ALL:ALL) ALL
```
Teste com: `id seu_usuario` e `su - seu_usuario`. Pronto! No SDDM ou no TTY, digite seu usuário e senha de rede.


## 📂 5. Pastas Compartilhadas do Windows (`\\servidor\compartilhamento`)

### Acesso Rápido no Navegador de Arquivos (Yazi ou Dolphin)
No Dolphin ou qualquer file manager com suporte a KIO/GVfs:
`smb://servidor.empresa.local/arquivos`

### Montagem Fixa no Terminal (CIFS/SMB)
Para montar uma pasta de rede compartilhada direto no seu sistema:
```bash
sudo mkdir -p /mnt/empresa
sudo mount -t cifs //192.168.1.5/arquivos /mnt/empresa -o username=joao,domain=EMPRESA,uid=$(id -u),gid=$(id -g)
```
Pronto! Você pode usar `cd /mnt/empresa`, pesquisar com `ripgrep`, navegar com `yazi` ou abrir arquivos no `nvim` a velocidade de rede local.

---

## 🛡️ 6. E se a Empresa Obrigar um Software 100% Exclusivo do Windows?

Caso a firma exija um antivírus proprietário corporativo (Crowdstrike restrito), VPN com certificação de hardware ou ferramenta antiga do Windows:

### A Solução Limpa: VM Windows 11 KVM (Near-Native Speed)
Graças ao KVM e QEMU instalados pela opção 5 do script, você pode criar uma máquina virtual de Windows 11 com:
- **VirtIO Drivers**: Velocidade de disco e rede idêntica à máquina física.
- **TPM 2.0 Virtual (`swtpm`)**: Atende 100% dos requisitos de segurança do Windows 11 e BitLocker.
- **Virt-Manager**: Interface gráfica limpa para gerenciar a VM (`Super + Espaço` -> `virt-manager`).

### O Toque de Mestre: WinApps
Com o projeto open-source **WinApps**, você não precisa deixar a tela cheia do Windows aberta. Os aplicativos instalados dentro da VM do Windows abrem como janelas transparentes individuais dentro do seu Hyprland, integradas ao Rofi e ao menu de aplicativos!

---

## 🚀 Resumo
Você mantém **100% da velocidade, leveza e beleza do Arch + Hyprland**, e quando a empresa pedir *"acessa aquele usuário no VNC"*, *"loga no ramal do MicroSIP"* ou *"entra na pasta de rede do domínio"*, você resolve tudo mais rápido do que qualquer pessoa que esteja presa no Windows 11.
