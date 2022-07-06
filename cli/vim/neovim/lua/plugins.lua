

require("packer").startup(function(use)
        use "wbthomason/packer.nvim" -- this is essential.

        use "jiangmiao/auto-pairs"
        use "tpope/vim-fugitive"
        use "ellisonleao/gruvbox.nvim"

        -- nvim-surround
        use({
                "kylechui/nvim-surround",
                config = function() require("nvim-surround").setup({}) end
        })

        -- telescope
        use {
                "nvim-telescope/telescope.nvim",
                requires = { {"nvim-lua/plenary.nvim"} },
        }
        use  "nvim-telescope/telescope-file-browser.nvim" 

        -- bufferline
        use {
                "akinsho/bufferline.nvim",
                tag = "v2.*",
                requires = "kyazdani42/nvim-web-devicons",
        }

        -- lsp
        use  "neovim/nvim-lspconfig"

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
end)


require("plugins/telescope")
require("plugins/lsp")
require("plugins/bufferline")
require("plugins/statusline")
require("plugins/comment")
