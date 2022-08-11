require("packer").startup(function(use)
    use "wbthomason/packer.nvim" -- this is essential.

    use "jiangmiao/auto-pairs"
    use "tpope/vim-fugitive"
    use "tpope/vim-rhubarb"
    use "ellisonleao/gruvbox.nvim"
    use "editorconfig/editorconfig-vim"

    -- nvim-surround
    use({
        "kylechui/nvim-surround",
        config = function() require("nvim-surround").setup({}) end
    })

    -- telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = { { "nvim-lua/plenary.nvim" } },
    }
    -- use "nvim-telescope/telescope-file-browser.nvim"
    use "nvim-telescope/telescope-media-files.nvim"

    -- bufferline
    use {
        "akinsho/bufferline.nvim",
        tag = "v2.*",
        requires = "kyazdani42/nvim-web-devicons",
    }

    -- lsp
    use "neovim/nvim-lspconfig"
    -- use "jose-elias-alvarez/null-ls.nvim"

    -- nvim-cmp
    use "hrsh7th/nvim-cmp" -- The completion plugin
    use "hrsh7th/cmp-nvim-lsp" -- LSP source for nvim-cmp
    use "hrsh7th/cmp-buffer" -- buffer completions
    use "hrsh7th/cmp-path" -- path completions
    -- use "hrsh7th/cmp-cmdline" -- cmdline completions
    use "saadparwaiz1/cmp_luasnip" -- snippet completions

    -- snippets
    use "L3MON4D3/LuaSnip" --snippet engine
    use "rafamadriz/friendly-snippets" -- a bunch of snippets to use


    -- statusline
    use "ojroques/nvim-hardline"

    -- comment
    use "numToStr/Comment.nvim"

    -- filetree
    use "klesh/nvim-tree.lua"


    -- treesitter
    use "nvim-treesitter/nvim-treesitter"
    use "nvim-treesitter/playground"
    use "acarapetis/vim-sh-heredoc-highlighting"

    use {
        "/home/klesh/Projects/klesh/nvim-runscript",
        config = function() require("nvim-runscript").setup({}) end
    }


    -- debugger
    use 'mfussenegger/nvim-dap'
    use 'leoluz/nvim-dap-go'
    use 'nvim-telescope/telescope-dap.nvim'
end)


require("plugins/telescope")
require("plugins/lsp")
require("plugins/bufferline")
require("plugins/statusline")
require("plugins/comment")
require("plugins/tree")
require("plugins/searchinfolder")
require("plugins/treesitter")
require("plugins/debugging")
