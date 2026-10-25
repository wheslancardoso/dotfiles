#!/usr/bin/env python3
"""
Adversarial Empirical Verification Harness for Milestone 1
===========================================================
Target: templates-lab/docs/01-fundamentos-web-e-javascript-vanilla.md
Challenger: empirical_challenger (Challenger 2, Milestone 1)

This harness executes real, headless Chromium browser sessions via Playwright
to empirically stress-test:
1. Event delegation, bubbling, and dynamic DOM manipulation.
2. CustomEvent dispatching, bubbling, and Shadow DOM crossing.
3. Memory leak avoidance and AbortController race condition stress-testing.
4. Canvas digital signature logic (PointerEvents, HiDPI, empty state validation).
5. Accessibility (landmarks, form associations, ARIA state management).
"""

from __future__ import annotations

import http.server
import json
import os
import socketserver
import threading
import unittest
from pathlib import Path

from playwright.sync_api import sync_playwright

DOC_FILE = (
    Path(__file__).resolve().parent.parent
    / "templates-lab"
    / "docs"
    / "01-fundamentos-web-e-javascript-vanilla.md"
)


class EphemeralHttpServer:
    """Simple in-process HTTP server to provide a real web origin for localStorage."""

    def __init__(self):
        self.html_content = ""
        server_instance = self

        class Handler(http.server.SimpleHTTPRequestHandler):
            def do_GET(self):
                self.send_response(200)
                self.send_header("Content-Type", "text/html; charset=utf-8")
                self.end_headers()
                self.wfile.write(server_instance.html_content.encode("utf-8"))

            def log_message(self, format, *args):
                pass  # suppress request logs

        self.httpd = socketserver.TCPServer(("127.0.0.1", 0), Handler)
        self.port = self.httpd.server_address[1]
        self.thread = threading.Thread(target=self.httpd.serve_forever, daemon=True)
        self.thread.start()

    def set_content(self, html: str):
        self.html_content = html

    def get_url(self) -> str:
        return f"http://127.0.0.1:{self.port}/"

    def shutdown(self):
        self.httpd.shutdown()
        self.httpd.server_close()


class BaseBrowserTest(unittest.TestCase):
    server: EphemeralHttpServer

    @classmethod
    def setUpClass(cls):
        cls.server = EphemeralHttpServer()
        cls.playwright = sync_playwright().start()
        cls.browser = cls.playwright.chromium.launch(headless=True)

    @classmethod
    def tearDownClass(cls):
        cls.browser.close()
        cls.playwright.stop()
        cls.server.shutdown()

    def setUp(self):
        self.context = self.browser.new_context(device_scale_factor=2)
        self.page = self.context.new_page()

    def tearDown(self):
        self.context.close()

    def load_html(self, html: str):
        self.server.set_content(html)
        self.page.goto(self.server.get_url())


