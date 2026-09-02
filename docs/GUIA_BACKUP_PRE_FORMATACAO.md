# 🛡️ Guia Definitivo de Backup Pré-Formatação (Zero Perda de Dados)

> **Como formatar seu computador sem medo, preservando documentos, configurações, chaves SSH e saves de todos os seus jogos, mesmo tendo apenas 1 SSD.**

---

## ⚡ 1. O Método Rápido (1 Clique)

1. Abra a pasta `scripts/` do projeto.
2. Clique duas vezes em **[`Backup-Pre-Formatacao.bat`](./scripts/Backup-Pre-Formatacao.bat)**.
3. O script irá:
   - Coletar suas **chaves SSH** (`~/.ssh`), configurações do **GlazeWM**, **Windows Terminal** e perfis.
   - Oferecer a abertura do **Ludusavi** para salvar os dados de todos os seus jogos.
   - Gerar um arquivo consolidado `BACKUP_MESTRE_DATA.zip` na sua Área de Trabalho.
4. **Envie este arquivo `.zip` e sua pasta `Documents` (com as pastas `00_` a `06_`) para o seu Google Drive.**

---

## 🎮 2. Backup de Saves de Jogos com o Ludusavi

O **[Ludusavi](https://github.com/mtkennerly/ludusavi)** é o software padrão ouro para gamers:
- **Instalação via Winget**: `winget install mtkennerly.ludusavi -e`
- **Como usar**:
  1. Abra o Ludusavi e clique em **Backup**.
  2. Ele varre automaticamente seus jogos da Steam, Epic, GOG, emuladores e jogos instalados fora de lojas.
  3. Gera a pasta de backup.
  4. Após formatar, abra o Ludusavi na máquina nova e clique em **Restore**.

---

## 💽 3. Estratégia de Partição `D:\` (Sem comprar outro SSD)

Caso você não queira ter que subir centenas de gigabytes para a nuvem:

1. Pressione `Win + X` e abra o **Gerenciamento de Disco** (`diskmgmt.msc`).
2. Clique com o botão direito na partição `C:\` e escolha **Diminuir Volume...**.
3. Defina o tamanho que quer separar para a partição `D:\`.
4. No espaço não alocado gerado, clique com botão direito e escolha **Novo Volume Simples** (letra `D:`).
5. Mova seus arquivos pesados, pastas do Organizador (`00_` a `06_`), jogos e backups para o disco `D:`.
6. **Na hora de formatar o Windows**:
   - Selecione para formatar **apenas a Partição C:** (Sistema).
   - A Partição D: continuará 100% intacta com todos os seus dados após a instalação do novo Windows!

---

## 📐 Dimensionamento Recomendado para SSD de 480 GB M.2

Um SSD de 480 GB entrega aproximadamente **~447 GB reais** utilizáveis no Windows. A divisão padrão ouro de alta eficiência é:

```
┌──────────────────────────────────────┬────────────────────────────────────────────────────────┐
│   Partição C:\ (Sistema & Apps)      │          Partição D:\ (Dados, Jogos & Backups)         │
│             130 GB a 140 GB          │                     ~310 GB a 320 GB                   │
└──────────────────────────────────────┴────────────────────────────────────────────────────────┘
```

### 1. Partição `C:\` (Sistema, Drivers e Softwares) ➔ **130 GB a 140 GB** (~140.000 MB)
- **Windows 11 com Debloat**: ~25 GB a 35 GB.
- **Todos os Softwares (Chrome, VS Code, Anki, Discord, Drivers AMD, etc.)**: ~30 GB a 40 GB.
- **Margem de Segurança (Cache, atualizações e memória virtual)**: ~50 GB a 60 GB livres para o SSD manter velocidade máxima sem engasgar.

### 2. Partição `D:\` (Cofre Pessoal, Jogos e Backups) ➔ **~310 GB a 320 GB** (Restante)
- **Taxonomia Mestre (`00_` a `06_`)**: Seus documentos, estudos (TCE-GO), códigos e mídias.
- **Jogos da Steam / Epic / Saves**: Instale as bibliotecas de jogos diretamente em `D:\Games`.
- **Backups do Ludusavi e ISOs**: Arquivos que sobrevivem a qualquer formatação do Windows.

---

### 💡 Dica de Ouro pós-formatação:
Depois de formatar o Windows no `C:\`, basta abrir a pasta `D:\organizador-master\scripts` e dar 1 clique em `Instalar-Programas-PC.bat`. Em 5 minutos o seu PC estará 100% configurado com todos os seus programas e com todos os seus arquivos do `D:\` já no lugar!
