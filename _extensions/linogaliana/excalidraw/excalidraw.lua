-- Schémas Excalidraw interactifs : une image `*.excalidraw.json` devient un
-- bloc HTML rendu côté client (voir excalidraw-embed.js). Filtre post-quarto :
-- les figures, légendes et références croisées sont déjà construites.

local DEP_NAME = "excalidraw-embed"
local dependency_added = false

-- Dossier de l'extension, déduit du chemin de ce script.
local function extension_dir()
  local script = PANDOC_SCRIPT_FILE or ""
  return script:match("^(.*)[/\\][^/\\]*$") or "."
end

-- Liste récursive des fichiers de `dir`, chemins préfixés par `rel`.
-- list_directory échoue sur un fichier : c'est ainsi qu'on repère les dossiers.
local function list_files(dir, rel, out)
  local ok, entries = pcall(pandoc.system.list_directory, dir)
  if not ok then return out end
  table.sort(entries)
  for _, name in ipairs(entries) do
    local full = dir .. "/" .. name
    local sub = rel .. "/" .. name
    local is_dir = pcall(pandoc.system.list_directory, full)
    if is_dir then
      list_files(full, sub, out)
    else
      table.insert(out, sub)
    end
  end
  return out
end

-- Déclare la dépendance HTML une seule fois par page.
local function add_dependency()
  if dependency_added then return end
  dependency_added = true
  local vendor_files = list_files(extension_dir() .. "/vendor", "vendor", {})
  local resources = {}
  for _, rel in ipairs(vendor_files) do
    table.insert(resources, { name = rel, path = rel })
  end
  quarto.doc.add_html_dependency({
    name = DEP_NAME,
    version = "1.0.0",
    scripts = {
      { path = "excalidraw-embed.js", attribs = { type = "module" }, afterBody = true },
    },
    stylesheets = { "excalidraw-embed.css" },
    resources = resources,
  })
end

-- Remplace toutes les occurrences de `old` (texte brut, sans motifs Lua).
local function replace_plain(s, old, new)
  local out, pos = {}, 1
  while true do
    local i, j = string.find(s, old, pos, true)
    if not i then break end
    table.insert(out, string.sub(s, pos, i - 1))
    table.insert(out, new)
    pos = j + 1
  end
  table.insert(out, string.sub(s, pos))
  return table.concat(out)
end

-- Échappement HTML d'une valeur d'attribut.
local function html_attr(s)
  s = replace_plain(s, "&", "&amp;")
  s = replace_plain(s, "<", "&lt;")
  s = replace_plain(s, ">", "&gt;")
  s = replace_plain(s, '"', "&quot;")
  return s
end

