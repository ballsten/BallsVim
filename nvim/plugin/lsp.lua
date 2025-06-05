if vim.fn.executable("lua-language-server") == 1 then
	vim.lsp.enable("lua_ls")
end
if vim.fn.executable("nixd") == 1 then
	vim.lsp.enable("nixd")
end
