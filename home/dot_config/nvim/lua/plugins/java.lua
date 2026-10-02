return {
  -- Configuração aprimorada de Java com nvim-jdtls
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- ☕ JDTLS requer Java 21+ para rodar o processo do servidor
      local java21_matches = vim.fn.glob("~/.local/share/mise/installs/java/21*/bin/java", false, true)
      local java21_bin = #java21_matches > 0 and java21_matches[#java21_matches] or ""
      if java21_bin ~= "" then
        opts.cmd = opts.cmd or { vim.fn.exepath("jdtls") }
        table.insert(opts.cmd, "--java-executable")
        table.insert(opts.cmd, java21_bin)
      end

      -- Configuração de runtimes de compilação (permite projeto Java 17 no JDTLS)
      local java17_home = vim.fn.expand("~/.local/share/mise/installs/java/openjdk-17.0.2")
      local java21_home = vim.fn.expand("~/.local/share/mise/installs/java/21.0.2")
      local runtimes = {}
      if vim.fn.isdirectory(java17_home) == 1 then
        table.insert(runtimes, { name = "JavaSE-17", path = java17_home })
      end
      if vim.fn.isdirectory(java21_home) == 1 then
        table.insert(runtimes, { name = "JavaSE-21", path = java21_home, default = true })
      end

      -- Configurações adicionais para garantir que o Java JDTLS funcione com Lombok e JDK local
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          configuration = {
            runtimes = #runtimes > 0 and runtimes or nil,
          },
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
        },
      })
      return opts
    end,
    init = function()
      -- 🚀 Auto-Scaffolding Inteligente de Classes, Interfaces e Pacotes Java
      -- Funciona tanto ao criar via :e quanto via Neo-tree (onde o arquivo é criado vazio no disco)
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
        pattern = "*.java",
        callback = function(args)
          -- Apenas preenche se o buffer estiver completamente vazio
          local existing_lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
          local is_empty = #existing_lines == 0 or (#existing_lines == 1 and existing_lines[1] == "")
          if not is_empty then
            return
          end

          local filepath = vim.fs.normalize(args.file)
          local filename = vim.fs.basename(filepath)
          local classname = filename:match("^([%w_]+)%.java$")
          if not classname then
            return
          end

          local dirname = vim.fs.dirname(filepath)
          local pkg_path = dirname:match("src/main/java/(.+)$")
            or dirname:match("src/test/java/(.+)$")
            or dirname:match("src/(.+)$")

          local lines = {}
          local cursor_line = 3

          if pkg_path and #pkg_path > 0 then
            local pkg_name = pkg_path:gsub("/", ".")
            table.insert(lines, "package " .. pkg_name .. ";")
            table.insert(lines, "")
            cursor_line = 4
          end

          -- Se for *Repository, define automaticamente como interface (Spring Data)
          local type_kw = classname:match("Repository$") and "interface" or "class"
          table.insert(lines, "public " .. type_kw .. " " .. classname .. " {")
          table.insert(lines, "  ")
          table.insert(lines, "}")
          table.insert(lines, "")

          vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
          vim.schedule(function()
            pcall(vim.api.nvim_win_set_cursor, 0, { cursor_line, 2 })
          end)
        end,
      })

      -- ⌨️ Atalhos de Produtividade Java (Geração de Código, Imports e Refatoração)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function(args)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
          end

          local jdtls = require("jdtls")

          local function generate(kind)
            vim.lsp.buf.code_action({
              context = {
                only = { kind or "source.generate" },
                diagnostics = {},
              },
            })
          end

          -- Imports & Ações Rápidas
          map("n", "<leader>jo", function() jdtls.organize_imports() end, "Organizar Imports (Shift+Alt+O)")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Actions / Quick Fix (Mover pacote, etc)")

          -- Geração de Código estilo IntelliJ (Alt+Insert)
          map("n", "<leader>jg", function() generate("source.generate") end, "Menu de Geração (Alt+Insert)")
          map("n", "<leader>jga", function() generate("source.generate.accessors") end, "Gerar Getters & Setters")
          map("n", "<leader>jgc", function() generate("source.generate.constructors") end, "Gerar Construtor")
          map("n", "<leader>jgs", function() generate("source.generate.toString") end, "Gerar toString()")
          map("n", "<leader>jge", function() generate("source.generate.hashCodeEquals") end, "Gerar hashCode() & equals()")

          -- Refatoração & Extração
          map("v", "<leader>jrv", function() jdtls.extract_variable(true) end, "Extrair Variável")
          map("n", "<leader>jrv", function() jdtls.extract_variable() end, "Extrair Variável")
          map("v", "<leader>jrc", function() jdtls.extract_constant(true) end, "Extrair Constante")
          map("n", "<leader>jrc", function() jdtls.extract_constant() end, "Extrair Constante")
          map("v", "<leader>jrm", function() jdtls.extract_method(true) end, "Extrair Método")

          -- Testes Unitários
          map("n", "<leader>jtc", function() jdtls.test_class() end, "Rodar Testes da Classe")
          map("n", "<leader>jtm", function() jdtls.test_nearest_method() end, "Rodar Teste do Método")
        end,
      })
    end,
  },
}
