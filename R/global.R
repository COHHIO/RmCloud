css_path <- file.path("inst", "app", "www", "css")
crssp_sass_bundle <- sass::sass_bundle(
  sass::sass_layer_file(file.path(css_path, "custom.scss"))
)

do_sass <- function (x) {
  sass::sass(
    x,
    options = sass::sass_options(output_style = "compressed"),
    output = file.path(css_path, "custom.min.css")
  )
}

do_sass(crssp_sass_bundle)
