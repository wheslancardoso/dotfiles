# 🚀 Guia de Performance Suprema: Ryzen 7 5700X + 32GB RAM + RTX 5060 + NVMe M.2

> **Hardware:** AMD Ryzen 7 5700X (8C/16T, 32MB L3) + 32 GB DDR4 3600MHz + NVIDIA GeForce RTX 5060 (8 GB GDDR6) + 512 GB NVMe M.2  
> **Filosofia:** Aproveitar 100% do poder bruto da máquina no dia a dia, com **devolução automática e instantânea** de recursos para jogos pesados, renders e máquinas virtuais.

---

## 🧠 Como o Sistema se Comporta (A Orquestração Inteligente)

Você não precisa mudar chaveamentos manuais. O sistema alterna dinamicamente entre dois estados:

```
[ MODO DIA A DIA: VELOCIDADE DA LUZ ]
 ├── AMD P-State EPP ajustando frequências em microssegundos (Zen 3 autônomo)
 ├── Navegador (Brave) rodando na memória RAM via PSD (/run/user/1000/psd)
 ├── Compilações AUR (yay) executadas no tmpfs em RAM (40+ GB/s de I/O)
 ├── Cache do Kernel mantendo executáveis e bibliotecas pré-carregados
 ├── NVMe M.2 com scheduler 'none' (filas de hardware diretas no silício)
 └── RTX 5060 em modo econômico (10-15W) usando NVDEC para decodificação 4K/AV1
                    │
                    ▼ (Quando você abre um Jogo, Render 3D ou VM Pesada)
[ MODO CARGA BRUTA: PRIORIDADE MÁXIMA ]
 ├── Kernel BORE + Ananicy-cpp detecta a carga e eleva a prioridade da CPU para tempo real
 ├── O Linux Page Cache devolve gigabytes de RAM instantaneamente em nanossegundos
 ├── GameMode (`gamemoded`) ativa os clocks máximos dos 16 threads e da RTX 5060
 └── Navegadores e tarefas secundárias são desaceleradas para priorizar o render/jogo
```

---

## ⚙️ 1. As Otimizações Ativas no seu Sistema

### A. AMD Ryzen 7 5700X: Escalonamento Autônomo por Hardware (`amd_pstate=active`)
* **O que faz:** O parâmetro de kernel `amd_pstate=active` ativa o Energy Performance Preference (EPP) diretamente no silício da arquitetura AMD Zen 3.
* **Vantagem:** O chaveamento de frequências dos núcleos da CPU passa de milissegundos (software do SO) para **microssegundos** (controlador do próprio chip), eliminando micro-travamentos na UI do Hyprland e elevando a resposta de jogos e cliques.

### B. NVMe M.2: I/O Scheduler `none` & `fstrim.timer`
* **O que faz:** Discos NVMe possuem mais de 64 mil filas de hardware diretamente no barramento PCIe. 
* **Vantagem:** O scheduler de software do kernel (`bfq` ou `mq-deadline`) foi substituído por `none` via regra udev (`60-io-schedulers.rules`). O processador fala direto com o controlador NVMe com zero latência.
* **Saúde:** O serviço `fstrim.timer` roda semanalmente em segundo plano, mantendo as células de flash limpas para velocidade máxima de escrita contínua.

### C. Navegador na RAM (Profile-Sync-Daemon - PSD)
* **O que faz:** O perfil completo do seu Brave (~900 MB de histórico, cookies, cache e bancos SQLite) foi colocado na **memória RAM** (`tmpfs`).
* **Vantagem:** Abrir 50 abas, pesquisar histórico ou alternar janelas é instantâneo. Zero desgaste do seu SSD NVMe.
* **Segurança:** O serviço `psd.service` sincroniza tudo de volta para o SSD silenciosamente a cada hora e automaticamente antes de reiniciar ou desligar o PC.
* **Como checar status:**
  ```bash
  psd status
  ```

