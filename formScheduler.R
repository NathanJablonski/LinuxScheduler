library(shiny)
library(RODBC)
library(odbc)
library(readtext)
library(safer)
library(blastula)

setwd("C:/Users/njablonski/Documents/GitHub/LinuxScheduler")
#source("loadENdata.R", local = TRUE)
#source("connect_to_Db.R", local = TRUE)


getwd()
list.files()

getAdvanced <- function(){
  sysdata <- Sys.info()
  pubkey <<- charToRaw(readtext("C:/Users/njablonski/Documents/GitHub/GLB_SeqRepo/KeyIDGenProject/KeyIDGeneratorApp/publicKeydev.txt")$text)
  privkey <<- charToRaw(readtext("C:/Users/njablonski/OneDrive - Greenlight Biosciences/ITwork/privKeydev.txt")$text)
  en_string <<- "SYCuY73UU9Dx7hGmUQRFXPmXuEtlypFZdY34yfipZROfFr4r3hcJMZwjaRMcLW4uz9kEUM8yKZz071qKfSFp/Tcx+Nv6IDNqd3p1"
  
  #con <- connect_to_Db(pubkey,privkey,en_string)
  
  connection= strsplit(decrypt_string(en_string, key = privkey, pkey = pubkey),",")
  
  con <-  dbConnect(
    odbc(),
    Driver = "ODBC Driver 17 for SQL Server",
    Server = connection[[1]][1],
    dbname =  connection[[1]][2],
    Uid = connection[[1]][3],
    Pwd =  connection[[1]][4]
  )
  
  sql = "select Formulation_ID from Formulation where Formulation_Status = 'Advanced'"
  
  print(sql)
  
  queryOutput <- dbGetQuery(con, sql)
  dbDisconnect(con)
  return(queryOutput)
}

sendEmail <- function(subject, body, to, userID, logmsg, mainBody, objectID, footer, from, group){
  date_time <- add_readable_time()
  
  image <- "https://www.greenlightbiosciences.com/wp-content/uploads/2019/06/logo@2x.png"
  
  confidentiality_msg <- paste("<br>", "<p><i>", 
                               "Information contained in this communication and all related attachments is confidential and proprietary to GreenLight Biosciences, Inc. This e-mail is intended for the named recipients only. Any access, use, distribution, copying or disclosure by any other person is prohibited. If you received this message in error please delete it and kindly notify the sender by reply e-mail.",
                               "</i></p>")
  
  if (missing(from)) {
    from_str <- "glbseqrepo@greenlightbio.com"
  }
  else {
    from_str <- from
  }
  if (missing(group) || group == 'none') {
    block_output = NULL
    group = 'none'
  }
  else {
    block_output <- as.character(group)
  }
  
  if (missing(footer)) {
    footer_str <- md(c(paste0("This is an automatic email sent from GLB Sequence Repository on ", date_time, "."),confidentiality_msg))
  }
  else {
    footer_str <- md(footer)
  }
  
  str_subject <- paste0("GLB SeqRepo - Formulations Awaiting Approvals: ", objectID)
  
  body_str <- blocks(
   block_articles(
     article(
       image = image,
       #title = paste0("GLB Sequence Repository [",name,"]"),
       title = "GLB Sequence Repository [DEV]",
       link = "http://www.glbdatascience.com/glbseqrepo",
       content =
         md(c(c("Hello,", "<br>", "This is a reminder email that the following Formulation(s) are awaiting approvals. ", "<br>","<br>", "<b>", "Formulation_ID(s):", "</b>", objectID,  "<br>"), body))
     )
   )
  )
   
  # build the email
  email <- compose_email(
    body = body_str,
    footer = footer_str
  )
  
  # send the email
  isolate(smtp_send(
    from = from_str,
    to = to,
    cc = block_output,
    subject = str_subject,
    credentials = creds_file("glbrepoemailcreds.crd"),
    email = email,
    verbose = FALSE))
}

advancedForms <- getAdvanced()
advFromStr <- paste(advancedForms[[1]], collapse = ', ')

if(nrow(advancedForms > 0)){
  sendEmail(subject =' ',
            body= " ",
            to= 'njablonski@greenlightbio.com',
            userID='njablonski', #user(),
            logmsg=paste0("Formulation Approval Reminder:", advFromStr,' -- sent Confirmation email '),
            mainBody = 'FormReminder',
            objectID = paste0(advFromStr))
}




