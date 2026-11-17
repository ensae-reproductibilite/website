-- _extensions/shortcodes/checkpoint.lua

-- Données de chaque étape (commandes GitOps, mise en place externe) :
-- chapters/applications/_checkpoints.yml. Lu une seule fois, par pandoc.
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

local STR = {
  fr = {
    vscode_intro = "<b>Si vous n'avez plus de <code>VSCode</code> actif avec la configuration proposée dans l'application préliminaire</b>, vous pouvez repartir de ce service:<br>",
    vscode_next = "<br>Et ensuite, après avoir clôné le dépôt<br><br>",
    annot = {
      "Récupérer le script de <em>checkpoint</em>",
      "Avancer à l’état à l’issue de l’application ",
      "Nettoyer derrière nous",
    },
    gitops = "Puis, dans votre clone du dépôt <code>application-deployment</code>, lancez les mêmes commandes :",
    todo_title = "Avant de continuer, à faire de votre côté",
    todo_hint = "Le script liste dans la console les valeurs à remplacer dans les fichiers (<code>&lt;GITHUB_USERNAME&gt;</code>, <code>&lt;DOCKERHUB_USERNAME&gt;</code>, <code>&lt;SSPCLOUD_USERNAME&gt;</code>, <code>&lt;APP_NAME&gt;</code>).",
  },
  en = {
    vscode_intro = "<b>If you no longer have an active <code>VSCode</code> with the configuration proposed in the preliminary application</b>, you can restart from this service:<br>",
    vscode_next = "<br>Then, after cloning the repository<br><br>",
    annot = {
      "Get the <em>checkpoint</em> script",
      "Move to the state at the end of application ",
      "Clean up after us",
    },
    gitops = "Then, in your clone of the <code>application-deployment</code> repository, run the same commands:",
    todo_title = "Before continuing, to do on your side",
    todo_hint = "The script lists in the console the values to replace in the files (<code>&lt;GITHUB_USERNAME&gt;</code>, <code>&lt;DOCKERHUB_USERNAME&gt;</code>, <code>&lt;SSPCLOUD_USERNAME&gt;</code>, <code>&lt;APP_NAME&gt;</code>).",
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

  -- Étape GitOps (à partir de l'application 22a) et mise en place externe.
  local gitops_block = ""
  local todo_block = ""
  local data = checkpoints_data()
  local entry = data and data[appli]
  if entry and entry.gitops == true then
    gitops_block = "<p>" .. S.gitops .. "</p>\n" ..
      terminal_block(appli, appli .. "-gitops", annot)
  end
  if entry and entry.todo then
    local items = {}
    for _, item in ipairs(entry.todo) do
      local txt = item.fr
      if en and item.en ~= nil then txt = item.en end
      table.insert(items, '<li>' .. inlines_html(txt) .. '</li>')
    end
    if #items > 0 then
      todo_block = '<div class="checkpoint-todo">\n' ..
        '<p><strong>' .. S.todo_title .. '</strong></p>\n' ..
        '<p>' .. S.todo_hint .. '</p>\n' ..
        '<ul>\n' .. table.concat(items, '\n') .. '\n</ul>\n' ..
        '</div>\n'
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

]] .. gitops_block .. todo_block .. [[

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
