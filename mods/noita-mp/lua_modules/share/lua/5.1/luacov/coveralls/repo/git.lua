local utils = require "luacov.coveralls.utils"
local path  = require "path"
local exec  = utils.exec

local function git_exec(cwd, ...)
  local ok, status, msg = exec(cwd, 'git', ...)
  if not ok then return ok, msg or status end
  return msg or ''
end

local function git_version()
  local ver, err = git_exec('.', '--version')
  if not ver then return nil, err end
  return (ver:gsub("%s+$", ""))
end

local function is_git_repo(cwd)
  local ok, err = git_exec(cwd, 'status')
  if not ok then return nil, err end
  return true
end

local function git_last_log(cwd, fmt)
  return git_exec(cwd, '--no-pager log -1 --pretty=format:%s', fmt)
end

local function make_git_log_getter(fmt)
  return function(cwd) return git_last_log(cwd, fmt) end
end

local git_id                   = make_git_log_getter'%H'
local git_last_author_name     = make_git_log_getter'%aN'
local git_last_author_email    = make_git_log_getter'%ae'
local git_last_committer_name  = make_git_log_getter'%cN'
local git_last_committer_email = make_git_log_getter'%ce'
local git_last_message         = make_git_log_getter'%s'
local git_current_branch       = function (cwd)
  local str, err = git_exec(cwd, 'rev-parse --abbrev-ref HEAD')
  if not str then return nil, err end
  return (str:match("^%s*(%S+)"))
end
local git_remotes              = function (cwd)
  local str, err = git_exec(cwd, 'remote -v')
  if not str then return nil, err end
  local res = {}
  str:gsub("%s*(%S+)%s+([^\n\r]+)%((%a+)%)%s*\r?\n", function(name, url, mode)
    if mode == 'fetch' then res[name] = url end
  end)
  return res
end

-----------------------------------------------------------
local GitRepoInfo = {} do
GitRepoInfo.__index = GitRepoInfo

function GitRepoInfo:new(repo_path)
  repo_path = path.fullpath(repo_path)

  if not path.isdir(repo_path) then
    return nil, 'git rep does not exists'
  end

  local ver, err = git_version()
  if not ver then
    return nil, err
  end

  local ok, err = is_git_repo(repo_path)
  if not ok then
    return nil, err
  end

  local o = setmetatable({
    _path = repo_path
  }, self)

  return o
end

GitRepoInfo.path                  = function(self) return self._path                             end
GitRepoInfo.version               = function(self) return git_version              ()            end
GitRepoInfo.id                    = function(self) return git_id                   (self:path()) end
GitRepoInfo.last_author_name      = function(self) return git_last_author_name     (self:path()) end
GitRepoInfo.last_author_email     = function(self) return git_last_author_email    (self:path()) end
GitRepoInfo.last_committer_name   = function(self) return git_last_committer_name  (self:path()) end
GitRepoInfo.last_committer_email  = function(self) return git_last_committer_email (self:path()) end
GitRepoInfo.last_message          = function(self) return git_last_message         (self:path()) end
GitRepoInfo.current_branch        = function(self) return git_current_branch       (self:path()) end
GitRepoInfo.remotes               = function(self) return git_remotes              (self:path()) end

end
-----------------------------------------------------------

return GitRepoInfo
