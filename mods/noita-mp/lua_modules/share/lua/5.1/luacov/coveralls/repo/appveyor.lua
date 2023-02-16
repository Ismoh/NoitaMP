local GitRepo = require"luacov.coveralls.repo.git"
local ci      = require"luacov.coveralls.CiInfo"
local path    = require"path"

-----------------------------------------------------------
local AppveyorRepoInfo = {} do
AppveyorRepoInfo.__index = AppveyorRepoInfo

function AppveyorRepoInfo:new(repo_path)
  if ci.name() ~= 'appveyor' then
    return nil, 'No appveyor CI'
  end

  local build_dir = ci.ENV.APPVEYOR_BUILD_FOLDER
  if build_dir then
    local repo, err = GitRepo:new(build_dir)
    if repo then return repo, "git" end
  end

  local _repo_type = ci.ENV.APPVEYOR_REPO_SCM
  if not _repo_type then _repo_type = 'unknown'
  else _repo_type = _repo_type:lower() end

  local o = setmetatable({
    _path = build_dir or path.fullpath(repo_path);
  }, self)

  return o, _repo_type
end

AppveyorRepoInfo.path                  = function(self) return self._path end
AppveyorRepoInfo.version               = function(self) end
AppveyorRepoInfo.id                    = function(self) return ci.commit_id()       end
AppveyorRepoInfo.last_author_name      = function(self) return ci.author_name()     end
AppveyorRepoInfo.last_author_email     = function(self) return ci.author_email()    end
AppveyorRepoInfo.last_committer_name   = function(self) return ci.committer_name()  end
AppveyorRepoInfo.last_committer_email  = function(self) return ci.committer_email() end
AppveyorRepoInfo.last_message          = function(self) return ci.message()         end
AppveyorRepoInfo.current_branch        = function(self) return ci.branch()          end
AppveyorRepoInfo.remotes               = function(self) return end

end
-----------------------------------------------------------

return AppveyorRepoInfo
