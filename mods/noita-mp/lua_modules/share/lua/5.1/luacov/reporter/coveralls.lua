
local coveralls = {}

local luacov_reporter = require"luacov.reporter"
local utils           = require"luacov.coveralls.utils"
local ci              = require"luacov.coveralls.CiInfo"
local CiRepo          = require"luacov.coveralls.CiRepo"

local json            = utils.json
local unix_path       = require"path".new("/")

local ReporterBase = luacov_reporter.ReporterBase

----------------------------------------------------------------
local CoverallsReporter = setmetatable({}, ReporterBase) do
CoverallsReporter.__index = CoverallsReporter

local EMPTY = json.null
local ZERO  = 0

local function debug_print(o, ...)
   if not o._debug then return end
   io.stdout:write(...)
end

local function trace_json(o)
   debug_print(o, "--------------------\n")
   debug_print(o, "service_name         : ", o._json.service_name    or "", "\n")
   debug_print(o, "repo_token           : ", o._json.repo_token and "<DETECTED>" or "<NOT DETECTED>", "\n")
   debug_print(o, "service_number       : ", o._json.service_number  or "", "\n")
   debug_print(o, "service_job_id       : ", o._json.service_job_id  or "", "\n")
   debug_print(o, "service_pull_request : ", o._json.service_pull_request  or "", "\n")
   debug_print(o, "source_files         : ", #o._json.source_files   or "", "\n")
   for _, source in ipairs(o._json.source_files) do
      debug_print(o, "  ", source.name, "\n")
   end
   if o._json.git then
      debug_print(o, "git\n")
      debug_print(o, "  head\n")
      debug_print(o, "    id             : ", o._json.git.head.id              or "", "\n")
      debug_print(o, "    author_name    : ", o._json.git.head.author_name     or "", "\n")
      debug_print(o, "    author_email   : ", o._json.git.head.author_email    or "", "\n")
      debug_print(o, "    committer_name : ", o._json.git.head.committer_name  or "", "\n")
      debug_print(o, "    committer_email: ", o._json.git.head.committer_email or "", "\n")
      debug_print(o, "    message        : ", o._json.git.head.message         or "", "\n")
      debug_print(o, "  branch           : ", o._json.git.branch               or "", "\n")
      debug_print(o, "  remotes\n")
      for i, t in ipairs(o._json.git.remotes) do
        debug_print(o, "    ", t.name, " ", t.url, "\n")
      end 
   end
   debug_print(o, "--------------------\n")
end

function CoverallsReporter:new(conf)
   local o, err = ReporterBase.new(self, conf)
   if not o then return nil, err end

   -- read coveralls specific configurations
   local cc = conf.coveralls or {}
   self._debug = not not cc.debug
   if cc.merge then
      self._source_files = {}
   end

   local repo, err = CiRepo:new(cc.root or '.')
   assert(repo, "LuaCov-covealls internal error :" .. tostring(err))

   debug_print(o, "CI: \n")
   debug_print(o, "  name            : ", ci.name            () or "<UNKNOWN>", "\n")
   debug_print(o, "  branch          : ", ci.branch          () or "<UNKNOWN>", "\n")
   debug_print(o, "  service_number  : ", ci.service_number  () or "<UNKNOWN>", "\n")
   debug_print(o, "  pull_request    : ", ci.pull_request    () or "<UNKNOWN>", "\n")
   debug_print(o, "  job_id          : ", ci.job_id          () or "<UNKNOWN>", "\n")
   debug_print(o, "  commit_id       : ", ci.commit_id       () or "<UNKNOWN>", "\n")
   debug_print(o, "  author_name     : ", ci.author_name     () or "<UNKNOWN>", "\n")
   debug_print(o, "  author_email    : ", ci.author_email    () or "<UNKNOWN>", "\n")
   debug_print(o, "  committer_name  : ", ci.committer_name  () or "<UNKNOWN>", "\n")
   debug_print(o, "  committer_email : ", ci.committer_email () or "<UNKNOWN>", "\n")
   debug_print(o, "  message         : ", ci.message         () or "<UNKNOWN>", "\n")
   debug_print(o, "  token           : ", ci.token() and "<DETECTED>" or "<NOT DETECTED>", "\n")

   debug_print(o, "Repository: \n")
   debug_print(o, "  type            : ", repo:type                 (),                "\n")
   debug_print(o, "  path            : ", repo:path                 () or "<UNKNOWN>", "\n")
   debug_print(o, "  version         : ", repo:version              () or "<UNKNOWN>", "\n")
   debug_print(o, "  id              : ", repo:id                   () or "<UNKNOWN>", "\n")
   debug_print(o, "  author_name     : ", repo:last_author_name     () or "<UNKNOWN>", "\n")
   debug_print(o, "  author_email    : ", repo:last_author_email    () or "<UNKNOWN>", "\n")
   debug_print(o, "  committer_name  : ", repo:last_committer_name  () or "<UNKNOWN>", "\n")
   debug_print(o, "  committer_email : ", repo:last_committer_email () or "<UNKNOWN>", "\n")
   debug_print(o, "  message         : ", repo:last_message         () or "<UNKNOWN>", "\n")
   debug_print(o, "  current_branch  : ", repo:current_branch       () or "<UNKNOWN>", "\n")

   if cc.pathcorrect then
      local pat = {}
      -- @todo implement function as path converter?
      for i, p in ipairs(cc.pathcorrect) do
         assert(type(p)    == "table")
         assert(type(p[1]) == "string")
         assert(type(p[2]) == "string")
         pat[i] = {p[1], p[2]}
         debug_print(o, "Add correct path: `", p[1], "` => `", p[2], "`\n")
      end
      o._correct_path_pat = pat
   end

   local base_file
   if cc.json then
      local err
      base_file, err = json.load_file(cc.json)
      debug_print(o, "Load merge file ", tostring(cc.json), ": ", tostring((not not base_file) or err), "\n")
      if base_file and base_file.source_files then
         for _, source in ipairs(base_file.source_files) do
            debug_print(o, "  ", source.name, "\n")
         end
         debug_print(o, "--------------------\n")
      end
      if not base_file then
         o:close()
         return nil, "Can not merge with " .. cc.json .. ". Error: " .. (err or "")
      end
   end

   o._json = base_file or {}

   o._json.service_name         = cc.service_name              or ci.name()  or o._json.service_name
   o._json.repo_token           = cc.repo_token                or ci.token() or o._json.repo_token
   o._json.service_number       = o._json.service_number       or ci.service_number()
   o._json.service_job_id       = o._json.service_job_id       or ci.job_id()
   o._json.source_files         = o._json.source_files         or json.init_array{}
   o._json.service_pull_request = o._json.service_pull_request or ci.pull_request()

   if cc.build_number then
      io.write("*****************************************************","\n")
      io.write("WARNING! change build number is experimental feature", "\n")
      io.write("and may be changed/excluded in future version!",       "\n")
      io.write("*****************************************************","\n")
      assert(tonumber(cc.build_number))
      local sign = string.sub(cc.build_number, 1, 1)
      if sign == '+' or sign == '-' then
         if tonumber(o._json.service_number) then
            local v = tonumber(o._json.service_number) + tonumber(cc.build_number)
            debug_print(o, "change service_number from ", o._json.service_number, " to ", tostring(v), "\n")
            o._json.service_number = tostring(v)
         else
            io.write("WARNING! can not change service_number from ", o._json.service_number, "\n")
         end
      else
         debug_print(o, "set service_number to ", tostring(cc.build_number), "\n")
         o._json.service_number = cc.build_number
      end
   end

   if repo:type() == 'git' then
      o._json.git      = o._json.git or {}
      o._json.git.head = o._json.git.head or {}

      o._json.git.head.id              = o._json.git.head.id              or repo:id()
      o._json.git.head.author_name     = o._json.git.head.author_name     or repo:last_author_name()
      o._json.git.head.author_email    = o._json.git.head.author_email    or repo:last_author_email()
      o._json.git.head.committer_name  = o._json.git.head.committer_name  or repo:last_committer_name()
      o._json.git.head.committer_email = o._json.git.head.committer_email or repo:last_committer_email()
      o._json.git.head.message         = o._json.git.head.message         or repo:last_message()
      o._json.git.branch               = o._json.git.branch               or ci.branch() or repo:current_branch()
      if not o._json.git.remotes then
         o._json.git.remotes = json.init_array{}
         local t = repo:remotes()
         if t then for name, url in pairs(t) do
            table.insert(o._json.git.remotes,{name=name,url=url})
         end end
      end
   end

   return o
end

function CoverallsReporter:correct_path(path)
   local before = path

   if self._correct_path_pat then
      for _, pat in ipairs(self._correct_path_pat) do
         path = path:gsub(pat[1], pat[2])
      end
   end

   -- @todo check if we have path not relevant to repo
   -- if is abs path then this is error path.

   path = unix_path:normolize(path)

   if before ~= path then
      debug_print(self, "correct path: ", before, "=>", path, "\n")
   end

   return path
end

function CoverallsReporter:on_start()
end

function CoverallsReporter:on_new_file(filename)
   local name = self:correct_path(filename)
   local source_file

   if self._source_files then
      source_file  = self._source_files[name]
   end

   if source_file then
      debug_print(self, "Merge duplicate file: ", filename, "\n")
      assert(source_file.name == name, "Expected: " .. tostring(name) .. " got " .. tostring(source_file.name))
      source_file.count = 0
      source_file.hits  = 0
      source_file.miss  = 0
   else
      source_file = {
         name      = name;
         source    = {};
         coverage  = json.init_array{};
         count     = 0;
         hits      = 0;
         miss      = 0;
      }
   end

   self._current_file = source_file;
end

local function get_cov(self, i, line)
   local cov = self._current_file.coverage[i]
   if not self._source_files then
      assert(cov == nil, tostring(cov))
   end

   if cov == nil then return nil end

   local exists_line = self._current_file.source[i]
   if line ~= exists_line then
      local pcov
      if cov == EMPTY then pcov = '<EMPTY>'
      elseif cov == ZERO then pcov = '<ZERO>'
      else pcov = tostring(cov) end
      io.write("\nWARNING: try merge different files as ", tostring(self._current_file.name), "\n")
      debug_print(self, "Line ", tostring(i), "(", pcov, ")\n")
      debug_print(self, "- ", tostring(exists_line), "\n")
      debug_print(self, "+ ", tostring(line), "\n")
   end

   return cov
end

function CoverallsReporter:on_empty_line(filename, lineno, line)
   local i = self._current_file.count + 1
   local cov = get_cov(self, i, line)

   self._current_file.count       = i
   self._current_file.coverage[i] = cov or EMPTY
   self._current_file.source[i]   = line
end

function CoverallsReporter:on_mis_line(filename, lineno, line)
   local i = self._current_file.count + 1
   local cov = get_cov(self, i, line)

   self._current_file.count       = i
   self._current_file.miss        = self._current_file.miss + 1
   self._current_file.coverage[i] = cov or ZERO
   self._current_file.source[i]   = line
end

function CoverallsReporter:on_hit_line(filename, lineno, line, hits)
   local i = self._current_file.count + 1
   local cov = tonumber(get_cov(self, i, line))

   self._current_file.count       = i
   self._current_file.hits        = self._current_file.hits + 1
   self._current_file.coverage[i] = (cov or 0) + hits
   self._current_file.source[i]   = line
end

function CoverallsReporter:on_end_file(filename, hits, miss)
   local source_file = self._current_file

   local total = source_file.hits + source_file.miss
   local cover = 0
   if total ~= 0 then cover = 100 * (source_file.hits / total) end

   print( string.format("File '%s'", source_file.name) )
   print( string.format("Lines executed:%.2f%% of %d\n", cover, total) )

   source_file.count = nil
   source_file.hits  = nil
   source_file.miss  = nil

   if self._source_files then
      if self._source_files[source_file.name] then
         return
      end
      self._source_files[source_file.name] = source_file
   end

   table.insert(self._json.source_files, source_file)
end

function CoverallsReporter:on_end()
   for _, source_file in ipairs(self._json.source_files) do
      if type(source_file.source) == 'table' then
         source_file.source = table.concat(source_file.source, "\n")
      end
   end

   trace_json(self)
   local msg = json.encode(self._json)
   self:write(msg)
end

end
----------------------------------------------------------------

function coveralls.report()
   return luacov_reporter.report(CoverallsReporter)
end

return coveralls