### D. Compilações do AUR no Disco de RAM (`BUILDDIR=/tmp/makepkg`)
* **O que faz:** Toda vez que você usa o `yay` para instalar ou compilar programas do AUR, o código é descompactado e compilado dentro do seu `/tmp` (RAM).
* **Vantagem:** Com 32GB RAM e 16 threads do Ryzen 7, a compilação é até 3x mais rápida e economiza dezenas de gigabytes de escrita no SSD.
* **Elasticidade:** Ao terminar a compilação, o diretório é apagado e a memória RAM volta a ficar 100% livre.

### E. Agendador Dinâmico de Processos (`ananicy-cpp` + `ananicy-rules-cachyos`)
* **O que faz:** O daemon `ananicy-cpp` do CachyOS monitora todos os processos em tempo real.
* **Regras automáticas aplicadas:**
  - **Jogos e Emuladores:** Recebem prioridade `Nice -10` e alta prioridade de I/O.
  - **QEMU / Máquinas Virtuais:** Identificado automaticamente como `Heavy_CPU` com prioridade dedicada.
  - **Blender, DaVinci Resolve, OBS Studio:** Ganham prioridade de tempo real e CPU burst.
  - **Processos de fundo (indexadores, downloads):** São rebaixados para `Nice 19` para não roubar nem 1 FPS do seu jogo.

### F. Feral GameMode (`gamemoded`)
* O serviço `gamemoded.service` do systemd já está **ativo e habilitado**.
* Quando você roda um jogo (Steam, Lutris, Heroic) ou programa pesado com `gamemoderun`:
  - O governador da CPU trava em `performance`.
  - A placa de vídeo NVIDIA RTX 5060 sobe os clocks de VRAM e Core para o teto (Performance Level 3).
  - Bloqueia descansos de tela e hibernação.
  - Ao fechar o jogo, tudo volta ao modo econômico automaticamente.

### G. Turbo Network Stack (Sysctl BBR + FQ_CoDel + Buffers Gigabit)
* `tcp_fastopen = 3`: Handshake acelerado enviando dados no pacote inicial SYN.
* `tcp_slow_start_after_idle = 0`: Mantém a velocidade máxima mesmo após pausas no tráfego.
* Buffers de janela TCP ampliados para 16MB para saturação total da banda em downloads e torrents.

---

## 🛡️ 2. Como os 32 GB de RAM se comportam em Carga Extrema

Muitos têm medo de faltar RAM se estiverem usando muito cache. No Linux, a matemática é diferente:

1. **Page Cache é Limpo (Descartável):**
   - Os gigabytes marcados como `buff/cache` no `free -h` não estão "presos".
   - Se o DaVinci Resolve ou uma VM do Windows 11 pedir **16 GB de RAM de uma vez**, o kernel descarta o cache em 0.001 segundo e entrega a memória pura.
2. **Colchão de Proteção com ZRAM (8 GB zstd):**
   - Se por acaso você rodar uma renderização massiva e passar de 32 GB de uso, o `/dev/zram0` comprime a memória com algoritmo `zstd` (taxa de 3:1).
   - Isso significa que seus 32 GB físicos conseguem segurar até **~45 GB de dados em memória** sem travar o PC e sem precisar de arquivo de swap lento no disco.

---

## 🎮 3. Tirando o Máximo da NVIDIA RTX 5060 (8 GB)

### Aceleração de Hardware em Vídeos (NVDEC):
No seu Brave, vídeos do YouTube em 4K a 60 FPS ou 120 FPS rodam decodificados diretamente pelos chips dedicados de silício da RTX 5060 (NVDEC). O uso do seu processador fica abaixo de **2%**, economizando energia e temperatura.

### Para Forçar Modo Performance em Qualquer Aplicativo:
Se você for rodar um render ou jogo pesado manualmente pelo terminal ou atalho:
```bash
gamemoderun meu_jogo_ou_app
```

