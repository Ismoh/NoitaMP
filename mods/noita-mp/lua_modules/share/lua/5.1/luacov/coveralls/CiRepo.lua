local GitRepo = require"luacov.coveralls.repo.git"
local ApvRepo = require"luacov.coveralls.repo.appveyor"
local ci      = require"luacov.coveralls.CiInfo"

local function try_any_repo(repo_path)
  -- currenly support only git
  local repo, err = GitRepo:new(repo_path) 
  if repo then return repo, "git" end

  repo, err = ApvRepo:new(repo_path)
  if repo then return repo, err end

  local function dummy() end
  return setmetatable({}, {__index = function() return dummy end}), "unknown"
end

-----------------------------------------------------------
local CiRepoInfo = {} do
CiRepoInfo.__index = CiRepoInfo

function CiRepoInfo:new(repo_path)
  local repo, type = try_any_repo(repo_path)
  local o = setmetatable({
    _repo      = assert(repo);
    _repo_type = assert(type);
  }, self)

  return o
end

CiRepoInfo.type                  = function(self) return self._repo_type                   end

CiRepoInfo.path                  = function(self) return self._repo:path()                 end
CiRepoInfo.version               = function(self) return self._repo:version()              end

CiRepoInfo.id                    = function(self) return self._repo:id()                   or ci.commit_id()       end
CiRepoInfo.last_author_name      = function(self) return self._repo:last_author_name()     or ci.author_name()     end
CiRepoInfo.last_author_email     = function(self) return self._repo:last_author_email()    or ci.author_email()    end
CiRepoInfo.last_committer_name   = function(self) return self._repo:last_committer_name()  or ci.committer_name()  end
CiRepoInfo.last_committer_email  = function(self) return self._repo:last_committer_email() or ci.committer_email() end
CiRepoInfo.last_message          = function(self) return self._repo:last_message()         or ci.message()         end
CiRepoInfo.current_branch        = function(self) return self._repo:current_branch()       or ci.branch()          end
CiRepoInfo.remotes               = function(self) return self._repo:remotes()                                      end

end
-----------------------------------------------------------

return CiRepoInfo
