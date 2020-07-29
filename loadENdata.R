##------------------------------------------------------------------------------
# File: loadENdata.R
# Name: Mateusz Grobelny
# Date: 11/19/2019
# Desc: Code to decrypt encrypted data & connection info
# Usage:
##-------------------------------------------------------------------------------



sysdata <- Sys.info()

# Set up connections and data
if (Sys.info()["nodename"] == "PRODUCTION") {
  name <<- "PRD"
  color <<- "color:white"

  # Connection
  pubkey <<- charToRaw(readtext("publicKeyprd.txt")$text)
  privkey <<- charToRaw(readtext("/home/datascience/Documents/privKeyprd.txt")$text)
  en_string <<- "zXzIiO0o7xfGlJFXyS2GuY6dpP12clr6WSJynvGOn8pTTMF47bWJVTAO2F175BGk+kojQ1bfuvmJn4ccApo2mem6YLw3DaLudplwLTE="

  pubkeyITS <<- charToRaw(readtext("publicITS.txt")$text)
  privkeyITS <<- charToRaw(readtext("/home/datascience/Documents/privITS.txt")$text)

  pubkeyITSrna <<- charToRaw(readtext("publicITSrna.txt")$text)
  privkeyITSrna <<- charToRaw(readtext("/home/datascience/Documents/privITSrna.txt")$text)

} else {
  if (sysdata[1] == "Windows") {
    # Connection
    pubkey <<- charToRaw(readtext("publicKeydev.txt")$text)
    privkey <<- charToRaw(readtext("C:/Users/njablonski/OneDrive - Greenlight Biosciences/ITwork/privKeydev.txt")$text)

    # ITS
    pubkeyITS <<- charToRaw(readtext("publicITS.txt")$text)
    privkeyITS <<- charToRaw(readtext("C:/Users/njablonski/OneDrive - Greenlight Biosciences/ITwork/privITS.txt")$text)

    # ITS
    pubkeyITSrna <<- charToRaw(readtext("publicITSrna.txt")$text)
    privkeyITSrna <<- charToRaw(readtext("C:/Users/njablonski/OneDrive - Greenlight Biosciences/ITwork/privITSrna.txt")$text)

  } else {
    # Connection
    pubkey <<- charToRaw(readtext("publicKeydev.txt")$text)
    privkey <<- charToRaw(readtext("/home/datascience/Documents/privKeydev.txt")$text)

    pubkeyITS <<- charToRaw(readtext("publicITS.txt")$text)
    privkeyITS <<- charToRaw(readtext("/home/datascience/Documents/privITS.txt")$text)

    pubkeyITSrna <<- charToRaw(readtext("publicITSrna.txt")$text)
    privkeyITSrna <<- charToRaw(readtext("/home/datascience/Documents/privITSrna.txt")$text)

    # privkey <<- charToRaw(readtext('privkey.txt')$text)
  }
  # Name of Instance
  name <<- "DEV"
  color <<- "color:red"
  en_string <<- "SYCuY73UU9Dx7hGmUQRFXPmXuEtlypFZdY34yfipZROfFr4r3hcJMZwjaRMcLW4uz9kEUM8yKZz071qKfSFp/Tcx+Nv6IDNqd3p1"

}
con_decryt = decrypt_string(en_string, privkey, pubkey)
connection = strsplit(con_decryt, ",")
connectionstring <<- paste0("Driver={ODBC Driver 17 for SQL Server};Server=", connection[[1]][1],
  ";Database=", connection[[1]][2], ";Uid=", connection[[1]][3], ";Pwd=", connection[[1]][4],
  ";")

its_EN <<- "mkBXWKCC8Oo9RipEG+Tewfkz8yTT/dtrhoCbiNGJFeIYuUbRbL7db42XIFQJL5I="
its_decryt = decrypt_string(its_EN, privkeyITS, pubkeyITS)
its = strsplit(its_decryt, ",")

itsRNA_EN <<- "6a2tbvTJ+awJyF4DiKLkF6ir8VhRoZj5/5uP6XndGE82oZ3hIHXd3vstmLJ3jfA="
itsRNA_decryt = decrypt_string(itsRNA_EN, privkeyITSrna, pubkeyITSrna)
itsRNA = strsplit(itsRNA_decryt, ",")

print("Prepared connection keys")
