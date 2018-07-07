files <- list.files(pattern = ".*.Rmd")
for(file in files){
    rmarkdown::render(file,
                      output_file = sprintf("html/%s.html", substr(file, 1, nchar(file)-4)))
}

?rmarkdown::render


html_files <- list.files("html/")
for(fname in html_files){
    message(sprintf("* [%s](%s)", substr(fname, 1, nchar(fname)-5), fname))
}