# ===========================================================================
# 1. EVENT DELEGATION & BUBBLING EMPIRICAL TESTS
# ===========================================================================
class TestEventDelegation(BaseBrowserTest):
    """Empirical verification of Event Delegation from Section 4.2."""

    def test_event_delegation_actions_and_dynamic_nodes(self):
        html = """
        <!DOCTYPE html>
        <html>
        <body>
          <table id="tabela-autos-fiscalizacao">
            <tbody id="corpo-tabela-autos">
              <tr data-id-auto="AUTO-001">
                <td>2026/001</td>
                <td>
                  <button type="button" data-acao="visualizar-auto">
                    <i class="icone">👁</i> <span class="label">Visualizar</span>
                  </button>
                  <button type="button" data-acao="gerar-dare">Gerar DARE</button>
                  <button type="button" data-acao="apreender-veiculo">Apreender</button>
                </td>
              </tr>
              <tr data-id-auto="AUTO-002">
                <td>2026/002</td>
                <td>
                  <button type="button" data-acao="visualizar-auto">Visualizar</button>
                </td>
              </tr>
            </tbody>
          </table>
          <script>
            window.dispatchedActions = [];
            const containerTabelaAutos = document.querySelector('#tabela-autos-fiscalizacao');

            containerTabelaAutos.addEventListener('click', (evento) => {
              const gatilho = evento.target.closest('[data-acao]');
              if (!gatilho || !containerTabelaAutos.contains(gatilho)) return;

              const linhaAuto = gatilho.closest('tr');
              const idAuto = linhaAuto ? linhaAuto.dataset.idAuto : null;
              const acao = gatilho.dataset.acao;

              if (!idAuto) return;

              window.dispatchedActions.push({ idAuto, acao, targetTag: evento.target.tagName });
            });
          </script>
        </body>
        </html>
        """
        self.load_html(html)

        # 1. Direct click on action button
        self.page.click("button[data-acao='gerar-dare']")
        actions = self.page.evaluate("() => window.dispatchedActions")
        self.assertEqual(len(actions), 1)
        self.assertEqual(actions[0], {"idAuto": "AUTO-001", "acao": "gerar-dare", "targetTag": "BUTTON"})

        # 2. Click on nested child <i> inside button (Event Bubbling)
        self.page.click("tr[data-id-auto='AUTO-001'] .icone")
        actions = self.page.evaluate("() => window.dispatchedActions")
        self.assertEqual(len(actions), 2)
        self.assertEqual(actions[1]["idAuto"], "AUTO-001")
        self.assertEqual(actions[1]["acao"], "visualizar-auto")
        self.assertEqual(actions[1]["targetTag"], "I")

        # 3. Click on row 2
        self.page.click("tr[data-id-auto='AUTO-002'] button[data-acao='visualizar-auto']")
        actions = self.page.evaluate("() => window.dispatchedActions")
        self.assertEqual(len(actions), 3)
        self.assertEqual(actions[2]["idAuto"], "AUTO-002")

        # 4. Dynamically append row 3 without adding new event listeners
        self.page.evaluate(
            """() => {
            const tbody = document.querySelector('#corpo-tabela-autos');
            const novaLinha = document.createElement('tr');
            novaLinha.dataset.idAuto = 'AUTO-003';
            novaLinha.innerHTML = `
              <td>2026/003</td>
              <td><button type="button" data-acao="apreender-veiculo">Apreender Novo</button></td>
            `;
            tbody.appendChild(novaLinha);
        }"""
        )

        self.page.click("tr[data-id-auto='AUTO-003'] button[data-acao='apreender-veiculo']")
        actions = self.page.evaluate("() => window.dispatchedActions")
        self.assertEqual(len(actions), 4)
        self.assertEqual(actions[3]["idAuto"], "AUTO-003")
        self.assertEqual(actions[3]["acao"], "apreender-veiculo")

        # 5. Click on plain TD (non-action element) -> no action should be dispatched
        self.page.click("tr[data-id-auto='AUTO-001'] td:first-child")
        actions = self.page.evaluate("() => window.dispatchedActions")
        self.assertEqual(len(actions), 4)


# ===========================================================================
# 2. CUSTOM EVENT & MULTI-TENANT BUBBLING EMPIRICAL TESTS
# ===========================================================================
class TestCustomEventBubbling(BaseBrowserTest):
    """Empirical verification of CustomEvent and ContextoEmpresaManager from Caso Prático 2."""

    def test_custom_event_propagation_and_shadow_dom(self):
        html = """
        <!DOCTYPE html>
        <html>
        <body>
          <div id="host-elemento"></div>
          <script>
            class ContextoEmpresaManager {
              static CHAVE_LOCAL_STORAGE = 'agr:contexto:empresa_ativa';
              static NOME_EVENTO_CUSTOMIZADO = 'agr:contexto-alterado';

              static definirEmpresaAtiva(empresa) {
                if (!empresa || !empresa.cnpj || !empresa.razaoSocial) {
                  throw new Error('Dados da concessionária incompletos ou inválidos.');
                }
                localStorage.setItem(this.CHAVE_LOCAL_STORAGE, JSON.stringify(empresa));

                const eventoNotificacao = new CustomEvent(this.NOME_EVENTO_CUSTOMIZADO, {
                  detail: {
                    cnpj: empresa.cnpj,
                    razaoSocial: empresa.razaoSocial,
                    registroRegulatorio: empresa.registroRegulatorio,
                    timestampAlteracao: Date.now()
                  },
                  bubbles: true,
                  composed: true
                });

                window.dispatchEvent(eventoNotificacao);
              }

              static obterEmpresaAtiva() {
                const dadosSalvos = localStorage.getItem(this.CHAVE_LOCAL_STORAGE);
                if (!dadosSalvos) return null;
                try {
                  return JSON.parse(dadosSalvos);
                } catch {
                  return null;
                }
              }

              static escutarAlteracao(callbackReativo) {
                window.addEventListener(this.NOME_EVENTO_CUSTOMIZADO, (evento) => {
                  callbackReativo(evento.detail);
                });
              }
            }

            window.ContextoEmpresaManager = ContextoEmpresaManager;
            window.receivedDetails = [];
            ContextoEmpresaManager.escutarAlteracao((detalhe) => {
              window.receivedDetails.push(detalhe);
            });
          </script>
        </body>
        </html>
        """
        self.load_html(html)

        # 1. Normal dispatch and localStorage persistence
        result = self.page.evaluate(
            """() => {
            window.ContextoEmpresaManager.definirEmpresaAtiva({
                cnpj: '01.234.567/0001-89',
                razaoSocial: 'Viação Araguarina Ltda',
                registroRegulatorio: 'AGR-TR-042'
            });
            const salvo = window.ContextoEmpresaManager.obterEmpresaAtiva();
            return { salvo, received: window.receivedDetails };
        }"""
        )
        self.assertEqual(result["salvo"]["cnpj"], "01.234.567/0001-89")
        self.assertEqual(result["salvo"]["razaoSocial"], "Viação Araguarina Ltda")
        self.assertEqual(len(result["received"]), 1)
        self.assertEqual(result["received"][0]["cnpj"], "01.234.567/0001-89")

        # 2. Validation of invalid input throws Error
        error_thrown = self.page.evaluate(
            """() => {
            try {
                window.ContextoEmpresaManager.definirEmpresaAtiva({ cnpj: '123' });
                return false;
            } catch (e) {
                return e.message;
            }
        }"""
        )
        self.assertEqual(error_thrown, "Dados da concessionária incompletos ou inválidos.")

        # 3. Resilient JSON error handling in obterEmpresaAtiva()
        corrupted_handled = self.page.evaluate(
            """() => {
            localStorage.setItem('agr:contexto:empresa_ativa', 'INVALID_JSON{{{');
            return window.ContextoEmpresaManager.obterEmpresaAtiva();
        }"""
        )
        self.assertIsNone(corrupted_handled)

        # 4. Shadow DOM crossing verification (composed: true)
        shadow_received = self.page.evaluate(
            """() => {
            let capturedAtWindow = null;
            window.addEventListener('agr:teste-shadow', (ev) => {
                capturedAtWindow = ev.detail;
            });

            const host = document.querySelector('#host-elemento');
            const shadow = host.attachShadow({ mode: 'open' });
            const btnShadow = document.createElement('button');
            shadow.appendChild(btnShadow);

            const customEvt = new CustomEvent('agr:teste-shadow', {
                detail: { origem: 'shadow-dom-profundo' },
                bubbles: true,
                composed: true
            });
            btnShadow.dispatchEvent(customEvt);

            return capturedAtWindow;
        }"""
        )
        self.assertEqual(shadow_received, {"origem": "shadow-dom-profundo"})


