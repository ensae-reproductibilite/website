-- _extensions/shortcodes/checkpoint.lua

function checkpoint(args, kwargs)
  local appli = args[1]
  local title = args[2] or ('Checkpoint post ' .. appli)
  return pandoc.RawBlock("html", [[
  <div class="callout callout-style-default callout-caution callout-titled">
    <div class="callout-header d-flex align-content-center collapse" data-bs-toggle="collapse" data-bs-target=".callout-]] .. appli .. [[-contents" aria-controls="callout-]] .. appli .. [[" aria-expanded="true" aria-label="Toggle callout">
      <div class="callout-icon-container">
        <i class="callout-icon"></i>
      </div>
      <div class="callout-title-container flex-fill">
        ]] .. title .. [[
      </div>
      <div class="callout-btn-toggle d-inline-block border-0 py-1 ps-1 pe-0 float-end"><i class="callout-toggle"></i></div>
    </div>
    <div id="callout-]] .. appli .. [[" class="callout-]] .. appli .. [[-contents callout-collapse collapse" style="">
      <div class="callout-body-container callout-body">
        <div class="code-with-filename">
          <div class="code-with-filename-file">
            <pre><strong>terminal</strong></pre>
          </div>
          <div class="sourceCode" data-filename="terminal">
            <pre class="sourceCode python code-annotated"><code class="sourceCode python">curl -sSL https://raw.githubusercontent.com/ensae-reproductibilite/website/refs/heads/main/chapters/applications/overwrite.sh -o update.sh && chmod +x update.sh
./update.sh ]] .. appli .. [[<a class="code-annotation-anchor" data-target-cell="annotated-cell-]].. appli .. [[" data-target-annotation="2" onclick="event.preventDefault();">2</a>
rm -f update.sh</code></pre>
          </div>
        </div>
        <dl class="code-annotation-container-grid">
          <dt>1</dt>
          <dd>Récupérer le script de <em>checkpoint</em></dd>
          <dt>2</dt>
          <dd>Avancer à l’état à l’issue de l’application ]] .. appli .. [[</dd>
          <dt>3</dt>
          <dd>Nettoyer derrière nous</dd>
        </dl>
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
