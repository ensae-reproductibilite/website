-- _extensions/shortcodes/checkpoint.lua

-- Données des étapes (ordre des étapes, commandes GitOps, mise en place externe
-- cumulée) : chapters/applications/_checkpoints.yml. Lu une seule fois, par pandoc.
local CHECKPOINTS_FILE = 'chapters/applications/_checkpoints.yml'
local checkpoints_meta = nil -- nil: pas encore lu ; false: absent ou illisible

local function read_file(path)
  local f = io.open(path, 'r')
  if f == nil then return nil end
  local txt = f:read('a')
  f:close()
  return txt
end

local function checkpoints_data()
  if checkpoints_meta ~= nil then return checkpoints_meta or nil end
  checkpoints_meta = false
  local candidates = {}
  if quarto and quarto.project and quarto.project.directory then
    table.insert(candidates, quarto.project.directory .. '/' .. CHECKPOINTS_FILE)
  end
  local script = PANDOC_SCRIPT_FILE or ''
  local dir = script:match('^(.*)[/\\][^/\\]*$') or '.'
  table.insert(candidates, dir .. '/../../' .. CHECKPOINTS_FILE)
  for _, path in ipairs(candidates) do
    local txt = read_file(path)
    if txt ~= nil then
      -- Lua n'a pas de parseur YAML : pandoc lit le fichier comme des métadonnées.
      local ok, doc = pcall(pandoc.read, '---\n' .. txt .. '\n---\n', 'markdown')
      if ok and doc then checkpoints_meta = doc.meta end
      break
    end
  end
  return checkpoints_meta or nil
end

-- Langue du rendu : le profil Quarto (_quarto-en.yml / _quarto-fr.yml).
local function is_english()
  local profile = os.getenv('QUARTO_PROFILE') or ''
  for name in profile:gmatch('[^,%s]+') do
    if name == 'en' then return true end
  end
  return false
end

-- Texte Markdown (métadonnées pandoc) vers HTML, sans balise <p>.
local function inlines_html(v)
  if v == nil then return '' end
  local html = pandoc.write(pandoc.Pandoc({ pandoc.Plain(v) }), 'html')
  return (html:gsub('^%s+', ''):gsub('%s+$', ''))
end

-- Texte d'une métadonnée pandoc (valeur ou élément de liste).
local function text(v)
  if v == nil then return nil end
  return pandoc.utils.stringify(v)
end

-- Position (1, 2, ...) d'une étape dans la liste ordonnée `names` ; nil si absente.
local function position(names, name)
  if name == nil then return nil end
  for i, s in ipairs(names) do
    if s == name then return i end
  end
  return nil
end

local STR = {
  fr = {
    vscode_intro = "<b>Si vous n'avez plus de <code>VSCode</code> actif avec la configuration proposée dans l'application préliminaire</b>, vous pouvez repartir de ce service:<br>",
    vscode_next = "<br>Et ensuite, après avoir clôné le dépôt<br><br>",
    annot = {
      "Récupérer le script de <em>checkpoint</em>",
      "Avancer à l’état à l’issue de l’application ",
      "Nettoyer derrière nous",
    },
    gitops_title = "Pour mettre à jour le dépôt GitOps",
    gitops = "Dans votre clone du dépôt <code>application-deployment</code>, lancez les mêmes commandes :",
    todo_title = "Avant de continuer, à faire de votre côté",
    todo_hint = "Le script vous demande dans la console les valeurs à remplacer dans les fichiers (Entrée pour en passer une), puis liste celles qui restent à remplacer (<code>&lt;GITHUB_USERNAME&gt;</code>, <code>&lt;DOCKERHUB_USERNAME&gt;</code>, <code>&lt;SSPCLOUD_USERNAME&gt;</code>, <code>&lt;APP_NAME&gt;</code>).",
  },
  en = {
    vscode_intro = "<b>If you no longer have an active <code>VSCode</code> with the configuration proposed in the preliminary application</b>, you can restart from this service:<br>",
    vscode_next = "<br>Then, after cloning the repository<br><br>",
    annot = {
      "Get the <em>checkpoint</em> script",
      "Move to the state at the end of application ",
      "Clean up after us",
    },
    gitops_title = "To update the GitOps repository",
    gitops = "In your clone of the <code>application-deployment</code> repository, run the same commands:",
    todo_title = "Before continuing, to do on your side",
    todo_hint = "The script asks you in the console for the values to replace in the files (Enter to skip one), then lists those still to replace (<code>&lt;GITHUB_USERNAME&gt;</code>, <code>&lt;DOCKERHUB_USERNAME&gt;</code>, <code>&lt;SSPCLOUD_USERNAME&gt;</code>, <code>&lt;APP_NAME&gt;</code>).",
  },
}

-- Bloc de commandes avec ses annotations. `cell` rend les ids d'annotation uniques.
local function terminal_block(appli, cell, labels)
  return [==[
        <div class="code-with-filename">
          <div class="code-with-filename-file">
            <pre><strong>terminal</strong></pre>
          </div>
          <div class="sourceCode" data-filename="terminal">
            <pre class="sourceCode python code-annotated"><code class="sourceCode python">curl -sSL https://raw.githubusercontent.com/ensae-reproductibilite/website/refs/heads/main/chapters/applications/overwrite.sh -o update.sh && chmod +x update.sh
./update.sh ]==] .. appli .. [==[<a class="code-annotation-anchor" data-target-cell="annotated-cell-]==] .. cell .. [==[" data-target-annotation="2" onclick="event.preventDefault();">2</a>
rm -f update.sh</code></pre>
          </div>
        </div>
        <dl class="code-annotation-container-grid">
          <dt>1</dt>
          <dd>]==] .. labels[1] .. [==[</dd>
          <dt>2</dt>
          <dd>]==] .. labels[2] .. appli .. [==[</dd>
          <dt>3</dt>
          <dd>]==] .. labels[3] .. [==[</dd>
        </dl>
]==]
end

