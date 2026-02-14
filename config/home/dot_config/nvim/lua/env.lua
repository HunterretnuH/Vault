
local env = "home"

local environments = {}
environments.home = {}
    environments.home.wiki = {}
        environments.home.wiki.wiki_dir_path         = '~/Desktop/Multimedia/Documents/Wiki/'
        environments.home.wiki.index_wiki_path       = environments.home.wiki.wiki_dir_path .. 'IndexWiki/'
        environments.home.wiki.main_wiki_path        = environments.home.wiki.wiki_dir_path .. 'MainWiki/'
        environments.home.wiki.dev_wiki_path         = environments.home.wiki.wiki_dir_path .. 'DevWiki/'
        environments.home.wiki.plotbuy_wiki_path     = environments.home.wiki.wiki_dir_path .. 'PlotBuyWiki/'
        environments.home.wiki.rpg_wiki_path         = environments.home.wiki.wiki_dir_path .. 'RpgWiki/'
        environments.home.wiki.private_wiki_path     = environments.home.wiki.wiki_dir_path .. 'PrivateWiki/'
        environments.home.wiki.work_wiki_path        = environments.home.wiki.wiki_dir_path .. 'WorkWiki/'
        environments.home.wiki.mman_wiki_path        = environments.home.wiki.wiki_dir_path .. 'MmanWiki/'
        environments.home.wiki.mssh_wiki_path        = environments.home.wiki.wiki_dir_path .. 'MsshWiki/'

        environments.home.wiki.default_wiki_path     = environments.home.wiki.index_wiki_path
environments.work = {}
    environments.work.wiki = {}
        environments.work.wiki.wiki_dir_path         = '~/Wiki/'
        environments.work.wiki.main_wiki_path        = environments.work.wiki.wiki_dir_path .. 'MainWiki/'
        environments.work.wiki.dev_wiki_path         = environments.work.wiki.wiki_dir_path .. 'DevWiki/'
        environments.work.wiki.work_wiki_path        = environments.work.wiki.wiki_dir_path .. 'WorkWiki/'
        environments.work.wiki.mman_wiki_path        = environments.work.wiki.wiki_dir_path .. 'MmanWiki/'

        environments.work.wiki.default_wiki_path     = environments.work.wiki.work_wiki_path

return environments[env]

