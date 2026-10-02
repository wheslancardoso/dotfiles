return {
  -- Configuração aprimorada de Java com nvim-jdtls
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- Configurações adicionais para garantir que o Java JDTLS funcione com Lombok e JDK local
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
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
      -- 🚀 Auto-Scaffolding Inteligente de Classes e Pacotes Java estilo IntelliJ / VS Code
      vim.api.nvim_create_autocmd("BufNewFile", {
        pattern = "*.java",
        callback = function(args)
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

          table.insert(lines, "public class " .. classname .. " {")
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

          -- Imports & Ações Rápidas
          map("n", "<leader>jo", function() jdtls.organize_imports() end, "Organizar Imports (Shift+Alt+O)")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Actions / Quick Fix (Mover pacote, etc)")

          -- Geração de Código
          map("n", "<leader>jga", function() jdtls.generate_accessor_methods() end, "Gerar Getters & Setters")
          map("n", "<leader>jgc", function() jdtls.generate_constructor() end, "Gerar Construtor")
          map("n", "<leader>jgs", function() jdtls.generate_to_string() end, "Gerar toString()")
          map("n", "<leader>jge", function() jdtls.generate_hash_code_equals() end, "Gerar hashCode() & equals()")

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