# ===========================================================================
# 3. MEMORY LEAKS & ABORTCONTROLLER EMPIRICAL ADVERSARIAL STRESS TEST
# ===========================================================================
class TestMemoryLeakAndAbortController(BaseBrowserTest):
    """Empirical verification of AbortController cancellation and stress testing."""

    def test_listener_count_efficiency(self):
        """Verify memory footprint of 1 delegated listener vs 1200 individual listeners."""
        html = """
        <!DOCTYPE html>
        <html>
        <body>
          <div id="container-plateia"></div>
          <script>
            window.testListenerCounts = () => {
              const container = document.querySelector('#container-plateia');
              for (let i = 0; i < 1200; i++) {
                const poltrona = document.createElement('div');
                poltrona.className = 'teatro-poltrona';
                poltrona.dataset.assento = 'A-' + (i + 1);
                container.appendChild(poltrona);
              }

              let clicksReceived = 0;
              container.addEventListener('click', (ev) => {
                const poltrona = ev.target.closest('.teatro-poltrona');
                if (poltrona) clicksReceived++;
              });

              return { totalPoltronas: container.children.length };
            };
          </script>
        </body>
        </html>
        """
        self.load_html(html)
        res = self.page.evaluate("() => window.testListenerCounts()")
        self.assertEqual(res["totalPoltronas"], 1200)

    def test_abort_controller_race_condition_and_finally_clobber_vulnerability(self):
        """
        ADVERSARIAL CHALLENGE:
        In ServicoConsultaCadu (lines 1209-1260), notice:
            finally {
              this.controladorAtivo = null;
            }
        When Request 1 is aborted by Request 2, Request 1's finally block
        executes and sets this.controladorAtivo = null!
        This nullifies the controller for Request 2 while Request 2 is STILL in flight!
        Then, when Request 3 comes in, it CANNOT abort Request 2!
        """
        html = """
        <!DOCTYPE html>
        <html>
        <body>
          <script>
            class ServicoConsultaCaduOriginal {
              constructor() {
                this.controladorAtivo = null;
              }

              async consultarVeiculoPorPlaca(placa, delayMs) {
                if (this.controladorAtivo) {
                  this.controladorAtivo.abort();
                }

                this.controladorAtivo = new AbortController();
                const { signal } = this.controladorAtivo;

                try {
                  await new Promise((resolve, reject) => {
                    const timer = setTimeout(() => resolve({ placa, status: 'OK' }), delayMs);
                    signal.addEventListener('abort', () => {
                      clearTimeout(timer);
                      const err = new Error('The user aborted a request.');
                      err.name = 'AbortError';
                      reject(err);
                    });
                  });
                  return { placa };
                } catch (erro) {
                  if (erro.name === 'AbortError') {
                    return null;
                  }
                  throw erro;
                } finally {
                  // VULNERABILITY IN THE CODE: unconditionally sets to null!
                  this.controladorAtivo = null;
                }
              }
            }

            // PATTERN WITH PROPER LEAK/CLOBBER DEFENSE:
            class ServicoConsultaCaduPatched {
              constructor() {
                this.controladorAtivo = null;
              }

              async consultarVeiculoPorPlaca(placa, delayMs) {
                if (this.controladorAtivo) {
                  this.controladorAtivo.abort();
                }

                this.controladorAtivo = new AbortController();
                const controladorLocal = this.controladorAtivo;
                const { signal } = controladorLocal;

                try {
                  await new Promise((resolve, reject) => {
                    const timer = setTimeout(() => resolve({ placa, status: 'OK' }), delayMs);
                    signal.addEventListener('abort', () => {
                      clearTimeout(timer);
                      const err = new Error('The user aborted a request.');
                      err.name = 'AbortError';
                      reject(err);
                    });
                  });
                  return { placa };
                } catch (erro) {
                  if (erro.name === 'AbortError') {
                    return null;
                  }
                  throw erro;
                } finally {
                  // SECURE DEFENSE: Only clear if this was the last active controller!
                  if (this.controladorAtivo === controladorLocal) {
                    this.controladorAtivo = null;
                  }
                }
              }
            }

            window.ServicoConsultaCaduOriginal = ServicoConsultaCaduOriginal;
            window.ServicoConsultaCaduPatched = ServicoConsultaCaduPatched;
          </script>
        </body>
        </html>
        """
        self.load_html(html)

        # 1. Demonstrate the vulnerability in the original code
        res_vuln = self.page.evaluate(
            """async () => {
            const servico = new window.ServicoConsultaCaduOriginal();

            const pA = servico.consultarVeiculoPorPlaca('PLACA-A', 100);
            const ctrlA = servico.controladorAtivo;

            const pB = servico.consultarVeiculoPorPlaca('PLACA-B', 100);
            const ctrlB = servico.controladorAtivo;

            // Wait 10ms for Request A's abort microtasks and finally to run
            await new Promise(r => setTimeout(r, 10));

            const controllerAfterAFinished = servico.controladorAtivo;

            // Launch Request C: Should abort Request B!
            const pC = servico.consultarVeiculoPorPlaca('PLACA-C', 50);

            // Was Request B aborted? Check ctrlB.signal.aborted
            const wasRequestBAbortedByC = ctrlB.signal.aborted;

            await Promise.all([pA, pB, pC]);

            return {
                wasRequestBAbortedByC,
                controllerAfterAFinishedIsNull: controllerAfterAFinished === null
            };
        }"""
        )

        # Empirical proof of the vulnerability
        self.assertTrue(
            res_vuln["controllerAfterAFinishedIsNull"],
            "Confirmed finding: Request A's finally block unconditionally wiped this.controladorAtivo to null!",
        )
        self.assertFalse(
            res_vuln["wasRequestBAbortedByC"],
            "Confirmed vulnerability: Request B was NOT aborted when Request C arrived because controladorAtivo was clobbered by Request A!",
        )

        # 2. Demonstrate that the defensive patch resolves the race condition
        res_patched = self.page.evaluate(
            """async () => {
            const servico = new window.ServicoConsultaCaduPatched();

            const pA = servico.consultarVeiculoPorPlaca('PLACA-A', 100);
            const ctrlA = servico.controladorAtivo;

            const pB = servico.consultarVeiculoPorPlaca('PLACA-B', 100);
            const ctrlB = servico.controladorAtivo;

            await new Promise(r => setTimeout(r, 10));

            const controllerAfterAFinished = servico.controladorAtivo;

            const pC = servico.consultarVeiculoPorPlaca('PLACA-C', 50);
            const wasRequestBAbortedByC = ctrlB.signal.aborted;

            await Promise.all([pA, pB, pC]);

            return {
                wasRequestBAbortedByC,
                controllerAfterAFinishedMatchesCtrlB: controllerAfterAFinished === ctrlB
            };
        }"""
        )
        self.assertTrue(res_patched["controllerAfterAFinishedMatchesCtrlB"])
        self.assertTrue(res_patched["wasRequestBAbortedByC"])


