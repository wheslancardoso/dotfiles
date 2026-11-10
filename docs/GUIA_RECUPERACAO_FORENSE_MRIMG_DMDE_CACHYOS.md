# 🛠️ GUIA FORENSE: RECUPERAÇÃO DE IMAGENS MACRIUM REFLECT (.MRIMG) VIA DMDE NO CACHYOS

> **Documento de Engenharia & Perícia de Dados**  
> **Sistema Operacional:** CachyOS (Arch Linux / Wayland / Hyprland / KDE)  
> **Objetivo:** Recuperação cirúrgica e ultrarrápida de arquivos de imagem de disco `.mrimg` e backups `.mrbak` do Macrium Reflect a partir de partições NTFS excluídas, lendo diretamente a tabela MFT sem risco de sobrescrita.

---

## 🤖 PROMPT PRONTO PARA A IA NO CACHYOS

Copie e cole o bloco abaixo diretamente na IA do seu terminal/ambiente no CachyOS:

```markdown
Estou no CachyOS (Arch Linux) e preciso recuperar arquivos de imagem de disco do Macrium Reflect (.mrimg) que foram apagados de um drive NTFS externo/secundário. 

Atue como um Engenheiro Forense de Dados e execute comigo o procedimento com segurança máxima contra sobrescrita:

1. **Inspeção de Discos Segura:**
   - Execute `lsblk -f` para identificar qual é o dispositivo do disco alvo (ex: `/dev/sdb1`, `/dev/sdc1`).
   - Garanta imediatamente que a partição alvo NÃO esteja montada (ou esteja montada estritamente como Read-Only com `mount -o ro`).

2. **Setup do DMDE no CachyOS:**
   - Instale o DMDE via AUR (`yay -S --needed dmde`) ou baixe o binário portátil oficial do Linux.
   - Se estivermos em sessão Wayland (KDE/Hyprland/Sway), configure as permissões de janela para root (`xhost +si:localuser:root` ou utilize o modo ncurses/terminal `dmde`).

3. **Guia de Extração Direta pela MFT (Sem Scan Completo):**
   - Me guie passo a passo para abrir o volume NTFS e ler a Master File Table (MFT) diretamente (sem fazer varredura bruta de setores desnecessária).
   - Como filtrar e localizar especificamente os arquivos excluídos com extensão `*.mrimg`.
   - Orientar a restauração direcionando a saída para um diretório seguro no meu SSD local do CachyOS (`/home/$USER/recuperados_mrimg/`).

4. **Validação Forense Pós-Recuperação:**
   - Após salvar o arquivo, rode um comando de inspeção (`ls -lh` e verificação de cabeçalho com `head`/`file`) para atestar a integridade do arquivo recuperado antes de qualquer outra ação.

Inicie listando os discos conectados para identificar o dispositivo correto.
```

---

## 📋 PROCEDIMENTO TÉCNICO COMPLETO (SOP MANUAL)

### 1. Cuidados Inegociáveis de Integridade Física
* **Não monte a partição alvo em modo Read-Write (`rw`):** O Linux ou Windows não podem gravar nenhum arquivo temporário no disco fonte.
* **Se o sistema montar automaticamente:**
  ```bash
  sudo umount /dev/sdX1
  ```
* **Destino Obrigatório:** O arquivo recuperado **DEVE** ser salvo no SSD local do CachyOS (ex: `~/recuperados_mrimg/`), **NUNCA** de volta no disco de onde está sendo resgatado.

---

### 2. Instalação do DMDE no CachyOS
O DMDE está disponível no AUR ou via binário portátil:
```bash
# Via AUR (yay ou paru)
yay -S --needed dmde

# Ou download manual portátil oficial (sem dependências)
mkdir -p ~/tools/dmde && cd ~/tools/dmde
wget https://dmde.com/download/dmde-4-2-2-linux-x64-gui.tgz
tar -xvf dmde-4-2-2-linux-x64-gui.tgz
```

---

### 3. Execução no Ambiente Gráfico (Wayland / X11)
Como o DMDE requer privilégios de superusuário para acessar dispositivos `/dev/sdX`:
```bash
# No Wayland (Hyprland / KDE Wayland), autorize o root a abrir janelas:
xhost +si:localuser:root

# Executar a interface gráfica:
sudo dmde
```
*(Caso prefira no terminal sem interface gráfica, execute `sudo ./dmde` na versão console).*

---

### 4. Extração Cirúrgica via MFT (30 Segundos)
1. **Selecionar Disco:** Escolha o disco físico correspondente (ex: `/dev/sdb` ou `/dev/sdc`).
2. **Abrir Partição NTFS:** Dê duplo clique na partição NTFS alvo.
3. **Open Volume (Abrir Volume):** Clique em **Open Volume** (ou *Virtual File System*). O DMDE lerá a Master File Table (MFT) em 3 a 5 segundos sem varrer os setores brutos.
4. **Localizar o `.mrimg`:**
   * Navegue pelas pastas com ícone de lixeira / marcação vermelha de exclusão (ou pasta `$Recycle.Bin`).
   * Pressione `Ctrl + F` e digite `*.mrimg`.
5. **Recuperar:**
   * Botão direito no arquivo -> **Recover (Restaurar)**.
   * Selecione o diretório de destino no SSD local: `/home/lanwsl/recuperados_mrimg/`.

---

### 5. Verificação de Integridade Pós-Recuperação
No terminal do CachyOS:
```bash
# 1. Verificar tamanho do arquivo recuperado
ls -lh ~/recuperados_mrimg/*.mrimg

# 2. Verificar os primeiros bytes de cabeçalho
hexdump -C ~/recuperados_mrimg/*.mrimg | head -n 10
```

Se o drive fonte não sofreu novas gravações, o arquivo `.mrimg` é recuperado com **100% de integridade estrutural**.
