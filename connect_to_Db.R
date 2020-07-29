##------------------------------------------------------------------------------
# Function: connect_to_Db
# Desc: sets up a database connection
# Parameters:
#   In: raw text
#   Out:
#   Returns: text without space characters
##-------------------------------------------------------------------------------

source("loadENdata.R", local = TRUE)

connect_to_Db <- function(pubkey,privkey,en_string){

   connection= strsplit(decrypt_string(en_string, key = privkey, pkey = pubkey),",")

   func_conn <-  dbConnect(
    odbc(),
    Driver = "ODBC Driver 17 for SQL Server",
    Server = connection[[1]][1],
    dbname =  connection[[1]][2],
    Uid = connection[[1]][3],
    Pwd =  connection[[1]][4]
  )
  #on.exit(dbDisconnect(func_conn), add = TRUE)
  return(func_conn)
}
