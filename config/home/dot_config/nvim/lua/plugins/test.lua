return {
    { lazy = true,
      "nvim-neotest/neotest-plenary" },
    { lazy = true,
      "rcasia/neotest-bash" },
    { lazy = true,
      "alfaix/neotest-gtest" },
    {
        "nvim-neotest/neotest",
        opts = { adapters = { "neotest-plenary", "neotest-bash", "neotest-gtest" } },
    },
}