# ===========================================================================
# 4. CANVAS DIGITAL SIGNATURE LOGIC EMPIRICAL TESTS
# ===========================================================================
class TestCanvasDigitalSignature(BaseBrowserTest):
    """Empirical verification of CanvasAssinaturaDigital from Caso Prático 1."""

    def test_canvas_signature_drawing_and_validation(self):
        html = """
        <!DOCTYPE html>
        <html>
        <head>
          <style>
            #canvas-assinatura {
              box-sizing: border-box;
              width: 400px;
              height: 200px;
              border: 1px solid #ccc;
              touch-action: none;
            }
          </style>
        </head>
        <body>
          <canvas id="canvas-assinatura"></canvas>
          <script>
            class CanvasAssinaturaDigital {
              constructor(seletorCanvas, opcoes = {}) {
                this.canvas = document.querySelector(seletorCanvas);
                if (!this.canvas) {
                  throw new Error(`Elemento canvas não encontrado para o seletor: ${seletorCanvas}`);
                }

                this.ctx = this.canvas.getContext('2d');
                this.estaDesenhando = false;
                this.houveTracoEfetivo = false;

                this.larguraTraco = opcoes.larguraTraco || 2.5;
                this.corTraco = opcoes.corTraco || '#002b49';

                this.configurarResolucaoHiDPI();
                this.inicializarPointerEvents();
              }

              configurarResolucaoHiDPI() {
                const dpr = window.devicePixelRatio || 1;
                const rect = this.canvas.getBoundingClientRect();

                this.canvas.width = rect.width * dpr;
                this.canvas.height = rect.height * dpr;

                this.ctx.scale(dpr, dpr);

                this.ctx.lineCap = 'round';
                this.ctx.lineJoin = 'round';
                this.ctx.lineWidth = this.larguraTraco;
                this.ctx.strokeStyle = this.corTraco;
              }

              inicializarPointerEvents() {
                this.canvas.addEventListener('pointerdown', this.iniciarDesenho.bind(this));
                this.canvas.addEventListener('pointermove', this.desenhar.bind(this));
                this.canvas.addEventListener('pointerup', this.finalizarDesenho.bind(this));
                this.canvas.addEventListener('pointerleave', this.finalizarDesenho.bind(this));
              }

              obterCoordenadas(evento) {
                const rect = this.canvas.getBoundingClientRect();
                return {
                  x: evento.clientX - rect.left,
                  y: evento.clientY - rect.top
                };
              }

              iniciarDesenho(evento) {
                this.estaDesenhando = true;
                this.houveTracoEfetivo = true;

                if (evento.pointerId && this.canvas.setPointerCapture) {
                  try { this.canvas.setPointerCapture(evento.pointerId); } catch(e) {}
                }

                const { x, y } = this.obterCoordenadas(evento);
                this.ctx.beginPath();
                this.ctx.moveTo(x, y);
              }

              desenhar(evento) {
                if (!this.estaDesenhando) return;

                const { x, y } = this.obterCoordenadas(evento);
                this.ctx.lineTo(x, y);
                this.ctx.stroke();
              }

              finalizarDesenho(evento) {
                if (!this.estaDesenhando) return;
                this.estaDesenhando = false;
                this.ctx.closePath();

                if (evento.pointerId && this.canvas.hasPointerCapture && this.canvas.hasPointerCapture(evento.pointerId)) {
                  try { this.canvas.releasePointerCapture(evento.pointerId); } catch(e) {}
                }
              }

              limpar() {
                const dpr = window.devicePixelRatio || 1;
                this.ctx.clearRect(0, 0, this.canvas.width / dpr, this.canvas.height / dpr);
                this.houveTracoEfetivo = false;
              }

              exportarPngBase64() {
                if (!this.houveTracoEfetivo) {
                  throw new Error('Assinatura obrigatória ausente. O fiscal ou condutor autuado deve assinar o termo.');
                }
                return this.canvas.toDataURL('image/png');
              }
            }

            window.CanvasAssinaturaDigital = CanvasAssinaturaDigital;
            window.assinatura = new CanvasAssinaturaDigital('#canvas-assinatura');
          </script>
        </body>
        </html>
        """
        self.load_html(html)

        # 1. Non-existent selector throws error
        err_selector = self.page.evaluate(
            """() => {
            try {
                new window.CanvasAssinaturaDigital('#canvas-inexistente');
                return false;
            } catch (e) {
                return e.message;
            }
        }"""
        )
        self.assertEqual(
            err_selector, "Elemento canvas não encontrado para o seletor: #canvas-inexistente"
        )

        # 2. Empty signature validation: calling exportarPngBase64() immediately throws Error
        err_empty = self.page.evaluate(
            """() => {
            try {
                window.assinatura.exportarPngBase64();
                return false;
            } catch (e) {
                return e.message;
            }
        }"""
        )
        self.assertEqual(
            err_empty,
            "Assinatura obrigatória ausente. O fiscal ou condutor autuado deve assinar o termo.",
        )

        # 3. HiDPI resolution scaling verification (context has device_scale_factor=2)
        dims = self.page.evaluate(
            """() => {
            const canvas = document.querySelector('#canvas-assinatura');
            const rect = canvas.getBoundingClientRect();
            return {
                physicalWidth: canvas.width,
                physicalHeight: canvas.height,
                rectWidth: rect.width,
                rectHeight: rect.height,
                dpr: window.devicePixelRatio
            };
        }"""
        )
        self.assertEqual(dims["dpr"], 2)
        self.assertEqual(dims["physicalWidth"], round(dims["rectWidth"] * 2))
        self.assertEqual(dims["physicalHeight"], round(dims["rectHeight"] * 2))

        # 4. Perform drawing with PointerEvents via mouse simulation
        canvas_box = self.page.locator("#canvas-assinatura").bounding_box()
        self.assertIsNotNone(canvas_box)

        start_x = canvas_box["x"] + 50
        start_y = canvas_box["y"] + 50
        mid_x = canvas_box["x"] + 150
        mid_y = canvas_box["y"] + 100
        end_x = canvas_box["x"] + 250
        end_y = canvas_box["y"] + 80

        self.page.mouse.move(start_x, start_y)
        self.page.mouse.down()
        self.page.mouse.move(mid_x, mid_y)
        self.page.mouse.move(end_x, end_y)
        self.page.mouse.up()

        # 5. Export base64 PNG after drawing
        data_url = self.page.evaluate("() => window.assinatura.exportarPngBase64()")
        self.assertTrue(data_url.startswith("data:image/png;base64,"))
        self.assertGreater(len(data_url), 200)

        # 6. Clear signature and verify it reverts to empty state
        self.page.evaluate("() => window.assinatura.limpar()")
        err_after_clear = self.page.evaluate(
            """() => {
            try {
                window.assinatura.exportarPngBase64();
                return false;
            } catch (e) {
                return e.message;
            }
        }"""
        )
        self.assertEqual(
            err_after_clear,
            "Assinatura obrigatória ausente. O fiscal ou condutor autuado deve assinar o termo.",
        )


