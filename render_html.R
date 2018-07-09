files <- list.files(pattern = ".*.Rmd")
files
for(file in files[11:13]){
    rmarkdown::render(file,
                      output_file = sprintf("html/%s.html", substr(file, 1, nchar(file)-4)))
}

?rmarkdown::render


html_files <- list.files("html/")
for(fname in html_files){
    message(sprintf("* [%s](html/%s)", substr(fname, 1, nchar(fname)-5), fname))
}