function checkpoint(args, kwargs)

  local appli = args[1]
  local title = args[2] or ('Checkpoint post ' .. appli)
  local insert_vscode = args[3] or "false"
  local id = args[4] or appli

  local en = is_english()
  local S = en and STR.en or STR.fr

  local vscode_link = ""
  if (insert_vscode == "true") then
    vscode_link = [[
    <a href="https://datalab.sspcloud.fr/launcher/ide/vscode-python?name=ENSAE%20Mise%20en%20production&version=2.1.24&s3=region-ec97c721&init.personalInit=«https%3A%2F%2Fraw.githubusercontent.com%2Fensae-reproductibilite%2Fwebsite%2Frefs%2Fheads%2Fmain%2Fchapters%2Fapplications%2Finit.sh»&kubernetes.role=«admin»&networking.user.enabled=true&autoLaunch=false" target="_blank" rel="noopener" data-original-href="https://datalab.sspcloud.fr/launcher/ide/vscode-python?name=ENSAE%20Mise%20en%20production&version=2.1.24&s3=region-ec97c721&init.personalInit=«https%3A%2F%2Fraw.githubusercontent.com%2Fensae-reproductibilite%2Fwebsite%2Frefs%2Fheads%2Fmain%2Fchapters%2Fapplications%2Finit.sh»&kubernetes.role=«admin»&networking.user.enabled=true&autoLaunch=false">
      <img src="https://img.shields.io/badge/SSP%20Cloud-Lancer_avec_VSCode-blue?logo=visualstudiocode&amp;logoColor=blue" alt="Onyxia">
    </a>
    ]]
    vscode_link = S.vscode_intro .. "<center>" .. vscode_link .. "</center>" .. S.vscode_next
  end

  local annot = { S.annot[1], S.annot[2], S.annot[3] }

  -- Étape GitOps, mise en place externe cumulée et rappel des placeholders.
  -- Une étape absente du fichier de données garde une boîte sans ces ajouts.
  local gitops_block = ""
  local todo_block = ""
  local hint_block = ""
  local data = checkpoints_data()
  local names = {}
  for i, s in ipairs(data and data.steps or {}) do names[i] = text(s) end
  local pos = position(names, appli)
  if pos then
    local gitops_from = position(names, text(data.gitops_from))
    local placeholders_from = position(names, text(data.placeholders_from))
    if gitops_from and pos >= gitops_from then
      gitops_block = '<details class="checkpoint-gitops">\n' ..
        '<summary>' .. S.gitops_title .. '</summary>\n' ..
        "<p>" .. S.gitops .. "</p>\n" ..
        terminal_block(appli, appli .. "-gitops", annot) ..
        '</details>\n'
    end
    local items = {}
    for _, item in ipairs(data.todo or {}) do
      local from = position(names, text(item.from))
      local to = position(names, text(item.to)) or math.huge
      if from and from <= pos and pos <= to then
        local txt = item.fr
        if en and item.en ~= nil then txt = item.en end
        table.insert(items, '<li>' .. inlines_html(txt) .. '</li>')
      end
    end
    local hint = placeholders_from and pos >= placeholders_from
    if hint then
      hint_block = '<p class="checkpoint-hint">' .. S.todo_hint .. '</p>\n'
    end
    if #items > 0 then
      todo_block = '<details class="checkpoint-todo">\n' ..
        '<summary>' .. S.todo_title .. '</summary>\n' ..
        '<ul>\n' .. table.concat(items, '\n') .. '\n</ul>\n' ..
        '</details>\n'
    end
  end

  return pandoc.RawBlock("html", [[
  <div class="callout callout-style-default callout-caution callout-titled">
    <div class="callout-header d-flex align-content-center collapse" data-bs-toggle="collapse" data-bs-target=".callout-]] .. id .. [[-contents" aria-controls="callout-]] .. appli .. [[" aria-expanded="true" aria-label="Toggle callout">
      <div class="callout-icon-container">
        <i class="callout-icon"></i>
      </div>
      <div class="callout-title-container flex-fill">
        ]] .. title .. [[
      </div>
      <div class="callout-btn-toggle d-inline-block border-0 py-1 ps-1 pe-0 float-end"><i class="callout-toggle"></i></div>
    </div>
    <div id="callout-]] .. id .. [[" class="callout-]] .. id .. [[-contents callout-collapse collapse" style="">
      <div class="callout-body-container callout-body">

        ]] .. vscode_link .. [[

]] .. terminal_block(appli, appli, annot) .. [[

]] .. hint_block .. gitops_block .. todo_block .. [[

        <div class="quarto-figure quarto-figure-center">
          <figure class="figure">
            <p><img src="/checkpoint.jpg" class="img-fluid quarto-figure quarto-figure-center figure-img" style="width:80.0%"></p>
          </figure>
        </div>
      </div>
    </div>
  </div>
  ]])
end

return {
  checkpoint = checkpoint
}