-- Chemin de l'image de repli, relatif à la page produite. Un chemin "/..." part de
-- la racine du projet, mais le site est publié sous un sous-dossier : on le ramène
-- à un chemin relatif, comme Quarto le fait pour les images ordinaires.
-- Profondeur = nombre de dossiers de la page source (relative au projet).
local function fallback_src(src)
  if src:sub(1, 1) ~= "/" then return src end
  local root = (quarto.project and quarto.project.directory) or "."
  local input = quarto.doc.input_file or ""
  if root ~= "." and input:sub(1, #root + 1) == root .. "/" then
    input = input:sub(#root + 2)
  end
  local dir = input:match("^(.*)[/\\][^/\\]*$") or ""
  local depth = 0
  for _ in dir:gmatch("[^/\\]+") do depth = depth + 1 end
  return string.rep("../", depth) .. src:sub(2)
end

-- Lit le JSON Excalidraw ; nil si illisible ou manifestement pas du JSON.
local function read_scene(src)
  local path
  if src:sub(1, 1) == "/" then
    local root = (quarto.project and quarto.project.directory) or "."
    path = root .. src
  else
    local input = quarto.doc.input_file or "."
    local dir = input:match("^(.*)[/\\][^/\\]*$") or "."
    path = dir .. "/" .. src
  end
  local f = io.open(path, "rb")
  if f == nil then
    quarto.log.warning("excalidraw : fichier introuvable : " .. path)
    return nil
  end
  local txt = f:read("a")
  f:close()
  if txt == nil or not txt:match("^%s*{") then
    quarto.log.warning("excalidraw : JSON invalide : " .. path)
    return nil
  end
  return txt
end

-- Échappement pour un contenu <script> : pas de "</" ni de "<!--" qui fermeraient le bloc.
local function escape_script(txt)
  txt = replace_plain(txt, "</", "<\\/")
  txt = replace_plain(txt, "<!--", "<\\!--")
  return txt
end

-- Hauteur CSS valide : nombre seul (px implicite) ou nombre avec unité autorisée.
local function height_value(h)
  if h == nil or h == "" then return "450px" end
  if h:match("^[%d%.]+$") then return h .. "px" end
  local num, unit = h:match("^([%d%.]+)(%a+)$")
  if num and (unit == "px" or unit == "em" or unit == "rem" or unit == "vh") then
    return h
  end
  if h:match("^[%d%.]+%%$") then return h end
  quarto.log.warning("excalidraw : hauteur ignorée : " .. h)
  return "450px"
end

local function is_excalidraw(img)
  return img.src:lower():match("%.excalidraw%.json$") ~= nil
end

local function excalidraw_image(img)
  if not is_excalidraw(img) then return nil end
  -- Légende de la figure, recopiée par Pandoc() (attribut interne, retiré ici).
  local figure_caption = img.attributes["excalidraw-caption"]
  img.attributes["excalidraw-caption"] = nil

  -- Hors HTML : on remplace par l'image de repli, si elle existe.
  if not quarto.doc.is_format("html") then
    local fallback = img.attributes["fallback"]
    if fallback == nil then return nil end
    -- Pandoc lit un fichier local : un chemin "/..." part de la racine du projet.
    if fallback:sub(1, 1) == "/" then
      fallback = ((quarto.project and quarto.project.directory) or ".") .. fallback
    end
    local new = pandoc.Image(img.caption, fallback, img.title, img.attr)
    new.attributes["fallback"] = nil
    return new
  end

  local scene = read_scene(img.src)
  if scene == nil then return nil end

  add_dependency()

  local label = pandoc.utils.stringify(img.caption)
  if label == "" then label = figure_caption or "" end
  if label == "" then label = img.attributes["alt"] or img.title or "" end
  if label == "" then label = "Schéma Excalidraw" end

  local height = height_value(img.attributes["height"])

  local classes = { "excalidraw-embed" }
  for _, c in ipairs(img.classes) do
    if c ~= "excalidraw-embed" then table.insert(classes, c) end
  end

  -- editable=false : pas de bouton "Modifier" pour ce schéma (attribut lu par le JS).
  local editable = ""
  if img.attributes["editable"] == "false" then
    editable = ' data-editable="false"'
  end

  local html = '<span class="' .. html_attr(table.concat(classes, " ")) ..
    '" style="height:' .. html_attr(height) ..
    '" role="img" aria-label="' .. html_attr(label) .. '"' .. editable .. '>' ..
    '<script type="application/json" class="excalidraw-data">' ..
    escape_script(scene) .. '</script>'

  local fallback = img.attributes["fallback"]
  if fallback ~= nil and fallback ~= "" then
    html = html .. '<noscript><img src="' .. html_attr(fallback_src(fallback)) ..
      '" alt="' .. html_attr(label) .. '"></noscript>'
  end
  html = html .. '</span>'

  return pandoc.RawInline("html", html)
end

-- Vrai si les blocs contiennent une image Excalidraw.
local function has_excalidraw(blocks)
  local found = false
  pandoc.Div(blocks):walk({
    Image = function(img)
      if is_excalidraw(img) then found = true end
    end,
  })
  return found
end

-- Première passe : à ce stade Quarto représente une figure par une Div
-- FloatRefTarget dont la légende est un bloc frère de l'image (pas un attribut
-- de l'image). On recopie cette légende sur les images Excalidraw de la figure.
function Pandoc(doc)
  doc = doc:walk({
    Div = function(div)
      if div.attributes["__quarto_custom_type"] ~= "FloatRefTarget" then return nil end
      local caption = ""
      for _, child in ipairs(div.content) do
        if child.t == "Div" and not has_excalidraw(child.content) then
          caption = pandoc.utils.stringify(child)
        end
      end
      if caption == "" then return nil end
      return div:walk({
        Image = function(img)
          if is_excalidraw(img) then
            img.attributes["excalidraw-caption"] = caption
            return img
          end
        end,
      })
    end,
  })
  return doc:walk({ Image = excalidraw_image })
end
