# REMEMBER to restart R after you modify and save this file!

# First, execute the global .Rprofile if it exists. You may configure blogdown
# options there, too, so they apply to any blogdown projects. Feel free to
# ignore this part if it sounds too complicated to you.
if (file.exists("~/.Rprofile")) {
  base::sys.source("~/.Rprofile", envir = environment())
}

# Now set options to customize the behavior of blogdown for this project. Below
# are a few sample options; for more options, see
# https://bookdown.org/yihui/blogdown/global-options.html
options(
  # to automatically serve the site on RStudio startup, set this option to TRUE
  blogdown.serve_site.startup = FALSE,
  # to disable knitting Rmd files on save, set this option to FALSE
  blogdown.knit.on_save = FALSE,
  # build .Rmd to .html (via Pandoc); to build to Markdown, set this option to 'markdown'
  blogdown.method = 'markdown'
)

# fix Hugo version
options(blogdown.hugo.version = "0.83.0")


reminder_box <- function(boxtype = "warning", type = c("markdown","html")){
  type <- match.arg(type)
  icon <- switch(boxtype,
                 warning = "fa fa-exclamation-triangle",
                 hint = "fa fa-lightbulb",
                 tip = "fa fa-lightbulb",
                 note = "fa fa-comment",
                 exercise = "fas fa-pencil-alt")
  box <- c(
    sprintf(
      '{{< box status="%s" title="%s" icon="%s" >}}',
      boxtype,
      Hmisc::capitalize(boxtype),
      icon
    ),
    "Example",
    "{{< /box >}}"
  )
  if (type == "html") cat(box, sep = "\n")
  
  box <- gsub("<","%", box)
  box <- gsub(">","%", box)
  
  cat(box, sep = "\n")
}
