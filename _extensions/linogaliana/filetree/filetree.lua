-- _extensions/linogaliana/filetree/filetree.lua
--
-- Transforme une liste à puces imbriquée placée dans une Div de classe
-- `filetree` en explorateur de fichiers façon VSCode : icônes par type de
-- fichier, indentation et dossiers dépliables. Hors HTML, la liste est
-- laissée telle quelle.
--
-- ::: {.filetree}
-- - application
--   - main.py
--   - src # un commentaire facultatif
--     - `__init__.py`
-- :::
--
-- Les noms contenant des `_` doivent être mis entre backticks pour ne pas
-- être interprétés comme de la mise en forme Markdown.
--
-- Des accolades délimitent des groupes de lignes consécutives, annotés à
-- droite de l'arbre : ` {libellé` en fin de ligne ouvre un groupe, ` }`
-- le ferme, ` {libellé}` forme un groupe d'une seule ligne.
--
-- ::: {.filetree}
-- - application
--   - README.md {Documentation
--   - docs
--     - main.py }
--   - tests {Tests}
-- :::
--
-- Le libellé est centré sur le groupe. Un groupe dont une partie est
-- repliée garde son accolade sur les lignes visibles.
--
-- Options de la Div :
--   open-depth=N : les dossiers de profondeur >= N sont repliés au départ
--                  (par défaut, tout est déplié).
--   label-width=L : largeur de la colonne des libellés de groupe (16em par
--                   défaut), au-delà de laquelle ils passent à la ligne.
-- Un élément avec une sous-liste, ou dont le nom se termine par `/`, est un
-- dossier.
--
-- Icônes : Material Icon Theme (MIT, voir LICENSE-icons).

local ICON_CACHE = {}

local FOLDER_ICONS = {
  src = "folder-src",
  data = "folder-database",
  notebooks = "folder-jupyter",
  docs = "folder-docs",
  doc = "folder-docs",
  tests = "folder-test",
  test = "folder-test",
  [".github"] = "folder-github",
  workflows = "folder-gh-workflows",
  config = "folder-config",
  configs = "folder-config",
  scripts = "folder-scripts",
  api = "folder-api",
  app = "folder-app",
  kubernetes = "folder-kubernetes",
  k8s = "folder-kubernetes",
  deployment = "folder-kubernetes",
  utils = "folder-utils",
  docker = "folder-docker",
  ci = "folder-ci",
  [".venv"] = "folder-environment",
  venv = "folder-environment",
}

local FILE_ICONS = {
  ["readme.md"] = "readme",
  ["license"] = "license",
  ["license.md"] = "license",
  ["dockerfile"] = "docker",
  [".dockerignore"] = "docker",
  [".gitignore"] = "git",
  [".gitattributes"] = "git",
  ["pyproject.toml"] = "python-misc",
  [".python-version"] = "python-misc",
  ["uv.lock"] = "uv",
}

local EXTENSION_ICONS = {
  py = "python",
  ipynb = "jupyter",
  md = "markdown",
  qmd = "quarto",
  csv = "table",
  parquet = "database",
  toml = "toml",
  lock = "lock",
  yaml = "yaml",
  yml = "yaml",
  json = "json",
  sh = "console",
  txt = "document",
  log = "log",
  r = "r",
  html = "html",
  css = "css",
  js = "javascript",
  cfg = "settings",
  ini = "settings",
}

