-- Default config
vim.g["lsp-timeout-config"] = vim.g["lsp-timeout-config"] or {
    stopTimeout =1000 * 60 * 5,
    startTimeout=1000 * 10,
    silent      =false
}

return vim.g["lsp-timeout-config"]
