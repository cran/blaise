## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(blaise)

## ----create datafiles---------------------------------------------------------
model1 = "
  DATAMODEL Test
  FIELDS
  A     : STRING[1]
  B     : INTEGER[1]
  C     : REAL[3,1]
  D     : REAL[3]
  E     : (Male, Female)
  F     : 1..20
  G     : 1.00..100.00
  ENDMODEL
  "
model2 = "
  DATAMODEL Test
  FIELDS
  A     : STRING[1]
  B     : INTEGER[1]
  C     : REAL[3,1]
  D     : REAL[3]
  E     : (Male (1), Female (2), Unknown (9))
  F     : 1..20
  G     : 1.00..100.00
  ENDMODEL
  "

data1 =
"A12.30.11 1  1.00
B23.41.2210 20.20
C34.50.0120100.00"
data2 = 
"A12,30,11 1  1,00
B23,41,2210 20,20
C34,50,0920100,00"
blafile1 = tempfile('testbla1', fileext = '.bla')
datafile1 = tempfile('testdata1', fileext = '.asc')
blafile2 = tempfile('testbla2', fileext = '.bla')
datafile2 = tempfile('testdata2', fileext = '.asc')
writeLines(data1, con = datafile1)
writeLines(model1, con = blafile1)
writeLines(data2, con = datafile2)
writeLines(model2, con = blafile2)

## ----read datafile------------------------------------------------------------
df = read_fwf_blaise(datafile1, blafile1)
df

## -----------------------------------------------------------------------------
df_comma = read_fwf_blaise(datafile2, blafile2)
df_comma

## -----------------------------------------------------------------------------
readr::problems(df_comma)

## -----------------------------------------------------------------------------
df_comma = read_fwf_blaise(datafile2, blafile2, locale = readr::locale(decimal_mark = ","))
df_comma

## -----------------------------------------------------------------------------
df_enum = read_fwf_blaise(datafile2, blafile2, locale = readr::locale(decimal_mark = ","), numbered_enum = FALSE)
df_enum

## -----------------------------------------------------------------------------
df_laf = read_fwf_blaise(datafile1, blafile1, output = "laf")
df_laf
df_laf$E

## -----------------------------------------------------------------------------
outfile = tempfile(fileext = ".asc")
outbla = sub(".asc", ".bla", outfile)
write_fwf_blaise(df, outfile)
readr::read_lines(outfile)
readr::read_lines(outbla)

## -----------------------------------------------------------------------------
outfile_model = tempfile(fileext = ".asc")
write_fwf_blaise_with_model(df_enum, outfile_model, blafile2)
readr::read_lines(outfile_model)

## -----------------------------------------------------------------------------
model3 = "
  DATAMODEL Test
  FIELDS
  A     : (A, B, C)
  B     : (Male (1), Female (2), Unknown (3))
  ENDMODEL
  "
blafile3 = tempfile('testbla3', fileext = '.bla')
writeLines(model3, con = blafile3)
outfile_new_model = tempfile(fileext = ".asc")
write_fwf_blaise_with_model(df_enum, outfile_new_model, blafile3)
readr::read_lines(outfile_new_model)

## ---- error=TRUE--------------------------------------------------------------
model4 = "
  DATAMODEL Test
  FIELDS
  A     : (A, B)
  B     : (Male (1), Female (2))
  ENDMODEL
  "
blafile4 = tempfile('testbla4', fileext = '.bla')
writeLines(model4, con = blafile4)
outfile_wrong_model = tempfile(fileext = ".asc")
write_fwf_blaise_with_model(df_enum, outfile_wrong_model, blafile4)

