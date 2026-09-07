# 🚀 Guia de Performance Suprema: RAM 32GB + RTX 5060 (Orquestração Dinâmica)

> **Hardware:** 32 GB DDR4 (Dual Channel) + NVIDIA GeForce RTX 5060 (8 GB GDDR6)  
> **Filosofia:** Aproveitar 100% do poder bruto da máquina no dia a dia, com **devolução automática e instantânea** de recursos para jogos pesados, renders e máquinas virtuais.

---

## 🧠 Como o Sistema se Comporta (A Orquestração Inteligente)

Você não precisa mudar chaveamentos manuais. O sistema alterna dinamicamente entre dois estados:

```
[ MODO DIA A DIA: VELOCIDADE DA LUZ ]
 ├── Navegador (Brave) rodando na memória RAM via PSD (/run/user/1000/psd)
 ├── Compilações AUR (yay) executadas no tmpfs (40+ GB/s de leitura/escrita)
 ├── Cache do Kernel mantendo executáveis e bibliotecas pré-carregados
 └── RTX 5060 em modo econômico (10-15W) usando NVDEC para decodificação 4K/AV1
                    │
                    ▼ (Quando você abre um Jogo, Render 3D ou VM Pesada)
[ MODO CARGA BRUTA: PRIORIDADE MÁXIMA ]
 ├── Kernel BORE + Ananicy-cpp detecta a carga e eleva a prioridade da CPU para tempo real
 ├── O Linux Page Cache devolve gigabytes de RAM instantaneamente em nanossegundos
 ├── GameMode (`gamemoded`) ativa os clocks máximos da CPU e da RTX 5060
 └── Navegadores e tarefas secundárias são desaceleradas para priorizar o render/jogo
```

---

## ⚙️ 1. As Otimizações Ativas no seu Sistema

### A. Navegador na RAM (Profile-Sync-Daemon - PSD)
* **O que faz:** O perfil completo do seu Brave (~900 MB de histórico, cookies, cache e bancos SQLite) foi colocado na **memória RAM** (`tmpfs`).
* **Vantagem:** Abrir 50 abas, pesquisar histórico ou alternar janelas é instantâneo. Zero desgaste do seu SSD NVMe.
* **Segurança:** O serviço `psd.service` sincroniza tudo de volta para o SSD silenciosamente a cada hora e automaticamente antes de reiniciar ou desligar o PC.
* **Como checar status:**
  ```bash
  psd status
  ```

### B. Compilações do AUR no Disco de RAM (`BUILDDIR=/tmp/makepkg`)
* **O que faz:** Toda vez que você usa o `yay` para instalar ou compilar programas do AUR, o código é descompactado e compilado dentro do seu `/tmp` (RAM).
* **Vantagem:** A compilação é até 3x mais rápida e economiza dezenas de gigabytes de escrita no SSD.
* **Elasticidade:** Ao terminar a compilação, o diretório é apagado e a memória RAM volta a ficar 100% livre.

### C. Agendador Dinâmico de Processos (`ananicy-cpp`)
* **O que faz:** O daemon `ananicy-cpp` do CachyOS monitora todos os processos em tempo real.
* **Regras automáticas aplicadas:**
  - **Jogos e Emuladores:** Recebem prioridade `Nice -10` e alta prioridade de I/O.
  - **QEMU / Máquinas Virtuais:** Identificado automaticamente como `Heavy_CPU` com prioridade dedicada.
  - **Blender, DaVinci Resolve, OBS Studio:** Ganham prioridade de tempo real e CPU burst.
  - **Processos de fundo (indexadores, downloads):** São rebaixados para `Nice 19` para não roubar nem 1 FPS do seu jogo.

### D. Feral GameMode (`gamemoded`)
* O serviço `gamemoded.service` do systemd já está **ativo e habilitado**.
* Quando você roda um jogo (Steam, Lutris, Heroic) ou programa pesado com `gamemoderun`:
  - O governador da CPU trava em `performance`.
  - A placa de vídeo NVIDIA RTX 5060 sobe os clocks de VRAM e Core para o teto (Performance Level 3).
  - Bloqueia descansos de tela e hibernação.
  - Ao fechar o jogo, tudo volta ao modo econômico automaticamente.

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

## 📊 Comandos Rápidos de Monitoramento

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
