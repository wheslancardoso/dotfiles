# 🎙️ ROADMAP: Cancelamento de Ruído por IA em Tempo Real (PipeWire + DeepFilterNet)

> **Status:** 📌 Registrado para Execução Futura  
> **Data de Registro:** 09 de Setembro de 2026  
> **Objetivo:** Isolar 100% o microfone de qualquer som ambiente (teclado mecânico, cliques, ventilador, eco e ruídos de fundo) usando redes neurais em tempo real integradas nativamente ao PipeWire / EasyEffects, com latência imperceptível (<10ms) e consumo mínimo de CPU/GPU.

---

## 🎯 1. Tecnologias Mapeadas

1. **DeepFilterNet (Estado da Arte em Supressão Neural):**
   * Rede neural treinada especificamente para distinguir voz humana de qualquer ruído acústico.
   * Superior ao RNNoise clássico, mantendo os harmônicos e o timbre natural da voz sem parecer "robótica" ou abafada.
   * Disponível via plugin LADSPA / LV2 integrado diretamente no pipeline do PipeWire.

2. **EasyEffects Daemon (Gerenciador Visual & Presets):**
   * Já configurado para iniciar como serviço em segundo plano (`easyeffects --gapplication-service`).
   * Permite alternar perfis (ex: *Estúdio Podcast*, *Call / Reunião*, *Gaming / Discord*) com 1 clique ou via script.

3. **PipeWire Filter-Chain Nativo (Zero Dependências de Interface):**
   * Configuração direta em `/home/lan/.config/pipewire/pipewire.conf.d/` ou via WirePlumber.
   * Cria um nó virtual de microfone limpo (`DeepFilterNet Source`) que qualquer aplicativo (Discord, Vesktop, OBS, Meet, Telegram) pode usar como microfone padrão.

---

## 📋 2. Checklist de Execução Futura

Quando você decidir ativar esse módulo, basta solicitar: *"Ative o Cancelamento de Ruído por IA"* e executaremos:

- [ ] **Instalação dos Pacotes e Shaders Neurais:**
  ```bash
  yay -S --needed deepfilter-ladspa easyeffects-presets
  ```
- [ ] **Configuração do Sink / Source Virtual no PipeWire:**
  * Criar o nó virtual com auto-roteamento para que todas as chamadas usem o microfone tratado automaticamente.
- [ ] **Preset Catppuccin / Voice Master:**
  * Incluir Noise Gate + DeepFilterNet + De-Esser + Compressor Leve para voz encorpada e nítida.
- [ ] **Atalho Rápido no Hyprland / Waybar (`Super + Alt + M`):**
  * Script toggle para ligar/desligar a supressão de ruído instantaneamente com notificação OSD.
- [ ] **Teste de Latência & Estresse com Digitação Mecânica:**
  * Validar em gravação simultânea enquanto digita rápido no teclado mecânico.
- [ ] **Commit & Sincronização nos Dotfiles.**

---

## 💡 3. Como acionar no futuro
Para iniciar a instalação deste módulo, basta pedir no chat:
> *"Aplique o Roadmap de Cancelamento de Ruído por IA"*