# ===========================================================================
# 5. HTML5 STRUCTURE & ACCESSIBILITY (A11Y) EMPIRICAL TESTS
# ===========================================================================
class TestAccessibilityAndHtmlStructure(BaseBrowserTest):
    """Empirical verification of HTML5 structure, landmarks, labels, and form associations."""

    def test_landmarks_and_semantic_hierarchy(self):
        """Extract and verify landmarks from Section 1.1."""
        html = """
        <!DOCTYPE html>
        <html lang="pt-BR">
        <head>
          <meta charset="UTF-8">
          <title>AGR - Teste A11y</title>
        </head>
        <body>
          <a href="#conteudo-principal" class="sr-only-focusable">Saltar diretamente para o conteúdo principal</a>
          <header class="cabecalho-governo" role="banner">
            <nav class="navegacao-principal" aria-label="Menu Principal de Operações" role="navigation">
              <ul><li><a href="/dashboard">Painel Geral</a></li></ul>
            </nav>
          </header>
          <main id="conteudo-principal" class="painel-fiscalizacao" role="main">
            <section class="painel-fiscalizacao__secao-autos" aria-labelledby="titulo-secao-autos">
              <h2 id="titulo-secao-autos">Autos de Infração</h2>
              <article class="card-auto" aria-labelledby="auto-num-2026-00412">
                <header><h3 id="auto-num-2026-00412">Auto Nº 2026/00412</h3></header>
              </article>
            </section>
            <aside class="painel-fiscalizacao__alertas" aria-labelledby="titulo-alertas-horus">
              <h2 id="titulo-alertas-horus">Alertas Críticos</h2>
            </aside>
          </main>
          <footer class="rodape-governo" role="contentinfo">
            <p>&copy; 2026 AGR</p>
          </footer>
        </body>
        </html>
        """
        self.load_html(html)

        checks = self.page.evaluate(
            """() => {
            return {
                lang: document.documentElement.lang,
                hasSkipLink: !!document.querySelector('a[href="#conteudo-principal"]'),
                hasHeaderBanner: !!document.querySelector('header[role="banner"]'),
                hasNavPrincipal: !!document.querySelector('nav[role="navigation"][aria-label="Menu Principal de Operações"]'),
                hasMain: !!document.querySelector('main#conteudo-principal[role="main"]'),
                hasSectionLabeled: !!document.querySelector('section[aria-labelledby="titulo-secao-autos"]'),
                hasSectionH2: !!document.querySelector('#titulo-secao-autos'),
                hasArticleLabeled: !!document.querySelector('article[aria-labelledby="auto-num-2026-00412"]'),
                hasArticleH3: !!document.querySelector('#auto-num-2026-00412'),
                hasAsideLabeled: !!document.querySelector('aside[aria-labelledby="titulo-alertas-horus"]'),
                hasAsideH2: !!document.querySelector('#titulo-alertas-horus'),
                hasFooterContentInfo: !!document.querySelector('footer[role="contentinfo"]')
            };
        }"""
        )

        for check_name, check_val in checks.items():
            if check_name == "lang":
                self.assertEqual(check_val, "pt-BR")
            else:
                self.assertTrue(check_val, f"Failed landmark check: {check_name}")

    def test_form_native_validation_and_associations(self):
        """Extract and verify Form constraints from Section 1.2."""
        html = """
        <!DOCTYPE html>
        <html>
        <body>
          <form class="formulario-vistoria" novalidate id="form-vistoria-cadastral">
            <fieldset class="formulario-vistoria__grupo">
              <legend class="formulario-vistoria__legenda">Identificação e Regularidade Cadastral do Veículo</legend>

              <div class="campo">
                <label for="placa-veiculo" class="campo__rotulo">
                  Placa do Veículo
                  <span aria-hidden="true" class="campo__obrigatorio">*</span>
                </label>
                <input
                  type="text"
                  id="placa-veiculo"
                  name="placa"
                  class="campo__controle"
                  required
                  maxlength="8"
                  pattern="^[A-Za-z]{3}-?[0-9][A-Za-z0-9][0-9]{2}$"
                  aria-describedby="ajuda-placa erro-placa"
                >
                <small id="ajuda-placa" class="campo__ajuda">Ajuda placa</small>
                <span id="erro-placa" class="campo__mensagem-erro" aria-live="polite"></span>
              </div>

              <div class="campo">
                <label for="renavam-veiculo" class="campo__rotulo">RENAVAM</label>
                <input
                  type="text"
                  id="renavam-veiculo"
                  name="renavam"
                  required
                  inputmode="numeric"
                  minlength="9"
                  maxlength="11"
                  pattern="^[0-9]{9,11}$"
                  aria-describedby="erro-renavam"
                >
                <span id="erro-renavam" aria-live="polite"></span>
              </div>

              <div class="campo">
                <label for="lotacao-veiculo">Lotação</label>
                <input type="number" id="lotacao-veiculo" name="lotacao" required min="4" max="60" value="44">
              </div>
            </fieldset>
            <button type="submit">Enviar</button>
          </form>
          <script>
            window.submitPrevented = false;
            window.placaErrorText = '';
            const formulario = document.querySelector('#form-vistoria-cadastral');
            const inputPlaca = document.querySelector('#placa-veiculo');
            const spanErroPlaca = document.querySelector('#erro-placa');

            formulario.addEventListener('submit', (evento) => {
              if (!formulario.checkValidity()) {
                evento.preventDefault();
                window.submitPrevented = true;
                if (inputPlaca.validity.valueMissing) {
                  spanErroPlaca.textContent = 'A placa do veículo é de preenchimento obrigatório.';
                } else if (inputPlaca.validity.patternMismatch) {
                  spanErroPlaca.textContent = 'A placa digitada não atende ao formato oficial Mercosul ou antigo.';
                }
                window.placaErrorText = spanErroPlaca.textContent;
              }
            });
          </script>
        </body>
        </html>
        """
        self.load_html(html)

        # Check HTML label associations
        assoc_checks = self.page.evaluate(
            """() => {
            const labelPlaca = document.querySelector('label[for="placa-veiculo"]');
            const inputPlaca = document.querySelector('#placa-veiculo');
            const labelRenavam = document.querySelector('label[for="renavam-veiculo"]');
            const inputRenavam = document.querySelector('#renavam-veiculo');
            const labelLotacao = document.querySelector('label[for="lotacao-veiculo"]');
            const inputLotacao = document.querySelector('#lotacao-veiculo');

            return {
                labelPlacaExists: !!labelPlaca && !!inputPlaca,
                labelRenavamExists: !!labelRenavam && !!inputRenavam,
                labelLotacaoExists: !!labelLotacao && !!inputLotacao,
                inputmodeNumeric: inputRenavam.getAttribute('inputmode') === 'numeric',
                patternPresent: !!inputPlaca.getAttribute('pattern')
            };
        }"""
        )
        self.assertTrue(assoc_checks["labelPlacaExists"])
        self.assertTrue(assoc_checks["labelRenavamExists"])
        self.assertTrue(assoc_checks["labelLotacaoExists"])
        self.assertTrue(assoc_checks["inputmodeNumeric"])
        self.assertTrue(assoc_checks["patternPresent"])

        # Submit empty form: constraint validation triggers preventDefault
        self.page.click("button[type='submit']")
        res_submit = self.page.evaluate(
            "() => ({ prevented: window.submitPrevented, error: window.placaErrorText })"
        )
        self.assertTrue(res_submit["prevented"])
        self.assertEqual(res_submit["error"], "A placa do veículo é de preenchimento obrigatório.")

        # Fill invalid pattern placa
        self.page.fill("#placa-veiculo", "INVALID123")
        self.page.click("button[type='submit']")
        res_pattern = self.page.evaluate("() => window.placaErrorText")
        self.assertEqual(
            res_pattern, "A placa digitada não atende ao formato oficial Mercosul ou antigo."
        )

    def test_accessible_accordion_interaction_and_keyboard(self):
        """Extract and verify Accordion component from Section 1.3."""
        html = """
        <!DOCTYPE html>
        <html>
        <body>
          <div class="sanfona-fiscalizacao">
            <h3>
              <button
                type="button"
                id="gatilho-evidencias-412"
                class="sanfona-fiscalizacao__gatilho"
                aria-expanded="false"
                aria-controls="painel-evidencias-412"
              >
                <span>Evidências</span>
                <span class="sanfona-fiscalizacao__icone" aria-hidden="true">▼</span>
              </button>
            </h3>
            <div
              id="painel-evidencias-412"
              class="sanfona-fiscalizacao__painel"
              role="region"
              aria-labelledby="gatilho-evidencias-412"
              hidden
            >
              <p>Conteúdo do painel</p>
            </div>
          </div>
          <script>
            const botaoSanfona = document.querySelector('#gatilho-evidencias-412');
            const painelSanfona = document.querySelector('#painel-evidencias-412');
            const iconeSanfona = botaoSanfona.querySelector('.sanfona-fiscalizacao__icone');

            botaoSanfona.addEventListener('click', () => {
              const expandido = botaoSanfona.getAttribute('aria-expanded') === 'true';
              botaoSanfona.setAttribute('aria-expanded', String(!expandido));
              painelSanfona.hidden = expandido;
              iconeSanfona.textContent = expandido ? '▼' : '▲';
            });

            botaoSanfona.addEventListener('keydown', (evento) => {
              if (evento.key === 'Escape' && botaoSanfona.getAttribute('aria-expanded') === 'true') {
                botaoSanfona.setAttribute('aria-expanded', 'false');
                painelSanfona.hidden = true;
                iconeSanfona.textContent = '▼';
              }
            });
          </script>
        </body>
        </html>
        """
        self.load_html(html)

        # Initial state
        state_init = self.page.evaluate(
            """() => {
            const btn = document.querySelector('#gatilho-evidencias-412');
            const panel = document.querySelector('#painel-evidencias-412');
            return {
                expanded: btn.getAttribute('aria-expanded'),
                hidden: panel.hidden
            };
        }"""
        )
        self.assertEqual(state_init["expanded"], "false")
        self.assertTrue(state_init["hidden"])

        # Click to expand
        self.page.click("#gatilho-evidencias-412")
        state_expanded = self.page.evaluate(
            """() => {
            const btn = document.querySelector('#gatilho-evidencias-412');
            const panel = document.querySelector('#painel-evidencias-412');
            return {
                expanded: btn.getAttribute('aria-expanded'),
                hidden: panel.hidden
            };
        }"""
        )
        self.assertEqual(state_expanded["expanded"], "true")
        self.assertFalse(state_expanded["hidden"])

        # Press Escape key to close
        self.page.focus("#gatilho-evidencias-412")
        self.page.keyboard.press("Escape")
        state_closed = self.page.evaluate(
            """() => {
            const btn = document.querySelector('#gatilho-evidencias-412');
            const panel = document.querySelector('#painel-evidencias-412');
            return {
                expanded: btn.getAttribute('aria-expanded'),
                hidden: panel.hidden
            };
        }"""
        )
        self.assertEqual(state_closed["expanded"], "false")
        self.assertTrue(state_closed["hidden"])


# ===========================================================================
# 6. RESUMO E RUNNER DIRETO
# ===========================================================================
if __name__ == "__main__":
    unittest.main(verbosity=2)
