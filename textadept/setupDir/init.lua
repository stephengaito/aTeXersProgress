-- Copyright 2017 Stephen Gaito. See License.md

-- This Lua script updates the user's .textadept/init.lua file
-- to add the A TeXer's Progress additions.

function updateInitLua()
  local initBuffer = _BUFFERS[1]

  local flags = buffer.FIND_REGEXP
  local startPos =
    initBuffer:search_next(flags, "^-- ATeXersProgress--Start$")
  if (startPos ~= -1) then
    initBuffer:goto_pos(startPos)
    initBuffer:line_down()
    startPos = initBuffer.current_pos
    initBuffer:search_anchor()
    local endPos =
      initBuffer:search_next(flags, "^-- ATeXersProgress--End$")
    initBuffer:set_sel(startPos, endPos)
    initBuffer:replace_sel("")
  else
    initBuffer:document_end()
    initBuffer:add_text("\n-- The following section (between the --Start and --End)\n")
    initBuffer:add_text("-- has been added by the ATeXersProgress setup script.\n")
    initBuffer:add_text("-- Any changes you make in this section will be removed\n")
    initBuffer:add_text("-- the next time you run the ATeXersProgress setup script.\n\n")
    initBuffer:add_text("-- ATeXersProgress--Start")
    initBuffer:add_text("\n-- ATeXersProgress--End\n")
    initBuffer:line_up()
  end

  initBuffer:add_text(
    "\n-- Ensure *.tex files whose first lines contain the word\n")
  initBuffer:add_text(
    "-- 'ConTeXt' are interpreted as ConTeXt files.\n\n")
  initBuffer:add_text(
    "textadept.file_types.patterns['[Cc][Oo][Nn][Tt][Ee][Xx][Tt]'] = 'context'\n\n")
  initBuffer.add_text("keys['c]'] = require('common/reWrapParagraph').reWrapParagraph -- Ctrl-]\n")
  initBuffer.add_text("keys['al'] = require('common/gotoLinks').goto_link             -- Alt-l\n\n")
  io.save_file()
  quit()
end

events.connect(events.INITIALIZED, updateInitLua)