local function escape_html(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function icon(name)
  if ICON_CACHE[name] == nil then
    local f = io.open(quarto.utils.resolve_path("icons/" .. name .. ".svg"), "r")
    local svg = f:read("a")
    f:close()
    -- Les id des SVG seraient dupliqués dans la page
    svg = svg:gsub('%s+id="[^"]*"', "")
    svg = svg:gsub("^<svg ", '<svg class="filetree-icon" aria-hidden="true" ', 1)
    ICON_CACHE[name] = svg
  end
  return ICON_CACHE[name]
end

local function folder_icon(name)
  return icon(FOLDER_ICONS[name:lower()] or "folder-base")
end

local function file_icon(name, parent)
  local lname = name:lower()
  if parent == "workflows" and lname:match("%.ya?ml$") then
    return icon("github-actions-workflow")
  end
  if FILE_ICONS[lname] then
    return icon(FILE_ICONS[lname])
  end
  if lname:match("^requirements.*%.txt$") then
    return icon("python-misc")
  end
  if lname:match("^%.env") then
    return icon("tune")
  end
  if lname:match("^dockerfile") then
    return icon("docker")
  end
  local ext = lname:match("%.([^.]+)$")
  return icon(EXTENSION_ICONS[ext] or "document")
end

local function label_text(blocks)
  for _, block in ipairs(blocks) do
    if block.t == "Plain" or block.t == "Para" then
      return pandoc.utils.stringify(block)
    end
  end
  return ""
end

-- Retire de la fin du texte les accolades ouvrant (` {libellé`) ou fermant
-- (` }`) un groupe
local function parse_group(text)
  local opens, closes, label = false, false, nil
  local before, rest = text:match("^(.-)%s+{(.*)$")
  if before then
    text, opens, label = before, true, rest
    if label:sub(-1) == "}" then
      label, closes = label:sub(1, -2), true
    end
    label = label:gsub("^%s+", ""):gsub("%s+$", "")
  elseif text:match("%s+}$") then
    text, closes = text:gsub("%s+}$", ""), true
  end
  return text, opens, closes, label
end

-- Convertit une liste à puces pandoc en arbre de nœuds
local function parse(list, depth, parent)
  local nodes = {}
  for _, item in ipairs(list.content) do
    local text = label_text(item):gsub("^%s+", ""):gsub("%s+$", "")
    local opens, closes, group_label
    text, opens, closes, group_label = parse_group(text)
    local name, comment = text:match("^(.-)%s+#%s+(.*)$")
    name = name or text
    local is_dir = name:sub(-1) == "/"
    if is_dir then
      name = name:sub(1, -2)
    end
    local children = {}
    for _, block in ipairs(item) do
      if block.t == "BulletList" then
        children = parse(block, depth + 1, name)
      end
    end
    table.insert(nodes, {
      name = name, comment = comment, is_dir = is_dir,
      children = children, depth = depth, parent = parent,
      opens = opens, closes = closes, group_label = group_label,
    })
  end
  return nodes
end

-- Lignes de l'arbre dans l'ordre d'affichage
local function flatten(nodes, rows)
  for _, node in ipairs(nodes) do
    table.insert(rows, node)
    flatten(node.children, rows)
  end
  return rows
end

local function close_group(rows, first, last, label)
  for i = first, last do
    rows[i].bracket = "mid"
  end
  if first == last then
    rows[first].bracket = "single"
  else
    rows[first].bracket = "start"
    rows[last].bracket = "end"
  end
  if label ~= "" then
    -- Avec un nombre pair de lignes, le libellé est centré sur la bordure
    -- haute de la ligne qui suit le milieu du groupe
    local n = last - first + 1
    local row = rows[first + n // 2]
    row.label = label
    row.label_pos = (n % 2 == 0) and "top" or "center"
  end
end

-- Attribue à chaque ligne son morceau d'accolade et renvoie true si l'arbre
-- contient au moins un groupe
local function assign_groups(rows)
  local first, label = nil, nil
  local has_groups = false
  for i, node in ipairs(rows) do
    if node.opens then
      if first then
        pandoc.log.warn("filetree: group '" .. label .. "' not closed before " .. node.name)
        close_group(rows, first, i - 1, label)
      end
      first, label, has_groups = i, node.group_label, true
    end
    if node.closes then
      if first then
        close_group(rows, first, i, label)
        first = nil
      else
        pandoc.log.warn("filetree: '}' without matching '{' on " .. node.name)
      end
    end
  end
  if first then
    pandoc.log.warn("filetree: group '" .. label .. "' never closed")
    close_group(rows, first, #rows, label)
  end
  return has_groups
end

-- Colonne de droite : morceau d'accolade puis libellé du groupe
local function render_gutter(node)
  local bracket = node.bracket and (" filetree-bracket-" .. node.bracket) or ""
  local html = '<span class="filetree-gutter"><span class="filetree-bracket' .. bracket .. '"></span>'
    .. '<span class="filetree-label-cell">'
  if node.label then
    html = html .. '<span class="filetree-label filetree-label-' .. node.label_pos .. '">'
      .. escape_html(node.label) .. "</span>"
  end
  return html .. "</span></span>"
end

local function render_label(node, icon_svg, has_groups)
  local html = icon_svg .. '<span class="filetree-name">' .. escape_html(node.name) .. "</span>"
  if node.comment then
    html = html .. '<span class="filetree-comment">' .. escape_html(node.comment) .. "</span>"
  end
  if has_groups then
    html = html .. render_gutter(node)
  end
  return html
end

local function render(nodes, open_depth, has_groups)
  local out = {}
  for _, node in ipairs(nodes) do
    if node.is_dir or #node.children > 0 then
      local open = (open_depth == nil or node.depth < open_depth) and " open" or ""
      table.insert(out, "<li><details" .. open .. '><summary class="filetree-row">'
        .. '<span class="filetree-chevron"></span>'
        .. render_label(node, folder_icon(node.name), has_groups) .. "</summary>"
        .. '<ul class="filetree-children">' .. render(node.children, open_depth, has_groups) .. "</ul>"
        .. "</details></li>")
    else
      table.insert(out, '<li><div class="filetree-row"><span class="filetree-spacer"></span>'
        .. render_label(node, file_icon(node.name, node.parent), has_groups) .. "</div></li>")
    end
  end
  return table.concat(out)
end

function Div(el)
  if not el.classes:includes("filetree") or not quarto.doc.is_format("html") then
    return nil
  end
  local list = nil
  for _, block in ipairs(el.content) do
    if block.t == "BulletList" then
      list = block
      break
    end
  end
  if list == nil then
    return nil
  end
  quarto.doc.add_html_dependency({
    name = "filetree",
    version = "1.0.0",
    stylesheets = { "filetree.css" },
  })
  local open_depth = tonumber(el.attributes["open-depth"])
  local nodes = parse(list, 0, nil)
  local has_groups = assign_groups(flatten(nodes, {}))
  local attrs = has_groups and ' class="filetree filetree-has-groups"' or ' class="filetree"'
  local label_width = el.attributes["label-width"]
  if label_width then
    attrs = attrs .. ' style="--filetree-label-width: ' .. escape_html(label_width) .. '"'
  end
  return pandoc.RawBlock("html",
    "<div" .. attrs .. '><ul class="filetree-root">' .. render(nodes, open_depth, has_groups) .. "</ul></div>")
end