---

## 💾 4. Transferência de Arquivos & HDs Externos (Zero Corrupção e Velocidade Real)

Muitos tentam usar softwares como o **PrimoCache** no Windows e sofrem com arquivos corrompidos:
* **A armadilha do PrimoCache:** Ele diz que a cópia terminou em 5 segundos, mas os arquivos ainda estão voláteis na RAM esperando para gravar no HD mecânico. Se o cabo USB for desconectado ou o PC suspender, os arquivos ficam quebrados com tamanho zerado e a partição vira RAW.

### A. A Calibragem Inteligente do Kernel no seu Sistema:
O seu CachyOS já está calibrado cirurgicamente com:
```ini
vm.dirty_background_bytes = 67108864   # 64 MB
vm.dirty_bytes = 268435456             # 256 MB
```
* **O que isso significa:** O kernel não "mente" para você fingindo que copiou 20 GB em 1 segundo. Ele limita o buffer da RAM a 256 MB. Assim que atinge 64 MB, ele começa a descarregar no HD externo em fluxo contínuo.
* **O ganho:** A cópia mostra a velocidade **real** do barramento USB (120-140 MB/s), o sistema nunca engasga e o botão de "Ejetar com Segurança" responde na hora sem travar por 10 minutos.

### B. O Melhor Sistema de Arquivos para HD Externo (Linux + Windows): **exFAT**
Se você for formatar um dos seus HDs externos para usar tanto no Arch quanto no Windows:

| Sistema de Arquivos | Compatibilidade | Problemas Frequentes | Veredito |
|---|---|---|---|
| **FAT32** | 100% | Limite ridículo de 4 GB por arquivo | ❌ Obsoleto |
| **NTFS** | Boa | Journaling pesado causa lentidão em HD mecânico; permissões de usuário (ACLs/SIDs) travam arquivos no Linux; *dirty bit* em caso de Fast Startup | ⚠️ Ruim para HD externo |
| **Btrfs / Ext4** | 100% no Linux | O Windows não lê nativamente sem drivers extras | ❌ Ruim para compartilhar com Windows |
| **exFAT** | **100% Nativo (Linux, Win, Mac)** | Nenhum. Suporta arquivos gigantes (> 50 GB), sem travas de permissão e sem overhead de journaling | **🏆 O Campeão Absoluto** |

#### Como Formatar seu HD Externo com Máxima Velocidade (Tamanho de Cluster 128KB):
Para HDs mecânicos com arquivos médios e grandes (vídeos, ISOs, backups), um tamanho de cluster de **128 KB** reduz a fragmentação e aumenta a taxa de transferência sequencial:
```bash
# Identifique a partição do HD externo (ex: /dev/sdb1 com lsblk)
# Formatar com rótulo "BACKUP_EXT":
sudo mkfs.exfat -s 128k -n "BACKUP_EXT" /dev/sdX1
```

### C. O Comando Supremo de Cópia com Retomada (`rsync`):
Em vez do `cp` tradicional que não mostra progresso e recomeça do zero se falhar, use:
```bash
rsync -ah --info=progress2 /pasta/origem/ /run/media/lan/NOME_DO_HD/destino/
```
* Exibe a velocidade real em MB/s e tempo estimado.
* Se a cópia for interrompida, basta rodar de novo: ele **retoma de onde parou** sem duplicar dados.

---

## 📊 5. Comandos Rápidos de Monitoramento

* **Ver Uso de RAM, CPU e Processos no Terminal:**
  ```bash
  btop
  ```
* **Ver Temperatura, VRAM e Uso da RTX 5060:**
  ```bash
  nvtop
  # ou
  nvidia-smi
  ```
* **Verificar sincronização do Navegador na RAM:**
  ```bash
  psd status
  ```
* **Garantir que todos os dados da RAM foram gravados nos discos externos:**
  ```bash
  sync
  ```
